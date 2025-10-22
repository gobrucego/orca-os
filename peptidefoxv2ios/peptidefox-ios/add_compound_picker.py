#!/usr/bin/env python3
"""Add CompoundPickerView.swift to project"""

import uuid

def generate_uuid():
    return uuid.uuid4().hex[:24].upper()

file_ref = generate_uuid()
build = generate_uuid()

print(f"CompoundPickerView.swift - File: {file_ref}, Build: {build}")

with open('PeptideFox.xcodeproj/project.pbxproj', 'r') as f:
    lines = f.readlines()

output_lines = []
current_section = None

for line in lines:
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

    # Add to PBXBuildFile
    if current_section == 'PBXBuildFile' and '/* Begin PBXBuildFile section */' in line:
        output_lines.append(f"\t\t{build} /* CompoundPickerView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref} /* CompoundPickerView.swift */; }};\n")
        print("✅ Added PBXBuildFile entry")

    # Add to PBXFileReference
    elif current_section == 'PBXFileReference' and '/* Begin PBXFileReference section */' in line:
        output_lines.append(f"\t\t{file_ref} /* CompoundPickerView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"Core/Presentation/Calculator/CompoundPickerView.swift\"; sourceTree = \"<group>\"; }};\n")
        print("✅ Added PBXFileReference entry")

    # Add to PeptideFox group
    elif '\t\t\t\t747035A4FC6649C99E2E6BB7 /* PeptideFoxApp.swift */,' in line:
        output_lines.append(f"\t\t\t\t{file_ref} /* CompoundPickerView.swift */,\n")
        print("✅ Added to PeptideFox group")

    # Add to PBXSourcesBuildPhase
    elif current_section == 'PBXSourcesBuildPhase' and '\t\t\t\tAEB5C6D7E833AABB12456791 /* ProtocolCompound.swift in Sources */,' in line:
        output_lines.append(f"\t\t\t\t{build} /* CompoundPickerView.swift in Sources */,\n")
        print("✅ Added to PBXSourcesBuildPhase")

with open('PeptideFox.xcodeproj/project.pbxproj', 'w') as f:
    f.writelines(output_lines)

print("\n✅ CompoundPickerView.swift added to project!")
