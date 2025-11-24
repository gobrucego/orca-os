# Response Awareness in OS 2.1

**Version:** OS 2.1
**Last Updated:** 2025-11-24

**Purpose:** Provide a light-weight, OS 2.1–native way to use Response Awareness ideas (metacognitive tags, planning modes) integrated with the unified `/plan` and `/audit` commands.

This doc defines:
- A small set of **RA tags** agents may use
- How tags are recorded in requirements/specs
- How tags integrate with `/plan` and `/audit` commands (NEW in OS 2.1)
- How tags can be surfaced via ProjectContext and vibe.db

---

## What's New in OS 2.1

**Integration Changes:**
- ✅ **Unified Planning** - RA tagging now happens in `/plan` command during blueprint creation
- ✅ **Meta-Audit System** - `/audit` command analyzes RA-tagged patterns for continuous improvement
- ✅ **Continuous Loop** - /plan → /orca-{domain} → /audit creates learning cycle
- ✅ **Standards from Failures** - /audit converts RA-detected failures into ProjectContext standards

**Old Workflow (OS 2.0):**
```
Manual RA tagging → Manual review → Manual standards creation
```

**New Workflow (OS 2.1):**
```
/plan (auto-tags with RA) → /orca (executes) → /audit (analyzes + creates standards)
```

---

## 1. Tag Taxonomy

Agents MAY annotate text (requirements, findings, implementation summaries) with inline tags to mark notable cognitive patterns or decisions:

- `#PATH_DECISION:` – multiple viable implementation paths considered; this marks the chosen path and, ideally, hints at alternatives.
- `#COMPLETION_DRIVE:` – the model filled in plausible content where real information was missing (assumption rather than observed fact).
- `#CARGO_CULT:` – pattern-matching from past examples is adding unrequested features or complexity.
- `#CONTEXT_DEGRADED:` – earlier specifics are no longer reliably retrievable; any reconstruction is "best effort".
- `#POISON_PATH:` – particular terminology or framing is biasing solutions toward a known-bad pattern.
- `#RESOLUTION_PRESSURE:` – generation strongly "wants" to tie things off; risk of prematurely declaring work "done".

These tags are **signals**, not verdicts. They should be used sparingly and only when they genuinely help future readers (including future agents).

---

## 2. Where Tags Can Appear

### During Planning (/plan command) - NEW in OS 2.1

The `/plan` command automatically applies RA tagging during blueprint creation:

**Phase 1: Discovery Questions (AskUserQuestion)**
- 5 high-level questions about the feature
- Context query via ProjectContextServer

**Phase 2: Detail Questions (AskUserQuestion)**
- 5 specific questions about implementation
- RA tagging applied to answers:
  - User says "like the existing export" → Tag with `#CARGO_CULT:` if copying untested patterns
  - User says "I think it should" → Tag with `#COMPLETION_DRIVE:` if assumption, not fact
  - Multiple approaches discussed → Tag with `#PATH_DECISION:` for chosen path

**Output:** `requirements/<id>/06-requirements-spec.md` with RA tags embedded

### During Implementation (orca-* commands)

Agents should:
- Read RA-tagged sections in the spec before planning/implementing
- Call out these tags in their own summaries ("this area carries #COMPLETION_DRIVE – verify during QA")
- Update phase_state.json with RA-related concerns

### During Meta-Audit (/audit command) - NEW in OS 2.1

The `/audit` command analyzes recent work for RA patterns:

**What it does:**
1. Loads recent task history from phase_state.json and ProjectContext
2. Applies RA lens to agent behavior:
   - Did scope creep occur? (#CARGO_CULT)
   - Were assumptions made without validation? (#COMPLETION_DRIVE)
   - Were quality gates bypassed? (#RESOLUTION_PRESSURE)
   - Did orchestrators break role boundaries? (#CONTEXT_DEGRADED)
3. Creates standards from failures via mcp__project-context__save_standard
4. Records learnings via mcp__project-context__save_task_history

**Output:** `.claude/orchestration/evidence/audit-<timestamp>.md`

**Example Audit Finding:**
```markdown
## Pattern Detected: #RESOLUTION_PRESSURE

**What Happened:**
In task "implement-dark-mode", the nextjs-builder agent declared work complete after implementation phase without running design QA gate (scored 88, below ≥90 threshold).

**Cost:**
Visual inconsistencies in dark mode required rework (+2 hours). User reported poor contrast in header.

**New Standard:**
"Design QA gate is MANDATORY for all UI changes. Score must be ≥90. If gate fails, iterate until pass. Never skip gates due to time pressure."

**Action Taken:**
Standard saved to ProjectContext (will block future similar bypasses).
```

---

## 3. Examples

### Planning (in /plan output)

```markdown
## Implementation Path

We will extend the existing `ProfileCard` component to support avatar upload.

#PATH_DECISION: Three approaches considered:
1. Extend ProfileCard (CHOSEN - maintains UX consistency)
2. New AvatarUploadCard component (rejected - duplicates layout logic)
3. Standalone modal (rejected - inconsistent with profile edit flow)

Alternative 2 was rejected because it would introduce layout duplication and require maintaining two separate card patterns.
```

```markdown
### Assumptions

The following assumptions were made and should be validated before implementation:

- #COMPLETION_DRIVE: We assumed "export to CSV" should mirror the existing PDF export filters, but this was not explicitly confirmed by the user. VALIDATE in Phase 4 before implementing filters.
- #COMPLETION_DRIVE: We assumed dark mode applies to all routes. User mentioned "main app" but didn't specify if auth pages are included. ASK user during implementation.
```

### Implementation Summary

```markdown
## Phase 4: Implementation Complete

Implemented dark mode support using Tailwind `dark:` classes.

**RA Concerns:**
- #PATH_DECISION: Chose Tailwind classes over CSS variables. Context-based switching via `next-themes` library.
- #CARGO_CULT: Copied color scheme from existing dashboard without testing accessibility. FLAGGED for accessibility gate.

**Verification Needed:**
- Contrast ratios (especially in header)
- Screen reader announcements for theme toggle
```

### Audit Output (from /audit command)

```markdown
# Meta-Audit: Last 10 Tasks

**Generated:** 2025-11-24 14:30:00

## Overview
Analyzed 10 tasks across iOS, Next.js, and Expo domains from Nov 18-24.

---

## Pattern 1: #CARGO_CULT - Feature Creep

**Instances:** 3/10 tasks

**Examples:**
1. "Add login page" → Builder added password strength meter (not requested)
2. "Update profile card" → Builder added loading skeletons (not in spec)
3. "Fix typo" → Builder refactored entire component (beyond scope)

**Root Cause:**
Builders pattern-matching from other projects without checking current requirements.

**New Standard Created:**
"SCOPE LOCK: Only implement features explicitly in the requirement spec. If you identify a useful enhancement, FLAG it for user decision. Never add features proactively."

**Status:** Standard saved to ProjectContext (requirement ID enforcement)

---

## Pattern 2: #RESOLUTION_PRESSURE - Premature Completion

**Instances:** 2/10 tasks

**Examples:**
1. "Dark mode" → Builder declared complete before design QA (scored 88/100, failed)
2. "API integration" → Verification agent skipped error handling tests (assumed working)

**Root Cause:**
Agents declaring work "done" to meet perceived expectations, bypassing quality gates.

**New Standard Created:**
"QUALITY GATES ARE MANDATORY: Standards ≥90, Design QA ≥90, Accessibility ≥90, Build/Test PASS. If gate fails, iterate. Never skip gates. Orchestrators must enforce."

**Status:** Standard saved to ProjectContext (gate enforcement)

---

## Pattern 3: #CONTEXT_DEGRADED - Orchestration Breakdown

**Instances:** 1/10 tasks (but CRITICAL)

**Example:**
"iOS biometric auth" → User asked clarifying question, orchestrator abandoned agent system and started coding directly.

**Root Cause:**
Orchestrator lost context of role during interruption. No state preservation.

**Fix Applied:**
OS 2.1 now includes phase_state.json + explicit role boundary enforcement in all orca commands.

**Status:** Architectural fix (should not recur in 2.1)

---

## Recommendations

1. **Builders:** Check requirement spec before adding ANY feature not explicitly listed
2. **Standards Enforcers:** Block completion if ANY gate <90
3. **Orchestrators:** Read phase_state.json after EVERY user input
4. **All Agents:** When in doubt, ASK the user rather than ASSUME

---

**Next Audit:** Run `/audit` after next 10 tasks to verify pattern reduction
```

---

## 4. Memory Integration

### ProjectContext (MCP)

The `/audit` command uses ProjectContext to:
- **Save standards:** `mcp__project-context__save_standard`
  ```typescript
  save_standard({
    domain: "nextjs",
    what_happened: "Builder added unrequested features",
    cost: "Scope creep, user confusion, +3 hours rework",
    rule: "SCOPE LOCK: Only implement features explicitly in requirement spec"
  })
  ```

- **Save learnings:** `mcp__project-context__save_task_history`
  ```typescript
  save_task_history({
    domain: "ios",
    task: "implement-dark-mode",
    outcome: "partial",
    learnings: "#RESOLUTION_PRESSURE detected: design QA bypassed. Standard created to enforce gates."
  })
  ```

### vibe.db (Persistent)

The `vibe.db` schema includes an `events` table that stores RA-related metadata:

**Recommended pattern:**
- When a requirement or implementation uses a significant RA tag:
  - Insert an `events` row with:
    - `type`: `"ra_tag"`
    - `data`: JSON containing:
      - `tag`: tag name (e.g. `"PATH_DECISION"`)
      - `location`: file/path within the repo (e.g. `requirements/.../06-requirements-spec.md`)
      - `requirement_id` or `task_id`
      - `note`: short description of what was marked

### Workshop

Workshop can also track RA-related decisions:
```bash
workshop decision "Chose Tailwind dark: classes over CSS variables for dark mode" \
  -r "Tailwind approach integrates better with existing design system" \
  -t dark-mode -t PATH_DECISION
```

---

## 5. Interaction with Pipelines

### Requirements Lane (/plan command)

**Automatic RA Tagging:**
- During discovery questions: Flag ambiguous answers with `#COMPLETION_DRIVE`
- During detail questions: Mark architectural decisions with `#PATH_DECISION`
- In final blueprint: Highlight assumptions with `#COMPLETION_DRIVE` for validation

**Output:** `requirements/<id>/06-requirements-spec.md` with tags

### Domain Pipelines (orca-*)

**Architect Agents:**
- Read RA-tagged sections in the spec before planning
- Call out RA tags in planning summaries
- Flag high-risk areas for additional scrutiny

**Builder Agents:**
- Validate `#COMPLETION_DRIVE` assumptions before implementing
- Document `#PATH_DECISION` choices in implementation summaries
- Avoid `#CARGO_CULT` by checking requirement scope

**Gate Agents:**
- Raise gate strictness when RA tags highlight riskier areas
- Block completion if `#COMPLETION_DRIVE` assumptions unvalidated
- Add follow-up tasks for `#PATH_DECISION` alternatives

### Meta-Audit Lane (/audit command)

**Behavior Analysis:**
- Load recent tasks from ProjectContext
- Apply RA lens to agent behavior
- Detect patterns: scope creep, premature completion, role violations

**Standards Creation:**
- Convert failures into standards (via save_standard)
- Make standards enforceable in future tasks
- Create learning loop: /plan → /orca → /audit → improved standards

---

## 6. Continuous Improvement Loop (NEW in OS 2.1)

```
User Request
    ↓
/plan "feature description"
    ↓
    → RA tagging during Q&A
    → Blueprint with tags: requirements/<id>/06-requirements-spec.md
    ↓
/orca-nextjs "implement requirement <id>"
    ↓
    → Agents read RA tags
    → Implement with awareness
    → Flag concerns in summaries
    ↓
Feature Complete
    ↓
Periodically: /audit "last 10 tasks"
    ↓
    → Analyze RA patterns
    → Create standards from failures
    → Update ProjectContext
    ↓
Future /plan commands
    ↓
    → Query ProjectContext (includes new standards)
    → Avoid previously detected patterns
    → Improved quality
```

**Result:** Self-improving system that learns from RA-detected patterns and prevents recurrence.

---

## 7. Best Practices

### When to Use RA Tags

**DO use tags for:**
- Significant architectural decisions (#PATH_DECISION)
- Assumptions that need validation (#COMPLETION_DRIVE)
- Patterns copied from elsewhere without verification (#CARGO_CULT)
- Areas where context was lost (#CONTEXT_DEGRADED)
- Known-bad patterns being suggested (#POISON_PATH)
- Pressure to declare work "done" prematurely (#RESOLUTION_PRESSURE)

**DON'T use tags for:**
- Every minor decision (noise)
- Well-established patterns (no uncertainty)
- Fully validated facts (not assumptions)

### When to Run /audit

**Recommended frequency:**
- After every 5-10 tasks
- After any major failure or rework
- Before starting large features (learn from recent patterns)
- When you notice recurring issues

**Audit scope:**
```bash
/audit "last 10 tasks"              # General review
/audit "recent iOS work"            # Domain-specific
/audit "tasks since Nov 20"         # Date range
/audit "all tasks with rework"      # Filter by outcome
```

---

## 8. Migration from OS 2.0

**Old Response Awareness Workflow:**
- Manual RA tagging in specs
- Manual review of tags
- Manual standards creation
- No automated analysis

**New OS 2.1 Workflow:**
- Automatic RA tagging in `/plan`
- Automatic analysis in `/audit`
- Automatic standards creation via ProjectContext
- Continuous improvement loop

**Action Items:**
1. Use `/plan` for all new requirements (auto-tags)
2. Run `/audit` periodically to analyze patterns
3. Existing requirements can be retroactively audited
4. New standards will prevent old patterns

---

Response Awareness in OS 2.1 is **integrated** and **automated**: it helps focus attention where it matters most, creates standards from failures, and builds a continuous improvement loop—without becoming noisy or blocking.
