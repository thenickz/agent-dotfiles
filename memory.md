# Memory

> Auto-maintained by the **active-brain-memory** skill. Read at the start of every session.
> Short bullets, one line each. Keep the file < ~150 lines.

## Current State
- in-progress: — (repo implemented, skills installed)
- next: publish on GitHub (`gh repo create agent-dotfiles --public` + push); test `scaffold-agents-md` on a new project; add save hardening (hook/plugin) if needed

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

## Learnings
- AGENTS.md is an open standard (Linux Foundation/AAIF), read by 20+ tools; < 150 lines, exact commands, code examples, explicit boundaries.
- Skills in Agent Skills format (`<name>/SKILL.md`, `name` + `description` frontmatter) load on demand (progressive disclosure).
- opencode reads `~/.claude/skills` and `~/.agents/skills` automatically; Claude Code reads `~/.claude/skills`; Codex reads `~/.agents/skills`.
- A giant CLAUDE.md is an anti-pattern (the agent starts ignoring rules) — prefer a small file + on-demand skills.
- AGENTS.md anti-patterns: too vague, contradictory rules, duplication across formats.

## Workflows & Commands
- Install skills: `./install.sh` (symlinks in `~/.claude/skills` and `~/.agents/skills`)
- Preview installation: `./install.sh --dry-run`
- Remove: `./install.sh --unlink`
- Validate skills/templates: `./scripts/validate.sh`
- New project: `scaffold-agents-md` skill → AGENTS.md + memory.md + architecture.md

## Primordial Flows
- NODE(A2) -> NODE(B) -> NODE(C) (globally installed skills work in every project)
- NODE(A1) -> NODE(C) (templates copied manually or via scaffold)
- AGENTS.md -> memory.md <-> architecture.md (brain loop)

## Session Log
- 2026-08-12 | Scope defined: base AGENTS.md + 5 skills; `active-brain-memory` and `scaffold-agents-md` approved; no CLAUDE.md/opencode.json; implementation started
- 2026-08-12 | Repo implemented: templates, 5 skills, install.sh, validate.sh, AGENTS.md/memory/architecture (dogfood). Skills installed via symlinks and validated; validate.sh + install.sh (dry-run/real/idempotent) OK. `set -e` bug fixed. Nothing committed.
- 2026-08-12 | README gained Authorship/Inspirations/License sections; LICENSE (MIT) created
- 2026-08-12 | Entire repo translated to English; README got a Summary (TOC); Personal Preferences section added to AGENTS.md (blank)
- 2026-08-12 | Repo published: branch renamed to main, GitHub repo created, all commits in user authorship (no co-author), pushed
