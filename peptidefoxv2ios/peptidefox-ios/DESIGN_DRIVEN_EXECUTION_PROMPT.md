# iOS Implementation - Design-Driven Execution

**CRITICAL:** This is NOT a checklist exercise. This is DESIGN WORK.

---

## The Problem with Previous Attempts

**Attempt 1 (failed):** Ignored the plan entirely, took shortcuts, claimed completion falsely.

**Attempt 2 (also failing):** Following plan mechanically like a robot, ignoring design vision, inspiration, and principles.

**Both failed for the same reason:** Lack of design understanding.

---

## What Actually Matters

**NOT:** Completing a checklist of 10 todos.

**YES:** Understanding and implementing the design vision that came from:
1. 4 carefully chosen design inspiration images
2. design-master's comprehensive analysis
3. Detailed design principles extracted
4. User's explicit design feedback

**The todos are verification points, NOT the goal.**

**The design vision IS the goal.**

---

## Phase 1: UNDERSTAND THE DESIGN (30 minutes - DO NOT SKIP)

### Step 1: Study Design Inspiration Images

**Location:**
- Image 1: [path]
- Image 2: [path]
- Image 3: [path]
- Image 4: [path]

**Read design-master's analysis:**
`docs/design-briefs/calculator-redesign-20251021.md`

**Extract and internalize:**
- What made these examples excellent?
- What design patterns appear across all 4?
- What visual hierarchy principles are demonstrated?
- How do they handle information density?
- What interaction patterns do they use?
- Why did the user choose THESE specific examples?

**Write a 1-paragraph summary proving you understand the vision:**
"These examples demonstrate [key principle] through [specific pattern]. The user wants [outcome] by applying [approach]. This differs from current implementation because [gap]."

**If you can't write this paragraph, you don't understand yet. Keep studying.**

### Step 2: Read Design Principles (From design-master)

**Location:** `docs/design-briefs/calculator-redesign-20251021.md`

**Key principles to internalize:**
1. Information hierarchy
2. Visual rhythm
3. Progressive disclosure
4. Interaction patterns
5. Typography scale
6. Spacing system
7. Color usage
8. Component design

**For EACH principle, note:**
- What it is
- Why it matters for this app
- How it applies to current work
- What would violate it

### Step 3: Read User's Design Feedback

**All feedback files in:**
- Session logs
- Design briefs
- Any comments in code

**What frustrated the user?**
- What patterns did they complain about?
- What did they explicitly ask for?
- What examples did they reference?
- What design language did they use?

### Step 4: Synthesize Understanding

**Before writing ANY code, answer these:**

1. **What's the design vision?** (in 2-3 sentences)
2. **What are the 3 most critical design principles for this work?**
3. **How is this different from generic iOS development?**
4. **What would "lazy as fuck" implementation look like?** (so you can avoid it)
5. **What would excellent, thoughtful implementation look like?**

**If you can't answer these confidently, you're not ready to code.**

---

## Phase 2: DESIGN-DRIVEN IMPLEMENTATION

### The Right Mental Model

**WRONG approach:**
```
Todo 1: Make cards 108px
→ Set height = 108
→ Check box
→ Move to next todo
```

**Result:** Robotic, misses the point, looks like shit.

**RIGHT approach:**
```
Design principle: Uniform card heights create visual rhythm
Inspiration: [Example 2] shows consistent 100px cards
User feedback: "Frequency cards different heights - breaks visual flow"

Implementation:
→ Understand WHY uniform heights matter (scanability, rhythm, professionalism)
→ Design 108px cards with proper internal spacing
→ Ensure ALL cards follow this pattern
→ Verify visual rhythm across entire screen
→ Test that it feels as polished as inspiration examples

Side effect: Todo about card heights is now complete
```

**Result:** Thoughtful, design-driven, looks professional.

### Implementation Guidelines

**For EACH feature you build:**

1. **Reference the design inspiration**
   - Which example demonstrates this pattern?
   - What made it work in that example?
   - How do I adapt that principle here?

2. **Apply the design principle**
   - Which design principle applies?
   - What's the underlying reason for this change?
   - How does this improve the user experience?

3. **Implement with design thinking**
   - Not just "change this value"
   - But "create this visual effect through these specific choices"
   - Consider: spacing, alignment, typography, visual weight, interaction

4. **Verify against design vision**
   - Does this match the quality of inspiration examples?
   - Would the user look at this and say "yes, that's what I meant"?
   - Or would they say "this is lazy as fuck"?

5. **Verify todo is complete** (as side effect)
   - The checklist item should naturally be done
   - Because you implemented the design properly

### Blend System Example (Critical - This Failed Last Time)

**WRONG (what happened last session):**
- Created files
- Commented out code with TODO markers
- Said "manual steps needed"
- Claimed completion

**RIGHT (what should happen):**

**Study inspiration:**
- How do the examples handle complex multi-part inputs?
- What progressive disclosure patterns do they use?
- How do they show relationships between inputs?

**Design principle:**
- Progressive disclosure: Simple by default, complexity on demand
- Ratio-locked inputs: Show relationship visually
- Clear affordances: User knows what's interactive

**Implementation:**
1. Understand the blend system design from brief
2. Create BlendVariantPickerView with design principles applied
3. Create BlendCompositionCard showing ratio relationships
4. Integrate both into CalculatorView
5. Add to Xcode project (not orphaned)
6. Connect to calculator logic
7. Test GLOW and KLOW in simulator
8. Verify it feels as polished as inspiration examples
9. Take screenshots showing it works

**Verification:**
- Files in Xcode project ✅
- No TODO markers ✅
- Visually matches design quality ✅
- Works in simulator ✅
- Todo complete as side effect ✅

---

## Phase 3: QUALITY VERIFICATION

### Design Quality Check (BEFORE mechanical tests)

**Look at your work and honestly answer:**

1. **Does this match the quality of the inspiration examples?**
   - Same level of polish?
   - Same attention to detail?
   - Same visual rhythm?

2. **Did I apply the design principles thoughtfully?**
   - Or did I just check boxes?
   - Can I explain WHY each design choice was made?

3. **Would the user say "yes, this is what I wanted"?**
   - Or would they say "this fucking sucks"?

4. **Is this something I'd be proud to show?**
   - Or is it "good enough" lazy work?

**If ANY answer is no, go back and fix it.**

**Only THEN run mechanical tests:**
- Build succeeds
- No orphaned files
- No TODO markers
- Simulator testing
- Screenshots

### Code Review Gate

**Use code-reviewer-pro BUT with design context:**

```javascript
Task({
  subagent_type: "code-reviewer-pro",
  description: "Review iOS implementation with design focus",
  prompt: `Review this iOS implementation session.

CRITICAL: This is design work, not just coding.

Design vision: [your 2-3 sentence summary from Phase 1]
Key design principles: [the 3 critical principles]

Files modified: [list]

Verify:
1. DESIGN QUALITY
   - Matches inspiration examples' polish level?
   - Design principles applied thoughtfully?
   - Visual hierarchy correct?
   - Information density appropriate?
   - Interaction patterns polished?

2. IMPLEMENTATION QUALITY
   - All todos complete (as side effect of good design)?
   - No orphaned files?
   - No TODO markers?
   - Clean code?

3. VERIFICATION
   - Tested in simulator?
   - Screenshots show design quality?

REJECT if design quality doesn't match inspiration examples.
REJECT if implementation is "checkbox completion" without design thinking.`
})
```

---

## The 10 Todos (AS VERIFICATION POINTS)

**These verify you implemented the design correctly:**

1. ✅ CompoundPickerView UI - Search hero, uniform 108px cards
2. ✅ Blend system - Ratio-locked multi-compound with progressive disclosure
3. ✅ Vial fields always visible - Disabled state when empty
4. ✅ Clean background - Remove glass, add swipe gesture
5. ✅ Profile corner icon - Move from tab bar
6. ✅ GLP collapsible - Progressive disclosure
7. ✅ GLP header badge - "GLP-1 Protocol Tool"
8. ✅ Uniform card heights - 108px (CRITICAL visual rhythm)
9. ✅ Remove banner - Clean interface
10. ✅ Add to Protocol CTA - Appears after calculation

**Use these to verify design principles were applied.**
**NOT as a mechanical checklist to complete.**

---

## Success Criteria

**Design success:**
- ✅ Matches inspiration examples' quality
- ✅ Design principles applied thoughtfully
- ✅ User says "yes, this is what I wanted"
- ✅ You're proud to show this work

**Technical success:**
- ✅ All 10 verification points pass (as side effect)
- ✅ Clean build
- ✅ Simulator tested with screenshots
- ✅ No orphaned files, no TODO markers
- ✅ code-reviewer-pro approved

**Process success:**
- ✅ Understood design vision BEFORE coding
- ✅ Implemented with design thinking
- ✅ Verified design quality BEFORE mechanical tests
- ✅ Did not do checkbox robotics

---

## Execution Sequence

```
1. UNDERSTAND (30 min) - CANNOT SKIP
   → Study inspiration images
   → Read design principles
   → Read user feedback
   → Synthesize understanding
   → Prove understanding with written summary

2. IMPLEMENT WITH DESIGN THINKING
   → For each feature:
     - Reference inspiration
     - Apply design principle
     - Implement thoughtfully
     - Verify design quality
     - Verify todo complete (side effect)

3. DESIGN QUALITY CHECK
   → Honestly evaluate against inspiration
   → Fix anything that doesn't match quality

4. MECHANICAL VERIFICATION
   → Build, test, screenshots
   → No orphaned files, no TODOs

5. CODE REVIEW WITH DESIGN FOCUS
   → Agent verifies design quality
   → Fix any issues

6. PRESENT WITH CONFIDENCE
   → Because you did it right
```

---

## Red Flags (If You See These, STOP)

🚩 "I'll just quickly implement these todos"
→ You didn't understand the design vision

🚩 "Changed height to 108px, moving on"
→ You're doing checkbox robotics

🚩 "Files created, left TODO for user"
→ You're taking shortcuts

🚩 "Looks good enough"
→ You're not matching inspiration quality

🚩 "I can skip the design study phase"
→ You're about to fail again

---

## What the User Actually Wants

**NOT:** A robot that completes checklists.

**YES:** A design-thinking implementer who:
- Understands the design vision
- Studies the inspiration examples
- Applies principles thoughtfully
- Creates polished, professional UIs
- Matches the quality of the examples
- Makes them say "yes, this is what I wanted"

---

## Prompt for Next Session

```
I need to implement iOS design work with design thinking, not checkbox robotics.

IMPORTANT: The /agentfeedback command now has a Design Understanding Gate (Step 1.6)
that will force you to prove understanding before building. Use it.

Read: /Users/adilkalam/Desktop/OBDN/peptidefox-ios/DESIGN_DRIVEN_EXECUTION_PROMPT.md

Use /agentfeedback with the feedback on this work. The command will:
1. Ask interactive questions (reference pages, adherence levels)
2. Read design docs and inspiration
3. FORCE you to write design understanding summary
4. SHOW that summary to me for approval
5. Only proceed after I approve your understanding
6. Pass that understanding to agents when dispatching

This prevents:
- Skipping design docs (gate catches it)
- Reading mechanically (gate catches it)
- Building wrong thing (I see your understanding before you build)

Files to read when gate asks:
- docs/design-briefs/calculator-redesign-20251021.md
- docs/session-logs/2025-10-21-ios-implementation-FAILED.md

The gate will ask you to write a summary proving you understand.
Write it honestly. Show me. Get approval. THEN build.

No bullshit. No checkbox robotics. Prove understanding first.
```

---

**READ THIS COMPLETELY.**
**UNDERSTAND THE DESIGN VISION.**
**IMPLEMENT WITH DESIGN THINKING.**
**MATCH THE INSPIRATION QUALITY.**

**That's what the user actually wants.**
