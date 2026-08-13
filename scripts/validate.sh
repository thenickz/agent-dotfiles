#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAIL=0

check_skill() {
  local dir="$1"
  local name
  name="$(basename "$dir")"
  local file="$dir/SKILL.md"

  if [[ ! -f "$file" ]]; then
    echo "FAIL: $file does not exist"
    FAIL=1
    return
  fi

  local fm_name fm_desc
  fm_name="$(awk -F': *' '/^name:/{print $2; exit}' "$file" | tr -d '[:space:]')"
  fm_desc="$(awk '/^description:/{sub(/^description: */,""); print; exit}' "$file" | tr -d '[:space:]')"

  if [[ -z "$fm_name" || "$fm_name" != "$name" ]]; then
    echo "FAIL: $file frontmatter name='$fm_name' does not match the folder '$name'"
    FAIL=1
  fi

  if [[ ! "$fm_name" =~ ^[a-z0-9-]+$ || "${#fm_name}" -gt 64 ]]; then
    echo "FAIL: $file name '$fm_name' — must be kebab-case, lowercase, ≤ 64 chars"
    FAIL=1
  fi

  if [[ -z "$fm_desc" ]]; then
    echo "FAIL: $file has no description in the frontmatter"
    FAIL=1
  fi
}

echo "## Skills"
for dir in "$REPO_DIR"/skills/*/; do
  [[ -e "$dir" ]] || continue
  check_skill "$dir"
  echo "  ok: $(basename "$dir")"
done

echo "## Template sync"
if [[ ! -f "$REPO_DIR/skills/scaffold-agents-md/templates/AGENTS.md" ]]; then
  echo "FAIL: missing skills/scaffold-agents-md/templates/AGENTS.md"
  FAIL=1
elif ! diff -q "$REPO_DIR/templates/AGENTS.md" "$REPO_DIR/skills/scaffold-agents-md/templates/AGENTS.md" >/dev/null 2>&1; then
  echo "FAIL: templates/AGENTS.md ≠ skills/scaffold-agents-md/templates/AGENTS.md"
  FAIL=1
else
  echo "  ok: AGENTS.md template in sync"
fi

if [[ "$FAIL" -eq 0 ]]; then
  echo "All good."
else
  echo "Failures found." >&2
  exit 1
fi
