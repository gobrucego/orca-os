#!/usr/bin/env python3
"""
Add a Swift file to Xcode project.pbxproj
"""

import sys
import uuid
import re

def generate_uuid():
    """Generate a 24-character hex UUID for Xcode"""
    return uuid.uuid4().hex[:24].upper()

def add_file_to_project(pbxproj_path, file_path, group_name):
    """
    Add a Swift file to the Xcode project

    Args:
        pbxproj_path: Path to project.pbxproj
        file_path: Relative path from project root (e.g., "PeptideFox/Views/GLPProtocolOutputView.swift")
        group_name: Group to add file to (e.g., "Views")
    """
    with open(pbxproj_path, 'r') as f:
        content = f.read()

    # Extract filename from path
    filename = file_path.split('/')[-1]

    # Generate UUIDs
    file_ref_uuid = generate_uuid()
    build_file_uuid = generate_uuid()

    # 1. Add PBXBuildFile entry (after first PBXBuildFile)
    build_file_entry = f"\t\t{build_file_uuid} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* {filename} */; }};"

    # Find first PBXBuildFile and add after it
    build_file_pattern = r'(/\* Begin PBXBuildFile section \*/\n)'
    match = re.search(build_file_pattern, content)
    if match:
        insert_pos = match.end()
        content = content[:insert_pos] + build_file_entry + '\n' + content[insert_pos:]
    else:
        print("ERROR: Could not find PBXBuildFile section")
        return False

    # 2. Add PBXFileReference entry (after first PBXFileReference)
    file_ref_entry = f"\t\t{file_ref_uuid} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {filename}; sourceTree = \"<group>\"; }};"

    file_ref_pattern = r'(/\* Begin PBXFileReference section \*/\n)'
    match = re.search(file_ref_pattern, content)
    if match:
        insert_pos = match.end()
        content = content[:insert_pos] + file_ref_entry + '\n' + content[insert_pos:]
    else:
        print("ERROR: Could not find PBXFileReference section")
        return False

    # 3. Add to PBXGroup (find the Views group or specified group)
    # Find the group by searching for its name in comments
    group_pattern = rf'(/\* {group_name} \*/ = {{[\s\S]*?children = \(\n)'
    match = re.search(group_pattern, content)
    if match:
        insert_pos = match.end()
        group_entry = f"\t\t\t\t{file_ref_uuid} /* {filename} */,\n"
        content = content[:insert_pos] + group_entry + content[insert_pos:]
    else:
        print(f"WARNING: Could not find {group_name} group, file added but not in group")

    # 4. Add to PBXSourcesBuildPhase
    sources_pattern = r'(isa = PBXSourcesBuildPhase;[\s\S]*?files = \(\n)'
    match = re.search(sources_pattern, content)
    if match:
        insert_pos = match.end()
        sources_entry = f"\t\t\t\t{build_file_uuid} /* {filename} in Sources */,\n"
        content = content[:insert_pos] + sources_entry + content[insert_pos:]
    else:
        print("ERROR: Could not find PBXSourcesBuildPhase")
        return False

    # Write back
    with open(pbxproj_path, 'w') as f:
        f.write(content)

    print(f"✅ Successfully added {filename} to project")
    print(f"   File Reference UUID: {file_ref_uuid}")
    print(f"   Build File UUID: {build_file_uuid}")
    return True

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python3 add_file_to_xcode.py <project.pbxproj> <file_path> <group_name>")
        print("Example: python3 add_file_to_xcode.py PeptideFox.xcodeproj/project.pbxproj 'PeptideFox/Views/GLPProtocolOutputView.swift' 'Views'")
        sys.exit(1)

    pbxproj_path = sys.argv[1]
    file_path = sys.argv[2]
    group_name = sys.argv[3]

    success = add_file_to_project(pbxproj_path, file_path, group_name)
    sys.exit(0 if success else 1)
