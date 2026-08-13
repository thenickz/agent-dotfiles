# Memory

> Auto-maintained by the **active-brain-memory** skill. Read at the start of every session.
> Short bullets, one line each. Keep the file < ~150 lines.

## Current State
- in-progress: — (repo implemented, skills + plugin installed)
- next: verify the memory plugin live loop (fresh opencode session); test one-shot setup (SETUP.md) on a new project

## Decisions
- 2026-08-12 | Agent dotfiles repo: `AGENTS.md` as the single source; NO `CLAUDE.md`, NO `opencode.json` | user does not use Claude Code; opencode reads AGENTS.md natively
- 2026-08-12 | Skills installed via symlinks (`~/.claude/skills` + `~/.agents/skills`), not copied | single source + cross-tool portability (Claude Code, opencode, Codex)
- 2026-08-12 | Memory = versioned files (`memory.md` + `architecture/`) instead of session context | eliminates re-explaining and long sessions
- 2026-08-12 | Architecture notation `NODE(LETTER)` + sub-nodes `NODE(LETTER+NUMBER)` | readable by LLMs and humans
- 2026-08-12 | `memory.md` updates autonomously and continuously during the session | user never has to ask to save
- 2026-08-12 | Memory skill named `active-brain-memory`; include `scaffold-agents-md` | user decision
- 2026-08-12 | `install.sh` with `set -e` needs explicit `if` instead of `[[ ]] && cmd` as the function's last line | a failing `[[ ]]` as the last command returned 1 and killed the script on the 1st link
- 2026-08-12 | MIT license; README with Authorship (authorial skills, personal preferences) and Inspirations sections | give credit and allow reuse
- 2026-08-12 | Entire repo in English; Personal Preferences section (blank) added to AGENTS.md | user preference: code/docs in English, interaction language configurable later
- 2026-08-12 | Commits authored by the user only — no `Co-authored-by` trailers (recorded as a Personal Preference in AGENTS.md) | user preference
- 2026-08-12 | Memory enforcement for opencode via `plugins/opencode-memory.js`: on `session.idle`, if `memory.md` exists and `git status --porcelain -- memory.md` is empty, inject a prompt (active-brain-memory) to update it | memory.md updates were voluntary (skill-following); a plugin makes them automatic on opencode only, with natural termination once the model saves and a last-user-message loop guard
- 2026-08-12 | `templates/ONBOARDING.md` (temporary first-run prompt) + `SETUP.md` (one-shot prompt for another LLM to clone/install/copy/onboard) | no manual setup: a single prompt bootstraps a new project with the brain system

## Learnings
- AGENTS.md is an open standard (Linux Foundation/AAIF), read by 20+ tools; < 150 lines, exact commands, code examples, explicit boundaries.
- Skills in Agent Skills format (`<name>/SKILL.md`, `name` + `description` frontmatter) load on demand (progressive disclosure).
- opencode reads `~/.claude/skills` and `~/.agents/skills` automatically; Claude Code reads `~/.claude/skills`; Codex reads `~/.agents/skills`.
- A giant CLAUDE.md is an anti-pattern (the agent starts ignoring rules) — prefer a small file + on-demand skills.
- AGENTS.md anti-patterns: too vague, contradictory rules, duplication across formats.

## Workflows & Commands
- Install skills + plugin: `./install.sh` (symlinks in `~/.claude/skills`, `~/.agents/skills`, `~/.config/opencode/plugins`)
- Preview installation: `./install.sh --dry-run`
- Remove: `./install.sh --unlink`
- Validate skills/templates/plugin/setup docs: `./scripts/validate.sh`
- New project: `SETUP.md` one-shot prompt (clone, install, copy templates + ONBOARDING.md, onboard)
- Disable memory enforcement: delete `~/.config/opencode/plugins/opencode-memory.js` or `./install.sh --unlink`

## Primordial Flows
- NODE(A2) -> NODE(B) -> NODE(C) (globally installed skills work in every project)
- NODE(A4) -> NODE(B) -> NODE(C) (opencode memory plugin enforces memory.md updates)
- NODE(A1) -> NODE(C) (templates copied manually or via scaffold)
- NODE(A5) -> NODE(C) (one-shot setup: SETUP.md + ONBOARDING.md)
- AGENTS.md -> memory.md <-> architecture.md (brain loop)

## Session Log
- 2026-08-12 | Scope defined: base AGENTS.md + 5 skills; `active-brain-memory` and `scaffold-agents-md` approved; no CLAUDE.md/opencode.json; implementation started
- 2026-08-12 | Repo implemented: templates, 5 skills, install.sh, validate.sh, AGENTS.md/memory/architecture (dogfood). Skills installed via symlinks and validated; validate.sh + install.sh (dry-run/real/idempotent) OK. `set -e` bug fixed. Nothing committed.
- 2026-08-12 | README gained Authorship/Inspirations/License sections; LICENSE (MIT) created
- 2026-08-12 | Entire repo translated to English; README got a Summary (TOC); Personal Preferences section added to AGENTS.md (blank)
- 2026-08-12 | Repo published: branch renamed to main, GitHub repo created, all commits in user authorship (no co-author), pushed
- 2026-08-12 | Memory enforcement plugin `plugins/opencode-memory.js` created (session.idle + git status + injected prompt + loop guard); install.sh/validate.sh extended (plugin symlink, node ESM syntax check); README/AGENTS.md updated; architecture + memory mapped (NODE A4). Validated: validate.sh OK, install.sh --dry-run shows plugin link, node --check OK
- 2026-08-12 | Plugin live loop verified headless (opencode serve + SDK): turn 1 → plugin injected, model appended Session Log bullet (memory.md = ` M`); turn 2 with memory already dirty → no re-injection (natural termination). Temp project removed
