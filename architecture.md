# Architecture

> System map of agent-dotfiles. Concentrated record; details in `architecture/`.
> Notation: `NODE(LETTER)`, sub-nodes `NODE(LETTER+NUMBER)`. Externals: `EXTERNAL API` / `EXTERNAL:<name>`.

## Overview

AI agent dotfiles repo: copyable templates for new projects + portable skills installed via symlinks. The system uses a "brain loop": AGENTS.md (always loaded) points to memory.md (persistent state) ⇄ architecture.md (map and flows), both maintained by the skills.

## Node Registry

| Node | Responsibility | Inputs/Outputs |
|---|---|---|
| NODE(A) | agent-dotfiles repo (source of everything) | -> NODE(A1), NODE(A2), NODE(A3), NODE(A4), NODE(A5), NODE(A6) |
| NODE(A1) | templates/ (files to copy into projects: AGENTS.md, ONBOARDING.md) | NODE(A) -> NODE(A1) -> NODE(C) |
| NODE(A2) | skills/ (portable SKILL.md) | NODE(A) -> NODE(A2) -> NODE(B) |
| NODE(A3) | scripts/ (validate.sh, notify.sh dispatcher) | NODE(A) -> NODE(A3) -> NODE(A2), NODE(A4) |
| NODE(A4) | plugins/ (opencode-memory.js + opencode-notify.js) | NODE(A) -> NODE(A4) -> NODE(B) |
| NODE(A5) | SETUP.md + templates/ONBOARDING.md (one-shot LLM bootstrap) | NODE(A) -> NODE(A5) -> NODE(C) |
| NODE(A6) | notifications (opencode-notify.js + notify.sh + skills/notify) | NODE(A) -> NODE(A6) -> NODE(B); NODE(A6) -> EXTERNAL:OS toast, EXTERNAL:Telegram Bot API |
| NODE(B) | Global installation (`~/.claude/skills`, `~/.agents/skills`, `~/.config/opencode/plugins`, `~/.config/opencode/notify.sh`) | NODE(A2), NODE(A4), NODE(A6) -> NODE(B) -> NODE(C) |
| NODE(C) | User project (client of the system) | NODE(A1), NODE(B) -> NODE(C) |

## Primordial Flows

- `NODE(A2) -> NODE(B) -> NODE(C)` — globally installed skills work in every project
- `NODE(A4) -> NODE(B) -> NODE(C)` — opencode plugins enforce memory.md updates and notify in every project
- `NODE(A1) -> NODE(C)` — templates copied manually, via scaffold, or via the one-shot setup
- `AGENTS.md -> memory.md <-> architecture.md` — brain loop (in the repo and in client projects)

## Flows

See `architecture/flows.md` for the flows in detail.

## Index

- `architecture/flows.md` — data flows and mermaid
