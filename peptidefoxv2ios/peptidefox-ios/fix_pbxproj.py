#!/usr/bin/env python3
"""Remove bad file references from project.pbxproj"""

with open('PeptideFox.xcodeproj/project.pbxproj', 'r') as f:
    lines = f.readlines()

# Remove lines with bad file references
filtered_lines = []
for line in lines:
    # Skip lines referencing files in wrong locations
    if 'AB5080A2' in line:  # Color+Hex.swift in root
        continue
    if 'AB5080A4' in line:  # FontSize 2.swift
        continue
    if 'AB5080A3' in line:  # Color+Hex.swift in Sources (wrong reference)
        continue
    if 'AB5080A5' in line:  # FontSize 2.swift in Sources
        continue
    filtered_lines.append(line)

with open('PeptideFox.xcodeproj/project.pbxproj', 'w') as f:
    f.writelines(filtered_lines)

print("✅ Removed bad file references")
