#!/bin/bash

# Enhanced File Location Guard - ENFORCES .claude/ structure
# This hook ensures orchestration files ONLY go in .claude/ directories

set -euo pipefail

# Colors for visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Check if this is a file write operation
if [[ "${TOOL_NAME:-}" == "Write" || "${TOOL_NAME:-}" == "NotebookEdit" || "${TOOL_NAME:-}" == "Edit" ]]; then

    # Extract the file path from the operation
    FILE_PATH=$(echo "$TOOL_PARAMS" | jq -r '.file_path // .notebook_path // ""' 2>/dev/null || echo "")

    if [[ -n "$FILE_PATH" ]]; then

        # Get the filename
        FILENAME=$(basename "$FILE_PATH")

        # Detect orchestration-related files that MUST go in .claude/
        ORCHESTRATION_PATTERNS=(
            "*-log.md"
            "*-audit.md"
            "*-analysis.md"
            "*-report.md"
            "*-evidence.md"
            "*-review.md"
            "*-plan.md"
            "*-notes.md"
            "session-*.md"
            "implementation-*.md"
            "verification-*.md"
        )

        # Check if this is an orchestration file
        IS_ORCHESTRATION=false
        for pattern in "${ORCHESTRATION_PATTERNS[@]}"; do
            if [[ "$FILENAME" == $pattern ]]; then
                IS_ORCHESTRATION=true
                break
            fi
        done

        # Additional content-based detection
        if [[ "$FILENAME" == *.md ]]; then
            # Check if path suggests orchestration content
            if [[ "$FILE_PATH" == *"temp"* ]] || \
               [[ "$FILE_PATH" == *"evidence"* ]] || \
               [[ "$FILE_PATH" == *"orchestration"* ]] || \
               [[ "$FILE_PATH" == *"analysis"* ]] || \
               [[ "$FILE_PATH" == *"audit"* ]]; then
                IS_ORCHESTRATION=true
            fi
        fi

        # ENFORCEMENT: If it's orchestration, it MUST be in .claude/
        if [[ "$IS_ORCHESTRATION" == true ]]; then
            # Check if it's already in .claude/
            if [[ "$FILE_PATH" != *"/.claude/"* ]]; then
                echo -e "${RED}${BOLD}🚨 ORCHESTRATION FILE LOCATION VIOLATION${NC}"
                echo ""
                echo -e "${RED}File: ${BOLD}$FILE_PATH${NC}"
                echo -e "${RED}This orchestration file MUST be in .claude/ directory!${NC}"
                echo ""
                echo -e "${GREEN}Suggested locations:${NC}"
                echo "  • .claude/orchestration/temp/$FILENAME (for working files)"
                echo "  • .claude/orchestration/evidence/$FILENAME (for final artifacts)"
                echo "  • .claude/orchestration/logs/$FILENAME (for logs)"
                echo ""
                echo -e "${YELLOW}This prevents clutter in the project root.${NC}"
                echo -e "${YELLOW}All orchestration files MUST go in .claude/${NC}"
                echo ""
                echo "BLOCKED: Move to .claude/ structure"
                exit 1
            fi
        fi

        # ENFORCEMENT: Prevent creating directories in project root
        DIR_PATH=$(dirname "$FILE_PATH")
        if [[ "$DIR_PATH" == "." ]] || [[ "$DIR_PATH" == "./" ]]; then
            # Creating file in project root - check if it's allowed
            ALLOWED_ROOT_FILES=(
                "README.md"
                "LICENSE"
                ".gitignore"
                "package.json"
                "Dockerfile"
                "docker-compose.yml"
                ".env"
                ".env.example"
            )

            IS_ALLOWED=false
            for allowed in "${ALLOWED_ROOT_FILES[@]}"; do
                if [[ "$FILENAME" == "$allowed" ]]; then
                    IS_ALLOWED=true
                    break
                fi
            done

            if [[ "$IS_ALLOWED" == false ]] && [[ "$FILENAME" == *.md ]]; then
                echo -e "${YELLOW}⚠️ Creating markdown file in project root${NC}"
                echo -e "File: $FILE_PATH"
                echo ""
                echo -e "${BLUE}Consider using .claude/ structure instead:${NC}"
                echo "  • .claude/docs/ (for documentation)"
                echo "  • .claude/orchestration/temp/ (for working files)"
                echo ""
                # Don't block, just warn
            fi
        fi

        # ENFORCEMENT: No scattered orchestration directories
        FORBIDDEN_DIRS=(
            "orchestration"  # Must be .claude/orchestration
            "evidence"       # Must be .claude/orchestration/evidence
            "logs"          # Must be .claude/orchestration/logs
            "temp"          # Must be .claude/orchestration/temp
            "workshop"      # Must be .claude/memory
        )

        for forbidden in "${FORBIDDEN_DIRS[@]}"; do
            # Check if creating directory outside .claude/
            if [[ "$DIR_PATH" == "$forbidden" ]] || [[ "$DIR_PATH" == "./$forbidden" ]]; then
                echo -e "${RED}${BOLD}🚨 DIRECTORY LOCATION VIOLATION${NC}"
                echo ""
                echo -e "${RED}Attempting to create: ${BOLD}$forbidden/${NC}"
                echo -e "${RED}This directory MUST be under .claude/${NC}"
                echo ""
                echo -e "${GREEN}Correct location: .claude/$forbidden/${NC}"
                echo ""
                echo "BLOCKED: Use .claude/ structure"
                exit 1
            fi
        done
    fi
fi

# Allow operation to continue if not blocked
exit 0