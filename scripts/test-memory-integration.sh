#!/usr/bin/env bash
set -euo pipefail

# Test script for unified memory integration
# Verifies all components are working together

echo "🧪 Testing Unified Memory Integration"
echo "======================================"
echo

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
test_pass() {
  echo -e "${GREEN}✅ $1${NC}"
  ((TESTS_PASSED++))
}

test_fail() {
  echo -e "${RED}❌ $1${NC}"
  ((TESTS_FAILED++))
}

test_warn() {
  echo -e "${YELLOW}⚠️ $1${NC}"
}

# Test 1: Workshop Database
echo "Test 1: Workshop Database"
# Check both possible locations
WORKSHOP_DB=""
if [ -f ".workshop/workshop.db" ]; then
  WORKSHOP_DB=".workshop/workshop.db"
  WORKSHOP_DIR=".workshop"
elif [ -f ".claude/memory/workshop.db" ]; then
  WORKSHOP_DB=".claude/memory/workshop.db"
  WORKSHOP_DIR=".claude/memory"
fi

if [ -n "$WORKSHOP_DB" ]; then
  if command -v workshop >/dev/null 2>&1; then
    ENTRY_COUNT=$(workshop --workspace "$WORKSHOP_DIR" summary 2>/dev/null | grep -oE '[0-9]+ entries' | grep -oE '[0-9]+' || echo "0")
    if [ "$ENTRY_COUNT" -gt 0 ]; then
      test_pass "Workshop DB exists at $WORKSHOP_DB with $ENTRY_COUNT entries"
    else
      test_warn "Workshop DB exists but is empty"
    fi
  else
    test_fail "Workshop CLI not found"
  fi
else
  test_fail "Workshop DB not found in .workshop/ or .claude/memory/"
fi
echo

# Test 2: Cache Directory
echo "Test 2: SharedContext Cache"
CACHE_DIR="$HOME/.claude/cache"
if [ -d "$CACHE_DIR" ]; then
  CACHE_COUNT=$(find "$CACHE_DIR" -name "*.json" -type f 2>/dev/null | wc -l | tr -d ' ')
  if [ "$CACHE_COUNT" -gt 0 ]; then
    test_pass "Cache directory exists with $CACHE_COUNT cached projects"
  else
    test_warn "Cache directory exists but is empty"
  fi
else
  mkdir -p "$CACHE_DIR"
  test_warn "Created cache directory at $CACHE_DIR"
fi
echo

# Test 3: SessionStart Hook
echo "Test 3: SessionStart Hook"
if [ -f "$HOME/.claude/hooks/session-start.sh" ]; then
  test_pass "SessionStart hook exists"

  # Check if enhanced version is installed
  if grep -q "SharedContext" "$HOME/.claude/hooks/session-start.sh" 2>/dev/null; then
    test_pass "Enhanced SessionStart with caching is installed"
  else
    test_warn "Basic SessionStart installed (not enhanced version)"
  fi
else
  test_fail "SessionStart hook not found"
fi
echo

# Test 4: SessionEnd Hook
echo "Test 4: SessionEnd Hook"
if [ -f "$HOME/.claude/hooks/session-end.sh" ]; then
  test_pass "SessionEnd hook exists"
else
  test_fail "SessionEnd hook not found"
fi
echo

# Test 5: Memory Search Scripts
echo "Test 5: Memory Search Integration"
if [ -f "$HOME/.claude/scripts/memory-search-unified.py" ]; then
  # Try a test search
  if python3 "$HOME/.claude/scripts/memory-search-unified.py" "test" --json >/dev/null 2>&1; then
    test_pass "Unified memory search script works"
  else
    test_warn "Memory search script exists but failed test query"
  fi
else
  test_fail "Unified memory search script not found"
fi
echo

# Test 6: Context Cache Integration
echo "Test 6: Context Cache Integration"
if [ -f "$HOME/.claude/scripts/integrate-context-cache.py" ]; then
  # Test cache status check
  if python3 "$HOME/.claude/scripts/integrate-context-cache.py" status 2>/dev/null | grep -qE "(Cache valid|No valid cache)"; then
    test_pass "Context cache integration script works"
  else
    test_warn "Cache integration script exists but status check failed"
  fi
else
  test_fail "Context cache integration script not found"
fi
echo

# Test 7: Vibe Memory Database
echo "Test 7: Vibe Memory Database"
VIBE_DB=".claude/memory/vibe.db"
if [ -f "$VIBE_DB" ]; then
  CHUNK_COUNT=$(sqlite3 "$VIBE_DB" "SELECT COUNT(*) FROM chunks" 2>/dev/null || echo "0")
  if [ "$CHUNK_COUNT" -gt 0 ]; then
    test_pass "Vibe DB exists with $CHUNK_COUNT chunks indexed"
  else
    test_warn "Vibe DB exists but no chunks indexed yet"
  fi
else
  test_warn "Vibe DB not initialized (will be created on first index)"
fi
echo

# Test 8: MCP Configuration
echo "Test 8: MCP Server Configuration"
CLAUDE_CONFIG="$HOME/.claude.json"
if [ -f "$CLAUDE_CONFIG" ]; then
  # Check for memory-related MCP servers
  if grep -q "vibe-memory" "$CLAUDE_CONFIG" 2>/dev/null; then
    test_pass "Vibe-memory MCP configured"
  else
    test_warn "Vibe-memory MCP not configured in ~/.claude.json"
  fi

  if grep -q "shared-context" "$CLAUDE_CONFIG" 2>/dev/null; then
    test_pass "SharedContext MCP configured"
  else
    test_warn "SharedContext MCP not configured"
  fi

  if grep -q "project-context" "$CLAUDE_CONFIG" 2>/dev/null; then
    test_pass "ProjectContext MCP configured"
  else
    test_warn "ProjectContext MCP not configured"
  fi
else
  test_fail "~/.claude.json not found"
fi
echo

# Test 9: Memory-Aware ORCA
echo "Test 9: Memory-Aware ORCA"
if [ -f "$HOME/.claude/commands/orca-memory-aware.md" ]; then
  test_pass "Memory-aware ORCA command documentation exists"
else
  test_warn "Memory-aware ORCA not documented"
fi
echo

# Test 10: Integration Check
echo "Test 10: End-to-End Integration"
TEMP_CONTEXT=".claude/orchestration/temp/session-context.md"
if [ -f "$TEMP_CONTEXT" ]; then
  # Check if context mentions memory systems
  if grep -qE "(Workshop|SharedContext|vibe|Memory System Status)" "$TEMP_CONTEXT" 2>/dev/null; then
    test_pass "Session context includes memory system status"
  else
    test_warn "Session context exists but doesn't mention memory systems"
  fi
else
  test_warn "No session context file found (run a SessionStart to generate)"
fi
echo

# Summary
echo "======================================"
echo "Test Summary:"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
if [ "$TESTS_FAILED" -gt 0 ]; then
  echo -e "${RED}Failed: $TESTS_FAILED${NC}"
else
  echo -e "${GREEN}Failed: 0${NC}"
fi
echo

# Recommendations
if [ "$TESTS_FAILED" -gt 0 ] || [ "$TESTS_PASSED" -lt 10 ]; then
  echo "📋 Recommendations:"
  echo

  if ! [ -f ".claude/memory/workshop.db" ]; then
    echo "1. Initialize Workshop:"
    echo "   workshop --workspace .claude/memory init"
    echo
  fi

  if ! [ -f "$HOME/.claude/hooks/session-start.sh" ]; then
    echo "2. Install SessionStart hook:"
    echo "   cp ~/.claude/hooks/session-start-enhanced.sh ~/.claude/hooks/session-start.sh"
    echo "   chmod +x ~/.claude/hooks/session-start.sh"
    echo
  fi

  if ! grep -q "vibe-memory" "$HOME/.claude.json" 2>/dev/null; then
    echo "3. Configure MCP servers in ~/.claude.json"
    echo "   Add vibe-memory, shared-context, and project-context MCPs"
    echo
  fi
fi

# Final status
if [ "$TESTS_FAILED" -eq 0 ] && [ "$TESTS_PASSED" -ge 8 ]; then
  echo -e "${GREEN}✨ Memory integration is working well!${NC}"
elif [ "$TESTS_FAILED" -eq 0 ]; then
  echo -e "${YELLOW}⚠️ Memory integration partially configured${NC}"
else
  echo -e "${RED}❌ Memory integration needs configuration${NC}"
fi