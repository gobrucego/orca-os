---
description: "OS 2.3 orchestrator entrypoint for Shopify theme tasks"
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

# /orca-shopify – Shopify Lane Orchestrator (OS 2.3)

Use this command for Shopify theme work (Liquid, sections, CSS, JS components).

## Usage

```bash
/orca-shopify "refactor header section CSS to use tokens"   # Auto-routes based on complexity
/orca-shopify -tweak "fix button padding"                    # Force light path
/orca-shopify "implement requirement 2025-11-25-header-redesign"  # Full path with spec
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
  → Enter Deep Audit Mode (skip normal implementation flow)
```

If `--audit` is present, run the Deep Audit flow in Section 0.5 and
return a report instead of implementing changes.

---

## 0.5 Deep Audit Mode (Optional)

Use this mode for a **deep review/audit of the existing Shopify theme**
rather than implementing a change. This is particularly useful for:

- CSS architecture (Liquid + CSS interactions)
- Section/snippet structure and responsibilities
- Design token usage vs inline styles
- Theme check issues and Shopify best practices

**IMPORTANT:** Audit mode MUST NOT modify any theme files. It only
analyzes and reports.

### 0.5.1 Clarify Audit Focus

Use `AskUserQuestion` to clarify what to prioritize. For example:

- CSS architecture & DevTools sanity
  - e.g. “When I open DevTools, I want no crossed-out properties and a
    single authoritative CSS source per element.”
- Liquid/section structure & reuse
- Performance & bundle size
- Accessibility & semantics
- Tracking/SEO behavior

Let the user pick one or more focus areas.

### 0.5.2 Memory & ProjectContext

1. **Memory-first search**
   - Use unified memory search to find:
     - Prior Shopify or CSS architecture incidents/decisions.
     - Any theme‑specific gotchas already recorded.

2. **ProjectContext diagnostic query**
   - Call `mcp__project-context__query_context` with:
     - `domain: "shopify"`
     - `task`: `"Deep Shopify theme audit"`
     - `projectPath`: repo root (theme root)
     - `maxFiles`: ~30–50
     - `includeHistory`: `true`

   - Use the ContextBundle to:
     - Identify key CSS assets (`assets/*.css`).
     - Identify `layout/theme.liquid`, major sections and snippets.
     - Surface any previous theme-related standards/decisions.

### 0.5.3 Assemble a Shopify Audit Squad (via Task)

Based on the user’s focus, delegate to relevant Shopify agents:

- **CSS & architecture**
  - `shopify-css-specialist` – review:
    - How CSS is structured across `assets/*.css` (e.g. `base.css`,
      `layout.css`, component/section CSS).
    - Where cascade/order issues or repeated overrides are likely
      causing crossed-out properties in DevTools.
    - Inline styles, `!important`, overly generic selectors.

- **Liquid & sections**
  - `shopify-liquid-specialist` – examine:
    - `layout/theme.liquid`, major `sections/*.liquid`,
      `snippets/*.liquid`.
    - Responsibilities of sections vs snippets; duplication and
      opportunities to normalize.

  - `shopify-section-builder` – check:
    - `templates/*.json` and which sections they reference.
    - Whether section JSON schemas are coherent and predictable.

- **Theme validation & behavior**
  - `shopify-theme-checker` – run `shopify theme check` (where safe)
    for linting and best‑practice violations.
  - Optionally, `shopify-js-specialist` – review key JS files for
    interactive behavior and event wiring.

In each `Task` prompt, make it explicit:

- This is an **audit**, not implementation.
- Agents should use `Read`/`Grep`/`Glob` and ProjectContext to inspect
  theme structure and CSS, not rely on `files_modified`.
- They must **not** edit files; only analyze and report.

### 0.5.4 Synthesize a Shopify Theme Architecture Audit

Combine the squad’s findings into a single report with clear sections,
for example:

- **CSS Architecture**
  - How CSS is currently organized.
  - Where overrides and crossed-out properties are likely coming from.
  - Recommendations to move toward:
    - Single authoritative CSS per element/section.
    - Consistent use of design tokens and 4px spacing grid.

- **Liquid & Section Structure**
  - How `layout/`, `sections/`, and `snippets/` are interacting.
  - Duplication or unclear responsibilities.
  - Suggested refactors for clearer boundaries and reuse.

- **Theme Check & Best Practices**
  - Summary of `shopify theme check` issues.
  - Any structural problems, performance, or SEO concerns.

- **Concrete Follow-Up Tasks**
  - Small, scoped tasks that can be turned into `/plan` + `/orca-shopify`
    or other lanes, e.g.:
    - “Normalize product card CSS into a single component file.”
    - “Remove inline styles from X sections and map them to tokens.”
    - “Consolidate header/footer layout rules into layout.css.”

### 0.5.5 (Optional) Save Audit History

Use `mcp__project-context__save_task_history` to log the audit:

- `domain`: `"shopify"`
- `task`: `"audit: shopify theme"`
- `outcome`: `"reviewed"` or `"diagnosed"`
- `learnings`: key bullet points from the audit

Return this audit report to the user and **do not** proceed into the
normal implementation pipeline unless they explicitly ask for a
specific follow‑up task to implement.

---

## 1. Memory-First Context & Complexity Classification

### 1.1 Memory Search (Before ProjectContext)

Before expensive ProjectContext queries, check local memory:

```bash
# Search Workshop for relevant Shopify decisions/gotchas
workshop --workspace .claude/memory why "Shopify $TASK_KEYWORDS"

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
- Minor CSS tweak (padding, color, spacing via tokens)
- Copy/label text changes
- Small Liquid fix with obvious location
- Keywords: "tweak", "fix", "adjust", "change" + single element

**MEDIUM (complexity_tier: "medium")** - Full Pipeline, Spec Recommended
- Single section changes
- New snippet or minor component
- CSS refactoring across a few files
- 2-5 files affected
- Theme Check validation needed

**COMPLEX (complexity_tier: "complex")** - Full Pipeline, Spec REQUIRED
- Multiple sections or templates
- New section with schema
- JavaScript/Web Component work
- Design token system changes
- Cart/checkout modifications
- Keywords: "implement", "build", "create", "refactor" + feature/system

### 1.3 Spec Gating for Complex Tasks

If `complexity_tier == "complex"`:

```bash
# Check for requirements spec
ls requirements/*/06-requirements-spec.md 2>/dev/null | head -5
```

**If NO spec exists:**
```
⚠️ Complex Shopify work requires a requirements spec.

Run first:
  /plan "Short description of the Shopify change"

Then return with:
  /orca-shopify "implement requirement <id>"
```

**STOP HERE** - Do not proceed without spec for complex work.

---

## 2. Route by Complexity

### Simple Tasks → Light Orchestrator

Delegate to `shopify-light-orchestrator`:

```
Task: shopify-light-orchestrator
Inputs:
  - task: user request
  - memory_hints: relevant Workshop/vibe.db hits
Expected outputs:
  - files_modified
  - change_summary
  - warnings (design token violations if any)
```

**Skip** team confirmation, gates, and verification for simple tasks.
Return light orchestrator's summary directly to user.

### Medium/Complex Tasks → Full Pipeline

Continue to Section 3 (Team Confirmation).

---

## 3. Team Confirmation (Full Pipeline Only)

Use `AskUserQuestion` to confirm the proposed agent team:

```
Proposed Shopify Pipeline:
- shopify-grand-architect (Opus) - coordination
- Specialists as needed:
  - shopify-css-specialist - CSS/tokens
  - shopify-liquid-specialist - Liquid templates
  - shopify-section-builder - sections/schemas
  - shopify-js-specialist - JavaScript/Web Components
- shopify-theme-checker - verification gate

Complexity: [simple/medium/complex]
Spec: [linked/none]

Proceed with this team?
```

---

## 4. ProjectContext Query

Call `mcp__project-context__query_context`:
- domain: "shopify"
- task: user request (short)
- projectPath: repo root
- maxFiles: 10–20
- includeHistory: true

---

## 5. Delegate to Grand Architect

Delegate to `shopify-grand-architect`:
- Inputs: ContextBundle, complexity_tier, spec_path (if present)
- Outputs: specialist assignments, task breakdown, design token status, risks
- Save decision via mcp__project-context__save_decision

---

## 6. Implementation (via Grand Architect)

Grand architect delegates to specialists:
- CSS/Tokens: `shopify-css-specialist` (refactoring, !important cleanup, design tokens)
- Liquid: `shopify-liquid-specialist` (templates, objects, filters, control flow)
- Sections: `shopify-section-builder` (schemas, blocks, presets)
- JavaScript: `shopify-js-specialist` (Web Components, PubSub, cart interactions)

**RA Integration:** Specialists should tag assumptions:
- `#COMPLETION_DRIVE` - assumed behavior without explicit confirmation
- `#CARGO_CULT` - copied pattern from elsewhere in codebase
- `#TOKEN_VIOLATION` - design token rule not followed (warn)

---

## 7. Gates & Verification

Delegate to `shopify-theme-checker`:
- Run `shopify theme check`
- Check design token compliance (warn only)
- Record in phase_state.gates

**Gate thresholds:**
- Theme Check: PASS if no errors (warnings acceptable)
- Design Tokens: Soft warning only (4px grid compliance)

**If gate fails:**
- One corrective pass allowed
- Re-run verification after fixes
- If still failing, mark as partial completion

---

## 8. Completion & Learning

1. Summarize:
   - Files modified
   - Gate scores (Theme Check, design tokens)
   - RA status (any unresolved assumptions)
   - Remaining warnings

2. Save task history via `mcp__project-context__save_task_history`:
   - domain: "shopify"
   - task: short description
   - outcome: success/partial/failure
   - files_modified
   - learnings

3. For recurring issues, save standard via `mcp__project-context__save_standard`

---

## 🔄 State Preservation & Session Continuity

**When the user interrupts (questions, clarifications, test results, pauses):**

1. **Read phase_state.json** to understand where you were:
   ```bash
   cat .claude/orchestration/phase_state.json
   ```

2. **Acknowledge the interruption** and process the new information

3. **DO NOT ABANDON THE PIPELINE:**
   - You are STILL orchestrating the Shopify lane
   - You are STILL using shopify-grand-architect and specialists
   - The agent team doesn't disappear because the user asked a question

4. **Resume orchestration:**
   - If in Implementation phase → continue with shopify-grand-architect
   - If in Gates phase → continue with shopify-theme-checker
   - If in Verification → continue with shopify-theme-checker
   - Update phase_state.json with new information
   - Delegate to the appropriate agent via Task tool

5. **Anti-Pattern Detection:**
   - ❌ "Let me write this code for you" → **WRONG. Delegate to specialist**
   - ❌ "I'll fix this directly" → **WRONG. Delegate to appropriate specialist**
   - ❌ Using Edit/Write tools yourself → **WRONG. You're an orchestrator**
   - ✅ "Based on your feedback, I'm delegating to shopify-css-specialist to..." → **CORRECT**

**Orchestration mode persists across the ENTIRE task. User questions don't reset your role.**
