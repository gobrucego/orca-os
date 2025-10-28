#!/bin/bash
# verify-proofpack.sh
# Verifies cryptographic integrity of a proofpack by recomputing and comparing SHA-256 hash

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check arguments
if [ $# -ne 1 ]; then
  echo "Usage: $0 <proofpack-file.json>"
  echo ""
  echo "Example:"
  echo "  $0 .orchestration/proofpacks/login-screen-20251024T210000Z.json"
  exit 1
fi

PROOFPACK_FILE="$1"

# Check file exists
if [ ! -f "$PROOFPACK_FILE" ]; then
  echo -e "${RED}❌ Error: File not found: $PROOFPACK_FILE${NC}"
  exit 1
fi

# Check jq is installed
if ! command -v jq &> /dev/null; then
  echo -e "${RED}❌ Error: jq is not installed${NC}"
  echo "Install with: brew install jq"
  exit 1
fi

echo "Verifying proofpack: $PROOFPACK_FILE"
echo ""

# Extract claimed hash
CLAIMED_HASH=$(jq -r '.hash' "$PROOFPACK_FILE")

if [ -z "$CLAIMED_HASH" ] || [ "$CLAIMED_HASH" == "null" ]; then
  echo -e "${RED}❌ Error: No hash field found in proofpack${NC}"
  exit 1
fi

echo "Claimed hash: $CLAIMED_HASH"

# Create temporary file with hashable content (excluding hash and signature)
TEMP_FILE=$(mktemp)
trap "rm -f $TEMP_FILE" EXIT

# Extract all fields except hash and signature, with sorted keys for canonical JSON
jq -S 'del(.hash, .signature)' "$PROOFPACK_FILE" > "$TEMP_FILE"

# Compute SHA-256 hash
COMPUTED_HASH_RAW=$(shasum -a 256 "$TEMP_FILE" | awk '{print $1}')
COMPUTED_HASH="sha256:$COMPUTED_HASH_RAW"

echo "Computed hash: $COMPUTED_HASH"
echo ""

# Compare hashes
if [ "$CLAIMED_HASH" == "$COMPUTED_HASH" ]; then
  echo -e "${GREEN}✅ Proofpack integrity VERIFIED${NC}"
  echo ""

  # Extract and display summary info
  TASK_ID=$(jq -r '.task_id' "$PROOFPACK_FILE")
  TASK_TYPE=$(jq -r '.task_type' "$PROOFPACK_FILE")
  VERDICT=$(jq -r '.verification_verdict' "$PROOFPACK_FILE")
  TIMESTAMP=$(jq -r '.timestamp' "$PROOFPACK_FILE")
  AGENT=$(jq -r '.agent' "$PROOFPACK_FILE")

  echo "Summary:"
  echo "  Task ID: $TASK_ID"
  echo "  Task Type: $TASK_TYPE"
  echo "  Agent: $AGENT"
  echo "  Timestamp: $TIMESTAMP"
  echo "  Verification Verdict: $VERDICT"
  echo ""

  # Display deliverables met
  echo "Deliverables Met:"
  jq -r '.deliverables_met | to_entries[] | "  - \(.key): \(if .value then "✅" else "❌" end)"' "$PROOFPACK_FILE"
  echo ""

  if [ "$VERDICT" == "PASSED" ]; then
    echo -e "${GREEN}Verdict: PASSED - All verifications successful${NC}"
    exit 0
  elif [ "$VERDICT" == "BLOCKED" ]; then
    echo -e "${RED}Verdict: BLOCKED - Some verifications failed${NC}"
    exit 1
  elif [ "$VERDICT" == "CONDITIONAL" ]; then
    echo -e "${YELLOW}Verdict: CONDITIONAL - Manual testing required${NC}"
    exit 0
  else
    echo -e "${YELLOW}Verdict: $VERDICT (unknown)${NC}"
    exit 0
  fi
else
  echo -e "${RED}❌ Proofpack TAMPERED - Hash mismatch!${NC}"
  echo ""
  echo "This proofpack has been modified after creation."
  echo "The cryptographic hash does not match the content."
  echo ""
  echo "Claimed:  $CLAIMED_HASH"
  echo "Computed: $COMPUTED_HASH"
  echo ""
  echo -e "${RED}DO NOT TRUST THIS PROOFPACK${NC}"
  exit 1
fi
