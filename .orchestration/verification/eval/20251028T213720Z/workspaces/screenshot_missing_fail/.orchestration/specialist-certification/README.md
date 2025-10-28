# Specialist Certification - Performance Tracking and Blacklisting

**Purpose:** Data-driven specialist selection based on historical performance

**Version:** 1.0.0 (Stage 3 Week 6)

---

## Overview

The Specialist Certification system tracks **performance metrics for each specialist agent** and uses data-driven thresholds to determine which specialists can be dispatched for new tasks.

**Philosophical Position:** Past performance predicts future results. Specialists with consistent failures should be blocked from tasks until performance improves.

---

## The Problem

**Current specialist selection (no performance tracking):**

```
User: "Build iOS login screen"

workflow-orchestrator selects:
  - swiftui-developer (no performance data)
  - state-architect (no performance data)
  - design-compiler (no performance data)

Result: Dispatches specialists blindly, regardless of past performance
```

**What if:**
- swiftui-developer failed last 5 tasks (bugs, incomplete implementations)?
- state-architect consistently violates architecture principles?
- design-compiler generates code that fails design review?

**Result:** Dispatch poor performers → predictable failure → wasted tokens

---

## The Solution: Certification Levels

**Performance-based certification:**

```
Specialist: swiftui-developer
Performance history: 15 tasks
  - Succeeded: 12 tasks
  - Failed: 3 tasks
  - Success rate: 80%

Certification: ✅ CERTIFIED (≥70% threshold)
Status: Eligible for dispatch
```

**Three certification levels:**

| Level | Success Rate | Status | Dispatch Eligibility |
|-------|-------------|--------|---------------------|
| **CERTIFIED** | ≥70% | ✅ Good standing | Eligible for all tasks |
| **PROBATION** | 50-69% | ⚠️ Under review | Limited dispatch (simple tasks only) |
| **BLOCKED** | <50% | ❌ Blocked | Not eligible for dispatch until improvement |

---

## Performance Tracking

**Location:** `.orchestration/costs.json` (schema v2.0.0 with skill vectors)

**Metrics tracked per specialist:**

```json
{
  "specialist_id": "swiftui-developer",
  "skill_vector": {
    "success_rate": 0.80,
    "tasks_completed": 15,
    "tasks_failed": 3,
    "average_cost_tokens": 42000,
    "domains": ["ios-ui", "swiftui", "ios15+"],
    "domain_vector": [0.9, 0.85, 0.8, ...],
    "performance_trend": "improving",
    "last_10_tasks": [
      {"task_id": "login-screen-001", "verdict": "PASSED", "cost": 40000},
      {"task_id": "settings-view-002", "verdict": "PASSED", "cost": 38000},
      {"task_id": "dashboard-003", "verdict": "FAILED", "cost": 50000},
      {"task_id": "profile-screen-004", "verdict": "PASSED", "cost": 42000},
      ...
    ],
    "certification": {
      "level": "CERTIFIED",
      "since": "2025-10-20T14:00:00Z",
      "review_date": "2025-11-20T14:00:00Z"
    }
  }
}
```

### Key Metrics

1. **success_rate** - Percentage of tasks that passed verification (most important)
2. **tasks_completed** - Total number of tasks assigned
3. **tasks_failed** - Total number of tasks that failed verification
4. **average_cost_tokens** - Average token usage per task (efficiency)
5. **performance_trend** - "improving" | "stable" | "declining"
6. **last_10_tasks** - Recent task history with verdicts
7. **certification** - Current certification level and dates

---

## Certification Thresholds

### CERTIFIED (≥70% Success Rate)

**Criteria:**
- Success rate ≥ 70%
- Minimum 5 tasks completed (to establish baseline)
- No critical failures in last 3 tasks

**Privileges:**
- Eligible for all task types
- Normal priority in team selection
- No restrictions

**Example:**
```
swiftui-developer:
  15 tasks completed
  12 passed (80%)
  3 failed
  → CERTIFIED ✅
```

### PROBATION (50-69% Success Rate)

**Criteria:**
- Success rate 50-69%
- OR: 2+ consecutive failures
- OR: Critical failure (security vulnerability, data loss)

**Restrictions:**
- Limited to simple tasks (difficulty ≤ 3/10)
- Not eligible for critical features
- Requires additional verification
- Monitored closely for 5 more tasks

**Example:**
```
backend-engineer:
  10 tasks completed
  6 passed (60%)
  4 failed
  → PROBATION ⚠️

Allowed: Simple CRUD endpoints
Not allowed: Authentication, payment processing
```

### BLOCKED (<50% Success Rate)

**Criteria:**
- Success rate < 50%
- OR: 3+ consecutive failures
- OR: Multiple critical failures

**Restrictions:**
- **Not eligible for any dispatch**
- Blocked from team selection
- Must undergo review and improvement
- Can be unblocked after demonstration of improvement

**Example:**
```
frontend-engineer:
  8 tasks completed
  3 passed (37.5%)
  5 failed
  → BLOCKED ❌

Status: Cannot be dispatched until performance improves
Required: Manual review and re-certification
```

---

## Blacklisting Mechanism

**How blacklisting works:**

1. **Performance degrades** → Specialist drops below 50% success rate
2. **Certification updated** → Level changed to BLOCKED
3. **Dispatch prevention** → workflow-orchestrator checks certification before dispatch
4. **Blacklist enforcement** → If specialist is BLOCKED, skip and select alternative

**Example workflow:**

```
workflow-orchestrator selecting team for "Build dashboard":

Available specialists:
  - ui-engineer (SUCCESS_RATE: 0.85, CERTIFIED) ✅
  - frontend-engineer (SUCCESS_RATE: 0.38, BLOCKED) ❌ SKIP
  - react-18-specialist (SUCCESS_RATE: 0.72, CERTIFIED) ✅

Team selected:
  - ui-engineer (not blocked)
  - react-18-specialist (not blocked)

frontend-engineer NOT dispatched (blacklisted due to poor performance)
```

---

## Integration with workflow-orchestrator

**Modified team selection logic:**

```markdown
# workflow-orchestrator.md (Certification Check)

## Specialist Selection with Certification

FOR each potential specialist:

  1. READ certification from costs.json:
     certification_level = costs.json[specialist]["skill_vector"]["certification"]["level"]

  2. CHECK certification level:
     IF certification_level == "BLOCKED":
       ❌ SKIP this specialist (blacklisted)
       LOG: "Specialist {specialist} blocked due to poor performance (success_rate < 50%)"
       CONTINUE to next candidate

     IF certification_level == "PROBATION":
       IF task_difficulty > 3:
         ⚠️ SKIP this specialist (restricted to simple tasks)
         LOG: "Specialist {specialist} on probation, not eligible for complex tasks"
         CONTINUE to next candidate
       ELSE:
         ✅ ALLOW dispatch with additional verification

     IF certification_level == "CERTIFIED":
       ✅ ALLOW dispatch (no restrictions)

  3. SELECT specialist if not blocked/restricted
```

---

## Performance Update Process

**After each task completion:**

1. **verification-agent completes** → Verdict: PASSED or BLOCKED
2. **Update costs.json** → Increment tasks_completed, update success_rate
3. **Recalculate certification** → Check if success_rate crosses threshold
4. **Update certification level** → CERTIFIED / PROBATION / BLOCKED
5. **Log certification change** → If level changed, log event

**Script:** `.orchestration/specialist-certification/update-performance.sh`

**Usage:**
```bash
./orchestration/specialist-certification/update-performance.sh \
  --specialist swiftui-developer \
  --task-id login-screen-20251024T220000Z \
  --verdict PASSED \
  --cost 42000
```

**Output:**
```
✅ Performance updated

Specialist: swiftui-developer
Task: login-screen-20251024T220000Z
Verdict: PASSED
Cost: 42,000 tokens

Updated metrics:
  Tasks completed: 16 (was 15)
  Tasks failed: 3 (unchanged)
  Success rate: 81.25% (was 80%)

Certification: CERTIFIED (no change)
```

---

## Certification Review Process

**Automatic review triggers:**

1. **Success rate crosses threshold**
   - 70% → 69%: CERTIFIED → PROBATION
   - 50% → 49%: PROBATION → BLOCKED
   - 69% → 70%: PROBATION → CERTIFIED

2. **Consecutive failures**
   - 2 consecutive: → PROBATION (regardless of overall rate)
   - 3 consecutive: → BLOCKED (regardless of overall rate)

3. **Critical failures**
   - Security vulnerability: → PROBATION immediately
   - Data loss: → BLOCKED immediately
   - Multiple critical: → BLOCKED permanently (requires manual review)

4. **Monthly review**
   - All specialists reviewed on 1st of month
   - Performance trends analyzed
   - Certification levels adjusted if needed

---

## Performance Trends

**Trend calculation (last 10 tasks):**

```
Recent 5 tasks: [PASS, PASS, PASS, FAIL, PASS] = 80%
Previous 5 tasks: [FAIL, PASS, FAIL, PASS, PASS] = 60%

Trend: 80% > 60% → "improving"
```

**Trend categories:**

- **improving**: Recent 5 tasks success rate > previous 5 tasks
- **stable**: Recent 5 tasks ≈ previous 5 tasks (within 10%)
- **declining**: Recent 5 tasks success rate < previous 5 tasks

**Impact on certification:**

- **Declining + PROBATION** → Expedited review (may lead to BLOCKED)
- **Improving + PROBATION** → May expedite return to CERTIFIED
- **Declining + CERTIFIED** → Early warning (may lead to PROBATION)

---

## Unblocking Process

**How to unblock a BLOCKED specialist:**

1. **Manual review**
   - Analyze failure patterns
   - Identify root causes (bugs, incomplete knowledge, etc.)
   - Document improvements needed

2. **Improvement demonstration**
   - Specialist completes 3 test tasks successfully
   - Test tasks reviewed manually
   - Performance metrics updated

3. **Re-certification**
   - If 3/3 test tasks pass → Upgrade to PROBATION
   - If 5/5 additional tasks pass → Upgrade to CERTIFIED
   - If any test task fails → Remain BLOCKED, require more improvement

**Script:** `.orchestration/specialist-certification/unblock-specialist.sh`

**Usage:**
```bash
# Manual unblock after review
./orchestration/specialist-certification/unblock-specialist.sh \
  --specialist frontend-engineer \
  --new-level PROBATION \
  --reviewer "human-operator" \
  --reason "Completed 3 test tasks successfully, demonstrated improvement"
```

---

## Certification Dashboard

**View certification status of all specialists:**

```bash
./orchestration/specialist-certification/certification-status.sh
```

**Output:**

```
========================================
Specialist Certification Status
========================================

✅ CERTIFIED (Success Rate ≥ 70%):
  swiftui-developer (80%, 15 tasks)
  ui-engineer (85%, 20 tasks)
  react-18-specialist (72%, 12 tasks)
  backend-engineer (75%, 18 tasks)

⚠️ PROBATION (Success Rate 50-69%):
  design-compiler (65%, 10 tasks) - TREND: improving
  state-architect (58%, 8 tasks) - TREND: stable

❌ BLOCKED (Success Rate < 50%):
  frontend-engineer (38%, 8 tasks) - TREND: declining
  tailwind-specialist (45%, 6 tasks) - TREND: declining

Total specialists: 8
Certified: 4 (50%)
Probation: 2 (25%)
Blocked: 2 (25%)

⚠️ WARNING: 2 specialists blocked from dispatch
```

---

## Use Cases

### Use Case 1: Preventing Poor Performer Dispatch

**Scenario:** frontend-engineer has 37.5% success rate (3/8 tasks passed)

**Certification:** BLOCKED

**User request:** "Build analytics dashboard"

**workflow-orchestrator behavior:**

```
Analyzing task: frontend-ui (analytics dashboard)

Candidate specialists:
  1. ui-engineer (SUCCESS_RATE: 0.85, CERTIFIED) ✅
  2. frontend-engineer (SUCCESS_RATE: 0.375, BLOCKED) ❌ SKIP
  3. react-18-specialist (SUCCESS_RATE: 0.72, CERTIFIED) ✅

Selected team:
  - ui-engineer (certified, 85% success rate)
  - react-18-specialist (certified, 72% success rate)

frontend-engineer NOT selected (blacklisted due to poor performance)
```

**Result:** Poor performer avoided, higher chance of success

---

### Use Case 2: Probation Restriction

**Scenario:** design-compiler has 65% success rate (on probation)

**User request:** "Build complex state-first architecture for iOS app"

**Task difficulty:** 8/10 (complex)

**workflow-orchestrator behavior:**

```
Analyzing task: ios-architecture (complex)

Candidate: design-compiler (SUCCESS_RATE: 0.65, PROBATION)

Certification check:
  Level: PROBATION
  Task difficulty: 8/10
  Restriction: PROBATION specialists limited to difficulty ≤ 3/10

  ❌ SKIP design-compiler (probation restrictions apply)

Alternative: system-architect (SUCCESS_RATE: 0.88, CERTIFIED)
  ✅ SELECT system-architect
```

**Result:** Probationary specialist not assigned complex task, reducing failure risk

---

### Use Case 3: Consecutive Failure Auto-Probation

**Scenario:** swiftui-developer has 80% overall success rate but last 2 tasks failed

**Task history:**
```
Task 13: PASS
Task 14: PASS
Task 15: FAIL
Task 16: FAIL ← 2 consecutive failures
```

**Automatic certification update:**

```
Consecutive failure trigger detected:
  Last 2 tasks: FAIL, FAIL
  Overall success rate: 80% (still above 70%)

Auto-downgrade:
  Previous: CERTIFIED
  New: PROBATION
  Reason: 2 consecutive failures

Restrictions applied:
  - Limited to simple tasks (difficulty ≤ 3)
  - Additional verification required
  - Under review for next 5 tasks
```

**Result:** Even high-performing specialists can be temporarily restricted after consecutive failures

---

### Use Case 4: Performance Improvement → Re-Certification

**Scenario:** design-compiler on PROBATION (65% success rate) improves

**Recent 5 tasks:**
```
Task 11: PASS
Task 12: PASS
Task 13: PASS
Task 14: PASS
Task 15: PASS ← 5 consecutive passes
```

**Updated metrics:**
```
Previous success rate: 65% (on PROBATION)
New success rate: 75% (after 5 passes)

Certification review:
  Success rate: 75% > 70% threshold
  Recent trend: 100% (5/5 recent tasks)
  Performance trend: improving

Auto-upgrade:
  Previous: PROBATION
  New: CERTIFIED
  Reason: Success rate exceeded 70%, consistent improvement
```

**Result:** Specialist re-certified after demonstrating improvement

---

## Impact on False Completion Rate

**Current (Stage 3 before certification):** ~8-12% false completion rate

**After Specialist Certification:** Expected **6-10%**

**Why:**
- Blocks consistently poor-performing specialists
- Prevents dispatch of specialists known to fail
- Restricts probationary specialists to appropriate difficulty
- Data-driven team selection

**Remaining false completions:**
- Novel failure modes not seen in training data
- Edge cases that pass verification but fail in production
- Integration issues between multiple specialists

---

## Best Practices

### 1. Require Minimum Task Count

Don't certify/block based on too few tasks:

**Good:**
```
swiftui-developer: 15 tasks, 80% success → CERTIFIED ✅
```

**Bad (insufficient data):**
```
new-specialist: 2 tasks, 50% success → BLOCKED ❌ (premature)
```

**Minimum thresholds:**
- CERTIFIED: Minimum 5 tasks
- PROBATION: Minimum 3 tasks
- BLOCKED: Minimum 5 tasks (unless critical failures)

### 2. Consider Performance Trends

Don't just look at overall rate, look at trends:

**Example 1:**
```
Overall: 68% (PROBATION threshold)
Recent 5 tasks: 100% (improving trend)
→ Consider early upgrade to CERTIFIED
```

**Example 2:**
```
Overall: 72% (CERTIFIED threshold)
Recent 5 tasks: 40% (declining trend)
→ Consider early downgrade to PROBATION
```

### 3. Review Critical Failures Immediately

Single critical failure → Immediate review:

```
backend-engineer: 85% overall success (CERTIFIED)
Latest task: SQL injection vulnerability (CRITICAL FAILURE)

Immediate action:
  → Downgrade to PROBATION
  → Manual review required
  → Not eligible for authentication/security tasks
```

### 4. Use Task Difficulty Appropriately

Match specialist certification to task difficulty:

| Task Difficulty | CERTIFIED | PROBATION | BLOCKED |
|----------------|-----------|-----------|---------|
| Simple (1-3) | ✅ Yes | ✅ Yes | ❌ No |
| Medium (4-6) | ✅ Yes | ❌ No | ❌ No |
| Complex (7-10) | ✅ Yes | ❌ No | ❌ No |

---

## Certification Schema

**Location:** `.orchestration/costs.json` (skill_vector.certification field)

```json
{
  "certification": {
    "level": "CERTIFIED|PROBATION|BLOCKED",
    "since": "2025-10-24T14:00:00Z",
    "review_date": "2025-11-24T14:00:00Z",
    "restrictions": [
      "max_difficulty: 3",
      "requires_additional_verification: true"
    ],
    "review_notes": "Consecutive failures detected, downgraded to PROBATION",
    "reviewer": "automatic|human-operator"
  }
}
```

---

## Directory Structure

```
.orchestration/specialist-certification/
├── README.md (this file)
├── update-performance.sh (update metrics after task)
├── certification-status.sh (view all certifications)
├── unblock-specialist.sh (manual unblock)
└── calculate-certification.sh (recalculate certification level)
```

---

## Future Enhancements

### Stage 4+

**Domain-Specific Certification:**
- Specialist certified for ios-ui but not ios-logic
- Fine-grained certification per skill area

**Team Composition Scoring:**
- Entire team success rate (not just individual specialists)
- Avoid combinations known to conflict

**Apprenticeship System:**
- BLOCKED specialists learn from CERTIFIED specialists
- Probationary specialists mentored by high performers

**Predictive Failure Detection:**
- ML model predicts task failure probability based on specialist history + task characteristics
- Pre-emptively switch specialists before failure occurs

---

## Related Documentation

- **Agent Skill Vectors** (.orchestration/agent-skill-vectors/README.md) - Performance tracking foundation
- **Completion Criteria Registry** (.orchestration/completion-criteria/README.md) - Defines success/failure
- **Quality Validator Checklist** (.orchestration/quality-checklist/README.md) - Binary pass/fail
- **workflow-orchestrator agent** (agents/orchestration/workflow-orchestrator.md) - Team selection with certification checks

---

**Last Updated:** 2025-10-24 (Stage 3 Week 6)
**Next Update:** Stage 4 (Domain-specific certification, team composition scoring)
