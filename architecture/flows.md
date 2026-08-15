# Flows

> Data flows in chain notation: `NODE(A) -> NODE(B)`. Externals: `EXTERNAL API` / `EXTERNAL:<name>`.

## Main flows

```
NODE(A2) -> NODE(B) -> NODE(C)          # local skills -> global installation -> projects
NODE(A7) -> NODE(B) -> NODE(C)          # dependency repos (plugins + dispatcher + skills) -> global installation -> projects
NODE(A7) -> EXTERNAL:GitHub             # submodule URLs -> standalone repos (source of the deps)
NODE(A1) -> NODE(C)                     # templates -> projects
NODE(A5) -> NODE(C)                     # one-shot setup (SETUP.md + ONBOARDING.md) -> projects
NODE(A3) -> NODE(A2), NODE(A7)          # validate.sh validates the local skills and the dep repos
```

## Memory enforcement (opencode)

```
session.idle -> memory.md exists? -> git status --porcelain -- memory.md -> non-empty? no-op
             -> empty -> client.session.prompt(active-brain-memory) -> model saves -> next idle no-op
```

The opencode plugin (from `NODE(A7)`, repo active-brain-memory) listens for
`session.idle`. If the project has a `memory.md` and it was not touched this
turn, it injects a prompt asking the model to run the active-brain-memory skill
and update `memory.md`. Natural termination: once saved, `git status` shows the
change and the next idle is a no-op. Projects where `memory.md` is gitignored
are skipped (`git check-ignore`), e.g. this repo.

## Notifications (opencode)

```
session.idle (root) | permission.asked | tool.execute.before(tool=question) -> NODE(A7)
NODE(A7) -> notify.sh (OPENCODE_NOTIFY_TITLE/MESSAGE) -> EXTERNAL:OS toast (auto-detect platform)
NODE(A7) -> fetch POST api.telegram.org/bot<TOKEN>/sendMessage -> EXTERNAL:Telegram Bot API (if token+chat id set)
```

The notify plugin (from `NODE(A7)`, repo opencode-notify) listens for three
events: `session.idle` (root sessions only, filtered by `parentID`, deduped
within 3s), `permission.asked`, and the `question` tool (via
`tool.execute.before`, sent when the question is asked). Each event is
independently togglable (`OPENCODE_NOTIFY_ON_*` / `OPENCODE_TELEGRAM_ON_*`);
OS channel routes through `scripts/notify.sh` (auto-detect:
WSL/Windows/Linux/macOS), Telegram is one-way `sendMessage`. Setup is guided
by the `notify` skill (from the opencode-notify repo). Failures are silent.

## Brain loop (in the repo and in client projects)

```
AGENTS.md -> memory.md <-> architecture.md
```

AGENTS.md (always loaded) forces reading memory.md at the start of every session; the active-brain-memory and architecture skills keep the files continuously updated.

## Mermaid (for humans)

```mermaid
flowchart LR
    A[agent-dotfiles] --> A1[templates/]
    A --> A2[skills/]
    A --> A3[scripts/validate.sh]
    A --> A5[SETUP.md]
    A --> A7[deps/: opencode-notify + active-brain-memory]
    A3 --> A2
    A3 --> A7
    A2 --> B[Global install: ~/.claude/skills + ~/.agents/skills]
    A7 --> B
    A7 --> GH[EXTERNAL: GitHub]
    A7 --> OS[EXTERNAL: OS toast]
    A7 --> TG[EXTERNAL: Telegram Bot API]
    A1 --> C[User project]
    A5 --> C
    B --> C
```
