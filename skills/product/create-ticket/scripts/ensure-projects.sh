#!/usr/bin/env bash
# Create module GitHub Projects v2 and write docs/projects.json.
# Usage: REPO_ROOT=/path/to/repo GITHUB_REPO=owner/repo bash ensure-projects.sh
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) not found." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq not found." >&2
  exit 1
fi

OWNER="${GITHUB_OWNER:-mskhmelik}"
REPO="${GITHUB_REPO:-}"
if [[ -z "$REPO" ]]; then
  REPO="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null)" || {
    echo "Set GITHUB_REPO or run from a git repo with gh remote." >&2
    exit 1
  }
fi

REPO_ROOT="${REPO_ROOT:-}"
if [[ -z "$REPO_ROOT" ]]; then
  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi

OUTPUT="${REPO_ROOT}/docs/projects.json"
mkdir -p "$(dirname "$OUTPUT")"

# title:key pairs
PAIRS="Money:money Health:health Time:time Wellbeing:wellbeing Foundation:foundation"

echo "Ensuring GitHub Projects for $OWNER (repo $REPO) ..."

projects_json="{}"

for pair in $PAIRS; do
  title="${pair%%:*}"
  key="${pair##*:}"

  existing_num="$(gh project list --owner "$OWNER" --format json --limit 100 2>/dev/null \
    | jq -r --arg t "$title" '.projects[] | select(.title == $t) | .number' | head -1 || true)"

  if [[ -n "$existing_num" && "$existing_num" != "null" ]]; then
    project_num="$existing_num"
    echo "  Found project: $title (#$project_num)"
  else
    echo "  Creating project: $title ..."
    project_num="$(gh project create --owner "$OWNER" --title "$title" --format json --jq .number)"
    echo "  Created $title (#$project_num)"
  fi

  gh project link "$project_num" --owner "$OWNER" --repo "$REPO" 2>/dev/null || true

  gh project field-create "$project_num" --owner "$OWNER" \
    --name "Status" --data-type SINGLE_SELECT \
    --single-select-options "Backlog,Ready,In progress,In review,Done" 2>/dev/null || true

  gh project field-create "$project_num" --owner "$OWNER" \
    --name "Priority" --data-type SINGLE_SELECT \
    --single-select-options "Must,Should" 2>/dev/null || true

  gh project field-create "$project_num" --owner "$OWNER" \
    --name "Agent" --data-type SINGLE_SELECT \
    --single-select-options "HITL,AFK" 2>/dev/null || true

  projects_json="$(echo "$projects_json" | jq --arg k "$key" --arg t "$title" --argjson n "$project_num" \
    '. + {($k): {title: $t, number: $n}}')"
done

jq -n \
  --arg owner "$OWNER" \
  --arg repo "$REPO" \
  --argjson projects "$projects_json" \
  '{
    owner: $owner,
    repo: $repo,
    projects: $projects,
    module_map: {
      "module:money": "money",
      "module:health": "health",
      "module:time": "time",
      "module:wellbeing": "wellbeing",
      "module:foundation": "foundation",
      "module:cross-cutting": "foundation",
      "module:intelligence": "foundation"
    }
  }' > "$OUTPUT"

echo "Wrote $OUTPUT"
echo "Done."
