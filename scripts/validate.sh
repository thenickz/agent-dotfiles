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

echo "## Skills (local)"
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

if [[ ! -f "$REPO_DIR/deps/active-brain-memory/templates/memory.md" ]]; then
  echo "FAIL: missing deps/active-brain-memory/templates/memory.md (submodule not checked out?)"
  FAIL=1
elif ! diff -q "$REPO_DIR/templates/memory.md" "$REPO_DIR/deps/active-brain-memory/templates/memory.md" >/dev/null 2>&1; then
  echo "FAIL: templates/memory.md ≠ deps/active-brain-memory/templates/memory.md"
  FAIL=1
else
  echo "  ok: memory.md template in sync"
fi

echo "## Onboarding"
for doc in templates/ONBOARDING.md agent/SETUP.md; do
  if [[ ! -f "$REPO_DIR/$doc" ]]; then
    echo "FAIL: $doc does not exist"
    FAIL=1
  else
    echo "  ok: $doc"
  fi
done

echo "## Dependencies (submodules)"
while IFS= read -r line; do
  status="${line:0:1}"
  name="$(echo "$line" | awk '{print $2}')"
  case "$status" in
    "-") echo "FAIL: $name is not initialized (run ./install.sh)" ; FAIL=1 ;;
    "+") echo "FAIL: $name is at a different commit than pinned (run git submodule update)" ; FAIL=1 ;;
    " ") echo "  ok: $name" ;;
    *) echo "FAIL: $name unexpected submodule status" ; FAIL=1 ;;
  esac
done < <(git -C "$REPO_DIR" submodule status)

for dep in "$REPO_DIR"/deps/*/; do
  [[ -d "$dep" ]] || continue
  dep_name="$(basename "$dep")"
  if [[ ! -f "$dep/scripts/validate.sh" ]]; then
    echo "FAIL: $dep_name/scripts/validate.sh does not exist"
    FAIL=1
    continue
  fi
  echo "## Dependency validate: $dep_name"
  if "$dep/scripts/validate.sh"; then
    echo "  ok: $dep_name validation passed"
  else
    echo "FAIL: $dep_name validation failed"
    FAIL=1
  fi
done

if [[ "$FAIL" -eq 0 ]]; then
  echo "All good."
else
  echo "Failures found." >&2
  exit 1
fi
