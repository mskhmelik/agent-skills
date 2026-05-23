#!/usr/bin/env bash
# Wire OneDrive ai/skills (per-skill symlinks) and ai/rules into ~/.cursor/ for Cursor IDE.
# Skills are organised in group subfolders (product/, vault/, utilities/, private/).
# This script is a thin wrapper — skills are also wired by setup/setup.sh.
# Run this if you want to ensure both skills and rules are linked for Cursor.

set -euo pipefail

AI_ROOT="$(cd "$(dirname "$0")" && pwd)"
CURSOR_DIR="${HOME}/.cursor"
SKILLS_SRC="${AI_ROOT}/skills"
RULES_SRC="${AI_ROOT}/rules"

mkdir -p "${CURSOR_DIR}"

# --- Skills: per-skill symlinks (same logic as setup/setup.sh) ---

CURSOR_SKILLS="${CURSOR_DIR}/skills"

# Remove legacy whole-folder symlink if present
if [[ -L "$CURSOR_SKILLS" ]]; then
  rm "$CURSOR_SKILLS"
  echo "Removed legacy skills symlink: $CURSOR_SKILLS"
fi
mkdir -p "$CURSOR_SKILLS"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "Missing skills source: $SKILLS_SRC"
  exit 1
fi

for skill_dir in "$SKILLS_SRC"/*/*/; do
  [[ -d "$skill_dir" ]] || continue
  skill_name="$(basename "$skill_dir")"
  link_path="${CURSOR_SKILLS}/${skill_name}"

  if [[ -L "$link_path" ]]; then
    current="$(readlink "$link_path")"
    if [[ "$current" == "$skill_dir" ]]; then
      echo "skills/${skill_name} already linked"
      continue
    fi
    rm "$link_path"
  elif [[ -e "$link_path" ]]; then
    echo "ERROR: $link_path exists and is not a symlink. Move it aside manually, then rerun."
    exit 1
  fi

  ln -s "$skill_dir" "$link_path"
  echo "Linked skills/${skill_name} -> $skill_dir"
done

# --- Rules: single folder symlink (rules/ stays flat) ---

CURSOR_RULES="${CURSOR_DIR}/rules"

if [[ ! -d "$RULES_SRC" ]]; then
  echo "Missing rules source: $RULES_SRC"
  exit 1
fi

if [[ -L "$CURSOR_RULES" ]]; then
  current="$(readlink "$CURSOR_RULES")"
  if [[ "$current" == "$RULES_SRC" ]]; then
    echo "rules already linked: $CURSOR_RULES -> $RULES_SRC"
  else
    echo "Replacing rules link (was -> $current)"
    rm "$CURSOR_RULES"
    ln -s "$RULES_SRC" "$CURSOR_RULES"
    echo "Linked rules: $CURSOR_RULES -> $RULES_SRC"
  fi
elif [[ -e "$CURSOR_RULES" ]]; then
  echo "ERROR: $CURSOR_RULES exists and is not a symlink. Move it aside manually, then rerun."
  exit 1
else
  ln -s "$RULES_SRC" "$CURSOR_RULES"
  echo "Linked rules: $CURSOR_RULES -> $RULES_SRC"
fi

echo
echo "Done. Restart Cursor to pick up new skills and rules."
