#!/bin/bash
# One-time setup for macOS.
# Run after OneDrive has synced 5_projects/agent-skills/.
#
# OneDrive path varies by macOS OneDrive version — check yours first:
#   ls ~/OneDrive        (older OneDrive)
#   ls ~/Library/CloudStorage/   (newer OneDrive, look for OneDrive-Personal)
#
# Edit ONEDRIVE below if needed, then: bash setup.sh

ONEDRIVE="${HOME}/OneDrive"
# ONEDRIVE="${HOME}/Library/CloudStorage/OneDrive-Personal"   # uncomment if needed

SKILLS="${ONEDRIVE}/5_projects/agent-skills/skills"

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
