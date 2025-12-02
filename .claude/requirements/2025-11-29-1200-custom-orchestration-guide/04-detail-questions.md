# Detail Questions

## Q1: Should the guide location be `docs/guides/building-orchestration/` (within existing docs structure)?
- **Default:** Yes
- **Why:** Keeps documentation consolidated. Follows existing pattern of `docs/concepts/`, `docs/pipelines/`, `docs/workflows/`.

## Q2: For the walkthrough section, should we use Next.js pipeline as the showcase example (vs Shopify or iOS)?
- **Default:** Yes (Next.js)
- **Why:** Next.js pipeline is most mature, has clearest three-tier routing, multiple gates, and comprehensive documentation. Good "reference implementation."

## Q3: Should the fundamentals section cover MCP servers and ProjectContext integration?
- **Default:** Yes (brief overview)
- **Why:** Beginners need to understand where agents get context from. ProjectContextServer is central to OS 2.4. But keep it brief - link to existing memory-systems.md for details.

## Q4: Should we include a "minimal working example" that users can copy and adapt (simple-pipeline folder with 1 command + 1 agent + 1 skill)?
- **Default:** Yes
- **Why:** Learning by example. A small, working pipeline beats pages of theory. Users can start with minimal setup and expand.

## Q5: Should the guide include a "Common Mistakes" / "Gotchas" section prominently (tools format, model line, root pollution)?
- **Default:** Yes (prominent, early in guide)
- **Why:** These cause silent failures. Better to warn upfront than have users debug mysterious agent failures. These are learned rules from actual OS 2.4 development.
