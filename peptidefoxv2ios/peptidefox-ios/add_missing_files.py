#!/usr/bin/env python3
"""
Add FontSize.swift and ProtocolOutputView.swift to project
"""

import uuid

def generate_uuid():
    return uuid.uuid4().hex[:24].upper()

# Generate UUIDs for both files
fontsize_file_ref = generate_uuid()
fontsize_build = generate_uuid()
protocol_file_ref = generate_uuid()
protocol_build = generate_uuid()

print(f"FontSize.swift - File: {fontsize_file_ref}, Build: {fontsize_build}")
print(f"ProtocolOutputView.swift - File: {protocol_file_ref}, Build: {protocol_build}")

# Read project
with open('PeptideFox.xcodeproj/project.pbxproj', 'r') as f:
    lines = f.readlines()

output_lines = []
current_section = None

for i, line in enumerate(lines):
    # Track sections
    if '/* Begin PBXBuildFile section */' in line:
        current_section = 'PBXBuildFile'
    elif '/* End PBXBuildFile section */' in line:
        current_section = None
    elif '/* Begin PBXFileReference section */' in line:
        current_section = 'PBXFileReference'
    elif '/* End PBXFileReference section */' in line:
        current_section = None
    elif 'isa = PBXSourcesBuildPhase;' in line:
        current_section = 'PBXSourcesBuildPhase'
    elif current_section == 'PBXSourcesBuildPhase' and 'runOnlyForDeploymentPostprocessing' in line:
        current_section = None

    output_lines.append(line)

    # Add to PBXBuildFile section
    if current_section == 'PBXBuildFile' and '/* Begin PBXBuildFile section */' in line:
        output_lines.append(f"\t\t{fontsize_build} /* FontSize.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {fontsize_file_ref} /* FontSize.swift */; }};\n")
        output_lines.append(f"\t\t{protocol_build} /* ProtocolOutputView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {protocol_file_ref} /* ProtocolOutputView.swift */; }};\n")

    # Add to PBXFileReference section
    elif current_section == 'PBXFileReference' and '/* Begin PBXFileReference section */' in line:
        output_lines.append(f"\t\t{fontsize_file_ref} /* FontSize.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FontSize.swift; sourceTree = \"<group>\"; }};\n")
        output_lines.append(f"\t\t{protocol_file_ref} /* ProtocolOutputView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ProtocolOutputView.swift; sourceTree = \"<group>\"; }};\n")

    # Add FontSize.swift to Models group (after ProtocolCompound.swift)
    elif '\t\t\t\tBEC5D6E7F8A9B0C1D2E3F456 /* ProtocolCompound.swift */,' in line:
        output_lines.append(f"\t\t\t\t{fontsize_file_ref} /* FontSize.swift */,\n")

    # Add ProtocolOutputView.swift to Protocol group (need to find it first)
    # For now, add to PeptideFox group
    elif '\t\t\t\t747035A4FC6649C99E2E6BB7 /* PeptideFoxApp.swift */,' in line:
        output_lines.append(f"\t\t\t\t{protocol_file_ref} /* ProtocolOutputView.swift */,\n")

    # Add to PBXSourcesBuildPhase
    elif current_section == 'PBXSourcesBuildPhase' and '\t\t\t\tAEB5C6D7E833AABB12456791 /* ProtocolCompound.swift in Sources */,' in line:
        output_lines.append(f"\t\t\t\t{fontsize_build} /* FontSize.swift in Sources */,\n")
        output_lines.append(f"\t\t\t\t{protocol_build} /* ProtocolOutputView.swift in Sources */,\n")

# Write back
with open('PeptideFox.xcodeproj/project.pbxproj', 'w') as f:
    f.writelines(output_lines)

print("\n✅ Added FontSize.swift and ProtocolOutputView.swift to project!")
