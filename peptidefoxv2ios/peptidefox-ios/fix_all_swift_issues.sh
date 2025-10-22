#!/bin/bash

# Comprehensive Swift Build Issue Fixer
# Finds and reports all common Swift compilation issues

set -e

cd "$(dirname "$0")"

echo "🔍 Scanning PeptideFox for Swift compilation issues..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ISSUES_FOUND=0

# Function to report issue
report_issue() {
    local file=$1
    local line=$2
    local issue=$3
    echo -e "${RED}❌ $file:$line${NC}"
    echo -e "   $issue"
    echo ""
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
}

# 1. Check for unused variables with 'let x =' pattern
echo "📌 Checking for unused 'let' variables..."
while IFS= read -r match; do
    file=$(echo "$match" | cut -d: -f1)
    line=$(echo "$match" | cut -d: -f2)
    code=$(echo "$match" | cut -d: -f3-)

    # Extract variable name
    varname=$(echo "$code" | sed -E 's/.*let ([a-zA-Z_][a-zA-Z0-9_]*).*/\1/')

    # Check if variable is used later in the file
    if ! grep -q "[^a-zA-Z_]$varname[^a-zA-Z0-9_]" "$file" 2>/dev/null; then
        report_issue "$file" "$line" "Unused variable: $varname"
    fi
done < <(grep -rn "^\s*let [a-zA-Z_][a-zA-Z0-9_]* =" PeptideFox --include="*.swift" 2>/dev/null || true)

# 2. Check for @State vars that might be unused
echo "📌 Checking for unused @State variables..."
grep -rn "@State.*var" PeptideFox --include="*.swift" 2>/dev/null | while IFS= read -r match; do
    file=$(echo "$match" | cut -d: -f1)
    line=$(echo "$match" | cut -d: -f2)
    echo -e "${YELLOW}⚠️  $file:$line${NC} - @State variable (manual check needed)"
done

# 3. Check for missing Sendable conformance
echo "📌 Checking for potential concurrency issues..."
grep -rn "static let.*\[" PeptideFox --include="*.swift" | grep -v "nonisolated" | while IFS= read -r match; do
    file=$(echo "$match" | cut -d: -f1)
    line=$(echo "$match" | cut -d: -f2)
    report_issue "$file" "$line" "Static array property may need 'nonisolated(unsafe)'"
done

# 4. Check for common SwiftUI issues
echo "📌 Checking for common SwiftUI issues..."

# Check for .padding with colon instead of comma
grep -rn "\.padding(.*:" PeptideFox --include="*.swift" | while IFS= read -r match; do
    file=$(echo "$match" | cut -d: -f1)
    line=$(echo "$match" | cut -d: -f2)
    if echo "$match" | grep -q "\.padding([^,]*:"; then
        report_issue "$file" "$line" "Incorrect padding syntax - use comma not colon"
    fi
done

# 5. Check for missing imports
echo "📌 Checking for common missing imports..."
for swiftfile in $(find PeptideFox -name "*.swift"); do
    # Check if file uses Color but doesn't import SwiftUI
    if grep -q "Color\." "$swiftfile" && ! grep -q "import SwiftUI" "$swiftfile" && ! grep -q "import Foundation" "$swiftfile"; then
        line=1
        report_issue "$swiftfile" "$line" "Uses Color but missing 'import SwiftUI'"
    fi

    # Check if file uses @Published but doesn't import Combine
    if grep -q "@Published" "$swiftfile" && ! grep -q "import Combine" "$swiftfile"; then
        line=1
        report_issue "$swiftfile" "$line" "Uses @Published but missing 'import Combine'"
    fi
done

# 6. Check for duplicate file entries in Xcode project
echo "📌 Checking Xcode project for duplicate file references..."
if [ -f "PeptideFox.xcodeproj/project.pbxproj" ]; then
    # Find duplicate UUIDs in PBXBuildFile section
    awk '/Begin PBXBuildFile/,/End PBXBuildFile/' PeptideFox.xcodeproj/project.pbxproj | \
    grep -o '[A-F0-9]\{24\}' | \
    sort | uniq -d | while read uuid; do
        filename=$(grep "$uuid" PeptideFox.xcodeproj/project.pbxproj | grep -o '/\* [^*]* \*/' | head -1 | sed 's#/\* ##' | sed 's# \*/##')
        echo -e "${YELLOW}⚠️  Xcode project${NC} - Duplicate file entry: $filename ($uuid)"
    done
fi

# 7. Check Assets.xcassets structure
echo "📌 Checking Assets.xcassets..."
if [ ! -d "PeptideFox/Resources/Assets.xcassets/AppIcon.appiconset" ]; then
    report_issue "PeptideFox/Resources/Assets.xcassets" "0" "Missing AppIcon.appiconset directory"
fi

if [ ! -f "PeptideFox/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json" ]; then
    report_issue "PeptideFox/Resources/Assets.xcassets/AppIcon.appiconset" "0" "Missing Contents.json"
fi

if [ ! -d "PeptideFox/Resources/Assets.xcassets/AccentColor.colorset" ]; then
    report_issue "PeptideFox/Resources/Assets.xcassets" "0" "Missing AccentColor.colorset directory"
fi

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ No critical issues found!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Open Xcode: open PeptideFox.xcodeproj"
    echo "2. Clean Build Folder: Product → Clean Build Folder (⇧⌘K)"
    echo "3. Build: Product → Build (⌘B)"
else
    echo -e "${RED}Found $ISSUES_FOUND potential issues${NC}"
    echo ""
    echo "Review the issues above and:"
    echo "1. Fix unused variables (replace 'let x =' with 'let _ =')"
    echo "2. Add nonisolated(unsafe) to static array properties"
    echo "3. Fix syntax errors"
    echo "4. Add missing imports"
    echo ""
    echo "Then rebuild in Xcode"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
