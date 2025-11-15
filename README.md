# Vibe Code — A Constrained, Evidence-Driven OS for Claude

> **An opinionated orchestration framework that transforms Claude Code from a helpful chat into a disciplined engineering system.**

```
┌────────────────────────────────────────────────────────────┐
│                                                            │
│  Beyond "Ask AI" → Systematic Software Development        │
│                                                            │
│  • Memory-First Architecture                              │
│  • Evidence-Based Completion                              │
│  • Design-OCD Quality Gates                               │
│  • Multi-Agent Orchestration with Guardrails              │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## The Problem This Solves

**Generic AI assistants drift.** They say "done" when code doesn't compile, tests fail, and UI is broken. They hallucinate design systems, ignore constraints, and produce janky outputs that require endless iteration loops.

**This framework enforces discipline:**
- Work isn't "done" until there's **evidence** (tests, builds, screenshots, logs)
- Agents operate in **strict lanes** with hard scopes
- **Memory persists** across sessions (no re-explaining decisions)
- **Quality gates** catch issues before humans see them

---

## System Architecture

```
┌────────────────────────────────────────────────────────────┐
│                      VIBE CODE OS                          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐            │
│  │ Commands │    │  Agents  │    │   MCPs   │            │
│  │ (/orca,  │◄───┤Orchestr. ├───►│(Browser, │            │
│  │/response-│    │+ Execute)│    │ Memory,  │            │
│  │  aware)  │    │          │    │DevTools) │            │
│  └────┬─────┘    └────┬─────┘    └────┬─────┘            │
│       │               │               │                   │
│       └───────────────┼───────────────┘                   │
│                       │                                   │
│                       ▼                                   │
│            ┌────────────────────┐                         │
│            │Verification Engine │                         │
│            │ • Meta-tag resolve │                         │
│            │ • Evidence capture │                         │
│            │ • Quality gates    │                         │
│            └─────────┬──────────┘                         │
│                      │                                    │
│                      ▼                                    │
│            ┌────────────────────┐                         │
│            │   Memory Layer     │                         │
│            │ • Project decisions│                         │
│            │ • Design DNA       │                         │
│            │ • Learned patterns │                         │
│            └────────────────────┘                         │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## Request Flow: From Idea to Verified Implementation

```
      ┌────────────────────┐
      │  Human Request     │  "Add dark mode to dashboard"
      └─────────┬──────────┘
                │
                ▼
┌────────────────────────────────────────────────────────────┐
│ PHASE 1: CONTEXT LOADING                                  │
│ ┌────────┐    ┌────────┐    ┌────────┐                   │
│ │ Memory │───►│Design  │───►│Project │                   │
│ │ Search │    │  DNA   │    │CLAUDE  │                   │
│ └────────┘    └────────┘    └────────┘                   │
└────────────────────────────────────────────────────────────┘
                │
                ▼
┌────────────────────────────────────────────────────────────┐
│ PHASE 2: ORCHESTRATION                                    │
│ ┌────────┐                                                │
│ │ /orca  │  • Detect stack (Next.js, iOS, etc.)          │
│ │/resp-  │  • Propose specialist team                    │
│ │ aware  │  • Get user confirmation                      │
│ └────────┘                                                │
└────────────────────────────────────────────────────────────┘
                │
                ▼
┌────────────────────────────────────────────────────────────┐
│ PHASE 3: PLANNING (Parallel)                              │
│ ┌──────┐      ┌──────┐      ┌──────┐                     │
│ │Design│      │Archit│      │Strat.│                     │
│ │Plans │      │Plans │      │Plans │                     │
│ └───┬──┘      └───┬──┘      └───┬──┘                     │
│     └─────────────┼─────────────┘                         │
│                   ▼                                        │
│        ┌──────────────────┐                               │
│        │ Synthesis Agent  │                               │
│        │ • Resolve issues │                               │
│        │ • Create plan    │                               │
│        │ • Tag uncertain  │                               │
│        └──────────────────┘                               │
└────────────────────────────────────────────────────────────┘
                │
                ▼
┌────────────────────────────────────────────────────────────┐
│ PHASE 4: IMPLEMENTATION                                   │
│ ┌──────┐      ┌──────┐      ┌──────┐                     │
│ │Front-│      │Back- │      │Tests │                     │
│ │ end  │      │ end  │      │Agent │                     │
│ └───┬──┘      └───┬──┘      └───┬──┘                     │
│     │             │             │                         │
│     │   Tag assumptions & file operations                 │
│     │   #FILE_CREATED, #COMPLETION_DRIVE                  │
│     └─────────────┼──────────────┘                        │
└───────────────────┼─────────────────────────────────────────┘
                │
                ▼
┌────────────────────────────────────────────────────────────┐
│ PHASE 5: VERIFICATION                                     │
│ ┌──────────────────────────────────────────────────────┐  │
│ │ Verification Agent                                   │  │
│ │ • Resolve ALL meta-tags                              │  │
│ │ • Run tests       → Capture output                   │  │
│ │ • Run build       → Capture logs                     │  │
│ │ • Screenshots     → Visual evidence                  │  │
│ │ • Check memory    → No orphaned claims               │  │
│ └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
                │
                ▼
┌────────────────────────────────────────────────────────────┐
│ PHASE 6: QUALITY GATES                                    │
│ ┌──────────────────────────────────────────────────────┐  │
│ │ Design Review (if UI changed)                        │  │
│ │ • Grid compliance (4px system)                       │  │
│ │ • Token-based styling (no magic numbers)             │  │
│ │ • Accessibility audit                                │  │
│ │ • Interaction states (hover, focus, active)          │  │
│ └──────────────────────────────────────────────────────┘  │
│ ┌──────────────────────────────────────────────────────┐  │
│ │ Content Awareness (if copy changed)                  │  │
│ │ • Matches brand voice                                │  │
│ │ • Audience-appropriate                               │  │
│ │ • Purpose-aligned                                    │  │
│ └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
                │
                ▼
      ┌────────────────────┐
      │      DONE          │  Evidence attached
      │   + EVIDENCE       │  Memory updated
      └────────────────────┘
```

---

## Memory Architecture: Workshop + vibe-memory MCP

**Every project gets its own persistent memory using SQLite + FTS5 full-text search.**

### What It Is

The memory system combines two components:
1. **Workshop CLI** — SQLite database with FTS5 search for project knowledge
2. **vibe-memory MCP** — Exposes `memory.search` tool to Claude via Model Context Protocol

**Key Design:** Each project maintains its own memory database at `.claude/memory/workshop.db`

### Actual Setup (Step-by-Step)

**1. Install Workshop CLI:**
```bash
cargo install workshop-cli
# or download binary from https://github.com/zachswift615/workshop
```

**2. Initialize project memory:**
```bash
cd your-project
workshop init                           # Creates .workshop/workshop.db
mkdir -p .claude/memory
mv .workshop/workshop.db .claude/memory/workshop.db
rmdir .workshop
```

**3. Configure vibe-memory MCP in `~/.claude.json`:**

**CRITICAL:** Per-project MCPs go in `~/.claude.json` under `projects`, NOT in `.claude/mcp.json` files.

```json
{
  "mcpServers": {
    "playwright": { },
    "chrome-devtools": { }
  },
  "projects": {
    "/absolute/path/to/your-project": {
      "mcpServers": {
        "vibe-memory": {
          "command": "python3",
          "args": ["/Users/you/.claude/mcp/vibe-memory/memory_server.py"],
          "env": { "PYTHONUNBUFFERED": "1" }
        }
      }
    }
  }
}
```

**4. MCP server location (global, shared across projects):**
```
~/.claude/mcp/vibe-memory/memory_server.py
```

### How It Works (Request Flow)

```
User asks: "What CSS approach did we decide on?"
    ↓
Claude calls: memory.search("CSS patterns")
    ↓
vibe-memory MCP server receives request via stdio (JSON-RPC 2.0)
    ↓
Server searches .claude/memory/workshop.db using:
  - Vector search (semantic, if sentence-transformers installed)
  - FTS5 full-text search (BM25 ranking, always available)
    ↓
Returns results: "Use global CSS with design tokens, not Tailwind"
    ↓
Claude uses context in response
```

### Directory Structure

**Per-project:**
```
your-project/
├── .claude/
│   ├── memory/
│   │   ├── workshop.db              ← SQLite database (FTS5)
│   │   └── playbooks/               ← ACE learning patterns
│   ├── orchestration/
│   │   ├── evidence/                ← Screenshots, logs
│   │   ├── temp/                    ← Working files (delete after session)
│   │   └── reference/               ← Key docs
│   └── hooks/
│       └── session-start.sh         ← Auto-loads memory context
├── CLAUDE.md                        ← Project-specific instructions
└── (source code...)
```

**Global:**
```
~/.claude/
├── mcp/vibe-memory/memory_server.py  ← MCP server (shared)
├── commands/                          ← Slash commands (/orca, etc.)
├── agents/                            ← Agent definitions
└── CLAUDE.md                          ← Global instructions
```

### Usage (Workshop CLI)

**Record knowledge:**
```bash
workshop decision "Use Supabase for auth" -r "Self-hosted requirement"
workshop gotcha "iOS Simulator needs Xcode 15.4+ on macOS 15"
workshop goal "Add dark mode support" -p high
workshop antipattern "Don't use inline styles" -r "Use design system classes"
```

**Search memory:**
```bash
# Via CLI
workshop search "CSS patterns"

# In Claude (automatic when MCP configured)
# Claude calls memory.search tool automatically
```

**View context:**
```bash
workshop context          # Recent context (loaded at session start)
workshop read decisions   # All decisions
workshop read gotchas     # All gotchas
```

### Path Resolution Priority

The vibe-memory MCP automatically finds your database by checking (in order):
1. `$WORKSHOP_DB` environment variable
2. `$WORKSHOP_ROOT/.claude/memory/workshop.db`
3. Walk up from CWD: `.claude/memory/workshop.db` ← **Primary location**
4. Walk up from CWD: `.claude-work/memory/workshop.db` ← Legacy fallback
5. Walk up from CWD: `.workshop/workshop.db` ← Legacy fallback
6. Fallback: `CWD/.claude/memory/workshop.db`

**Result:** Automatically finds database in consolidated `.claude/memory/` location.

### Why Per-Project Memory?

- **Isolation** — Each project's memory is independent
- **Performance** — Uses local machine (no cloud latency)
- **Privacy** — Memory stays on your machine, never sent to cloud
- **Portability** — Database travels with project (commit it or not, your choice)
- **Scale** — No shared global database bottleneck

### Migration from Legacy Structure

Use `/cleanup` command to auto-consolidate old folders:

```bash
/cleanup
```

Moves:
- `.claude-work/memory/workshop.db` → `.claude/memory/workshop.db`
- `.orchestration/` → `.claude/orchestration/`
- `.workshop/workshop.db` → `.claude/memory/workshop.db`

---

## Agent Hierarchy: Orchestrators vs Specialists

```
┌────────────────────────────────────────────────────────────┐
│                     ORCHESTRATORS                          │
│ (Own planning, synthesis, and decision-making)             │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  /orca                      /response-aware                │
│  ┌──────────────┐       ┌──────────────┐                   │
│  │ • Stack      │       │ • 6-phase    │                   │
│  │   detect     │       │   flow       │                   │
│  │ • Team       │       │ • Meta-tags  │                   │
│  │   proposal   │       │ • Evidence   │                   │
│  │ • User       │       │   req'd      │                   │
│  │   confirm    │       │ • Quality    │                   │
│  │ • Parallel   │       │   gates      │                   │
│  │   exec       │       │ • Final      │                   │
│  │ • Chaos      │       │   synthesis  │                   │
│  │   prevent    │       │              │                   │
│  └──────────────┘       └──────────────┘                   │
│         │                       │                          │
│         └───────────┬───────────┘                          │
│                     │                                      │
│                     ▼                                      │
└────────────────────────────────────────────────────────────┘
                       │
                       │ Dispatches →
                       │
┌────────────────────────────────────────────────────────────┐
│                      SPECIALISTS                           │
│ (Narrow scopes, strict inputs, explicit limits)            │
├────────────────────────────────────────────────────────────┤
│                                                            │
│ Planning Layer                                             │
│ ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
│ │ system-  │  │ require- │  │  plan-   │                   │
│ │architect │  │ analyst  │  │synthesis │                   │
│ └──────────┘  └──────────┘  └──────────┘                   │
│                                                            │
│ Design Layer                                               │
│ ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
│ │ design-  │  │creative- │  │   ux-    │                   │
│ │ director │  │strategist│  │strategist│                   │
│ └──────────┘  └──────────┘  └──────────┘                   │
│                                                            │
│ Implementation Layer                                       │
│ ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
│ │frontend- │  │ backend- │  │   ui-    │                   │
│ │(Next.js) │  │(Node,Go) │  │ engineer │                   │
│ └──────────┘  └──────────┘  └──────────┘                   │
│                                                            │
│ Quality Layer                                              │
│ ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
│ │  test-   │  │ design-  │  │ verify-  │                   │
│ │ engineer │  │ reviewer │  │  agent   │                   │
│ └──────────┘  └──────────┘  └──────────┘                   │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

**Pattern that works:**
1. **Narrow role** — One job, clearly defined
2. **Mandatory context recall** — Always load memory + design DNA first
3. **Thinking scaffold** — Fixed reasoning structure (FRAME → STRUCTURE → SURFACE)
4. **Hard rules** — Type scales, spacing tokens, banned patterns
5. **Structured output** — Blueprint templates, not freeform

**Pattern that failed:**
- Broad "design" agents that tried to do everything → drift and hallucination

---

## Evidence-Based Completion: Meta-Tags + Verification

### The Problem: False Completion

```
❌ OLD APPROACH:
   Agent: "I've added dark mode support."
   Reality: Code doesn't compile, tests fail, UI is broken
```

### The Solution: Meta-Tag System

```
✅ NEW APPROACH:

Implementation Agent:
┌────────────────────────────────────────────────────────────┐
│ Created components/DarkModeToggle.tsx                      │
│ #FILE_CREATED: components/DarkModeToggle.tsx               │
│ #COMPLETION_DRIVE: Assuming CSS vars exist                 │
│ #SCREENSHOT_CLAIMED: .orchestration/evidence/ui.png        │
└────────────────────────────────────────────────────────────┘

Verification Agent:
┌────────────────────────────────────────────────────────────┐
│ Resolving tags...                                          │
│                                                            │
│ ✓ #FILE_CREATED → ls confirms exists                       │
│ ✓ #COMPLETION_DRIVE → grep found CSS vars                  │
│ ✓ #SCREENSHOT_CLAIMED → screenshot captured                │
│ ✓ Build → npm run build (success)                          │
│ ✓ Tests → npm test (12/12 passed)                          │
│                                                            │
│ Evidence attached:                                         │
│ - Build logs: .orchestration/logs/build.log                │
│ - Test output: .orchestration/logs/test.log                │
│ - Screenshot: .orchestration/evidence/ui.png               │
└────────────────────────────────────────────────────────────┘

Result: VERIFIED COMPLETE (with proof)
```

**Core Tags:**
- `#FILE_CREATED`, `#FILE_MODIFIED`, `#FILE_DELETED` → File operations
- `#COMPLETION_DRIVE` → Assumptions that need verification
- `#SCREENSHOT_CLAIMED` → Visual evidence needed
- `#PATH_DECISION` → Architectural choices
- `#PLAN_UNCERTAINTY` → Needs clarification

**Verification Requirements:**
- All tags must be resolved
- Evidence must be captured (not claimed)
- No work is "done" until verification passes

---

## Design-OCD Quality Gates

### Visual Precision is Non-Negotiable

```
┌────────────────────────────────────────────────────────────┐
│ DESIGN REVIEW CHECKLIST (Automatic)                        │
├────────────────────────────────────────────────────────────┤
│                                                            │
│ Grid Compliance                                            │
│ ┌──────────────────────────────────────────────────┐       │
│ │ ✓ All spacing uses 4px/8px/16px/24px/32px       │        │
│ │   progression                                    │       │
│ │ ✓ No arbitrary margins (e.g., margin: 13px ❌)   │        │
│ │ ✓ Container widths from design system scale      │       │
│ └──────────────────────────────────────────────────┘       │
│                                                            │
│ Token-Based Styling                                        │
│ ┌──────────────────────────────────────────────────┐       │
│ │ ✓ All colors from design tokens (no #HEX)        │       │
│ │ ✓ Typography uses scale (no arbitrary font-size) │       │
│ │ ✓ No inline styles (className only)              │       │
│ └──────────────────────────────────────────────────┘       │
│                                                            │
│ Interaction States                                         │
│ ┌──────────────────────────────────────────────────┐       │
│ │ ✓ Hover states defined                           │       │
│ │ ✓ Focus states (keyboard navigation)             │       │
│ │ ✓ Active/pressed states                          │       │
│ │ ✓ Disabled states                                │       │
│ └──────────────────────────────────────────────────┘       │
│                                                            │
│ Accessibility                                              │
│ ┌──────────────────────────────────────────────────┐       │
│ │ ✓ ARIA labels on interactive elements            │       │
│ │ ✓ Semantic HTML (not div soup)                   │       │
│ │ ✓ Keyboard navigable                             │       │
│ │ ✓ Color contrast meets WCAG AA                   │       │
│ └──────────────────────────────────────────────────┘       │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

**Philosophy:**
- Visual bugs are as critical as functional bugs
- Design review is MANDATORY, not optional
- Optical alignment > geometric alignment
- Calculate, don't guess

---

## MCP Integrations: Structured I/O, Not Magic

```
┌────────────────────────────────────────────────────────────┐
│                      MCP SERVERS                           │
├────────────────────────────────────────────────────────────┤
│                                                            │
│ vibe-memory (Local Custom)                                 │
│ ┌──────────────────────────────────────────────────┐       │
│ │ Path: ~/.claude/mcp/vibe-memory/                 │       │
│ │ Tools:                                           │       │
│ │  • memory.search (semantic + FTS)                │       │
│ │  • Auto-loads project decisions, gotchas, goals  │       │
│ │ Used by: All orchestrators and specialists       │       │
│ └──────────────────────────────────────────────────┘       │
│                                                            │
│ playwright (External)                                      │
│ ┌──────────────────────────────────────────────────┐       │
│ │ Purpose: End-to-end browser automation           │       │
│ │ Tools:                                           │       │
│ │  • navigate, click, fill, screenshot, video      │       │
│ │  • Network/console capture for evidence          │       │
│ │ Used by: design-reviewer, verification-agent     │       │
│ └──────────────────────────────────────────────────┘       │
│                                                            │
│ chrome-devtools (External)                                 │
│ ┌──────────────────────────────────────────────────┐       │
│ │ Purpose: Live page inspection                    │       │
│ │ Tools:                                           │       │
│ │  • DOM inspection, network, console logs         │       │
│ │ Used by: design-reviewer, ui-testing-expert      │       │
│ └──────────────────────────────────────────────────┘       │
│                                                            │
│ XcodeBuildMCP (External)                                   │
│ ┌──────────────────────────────────────────────────┐       │
│ │ Purpose: iOS/macOS development automation        │       │
│ │ Tools:                                           │       │
│ │  • Build, test, run, deploy to simulators/devices│       │
│ │ Used by: ios-specialists, swiftui-developer      │       │
│ └──────────────────────────────────────────────────┘       │
│                                                            │
│ context7 (External)                                        │
│ ┌──────────────────────────────────────────────────┐       │
│ │ Purpose: Library docs and code search            │       │
│ │ Tools:                                           │       │
│ │  • resolve-library-id, get-library-docs          │       │
│ │ Used by: All implementation agents               │       │
│ └──────────────────────────────────────────────────┘       │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

**Key Principle:** All I/O goes through declared tools. Agents can only use MCPs specified in their `allowed-tools` — this acts as a hard permission boundary.

---

## File Organization: Chaos Prevention

```
project-root/
├── .claude/
│   ├── memory/
│   │   └── workshop.db              ← Per-project knowledge graph
│   ├── orchestration/
│   │   ├── evidence/                ← FINAL artifacts (screenshots, reports)
│   │   ├── temp/                    ← Working files (DELETE after session)
│   │   ├── playbooks/               ← Reference patterns
│   │   └── reference/               ← Key docs
│   └── hooks/
│       └── session-start.sh         ← Auto-loads context at session start
│
├── CLAUDE.md                        ← Project-specific instructions
└── (source code...)

~/.claude/ (Global OS)
├── commands/                        ← Live slash commands
│   ├── orca.md
│   ├── response-aware.md
│   ├── creative-strategist.md
│   └── ...
├── agents/                          ← Custom agent definitions
│   ├── orchestration/
│   ├── specialists/
│   └── ...
├── mcp/
│   └── vibe-memory/                 ← Custom MCP server
├── hooks/
│   └── session-start.sh             ← Global session hook
└── CLAUDE.md                        ← Global instructions
```

**Chaos Prevention Rules:**
1. **File limits** — Max files per agent, per session
2. **Standard paths** — Evidence, logs, temp all in `.claude/orchestration/`
3. **Meta-tags required** — `#FILE_CREATED`, `#FILE_MODIFIED`, `#FILE_DELETED`
4. **No planning doc explosion** — No `PLAN.md`, `TODO.md`, etc.
5. **Cleanup enforcement** — `/cleanup` command consolidates legacy folders

---

## Project-Specific Frontend Agents & Commands

This repo defines a **meta frontend agent pair** and three **project-specific pairs** that follow the same pattern:

- Concept agents → Design-only, blueprint/spec output, no file edits.
- Builder agents → Implementation-only, read-before-write, minimal-safe changes.
- Commands → Project entrypoints that:
  - Load design DNA + system rules.
  - Route to Concept or Builder mode via flags.
  - Save/load specs under `.orchestration/specs/`.

### Meta Frontend Agents (Blueprint Layer)

- `agents/frontend-concept-agent.md`
  - Generic methodology for UI concept work: design-system-first → multi-concept exploration → implementation handoff.
  - Stays stack-agnostic and brand-agnostic; talks in tokens, components, and flows, not code.

- `agents/frontend-builder-agent.md`
  - Generic implementation loop: understand → small plan → read-before-write → minimal edits → lint/tests → design compliance.
  - Assumes a Next.js + TypeScript + Tailwind/shadcn-like stack, but is intended as a base template.

Each project-specific pair **inherits the behavior pattern from these**, then hard-codes brand DNA, precedents, and anti-patterns.

### Marina Moscone (MM) – `/mm`

**Design DNA Source**
- External MM design-dna folder (brand system + agent guides).
- Repo-level DNA:
  - `docs/design/design-dna/design-dna.json`
  - `docs/design/design-system-guide.md`

**Agents**
- Concept:
  - `agents/project-specific/mm-concept-agent.md`
  - Role:
    - Quiet-luxury editorial designer.
    - Mandatory context recall (Avenir, tonal neutrals, Atmospheric vs Reporting spacing).
    - Uses MM scaffold: FRAME → STRUCTURE → SURFACE → CALCULATE → CHECK ANTI-PATTERNS.
    - Enforces **precedent-driven design**:
      - NEVER/ALWAYS patterns for heroes, product listing/detail, navigation/footer, product cards, buttons/forms.
      - Generic pattern detector (centered hero + buttons, 3-column rows, SaaS card grids, etc.).
    - Outputs an **MM DESIGN BLUEPRINT** with explicit spacing math and an `IMPLEMENTATION HANDOFF FOR MM BUILDER` section.

- Builder:
  - `agents/project-specific/mm-builder-agent.md`
  - Role:
    - Implementation agent for MM’s web app.
    - Summarizes MM design DNA at the top of each task.
    - Implements from specs, mapping each change to:
      - Tokens (colors, spacing, type).
      - Named MM precedents (Editorial Opener, Editorial Product Card, Atmospheric vs Reporting layouts).
    - Includes a required **Token & Pattern Mapping** section per task.
    - Enforces generic-guard rails (no SaaS hero, no default grids) and stops once request is satisfied.

**Command**
- `commands/project-specific/mm.md`
  - `/mm --concept <task>`:
    - Mode: CONCEPT.
    - Loads MM design-dna and `mm-concept-agent`.
    - Produces multi-concept spec and saves it under `.orchestration/specs/…`.
  - `/mm --build <task>`:
    - Mode: BUILD.
    - Loads `mm-builder-agent`.
    - Optionally loads a saved spec via “Using spec from …”.
    - Implements minimal compliant changes, then summarizes files touched.

### PeptideFox – `/fox`

**Design DNA Source**
- `/Users/adilkalam/Desktop/peptidefox/design-dna/`:
  - `design-system-v7.0.md`
  - `DESIGN_RULES_v7.0.md`
  - `peptidefox_designer_prompt.md` (legacy design prompt).

**Agents**
- Concept:
  - `agents/project-specific/fox-concept-agent.md`
  - Role:
    - PeptideFox Scientific Premium Minimalism™ designer.
    - Mandatory context recall: Clean Future Blue, Lavender haze, Brown LL / Brown Mono / Brown Inline, tool vs library vs education modes.
    - Enforces a **Generic Pattern Guard** (no generic SaaS hero, 3-col features, card grids, etc.).
    - Uses FRAME → STRUCTURE → SURFACE → CALCULATE → PRECEDENT CHECK.
    - Defines NEVER/ALWAYS precedents for:
      - Tools/calculators (tiered layout: context → inputs → primary result → explanation → detail).
      - Library views (peptide cards as scientific catalog, not generic tiles).
      - Protocol/education views (structured “what/why/how” blocks).
      - Peptide cards (Brown Inline for peptide names, identity vs data zones).
    - Outputs **PEPTIDEFOX DESIGN BLUEPRINT** + `IMPLEMENTATION HANDOFF FOR FOX BUILDER`.

- Builder:
  - `agents/project-specific/fox-builder-agent.md`
  - Role:
    - Implementation agent for `/Users/adilkalam/Desktop/peptidefox`.
    - Summarizes design-dna v7.0; enforces:
      - Tokens for Light/Dark, Blue/Lavender roles, spacing.
      - Typography roles (Brown LL, Brown Mono, Brown Inline rules).
    - Uses a core loop: understand → small plan → read → minimal edit → lint/tests → design compliance.
    - Requires **Token & Pattern Mapping** for non-trivial changes (tokens, spacing, type roles, structural patterns).

**Command**
- `commands/project-specific/fox.md`
  - `/fox --concept <task>`:
    - Mode: CONCEPT.
    - Loads PeptideFox design-dna + `fox-concept-agent`.
    - Saves spec to `.orchestration/specs/…` with a Fox blueprint and handoff.
  - `/fox --build <task>`:
    - Mode: BUILD.
    - Loads `fox-builder-agent`.
    - Optional spec-loading if arguments reference “Using spec from …”.

### OBDN – `/obdn`

**Design DNA Source**
- `/Users/adilkalam/Desktop/OBDN/obdn_site/design-system/`:
  - `design-dna-v2.0.md`
  - `system_rules-v2.0.md`
  - `design-system-v2.0.md`
  - `obdn_designer_prompt.md` (legacy prompt).

**Agents**
- Concept:
  - `agents/project-specific/obdn-concept-agent.md`
  - Role:
    - Luxury alchemical system designer (Obsidian + Gold + White).
    - Mandatory context recall: materials, type stack (Domaine/Pantheon/Supreme/Unica), spacing tokens, bento zones, dark-mode-first.
    - Uses FRAME → STRUCTURE → SURFACE → GOLD → CALCULATE → PRECEDENT CHECK.
    - Enforces NEVER/ALWAYS precedents for:
      - Product/stack presentations (bento card sets, not generic feature grids).
      - Editorial/education screens (Domaine + Pantheon editorial hierarchy, gold bullets, spacing).
      - Bento cards (zones 1–6 with fixed heights and flexing bodies).
    - Outputs an **OBDN DESIGN BLUEPRINT** + `IMPLEMENTATION HANDOFF FOR OBDN BUILDER`.

- Builder:
  - `agents/project-specific/obdn-builder-agent.md`
  - Role:
    - Implementation agent for `/Users/adilkalam/Desktop/OBDN/obdn_site`.
    - Summarizes OBDN design-dna/system rules before changes.
    - Enforces:
      - Material tokens (Obsidian, Gold, White, minimal semantics).
      - Type roles (Domaine/Pantheon/Supreme/Unica).
      - Spacing tokens and bento alignment.
    - Uses a standard builder loop + required **Token & Pattern Mapping** section.

**Command**
- `commands/project-specific/obdn.md`
  - `/obdn --concept <task>`:
    - Mode: CONCEPT.
    - Loads OBDN design-dna + `obdn-concept-agent`.
    - Produces and saves an OBDN blueprint spec under `.orchestration/specs/…`.
  - `/obdn --build <task>`:
    - Mode: BUILD.
    - Loads `obdn-builder-agent`.
    - Optionally loads a blueprint via “Using spec from …”.

### Example Flows

- Full MM design → build:
  - `/mm Product listing page`  
  - Then: `/mm --build Using spec from .orchestration/specs/2025...-product-listing.md`

- PeptideFox tool from scratch:
  - `/fox --concept New metabolic protocol calculator`  
  - Then: `/fox --build Using spec from .orchestration/specs/2025...-protocol-calculator.md`

- OBDN bento screen refactor:
  - `/obdn --concept Refine [screen] into full bento layout`  
  - Then: `/obdn --build Using spec from .orchestration/specs/2025...-bento-screen.md`

Each of these flows guarantees:
- Design work runs through a brand-specific Concept agent with precedents and genericness checks.
- Implementation runs through a brand-specific Builder agent that:
  - Reads before it writes.
  - Enforces tokens and spacing.
  - Maps changes back to the design system explicitly.

---

## Usage Recipes

### Full End-to-End Implementation with Verification

```bash
/response-aware "Add dark mode to dashboard"
```

**What happens:**
1. Loads memory (prior decisions about theming)
2. Loads design DNA (color tokens, spacing)
3. Plans implementation (parallel planners)
4. Synthesizes single blueprint
5. Implements (with meta-tags)
6. Verifies (resolves all tags, captures evidence)
7. Runs quality gates (design review, tests)
8. Returns with evidence attached

---

### Plan-Only Mode (Review Before Implementation)

```bash
/response-aware -plan "iOS to React migration"
```

**What happens:**
1. Survey phase (map domains, interfaces)
2. Parallel planning (multiple approaches)
3. Synthesis (single blueprint with risks)
4. User approval required
5. Stops (no implementation yet)

**Then implement from blueprint:**

```bash
/response-aware -build path/to/blueprint.md
```

---

### Design a New Layout

```bash
/design-director "product detail page layout"
```

**What happens:**
1. Loads design DNA (typography, spacing, grid)
2. Applies thinking scaffold (FRAME → STRUCTURE → SURFACE)
3. Produces blueprint with:
   - Mathematical spacing calculations
   - Component hierarchy
   - Token-based styling specs
   - No code (blueprint-first)

---

### Strategic Analysis with Performance Data

```bash
/creative-strategist "<paste performance data + ads>"
```

**What happens:**
1. Analyzes creative signals (copy, visuals, CTAs)
2. Maps to performance metrics
3. Identifies patterns (what worked, what didn't)
4. Provides recommendations grounded in data
5. No implementation (strategy only)

---

### Multi-Agent Orchestration with Stack Detection

```bash
/orca "Implement user authentication"
```

**What happens:**
1. Detects stack (inspects package.json, files)
2. Proposes specialist team (architect, backend, frontend, test)
3. Shows team to user via interactive confirmation
4. Dispatches agents in parallel (with file limits)
5. Synthesis agent resolves conflicts
6. Verification agent proves completion

---

## Design Principles

### 1. Blueprint-First, Code-Second

For UI and complex systems, always design the blueprint (structure, spacing, tokens) before writing code. Prevents hallucinated design systems and janky layouts.

### 2. Evidence-Based "Done"

Work is complete only when tags are resolved and evidence is captured: tests, builds, screenshots, logs. No more "it works" without proof.

### 3. Narrow Agents with Hard Scopes

Each agent has a single job, strict inputs, and explicit non-responsibilities. Generic agents drift; narrow agents behave.

### 4. Memory as Ground Truth

Decisions live in Workshop (via `vibe-memory` MCP), not ephemeral chat. Design DNA lives in versioned design system docs.

### 5. Parallel Planning, Centralized Decisions

Many agents can explore paths, but one orchestrator decides and enforces. Prevents chaos.

### 6. Calculate, Don't Guess

Spacing, typography, layout all follow mathematical systems. No arbitrary values, no eyeballed alignment.

---

## Token Efficiency Through Discipline

**Why this is more efficient than generic chat:**

1. **Less context repetition**
   - Decisions stored in memory (query once, not re-explain)
   - Design DNA loaded automatically (not pasted into chat)

2. **Fewer iteration loops**
   - Verification catches issues before human review
   - Quality gates prevent janky outputs
   - Blueprint-first prevents "rebuild it properly" cycles

3. **Smaller, reusable prompts**
   - Specialist agents < 3KB each (not one giant persona)
   - Orchestrators dispatch narrow agents (not doing everything)

4. **Bounded parallelism**
   - File limits prevent runaway planning docs
   - Meta-tags track actual work (not phantom claims)

---

## Getting Started

### 1. Install Workshop CLI

```bash
cargo install workshop-cli
# or download binary from https://github.com/zachswift615/workshop
```

### 2. Initialize Project Memory

```bash
cd your-project
workshop init
mkdir -p .claude/memory
mv .workshop/workshop.db .claude/memory/workshop.db
```

### 3. Configure vibe-memory MCP

Add to `~/.claude.json`:

```json
{
  "projects": {
    "/absolute/path/to/your-project": {
      "mcpServers": {
        "vibe-memory": {
          "command": "python3",
          "args": ["/path/to/.claude/mcp/vibe-memory/memory_server.py"],
          "env": { "PYTHONUNBUFFERED": "1" }
        }
      }
    }
  }
}
```

### 4. Add Project Instructions

Create `CLAUDE.md` in project root with project-specific constraints, design system, and preferences.

### 5. Start Using Commands

```bash
# Full implementation with verification
/response-aware "Your feature request"

# Multi-agent orchestration
/orca "Your complex task"

# Design-only
/design-director "Your layout request"

# Strategy analysis
/creative-strategist "Your data + context"
```

---

## Documentation Structure

```
/
├── README.md                        ← You are here
├── quick-reference/
│   ├── memory-explainer.md          ← Memory system deep dive
│   ├── agents-teams.md              ← Agent hierarchy and scopes
│   ├── verification.md              ← Meta-tag system and quality gates
│   ├── commands.md                  ← Slash command reference
│   └── visual-design.md             ← Design-OCD principles
├── commands/                        ← Slash command definitions
├── agents/                          ← Agent definitions
├── mcp/                             ← Custom MCP servers
└── scripts/                         ← Helper scripts
```

---

## Philosophy: Why This Exists

**Generic AI assistants are helpful but undisciplined.** They drift from requirements, hallucinate constraints, and say "done" when reality disagrees.

**This framework treats Claude Code as an operating system:**
- Commands are **system calls** (orchestrators)
- Agents are **processes** (constrained, observable)
- MCPs are **I/O interfaces** (structured, permission-bounded)
- Memory is **persistent state** (queryable knowledge graph)
- Verification is **syscall validation** (evidence required)

**The result:** A disciplined, evidence-driven development system that produces reliable outputs and learns from failures.

---

## License

MIT

---

## Contributing

This is a personal framework, but the patterns are generalizable. If you build on this:
- Share agent definitions and orchestration patterns
- Document what works (and what failed)
- Contribute to Workshop CLI and vibe-memory MCP

---

**Build right first. Verify with evidence. Learn from memory.**
