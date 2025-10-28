# Config Cleanup - Model Selection Strategy

**Date:** 2025-10-27
**File:** `~/.claude/config/model-selection-strategy.yml`
**Backup:** `~/.claude/config/model-selection-strategy.yml.backup`

## Changes Made

### 1. Cleared opus_agents list
**Before:**
```yaml
opus_agents:
  - design-master
  - swift-architect
  - nextjs-pro
  - ux-designer
  - ui-designer
```

**After:**
```yaml
opus_agents: []  # Opus only for confirmed complex tasks
```

### 2. Moved agents to sonnet_agents
Added the following agents to `sonnet_agents`:
- design-master
- swift-architect
- nextjs-pro
- ux-designer
- ui-designer

### 3. Removed keyword-based Opus triggers
Deleted entire `by_complexity` rule section that triggered Opus based on keywords like "design", "creative", "architecture".

### 4. Removed token threshold Opus triggers
Deleted entire `by_tokens` rule section that triggered Opus for tasks >40,000 tokens.

### 5. Changed quality escalation
**Before:**
```yaml
quality_threshold:
  minimum_pass_rate: 90%
  action_if_below: "Escalate agent to Opus"
```

**After:**
```yaml
quality_threshold:
  minimum_pass_rate: 80%
  action_if_below: "Run /ultra-think for deep analysis (not model escalation)"
```

## Verification

All changes verified with grep commands:
- ✅ `opus_agents: []` confirmed
- ✅ `design-master` in sonnet_agents confirmed
- ✅ `by_complexity` removed (no matches)
- ✅ `by_tokens` removed (no matches)
- ✅ `Run /ultra-think` in quality threshold confirmed

## Impact

Opus no longer auto-triggered by:
- Agent type (5 agents moved to Sonnet)
- Keywords in task description
- Token count thresholds
- Quality failures (now use /ultra-think instead)

Opus usage now requires explicit user confirmation via:
- /ultra-think model selection
- /orca complexity assessment (for complex tasks only)
