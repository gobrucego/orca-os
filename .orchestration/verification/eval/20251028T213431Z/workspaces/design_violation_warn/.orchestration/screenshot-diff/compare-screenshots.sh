#!/bin/bash
#
# Screenshot Diff - Visual Regression Detection
#
# Purpose: Compare BEFORE and AFTER screenshots to detect visual changes
# Usage: verification-agent runs this to catch "claimed but not done" UI work
#
# Stage 3 Week 5 - Mandatory Screenshot Diff
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
MIN_CHANGED_PIXELS=100  # Minimum pixels changed to consider "visual change"
DIFF_THRESHOLD=0.001    # 0.1% of pixels must change

#######################################
# Usage
#######################################

usage() {
  echo "Usage: $0 <before-screenshot> <after-screenshot> [options]"
  echo ""
  echo "Options:"
  echo "  --task-id ID          Task identifier for evidence naming"
  echo "  --threshold N         Minimum pixels changed (default: 100)"
  echo "  --output-dir DIR      Output directory (default: .orchestration/evidence)"
  echo "  --strict              Fail if no visual changes detected"
  echo ""
  echo "Example:"
  echo "  $0 before.png after.png --task-id login-screen --strict"
  exit 1
}

#######################################
# Parse Arguments
#######################################

if [ $# -lt 2 ]; then
  usage
fi

BEFORE_SCREENSHOT="$1"
AFTER_SCREENSHOT="$2"
shift 2

TASK_ID="screenshot-diff"
OUTPUT_DIR=".orchestration/evidence"
STRICT_MODE=false

while [ $# -gt 0 ]; do
  case "$1" in
    --task-id)
      TASK_ID="$2"
      shift 2
      ;;
    --threshold)
      MIN_CHANGED_PIXELS="$2"
      shift 2
      ;;
    --output-dir)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --strict)
      STRICT_MODE=true
      shift
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

# Check ImageMagick installed
if ! command -v compare &> /dev/null; then
  echo -e "${RED}❌ Error: ImageMagick 'compare' not installed${NC}"
  echo "Install with: brew install imagemagick"
  exit 1
fi

# Check files exist
if [ ! -f "$BEFORE_SCREENSHOT" ]; then
  echo -e "${RED}❌ Error: BEFORE screenshot not found: $BEFORE_SCREENSHOT${NC}"
  exit 1
fi

if [ ! -f "$AFTER_SCREENSHOT" ]; then
  echo -e "${RED}❌ Error: AFTER screenshot not found: $AFTER_SCREENSHOT${NC}"
  exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

#######################################
# Screenshot Comparison
#######################################

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}Screenshot Diff Analysis${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""
echo "Task ID: $TASK_ID"
echo "BEFORE: $BEFORE_SCREENSHOT"
echo "AFTER:  $AFTER_SCREENSHOT"
echo "Threshold: $MIN_CHANGED_PIXELS pixels"
echo ""

# Output files
DIFF_IMAGE="${OUTPUT_DIR}/${TASK_ID}-diff.png"
DIFF_REPORT="${OUTPUT_DIR}/${TASK_ID}-diff-report.json"

# Run ImageMagick compare
echo "Running pixel comparison..."

# Compare images and generate diff visualization
# -metric AE counts absolute number of pixels that differ
# -fuzz 5% allows for minor compression artifacts
compare -metric AE -fuzz 5% \
  "$BEFORE_SCREENSHOT" \
  "$AFTER_SCREENSHOT" \
  "$DIFF_IMAGE" 2>&1 | tee /tmp/diff_count.txt || true

CHANGED_PIXELS=$(cat /tmp/diff_count.txt | tail -n1)

# Get image dimensions for percentage calculation
WIDTH=$(identify -format "%w" "$BEFORE_SCREENSHOT")
HEIGHT=$(identify -format "%h" "$BEFORE_SCREENSHOT")
TOTAL_PIXELS=$((WIDTH * HEIGHT))

# Calculate percentage
PERCENT_CHANGED=$(echo "scale=4; ($CHANGED_PIXELS / $TOTAL_PIXELS) * 100" | bc)

echo ""
echo -e "${CYAN}Results:${NC}"
echo "  Image dimensions: ${WIDTH}x${HEIGHT} (${TOTAL_PIXELS} pixels)"
echo "  Changed pixels: ${CHANGED_PIXELS}"
echo "  Percentage changed: ${PERCENT_CHANGED}%"
echo ""

#######################################
# Analysis
#######################################

# Determine verdict
VERDICT="UNKNOWN"
SEVERITY="INFO"

if [ "$CHANGED_PIXELS" -lt "$MIN_CHANGED_PIXELS" ]; then
  # Very few pixels changed
  if [ "$STRICT_MODE" = true ]; then
    VERDICT="BLOCKED"
    SEVERITY="ERROR"
    echo -e "${RED}❌ BLOCKED: No significant visual changes detected${NC}"
    echo ""
    echo "Specialist claimed UI changes but screenshots are nearly identical."
    echo "This suggests the implementation may not have actually changed the UI."
    echo ""
    echo "Possible causes:"
    echo "  1. Wrong screenshot captured (screenshot of wrong screen)"
    echo "  2. Implementation incomplete (changes not visible)"
    echo "  3. BEFORE and AFTER screenshots are the same file"
    echo ""
    echo "Required: Review implementation and recapture screenshots"
  else
    VERDICT="WARNING"
    SEVERITY="WARNING"
    echo -e "${YELLOW}⚠️  WARNING: Minimal visual changes detected${NC}"
    echo ""
    echo "Only ${CHANGED_PIXELS} pixels changed (< ${MIN_CHANGED_PIXELS} threshold)."
    echo "This may indicate:"
    echo "  - Minor UI tweaks (acceptable)"
    echo "  - Wrong screenshots (investigate)"
    echo "  - Incomplete implementation (investigate)"
  fi
else
  # Significant changes detected
  VERDICT="PASSED"
  SEVERITY="SUCCESS"
  echo -e "${GREEN}✅ PASSED: Visual changes detected${NC}"
  echo ""
  echo "${CHANGED_PIXELS} pixels changed (${PERCENT_CHANGED}% of image)."
  echo "This confirms UI implementation produced visible changes."
  echo ""
  echo "Diff visualization saved: $DIFF_IMAGE"
  echo "(Red pixels = changed, black pixels = unchanged)"
fi

#######################################
# Generate Report
#######################################

cat > "$DIFF_REPORT" <<EOF
{
  "task_id": "$TASK_ID",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "before_screenshot": "$BEFORE_SCREENSHOT",
  "after_screenshot": "$AFTER_SCREENSHOT",
  "image_dimensions": {
    "width": $WIDTH,
    "height": $HEIGHT,
    "total_pixels": $TOTAL_PIXELS
  },
  "diff_analysis": {
    "changed_pixels": $CHANGED_PIXELS,
    "percent_changed": $PERCENT_CHANGED,
    "threshold_pixels": $MIN_CHANGED_PIXELS,
    "threshold_percent": $(echo "scale=4; ($MIN_CHANGED_PIXELS / $TOTAL_PIXELS) * 100" | bc)
  },
  "verdict": "$VERDICT",
  "severity": "$SEVERITY",
  "diff_visualization": "$DIFF_IMAGE",
  "strict_mode": $STRICT_MODE
}
EOF

echo ""
echo "Report saved: $DIFF_REPORT"

#######################################
# Exit
#######################################

echo ""
echo -e "${CYAN}=========================================${NC}"

case "$VERDICT" in
  PASSED)
    echo -e "${GREEN}Verdict: PASSED - Visual changes confirmed${NC}"
    exit 0
    ;;
  WARNING)
    echo -e "${YELLOW}Verdict: WARNING - Minimal changes detected${NC}"
    exit 0  # Don't fail, just warn
    ;;
  BLOCKED)
    echo -e "${RED}Verdict: BLOCKED - No visual changes${NC}"
    exit 1
    ;;
  *)
    echo "Verdict: UNKNOWN"
    exit 1
    ;;
esac
