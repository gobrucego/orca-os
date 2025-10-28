#!/bin/bash
#
# Verification Replay Search
#
# Purpose: Find matching verification scripts in replay library
# Usage: verification-agent uses this to locate reusable scripts before generating new ones
#
# Stage 3 Week 6 - Verification Replay
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#######################################
# Configuration
#######################################

REPLAY_DIR=".orchestration/verification-replay"
MATCH_THRESHOLD=0.70  # Minimum similarity score to consider a match

#######################################
# Usage
#######################################

usage() {
  echo "Usage: $0 --feature-type TYPE --keywords \"keyword1,keyword2,...\""
  echo ""
  echo "Required arguments:"
  echo "  --feature-type TYPE     Task type: frontend-ui|ios-ui|backend-api"
  echo "  --keywords KEYWORDS     Comma-separated keywords"
  echo ""
  echo "Example:"
  echo "  $0 --feature-type frontend-ui --keywords \"login,email,password,authentication\""
  exit 1
}

#######################################
# Helpers
#######################################

# Check jq installed
check_jq() {
  if ! command -v jq &> /dev/null; then
    echo -e "${RED}❌ Error: jq not installed${NC}"
    echo "Install with: brew install jq"
    exit 1
  fi
}

# Calculate keyword overlap score
keyword_overlap() {
  local user_keywords="$1"
  local candidate_keywords="$2"

  # Convert to arrays
  IFS=',' read -ra user_kw <<< "$user_keywords"
  IFS=',' read -ra cand_kw <<< "$candidate_keywords"

  # Count overlaps
  local overlap=0
  for ukw in "${user_kw[@]}"; do
    for ckw in "${cand_kw[@]}"; do
      if [ "$ukw" == "$ckw" ]; then
        overlap=$((overlap + 1))
        break
      fi
    done
  done

  # Calculate score (overlap / total unique keywords)
  local total=${#user_kw[@]}
  local score=$(echo "scale=4; $overlap / $total" | bc)
  echo "$score"
}

#######################################
# Search Replay Library
#######################################

search_replay() {
  local feature_type="$1"
  local keywords="$2"

  # Determine directory based on feature type
  local search_dir=""
  case "$feature_type" in
    frontend-ui)
      search_dir="${REPLAY_DIR}/frontend"
      ;;
    ios-ui)
      search_dir="${REPLAY_DIR}/ios"
      ;;
    backend-api)
      search_dir="${REPLAY_DIR}/backend"
      ;;
    *)
      echo -e "${RED}Error: Unknown feature type $feature_type${NC}"
      echo "Supported types: frontend-ui, ios-ui, backend-api"
      exit 1
      ;;
  esac

  # Check if directory exists
  if [ ! -d "$search_dir" ]; then
    echo -e "${YELLOW}No replay scripts found for $feature_type${NC}"
    exit 0
  fi

  # Find all metadata files
  local metadata_files=$(find "$search_dir" -name "*.meta.json" 2>/dev/null || true)

  if [ -z "$metadata_files" ]; then
    echo -e "${YELLOW}No replay scripts found for $feature_type${NC}"
    exit 0
  fi

  echo -e "${CYAN}Searching replay library for $feature_type...${NC}"
  echo ""

  # Track best match
  local best_score=0
  local best_match=""
  local best_script=""

  # Search each candidate
  while IFS= read -r metadata_file; do
    # Read candidate keywords
    local candidate_keywords=$(jq -r '.keywords | join(",")' "$metadata_file")
    local script_id=$(jq -r '.script_id' "$metadata_file")
    local description=$(jq -r '.description' "$metadata_file")

    # Calculate keyword overlap score
    local score=$(keyword_overlap "$keywords" "$candidate_keywords")

    echo "Candidate: $script_id"
    echo "  Description: $description"
    echo "  Keywords: $candidate_keywords"
    echo "  Match score: $score"
    echo ""

    # Track best match
    if (( $(echo "$score > $best_score" | bc -l) )); then
      best_score=$score
      best_match="$metadata_file"
      best_script=$(dirname "$metadata_file")/$(jq -r '.script_id' "$metadata_file" | sed 's/.*-//').test.ts

      # Handle different extensions
      if [ ! -f "$best_script" ]; then
        best_script=$(dirname "$metadata_file")/$(jq -r '.script_id' "$metadata_file" | sed 's/.*-//')UITests.swift
      fi
      if [ ! -f "$best_script" ]; then
        best_script=$(dirname "$metadata_file")/$(jq -r '.script_id' "$metadata_file" | sed 's/.*-//')-test.sh
      fi
    fi
  done <<< "$metadata_files"

  # Determine if best match exceeds threshold
  if (( $(echo "$best_score >= $MATCH_THRESHOLD" | bc -l) )); then
    echo -e "${GREEN}✅ MATCH FOUND${NC}"
    echo ""
    echo "Best match: $(jq -r '.script_id' "$best_match")"
    echo "Description: $(jq -r '.description' "$best_match")"
    echo "Match score: $best_score (threshold: $MATCH_THRESHOLD)"
    echo "Script location: $best_script"
    echo "Metadata: $best_match"
    echo ""
    echo "Customizable fields:"
    jq -r '.customizable_fields[] | "  - \(.field): \(.description) (default: \(.default))"' "$best_match"
    exit 0
  else
    echo -e "${YELLOW}❌ NO MATCH FOUND${NC}"
    echo ""
    echo "Best match score: $best_score (below threshold: $MATCH_THRESHOLD)"
    echo "Recommendation: Generate new verification script"
    exit 1
  fi
}

#######################################
# Main
#######################################

check_jq

# Parse arguments
if [ $# -lt 4 ]; then
  usage
fi

FEATURE_TYPE=""
KEYWORDS=""

while [ $# -gt 0 ]; do
  case "$1" in
    --feature-type)
      FEATURE_TYPE="$2"
      shift 2
      ;;
    --keywords)
      KEYWORDS="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Validate arguments
if [ -z "$FEATURE_TYPE" ] || [ -z "$KEYWORDS" ]; then
  echo -e "${RED}Error: Missing required arguments${NC}"
  usage
fi

# Search replay library
search_replay "$FEATURE_TYPE" "$KEYWORDS"

#######################################
# Replay Search Complete
#
# This script searches the verification replay library for matching scripts
# based on feature type and keyword similarity.
#
# Exit codes:
#   0 = Match found (score >= threshold)
#   1 = No match found (generate new script)
#######################################
