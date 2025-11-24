#!/usr/bin/env bash
set -euo pipefail

# Clean SessionStart Hook - Everything in .claude/
# - Loads Workshop context from .claude/memory/
# - Checks SharedContext cache
# - Initializes vibe-memory if needed
# - Outputs to .claude/orchestration/temp/

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

# All paths under .claude/
CLAUDE_DIR=".claude"
MEMORY_DIR="$CLAUDE_DIR/memory"
ORCH_DIR="$CLAUDE_DIR/orchestration"
TEMP_DIR="$ORCH_DIR/temp"
CACHE_DIR="$CLAUDE_DIR/cache"

# Create structure if needed
mkdir -p "$MEMORY_DIR" "$TEMP_DIR" "$CACHE_DIR"

# Output file
OUT_MD="$TEMP_DIR/session-context.md"

# Database paths
WORKSHOP_DB="$MEMORY_DIR/workshop.db"
VIBE_DB="$MEMORY_DIR/vibe.db"

ts() { date -u '+%Y-%m-%dT%H:%M:%SZ'; }

# Generate project hash for caching
PROJECT_HASH=$(echo "$ROOT_DIR" | sha256sum | cut -c1-16)
PROJECT_NAME=$(basename "$ROOT_DIR")
GLOBAL_CACHE="$HOME/.claude/cache/${PROJECT_HASH}.json"
LOCAL_CACHE="$CACHE_DIR/context.json"

# Check cache (both global and local)
check_cache() {
  # Check local cache first
  if [ -f "$LOCAL_CACHE" ]; then
    if [ "$(find "$LOCAL_CACHE" -mtime -1 2>/dev/null)" ]; then
      echo "local:hit"
      return
    fi
  fi

  # Check global cache
  if [ -f "$GLOBAL_CACHE" ]; then
    if [ "$(find "$GLOBAL_CACHE" -mtime -1 2>/dev/null)" ]; then
      echo "global:hit"
      return
    fi
  fi

  echo "miss"
}

# Load CLAUDE.md (check both locations for compatibility)
CLAUDE_MD=""
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
elif [ -f "CLAUDE.md" ]; then
  CLAUDE_MD="CLAUDE.md"
fi

# Initialize Workshop if needed
if [ ! -f "$WORKSHOP_DB" ]; then
  if command -v workshop >/dev/null 2>&1; then
    workshop --workspace "$MEMORY_DIR" init 2>/dev/null || true
  fi
fi

# Initialize vibe.db if needed
if [ ! -f "$VIBE_DB" ]; then
  if [ -f "$HOME/.claude/scripts/memory-index.py" ]; then
    python3 "$HOME/.claude/scripts/memory-index.py" --init --db "$VIBE_DB" 2>/dev/null || true
  fi
fi

# Check cache status
CACHE_STATUS=$(check_cache)
CACHE_LOCATION=""
CACHED_SUMMARY=""

if [[ "$CACHE_STATUS" == *"hit"* ]]; then
  if [[ "$CACHE_STATUS" == "local:hit" ]]; then
    CACHE_LOCATION="local"
    CACHED_SUMMARY=$(jq -r '.summary // ""' "$LOCAL_CACHE" 2>/dev/null || echo "")
  else
    CACHE_LOCATION="global"
    CACHED_SUMMARY=$(jq -r '.summary // ""' "$GLOBAL_CACHE" 2>/dev/null || echo "")
  fi
fi

# Load Workshop context
WORKSHOP_CONTEXT=""
WORKSHOP_RECENT=""
if [ -f "$WORKSHOP_DB" ] && command -v workshop >/dev/null 2>&1; then
  WORKSHOP_CONTEXT=$(workshop --workspace "$MEMORY_DIR" context 2>/dev/null || echo "No context yet")
  WORKSHOP_RECENT=$(workshop --workspace "$MEMORY_DIR" recent --limit 5 2>/dev/null || echo "")
fi

# Check vibe.db status
VIBE_STATUS="not initialized"
if [ -f "$VIBE_DB" ]; then
  CHUNK_COUNT=$(sqlite3 "$VIBE_DB" 'SELECT COUNT(*) FROM chunks' 2>/dev/null || echo 0)
  VIBE_STATUS="ready ($CHUNK_COUNT chunks)"
fi

# Generate session context
{
  echo "# Session Context - $(ts)"
  echo
  echo "## Project: $PROJECT_NAME"
  echo "- Root: $ROOT_DIR"
  echo "- Hash: $PROJECT_HASH"
  echo

  echo "## Memory Status"
  echo "- Workshop: $([ -f "$WORKSHOP_DB" ] && echo "✅ active" || echo "❌ not initialized")"
  echo "- Vibe DB: $VIBE_STATUS"
  echo "- Cache: **$CACHE_STATUS** $([ -n "$CACHE_LOCATION" ] && echo "($CACHE_LOCATION)" || echo "")"
  echo

  if [ -n "$CACHED_SUMMARY" ]; then
    echo "## Cached Context"
    echo "$CACHED_SUMMARY"
    echo
  fi

  if [ -n "$WORKSHOP_CONTEXT" ]; then
    echo "## Workshop Context"
    echo "$WORKSHOP_CONTEXT"
    echo
  fi

  if [ -n "$WORKSHOP_RECENT" ]; then
    echo "## Recent Activity"
    echo "$WORKSHOP_RECENT"
    echo
  fi

  echo "## Memory Tools Available"
  echo "- \`query_context\` - Get project context (with caching)"
  echo "- \`memory.search\` - Search local vibe.db"
  echo "- \`workshop\` - Record decisions/gotchas"
  echo

  echo "## Directory Structure"
  echo '```'
  echo ".claude/"
  echo "├── memory/          # All databases"
  echo "│   ├── workshop.db  # $([ -f "$WORKSHOP_DB" ] && echo "✅" || echo "❌") Decisions/gotchas"
  echo "│   └── vibe.db      # $([ -f "$VIBE_DB" ] && echo "✅" || echo "❌") Code search"
  echo "├── orchestration/   # Working files"
  echo "│   ├── temp/        # Session files"
  echo "│   └── evidence/    # Artifacts"
  echo "└── cache/           # Context cache"
  echo '```'
} > "$OUT_MD"

echo "SessionStart:clean hook success: Context written to $OUT_MD"

# Display CLAUDE.md if it exists
if [ -n "$CLAUDE_MD" ]; then
  echo ""
  echo "═══════════════════════════════════════════════════════════"
  echo "PROJECT INSTRUCTIONS ($CLAUDE_MD)"
  echo "═══════════════════════════════════════════════════════════"
  echo ""
  cat "$CLAUDE_MD"
  echo ""
  echo "═══════════════════════════════════════════════════════════"
  echo "END OF PROJECT INSTRUCTIONS"
  echo "═══════════════════════════════════════════════════════════"
fi

# Signal if cache miss
if [ "$CACHE_STATUS" = "miss" ]; then
  echo ""
  echo "🔴 Cache miss - Call query_context() to populate cache for future sessions"
fi

exit 0