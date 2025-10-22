#!/bin/bash

echo "=== ValidationEngine Implementation Verification ==="
echo ""

# File existence checks
echo "1. Checking file existence..."
FILES=(
    "PeptideFoxProject/PeptideFox/Core/Data/Models/ProtocolModels.swift"
    "PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift"
    "PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngineExample.swift"
    "PeptideFoxProject/PeptideFox/Core/Data/Engines/README.md"
    "PeptideFoxProject/PeptideFoxTests/EngineTests/ValidationEngineTests.swift"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ Missing: $file"
    fi
done

echo ""
echo "2. Checking for force-unwraps..."
FORCE_UNWRAPS=$(grep -r "!" PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift | grep -v "// " | grep -v "/// " | wc -l)
if [ "$FORCE_UNWRAPS" -eq 0 ]; then
    echo "   ✅ No force-unwraps found in ValidationEngine.swift"
else
    echo "   ⚠️  Found $FORCE_UNWRAPS potential force-unwraps (manual review needed)"
fi

echo ""
echo "3. Code statistics..."
echo "   ValidationEngine.swift: $(wc -l < PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift) lines"
echo "   ProtocolModels.swift: $(wc -l < PeptideFoxProject/PeptideFox/Core/Data/Models/ProtocolModels.swift) lines"
echo "   ValidationEngineTests.swift: $(wc -l < PeptideFoxProject/PeptideFoxTests/EngineTests/ValidationEngineTests.swift) lines"

echo ""
echo "4. Checking Swift patterns..."
if grep -q "Sendable" PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift; then
    echo "   ✅ Sendable conformance found"
else
    echo "   ❌ Missing Sendable conformance"
fi

if grep -q "@MainActor\|actor " PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift; then
    echo "   ✅ Actor isolation patterns found"
else
    echo "   ⚠️  No actor patterns (may be intentional for struct)"
fi

echo ""
echo "5. Checking validation rules..."
RULES_COUNT=$(grep -c "case \.max\|case \.injection\|case \.timing\|case \.interaction" PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift)
echo "   Found $RULES_COUNT rule evaluation cases"

if grep -q "Semaglutide.*2.4" PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift; then
    echo "   ✅ Semaglutide 2.4mg limit found"
fi

if grep -q "Tirzepatide.*15" PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift; then
    echo "   ✅ Tirzepatide 15mg limit found"
fi

if grep -q "Retatrutide.*12" PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift; then
    echo "   ✅ Retatrutide 12mg limit found"
fi

echo ""
echo "6. Checking hash implementation..."
if grep -q "pf_" PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift; then
    echo "   ✅ Hash prefix 'pf_' found"
fi

if grep -q "simpleHash" PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift; then
    echo "   ✅ simpleHash function found"
fi

if grep -q "<<.*5.*-.*\+" PeptideFoxProject/PeptideFox/Core/Data/Engines/ValidationEngine.swift; then
    echo "   ✅ Bit-shift hash algorithm found"
fi

echo ""
echo "7. Test coverage check..."
TEST_FUNCTIONS=$(grep -c "func test" PeptideFoxProject/PeptideFoxTests/EngineTests/ValidationEngineTests.swift)
echo "   Found $TEST_FUNCTIONS test functions"

if [ "$TEST_FUNCTIONS" -ge 15 ]; then
    echo "   ✅ Comprehensive test coverage ($TEST_FUNCTIONS tests)"
else
    echo "   ⚠️  Limited test coverage ($TEST_FUNCTIONS tests)"
fi

echo ""
echo "8. Documentation check..."
if [ -f "PeptideFoxProject/PeptideFox/Core/Data/Engines/README.md" ]; then
    README_LINES=$(wc -l < PeptideFoxProject/PeptideFox/Core/Data/Engines/README.md)
    echo "   ✅ README.md exists ($README_LINES lines)"
else
    echo "   ❌ README.md missing"
fi

echo ""
echo "=== Verification Complete ==="
