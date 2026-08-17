#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY=false
FROM=""

usage() {
  cat <<'EOF'
Migrates agent-dotfiles to a newer version. Detects the current version
automatically or accepts an explicit --from flag.

Usage: ./scripts/migrate.sh [--dry-run] [--from VERSION]

Examples:
  ./scripts/migrate.sh              # auto-detect and migrate
  ./scripts/migrate.sh --from beta  # explicit migration from beta
  ./scripts/migrate.sh --dry-run    # preview changes

Versions:
  beta    → pre-versioning (no version line in AGENTS.md)
  0.1.0   → current (brain files in agent/)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY=true ;;
    --from) FROM="$2"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

detect_version() {
  if [[ -n "$FROM" ]]; then
    echo "$FROM"
    return
  fi

  if grep -qE '^> v[0-9]' "$REPO_DIR/AGENTS.md" 2>/dev/null; then
    grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' "$REPO_DIR/AGENTS.md" | head -1
  elif [[ -f "$REPO_DIR/memory.md" || -f "$REPO_DIR/architecture.md" || -f "$REPO_DIR/SETUP.md" ]]; then
    echo "beta"
  else
    echo "clean"
  fi
}

CURRENT_VERSION="$(detect_version)"
echo "Detected version: $CURRENT_VERSION"

if [[ "$CURRENT_VERSION" == "clean" ]]; then
  echo "Nothing to migrate — no legacy files found."
  exit 0
fi

MOVED=0

move_if_exists() {
  local src="$1" dest="$2"
  if [[ -f "$src" ]]; then
    if [[ "$DRY" == true ]]; then
      echo "  would move: $(basename "$src") → $dest"
    else
      mkdir -p "$(dirname "$dest")"
      mv "$src" "$dest"
      echo "  moved: $(basename "$src") → $dest"
    fi
    MOVED=1
  fi
}

remove_dir_if_empty() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    if [[ -z "$(ls -A "$dir" 2>/dev/null)" ]]; then
      if [[ "$DRY" == true ]]; then
        echo "  would remove: $dir/"
      else
        rmdir "$dir"
        echo "  removed: $dir/"
      fi
    fi
  fi
}

case "$CURRENT_VERSION" in
  beta)
    echo "Migrating beta → 0.1.0..."
    move_if_exists "$REPO_DIR/memory.md" "$REPO_DIR/agent/memory.md"
    move_if_exists "$REPO_DIR/architecture.md" "$REPO_DIR/agent/architecture.md"
    move_if_exists "$REPO_DIR/architecture/flows.md" "$REPO_DIR/agent/flows.md"
    move_if_exists "$REPO_DIR/SETUP.md" "$REPO_DIR/agent/SETUP.md"
    remove_dir_if_empty "$REPO_DIR/architecture"
    ;;
  *)
    echo "Version $CURRENT_VERSION → 0.1.0: nothing to migrate (already current)."
    exit 0
    ;;
esac

if [[ "$MOVED" -eq 0 && "$CURRENT_VERSION" != "clean" ]]; then
  echo "No files to move — structure may already be current."
fi

if [[ "$DRY" == true ]]; then
  echo "Dry run complete. No changes made."
else
  echo "Migration to 0.1.0 complete."
fi
