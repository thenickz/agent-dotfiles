---
name: scaffold-agents-md
description: Bootstraps a project with the agent knowledge system: generates AGENTS.md (from the base template), memory.md, and architecture.md tailored to the codebase. Use when starting a NEW project (after git init), when a project lacks AGENTS.md/memory.md/architecture.md, or when asked to "scaffold", "create the AGENTS.md", "set up the project brain", or "start a new project". Analyzes the codebase (package manager, build/test/lint commands, structure, code style) and fills the template with verified commands.
---

# Scaffold AGENTS.md (+ memory + architecture)

Project bootstrap: creates `AGENTS.md`, `memory.md`, and `architecture.md` tailored to the project, following the 3-layer memory system.

## When to use

- New project (after `git init`).
- Existing project without `AGENTS.md` / `memory.md` / `architecture.md`.
- Reviewing `AGENTS.md` when the project has evolved a lot.

## Steps

1. **Read the base template** at `templates/AGENTS.md` in this skill.
2. **Analyze the project**:
   - Detect runtime/manager: `pyproject.toml` (uv/poetry/pip), `package.json` (npm/pnpm/yarn/bun), `Cargo.toml`, `go.mod`, `Gemfile`, etc.
   - Detect build/test/lint/typecheck commands: scripts in `package.json`, tool configs in `pyproject.toml`, `Makefile`, `.github/workflows`.
   - Detect the test framework (pytest, vitest/jest, cargo test, go test...).
   - Map the folder structure (`src/`, `tests/`, `docs/`...).
   - Capture the code style: read 2-3 representative files + linter/formatter configs.
3. **Fill the template**:
   - Stack with specific versions (never "recent Python").
   - `Commands` EXACT and **VERIFIED**: run each one to confirm; if it fails, adjust until it works.
   - `Code style` with 1-2 examples mined from the repo itself (right/wrong).
   - `Structure`: short folder map.
   - `Boundaries`: generated dirs, migrations, vendored code, dangerous commands.
   - **BRAIN** section pointing to `memory.md` and `architecture.md` (already in the template).
4. **Create `memory.md`** from the structure documented in the active-brain-memory skill, with initial `Current State` and a `Session Log` entry for today's bootstrap.
5. **Create `architecture.md`** (and `architecture/flows.md`) from the architecture skill, with an initial overview and a Node Registry for the components already visible in the code.
6. **Validate**: `AGENTS.md` < 150 lines; run the documented commands; confirm the memory/architecture templates follow the skills' structure.

## Notes

- If this skill's template (`templates/AGENTS.md`) is not available, rebuild the skeleton: Stack, Commands, Code style, Structure, Boundaries, Git workflow, Memory & Architecture (BRAIN), Verification.
- Do not create files that already exist — update what exists and let the user know.
- Ask only the essentials; for the rest, decide based on the code.
