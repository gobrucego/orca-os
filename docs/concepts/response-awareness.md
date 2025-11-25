# Response Awareness (RA)

Response Awareness is OS 2.3's system for tracking assumptions, decisions, and potential issues during agent work.

## Why RA?

AI agents make assumptions. Without tracking:
- Assumptions become invisible
- Same mistakes repeat
- No audit trail for decisions
- Hard to diagnose failures

RA makes the implicit explicit.

## RA Tags

Agents use these tags to flag different types of assumptions:

### `#COMPLETION_DRIVE`
Assumed behavior without explicit confirmation.

```
#COMPLETION_DRIVE: Assuming mobile breakpoint is 768px
#COMPLETION_DRIVE: Assuming user wants haptic on all buttons
```

### `#CARGO_CULT`
Copied pattern from elsewhere in codebase without understanding.

```
#CARGO_CULT: Mirroring header section's token usage
#CARGO_CULT: Following existing error handling pattern
```

### `#PATH_DECISION`
Architectural choice made during implementation.

```
#PATH_DECISION: Using Web Component over vanilla JS
#PATH_DECISION: Chose SwiftUI over UIKit for this view
```

### `#PATH_RATIONALE`
Explanation for a path decision.

```
#PATH_RATIONALE: Web Component provides encapsulation and reusability
```

### `#POISON_PATH`
User framing or prior code is leading toward unsafe patterns.

```
#POISON_PATH: Existing code uses force unwraps in async context
#POISON_PATH: Request implies skipping validation
```

### `#TOKEN_VIOLATION`
Design token rule not followed.

```
#TOKEN_VIOLATION: Using hardcoded #333 - token not available
#TOKEN_VIOLATION: 17px not on 4px grid
```

### `#CONTEXT_DEGRADED`
Operating with reduced context quality.

```
#CONTEXT_DEGRADED: ProjectContext timeout, using manual file search
```

### `#SCOPE_EXCEEDED`
Task is beyond the agent's intended scope.

```
#SCOPE_EXCEEDED: This requires multi-file changes, recommend full pipeline
```

## RA in Phase State

RA events are tracked in `phase_state.json`:

```json
{
  "implementation_pass1": {
    "files_modified": ["SaveButton.swift"],
    "ra_events": [
      {
        "tag": "#COMPLETION_DRIVE",
        "message": "Assuming haptic should be .medium intensity",
        "file": "SaveButton.swift",
        "resolved": false
      },
      {
        "tag": "#PATH_DECISION",
        "message": "Using UIImpactFeedbackGenerator over UISelectionFeedbackGenerator",
        "rationale": "Impact provides more noticeable feedback for button taps",
        "resolved": true
      }
    ]
  }
}
```

## RA in Gates

Gate agents check RA status and report in their output:

```markdown
## RA Status
- Tags found: 3
- Unresolved: 1
  - SaveButton.swift:45 - #COMPLETION_DRIVE: Assuming .medium intensity

Gate Decision: CAUTION (unresolved RA assumption)
```

RA status affects gate decisions:
- `ra_status: "none"` - No RA tags (clean)
- `ra_status: "present_resolved"` - Tags exist but documented/resolved
- `ra_status: "present_unresolved"` - Unresolved assumptions (flag for review)

## RA in /audit

The `/audit` command mines RA events across tasks:

```bash
/audit "last 10 tasks"
```

Audit report includes:
```markdown
## RA Event Summary
- #COMPLETION_DRIVE: 7 occurrences (3 unresolved)
- #CARGO_CULT: 2 occurrences
- #PATH_DECISION: 5 occurrences (all documented)

### Frequent Assumptions
- "Mobile breakpoint 768px" appeared 4 times → candidate for standard
```

## RA → Standards Loop

When `/audit` finds recurring RA patterns, it can promote them to standards:

```
Recurring RA assumption
    ↓
/audit identifies pattern
    ↓
mcp__project-context__save_standard()
    ↓
Standard appears in future ContextBundles
    ↓
Gates enforce the standard
```

This closes the learning loop: assumption → audit → standard → enforcement.

## v2.4 Roadmap: Automatic Escalation

**Not yet implemented** - future evolution:

- If a certain RA tag appears frequently (e.g., same assumption 3+ times):
  - Automatically prompt to promote to standard
  - Adjust complexity thresholds if assumptions indicate underestimated complexity
- Requires: RA event aggregation across sessions, frequency analysis, threshold triggers

## Best Practices

### For Specialists
- Tag assumptions as you make them
- Use `#PATH_DECISION` + `#PATH_RATIONALE` for architectural choices
- Flag `#POISON_PATH` if user request or existing code seems unsafe

### For Gates
- Check `ra_events` from implementation phases
- Report unresolved assumptions
- Factor RA status into gate decision

### For Orchestrators
- Pass RA events from specialists to gates
- Include RA summary in completion report
- Flag unresolved assumptions to user

## See Also

- [Pipeline Model](pipeline-model.md) - Where RA fits in the pipeline
- [Memory Systems](memory-systems.md) - How RA events persist
