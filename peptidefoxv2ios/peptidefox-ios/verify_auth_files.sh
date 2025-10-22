#!/bin/bash

echo "=========================================="
echo "PeptideFox Authentication Implementation"
echo "File Verification Script"
echo "=========================================="
echo ""

# Check if files exist
FILES=(
    "PeptideFox/Core/Auth/AuthManager.swift"
    "PeptideFox/Models/FontSize.swift"
    "PeptideFox/Views/Profile/ProfileView.swift"
    "PeptideFox/Views/Profile/UnauthenticatedProfileView.swift"
    "PeptideFox/Views/Profile/RegisterView.swift"
    "PeptideFox/Views/Profile/SignInView.swift"
    "PeptideFox/Views/Profile/AuthenticatedProfileView.swift"
)

echo "Checking files..."
echo ""

all_exist=true
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        size=$(wc -c < "$file" | tr -d ' ')
        lines=$(wc -l < "$file" | tr -d ' ')
        echo "✓ $file"
        echo "  → $lines lines, $size bytes"
    else
        echo "✗ $file (MISSING)"
        all_exist=false
    fi
done

echo ""
echo "=========================================="

if [ "$all_exist" = true ]; then
    echo "✓ All authentication files created successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Open PeptideFox.xcodeproj in Xcode"
    echo "2. Add the files to the project (drag & drop or Add Files)"
    echo "3. Build and run (Cmd+R)"
    echo "4. Navigate to Profile tab to test authentication"
else
    echo "✗ Some files are missing. Please check the implementation."
    exit 1
fi
