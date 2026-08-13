---
name: git-conventional-commits
description: Writes commits, amends, and PRs following Conventional Commits. Use whenever the user asks to commit, stage, amend, rebase, write a commit message, or create a pull request. Always inspect the repo's existing git log style first and follow it.
---

# Conventional Commits

## Format

```
type(scope): summary
```

## Types

- `feat` — new feature
- `fix` — bug fix
- `refactor` — change without new behavior
- `perf` — performance improvement
- `docs` — documentation
- `test` — tests
- `build` — build/tooling
- `ci` — continuous integration
- `chore` — maintenance
- `style` — formatting
- `revert` — revert a commit

## Rules

1. Before writing: `git log --oneline -10` and follow the repo's style (types used, language, with/without scope).
2. Summary in imperative mood ("add", not "added"), < 72 chars, no trailing period.
3. Optional scope, kebab-case: `fix(auth): ...`.
4. Body explains the **why** + what changes. Be specific.
5. Breaking change: `feat!(api): ...` + footer `BREAKING CHANGE: <description>`.
6. Reference issues in the footer: `Closes #12`.
7. One commit = one logical change. Use `git add -p` to split changes.
8. Do not rewrite public history. `amend`/`rebase -i` only on a local, unpushed branch.
9. Review `git diff` before committing: never include secrets, environment files, or junk.

## Anti-patterns

- Emojis (unless the repo already uses them).
- Generic messages: "update", "fix stuff", "changes".
- Mixing unrelated changes in the same commit.

## PR

- Title in the same style (`type(scope): summary`).
- Description: what / why / how to test.
- Draft for WIP.
