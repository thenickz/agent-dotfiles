#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
CLAUDE_DIR="$HOME/.claude/skills"
AGENTS_DIR="$HOME/.agents/skills"
OPENCODE_PLUGIN_DIR="$HOME/.config/opencode/plugins"
PLUGIN_SRC="$REPO_DIR/plugins/opencode-memory.js"

DRY=false
UNLINK=false

usage() {
  cat <<'EOF'
Installs the repo skills and the opencode memory plugin as symlinks in the
tools' global paths.

Usage: ./install.sh [--dry-run] [--unlink]

Paths (created if missing):
  ~/.claude/skills/           Claude Code + opencode
  ~/.agents/skills/           Codex + opencode
  ~/.config/opencode/plugins/ opencode memory enforcement plugin

Options:
  --dry-run  show what it would do without changing anything
  --unlink   remove the created symlinks (does not touch the repo)

Non-destructive: never overwrites an existing dir/file that is not a symlink
to this repo; in those cases it skips with a warning.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY=true ;;
    --unlink) UNLINK=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "Error: skills/ dir not found at $SKILLS_DIR" >&2
  exit 1
fi

link_one() {
  local src="$1" dest="$2"

  if [[ "$UNLINK" == true ]]; then
    if [[ -L "$dest" ]]; then
      echo "  remove $dest"
      if [[ "$DRY" == false ]]; then
        rm "$dest"
      fi
    else
      echo "  skip $dest (not a symlink)"
    fi
    return
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" ]]; then
      echo "  ok $dest (already linked)"
    else
      echo "  SKIP $dest (exists and is not a symlink to this repo)"
    fi
    return
  fi

  echo "  link $dest"
  if [[ "$DRY" == false ]]; then
    ln -s "$src" "$dest"
  fi
}

if [[ "$DRY" == true ]]; then
  echo "## DRY RUN — nothing will be changed"
fi

if [[ "$UNLINK" == false && "$DRY" == false ]]; then
  mkdir -p "$CLAUDE_DIR" "$AGENTS_DIR" "$OPENCODE_PLUGIN_DIR"
fi

for skill_dir in "$SKILLS_DIR"/*/; do
  [[ -e "$skill_dir" ]] || continue
  name="$(basename "$skill_dir")"
  if [[ ! -f "$skill_dir/SKILL.md" ]]; then
    echo "skip $name (no SKILL.md)"
    continue
  fi
  link_one "$skill_dir" "$CLAUDE_DIR/$name"
  link_one "$skill_dir" "$AGENTS_DIR/$name"
done

if [[ -f "$PLUGIN_SRC" ]]; then
  link_one "$PLUGIN_SRC" "$OPENCODE_PLUGIN_DIR/opencode-memory.js"
else
  echo "skip opencode plugin (missing $PLUGIN_SRC)"
fi

echo "done."
