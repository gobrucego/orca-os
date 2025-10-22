#!/usr/bin/env python3
"""Remove old ProtocolOutputView.swift references from project.pbxproj"""

with open('PeptideFox.xcodeproj/project.pbxproj', 'r') as f:
    lines = f.readlines()

# Remove lines containing the old ProtocolOutputView UUID
filtered_lines = [
    line for line in lines
    if '0C379C9542434C72A7899E51' not in line
    and 'E9D35CADFD45492694D7AE40' not in line
]

with open('PeptideFox.xcodeproj/project.pbxproj', 'w') as f:
    f.writelines(filtered_lines)

print("✅ Removed old ProtocolOutputView.swift references")
