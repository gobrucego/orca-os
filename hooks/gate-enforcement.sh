#!/bin/bash
# Gate Enforcement Hook
# Enforces Blueprint Gate, Pattern Violations, and Context Proof

set -e

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
GATE_RUNNER="$HOME/.claude/mcp/shared-context-server/dist/gates/runner.js"
PHASE_STATE=".claude/orchestration/phase_state.json"

# Only run if we have the gate runner
if [ ! -f "$GATE_RUNNER" ]; then
    # Gates not built yet - allow for now
    exit 0
fi

# Check what triggered this hook
TRIGGER="${HOOK_TRIGGER:-unknown}"

# ==================================================
# Blueprint Gate: Phase-Based Tool Enforcement
# ==================================================

if [[ "$TOOL_NAME" =~ ^(Write|Edit|MultiEdit|NotebookEdit)$ ]]; then
    # Check current phase
    CURRENT_PHASE=1
    if [ -f "$PHASE_STATE" ]; then
        CURRENT_PHASE=$(jq -r '.current_phase // 1' "$PHASE_STATE" 2>/dev/null || echo "1")
    fi

    # Phase 1: Code tools forbidden
    if [ "$CURRENT_PHASE" = "1" ]; then
        FILE_PATH=$(echo "$TOOL_PARAMS" | jq -r '.file_path // .notebook_path // ""' 2>/dev/null || echo "")

        # Check if it's a blueprint file (allowed)
        if [[ "$FILE_PATH" =~ ^00-blueprint/ ]]; then
            # Blueprint file - allowed
            exit 0
        fi

        # Check if it's code/implementation (forbidden)
        if [[ "$FILE_PATH" =~ ^(src/|components/|lib/|app/|pages/) ]]; then
            echo -e "${RED}🚫 BLUEPRINT GATE BLOCKED${NC}"
            echo ""
            echo -e "${YELLOW}Phase 1 = Blueprint Only${NC}"
            echo "Code tools (Write, Edit) are forbidden until blueprint is approved."
            echo ""
            echo "File attempted: $FILE_PATH"
            echo ""
            echo -e "${BLUE}What to do:${NC}"
            echo "1. Create blueprint in 00-blueprint/design-blueprint.md"
            echo "2. Get user approval"
            echo "3. User will advance to Phase 2"
            echo ""
            echo -e "${RED}#POISON_PATH: Trying to code before blueprint approved${NC}"
            exit 1
        fi
    fi
fi

# ==================================================
# Pattern Violation Detection
# ==================================================

if [[ "$TOOL_NAME" =~ ^(Write|Edit)$ ]] && [[ "${CHECK_PATTERNS:-true}" = "true" ]]; then
    FILE_PATH=$(echo "$TOOL_PARAMS" | jq -r '.file_path // ""' 2>/dev/null || echo "")

    # Only check CSS/style files
    if [[ "$FILE_PATH" =~ \.(css|scss|sass|tsx|jsx)$ ]]; then
        # Get file content
        CONTENT=$(echo "$TOOL_PARAMS" | jq -r '.content // .new_string // ""' 2>/dev/null || echo "")

        if [ -n "$CONTENT" ]; then
            # Run pattern violation detector
            VIOLATIONS=$(node "$GATE_RUNNER" pattern-check "$FILE_PATH" 2>&1 || echo "")

            if echo "$VIOLATIONS" | grep -q "BLOCKED"; then
                echo -e "${RED}🚫 PATTERN VIOLATION DETECTED${NC}"
                echo ""
                echo "$VIOLATIONS"
                echo ""
                echo -e "${RED}#POISON_PATH: Forbidden design patterns detected${NC}"
                exit 1
            elif echo "$VIOLATIONS" | grep -q "WARNING"; then
                echo -e "${YELLOW}⚠️  Pattern Warnings:${NC}"
                echo "$VIOLATIONS"
                # Don't block, just warn
            fi
        fi
    fi
fi

# ==================================================
# Context Proof Gate
# ==================================================

# This is checked by specialist agents before work starts
# The hook just ensures phase_state has proof status

if [ -f "$PHASE_STATE" ]; then
    CONTEXT_PROOF=$(jq -r '.context_proof_passed // false' "$PHASE_STATE" 2>/dev/null || echo "false")

    if [ "$CONTEXT_PROOF" = "false" ] && [ "$CURRENT_PHASE" != "0" ]; then
        echo -e "${YELLOW}⚠️  Context proof not verified${NC}"
        echo "Agent should prove understanding of design system before starting work."
        # Don't block - just reminder
    fi
fi

# All checks passed
exit 0
