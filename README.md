# agent-dotfiles

AI agent dotfiles: a project standard + a set of portable skills that turn any repository into a system with persistent memory ("brain").

## Summary

- [The system (3 layers)](#the-system-3-layers)
- [Repository structure](#repository-structure)
- [Installation](#installation)
- [Using in a new project](#using-in-a-new-project)
- [Memory enforcement (opencode plugin)](#memory-enforcement-opencode-plugin)
- [Bootstrap a new project with another LLM](#bootstrap-a-new-project-with-another-llm)
- [Skills](#skills)
- [Authorship](#authorship)
- [Inspirations](#inspirations)
- [License](#license)
- [Philosophy](#philosophy)

## The system (3 layers)

| Layer | File | What it stores |
|---|---|---|
| Constitution | `AGENTS.md` | stack, exact commands, style, boundaries, git workflow |
| Brain | `memory.md` | current state, decisions, learnings, workflows, session log |
| Map | `architecture.md` + `architecture/` | structure with `NODE(X)` notation and data flows |

Nothing stays trapped in the session context. Knowledge lives in versioned files — short sessions + files = zero lost context, no re-explaining.

## Repository structure

```
templates/   # files to copy into new projects (AGENTS.md, ONBOARDING.md)
skills/      # portable skills (Agent Skills format)
plugins/     # opencode memory enforcement plugin
scripts/     # validation
SETUP.md     # one-shot prompt for another LLM to bootstrap a project
install.sh   # installs the skills + plugin via symlinks
LICENSE      # MIT
```

## Installation

```bash
./install.sh            # creates symlinks in ~/.claude/skills, ~/.agents/skills and ~/.config/opencode/plugins
./install.sh --dry-run  # shows what it would do, without changing anything
./install.sh --unlink   # removes the symlinks
./scripts/validate.sh   # validates skill frontmatter, template sync, plugin, setup docs
```

Why symlinks: a single source of truth in the repo; edit here and every tool (Claude Code, opencode, Codex) sees the change immediately. On a new machine: `git clone` + `./install.sh`.

## Using in a new project

1. Copy `templates/AGENTS.md` (and adapt it), or ask the agent to run the **scaffold-agents-md** skill — it analyzes the project and generates `AGENTS.md` + `memory.md` + `architecture/` with verified commands.
2. From then on the brain is on: `memory.md` is read and updated automatically every session (**active-brain-memory**), and the map stays in sync (**architecture**).

## Memory enforcement (opencode plugin)

Updating `memory.md` is normally voluntary — the agent follows the **active-brain-memory** skill. On opencode, `plugins/opencode-memory.js` (installed by `./install.sh` into `~/.config/opencode/plugins/`) makes it automatic: at the end of every turn (`session.idle`) it checks whether `memory.md` was touched in this project. If not, it injects a prompt asking the agent to run **active-brain-memory** and update `memory.md`; when the model saves, the next `session.idle` becomes a no-op. It does nothing in projects without `memory.md` or without git.

To disable it: `./install.sh --unlink` removes all symlinks including the plugin, or delete `~/.config/opencode/plugins/opencode-memory.js`. No effect on Claude Code or Codex.

## Bootstrap a new project with another LLM

No manual setup required: give any LLM the prompt in [SETUP.md](SETUP.md) (e.g. "Read `https://github.com/thenickz/agent-dotfiles` and configure a new project"). It clones the repo, installs the skills and plugin, copies `AGENTS.md` + `ONBOARDING.md` into the project, scaffolds the brain files, and runs the onboarding — all in one shot.

## Skills

- **active-brain-memory** — the project's persistent memory: reads it at start, continuously records decisions/learnings/workflows/state, condenses old sessions into long-term knowledge, and forgets what is irrelevant.
- **architecture** — maintains `architecture.md`/`architecture/` with `NODE(LETTER)`/`NODE(LETTER+NUMBER)` node notation and chained data flows; mirrors the primordial flows into memory.
- **git-conventional-commits** — commits and PRs following Conventional Commits (`type(scope): summary`).
- **github** — GitHub workflows with the `gh` CLI (repos, PRs, issues, releases, Actions).
- **scaffold-agents-md** — new-project bootstrap: generates a tailored AGENTS.md + memory.md + architecture.md.

## Authorship

The skills, the templates, and the `NODE(LETTER)` notation are **authorial**: created from personal preferences and optimized for my own workflow. They were born from well-established community best practices, but were shaped and tuned for the way I work with AI agents. Use them as a base and adapt them to your context.

## Inspirations

The **Agent Skills** format (`SKILL.md` with `name` + `description` frontmatter) is an open standard started by Anthropic and adopted by Claude Code, opencode, Codex, Cursor, Copilot, and others:

- [Agent Skills (Anthropic docs)](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) — `SKILL.md` format, progressive disclosure
- [AGENTS.md (agentes.md)](https://agents.md) — open per-project instruction convention, adopted by the Linux Foundation / Agentic AI Foundation
- [self.md / Self-Updating Instructions](https://self.md) — procedural memory built one correction at a time (the philosophy behind `active-brain-memory`)
- [Claude Code Auto Memory](https://code.claude.com/docs/en/memory) — layered automatic memory (inspiration for the brain loop)
- [C4 model](https://c4model.com) — leveled diagrams; the `NODE(X)` notation is a simplified textual adaptation for LLM readability
- [Conventional Commits](https://www.conventionalcommits.org) — `type(scope): summary` format
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices) — give the agent a way to verify its work, explore → plan → code, lean context
- Community: [obra/superpowers](https://github.com/obra/superpowers), [mattpocock/skills](https://github.com/mattpocock/skills), [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)

## License

MIT — see [LICENSE](LICENSE).

## Philosophy

- `AGENTS.md` as the single source of conventions (< 150 lines, Linux Foundation/AAIF open standard).
- Skills in the **Agent Skills** format (`<name>/SKILL.md`, `name` + `description` frontmatter), loaded on demand.
- Portability: skills in `~/.claude/skills` **and** `~/.agents/skills` (paths read by Claude Code, opencode, and Codex).
- Non-destructive installation: never overwrites existing configuration.
