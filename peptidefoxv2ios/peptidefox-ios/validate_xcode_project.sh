#!/bin/bash
# Validate Xcode project can build

cd "$(dirname "$0")"

echo "🔍 Validating Xcode project structure..."

# Check project file exists
if [ ! -f "PeptideFox.xcodeproj/project.pbxproj" ]; then
    echo "❌ Project file not found"
    exit 1
fi
echo "✅ Project file found"

# Check workspace
if [ ! -d "PeptideFox.xcodeproj/project.xcworkspace" ]; then
    echo "❌ Workspace directory not found"
    exit 1
fi
echo "✅ Workspace directory found"

# Check app icon
if [ ! -f "PeptideFox/Assets.xcassets/AppIcon.appiconset/AppIcon.png" ]; then
    echo "❌ App icon not found"
    exit 1
fi
echo "✅ App icon found"

# Check fonts
FONT_COUNT=$(ls -1 PeptideFox/Resources/Fonts/*.otf 2>/dev/null | wc -l)
if [ "$FONT_COUNT" -lt 7 ]; then
    echo "❌ Expected at least 7 fonts, found $FONT_COUNT"
    exit 1
fi
echo "✅ Found $FONT_COUNT custom fonts"

# Check Info.plist
if [ ! -f "PeptideFox/Info.plist" ]; then
    echo "❌ Info.plist not found"
    exit 1
fi
echo "✅ Info.plist found"

# Check PeptideFoxApp.swift
if [ ! -f "PeptideFox/PeptideFoxApp.swift" ]; then
    echo "❌ PeptideFoxApp.swift not found"
    exit 1
fi
echo "✅ App entry point found"

# Count Swift files
SWIFT_COUNT=$(find PeptideFox -name "*.swift" -type f | wc -l)
echo "✅ Found $SWIFT_COUNT Swift source files"

# Try to list schemes
echo ""
echo "📋 Available schemes:"
xcodebuild -list -project PeptideFox.xcodeproj 2>/dev/null || echo "⚠️  Could not list schemes (may be normal)"

# Try to build for simulator
echo ""
echo "🔨 Building project for iOS Simulator..."
echo "   (This may take a few minutes...)"

xcodebuild -project PeptideFox.xcodeproj \
           -scheme PeptideFox \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
           clean build \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           CODE_SIGNING_ALLOWED=NO \
           2>&1 | tee build.log

BUILD_RESULT=${PIPESTATUS[0]}

if [ $BUILD_RESULT -eq 0 ]; then
    echo ""
    echo "✅ PROJECT BUILDS SUCCESSFULLY!"
    echo ""
    echo "Summary:"
    echo "  - Xcode project: ✅ Valid"
    echo "  - Swift files: $SWIFT_COUNT"
    echo "  - Custom fonts: $FONT_COUNT"
    echo "  - App icon: ✅ Set"
    echo "  - Build status: ✅ Success"
    echo ""
    echo "Next steps:"
    echo "  1. Open PeptideFox.xcodeproj in Xcode"
    echo "  2. Set your development team in Signing & Capabilities"
    echo "  3. Run on simulator or device"
    exit 0
else
    echo ""
    echo "❌ BUILD FAILED"
    echo ""
    echo "Check build.log for details"
    echo "Common issues:"
    echo "  - Missing development team (set in Xcode project settings)"
    echo "  - Swift 6.0 compiler errors (check syntax)"
    echo "  - Missing dependencies"
    exit 1
fi
