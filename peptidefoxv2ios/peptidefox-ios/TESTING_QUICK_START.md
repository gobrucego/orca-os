# Testing Quick Start Guide

Quick reference for running PeptideFox tests.

## TL;DR

```bash
# Run all tests
./run_tests.sh

# Run only unit tests
./run_tests.sh unit

# Run only UI tests
./run_tests.sh ui

# Generate coverage report
./run_tests.sh coverage
```

## Xcode Shortcuts

| Action | Shortcut | Description |
|--------|----------|-------------|
| Run All Tests | `Cmd + U` | Run all test targets |
| Run Test File | Click ◊ next to class | Run all tests in file |
| Run Single Test | Click ◊ next to method | Run one test |
| Show Tests | `Cmd + 6` | Open test navigator |
| Show Coverage | `Cmd + 9` → Coverage | View code coverage |

## Test Files Location

```
PeptideFoxProject/
├── PeptideFoxTests/
│   ├── CalculatorEngineTests.swift      ← Calculation logic
│   ├── PeptideDatabaseTests.swift       ← Data integrity
│   ├── ViewModelTests.swift             ← ViewModels
│   ├── TestHelpers.swift                ← Utilities
│   └── SnapshotTests/
│       ├── CalculatorViewSnapshotTests.swift
│       └── PeptideLibraryViewSnapshotTests.swift
│
└── PeptideFoxUITests/
    ├── CalculatorFlowTests.swift        ← Calculator flows
    ├── LibraryFlowTests.swift           ← Library navigation
    └── AccessibilityTests.swift         ← A11y compliance
```

## Command Line

### Run Specific Tests

```bash
# Unit tests only
xcodebuild test -scheme PeptideFox -only-testing:PeptideFoxTests

# UI tests only
xcodebuild test -scheme PeptideFox -only-testing:PeptideFoxUITests

# Specific test class
xcodebuild test -scheme PeptideFox \
  -only-testing:PeptideFoxTests/CalculatorEngineTests

# Specific test method
xcodebuild test -scheme PeptideFox \
  -only-testing:PeptideFoxTests/CalculatorEngineTests/testBasicConcentrationCalculation
```

### With Coverage

```bash
xcodebuild test \
  -project PeptideFoxProject/PeptideFox.xcodeproj \
  -scheme PeptideFox \
  -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
  -enableCodeCoverage YES
```

## Snapshot Testing

### First Time Setup

1. Add swift-snapshot-testing package to project
2. Import in test files: `import SnapshotTesting`

### Recording Snapshots

```swift
override func setUpWithError() throws {
    isRecording = true  // Record new snapshots
}
```

Run tests → Set `isRecording = false` → Run again to verify

### Updating Snapshots

When UI changes:
1. Set `isRecording = true`
2. Run snapshot tests
3. Review changes in Git
4. Set `isRecording = false`
5. Commit updated snapshots

## Test Coverage

### View Coverage in Xcode

1. Enable coverage: Edit Scheme → Test → Options → ✓ Gather coverage
2. Run tests: `Cmd + U`
3. View report: `Cmd + 9` → Coverage tab

### Coverage Targets

- Calculation Engines: 90%+
- Data Layer: 80%+
- ViewModels: 70%+
- Overall: 70%+

## Writing New Tests

### Unit Test Template

```swift
import XCTest
@testable import PeptideFox

final class MyFeatureTests: XCTestCase {
    var sut: MyFeature!
    
    override func setUpWithError() throws {
        sut = MyFeature()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testMyFeature() throws {
        // Given
        let input = "test"
        
        // When
        let result = sut.process(input)
        
        // Then
        XCTAssertEqual(result, "expected")
    }
}
```

### UI Test Template

```swift
import XCTest

final class MyFeatureUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testUserFlow() throws {
        app.buttons["Action"].tap()
        
        let result = app.staticTexts["Result"]
        XCTAssertTrue(result.waitForExistence(timeout: 3))
    }
}
```

## Common Issues

### UI Test Not Finding Element

```swift
// ❌ Don't
XCTAssertTrue(app.buttons["Calculate"].exists)

// ✅ Do
XCTAssertTrue(app.buttons["Calculate"].waitForExistence(timeout: 5))
```

### Async Test Not Working

```swift
func testAsyncOperation() async throws {
    let result = try await myAsyncFunction()
    XCTAssertEqual(result, expected)
}
```

### Test Target Can't Find App Code

```swift
@testable import PeptideFox  // Add this
```

## CI/CD Integration

### GitHub Actions

```yaml
- name: Run Tests
  run: ./run_tests.sh all
```

### Pre-commit Hook

```bash
#!/bin/bash
./run_tests.sh unit || exit 1
```

## Test Execution Times

| Suite | Time | Tests |
|-------|------|-------|
| Unit Tests | ~5s | 70+ |
| UI Tests | ~75s | 50+ |
| Snapshot Tests | ~5s | 20+ |
| **Total** | **~85s** | **140+** |

## Helper Functions

### Test Data Builders

```swift
// Standard calculator input
let input = TestDataBuilder.standardCalculatorInput()

// Custom calculator input
let input = TestDataBuilder.calculatorInput(
    vialSize: 10.0,
    targetDose: 0.25
)

// Standard devices
let device = TestDataBuilder.standardDevice(type: .syringe50)
```

### UI Test Helpers

```swift
// Perform calculator input
performCalculatorInput(
    app: app,
    vialSize: "10",
    reconVolume: "2",
    targetDose: "0.25"
)

// Wait and tap
button.tapAfterWaiting(timeout: 5)

// Clear and type
textField.clearAndTypeText("new value")
```

## Test Review Checklist

Before submitting PR:

- [ ] All tests pass (`Cmd + U`)
- [ ] Coverage meets targets (>70%)
- [ ] New features have tests
- [ ] Snapshots updated if needed
- [ ] No test warnings
- [ ] Test names are descriptive

## Resources

- [Full Testing Guide](./README_TESTING.md)
- [Test Summary](./TEST_SUMMARY.md)
- [Apple XCTest Docs](https://developer.apple.com/documentation/xctest)

---

**Need Help?** Check README_TESTING.md for detailed documentation.
