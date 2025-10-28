# Quality Validator Checklist - Binary Pass/Fail Validation

**Purpose:** Deterministic quality gate using completion criteria registry

**Version:** 1.0.0 (Stage 3 Week 5)

---

## Overview

The Quality Validator Checklist is a **binary pass/fail system** that quality-validator uses to make approval decisions. It eliminates subjective judgment by providing concrete, verifiable checkpoints derived from the completion criteria registry.

**Philosophical Position:** Quality validation should be deterministic, not subjective. If all deliverables are met, approve. If any are missing, block.

---

## The Problem

**Current quality-validator behavior (subjective):**

```
quality-validator reviews work:
  - "Code looks good" ✅
  - "Tests seem to pass" ✅
  - "Implementation appears complete" ✅

Verdict: APPROVED (based on impression)
```

**But what if:**
- Screenshots were never taken?
- Accessibility audit was skipped?
- Design review wasn't run?
- Performance benchmarks not measured?

**Result:** False completion - work "approved" but missing critical deliverables.

---

## The Solution: Checklist-Based Validation

**New quality-validator behavior (deterministic):**

```
quality-validator runs checklist:
  ☐ Source files exist (LoginView.swift)
  ☐ Screenshots captured (.orchestration/evidence/login-screen.png)
  ☐ Build succeeded (xcodebuild output in proofpack)
  ☐ Tests passed (test-results.json in proofpack)
  ☐ Accessibility verified (accessibility-report.md exists)
  ☐ Design review passed (design-review-report.md exists)

Result: 6/6 deliverables met ✅ → APPROVED
Result: 5/6 deliverables met ❌ → BLOCKED (missing deliverable listed)
```

**Now validation is binary:** All deliverables met = approve. Any missing = block.

---

## How It Works

### Step 1: Load Completion Criteria

quality-validator identifies task type (ios-ui, frontend-ui, backend-api) and loads corresponding completion criteria:

```bash
# For iOS UI task
CRITERIA_FILE=".orchestration/completion-criteria/ios-ui.json"
```

**Example criteria (ios-ui.json):**
```json
{
  "deliverables": [
    {
      "id": "source-files",
      "required": true,
      "verification_command": "ls -la {{SOURCE_PATH}}"
    },
    {
      "id": "screenshots",
      "required": true,
      "verification_command": "ls -la .orchestration/evidence/{{TASK_ID}}-*.png"
    },
    ...
  ]
}
```

### Step 2: Generate Checklist

quality-validator creates a validation checklist with one item per required deliverable:

```
Quality Validation Checklist
Task ID: login-screen-20251024T220000Z
Task Type: ios-ui

Required Deliverables:
  ☐ 1. Source files exist
  ☐ 2. Screenshots captured
  ☐ 3. Build succeeded
  ☐ 4. Tests passed
  ☐ 5. Accessibility verified
  ☐ 6. Design review passed
```

### Step 3: Execute Verification Commands

For each deliverable, run the verification command and mark pass/fail:

```bash
# Deliverable 1: Source files
ls -la Views/LoginView.swift
  → File exists ✅ (1/6 passed)

# Deliverable 2: Screenshots
ls -la .orchestration/evidence/login-screen-*.png
  → File exists ✅ (2/6 passed)

# Deliverable 3: Build succeeded
grep "BUILD SUCCEEDED" .orchestration/proofpacks/login-screen-proofpack.json
  → Found ✅ (3/6 passed)

# Deliverable 4: Tests passed
jq '.evidence.test_outputs.verdict' .orchestration/proofpacks/login-screen-proofpack.json
  → "PASSED" ✅ (4/6 passed)

# Deliverable 5: Accessibility verified
ls -la .orchestration/evidence/accessibility-report.md
  → File NOT found ❌ (4/6 passed)

# Deliverable 6: Design review passed
ls -la .orchestration/evidence/design-review-report.md
  → File exists ✅ (5/6 passed)

Final Score: 5/6 deliverables met (83%)
```

### Step 4: Binary Decision

**Pass threshold: 100% (all deliverables met)**

```bash
if [ $PASSED -eq $TOTAL ]; then
  VERDICT="APPROVED"
else
  VERDICT="BLOCKED"
  MISSING_DELIVERABLES="accessibility-verified"
fi
```

**Result:**
- 6/6 deliverables → APPROVED ✅
- 5/6 deliverables → BLOCKED ❌ (missing: accessibility-verified)

### Step 5: Report to User

quality-validator reports outcome with checklist:

**If APPROVED:**
```
✅ Quality Validation PASSED

Checklist Results (6/6):
  ✅ Source files exist
  ✅ Screenshots captured
  ✅ Build succeeded
  ✅ Tests passed
  ✅ Accessibility verified
  ✅ Design review passed

Verdict: APPROVED - All deliverables met
```

**If BLOCKED:**
```
❌ Quality Validation BLOCKED

Checklist Results (5/6):
  ✅ Source files exist
  ✅ Screenshots captured
  ✅ Build succeeded
  ✅ Tests passed
  ❌ Accessibility verified (MISSING)
  ✅ Design review passed

Verdict: BLOCKED - Missing deliverable: accessibility-verified

Required action: Run accessibility audit before approval
```

---

## Checklist Schema

**Generated checklist structure:**

```json
{
  "task_id": "login-screen-20251024T220000Z",
  "task_type": "ios-ui",
  "timestamp": "2025-10-24T22:00:00Z",
  "checklist": [
    {
      "deliverable_id": "source-files",
      "description": "Source files exist",
      "required": true,
      "verification_command": "ls -la Views/LoginView.swift",
      "status": "PASSED",
      "evidence": "File exists: Views/LoginView.swift"
    },
    {
      "deliverable_id": "screenshots",
      "description": "Screenshots captured",
      "required": true,
      "verification_command": "ls -la .orchestration/evidence/login-screen-*.png",
      "status": "PASSED",
      "evidence": "File exists: login-screen-main.png"
    },
    ...
  ],
  "summary": {
    "total_deliverables": 6,
    "passed": 5,
    "failed": 1,
    "pass_rate": 0.83
  },
  "verdict": "BLOCKED",
  "missing_deliverables": ["accessibility-verified"],
  "blocking_reason": "Missing required deliverable: accessibility-verified"
}
```

---

## Integration with Verification Flow

### Current Flow (Stage 2)

```
Specialist implements
    ↓
verification-agent runs behavioral oracles
    ↓
quality-validator reviews work (subjective)
    ↓
Verdict: APPROVED/BLOCKED
```

### Enhanced Flow (Stage 3 Week 5)

```
Specialist implements
    ↓
verification-agent runs behavioral oracles
    ↓
quality-validator loads completion criteria
    ↓
quality-validator generates checklist
    ↓
quality-validator executes verification commands
    ↓
quality-validator calculates pass/fail (binary)
    ↓
If BLOCKED → Report missing deliverables
    ↓
If APPROVED → Deliver to user
```

---

## Task Type Coverage

**Supported task types (from completion criteria registry):**

1. **ios-ui** - 6 deliverables (source files, screenshots, build, tests, accessibility, design review)
2. **frontend-ui** - 7 deliverables (source files, browser screenshots, build, tests, accessibility, visual review, performance)
3. **backend-api** - 8 deliverables (API files, endpoints, curl verification, tests, performance benchmarks, security scan, logs, API docs)

**Future:** Add more task types as completion criteria are defined (ios-logic, frontend-logic, backend-database, etc.)

---

## Advantages

### 1. Eliminates Subjective Judgment

**Before (subjective):**
```
quality-validator: "This looks good to me, approved"
User: "But you didn't check accessibility!"
```

**After (deterministic):**
```
quality-validator: "Checklist: 5/6 passed. Missing: accessibility-verified. BLOCKED."
```

### 2. Transparent Decision-Making

User can see EXACTLY why work was approved or blocked:

**Approval:**
```
✅ All 6 deliverables met → APPROVED
```

**Block:**
```
❌ Missing deliverable: accessibility-verified → BLOCKED
```

No ambiguity.

### 3. Prevents Partial Completion

**Scenario:** Specialist implements feature but skips accessibility audit.

**Old behavior:** quality-validator might approve based on "looks good"

**New behavior:** Checklist shows 5/6 passed → BLOCKED (accessibility missing)

### 4. Auditable

Checklist results saved to JSON provide audit trail:

```json
{
  "task_id": "login-screen-20251024T220000Z",
  "verdict": "BLOCKED",
  "missing_deliverables": ["accessibility-verified"],
  "timestamp": "2025-10-24T22:00:00Z"
}
```

**Can answer:** "Why was this blocked?" → "accessibility-verified deliverable not met"

---

## Use Cases

### Use Case 1: iOS UI Feature (Complete)

**Task:** Build login screen for iOS app

**Checklist execution:**
```
Loading completion criteria: ios-ui.json
Generating checklist: 6 deliverables

Verifying:
  ✅ Source files exist (Views/LoginView.swift)
  ✅ Screenshots captured (login-screen-main.png, login-screen-error.png)
  ✅ Build succeeded (xcodebuild output in proofpack)
  ✅ Tests passed (LoginViewUITests.swift)
  ✅ Accessibility verified (accessibility-report.md)
  ✅ Design review passed (design-review-report.md)

Result: 6/6 deliverables met
Verdict: APPROVED ✅
```

---

### Use Case 2: Frontend UI Feature (Incomplete)

**Task:** Build data dashboard for web app

**Checklist execution:**
```
Loading completion criteria: frontend-ui.json
Generating checklist: 7 deliverables

Verifying:
  ✅ Source files exist (components/Dashboard.tsx)
  ✅ Browser screenshots captured (dashboard-chrome.png)
  ✅ Build succeeded (npm run build output)
  ✅ Tests passed (Dashboard.test.tsx)
  ❌ Accessibility audit (MISSING - no accessibility-report.md)
  ❌ Visual review (/visual-review not run)
  ✅ Performance metrics (Core Web Vitals in proofpack)

Result: 5/7 deliverables met (71%)
Verdict: BLOCKED ❌

Missing deliverables:
  - accessibility-audit
  - visual-review

Required action: Run accessibility audit and /visual-review before approval
```

---

### Use Case 3: Backend API (Security Missing)

**Task:** Build authentication API

**Checklist execution:**
```
Loading completion criteria: backend-api.json
Generating checklist: 8 deliverables

Verifying:
  ✅ API files exist (routes/auth.ts, controllers/auth.ts)
  ✅ Endpoints accessible (POST /api/auth/register, POST /api/auth/login)
  ✅ curl verification (api-test.sh passed)
  ✅ Tests passed (auth.test.ts)
  ✅ Performance benchmarks (p95: 85ms < 200ms threshold)
  ❌ Security scan (MISSING - no security-scan.json)
  ✅ Logs verified (console output in proofpack)
  ✅ API docs updated (swagger.json)

Result: 7/8 deliverables met (88%)
Verdict: BLOCKED ❌

Missing deliverable:
  - security-scan

Required action: Run security scan (npm audit, OWASP check) before approval
```

---

## Checklist Generation Script

**Location:** `.orchestration/quality-checklist/generate-checklist.sh`

**Usage:**
```bash
./orchestration/quality-checklist/generate-checklist.sh \
  --task-id login-screen-20251024T220000Z \
  --task-type ios-ui \
  --proofpack .orchestration/proofpacks/login-screen-proofpack.json
```

**Output:**
- Console: Pass/fail for each deliverable
- File: `.orchestration/quality-checklist/{task-id}-checklist.json`
- Exit code: 0 (approved), 1 (blocked)

---

## quality-validator Integration

**Modified workflow:**

```markdown
# quality-validator.md (updated)

## Quality Validation Process

1. **Load Completion Criteria**
   ```bash
   TASK_TYPE=$(jq -r '.task_type' .orchestration/verification-report.md)
   CRITERIA_FILE=".orchestration/completion-criteria/${TASK_TYPE}.json"
   ```

2. **Generate Checklist**
   ```bash
   ./orchestration/quality-checklist/generate-checklist.sh \
     --task-id $TASK_ID \
     --task-type $TASK_TYPE \
     --proofpack .orchestration/proofpacks/${TASK_ID}-proofpack.json
   ```

3. **Read Checklist Results**
   ```bash
   VERDICT=$(jq -r '.verdict' .orchestration/quality-checklist/${TASK_ID}-checklist.json)
   ```

4. **Binary Decision**
   - If VERDICT == "APPROVED" → Deliver work to user
   - If VERDICT == "BLOCKED" → Report missing deliverables, do not deliver

5. **Report to User**
   - APPROVED: Show checklist (all ✅)
   - BLOCKED: Show checklist with ❌, explain what's missing
```

---

## Configuration

### Pass Threshold

**Default:** 100% (all deliverables must be met)

**Rationale:**
- Partial completion = false completion
- If deliverable is required, it's required
- No subjective "good enough" threshold

**Future:** Could add task-specific thresholds if needed (e.g., 90% for non-critical features), but default should be 100%.

### Optional vs Required Deliverables

**Completion criteria schema supports optional deliverables:**

```json
{
  "id": "performance-benchmarks",
  "required": false,
  "verification_command": "..."
}
```

**Checklist behavior:**
- Required deliverables (required: true) → Must pass for approval
- Optional deliverables (required: false) → Checked but don't block approval

**Example:**
```
Checklist Results (6/6 required, 1/1 optional):
  ✅ Source files exist (required)
  ✅ Screenshots captured (required)
  ✅ Build succeeded (required)
  ✅ Tests passed (required)
  ✅ Accessibility verified (required)
  ✅ Design review passed (required)
  ✅ Performance benchmarks (optional)

Verdict: APPROVED (all required deliverables met)
```

---

## Directory Structure

```
.orchestration/quality-checklist/
├── README.md (this file)
├── generate-checklist.sh (checklist generation script)
└── [task-id]-checklist.json (generated checklists, gitignored)
```

**Template files:** Tracked in git
**Generated files:** Gitignored (ephemeral evidence)

---

## Integration with Other Systems

### With Completion Criteria Registry

```
completion-criteria/{task-type}.json
    ↓
quality-validator loads criteria
    ↓
generate-checklist.sh creates checklist
    ↓
Execute verification commands
    ↓
Binary pass/fail
```

**Completion criteria = source of truth for what constitutes "done"**

### With Proofpacks

Checklist verification commands read from proofpack:

```bash
# Check if build succeeded
jq '.evidence.build_output.status' proofpack.json
  → "SUCCESS" ✅

# Check if tests passed
jq '.evidence.test_outputs.verdict' proofpack.json
  → "PASSED" ✅
```

**Proofpack = evidence container**
**Checklist = verification logic**

### With Behavioral Oracles

Oracles provide test evidence that checklist verifies:

```
Oracle runs → test-results.json created
    ↓
Checklist verifies: "Tests passed?" → Check test-results.json
    ↓
If oracle verdict == "PASSED" → ✅
If oracle verdict == "FAILED" → ❌
```

### With Screenshot Diff

Screenshot Diff provides visual evidence that checklist verifies:

```
Screenshot Diff runs → diff-report.json created
    ↓
Checklist verifies: "Visual changes detected?" → Check diff-report.json
    ↓
If changed_pixels >= threshold → ✅
If changed_pixels < threshold → ❌
```

### With Design DNA System

Design DNA visual-reviewer provides taste compliance evidence:

```
visual-reviewer-v2 runs → design-review-report.md created
    ↓
Checklist verifies: "Design review passed?" → Check design-review-report.md
    ↓
If quality_score >= 0.70 → ✅
If quality_score < 0.70 → ❌
```

---

## Impact on False Completion Rate

**Current (Stage 2):** ~15-20% false completion rate (after Behavioral Oracles)

**After Quality Validator Checklist:** Expected **10-15%**

**Why:**
- Eliminates subjective "looks good" approvals
- Enforces 100% deliverable completion
- Prevents partial verification (e.g., build passed but tests not run)
- Binary decision removes ambiguity

**Remaining false completions:**
- Bugs that pass tests (logic errors)
- Visual issues that pass linter but fail "eyes test"
- Integration issues not caught by unit tests
- (Future stages will address these)

---

## Best Practices

### 1. Keep Verification Commands Simple

**Good:**
```json
{
  "verification_command": "ls -la .orchestration/evidence/accessibility-report.md"
}
```

**Bad (too complex):**
```json
{
  "verification_command": "cat accessibility-report.md | grep -A 100 'violations' | jq -r '.critical_count' | awk '{if($1==0) print \"PASSED\"; else print \"FAILED\"}'"
}
```

**Rationale:** Checklist should verify deliverable EXISTS and is VALID, not re-implement verification logic.

### 2. Fail Fast

If any required deliverable is missing, stop and block immediately:

```bash
for deliverable in $REQUIRED_DELIVERABLES; do
  verify_deliverable $deliverable
  if [ $? -ne 0 ]; then
    VERDICT="BLOCKED"
    break  # Stop checking, already blocked
  fi
done
```

### 3. Provide Actionable Feedback

**Don't:**
```
Verdict: BLOCKED
Reason: Missing deliverables
```

**Do:**
```
Verdict: BLOCKED
Missing deliverables:
  - accessibility-verified

Required action:
  1. Run accessibility audit: npm run a11y-audit
  2. Save report to: .orchestration/evidence/accessibility-report.md
  3. Re-run quality validation
```

---

## Future Enhancements

### Stage 4+

**Weighted Deliverables:**
- Critical deliverables (weight: 10) - Must pass
- Important deliverables (weight: 5) - Should pass
- Nice-to-have deliverables (weight: 1) - Optional

**Conditional Deliverables:**
```json
{
  "id": "ios-simulator-screenshots",
  "required": true,
  "condition": "task_type == 'ios-ui'"
}
```

**Deliverable Dependencies:**
```json
{
  "id": "integration-tests",
  "required": true,
  "depends_on": ["unit-tests"]
}
```

**Auto-Remediation:**
If deliverable missing but can be auto-generated, generate it:
```
Missing: accessibility-report.md
Auto-remedy: Run npm run a11y-audit
Generated: accessibility-report.md
Re-verify: ✅ Now passes
```

---

## Related Documentation

- **Completion Criteria Registry** (.orchestration/completion-criteria/README.md) - Defines deliverables per task type
- **Unified Proof Artifact** (.orchestration/proofpacks/README.md) - Evidence storage
- **Behavioral Oracles** (.orchestration/oracles/README.md) - Executable tests
- **Screenshot Diff** (.orchestration/screenshot-diff/README.md) - Visual verification
- **quality-validator agent** (agents/orchestration/quality-validator.md) - Runs checklists

---

**Last Updated:** 2025-10-24 (Stage 3 Week 5)
**Next Update:** Stage 4 (Weighted deliverables, conditional requirements)
