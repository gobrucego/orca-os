```
 __   __  _  _            ___   ___     ___    ____
 \ \ / / (_)| |__   ___  / _ \ / __|   |_  )  |__ /
  \ V /  | || '_ \ / -_)| (_) |\__ \    / /    |_ \
   \_/   |_||_.__/ \___| \___/ |___/   /___|  |___/

```

# A Context-Aware, Memory-Persistent OS for Claude Code

```
+------------------------------------------------------------------+
|                                                                  |
|   Make Claude Code remember, stay disciplined, and finish work   |
|                                                                  |
|   - Memory-first architecture (local vectors + Workshop)         |
|   - Response awareness (track assumptions, not just outputs)     |
|   - Evidence-based completion (tests pass or it is not done)     |
|   - Multi-lane orchestration (7 domains, 62 agents)              |
|   - Complexity routing (simple tweaks to complex features)       |
|                                                                  |
+------------------------------------------------------------------+
```

---

## The Problem This Solves

**Claude Code is powerful. But it forgets everything and declares victory prematurely.**

Without guardrails:

- "Done" when the code does not compile
- "Done" when tests are failing
- "Done" when the UI is visually broken
- Context re-gathered every single session
- Orchestration abandoned when you ask a question
- Design systems hallucinated instead of followed

The result: endless iteration loops, human frustration, and outputs that do not meet spec.

**This system enforces discipline:**

- Projects indexed locally with persistent vectors for fast semantic queries
- An orchestration layer that coordinates specialists but never writes code itself
- Agents operating in strict lanes with hard-scoped responsibilities
- Memory persisting across sessions (no re-explaining decisions)
- Quality gates catching issues before humans see them
- Work not marked complete until evidence exists (tests, builds, screenshots)

---

## System Architecture

```
+-----------------------------------------------------------------------+
|                           VIBE OS 2.3                                 |
+-----------------------------------------------------------------------+
|                                                                       |
|  FOUNDATION: LOCAL MEMORY (runs on your machine)                      |
|  +-------------------------------------------------------------------+|
|  |                                                                   ||
|  |  Workshop (.claude/memory/)       vibe.db (SQLite)                ||
|  |  - Decisions with reasoning       - Pre-chunked code + symbols    ||
|  |  - Gotchas and antipatterns       - Hybrid search:                ||
|  |  - Standards from failures          symbol + fulltext + semantic  ||
|  |  - Session hooks load on start    - Embeddings optional (Ollama)  ||
|  |                                                                   ||
|  +-------------------------------------------------------------------+|
|                                  |                                    |
|                    local queries | (no model calls yet)               |
|                                  v                                    |
|  CONTEXT LAYER (local MCP)                                            |
|  +-------------------------------------------------------------------+|
|  |  ProjectContextServer                                             ||
|  |  - Runs locally, does heavy lifting before anything hits model    ||
|  |  - Searches repo, stitches decisions/standards from vibe.db       ||
|  |  - Returns ContextBundle: relevant files + past decisions         ||
|  +-------------------------------------------------------------------+|
|                                  |                                    |
|                   context bundle | (now model receives it)            |
|                                  v                                    |
|  AGENT LAYER                                                          |
|  +-------------------------------------------------------------------+|
|  |                                                                   ||
|  |  Grand Architects             Specialists                         ||
|  |  - Coordinate pipelines       - ios-swiftui-specialist            ||
|  |  - Never write code           - nextjs-tailwind-specialist        ||
|  |  - Delegate via Task tool     - shopify-liquid-specialist         ||
|  |                               - 62 total across 7 domains         ||
|  |                                                                   ||
|  +-------------------------------------------------------------------+|
|                                  |                                    |
|                         outputs  |                                    |
|                                  v                                    |
|  VALIDATION LAYER                                                     |
|  +-------------------------------------------------------------------+|
|  |  Quality Gates                                                    ||
|  |  - Standards enforcement (>= 90)                                  ||
|  |  - Design QA (>= 90)                                              ||
|  |  - Build verification                                             ||
|  |  - Test execution                                                 ||
|  +-------------------------------------------------------------------+|
|                                  |                                    |
|                        evidence  |                                    |
|                                  v                                    |
|  USER INTERFACE                                                       |
|  +-------------------------------------------------------------------+|
|  |  /plan        /orca-ios      /orca-nextjs     /audit              ||
|  |  /orca-expo   /orca-shopify  /root-cause      -tweak  --audit     ||
|  +-------------------------------------------------------------------+|
|                                                                       |
+-----------------------------------------------------------------------+
```

**Reading order:** Memory is the foundation. Context aggregates memory. Agents receive context. Gates validate outputs. Commands are the entry points users interact with.

---

## How It Works

### Plan First, Execute Second

1. **`/plan`** gathers requirements through structured questions
2. Creates a spec file with Response Awareness tags
3. Spec includes architecture decisions that should not be re-decided

### Execute via Domain Orchestrator

1. **`/orca`** auto-detects stack and routes to the right lane
2. Or call directly: `/orca-ios`, `/orca-nextjs`, `/orca-expo`, `/orca-shopify`
3. Orchestrator classifies complexity (simple/medium/complex)
4. Delegates to specialists via Task tool (never writes code itself)
5. Quality gates validate work before marking complete
6. Memory systems updated with learnings

### Complexity Determines Path

- **Simple** - Light orchestrator, single specialist, skip gates
- **Medium** - Full pipeline, spec recommended
- **Complex** - Full pipeline, spec REQUIRED

Use `-tweak` flag to force the fast path:
```
/orca-ios -tweak "fix button padding"
```

Use `--audit` flag for review without changes:
```
/orca-ios --audit
```

---

## Memory Architecture

Every `/orca-*` call leans on your local CPU/disk instead of asking the model to re-scan files from scratch.

```
+-----------------------------------------------------------------------+
|                    LOCAL-FIRST MEMORY                                 |
+-----------------------------------------------------------------------+
|                                                                       |
|   1. Workshop (.claude/memory/workshop.db)                            |
|   +-------------------------------------------------------------------+
|   |  - Decisions with reasoning (the "why")                          ||
|   |  - Gotchas and antipatterns                                      ||
|   |  - Standards codified from failures                              ||
|   |  - Session hooks auto-load on start                              ||
|   +-------------------------------------------------------------------+
|                                                                       |
|   2. vibe.db (.claude/memory/vibe.db)                                 |
|   +-------------------------------------------------------------------+
|   |  - Pre-chunked code and symbols                                  ||
|   |  - Hybrid search (hsearch):                                      ||
|   |      Symbol search: "where is createUser defined?"               ||
|   |      Full-text search: "where does checkout appear?"             ||
|   |      Semantic search: "code about auth" (if embeddings on)       ||
|   +-------------------------------------------------------------------+
|                                                                       |
|   3. ProjectContextServer (local MCP)                                 |
|   +-------------------------------------------------------------------+
|   |  - Runs on your machine                                          ||
|   |  - When /orca-* calls query_context, heavy lifting happens       ||
|   |    entirely locally before anything hits the model               ||
|   |  - Returns ContextBundle: relevant files + past decisions        ||
|   +-------------------------------------------------------------------+
|                                                                       |
+-----------------------------------------------------------------------+
```

**Ollama embeddings (optional turbo):**

If you want better semantic search:
```bash
ollama serve
ollama pull nomic-embed-text
/project-code sync --embeddings
```

This means:
- Code gets embeddings once during sync
- Queries use vector similarity to find relevant code by meaning, not just text
- Local GPU/CPU does the vector math; the model sees fewer, more relevant files
- Instead of "read 50 files and hope," ProjectContext asks the embedding index for the 10 most meaningful files

---

## Orchestration Flow

```
User Request: "Add haptic feedback to save button"
          |
          v
+---------------------------+
| /orca-ios                 |
| (entry point)             |
+------------+--------------+
             |
             v
+---------------------------+
| Phase 0: Memory-First     |
| workshop why "haptics"    |
| vibe search "haptic"      |
+------------+--------------+
             |
             v
+---------------------------+
| Phase 0.5: Classify       |
| Complexity                |
+------------+--------------+
             |
   +---------+---------+
   |                   |
   v                   v
SIMPLE             MEDIUM/COMPLEX
   |                   |
   v                   v
+-------------+   +---------------------------+
| Light Orch  |   | Phase 1: Team Confirm     |
| Skip gates  |   | AskUserQuestion           |
| Direct impl |   +------------+--------------+
+------+------+                |
       |                       v
       |        +---------------------------+
       |        | Phase 2: ProjectContext   |
       |        | Query (full bundle)       |
       |        +------------+--------------+
       |                     |
       |                     v
       |        +---------------------------+
       |        | Phase 3: Grand Architect  |
       |        | Planning + coordination   |
       |        +------------+--------------+
       |                     |
       |                     v
       |        +---------------------------+
       |        | Phase 4: Specialists      |
       |        | Implementation            |
       |        +------------+--------------+
       |                     |
       |                     v
       |        +---------------------------+
       |        | Phase 5: Quality Gates    |
       |        | Standards >= 90           |
       |        | Build/Test pass           |
       |        +------------+--------------+
       |                     |
       v                     v
+---------------------------+
| Phase 6: Completion       |
| Save task history         |
| Update Workshop           |
+---------------------------+
```

**Key insight:** Grand Architects coordinate. Specialists implement. Gates validate. No role crosses its boundary.

---

## Example: iOS Workflow with --audit

```
User: /orca-ios --audit

          |
          v
+---------------------------+
| Parse Arguments           |
| Detect: --audit flag      |
+------------+--------------+
             |
             v
+---------------------------+
| Phase 0: Memory-First     |
| Load recent decisions     |
| Load project state        |
+------------+--------------+
             |
             v
+---------------------------+
| Phase 0.5: AUDIT MODE     |
| (no implementation)       |
+------------+--------------+
             |
             v
+---------------------------+
| Clarify Focus             |
| AskUserQuestion:          |
| - Architecture review?    |
| - Performance audit?      |
| - Accessibility check?    |
| - Security review?        |
| - Full codebase audit?    |
+------------+--------------+
             |
             v (user selects: "Performance audit")
+---------------------------+
| Assemble Audit Squad      |
| - ios-architect (scan)    |
| - ios-performance-spec    |
| - ios-testing-specialist  |
+------------+--------------+
             |
             v
+---------------------------+
| Parallel Analysis         |
+---------------------------+
|                           |
|  +---------------------+  |
|  | ios-architect       |  |
|  | Read, Glob, Grep    |  |
|  | NO Edit/Write       |  |
|  +---------------------+  |
|                           |
|  +---------------------+  |
|  | ios-performance     |  |
|  | Analyze patterns    |  |
|  | Identify issues     |  |
|  +---------------------+  |
|                           |
|  +---------------------+  |
|  | ios-testing         |  |
|  | Review test gaps    |  |
|  | Coverage analysis   |  |
|  +---------------------+  |
|                           |
+------------+--------------+
             |
             v
+---------------------------+
| Synthesize Findings       |
| Produce Audit Report      |
+---------------------------+
|                           |
|  AUDIT REPORT             |
|  -------------------------+
|  Domain: iOS              |
|  Focus: Performance       |
|                           |
|  Findings:                |
|  1. MainActor blocking    |
|     in DataService.swift  |
|  2. Uncached images in    |
|     ProductCell.swift     |
|  3. N+1 query pattern in  |
|     OrderListView.swift   |
|                           |
|  Recommendations:         |
|  - Move DataService to    |
|    background actor       |
|  - Add AsyncImage with    |
|    caching layer          |
|  - Batch fetch orders     |
|                           |
|  Suggested Follow-ups:    |
|  /orca-ios "Fix MainActor |
|   blocking in DataService"|
|                           |
+---------------------------+
             |
             v
+---------------------------+
| Save to Workshop          |
| Log as audit task         |
| NO code changes made      |
+---------------------------+
```

**Audit mode enforces:**
- Agents use Read, Glob, Grep only
- No Edit, Write, or MultiEdit allowed
- Analysis produces report, not changes
- Follow-up tasks suggested for user to execute

---

## Key Design Decisions

### 1. Deep Roster of Specialists Over General Agents

**Problem:** Broad "frontend agent" or "mobile agent" drifts and hallucinates.

**Solution:** 62 agents with narrow scopes:
- `ios-swiftui-specialist` knows SwiftUI patterns deeply
- `ios-uikit-specialist` handles UIKit separately
- `nextjs-tailwind-specialist` focuses on Tailwind
- `shopify-liquid-specialist` handles only Liquid templates

**Result:** Each agent has hard boundaries. When scope creeps, task is re-routed to appropriate specialist.

### 2. Simplified Memory Architecture

**Problem:** Complex memory systems with multiple layers create confusion and maintenance burden.

**Solution:** Two systems only:
- **Workshop** - Human decisions (the "why", stored in SQLite)
- **vibe.db** - Code intelligence (symbols, chunks, hybrid search)

**Result:** Fast queries, local-first, clear separation between human knowledge and code knowledge.

### 3. Lane-Specific Orchestration Commands

**Problem:** Generic `/orca` command tries to do everything, context gets confused.

**Solution:** Explicit lane commands:
```
/orca-ios        # iOS specialists
/orca-nextjs     # Next.js specialists
/orca-expo       # Expo specialists
/orca-shopify    # Shopify specialists
```

**Result:** Domain context loaded immediately. No stack detection errors. Right agents every time.

### 4. Complexity Routing with Flags

**Problem:** Simple tweaks go through full pipeline (slow). Complex tasks skip planning (broken).

**Solution:** Three-tier routing:
- SIMPLE: Light orchestrator, skip gates
- MEDIUM: Full pipeline, spec recommended
- COMPLEX: Full pipeline, spec REQUIRED (blocked without it)

Plus explicit flags:
- `-tweak` forces light path
- `--audit` forces review-only mode

**Result:** Right amount of overhead for each task type.

### 5. Role Boundaries at Command Top

**Problem:** Orchestrators start coding when user asks questions. Pipeline abandoned.

**Solution:** Every orchestrator command includes at top:
```
If about to use Edit/Write --> VIOLATION. Delegate instead.
```

Orchestrators read phase_state.json, process user input, then delegate. Never code directly.

**Result:** Pipelines survive interruptions. Questions get answered without abandoning coordination.

### 6. Local-First Search (Embeddings Optional)

**Problem:** External APIs cost money, add latency, require network. But semantic search helps find relevant code.

**Solution:** vibe.db does hybrid search locally:
- Symbol search works immediately (no setup)
- Full-text search works immediately (no setup)
- Semantic search available if you enable Ollama embeddings

Optional turbo (for semantic search):
```bash
ollama serve && ollama pull nomic-embed-text
/project-code sync --embeddings
```

**Result:**
- Works offline by default
- Sub-100ms queries
- Embeddings optional, not required

### 7. Numerical Quality Gates

**Problem:** Pass/fail gates provide no gradient. "Almost passing" same as "terrible."

**Solution:** All gates produce numerical scores:
- Standards: 0-100 (threshold: 90)
- Design QA: 0-100 (threshold: 90)
- Accessibility: 0-100 (threshold: 90)

**Result:** Scores show improvement. 87 to 92 is visible progress. Gates explain deductions.

---

## Agent Roster

```
+-----------------------------------------------------------------------+
|                        62 AGENTS ACROSS 7 DOMAINS                     |
+-----------------------------------------------------------------------+
|                                                                       |
|  iOS Lane (19 agents)                                                 |
|  +---------------------+  +---------------------+                     |
|  | Coordination        |  | Specialists         |                     |
|  | - grand-architect   |  | - swiftui-spec      |                     |
|  | - light-orchestrator|  | - uikit-spec        |                     |
|  | - architect         |  | - accessibility     |                     |
|  | - builder           |  | - performance       |                     |
|  +---------------------+  | - persistence       |                     |
|                           | - networking        |                     |
|  +---------------------+  | - security          |                     |
|  | Gates               |  | - testing           |                     |
|  | - standards-enforcer|  | - ui-testing        |                     |
|  | - verification      |  | - spm-config        |                     |
|  | - ui-reviewer       |  | - fastlane          |                     |
|  | - design-dna-guard  |  +---------------------+                     |
|  +---------------------+                                              |
|                                                                       |
|  Next.js Lane (14 agents)                                             |
|  - grand-architect, light-orchestrator, architect, builder            |
|  - typescript-spec, tailwind-spec, layout-spec, layout-analyzer       |
|  - performance-spec, accessibility-spec, seo-spec                     |
|  - standards-enforcer, verification-agent, design-reviewer            |
|                                                                       |
|  Expo Lane (10 agents)                                                |
|  - grand-orchestrator, light-orchestrator, architect, builder         |
|  - aesthetics-spec, api-guardian, bundle-assassin                     |
|  - impact-analyzer, refactor-surgeon, test-generator                  |
|                                                                       |
|  Shopify Lane (7 agents)                                              |
|  - grand-architect, light-orchestrator                                |
|  - css-spec, liquid-spec, section-builder, js-spec                    |
|  - theme-checker                                                      |
|                                                                       |
|  Data Lane (4 agents)                                                 |
|  - python-analytics, data-researcher, research-spec, competitive      |
|                                                                       |
|  SEO Lane (4 agents)                                                  |
|  - research-spec, brief-strategist, draft-writer, quality-guardian    |
|                                                                       |
|  Cross-Cutting (6 agents)                                             |
|  - a11y-enforcer, performance-enforcer, performance-prophet           |
|  - security-specialist, design-token-guardian, design-system-architect|
|                                                                       |
+-----------------------------------------------------------------------+
```

---

## Commands Reference

```
+-----------------------------------------------------------------------+
|                           COMMANDS                                    |
+-----------------------------------------------------------------------+
|                                                                       |
|  PLANNING                                                             |
|  /plan "description"         Create requirements spec                 |
|                              Asks discovery questions                 |
|                              Produces: requirements/<id>/spec.md      |
|                                                                       |
|  EXECUTION                                                            |
|  /orca "task"                Auto-detect domain, execute pipeline     |
|  /orca-ios "task"            iOS lane (19 agents)                     |
|  /orca-nextjs "task"         Next.js lane (14 agents)                 |
|  /orca-expo "task"           Expo lane (10 agents)                    |
|  /orca-shopify "task"        Shopify lane (7 agents)                  |
|                                                                       |
|  FLAGS                                                                |
|  -tweak                      Force light path (simple tasks)          |
|  --audit                     Review only (no changes)                 |
|                                                                       |
|  EXAMPLES                                                             |
|  /orca-ios -tweak "fix padding"      Quick fix, skip gates            |
|  /orca-ios --audit                   Deep review, suggest fixes       |
|  /orca-nextjs "add dark mode"        Full pipeline with gates         |
|                                                                       |
|  RETROSPECTIVE                                                        |
|  /audit "last 10 tasks"      Review behavior, create standards        |
|  /root-cause "error msg"     Diagnose failures before fixing          |
|                                                                       |
|  MEMORY                                                               |
|  workshop why "topic"        Query past decisions                     |
|  workshop recent             Recent activity                          |
|  workshop decision "x" -r "reason"   Record decision                  |
|                                                                       |
+-----------------------------------------------------------------------+
```

---

## Getting Started

```bash
# 1. Plan complex work
/plan "Add user authentication with OAuth"

# 2. Execute via domain orchestrator
/orca "Implement the auth requirement"

# 3. Quick fixes bypass overhead
/orca-ios -tweak "fix button color"

# 4. Review without changes
/orca-nextjs --audit

# 5. Learn from failures
/audit "last 5 tasks"
```

---

## File Structure

```
project/
  .claude/
    memory/
      workshop.db        # Decisions, gotchas, standards
      vibe.db            # Vectors, symbols, code index
    orchestration/
      phase_state.json   # Pipeline state (survives interruptions)
      evidence/          # Final artifacts
      temp/              # Working files (clean up after session)
  requirements/          # /plan outputs
    <timestamp>-<slug>/
      06-requirements-spec.md
  CLAUDE.md              # Project-specific instructions
```

---

## License

MIT

---

**Plan. Execute. Learn. Repeat.**
