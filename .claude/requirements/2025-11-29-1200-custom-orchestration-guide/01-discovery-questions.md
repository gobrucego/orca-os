# Discovery Questions

## Q1: Should this guide target users who already have Claude Code experience?
- **Default:** Yes
- **Why:** Building custom orchestration is an advanced topic. Users need to understand basic Claude Code concepts (agents, tools, MCP servers) before tackling orchestration patterns.

## Q2: Should the documentation be modular (separate files for agents, pipelines, skills) rather than one monolithic guide?
- **Default:** Yes
- **Why:** Modular docs allow users to reference specific topics without reading everything. Matches existing `docs/` structure. Easier to maintain and update independently.

## Q3: Should the guide include a "Quick Start" example that builds a minimal working orchestration system?
- **Default:** Yes
- **Why:** Concrete examples accelerate learning. A minimal example (1 command, 1 orchestrator, 1 builder, 1 pipeline) demonstrates the pattern without overwhelming detail.

## Q4: Should the guide live in `docs/guides/` as part of the OS 2.4 documentation (vs. a standalone extractable format)?
- **Default:** Yes
- **Why:** Keeping it in `docs/` maintains single source of truth, benefits from existing navigation structure, and stays in sync with the system it documents.

## Q5: Should the guide emphasize the "why" (architecture decisions, tradeoffs) over the "how" (reference syntax)?
- **Default:** Yes (both, but architecture-first)
- **Why:** Understanding *why* patterns exist prevents cargo-culting and enables users to adapt patterns to their needs. Reference syntax is easier to look up; mental models are harder to acquire.
