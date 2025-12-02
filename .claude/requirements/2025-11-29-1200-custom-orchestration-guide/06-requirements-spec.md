# Requirements Spec: Custom Orchestration Guide

**ID:** custom-orchestration-guide
**Tier:** default
**Domain:** documentation
**Status:** complete
**Created:** 2025-11-29

---

## Problem Statement

Users who want to build custom orchestration systems for Claude Code lack comprehensive documentation on how OS 2.4's components work together. Existing docs are scattered across `docs/concepts/`, `docs/pipelines/`, and agent/skill files, requiring users to piece together the full picture themselves.

## Solution Overview

Create a standalone `guides/` directory at repo root containing a modular, beginner-friendly guide on building custom orchestration workflows. The guide uses iOS pipeline as the showcase example and includes dedicated coverage of MCP/ProjectContext integration.

---

## Functional Requirements

### FR1: Guide Structure
Create `guides/` directory with the following structure:

```
guides/
  README.md                      # "Start Here" - overview, prereqs, learning path
  01-fundamentals.md             # Claude Code basics for beginners
  02-commands.md                 # How to create commands (entry points)
  03-agents.md                   # How to create agents (workers)
  04-skills.md                   # How to create skills (knowledge packages)
  05-pipelines.md                # How to wire everything together
  06-phase-configs.md            # Machine-readable pipeline definitions
  07-mcp-projectcontext.md       # MCP servers and ProjectContext integration
  08-ios-walkthrough.md          # Step-by-step iOS pipeline breakdown
  09-gotchas.md                  # Common mistakes and how to avoid them
```

### FR2: Target Audience
- Beginners to Claude Code
- Include foundational concepts before diving into orchestration
- Assume no prior knowledge of agents, skills, or pipelines
- Do NOT assume familiarity with MCP servers

### FR3: Format/Style
- Reference-first: Lead with formats, options, syntax
- Architecture as supporting context (explain "why" where helpful)
- Modular: Each file stands alone but links to related content
- README.md as "Start Here" that guides reading order

### FR4: iOS Pipeline Walkthrough
Section 08 must walk through the iOS pipeline as a real example:
1. Entry point: `commands/orca-ios.md` structure and logic
2. Orchestrator: `agents/iOS/ios-grand-architect.md` role and tools
3. Builder: `agents/iOS/ios-builder.md` implementation patterns
4. Gate: `agents/iOS/ios-verification.md` validation approach
5. Pipeline doc: `docs/pipelines/ios-pipeline.md` phase flow
6. Phase config: `docs/reference/phase-configs/ios-phase-config.yaml` schema

### FR5: MCP/ProjectContext Coverage
Section 07 must explain:
- What MCP servers are and why they matter
- How ProjectContextServer provides context to agents
- The memory-first pattern (Workshop + vibe.db before ProjectContext)
- How to wire MCP tools in agent definitions

### FR6: Gotchas Section
Section 09 must prominently cover:
1. **Tools format**: Comma-separated string, NOT YAML array
2. **Model specification**: Omit model line (Opus 4.5 is default)
3. **Root pollution**: All artifacts in `.claude/`, never project root
4. **Spec gating**: Complex tasks require requirements spec

---

## Technical Requirements

### TR1: File References
Reference existing OS 2.4 files throughout (no separate minimal examples):
- Link to actual agent files in `agents/`
- Link to actual skill files in `skills/`
- Link to actual command files in `commands/`
- Link to actual pipeline docs in `docs/pipelines/`

### TR2: Cross-Linking
Each guide section must:
- Link to related sections in the guide
- Link to relevant existing docs (e.g., `docs/concepts/pipeline-model.md`)
- Include "See Also" section at bottom

### TR3: Code Examples
Include inline code examples showing:
- YAML frontmatter format for agents
- YAML frontmatter format for commands
- YAML frontmatter format for skills
- Phase config YAML structure

### TR4: Navigation
README.md must include:
- Clear learning path (suggested order)
- Quick links to all sections
- Prerequisites checklist
- "What you'll learn" summary

---

## Acceptance Criteria

1. [ ] `guides/` directory created at repo root
2. [ ] All 9 files created with content
3. [ ] README.md provides clear "Start Here" navigation
4. [ ] iOS walkthrough references actual OS 2.4 files
5. [ ] MCP/ProjectContext explained as standalone topic
6. [ ] Gotchas section covers all 4 critical issues
7. [ ] All sections cross-link appropriately
8. [ ] Beginner-friendly language throughout (no assumed knowledge)
9. [ ] Reference-first style (formats/syntax before theory)

---

## Files to Create

| File | Purpose | Est. Lines |
|------|---------|------------|
| `guides/README.md` | Start Here, navigation, prereqs | 80-100 |
| `guides/01-fundamentals.md` | Claude Code basics | 150-200 |
| `guides/02-commands.md` | Command creation | 200-250 |
| `guides/03-agents.md` | Agent creation | 250-300 |
| `guides/04-skills.md` | Skill creation | 150-200 |
| `guides/05-pipelines.md` | Pipeline architecture | 200-250 |
| `guides/06-phase-configs.md` | Phase config YAML | 150-200 |
| `guides/07-mcp-projectcontext.md` | MCP integration | 200-250 |
| `guides/08-ios-walkthrough.md` | iOS example walkthrough | 300-400 |
| `guides/09-gotchas.md` | Common mistakes | 100-150 |

**Total estimated:** 1,780-2,300 lines across 10 files

---

## Out of Scope

- Minimal working example folder (per user decision)
- Video/interactive tutorials
- Automated testing of guide content
- Translations

---

## Dependencies

- Existing iOS pipeline files must be stable
- Existing docs structure remains unchanged
- No changes to agent/skill/command formats

---

## Next Steps

After approval:
```bash
/orca-os-dev Implement requirement custom-orchestration-guide
```

This will create the `guides/` directory and all content files.
