# agent-dotfiles

AI agent dotfiles: copyable templates for new projects + portable skills (persistent memory, architecture, git, github) that run on Claude Code, opencode, and Codex.

## Stack
- Shell: bash
- Skills format: Agent Skills (`SKILL.md`, `name` + `description` frontmatter)
- Convention: `AGENTS.md` as the single source (< 150 lines)

## Commands
> EXACT and verified commands.
- Install skills + opencode plugins (memory + notify): `./install.sh`
- Preview what it would do: `./install.sh --dry-run`
- Remove symlinks: `./install.sh --unlink`
- Validate skills/templates/plugins/setup docs: `./scripts/validate.sh`
- OS notification dispatcher (test): `~/.config/opencode/notify.sh "title" "message" done`
- Bootstrap a new project with another LLM: see `SETUP.md` (one-shot prompt)

## Code style
- Skill name: kebab-case, lowercase, ≤ 64 chars, folder = name.
- `description`: "what it does" + "when to use"; lead with trigger keywords.
- Portability: skills live in `skills/<name>/`; installed via symlinks in `~/.claude/skills` and `~/.agents/skills`.
- Reference instead of duplicating; keep `templates/AGENTS.md` in sync with `skills/scaffold-agents-md/templates/AGENTS.md`.
- Plugin (`plugins/*.js`): ESM, no external deps, uses only Bun.file, `$`, and the SDK client.

## Structure
```
templates/     # files to copy into new projects (AGENTS.md, ONBOARDING.md)
skills/        # portable skills (SKILL.md)
plugins/       # opencode plugins (memory enforcement + notify)
scripts/       # utilities (validate.sh, notify.sh)
architecture/  # map details (flows.md)
SETUP.md       # one-shot prompt for another LLM to bootstrap a project
```

## Personal Preferences
> Project-agnostic user preferences (apply to every project).
- Keep code and documentation in English.
- Commits are authored by the user only — do not add `Co-authored-by` trailers.
> Add your own here, e.g.: "Speak Portuguese with the user, but keep code and documentation in English."

## Boundaries
- `install.sh` NEVER overwrites existing config (skips with a warning).
- Never store secrets in `memory.md` or `AGENTS.md`.
- `session-*.md` files are not versioned (personal transcripts).

## Git workflow
- Conventional commits: `type(scope): summary` (git-conventional-commits skill).
- Before committing, follow the style of `git log --oneline -10`.
- Branch: `main` (personal dotfiles).

## Memory & Architecture (BRAIN)
This project uses the **active-brain-memory** and **architecture** skills.

- At the START of every session, READ `memory.md` and `architecture.md` (always).
- Update `memory.md` continuously: decisions, learnings, workflows, session bullets — without the user asking.
- Keep the Node Registry and flows in `architecture.md` in sync when the structure changes.
- `memory.md` and `architecture.md` are the source of truth for this project's state.

## Verification
- After changes to skills/templates: run `./scripts/validate.sh` and show the output.
