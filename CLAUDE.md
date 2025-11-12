# Project: claude-vibe-code

## ⚠️ CRITICAL: WHAT THIS REPOSITORY IS ⚠️

**THIS IS A CONFIGURATION ADMINISTRATIVE TOOL FOR GLOBAL CLAUDE CODE**

### What this means:
- This repo MANAGES configurations that get deployed to `~/.claude` (the GLOBAL Claude Code directory)
- Agents, commands, MCPs, skills, etc. are INSTALLED GLOBALLY to `~/.claude`
- Files in this repo are CONFIGURATION SOURCES that get deployed globally
- This is NOT a regular project - it's an ADMIN TOOL for Claude Code itself

### Directory Rules:

#### `_explore/` - DO NOT TOUCH - READ ONLY
- **THIS IS MY PERSONAL EXPLORATION FOLDER**
- **NEVER move files from here**
- **NEVER install anything here**
- **NEVER delete anything from here**
- **NEVER add anything to here**
- **NEVER point production configs to here**
- **TREAT AS READ-ONLY - NO EXCEPTIONS**

#### `mcp/` - Local development copies
- Contains LOCAL COPIES of MCP servers for development
- These get DEPLOYED to appropriate global locations
- The `.mcp.json` should point to production paths, NOT _explore

#### Other directories
- `agents/` - Agent definitions that deploy to `~/.claude/agents/`
- `.claude/commands/` - Commands that deploy to `~/.claude/commands/`
- `scripts/` - Admin scripts for managing the global Claude Code setup

### Installation Pattern:
1. Develop/configure in this repo
2. Deploy to `~/.claude` globally
3. All Claude Code sessions use the global configs

## THE RULE

After ANY code change:
1. Run it
2. Show output
3. Then verify

If you skip step 1, session ends.

---

_Last updated: 2025-11-12_

## Context7 Usage

When answering coding tasks that involve library/framework APIs, setup, or config:
- Automatically use the Context7 MCP tools (resolve-library-id, get-library-docs)
- Prefer version-specific docs when available
- You do not need the user to type "use context7"

## Visual Development

### Quick Visual Check
Immediately after implementing any front-end change:
- Identify what changed and navigate to affected views
- Use Playwright MCP to visit the page and capture evidence
  - Desktop 1440x900, Tablet 768x1024, Mobile 375x812
  - Save to `.orchestration/evidence/screenshots/`
- Check console for errors via Playwright MCP and save logs to `.orchestration/evidence/logs/`
- Compare against design principles and style guide (if present)

Tip: run the `/design-review` command for a guided flow with standardized outputs.
