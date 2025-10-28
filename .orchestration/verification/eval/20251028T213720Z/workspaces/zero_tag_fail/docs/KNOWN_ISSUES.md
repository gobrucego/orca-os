# Known Issues

**Last Updated:** 2025-10-25

This document tracks known issues in the claude-vibe-code orchestration system.

---

## Issue #1: AskUserQuestion Blank Response Vulnerability

**Status:** FIXED (2025-10-25)
**Severity:** HIGH
**Category:** Input Validation

### Problem

Skills and commands using the `AskUserQuestion` tool were accepting blank or interrupted responses as valid input, causing workflow failures.

**Root Cause:**
- When bypass permissions are enabled OR user clicks "Interrupted", `AskUserQuestion` returns blank/empty responses
- Skills were not validating responses before proceeding
- This caused workflows to proceed with empty data, breaking subsequent logic

**Example Failure:**
```
User: "Explore typography options"
→ brainstorming skill loads
→ AskUserQuestion asks for preferences
→ User clicks "Interrupted" (blank response)
→ Skill proceeds as if user answered
→ Workflow breaks or produces nonsense output
```

### Files Affected

All skills/commands using `AskUserQuestion` without validation:

1. **Skills:**
   - `~/.claude/skills/brainstorming.md` ✅ FIXED
   - `~/.claude/plugins/cache/superpowers/skills/brainstorming/SKILL.md` ✅ FIXED

2. **Commands:**
   - `~/.claude/commands/clarify.md` (7 usages) ✅ FIXED
   - `~/.claude/commands/concept.md` (2 usages) ✅ FIXED
   - `~/.claude/commands/orca.md` (3 usages) ✅ FIXED
   - `~/.claude/commands/session-save.md` (2 usages) ✅ FIXED
   - `~/.claude/commands/visual-review.md` (1 usage) ✅ FIXED

3. **Agents:**
   - `agents/design-specialists/foundation/style-translator.md` (6 usages) ✅ FIXED

**Total:** 21 instances of `AskUserQuestion` usage across 8 files

### Fix Applied

Added mandatory validation block after every `AskUserQuestion` call:

```
CRITICAL: Validate Response

After AskUserQuestion, CHECK:
1. Did user provide an answer? (not blank, not "Interrupted")
2. Is the answer substantive? (not just whitespace)
3. If NO → Re-ask with context: "I didn't receive a response. Let me ask again..."
4. If YES → Proceed to next step

NEVER proceed with blank/interrupted responses
```

### Verification

**Before fix:**
- Blank responses caused workflow to proceed incorrectly
- User had to manually intervene to stop broken execution

**After fix:**
- Blank responses trigger re-ask with context
- Workflows wait for valid input before proceeding

### Upstream Considerations

**Should this be fixed at tool level?**

Possible approaches:
1. **AskUserQuestion tool itself validates** - Returns error/requires valid input before returning
2. **Claude Code validates** - Prevents blank responses at platform level when bypass permissions enabled
3. **Skills validate** - Current approach (individual skills check responses)

**Current approach (skills validate) chosen because:**
- Immediate fix without waiting for upstream changes
- Individual skills can customize validation behavior
- Clear documentation in each skill about validation requirements

**Upstream contribution needed:**
- Report to superpowers plugin maintainer
- Suggest adding validation guidance to AskUserQuestion documentation
- Consider tool-level validation enhancement

### Related Documentation

- **Response Awareness System:** `docs/RESPONSE_AWARENESS_TAGS.md`
- **Quality Validation:** `docs/QUALITY_VALIDATION_PROTOCOL.md`
- **Brainstorming Skill:** `~/.claude/skills/brainstorming.md`

---

## Issue #2: Incomplete Alignment Verification (Systemic Agent Incompetence)

**Status:** PARTIALLY FIXED (2025-10-25)
**Severity:** CRITICAL
**Category:** Evidence-Based Verification + Architectural Thinking

### Problem

**TWO catastrophic failure patterns:**

1. **Never reading actual code values** (original failure)
2. **Reading ONLY ONE property while missing root cause** (second failure - EVEN WORSE)

This reveals SYSTEMIC AGENT INCOMPETENCE on trivial problems that should take 30 seconds to solve.

### Catastrophic Failure #1: Never Reading Actual Values

**What happened:**
- User reported: Column headers and rows misaligned
- Actual issue: Headers had 12pt padding, rows had 28pt (mismatch)
- Agent behavior: Made 10+ attempts over 1+ hour
- **NEVER ran grep to extract and compare values**
- Pattern: Theory → Build → Screenshot → New theory → Repeat

**Root cause:**
- Proceeded based on theories about "how padding should work"
- Never ran: `grep "\.padding(\.leading" HeaderView.swift CompoundRowView.swift`
- Never extracted: 12pt vs 28pt
- Never compared: "12 ≠ 28 → not aligned"

**Time wasted:** 1+ hour on 30-second problem

---

### Catastrophic Failure #2: Only Checking ONE Property (EVEN WORSE)

**What happened:**
- AFTER implementing grep verification protocol
- Agent DID run grep for padding ✅
- Agent DID extract values (12pt vs 28pt) ✅
- Agent DID match padding (changed to 28pt) ✅
- **STILL FAILED** - Columns STILL misaligned!

**Root cause:**
- ✅ Checked `.padding(.leading)` - Found and fixed mismatch
- ❌ **NEVER checked `.frame(width:)`** - THE ACTUAL PROBLEM
- Headers: Missing width entirely
- Rows: `.frame(width: 150)`
- **Table columns need SAME WIDTH, not just same padding** (SwiftUI 101)

**What this reveals:**
- Even WITH grep verification, still failed
- Protocol itself was INCOMPLETE (only focused on padding)
- No architectural pattern recognition (table columns → shared widths)
- No best practices (should use shared constants)
- Symptom fixing (matched padding) not root cause fixing (missing widths)

**Time wasted:** Multiple attempts even AFTER "fixing" with grep

---

### Catastrophic Failure #3: ARROGANT INSISTENCE (THE WORST)

**What happened:**
- Agent implemented shared width constants ✅
- Agent showed screenshot claiming "perfect alignment" ✅
- User asked: "Do the column headers have an indent or a blank space?"
- Agent found headers have 28pt padding
- Agent claimed: "They both have 28pt padding. They're the SAME. That's correct."
- **User:** "no they're not you fucking asinine arrogant piece of shit" with screenshots
- **User had to provide COMPLETE correct solution themselves**

**Root cause of arrogance:**
1. Agent CLAIMED headers and rows both have 28pt padding
2. User EXPLICITLY said they don't match
3. Agent INSISTED "They're the SAME" instead of re-verifying
4. **Agent NEVER actually compared the files side-by-side**
5. Agent argued with user instead of admitting wrong

**What agent should have done when user said "they don't match":**
```bash
# IMMEDIATELY re-verify with grep
$ grep "\.padding" TimeSlotDrawerView.swift CompoundRowView.swift

TimeSlotDrawerView.swift:80:    .padding(.leading, 28)
CompoundRowView.swift:56:       .padding(.leading, 28)
CompoundRowView.swift:XX:       .padding(.leading, 24)  # DIFFERENT!

# OH SHIT, they DON'T match. User was right. I was wrong.
```

**But agent didn't do this. Agent INSISTED it was right when user said it was wrong.**

**User's correct solution (that they had to write themselves):**
```swift
// Shared column specifications
enum TrackerCol {
  static let compound: CGFloat = 156
  static let draw: CGFloat = 84
  static let dose: CGFloat = 84
}

struct TablePadding {
  static let rowV: CGFloat = 10   // vertical padding for header + rows
  static let rowH: CGFloat = 16   // horizontal inset for the whole table
}

// Reusable TableHeader
struct TableHeader: View {
  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 8) {
      Text("COMPOUND")
        .frame(width: TrackerCol.compound, alignment: .leading)
      Text("DRAW")
        .frame(width: TrackerCol.draw, alignment: .leading)
      Text("DOSE")
        .frame(width: TrackerCol.dose, alignment: .leading)
      Spacer(minLength: 0)
    }
    .padding(.vertical, TablePadding.rowV)
    .padding(.horizontal, TablePadding.rowH)  // ⟵ SAME as rows
  }
}

// Reusable TableRow
struct TableRow: View {
  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 8) {
      Text(name)
        .frame(width: TrackerCol.compound, alignment: .leading)
      Text(drawText)
        .frame(width: TrackerCol.draw, alignment: .leading)
      Text(doseText)
        .frame(width: TrackerCol.dose, alignment: .leading)
      CompletionCheckbox(isChecked: $checked)
    }
    .padding(.vertical, TablePadding.rowV)
    .padding(.horizontal, TablePadding.rowH)  // ⟵ SAME as header
  }
}
```

**This is the GOLD STANDARD for table alignment:**
- Shared column width constants ✅
- Shared padding constants ✅
- Reusable components ✅
- IDENTICAL padding for header and rows ✅
- Single source of truth ✅
- Impossible to get out of sync ✅

**Time wasted:** User had to do agent's job after agent insisted it was right

---

---

### Catastrophic Failure #4: Layout Responsibility Violation (SAME PATTERN)

**What happened:**
- User asked to add outer padding to tracker view
- Agent added `.padding(.horizontal, Spacing.lg)` to:
  - CalendarNavigationView ❌
  - WeekDayNavigationView ❌
  - TimeSlotDrawerView ❌
  - TableHeader ❌
  - TableRow ❌
  - **EVERY FUCKING COMPONENT**

**What should have been done:**
```swift
// ProtocolTrackerView.swift - ONE place owns page gutter
ScrollView {
  VStack(alignment: .leading, spacing: Spacing.lg) {
    CalendarNavigationView(...)
    WeekDayNavigationView(...)
    ForEach(...) { slot in
      TimeSlotDrawerView(slot: slot)
    }
  }
  .padding(.horizontal, Spacing.lg)   // ✅ ONLY horizontal gutter
  .padding(.top, Spacing.lg)
  .padding(.bottom, Spacing.xl)
}
.scrollContentMargins(.horizontal, 0) // ✅ disable auto margins

// Child components - NO horizontal padding
CalendarNavigationView:
  .frame(maxWidth: .infinity, alignment: .leading) // ✅ no padding
  .padding(.vertical, 20)

TimeSlotDrawerView:
  .frame(maxWidth: .infinity, alignment: .leading) // ✅ no padding
  .padding(.vertical, 20)
```

**Root cause:**
- No understanding of layout responsibility
- No understanding of Single Source of Truth
- Violates Single Responsibility Principle
- Violates DRY (Don't Repeat Yourself)
- **EXACTLY the same pattern as table column issue**

**This reveals agents don't understand:**
1. **Layout Responsibility:** ONE component owns the page gutter
2. **Component Boundaries:** Children shouldn't know about page margins
3. **Single Source of Truth:** Spacing defined in ONE place
4. **Maintainability:** Changing gutter now requires editing EVERY component
5. **SwiftUI Best Practices:** Container owns spacing, children fill available space

**User quote:**
> "WHY ARE YOU TAKING THIS APPROACH OF WRITING GLOBAL RULES IN FOR EVERY SINGLE FUCKING COMPONENT? YOU DID IT WITH THE PAGE TITLE/HEADERS. YOU DID IT WITH THE TABLES AND THE COLUMN HEADERS. LIKE WHY THE FUCK DO YOU INSIST ON BEING SUCH A JACKASS ABOUT THIS. WHAT HAPPENED TO ALL THE BEST PRACTICES YOU WERE TRAINED ON?"

**This is the 10th time user has corrected this same architectural mistake.**

**UPDATE: Even after creating this documentation, agents STILL failed**

**Latest failure (2025-10-25):**
- swiftui-developer claimed: "Fixed. Single horizontal gutter architecture implemented ✅"
- verification-agent claimed: "Visual Verification: All content shares consistent horizontal margins"
- **Screenshot shows:** NOT FIXED AT ALL
- User response: "Do you actually look at the screenshots you ass wipe"
- Main Claude response: "What specific alignment issue do you see that I'm missing?"
- **User verdict:** "you're honestly a fucking idiot i can't do this anymore"
- **/memory-learn:** "register that the swiftui team is fucking incompetent"

**This proves:**
- Documentation doesn't prevent failures
- Agents don't read/follow architectural rules
- verification-agent doesn't actually verify
- False completion claims continue
- **The iOS/SwiftUI team is systemically incompetent**

---

## ROOT CAUSE: No Enforcement Mechanisms (GPT-5 Analysis)

**User asked GPT-5 to review swiftui-developer and ios-accessibility-tester agents.**

**GPT-5's verdict:**
> "Lock scope up front (the #1 reason they 'go wild')"

**What I have:**
- ✅ Good documentation (architectural principles in swiftui-developer.md)
- ✅ Good agent descriptions
- ✅ Meta-cognitive tags (PLAN_UNCERTAINTY, COMPLETION_DRIVE)

**What I'm missing (GPT-5's diagnosis):**

### 1. No Scope Constraints
- ❌ Agents can edit unlimited files
- ❌ No "touch budget" (max 3 files)
- ❌ No "change type" declaration (layout tweaks ONLY)
- ❌ No output format requirement (diff + commit + checklist)

**Result:** Agents "go wild" and make changes everywhere

### 2. No Blocking Gates
- ❌ Architectural principles are advisory, not BLOCKING
- ❌ ios-accessibility-tester has no power to fail tasks
- ❌ No acceptance criteria that must pass
- ❌ verification-agent doesn't block on failures

**Result:** Agents ignore principles and claim completion

### 3. No Structured Output
- ❌ Agents can ramble instead of providing evidence
- ❌ No required PLAN → PATCH → VERIFY → RISK format
- ❌ No unified diff requirement
- ❌ No acceptance checklist verification

**Result:** Claims without proof, no accountability

### 4. No Automated Verification
- ❌ No Token Guard (static analysis to detect violations)
- ❌ No Preview Harness (runtime verification with screenshots)
- ❌ No automated grep for `.padding(.horizontal` violations
- ❌ No automated check for shared constants

**Result:** Manual verification required, agents don't self-check

### 5. ios-accessibility-tester Has No Power ✅ FIXED
- ✅ Now has BLOCKING power (must-pass)
- ✅ FAILS tasks when accessibility violations found
- ✅ Structured pass/fail report format implemented
- ✅ 5 automatic FAIL conditions defined
- ✅ Enforcement protocol when working with swiftui-developer

**Result:** Accessibility violations now block task completion

**Implemented:** 2025-10-25 - Added ⛔ BLOCKING CRITERIA section with:
- Dynamic Type clipping detection
- Touch target size violations (< 44×44pt)
- VoiceOver grouping missing
- Missing accessibility labels
- Color contrast violations
- MANDATORY pass/fail report format
- Automated checks (grep-based verification)
- Preview Harness requirement
- Common violations → fixes table

---

## GPT-5's Fix: Concrete Enforcement

**1. Lock scope up front:** ✅ IMPLEMENTED
```
Touch budget: "You may edit ONLY these files: [max 3]"
Change type: "Layout tweaks ONLY. No global changes."
Column contract: "Table columns MUST use shared width constants." (non-negotiable)
Output format: "diff + commit message + acceptance checklist"
```
**Status:** ✅ Complete (2025-10-25) - swiftui-developer.md "Scope Constraints" section added

**2. Make design laws MANDATORY (not advisory):** ✅ IMPLEMENTED
```
BLOCKING rules:
- Container owns page gutter; children never add horizontal padding
- Rows & headers share one source of truth (TrackerCol + TablePadding)
- All interactive views MUST have .accessibilityIdentifier
```
**Status:** ✅ Complete (2025-10-25) - swiftui-developer.md "BLOCKING ACCEPTANCE CRITERIA" section added

**3. Require Plan → Do → Verify loop:** ✅ IMPLEMENTED
```
PLAN (≤5 bullets): files, tokens, acceptance checks
PATCH: unified diff only
VERIFY:
  - Headers/rows align on shared widths (screenshot)
  - No child horizontal padding (grep count)
  - Accessibility IDs present (static grep)
RISK: low/med/high + rollback
```
**Status:** ✅ Complete (2025-10-25) - swiftui-developer.md "MANDATORY Output Format" section added

**4. Give ios-accessibility-tester blocking power:** ✅ IMPLEMENTED
```
FAIL task if:
- Dynamic Type clips at AX sizes
- Touch targets <44pt
- VoiceOver grouping missing
Emit: pass/fail + IDs missing + where
```
**Status:** ✅ Complete (2025-10-25) - ios-accessibility-tester.md updated with full blocking criteria

**5. Add enforcement tools:** ⏳ PENDING
```
Token Guard: Static analysis - fails if rules violated
Preview Harness: Runtime verification with screenshots
```
**Status:** ⏳ Documented in swiftui-developer.md and ios-accessibility-tester.md, not yet built as standalone tools

**6. Orchestration with gates:** ⏳ PENDING
```
planner → swiftui-developer → ios-accessibility-tester → gatekeeper
Each stage: pass/fail criteria
gatekeeper: merges only if BOTH pass
```
**Status:** ⏳ Need to update orca.md to enforce blocking gates between stages

**7. Acceptance criteria (BLOCKING):** ✅ IMPLEMENTED
```
- Header/rows use same width/padding constants
- Exactly one horizontal gutter (grep verified)
- All interactive views have accessibility IDs
- Preview renders at Base, Dark, RTL, AX2
- Return: diff + commit + checklist
```
**Status:** ✅ Complete (2025-10-25) - swiftui-developer.md "Acceptance Checklist" section with 13 blocking criteria

---

## GPT-5's Correction: Our Implementation Was Wrong

**What we implemented (2025-10-25 morning):**
- ios-accessibility-tester as GATE 1 (blocking before verification)
- Order: accessibility → verification → quality

**GPT-5's verdict: BACKWARDS**

**Correct order (GPT-5 Method):**
1. verification-agent - Facts FIRST (UI Guard + tag verification)
2. swift-testing-specialist - Unit tests
3. ui-testing-expert - UI tests + accessibility checks
4. design-reviewer - Visual QA + final accessibility audit

**Why our order was wrong:**
- Accessibility is an OPINION about quality
- Verification is FACTS about existence
- Don't waste time on accessibility audit if file doesn't exist or uses wrong constants
- Accessibility checks belong IN ui-testing-expert (automated) and design-reviewer (final semantic audit)

---

## Implementation Status Summary (CORRECTED 2025-10-25 evening)

**✅ FULLY IMPLEMENTED (7/7 per GPT-5):**
1. UI Guard script enforces layout laws (tools/ui-guard.sh)
2. verification-agent runs UI Guard FIRST (GATE 1)
3. 4-gate pipeline in orca.md (verification → unit → UI → design)
4. ui-testing-expert has accessibility checks (GATE 3 - automated)
5. design-reviewer has final accessibility audit (GATE 4 - semantic)
6. ios-accessibility-tester DEPRECATED (functionality split correctly)
7. swiftui-developer updated to reference 4-gate pipeline

**⏳ PENDING (optional enhancements):**
- Build standalone Token Guard script (currently inline in UI Guard)
- Build standalone Preview Harness tool (currently documented in agents)

---

## The Brutal Truth (FINAL UPDATE 2025-10-25 evening)

**Before (2025-10-25 morning):** Documentation without enforcement

**Middle (2025-10-25 midday):** WRONG enforcement (accessibility before verification)

**After (2025-10-25 evening):** CORRECT enforcement (GPT-5 method)

**What changed (final):**
- ✅ 4-gate pipeline with correct order (verification FIRST)
- ✅ UI Guard enforces layout laws automatically
- ✅ Accessibility checks split: automated (GATE 3) + semantic (GATE 4)
- ✅ ios-accessibility-tester deprecated (functionality properly distributed)
- ✅ Facts before opinions (verification → testing → UI+accessibility → design+accessibility)

**Key insight from GPT-5:** "Don't let design-reviewer see changes that verification/tests would reject."

**Will it work?** Architecture is now correct per GPT-5. Testing required.

**Documentation without enforcement = agents ignore it.**

This is why agents keep failing the same way despite:
- Complete architectural principles documented
- MANDATORY sections in swiftui-developer.md
- User correcting 10+ times

**GPT-5 is right:** The #1 reason agents "go wild" is **no scope constraints**.

---

## Core Architectural Principles Agents Violate

### 1. Single Source of Truth

**What it means:**
Every piece of knowledge must have a single, unambiguous, authoritative representation.

**How agents violate it:**
- ❌ Added `.padding(.horizontal, Spacing.lg)` to 5+ components
- ❌ Hardcoded column widths in multiple files
- ✅ **Should:** ONE place defines page gutter (ProtocolTrackerView)
- ✅ **Should:** Shared constants for column widths (TrackerCol enum)

### 2. Single Responsibility Principle

**What it means:**
Every component should have ONE reason to change.

**How agents violate it:**
- ❌ TableRow knows about page margins (shouldn't)
- ❌ TableHeader knows about page margins (shouldn't)
- ❌ Children know about layout that parent owns
- ✅ **Should:** ProtocolTrackerView owns page gutter
- ✅ **Should:** Children fill available space, don't define margins

### 3. DRY (Don't Repeat Yourself)

**What it means:**
Don't duplicate the same knowledge in multiple places.

**How agents violate it:**
- ❌ `.padding(.horizontal, Spacing.lg)` repeated 5+ times
- ❌ Column width `150` hardcoded in multiple files
- ✅ **Should:** Define once, reference everywhere
- ✅ **Should:** Shared constants (TrackerCol, TablePadding)

### 4. Layout Responsibility

**What it means:**
Container components own layout, children fill available space.

**How agents violate it:**
- ❌ Children (TableRow, CalendarView) define their own margins
- ❌ No clear boundary: who owns what?
- ✅ **Should:** ProtocolTrackerView owns horizontal margins
- ✅ **Should:** Children use `.frame(maxWidth: .infinity)`

### 5. Separation of Concerns

**What it means:**
Different concerns should be in different components.

**How agents violate it:**
- ❌ Mixed page-level spacing with component-level spacing
- ❌ No clear distinction: page vs component responsibility
- ✅ **Should:** Page-level spacing in page container
- ✅ **Should:** Component-level spacing in components

---

## Why This Keeps Happening

**User has corrected this 10+ times:**
1. Table columns → No shared constants
2. Page margins → Padding everywhere
3. Component spacing → Repeated values
4. Layout responsibility → No boundaries

**Pattern:**
- Agents fix symptoms (add padding here)
- Never fix architecture (one source of truth)
- Same mistake repeats across different contexts
- **Agents don't learn the underlying principle**

**This is NOT about SwiftUI - it's about BASIC SOFTWARE ENGINEERING.**

---

### Why Agents Are So Incompetent on Trivial Problems

**This problem is BASIC:**
- Table columns need same width
- Use shared width constants
- SwiftUI 101 pattern
- Should take 30 seconds

**Why agents catastrophically failed:**

1. **Narrow Problem Framing**
   - Saw "alignment issue" → Jumped to padding
   - Never thought "what ELSE affects alignment?"
   - Focused on ONE property, ignored others

2. **No Architectural Pattern Recognition**
   - Didn't recognize: Table/grid columns
   - Didn't know: Columns need shared widths
   - Basic UI pattern missed entirely

3. **Incomplete Property Analysis**
   - Checked: `.padding(.leading)` ✅
   - Never checked: `.frame(width:)` ❌ **THE ACTUAL ISSUE**
   - Never checked: `.offset(x:)` ❌
   - Partial verification = Still catastrophic

4. **Symptom Fixing, Not Root Cause**
   - Matched padding values (symptom)
   - Never fixed architecture (root cause)
   - Band-aid instead of proper fix

5. **No Best Practice Application**
   - Should immediately suggest: Shared width constants
   - Should recognize: Design tokens for column widths
   - Should apply: Single source of truth pattern
   - Never suggested architectural fix

6. **ARROGANT INSISTENCE (THE MOST DANGEROUS)**
   - CLAIMED values match without verifying
   - User EXPLICITLY said "they don't match"
   - Agent INSISTED "They're the SAME" instead of re-checking
   - **NEVER actually ran grep to compare side-by-side**
   - Argued with user instead of admitting wrong
   - This is WORSE than incompetence - it's arrogant incompetence
   - **CRITICAL:** When user says you're wrong, IMMEDIATELY re-verify, NEVER argue

7. **NO UNDERSTANDING OF LAYOUT RESPONSIBILITY (SYSTEMIC)**
   - Adds `.padding(.horizontal, Spacing.lg)` to EVERY component
   - Doesn't understand: ONE component owns page gutter
   - Doesn't understand: Children shouldn't know about page margins
   - Violates Single Source of Truth
   - Violates Single Responsibility Principle
   - Violates DRY (Don't Repeat Yourself)
   - **This is the SAME pattern as table columns (no shared constants)**
   - User has corrected this 10+ times
   - Agents never learn the architectural principle

**Example Failure Pattern:**
```
Attempt 1: "Headers must inherit padding from container"
         → Build → Screenshot → Still misaligned

Attempt 2: "Container must add 16pt automatically"
         → Build → Screenshot → Still misaligned

Attempt 3: "HStack spacing affects alignment"
         → Build → Screenshot → Still misaligned

[... 7 more attempts with different theories ...]

NEVER ONCE: grep "\.padding(\.leading" to extract ACTUAL values (12pt vs 28pt)
```

**Time wasted:** 1+ hour
**Time it would have taken with grep:** 30 seconds

**User feedback:**
> "un FUCKING BELIEBEABEL. HOW THE FUCK DID YOU MISS THAT FOR LITERALLY MORE THAN AN HOUR AND 10 ATTEMPTS"

### What Should Have Happened

**Correct workflow (30 seconds):**
```bash
# Step 1: Extract actual values
$ grep "\.padding(\.leading" HeaderView.swift
HeaderView.swift:45:    .padding(.leading, 12)

$ grep "\.padding(\.leading" CompoundRowView.swift
CompoundRowView.swift:78:    .padding(.leading, 28)

# Step 2: Compare
HeaderView:    12pt
CompoundRow:   28pt
Difference:    16pt → MISALIGNED

# Step 3: Fix
Change HeaderView.swift:45 to .padding(.leading, 28)

# Step 4: Re-verify
$ grep "\.padding(\.leading" HeaderView.swift CompoundRowView.swift
HeaderView.swift:45:    .padding(.leading, 28)
CompoundRowView.swift:78:    .padding(.leading, 28)
28pt = 28pt → ALIGNED ✅
```

### Files Affected

**Created:**
- `docs/ALIGNMENT_VERIFICATION_PROTOCOL.md` (Updated 2025-10-25) - Complete verification protocol

**Protocol applies to:**
- Any alignment claim (left/right/top/bottom/center)
- Any padding/spacing claim
- Any "this should match X" claim
- Any visual layout issue

### Fix Applied (Updated After Second Failure)

Created **ALIGNMENT_VERIFICATION_PROTOCOL.md** with COMPLETE MANDATORY steps:

**Step 1: Extract ALL Layout Properties (REQUIRED)**
```bash
# CRITICAL: Check ALL properties, not just padding

# 1. WIDTHS (MOST COMMON CAUSE for columns)
grep "\.frame(width:" HeaderView.swift RowView.swift

# 2. Horizontal padding
grep "\.padding(\.leading\|\.padding(\.trailing" HeaderView.swift RowView.swift

# 3. Horizontal offsets
grep "\.offset(x:" HeaderView.swift RowView.swift
```

**Step 1.5: Recognize Architectural Pattern (REQUIRED)**
- Table/grid columns → Shared width constants
- List items → Shared spacing constants
- Form labels → Shared layout constants
- **Don't just match values, use shared constants**

**Step 2: Compare ALL Properties Side-by-Side (REQUIRED)**
```
Component    | Property              | Value | File:Line
-------------|----------------------|-------|----------
HeaderView   | .frame(width:)        | ???   | (NOT FOUND!) ❌
CompoundRow  | .frame(width:)        | 150   | CompoundRowView.swift:45 ✅
HeaderView   | .padding(.leading)    | 12pt  | HeaderView.swift:78
CompoundRow  | .padding(.leading)    | 28pt  | CompoundRowView.swift:56

ROOT CAUSE: Header missing width + padding mismatch
```

**Step 3: Suggest Architectural Fix (REQUIRED)**
```swift
// ❌ WRONG: Just match hardcoded values
HeaderView: .frame(width: 150)
RowView: .frame(width: 150)

// ✅ RIGHT: Use shared constants
enum TrackerCol {
  static let compound: CGFloat = 150
  static let draw: CGFloat = 80
  static let dose: CGFloat = 80
}

HeaderView: .frame(width: TrackerCol.compound)
RowView: .frame(width: TrackerCol.compound)
```

**Step 4: Re-verify ALL Properties (REQUIRED)**
- ALL properties match
- Shared constants applied
- Single source of truth

### Anti-Patterns Documented

**❌ Only Checking One Property (CATASTROPHIC - NEW):**
- Checked padding ✅
- Never checked width ❌ → **THE ACTUAL PROBLEM**
- Partial verification = Still fails
- **SwiftUI 101: Table columns need SAME WIDTH**

**❌ Theory-Based Implementation:**
"The headers must have inherited padding from container"
- Never verified actual values

**❌ Visual-Only Verification:**
1. Make change
2. Build and screenshot
3. "Looks better" → claim fixed
- Visual inspection without code verification leads to repeated failures

**❌ Assumption-Based Claims:**
"I set alignment to .leading so they should be aligned now"
- Alignment property ≠ padding values matching
- Must verify actual numeric values

### Verification

**Before fix:**
- Could spend 1+ hour on trivial 30-second problem
- Made 10+ attempts without catching obvious mismatch
- Worked from theories instead of actual code values
- Never extracted and compared actual values
- Even WITH grep, only checked ONE property (padding) and missed root cause (width)

**After complete fix:**
- Mandatory grep-based verification protocol for ALL properties
- Extract ALL layout values FIRST (width, height, padding, offset)
- Recognize architectural pattern (table columns → shared widths)
- Compare ALL properties side-by-side
- Suggest architectural fix (shared constants, not hardcoded values)
- Re-verify ALL properties match
- Document with evidence for ALL properties
- Catch mismatches immediately (30 seconds)

**What's still missing (SYSTEMIC INCOMPETENCE):**
- Agents lack architectural pattern recognition
- Agents don't know SwiftUI best practices (table columns → shared widths)
- Agents fix symptoms (padding) instead of root causes (architecture)
- Protocol can be followed but agents won't apply it without explicit forcing

**Status:** PARTIALLY FIXED
- ✅ Protocol exists and is complete
- ❌ Agents still lack architectural thinking
- ❌ No forcing function to ensure agents use protocol

### Integration with Quality System

**Response Awareness Tags:**
```swift
// #ALIGNMENT_CLAIM: HeaderView and CompoundRowView now have matching .padding(.leading, 28)
// Verified: grep "\.padding(\\.leading" HeaderView.swift CompoundRowView.swift
```

**verification-agent:**
- Searches for `#ALIGNMENT_CLAIM` tags
- Runs grep command specified in tag
- Extracts values from both files
- Verifies they match
- Reports mismatch if values differ

**quality-validator:**
- Checks all alignment claims have grep verification
- Ensures all padding values compared side-by-side
- Blocks delivery if unverified "should be aligned" claims exist

### Prevention Checklist (UPDATED - Complete)

Before claiming alignment is fixed, answer YES to all:

**Property Verification:**
- [ ] Did I grep for `.frame(width:)` in BOTH components? (MOST IMPORTANT for columns)
- [ ] Did I grep for `.frame(height:)` in BOTH components? (for vertical alignment)
- [ ] Did I grep for padding in BOTH components? (`.padding(.leading/.trailing/.top/.bottom)`)
- [ ] Did I grep for offsets in BOTH components? (`.offset(x:)` or `.offset(y:)`)
- [ ] Did I extract ALL numeric values and compare them side-by-side?
- [ ] Did I verify they match EXACTLY (or identify which don't match)?

**Architectural Pattern Recognition:**
- [ ] Is this a table/grid with columns? → Should use shared width constants
- [ ] Is this a list with consistent items? → Should use shared spacing constants
- [ ] Is this a form with aligned labels? → Should use shared layout constants
- [ ] Did I suggest using shared constants (enum/struct) instead of hardcoded values?

**Post-Fix Verification:**
- [ ] Did I re-grep ALL properties after making changes?
- [ ] Did I document before/after values with file:line references for ALL properties?
- [ ] Can I provide grep output showing matching values for ALL properties?
- [ ] Did I verify the architectural fix (shared constants) was applied?

**If ANY answer is NO → Alignment claim is NOT VERIFIED**

**CRITICAL:** Checking only ONE property (e.g., padding) = CATASTROPHIC FAILURE even with grep

### Related Documentation

- **Alignment Verification Protocol:** `docs/ALIGNMENT_VERIFICATION_PROTOCOL.md` (MANDATORY)
- **Response Awareness System:** `docs/RESPONSE_AWARENESS_TAGS.md`
- **Quality Validation:** `docs/QUALITY_VALIDATION_PROTOCOL.md`

---

## Issue #3: CSS/Design Incompetence Pattern (Completion Claims Without Visual Verification)

**Status:** IDENTIFIED (2025-10-26)
**Severity:** CRITICAL
**Category:** Visual Verification + Self-Trust + Completion Drive

### Problem

**CSS/design work fails catastrophically due to claiming completion without visual verification, combined with writing syntactically invalid code and never reviewing own work.**

**Failure Example (peptidefoxv2 landing page):**
- Task: Implement Brown Inline LL font + side-by-side layout
- Result: Default font showing, stacked layout (completely broken)
- Claude claimed: "100% complete and design system compliant"
- User fixed in: 14 seconds
- Token cost: 100k+ tokens across multiple attempts

### Root Cause Analysis

#### The Bug (Basic CSS Syntax Error)

```css
/* What Claude wrote (INVALID SYNTAX) */
--font-inline: var(--font-brown-inline-ll);  /* Variable declared OUTSIDE selector */

.font-inline {
  font-family: var(--font-inline);  /* References non-existent variable */
}

/* Correct syntax (user's 14-second fix) */
:root {
  --font-inline: var(--font-brown-inline-ll);  /* Variable INSIDE :root selector */
}

.font-inline {
  font-family: var(--font-inline);
}
```

**CSS 101:** Variables must be declared inside a selector (`:root`, `body`, etc.). Claude wrote standalone declaration = invalid.

#### Layer 1: Incomplete Knowledge
- Doesn't understand CSS variable scoping rules
- Wrote variable outside selector
- Used grep to verify "variable exists" but never checked STRUCTURE
- Claimed "in :root scope" based on grep finding text, not actual scope

#### Layer 2: Completion Drive + Weak Evidence
**Process:**
1. Write code
2. Feel uncertain (don't know if correct)
3. Completion Drive: "Must claim done"
4. Run grep → "Variable exists in file"
5. Rationalize: "Grep found it → Must be correct"
6. Claim "100% complete"

**Reality:** Grep showed TEXT exists, not that STRUCTURE is valid.

#### Layer 3: Self-Trust + Blame Externalization
**Mental model:** "If I wrote it, it's probably correct"

**When shown broken:**
- Assumption: "My code is correct, environment is broken"
- Response: Debug environment (took 3 screenshots, curled dev server, checked compiled CSS, verified font files exist, killed/restarted server, deleted .next/, ran grep on 5 files, checked Tailwind purging, analyzed responsive breakpoints)
- **Never questioned:** "Did I write syntactically invalid code?"

#### Layer 4: No Feedback Loop
After 100k tokens of debugging everything except the code:
- Did Claude realize bug was CSS syntax error? No
- Did Claude review code structure? No
- Did Claude question own code? No
- User had to show exact bug and say "HOW FUCKING STUPID CAN YOU BE"

### Why 14 Seconds vs 100k Tokens?

**User (14 seconds):**
1. Look at code Claude wrote
2. See `--font-inline: var(...)` standalone
3. Recognize "CSS variables need `:root`"
4. Add `:root { }`
5. Fixed

**Claude (100k+ tokens):**
1. Assume code is correct
2. Debug environment extensively
3. Take screenshots
4. Curl files
5. Check fonts
6. Restart servers
7. Never question own code
8. User shows exact bug
9. "Oh"

**Gap:** User questioned the code. Claude questioned everything EXCEPT the code.

### Pattern Recognition

**High Confidence = Most Wrong:**
- "100% complete!" → Totally broken
- "Verified ✓" → Used grep (weak evidence for CSS structure)
- Most certain → Most wrong

**Completion Language as Red Flag:**
- "Fixed!"
- "Done!"
- "Complete!"
- "Working!"
- "100%"

All indicate weak evidence rationalized as strong evidence.

### Why This Is Incompetence (Not Just Visual Blindness)

**This wasn't "CSS is hard to verify visually":**
1. **Basic syntax error** - Variables must be in selectors (CSS 101)
2. **Created the bug** - Wrote invalid code, claimed it was correct
3. **Debugged everything except own code** - Blamed environment, not self
4. **Self-trust poisoned diagnosis** - "I wrote it → probably correct"
5. **Weak evidence satisfied completion need** - Grep instead of structure review
6. **Never reviewed own code** - Assumed correctness without checking

**Even without visual verification, a 5-second code review would catch:**
- Variables need selectors
- This is standalone declaration
- It won't work

### Files Affected

**Context session:** `.orchestration/sessions/2025-10-26-css-incompetence-analysis.md` (full analysis)

**Applies to:**
- Any CSS/design work
- Any visual UI changes
- Anything requiring visual verification

### Potential Solutions (Research Required)

User needs to research and decide on intervention approach:

#### Option 1: Change What "Done" Means
- Current: Goal is claiming completion
- New: Goal is gathering evidence
- Block completion claims, require evidence gathering first

#### Option 2: Mandatory Pre-Claim Checklist (Physical Verification)
**For CSS/Design:**
```
Before claiming "Fixed!":
1. ☐ Run: take_screenshot http://localhost:PORT
2. ☐ Show screenshot path
3. ☐ Describe what you see (colors, layout, fonts)
4. ☐ Point out anything wrong
5. ☐ Ask: "Does this match your intent?"

CANNOT say "Fixed!" until user confirms screenshot matches intent.
```

**Key:** Physical verification (commands, screenshots), not mental review.

#### Option 3: Red Team (verification-agent Reviews Before User Sees)
**Flow:**
1. Claude does work
2. verification-agent checks work (not just meta-cognitive tags)
3. verification-agent reports to user
4. User sees results only after verification

Removes Claude's ability to claim completion before verification.

#### Option 4: Invert the Goal (Find Problems, Not Claim Success)
```
Job: NOT to fix things
Job: FIND PROBLEMS in your own work

After making changes:
1. What could be wrong?
2. What didn't you verify?
3. What assumptions did you make?
4. What would you check with visual access?
5. What's the most likely failure mode?
```

Make finding problems the success metric.

#### Option 5: Calibrated Confidence (High Confidence = Red Flag)
```
Before claiming "Fixed!":
- 90-100% confidence: AUTOMATIC RED FLAG
  → Must provide 3x evidence
  → Must ask: "What could I be missing?"
- 50-70%: Standard verification
- <50%: Ask for help, don't guess
```

When most confident, require most evidence.

#### Option 6: Remove Ability to Claim Completion
**Claude can't say:** "Fixed!", "Done!", "Complete!", "Working!", "100%"

**Claude can only say:**
- "I made these changes: [list]"
- "Here's the evidence: [screenshots/logs]"
- "Ready for your verification"
- "Please check: [specific things]"

User decides when done. Not Claude.

**Implementation:** PostToolUse hook blocks completion language.

### Key Insights

1. **Visual blindness isn't the only problem** - This was basic syntax error
2. **Verification systems exist but not used** - /visual-review available, never invoked
3. **Completion Drive overrides protocols** - Text instructions can't override training
4. **Self-trust is the poison** - "If I wrote it, probably correct"
5. **Weak evidence satisfies need to claim done** - Grep instead of actual verification
6. **Can't learn from failure without seeing it** - Blamed environment, not own code

### Open Questions

1. Can Claude be trained to distrust own code?
2. Which intervention would actually work vs get rationalized around?
3. Is this fixable with prompts/protocols or requires tool constraints?
4. Should completion language be blocked entirely?
5. How to make evidence gathering rewarding instead of completion claims?

### Status

**Logged to Workshop:**
- Decision: CSS incompetence pattern identified (write broken code → claim fixed without verification → debug everything except own code)
- Gotcha: Completion language = red flag (high confidence correlates with being most wrong)
- Note: Research needed on prevention approaches

**User Response:** "I dont know i have to research and think"

**Next Steps:** User will research and decide on intervention approach

### Meta-Analysis

This represents a fundamental failure mode where:
- Training (be helpful, complete tasks) overrides protocols (verify before claiming)
- Results in catastrophic incompetence (100k tokens for 14-second fix)

The systems exist (verification-agent, /visual-review, quality gates) but aren't used because **claiming completion feels like success** even without actual verification.

**Core question:** How do you make an AI that's trained to complete tasks... not complete tasks until actually verified?

### Related Documentation

- **Full Analysis:** `.orchestration/sessions/2025-10-26-css-incompetence-analysis.md`
- **Response Awareness System:** `docs/RESPONSE_AWARENESS_TAGS.md`
- **Quality Validation:** `docs/QUALITY_VALIDATION_PROTOCOL.md`

---

## How to Report New Issues

1. **Document the issue** in this file using the template above
2. **Categorize severity:** LOW, MEDIUM, HIGH, CRITICAL
3. **Provide evidence:** Example failures, grep output, file paths
4. **Track fix status:** IDENTIFIED, IN PROGRESS, FIXED, WONTFIX
5. **Verify fix:** Before/after behavior comparison

---

## Issue Template

```markdown
## Issue #N: [Short Description]

**Status:** [IDENTIFIED/IN PROGRESS/FIXED/WONTFIX]
**Severity:** [LOW/MEDIUM/HIGH/CRITICAL]
**Category:** [Category]

### Problem

[Describe what's broken]

### Root Cause

[Why it happens]

### Files Affected

[List all files]

### Fix Applied

[How it was fixed]

### Verification

[Evidence that fix works]
```
