#!/usr/bin/env bash
set -euo pipefail

# SessionStart Hook
# - Loads session context FROM Workshop (source of truth)
# - Displays CLAUDE.md instructions
# - Output: .claude/orchestration/temp/session-context.md

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

ORCH_DIR=".claude/orchestration"
TEMP_DIR="$ORCH_DIR/temp"
OUT_MD="$TEMP_DIR/session-context.md"
DB_PATH=".claude/memory/workshop.db"
WORKSHOP_DIR=".claude/memory"
VIBE_DB="$WORKSHOP_DIR/vibe.db"

mkdir -p "$ORCH_DIR" "$TEMP_DIR" "$WORKSHOP_DIR"

ts() { date -u '+%Y-%m-%dT%H:%M:%SZ'; }

# Native memory status (CLAUDE.md)
NATIVE_PATH=""
if [ -f "CLAUDE.md" ]; then
  NATIVE_PATH="CLAUDE.md"
elif [ -f ".claude/CLAUDE.md" ]; then
  NATIVE_PATH=".claude/CLAUDE.md"
fi

NATIVE_NOTE="missing"
if [ -n "$NATIVE_PATH" ]; then
  NATIVE_NOTE="$(wc -l < "$NATIVE_PATH" | tr -d ' ') lines"
fi

# Load context from Workshop (source of truth)
WORKSHOP_CONTEXT=""
if [ -f "$DB_PATH" ] && command -v workshop >/dev/null 2>&1; then
  WORKSHOP_CONTEXT=$(workshop --workspace "$WORKSHOP_DIR" context 2>/dev/null || echo "Workshop available but no context yet")
else
  WORKSHOP_CONTEXT="Workshop not initialized - run: workshop --workspace .claude/memory init"
fi

# Initialize vibe.db if needed
VIBE_STATUS="not initialized"
if [ ! -f "$VIBE_DB" ]; then
  if command -v python3 >/dev/null 2>&1 && [ -f "$HOME/.claude/scripts/memory-index.py" ]; then
    python3 "$HOME/.claude/scripts/memory-index.py" --init --db "$VIBE_DB" >/dev/null 2>&1 && VIBE_STATUS="initialized"
  fi
else
  VIBE_STATUS="ready ($(du -h "$VIBE_DB" | cut -f1))"
fi

# Generate session context from Workshop
{
  echo "# Session Context"
  echo
  echo "- Timestamp: $(ts)"
  echo "- Native Memory: ${NATIVE_PATH:-none} (${NATIVE_NOTE})"
  echo "- Vibe DB: $VIBE_STATUS"
  echo
  echo "## Workshop Context (Source of Truth)"
  echo
  echo "$WORKSHOP_CONTEXT"
  echo
} > "$OUT_MD"

echo "SessionStart context written: $OUT_MD"

# SharedContext auto-load instruction
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "SHAREDCONTEXT AUTO-LOAD REQUIRED"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "INSTRUCTION FOR CLAUDE: Immediately run the following MCP call:"
echo ""
echo "mcp__shared-context__get_shared_context({ projectId: \"$ROOT_DIR\" })"
echo ""
echo "This will load stored project context including architecture decisions,"
echo "critical rules, and project configuration. DO THIS FIRST before any work."
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""

# Output CLAUDE.md contents so Claude actually reads and follows instructions
if [ -n "$NATIVE_PATH" ]; then
  echo ""
  echo "═══════════════════════════════════════════════════════════"
  echo "PROJECT INSTRUCTIONS (CLAUDE.md) - FOLLOW THESE THROUGHOUT SESSION"
  echo "═══════════════════════════════════════════════════════════"
  echo ""
  cat "$NATIVE_PATH"
  echo ""
  echo "═══════════════════════════════════════════════════════════"
  echo "END OF PROJECT INSTRUCTIONS - THESE MUST BE FOLLOWED"
  echo "═══════════════════════════════════════════════════════════"
fi
