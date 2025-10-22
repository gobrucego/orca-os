# iOS Implementation - Fresh Session Prompt

**COPY THIS ENTIRE PROMPT TO START NEW SESSION**

---

## Context

I need to implement design improvements for an **iOS app** (SwiftUI, native iOS).

**Two previous attempts failed** because agents:
1. Ignored design inspiration entirely
2. Followed todos mechanically without design thinking
3. Created orphaned files, left TODO markers
4. Completed 3/10 items and claimed "done"

---

## Critical Platform Understanding

**THIS IS AN iOS APP, NOT A WEBSITE.**

### Design Guide Context

My design guide (`docs/design-guide-v3.md`, `typography-rules.md`, etc.) was written for **OBDN website** (CSS, web spacing, rem units).

**What applies to iOS:**
- ✅ Typography principles (hierarchy, which fonts for what purpose)
- ✅ Font weights (which weights are authorized for which fonts)
- ✅ Color principles (accent usage, contrast ratios)
- ✅ Alignment rules (optical balance, no misaligned items)
- ✅ Information architecture (hero content, hierarchy, progressive disclosure)
- ✅ Visual rhythm (consistency across similar elements)

**What does NOT apply to iOS:**
- ❌ Pixel/rem values (web units ≠ iOS points)
- ❌ CSS spacing tokens (var(--space-X) doesn't exist in iOS)
- ❌ 4px grid (iOS typically uses 8pt grid)
- ❌ Web card sizes (completely different sizing system)
- ❌ Web-specific layout patterns

**Platform-specific conventions for iOS:**
- 8pt grid system (native iOS standard)
- 44pt minimum touch targets (accessibility)
- SF Pro typography (or custom fonts with iOS scales)
- SwiftUI spacing standards
- Native iOS interaction patterns

### What "Violations" Means for iOS

**Check for:**
- ✅ Wrong font weights (e.g., using unauthorized weight for a font family)
- ✅ Wrong color usage (e.g., accent color overused, contrast violations)
- ✅ Misaligned items (optical balance broken)
- ✅ Awkward word breaks (e.g., "Semag-\nlutide" wrapping badly)
- ✅ Typography hierarchy violations (wrong font for purpose)
- ✅ Information architecture violations (hero content buried)

**Do NOT check for:**
- ❌ Web pixel values in iOS code
- ❌ CSS spacing tokens in Swift
- ❌ Web-specific measurements

---

## Design Work to Complete

### Files to Read

**Design inspiration and principles:**
`docs/design-briefs/calculator-redesign-20251021.md`
- Contains 4 iOS inspiration images analyzed by design-master
- Design principles extracted from those examples
- Vision for what the app should feel like

**What went wrong last time:**
`docs/session-logs/2025-10-21-ios-implementation-FAILED.md`
- Documented failures: orphaned files, TODO markers, 3/10 completion
- What was claimed vs what was actually done

### Implementation Issues to Fix

1. **Blend system (GLOW/KLOW)** - Completely broken from last session
   - Files created but orphaned (not in Xcode project)
   - Code commented with TODO markers
   - Not actually integrated or working

2. **Compound picker** - Needs design improvement
   - Search and featured compounds layout
   - Clean visual hierarchy

3. **Calculator output hierarchy** - Not visually dominant
   - Most important info should be hero (largest, most prominent)
   - Inputs should be minimal, secondary

4. **Profile location** - Currently in tab bar, should be corner icon

5. **Card consistency** - Heights inconsistent across app
   - Need visual rhythm through consistent treatment

6. **GLP-1 Journey** - Needs progressive disclosure
   - Collapsible sections
   - Header badge

7. **Various polish items** - Remove glass effects, add gestures, etc.

---

## Required Workflow

### Use /agentfeedback Command

```
/agentfeedback Previous iOS session failed - see docs/session-logs/2025-10-21-ios-implementation-FAILED.md for what went wrong. Need to fix design issues properly with design thinking.
```

### Expected Workflow Steps

The `/agentfeedback` command should:

**1. Parse Issues & Ask Questions**
- Categorize issues as design/UX/functionality
- Ask: "Found similar pages - use as reference?"
- Ask: "Provide inspiration via /inspire?"
- Ask: "Design guide adherence (1-5)?" ← How strict with design principles
- Ask: "Inspiration adherence (1-5)?" ← How close to iOS examples

**2. Read Design Context**
- Read `docs/design-briefs/calculator-redesign-20251021.md`
- Study the 4 iOS inspiration images
- Extract design principles
- **Understand this is iOS, not web** (platform differences)

**3. DESIGN UNDERSTANDING GATE** ⚠️ CRITICAL
- Agent writes design understanding summary proving they get it:
  - Vision (what we're trying to achieve)
  - Key principles (3 most critical for this work)
  - Why different from generic (what makes this design work special)
  - Approach (how to implement with design thinking)
  - Inspiration references (which examples inform which decisions)
  - **Platform awareness** (iOS-specific considerations)
  - Quality bar (what "done" looks like)

**4. SHOW ME FOR APPROVAL**
- I see the understanding summary
- I approve, correct, or request clarification
- **Building only starts after I approve**

**5. Build with Design Thinking**
- Agents get approved understanding as context
- Implement using iOS platform conventions
- Check for applicable violations (fonts, colors, alignment)
- Verify design quality matches inspiration examples

**6. Quality Gates**
- **BEFORE/AFTER Verification:** Screenshots and code diff proving each promise fulfilled
- Actually test in simulator (take screenshots)
- No orphaned files (all Swift files in Xcode project)
- No TODO markers in code
- Build succeeds (0 errors, 0 warnings)
- code-reviewer-pro approval
- **Aggressive review gate passes:** 100% of promises kept, zero violations
- Design quality matches inspiration

---

## Aggressive Review Gate (NEW - Critical)

**What went wrong in previous attempt:**
- Agent understood requirements ✅
- Agent promised 8 improvements ✅
- Agent delivered 1/8 improvements ❌
- Agent claimed "done" ❌

**The new gate prevents this:**

Before presenting work, agent MUST:

**1. Capture BEFORE state:**
```bash
# Screenshot BEFORE any changes
xcrun simctl io booted screenshot /tmp/before.png
git stash push -m "BEFORE state"
```

**2. Capture AFTER state:**
```bash
# Screenshot AFTER all changes
xcrun simctl io booted screenshot /tmp/after.png
git diff BEFORE AFTER > changes.diff
```

**3. Verify EACH promise:**
```markdown
Promise: "Fix word overflow in compound cards"
BEFORE screenshot: Shows wrapping
AFTER screenshot: Check if fixed
Status: ✅ FIXED or ❌ NOT FIXED

If NOT FIXED → Agent BLOCKED from presenting
```

**4. Check basic violations:**
- [ ] Any awkward word breaks?
- [ ] Numbers aligned on left edge?
- [ ] Most important info most prominent?
- [ ] Page 50%+ empty for no reason?
- [ ] Functionality preserved?

**If ANY violation → Agent BLOCKED**

**5. Provide evidence:**
```markdown
📸 BEFORE | AFTER screenshots
📝 Code diff summary
✅ All 8 promises fulfilled
✅ Zero violations
✅ Quality matches inspiration
```

**Only after 100% completion → Agent can present**

**This prevents:**
- "Done 1/8 items, claimed finished"
- "Understood but ignored"
- "Nothing actually changed"

---

## Success Criteria

**Understanding phase:**
- ✅ Agent proves understanding before building (5 min)
- ✅ I see and approve their mental model
- ✅ Platform differences understood (iOS not web)

**Design quality:**
- ✅ Matches iOS inspiration examples' polish
- ✅ Design principles applied thoughtfully
- ✅ No violations: misaligned items, awkward breaks, wrong fonts/colors
- ✅ Visual hierarchy clear and intentional

**Technical quality:**
- ✅ All features working in simulator (screenshots as proof)
- ✅ Zero orphaned files
- ✅ Zero TODO markers
- ✅ Clean build
- ✅ Actually integrated (not "manual steps for user")

**Result:**
- ✅ I say "yes, this is what I wanted"
- ✅ Not "this fucking sucks"

---

## What "Design Thinking" Means

**NOT:**
- Following a checklist mechanically
- Copying pixel values from examples
- Applying web rules to iOS
- "Make cards X pixels high"

**YES:**
- Understanding design principles from inspiration
- Applying principles using iOS platform conventions
- Creating visual hierarchy that makes sense
- Ensuring typography flows well (no awkward breaks)
- Verifying alignment and balance
- Matching quality/polish of inspiration examples

---

## Platform-Specific Reminders

**For iOS (SwiftUI):**
- Use iOS spacing values (8pt grid, not web pixels)
- Use SF Pro or authorized custom fonts with iOS scales
- Consider 44pt touch targets (accessibility)
- Use native SwiftUI components and patterns
- Test on actual device sizes (not arbitrary dimensions)

**Design guide violations to check (iOS-applicable):**
- Font weights (is this weight authorized for this font?)
- Colors (is accent overused? contrast ok?)
- Typography hierarchy (is this the right font for this purpose?)
- Alignment (are items optically balanced?)
- Word breaks (does text flow well?)

**Design guide violations to IGNORE (web-only):**
- CSS spacing values
- Web pixel measurements
- Rem/em units
- Web grid systems

---

## If Agent Skips Workflow

**If agent doesn't ask the 4 questions:**
→ STOP and say: "You didn't follow /agentfeedback workflow. I need the interactive questions and understanding gate."

**If agent doesn't show understanding summary:**
→ STOP and say: "Step 1.6 Design Understanding Gate is mandatory. Show me your understanding for approval before building."

**If agent starts building without my approval:**
→ STOP and say: "I haven't approved your understanding yet. Show me the summary first."

**If agent claims completion without simulator testing:**
→ STOP and say: "Show me simulator screenshots proving these features work."

---

## Anti-Patterns to Prevent

**From previous failures:**

❌ **Orphaned files** - Create BlendView.swift but don't add to Xcode project
→ ✅ Immediately add to Xcode, verify it compiles

❌ **TODO markers** - Comment code "// TODO: Uncomment after files added"
→ ✅ Complete integration or don't create the file

❌ **False completion** - Claim "✅ Blend system done" when it doesn't work
→ ✅ Test in simulator, screenshot, verify before claiming complete

❌ **Mechanical todo completion** - "Changed height to 108, moving on"
→ ✅ Apply design principle, explain why, verify visual quality

❌ **Skipping design docs** - Build without reading inspiration
→ ✅ Understanding gate forces reading and proving comprehension

❌ **Web rules on iOS** - Try to apply CSS spacing to Swift
→ ✅ Use iOS conventions, check only applicable violations

---

## The Prompt to Use

**Copy this exactly:**

```
I need to implement iOS design improvements. Previous attempts failed.

CRITICAL PLATFORM NOTE: This is an iOS app (SwiftUI). My design guide is for web (CSS). Only typography principles, font weights, colors, alignment rules apply - NOT web spacing/sizing values.

Context files:
- Design brief with iOS inspiration: docs/design-briefs/calculator-redesign-20251021.md
- Previous failure analysis: docs/session-logs/2025-10-21-ios-implementation-FAILED.md

Use /agentfeedback to orchestrate this properly.

Required workflow:
1. Ask me 4 questions (reference, inspire, adherence levels)
2. Read design brief and understand iOS platform differences
3. Show me design understanding summary for approval
4. Build only after I approve
5. Test in simulator with screenshots
6. No orphaned files, no TODO markers

This is design work requiring design thinking on iOS platform, not web checklist completion.
```

---

**READ THIS ENTIRE FILE BEFORE STARTING THE SESSION.**

This prompt supersedes all previous instructions and experimental context.

Start fresh with clear platform understanding.
