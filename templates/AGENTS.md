# <Project>

> <One line about what the project does and for whom.>

## Stack
- Language: <Python 3.12>
- Runtime / manager: <uv>
- Framework: <...>
- Main dependencies: <...>

## Commands
> EXACT and verified commands. Run each one before documenting it.
- Setup: `<uv sync>`
- Dev: `<...>`
- Test: `<...>`
- Lint: `<...>`
- Typecheck: `<...>`
- Build: `<...>`
- Deploy: `<...>`

## Code style
> One rule + one code example per rule. No generic "clean code".

### <Rule>
```<lang>
# right: <...>
# wrong: <...>
```

## Structure
> Short folder map.
```
src/      # code
tests/    # tests
docs/     # documentation
```

## Personal Preferences
> Project-agnostic user preferences (apply to every project).
- Keep code and documentation in English.
- Commits are authored by the user only — do not add `Co-authored-by` trailers.
> Add your own here, e.g.: "Speak Portuguese with the user, but keep code and documentation in English."

## Boundaries
- Never edit: <generated/, migrations/, vendored/>
- Ask before: <...>
- Do not: <...>

## Git workflow
- Conventional commits: `type(scope): summary` (see git-conventional-commits skill).
- Before committing, follow the style of `git log --oneline -10`.
- Branch: `<feature/xxx>`
- PR: `<draft → review → merge>`

## Memory & Architecture (BRAIN)
This project uses the **active-brain-memory** and **architecture** skills.

- At the START of every session, READ `memory.md` and `architecture/` (always).
- Update `memory.md` continuously: decisions, learnings, workflows, session bullets — without the user asking.
- Keep the Node Registry and flows in `architecture.md` in sync when the structure changes.
- `memory.md` and `architecture.md` are the source of truth for this project's state.

## Verification
- Always run `<test command>` after changes.
- Show evidence (test/build output) instead of asserting success.
