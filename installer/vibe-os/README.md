# create-vibe-os

**One-command installation for Vibe OS 2.0 - Context-aware, memory-persistent orchestration for Claude Code.**

[![npm version](https://img.shields.io/npm/v/create-vibe-os.svg)](https://www.npmjs.com/package/create-vibe-os)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Installation

```bash
npx create-vibe-os
```

That's it! The installer will guide you through setup.

---

## What You Get

- **3 MCP Servers** - ProjectContext, SharedContext, vibe-memory
- **18+ Slash Commands** - /orca, /response-aware, /design-director, etc.
- **120+ Agents** - Orchestrators and domain specialists
- **Session Hooks** - Auto-load context, prevent conflicts
- **Complete Setup** - Automatic ~/.claude configuration

---

## Quick Start

### Install

```bash
npx create-vibe-os
```

### Verify

```bash
vibe-os doctor
```

### Initialize Project

```bash
cd your-project
vibe-os init
```

### Use It

```bash
# In Claude Code
/orca "add dark mode to dashboard"
```

---

## CLI Commands

```bash
vibe-os doctor    # Verify installation
vibe-os init      # Initialize project
vibe-os info      # View configuration
vibe-os update    # Update to latest
```

---

## Prerequisites

- **Claude Code** - Installed and configured
- **Python 3.8+** - For MCP servers
- **Node.js 18+** - For installer
- **Workshop CLI** - (optional) Installed during setup

---

## What Gets Installed

### Global (~/.claude/)
```
~/.claude/
├── mcp/
│   ├── project-context/     # Context bundling
│   ├── shared-context/      # Cross-session state
│   └── vibe-memory/         # Memory graph
├── commands/                # Slash commands
├── agents/                  # Agent definitions
└── hooks/                   # Session automation
```

### Per-Project (.claude/)
```
.claude/
├── memory/
│   └── workshop.db          # Knowledge graph
└── orchestration/
    ├── evidence/            # Screenshots, reports
    ├── temp/                # Working files
    └── playbooks/           # Reference patterns
```

---

## Features

✅ **Interactive Installation** - Prompts for preferences
✅ **Prerequisites Check** - Validates environment
✅ **Automatic Configuration** - Updates ~/.claude.json
✅ **Workshop Integration** - Memory system setup
✅ **Project Initialization** - Creates .claude/ structure
✅ **Verification Tool** - Post-install validation

---

## Documentation

- **Full Documentation**: [See INSTALLER.md](../INSTALLER.md)
- **Repository**: https://github.com/adilkalam/claude-vibe-code
- **Issues**: https://github.com/adilkalam/claude-vibe-code/issues

---

## Example Usage

### Full Implementation with Verification

```bash
/response-aware "implement user authentication"
```

### Multi-Agent Orchestration

```bash
/orca "add search across 4 pages"
```

### Design Blueprint

```bash
/design-director "product detail page"
```

---

## Troubleshooting

### MCP Servers Not Loading

```bash
vibe-os info              # Check paths
python3 --version         # Verify Python
tail -f ~/.claude/logs/*  # Check logs
```

### Workshop Not Initializing

```bash
cargo install workshop-cli
cd your-project
workshop init
mv .workshop/workshop.db .claude/memory/workshop.db
```

### Commands Not Showing

```bash
ls ~/.claude/commands/    # Verify files
# Restart Claude Code
```

---

## Architecture

### Context Flow
```
Request → ProjectContext → Context Bundle → Agent → Implementation
```

### Memory Flow
```
Decision → Workshop DB → vibe-memory MCP → Future Queries
```

### Orchestration Flow
```
/orca → Stack Detection → Team Proposal → Execution → Verification
```

---

## Uninstallation

```bash
# Remove global installation
rm -rf ~/.claude/mcp/{project-context,shared-context,vibe-memory}
rm ~/.claude/commands/*.md
rm -rf ~/.claude/agents
rm ~/.claude/hooks/*.sh

# Edit ~/.claude.json to remove MCP servers

# Per-project
rm -rf .claude/
```

---

## License

MIT

---

## Contributing

Issues and PRs welcome at https://github.com/adilkalam/claude-vibe-code

---

**Built by the Vibe OS community • Making Claude Code remember everything**
