# Verification Replay - Reusable Verification Scripts

**Purpose:** Save and reuse verification scripts to reduce token cost and verification time

**Version:** 1.0.0 (Stage 3 Week 6)

---

## Overview

Verification Replay allows **verification scripts to be saved and reused across sessions**, eliminating the need to regenerate Behavioral Oracles, Screenshot Diff commands, and Quality Validator Checklists for similar tasks.

**Philosophical Position:** If verification logic was correct once, it's correct again for similar features. Don't wastefully regenerate what already works.

---

## The Problem

**Current verification workflow (regenerate every time):**

```
Session 1: Build login screen
  → verification-agent generates Playwright oracle
  → verification-agent writes login-screen-20251024.test.ts
  → Oracle runs, task verified
  → Script discarded (gitignored, ephemeral)

Session 2: Build login screen (different project)
  → verification-agent generates Playwright oracle AGAIN
  → Regeneration cost: 10,000 tokens
  → Same verification logic as Session 1

Session 3: Build login screen (refinements)
  → verification-agent generates Playwright oracle AGAIN
  → Regeneration cost: 10,000 tokens
  → Same verification logic as Sessions 1-2
```

**Total cost:** 30,000 tokens for 3x the same verification logic

**Problem:** Wasteful regeneration when verification logic is reusable

---

## The Solution: Verification Script Library

**New workflow (reuse verification scripts):**

```
Session 1: Build login screen
  → verification-agent generates Playwright oracle
  → verification-agent writes login-screen-20251024.test.ts
  → Oracle runs, task verified
  → Script SAVED to verification-replay/frontend/login-screen.test.ts (reusable template)

Session 2: Build login screen (different project)
  → verification-agent checks replay library
  → FOUND: login-screen.test.ts
  → REUSE existing script (0 tokens for generation)
  → Customize variables (email field ID, button text)
  → Oracle runs, task verified

Session 3: Build login screen (refinements)
  → verification-agent checks replay library
  → FOUND: login-screen.test.ts
  → REUSE existing script (0 tokens)
  → Oracle runs, task verified
```

**Total cost:** 10,000 tokens (1x generation) + minor customization (500 tokens × 2) = 11,000 tokens

**Savings:** 19,000 tokens (63% reduction)

---

## How It Works

### Step 1: Initial Generation (First Time)

verification-agent generates verification script from template:

```typescript
// Generated: .orchestration/oracles/frontend/login-screen-20251024T220000Z.test.ts
import { test, expect } from '@playwright/test';

test.describe('Login Screen - Behavioral Oracle', () => {
  test('should load page without errors', async ({ page }) => {
    await page.goto('http://localhost:3000/login');
    await page.waitForLoadState('networkidle');
    expect(await page.title()).toBeTruthy();
  });

  test('should complete login workflow', async ({ page }) => {
    await page.goto('http://localhost:3000/login');
    await page.getByLabel('Email').fill('test@example.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Login' }).click();
    await expect(page).toHaveURL('http://localhost:3000/dashboard');
  });
});
```

**Cost:** 10,000 tokens (script generation)

### Step 2: Save to Replay Library

verification-agent identifies reusable pattern and saves to library:

```bash
# Copy to replay library with descriptive name
cp .orchestration/oracles/frontend/login-screen-20251024T220000Z.test.ts \
   .orchestration/verification-replay/frontend/login-screen.test.ts

# Add metadata
cat > .orchestration/verification-replay/frontend/login-screen.meta.json <<EOF
{
  "script_id": "frontend-login-screen",
  "feature_type": "frontend-ui",
  "description": "Login screen with email/password authentication",
  "created": "2025-10-24T22:00:00Z",
  "times_reused": 0,
  "customizable_fields": ["page_url", "email_field_label", "password_field_label", "login_button_text"],
  "test_cases": [
    "page loads without errors",
    "login workflow completes successfully",
    "error handling for invalid credentials"
  ]
}
EOF
```

### Step 3: Future Reuse

verification-agent searches replay library before generating new script:

```bash
# Search for matching verification script
./orchestration/verification-replay/search-replay.sh \
  --feature-type "frontend-ui" \
  --keywords "login,email,password,authentication"

# Found: frontend/login-screen.test.ts (similarity: 0.95)
```

### Step 4: Customize and Run

verification-agent customizes reusable script with task-specific values:

```typescript
// Customized from template
import { test, expect } from '@playwright/test';

const PAGE_URL = 'http://localhost:8080/auth/login';  // Customized
const EMAIL_LABEL = 'Email Address';  // Customized
const PASSWORD_LABEL = 'Password';    // Customized
const LOGIN_BUTTON = 'Sign In';       // Customized

test.describe('Login Screen - Behavioral Oracle', () => {
  test('should load page without errors', async ({ page }) => {
    await page.goto(PAGE_URL);
    await page.waitForLoadState('networkidle');
    expect(await page.title()).toBeTruthy();
  });

  test('should complete login workflow', async ({ page }) => {
    await page.goto(PAGE_URL);
    await page.getByLabel(EMAIL_LABEL).fill('test@example.com');
    await page.getByLabel(PASSWORD_LABEL).fill('password123');
    await page.getByRole('button', { name: LOGIN_BUTTON }).click();
    await expect(page).toHaveURL(/\/dashboard/);
  });
});
```

**Customization cost:** 500 tokens (variable substitution)
**Total cost:** 500 tokens (vs 10,000 for full generation)
**Savings:** 9,500 tokens (95% reduction)

---

## Replay Library Structure

```
.orchestration/verification-replay/
├── README.md (this file)
├── search-replay.sh (find matching verification scripts)
├── frontend/
│   ├── login-screen.test.ts
│   ├── login-screen.meta.json
│   ├── data-dashboard.test.ts
│   ├── data-dashboard.meta.json
│   ├── settings-view.test.ts
│   └── settings-view.meta.json
├── ios/
│   ├── LoginViewUITests.swift
│   ├── LoginViewUITests.meta.json
│   ├── SettingsViewUITests.swift
│   └── SettingsViewUITests.meta.json
└── backend/
    ├── auth-api-test.sh
    ├── auth-api-test.meta.json
    ├── crud-api-test.sh
    └── crud-api-test.meta.json
```

**Script types:**
- `*.test.ts` - Playwright tests (frontend)
- `*UITests.swift` - XCUITest scripts (iOS)
- `*-test.sh` - curl scripts (backend)
- `*.meta.json` - Metadata for search and customization

---

## Metadata Schema

**Location:** `{script-name}.meta.json`

```json
{
  "script_id": "frontend-login-screen",
  "feature_type": "frontend-ui|ios-ui|backend-api",
  "description": "Human-readable description of what this verifies",
  "created": "2025-10-24T22:00:00Z",
  "last_used": "2025-10-25T14:30:00Z",
  "times_reused": 5,
  "average_customization_cost_tokens": 450,
  "customizable_fields": [
    {
      "field": "page_url",
      "description": "Login page URL",
      "default": "http://localhost:3000/login"
    },
    {
      "field": "email_field_label",
      "description": "Email input label",
      "default": "Email"
    }
  ],
  "test_cases": [
    "page loads without errors",
    "required UI elements present",
    "login workflow completes successfully",
    "error handling for invalid credentials"
  ],
  "keywords": ["login", "authentication", "email", "password", "frontend-ui"],
  "pattern_embedding": [0.823, -0.412, 0.156, ...]  // 1536-dim semantic vector
}
```

---

## Search and Match Algorithm

**How verification-agent finds matching scripts:**

### Step 1: Feature Type Filter

```bash
# Only search scripts matching task type
task_type="frontend-ui"
candidates=$(find .orchestration/verification-replay/frontend/ -name "*.meta.json")
```

### Step 2: Keyword Matching

```bash
# Extract keywords from user request
user_request="Build login screen with email/password authentication"
keywords=["login", "email", "password", "authentication"]

# Score candidates by keyword overlap
for candidate in $candidates; do
  candidate_keywords=$(jq -r '.keywords[]' "$candidate")
  overlap=$(count_common_words "$keywords" "$candidate_keywords")
  score=$((overlap / total_keywords))
done
```

### Step 3: Semantic Similarity (if Pattern Embeddings enabled)

```bash
# Compare pattern embeddings using cosine similarity
request_embedding=$(generate_embedding "$user_request")
candidate_embedding=$(jq -r '.pattern_embedding' "$candidate")

similarity=$(cosine_similarity "$request_embedding" "$candidate_embedding")

# Threshold: similarity > 0.80 → strong match
```

### Step 4: Ranking and Selection

```bash
# Rank candidates by combined score
combined_score = (keyword_score × 0.5) + (semantic_similarity × 0.5)

# Select top match if score > 0.70
if [ $combined_score > 0.70 ]; then
  echo "FOUND: $candidate (similarity: $combined_score)"
  REUSE_SCRIPT="$candidate"
else
  echo "NO MATCH FOUND - Generating new script"
  GENERATE_NEW=true
fi
```

---

## Customization Process

**After finding matching script, verification-agent customizes:**

1. **Read customizable fields** from metadata
2. **Extract values** from current task context
3. **Substitute variables** in script template
4. **Save customized script** to ephemeral oracles directory
5. **Run verification** as normal

**Example customization:**

```bash
# Template script uses variables
const PAGE_URL = '{{PAGE_URL}}';
const EMAIL_LABEL = '{{EMAIL_LABEL}}';

# verification-agent substitutes
PAGE_URL → 'http://localhost:8080/auth/login'
EMAIL_LABEL → 'Email Address'

# Result: Customized script ready to run
```

---

## Use Cases

### Use Case 1: Login Screen Reuse

**Session 1:** Build login screen for Project A
- Generate Playwright oracle (10,000 tokens)
- Save to replay library

**Session 2:** Build login screen for Project B
- Find `login-screen.test.ts` in replay library
- Customize URL, labels (500 tokens)
- Run verification
- **Savings:** 9,500 tokens

**Session 3:** Refine login screen for Project A
- Reuse same script (0 tokens generation)
- Run verification
- **Savings:** 10,000 tokens

**Total savings:** 19,500 tokens across 3 sessions

---

### Use Case 2: CRUD API Reuse

**Session 1:** Build user CRUD API
- Generate curl oracle script (5,000 tokens)
- Save to replay library as `crud-api-test.sh`

**Sessions 2-10:** Build CRUD APIs for different entities (products, orders, etc.)
- Reuse `crud-api-test.sh` (0 tokens generation)
- Customize endpoint paths, entity names (300 tokens each)
- **Savings:** 4,700 tokens per reuse × 9 sessions = 42,300 tokens

---

### Use Case 3: Settings View iOS

**Session 1:** Build settings view for iOS App A
- Generate XCUITest script (8,000 tokens)
- Save to replay library

**Session 2:** Build settings view for iOS App B
- Reuse XCUITest script
- Customize toggle names, button labels (400 tokens)
- **Savings:** 7,600 tokens

---

## Token Cost Analysis

**Without Verification Replay:**

| Task Type | Generation Cost | Sessions | Total Cost |
|-----------|----------------|----------|------------|
| Frontend UI | 10,000 | 5 | 50,000 |
| iOS UI | 8,000 | 3 | 24,000 |
| Backend API | 5,000 | 7 | 35,000 |
| **Total** | | **15** | **109,000** |

**With Verification Replay:**

| Task Type | Initial Gen | Reuse Cost | Sessions | Total Cost |
|-----------|------------|------------|----------|------------|
| Frontend UI | 10,000 | 500 × 4 | 5 | 12,000 |
| iOS UI | 8,000 | 400 × 2 | 3 | 8,800 |
| Backend API | 5,000 | 300 × 6 | 7 | 6,800 |
| **Total** | | | **15** | **27,600** |

**Savings:** 81,400 tokens (75% reduction)

---

## Integration with Workflow

**Modified verification-agent behavior:**

```markdown
# verification-agent.md (Verification Replay Integration)

## Behavioral Oracle Generation with Replay

1. **Check Replay Library First**

   ```bash
   ./orchestration/verification-replay/search-replay.sh \
     --feature-type $TASK_TYPE \
     --keywords "${USER_REQUEST_KEYWORDS}"
   ```

2. **If Match Found (similarity > 0.70)**

   ```bash
   REUSE_SCRIPT=true
   TEMPLATE_SCRIPT=".orchestration/verification-replay/frontend/login-screen.test.ts"
   METADATA=".orchestration/verification-replay/frontend/login-screen.meta.json"

   # Extract customizable fields
   FIELDS=$(jq -r '.customizable_fields[].field' "$METADATA")

   # Substitute values from task context
   for field in $FIELDS; do
     value=$(extract_from_context "$field" "$TASK_CONTEXT")
     sed -i "s/{{$field}}/$value/g" "$TEMPLATE_SCRIPT"
   done

   # Save customized script to ephemeral oracles directory
   cp "$TEMPLATE_SCRIPT" ".orchestration/oracles/frontend/${TASK_ID}.test.ts"

   # Update reuse counter
   jq '.times_reused += 1 | .last_used = "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"' \
     "$METADATA" > "${METADATA}.tmp" && mv "${METADATA}.tmp" "$METADATA"
   ```

3. **If No Match Found**

   ```bash
   GENERATE_NEW=true

   # Generate from template as usual
   instantiate_template "frontend/template-playwright.test.ts"

   # After successful verification, prompt to save to replay library
   if [ $ORACLE_VERDICT == "PASSED" ]; then
     prompt_save_to_replay_library
   fi
   ```

4. **Run Oracle (reused or new)**

   Same execution flow regardless of source
```

---

## Replay Library Management

### Adding New Scripts

**Manual addition:**

```bash
./orchestration/verification-replay/add-script.sh \
  --type frontend \
  --script login-screen.test.ts \
  --description "Login screen with email/password authentication" \
  --keywords "login,email,password,authentication"
```

**Automatic addition after successful verification:**

```bash
# verification-agent prompts after oracle passes
"Oracle passed. Save to replay library for future reuse? (y/n)"

# If yes:
./orchestration/verification-replay/add-script.sh \
  --type $TASK_TYPE \
  --script $ORACLE_SCRIPT \
  --auto
```

### Removing Obsolete Scripts

**Criteria for removal:**

1. **Never reused** (times_reused = 0) after 90 days
2. **Deprecated patterns** (old test framework, obsolete selectors)
3. **Low success rate** (oracle frequently fails when reused)

**Manual removal:**

```bash
./orchestration/verification-replay/remove-script.sh \
  --script-id frontend-login-screen \
  --reason "Replaced by OAuth-based login pattern"
```

---

## Advantages

### 1. Token Cost Savings

**75% reduction** in verification script generation costs for reusable patterns

**Example:**
- Without replay: 10,000 tokens × 10 sessions = 100,000 tokens
- With replay: 10,000 + (500 × 9) = 14,500 tokens
- **Savings:** 85,500 tokens

### 2. Faster Verification

**Script reuse is instant:**
- No generation time
- No template instantiation
- Just variable substitution (< 1 second)

### 3. Proven Verification Logic

**Scripts in replay library are battle-tested:**
- Used successfully in previous sessions
- Known to catch real issues
- Trusted verification patterns

### 4. Consistency Across Projects

**Same verification logic for similar features:**
- Login screens verified identically across all projects
- CRUD APIs use same comprehensive checks
- Settings views have consistent test coverage

---

## Limitations

### 1. Not All Scripts Are Reusable

**Unique features** don't benefit from replay:
- Novel UI patterns
- Custom authentication flows
- Domain-specific logic

**Solution:** Only save scripts identified as reusable patterns

### 2. Customization May Be Insufficient

**Script template might not match new feature:**
- Different field names
- Additional test cases needed
- Different workflows

**Solution:** Fall back to full generation if customization fails

### 3. Maintenance Overhead

**Replay library can become stale:**
- Obsolete test patterns
- Deprecated selectors
- Unused scripts accumulate

**Solution:** Periodic cleanup (remove scripts with times_reused=0 after 90 days)

---

## Best Practices

### 1. Save Only Proven Scripts

Don't save to replay library until oracle has been used successfully at least once.

**Good:**
```
Oracle passes in Session 1 → Save to replay library
Reused in Session 2 → Passes again → Confirmed reusable
```

**Bad:**
```
Oracle fails in Session 1 → Don't save (verification logic may be flawed)
```

### 2. Use Descriptive Names

**Good:**
- `login-screen-email-password.test.ts`
- `crud-api-with-pagination.sh`
- `SettingsViewWithToggles.swift`

**Bad:**
- `test1.test.ts`
- `api-test.sh`
- `ViewTests.swift`

### 3. Document Customizable Fields

**Good metadata:**
```json
{
  "customizable_fields": [
    {"field": "page_url", "description": "Login page URL", "default": "http://localhost:3000/login"},
    {"field": "email_label", "description": "Email input label", "default": "Email"}
  ]
}
```

**Bad metadata:**
```json
{
  "customizable_fields": ["url", "label1", "label2"]
}
```

### 4. Review and Cleanup Periodically

**Monthly review:**
- Identify scripts with `times_reused = 0` after 90 days → Remove
- Update scripts with deprecated patterns → Modernize or remove
- Merge similar scripts → Consolidate

---

## Directory Structure

```
.orchestration/verification-replay/
├── README.md (this file)
├── search-replay.sh (find matching scripts)
├── add-script.sh (add new script to library)
├── remove-script.sh (remove obsolete script)
├── frontend/
│   ├── login-screen.test.ts (Playwright test)
│   ├── login-screen.meta.json (Metadata)
│   ├── data-dashboard.test.ts
│   ├── data-dashboard.meta.json
│   ├── settings-view.test.ts
│   └── settings-view.meta.json
├── ios/
│   ├── LoginViewUITests.swift (XCUITest)
│   ├── LoginViewUITests.meta.json
│   ├── SettingsViewUITests.swift
│   └── SettingsViewUITests.meta.json
└── backend/
    ├── auth-api-test.sh (curl script)
    ├── auth-api-test.meta.json
    ├── crud-api-test.sh
    └── crud-api-test.meta.json
```

**Tracked in git:** Scripts and metadata (reusable templates)
**Gitignored:** None (all replay library files are tracked)

---

## Impact on False Completion Rate

**Current (Stage 3 before replay):** ~6-10% false completion rate

**After Verification Replay:** Expected **6-10%** (no change in accuracy)

**Why no impact on accuracy:**
- Replay doesn't change verification logic, just reuses it
- Main benefit: Token cost savings and faster verification
- Accuracy remains the same (proven verification scripts)

**Token cost impact:** 75% reduction in verification script generation costs

---

## Related Documentation

- **Behavioral Oracles** (.orchestration/oracles/README.md) - Original oracle system
- **Completion Criteria Registry** (.orchestration/completion-criteria/README.md) - Defines what to verify
- **Quality Validator Checklist** (.orchestration/quality-checklist/README.md) - Verification execution
- **Pattern Embeddings** (.orchestration/playbooks/README.md) - Semantic similarity for search

---

**Last Updated:** 2025-10-24 (Stage 3 Week 6)
**Next Update:** Stage 4 (ML-based script recommendation, automatic customization)
