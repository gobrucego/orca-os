#!/bin/bash

# This script adds authentication files to the Xcode project
# It uses a Ruby script to modify the project.pbxproj file

PROJECT_FILE="PeptideFox.xcodeproj/project.pbxproj"

# Create backup
cp "$PROJECT_FILE" "${PROJECT_FILE}.backup-$(date +%s)"

# Files to add
AUTH_FILES=(
    "PeptideFox/Core/Auth/AuthManager.swift"
    "PeptideFox/Models/FontSize.swift"
    "PeptideFox/Views/Profile/ProfileView.swift"
    "PeptideFox/Views/Profile/UnauthenticatedProfileView.swift"
    "PeptideFox/Views/Profile/RegisterView.swift"
    "PeptideFox/Views/Profile/SignInView.swift"
    "PeptideFox/Views/Profile/AuthenticatedProfileView.swift"
)

echo "Adding authentication files to Xcode project..."
for file in "${AUTH_FILES[@]}"; do
    echo "- $file"
done

# Use xcodeproj gem to add files properly
ruby << 'RUBY'
require 'xcodeproj'

project_path = 'PeptideFox.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get the main target
target = project.targets.first

# Files to add with their groups
files = {
  'Auth' => ['PeptideFox/Core/Auth/AuthManager.swift'],
  'Models' => ['PeptideFox/Models/FontSize.swift'],
  'Profile' => [
    'PeptideFox/Views/Profile/ProfileView.swift',
    'PeptideFox/Views/Profile/UnauthenticatedProfileView.swift',
    'PeptideFox/Views/Profile/RegisterView.swift',
    'PeptideFox/Views/Profile/SignInView.swift',
    'PeptideFox/Views/Profile/AuthenticatedProfileView.swift'
  ]
}

files.each do |group_name, file_paths|
  file_paths.each do |file_path|
    # Check if file already exists in project
    existing = project.files.find { |f| f.path == file_path }
    next if existing
    
    # Add file reference
    file_ref = project.new_file(file_path)
    
    # Add to build phase
    target.source_build_phase.add_file_reference(file_ref)
  end
end

project.save

puts "Successfully added files to Xcode project"
RUBY

echo "Done! Files added to Xcode project."
