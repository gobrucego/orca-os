#!/bin/bash

# PeptideFox iOS - Reliable Simulator Rebuild Script
# Usage: ./scripts/rebuild-sim.sh [clean]
#
# Pass "clean" argument to do a full clean rebuild
# Otherwise does incremental build

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_ROOT="/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios"
PROJECT_FILE="$PROJECT_ROOT/PeptideFox.xcodeproj"
SCHEME="PeptideFox"
BUNDLE_ID="com.peptidefox.app"
SIMULATOR_NAME="iPhone 17 Pro"
SIMULATOR_ID="F223B876-5B50-4ABE-B792-32F179019217"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  PeptideFox iOS Simulator Rebuild${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Check if simulator is booted
SIM_STATE=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -o "Booted" || echo "Shutdown")
if [ "$SIM_STATE" != "Booted" ]; then
    echo -e "${YELLOW}⚠️  Simulator not booted. Booting now...${NC}"
    xcrun simctl boot "$SIMULATOR_ID"
    sleep 3
else
    echo -e "${GREEN}✓ Simulator already booted${NC}"
fi

# Clean build if requested
if [ "$1" == "clean" ]; then
    echo -e "${YELLOW}🧹 Cleaning DerivedData...${NC}"
    rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*

    echo -e "${YELLOW}🧹 Cleaning Xcode project...${NC}"
    xcodebuild clean -project "$PROJECT_FILE" -scheme "$SCHEME" -configuration Debug > /dev/null

    echo -e "${YELLOW}🗑️  Uninstalling app from simulator...${NC}"
    xcrun simctl uninstall "$SIMULATOR_ID" "$BUNDLE_ID" 2>/dev/null || true

    echo -e "${GREEN}✓ Clean complete${NC}"
    echo
fi

# Build
echo -e "${BLUE}🔨 Building $SCHEME...${NC}"
xcodebuild build \
    -project "$PROJECT_FILE" \
    -scheme "$SCHEME" \
    -configuration Debug \
    -sdk iphonesimulator \
    -destination "id=$SIMULATOR_ID" \
    ONLY_ACTIVE_ARCH=YES \
    | grep -E "^(Build|Compile|Link|\/\* com\.apple|warning:|error:)" || true

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Build succeeded${NC}"
echo

# Find the built app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Build/Products/Debug-iphonesimulator -name "PeptideFox.app" -type d | head -1)

if [ -z "$APP_PATH" ]; then
    echo -e "${RED}❌ Could not find built app${NC}"
    exit 1
fi

echo -e "${BLUE}📦 App built at:${NC}"
echo "  $APP_PATH"
echo

# Check timestamps
SOURCE_FILE="$PROJECT_ROOT/PeptideFox/Core/Presentation/Calculator/CompoundPickerView.swift"
SOURCE_TIME=$(stat -f "%m" "$SOURCE_FILE")
BINARY_TIME=$(stat -f "%m" "$APP_PATH/PeptideFox")

if [ $BINARY_TIME -lt $SOURCE_TIME ]; then
    echo -e "${RED}⚠️  WARNING: Binary is older than source file!${NC}"
    echo -e "${YELLOW}   This might indicate a stale build. Consider running with 'clean' flag.${NC}"
    echo
else
    echo -e "${GREEN}✓ Binary is up to date${NC}"
fi

# Install
echo -e "${BLUE}📲 Installing app on simulator...${NC}"
xcrun simctl install "$SIMULATOR_ID" "$APP_PATH"
echo -e "${GREEN}✓ Installation complete${NC}"
echo

# Launch
echo -e "${BLUE}🚀 Launching app...${NC}"
xcrun simctl launch "$SIMULATOR_ID" "$BUNDLE_ID" > /dev/null
echo -e "${GREEN}✓ App launched${NC}"
echo

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Ready to test!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo "Next steps:"
echo "  1. Open Simulator app"
echo "  2. Navigate to Calculator tab"
echo "  3. Tap 'Select Compound' button"
echo "  4. Verify changes are visible"
echo
echo "To view logs:"
echo "  xcrun simctl launch --console $SIMULATOR_ID $BUNDLE_ID"
echo
echo "To take screenshot:"
echo "  xcrun simctl io $SIMULATOR_ID screenshot ~/Desktop/peptidefox-screenshot.png"
echo
