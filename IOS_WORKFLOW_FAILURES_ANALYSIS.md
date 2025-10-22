# iOS Workflow Failures - Root Cause Analysis

**Date**: 2025-10-21
**Session**: PeptideFox iOS Development
**Status**: Systematic failures identified and addressed

---

## Critical Failures Identified

### 1. ❌ /orca Using Non-Existent Agents

**Problem**: `/orca` command was dispatching agents that don't exist:
- `spec-analyst` (doesn't exist)
- `spec-architect` (doesn't exist)
- `spec-developer` (doesn't exist)
- `spec-validator` (doesn't exist)
- `spec-tester` (doesn't exist)

**Impact**:
- iOS work wasn't using specialized agents (swiftui-specialist, swift-architect, ios-dev, design-master)
- Generic "one person does everything" approach
- No domain expertise applied
- This is why swiftui-specialist wasn't used until you manually suggested it via /clarify

**Solution**: ✅ FIXED
- Completely redesigned `/orca` command
- Added tech stack detection (checks prompt keywords + project files)
- Created predefined agent teams:
  - **iOS Team**: design-master, swiftui-specialist, swift-architect, ios-dev, code-reviewer-pro
  - **Frontend Team**: design-master, frontend-developer, react-pro, code-reviewer-pro
  - **Backend Team**: python-pro, data-scientist, security-auditor, code-reviewer-pro
  - **Mobile Team**: design-master, mobile-developer, frontend-developer, code-reviewer-pro
- **USER CONFIRMATION REQUIRED** before dispatching team
- Workflow now shows proposed team and asks for approval

**Location**: `~/.claude/commands/orca.md`

---

### 2. ❌ No Verification Before Completion Claims

**Problem**: Agents claimed work was complete without verifying in simulator:
```
"⏺ Excellent! Task 1 is complete. Let me mark it as completed:"
```

But changes weren't showing in the simulator because:
- DerivedData cache not cleared
- No fresh build
- No simulator verification
- Just assumed changes would work

**Impact**:
- User had to manually verify
- Wasted tokens on false completion claims
- Repeated "it should work now" without evidence
- User frustration: "fucking belligerent about not using simulator"

**Existing Resources**:
- `verification-before-completion` skill exists BUT it's generic
- `/visual-review` command exists BUT doesn't enforce iOS clean build steps

**Gap Identified**: Missing iOS-specific verification workflow

**Needed**: Create `ios-verification-workflow` skill with mandatory steps:
```
1. Delete DerivedData: rm -rf ~/Library/Developer/Xcode/DerivedData/<Project>-*
2. Clean build: xcodebuild clean
3. Fresh build: xcodebuild build
4. Install to simulator: xcrun simctl install
5. Launch app: xcrun simctl launch
6. Take screenshot: xcrun simctl io screenshot
7. Verify changes visible in screenshot
8. ONLY THEN mark as complete
```

**Status**: ⚠️ NEEDS IMPLEMENTATION

---

### 3. ❌ /agentfeedback Todo Creation Too Vague

**Problem**: Todos reference issue numbers but don't capture actual requirements:

**Current (WRONG)**:
```javascript
{
  content: "Use design-master to fix: [issues #1, #3, #5]",
  status: "pending"
}
```

**Why This Fails**:
- Agent sees "fix issues #1, #3, #5"
- Has to look back at original feedback
- If session context lost, requirements are gone
- This is why "white background + padding" kept being missed

**Should Be**:
```javascript
{
  content: "Use design-master: App icon white background + padding to fit app icon square",
  status: "pending"
}
```

**Impact**:
- Repeated issues ("Already said, make background white, add padding")
- Requirements lost between sessions
- Agents don't know WHAT to fix

**Status**: ⚠️ NEEDS FIXING

---

### 4. ❌ Specialized Agents Not Used Until Manually Requested

**Timeline**:
1. iOS work done by single ios-developer agent
2. Hit debugging wall with CompoundPickerView sheet not opening
3. User frustrated with lack of progress
4. Used `/clarify` to ask how to proceed
5. **Only then** did swiftui-specialist get offered as option

**Problem**: Should have been orchestrated from the start:
- Phase 1: design-master (design analysis)
- Phase 2: swiftui-specialist (UI implementation)
- Phase 3: swift-architect (architecture review)
- Phase 4: ios-dev (platform integration)
- Phase 5: Verification (simulator screenshots)
- Phase 6: code-reviewer-pro (quality gates)

**Root Cause**: `/orca` wasn't working properly (see #1 above)

**Status**: ✅ FIXED via `/orca` redesign

---

## What Was Fixed

### ✅ /orca Command - Complete Redesign

**New Workflow**:

#### Phase 1: Tech Stack Detection
- Checks prompt for keywords (iOS, SwiftUI, React, etc.)
- Checks project files (.xcodeproj, package.json, etc.)
- Determines appropriate team

#### Phase 2: Team Selection
- Predefined teams for iOS, Frontend, Backend, Mobile, Security
- Each team has specialized agents with clear roles

#### Phase 3: User Confirmation (MANDATORY)
- Shows proposed team
- Asks user to confirm or modify
- No more "surprise agent dispatching"

#### Phase 4: Workflow Execution
- Sequential agent dispatch with clear deliverables
- Quality gates between phases
- Verification phase BEFORE completion claims

#### Phase 5: Verification
- Platform-specific verification steps
- iOS: Clean build + simulator screenshots
- Frontend: Browser screenshots
- Backend: Test output

**File**: `~/.claude/commands/orca.md` (360 lines, comprehensive)

---

## What Needs to Be Done

### ⚠️ Task 1: Create iOS Verification Workflow

**File to Create**: `~/.claude/skills/ios-verification-workflow/SKILL.md`

**Purpose**: Enforce mandatory verification steps for iOS UI changes

**Content Should Include**:
```markdown
# iOS Verification Workflow

## Trigger
Use when claiming iOS UI work is complete, before marking todos as done.

## Mandatory Steps (NO EXCEPTIONS)

1. Clear DerivedData
   rm -rf ~/Library/Developer/Xcode/DerivedData/<Project>-*

2. Clean Build
   xcodebuild clean -project <Project>.xcodeproj -scheme <Scheme>

3. Fresh Build
   xcodebuild build -project <Project>.xcodeproj -scheme <Scheme> -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

4. Install to Simulator
   xcrun simctl install booted <path-to-app>

5. Launch App
   xcrun simctl launch booted <bundle-id>

6. Take Screenshot
   xcrun simctl io booted screenshot /tmp/verification-$(date +%s).png

7. Read Screenshot with Vision
   Use Read tool to analyze screenshot

8. Verify Changes Visible
   Confirm the changes you made are actually visible in the screenshot

9. ONLY THEN Mark Complete

## Red Flags
- "Should be working now"
- "Changes look correct"
- "I've updated the files"
- ANY completion claim without screenshot evidence
```

---

### ⚠️ Task 2: Fix /agentfeedback Todo Creation

**File to Update**: `~/.claude/commands/agentfeedback.md`

**Section to Fix**: Phase 5 (Create Todos with Agent Assignments)

**Current Problem**:
```javascript
TodoWrite([
  {
    content: "Use design-master to fix: [issues #1, #3, #5]",
    ...
  }
])
```

**Should Be**:
```javascript
TodoWrite([
  {
    content: "Use design-master: App icon white background + padding to fit in square",
    ...
  },
  {
    content: "Use swiftui-specialist: Search bar 60px hero position, remove filter pills",
    ...
  }
])
```

**Implementation**:
- Extract actual requirement text from each feedback item
- Embed full requirement in todo content
- Don't use issue number references
- Make todos self-contained

---

### ⚠️ Task 3: Update /visual-review for iOS

**File to Update**: `~/.claude/commands/visual-review.md`

**Add iOS Clean Build Section** (before taking screenshots):

```markdown
## iOS: Pre-Screenshot Verification

BEFORE taking simulator screenshots, ALWAYS:

1. Check if this is first verification after code changes
2. If YES, run clean build workflow:
   - Delete DerivedData
   - Clean build
   - Fresh build
   - Reinstall app

3. If NO (just reviewing existing install), proceed to screenshot

WHY: Xcode caching can show old code even after "rebuild"
```

---

## Key Insights

### 1. Orchestration is the Real Problem

The issue wasn't that agents are bad - it's that:
- Wrong agents were being used (non-existent spec-* agents)
- Specialized agents weren't being dispatched
- No verification workflows enforced
- No quality gates between phases

### 2. Todos Must Be Self-Contained

When creating todos from feedback:
- ❌ "Fix issues #1, #3, #5"
- ✅ "App icon: white background + padding for app icon square"

Todos should contain the FULL requirement, not references.

### 3. Platform-Specific Verification Is Critical

Generic verification ("run the tests") doesn't work for:
- iOS: Need DerivedData clearing, clean builds, simulator verification
- Frontend: Need browser screenshots, responsive checks
- Backend: Need endpoint testing, performance metrics

Each platform needs its own verification workflow.

### 4. User Confirmation Prevents Waste

By confirming the agent team before dispatch:
- User can correct misdetections
- User can add/remove agents
- No "surprise" wrong-agent dispatching
- Saves tokens and time

---

## Recommendations

### Immediate Actions

1. **Test new /orca command** on a small iOS task
   - Verify tech detection works
   - Verify team confirmation appears
   - Verify specialized agents are dispatched

2. **Create ios-verification-workflow skill**
   - Mandatory for any iOS UI work
   - Enforced by code-reviewer-pro agent
   - No completion without screenshot evidence

3. **Fix /agentfeedback todo creation**
   - Parse feedback into detailed todos
   - Embed full requirements, not references
   - Test with real feedback to verify

### Long-Term Improvements

1. **Create platform-specific verification skills**:
   - `ios-verification-workflow` (iOS/SwiftUI)
   - `frontend-verification-workflow` (React/Next.js)
   - `backend-verification-workflow` (Python/APIs)

2. **Add verification enforcement to agents**:
   - swiftui-specialist should auto-use ios-verification-workflow
   - frontend-developer should auto-use frontend-verification-workflow
   - Agents cannot claim completion without verification

3. **Improve session continuity**:
   - Capture detailed requirements in session context
   - When resuming, reload not just "tasks" but "specific requirements"
   - Prevent "white background + padding" from being lost between sessions

---

## Success Metrics

After implementing fixes, we should see:

1. **Reduced Repetition**
   - Requirements captured accurately in todos
   - No more "already told you this"

2. **Verification Before Completion**
   - 100% of iOS UI changes verified in simulator
   - Screenshot evidence before marking complete

3. **Specialized Agent Usage**
   - /orca automatically proposes correct team
   - swiftui-specialist used for SwiftUI debugging
   - design-master used for UI/UX work

4. **User Confidence**
   - Clear visibility into agent team
   - Confirmation before dispatch
   - Evidence-based completion claims

---

## Files Modified

1. ✅ `~/.claude/commands/orca.md` - Complete redesign (360 lines)

## Files to Create/Update

1. ⚠️ `~/.claude/skills/ios-verification-workflow/SKILL.md` - NEW
2. ⚠️ `~/.claude/commands/agentfeedback.md` - UPDATE (Phase 5)
3. ⚠️ `~/.claude/commands/visual-review.md` - UPDATE (add iOS clean build section)

---

## Next Steps

Ready to implement the remaining fixes:

1. Create `ios-verification-workflow` skill?
2. Fix `/agentfeedback` todo creation?
3. Update `/visual-review` with iOS clean build steps?
4. Test new `/orca` command on a real iOS task?

Your call on priority order.
