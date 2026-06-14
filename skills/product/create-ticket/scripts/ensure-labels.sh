#!/usr/bin/env bash
# Ensure standard create-ticket labels exist on a GitHub repo.
# Usage: GITHUB_REPO=owner/repo bash ensure-labels.sh
#        bash ensure-labels.sh   # uses gh repo view in cwd
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) not found. Install: brew install gh && gh auth login" >&2
  exit 1
fi

REPO="${GITHUB_REPO:-}"
if [[ -z "$REPO" ]]; then
  REPO="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null)" || {
    echo "Set GITHUB_REPO or run from a git repo with gh remote." >&2
    exit 1
  }
fi

labels_create() {
  gh label create "$1" --repo "$REPO" --color "$2" --description "$3" 2>/dev/null || true
}

echo "Ensuring create-ticket labels on $REPO ..."
labels_create "type:bug" "D73A4A" "Defect / incorrect behaviour"
labels_create "type:security" "B60205" "Security finding"
labels_create "type:refactor" "5319E7" "Refactor / architecture"
labels_create "type:test" "FBCA04" "Test / coverage"
labels_create "type:slice" "0E8A16" "Vertical slice backlog item"
labels_create "type:spike" "D4C5F9" "Spike or decision-only work"
labels_create "module:foundation" "C5DEF5" "Cross-cutting foundation"
labels_create "module:money" "3DBFA0" "Money module"
labels_create "module:time" "7C6FF2" "Time module"
labels_create "module:intelligence" "A371F7" "Claude / MCP"
labels_create "module:health" "E87272" "Health module"
labels_create "module:wellbeing" "E8A84C" "Well-being module"
labels_create "module:cross-cutting" "6E7781" "Cross-module shell"
labels_create "priority:must" "B60205" "Must-have"
labels_create "priority:should" "F9D0C4" "Should-have"
labels_create "agent:hitl" "0E8A16" "Agent opens PR; human review before merge"
labels_create "agent:afk" "1D76DB" "Agent may run autonomously"
echo "Done."
