# Detail Answers

## Q1: Guide Location
**Answer:** Standalone root (`guides/`)

**Implication:** Create `guides/` directory at repo root for easier extraction and sharing. Not nested inside `docs/`.

## Q2: Showcase Pipeline
**Answer:** iOS

**Implication:** Use iOS pipeline as the walkthrough example instead of Next.js. Walk through:
- `commands/orca-ios.md`
- `agents/iOS/ios-grand-architect.md`
- `agents/iOS/ios-builder.md`
- `agents/iOS/ios-verification.md`
- `docs/pipelines/ios-pipeline.md`
- `docs/reference/phase-configs/ios-phase-config.yaml`

## Q3: MCP Coverage
**Answer:** Standalone document in `/guides`

**Implication:** Create a dedicated MCP/ProjectContext guide in the guides folder. Not just a brief mention - a full document explaining how agents get context.

## Q4: Minimal Example
**Answer:** No

**Implication:** Reference existing OS 2.4 files throughout the guide. No separate `examples/` folder with stripped-down versions. Users learn from real, production files.

## Q5: Gotchas Section
**Answer:** Yes (implied from discovery - need prominent coverage)

**Implication:** Include "Common Mistakes / Gotchas" section early in the guide. Cover:
- Tools format (comma-separated, not YAML array)
- Model specification (omit, Opus is default)
- Root pollution (all artifacts in `.claude/`)
- Spec gating (complex tasks need specs)
