## Phase 0: Reference Capture & Review (MANDATORY if Reference Exists)

**CRITICAL**: If user mentions reference (web app, existing app, design guide), capture and review BEFORE implementation.

**This prevents the catastrophic pattern:**
- User says: "Build iOS app matching web app"
- Team builds for 6-8 hours
- quality-validator discovers: "This doesn't match at all" (40/100)
- Result: 6-8 hours wasted

**The fix: Capture and approve reference FIRST**

### When This Phase Runs

**MANDATORY if Phase 0 detected reference:**
- User mentions "web app", "existing app", "like the [X]"
- User says "match", "same as", "based on"
- User provides URL or reference document

**Skip if:**
- Building from scratch, no reference
- Phase 0 scored as Simple (direct implementation, no orchestration)

---

### Step 1: Capture Reference Screenshots

**Before ANY implementation, capture reference screenshots:**

```bash
# If web app URL provided
URL="[from user request]"

# Capture EVERY view
# Calculator view
# Library view
# About view
# Any modals/dialogs
# Different states (empty, populated, loading, error)

# Save to .orchestration/evidence/reference-[view-name].png
```

**For each view, capture:**
- Desktop resolution (1440px)
- Mobile resolution if responsive (375px)
- Different states if relevant (light/dark mode, empty/populated)

**Result**: 5-10 reference screenshots showing EXACTLY what to build

---

### Step 2: Design Agent Review & Checklist Creation

**Deploy design agent BEFORE implementation to analyze reference:**

**Agent**: design-system-architect OR ux-strategist

**Task**: "Review reference screenshots and create implementation checklist"

**Agent creates `.orchestration/reference-analysis.md`:**

```markdown
# Reference Analysis - [Project Name]

## Reference Screenshots Captured

1. reference-calculator.png - Calculator view
2. reference-library.png - Library view with peptide cards
3. reference-about.png - About page

## Visual Inventory

### Calculator View (reference-calculator.png)

**Layout:**
- Single header: "Dosing Calculator"
- Compound selection dropdown (PROMINENT, top of page)
- 4 input fields in 2x2 grid (Dose, Units, Concentration, Volume)
- 4 vial size buttons in row (1mL, 3mL, 5mL, 10mL)
- Bottom sheet with calculation result
- Screen space: 60% content, 40% white space (generous)

**Typography:**
- Header: Brown LL, 28pt, semibold
- Labels: Sharp Sans No2, 14pt, regular
- Inputs: 16pt, medium
- Text alignment: LEFT (all content left-aligned)

**Colors:**
- Accent: Purple #8b5cf6
- Background: White #ffffff
- Text: Dark gray #1a1a1a

**Spacing:**
- 8pt grid system
- 16pt minimum between components
- 24pt padding around edges
- NOT cramped

**Components:**
- Dropdown with chevron icon
- Text inputs with labels above
- Pill-shaped buttons (rounded)
- Bottom sheet with drag indicator

### Library View (reference-library.png)

**Layout:**
- Single header: "Peptide Library"
- Grid of cards (2 columns on mobile, 3 on tablet)
- Each card: Full width, generous padding

**Card Design:**
- Color-coded left border (different color per peptide type)
- Peptide name: LEFT-aligned, bold
- Description: LEFT-aligned, 2-3 lines
- Synergistic compounds: Pills below description
- Generous spacing between cards (16pt+)

**NOT present:**
- Center-aligned text
- Cramped sardine layout
- Missing color borders

### About View (reference-about.png)

[Similar detailed analysis]

## Feature Checklist (MANDATORY)

### Calculator View Features
- [ ] Compound selection dropdown (top, prominent)
- [ ] Dose input with units
- [ ] Concentration input
- [ ] Volume calculation display
- [ ] Vial size selection (1/3/5/10mL)
- [ ] Bottom sheet with result
- [ ] Input validation
- [ ] Calculation updates on change

### Library View Features
- [ ] Grid layout (2-3 columns)
- [ ] Color-coded card borders
- [ ] Peptide name (bold, left-aligned)
- [ ] Description (2-3 lines, left-aligned)
- [ ] Synergistic compounds (pills)
- [ ] Generous card spacing
- [ ] Search functionality (if in reference)

### Design Rules from Reference
- [ ] Text alignment: LEFT (never center)
- [ ] Spacing: 8pt grid, 16pt minimum between components
- [ ] Typography: Brown LL headers, Sharp Sans No2 body
- [ ] Colors: Purple accent #8b5cf6
- [ ] Layout: 60/40 content/whitespace ratio (not cramped)
- [ ] Headers: Single descriptive header (not redundant)

## Implementation Priorities

**Priority 1 (Cannot ship without):**
- Compound selection dropdown
- Color-coded library cards
- Left-aligned text
- Generous spacing

**Priority 2 (Important):**
- Synergistic compound pills
- Bottom sheet design
- Proper typography

**Priority 3 (Nice to have):**
- Animations
- Loading states
- Error messages

## Red Flags to Avoid

❌ **DO NOT**:
- Center-align content text (reference shows left-aligned)
- Cram components (reference shows generous spacing)
- Add redundant headers ("Calculator" then "Dosing Calculator")
- Remove compound selection (it's prominent in reference)
- Change card design (reference has specific color-coded style)
- Use >50% of screen as white space (reference is ~40%)

## Approval Checklist

Before implementation begins, user must approve:
- [ ] All reference screenshots captured?
- [ ] Feature checklist complete and accurate?
- [ ] Design rules extracted correctly?
- [ ] Red flags documented?
- [ ] Implementation priorities clear?

**User must explicitly approve this document before implementation starts.**
```

---

### Step 3: User Approval of Reference Analysis

**MANDATORY: Present reference-analysis.md to user for approval**

```markdown
📋 REFERENCE ANALYSIS COMPLETE

I've captured [N] reference screenshots and created a detailed implementation checklist.

**Reference screenshots captured:**
- .orchestration/evidence/reference-calculator.png
- .orchestration/evidence/reference-library.png
- .orchestration/evidence/reference-about.png

**Checklist created:**
- [N] features identified
- [N] design rules extracted
- [N] red flags documented

**Please review**: .orchestration/reference-analysis.md

**Critical questions:**
1. Did I capture all important views from the reference?
2. Is the feature checklist complete and accurate?
3. Are the design rules correct (alignment, spacing, typography)?
4. Did I identify the right priorities?

**I need your explicit approval before implementation starts.**

Without your approval, the team will build the wrong thing (like last time).

Approve to proceed? (Yes/No/Needs changes)
```

**If user says "Needs changes":**
- User specifies what's wrong
- Design agent updates reference-analysis.md
- Re-present for approval
- Repeat until approved

**If user says "Yes":**
- Proceed to Phase 1 (Tech Stack Detection)
- reference-analysis.md is now the source of truth
- All implementation must check against it

---

### Step 4: Mid-Implementation Visual Checkpoint

**MANDATORY checkpoint halfway through implementation:**

**After implementation agent claims 50% complete:**

1. **Capture implementation screenshots** (.orchestration/evidence/impl-[view]-wip.png)
2. **Deploy design agent for mid-point review**
3. **Design agent creates comparison report**:

```markdown
# Mid-Implementation Visual Checkpoint

## Side-by-Side Comparison

### Calculator View

| Aspect | Reference | Implementation (WIP) | Match? |
|--------|-----------|---------------------|---------|
| Compound selection | ✅ Dropdown at top | ❌ MISSING | ❌ FAIL |
| Text alignment | ✅ Left-aligned | ❌ Center-aligned | ❌ FAIL |
| Spacing | ✅ Generous (16pt+) | ❌ Cramped (<8pt) | ❌ FAIL |
| Header | ✅ "Dosing Calculator" | ❌ "Calculator" + "Dosing Calculator" | ❌ FAIL |

**Match Score: 25%**

❌ CHECKPOINT FAILED

**Critical issues found:**
1. Missing compound selection dropdown (Priority 1 feature)
2. Text center-aligned instead of left-aligned (violates design rule)
3. Components cramped (<8pt spacing, should be 16pt+)
4. Redundant headers

**Required fixes BEFORE continuing:**
- Add compound selection dropdown
- Change all text to left-aligned
- Increase spacing to 16pt minimum
- Remove redundant header

**DO NOT CONTINUE until these issues fixed.**
```

4. **If checkpoint fails**: Fix issues before continuing
5. **If checkpoint passes**: Continue with remaining implementation

**This catches issues EARLY (at 50% mark) instead of at the end (100%).**

---

### Critical Rules for Phase 0.5

**NEVER skip this phase if reference exists:**
- Even for Simple tasks (direct implementation still needs reference)
- Even for Medium tasks (minimal team still needs reference)
- Especially for Complex tasks (full team definitely needs reference)

**Design agent must review reference BEFORE implementation:**
- No implementation without approved reference-analysis.md
- No "we'll check later" - check FIRST

**Mid-implementation checkpoint is MANDATORY:**
- Catches issues at 50% (not 100%)
- Prevents 6-8 hours of wasted work
- Forces visual comparison DURING work (not just at end)

**User approval required:**
- reference-analysis.md must be explicitly approved
- If user says "that's not right", fix it BEFORE implementation
- Don't proceed on assumptions

