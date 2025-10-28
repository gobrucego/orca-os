#!/bin/bash
#
# Specialist Performance Updater
#
# Purpose: Update specialist performance metrics and recalculate certification after each task
# Usage: workflow-orchestrator runs this after verification-agent completes
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

# Certification thresholds
CERTIFIED_THRESHOLD=0.70   # 70%
PROBATION_THRESHOLD=0.50   # 50%
MIN_TASKS_FOR_CERTIFICATION=5

#######################################
# Usage
#######################################

usage() {
  echo "Usage: $0 --specialist NAME --task-id ID --verdict VERDICT --cost TOKENS"
  echo ""
  echo "Required arguments:"
  echo "  --specialist NAME    Specialist agent name"
  echo "  --task-id ID         Task identifier"
  echo "  --verdict VERDICT    PASSED or BLOCKED"
  echo "  --cost TOKENS        Token cost for this task"
  echo ""
  echo "Example:"
  echo "  $0 --specialist swiftui-developer --task-id login-screen-001 --verdict PASSED --cost 42000"
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

# Initialize costs.json if not exists
init_costs_file() {
  if [ ! -f "$COSTS_FILE" ]; then
    mkdir -p "$(dirname "$COSTS_FILE")"
    echo '{}' > "$COSTS_FILE"
  fi
}

# Initialize specialist if not exists
init_specialist() {
  local specialist="$1"

  # Check if specialist exists in costs.json
  local exists=$(jq -e --arg specialist "$specialist" 'has($specialist)' "$COSTS_FILE")

  if [ "$exists" == "false" ]; then
    echo "Initializing new specialist: $specialist"

    jq --arg specialist "$specialist" \
       '.[$specialist] = {
         "specialist_id": $specialist,
         "skill_vector": {
           "success_rate": 0.0,
           "tasks_completed": 0,
           "tasks_failed": 0,
           "average_cost_tokens": 0,
           "domains": [],
           "domain_vector": [],
           "performance_trend": "new",
           "last_10_tasks": [],
           "certification": {
             "level": "PROBATION",
             "since": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
             "review_date": "'$(date -u +%Y-%m-%dT%H:%M:%SZ -v+30d)'",
             "restrictions": ["max_difficulty: 3", "requires_additional_verification: true"],
             "review_notes": "New specialist, starting on PROBATION until proven",
             "reviewer": "automatic"
           }
         }
       }' "$COSTS_FILE" > "${COSTS_FILE}.tmp" && mv "${COSTS_FILE}.tmp" "$COSTS_FILE"
  fi
}

# Calculate certification level
calculate_certification() {
  local success_rate="$1"
  local tasks_completed="$2"
  local consecutive_failures="$3"

  # Not enough tasks → PROBATION
  if [ "$tasks_completed" -lt "$MIN_TASKS_FOR_CERTIFICATION" ]; then
    echo "PROBATION"
    return
  fi

  # 3+ consecutive failures → BLOCKED (regardless of overall rate)
  if [ "$consecutive_failures" -ge 3 ]; then
    echo "BLOCKED"
    return
  fi

  # 2 consecutive failures → PROBATION
  if [ "$consecutive_failures" -ge 2 ]; then
    echo "PROBATION"
    return
  fi

  # Check success rate thresholds
  if (( $(echo "$success_rate >= $CERTIFIED_THRESHOLD" | bc -l) )); then
    echo "CERTIFIED"
  elif (( $(echo "$success_rate >= $PROBATION_THRESHOLD" | bc -l) )); then
    echo "PROBATION"
  else
    echo "BLOCKED"
  fi
}

# Calculate performance trend
calculate_trend() {
  local last_10_json="$1"

  # Need at least 6 tasks to calculate trend
  local task_count=$(echo "$last_10_json" | jq 'length')
  if [ "$task_count" -lt 6 ]; then
    echo "new"
    return
  fi

  # Recent 5 tasks success rate
  local recent_5_passes=$(echo "$last_10_json" | jq '[.[-5:][].verdict] | map(select(. == "PASSED")) | length')
  local recent_5_rate=$(echo "scale=4; $recent_5_passes / 5" | bc)

  # Previous 5 tasks success rate
  local previous_5_passes=$(echo "$last_10_json" | jq '[.[0:5][].verdict] | map(select(. == "PASSED")) | length')
  local previous_5_rate=$(echo "scale=4; $previous_5_passes / 5" | bc)

  # Compare trends
  local diff=$(echo "$recent_5_rate - $previous_5_rate" | bc)

  if (( $(echo "$diff > 0.1" | bc -l) )); then
    echo "improving"
  elif (( $(echo "$diff < -0.1" | bc -l) )); then
    echo "declining"
  else
    echo "stable"
  fi
}

# Count consecutive failures
count_consecutive_failures() {
  local last_10_json="$1"

  # Check most recent tasks
  local consecutive=0
  local verdicts=$(echo "$last_10_json" | jq -r '.[] | .verdict' | tac)  # Reverse order (most recent first)

  while IFS= read -r verdict; do
    if [ "$verdict" == "FAILED" ]; then
      consecutive=$((consecutive + 1))
    else
      break  # Stop at first PASS
    fi
  done <<< "$verdicts"

  echo "$consecutive"
}

#######################################
# Update Performance
#######################################

update_performance() {
  local specialist="$1"
  local task_id="$2"
  local verdict="$3"
  local cost="$4"

  # Ensure specialist exists
  init_specialist "$specialist"

  # Read current metrics
  local tasks_completed=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.tasks_completed' "$COSTS_FILE")
  local tasks_failed=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.tasks_failed' "$COSTS_FILE")
  local avg_cost=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.average_cost_tokens' "$COSTS_FILE")
  local last_10=$(jq -c --arg specialist "$specialist" '.[$specialist].skill_vector.last_10_tasks' "$COSTS_FILE")

  # Update counters
  tasks_completed=$((tasks_completed + 1))
  if [ "$verdict" == "FAILED" ] || [ "$verdict" == "BLOCKED" ]; then
    tasks_failed=$((tasks_failed + 1))
    verdict_normalized="FAILED"
  else
    verdict_normalized="PASSED"
  fi

  # Calculate new success rate
  local success_rate=$(echo "scale=4; ($tasks_completed - $tasks_failed) / $tasks_completed" | bc)

  # Update average cost
  if [ "$tasks_completed" -eq 1 ]; then
    avg_cost=$cost
  else
    avg_cost=$(echo "scale=0; ($avg_cost * ($tasks_completed - 1) + $cost) / $tasks_completed" | bc)
  fi

  # Add task to last_10
  local new_task=$(cat <<EOF
{
  "task_id": "$task_id",
  "verdict": "$verdict_normalized",
  "cost": $cost,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)

  # Append to last_10, keep only last 10
  last_10=$(echo "$last_10" | jq --argjson task "$new_task" '. + [$task] | if length > 10 then .[-10:] else . end')

  # Calculate performance trend
  local performance_trend=$(calculate_trend "$last_10")

  # Count consecutive failures
  local consecutive_failures=$(count_consecutive_failures "$last_10")

  # Calculate new certification level
  local previous_level=$(jq -r --arg specialist "$specialist" '.[$specialist].skill_vector.certification.level' "$COSTS_FILE")
  local new_level=$(calculate_certification "$success_rate" "$tasks_completed" "$consecutive_failures")

  # Determine certification change reason
  local certification_change="no change"
  local review_notes=""

  if [ "$new_level" != "$previous_level" ]; then
    certification_change="$previous_level → $new_level"

    if [ "$new_level" == "BLOCKED" ]; then
      if [ "$consecutive_failures" -ge 3 ]; then
        review_notes="3+ consecutive failures detected, auto-blocked"
      else
        review_notes="Success rate dropped below 50%, auto-blocked"
      fi
    elif [ "$new_level" == "PROBATION" ]; then
      if [ "$consecutive_failures" -ge 2 ]; then
        review_notes="2 consecutive failures detected, auto-probation"
      else
        review_notes="Success rate dropped below 70%, auto-probation"
      fi
    elif [ "$new_level" == "CERTIFIED" ]; then
      review_notes="Success rate exceeded 70%, auto-certified"
    fi
  fi

  # Update costs.json
  jq --arg specialist "$specialist" \
     --argjson tasks_completed "$tasks_completed" \
     --argjson tasks_failed "$tasks_failed" \
     --arg success_rate "$success_rate" \
     --argjson avg_cost "$avg_cost" \
     --arg performance_trend "$performance_trend" \
     --argjson last_10 "$last_10" \
     --arg new_level "$new_level" \
     --arg review_notes "$review_notes" \
     '.[$specialist].skill_vector.tasks_completed = $tasks_completed |
      .[$specialist].skill_vector.tasks_failed = $tasks_failed |
      .[$specialist].skill_vector.success_rate = ($success_rate | tonumber) |
      .[$specialist].skill_vector.average_cost_tokens = $avg_cost |
      .[$specialist].skill_vector.performance_trend = $performance_trend |
      .[$specialist].skill_vector.last_10_tasks = $last_10 |
      .[$specialist].skill_vector.certification.level = $new_level |
      (if $new_level != .[$specialist].skill_vector.certification.level then
        .[$specialist].skill_vector.certification.since = "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'" else . end) |
      .[$specialist].skill_vector.certification.review_notes = $review_notes |
      .[$specialist].skill_vector.certification.reviewer = "automatic"' \
     "$COSTS_FILE" > "${COSTS_FILE}.tmp" && mv "${COSTS_FILE}.tmp" "$COSTS_FILE"

  # Display results
  echo -e "${GREEN}✅ Performance updated${NC}"
  echo ""
  echo "Specialist: $specialist"
  echo "Task: $task_id"
  echo "Verdict: $verdict_normalized"
  echo "Cost: $(printf "%'d" $cost) tokens"
  echo ""
  echo -e "${CYAN}Updated metrics:${NC}"
  echo "  Tasks completed: $tasks_completed"
  echo "  Tasks failed: $tasks_failed"
  echo "  Success rate: $(echo "scale=1; $success_rate * 100" | bc)%"
  echo "  Average cost: $(printf "%'d" $avg_cost) tokens"
  echo "  Performance trend: $performance_trend"
  echo "  Consecutive failures: $consecutive_failures"
  echo ""
  echo -e "${CYAN}Certification:${NC}"

  if [ "$certification_change" == "no change" ]; then
    if [ "$new_level" == "CERTIFIED" ]; then
      echo -e "  ${GREEN}CERTIFIED${NC} (no change)"
    elif [ "$new_level" == "PROBATION" ]; then
      echo -e "  ${YELLOW}PROBATION${NC} (no change)"
    else
      echo -e "  ${RED}BLOCKED${NC} (no change)"
    fi
  else
    echo -e "  ${YELLOW}⚠️ CERTIFICATION CHANGED: $certification_change${NC}"
    echo "  Reason: $review_notes"

    if [ "$new_level" == "BLOCKED" ]; then
      echo ""
      echo -e "${RED}⚠️ SPECIALIST BLOCKED FROM FUTURE DISPATCH${NC}"
      echo "This specialist cannot be dispatched until performance improves."
    elif [ "$new_level" == "PROBATION" ]; then
      echo ""
      echo -e "${YELLOW}⚠️ SPECIALIST ON PROBATION${NC}"
      echo "Restricted to simple tasks (difficulty ≤ 3) until performance improves."
    fi
  fi
}

#######################################
# Main
#######################################

check_jq
init_costs_file

# Parse arguments
if [ $# -lt 8 ]; then
  usage
fi

SPECIALIST=""
TASK_ID=""
VERDICT=""
COST=""

while [ $# -gt 0 ]; do
  case "$1" in
    --specialist)
      SPECIALIST="$2"
      shift 2
      ;;
    --task-id)
      TASK_ID="$2"
      shift 2
      ;;
    --verdict)
      VERDICT="$2"
      shift 2
      ;;
    --cost)
      COST="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Validate arguments
if [ -z "$SPECIALIST" ] || [ -z "$TASK_ID" ] || [ -z "$VERDICT" ] || [ -z "$COST" ]; then
  echo -e "${RED}Error: Missing required arguments${NC}"
  usage
fi

# Update performance
update_performance "$SPECIALIST" "$TASK_ID" "$VERDICT" "$COST"

#######################################
# Performance Update Complete
#
# This script updates specialist performance metrics after each task
# and automatically recalculates certification level.
#
# workflow-orchestrator calls this after verification-agent completes.
#######################################
