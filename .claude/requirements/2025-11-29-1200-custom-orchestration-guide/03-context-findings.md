# Context Findings

## Existing Documentation Structure

### Current `docs/` Layout
```
docs/
  README.md              # Index/entry point
  agents.md              # Agent roster
  changelog.md           # Version history
  concepts/              # Core mental models (5 files)
    - pipeline-model.md
    - complexity-routing.md
    - memory-systems.md
    - response-awareness.md
    - skills.md
    - self-improvement.md
  pipelines/             # Lane architecture (9 files)
    - nextjs-pipeline.md
    - ios-pipeline.md
    - expo-pipeline.md
    - shopify-pipeline.md
    - etc.
  workflows/             # User-facing guides (2 files)
  reference/             # Technical schemas
    - phase-configs/*.yaml
```

### Key Patterns in Existing Docs

1. **README.md as Index** - Central entry point with quick start, tables linking to sub-docs
2. **Concepts vs Pipelines** - Concepts explain "what/why", Pipelines explain "how" per domain
3. **YAML Phase Configs** - Machine-readable pipeline definitions
4. **Markdown Pipeline Docs** - Human-readable detailed explanations

## Key Components to Document

### 1. Commands (Entry Points)
- Location: `commands/*.md`
- Format: YAML frontmatter + markdown body
- Key fields: `description`, `argument-hint`, `allowed-tools`
- Example: `/orca-nextjs` (596 lines, comprehensive orchestration logic)

### 2. Agents
- Location: `agents/**/*.md`
- Format: YAML frontmatter + markdown body
- Key fields: `name`, `description`, `tools` (comma-separated string - CRITICAL)
- Three types: Orchestrators, Specialists (Builders), Gates
- Example: `nextjs-builder.md` (312 lines)

### 3. Pipelines
- Location: `docs/pipelines/*.md`
- Purpose: Document the complete flow for a domain
- Structure: Overview → Three-Tier Routing → Phase Definitions → Gates → Configuration
- Example: `nextjs-pipeline.md` (957 lines)

### 4. Phase Configs
- Location: `docs/reference/phase-configs/*.yaml`
- Purpose: Machine-readable pipeline definitions
- Structure: `pipeline:` metadata, `phase_state:` schema, `complexity_tiers:`, `phases:`, `gates:`, `config:`
- Example: `nextjs-phase-config.yaml` (347 lines)

### 5. Skills
- Location: `skills/*/SKILL.md`
- Format: YAML frontmatter + markdown body
- Key fields: `name`, `description`
- Types: Universal (wired to all agents) vs Domain-specific
- Example: `cursor-code-style/SKILL.md` (189 lines)

## Architecture Patterns to Document

### Three-Tier Routing
- Default: Light path WITH gates
- Tweak (`-tweak`): Light path WITHOUT gates
- Complex (`--complex`): Full pipeline with spec requirement

### Orchestrator-Specialist-Gate Pattern
```
Orchestrator (coordinates, never edits)
    ↓
Specialists (implement changes)
    ↓
Gates (validate, never fix)
```

### State Preservation
- `phase_state.json` tracks pipeline progress
- Survives interruptions
- Enables resume from any phase

### Memory-First Context
- Check Workshop + vibe.db before ProjectContext
- Reduces expensive MCP calls

## Reference Examples (for "Showcase" Approach)

**Best candidate for walkthrough: Next.js Pipeline**
- Most mature and complete
- Clear three-tier routing
- Multiple specialists
- Multiple gates
- Comprehensive phase config

Components to walk through:
1. Entry: `commands/orca-nextjs.md`
2. Orchestrator: `agents/dev/nextjs-grand-architect.md`
3. Builder: `agents/dev/nextjs-builder.md`
4. Gate: `agents/dev/nextjs-standards-enforcer.md`
5. Pipeline doc: `docs/pipelines/nextjs-pipeline.md`
6. Phase config: `docs/reference/phase-configs/nextjs-phase-config.yaml`

## Gotchas to Document (CRITICAL)

1. **Agent tools format**: MUST be comma-separated string, NOT YAML array
   ```yaml
   # WRONG - causes silent failures
   tools: ["Read", "Edit"]

   # RIGHT
   tools: Read, Edit, MultiEdit, Grep, Glob, Bash
   ```

2. **Model specification**: All agents use Opus 4.5, never specify model line

3. **No root pollution**: All artifacts go in `.claude/`, never project root

4. **Spec gating**: Complex tasks require requirements spec before execution

## Guide Structure Recommendation

Based on discovery answers (beginner audience, modular with "Start Here", reference-first, showcase existing pipeline):

```
docs/guides/
  building-orchestration/
    README.md              # "Start Here" - overview, prereqs, learning path
    01-fundamentals.md     # Claude Code basics for beginners
    02-commands.md         # How to create commands (entry points)
    03-agents.md           # How to create agents (the workers)
    04-skills.md           # How to create skills (knowledge packages)
    05-pipelines.md        # How to wire it all together
    06-phase-configs.md    # Machine-readable pipeline definitions
    07-walkthrough.md      # Step-by-step Next.js pipeline breakdown
    examples/              # Minimal working examples
      simple-pipeline/
      single-agent/
```
