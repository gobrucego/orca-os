---
description: "OS 2.3 orchestrator entrypoint for native iOS tasks"
argument-hint: "[-tweak] <task description or requirement ID>"
allowed-tools:
  - Task
  - AskUserQuestion
  - mcp__project-context__query_context
  - mcp__project-context__save_decision
  - mcp__project-context__save_task_history
  - Read
  - Bash
  - Grep
  - Glob
---

# /orca-ios – iOS Lane Orchestrator (OS 2.3)

Use this command for native iOS work (Swift/SwiftUI/UIKit, Xcode, device features).

## Usage

```bash
/orca-ios "add haptic feedback to save button"       # Auto-routes based on complexity
/orca-ios -tweak "fix button padding"                # Force light path
/orca-ios "implement requirement 2025-11-25-0930-workspace-sharing"  # Full path with spec
```

## 🚨 CRITICAL ROLE BOUNDARY 🚨

**YOU ARE AN ORCHESTRATOR. YOU NEVER WRITE CODE.**

- **DO NOT** use Edit/Write tools
- **DO NOT** bypass the agent system
- **DELEGATE** via Task tool only
- Update phase_state.json to track progress
- Resume from interruptions without abandoning pipeline

---

## 0. Parse Arguments & Detect Mode

**Check for `-tweak` flag:**
```
$ARGUMENTS contains "-tweak" → FORCE light path (skip to Section 2)
```

**Check for requirement ID:**
```
$ARGUMENTS matches "requirement <id>" or "<YYYY-MM-DD-HHMM-*>"
  → Look for requirements/<id>/06-requirements-spec.md
  → If found, this is a SPEC-DRIVEN task (see Section 1.3)
```

**Check for `--audit` / audit mode:**
```
$ARGUMENTS contains "--audit"
  OR starts with "audit" / "review"
  → Enter Deep Audit Mode (skip normal planning/implementation flow)
```

If `--audit` is present, run the Deep Audit flow in Section 0.5 and then
return a report instead of implementing changes.

---

## 0.5 Deep Audit Mode (Optional)

Use this mode when you want a **deep review/audit** of the existing iOS
codebase, not implementation:

- Architecture consistency
- Concurrency and safety
- Design DNA & UI/UX quality
- Performance/security/accessibility risks

**IMPORTANT:** Audit mode MUST NOT modify code. It only analyzes and
reports.

When `--audit` is detected:

1. **Clarify focus**
   - Use `AskUserQuestion` to ask what to prioritize:
     - Architecture & standards
     - UI/UX & design tokens
     - Concurrency & safety
     - Performance
     - Security & privacy
     - Accessibility

2. **Memory & ProjectContext**
   - Run memory-first search (Workshop + unified memory) for:
     - Past iOS incidents, RA tags, and standards.
   - Call `mcp__project-context__query_context` with a diagnostic task:
     - `domain: "ios"`
     - `task`: "Deep iOS codebase audit"
     - `maxFiles`: larger than usual (e.g. 30–50)
     - `includeHistory: true`

3. **Assemble an audit squad (via Task)**
   - Based on focus, delegate to relevant agents:
     - Standards/architecture:
       - `ios-standards-enforcer`
     - UI/UX & tokens:
       - `ios-ui-reviewer`
       - `design-dna-guardian`
     - Concurrency/safety:
       - `ios-performance-specialist`
       - `ios-security-specialist`
     - Accessibility:
       - `ios-accessibility-specialist`
     - Testing:
       - `ios-testing-specialist`
       - `ios-ui-testing-specialist`

   - In prompts, make it explicit that:
     - They are in **audit** mode.
     - They should use `Read`/`Grep`/`Glob` (+ ProjectContext) to inspect
       code and tests, not rely on `files_modified`.
     - They MUST NOT edit code; only analyze and report.

4. **Synthesize an iOS Audit Report**
   - Combine findings into a single report:
     - Architecture & standards issues
     - Concurrency/safety concerns
     - UI/UX & design DNA issues
     - Performance/security/accessibility gaps
     - Suggested follow-up tasks (each can become `/plan` + `/orca-ios` work).

5. **(Optional) Save audit history**
   - Use `mcp__project-context__save_task_history` with:
     - `domain: "ios"`
     - `task`: "audit: ios codebase"
     - `outcome`: `"diagnosed"` or `"reviewed"`
     - `learnings`: key bullets from the audit

Return this report to the user and **do not** proceed into the normal
implementation pipeline unless explicitly requested.

---

## 1. Memory-First Context & Complexity Classification

### 1.1 Memory Search (Before ProjectContext)

Before expensive ProjectContext queries, check local memory:

```bash
# Search Workshop for relevant iOS decisions/gotchas
workshop --workspace .claude/memory why "iOS $TASK_KEYWORDS"

# Search vibe.db for relevant code/symbols (if available)
python3 ~/.claude/scripts/memory-search-unified.py "$TASK_KEYWORDS" --mode all --top-k 5
```

If memory hits are relevant:
- Note them for context
- May skip or reduce ProjectContext query scope

### 1.2 Complexity Classification

Analyze the request using these heuristics:

**SIMPLE (complexity_tier: "simple")** - Route to Light Orchestrator
- Single file change
- Minor UI tweak (padding, color, text)
- Small bugfix with obvious location
- Copy/label changes
- Adding simple interaction (haptic, animation)
- Keywords: "tweak", "fix", "adjust", "change", "update" + single element

**MEDIUM (complexity_tier: "medium")** - Full Pipeline, Spec Recommended
- Single screen changes
- New simple component
- Modest logic changes
- Some tests needed
- 2-5 files affected

**COMPLEX (complexity_tier: "complex")** - Full Pipeline, Spec REQUIRED
- Multiple screens/flows
- Architecture/data layer changes
- New feature with state management
- Security/auth/payments
- Offline/sync functionality
- Migration work
- Keywords: "implement", "build", "create", "refactor" + feature/flow/system

**If uncertain:** Use AskUserQuestion:
```
"How would you classify this task?"
Options:
- Simple tweak (1-2 files, quick fix)
- Medium feature (single screen, some logic)
- Complex feature (multi-screen, architecture)
```

### 1.3 Spec Gating (Complex Tasks Only)

**If complexity_tier == "complex":**

1. Check if request references a requirement ID
2. Look for `requirements/<id>/06-requirements-spec.md`
3. **If spec NOT found:**
   ```
   ⛔ BLOCKED: Complex task requires a spec.

   This task appears to involve multiple screens/flows or architectural changes.
   Please run:
     /plan "<task description>"

   Then return with:
     /orca-ios "implement requirement <id>"
   ```
4. **If spec found:**
   - Record `requirement_id` and `requirements_spec_path` in phase_state
   - Spec becomes authoritative source for ios-architect

---

## 2. Routing Decision

Based on complexity_tier:

### Route A: Light Path (simple OR -tweak flag)

Delegate to `ios-light-orchestrator`:

```
Task({
  subagent_type: "ios-light-orchestrator",
  description: "Light iOS task: <short description>",
  prompt: `
Handle this simple iOS task via the light path.

REQUEST: $ARGUMENTS

MEMORY CONTEXT (if any):
<memory hits from 1.1>

Skip heavy ceremony. Route to ios-builder + specialists as needed.
Report what was changed and any follow-up notes.
  `
})
```

**Done.** Light orchestrator handles the rest. No phase_state, no gates.

---

### Route B: Full Pipeline (medium/complex)

Continue with full orchestration below.

---

## 3. Full Pipeline Flow

### 3.0 Team Confirmation (MANDATORY)

Use AskUserQuestion to confirm:

```
Detected: iOS task (complexity: medium/complex)

Proposed Pipeline:
1. Context Query (ProjectContext)
2. Grand Architect (ios-grand-architect) - architecture decisions
3. Planning (ios-architect) - detailed plan
4. Implementation (ios-builder + specialists)
5. Gates (ios-standards-enforcer, ios-ui-reviewer)
6. Verification (ios-verification)

Proposed Agents:
- ios-grand-architect (Opus)
- ios-architect
- ios-builder
- [specialists based on task]
- ios-standards-enforcer
- ios-ui-reviewer
- ios-verification

Options:
- Proceed as planned
- Adjust team/phases
- Switch to light path (-tweak)
```

### 3.1 Context Query

Call ProjectContextServer (unless memory-first gave sufficient context):

```
mcp__project-context__query_context({
  domain: "ios",
  task: <sanitized task description>,
  projectPath: <repo root>,
  maxFiles: 10-20,
  includeHistory: true
})
```

Initialize phase_state.json:
```json
{
  "domain": "ios",
  "complexity_tier": "medium|complex",
  "requirement_id": "<if applicable>",
  "requirements_spec_path": "<if applicable>",
  "current_phase": "context_query",
  "memory_summary": "<hits from memory search>",
  "context_query": {
    "status": "completed",
    "summary": "<brief context summary>"
  }
}
```

### 3.2 Grand Architect (Opus)

Delegate to `ios-grand-architect`:

Inputs:
- ContextBundle
- Memory summary
- Requirements spec (if complex)

Outputs:
- Architecture path (SwiftUI vs MVVM/TCA/UIKit)
- Data strategy (SwiftData vs Core Data/GRDB)
- Design DNA presence check
- Risk assessment
- Task force plan

Save decision via `mcp__project-context__save_decision`.

### 3.3 Planning (ios-architect)

Delegate to `ios-architect`:

**If requirements_spec_path exists:**
- ios-architect MUST read spec first
- Spec's constraints and acceptance criteria are authoritative
- Note any out-of-scope or ambiguous items

Outputs:
- Change type classification
- Impact analysis (screens, flows, data, navigation)
- Detailed plan with steps
- Constraints and risks

Update phase_state.planning.

### 3.4 Implementation (ios-builder + specialists)

Delegate to `ios-builder`:

Specialists as needed:
- UI: `ios-swiftui-specialist` or `ios-uikit-specialist`
- Tokens: `design-dna-guardian`
- Data: `ios-persistence-specialist`
- Networking: `ios-networking-specialist`
- Testing: `ios-testing-specialist`, `ios-ui-testing-specialist`
- Risk: `ios-performance-specialist`, `ios-security-specialist`, `ios-accessibility-specialist`

Update phase_state.implementation_pass1.

### 3.5 Gates

Run gate agents:

1. **ios-standards-enforcer** - Code standards, Swift 6 concurrency
   - Threshold: 90/100
   - Hard block if < 90

2. **ios-ui-reviewer** - UI/UX quality
   - Threshold: 90/100
   - Hard block if < 90

3. **ios-verification** - Build/test
   - Must pass build
   - Must pass tests

Update phase_state.gates.

**If gates fail:** Allow one corrective pass (implementation_pass2) scoped to violations only.

### 3.6 Completion

- Summarize gate scores, verification results, risks
- Save task history via `mcp__project-context__save_task_history`
- Archive phase_state

---

## 4. State Preservation & Session Continuity

**When user interrupts (questions, clarifications, test results):**

1. Read phase_state.json:
   ```bash
   cat .claude/orchestration/phase_state.json
   ```

2. Acknowledge and process new information

3. **DO NOT ABANDON PIPELINE:**
   - You are STILL orchestrating
   - Resume from current phase
   - Delegate to appropriate agent

4. **Anti-Pattern Detection:**
   - "Let me write this code" → WRONG. Delegate to ios-builder
   - "I'll fix this directly" → WRONG. Delegate to specialist
   - Using Edit/Write tools → WRONG. You're an orchestrator
   - "Based on feedback, delegating to ios-builder..." → CORRECT

---

## 5. Notes

- Block UI work if design DNA/tokens missing
- Do not change data store without explicit plan
- Keep edits scoped; no scope creep
- Complex tasks MUST have specs
- Simple tasks use light path for speed
