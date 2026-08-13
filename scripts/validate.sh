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

echo "## Onboarding"
for doc in templates/ONBOARDING.md SETUP.md; do
  if [[ ! -f "$REPO_DIR/$doc" ]]; then
    echo "FAIL: $doc does not exist"
    FAIL=1
  else
    echo "  ok: $doc"
  fi
done

echo "## opencode plugins"
for plugin in "$REPO_DIR"/plugins/*.js; do
  [[ -e "$plugin" ]] || continue
  name="$(basename "$plugin")"
  if ! command -v node >/dev/null 2>&1; then
    echo "  ok: $name (node not available, skipped syntax check)"
    continue
  fi
  if node --input-type=module --check < "$plugin" 2>/dev/null; then
    echo "  ok: $name syntax (node)"
  else
    echo "FAIL: $name has a syntax error"
    FAIL=1
  fi
done

echo "## notify.sh dispatcher"
if [[ ! -f "$REPO_DIR/scripts/notify.sh" ]]; then
  echo "FAIL: scripts/notify.sh does not exist"
  FAIL=1
else
  if [[ ! -x "$REPO_DIR/scripts/notify.sh" ]]; then
    echo "FAIL: scripts/notify.sh is not executable"
    FAIL=1
  fi
  if bash -n "$REPO_DIR/scripts/notify.sh" 2>/dev/null; then
    echo "  ok: scripts/notify.sh syntax (bash)"
  else
    echo "FAIL: scripts/notify.sh has a syntax error"
    FAIL=1
  fi
fi

if [[ "$FAIL" -eq 0 ]]; then
  echo "All good."
else
  echo "Failures found." >&2
  exit 1
fi
