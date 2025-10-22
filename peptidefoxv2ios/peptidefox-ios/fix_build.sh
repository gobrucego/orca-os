#!/bin/bash

# fix_build.sh - Automated build diagnostics and fixes for PeptideFox iOS
# Usage: ./fix_build.sh

set -e

PROJECT_DIR="/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios"
cd "$PROJECT_DIR"

echo "============================================"
echo "PeptideFox Build Diagnostic Tool"
echo "============================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check 1: Xcode installation
echo -e "${BLUE}[1/10] Checking Xcode installation...${NC}"
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -1)
    echo -e "${GREEN}✓ Xcode found: $XCODE_VERSION${NC}"
else
    echo -e "${RED}✗ Xcode not found or not in PATH${NC}"
    echo "  Install Xcode from App Store"
    exit 1
fi
echo ""

# Check 2: Swift version
echo -e "${BLUE}[2/10] Checking Swift version...${NC}"
SWIFT_VERSION=$(xcrun swift --version | head -1)
echo -e "${GREEN}✓ $SWIFT_VERSION${NC}"
echo ""

# Check 3: Project file exists
echo -e "${BLUE}[3/10] Checking project file...${NC}"
if [ -d "PeptideFox.xcodeproj" ]; then
    echo -e "${GREEN}✓ PeptideFox.xcodeproj found${NC}"
else
    echo -e "${RED}✗ PeptideFox.xcodeproj not found${NC}"
    echo "  Run create-xcode-project.sh first"
    exit 1
fi
echo ""

# Check 4: Deployment target
echo -e "${BLUE}[4/10] Checking deployment target...${NC}"
DEPLOYMENT_TARGET=$(grep -m 1 "IPHONEOS_DEPLOYMENT_TARGET" PeptideFox.xcodeproj/project.pbxproj | sed 's/.*= \(.*\);/\1/')
if [ "$DEPLOYMENT_TARGET" = "17.0" ]; then
    echo -e "${GREEN}✓ Deployment target: $DEPLOYMENT_TARGET${NC}"
else
    echo -e "${YELLOW}⚠ Deployment target: $DEPLOYMENT_TARGET (should be 17.0)${NC}"
fi
echo ""

# Check 5: Required Swift files exist
echo -e "${BLUE}[5/10] Checking required files...${NC}"
REQUIRED_FILES=(
    "PeptideFox/PeptideFoxApp.swift"
    "PeptideFox/Core/Presentation/ContentView.swift"
    "PeptideFox/Core/Design/DesignTokens.swift"
    "PeptideFox/Core/Design/ComponentStyles.swift"
    "PeptideFox/Core/Data/Models/PeptideModels.swift"
)

MISSING_COUNT=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}  ✓ $file${NC}"
    else
        echo -e "${RED}  ✗ $file (missing)${NC}"
        ((MISSING_COUNT++))
    fi
done

if [ $MISSING_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ All required files present${NC}"
else
    echo -e "${RED}✗ $MISSING_COUNT required files missing${NC}"
fi
echo ""

# Check 6: Syntax check on key files
echo -e "${BLUE}[6/10] Checking file syntax...${NC}"
SYNTAX_ERRORS=0

for file in PeptideFox/Core/Design/*.swift; do
    if [ -f "$file" ]; then
        if xcrun swiftc -typecheck "$file" 2>/dev/null; then
            echo -e "${GREEN}  ✓ $(basename $file)${NC}"
        else
            echo -e "${RED}  ✗ $(basename $file) (syntax errors)${NC}"
            ((SYNTAX_ERRORS++))
        fi
    fi
done

if [ $SYNTAX_ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ No syntax errors in design files${NC}"
else
    echo -e "${YELLOW}⚠ $SYNTAX_ERRORS files have syntax errors${NC}"
fi
echo ""

# Check 7: SwiftData import check
echo -e "${BLUE}[7/10] Checking for SwiftData imports...${NC}"
if grep -r "import SwiftData" PeptideFox/ 2>/dev/null | grep -v "//"; then
    echo -e "${YELLOW}⚠ SwiftData imports found${NC}"
    echo "  SwiftData should be removed for MVP (see BUILD_FIX.md)"
else
    echo -e "${GREEN}✓ No SwiftData imports (correct for MVP)${NC}"
fi
echo ""

# Check 8: Common syntax issues
echo -e "${BLUE}[8/10] Checking for common syntax issues...${NC}"
SYNTAX_ISSUES=0

# Check for wrong padding syntax
if grep -r "\.padding(\.vertical:" PeptideFox/ 2>/dev/null | grep -v "//"; then
    echo -e "${YELLOW}  ⚠ Found .padding(.vertical: ...) - should use comma${NC}"
    ((SYNTAX_ISSUES++))
fi

# Check for wrong padding syntax
if grep -r "\.padding(\.horizontal:" PeptideFox/ 2>/dev/null | grep -v "//"; then
    echo -e "${YELLOW}  ⚠ Found .padding(.horizontal: ...) - should use comma${NC}"
    ((SYNTAX_ISSUES++))
fi

if [ $SYNTAX_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ No common syntax issues found${NC}"
fi
echo ""

# Check 9: Find duplicate files
echo -e "${BLUE}[9/10] Checking for duplicate files...${NC}"
DUPLICATES=$(find PeptideFox -name "*.swift" -exec basename {} \; | sort | uniq -d)
if [ -z "$DUPLICATES" ]; then
    echo -e "${GREEN}✓ No duplicate file names${NC}"
else
    echo -e "${YELLOW}⚠ Duplicate file names found:${NC}"
    echo "$DUPLICATES"
fi
echo ""

# Check 10: Build test
echo -e "${BLUE}[10/10] Attempting build...${NC}"
echo "This may take a moment..."
echo ""

# Try to build (will fail if Xcode not installed, but that's ok)
if xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox -showBuildSettings &>/dev/null; then
    BUILD_OUTPUT=$(xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox build 2>&1)
    BUILD_EXIT_CODE=$?
    
    if [ $BUILD_EXIT_CODE -eq 0 ]; then
        echo -e "${GREEN}✓✓✓ BUILD SUCCESSFUL! ✓✓✓${NC}"
        echo ""
        echo "The app is ready to run!"
        exit 0
    else
        # Extract errors
        ERROR_COUNT=$(echo "$BUILD_OUTPUT" | grep -c "error:" || true)
        WARNING_COUNT=$(echo "$BUILD_OUTPUT" | grep -c "warning:" || true)
        
        echo -e "${RED}✗ Build failed with $ERROR_COUNT errors and $WARNING_COUNT warnings${NC}"
        echo ""
        echo "First 5 errors:"
        echo "$BUILD_OUTPUT" | grep "error:" | head -5
        echo ""
        echo "See BUILD_FIX.md for solutions"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠ Cannot run xcodebuild (Xcode Command Line Tools required)${NC}"
    echo "  Please open project in Xcode and build there"
fi
echo ""

# Summary
echo "============================================"
echo "Diagnostic Summary"
echo "============================================"
echo ""
echo "Next steps:"
echo "1. Open PeptideFox.xcodeproj in Xcode"
echo "2. Review any errors in Issue Navigator (⌘5)"
echo "3. Consult BUILD_FIX.md for solutions"
echo "4. Consult COMMON_BUILD_ERRORS.md for examples"
echo ""
echo "Quick fixes:"
echo "- SwiftData removed: See PeptideFoxApp.swift"
echo "- Syntax errors: Check COMMON_BUILD_ERRORS.md"
echo "- Missing types: Check PeptideModels.swift"
echo ""
