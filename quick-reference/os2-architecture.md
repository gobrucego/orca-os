# OS 2.4 Architecture Quick Reference

**Last Updated:** 2025-11-27
**Version:** OS 2.4

## What's New in OS 2.4

**Three-Tier Routing (NEW):**
-  **Default mode** now runs gates (inverted from OS 2.2)
-  **-tweak flag** for pure speed (skips gates, user verifies)
-  **--complex flag** for full pipeline (requires spec)
-  Light orchestrators handle BOTH default (with gates) AND tweak (no gates)

**Memory Architecture:**
-  **Workshop** → Session memory (decisions, gotchas, learnings)
-  **vibe.db** → Code intelligence (chunks, symbols, hybrid search)
-  **project-meta** → Stable project metadata (MCP with versioning)
-  **ProjectContext v2.3** → Task bundler (queries all sources)
-  Memory-first search (Workshop + vibe.db before ProjectContext)

**From OS 2.2:**
-  Role boundary enforcement layer (orchestrators NEVER write code)
-  State preservation mechanism (phase_state.json)
-  Team confirmation layer (AskUserQuestion before execution)
-  Unified planning command (/plan replaces 8+ commands)
-  Meta-audit system (/audit for behavior review)
-  All agents use Opus 4.5 (unified model)

---

## Three-Tier Routing (OS 2.4)

All `/orca-*` commands support three execution modes:

| Mode | Flag | Path | Gates | Use Case |
|------|------|------|-------|----------|
| **Default** | (none) | Light + Gates | YES | Most work – fast with quality |
| **Tweak** | `-tweak` | Light (pure) | NO | Speed iteration, user verifies |
| **Complex** | `--complex` | Full pipeline | YES | Architecture, multi-file, specs |

### Routing Flow

```
/orca-{domain} "task"
    ↓
[Complexity Detection + Flag Check]
    ↓
 NO FLAG → Default Mode
     ↓
     [Light Orchestrator] → [Builder] → [Gates] → Done

 -tweak FLAG → Tweak Mode
     ↓
     [Light Orchestrator] → [Builder] → Done (no gates)

 --complex FLAG → Complex Mode
      ↓
      [Spec Required] → [Grand Architect] → [Full Pipeline] → Done
```

### Gate Behavior

**Default Mode (most work):**
- Light orchestrator coordinates
- Gates run AFTER implementation
- Domain-specific gates (standards + design/UI review)
- Scores must pass (≥90)

**Tweak Mode (pure speed):**
- Same light orchestrator
- Gates SKIPPED entirely
- User explicitly accepts verification responsibility

**Complex Mode (architecture):**
- Requires spec: `.claude/requirements/<id>/06-requirements-spec.md`
- Grand architect coordinates full pipeline
- All gates run with verification

---

## Core Architecture (OS 2.4)

### Foundation: Context-First Orchestration with Role Boundaries
```
User Request
    ↓
/plan Command (unified planner) [for complex work]
    ↓
    Creates: .claude/requirements/<id>/06-requirements-spec.md
    ↓
/orca-{domain} Command (orchestrator)
    ↓
[Three-Tier Routing] [NEW in 2.3]
     Default → Light + Gates
     -tweak → Light only
     --complex → Full pipeline
    ↓
Memory-First Search (Workshop + vibe.db) [MANDATORY]
    ↓
ProjectContextServer Query [MANDATORY for complex]
    ↓
Team Confirmation (AskUserQuestion) [for complex]
    ↓
Role Boundary Enforcement
    ↓
Pipeline Phases (varies by mode)
    ↓
Quality Gates (≥90 scores) [default and complex only]
    ↓
Output + Learning
    ↓
/audit Command (periodic meta-review)
```

---

## Key Components

### 1. ProjectContextServer (MCP)
- **Purpose:** Mandatory context provider
- **Location:** `~/.claude/mcp/project-context-server/`
- **Features:**
  - Semantic search across project
  - Historical context retrieval (via mcp__project-context__query_context)
  - Standards and decisions database (via save_decision, save_standard)
  - Task history tracking (via save_task_history)
- **Integration:** Required for ALL operations (blocks execution if unavailable)

### 2. Orchestrator Layer (/orca-*)

#### Domain Orchestrators
- **Purpose:** Coordination engines that NEVER write code
- **Domains:** nextjs, ios, expo, data, seo, brand
- **Flow:**
  1. Detect domain from request
  2. Query ProjectContextServer (mandatory)
  3. Confirm team with user (AskUserQuestion - mandatory)
  4. Execute phase pipeline via Task tool
  5. Enforce quality gates
  6. Update memory systems
  7. Preserve state across interruptions

#### Role Boundary Enforcement (NEW in OS 2.2)
```
 CRITICAL: Orchestrators NEVER write code

**What Orchestrators DO:**
- Read phase_state.json
- Coordinate agents via Task tool
- Pass context between phases
- Track progress
- Resume after interruptions

**What Orchestrators NEVER DO:**
- Use Edit/Write tools
- Implement code directly
- Bypass agent system
- Abandon pipeline on interruption

**Anti-Pattern Detection:**
If orchestrator uses Edit/Write → ROLE VIOLATION → Stop immediately
```

### 3. Agent Layer

#### All Agents Use Opus 4.5 (OS 2.4)
```yaml
All Agent Roles:
  - Grand Architects (ios-grand-architect, nextjs-grand-architect, expo-grand-orchestrator)
  - Architects (planning and impact analysis)
  - Builders (implementation)
  - Specialists (domain-specific work)
  - Gates (standards, design QA, verification)

Model: Opus 4.5 (all agents)
Benefit: Consistent quality, no model-selection overhead, unified capability
```

#### Agent Types
```
Builders:
- ios-builder, nextjs-builder, expo-builder
- Implement features, write code
- Receive context from orchestrator

Specialists:
- Domain experts (ios-swiftui-specialist, nextjs-typescript-specialist)
- Handle specific concerns (performance, accessibility, security)
- Called by orchestrator when needed

Gate Enforcers:
- ios-standards-enforcer, nextjs-standards-enforcer
- Numerical scoring (≥90 to pass)
- Block pipeline if quality fails

Verification Agents:
- ios-verification, nextjs-verification-agent, expo-verification-agent
- Build/test/lint verification
- Evidence capture
```

### 4. State Preservation (NEW in OS 2.2)

#### phase_state.json
**Location:** `.claude/orchestration/phase_state.json`

**Structure:**
```json
{
  "current_phase": "phase_4_implementation",
  "completed_phases": ["phase_1_context", "phase_2_team_confirmation", "phase_3_planning"],
  "agent_assignments": {
    "planning": "ios-grand-architect",
    "implementation": "ios-builder",
    "gates": ["ios-standards-enforcer", "ios-ui-reviewer"]
  },
  "gate_results": {
    "standards": 92,
    "ui_review": 88
  },
  "interruption_count": 2,
  "last_updated": "2025-11-24T14:30:00Z"
}
```

**Purpose:**
- Survives user interruptions (questions, clarifications, pauses)
- Allows orchestrator to resume at correct phase
- Prevents pipeline abandonment
- Tracks progress across conversation turns

**Usage:**
Orchestrators read this file after ANY user input to determine where they were and what to do next.

### 5. Team Confirmation (NEW in OS 2.2)

#### AskUserQuestion Integration
Before pipeline execution, orchestrators MUST:
1. Detect domain
2. Propose agent team
3. Present via AskUserQuestion tool
4. Wait for confirmation

**Example Flow:**
```typescript
AskUserQuestion({
  questions: [{
    question: "I detect this as an iOS task. Proposed pipeline:\n\nPhases:\n1. Context (ProjectContext query)\n2. Planning (ios-grand-architect)\n3. Implementation (ios-builder)\n4. Standards Gate (ios-standards-enforcer ≥90)\n5. UI Review Gate (ios-ui-reviewer ≥90)\n6. Verification (ios-verification)\n\nProposed agents: ios-grand-architect, ios-builder, ios-swiftui-specialist, ios-standards-enforcer, ios-ui-reviewer, ios-verification\n\nDoes this look right?",
    header: "Confirm iOS Team",
    multiSelect: false,
    options: [
      {
        label: "Proceed as planned",
        description: "Execute with the proposed iOS pipeline and agent team"
      },
      {
        label: "Adjust team",
        description: "Modify which agents are involved or add specialists"
      },
      {
        label: "Change approach",
        description: "Different pipeline or domain detection"
      }
    ]
  }]
})
```

**Benefits:**
- No surprise agent teams
- User controls scope before work starts
- Clear expectations

### 6. Quality Gates

#### Gate Scoring (OS 2.2)
All gates use numerical scores with ≥90 threshold:

**Standards Gate**
- **Threshold:** 90/100
- **Measures:** Code quality, best practices, patterns
- **Agent:** domain-standards-enforcer
- **Action:** Iterate if <90, block if critical violation

**Design QA Gate** (UI work only)
- **Threshold:** 90/100
- **Measures:** Visual quality, UX, responsiveness
- **Agent:** domain-design-reviewer
- **Action:** Iterate if <90

**Accessibility Gate** (UI work only)
- **Threshold:** 90/100
- **Measures:** WCAG compliance, screen reader support, keyboard nav
- **Agent:** domain-accessibility-specialist
- **Action:** Block if <90 (prevents App Store rejection)

**Performance Gate** (mobile work only)
- **Type:** Budget compliance
- **Measures:** Bundle size, render time, memory usage
- **Agent:** performance-enforcer
- **Action:** Block if exceeds budget

**Build/Test Gate** (all domains)
- **Type:** Hard block
- **Measures:** Compilation success, test pass rate
- **Agent:** domain-verification
- **Action:** Fail pipeline if build/tests fail

### 7. Memory Systems (OS 2.2)

The OS 2.2 memory architecture cleanly separates concerns:

```

                    OS 2.2 MEMORY ARCHITECTURE                    

                                                                  
       
      Workshop             vibe.db          project-meta   
    (Session Mem)       (Code Intel)       (Stable Config) 
       
   • Decisions         • Code chunks       • Project type  
   • Gotchas           • Symbols           • Dependencies  
   • Learnings         • Embeddings        • Design tokens 
   • Task history      • Hybrid search     • Build config  
       
                                                               
                     
                                                                 
                                                                 
                              
                  ProjectContext MCP v2.2                       
                     (Task Bundler)                             
                 Queries ALL sources for                        
                 agent context bundles                          
                              
                                                                  

```

#### Workshop (Session Memory)
- **Type:** Persistent, session/project-scoped
- **Location:** `.claude/memory/workshop.db`
- **Contents:**
  - Decisions with reasoning (`workshop decision`)
  - Gotchas and antipatterns (`workshop gotcha`)
  - Preferences and goals
  - Session summaries
  - Task history
- **Access:** `workshop` CLI or `/project-memory` command
- **Queried by:** ProjectContext MCP (via WorkshopClient)

#### vibe.db (Code Intelligence)
- **Type:** Persistent, project-scoped
- **Location:** `.claude/memory/vibe.db`
- **Contents:**
  - Code chunks (functions, classes, methods)
  - Symbols (extracted function/class names)
  - Embeddings (semantic vectors when enabled)
- **Search:** Hybrid (semantic 40% + symbol 35% + fulltext 25%)
- **Access:** `vibe-sync.py` CLI or `/project-code` command
- **Queried by:** ProjectContext MCP (via CodeSearch)

#### project-meta (Stable Config)
- **Type:** Persistent, rarely-changing
- **Location:** MCP cache (versioned)
- **Contents:**
  - Project type (iOS, Next.js, Expo, etc.)
  - Dependencies and versions
  - Design system tokens
  - Build configuration
- **Features:** Differential updates (20-30% token reduction)
- **Access:** `/project-meta` command or MCP tools

#### ProjectContext MCP v2.2 (Task Bundler)
- **Purpose:** Mandatory context provider for all agents
- **Queries:** Workshop + vibe.db + project state
- **Returns:** ContextBundle with files, decisions, standards, history
- **Access:** `mcp__project-context__query_context`

#### SharedContext (Cross-Session)
- **Type:** Persistent, cross-session caching
- **Location:** `~/.claude/shared-context/`
- **Purpose:** Cache context bundles across sessions
- **Features:** Versioning, differential updates
- **Access:** `mcp__shared-context__*` tools

---

## Directory Structure (OS 2.2)

```
~/.claude/
 agents/                    # OS 2.2 agent definitions (57 total)
    ios/                   # iOS team (18 agents)
    nextjs/                # Next.js team (13 agents)
    expo/                  # Expo team (10 agents)
    data/                  # Data team (4 agents)
    seo/                   # SEO team (4 agents)
    design/                # Design team (2 agents)
 commands/                  # Orchestrator commands
    plan.md                # Unified planner
    audit.md               # Meta-audit
    project-memory.md      # NEW: Workshop interface
    project-code.md        # NEW: vibe.db interface
    project-meta.md        # NEW: project-meta interface
    orca.md                # Main orchestrator
    orca-ios.md            # iOS lane
    orca-nextjs.md         # Next.js lane
    orca-expo.md           # Expo lane
    orca-data.md           # Data lane
 mcp/                       # MCP servers
    project-context-server/ # v2.2 - queries Workshop + vibe.db
    project-meta-server/   # NEW: Stable project metadata
    shared-context/        # Cross-session caching
    sequential-thinking/   # Deep reasoning
 scripts/                   # Helper scripts
    init-memory.sh         # Initialize OS 2.2 memory
    vibe-sync.py           # vibe.db management
 hooks/                     # Session hooks
     session-start.sh       # Load context
     session-end.sh         # Save session summary

<project>/.claude/
 memory/                    # OS 2.2 MEMORY SYSTEM
    workshop.db            # Session memory (decisions, gotchas)
    vibe.db                # Code intelligence (chunks, symbols)
 orchestration/
    phase_state.json       # State preservation
    evidence/              # Final artifacts
    temp/                  # Working files (clean up after session)
 cache/                     # Context caching
    .project-meta-init     # project-meta marker
 requirements/              # Planning outputs
     YYYY-MM-DD-HHMM-<slug>/
         06-requirements-spec.md

claude-vibe-config/            # This repo (mirror/record)
 agents/                    # Agent records
 commands/                  # Command records
 mcp/                       # Custom MCP records
 scripts/                   # Script records
 docs/                      # Documentation
 quick-reference/           # This reference
 .deprecated/               # Archived content
```

---

## Phase Pipeline Pattern (OS 2.4)

### Updated 6-Phase Structure
```yaml
Phase 1: Context Query [MANDATORY]
  agent: ProjectContextServer (MCP)
  purpose: Load project knowledge
  blocks_on_failure: true
  output: context bundle

Phase 2: Team Confirmation [complex mode only]
  tool: AskUserQuestion
  purpose: User approves agent team
  blocks_on_failure: true
  output: confirmed team

Phase 3: Planning
  agent: grand-architect OR architect
  purpose: Architecture decisions, approach selection
  context_required: true
  output: implementation plan

Phase 4: Implementation
  agent: builder
  purpose: Core execution, building, creating
  dependencies: [phase_3]
  output: implemented feature

Phase 5: Quality Gates [skipped in -tweak mode]
  agents: [standards-enforcer, design-reviewer, accessibility-specialist]
  purpose: Standards enforcement, quality validation
  gates:
    - standards: 90
    - design_qa: 90
    - accessibility: 90
  action: iterate if fail, block if critical
  output: gate scores

Phase 6: Verification
  agent: verification-agent
  purpose: Build/test/lint verification
  evidence_required: true
  output: verification evidence
```

**Note:** All agents use Opus 4.5.

---

## Integration Flow (OS 2.2)

### Complete Request Lifecycle
```
User Request: "Add dark mode support"
    ↓
/plan "Add dark mode support"
    ↓
    → 5 discovery questions (AskUserQuestion)
    → ProjectContextServer query
    → 5 detail questions (AskUserQuestion)
    → Response Awareness tagging (#PATH_DECISION, etc.)
    → Blueprint generation
    ↓
    Output: .claude/requirements/2025-11-24-1430-dark-mode/06-requirements-spec.md
    ↓
User: "/nextjs implement requirement 2025-11-24-1430-dark-mode using that spec"
    ↓
/nextjs Command (orchestrator mode)
    ↓
Phase 1: ProjectContextServer Query [MANDATORY]
    ↓
    → Query: "Next.js dark mode implementation, user preferences"
    → Returns: relevant files, past decisions, standards
    ↓
Phase 2: Team Confirmation [MANDATORY, NEW in 2.1]
    ↓
    → AskUserQuestion: "Confirm Next.js team?"
    → Proposed: nextjs-grand-architect, nextjs-builder, nextjs-tailwind-specialist, nextjs-standards-enforcer, nextjs-design-reviewer, nextjs-verification-agent
    → User confirms
    ↓
Phase 3: Planning (via Task tool)
    ↓
    → Orchestrator delegates to nextjs-grand-architect
    → Grand architect reads context, creates implementation plan
    → Updates phase_state.json: {"current_phase": "phase_3_planning", "agent": "nextjs-grand-architect"}
    ↓
[USER INTERRUPTION: "Will this work with Tailwind dark: classes?"]
    ↓
    → Orchestrator reads phase_state.json
    → Sees: Still in orchestrator mode, phase 3 planning
    → Processes question, updates context
    → Delegates back to nextjs-grand-architect with clarification
    → Does NOT start coding directly
    → Does NOT abandon pipeline
    ↓
Phase 4: Implementation (via Task tool)
    ↓
    → Orchestrator delegates to nextjs-builder
    → Builder implements dark mode with Tailwind
    → Updates phase_state.json: {"current_phase": "phase_4_implementation", "agent": "nextjs-builder"}
    ↓
Phase 5: Quality Gates (via Task tool)
    ↓
    → Orchestrator delegates to nextjs-standards-enforcer
    → Result: 92/100 (PASS)
    → Orchestrator delegates to nextjs-design-reviewer
    → Result: 88/100 (FAIL - need ≥90)
    → Orchestrator delegates back to nextjs-builder to fix issues
    → Re-run gate: 91/100 (PASS)
    → Updates phase_state.json: {"gate_results": {"standards": 92, "design": 91}}
    ↓
Phase 6: Verification (via Task tool)
    ↓
    → Orchestrator delegates to nextjs-verification-agent
    → Runs: npm run build && npm run test && npm run lint
    → All pass
    → Evidence captured
    → Updates phase_state.json: {"current_phase": "phase_6_verification", "status": "complete"}
    ↓
Output + Learning
    ↓
    → Feature complete
    → ProjectContext updated (save_task_history)
    → Workshop updated (workshop decision)
    → phase_state.json archived
    ↓
Later: /audit "last 5 tasks"
    ↓
    → Analyzes recent behavior
    → Creates standards from failures
    → Records learnings
    → Output: .claude/orchestration/evidence/audit-<timestamp>.md
```

---

## Role Boundary Enforcement (OS 2.2)

### The Problem (OS 2.0)
```
User: "Add dark mode"
    ↓
/nextjs
    ↓
Planning phase (via agent)
    ↓
[User asks: "Will this work with existing styles?"]
    ↓
 Orchestrator abandons agent system
 Orchestrator starts coding directly
 Entire agentic system bypassed
```

### The Solution (OS 2.2)
```
User: "Add dark mode"
    ↓
/nextjs
    ↓
Planning phase (via agent)
    ↓
[User asks: "Will this work with existing styles?"]
    ↓
 Orchestrator reads phase_state.json
 Orchestrator processes question
 Orchestrator updates context
 Orchestrator delegates to appropriate agent
 Pipeline continues
```

### Enforcement Mechanism
Every orca command includes:
```markdown
##  CRITICAL ROLE BOUNDARY 

**YOU ARE AN ORCHESTRATOR. YOU NEVER WRITE CODE.**

If the user interrupts with questions, clarifications, or test results:
- **REMAIN IN ORCHESTRATOR MODE**
- **DO NOT start writing code yourself**
- **DO NOT bypass the agent system**
- Process the input and **DELEGATE to the appropriate agent via Task tool**
- Update phase_state.json to reflect the new information
- Resume orchestration where you left off

**If you find yourself about to use Edit/Write tools: STOP. You've broken role.**
**Your only job: coordinate agents via Task tool. That's it.**
```

---

## Configuration Files

### Phase Configurations
Location: `~/.claude/docs/reference/phase-configs/`
- `nextjs-phase-config.yaml` (6 phases, role boundaries enforced)
- `ios-phase-config.yaml` (6 phases, role boundaries enforced)
- `expo-phase-config.yaml` (6 phases, role boundaries enforced)
- `data-phases.yaml` (4 phases, role boundaries enforced)
- `seo-phase-config.yaml` (4 phases)

### Pipeline Specifications
Location: `~/.claude/docs/pipelines/`
- `nextjs-pipeline.md` (13-agent team)
- `ios-pipeline.md` (18-agent team)
- `expo-pipeline.md` (10-agent team)
- `data-pipeline.md` (4-agent team)
- `design-pipeline.md` (2-agent team)
- `seo-pipeline.md` (4-agent team)

### MCP Registration
File: `~/.claude.json`
```json
{
  "mcp-servers": {
    "project-context": {
      "path": "~/.claude/mcp/project-context-server/",
      "required": true
    },
    "shared-context": {
      "path": "~/.claude/mcp/shared-context/",
      "required": false
    },
    "sequential-thinking": {
      "path": "~/.claude/mcp/sequential-thinking/",
      "required": false
    }
  }
}
```

---

## Key Principles (OS 2.2)

1. **Context is Mandatory** - No operation without ProjectContextServer query
2. **Team Confirmation is Mandatory** - User approves agents before execution
3. **Role Boundaries are Enforced** - Orchestrators NEVER write code
4. **State Preservation is Automatic** - phase_state.json survives interruptions
5. **Phases are Sequential** - Each builds on previous (except parallel gates)
6. **Quality is Non-Negotiable** - Gates must pass (≥90 scores) except -tweak mode
7. **Memory is Multi-Layered** - Ephemeral (AgentDB), persistent (ProjectContext, Workshop), shared (SharedContext)
8. **All Agents Use Opus 4.5** - Unified model, no cost/quality tradeoffs
9. **Continuous Improvement** - /audit creates standards from failures

---

## OS 2.4 vs OS 2.2

| Feature | OS 2.2 | OS 2.4 |
|---------|--------|--------|
| **Routing** | simple/medium/complex | **default/tweak/complex (three-tier)** |
| **Default Gates** | Skip (light path) | **Run (inverted)** |
| **Speed Mode** | None explicit | **-tweak flag** |
| **Full Pipeline** | Implicit for complex | **--complex flag explicit** |
| Planning | Unified /plan command | Same |
| Meta-Review | /audit command | Same |
| Role Boundaries | Explicit enforcement | Same |
| Team Confirmation | Mandatory AskUserQuestion | Same (complex only in 2.3) |
| State Preservation | phase_state.json | Same |
| Agent Count | 57 | 82 |
| Agent Model | Opus + Sonnet | Opus 4.5 (all) |
| Quality Gates | Numerical scores ≥90 | Same |
| Workflow | /plan → /orca → /audit | /orca (default) or /plan → /orca --complex |

---

_OS 2.4 inverts the default: quality gates now run by default on the light path. Use `-tweak` for pure speed when you'll verify manually. Use `--complex` for architecture work requiring specs and full pipeline coordination._
