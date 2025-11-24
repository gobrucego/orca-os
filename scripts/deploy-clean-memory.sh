#!/usr/bin/env bash
set -euo pipefail

# Deploy Clean Memory System to Global ~/.claude
# This script installs the clean memory integration to the global Claude config

echo "🚀 Deploying Clean Memory System to ~/.claude"
echo "============================================"
echo

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Source directory (this repo)
SOURCE_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$SOURCE_DIR"

# Target directory (global config)
TARGET_DIR="$HOME/.claude"

# Create target structure
echo "📁 Creating ~/.claude directory structure..."
mkdir -p "$TARGET_DIR"/{hooks,scripts,cache}

# Deploy hooks
echo "🔧 Installing hooks..."

# SessionStart
if [ -f ".claude/hooks/session-start-clean.sh" ]; then
  cp .claude/hooks/session-start-clean.sh "$TARGET_DIR/hooks/session-start.sh"
  chmod +x "$TARGET_DIR/hooks/session-start.sh"
  echo -e "  ${GREEN}✓${NC} SessionStart hook installed"
else
  echo -e "  ${RED}✗${NC} SessionStart hook not found"
fi

# SessionEnd
if [ -f ".claude/hooks/session-end-clean.sh" ]; then
  cp .claude/hooks/session-end-clean.sh "$TARGET_DIR/hooks/session-end.sh"
  chmod +x "$TARGET_DIR/hooks/session-end.sh"
  echo -e "  ${GREEN}✓${NC} SessionEnd hook installed"
else
  echo -e "  ${RED}✗${NC} SessionEnd hook not found"
fi

# Deploy scripts
echo "📜 Installing scripts..."

SCRIPTS=(
  "migrate-to-claude-dir.sh"
  "integrate-context-cache.py"
  "memory-search-unified.py"
  "test-memory-integration.sh"
)

for script in "${SCRIPTS[@]}"; do
  if [ -f ".claude/scripts/$script" ]; then
    cp ".claude/scripts/$script" "$TARGET_DIR/scripts/$script"
    chmod +x "$TARGET_DIR/scripts/$script"
    echo -e "  ${GREEN}✓${NC} $script installed"
  else
    echo -e "  ${YELLOW}⚠${NC} $script not found (skipping)"
  fi
done

# Deploy commands
echo "📝 Installing commands..."
if [ ! -d "$TARGET_DIR/commands" ]; then
  mkdir -p "$TARGET_DIR/commands"
fi

if [ -f ".claude/commands/orca-memory-aware.md" ]; then
  cp .claude/commands/orca-memory-aware.md "$TARGET_DIR/commands/"
  echo -e "  ${GREEN}✓${NC} orca-memory-aware command installed"
fi

# Update settings.json for hooks
echo "⚙️ Updating ~/.claude/settings.json..."

SETTINGS_FILE="$TARGET_DIR/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
  # Create new settings.json
  cat > "$SETTINGS_FILE" << 'EOF'
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "all",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/session-start.sh"
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "matcher": "all",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/session-end.sh"
          }
        ]
      }
    ]
  }
}
EOF
  echo -e "  ${GREEN}✓${NC} Created settings.json with hooks"
else
  echo -e "  ${YELLOW}⚠${NC} settings.json exists - please manually add hooks if needed"
  echo "  Add to hooks section:"
  echo '    "SessionStart": [{"matcher": "all", "hooks": [{"type": "command", "command": "~/.claude/hooks/session-start.sh"}]}]'
  echo '    "SessionEnd": [{"matcher": "all", "hooks": [{"type": "command", "command": "~/.claude/hooks/session-end.sh"}]}]'
fi

# Create global CLAUDE.md template
echo "📄 Creating global CLAUDE.md template..."
cat > "$TARGET_DIR/CLAUDE.md" << 'EOF'
# Global Claude Memory Configuration

This configuration ensures all projects use the clean `.claude/` structure.

## Memory System Architecture

All project memory lives in `.claude/`:
- `.claude/memory/` - Workshop and vibe databases
- `.claude/orchestration/` - Working files and artifacts
- `.claude/cache/` - Context caching

## Automatic Features

With this configuration:
1. **SessionStart** automatically loads cached context
2. **SessionEnd** captures session summaries to Workshop
3. **Memory search** available via vibe.db and Workshop
4. **Context caching** reduces token usage by 50-70%

## First Run in a Project

When you start a session in a new project:
1. Run migration: `bash ~/.claude/scripts/migrate-to-claude-dir.sh`
2. This creates the `.claude/` structure
3. Initializes Workshop and vibe.db
4. Future sessions will use cached context

## Available Commands

- `workshop --workspace .claude/memory <command>` - Workshop operations
- `python3 ~/.claude/scripts/memory-search-unified.py <query>` - Search all memory
- `bash ~/.claude/scripts/test-memory-integration.sh` - Test setup

## Important Rules

1. **Everything goes in .claude/** - no files in project root
2. **Memory in .claude/memory/** - all databases here
3. **Temp files in .claude/orchestration/temp/** - clean up after sessions
4. **Cache in .claude/cache/** - automatic context caching
EOF
echo -e "  ${GREEN}✓${NC} Global CLAUDE.md created"

# Summary
echo
echo "============================================"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo
echo "Installed to ~/.claude:"
echo "  ├── hooks/"
echo "  │   ├── session-start.sh"
echo "  │   └── session-end.sh"
echo "  ├── scripts/"
echo "  │   ├── migrate-to-claude-dir.sh"
echo "  │   ├── integrate-context-cache.py"
echo "  │   ├── memory-search-unified.py"
echo "  │   └── test-memory-integration.sh"
echo "  ├── commands/"
echo "  │   └── orca-memory-aware.md"
echo "  ├── settings.json"
echo "  └── CLAUDE.md"
echo
echo "Next steps:"
echo -e "${BLUE}1. Run migration in this project:${NC}"
echo "   bash ~/.claude/scripts/migrate-to-claude-dir.sh"
echo
echo -e "${BLUE}2. Test the integration:${NC}"
echo "   bash ~/.claude/scripts/test-memory-integration.sh"
echo
echo -e "${BLUE}3. Restart Claude Code to load new hooks${NC}"