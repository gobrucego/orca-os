#!/bin/bash

# Fix duplicate file entries in Xcode project
# This removes duplicate CalculatorView.swift references

set -e

cd "$(dirname "$0")"

PROJECT_FILE="PeptideFox.xcodeproj/project.pbxproj"
BACKUP_FILE="PeptideFox.xcodeproj/project.pbxproj.backup-$(date +%s)"

echo "🔧 Fixing duplicate files in Xcode project..."

# Backup first
echo "📦 Creating backup: $BACKUP_FILE"
cp "$PROJECT_FILE" "$BACKUP_FILE"

# Remove the FIRST occurrence of duplicate CalculatorView entries
# Keep the second one (which is in the correct location)

# Remove first PBXBuildFile reference (line 16)
sed -i '' '/36E24FD7469544FE8840A1DA.*CalculatorView\.swift in Sources/d' "$PROJECT_FILE"

# Remove first PBXFileReference (line 49)
sed -i '' '/2AB0D8109B7B4EFD93E20F9A.*CalculatorView\.swift/d' "$PROJECT_FILE"

# Remove first group reference (line 227)
# This is trickier - need to remove the line with the UUID only
sed -i '' '/2AB0D8109B7B4EFD93E20F9A.*CalculatorView\.swift.*,$/d' "$PROJECT_FILE"

# Remove first Sources reference (line 404)
sed -i '' '/36E24FD7469544FE8840A1DA.*CalculatorView\.swift in Sources.*,$/d' "$PROJECT_FILE"

echo "✅ Duplicate entries removed!"
echo ""
echo "Removed references:"
echo "  - 36E24FD7469544FE8840A1DA (duplicate PBXBuildFile)"
echo "  - 2AB0D8109B7B4EFD93E20F9A (duplicate PBXFileReference)"
echo ""
echo "Kept references:"
echo "  - CD57CC91B0344C02AAD8C38C (PBXBuildFile)"
echo "  - A79435B8C3C14527927EBB8F (PBXFileReference)"
echo ""
echo "🔍 Verifying fix..."
CALC_COUNT=$(grep -c "CalculatorView.swift" "$PROJECT_FILE" || true)
echo "CalculatorView.swift appears $CALC_COUNT times (should be 4: 2 references + 2 uses)"

if [ "$CALC_COUNT" -eq 4 ]; then
    echo "✅ Fix successful! Each file now appears exactly once."
else
    echo "⚠️  Count is $CALC_COUNT (expected 4). Manual verification recommended."
fi

echo ""
echo "Next steps:"
echo "1. Open Xcode: open PeptideFox.xcodeproj"
echo "2. Clean Build Folder: Product → Clean Build Folder (⇧⌘K)"
echo "3. Build: Product → Build (⌘B)"
echo ""
echo "If build still fails, restore backup:"
echo "  cp $BACKUP_FILE $PROJECT_FILE"
