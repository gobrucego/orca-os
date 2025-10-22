#!/bin/bash

# minimal-build-test.sh - Test if basic Swift compilation works
# This helps isolate project issues from toolchain issues

echo "============================================"
echo "Minimal Swift Build Test"
echo "============================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test 1: Create minimal SwiftUI app
echo -e "${BLUE}[1/3] Creating minimal SwiftUI app...${NC}"

cat > /tmp/MinimalTest.swift << 'SWIFT_EOF'
import SwiftUI

@main
struct MinimalApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Hello, PeptideFox!")
                .padding()
        }
    }
}
SWIFT_EOF

echo -e "${GREEN}✓ Test file created${NC}"
echo ""

# Test 2: Try to compile it
echo -e "${BLUE}[2/3] Testing Swift compiler...${NC}"
if xcrun swiftc -parse-as-library -typecheck /tmp/MinimalTest.swift 2>&1; then
    echo -e "${GREEN}✓ Swift compiler works${NC}"
else
    echo -e "${RED}✗ Swift compiler failed${NC}"
    echo "  Your Swift toolchain may be broken"
    exit 1
fi
echo ""

# Test 3: Test with iOS target
echo -e "${BLUE}[3/3] Testing iOS compilation...${NC}"
IOS_TEST_OUTPUT=$(xcrun swiftc -parse-as-library -target arm64-apple-ios17.0 -typecheck /tmp/MinimalTest.swift 2>&1)
if echo "$IOS_TEST_OUTPUT" | grep -q "unable to load standard library"; then
    echo -e "${YELLOW}⚠ iOS compilation requires full Xcode (not just Command Line Tools)${NC}"
    echo "  This is OK - Command Line Tools installed, but iOS SDK needs Xcode.app"
elif [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ iOS 17.0 target works${NC}"
else
    echo -e "${RED}✗ iOS compilation failed${NC}"
    echo "  Check Xcode installation"
fi
echo ""

# Test 4: Test @Observable
echo -e "${BLUE}[4/4] Testing @Observable macro...${NC}"

cat > /tmp/ObservableTest.swift << 'SWIFT_EOF'
import SwiftUI
import Observation

@Observable
class TestViewModel {
    var value: String = "test"
}

struct TestView: View {
    @State private var viewModel = TestViewModel()
    
    var body: some View {
        Text(viewModel.value)
    }
}
SWIFT_EOF

OBSERVABLE_OUTPUT=$(xcrun swiftc -parse-as-library -target arm64-apple-ios17.0 -typecheck /tmp/ObservableTest.swift 2>&1)
if echo "$OBSERVABLE_OUTPUT" | grep -q "unable to load standard library"; then
    echo -e "${YELLOW}⚠ Cannot test @Observable (needs full Xcode)${NC}"
    echo "  Will work once project opened in Xcode.app"
elif [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ @Observable macro works${NC}"
else
    echo -e "${YELLOW}⚠ @Observable macro failed${NC}"
    echo "  This is OK if targeting iOS 16"
fi
echo ""

# Cleanup
rm -f /tmp/MinimalTest.swift /tmp/ObservableTest.swift

# Summary
echo "============================================"
echo "Test Summary"
echo "============================================"
echo ""
echo -e "${GREEN}✓ Swift toolchain is working${NC}"
echo ""
echo "Next steps:"
echo "1. Open PeptideFox.xcodeproj in Xcode.app"
echo "2. Build the project (⌘B)"
echo "3. If errors occur, run: ./fix_build.sh"
echo "4. Consult BUILD_FIX.md for solutions"
echo ""
echo "Environment:"
echo "Swift: $(xcrun swift --version | head -1)"
if command -v xcodebuild &> /dev/null; then
    xcodebuild -version 2>/dev/null || echo "Xcode: Command Line Tools only (need full Xcode.app)"
else
    echo "Xcode: Not available via command line"
fi
echo ""
