#!/usr/bin/env bash
set -euo pipefail

# Enhanced SessionStart Hook with Unified Memory Integration
# - Loads cached context from SharedContext (zero tokens)
# - Initializes vibe-memory if needed
# - Loads Workshop context
# - Prepares comprehensive session context
# - Displays CLAUDE.md instructions

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

ORCH_DIR=".claude/orchestration"
TEMP_DIR="$ORCH_DIR/temp"
OUT_MD="$TEMP_DIR/session-context.md"
WORKSHOP_DIR=".claude/memory"
DB_PATH="$WORKSHOP_DIR/workshop.db"
VIBE_DB="$WORKSHOP_DIR/vibe.db"
CACHE_DIR="$HOME/.claude/cache"

mkdir -p "$ORCH_DIR" "$TEMP_DIR" "$CACHE_DIR"

ts() { date -u '+%Y-%m-%dT%H:%M:%SZ'; }

# Generate project identifier for caching
PROJECT_HASH=$(echo "$ROOT_DIR" | sha256sum | cut -c1-16)
PROJECT_NAME=$(basename "$ROOT_DIR")
CACHE_FILE="$CACHE_DIR/${PROJECT_HASH}.json"

# Function to check SharedContext cache
check_cache() {
  if [ -f "$CACHE_FILE" ]; then
    # Check if cache is less than 24 hours old
    if [ "$(find "$CACHE_FILE" -mtime -1 2>/dev/null)" ]; then
      echo "hit"
    else
      echo "expired"
    fi
  else
    echo "miss"
  fi
}

# Function to signal that ProjectContext should be cached
signal_cache_needed() {
  cat > "$TEMP_DIR/.cache-signal" << EOF
{
  "project_hash": "$PROJECT_HASH",
  "project_path": "$ROOT_DIR",
  "cache_file": "$CACHE_FILE",
  "timestamp": "$(ts)"
}
EOF
}

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

# Check SharedContext cache
CACHE_STATUS=$(check_cache)
CACHED_CONTEXT=""

if [ "$CACHE_STATUS" = "hit" ]; then
  echo "✅ Loading cached project context (zero tokens)..."
  CACHED_CONTEXT=$(cat "$CACHE_FILE" 2>/dev/null | jq -r '.summary // "Cache read error"')
else
  echo "⚠️ Cache $CACHE_STATUS - will load on first query_context call"
  signal_cache_needed
fi

# Initialize vibe-memory if needed
VIBE_STATUS="not initialized"
if [ ! -f "$VIBE_DB" ]; then
  if command -v python3 >/dev/null 2>&1 && [ -f "$HOME/.claude/scripts/memory-index.py" ]; then
    echo "Initializing vibe-memory database..."
    python3 "$HOME/.claude/scripts/memory-index.py" --init --project "$ROOT_DIR" 2>/dev/null || true
    VIBE_STATUS="initialized"
  fi
else
  VIBE_STATUS="ready ($(sqlite3 "$VIBE_DB" 'SELECT COUNT(*) FROM chunks' 2>/dev/null || echo 0) chunks indexed)"
fi

# Load Workshop context
WORKSHOP_CONTEXT=""
WORKSHOP_RECENT=""
if [ -f "$DB_PATH" ] && command -v workshop >/dev/null 2>&1; then
  WORKSHOP_CONTEXT=$(workshop --workspace "$WORKSHOP_DIR" context 2>/dev/null || echo "Workshop available but no context yet")
  WORKSHOP_RECENT=$(workshop --workspace "$WORKSHOP_DIR" recent --limit 5 2>/dev/null || echo "No recent entries")
else
  WORKSHOP_CONTEXT="Workshop not initialized - run: workshop --workspace .claude/memory init"
fi

# Generate comprehensive session context
{
  echo "# Session Context - $(ts)"
  echo
  echo "## Project: $PROJECT_NAME"
  echo "- Path: $ROOT_DIR"
  echo "- Hash: $PROJECT_HASH"
  echo "- Native Memory: ${NATIVE_PATH:-none} (${NATIVE_NOTE})"
  echo

  echo "## Memory System Status"
  echo "- SharedContext Cache: **$CACHE_STATUS**"
  if [ "$CACHE_STATUS" = "hit" ]; then
    echo "  - Cached context loaded (zero tokens)"
  fi
  echo "- Vibe Memory: $VIBE_STATUS"
  echo "- Workshop: $([ -f "$DB_PATH" ] && echo "active" || echo "not initialized")"
  echo

  if [ "$CACHE_STATUS" = "hit" ] && [ -n "$CACHED_CONTEXT" ]; then
    echo "## Cached Project Context"
    echo "$CACHED_CONTEXT"
    echo
  fi

  echo "## Workshop Context"
  echo "$WORKSHOP_CONTEXT"
  echo

  echo "## Recent Workshop Activity"
  echo "$WORKSHOP_RECENT"
  echo

  echo "## Available Memory Tools"
  echo "- \`query_context\` - ProjectContext MCP (with SharedContext caching)"
  echo "- \`memory.search\` - Vibe-memory MCP for local DB/vector search"
  echo "- \`workshop\` - CLI for decisions, gotchas, preferences"
  echo "- \`get_shared_context\` - Retrieve cached context"
  echo "- \`update_shared_context\` - Update cache"
  echo

  echo "## Integration Instructions"
  echo "1. If cache hit: Context already loaded, proceed with work"
  echo "2. If cache miss: Call \`query_context\` once, it will auto-cache"
  echo "3. Use \`memory.search\` for semantic search before expensive operations"
  echo "4. Record decisions/gotchas with Workshop as you work"
  echo
} > "$OUT_MD"

# Create a cache metadata file for MCP tools to use
if [ "$CACHE_STATUS" != "hit" ]; then
  cat > "$TEMP_DIR/cache-metadata.json" << EOF
{
  "project_hash": "$PROJECT_HASH",
  "project_path": "$ROOT_DIR",
  "cache_status": "$CACHE_STATUS",
  "cache_file": "$CACHE_FILE",
  "timestamp": "$(ts)",
  "action_required": "Call query_context to populate cache"
}
EOF
fi

echo "SessionStart:enhanced hook success: Session context written to $OUT_MD"

# Output CLAUDE.md contents for Claude to follow
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

# Signal to Claude that it should proactively use memory tools
if [ "$CACHE_STATUS" != "hit" ]; then
  echo ""
  echo "🔴 ACTION REQUIRED: Cache miss detected. Please call query_context() to populate cache."
  echo "This will cache the context for future sessions (zero tokens)."
fi

exit 0