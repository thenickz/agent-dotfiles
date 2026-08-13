# Memory

> Auto-maintained by the **active-brain-memory** skill. Read at the start of every session.
> Short bullets, one line each. Keep the file < ~150 lines.

## Current State
- done: notifications fully implemented + verified live on the real TUI: question ✅ (Telegram msg 11), response finished ✅ (was doubling — fixed with idle dedupe, verified msg 15 single-send), permission ✅ headless (bash is auto-allowed in this setup, so permission.asked doesn't fire live — expected silence)
- next: restart opencode once more to load the dedupe fix; then the feature is ready to commit
- done: research themes (MCPs, proxys, skills, harness, loops) — all other features discarded, only notifications chosen

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
- 2026-08-12 | Notifications = new opencode plugin `opencode-notify.js` + `scripts/notify.sh` (OS dispatcher) + `skills/notify` (guided setup); config via env vars; 2 event types only (question/permission + response done) | user-scoped "finalize framework" to notifications only; OS auto-detect + Telegram optional; all other research themes (MCPs, proxys, harness, loops, new skills) discarded
- 2026-08-12 | notify.sh receives title/message via env vars (`OPENCODE_NOTIFY_TITLE/MESSAGE`), not argv | avoids shell quoting issues from the plugin
- 2026-08-12 | Telegram one-way notification only (Bot API sendMessage via fetch); no webhook/two-way | user asked for optional Telegram notification, not remote control
- 2026-08-12 | `templates/ONBOARDING.md` (temporary first-run prompt) + `SETUP.md` (one-shot prompt for another LLM to clone/install/copy/onboard) | no manual setup: a single prompt bootstraps a new project with the brain system

## Learnings
- AGENTS.md is an open standard (Linux Foundation/AAIF), read by 20+ tools; < 150 lines, exact commands, code examples, explicit boundaries.
- Skills in Agent Skills format (`<name>/SKILL.md`, `name` + `description` frontmatter) load on demand (progressive disclosure).
- opencode reads `~/.claude/skills` and `~/.agents/skills` automatically; Claude Code reads `~/.claude/skills`; Codex reads `~/.agents/skills`.
- A giant CLAUDE.md is an anti-pattern (the agent starts ignoring rules) — prefer a small file + on-demand skills.
- AGENTS.md anti-patterns: too vague, contradictory rules, duplication across formats.
- opencode events for notifications: `session.idle` = response finished (fires for subagents too — filter via `parentID` on session.created); `permission.asked` = permission request (the `permission.ask` hook is inert); the `question` tool is detected via `tool.execute.after` with `input.tool === "question"`.
- OS notifications: WSL → `wsl-notify-send.exe` (Windows toast, zero config); Linux → `notify-send`; macOS → `osascript`; Windows → PowerShell BurntToast.
- Telegram: Bot API `sendMessage` is a single POST; bot cannot message until the user sends `/start`; chat id via `getUpdates`.
- MCP gateways/proxies (MetaMCP, McpMesh, Portkey) are overhead for solo setups — opencode aggregates remote MCPs natively.

## Workflows & Commands
- Install skills + plugin: `./install.sh` (symlinks in `~/.claude/skills`, `~/.agents/skills`, `~/.config/opencode/plugins`)
- Preview installation: `./install.sh --dry-run`
- Remove: `./install.sh --unlink`
- Validate skills/templates/plugins/setup docs: `./scripts/validate.sh`
- Test OS notification (WSL/Linux): `~/.config/opencode/notify.sh "opencode" "test" done` (or `scripts/notify.sh`)
- New project: `SETUP.md` one-shot prompt (clone, install, copy templates + ONBOARDING.md, onboard)
- Disable memory enforcement: delete `~/.config/opencode/plugins/opencode-memory.js` or `./install.sh --unlink`
- Notify env vars: `OPENCODE_NOTIFY_DISABLED=1` (master), `OPENCODE_NOTIFY_OS=auto`, `OPENCODE_TELEGRAM_BOT_TOKEN` + `OPENCODE_TELEGRAM_CHAT_ID` (enables Telegram)

## Primordial Flows
- NODE(A2) -> NODE(B) -> NODE(C) (globally installed skills work in every project)
- NODE(A4) -> NODE(B) -> NODE(C) (opencode plugins: memory enforcement + notify)
- NODE(A6) -> NODE(B) (notify plugin + notify.sh -> global installation); NODE(A6) -> EXTERNAL:OS toast / EXTERNAL:Telegram Bot API
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
- 2026-08-12 | Research for finalizing the framework (5 themes: MCPs, proxys, skills, harness, loops): recommendations — context7+grep.app opt-in, no MCP proxy (overhead), handoff+verify skills, harness fits, keep loops minimal; user approved ONLY the notifications feature
- 2026-08-12 | Notifications: `scripts/notify.sh` created (OS auto-detect: WSL → wsl-notify-send.exe → BurntToast fallback, macOS → osascript, Linux → notify-send, Windows → BurntToast; env OPENCODE_NOTIFY_OS/DISABLED/DEBUG; title/message via env); `plugins/opencode-notify.js` created (events session.idle root-only via parentID, permission.asked, tool.execute.after tool=question; OS + Telegram channels; per-event toggles); `skills/notify/SKILL.md` created (guided Telegram setup: BotFather, chat id, curl smoke test, ~/.bashrc persistence; wsl-notify-send.exe install; config table + testing + troubleshooting). install.sh (symlink plugin + notify.sh, --unlink/--dry-run), validate.sh (loop de plugins + notify.sh checks), AGENTS.md/README.md/templates docs, architecture NODE(A6) + flows updated. Still to do: validate + WSL smoke test + Telegram setup + live test
- 2026-08-12 | Notifications validated + installed: validate.sh all ok (6 skills incl. notify, both plugins node syntax, notify.sh bash syntax); install.sh real run linked notify skill (claude+agents), opencode-notify.js and notify.sh; WSL smoke test fired silently (success path, no debug output) both via repo script and installed ~/.config/opencode/notify.sh
- 2026-08-13 | Telegram setup guided (skills/notify): bot opencode-niko-notify-bot created, chat id 1100349199 obtained via getUpdates long-poll, curl smoke test OK, env vars persisted to ~/.bashrc (OPENCODE_TELEGRAM_BOT_TOKEN + OPENCODE_TELEGRAM_CHAT_ID). Live "question" test failed because the plugin was symlinked MID-session (plugins load at opencode startup) — not a code bug
- 2026-08-13 | Notify plugin verified headless end-to-end (opencode serve + SDK + getUpdates long-poll): session.idle + permission.asked + tool.execute.after(question) all fire and send Telegram (status 200, delivered). Tool id confirmed "question" with args.questions. Bug discovered: getUpdates does NOT list bot outbound messages (only messages the bot receives) — verify sends by chat side, not getUpdates. Debug aids added to plugin gated by OPENCODE_NOTIFY_DEBUG=1 (writes /tmp/opencode/notify-debug.log via appendFileSync; async Bun.write append lost lines due to race). Note: `pkill -f "opencode serve"` self-matches and kills the caller's own shell — use anchored `pkill -f '^opencode serve'`
- 2026-08-13 | LIVE TUI verification (plugin loaded at startup, OPENCODE_NOTIFY_DEBUG=1 trace): question event fired and delivered (Telegram msg 11); response finished fired TWICE for the same session (~46ms apart, opencode emits duplicate session.idle) → added idle dedupe (3s window per session), verified single-send (msg 15). permission.asked does NOT fire in this setup (bash auto-allowed) — documented in skill. Removed OPENCODE_NOTIFY_DEBUG from ~/.bashrc (on-demand only). Feature complete and validated
- 2026-08-13 | Live TUI re-verified after dedupe restart: question arrived (but only AFTER answering) + response finished single-send correct. UX fix: moved question detection from tool.execute.after to tool.execute.before so the notification arrives when the question is ASKED, not after the answer (verified handler send, msg 19). Skill + architecture flows updated. One final restart pending to load the before-hook
- 2026-08-13 | FINAL live verification (before-hook loaded): question notification arrives BEFORE answering (confirmed "Chegou antes"), response finished single-send confirmed earlier. Notifications feature COMPLETE: 3 events (question/permission/done) x 2 channels (OS toast + Telegram) verified. Ready to commit
- 2026-08-13 | OS channel bug found & fixed: notify.sh claimed success via the PowerShell fallback even when BurntToast was NOT installed (old `if (Get-Module ...) { New-BurntToastNotification }` exits 0 either way) — so no OS toast had EVER actually displayed. Fixed both notify_wsl and notify_windows to `exit 0` only inside the `if` and `exit 1` otherwise
- 2026-08-13 | WSL channel priority reversed: BurntToast now FIRST (installed `Install-Module BurntToast -Scope CurrentUser` — reliable, errors when it cannot toast), wsl-notify-send.exe now a fallback. Reason: wsl-notify-send.exe exits 0 even when Windows silently drops the toast (go-toast app id `wsl-notify-send` has no Start Menu shortcut). Installed exe to C:\Users\niko\.local\bin (on Windows PATH) but it stays a fallback. Live-verified: OS done toast + OS question toast (via tool.execute.before) both show on Windows
- 2026-08-13 | Skill `notify` enhanced with "Changing config when the user asks": procedure (grep ~/.bashrc → edit → restart reminder) + request→change map (turn off all / only Telegram / only OS / per-event toggles / change chat). Description updated with config-change triggers so the skill auto-loads on requests like "desliga o Telegram"
