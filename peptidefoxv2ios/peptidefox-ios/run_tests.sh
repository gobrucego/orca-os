#!/bin/bash

# PeptideFox Test Runner Script
# Runs unit tests, UI tests, and generates coverage reports

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_PATH="PeptideFoxProject/PeptideFox.xcodeproj"
SCHEME="PeptideFox"
SIMULATOR="iPhone 14 Pro"
DERIVED_DATA_PATH="build"

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    PeptideFox Test Runner v1.0        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Parse arguments
TEST_TYPE="${1:-all}"

function print_header() {
    echo ""
    echo -e "${YELLOW}▶ $1${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

function run_unit_tests() {
    print_header "Running Unit Tests"
    
    xcodebuild test \
        -project "$PROJECT_PATH" \
        -scheme "$SCHEME" \
        -destination "platform=iOS Simulator,name=$SIMULATOR" \
        -only-testing:PeptideFoxTests \
        -derivedDataPath "$DERIVED_DATA_PATH" \
        -enableCodeCoverage YES \
        | xcpretty --color
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo -e "${GREEN}✓ Unit tests passed${NC}"
    else
        echo -e "${RED}✗ Unit tests failed${NC}"
        exit 1
    fi
}

function run_ui_tests() {
    print_header "Running UI Tests"
    
    xcodebuild test \
        -project "$PROJECT_PATH" \
        -scheme "$SCHEME" \
        -destination "platform=iOS Simulator,name=$SIMULATOR" \
        -only-testing:PeptideFoxUITests \
        -derivedDataPath "$DERIVED_DATA_PATH" \
        | xcpretty --color
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo -e "${GREEN}✓ UI tests passed${NC}"
    else
        echo -e "${RED}✗ UI tests failed${NC}"
        exit 1
    fi
}

function run_all_tests() {
    print_header "Running All Tests"
    
    xcodebuild test \
        -project "$PROJECT_PATH" \
        -scheme "$SCHEME" \
        -destination "platform=iOS Simulator,name=$SIMULATOR" \
        -derivedDataPath "$DERIVED_DATA_PATH" \
        -enableCodeCoverage YES \
        | xcpretty --color
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo -e "${GREEN}✓ All tests passed${NC}"
    else
        echo -e "${RED}✗ Some tests failed${NC}"
        exit 1
    fi
}

function generate_coverage_report() {
    print_header "Generating Coverage Report"
    
    # Find the latest xcresult
    XCRESULT=$(find "$DERIVED_DATA_PATH" -name "*.xcresult" -type d | head -n 1)
    
    if [ -z "$XCRESULT" ]; then
        echo -e "${YELLOW}⚠ No test results found${NC}"
        return
    fi
    
    echo "Test results: $XCRESULT"
    
    # Generate coverage report
    xcrun xccov view --report "$XCRESULT" > coverage_report.txt
    
    echo -e "${GREEN}✓ Coverage report saved to coverage_report.txt${NC}"
    
    # Display coverage summary
    echo ""
    echo "Coverage Summary:"
    grep -A 5 "PeptideFox" coverage_report.txt | head -n 10
}

function clean_build() {
    print_header "Cleaning Build Directory"
    rm -rf "$DERIVED_DATA_PATH"
    echo -e "${GREEN}✓ Build directory cleaned${NC}"
}

# Main execution
case "$TEST_TYPE" in
    unit)
        run_unit_tests
        generate_coverage_report
        ;;
    ui)
        run_ui_tests
        ;;
    all)
        run_all_tests
        generate_coverage_report
        ;;
    coverage)
        run_all_tests
        generate_coverage_report
        ;;
    clean)
        clean_build
        ;;
    *)
        echo "Usage: $0 {unit|ui|all|coverage|clean}"
        echo ""
        echo "  unit     - Run unit tests only"
        echo "  ui       - Run UI tests only"
        echo "  all      - Run all tests (default)"
        echo "  coverage - Run all tests and generate coverage report"
        echo "  clean    - Clean build directory"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         Test Run Complete ✓            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
