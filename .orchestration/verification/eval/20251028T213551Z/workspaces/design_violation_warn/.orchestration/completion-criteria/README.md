# Completion Criteria Registry

**Purpose:** Define what "done" means for each task type with binary, verifiable requirements.

**Version:** 1.0.0 (Stage 1 Week 1)

---

## Overview

The Completion Criteria Registry eliminates ambiguity in task completion by providing:

1. **Explicit deliverables** - Exactly what files, tests, evidence must exist
2. **Verification commands** - How to check each requirement (ls, grep, xcodebuild test, npm test)
3. **Binary pass/fail** - No fuzzy scores, either requirement is met or it's not
4. **Quality gate threshold** - Must meet 100% of required deliverables

---

## How It Works

### 1. Task Type Identification

When workflow-orchestrator dispatches a specialist, it identifies the task type:
- **ios-ui** → iOS User Interface implementation
- **frontend-ui** → Web Frontend User Interface implementation
- **backend-api** → Backend API implementation

### 2. Load Completion Criteria

verification-agent loads the corresponding JSON file:
```bash
cat .orchestration/completion-criteria/ios-ui.json
```

### 3. Verify Each Deliverable

For EACH `required_deliverable` in the JSON:
```javascript
{
  "id": "ios_screenshot",
  "type": "screenshot",
  "location": ".orchestration/evidence/ios-simulator.png",
  "required": true,
  "verification_command": "ls .orchestration/evidence/ios-simulator.png"
}
```

verification-agent runs:
```bash
ls .orchestration/evidence/ios-simulator.png
```

If file exists → ✅ Deliverable met
If file missing → ❌ Deliverable failed

### 4. Generate Verification Report

verification-agent creates `.orchestration/verification-report.md`:

```markdown
# Verification Report: ios-ui Task

## Deliverable Verification

1. source_files: ✅ VERIFIED
   - Command: `find . -name '*.swift' -type f`
   - Result: Found 3 Swift files

2. ios_screenshot: ❌ FAILED
   - Command: `ls .orchestration/evidence/ios-simulator.png`
   - Result: No such file or directory
   - **BLOCKER**: iOS Simulator screenshot missing

3. build_success: ✅ VERIFIED
   - Command: `xcodebuild build`
   - Result: Build succeeded (exit code 0)

...

## Summary

- Total deliverables: 6
- Verified: 4
- Failed: 2
- **Overall Verdict: BLOCKED**

## Failed Verifications

1. ios_screenshot - iOS Simulator screenshot missing
2. accessibility_audit - No accessibility labels found

## Required Actions

1. Take iOS Simulator screenshot and save to .orchestration/evidence/ios-simulator.png
2. Add accessibility labels to all interactive elements
3. Re-run verification-agent
```

### 5. Enforcement

workflow-orchestrator reads verification-report.md:
- If verdict == "BLOCKED" → **HARD BLOCK ACTIVATED** (no quality-validator)
- If verdict == "PASSED" → Proceed to quality-validator

---

## Task Types

### ios-ui (iOS User Interface)

**Required Deliverables:**
1. Swift source files (*.swift)
2. iOS Simulator screenshot
3. Xcode build success
4. XCTest/XCUITest passing
5. Accessibility audit
6. design-reviewer visual QA

**Usage:**
```bash
cat .orchestration/completion-criteria/ios-ui.json
```

---

### frontend-ui (Web Frontend User Interface)

**Required Deliverables:**
1. TypeScript/JavaScript source files (*.tsx, *.ts, *.jsx, *.js)
2. Browser screenshot (ChromeDevTools or /visual-review)
3. Build success (npm/yarn build)
4. Component tests passing
5. Accessibility audit (axe-core, Lighthouse)
6. /visual-review with design-reviewer
7. Clean browser console (no errors)

**Usage:**
```bash
cat .orchestration/completion-criteria/frontend-ui.json
```

---

### backend-api (Backend API)

**Required Deliverables:**
1. Backend source files (*.ts, *.js, *.py, *.go)
2. API endpoint documentation
3. Build success
4. API tests passing (unit + integration)
5. curl/HTTP verification (API responds)
6. Security scan (0 critical/high vulnerabilities)
7. Database migrations (if applicable)
8. Performance benchmarks (p95 < 200ms)

**Usage:**
```bash
cat .orchestration/completion-criteria/backend-api.json
```

---

## JSON Schema

```json
{
  "task_type": "string (ios-ui, frontend-ui, backend-api)",
  "description": "string",
  "version": "string (semver)",
  "required_deliverables": [
    {
      "id": "unique_identifier",
      "type": "file | screenshot | build | test_output | accessibility | design_review | etc.",
      "description": "What this deliverable proves",
      "pattern": "glob pattern (for files)",
      "location": "path to evidence file",
      "command": "command to run (for builds/tests)",
      "expected_exit_code": 0,
      "required": true | false,
      "verification_command": "command verification-agent runs to check",
      "failure_message": "message if deliverable missing/failed"
    }
  ],
  "verification_script": "path to oracle script (Stage 2 Week 4)",
  "quality_gate_threshold": 100,
  "notes": ["additional context"]
}
```

---

## Integration with Quality System

### Stage 1 (Current)

```
Implementation Agent
    ↓ (creates files, claims completion)
verification-agent
    ↓ (loads completion criteria JSON)
    ↓ (runs verification_command for each deliverable)
    ↓ (generates verification-report.md)
workflow-orchestrator
    ↓ (reads verification-report.md)
    ↓ (if BLOCKED → HARD BLOCK)
    ↓ (if PASSED → proceed to quality-validator)
```

### Stage 2 Week 4 (Behavioral Oracles)

```
verification-agent
    ↓ (loads completion criteria)
    ↓ (runs verification_script from JSON)
    ↓ (.orchestration/oracles/ios-ui-verify.sh executes)
    ↓ (Playwright/XCTest/curl tests run automatically)
    ↓ (generates verification-report.md with oracle results)
```

### Stage 3 Week 5 (Screenshot Diff)

```
verification-agent
    ↓ (takes BEFORE screenshot)
Implementation Agent
    ↓ (makes changes)
verification-agent
    ↓ (takes AFTER screenshot)
    ↓ (pixel diff comparison)
    ↓ (if diff < 100 pixels → flag "No visual changes")
    ↓ (adds to verification-report.md)
```

---

## Adding New Task Types

To add a new task type (e.g., `mobile-native`, `data-pipeline`):

1. Create JSON file:
```bash
.orchestration/completion-criteria/mobile-native.json
```

2. Define required deliverables:
```json
{
  "task_type": "mobile-native",
  "description": "React Native or Flutter mobile implementation",
  "required_deliverables": [
    {
      "id": "android_screenshot",
      "type": "screenshot",
      "location": ".orchestration/evidence/android-emulator.png",
      "required": true,
      "verification_command": "ls .orchestration/evidence/android-emulator.png",
      "failure_message": "Android emulator screenshot missing"
    },
    {
      "id": "ios_screenshot",
      "type": "screenshot",
      "location": ".orchestration/evidence/ios-simulator.png",
      "required": true,
      "verification_command": "ls .orchestration/evidence/ios-simulator.png",
      "failure_message": "iOS Simulator screenshot missing"
    }
  ]
}
```

3. Update verification-agent to recognize new task type

4. Create oracle script (optional, for Stage 2):
```bash
.orchestration/oracles/mobile-native-verify.sh
```

---

## Future Enhancements

### Stage 2 Week 4: Behavioral Oracles
- Automated Playwright tests for frontend-ui
- Automated XCUITest for ios-ui
- Automated curl scripts for backend-api
- Oracle execution via `verification_script` field

### Stage 3 Week 5: Screenshot Diff
- BEFORE/AFTER screenshot comparison
- Pixel diff calculation
- Flag "claimed but not done" UI changes

### Stage 3 Week 5: Quality Validator Checklist
- quality-validator loads completion criteria
- Generates binary checklist from deliverables
- 100% required (no fuzzy scoring)

### Stage 3 Week 6: Verification Replay
- verification-agent saves verification commands to script
- Developers can re-run: `bash .orchestration/verification-script.sh`
- Enables iterative fixes

---

## Key Principles

1. **Binary, Not Fuzzy** - Either requirement is met or it's not (no 94% vs 95%)
2. **Verifiable, Not Assumed** - Every deliverable has a `verification_command`
3. **Evidence-Based** - Files must exist, tests must pass, screenshots must be captured
4. **Mandatory, Not Optional** - `required: true` means HARD BLOCK if missing
5. **Quality Gate Threshold 100%** - Must meet ALL required deliverables

---

## Examples

### Example: ios-ui Task Verification

**Task:** Implement login screen for iOS app

**Completion Criteria:** `.orchestration/completion-criteria/ios-ui.json`

**verification-agent runs:**
```bash
# Check 1: Swift files exist
find . -name '*.swift' -type f
# Result: LoginView.swift found ✅

# Check 2: iOS screenshot exists
ls .orchestration/evidence/ios-simulator.png
# Result: File exists ✅

# Check 3: Build succeeds
xcodebuild build -scheme MyApp -destination 'platform=iOS Simulator,name=iPhone 15'
# Result: Exit code 0 ✅

# Check 4: Tests pass
xcodebuild test -scheme MyApp
# Result: Exit code 0 ✅

# Check 5: Accessibility labels present
grep -r 'accessibilityLabel' .
# Result: Found 5 accessibility labels ✅

# Check 6: design-reviewer ran
ls .orchestration/evidence/design-review-report.md
# Result: File exists ✅
```

**Verdict:** ✅ ALL VERIFIED (6/6 deliverables met)

**workflow-orchestrator:** Proceeds to quality-validator

---

### Example: frontend-ui Task Verification (with failure)

**Task:** Implement dashboard for web app

**Completion Criteria:** `.orchestration/completion-criteria/frontend-ui.json`

**verification-agent runs:**
```bash
# Check 1: Component files exist
find . -name '*.tsx' -type f
# Result: Dashboard.tsx found ✅

# Check 2: Browser screenshot exists
ls .orchestration/evidence/browser-screenshot.png
# Result: No such file or directory ❌

# Check 3: Build succeeds
npm run build
# Result: Exit code 0 ✅

# Check 4: Tests pass
npm test
# Result: Exit code 1 ❌ (3 tests failed)

# Check 5: Accessibility audit
npm run test:a11y
# Result: Not run ❌

# Check 6: /visual-review ran
ls .orchestration/evidence/visual-review-report.md
# Result: No such file or directory ❌

# Check 7: Console clean
grep 'console.error' .orchestration/evidence/browser-console.log
# Result: File not found ❌
```

**Verdict:** ❌ BLOCKED (5/7 deliverables FAILED)

**Failed Verifications:**
1. browser_screenshot - Screenshot missing
2. component_tests - 3 tests failing
3. accessibility_audit - Not run
4. visual_review - /visual-review not run
5. console_clean - Console log not captured

**workflow-orchestrator:** **HARD BLOCK ACTIVATED** - Cannot proceed

---

## Troubleshooting

### Q: verification-agent reports "verification_command not found"

**A:** The command in the JSON may not be available in the current environment. Update the JSON to use available commands:

```json
// Before (macOS-specific)
"verification_command": "xcodebuild test"

// After (cross-platform)
"verification_command": "ls build/ && grep -r 'Test.*passed' build/"
```

### Q: verification-agent passes but quality-validator fails

**A:** Completion criteria check for MINIMUM requirements (files exist, tests pass). quality-validator checks QUALITY (code quality, performance, security). Both are needed.

### Q: How do I make a deliverable optional?

**A:** Set `"required": false` and `"optional": true`:

```json
{
  "id": "database_migrations",
  "required": false,
  "optional": true,
  "applies_if": "database_required"
}
```

verification-agent will skip optional deliverables unless `applies_if` condition is met.

---

## Related Documentation

- **workflow-orchestrator.md** - Enforcement mechanisms and quality gates
- **verification-agent.md** - How verification commands are executed
- **quality-validator.md** - Final quality scoring after verification passes
- **.orchestration/playbooks/README.md** - ACE Playbook System
- **Response Awareness Tags** - Meta-cognitive tagging system

---

**Last Updated:** 2025-10-24 (Stage 1 Week 1)
**Next Update:** Stage 2 Week 4 (Behavioral Oracles integration)
