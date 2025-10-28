#!/bin/bash
#
# Quality Validator Checklist Generator
#
# Purpose: Generate binary pass/fail checklist from completion criteria
# Usage: quality-validator runs this to make deterministic approval decisions
#
# Stage 3 Week 5 - Quality Validator Checklist
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#######################################
# Usage
#######################################

usage() {
  echo "Usage: $0 --task-id ID --task-type TYPE --proofpack PATH"
  echo ""
  echo "Required arguments:"
  echo "  --task-id ID          Task identifier"
  echo "  --task-type TYPE      Task type (ios-ui, frontend-ui, backend-api)"
  echo "  --proofpack PATH      Path to proofpack.json"
  echo ""
  echo "Example:"
  echo "  $0 --task-id login-screen-20251024T220000Z --task-type ios-ui --proofpack .orchestration/proofpacks/login-screen-proofpack.json"
  exit 1
}

#######################################
# Parse Arguments
#######################################

if [ $# -lt 6 ]; then
  usage
fi

while [ $# -gt 0 ]; do
  case "$1" in
    --task-id)
      TASK_ID="$2"
      shift 2
      ;;
    --task-type)
      TASK_TYPE="$2"
      shift 2
      ;;
    --proofpack)
      PROOFPACK_PATH="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

#######################################
# Validation
#######################################

# Check required arguments
if [ -z "$TASK_ID" ] || [ -z "$TASK_TYPE" ] || [ -z "$PROOFPACK_PATH" ]; then
  echo -e "${RED}Error: Missing required arguments${NC}"
  usage
fi

# Check jq installed
if ! command -v jq &> /dev/null; then
  echo -e "${RED}❌ Error: jq not installed${NC}"
  echo "Install with: brew install jq"
  exit 1
fi

# Load completion criteria
CRITERIA_FILE=".orchestration/completion-criteria/${TASK_TYPE}.json"

if [ ! -f "$CRITERIA_FILE" ]; then
  echo -e "${RED}❌ Error: Completion criteria not found: $CRITERIA_FILE${NC}"
  echo "Supported task types: ios-ui, frontend-ui, backend-api"
  exit 1
fi

# Check proofpack exists
if [ ! -f "$PROOFPACK_PATH" ]; then
  echo -e "${RED}❌ Error: Proofpack not found: $PROOFPACK_PATH${NC}"
  exit 1
fi

# Create output directory
OUTPUT_DIR=".orchestration/quality-checklist"
mkdir -p "$OUTPUT_DIR"

OUTPUT_FILE="${OUTPUT_DIR}/${TASK_ID}-checklist.json"

#######################################
# Checklist Generation
#######################################

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}Quality Validator Checklist${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""
echo "Task ID: $TASK_ID"
echo "Task Type: $TASK_TYPE"
echo "Completion Criteria: $CRITERIA_FILE"
echo "Proofpack: $PROOFPACK_PATH"
echo ""

# Read deliverables from completion criteria
DELIVERABLES=$(jq -r '.deliverables[] | @json' "$CRITERIA_FILE")

# Initialize checklist
cat > "$OUTPUT_FILE" <<EOF
{
  "task_id": "$TASK_ID",
  "task_type": "$TASK_TYPE",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "checklist": [],
  "summary": {
    "total_deliverables": 0,
    "required_deliverables": 0,
    "passed": 0,
    "failed": 0,
    "pass_rate": 0.0
  },
  "verdict": "UNKNOWN",
  "missing_deliverables": [],
  "blocking_reason": ""
}
EOF

# Counters
TOTAL=0
REQUIRED=0
PASSED=0
FAILED=0
MISSING_IDS=()

echo -e "${CYAN}Verifying Deliverables:${NC}"
echo ""

# Process each deliverable
while IFS= read -r deliverable_json; do
  # Parse deliverable
  DELIVERABLE_ID=$(echo "$deliverable_json" | jq -r '.id')
  DESCRIPTION=$(echo "$deliverable_json" | jq -r '.description')
  REQUIRED_FLAG=$(echo "$deliverable_json" | jq -r '.required')
  VERIFICATION_CMD=$(echo "$deliverable_json" | jq -r '.verification_command')

  TOTAL=$((TOTAL + 1))

  if [ "$REQUIRED_FLAG" == "true" ]; then
    REQUIRED=$((REQUIRED + 1))
  fi

  # Display deliverable
  echo -n "  $TOTAL. $DESCRIPTION ... "

  # Execute verification command
  # Note: Commands may contain variables like {{TASK_ID}}, replace them
  VERIFICATION_CMD_EXPANDED=$(echo "$VERIFICATION_CMD" | sed "s/{{TASK_ID}}/$TASK_ID/g")

  # Run verification
  if eval "$VERIFICATION_CMD_EXPANDED" > /dev/null 2>&1; then
    STATUS="PASSED"
    EVIDENCE="Verification succeeded: $VERIFICATION_CMD_EXPANDED"
    PASSED=$((PASSED + 1))
    echo -e "${GREEN}✅ PASSED${NC}"
  else
    STATUS="FAILED"
    EVIDENCE="Verification failed: $VERIFICATION_CMD_EXPANDED"
    FAILED=$((FAILED + 1))
    echo -e "${RED}❌ FAILED${NC}"

    # Track missing required deliverables
    if [ "$REQUIRED_FLAG" == "true" ]; then
      MISSING_IDS+=("$DELIVERABLE_ID")
    fi
  fi

  # Add to checklist JSON
  CHECKLIST_ITEM=$(cat <<EOF_ITEM
{
  "deliverable_id": "$DELIVERABLE_ID",
  "description": "$DESCRIPTION",
  "required": $REQUIRED_FLAG,
  "verification_command": "$VERIFICATION_CMD_EXPANDED",
  "status": "$STATUS",
  "evidence": "$EVIDENCE"
}
EOF_ITEM
)

  # Append to checklist array
  jq --argjson item "$CHECKLIST_ITEM" '.checklist += [$item]' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" && mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

done <<< "$DELIVERABLES"

echo ""

#######################################
# Calculate Verdict
#######################################

# Calculate pass rate
if [ $REQUIRED -gt 0 ]; then
  REQUIRED_PASSED=$((REQUIRED - ${#MISSING_IDS[@]}))
  PASS_RATE=$(echo "scale=4; $REQUIRED_PASSED / $REQUIRED" | bc)
else
  PASS_RATE=1.0
fi

# Determine verdict
if [ ${#MISSING_IDS[@]} -eq 0 ]; then
  # All required deliverables passed
  VERDICT="APPROVED"
  BLOCKING_REASON=""
else
  # Some required deliverables failed
  VERDICT="BLOCKED"
  MISSING_LIST=$(IFS=,; echo "${MISSING_IDS[*]}")
  BLOCKING_REASON="Missing required deliverables: $MISSING_LIST"
fi

# Update summary in JSON
jq --arg total "$TOTAL" \
   --arg required "$REQUIRED" \
   --arg passed "$PASSED" \
   --arg failed "$FAILED" \
   --arg pass_rate "$PASS_RATE" \
   --arg verdict "$VERDICT" \
   --argjson missing "$(printf '%s\n' "${MISSING_IDS[@]}" | jq -R . | jq -s .)" \
   --arg blocking_reason "$BLOCKING_REASON" \
   '.summary.total_deliverables = ($total | tonumber) |
    .summary.required_deliverables = ($required | tonumber) |
    .summary.passed = ($passed | tonumber) |
    .summary.failed = ($failed | tonumber) |
    .summary.pass_rate = ($pass_rate | tonumber) |
    .verdict = $verdict |
    .missing_deliverables = $missing |
    .blocking_reason = $blocking_reason' \
   "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" && mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

#######################################
# Report Results
#######################################

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}Checklist Summary${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""
echo "Total Deliverables: $TOTAL"
echo "Required Deliverables: $REQUIRED"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"

if [ $REQUIRED -gt 0 ]; then
  PASS_PERCENTAGE=$(echo "scale=1; $PASS_RATE * 100" | bc)
  echo "Pass Rate (Required): ${PASS_PERCENTAGE}%"
fi

echo ""

if [ "$VERDICT" == "APPROVED" ]; then
  echo -e "${GREEN}=========================================${NC}"
  echo -e "${GREEN}✅ Verdict: APPROVED${NC}"
  echo -e "${GREEN}=========================================${NC}"
  echo ""
  echo "All required deliverables met."
  echo "Work is ready for delivery to user."
  echo ""
  echo "Checklist saved: $OUTPUT_FILE"
  exit 0
else
  echo -e "${RED}=========================================${NC}"
  echo -e "${RED}❌ Verdict: BLOCKED${NC}"
  echo -e "${RED}=========================================${NC}"
  echo ""
  echo "Missing required deliverables:"
  for missing_id in "${MISSING_IDS[@]}"; do
    # Get deliverable description
    MISSING_DESC=$(jq -r ".deliverables[] | select(.id == \"$missing_id\") | .description" "$CRITERIA_FILE")
    echo "  ❌ $missing_id - $MISSING_DESC"
  done
  echo ""
  echo "Required action:"
  echo "  1. Complete missing deliverables"
  echo "  2. Re-run verification"
  echo "  3. Re-run quality validation"
  echo ""
  echo "Checklist saved: $OUTPUT_FILE"
  exit 1
fi

#######################################
# Checklist Generation Complete
#
# This script provides binary pass/fail validation based on completion criteria.
# quality-validator uses this to make deterministic approval decisions.
#
# Exit codes:
#   0 = APPROVED (all required deliverables met)
#   1 = BLOCKED (missing required deliverables)
#######################################
