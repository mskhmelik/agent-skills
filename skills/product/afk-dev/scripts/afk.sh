#!/bin/bash
# Headless outer loop for /afk-dev — runs the coordinator repeatedly until it
# reports the cycle is complete, or until $1 iterations are used up.
#
# Usage: bash afk.sh <max-iterations> [agent-cli]
#   agent-cli: "claude" (default) or "cursor-agent"
#
# Each iteration:
#   - resets context to a fresh agent process (no shared memory between runs)
#   - feeds it /afk-dev plus the on-disk state (docs/engineering/loops/loop_<date>-<slug>/{plan,log}.md, issues)
#   - the coordinator itself enforces the caps in CONVENTIONS.md
#
# Run this from the repo root, inside a sandboxed checkout/worktree — each
# iteration runs with permission-prompt bypass (--force / acceptEdits).

set -eo pipefail

MAX_ITER="${1:-}"
AGENT_CLI="${2:-claude}"

if [ -z "$MAX_ITER" ]; then
  echo "Usage: $0 <max-iterations> [claude|cursor-agent]"
  exit 1
fi

DONE_MARKER="<promise>AFK CYCLE COMPLETE</promise>"
LOG_FILE="docs/engineering/loops/loop_<date>-<slug>/log.md"
mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"

for ((i=1; i<=MAX_ITER; i++)); do
  echo "=== AFK iteration $i/$MAX_ITER ($(date)) ==="

  case "$AGENT_CLI" in
    claude)
      result=$(claude --print --output-format json --permission-mode acceptEdits "/afk-dev")
      ;;
    cursor-agent)
      result=$(cursor-agent -p --force --output-format text "/afk-dev")
      ;;
    *)
      echo "Unknown agent CLI: $AGENT_CLI"
      exit 1
      ;;
  esac

  echo "$result"

  # Tail the shared log so you can watch progress without re-reading the whole file
  echo "--- docs/engineering/loops/loop_<date>-<slug>/log.md (last 5 lines) ---"
  tail -n 5 "$LOG_FILE" 2>/dev/null || true

  if [[ "$result" == *"$DONE_MARKER"* ]]; then
    echo "AFK dev cycle complete after $i iteration(s)."
    exit 0
  fi
done

echo "Reached max iterations ($MAX_ITER) without a completion signal — review docs/engineering/loops/loop_<date>-<slug>/{plan,log}.md."
