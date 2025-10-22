#!/bin/bash

# AK Protocol iOS - Xcode Project Generator
# This script uses xcodegen to create an Xcode project from the source files

set -e

echo "🚀 AK Protocol iOS - Xcode Project Generator"
echo "=============================================="
echo ""

# Check if xcodegen is installed
if ! command -v xcodegen &> /dev/null; then
    echo "❌ Error: xcodegen is not installed"
    echo ""
    echo "Install it with Homebrew:"
    echo "  brew install xcodegen"
    echo ""
    echo "Or visit: https://github.com/yonaskolb/XcodeGen"
    exit 1
fi

echo "✅ xcodegen found"
echo ""

# Create project.yml for xcodegen
echo "📝 Creating project configuration..."

cat > project.yml << 'EOF'
name: AKProtocol

options:
  bundleIdPrefix: com.peptidefox
  deploymentTarget:
    iOS: "16.0"

targets:
  AKProtocol:
    type: application
    platform: iOS
    sources:
      - AKProtocol
    info:
      path: AKProtocol/Info.plist
      properties:
        CFBundleDisplayName: AK Protocol
        CFBundleShortVersionString: "1.0"
        CFBundleVersion: "1"
        UILaunchScreen: {}
        UIApplicationSceneManifest:
          UIApplicationSupportsMultipleScenes: true
        UISupportedInterfaceOrientations:
          - UIInterfaceOrientationPortrait
          - UIInterfaceOrientationLandscapeLeft
          - UIInterfaceOrientationLandscapeRight
        UISupportedInterfaceOrientations~ipad:
          - UIInterfaceOrientationPortrait
          - UIInterfaceOrientationPortraitUpsideDown
          - UIInterfaceOrientationLandscapeLeft
          - UIInterfaceOrientationLandscapeRight
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.peptidefox.AKProtocol
      SWIFT_VERSION: "5.0"
      TARGETED_DEVICE_FAMILY: "1,2"
      INFOPLIST_FILE: AKProtocol/Info.plist
      ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
      ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME: AccentColor
EOF

echo "✅ Configuration created"
echo ""

# Generate Xcode project
echo "🔨 Generating Xcode project..."
xcodegen generate

echo ""
echo "✅ Project generated successfully!"
echo ""
echo "📂 Output: AKProtocol.xcodeproj"
echo ""
echo "To open the project:"
echo "  open AKProtocol.xcodeproj"
echo ""
echo "Or in Xcode:"
echo "  1. File → Open"
echo "  2. Select AKProtocol.xcodeproj"
echo ""
echo "🎉 Done! Happy coding!"
