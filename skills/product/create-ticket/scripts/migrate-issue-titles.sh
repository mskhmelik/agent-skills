#!/usr/bin/env bash
# Migrate issue titles so PREFIX-N matches GitHub issue number.
# Usage: GITHUB_REPO=owner/repo bash migrate-issue-titles.sh [--apply] [--add-to-projects]
set -euo pipefail

if ! command -v gh >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  echo "Requires gh and jq." >&2
  exit 1
fi

APPLY=false
ADD_PROJECTS=false
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=true ;;
    --add-to-projects) ADD_PROJECTS=true ;;
  esac
done

REPO="${GITHUB_REPO:-}"
if [[ -z "$REPO" ]]; then
  REPO="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null)" || {
    echo "Set GITHUB_REPO." >&2
    exit 1
  }
fi

REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FINALIZE="$SCRIPT_DIR/finalize-issue.sh"

cutoff="$(date -u -v-90d +%Y-%m-%d 2>/dev/null || date -u -d '90 days ago' +%Y-%m-%d 2>/dev/null || echo "")"

compute_target() {
  local num="$1"
  local title="$2"
  local prefix="" rest=""

  if [[ "$title" =~ ^([A-Z]+)-([0-9]+):\ (.+)$ ]]; then
    prefix="${BASH_REMATCH[1]}"
    rest="${BASH_REMATCH[3]}"
    if [[ "${BASH_REMATCH[2]}" -eq "$num" ]]; then
      echo ""
      return
    fi
    echo "${prefix}-${num}: ${rest}"
    return
  fi

  if [[ "$title" =~ ^Slice\ [0-9]+\ —\ (.+)$ ]]; then
    rest="${BASH_REMATCH[1]}"
    echo "SLICE-${num}: ${rest}"
    return
  fi

  if [[ "$title" =~ ^([Aa]rch)-([0-9]+):\ (.+)$ ]]; then
    prefix="ARCH"
    rest="${BASH_REMATCH[3]}"
    if [[ "${BASH_REMATCH[2]}" -eq "$num" ]]; then
      echo ""
      return
    fi
    echo "ARCH-${num}: ${rest}"
    return
  fi

  if [[ "$title" =~ ^DRAFT:\ (.+)$ ]]; then
    echo ""
    return
  fi

  echo ""
}

fetch_issues() {
  gh issue list --repo "$REPO" --state open --limit 500 --json number,title,labels \
    | jq -c '.[]'
  if [[ -n "$cutoff" ]]; then
    gh issue list --repo "$REPO" --state closed --limit 500 --json number,title,labels,closedAt \
      | jq -c --arg c "$cutoff" '.[] | select(.closedAt >= ($c + "T00:00:00Z"))'
  fi
}

echo "Migrating issue titles on $REPO (open + closed since $cutoff)"
echo "Mode: $(if $APPLY; then echo APPLY; else echo DRY-RUN; fi)"
echo ""

count=0
skipped=0

while IFS= read -r row; do
  num="$(echo "$row" | jq -r .number)"
  title="$(echo "$row" | jq -r .title)"
  target="$(compute_target "$num" "$title")"

  if [[ -z "$target" ]]; then
    ((skipped++)) || true
    continue
  fi

  ((count++)) || true
  echo "#$num: $title"
  echo "    → $target"

  if $APPLY; then
    gh issue edit "$num" --repo "$REPO" --title "$target"
    if $ADD_PROJECTS; then
      module="$(echo "$row" | jq -r '[.labels[].name | select(startswith("module:"))] | first // empty')"
      if [[ -n "$module" && "$target" =~ ^([A-Z]+)- ]]; then
        prefix="${BASH_REMATCH[1]}"
        short="${target#${prefix}-${num}: }"
        REPO_ROOT="$REPO_ROOT" GITHUB_REPO="$REPO" \
          bash "$FINALIZE" "$num" "$prefix" "$short" "$module" 2>/dev/null || true
      fi
    fi
  fi
done < <(fetch_issues | sort -u -t, -k1,1)

echo ""
echo "Would rename / renamed: $count; skipped (already aligned or unrecognized): $skipped"
if ! $APPLY; then
  echo "Run with --apply to execute. Add --add-to-projects to enqueue on module boards."
fi
