#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
CLAUDE_DIR="$HOME/.claude/skills"
AGENTS_DIR="$HOME/.agents/skills"

DEPS=(
  "$REPO_DIR/deps/opencode-notify"
  "$REPO_DIR/deps/active-brain-memory"
)

DRY=false
UNLINK=false

usage() {
  cat <<'EOF'
Installs the repo skills as symlinks in the tools' global paths and delegates
the opencode plugins and the notify dispatcher to the dependency repos
(git submodules in deps/).

Usage: ./install.sh [--dry-run] [--unlink]

Paths (created if missing):
  ~/.claude/skills/            local skills (Claude Code + opencode)
  ~/.agents/skills/            local skills (Codex + opencode)

Delegated to deps/ (see each repo's own install.sh):
  deps/opencode-notify         notify plugin + dispatcher + skill + env template
  deps/active-brain-memory     memory enforcement plugin + skill

Options:
  --dry-run  show what it would do without changing anything
  --unlink   remove the created symlinks (does not touch the repos)

Submodules are initialized automatically (git submodule update --init).

Non-destructive: never overwrites an existing dir/file that is not a symlink
to this repo; in those cases it skips with a warning.
EOF
}

orig_args=("$@")

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

if [[ "$UNLINK" == false && "$DRY" == false ]]; then
  echo "## Initializing submodules (deps/)"
  git -C "$REPO_DIR" submodule update --init --recursive
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
  mkdir -p "$CLAUDE_DIR" "$AGENTS_DIR"
fi

echo "## Local skills"
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

echo "## Dependencies"
for dep in "${DEPS[@]}"; do
  if [[ ! -f "$dep/install.sh" ]]; then
    echo "SKIP $dep (submodule not checked out — run ./install.sh first)"
    continue
  fi
  echo "delegating: $dep/install.sh ${orig_args[*]}"
  "$dep/install.sh" "${orig_args[@]}"
done

echo "done."
