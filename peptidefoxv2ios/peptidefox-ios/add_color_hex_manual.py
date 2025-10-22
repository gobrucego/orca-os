#!/usr/bin/env python3
"""
Very simple script to add Color+Hex.swift to project.pbxproj
Uses exact same pattern as AuthManager.swift
"""

import uuid

def generate_uuid():
    """Generate 24-char hex UUID like Xcode"""
    return uuid.uuid4().hex[:24].upper()

# Generate two UUIDs
file_ref_uuid = generate_uuid()
build_file_uuid = generate_uuid()

print(f"File Reference UUID: {file_ref_uuid}")
print(f"Build File UUID: {build_file_uuid}")

# Read project
with open('PeptideFox.xcodeproj/project.pbxproj', 'r') as f:
    lines = f.readlines()

output_lines = []
added_build = False
added_fileref = False
added_group = False
added_sources = False

for i, line in enumerate(lines):
    output_lines.append(line)

    # 1. Add to PBXBuildFile section (after the first entry)
    if not added_build and 'Begin PBXBuildFile section' in line:
        # Add after the section header
        output_lines.append(f"\t\t{build_file_uuid} /* Color+Hex.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* Color+Hex.swift */; }};\n")
        added_build = True
        print("✅ Added PBXBuildFile entry")

    # 2. Add to PBXFileReference section
    elif not added_fileref and 'Begin PBXFileReference section' in line:
        output_lines.append(f"\t\t{file_ref_uuid} /* Color+Hex.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"Color+Hex.swift\"; sourceTree = \"<group>\"; }};\n")
        added_fileref = True
        print("✅ Added PBXFileReference entry")

    # 3. Add to Auth group (where AuthManager.swift is)
    elif not added_group and 'BDC4D5E6F7A8B9C0D1E2F345 /* AuthManager.swift */' in line:
        output_lines.append(f"\t\t\t\t{file_ref_uuid} /* Color+Hex.swift */,\n")
        added_group = True
        print("✅ Added to Auth group (same as AuthManager)")

    # 4. Add to PBXSourcesBuildPhase
    elif not added_sources and 'ADB4C5D6E7229ABA01345690 /* AuthManager.swift in Sources */' in line:
        output_lines.append(f"\t\t\t\t{build_file_uuid} /* Color+Hex.swift in Sources */,\n")
        added_sources = True
        print("✅ Added to PBXSourcesBuildPhase")

# Write back
with open('PeptideFox.xcodeproj/project.pbxproj', 'w') as f:
    f.writelines(output_lines)

print("\n✅ Color+Hex.swift added to project!")
print(f"Added {added_build + added_fileref + added_group + added_sources}/4 entries")
