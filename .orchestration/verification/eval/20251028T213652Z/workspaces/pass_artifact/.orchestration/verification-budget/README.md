# Verification Budget - Mandatory Token Allocation

**Purpose:** Prevent verification from being skipped due to token exhaustion

**Version:** 1.0.0 (Stage 3 Week 5)

---

## Overview

The Verification Budget system **reserves 20% of token budget for verification activities**, preventing the common failure mode where implementation consumes all tokens and verification gets skipped.

**Philosophical Position:** If you can't afford to verify, you can't afford to implement. Verification is not optional overhead—it's mandatory quality assurance.

---

## The Problem

**Scenario: Token Budget Exhaustion**

```
Session starts with 200,000 token budget

Implementation phase:
  workflow-orchestrator → 5,000 tokens
  requirement-analyst → 15,000 tokens
  system-architect → 20,000 tokens
  swiftui-developer → 50,000 tokens
  ui-engineer → 40,000 tokens
  design-compiler → 25,000 tokens

Total implementation: 155,000 tokens (77.5% of budget)

Remaining: 45,000 tokens (22.5%)

Verification phase:
  verification-agent → 30,000 tokens
  Behavioral oracle execution → 10,000 tokens
  Screenshot diff → 2,000 tokens
  quality-validator → 8,000 tokens

Total verification needed: 50,000 tokens
Budget remaining: 45,000 tokens

Result: ❌ BUDGET EXHAUSTED - Verification incomplete
```

**Outcome:** Implementation proceeds without full verification → False completion

---

## The Solution: Reserved Verification Budget

**Budget allocation model:**

```
Total budget: 200,000 tokens

Reserved for verification (20%): 40,000 tokens
Available for implementation (80%): 160,000 tokens
```

**Enforcement:**

1. **Implementation phase** can use up to 160,000 tokens (80%)
2. **Verification phase** has guaranteed 40,000 tokens (20%)
3. If implementation attempts to exceed 80%, **BLOCK and prompt budget increase**

**Result:** Verification always has sufficient budget to complete.

---

## Budget Allocation Formula

```
Total Budget (T) = User-specified session budget (default: 200,000 tokens)

Verification Reserve (V) = T × 0.20 (20%)
Implementation Budget (I) = T × 0.80 (80%)

Enforcement:
  IF implementation_tokens_used > I:
    BLOCK implementation
    REQUEST budget increase OR simplification
```

**Example budgets:**

| Total Budget | Implementation (80%) | Verification (20%) |
|--------------|---------------------|-------------------|
| 100,000      | 80,000             | 20,000            |
| 200,000      | 160,000            | 40,000            |
| 300,000      | 240,000            | 60,000            |
| 500,000      | 400,000            | 100,000           |

---

## Budget Tracking

**Location:** `.orchestration/verification-budget/budget-tracker.json`

**Schema:**

```json
{
  "session_id": "session-20251024T220000Z",
  "total_budget": 200000,
  "verification_reserve": 40000,
  "implementation_budget": 160000,
  "usage": {
    "implementation": {
      "workflow-orchestrator": 5000,
      "requirement-analyst": 15000,
      "system-architect": 20000,
      "swiftui-developer": 50000,
      "ui-engineer": 40000,
      "design-compiler": 25000,
      "total": 155000
    },
    "verification": {
      "verification-agent": 30000,
      "behavioral-oracles": 10000,
      "screenshot-diff": 2000,
      "quality-validator": 8000,
      "total": 50000
    }
  },
  "budget_status": {
    "implementation_remaining": 5000,
    "implementation_utilization": 0.969,
    "verification_remaining": -10000,
    "verification_utilization": 1.25,
    "overall_utilization": 1.025,
    "status": "OVER_BUDGET"
  },
  "warnings": [
    "Verification phase exceeded reserve by 10,000 tokens",
    "Overall budget exceeded by 5,000 tokens"
  ]
}
```

---

## Workflow Integration

### Implementation Phase Budget Check

**workflow-orchestrator enforces implementation budget:**

```markdown
# workflow-orchestrator.md (Budget Gate)

## Budget Gate: Before Specialist Dispatch

READ: .orchestration/verification-budget/budget-tracker.json

CALCULATE:
  implementation_tokens_used = SUM(all implementation specialist tokens)
  implementation_budget = total_budget × 0.80

IF implementation_tokens_used > implementation_budget:
  ❌ BUDGET GATE BLOCKED

  Report to user:
    "🚫 IMPLEMENTATION BUDGET EXCEEDED

    Implementation tokens used: {implementation_tokens_used}
    Implementation budget (80%): {implementation_budget}
    Remaining for verification: {verification_reserve}

    Options:
      A) Increase total budget (current: {total_budget})
      B) Simplify implementation (reduce specialist usage)
      C) Defer some features to next session

    Cannot proceed without budget adjustment or simplification."

  STOP HERE - Do not dispatch more specialists
```

### Verification Phase Budget Check

**workflow-orchestrator checks verification budget before verification:**

```markdown
# workflow-orchestrator.md (Verification Budget Gate)

## Budget Gate: Before Verification

READ: .orchestration/verification-budget/budget-tracker.json

CALCULATE:
  verification_budget = total_budget × 0.20
  verification_tokens_available = verification_budget

IF verification_tokens_available < 10000:
  ⚠️ VERIFICATION BUDGET WARNING

  Report to user:
    "⚠️ VERIFICATION BUDGET LOW

    Verification budget: {verification_budget}
    Estimated verification cost: 40,000 tokens
    Shortfall: {40000 - verification_budget}

    Options:
      A) Increase total budget
      B) Run minimal verification (tests only, skip design review)
      C) Accept risk of incomplete verification

    Recommendation: Increase budget to ensure full verification."
```

---

## Budget Monitoring Script

**Location:** `.orchestration/verification-budget/track-budget.sh`

**Usage:**

```bash
# Initialize budget for session
./orchestration/verification-budget/track-budget.sh \
  --session-id session-20251024T220000Z \
  --total-budget 200000

# Record specialist token usage
./orchestration/verification-budget/track-budget.sh \
  --session-id session-20251024T220000Z \
  --specialist swiftui-developer \
  --tokens 50000 \
  --phase implementation

# Check budget status
./orchestration/verification-budget/track-budget.sh \
  --session-id session-20251024T220000Z \
  --check
```

**Output:**

```
Budget Status for session-20251024T220000Z:

Total Budget: 200,000 tokens
Implementation Budget (80%): 160,000 tokens
Verification Reserve (20%): 40,000 tokens

Implementation Usage:
  workflow-orchestrator: 5,000
  requirement-analyst: 15,000
  system-architect: 20,000
  swiftui-developer: 50,000
  ui-engineer: 40,000
  design-compiler: 25,000
  ─────────────────────────
  Total: 155,000 / 160,000 (96.9%)
  Remaining: 5,000 tokens

Verification Usage:
  (not yet started)
  Reserved: 40,000 tokens

Overall Status: ✅ WITHIN BUDGET
```

---

## Budget Phases

### Phase 1: Planning (5% of total)

**Agents:** requirement-analyst, system-architect, plan-synthesis-agent

**Budget:** 10,000 tokens (5% of 200,000)

**Purpose:** Requirements, architecture, planning

### Phase 2: Implementation (75% of total)

**Agents:** All implementation specialists (swiftui-developer, ui-engineer, backend-engineer, etc.)

**Budget:** 150,000 tokens (75% of 200,000)

**Purpose:** Code generation, design compilation, feature implementation

### Phase 3: Verification (20% of total)

**Agents:** verification-agent, quality-validator

**Systems:** Behavioral oracles, screenshot diff, design review, accessibility audit

**Budget:** 40,000 tokens (20% of 200,000)

**Purpose:** Testing, validation, evidence collection, quality gates

**Total:** 100% (Planning 5% + Implementation 75% + Verification 20%)

---

## Budget Enforcement Levels

### Level 1: Soft Warning (90% of phase budget)

```
Implementation at 144,000 / 160,000 tokens (90%)

⚠️ WARNING: Implementation budget at 90%
Remaining: 16,000 tokens
Consider wrapping up implementation to reserve budget for verification.
```

**Action:** Warning only, no blocking

### Level 2: Hard Block (100% of phase budget)

```
Implementation at 160,000 / 160,000 tokens (100%)

❌ BLOCKED: Implementation budget exhausted
Verification reserve: 40,000 tokens (protected)

Cannot dispatch more implementation specialists.
Must increase budget or simplify implementation.
```

**Action:** Block further implementation, protect verification reserve

### Level 3: Emergency Reserve (verification at risk)

```
Overall tokens used: 195,000 / 200,000 (97.5%)
Verification completed: 35,000 / 40,000 tokens
Remaining: 5,000 tokens

⚠️ EMERGENCY: Near total budget exhaustion
Verification incomplete, only 5,000 tokens remaining.

Minimal verification: Tests only, skip design review.
```

**Action:** Run minimal verification to stay within total budget

---

## Dynamic Budget Adjustment

**User can adjust budget mid-session:**

```bash
# User realizes implementation needs more budget
./orchestration/verification-budget/track-budget.sh \
  --session-id session-20251024T220000Z \
  --adjust-total-budget 300000

# Recalculates:
# Implementation: 240,000 (80%)
# Verification: 60,000 (20%)
```

**Prevents:**
- Running out of tokens mid-implementation
- Skipping verification due to budget constraints

---

## Budget Failure Modes

### Failure Mode 1: Implementation Overage

**Scenario:** Implementation specialists exceed 80% budget

**Prevention:**
- workflow-orchestrator tracks cumulative token usage
- Blocks specialist dispatch when approaching 80%
- Prompts user to increase budget or simplify

**Result:** Verification budget protected

### Failure Mode 2: Verification Complexity Underestimated

**Scenario:** Verification needs more than 20% (complex testing, many oracles)

**Prevention:**
- Initial budget sizing includes verification estimate
- User can pre-allocate larger verification budget (e.g., 30% for complex features)
- Dynamic adjustment mid-session

**Example:**
```bash
# Complex feature with extensive testing needs
./orchestration/verification-budget/track-budget.sh \
  --session-id session-20251024T220000Z \
  --total-budget 300000 \
  --verification-percentage 30

# Results in:
# Implementation: 210,000 (70%)
# Verification: 90,000 (30%)
```

### Failure Mode 3: Total Budget Exhaustion

**Scenario:** Both implementation and verification exceed budgets

**Prevention:**
- Set realistic total budget based on task complexity
- Monitor budget status continuously
- Early warning at 90% utilization

**Mitigation:**
- Increase total budget
- Run minimal verification (tests only)
- Defer non-critical features to next session

---

## Budget Best Practices

### 1. Size Budget Appropriately

**Small features:** 100,000 tokens (20,000 for verification)
**Medium features:** 200,000 tokens (40,000 for verification)
**Large features:** 300,000+ tokens (60,000+ for verification)

### 2. Monitor Budget Early

Check budget status after each specialist dispatch:

```bash
./orchestration/verification-budget/track-budget.sh --check
```

### 3. Protect Verification Reserve

Never compromise the 20% verification reserve unless absolutely necessary. Verification skipping → false completions.

### 4. Plan for Verification Complexity

**High verification needs:**
- UI features → Screenshot diff, design review, accessibility audit
- APIs → Behavioral oracles, performance benchmarks, security scans
- Complex workflows → Multiple oracle types, integration tests

**Adjust verification percentage upward if needed** (25-30%).

---

## Integration with Cost Tracking

**Budget tracker integrates with `.orchestration/costs.json`:**

```json
{
  "session": "session-20251024T220000Z",
  "budget": {
    "total": 200000,
    "implementation": 160000,
    "verification": 40000
  },
  "actual_usage": {
    "implementation": 155000,
    "verification": 50000,
    "total": 205000
  },
  "overages": {
    "verification": 10000,
    "total": 5000
  }
}
```

**Feeds into Agent Skill Vectors:**
- Specialists consistently exceeding budgets → Lower efficiency score
- Specialists staying within budgets → Higher efficiency score

---

## Impact on False Completion Rate

**Current (Stage 3 before budget):** ~10-15% false completion rate

**After Verification Budget:** Expected **8-12%**

**Why:**
- Prevents "out of tokens, skip verification" scenario
- Ensures verification always completes
- Reduces partial verification (tests run but design review skipped)

**Remaining false completions:**
- Bugs that pass verification (logic errors)
- Edge cases not covered by tests
- Integration issues not caught by isolated testing

---

## Example Budget Scenarios

### Scenario 1: Small iOS UI Feature

**Task:** Add settings toggle

**Budget plan:**
- Total: 100,000 tokens
- Implementation (80%): 80,000 tokens
  - swiftui-developer: 40,000
  - state-architect: 20,000
  - design-compiler: 15,000
- Verification (20%): 20,000 tokens
  - XCUITest oracle: 10,000
  - Screenshot diff: 2,000
  - quality-validator: 8,000

**Outcome:** ✅ All phases complete within budget

### Scenario 2: Complex Frontend Dashboard

**Task:** Build analytics dashboard with 10+ charts

**Budget plan:**
- Total: 300,000 tokens
- Implementation (75%): 225,000 tokens
  - react-18-specialist: 80,000
  - ui-engineer: 60,000
  - state-management-specialist: 40,000
  - design-compiler: 30,000
  - frontend-performance-specialist: 15,000
- Verification (25%): 75,000 tokens
  - Playwright oracles: 30,000
  - Screenshot diff (10 viewports): 10,000
  - Design review: 15,000
  - Accessibility audit: 10,000
  - Performance tests: 10,000

**Note:** Higher verification percentage (25%) due to complexity

**Outcome:** ✅ All phases complete with adequate verification

### Scenario 3: Backend API with Security Requirements

**Task:** Authentication system with OAuth, JWT, security scanning

**Budget plan:**
- Total: 250,000 tokens
- Implementation (80%): 200,000 tokens
  - backend-engineer: 100,000
  - system-architect: 50,000
  - infrastructure-engineer: 40,000
- Verification (20%): 50,000 tokens
  - curl oracles: 15,000
  - Security scanning: 15,000
  - Performance benchmarks: 10,000
  - quality-validator: 10,000

**Outcome:** ✅ All security verification completes

---

## Future Enhancements

### Stage 4+

**Adaptive Budget Allocation:**
- ML model predicts verification cost based on task complexity
- Automatically adjusts verification percentage (15-30%)
- Learns from historical budget usage

**Budget Optimization:**
- Identify redundant verification steps
- Parallelize oracles to reduce total cost
- Cache verification results for unchanged code

**Budget Rollover:**
- Unused verification budget → Next session verification reserve
- Prevents "use it or lose it" wasteful token spending

---

## Related Documentation

- **Completion Criteria Registry** (.orchestration/completion-criteria/README.md) - Defines verification requirements
- **Behavioral Oracles** (.orchestration/oracles/README.md) - Verification execution
- **Quality Validator Checklist** (.orchestration/quality-checklist/README.md) - Binary validation
- **Agent Skill Vectors** (.orchestration/agent-skill-vectors/README.md) - Cost tracking per specialist

---

**Last Updated:** 2025-10-24 (Stage 3 Week 5)
**Next Update:** Stage 4 (Adaptive budget allocation, ML-based cost prediction)
