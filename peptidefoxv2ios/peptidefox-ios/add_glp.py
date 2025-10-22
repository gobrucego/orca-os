#!/usr/bin/env python3
import uuid

def gen_uuid():
    return uuid.uuid4().hex[:24].upper()

file_ref, build = gen_uuid(), gen_uuid()
print(f"GLPProtocolOutputView.swift - File: {file_ref}, Build: {build}")

with open('PeptideFox.xcodeproj/project.pbxproj', 'r') as f:
    lines = f.readlines()

out, sec = [], None
for line in lines:
    if '/* Begin PBXBuildFile section */' in line: sec = 'B'
    elif '/* End PBXBuildFile section */' in line: sec = None
    elif '/* Begin PBXFileReference section */' in line: sec = 'F'
    elif '/* End PBXFileReference section */' in line: sec = None
    elif 'isa = PBXSourcesBuildPhase;' in line: sec = 'S'
    elif sec == 'S' and 'runOnlyForDeploymentPostprocessing' in line: sec = None
    
    out.append(line)
    
    if sec == 'B' and '/* Begin PBXBuildFile section */' in line:
        out.append(f"\t\t{build} /* GLPProtocolOutputView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref} /* GLPProtocolOutputView.swift */; }};\n")
    elif sec == 'F' and '/* Begin PBXFileReference section */' in line:
        out.append(f"\t\t{file_ref} /* GLPProtocolOutputView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"Views/GLPProtocolOutputView.swift\"; sourceTree = \"<group>\"; }};\n")
    elif '\t\t\t\t747035A4FC6649C99E2E6BB7 /* PeptideFoxApp.swift */,' in line:
        out.append(f"\t\t\t\t{file_ref} /* GLPProtocolOutputView.swift */,\n")
    elif sec == 'S' and '\t\t\t\tAEB5C6D7E833AABB12456791 /* ProtocolCompound.swift in Sources */,' in line:
        out.append(f"\t\t\t\t{build} /* GLPProtocolOutputView.swift in Sources */,\n")

with open('PeptideFox.xcodeproj/project.pbxproj', 'w') as f:
    f.writelines(out)

print("✅ Added GL PProtocolOutputView.swift!")
