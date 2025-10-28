# Behavioral Oracles - Executable "It Works" Proofs

**Purpose:** Gold standard verification through executable tests

**Version:** 1.0.0 (Stage 2 Week 4)

---

## Overview

Behavioral Oracles are **executable test scripts** that provide concrete, reproducible proof that implemented features actually work.

**Philosophical Shift:** Move from "I claim it works" to "Here's the test that proves it works"

---

## The Problem

**Current verification (static checks):**

```
verification-agent checks:
  ✅ File exists: LoginView.swift
  ✅ Build succeeds
  ✅ Screenshot present

Verdict: PASSED
```

**But does it actually WORK?**
- Can user type into the email field?
- Does the login button respond to taps?
- Does authentication actually succeed?
- **We don't know - we only verified files exist**

---

## The Solution: Behavioral Oracles

**New verification (behavioral tests):**

```
Behavioral Oracle runs:
  1. Launch app in simulator
  2. Navigate to login screen
  3. Type "test@example.com" in email field
  4. Type "password123" in password field
  5. Tap login button
  6. Assert: Dashboard appears

Result: ✅ PASSED (executable proof)
```

**Now we KNOW it works** - the test physically performed the actions.

---

## Oracle Types

### 1. Frontend Oracles (Playwright)

**For:** frontend-ui tasks (React, Next.js, Vue)

**Template:** `.orchestration/oracles/frontend/template-playwright.test.ts`

**Verification:**
- Page loads without errors
- Required UI elements exist
- User workflows complete successfully
- Accessibility standards met
- Screenshot evidence captured
- Error handling works
- Responsive design works

**Execution:**
```bash
npm test login-screen-playwright.test.ts
```

**Output:**
```
✅ should load page without errors (250ms)
✅ should render all required UI elements (150ms)
✅ should complete user workflow successfully (450ms)
✅ should meet accessibility standards (200ms)
✅ should capture screenshot for evidence (100ms)
✅ should handle errors gracefully (300ms)
✅ should work on mobile viewport (180ms)

7 tests passed (1.6s)
```

---

### 2. iOS Oracles (XCUITest)

**For:** ios-ui tasks (SwiftUI, UIKit)

**Template:** `.orchestration/oracles/ios/TemplateUITests.swift`

**Verification:**
- View appears without errors
- Required UI elements exist
- User workflows complete successfully
- Accessibility labels present
- Screenshot evidence captured
- Error handling works
- State persistence works (if applicable)
- Performance meets standards

**Execution:**
```bash
xcodebuild test \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:MyAppUITests/LoginViewUITests
```

**Output:**
```
Test Suite 'LoginViewUITests' started
✅ testViewAppearsWithoutErrors (0.8s)
✅ testRequiredElementsPresent (0.5s)
✅ testUserWorkflowCompletes (1.2s)
✅ testAccessibilityLabelsPresent (0.4s)
✅ testCaptureScreenshotEvidence (0.3s)
✅ testErrorHandlingWorks (0.9s)
✅ testStatePersistence (1.5s)
✅ testPerformanceMetrics (2.1s)

Test Suite 'LoginViewUITests' passed: 8 tests (7.7s)
```

---

### 3. Backend Oracles (curl scripts)

**For:** backend-api tasks (Node.js, Python, Go)

**Template:** `.orchestration/oracles/backend/template-api-test.sh`

**Verification:**
- API is running (health check)
- All endpoints respond correctly
- Response data structures valid
- Error handling works
- Performance meets thresholds (p95 < 200ms)
- Security headers present

**Execution:**
```bash
bash .orchestration/oracles/backend/auth-api-test.sh
```

**Output:**
```
Test 1: API Health Check
✅ PASSED (Status: 200)

Test 2: POST /api/auth/register
✅ PASSED (Status: 201)

Test 3: POST /api/auth/login
✅ PASSED (Status: 200)

Test 4: Invalid credentials
✅ PASSED (Status: 401)

Test 5: Performance: POST /api/auth/login
Average latency: 85ms
✅ Performance OK (85ms < 200ms)

Test Summary:
Total: 5
Passed: 5
Failed: 0

✅ ORACLE VERDICT: PASSED
```

---

## How Oracles Work

### Step 1: Template Selection

verification-agent identifies task type:
- `ios-ui` → Use XCUITest template
- `frontend-ui` → Use Playwright template
- `backend-api` → Use curl template

### Step 2: Template Instantiation

verification-agent fills in template variables:

**From completion criteria:**
- Required UI elements
- Expected behaviors
- Error scenarios

**From user requirements:**
- Workflow steps
- Acceptance criteria

**Example (Playwright template → instantiated test):**

```typescript
// Template variable: {{FEATURE_NAME}}
test.describe('{{FEATURE_NAME}} - Behavioral Oracle', () => {

// Becomes:
test.describe('Login Screen - Behavioral Oracle', () => {

// Template variable: {{#EACH ACCEPTANCE_CRITERIA}}
await expect(page.{{SELECTOR}}).toBeVisible();

// Becomes:
await expect(page.getByLabel('Email')).toBeVisible();
await expect(page.getByLabel('Password')).toBeVisible();
await expect(page.getByRole('button', { name: 'Login' })).toBeVisible();
```

### Step 3: Oracle Execution

verification-agent runs the test:

```bash
# Frontend
npm test login-screen-20251024T220000Z.test.ts

# iOS
xcodebuild test -scheme MyApp -only-testing:MyAppUITests/LoginViewUITests

# Backend
bash .orchestration/oracles/backend/auth-api-20251024T220000Z.sh
```

### Step 4: Result Capture

Test output captured for proofpack:

```json
{
  "oracle_type": "playwright",
  "task_id": "login-screen-20251024T220000Z",
  "tests_run": 7,
  "tests_passed": 7,
  "tests_failed": 0,
  "duration_ms": 1600,
  "verdict": "PASSED",
  "output": "✅ should load page without errors (250ms)\n..."
}
```

### Step 5: Evidence Integration

Oracle results added to proofpack.json:

```json
{
  "evidence": {
    "screenshots": {...},
    "test_outputs": {...},
    "behavioral_oracle": {
      "type": "playwright",
      "tests_passed": 7,
      "tests_failed": 0,
      "verdict": "PASSED",
      "output": "...",
      "script_location": ".orchestration/oracles/frontend/login-screen-20251024T220000Z.test.ts"
    }
  },
  "verification_verdict": "PASSED"
}
```

---

## Oracle Directory Structure

```
.orchestration/oracles/
├── README.md (this file)
├── frontend/
│   ├── template-playwright.test.ts
│   └── [task-id]-playwright.test.ts (generated)
├── ios/
│   ├── TemplateUITests.swift
│   └── [task-id]UITests.swift (generated)
└── backend/
    ├── template-api-test.sh
    └── [task-id]-api-test.sh (generated)
```

**Template files:** Reusable test structure (tracked in git)
**Generated files:** Task-specific tests (gitignored, ephemeral)

---

## Integration with Verification Flow

### Current Flow (Stage 1-2)

```
Specialist implements
    ↓
verification-agent runs static checks (files exist, build passes)
    ↓
Verdict: PASSED/BLOCKED
```

### Enhanced Flow (Stage 2 Week 4)

```
Specialist implements
    ↓
verification-agent runs static checks
    ↓
verification-agent generates behavioral oracle from template
    ↓
verification-agent runs oracle (Playwright/XCUITest/curl)
    ↓
Oracle result: PASSED/FAILED
    ↓
Verdict: PASSED (only if static + behavioral both pass)
```

---

## Advantages

### 1. Executable Proof

**Before:** "I verified the login screen works"
**After:** "Here's the Playwright test that logged in successfully"

**Impact:** No more "it works on my machine" - oracle ran the exact workflow

### 2. Reproducible

Anyone can re-run the oracle:

```bash
# Developer re-runs oracle after fixes
bash .orchestration/oracles/backend/auth-api-test.sh

# QA team re-runs oracle before release
npm test login-screen-playwright.test.ts
```

### 3. Prevents False Completions

**Scenario:** Specialist claims login screen works

**Static verification:** ✅ Files exist, build passes
**Behavioral oracle:** ❌ Login button doesn't respond to clicks

**Result:** BLOCKED (oracle caught the bug)

### 4. Documentation

Oracle scripts document expected behavior:

```typescript
// This test IS the specification
test('should complete login workflow', async ({ page }) => {
  await page.getByLabel('Email').fill('test@example.com');
  await page.getByLabel('Password').fill('password123');
  await page.getByRole('button', { name: 'Login' }).click();
  await expect(page).toHaveURL('/dashboard');
});
```

**Result:** Future developers know exactly how login should work

---

## Limitations

### 1. Setup Overhead

**Problem:** Oracles require environment setup
- Frontend: npm install, dev server running
- iOS: Xcode, simulators installed
- Backend: API server running, database seeded

**Mitigation:** Document setup in completion criteria

### 2. Flaky Tests

**Problem:** UI tests notoriously brittle
- Timing issues
- Selector changes
- Race conditions

**Mitigation:**
- Use waitForExistence/waitForLoadState
- Retry failed tests once
- Threshold: 2/3 runs must pass

### 3. Authoring Cost

**Problem:** Writing oracle scripts takes time
- verification-agent must generate tests
- 5-10 minutes per oracle

**Mitigation:**
- Templates reduce authoring time
- Reuse oracles across similar tasks
- Oracle generation is one-time cost

### 4. Maintenance

**Problem:** Oracles break when features change
- UI redesign → Playwright selectors fail
- API changes → curl tests fail

**Mitigation:**
- Update oracles when features change
- Version oracles with code
- Archive old oracles

---

## Best Practices

### 1. Keep Oracles Simple

**Good:**
```typescript
test('should login successfully', async ({ page }) => {
  await page.getByLabel('Email').fill('test@example.com');
  await page.getByLabel('Password').fill('password123');
  await page.getByRole('button', { name: 'Login' }).click();
  await expect(page).toHaveURL('/dashboard');
});
```

**Bad (too complex):**
```typescript
test('should complete entire user journey', async ({ page }) => {
  // 50 lines of complex multi-screen workflow
  // Too fragile, too slow, too hard to debug
});
```

### 2. Test Happy Path First

**Priority 1:** User can complete primary workflow
**Priority 2:** Error handling works
**Priority 3:** Edge cases

### 3. Parallelize When Possible

```typescript
// Run tests in parallel
test.describe.configure({ mode: 'parallel' });

test('test 1', async () => { ... });  // Runs concurrently
test('test 2', async () => { ... });  // Runs concurrently
test('test 3', async () => { ... });  // Runs concurrently
```

### 4. Capture Evidence

```typescript
// Always take screenshot for proofpack
const screenshot = await page.screenshot({
  path: `.orchestration/evidence/${taskId}-oracle.png`
});
```

---

## Impact on False Completion Rate

**Current:** ~20-30% after Stage 2 (Two-Phase Commit + Skill Vectors)

**After Behavioral Oracles:** Expected **15-20%**

**Why:**
- Oracles catch bugs that static checks miss
- Executable proof eliminates "I verified mentally"
- Reproducible verification prevents false positives

**Not a massive reduction because:**
- Stage 1-2 already prevented verification skipping
- Oracles improve verification QUALITY, not just enforcement
- Main benefit: Confidence and reliability, not just false completion rate

---

## Future Enhancements

### Stage 3+

**Screenshot Diff Integration:**
- BEFORE oracle run → take screenshot
- AFTER oracle run → take screenshot
- Pixel diff → detect visual changes

**Visual Regression:**
- Store baseline screenshots
- Compare oracle screenshots to baselines
- Detect unintended visual changes

**Performance Oracles:**
- Measure rendering time
- Track API latency trends
- Alert on performance degradation

**Cross-Browser Testing:**
- Run Playwright oracles on Chrome + Firefox + Safari
- Ensure cross-browser compatibility

**Continuous Oracles:**
- Run oracles on every git push
- CI/CD integration
- Prevent regressions

---

## Examples

### Example 1: Frontend Oracle (Login Screen)

**Generated from template:**

```typescript
import { test, expect } from '@playwright/test';

test.describe('Login Screen - Behavioral Oracle', () => {

  test('should load page without errors', async ({ page }) => {
    await page.goto('http://localhost:3000/login');
    await page.waitForLoadState('networkidle');
    expect(await page.title()).toBeTruthy();
  });

  test('should render all required UI elements', async ({ page }) => {
    await page.goto('http://localhost:3000/login');
    await expect(page.getByLabel('Email')).toBeVisible();
    await expect(page.getByLabel('Password')).toBeVisible();
    await expect(page.getByRole('button', { name: 'Login' })).toBeVisible();
  });

  test('should complete login workflow', async ({ page }) => {
    await page.goto('http://localhost:3000/login');
    await page.getByLabel('Email').fill('test@example.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Login' }).click();
    await expect(page).toHaveURL('http://localhost:3000/dashboard');
  });

  test('should capture screenshot', async ({ page }) => {
    await page.goto('http://localhost:3000/login');
    await page.screenshot({
      path: '.orchestration/evidence/login-screen-oracle.png'
    });
  });
});
```

---

### Example 2: iOS Oracle (Settings View)

**Generated from template:**

```swift
import XCTest

final class SettingsViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }

    func testViewAppearsWithoutErrors() throws {
        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.waitForExistence(timeout: 5))
        settingsTab.tap()

        let settingsView = app.otherElements["SettingsView"]
        XCTAssertTrue(settingsView.waitForExistence(timeout: 5))
    }

    func testRequiredElementsPresent() throws {
        app.tabBars.buttons["Settings"].tap()

        let darkModeToggle = app.switches["Dark Mode"]
        XCTAssertTrue(darkModeToggle.exists)

        let notificationsToggle = app.switches["Notifications"]
        XCTAssertTrue(notificationsToggle.exists)

        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists)
    }

    func testDarkModeToggle() throws {
        app.tabBars.buttons["Settings"].tap()

        let darkModeToggle = app.switches["Dark Mode"]
        darkModeToggle.tap()

        XCTAssertEqual(darkModeToggle.value as? String, "1")
    }
}
```

---

### Example 3: Backend Oracle (Authentication API)

**Generated from template:**

```bash
#!/bin/bash

API_BASE_URL="http://localhost:3000/api"

# Test 1: Register new user
response=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}' \
  ${API_BASE_URL}/auth/register)

status=$(echo $response | jq -r '.status')
if [ "$status" == "success" ]; then
  echo "✅ User registration works"
else
  echo "❌ User registration failed"
  exit 1
fi

# Test 2: Login with credentials
response=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}' \
  ${API_BASE_URL}/auth/login)

token=$(echo $response | jq -r '.token')
if [ -n "$token" ]; then
  echo "✅ Login works, got token"
else
  echo "❌ Login failed"
  exit 1
fi

# Test 3: Access protected endpoint
response=$(curl -s -X GET \
  -H "Authorization: Bearer $token" \
  ${API_BASE_URL}/users/me)

email=$(echo $response | jq -r '.email')
if [ "$email" == "test@example.com" ]; then
  echo "✅ Protected endpoint works"
else
  echo "❌ Protected endpoint failed"
  exit 1
fi

echo "✅ ALL TESTS PASSED"
```

---

## Related Documentation

- **.orchestration/completion-criteria/** - Defines what to verify
- **.orchestration/proofpacks/** - Where oracle results are stored
- **verification-agent.md** - Runs oracles and collects results
- **workflow-orchestrator.md** - Enforces oracle execution

---

**Last Updated:** 2025-10-24 (Stage 2 Week 4)
**Next Update:** Stage 3 (Screenshot Diff integration with oracles)
