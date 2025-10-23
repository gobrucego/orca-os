---
name: nav
description: View your complete Claude Code setup (agents, skills, MCPs) in a navigable format
---

# Claude Code Navigation

## 🤖 Agents (12 total - Response Awareness System)

Run to see all agents:
```bash
ls -1 ~/.claude/agents/*/
```

**Orchestration:**
- workflow-orchestrator.md - Pure orchestrator (Read, Task, TodoWrite only)

**Planning:**
- requirement-analyst.md - Requirements elicitation and analysis
- system-architect.md - Technical architecture design

**Implementation:**
- frontend-engineer.md - React 18, Vue 3, Next.js, Tailwind CSS v4, daisyUI 5
- backend-engineer.md - Node.js, Go, Python server development
- ios-engineer.md - Swift 6.0, SwiftUI, iOS ecosystem (Widgets, Live Activities)
- android-engineer.md - Kotlin, Jetpack Compose, Material Design 3
- cross-platform-mobile.md - React Native & Flutter development

**Quality:**
- test-engineer.md - Unit, integration, E2E, performance testing
- quality-validator.md - 3-phase quality gates (95%, 85%, 95% thresholds)

**Specialized:**
- design-engineer.md - UI/UX, design systems, accessibility
- infrastructure-engineer.md - CI/CD, Docker, Kubernetes, Fastlane

---

## 🎯 Skills

Run to see all skills:
```bash
ls -1 ~/.claude/skills/
```

Available skills include:
- brainstorming.md - Interactive brainstorming
- article-extractor/ - Extract article content
- youtube-transcript/ - Download YouTube transcripts
- uxscii-* - UI component creation tools
- And more...

---

## 📚 Context Files

Run to see context:
```bash
ls -1 ~/.claude/context/
```

**Current context:**
- daisyui.llms.txt (59KB) - Complete daisyUI 5 reference

---

## 🔌 MCP Servers

Run to see MCP configuration:
```bash
cat ~/.config/claude-code/mcp.json
```

**Configured MCPs:**
- XcodeBuildMCP - iOS simulator control and Xcode builds

**Also available (Claude Desktop):**
- sequential-thinking - Complex reasoning
- puppeteer - Browser automation

---

## 📦 Archive

Old agents preserved in:
```bash
ls -1 ~/claude-vibe-code/archive/
```

**Archived (11 agents):**
- Web agents: frontend-developer-1, frontend-developer-2, ui-engineer, etc.
- Mobile agents: mobile-app-builder, react-native-dev, etc.

---

## 🚀 Quick Commands

```bash
# Count agents
ls ~/.claude/agents/*.md | wc -l

# Search for specific agent
ls ~/.claude/agents/ | grep -i "mobile"

# View agent description
head -15 ~/.claude/agents/frontend-engineer.md

# Check MCP status (requires restart after changes)
cat ~/.config/claude-code/mcp.json
```

---

## 📊 Structure Summary

```
.claude/
├── agents/ (12 agents - Response Awareness System)
│   ├── orchestration/ - workflow-orchestrator
│   ├── planning/ - requirement-analyst, system-architect
│   ├── implementation/ - frontend-engineer, backend-engineer, ios-engineer, android-engineer, cross-platform-mobile
│   ├── quality/ - test-engineer, quality-validator
│   └── specialized/ - design-engineer, infrastructure-engineer
├── context/
│   └── daisyui.llms.txt (59KB)
├── skills/
│   └── 14+ skills (brainstorming, article-extractor, etc.)
└── commands/
    └── /orca, /enhance, /agentfeedback, /concept, /clarify, and more

~/.config/claude-code/
└── mcp.json (XcodeBuildMCP configured)

~/claude-vibe-code/
└── archive/ (60+ original agents synthesized into 12)
```

---

**Tip:** After reorganization, restart Claude Code to ensure all agents and MCPs are loaded properly.
