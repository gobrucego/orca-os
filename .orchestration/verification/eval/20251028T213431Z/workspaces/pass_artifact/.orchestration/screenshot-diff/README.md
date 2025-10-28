# Mandatory Screenshot Diff - Visual Regression Detection

**Purpose:** Prevent "claimed but not done" UI work through pixel-level comparison

**Version:** 1.0.0 (Stage 3 Week 5)

---

## Overview

Screenshot Diff is the **anti-bullshit detector** for UI implementations. It compares BEFORE and AFTER screenshots to catch specialists who claim UI changes but delivered nothing visible.

**Philosophical Position:** If you claim UI changed, pixels must have changed. No pixels changed = no UI changed.

---

## Relationship to Design DNA System

**Screenshot Diff and Design DNA are complementary verification layers:**

| System | Purpose | Catches |
|--------|---------|---------|
| **Screenshot Diff** (this doc) | Implementation verification | "Claimed UI change but nothing actually changed" |
| **Design DNA visual-reviewer-v2** | Quality/taste verification | "UI changed but violates aesthetic standards" |

**Integration:**
```
Implementation claimed
    ↓
Screenshot Diff: Did pixels actually change?
    ✅ YES → visual-reviewer-v2: Does it match Design DNA?
    ❌ NO → BLOCKED (nothing changed)
```

**Both run:** Screenshot Diff checks IF implemented, Design DNA checks HOW WELL implemented.

---

## The Problem

**Scenario: Specialist Claims UI Work**

```
Specialist: "I implemented the login screen redesign"

Verification checks:
  ✅ LoginView.swift exists
  ✅ Build succeeds
  ✅ Screenshot present

Verdict: PASSED
```

**But when you look at the screenshot...**

BEFORE screenshot: Login screen with email/password fields
AFTER screenshot: **IDENTICAL** - Nothing changed!

**Result:** Specialist claimed work but didn't actually change the UI.

---

## The Solution: Pixel Diff

**New verification:**

```
BEFORE screenshot: login-before.png
AFTER screenshot: login-after.png

Screenshot Diff runs:
  compare -metric AE -fuzz 5% before.png after.png diff.png

Result: 15 pixels changed (0.001% of image)

Verdict: ❌ BLOCKED - No significant visual changes detected
```

**Now we catch the bullshit:** Specialist must actually implement visible changes.

---

## How It Works

### Step 1: Capture BEFORE Screenshot

**When:** Before implementation begins

```bash
# verification-agent captures baseline
# Frontend (Playwright)
page.screenshot({ path: '.orchestration/evidence/login-before.png' })

# iOS (XCUITest)
let screenshot = XCUIScreen.main.screenshot()
save(screenshot, to: '.orchestration/evidence/login-before.png')
```

### Step 2: Implementation

Specialist implements UI changes

### Step 3: Capture AFTER Screenshot

**When:** After implementation claimed

```bash
# verification-agent captures after implementation
# Same viewport, same state, same conditions
page.screenshot({ path: '.orchestration/evidence/login-after.png' })
```

### Step 4: Pixel Comparison

```bash
./orchestration/screenshot-diff/compare-screenshots.sh \
  login-before.png \
  login-after.png \
  --task-id login-redesign \
  --threshold 100 \
  --strict
```

**ImageMagick compare:**
- Counts pixels that differ between images
- Allows 5% fuzz for compression artifacts
- Generates diff visualization (red = changed)

### Step 5: Verdict

**Changed pixels ≥ threshold (100):**
```
✅ PASSED: 1,250 pixels changed (0.5% of image)
Visual changes confirmed.
```

**Changed pixels < threshold (100):**
```
❌ BLOCKED: 15 pixels changed (0.001% of image)
No significant visual changes detected.

Possible causes:
  1. Wrong screenshot captured
  2. Implementation incomplete
  3. BEFORE and AFTER are same file

Required: Review implementation and recapture screenshots
```

---

## Configuration

### Threshold: Minimum Pixels Changed

**Default:** 100 pixels

**Rationale:**
- Small change (button color): ~500-1000 pixels
- Medium change (new component): ~5000-10000 pixels
- Large change (screen redesign): ~50000+ pixels

**100 pixels** filters out noise (anti-aliasing, compression) while catching real non-implementations.

### Strict Mode

**--strict flag:** BLOCK if no visual changes

**Use when:**
- Specialist explicitly claimed "visual redesign"
- User requested UI changes
- Task type is "ui-refresh" or "visual-update"

**Don't use when:**
- Internal refactoring (no visual changes expected)
- Logic changes only
- Backend work

---

## Evidence

### Diff Visualization

**Output:** `{task-id}-diff.png`

**Format:** Red pixels = changed, Black pixels = unchanged

**Example:**
```
Before: Blue button with white text
After:  Green button with white text

Diff image: Button area shows red (color changed)
            Text area shows black (unchanged)
```

**Value:** Visual proof of what actually changed

### Diff Report JSON

**Output:** `{task-id}-diff-report.json`

```json
{
  "task_id": "login-redesign",
  "timestamp": "2025-10-24T22:00:00Z",
  "before_screenshot": ".orchestration/evidence/login-before.png",
  "after_screenshot": ".orchestration/evidence/login-after.png",
  "image_dimensions": {
    "width": 1440,
    "height": 900,
    "total_pixels": 1296000
  },
  "diff_analysis": {
    "changed_pixels": 1250,
    "percent_changed": 0.0964,
    "threshold_pixels": 100,
    "threshold_percent": 0.0077
  },
  "verdict": "PASSED",
  "severity": "SUCCESS",
  "diff_visualization": ".orchestration/evidence/login-redesign-diff.png",
  "strict_mode": true
}
```

**Added to proofpack.json** for audit trail.

---

## Integration with Verification Flow

### Current Flow (Stage 2)

```
Specialist implements
    ↓
verification-agent runs static checks
    ↓
verification-agent runs behavioral oracles
    ↓
Verdict: PASSED/BLOCKED
```

### Enhanced Flow (Stage 3 Week 5)

```
verification-agent captures BEFORE screenshot
    ↓
Specialist implements
    ↓
verification-agent captures AFTER screenshot
    ↓
Screenshot Diff runs pixel comparison
    ↓
If BLOCKED → Stop here (nothing changed)
    ↓
If PASSED → Continue to static checks
    ↓
verification-agent runs behavioral oracles
    ↓
If Design DNA exists → visual-reviewer-v2 (taste compliance)
    ↓
Verdict: PASSED (only if all layers pass)
```

---

## Design DNA Integration

**Screenshot Diff runs BEFORE Design DNA visual-reviewer-v2:**

```
Screenshot Diff (Stage 3): Did implementation happen?
    ✅ YES (pixels changed)
    ↓
visual-reviewer-v2 (Design DNA Phase 4): Is implementation taste-compliant?
    ✅ YES (matches DNA rules)
    ↓
quality-validator: Final approval
```

**Why this order:**
- No point checking taste compliance if nothing was implemented
- Screenshot Diff is fast (2 seconds)
- Design DNA review is slower (screenshots + analysis)

---

## Use Cases

### Use Case 1: Button Redesign

**Claim:** "Changed login button to premium style"

**Screenshot Diff:**
```
BEFORE: Standard blue button
AFTER: Premium dark button with gold accent

Changed pixels: 2,450 (button region)
Verdict: ✅ PASSED
```

**Then Design DNA:**
```
Linter: ✅ Gold usage within 10% limit
Visual: ✅ Typography matches Domaine Sans specs
Verdict: ✅ APPROVED
```

---

### Use Case 2: Fake Implementation

**Claim:** "Redesigned entire dashboard"

**Screenshot Diff:**
```
BEFORE: Dashboard with cards
AFTER: Dashboard with cards (IDENTICAL)

Changed pixels: 8 (compression artifacts)
Verdict: ❌ BLOCKED - No visual changes
```

**Stops here** - no need to run Design DNA on non-implementation.

---

### Use Case 3: Partial Implementation

**Claim:** "Added search bar and filters"

**Screenshot Diff:**
```
BEFORE: Header without search
AFTER: Header with search bar (filters missing)

Changed pixels: 1,200 (search bar only)
Verdict: ✅ PASSED (but...)
```

**Then behavioral oracle:**
```
test('should show filters'):
  ❌ FAILED - Filter buttons not found

Verdict: ❌ BLOCKED - Incomplete implementation
```

**Screenshot Diff passed** (search bar added) but **oracle caught missing filters**.

---

## Advantages

### 1. Catches Lazy Work

**Before Screenshot Diff:**
```
Specialist: "I redesigned it"
Review: (assumes it's done)
User: "This looks exactly the same!"
```

**After Screenshot Diff:**
```
Specialist: "I redesigned it"
Screenshot Diff: ❌ 5 pixels changed
Specialist: (caught, must actually implement)
```

### 2. Visual Proof

Diff image shows EXACTLY what changed:
- Red pixels = where work happened
- Black pixels = unchanged areas

Can verify specialist focused on right areas.

### 3. Prevents Iteration Loops

**Without Screenshot Diff:**
```
Iteration 1: Claim done → User sees nothing → Redo
Iteration 2: Claim done → Still wrong → Redo
Iteration 3: Actually done
Total: 3 iterations
```

**With Screenshot Diff:**
```
Iteration 1: Claim done → Screenshot Diff catches → Fix immediately
Iteration 2: Actually done
Total: 2 iterations (33% faster)
```

### 4. Quantifiable Evidence

"Changed 1,250 pixels (0.5% of screen)" is more concrete than "looks different to me"

---

## Limitations

### 1. Can't Detect Quality

Screenshot Diff only knows IF changed, not IF BETTER.

**Example:**
```
BEFORE: Beautiful button
AFTER: Ugly button (but different)

Screenshot Diff: ✅ PASSED (pixels changed)
```

**Solution:** Design DNA visual-reviewer-v2 catches quality issues.

### 2. Sensitive to Screenshot Conditions

**Different viewport:**
```
BEFORE: 1440px wide
AFTER: 1441px wide (1px difference)

Result: Entire screen flagged as changed
```

**Mitigation:** Enforce identical screenshot conditions (same viewport, same zoom).

### 3. Compression Artifacts

**JPEG compression:**
```
BEFORE: PNG (lossless)
AFTER: JPEG (lossy)

Result: 500 pixels "changed" (just compression)
```

**Mitigation:** Use PNG, allow 5% fuzz tolerance.

### 4. False Positives on Animations

**Animated UI:**
```
BEFORE: Button at frame 0
AFTER: Button at frame 5 (mid-animation)

Result: Massive diff (animation state)
```

**Mitigation:** Wait for animations to complete before screenshot.

---

## Best Practices

### 1. Consistent Screenshot Conditions

**Enforce:**
- Same viewport size
- Same zoom level
- Same browser/simulator
- Same UI state (modals closed, animations complete)
- Same theme (light/dark)

### 2. Wait for Stability

```typescript
// Playwright
await page.waitForLoadState('networkidle');
await page.waitForTimeout(500);  // Animations settle
await page.screenshot({ path: 'after.png' });
```

### 3. Use PNG Format

```typescript
await page.screenshot({
  path: 'screenshot.png',  // ✅ PNG (lossless)
  type: 'png'
});
```

### 4. Capture Multiple Viewports (if responsive)

```typescript
// Desktop
await page.setViewportSize({ width: 1440, height: 900 });
await page.screenshot({ path: 'before-desktop.png' });

// Mobile
await page.setViewportSize({ width: 375, height: 667 });
await page.screenshot({ path: 'before-mobile.png' });
```

Compare each viewport separately.

---

## Command Line Usage

```bash
# Basic usage
./orchestration/screenshot-diff/compare-screenshots.sh \
  before.png \
  after.png

# With task ID
./orchestration/screenshot-diff/compare-screenshots.sh \
  before.png \
  after.png \
  --task-id login-redesign

# Strict mode (block if no changes)
./orchestration/screenshot-diff/compare-screenshots.sh \
  before.png \
  after.png \
  --task-id login-redesign \
  --strict

# Custom threshold
./orchestration/screenshot-diff/compare-screenshots.sh \
  before.png \
  after.png \
  --threshold 500

# Custom output directory
./orchestration/screenshot-diff/compare-screenshots.sh \
  before.png \
  after.png \
  --output-dir /custom/path
```

---

## Dependencies

### ImageMagick

**Required for:** `compare` command (pixel diff)

**Install:**
```bash
# macOS
brew install imagemagick

# Verify
compare -version
```

**Alternative:** Could use Node.js `pixelmatch` library, but ImageMagick is standard.

---

## Impact on False Completion Rate

**Current:** ~15-20% after Stage 2 (Behavioral Oracles)

**After Screenshot Diff:** Expected **10-15%**

**Why:**
- Catches specialists claiming UI work without implementing
- Prevents "looks the same but build passes" false completions
- Adds visual evidence layer

**Not massive reduction because:**
- Most false completions are logic bugs (not "no implementation")
- Behavioral oracles already catch many UI issues
- Main benefit: Prevents specific "lazy UI work" pattern

---

## Integration with Proofpack

Screenshot Diff results added to proofpack.json:

```json
{
  "evidence": {
    "screenshots": {
      "before": "data:image/png;base64,...",
      "after": "data:image/png;base64,...",
      "diff": "data:image/png;base64,..."
    },
    "screenshot_diff": {
      "changed_pixels": 1250,
      "percent_changed": 0.0964,
      "threshold_pixels": 100,
      "verdict": "PASSED",
      "diff_visualization": ".orchestration/evidence/login-redesign-diff.png",
      "report": ".orchestration/evidence/login-redesign-diff-report.json"
    }
  }
}
```

---

## Future Enhancements

### Stage 4+

**Perceptual Diff (not just pixel diff):**
- Use perceptual hash (pHash)
- Detect "looks different to human" vs "pixels different"
- More robust to minor rendering differences

**Region-Based Diff:**
- Define regions of interest (header, sidebar, content)
- Report: "Header: 2000 pixels changed, Sidebar: 50 pixels changed"
- Catch partial implementations

**Historical Baseline:**
- Store baseline screenshots for each screen
- Compare new implementation to baseline
- Detect unintended visual regressions

**Animation Detection:**
- Capture multiple frames
- Detect if "changed pixels" are just animation
- Auto-adjust threshold

---

## Related Documentation

- **Design DNA System** (docs/DESIGN_DNA_SYSTEM.md) - Quality/taste verification (complementary)
- **Behavioral Oracles** (.orchestration/oracles/README.md) - Functional verification
- **Unified Proof Artifact** (.orchestration/proofpacks/README.md) - Evidence storage
- **verification-agent.md** - Runs screenshot diff

---

**Last Updated:** 2025-10-24 (Stage 3 Week 5)
**Next Update:** Stage 4 (Perceptual diff integration)
