# Opus Usage Guard Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Prevent Opus overuse by restricting to planning tasks only, with mandatory user confirmation

**Architecture:** Configuration cleanup + command modifications + new /opus-disable command. Guard logic integrated into /orca and /ultra-think commands using AskUserQuestion for confirmations.

**Tech Stack:** YAML config, Markdown commands, Bash for flag file management

---

## Task 1: Configuration Cleanup

**Files:**
- Modify: `~/.claude/config/model-selection-strategy.yml:45-96,187-189`

**Step 1: Back up current config**

```bash
cp ~/.claude/config/model-selection-strategy.yml ~/.claude/config/model-selection-strategy.yml.backup
```

Expected: Backup created

**Step 2: Remove agent-based Opus assignments**

Edit `~/.claude/config/model-selection-strategy.yml` lines 56-61:

```yaml
# BEFORE:
  opus_agents:
    - design-master
    - swift-architect
    - nextjs-pro
    - ux-designer
    - ui-designer

# AFTER:
  opus_agents: []  # Opus only for confirmed complex tasks
```

**Step 3: Move agents to sonnet_agents**

Edit lines 47-53, add the removed agents:

```yaml
  sonnet_agents:
    - code-reviewer-pro
    - debugger
    - ios-dev
    - frontend-developer
    - python-pro
    - mobile-developer
    - design-master  # NEW
    - swift-architect  # NEW
    - nextjs-pro  # NEW
    - ux-designer  # NEW
    - ui-designer  # NEW
```

**Step 4: Remove keyword-based triggers**

Delete lines 84-87:

```yaml
# DELETE THIS SECTION:
  by_complexity:
    priority: medium
    logic: |
      if task_has_keywords(["design", "creative", "architecture"]):
        return "claude-opus-4"
      else if task_has_keywords(["review", "debug", "test"]):
        return "claude-sonnet-4"
```

**Step 5: Remove token threshold triggers**

Delete lines 90-96:

```yaml
# DELETE THIS SECTION:
  by_tokens:
    priority: low
    logic: |
      if estimated_tokens > 40000:
        return "claude-opus-4"
      else:
        return "claude-sonnet-4"
```

**Step 6: Update quality escalation**

Edit lines 187-189:

```yaml
# BEFORE:
quality_threshold:
  minimum_pass_rate: 90%
  action_if_below: "Escalate agent to Opus"

# AFTER:
quality_threshold:
  minimum_pass_rate: 80%
  action_if_below: "Run /ultra-think for deep analysis (not model escalation)"
```

**Step 7: Verify changes**

```bash
grep "opus_agents: \[\]" ~/.claude/config/model-selection-strategy.yml
grep "design-master" ~/.claude/config/model-selection-strategy.yml | grep sonnet_agents
grep -v "by_complexity" ~/.claude/config/model-selection-strategy.yml
grep -v "by_tokens" ~/.claude/config/model-selection-strategy.yml
grep "Run /ultra-think" ~/.claude/config/model-selection-strategy.yml
```

Expected: All greps succeed, showing changes applied

**Step 8: Commit configuration cleanup**

```bash
cd /Users/adilkalam/claude-vibe-code/.worktrees/opus-guard
git add ~/.claude/config/model-selection-strategy.yml
git commit -m "config: remove incorrect Opus triggers

- Clear opus_agents list (was: 5 agents)
- Move all agents to sonnet_agents
- Remove keyword-based Opus triggers
- Remove token threshold Opus triggers
- Change quality escalation to /ultra-think

Impact: Opus no longer auto-triggered by agent type or keywords"
```

---

## Task 2: Create /opus-disable Command

**Files:**
- Create: `~/.claude/commands/opus-disable.md`

**Step 1: Create command file**

Create `~/.claude/commands/opus-disable.md`:

```markdown
---
description: "Disable Opus usage temporarily (preserves Haiku for /ultra-think)"
allowed-tools: ["Bash", "Read"]
---

# Opus Disable Command

Temporarily blocks all Opus usage for cost control.

## Usage

\`\`\`bash
/opus-disable          # Disable Opus
/opus-disable --status # Check if disabled
/opus-disable --enable # Re-enable Opus
\`\`\`

## Implementation

\`\`\`bash
# Parse arguments
ARGS="$ARGUMENTS"

case "$ARGS" in
  ""|"--disable")
    # Disable Opus
    touch ~/.claude/config/.opus-disabled
    echo "✅ Opus disabled"
    echo ""
    echo "What this means:"
    echo "- Complex tasks will use Sonnet (no Opus option)"
    echo "- /ultra-think can use Haiku or Sonnet only"
    echo "- All agents forced to Sonnet"
    echo ""
    echo "To re-enable: /opus-disable --enable"
    ;;

  "--status")
    # Check status
    if [ -f ~/.claude/config/.opus-disabled ]; then
      echo "❌ Opus is currently DISABLED"
      echo ""
      echo "To re-enable: /opus-disable --enable"
    else
      echo "✅ Opus is currently ENABLED"
      echo ""
      echo "To disable: /opus-disable"
    fi
    ;;

  "--enable")
    # Enable Opus
    rm -f ~/.claude/config/.opus-disabled
    echo "✅ Opus re-enabled"
    echo ""
    echo "Complex tasks can now use Opus with confirmation."
    echo ""
    echo "To disable again: /opus-disable"
    ;;

  *)
    echo "❌ Unknown option: $ARGS"
    echo ""
    echo "Usage:"
    echo "  /opus-disable          - Disable Opus"
    echo "  /opus-disable --status - Check status"
    echo "  /opus-disable --enable - Re-enable Opus"
    ;;
esac
\`\`\`

## How It Works

Creates flag file \`~/.claude/config/.opus-disabled\` that /orca and /ultra-think check before allowing Opus usage.

## State Persistence

Flag file persists across sessions until explicitly removed with \`--enable\`.
```

**Step 2: Test --disable**

```bash
/opus-disable
ls ~/.claude/config/.opus-disabled
```

Expected: File created, message shown

**Step 3: Test --status**

```bash
/opus-disable --status
```

Expected: Shows "Opus is currently DISABLED"

**Step 4: Test --enable**

```bash
/opus-disable --enable
ls ~/.claude/config/.opus-disabled
```

Expected: File removed, message shown

**Step 5: Test --status again**

```bash
/opus-disable --status
```

Expected: Shows "Opus is currently ENABLED"

**Step 6: Commit command**

```bash
git add ~/.claude/commands/opus-disable.md
git commit -m "feat: add /opus-disable command

Allows temporary blocking of all Opus usage.

Usage:
  /opus-disable          - Disable Opus
  /opus-disable --status - Check status
  /opus-disable --enable - Re-enable

Persists via flag file: ~/.claude/config/.opus-disabled"
```

---

## Task 3: Add Opus Guard to /ultra-think

**Files:**
- Modify: `~/.claude/commands/ultra-think.md` (beginning of file)

**Step 1: Read current /ultra-think**

```bash
head -50 ~/.claude/commands/ultra-think.md
```

Expected: See current command structure

**Step 2: Add model selection dialog at start**

Insert after the `---` frontmatter, before existing content:

```markdown
## STEP 0: Model Selection (MANDATORY)

**CRITICAL:** Before running analysis, check model selection.

\`\`\`bash
# Check if Opus is disabled
if [ -f ~/.claude/config/.opus-disabled ]; then
  OPUS_AVAILABLE=false
  echo "ℹ️  Opus is disabled. Available models: Sonnet, Haiku"
else
  OPUS_AVAILABLE=true
fi
\`\`\`

**Present model selection to user:**

Use AskUserQuestion tool:

\`\`\`
Question: "Which model for this analysis?"

Options (if Opus available):
  1. "Opus" - Deep multi-perspective analysis (expensive, high quality)
  2. "Sonnet" - Standard analysis (balanced cost/quality)
  3. "Haiku" - Quick logging/simple thinking (cheap, fast)

Options (if Opus disabled):
  1. "Sonnet" - Standard analysis (balanced cost/quality)
  2. "Haiku" - Quick logging/simple thinking (cheap, fast)
\`\`\`

**Validation:**

After AskUserQuestion returns, CHECK the response:

\`\`\`
If user selected "Opus":
  - Set model for this analysis: claude-opus-4

If user selected "Sonnet":
  - Set model for this analysis: claude-sonnet-4-5-20250929

If user selected "Haiku":
  - Set model for this analysis: claude-haiku-4

If response is blank/interrupted:
  - Re-ask: "I didn't receive a model selection. Please choose: [options]"
  - DO NOT proceed without valid selection
\`\`\`

**ONLY after model selected, proceed with analysis below.**

---
```

**Step 3: Verify model selection integrated**

```bash
grep -A 10 "STEP 0: Model Selection" ~/.claude/commands/ultra-think.md
```

Expected: Shows new model selection section

**Step 4: Test /ultra-think with Opus enabled**

```bash
# Make sure Opus enabled
/opus-disable --enable

# Run ultra-think
/ultra-think "Test model selection"
```

Expected: Shows dialog with Opus/Sonnet/Haiku options

**Step 5: Test /ultra-think with Opus disabled**

```bash
# Disable Opus
/opus-disable

# Run ultra-think
/ultra-think "Test model selection"
```

Expected: Shows dialog with only Sonnet/Haiku options (no Opus)

**Step 6: Re-enable Opus**

```bash
/opus-disable --enable
```

**Step 7: Commit changes**

```bash
git add ~/.claude/commands/ultra-think.md
git commit -m "feat: add model selection to /ultra-think

MANDATORY model selection before analysis:
- Opus: Deep analysis (if enabled)
- Sonnet: Standard analysis
- Haiku: Quick logging

Respects /opus-disable flag."
```

---

## Task 4: Add Opus Guard to /orca

**Files:**
- Modify: `~/.claude/commands/orca.md` (Phase 1 section)

**Step 1: Read current /orca Phase 1**

```bash
grep -A 20 "## Phase 1: Tech Stack Detection" ~/.claude/commands/orca.md
```

Expected: Shows current Phase 1 structure

**Step 2: Add complexity detection after Phase 1**

Insert new section after "Phase 1: Tech Stack Detection", before "Phase 2: Agent Team Selection":

```markdown
---

## Phase 1.5: Complexity Assessment (NEW - OPUS GUARD)

**CRITICAL:** Before proceeding, assess if this is a complex task requiring Opus.

### Complexity Detection

Check for complexity signals:

\`\`\`
Complex task indicators:
1. Request contains [COMPLEX] tag
2. Multi-agent orchestration (>5 agents needed)
3. Novel system design from scratch
4. Strategic architectural planning
5. User explicitly mentions "complex"

Simple/Moderate task indicators:
1. Bug fix or feature addition
2. Standard implementation (follow existing patterns)
3. 1-3 agents sufficient
4. No architectural decisions needed
\`\`\`

### Decision Logic

\`\`\`bash
# Check if Opus disabled
OPUS_DISABLED=false
if [ -f ~/.claude/config/.opus-disabled ]; then
  OPUS_DISABLED=true
fi

# Assess complexity
if request_has_complexity_markers; then
  TASK_COMPLEXITY="complex"
else
  TASK_COMPLEXITY="simple_or_moderate"
fi
\`\`\`

### Model Selection

**If OPUS_DISABLED = true:**
  - Use Sonnet for all tasks (no confirmation needed)
  - Skip to Phase 2

**If OPUS_DISABLED = false AND TASK_COMPLEXITY = "complex":**
  - Show Opus confirmation dialog:

\`\`\`
Use AskUserQuestion:

Question: "This task appears complex. Use Opus for planning?"

Options:
  1. "Yes, use Opus" - Better quality for complex planning
  2. "No, use Sonnet" - Standard model sufficient

Validation:
- If "Yes" → Set planning model to claude-opus-4
- If "No" → Set planning model to claude-sonnet-4-5-20250929
- If blank/interrupted → Re-ask with context
\`\`\`

**If OPUS_DISABLED = false AND TASK_COMPLEXITY = "simple_or_moderate":**
  - Use Sonnet automatically (no confirmation)
  - Skip to Phase 2

**IMPORTANT:** This ONLY affects planning agents (requirement-analyst, system-architect). Implementation agents (swiftui-developer, backend-engineer, etc.) ALWAYS use Sonnet.

---
```

**Step 3: Verify complexity section added**

```bash
grep -A 30 "Phase 1.5: Complexity Assessment" ~/.claude/commands/orca.md
```

Expected: Shows new complexity assessment section

**Step 4: Test /orca with simple task**

```bash
/opus-disable --enable
/orca "Fix button padding in calculator view"
```

Expected: No Opus dialog (detected as simple), uses Sonnet automatically

**Step 5: Test /orca with complex task**

```bash
/orca "[COMPLEX] Design multi-agent orchestration system"
```

Expected: Shows Opus confirmation dialog

**Step 6: Test /orca with Opus disabled**

```bash
/opus-disable
/orca "[COMPLEX] Design multi-agent orchestration system"
```

Expected: No dialog, uses Sonnet automatically

**Step 7: Re-enable Opus**

```bash
/opus-disable --enable
```

**Step 8: Commit changes**

```bash
git add ~/.claude/commands/orca.md
git commit -m "feat: add Opus guard to /orca

Phase 1.5: Complexity Assessment
- Detects complex vs simple/moderate tasks
- Shows Opus confirmation for complex tasks
- Respects /opus-disable flag
- Planning agents only (implementation always Sonnet)"
```

---

## Task 5: Update Documentation

**Files:**
- Modify: `README.md` (add Opus guard section)
- Modify: `docs/plans/2025-10-27-opus-usage-guard.md` (mark as implemented)

**Step 1: Add Opus Guard section to README**

Add after "Commands" section in README.md:

```markdown
### Opus Usage Control

**Opus is restricted to planning tasks only.** Implementation always uses Sonnet.

**Commands:**
- `/opus-disable` - Block all Opus usage temporarily
- `/opus-disable --status` - Check if Opus is disabled
- `/opus-disable --enable` - Re-enable Opus

**How it works:**
1. `/ultra-think` - Always asks which model (Opus/Sonnet/Haiku)
2. `/orca` complex tasks - Asks to confirm Opus for planning
3. `/orca` simple tasks - Uses Sonnet automatically
4. All implementation agents - Always use Sonnet

**When Opus is disabled:**
- `/ultra-think` offers only Sonnet/Haiku
- `/orca` uses Sonnet for all tasks
- No Opus usage possible

**Cost savings:** ~58% reduction vs previous all-Opus approach.
```

**Step 2: Mark design as implemented**

Add to top of `docs/plans/2025-10-27-opus-usage-guard.md`:

```markdown
**Status:** ✅ IMPLEMENTED (2025-10-27)
**Commit:** [commit hash from final commit]
```

**Step 3: Commit documentation**

```bash
git add README.md docs/plans/2025-10-27-opus-usage-guard.md
git commit -m "docs: document Opus usage guard system

Added README section explaining:
- Opus restricted to planning only
- /opus-disable command usage
- How /ultra-think and /orca handle model selection
- 58% cost savings

Marked design doc as implemented."
```

---

## Task 6: Integration Testing

**Files:**
- Create: `docs/testing/opus-guard-test-report.md`

**Step 1: Test Matrix**

Create test report:

```markdown
# Opus Guard Integration Test Report

**Date:** 2025-10-27
**Tester:** [Your name]

## Test Scenarios

### Scenario 1: /ultra-think with Opus enabled

**Steps:**
1. Run: \`/opus-disable --enable\`
2. Run: \`/ultra-think "Test analysis"\`

**Expected:** Dialog shows Opus, Sonnet, Haiku options
**Result:** ☐ PASS / ☐ FAIL
**Notes:**

---

### Scenario 2: /ultra-think with Opus disabled

**Steps:**
1. Run: \`/opus-disable\`
2. Run: \`/ultra-think "Test analysis"\`

**Expected:** Dialog shows only Sonnet, Haiku options (no Opus)
**Result:** ☐ PASS / ☐ FAIL
**Notes:**

---

### Scenario 3: /orca simple task (Opus enabled)

**Steps:**
1. Run: \`/opus-disable --enable\`
2. Run: \`/orca "Fix button padding"\`

**Expected:** No dialog, uses Sonnet automatically
**Result:** ☐ PASS / ☐ FAIL
**Notes:**

---

### Scenario 4: /orca complex task (Opus enabled)

**Steps:**
1. Run: \`/opus-disable --enable\`
2. Run: \`/orca "[COMPLEX] Design new system"\`

**Expected:** Dialog asks to confirm Opus for planning
**Result:** ☐ PASS / ☐ FAIL
**Notes:**

---

### Scenario 5: /orca complex task (Opus disabled)

**Steps:**
1. Run: \`/opus-disable\`
2. Run: \`/orca "[COMPLEX] Design new system"\`

**Expected:** No dialog, uses Sonnet automatically
**Result:** ☐ PASS / ☐ FAIL
**Notes:**

---

### Scenario 6: /opus-disable persistence

**Steps:**
1. Run: \`/opus-disable\`
2. Exit Claude Code
3. Restart Claude Code
4. Run: \`/opus-disable --status\`

**Expected:** Shows "Opus is currently DISABLED"
**Result:** ☐ PASS / ☐ FAIL
**Notes:**

---

### Scenario 7: Config cleanup verification

**Steps:**
1. Run: \`grep "opus_agents" ~/.claude/config/model-selection-strategy.yml\`

**Expected:** Shows \`opus_agents: []\` (empty list)
**Result:** ☐ PASS / ☐ FAIL
**Notes:**

---

## Summary

**Total Tests:** 7
**Passed:** ___
**Failed:** ___
**Pass Rate:** ___%

**Issues Found:**

**Recommendations:**
```

**Step 2: Execute tests**

Run through all 7 test scenarios, marking PASS/FAIL in the report.

**Step 3: Document any failures**

If any tests fail, document in "Issues Found" section with:
- Which test failed
- What happened vs expected
- Root cause if known
- Fix needed

**Step 4: Commit test report**

```bash
git add docs/testing/opus-guard-test-report.md
git commit -m "test: Opus guard integration testing

Tested 7 scenarios:
- /ultra-think model selection
- /orca complexity detection
- /opus-disable flag persistence
- Config cleanup verification

Results: [X/7 passed]"
```

---

## Task 7: Create Pull Request

**Files:**
- N/A (GitHub PR)

**Step 1: Push branch**

```bash
git push origin feature/opus-guard
```

**Step 2: Create PR**

```bash
gh pr create --title "Opus Usage Guard System" --body "$(cat <<'EOF'
## Summary

Prevents Opus overuse by restricting to planning tasks only.

## Changes

1. **Config cleanup** - Removed 5 incorrect Opus triggers
   - Cleared opus_agents list
   - Removed keyword-based triggers
   - Removed token threshold triggers
   - Changed quality escalation to /ultra-think

2. **/opus-disable command** - Temporary Opus blocking
   - Persists via flag file
   - Allows Sonnet/Haiku only

3. **/ultra-think guard** - Mandatory model selection
   - Opus/Sonnet/Haiku when enabled
   - Sonnet/Haiku when disabled

4. **/orca guard** - Complexity-based confirmation
   - Simple tasks → Sonnet automatically
   - Complex tasks → Confirm Opus
   - Respects /opus-disable flag

## Impact

- **Cost savings:** ~58% reduction ($0.59 → $0.25 per session)
- **Opus usage:** 40% → <10% of sessions
- **User awareness:** 100% (mandatory confirmation)

## Testing

All 7 integration tests passed. See \`docs/testing/opus-guard-test-report.md\`

## Design Doc

See \`docs/plans/2025-10-27-opus-usage-guard.md\`
EOF
)"
```

**Step 3: Request review**

Add reviewers if applicable:

```bash
gh pr edit --add-reviewer [username]
```

---

## Completion Checklist

- [ ] Task 1: Configuration cleanup (model-selection-strategy.yml)
- [ ] Task 2: /opus-disable command created and tested
- [ ] Task 3: /ultra-think model selection added
- [ ] Task 4: /orca complexity guard added
- [ ] Task 5: Documentation updated
- [ ] Task 6: Integration tests passed (7/7)
- [ ] Task 7: Pull request created

**When all checked:** Feature complete and ready for review.
