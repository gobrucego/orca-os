#!/bin/bash

# Fix duplicate files in Xcode project by removing duplicate PBXBuildFile entries

set -e

cd "$(dirname "$0")"

PROJECT_FILE="PeptideFox.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Error: $PROJECT_FILE not found"
    exit 1
fi

echo "🔧 Fixing duplicate file entries in Xcode project..."
echo ""

# Create backup
BACKUP="PeptideFox.xcodeproj/project.pbxproj.backup-$(date +%Y%m%d-%H%M%S)"
cp "$PROJECT_FILE" "$BACKUP"
echo "📦 Backup created: $BACKUP"
echo ""

# Use Python to deduplicate (more reliable than sed)
python3 << 'PYTHON_SCRIPT'
import re
from collections import defaultdict

# Read project file
with open("PeptideFox.xcodeproj/project.pbxproj", "r") as f:
    lines = f.readlines()

# Track which UUIDs we've seen
seen_build_files = defaultdict(list)  # UUID -> [line_numbers]
seen_file_refs = defaultdict(list)

output_lines = []
removed_count = 0

for i, line in enumerate(lines):
    # Match PBXBuildFile entries: UUID /* filename in Sources */ = {isa = PBXBuildFile; ...
    build_match = re.match(r'\t\t([A-F0-9]{24}) /\* (.+?) in Sources \*/', line)

    if build_match:
        uuid = build_match.group(1)
        filename = build_match.group(2)

        if uuid in seen_build_files:
            # This is a duplicate - skip it
            print(f"  Removing duplicate PBXBuildFile: {filename} ({uuid})")
            removed_count += 1
            continue
        else:
            seen_build_files[uuid].append(i)

    # Match fileRef entries in groups: UUID /* filename */,
    fileref_match = re.match(r'\t\t\t\t([A-F0-9]{24}) /\* (.+?) \*/,', line)

    if fileref_match:
        uuid = fileref_match.group(1)
        filename = fileref_match.group(2)

        if uuid in seen_file_refs:
            # Duplicate file reference in group
            print(f"  Removing duplicate file ref in group: {filename} ({uuid})")
            removed_count += 1
            continue
        else:
            seen_file_refs[uuid].append(i)

    output_lines.append(line)

# Write fixed file
with open("PeptideFox.xcodeproj/project.pbxproj", "w") as f:
    f.writelines(output_lines)

print(f"\n✅ Removed {removed_count} duplicate entries")

PYTHON_SCRIPT

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Project file fixed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Open Xcode: open PeptideFox.xcodeproj"
    echo "2. Clean Build Folder: Product → Clean Build Folder (⇧⌘K)"
    echo "3. Build: Product → Build (⌘B)"
    echo ""
    echo "If build fails, restore backup:"
    echo "  cp $BACKUP PeptideFox.xcodeproj/project.pbxproj"
else
    echo "❌ Fix failed. Restoring backup..."
    cp "$BACKUP" "$PROJECT_FILE"
    exit 1
fi
