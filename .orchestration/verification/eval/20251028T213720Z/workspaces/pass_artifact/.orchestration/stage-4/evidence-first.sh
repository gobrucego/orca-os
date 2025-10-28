#!/bin/bash
#
# Evidence-First Dispatch Protocol (Stage 4)
#
# Purpose: Gather environmental evidence BEFORE making assumptions
# Usage: Called by /orca before specialist dispatch
#
# CRITICAL: This prevents assumption failures by detecting ambiguity
#
# Exit codes:
#   0 = Single unambiguous target found
#   1 = Error (no target identified)
#   2 = Ambiguity detected (HARD BLOCK - user clarification required)
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#######################################
# Configuration
#######################################

# Minimum confidence for unambiguous target
MIN_CONFIDENCE=0.9

#######################################
# Usage
#######################################

usage() {
  echo "Usage: $0 --request \"USER_REQUEST\""
  echo ""
  echo "Example:"
  echo "  $0 --request \"Build a simple premium card component for OBDN\""
  exit 1
}

#######################################
# Extract Target from Request
#######################################

extract_target() {
  local request="$1"

  # Priority 1: Extract after "for" keyword (most specific)
  local target=$(echo "$request" | grep -oiE 'for [a-zA-Z0-9_-]+' | sed 's/for //i' | tr -d ' ' | head -1)

  if [ -z "$target" ]; then
    # Priority 2: Extract all-caps words (likely project identifiers like OBDN)
    target=$(echo "$request" | grep -oE '\b[A-Z]{2,}[A-Za-z0-9_-]*\b' | head -1)
  fi

  if [ -z "$target" ]; then
    # Priority 3: Extract capitalized words (but skip common verbs like "Build")
    local skip_words="Build|Create|Add|Fix|Update|Design|Implement"
    target=$(echo "$request" | grep -oE '\b[A-Z][a-z0-9_-]+\b' | grep -vE "^($skip_words)$" | head -1)
  fi

  echo "$target"
}

#######################################
# Gather Environmental Evidence
#######################################

gather_evidence() {
  local target="$1"

  echo -e "${CYAN}=== Evidence-First Dispatch ===${NC}"
  echo "Target identifier: $target"
  echo ""

  # Evidence collection
  echo "Gathering evidence..."

  # 1. Find directories matching target (case-insensitive)
  local target_lower=$(echo "$target" | tr '[:upper:]' '[:lower:]')
  local dir_matches=$(find . -type d \( -name "*${target}*" -o -name "*${target_lower}*" \) 2>/dev/null | grep -v node_modules | grep -v .git | head -20)

  # 2. Find files referencing target
  local file_matches=$(grep -r "$target" --include="*.json" --include="*.md" --include="*.swift" --include="*.ts" --include="*.tsx" 2>/dev/null | cut -d: -f1 | sort -u | head -10)

  # 3. Find package.json or project files
  local project_files=""
  if [ -n "$dir_matches" ]; then
    while IFS= read -r dir; do
      if [ -f "$dir/package.json" ]; then
        project_files="$project_files\n$dir (Next.js/React project)"
      elif [ -f "$dir/Cargo.toml" ]; then
        project_files="$project_files\n$dir (Rust project)"
      elif [ -n "$(find "$dir" -name "*.xcodeproj" 2>/dev/null | head -1)" ]; then
        project_files="$project_files\n$dir (iOS/Xcode project)"
      fi
    done <<< "$dir_matches"
  fi

  echo ""
  echo -e "${CYAN}Evidence Summary:${NC}"
  echo ""

  # Count evidence
  local dir_count=0
  if [ -n "$dir_matches" ]; then
    dir_count=$(echo "$dir_matches" | wc -l | xargs)
  fi

  local file_count=0
  if [ -n "$file_matches" ]; then
    file_count=$(echo "$file_matches" | wc -l | xargs)
  fi

  echo "Directories matching '$target': $dir_count"
  if [ "$dir_count" -gt 0 ]; then
    echo "$dir_matches" | while IFS= read -r dir; do
      echo "  - $dir"
    done
  fi
  echo ""

  echo "Files referencing '$target': $file_count"
  if [ "$file_count" -gt 0 ] && [ "$file_count" -le 5 ]; then
    echo "$file_matches" | while IFS= read -r file; do
      echo "  - $file"
    done
  elif [ "$file_count" -gt 5 ]; then
    echo "  (showing first 5)"
    echo "$file_matches" | head -5 | while IFS= read -r file; do
      echo "  - $file"
    done
  fi
  echo ""

  # Detect ambiguity
  if [ "$dir_count" -eq 0 ] && [ "$file_count" -eq 0 ]; then
    echo -e "${RED}#STAGE_4_BLOCK: Target '$target' not found in codebase${NC}"
    echo -e "${RED}REQUIRED_ACTION: Ask user to clarify target location${NC}"
    exit 1
  fi

  if [ "$dir_count" -gt 1 ]; then
    echo -e "${YELLOW}#STAGE_4_AMBIGUITY_DETECTED: Multiple directories found${NC}"
    echo ""
    echo -e "${YELLOW}Ambiguity: Found $dir_count locations for '$target'${NC}"
    echo ""

    # Analyze each location
    echo "Location analysis:"
    echo "$dir_matches" | while IFS= read -r dir; do
      local project_type="Unknown"

      if [ -f "$dir/package.json" ]; then
        project_type="Next.js/React project"
      elif [ -f "$dir/Cargo.toml" ]; then
        project_type="Rust project"
      elif [ -n "$(find "$dir" -name "*.xcodeproj" 2>/dev/null | head -1)" ]; then
        project_type="iOS/Xcode project"
      elif [ -n "$(find "$dir" -name "*.swift" 2>/dev/null | head -1)" ]; then
        project_type="iOS/Swift code"
      elif [ -n "$(find "$dir" -name "*.tsx" -o -name "*.ts" 2>/dev/null | head -1)" ]; then
        project_type="TypeScript/React code"
      elif [ -n "$(find "$dir" -name "*.md" 2>/dev/null | head -1)" ]; then
        project_type="Documentation/Design"
      fi

      echo "  $dir → $project_type"
    done
    echo ""

    echo -e "${RED}#STAGE_4_BLOCK: AMBIGUITY${NC}"
    echo -e "${RED}REQUIRED_ACTION: AskUserQuestion with evidence${NC}"
    echo ""
    echo "MANDATORY: Present these options to user and get clarification"
    echo "DO NOT assume which location the user meant"
    echo "DO NOT proceed without explicit user selection"
    exit 2
  fi

  # Single unambiguous target
  if [ "$dir_count" -eq 1 ]; then
    echo -e "${GREEN}✅ Single unambiguous target found${NC}"
    echo ""
    echo "Target: $dir_matches"

    # Detect project type
    local project_type="Unknown"
    if [ -f "$dir_matches/package.json" ]; then
      project_type="Next.js/React project"
    elif [ -n "$(find "$dir_matches" -name "*.xcodeproj" 2>/dev/null | head -1)" ]; then
      project_type="iOS/Xcode project"
    fi

    echo "Type: $project_type"
    echo ""
    echo "#STAGE_4_EVIDENCE_GATHERED: $dir_matches"
    echo "#PROJECT_TYPE: $project_type"
    exit 0
  fi

  # File references only (no directories)
  echo -e "${YELLOW}⚠️ No project directory found, only file references${NC}"
  echo ""
  echo "#STAGE_4_UNCERTAINTY: Target found in files but no clear project directory"
  echo "REQUIRED_ACTION: Ask user to specify project location"
  exit 2
}

#######################################
# Main
#######################################

# Parse arguments
if [ $# -lt 2 ]; then
  usage
fi

REQUEST=""

while [ $# -gt 0 ]; do
  case "$1" in
    --request)
      REQUEST="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

if [ -z "$REQUEST" ]; then
  echo -e "${RED}Error: Missing required argument --request${NC}"
  usage
fi

# Extract target
TARGET=$(extract_target "$REQUEST")

if [ -z "$TARGET" ]; then
  echo -e "${RED}#STAGE_4_ERROR: Could not extract target identifier from request${NC}"
  echo "Request: $REQUEST"
  echo ""
  echo "REQUIRED_ACTION: Ask user to clarify target project/location"
  exit 1
fi

# Gather evidence
gather_evidence "$TARGET"
