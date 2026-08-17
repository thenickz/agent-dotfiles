# agent-dotfiles

AI agent dotfiles: a project standard + a set of portable skills that turn any repository into a system with persistent memory ("brain").

## Summary

- [The system (3 layers)](#the-system-3-layers)
- [Repository structure](#repository-structure)
- [Installation](#installation)
- [Using in a new project](#using-in-a-new-project)
- [Dependencies](#dependencies)
- [Memory enforcement (opencode plugin)](#memory-enforcement-opencode-plugin)
- [Notifications (opencode plugin)](#notifications-opencode-plugin)
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
| Brain | `agent/memory.md` (gitignored) | current state, decisions, learnings, workflows, session log |
| Map | `agent/architecture.md` + `agent/flows.md` (gitignored) | structure with `NODE(X)` notation and data flows |

Nothing stays trapped in the session context. Knowledge lives in versioned files — short sessions + files = zero lost context, no re-explaining.

## Repository structure

```
agent/         # personal agent state (gitignored): memory.md, architecture.md, flows.md, SETUP.md
templates/     # files to copy into new projects (AGENTS.md, ONBOARDING.md)
skills/        # portable skills (Agent Skills format)
deps/          # git submodules: opencode-notify + active-brain-memory (plugins + dispatcher)
scripts/       # validation (validate.sh)
install.sh     # installs the skills + plugins via symlinks (inits deps/ submodules)
LICENSE        # MIT
```

## Installation

```bash
./install.sh            # inits deps/ submodules; symlinks skills in ~/.claude/skills and ~/.agents/skills; installs the dep plugins via their own install.sh
./install.sh --dry-run  # shows what it would do, without changing anything
./install.sh --unlink   # removes the symlinks
./scripts/validate.sh   # validates skill frontmatter, template sync, submodules, dep repos
```

Why symlinks: a single source of truth in the repo; edit here and every tool (Claude Code, opencode, Codex) sees the change immediately. On a new machine: `git clone --recursive` + `./install.sh` (install.sh also inits the submodules itself).

## Using in a new project

1. Copy `templates/AGENTS.md` (and adapt it), or ask the agent to run the **scaffold-agents-md** skill — it analyzes the project and generates `AGENTS.md` + `memory.md` + `architecture/` with verified commands.
2. From then on the brain is on: `memory.md` is read and updated automatically every session (**active-brain-memory**), and the map stays in sync (**architecture**).

## Dependencies

The opencode plugins (memory enforcement + notifications) and the `notify.sh` dispatcher are not copied here — they live in two standalone repos pinned as git submodules in `deps/`:

- **[thenickz/opencode-notify](https://github.com/thenickz/opencode-notify)** — notifications plugin + dispatcher + `notify` skill
- **[thenickz/active-brain-memory](https://github.com/thenickz/active-brain-memory)** — memory enforcement plugin + skill + memory.md template

`./install.sh` initializes the submodules and delegates the install to each repo's own `install.sh`. Update the pins with `git submodule update --remote deps/opencode-notify deps/active-brain-memory`. `./scripts/validate.sh` runs each repo's validation.

## Memory enforcement (opencode plugin)

Updating `memory.md` is normally voluntary — the agent follows the **active-brain-memory** skill. On opencode, the enforcement plugin (from `deps/active-brain-memory`, installed into `~/.config/opencode/plugins/`) makes it automatic: at the end of every turn (`session.idle`) it checks whether `memory.md` was touched in this project. If not, it injects a prompt asking the agent to run **active-brain-memory** and update `memory.md`; when the model saves, the next `session.idle` becomes a no-op. It does nothing in projects without `memory.md` or without git, and it auto-skips projects where `memory.md` is gitignored (like this repo).

To disable it: `./install.sh --unlink` removes all symlinks including the plugin, or delete `~/.config/opencode/plugins/opencode-memory.js`. No effect on Claude Code or Codex.

## Notifications (opencode plugin)

The notifications plugin (from `deps/opencode-notify`, installed by `./install.sh`) sends a notification when opencode asks a question, asks for permission, or finishes a response. Two channels, each independently togglable via env vars:

- **OS desktop** — `scripts/notify.sh` auto-detects the platform: WSL → native Windows toast (`wsl-notify-send.exe`, fallback PowerShell BurntToast), macOS → `osascript`, Linux → `notify-send`, Windows → BurntToast.
- **Telegram** — optional; one `sendMessage` via the Bot API, active only when `OPENCODE_TELEGRAM_BOT_TOKEN` and `OPENCODE_TELEGRAM_CHAT_ID` are set.

Key env vars (all optional, every event defaults to on):

| Var | Meaning |
|---|---|
| `OPENCODE_NOTIFY_DISABLED=1` | master switch |
| `OPENCODE_NOTIFY_ON_DONE` / `_ON_PERMISSION` / `_ON_QUESTION=0` | disable an OS event |
| `OPENCODE_NOTIFY_OS=auto` | `auto` \| `darwin` \| `linux` \| `wsl` \| `windows` \| `none` |
| `OPENCODE_TELEGRAM_BOT_TOKEN` + `OPENCODE_TELEGRAM_CHAT_ID` | enables Telegram |
| `OPENCODE_TELEGRAM_ON_DONE` / `_ON_PERMISSION` / `_ON_QUESTION=0` | disable a Telegram event |

Test the OS dispatcher: `~/.config/opencode/notify.sh "opencode" "test" done`. For the guided Telegram setup (BotFather, chat id, smoke test) load the **notify** skill or see `deps/opencode-notify/skills/notify/SKILL.md`. Telegram needs `env` in the shell that starts opencode; never put the token in `memory.md`/`AGENTS.md`.

## Bootstrap a new project with another LLM

No manual setup required: give any LLM the prompt in [agent/SETUP.md](agent/SETUP.md) (e.g. "Read `https://github.com/thenickz/agent-dotfiles` and configure a new project"). It clones the repo, installs the skills and plugin, copies `AGENTS.md` + `ONBOARDING.md` into the project, scaffolds the brain files, and runs the onboarding — all in one shot.

## Skills

Local (`skills/`):

- **architecture** — maintains `architecture.md`/`architecture/` with `NODE(LETTER)`/`NODE(LETTER+NUMBER)` node notation and chained data flows; mirrors the primordial flows into memory.
- **git-conventional-commits** — commits and PRs following Conventional Commits (`type(scope): summary`).
- **github** — GitHub workflows with the `gh` CLI (repos, PRs, issues, releases, Actions).
- **scaffold-agents-md** — new-project bootstrap: generates a tailored AGENTS.md + memory.md + architecture.md.

From the dependencies (`deps/`, see [Dependencies](#dependencies)):

- **active-brain-memory** — the project's persistent memory: reads it at start, continuously records decisions/learnings/workflows/state, condenses old sessions into long-term knowledge, and forgets what is irrelevant.
- **notify** — guided setup for opencode notifications (OS desktop + optional Telegram).

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
