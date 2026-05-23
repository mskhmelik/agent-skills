#!/bin/bash
# One-time setup for macOS.
# Run from anywhere — the script locates itself and derives the skills path.
# Usage: bash /path/to/agent-skills/setup/setup.sh
#
# Skills are now organised in group subfolders (product/, vault/, utilities/, private/).
# This script creates individual per-skill symlinks so Claude Code and Cursor still find
# each skill at ~/.claude/skills/<name>/ and ~/.cursor/skills/<name>/.

REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SKILLS="${REPO_ROOT}/skills"

if [ ! -d "$SKILLS" ]; then
  echo "ERROR: Skills folder not found at $SKILLS"
  echo "Make sure OneDrive has finished syncing."
  exit 1
fi

for TARGET_DIR in "${HOME}/.claude/skills" "${HOME}/.cursor/skills"; do
  # If a legacy whole-folder symlink exists, remove it and create the directory instead
  if [ -L "$TARGET_DIR" ]; then
    rm "$TARGET_DIR"
    echo "Removed legacy symlink: $TARGET_DIR"
  fi
  mkdir -p "$TARGET_DIR"

  # Create one symlink per skill (scan two levels deep: group/skillname/)
  for skill_dir in "$SKILLS"/*/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    link_path="${TARGET_DIR}/${skill_name}"

    if [ -L "$link_path" ]; then
      rm "$link_path"
    elif [ -e "$link_path" ]; then
      mv "$link_path" "${link_path}.bak"
      echo "Backed up existing: $link_path → ${link_path}.bak"
    fi

    ln -sf "$skill_dir" "$link_path"
    echo "Linked: $link_path → $skill_dir"
  done

  echo "Done: $TARGET_DIR"
done

# --- Cursor rules: single folder symlink ---
CURSOR_RULES="${HOME}/.cursor/rules"
RULES_SRC="${REPO_ROOT}/rules"

if [ -d "$RULES_SRC" ]; then
  if [ -L "$CURSOR_RULES" ] && [ "$(readlink "$CURSOR_RULES")" = "$RULES_SRC" ]; then
    echo "rules already linked: $CURSOR_RULES"
  else
    [ -L "$CURSOR_RULES" ] && rm "$CURSOR_RULES"
    ln -sf "$RULES_SRC" "$CURSOR_RULES"
    echo "Linked: $CURSOR_RULES → $RULES_SRC"
  fi
fi

echo
echo "All skills linked for Claude Code and Cursor (including Cursor rules)."
