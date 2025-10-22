#!/bin/bash

# PeptideFox iOS - Automated Xcode Project Creator
# This script creates a proper Xcode project from the source files

set -e

echo "🦊 PeptideFox iOS Setup"
echo "======================="
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed or not in PATH"
    exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "📂 Working directory: $SCRIPT_DIR"
echo ""

# Check if project already exists
if [ -d "PeptideFoxProject/PeptideFox.xcodeproj" ]; then
    echo "⚠️  Xcode project already exists at PeptideFoxProject/"
    read -p "Delete and recreate? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf PeptideFoxProject
        echo "✅ Removed existing project"
    else
        echo "❌ Cancelled"
        exit 0
    fi
fi

echo "📦 Creating Xcode project structure..."

# Create project directory
mkdir -p PeptideFoxProject/PeptideFox

# Copy source files
echo "📄 Copying source files..."
cp -r PeptideFox/Models PeptideFoxProject/PeptideFox/
cp -r PeptideFox/Views PeptideFoxProject/PeptideFox/
cp PeptideFox/PeptideFoxApp.swift PeptideFoxProject/PeptideFox/
cp PeptideFox/Info.plist PeptideFoxProject/PeptideFox/

# Create Assets catalog
mkdir -p PeptideFoxProject/PeptideFox/Assets.xcassets/AppIcon.appiconset
cat > PeptideFoxProject/PeptideFox/Assets.xcassets/AppIcon.appiconset/Contents.json << 'EOF'
{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

cat > PeptideFoxProject/PeptideFox/Assets.xcassets/Contents.json << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "🔧 Generating Xcode project..."
cd PeptideFoxProject

# Use xcodegen or manual creation
cat > project.yml << 'EOF'
name: PeptideFox
options:
  bundleIdPrefix: com.peptidefox
targets:
  PeptideFox:
    type: application
    platform: iOS
    deploymentTarget: "16.0"
    sources: [PeptideFox]
    settings:
      INFOPLIST_FILE: PeptideFox/Info.plist
      PRODUCT_BUNDLE_IDENTIFIER: com.peptidefox.app
      SWIFT_VERSION: "5.0"
      DEVELOPMENT_TEAM: ""
EOF

# Check if xcodegen is available
if command -v xcodegen &> /dev/null; then
    echo "✅ Using xcodegen to create project..."
    xcodegen
    echo ""
    echo "✅ Project created successfully!"
    echo ""
    echo "🚀 To open the project:"
    echo "   open PeptideFox.xcodeproj"
    echo ""
else
    echo ""
    echo "⚠️  xcodegen not found. Please install it with:"
    echo "   brew install xcodegen"
    echo ""
    echo "Or follow the manual setup in SETUP.md"
fi

cd "$SCRIPT_DIR"
