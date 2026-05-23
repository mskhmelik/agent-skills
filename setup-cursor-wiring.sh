#!/usr/bin/env bash
# Wire OneDrive ai/skills and ai/rules into ~/.cursor/ for Cursor IDE.

set -euo pipefail

AI_ROOT="$(cd "$(dirname "$0")" && pwd)"
CURSOR_DIR="${HOME}/.cursor"
SKILLS_SRC="${AI_ROOT}/skills"
RULES_SRC="${AI_ROOT}/rules"

mkdir -p "${CURSOR_DIR}"

link_dir() {
  local src="$1"
  local dest="$2"
  local name="$3"

  if [[ ! -d "$src" ]]; then
    echo "Missing ${name} source: $src"
    exit 1
  fi

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest")"
    if [[ "$current" == "$src" ]]; then
      echo "${name} already linked: $dest -> $src"
      return
    fi
    echo "Replacing ${name} link (was -> $current)"
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    echo "ERROR: $dest exists and is not a symlink. Move it aside manually, then rerun."
    exit 1
  fi

  ln -s "$src" "$dest"
  echo "Linked ${name}: $dest -> $src"
}

link_dir "$SKILLS_SRC" "${CURSOR_DIR}/skills" "skills"
link_dir "$RULES_SRC" "${CURSOR_DIR}/rules" "rules"

echo
echo "Done. Restart Cursor to pick up new skills and rules."
