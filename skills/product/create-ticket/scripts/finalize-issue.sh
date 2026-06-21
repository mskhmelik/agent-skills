#!/usr/bin/env bash
# Rename issue to PREFIX-N:title and add to module GitHub Project.
# Usage: finalize-issue.sh ISSUE_NUM PREFIX "Short title" module:label
# Env: GITHUB_REPO, REPO_ROOT (git repo with docs/projects.json)
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) not found." >&2
  exit 1
fi

ISSUE_NUM="${1:?issue number required}"
PREFIX="${2:?prefix required (e.g. BUG, DEBT, SLICE)}"
SHORT_TITLE="${3:?short title required}"
MODULE_LABEL="${4:?module label required (e.g. module:money)}"

REPO="${GITHUB_REPO:-}"
if [[ -z "$REPO" ]]; then
  REPO="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null)" || {
    echo "Set GITHUB_REPO or run from a git repo with gh remote." >&2
    exit 1
  }
fi

FULL_TITLE="${PREFIX}-${ISSUE_NUM}: ${SHORT_TITLE}"

current="$(gh issue view "$ISSUE_NUM" --repo "$REPO" --json title --jq .title)"
if [[ "$current" == "$FULL_TITLE" ]]; then
  echo "Title already aligned: $FULL_TITLE"
else
  gh issue edit "$ISSUE_NUM" --repo "$REPO" --title "$FULL_TITLE"
  echo "Renamed #$ISSUE_NUM → $FULL_TITLE"
fi

REPO_ROOT="${REPO_ROOT:-}"
if [[ -z "$REPO_ROOT" ]]; then
  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
fi

PROJECTS_JSON="${PROJECTS_JSON:-${REPO_ROOT}/docs/projects.json}"
if [[ ! -f "$PROJECTS_JSON" ]]; then
  echo "No docs/projects.json at $PROJECTS_JSON — skip project add (run ensure-projects.sh)." >&2
  exit 0
fi

OWNER="$(jq -r '.owner' "$PROJECTS_JSON")"
PROJECT_KEY="$(jq -r --arg m "$MODULE_LABEL" '.module_map[$m] // empty' "$PROJECTS_JSON")"
if [[ -z "$PROJECT_KEY" ]]; then
  echo "No project mapping for $MODULE_LABEL — skip project add." >&2
  exit 0
fi

PROJECT_NUM="$(jq -r --arg k "$PROJECT_KEY" '.projects[$k].number // empty' "$PROJECTS_JSON")"
if [[ -z "$PROJECT_NUM" ]]; then
  echo "No project number for key $PROJECT_KEY — skip project add." >&2
  exit 0
fi

ISSUE_URL="$(gh issue view "$ISSUE_NUM" --repo "$REPO" --json url --jq .url)"
if [[ -z "$ISSUE_URL" || "$ISSUE_URL" == "null" ]]; then
  echo "Could not resolve URL for issue #$ISSUE_NUM" >&2
  exit 1
fi

if gh project item-add "$PROJECT_NUM" --owner "$OWNER" --url "$ISSUE_URL" 2>/dev/null; then
  echo "Added #$ISSUE_NUM to project $PROJECT_KEY (#$PROJECT_NUM)"
else
  echo "Project add skipped (may already exist or need gh auth refresh)." >&2
fi
