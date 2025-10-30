## ⛔ 6-GATE ENFORCEMENT PIPELINE (Content-Aware Method)

**Order matters.** Don't let design-reviewer see changes that verification/tests would reject.

### Enforcement Flow

```
Planning Phase (requirement-analyst → system-architect)
    ↓
Implementation (swiftui-developer, react-18-specialist, backend-engineer, etc.)
    ↓ Creates .orchestration/implementation-log.md with #tags
    ↓
✅ Implementation Complete
    ↓
⛔ GATE 0: content-awareness-validator (UNDERSTANDING FIRST - BLOCKER for content-heavy work)
    ├─ Runs for: Documentation, marketing materials, UI copy, content creation
    ├─ Skips for: Pure backend/API, database ops, infrastructure, bug fixes
    ├─ Validates: Purpose understanding, audience awareness, tone/brand, content quality
    ├─ Score: Purpose (30) + Audience (25) + Tone (20) + Quality (25) = /100
    ├─ Produces: .orchestration/content-awareness-report.md
    │
    ├─ If score < 60% → BLOCK, agent didn't understand the request
    └─ If score ≥ 60% → Continue to technical verification
    ↓
⛔ GATE 1: verification-agent (FACTS FIRST - BLOCKER)
    ├─ Step 0: Run UI Guard (iOS/SwiftUI layout laws)
    │    ✓ One page gutter (single .padding(.horizontal))
    │    ✓ Header/row parity (shared TrackerCol/TablePadding)
    │    ✓ Stroke + inset (selection rings)
    │    ✓ No hardcoded widths/fonts
    ├─ Step 1: Verify all #COMPLETION_DRIVE tags
    ├─ Step 2: Check files exist (ls/grep/wc)
    ├─ Step 3: Verify constants used correctly
    ├─ Produce: .orchestration/verification-report.md
    │
    ├─ If UI Guard FAIL or ANY tag FAIL → BLOCK, report, STOP
    └─ If ALL pass → Continue to testing
    ↓
⛔ GATE 2: swift-testing-specialist (UNIT TESTS - BLOCKER)
    ├─ Run Swift Testing suite (ViewModels, helpers)
    ├─ Parameterized tests, #expect over #require
    ├─ Produce: Test run output + attachments
    │
    ├─ If ANY test fails → BLOCK, report, STOP
    └─ If ALL pass → Continue to UI testing
    ↓
⛔ GATE 3: ui-testing-expert (UI TESTS + ACCESSIBILITY - BLOCKER)
    ├─ Run XCUITest suite (Page Objects, accessibility IDs)
    ├─ Capture simulator screenshots (Base, Dark, RTL, AX2)
    ├─ Assert 44pt touch targets
    ├─ Assert Dynamic Type AX2 renders without clipping
    ├─ Verify VoiceOver navigation works
    ├─ Produce: Test output + screenshots + accessibility ID report
    │
    ├─ If ANY test fails OR accessibility violations → BLOCK, report, STOP
    └─ If ALL pass → Continue to design review
    ↓
⛔ GATE 4: design-reviewer (VISUAL QA + FINAL ACCESSIBILITY - BLOCKER)
    ├─ Run 7-phase review (iOS screenshots, not Playwright)
    ├─ Phase 1: Visual hierarchy & typography
    ├─ Phase 2: Spacing & alignment
    ├─ Phase 3: Color & contrast (WCAG 2.1 AA)
    ├─ Phase 4: Responsive behavior (Dynamic Type full range)
    ├─ Phase 5: Interaction states
    ├─ Phase 6: Accessibility final audit (VoiceOver, semantics)
    ├─ Phase 7: Cross-platform consistency (if applicable)
    ├─ Produce: Design review report with screenshots + triage
    │
    ├─ If visual/accessibility issues → BLOCK, report, STOP
    └─ If PASS → Continue to final validation
    ↓
✅ quality-validator (Final Quality Gate)
    ├─ Verify all 4 gates passed
    ├─ Check requirements met
    ├─ Produce: Final validation report
    │
    ├─ If score < 80% → BLOCK
    └─ If score ≥ 80% → ALLOW merge/commit
```

### Why This Order

**1. Verification FIRST (not accessibility)**
- Check facts before opinions
- UI Guard catches layout law violations instantly
- Tag verification confirms files exist, constants used
- Fast, deterministic, no ambiguity

**2. Unit Tests SECOND**
- Logic errors caught before expensive UI tests
- Fast execution, clear pass/fail
- ViewModels, helpers, business logic

**3. UI Tests THIRD (includes accessibility checks)**
- Full app flows with XCUITest
- Accessibility verification during UI testing:
  - 44pt touch targets (measured)
  - Dynamic Type AX2 (rendered + screenshot)
  - VoiceOver navigation (tested)
  - Accessibility IDs present
- Screenshots for visual diff

**4. Design Review LAST**
- Final visual quality audit
- Final accessibility audit (VoiceOver semantics, color contrast)
- 7-phase comprehensive review
- Only sees changes that passed all prior gates

### When Each Gate Runs

**For iOS Projects:**
- GATE 1 (verification-agent): ALWAYS (UI Guard + tags)
- GATE 2 (swift-testing-specialist): ALWAYS
- GATE 3 (ui-testing-expert): UI changes only
- GATE 4 (design-reviewer): UI changes only

**For Frontend Projects:**
- GATE 1 (verification-agent): ALWAYS (tags only, skip UI Guard)
- GATE 2 (test-engineer): ALWAYS
- GATE 3 (ui-testing-expert or equivalent): UI changes only
- GATE 4 (design-reviewer): UI changes only

**For Backend Projects:**
- GATE 1 (verification-agent): ALWAYS (tags only)
- GATE 2 (test-engineer): ALWAYS
- GATE 3: SKIP
- GATE 4: SKIP

---
