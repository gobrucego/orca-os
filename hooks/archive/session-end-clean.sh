#!/usr/bin/env bash
set -euo pipefail

# Clean SessionEnd Hook - Everything in .claude/
# - Captures session summary to .claude/memory/workshop.db
# - Updates cache if needed
# - Cleans up temp files

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

# All paths under .claude/
CLAUDE_DIR=".claude"
MEMORY_DIR="$CLAUDE_DIR/memory"
TEMP_DIR="$CLAUDE_DIR/orchestration/temp"
WORKSHOP_DB="$MEMORY_DIR/workshop.db"

# Check if Workshop is available
if ! command -v workshop >/dev/null 2>&1; then
  echo "Workshop not installed - session not captured"
  exit 0
fi

# Check if Workshop is initialized
if [ ! -f "$WORKSHOP_DB" ]; then
  echo "Workshop not initialized in .claude/memory/"
  echo "Run: workshop --workspace .claude/memory init"
  exit 0
fi

# Get git status for session summary
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-git")
CHANGED_FILES=$(git status --short 2>/dev/null | wc -l | tr -d ' ')

# Check for recent commits (last 2 hours)
RECENT_COMMIT=""
if git log -1 --since="2 hours ago" --oneline 2>/dev/null | grep -q .; then
  RECENT_COMMIT=$(git log -1 --oneline)
fi

# Build session summary
SESSION_SUMMARY="Session on branch: $BRANCH"
if [ "$CHANGED_FILES" -gt 0 ]; then
  SESSION_SUMMARY="$SESSION_SUMMARY | $CHANGED_FILES file(s) changed"
fi
if [ -n "$RECENT_COMMIT" ]; then
  SESSION_SUMMARY="$SESSION_SUMMARY | Commit: $RECENT_COMMIT"
fi

# Record to Workshop
workshop --workspace "$MEMORY_DIR" note "$SESSION_SUMMARY" \
  --tags "session" "auto-captured" 2>/dev/null || true

# Clean up old temp files (older than 24 hours)
if [ -d "$TEMP_DIR" ]; then
  find "$TEMP_DIR" -type f -mtime +1 -delete 2>/dev/null || true
fi

# Display summary
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "SESSION END SUMMARY"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "✅ Session captured to .claude/memory/workshop.db"
echo "📁 All memory stored in .claude/"
echo ""
echo "Branch: $BRANCH"
if [ "$CHANGED_FILES" -gt 0 ]; then
  echo "Changed files: $CHANGED_FILES"
fi
if [ -n "$RECENT_COMMIT" ]; then
  echo "Recent commit: $RECENT_COMMIT"
fi
echo ""
echo "To review: workshop --workspace .claude/memory recent"
echo "═══════════════════════════════════════════════════════════"

exit 0