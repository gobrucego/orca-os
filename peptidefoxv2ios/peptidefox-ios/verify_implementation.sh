#!/bin/bash

# PeptideFox SwiftUI Implementation Verification Script

echo "🔍 Verifying PeptideFox SwiftUI Implementation..."
echo ""

BASE_DIR="/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox"
MISSING_FILES=0
TOTAL_FILES=0

check_file() {
    TOTAL_FILES=$((TOTAL_FILES + 1))
    if [ -f "$1" ]; then
        echo "✅ $2"
        return 0
    else
        echo "❌ $2 - MISSING"
        MISSING_FILES=$((MISSING_FILES + 1))
        return 1
    fi
}

echo "📁 Design System Files:"
check_file "$BASE_DIR/Core/Design/DesignTokens.swift" "DesignTokens.swift"
check_file "$BASE_DIR/Core/Design/ComponentStyles.swift" "ComponentStyles.swift"

echo ""
echo "📁 Data Models:"
check_file "$BASE_DIR/Core/Data/Models/PeptideModels.swift" "PeptideModels.swift"
check_file "$BASE_DIR/Core/Data/PeptideDatabase.swift" "PeptideDatabase.swift"
check_file "$BASE_DIR/Core/Data/Engines/CalculatorEngine.swift" "CalculatorEngine.swift (existing)"

echo ""
echo "📁 View Models:"
check_file "$BASE_DIR/Core/ViewModels/CalculatorViewModel.swift" "CalculatorViewModel.swift"
check_file "$BASE_DIR/Core/ViewModels/PeptideLibraryViewModel.swift" "PeptideLibraryViewModel.swift"

echo ""
echo "📁 Calculator Views:"
check_file "$BASE_DIR/Core/Presentation/Calculator/CalculatorView.swift" "CalculatorView.swift"
check_file "$BASE_DIR/Core/Presentation/Calculator/Components/DevicePickerView.swift" "DevicePickerView.swift"
check_file "$BASE_DIR/Core/Presentation/Calculator/Components/SyringeVisualView.swift" "SyringeVisualView.swift"

echo ""
echo "📁 Library Views:"
check_file "$BASE_DIR/Core/Presentation/Library/PeptideLibraryView.swift" "PeptideLibraryView.swift"
check_file "$BASE_DIR/Core/Presentation/Library/PeptideDetailView.swift" "PeptideDetailView.swift"
check_file "$BASE_DIR/Core/Presentation/Library/Components/PeptideCardView.swift" "PeptideCardView.swift"

echo ""
echo "📁 Main Navigation:"
check_file "$BASE_DIR/Core/Presentation/ContentView.swift" "ContentView.swift"
check_file "$BASE_DIR/PeptideFoxApp.swift" "PeptideFoxApp.swift (existing)"

echo ""
echo "📁 Documentation:"
check_file "/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/SWIFTUI_IMPLEMENTATION_SUMMARY.md" "Implementation Summary"
check_file "/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/INTEGRATION_GUIDE.md" "Integration Guide"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Summary:"
echo "   Total Files: $TOTAL_FILES"
echo "   Found: $((TOTAL_FILES - MISSING_FILES))"
echo "   Missing: $MISSING_FILES"
echo ""

if [ $MISSING_FILES -eq 0 ]; then
    echo "✨ All files present! Ready to integrate."
    echo ""
    echo "Next steps:"
    echo "1. Open PeptideFox.xcodeproj in Xcode"
    echo "2. Add files to project (see INTEGRATION_GUIDE.md)"
    echo "3. Update PeptideFoxApp.swift to use ContentView"
    echo "4. Build and run (Cmd+R)"
    echo ""
    echo "📖 Read INTEGRATION_GUIDE.md for detailed instructions"
    exit 0
else
    echo "⚠️  Some files are missing. Please check the paths."
    exit 1
fi
