# Blueprint: /record Command

**Requirement ID:** record-command
**Status:** Blueprint Complete
**Date:** 2025-11-27

---

## Problem Statement

After completing significant work, capturing learnings to project memory requires manually invoking multiple Workshop and ProjectContext commands:
- `workshop decision` for decisions
- `workshop gotcha` for warnings
- `workshop note` for reference
- `mcp__project-context__save_decision` for decisions
- `mcp__project-context__save_task_history` for task outcomes

This is tedious, often forgotten, and learnings are lost between sessions.

## Solution Overview

A `/record` command that:
1. **Analyzes** the current session (git history, modified files, user input)
2. **Extracts** multiple learnings and auto-categorizes them
3. **Confirms** with user (interactive by default, --quick to skip)
4. **Records** to both Workshop AND ProjectContext
5. **Suggests** pattern analysis for recurring issues
6. **Blocks** duplicates within 7 days

---

## Functional Requirements

### FR1: Session Analysis

**What:** Gather context from the current session to extract learnings.

**Sources:**
1. Git commits (last 10-20)
2. Git diff (files modified)
3. phase_state.json (if exists, for pipeline context)
4. User-provided summary (if context insufficient)

**Output:**
```json
{
  "commits": ["abc123: Fixed auth flow", "def456: Refactored API"],
  "files_modified": ["src/auth.ts", "src/api.ts"],
  "domain_detected": "nextjs",
  "pipeline_context": { /* from phase_state */ }
}
```

### FR2: Learning Extraction & Auto-Categorization

**What:** Extract learnings from context and auto-categorize.

**Categories:**
| Pattern | Category |
|---------|----------|
| Architecture change, new pattern | `decision` |
| Bug fix with lesson, warning | `gotcha` |
| Breaking change, pitfall | `gotcha` |
| Reference info, docs | `note` |
| Task completion summary | `task_history` |

**Heuristics:**
- Commit messages with "decide", "chose", "use X instead of Y" → decision
- Commit messages with "fix", "bug", "avoid", "don't" → gotcha
- Multiple files in same feature area → decision (architecture)
- Single fix commit → gotcha (lesson learned)

**Output:**
```json
{
  "learnings": [
    {
      "type": "decision",
      "content": "Use JWT for authentication",
      "reasoning": "Stateless, scales horizontally",
      "confidence": 0.8
    },
    {
      "type": "gotcha",
      "content": "Don't store tokens in localStorage",
      "tags": ["security", "auth"],
      "confidence": 0.9
    }
  ]
}
```

### FR3: Duplicate Detection (7-day window)

**What:** Check Workshop for similar entries in last 7 days.

**Logic:**
1. Query `workshop search "<content_snippet>"`
2. Check timestamps of results
3. If match within 7 days: BLOCK with message showing existing entry
4. If no match: proceed

**Message:**
```
 DUPLICATE DETECTED

Similar entry exists (recorded 3 days ago):
  "Don't store tokens in localStorage" [gotcha]

Options:
  - Skip this item
  - Record anyway (creates duplicate)
  - Update existing entry
```

### FR4: Interactive Confirmation

**What:** Present extracted learnings for user review.

**Flow:**
1. Show all extracted learnings with auto-categories
2. For each learning, use AskUserQuestion:
   - Confirm category (decision/gotcha/note)
   - Edit content if needed
   - Set severity (critical/important/reference)
   - Add tags
3. Confirm domain detection
4. Final confirmation before recording

**--quick flag:** Skip confirmation, use auto-categorized values.

### FR5: Multi-Target Recording

**What:** Record confirmed learnings to both Workshop and ProjectContext.

**Workshop targets:**
```bash
# Decisions
workshop --workspace .claude/memory decision "<content>" -r "<reasoning>" -t <tags>

# Gotchas
workshop --workspace .claude/memory gotcha "<content>" -t <tags>

# Notes
workshop --workspace .claude/memory note "<content>"
```

**ProjectContext targets:**
```
# Decisions
mcp__project-context__save_decision(domain, decision, reasoning, tags)

# Task history (if task outcome recorded)
mcp__project-context__save_task_history(domain, task, outcome, files, learnings)
```

**Recording logic:**
| Learning Type | Workshop | ProjectContext |
|---------------|----------|----------------|
| decision |  decision |  save_decision |
| gotcha |  gotcha |  (no equivalent) |
| note |  note |  (no equivalent) |
| task_history |  note |  save_task_history |

### FR6: Standard Promotion Suggestion

**What:** Suggest promoting critical gotchas to standards.

**Trigger:** When a gotcha has severity=critical

**Message:**
```
 STANDARD SUGGESTION

This gotcha seems critical enough to become a standard:
  "Never store auth tokens in localStorage"

Standards are enforced by gates. Promote to standard?
  - Yes, create standard
  - No, keep as gotcha
```

**If promoted:**
```
mcp__project-context__save_standard(
  what_happened: "Auth tokens were stored in localStorage",
  cost: "Security vulnerability - XSS attacks can steal tokens",
  rule: "Never store auth tokens in localStorage; use httpOnly cookies",
  domain: "nextjs"
)
```

### FR7: Pattern Analysis Hint

**What:** Suggest running pattern analysis if recorded item looks recurring.

**Trigger:** After recording, if Workshop search shows 2+ similar gotchas

**Message:**
```
 PATTERN DETECTED

This gotcha appears similar to 2 other entries:
  - "Auth token exposed in URL" (2025-11-20)
  - "Token leaked via console.log" (2025-11-15)

This might be a recurring pattern. Run /audit to analyze and consider improvement proposals.
```

### FR8: Summary Output

**What:** Display summary of what was recorded.

**Format:**
```
 RECORDED TO PROJECT MEMORY

Workshop:
   Decisions: 2 recorded
   Gotchas: 1 recorded
   Notes: 1 recorded

ProjectContext:
   Decision saved (domain: nextjs)
   Task history saved

Tags: #auth, #security, #v2.3.1

Query later:
  workshop why "authentication"
  workshop search "token"

 Tip: Run /audit periodically to analyze patterns
```

---

## Technical Requirements

### TR1: Command Definition

**File:** `commands/record.md`

**Frontmatter:**
```yaml
---
description: "Record session learnings to Workshop and ProjectContext"
argument-hint: "[--quick] [topic to record]"
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
  - AskUserQuestion
  - mcp__project-context__save_decision
  - mcp__project-context__save_task_history
  - mcp__project-context__save_standard
---
```

### TR2: Domain Detection

**Patterns:**
| Files | Domain |
|-------|--------|
| `*.swift`, `*.xcodeproj`, `Package.swift` | ios |
| `*.tsx`, `next.config.*`, `app/`, `pages/` | nextjs |
| `app.json`, `expo`, `*.tsx` (no next.config) | expo |
| `*.liquid`, `theme.liquid`, `sections/` | shopify |
| `agents/`, `commands/`, `CLAUDE.md` | os-dev |
| Default | general |

### TR3: Git Analysis Commands

```bash
# Recent commits
git log --oneline -20

# Files modified
git diff --stat HEAD~10

# Commit messages for analysis
git log --format="%s" -20

# Current branch
git branch --show-current
```

### TR4: Workshop Query for Duplicates

```bash
# Search for similar content
workshop --workspace .claude/memory search "<content_first_20_chars>" --limit 5

# Check recent entries
workshop --workspace .claude/memory recent --limit 20
```

### TR5: Argument Parsing

| Argument | Behavior |
|----------|----------|
| (none) | Interactive mode, analyze session |
| `--quick` | Skip confirmation, use defaults |
| `<topic>` | Focus analysis on specific topic |
| `--domain <d>` | Override domain detection |

---

## Implementation Flow

```
/record [--quick] [topic]
    
     Parse arguments
    
     Gather context
        git log --oneline -20
        git diff --stat HEAD~10
        cat .claude/orchestration/phase_state.json
        workshop recent --limit 10
    
     Detect domain
    
     Extract learnings
        Parse commit messages
        Identify patterns (decision/gotcha/note)
        Auto-categorize
    
     If insufficient context:
        AskUserQuestion for summary
    
     Check duplicates (7-day window)
        workshop search for each learning
        Block if duplicate found
    
     If NOT --quick:
        Present learnings
        Confirm category/content/severity
        Confirm domain
    
     Record to Workshop
        workshop decision (with -r reasoning)
        workshop gotcha (with -t tags)
        workshop note
    
     Record to ProjectContext
        save_decision
        save_task_history
    
     If critical gotcha:
        Suggest standard promotion
    
     Check for patterns
        If 2+ similar: hint /audit
    
     Display summary
```

---

## RA-Tagged Decisions

### #PATH_DECISION: Confirmed

1. **Human learnings only** - No code-level patterns (vibe-sync handles that)
2. **Workshop + ProjectContext dual recording** - Decisions go to both, gotchas Workshop-only
3. **7-day duplicate blocking** - Prevents accidental re-recording
4. **Interactive by default** - User controls what gets recorded
5. **Suggest, don't auto-create standards** - User explicitly promotes

### #COMPLETION_DRIVE: Assumptions

1. Git history is sufficient for session analysis in most cases
2. Conversation transcript is not directly accessible
3. Auto-categorization heuristics are good enough (user can override)
4. 7 days is appropriate duplicate window

### #POISON_PATH: Avoid

1. **Auto-modifying agents** - /record captures learnings, doesn't apply them
2. **Recording to vibe.db code tables** - That's for code intelligence, not learnings
3. **Skipping duplicate check** - Would pollute memory with redundant entries

---

## Acceptance Criteria

- [ ] `/record` analyzes git history and extracts learnings
- [ ] Auto-categorization suggests decision/gotcha/note types
- [ ] Duplicate check blocks entries within 7-day window
- [ ] Interactive confirmation shows learnings for review
- [ ] `--quick` flag skips confirmation
- [ ] Decisions recorded to both Workshop and ProjectContext
- [ ] Gotchas/notes recorded to Workshop only
- [ ] Critical gotchas prompt for standard promotion
- [ ] Pattern hint shown when 2+ similar entries exist
- [ ] Summary shows what was recorded with query hints

---

## Next Steps

```
/orca-os-dev implement requirement record-command
```
