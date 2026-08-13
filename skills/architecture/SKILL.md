---
name: architecture
description: Maintains the project's architecture map (architecture.md plus architecture/ files) using NODE(LETTER) notation for components and chain notation for data flows. Use when a project contains architecture.md or an AGENTS.md brain block: when exploring project structure or data flows, when adding a new component, when integrating with external systems, or when refactoring changes the flow. After updating the map, mirror the Primordial Flows into memory.md.
---

# Architecture

The project keeps `architecture.md` (concentrated record) + `architecture/` (separable details). Your responsibility: keep the map accurate and mirror the primordial flows into `memory.md`.

## Node notation

- Every meaningful component: `NODE(UPPERCASE LETTER)`, e.g., `NODE(A)`.
- Sub-components: `NODE(LETTER+NUMBER)`, e.g., `NODE(A1)`, `NODE(A2)`.
- External systems: `EXTERNAL API` or `EXTERNAL:<name>`.
- The **Node Registry** (in architecture.md) defines every node used in flows. Flows only use registered nodes.

## Flows

- Chain format: `DATABASE -> WORKER -> API -> CORE -> NODE(A) -> UI`.
- Each flow may have a context line (why it exists, failure points).
- Optional: Mermaid block generated from the text (plain text is the source of truth, LLM-parseable; Mermaid is the human view).

## File structure

- `architecture.md` — overview + Node Registry + Primordial Flows + index
- `architecture/flows.md` — data flows in detail
- `architecture/components.md` — per-node detail (optional)

## When to update

- New component, new external integration, refactor that changes a flow, change of a node's responsibility.
- **DURING work**: if the work changes the structure, update right away — don't wait for the end of the session.

## Export to memory

- Keep the `Primordial Flows` section of `memory.md` mirroring the 2-3 core flows of `architecture.md`.
- Whenever `architecture.md` changes, sync that mirror (directly or by triggering the **active-brain-memory** skill).

## Verification

- Every node referenced in flows exists in the Node Registry, and vice versa.
- Node names are `NODE(LETTER)` or `NODE(LETTER+NUMBER)` — nothing outside that format.
