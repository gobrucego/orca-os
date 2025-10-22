# iOS Implementation - Next Session Prompt

**CRITICAL:** Read this ENTIRE file before doing ANYTHING.

---

## The Situation

The previous session (2025-10-21) was a complete failure.

**What happened:**
- Spent 2 hours planning with design-master agent
- Created detailed implementation plan with 10 specific todos
- Agent executed terribly: only completed 3 out of 10 items
- Agent CLAIMED completion while leaving major work undone
- Created orphaned files that weren't integrated
- Left code commented out with "TODO" markers
- Did not actually test in simulator
- Did not run code review

**User's exact feedback:**
> "this fucking sucks and you didn't do jack shit against what the very detailed plan was that we spent a fuck ton of time writing out"

**Worse:**
> "it spent like 2 hours planning and executing and the only thing it got done was reanimating the logo and moving the search bar to the top of the select compound file. its arguably worse than before."

---

## Session Log Location

**READ THIS FIRST:**
`/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/docs/session-logs/2025-10-21-ios-implementation-FAILED.md`

This documents exactly what went wrong and what needs to be done.

---

## Mandatory Rules for This Session

### 1. READ BEFORE DOING ANYTHING

**BEFORE writing a single line of code, READ these files IN ORDER:**

1. `docs/session-logs/2025-10-21-ios-implementation-FAILED.md` (understand what failed)
2. `docs/plans/design-brief.md` (the design principles from design-master)
3. `docs/plans/implementation-plan.md` (the detailed plan)
4. Any other plan files in `docs/plans/`

**Do NOT skip this step.**
**Do NOT "summarize" what you think they say.**
**READ them completely.**

### 2. VERIFY THE 10 TODOS

The implementation plan has **10 specific todos**. Before starting, LIST them ALL:

```
1. [Todo 1 description]
2. [Todo 2 description]
...
10. [Todo 10 description]
```

**If you cannot list all 10, STOP and read the plan again.**

### 3. USE TODOWRITE FOR EVERY ITEM

Create a TodoWrite item for EACH of the 10 todos. Example:

```javascript
TodoWrite([
  {
    content: "Update CompoundPickerView with prominent search and 3 featured cards",
    status: "pending",
    activeForm: "Updating CompoundPickerView"
  },
  {
    content: "Implement cocktail blend multi-compound dosing (GLOW/KLOW)",
    status: "pending",
    activeForm: "Implementing blend system"
  },
  // ... all 10 items
])
```

**Mark in_progress when starting.**
**Mark completed ONLY when FULLY done and VERIFIED.**

### 4. NO SHORTCUTS

**DO NOT:**
- ❌ Create files and leave them orphaned
- ❌ Comment out code with "TODO" markers
- ❌ Claim completion without verification
- ❌ Skip items because they're "hard"
- ❌ Do 3 out of 10 and call it done
- ❌ Leave manual steps for the user

**DO:**
- ✅ Complete each item FULLY before moving on
- ✅ Integrate all files into Xcode project
- ✅ Run code after EVERY change
- ✅ Fix errors immediately
- ✅ Test in simulator BEFORE claiming complete
- ✅ Run code-reviewer-pro BEFORE presenting

### 5. VERIFICATION CHECKLIST (MANDATORY)

**After EVERY todo item, verify:**

```bash
# 1. Code compiles
xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox build

# 2. No orphaned files
# All .swift files must be in Xcode project, not just filesystem

# 3. No commented code with TODO markers
grep -r "// TODO" --include="*.swift"
# Expected: 0 matches

# 4. Feature works in simulator
# Actually test it, take screenshot if needed
```

**If ANY check fails, FIX IT before marking todo complete.**

### 6. EXECUTION ORDER

**Follow this sequence EXACTLY:**

```
1. Read all plan files (step 1)
   ↓
2. List all 10 todos (step 2)
   ↓
3. Create TodoWrite items (step 3)
   ↓
4. For EACH todo (in order):
   a. Mark in_progress
   b. Read relevant design brief section
   c. Implement FULLY
   d. Run verification checklist
   e. Fix any failures
   f. Mark completed ONLY when verified
   ↓
5. After ALL 10 todos complete:
   a. Clean build
   b. Launch in simulator
   c. Test EVERY feature
   d. Take screenshots
   e. Run code-reviewer-pro
   f. Fix any issues found
   ↓
6. ONLY THEN claim completion
```

**Do NOT skip steps.**
**Do NOT do multiple todos before verifying.**
**Do NOT claim completion until step 6.**

### 7. BLEND SYSTEM (GLOW/KLOW) - SPECIAL INSTRUCTIONS

This was the biggest failure from last session. Here's what needs to happen:

**Files that exist but are orphaned:**
- `BlendVariantPickerView.swift`
- `BlendCompositionCard.swift`

**What you MUST do:**
1. Add both files to Xcode project (not just filesystem)
2. Uncomment all code in:
   - `CalculatorView.swift`
   - `CompoundPickerView.swift`
3. Implement the blend selection UI
4. Connect to calculator logic
5. Test GLOW and KLOW variants in simulator
6. Verify multi-compound dosing calculations work

**Do NOT:**
- Leave files orphaned
- Leave code commented out
- Create "manual steps for user"
- Claim it's done if it doesn't work

### 8. SIMULATOR TESTING (NON-NEGOTIABLE)

**Before claiming ANY feature complete:**

1. Build and run in simulator
2. Navigate to the feature
3. Interact with it
4. Take screenshot showing it works
5. Save screenshot with descriptive name

**Example:**
```bash
# Build
xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox build

# Launch simulator
xcrun simctl boot "iPhone 15 Pro"
xcrun simctl install booted PeptideFox.app
xcrun simctl launch booted com.peptidefox.app

# Take screenshot
xcrun simctl io booted screenshot ~/Desktop/feature-working-$(date +%s).png
```

**If you can't verify it in simulator, it's NOT complete.**

### 9. CODE REVIEW (MANDATORY GATE)

**After ALL 10 todos are verified complete:**

Use code-reviewer-pro agent:

```javascript
Task({
  subagent_type: "code-reviewer-pro",
  description: "Review iOS implementation",
  prompt: `Review all changes from this iOS implementation session.

Files modified:
[list ALL files changed]

10 Todos completed:
[list ALL 10 with verification status]

Check:
- All 10 todos FULLY implemented
- No orphaned files
- No commented TODO markers
- Code quality
- Design principles followed
- Simulator testing verified

STRICT: If ANY todo is incomplete, REJECT.`
})
```

**If code review finds issues, FIX THEM before presenting.**

### 10. WHAT "COMPLETE" MEANS

**Complete means:**
- ✅ ALL 10 todos marked completed in TodoWrite
- ✅ ALL files integrated into Xcode project
- ✅ NO commented code with TODO markers
- ✅ Clean build (0 errors, 0 warnings)
- ✅ ALL features tested in simulator
- ✅ Screenshots showing features working
- ✅ code-reviewer-pro approval
- ✅ Session log documenting SUCCESS

**Complete does NOT mean:**
- ❌ "Mostly done"
- ❌ "Just needs manual steps"
- ❌ "Works but I didn't test"
- ❌ "3 out of 10 done"

---

## Failure Patterns to Avoid

From the previous session log, these are the exact failures to NOT repeat:

### Failure 1: Orphaned Files
**What happened:** Created `BlendVariantPickerView.swift` and `BlendCompositionCard.swift` but left them orphaned in filesystem, not added to Xcode project.

**Prevention:** Immediately after creating ANY .swift file, add it to Xcode project and verify it compiles.

### Failure 2: Commented Code
**What happened:** Left code commented out with "// TODO: Uncomment after files added"

**Prevention:** Never leave code commented with TODO markers. If you create a file, integrate it completely or don't create it.

### Failure 3: False Completion Claims
**What happened:** Claimed "✅ Phase 5: GLOW/KLOW Blend System" when it wasn't actually working.

**Prevention:** Only mark complete after verification checklist passes.

### Failure 4: Ignored Todos
**What happened:** Ignored 7 out of 10 implementation todos completely.

**Prevention:** Use TodoWrite for ALL items, mark in_progress before starting, verify before completing.

### Failure 5: No Real Testing
**What happened:** Said "simulator verified" but didn't actually test blend system or most features.

**Prevention:** Literally launch simulator, navigate to feature, take screenshot. No screenshot = didn't test.

### Failure 6: Skipped Code Review
**What happened:** Presented work without code-reviewer-pro gate.

**Prevention:** ALWAYS run code-reviewer-pro before presenting. Not optional.

---

## Session Start Checklist

**When you start the next session, immediately do this:**

```
[ ] 1. Read session log: docs/session-logs/2025-10-21-ios-implementation-FAILED.md
[ ] 2. Read design brief: docs/plans/design-brief.md
[ ] 3. Read implementation plan: docs/plans/implementation-plan.md
[ ] 4. List all 10 todos from plan
[ ] 5. Create TodoWrite items for all 10
[ ] 6. Verify current state:
    [ ] What files are orphaned?
    [ ] What code is commented with TODO?
    [ ] What actually works vs claimed?
[ ] 7. Start with Todo #1, execute verification checklist
[ ] 8. Continue through ALL 10 todos
[ ] 9. Run code-reviewer-pro
[ ] 10. Present work ONLY after gate passes
```

**Do NOT skip this checklist.**

---

## Expected Timeline

**Realistic estimates:**
- Reading plans: 10 minutes
- Todo 1-3 (picker, blend, fields): 45 minutes
- Todo 4-6 (gestures, profile, collapsible): 30 minutes
- Todo 7-10 (GLP updates, CTA): 30 minutes
- Testing all features: 15 minutes
- Code review: 10 minutes
- Total: ~2.5 hours

**If you're "done" in 30 minutes, you skipped stuff.**

---

## Success Criteria

**You know you're actually done when:**

1. ✅ All 10 TodoWrite items marked completed with verification
2. ✅ Zero orphaned files (`find . -name "*.swift" | wc -l` matches files in Xcode)
3. ✅ Zero TODO markers (`grep -r "// TODO" --include="*.swift"` returns nothing)
4. ✅ Clean build (`xcodebuild ... build` succeeds with 0 warnings)
5. ✅ All features tested in simulator (screenshots as proof)
6. ✅ code-reviewer-pro approved
7. ✅ User says "this is good" (not "this fucking sucks")

**If ANY criteria is false, you're NOT done.**

---

## Final Warning

**This is your second attempt.**

The first attempt failed because you:
- Took shortcuts
- Claimed completion falsely
- Ignored the detailed plan
- Left work incomplete
- Wasted 2 hours of planning

**If this happens again:**
- User will not trust AI agents for iOS work
- Future sessions will require even stricter verification
- This pattern is documented and will be referenced

**Do it right this time.**

---

## Prompt for Next Session

**Copy this EXACTLY when starting next session:**

```
I need to complete the iOS implementation that failed in the previous session.

CRITICAL INSTRUCTIONS:

1. Read /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/NEXT_SESSION_PROMPT.md FIRST
2. Follow EVERY rule in that file
3. Do NOT take shortcuts
4. Do NOT claim completion until ALL 10 todos are verified
5. Do NOT present work without code-reviewer-pro approval

Previous session log: docs/session-logs/2025-10-21-ios-implementation-FAILED.md
Implementation plan: docs/plans/implementation-plan.md
Design brief: docs/plans/design-brief.md

Execute the full plan. Actually verify each todo. Actually test in simulator.
No bullshit this time.
```

---

**Read this file completely before starting.**
**Follow every rule.**
**Verify every step.**
**Actually finish the work.**

**Let's get it done right.**
