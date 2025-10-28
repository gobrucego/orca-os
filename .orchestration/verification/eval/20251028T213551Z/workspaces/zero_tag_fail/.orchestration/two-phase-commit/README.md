# Two-Phase Commit State Machine

**Purpose:** Separate task completion claims from verification, preventing false completions

**Version:** 1.0.0 (Stage 2 Week 3)

---

## Overview

The Two-Phase Commit system implements a state machine for task completion that **separates claiming from verification**, making it impossible for specialists to mark tasks complete without evidence.

**Core Principle:** Only verification-agent can mark tasks as VERIFIED. Only VERIFIED tasks can be marked COMPLETED.

---

## The Problem

**Current flow (allows false completions):**

```
Specialist implements task
    ↓
Specialist marks TodoWrite item as "completed"
    ↓
Task appears done (but no verification ran!)
    ↓
workflow-orchestrator proceeds to next task
    ↓
User discovers nothing actually works
```

**Problem:** Specialist can claim completion without verification.

---

## The Solution: Two-Phase Commit

**New flow (prevents false completions):**

```
Specialist implements task
    ↓
Specialist marks TodoWrite item as "claimed"  ← Phase 1: CLAIM
    ↓
verification-agent MUST run
    ↓
verification-agent marks item as "verified"   ← Phase 2: VERIFY
    ↓
workflow-orchestrator marks as "completed"    ← Only after verified
    ↓
Task is actually done (with evidence)
```

**Key Difference:** Task cannot go from CLAIMED → COMPLETED without passing through VERIFIED.

---

## State Machine

### States

```
PENDING → CLAIMED → VERIFIED → COMPLETED
            ↓ (if verification fails)
          BLOCKED → back to PENDING
```

**State Definitions:**

1. **PENDING**
   - Task not yet started
   - Waiting for specialist dispatch
   - Initial state for all tasks

2. **CLAIMED**
   - Specialist claims implementation is done
   - Evidence files created (screenshots, test outputs, etc.)
   - Verification has NOT run yet
   - **CRITICAL:** Task is NOT complete yet

3. **VERIFIED**
   - verification-agent ran all checks
   - All deliverables met (per completion criteria)
   - Proofpack generated with passing verdict
   - **Ready for COMPLETED status**

4. **BLOCKED**
   - verification-agent found failures
   - Some deliverables not met
   - Task CANNOT proceed to COMPLETED
   - Must return to PENDING for fixes

5. **COMPLETED**
   - verification passed (VERIFIED state confirmed)
   - quality-validator approved (if applicable)
   - Task fully done with evidence
   - **Final state**

---

## State Transitions

### Allowed Transitions

```
PENDING → CLAIMED
  Who: Specialist agent
  When: Implementation finished
  Evidence: Files created, claim made

CLAIMED → VERIFIED
  Who: verification-agent ONLY
  When: All verifications pass
  Evidence: Proofpack with verdict=PASSED

CLAIMED → BLOCKED
  Who: verification-agent ONLY
  When: Any verification fails
  Evidence: Proofpack with verdict=BLOCKED

BLOCKED → PENDING
  Who: workflow-orchestrator
  When: Ready to retry after fixes
  Evidence: Failure report reviewed

VERIFIED → COMPLETED
  Who: workflow-orchestrator
  When: quality-validator approves (if needed)
  Evidence: Final validation report
```

### Forbidden Transitions

```
❌ PENDING → COMPLETED
  Violation: Cannot skip implementation

❌ CLAIMED → COMPLETED
  Violation: Cannot skip verification (THIS IS THE CRITICAL ENFORCEMENT)

❌ PENDING → VERIFIED
  Violation: Cannot verify without implementation

❌ BLOCKED → COMPLETED
  Violation: Cannot complete with failed verifications

❌ VERIFIED → PENDING
  Violation: Cannot un-verify (must create new task)
```

---

## TodoWrite Integration

### Current TodoWrite Format

```javascript
{
  "content": "Implement login screen",
  "status": "pending" | "in_progress" | "completed",
  "activeForm": "Implementing login screen"
}
```

### Enhanced TodoWrite Format (Two-Phase Commit)

```javascript
{
  "content": "Implement login screen",
  "status": "pending" | "in_progress" | "claimed" | "verified" | "blocked" | "completed",
  "activeForm": "Implementing login screen",
  "phase": "implementation" | "verification" | "completion",
  "claimed_by": "swiftui-developer",
  "claimed_at": "2025-10-24T22:00:00Z",
  "verified_by": "verification-agent",
  "verified_at": "2025-10-24T22:05:00Z",
  "proofpack": ".orchestration/proofpacks/login-screen-20251024T220500Z.json"
}
```

**New Fields:**

- `status`: Now includes "claimed", "verified", "blocked" states
- `phase`: Current phase of work (implementation/verification/completion)
- `claimed_by`: Which agent claimed completion
- `claimed_at`: Timestamp of claim
- `verified_by`: verification-agent (only this agent can verify)
- `verified_at`: Timestamp of verification
- `proofpack`: Path to proof artifact

---

## Workflow Integration

### Phase 1: Implementation

**Specialist Agent (swiftui-developer, react-18-specialist, etc.):**

```markdown
1. Receive task from workflow-orchestrator
2. Implement feature
3. Create evidence files (screenshots, tests, etc.)
4. Mark TodoWrite status as "claimed":

   TodoWrite({
     content: "Implement login screen",
     status: "claimed",  ← NOT "completed"!
     phase: "verification",
     claimed_by: "swiftui-developer",
     claimed_at: new Date().toISOString()
   })

5. Report to workflow-orchestrator:
   "Implementation complete. Evidence created. Status: CLAIMED.
    Verification required before completion."
```

**CRITICAL:** Specialist CANNOT mark status as "completed". Only "claimed".

---

### Phase 2: Verification

**workflow-orchestrator:**

```markdown
1. Check all tasks for status="claimed"
2. For each claimed task:

   if (task.status === "claimed" && !task.verified_by) {
     dispatch verification-agent with:
       - Task ID
       - Completion criteria (from registry)
       - Evidence location
   }

3. verification-agent runs:
   - Load completion criteria
   - Run verification commands
   - Generate proofpack
   - Update TodoWrite:

   if (all_verifications_pass) {
     TodoWrite({
       ...task,
       status: "verified",
       verified_by: "verification-agent",
       verified_at: new Date().toISOString(),
       proofpack: "path/to/proofpack.json"
     })
   } else {
     TodoWrite({
       ...task,
       status: "blocked",
       verified_by: "verification-agent",
       verified_at: new Date().toISOString(),
       proofpack: "path/to/proofpack.json",
       failures: [...list of failed verifications]
     })
   }

4. workflow-orchestrator reads updated status:
   - If "verified" → Proceed to completion phase
   - If "blocked" → HARD BLOCK, report failures, wait for fixes
```

---

### Phase 3: Completion

**workflow-orchestrator:**

```markdown
1. Check all tasks for status="verified"
2. For each verified task:

   if (task.status === "verified") {
     // Optional: Dispatch quality-validator for final check
     dispatch quality-validator with task.proofpack

     // Mark as completed
     TodoWrite({
       ...task,
       status: "completed",
       phase: "completion",
       completed_at: new Date().toISOString()
     })
   }

3. Report to user:
   "Task completed with verification:
   - Implementation: swiftui-developer at 22:00:00
   - Verification: verification-agent at 22:05:00
   - Evidence: .orchestration/proofpacks/login-screen-20251024T220500Z.json"
```

---

## Enforcement Rules

### Rule 1: Specialists Cannot Verify Their Own Work

```javascript
// BLOCKED
if (task.status === "claimed" && task.claimed_by === "swiftui-developer") {
  // swiftui-developer CANNOT mark status="verified"
  throw new Error("Only verification-agent can mark tasks as verified");
}

// ALLOWED
if (verification-agent marks status="verified") {
  // This is the ONLY way to verify
}
```

### Rule 2: Cannot Skip Verification

```javascript
// BLOCKED
if (task.status === "claimed") {
  task.status = "completed";  // ❌ NOT ALLOWED
}

// ALLOWED
if (task.status === "claimed") {
  task.status = "verified";  // verification-agent only
}
if (task.status === "verified") {
  task.status = "completed";  // workflow-orchestrator
}
```

### Rule 3: Blocked Tasks Must Be Fixed

```javascript
// BLOCKED
if (task.status === "blocked") {
  task.status = "completed";  // ❌ NOT ALLOWED
  task.status = "verified";   // ❌ NOT ALLOWED
}

// ALLOWED
if (task.status === "blocked") {
  task.status = "pending";    // ✅ Reset for retry
  // Specialist must fix issues, reclaim, re-verify
}
```

---

## Example: Full Task Lifecycle

### Task: "Implement login screen for iOS app"

**Step 1: Dispatch (PENDING → in_progress)**

```javascript
TodoWrite({
  content: "Implement login screen",
  status: "in_progress",
  activeForm: "Implementing login screen",
  phase: "implementation",
  assigned_to: "swiftui-developer"
})
```

**Step 2: Implementation Complete (in_progress → CLAIMED)**

```javascript
// swiftui-developer finishes work
TodoWrite({
  content: "Implement login screen",
  status: "claimed",
  activeForm: "Verifying login screen implementation",
  phase: "verification",
  claimed_by: "swiftui-developer",
  claimed_at: "2025-10-24T22:00:00Z"
})
```

**Step 3: Verification Pass (CLAIMED → VERIFIED)**

```javascript
// verification-agent runs checks
// All deliverables met
TodoWrite({
  content: "Implement login screen",
  status: "verified",
  activeForm: "Completing login screen",
  phase: "completion",
  claimed_by: "swiftui-developer",
  claimed_at: "2025-10-24T22:00:00Z",
  verified_by: "verification-agent",
  verified_at: "2025-10-24T22:05:00Z",
  proofpack: ".orchestration/proofpacks/login-screen-20251024T220500Z.json"
})
```

**Step 4: Final Completion (VERIFIED → COMPLETED)**

```javascript
// workflow-orchestrator marks complete
TodoWrite({
  content: "Implement login screen",
  status: "completed",
  activeForm: "Login screen complete",
  phase: "completion",
  claimed_by: "swiftui-developer",
  claimed_at: "2025-10-24T22:00:00Z",
  verified_by: "verification-agent",
  verified_at: "2025-10-24T22:05:00Z",
  completed_at: "2025-10-24T22:10:00Z",
  proofpack: ".orchestration/proofpacks/login-screen-20251024T220500Z.json"
})
```

---

## Example: Verification Failure

### Task: "Implement dashboard UI"

**Step 1-2: Implementation and Claim (same as above)**

**Step 3: Verification Fail (CLAIMED → BLOCKED)**

```javascript
// verification-agent runs checks
// 3 deliverables failed
TodoWrite({
  content: "Implement dashboard UI",
  status: "blocked",
  activeForm: "Dashboard UI verification failed",
  phase: "verification",
  claimed_by: "react-18-specialist",
  claimed_at: "2025-10-24T22:00:00Z",
  verified_by: "verification-agent",
  verified_at: "2025-10-24T22:05:00Z",
  proofpack: ".orchestration/proofpacks/dashboard-ui-20251024T220500Z.json",
  failures: [
    "browser_screenshot - Screenshot missing",
    "component_tests - 3 tests failing",
    "visual_review - /visual-review not run"
  ]
})
```

**Step 4: HARD BLOCK**

```markdown
workflow-orchestrator:
  Reads task.status === "blocked"

  Report to user:
  "🚫 TASK BLOCKED - Verification Failed

  Task: Implement dashboard UI
  Claimed by: react-18-specialist at 22:00:00
  Verified by: verification-agent at 22:05:00

  Failed verifications (3):
  1. browser_screenshot - Screenshot missing
  2. component_tests - 3 tests failing
  3. visual_review - /visual-review not run

  Evidence: .orchestration/proofpacks/dashboard-ui-20251024T220500Z.json

  Required actions:
  1. Fix all 3 failed verifications
  2. Task will be reset to PENDING
  3. React-18-specialist must re-implement
  4. Verification will run again

  Workflow cannot proceed until ALL verifications pass."

  STOP HERE
```

**Step 5: Reset for Retry (BLOCKED → PENDING)**

```javascript
// After user reviews failures
TodoWrite({
  content: "Implement dashboard UI",
  status: "pending",
  activeForm: "Implementing dashboard UI (retry after failures)",
  phase: "implementation",
  previous_attempt: {
    claimed_by: "react-18-specialist",
    failures: [...]
  }
})
```

---

## Benefits

### 1. Impossible to Skip Verification

**Before Two-Phase Commit:**
```
Specialist: "I'm done" → Marks completed → No verification
```

**After Two-Phase Commit:**
```
Specialist: "I'm done" → Marks claimed → verification-agent MUST run → Then completed
```

### 2. Clear Accountability

Every task has audit trail:
- Who implemented (claimed_by)
- When claimed (claimed_at)
- Who verified (verified_by)
- When verified (verified_at)
- Where's the evidence (proofpack)

### 3. Explicit Failures

BLOCKED state makes failures explicit:
- User sees exactly what failed
- Can't proceed without fixing
- Audit trail preserved in proofpack

### 4. Separation of Concerns

- **Specialists:** Focus on implementation
- **verification-agent:** Focus on verification
- **workflow-orchestrator:** Focus on coordination

---

## Impact on False Completion Rate

**Current:** ~50-60% after Stage 1 enforcement

**After Two-Phase Commit:** Expected **25-35%**

**Why:**
- Stage 1: Prevents skipping verification entirely
- Stage 2: Prevents claiming without verification passing
- Net effect: Verification MUST pass for completion

---

## Backward Compatibility

**Old TodoWrite format still works:**
```javascript
{
  "content": "Task",
  "status": "completed",  // Maps to "completed" in new system
  "activeForm": "Task"
}
```

**New format is optional:**
```javascript
{
  "content": "Task",
  "status": "verified",  // Uses new state machine
  "claimed_by": "...",   // Optional metadata
  "proofpack": "..."     // Optional evidence link
}
```

---

## Related Documentation

- **workflow-orchestrator.md** - Enforcement of two-phase commit
- **verification-agent.md** - How verification updates task status
- **.orchestration/completion-criteria/** - What gets verified
- **.orchestration/proofpacks/** - Evidence artifacts

---

**Last Updated:** 2025-10-24 (Stage 2 Week 3)
**Next Update:** Stage 3 (Quality Validator Checklist integration)
