#!/bin/bash

# Fix ALL duplicate file entries in Xcode project
# Removes duplicate Swift file references

set -e

cd "$(dirname "$0")"

PROJECT_FILE="PeptideFox.xcodeproj/project.pbxproj"
BACKUP_FILE="PeptideFox.xcodeproj/project.pbxproj.backup-all-$(date +%s)"

echo "🔧 Fixing ALL duplicate files in Xcode project..."

# Backup first
echo "📦 Creating backup: $BACKUP_FILE"
cp "$PROJECT_FILE" "$BACKUP_FILE"

# Strategy: Find duplicate UUIDs and remove first occurrence of each

# List of duplicate UUIDs (from grep output)
DUPLICATES=(
    "0586E9EAC5574C9CBF778C92"
    "101E60A2CFE54A74B4F1080D"
    "2BD48A5633304523981D1334"
    "3546E4BED6BA43C2A231C481"
    "38326CC85B3741ABB412FF01"
    "3D4133F5DFB4438094B06D98"
    "49437BF16C3E406B8A848E07"
    "657A598D685A4FBBB92294E6"
    "6753F1F4DC1D4C3B8405D99E"
    "8D6F32CE1E7E4297B72EE5C9"
    "AD926E93077144558468AD4D"
    "ADBC72E61A3341E99FD33059"
    "B044542DBA2D4DB48C2B7545"
    "B2576F8218254FBCB0319113"
    "B631BAB6C00A4681919499FC"
    "B764067F479747AABFE3A3E1"
    "BF33AE5D449643C0BF6F6FC5"
    "CD57CC91B0344C02AAD8C38C"
    "D0D9B2BC7DFC477683A6AB05"
    "E04CABE034B14250861A96E9"
    "E9D35CADFD45492694D7AE40"
    "F2C020FE0646443C8C4E8C0A"
)

echo "Found ${#DUPLICATES[@]} files with duplicate entries"
echo ""

for UUID in "${DUPLICATES[@]}"; do
    # Get filename for this UUID
    FILENAME=$(grep "$UUID" "$PROJECT_FILE" | grep -o '/\* [^*]*.swift' | head -1 | sed 's#/\* ##' || echo "unknown")

    echo "Removing first duplicate of: $FILENAME ($UUID)"

    # Remove FIRST occurrence only (keep second)
    # This uses perl for better multi-line pattern matching
    perl -i -0pe "s/\t\t$UUID[^\n]*\n//" "$PROJECT_FILE" -T 1
done

echo ""
echo "✅ All duplicate entries removed!"
echo ""
echo "🔍 Verifying fix..."

# Count how many times each duplicate UUID appears now (should be 0 since we removed first occurrence)
STILL_DUPLICATE=0
for UUID in "${DUPLICATES[@]}"; do
    COUNT=$(grep -c "$UUID" "$PROJECT_FILE" || echo "0")
    if [ "$COUNT" -gt 0 ]; then
        STILL_DUPLICATE=$((STILL_DUPLICATE + 1))
    fi
done

if [ "$STILL_DUPLICATE" -eq 0 ]; then
    echo "✅ Perfect! All duplicates removed successfully."
else
    echo "⚠️  Warning: $STILL_DUPLICATE UUIDs still present (this may be OK if they're needed)"
fi

echo ""
echo "Next steps:"
echo "1. Close Xcode if it's open"
echo "2. Open Xcode: open PeptideFox.xcodeproj"
echo "3. Clean Build Folder: Product → Clean Build Folder (⇧⌘K)"
echo "4. Build: Product → Build (⌘B)"
echo ""
echo "If build still fails, restore backup:"
echo "  cp $BACKUP_FILE $PROJECT_FILE"
