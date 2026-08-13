# Architecture

> System map. Concentrated record; details in separate files under `architecture/`.
> Node notation: `NODE(LETTER)`; sub-nodes `NODE(LETTER+NUMBER)`, e.g., `NODE(A1)`.

## Overview
<2-5 lines: how the system is organized and where data flows>

## Node Registry
| Node | Responsibility | Inputs/Outputs |
|---|---|---|
| NODE(A) | <...> | <...> |
| NODE(A1) | <...> | <...> |

## Primordial Flows
> Core flows that should always be in mind (mirrored in memory.md).
- <DATABASE -> WORKER -> API -> CORE -> NODE(A) -> UI>

## Flows
See `architecture/flows.md` for the flows in detail.

## Index
- `architecture/flows.md` — data flows
- `architecture/components.md` — per-node detail (optional)
