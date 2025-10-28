#!/bin/bash
#
# Verification Budget Tracker
#
# Purpose: Enforce 20% token allocation for verification to prevent verification skipping
# Usage: workflow-orchestrator uses this to track and enforce budget limits
#
# Stage 3 Week 5 - Verification Budget
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

BUDGET_DIR=".orchestration/verification-budget"
mkdir -p "$BUDGET_DIR"

# Default budget percentages
IMPLEMENTATION_PERCENTAGE=0.80  # 80%
VERIFICATION_PERCENTAGE=0.20    # 20%
PLANNING_PERCENTAGE=0.05        # 5% (from implementation budget)

# Warning threshold (soft warning at 90% of phase budget)
WARNING_THRESHOLD=0.90

#######################################
# Usage
#######################################

usage() {
  echo "Usage: $0 [command] [options]"
  echo ""
  echo "Commands:"
  echo "  --init                Initialize budget for new session"
  echo "  --record              Record specialist token usage"
  echo "  --check               Check current budget status"
  echo "  --adjust              Adjust total budget mid-session"
  echo ""
  echo "Init options:"
  echo "  --session-id ID                  Session identifier"
  echo "  --total-budget TOKENS            Total token budget (default: 200000)"
  echo "  --verification-percentage PCT    Verification % (default: 0.20)"
  echo ""
  echo "Record options:"
  echo "  --session-id ID         Session identifier"
  echo "  --specialist NAME       Specialist agent name"
  echo "  --tokens AMOUNT         Token usage"
  echo "  --phase PHASE           Phase: planning|implementation|verification"
  echo ""
  echo "Check options:"
  echo "  --session-id ID         Session identifier"
  echo ""
  echo "Adjust options:"
  echo "  --session-id ID                  Session identifier"
  echo "  --adjust-total-budget TOKENS     New total budget"
  echo ""
  echo "Examples:"
  echo "  $0 --init --session-id session-123 --total-budget 200000"
  echo "  $0 --record --session-id session-123 --specialist swiftui-developer --tokens 50000 --phase implementation"
  echo "  $0 --check --session-id session-123"
  echo "  $0 --adjust --session-id session-123 --adjust-total-budget 300000"
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

# Get budget file path
get_budget_file() {
  local session_id="$1"
  echo "${BUDGET_DIR}/${session_id}-budget.json"
}

#######################################
# Initialize Budget
#######################################

init_budget() {
  local session_id="$1"
  local total_budget="${2:-200000}"
  local verification_pct="${3:-$VERIFICATION_PERCENTAGE}"

  local budget_file=$(get_budget_file "$session_id")

  # Calculate budget allocations
  local verification_reserve=$(echo "scale=0; $total_budget * $verification_pct / 1" | bc)
  local implementation_budget=$(echo "scale=0; $total_budget - $verification_reserve" | bc)

  # Create budget file
  cat > "$budget_file" <<EOF
{
  "session_id": "$session_id",
  "timestamp_init": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "total_budget": $total_budget,
  "verification_percentage": $verification_pct,
  "verification_reserve": $verification_reserve,
  "implementation_budget": $implementation_budget,
  "usage": {
    "planning": {},
    "implementation": {},
    "verification": {}
  },
  "budget_status": {
    "implementation_total": 0,
    "implementation_remaining": $implementation_budget,
    "implementation_utilization": 0.0,
    "verification_total": 0,
    "verification_remaining": $verification_reserve,
    "verification_utilization": 0.0,
    "overall_utilization": 0.0,
    "status": "WITHIN_BUDGET"
  },
  "warnings": []
}
EOF

  echo -e "${GREEN}✅ Budget initialized${NC}"
  echo ""
  echo "Session ID: $session_id"
  echo "Total Budget: $(printf "%'d" $total_budget) tokens"
  echo "Implementation Budget (${implementation_pct}%): $(printf "%'d" $implementation_budget) tokens"
  echo "Verification Reserve (${verification_pct}%): $(printf "%'d" $verification_reserve) tokens"
  echo ""
  echo "Budget file: $budget_file"
}

#######################################
# Record Token Usage
#######################################

record_usage() {
  local session_id="$1"
  local specialist="$2"
  local tokens="$3"
  local phase="$4"

  local budget_file=$(get_budget_file "$session_id")

  if [ ! -f "$budget_file" ]; then
    echo -e "${RED}❌ Error: Budget not initialized for session $session_id${NC}"
    echo "Run: $0 --init --session-id $session_id --total-budget 200000"
    exit 1
  fi

  # Read current values
  local total_budget=$(jq -r '.total_budget' "$budget_file")
  local implementation_budget=$(jq -r '.implementation_budget' "$budget_file")
  local verification_reserve=$(jq -r '.verification_reserve' "$budget_file")

  # Add usage to appropriate phase
  jq --arg phase "$phase" \
     --arg specialist "$specialist" \
     --argjson tokens "$tokens" \
     '.usage[$phase][$specialist] = $tokens' \
     "$budget_file" > "${budget_file}.tmp" && mv "${budget_file}.tmp" "$budget_file"

  # Recalculate totals
  local implementation_total=$(jq '[.usage.planning[], .usage.implementation[]] | add // 0' "$budget_file")
  local verification_total=$(jq '[.usage.verification[]] | add // 0' "$budget_file")
  local overall_total=$((implementation_total + verification_total))

  local implementation_remaining=$((implementation_budget - implementation_total))
  local verification_remaining=$((verification_reserve - verification_total))

  local implementation_utilization=$(echo "scale=4; $implementation_total / $implementation_budget" | bc)
  local verification_utilization=$(echo "scale=4; $verification_total / $verification_reserve" | bc)
  local overall_utilization=$(echo "scale=4; $overall_total / $total_budget" | bc)

  # Determine status
  local status="WITHIN_BUDGET"
  if (( $(echo "$implementation_utilization > 1.0" | bc -l) )) || (( $(echo "$verification_utilization > 1.0" | bc -l) )); then
    status="OVER_BUDGET"
  elif (( $(echo "$implementation_utilization > $WARNING_THRESHOLD" | bc -l) )) || (( $(echo "$verification_utilization > $WARNING_THRESHOLD" | bc -l) )); then
    status="WARNING"
  fi

  # Update budget status
  jq --argjson impl_total "$implementation_total" \
     --argjson impl_remaining "$implementation_remaining" \
     --arg impl_util "$implementation_utilization" \
     --argjson ver_total "$verification_total" \
     --argjson ver_remaining "$verification_remaining" \
     --arg ver_util "$verification_utilization" \
     --arg overall_util "$overall_utilization" \
     --arg status "$status" \
     '.budget_status.implementation_total = $impl_total |
      .budget_status.implementation_remaining = $impl_remaining |
      .budget_status.implementation_utilization = ($impl_util | tonumber) |
      .budget_status.verification_total = $ver_total |
      .budget_status.verification_remaining = $ver_remaining |
      .budget_status.verification_utilization = ($ver_util | tonumber) |
      .budget_status.overall_utilization = ($overall_util | tonumber) |
      .budget_status.status = $status' \
     "$budget_file" > "${budget_file}.tmp" && mv "${budget_file}.tmp" "$budget_file"

  echo -e "${GREEN}✅ Usage recorded${NC}"
  echo ""
  echo "Specialist: $specialist ($phase)"
  echo "Tokens: $(printf "%'d" $tokens)"
  echo ""
  echo "Budget Status:"
  echo "  Implementation: $(printf "%'d" $implementation_total) / $(printf "%'d" $implementation_budget) (${implementation_utilization})"
  echo "  Verification: $(printf "%'d" $verification_total) / $(printf "%'d" $verification_reserve) (${verification_utilization})"
  echo "  Overall: $(printf "%'d" $overall_total) / $(printf "%'d" $total_budget) (${overall_utilization})"

  # Check for warnings/blocks
  if [ "$phase" == "implementation" ] && (( $(echo "$implementation_utilization > 1.0" | bc -l) )); then
    echo ""
    echo -e "${RED}❌ BLOCKED: Implementation budget exceeded${NC}"
    echo "Cannot proceed with more implementation specialists."
    echo "Options:"
    echo "  A) Increase total budget"
    echo "  B) Simplify implementation"
    exit 1
  elif [ "$phase" == "implementation" ] && (( $(echo "$implementation_utilization > $WARNING_THRESHOLD" | bc -l) )); then
    echo ""
    echo -e "${YELLOW}⚠️  WARNING: Implementation budget at ${implementation_utilization}${NC}"
    echo "Consider wrapping up implementation to reserve budget for verification."
  fi
}

#######################################
# Check Budget Status
#######################################

check_budget() {
  local session_id="$1"
  local budget_file=$(get_budget_file "$session_id")

  if [ ! -f "$budget_file" ]; then
    echo -e "${RED}❌ Error: Budget not initialized for session $session_id${NC}"
    exit 1
  fi

  # Read budget data
  local total_budget=$(jq -r '.total_budget' "$budget_file")
  local implementation_budget=$(jq -r '.implementation_budget' "$budget_file")
  local verification_reserve=$(jq -r '.verification_reserve' "$budget_file")
  local verification_pct=$(jq -r '.verification_percentage' "$budget_file")

  local impl_total=$(jq -r '.budget_status.implementation_total' "$budget_file")
  local impl_remaining=$(jq -r '.budget_status.implementation_remaining' "$budget_file")
  local impl_util=$(jq -r '.budget_status.implementation_utilization' "$budget_file")

  local ver_total=$(jq -r '.budget_status.verification_total' "$budget_file")
  local ver_remaining=$(jq -r '.budget_status.verification_remaining' "$budget_file")
  local ver_util=$(jq -r '.budget_status.verification_utilization' "$budget_file")

  local overall_util=$(jq -r '.budget_status.overall_utilization' "$budget_file")
  local status=$(jq -r '.budget_status.status' "$budget_file")

  # Display budget status
  echo -e "${CYAN}=========================================${NC}"
  echo -e "${CYAN}Budget Status for $session_id${NC}"
  echo -e "${CYAN}=========================================${NC}"
  echo ""
  echo "Total Budget: $(printf "%'d" $total_budget) tokens"
  echo "Implementation Budget (80%): $(printf "%'d" $implementation_budget) tokens"
  echo "Verification Reserve ($(echo "$verification_pct * 100" | bc)%): $(printf "%'d" $verification_reserve) tokens"
  echo ""

  # Implementation usage
  echo -e "${CYAN}Implementation Usage:${NC}"

  # List specialists
  jq -r '.usage.planning // {}, .usage.implementation // {} | to_entries[] | "  \(.key): \(.value)"' "$budget_file" | while read line; do
    echo "$line"
  done

  echo "  ─────────────────────────"
  echo "  Total: $(printf "%'d" $impl_total) / $(printf "%'d" $implementation_budget) ($(echo "scale=1; $impl_util * 100" | bc)%)"
  echo "  Remaining: $(printf "%'d" $impl_remaining) tokens"
  echo ""

  # Verification usage
  echo -e "${CYAN}Verification Usage:${NC}"

  if [ "$ver_total" -eq 0 ]; then
    echo "  (not yet started)"
    echo "  Reserved: $(printf "%'d" $verification_reserve) tokens"
  else
    jq -r '.usage.verification // {} | to_entries[] | "  \(.key): \(.value)"' "$budget_file" | while read line; do
      echo "$line"
    done
    echo "  ─────────────────────────"
    echo "  Total: $(printf "%'d" $ver_total) / $(printf "%'d" $verification_reserve) ($(echo "scale=1; $ver_util * 100" | bc)%)"
    echo "  Remaining: $(printf "%'d" $ver_remaining) tokens"
  fi

  echo ""
  echo -e "${CYAN}Overall Status:${NC}"

  if [ "$status" == "WITHIN_BUDGET" ]; then
    echo -e "  ${GREEN}✅ WITHIN BUDGET${NC} ($(echo "scale=1; $overall_util * 100" | bc)%)"
  elif [ "$status" == "WARNING" ]; then
    echo -e "  ${YELLOW}⚠️  WARNING${NC} - Approaching budget limits ($(echo "scale=1; $overall_util * 100" | bc)%)"
  else
    echo -e "  ${RED}❌ OVER BUDGET${NC} ($(echo "scale=1; $overall_util * 100" | bc)%)"
  fi

  echo ""
}

#######################################
# Adjust Budget
#######################################

adjust_budget() {
  local session_id="$1"
  local new_total_budget="$2"
  local budget_file=$(get_budget_file "$session_id")

  if [ ! -f "$budget_file" ]; then
    echo -e "${RED}❌ Error: Budget not initialized for session $session_id${NC}"
    exit 1
  fi

  # Read current verification percentage
  local verification_pct=$(jq -r '.verification_percentage' "$budget_file")

  # Recalculate allocations
  local verification_reserve=$(echo "scale=0; $new_total_budget * $verification_pct / 1" | bc)
  local implementation_budget=$(echo "scale=0; $new_total_budget - $verification_reserve" | bc)

  # Update budget file
  jq --argjson total "$new_total_budget" \
     --argjson impl "$implementation_budget" \
     --argjson ver "$verification_reserve" \
     '.total_budget = $total |
      .implementation_budget = $impl |
      .verification_reserve = $ver' \
     "$budget_file" > "${budget_file}.tmp" && mv "${budget_file}.tmp" "$budget_file"

  echo -e "${GREEN}✅ Budget adjusted${NC}"
  echo ""
  echo "New Total Budget: $(printf "%'d" $new_total_budget) tokens"
  echo "New Implementation Budget: $(printf "%'d" $implementation_budget) tokens"
  echo "New Verification Reserve: $(printf "%'d" $verification_reserve) tokens"
}

#######################################
# Main
#######################################

check_jq

# Parse command
if [ $# -eq 0 ]; then
  usage
fi

COMMAND=""
SESSION_ID=""
TOTAL_BUDGET=""
VERIFICATION_PCT=""
SPECIALIST=""
TOKENS=""
PHASE=""
ADJUST_TOTAL=""

while [ $# -gt 0 ]; do
  case "$1" in
    --init)
      COMMAND="init"
      shift
      ;;
    --record)
      COMMAND="record"
      shift
      ;;
    --check)
      COMMAND="check"
      shift
      ;;
    --adjust)
      COMMAND="adjust"
      shift
      ;;
    --session-id)
      SESSION_ID="$2"
      shift 2
      ;;
    --total-budget)
      TOTAL_BUDGET="$2"
      shift 2
      ;;
    --verification-percentage)
      VERIFICATION_PCT="$2"
      shift 2
      ;;
    --specialist)
      SPECIALIST="$2"
      shift 2
      ;;
    --tokens)
      TOKENS="$2"
      shift 2
      ;;
    --phase)
      PHASE="$2"
      shift 2
      ;;
    --adjust-total-budget)
      ADJUST_TOTAL="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Execute command
case "$COMMAND" in
  init)
    if [ -z "$SESSION_ID" ]; then
      echo "Error: --session-id required"
      usage
    fi
    init_budget "$SESSION_ID" "$TOTAL_BUDGET" "$VERIFICATION_PCT"
    ;;
  record)
    if [ -z "$SESSION_ID" ] || [ -z "$SPECIALIST" ] || [ -z "$TOKENS" ] || [ -z "$PHASE" ]; then
      echo "Error: --session-id, --specialist, --tokens, and --phase required"
      usage
    fi
    record_usage "$SESSION_ID" "$SPECIALIST" "$TOKENS" "$PHASE"
    ;;
  check)
    if [ -z "$SESSION_ID" ]; then
      echo "Error: --session-id required"
      usage
    fi
    check_budget "$SESSION_ID"
    ;;
  adjust)
    if [ -z "$SESSION_ID" ] || [ -z "$ADJUST_TOTAL" ]; then
      echo "Error: --session-id and --adjust-total-budget required"
      usage
    fi
    adjust_budget "$SESSION_ID" "$ADJUST_TOTAL"
    ;;
  *)
    usage
    ;;
esac

#######################################
# Budget Tracking Complete
#
# This script enforces 20% verification budget allocation to prevent
# verification from being skipped due to token exhaustion.
#
# workflow-orchestrator integrates this to block implementation
# when budget limits are reached.
#######################################
