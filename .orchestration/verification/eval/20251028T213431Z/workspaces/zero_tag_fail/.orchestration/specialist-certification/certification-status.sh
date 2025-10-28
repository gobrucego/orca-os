#!/bin/bash
#
# Specialist Certification Status Dashboard
#
# Purpose: Display certification status of all specialists
# Usage: View performance metrics and certification levels at a glance
#
# Stage 3 Week 6 - Specialist Certification
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

COSTS_FILE=".orchestration/costs.json"

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

# Check costs.json exists
check_costs_file() {
  if [ ! -f "$COSTS_FILE" ]; then
    echo -e "${YELLOW}⚠️ No performance data found${NC}"
    echo "Run tasks to populate specialist performance metrics."
    exit 0
  fi
}

#######################################
# Display Certification Status
#######################################

display_status() {
  echo -e "${CYAN}=========================================${NC}"
  echo -e "${CYAN}Specialist Certification Status${NC}"
  echo -e "${CYAN}=========================================${NC}"
  echo ""

  # Get all specialists
  local specialists=$(jq -r 'keys[]' "$COSTS_FILE")

  # Categorize by certification level
  local certified=()
  local probation=()
  local blocked=()

  while IFS= read -r specialist; do
    local level=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.certification.level' "$COSTS_FILE")

    if [ "$level" == "CERTIFIED" ]; then
      certified+=("$specialist")
    elif [ "$level" == "PROBATION" ]; then
      probation+=("$specialist")
    elif [ "$level" == "BLOCKED" ]; then
      blocked+=("$specialist")
    fi
  done <<< "$specialists"

  # Display CERTIFIED specialists
  if [ ${#certified[@]} -gt 0 ]; then
    echo -e "${GREEN}✅ CERTIFIED (Success Rate ≥ 70%):${NC}"
    for specialist in "${certified[@]}"; do
      local success_rate=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.success_rate' "$COSTS_FILE")
      local tasks=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.tasks_completed' "$COSTS_FILE")
      local trend=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.performance_trend' "$COSTS_FILE")

      local percentage=$(echo "scale=0; $success_rate * 100" | bc)
      echo "  $specialist (${percentage}%, $tasks tasks) - TREND: $trend"
    done
    echo ""
  fi

  # Display PROBATION specialists
  if [ ${#probation[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️ PROBATION (Success Rate 50-69% or Consecutive Failures):${NC}"
    for specialist in "${probation[@]}"; do
      local success_rate=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.success_rate' "$COSTS_FILE")
      local tasks=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.tasks_completed' "$COSTS_FILE")
      local trend=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.performance_trend' "$COSTS_FILE")

      local percentage=$(echo "scale=0; $success_rate * 100" | bc)
      echo "  $specialist (${percentage}%, $tasks tasks) - TREND: $trend"
    done
    echo ""
  fi

  # Display BLOCKED specialists
  if [ ${#blocked[@]} -gt 0 ]; then
    echo -e "${RED}❌ BLOCKED (Success Rate < 50% or Critical Failures):${NC}"
    for specialist in "${blocked[@]}"; do
      local success_rate=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.success_rate' "$COSTS_FILE")
      local tasks=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.tasks_completed' "$COSTS_FILE")
      local trend=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.performance_trend' "$COSTS_FILE")
      local review_notes=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.certification.review_notes' "$COSTS_FILE")

      local percentage=$(echo "scale=0; $success_rate * 100" | bc)
      echo "  $specialist (${percentage}%, $tasks tasks) - TREND: $trend"
      echo "    Reason: $review_notes"
    done
    echo ""
  fi

  # Summary stats
  local total=$(echo "$specialists" | wc -l | xargs)  # xargs trims whitespace
  local certified_count=${#certified[@]}
  local probation_count=${#probation[@]}
  local blocked_count=${#blocked[@]}

  local certified_pct=0
  local probation_pct=0
  local blocked_pct=0

  if [ "$total" -gt 0 ]; then
    certified_pct=$(echo "scale=0; $certified_count * 100 / $total" | bc)
    probation_pct=$(echo "scale=0; $probation_count * 100 / $total" | bc)
    blocked_pct=$(echo "scale=0; $blocked_count * 100 / $total" | bc)
  fi

  echo -e "${CYAN}Summary:${NC}"
  echo "Total specialists: $total"
  echo -e "  ${GREEN}Certified: $certified_count (${certified_pct}%)${NC}"
  echo -e "  ${YELLOW}Probation: $probation_count (${probation_pct}%)${NC}"
  echo -e "  ${RED}Blocked: $blocked_count (${blocked_pct}%)${NC}"

  # Warnings
  if [ ${#blocked[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}⚠️ WARNING: ${#blocked[@]} specialist(s) blocked from dispatch${NC}"
    echo "These specialists cannot be assigned tasks until performance improves."
  fi

  if [ ${#probation[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}⚠️ NOTICE: ${#probation[@]} specialist(s) on probation${NC}"
    echo "These specialists are restricted to simple tasks (difficulty ≤ 3)."
  fi
}

#######################################
# Main
#######################################

check_jq
check_costs_file
display_status

#######################################
# Certification Status Dashboard Complete
#
# This script provides an overview of all specialist certification levels
# for quick assessment of team health.
#######################################
