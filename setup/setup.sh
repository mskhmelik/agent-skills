#!/bin/bash
# One-time setup for macOS.
# Run from anywhere — the script locates itself and derives the skills path.
# Usage: bash /path/to/agent-skills/setup/setup.sh

REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SKILLS="${REPO_ROOT}/skills"

if [ ! -d "$SKILLS" ]; then
  echo "ERROR: Skills folder not found at $SKILLS"
  echo "Make sure OneDrive has finished syncing and update ONEDRIVE in this script."
  exit 1
fi

for TARGET in "${HOME}/.claude/skills" "${HOME}/.cursor/skills"; do
  if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    mv "$TARGET" "${TARGET}.bak"
    echo "Backed up existing: $TARGET → ${TARGET}.bak"
  elif [ -L "$TARGET" ]; then
    rm "$TARGET"
  fi
  ln -sf "$SKILLS" "$TARGET"
  echo "Linked: $TARGET → $SKILLS"
done

echo "Done. Both Claude Code and Cursor now use: $SKILLS"
