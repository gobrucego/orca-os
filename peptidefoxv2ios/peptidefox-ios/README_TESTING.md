# PeptideFox Testing Guide

Comprehensive testing documentation for the PeptideFox iOS application.

## Table of Contents

- [Overview](#overview)
- [Test Structure](#test-structure)
- [Running Tests](#running-tests)
- [Test Coverage](#test-coverage)
- [Writing Tests](#writing-tests)
- [Snapshot Testing](#snapshot-testing)
- [Continuous Integration](#continuous-integration)

---

## Overview

PeptideFox uses a comprehensive testing strategy that includes:

- **Unit Tests**: Testing individual components and calculation engines
- **UI Tests**: Testing complete user flows and interactions
- **Snapshot Tests**: Visual regression testing for UI components
- **Accessibility Tests**: Ensuring VoiceOver, Dynamic Type, and touch target compliance

### Testing Philosophy

1. **Test Critical Paths**: Focus on user-facing features and calculation accuracy
2. **Fast Feedback**: Keep unit tests fast; reserve UI tests for integration scenarios
3. **Maintainable**: Use helper methods to reduce duplication
4. **Comprehensive**: Aim for 90%+ coverage on calculation engines and business logic

---

## Test Structure

```
PeptideFoxProject/
├── PeptideFoxTests/               # Unit Tests
│   ├── EngineTests/
│   │   └── ValidationEngineTests.swift
│   ├── SnapshotTests/
│   │   ├── CalculatorViewSnapshotTests.swift
│   │   └── PeptideLibraryViewSnapshotTests.swift
│   ├── CalculatorEngineTests.swift
│   └── PeptideDatabaseTests.swift
│
└── PeptideFoxUITests/             # UI Tests
    ├── CalculatorFlowTests.swift
    ├── LibraryFlowTests.swift
    └── AccessibilityTests.swift
```

### Test Categories

#### Unit Tests (`PeptideFoxTests/`)

- **CalculatorEngineTests.swift**: Tests for dose calculation logic
  - Concentration calculations
  - Draw volume calculations
  - Supply planning (doses per vial, monthly vials)
  - Device compatibility
  - Unit conversions
  - Validation and error handling
  
- **PeptideDatabaseTests.swift**: Tests for peptide data integrity
  - Database content validation
  - Category filtering
  - Search functionality
  - Data integrity (doses, contraindications, synergies)
  
- **ValidationEngineTests.swift**: Tests for protocol validation
  - Safety checks
  - Drug interaction warnings
  - Max dose validations

#### UI Tests (`PeptideFoxUITests/`)

- **CalculatorFlowTests.swift**: End-to-end calculator workflows
  - Complete calculation flow
  - Device picker navigation
  - Frequency selection
  - Results display
  - Error handling
  
- **LibraryFlowTests.swift**: Library navigation and filtering
  - Browse peptide library
  - Category filtering
  - Search functionality
  - Peptide detail navigation
  
- **AccessibilityTests.swift**: Accessibility compliance
  - VoiceOver labels
  - Dynamic Type support
  - Touch target sizes (44pt minimum)
  - Color contrast verification

#### Snapshot Tests (`PeptideFoxTests/SnapshotTests/`)

- **CalculatorViewSnapshotTests.swift**: Visual regression for calculator
  - Initial state
  - With results
  - Light/dark mode
  - Different device sizes
  - Error states
  
- **PeptideLibraryViewSnapshotTests.swift**: Visual regression for library
  - Grid layout
  - Peptide detail views
  - Category filters
  - Empty states

---

## Running Tests

### Xcode UI

1. **Run All Tests**: `Cmd + U`
2. **Run Specific Test File**: Click diamond icon next to class name
3. **Run Single Test**: Click diamond icon next to test method
4. **View Test Results**: Show Test Navigator (`Cmd + 6`)

### Command Line

```bash
# Run all tests
xcodebuild test \
  -project PeptideFoxProject/PeptideFox.xcodeproj \
  -scheme PeptideFox \
  -destination 'platform=iOS Simulator,name=iPhone 14 Pro'

# Run only unit tests
xcodebuild test \
  -project PeptideFoxProject/PeptideFox.xcodeproj \
  -scheme PeptideFox \
  -only-testing:PeptideFoxTests

# Run only UI tests
xcodebuild test \
  -project PeptideFoxProject/PeptideFox.xcodeproj \
  -scheme PeptideFox \
  -only-testing:PeptideFoxUITests

# Run specific test class
xcodebuild test \
  -project PeptideFoxProject/PeptideFox.xcodeproj \
  -scheme PeptideFox \
  -only-testing:PeptideFoxTests/CalculatorEngineTests
```

### CI/CD (GitHub Actions example)

```yaml
# .github/workflows/ios-tests.yml
name: iOS Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-13
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Unit Tests
        run: |
          xcodebuild test \
            -project PeptideFoxProject/PeptideFox.xcodeproj \
            -scheme PeptideFox \
            -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
            -only-testing:PeptideFoxTests
      
      - name: Run UI Tests
        run: |
          xcodebuild test \
            -project PeptideFoxProject/PeptideFox.xcodeproj \
            -scheme PeptideFox \
            -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
            -only-testing:PeptideFoxUITests
```

---

## Test Coverage

### Coverage Goals

- **Calculation Engines**: 90%+ (critical path)
- **Data Models**: 80%+ (validation and integrity)
- **ViewModels**: 70%+ (business logic)
- **Views**: Snapshot tests (visual regression)
- **Overall Project**: 70%+

### Viewing Coverage

1. Enable Code Coverage in Xcode:
   - Edit Scheme → Test → Options
   - Check "Gather coverage for: All targets"

2. Run tests with coverage: `Cmd + U`

3. View coverage report:
   - Show Report Navigator (`Cmd + 9`)
   - Select latest Test report
   - Click Coverage tab

### Command Line Coverage

```bash
xcodebuild test \
  -project PeptideFoxProject/PeptideFox.xcodeproj \
  -scheme PeptideFox \
  -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
  -enableCodeCoverage YES
```

Extract coverage report:
```bash
xcrun xccov view --report \
  ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Logs/Test/*.xcresult
```

---

## Writing Tests

### Unit Test Template

```swift
import XCTest
@testable import PeptideFox

final class MyFeatureTests: XCTestCase {
    var sut: MyFeature! // System Under Test
    
    override func setUpWithError() throws {
        sut = MyFeature()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Test Cases
    
    func testFeatureBehavior() throws {
        // Given
        let input = "test input"
        
        // When
        let result = sut.process(input)
        
        // Then
        XCTAssertEqual(result, "expected output")
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
        // Navigate
        app.tabBars.buttons["Tab"].tap()
        
        // Interact
        let button = app.buttons["Action"]
        XCTAssertTrue(button.exists)
        button.tap()
        
        // Verify
        let result = app.staticTexts["Result"]
        XCTAssertTrue(result.waitForExistence(timeout: 3))
    }
}
```

### Best Practices

1. **Use descriptive test names**: `testCalculatorComputesCorrectConcentration()`
2. **Follow Given-When-Then pattern**: Setup, action, assertion
3. **Test one thing per test**: Focused, clear purpose
4. **Use XCTAssert variants**: `XCTAssertEqual`, `XCTAssertTrue`, `XCTAssertNil`, etc.
5. **Clean up resources**: Use `tearDown()` for cleanup
6. **Test edge cases**: Zero, negative, maximum values
7. **Test error paths**: Not just happy path

### Testing Async Code

```swift
func testAsyncCalculation() async throws {
    let calculator = CalculatorEngine()
    
    let input = CalculatorInput(
        vialSize: 10.0,
        reconstitutionVolume: 2.0,
        targetDose: 0.25,
        frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
    )
    
    let output = try await calculator.calculate(input: input)
    
    XCTAssertEqual(output.concentration, 5.0, accuracy: 0.001)
}
```

---

## Snapshot Testing

### Setup

1. Add swift-snapshot-testing dependency:

```swift
// Package.swift or Xcode project
dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0")
]
```

2. Import in test file:

```swift
import SnapshotTesting
import SwiftUI
@testable import PeptideFox
```

### Recording Snapshots

```swift
final class MyViewSnapshotTests: XCTestCase {
    override func setUpWithError() throws {
        // Set to true to record new snapshots
        isRecording = true
    }
    
    func testMyView() {
        let view = MyView()
            .frame(width: 390, height: 844)
        
        assertSnapshot(matching: view, as: .image)
    }
}
```

**First run**: With `isRecording = true`, generates reference images in `__Snapshots__/` directory

**Subsequent runs**: With `isRecording = false`, compares against reference images

### Updating Snapshots

When UI changes intentionally:

1. Set `isRecording = true` in test setup
2. Run tests to regenerate snapshots
3. Review changes in Git diff
4. Set `isRecording = false`
5. Commit updated snapshots

### Snapshot Strategies

**Device Variants**:
```swift
func testMyViewAllDevices() {
    let view = MyView()
    
    // iPhone SE
    assertSnapshot(matching: view.frame(width: 375, height: 667), as: .image, named: "iPhoneSE")
    
    // iPhone 14 Pro
    assertSnapshot(matching: view.frame(width: 390, height: 844), as: .image, named: "iPhone14Pro")
    
    // iPad Pro
    assertSnapshot(matching: view.frame(width: 834, height: 1194), as: .image, named: "iPadPro")
}
```

**Dark Mode**:
```swift
func testMyViewDarkMode() {
    let view = MyView()
        .frame(width: 390, height: 844)
        .preferredColorScheme(.dark)
    
    assertSnapshot(matching: view, as: .image)
}
```

**Accessibility**:
```swift
func testMyViewExtraLargeText() {
    let view = MyView()
        .frame(width: 390, height: 844)
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    
    assertSnapshot(matching: view, as: .image)
}
```

---

## Accessibility Testing

### VoiceOver Labels

```swift
func testVoiceOverLabels() throws {
    app.launch()
    
    let button = app.buttons["Calculate"]
    XCTAssertNotNil(button.label)
    XCTAssertEqual(button.label, "Calculate")
}
```

### Dynamic Type

```swift
func testDynamicTypeSupport() throws {
    app.launchArguments = [
        "-UIPreferredContentSizeCategoryName",
        "UICTContentSizeCategoryAccessibilityXXXL"
    ]
    app.launch()
    
    // Verify app doesn't crash and elements are accessible
    XCTAssertTrue(app.buttons["Calculate"].exists)
}
```

### Touch Targets

```swift
func testMinimumTouchTargetSize() throws {
    app.launch()
    
    let button = app.buttons["Calculate"]
    let frame = button.frame
    
    // Apple HIG: 44pt minimum
    XCTAssertGreaterThanOrEqual(frame.height, 44)
    XCTAssertGreaterThanOrEqual(frame.width, 44)
}
```

---

## Continuous Integration

### GitHub Actions

Create `.github/workflows/ios-tests.yml`:

```yaml
name: iOS Tests

on:
  push:
    branches: [ main, dev ]
  pull_request:
    branches: [ main, dev ]

jobs:
  test:
    runs-on: macos-13
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Select Xcode version
      run: sudo xcode-select -s /Applications/Xcode_14.3.app
    
    - name: Run Unit Tests
      run: |
        xcodebuild test \
          -project PeptideFoxProject/PeptideFox.xcodeproj \
          -scheme PeptideFox \
          -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
          -only-testing:PeptideFoxTests \
          -enableCodeCoverage YES
    
    - name: Run UI Tests
      run: |
        xcodebuild test \
          -project PeptideFoxProject/PeptideFox.xcodeproj \
          -scheme PeptideFox \
          -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
          -only-testing:PeptideFoxUITests
    
    - name: Upload Test Results
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: test-results
        path: ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Logs/Test/*.xcresult
```

### Xcode Cloud

1. Open Xcode Cloud settings in Xcode
2. Create workflow for "Test" action
3. Configure:
   - **Trigger**: On push to main/dev branches
   - **Environment**: macOS 13, Xcode 14.3
   - **Actions**: Run tests for PeptideFox scheme
   - **Post-actions**: Archive test results

---

## Troubleshooting

### UI Tests Timing Issues

**Problem**: UI test fails intermittently due to timing

**Solution**: Use `waitForExistence(timeout:)`

```swift
// ❌ Don't do this
XCTAssertTrue(app.buttons["Calculate"].exists)

// ✅ Do this
XCTAssertTrue(app.buttons["Calculate"].waitForExistence(timeout: 5))
```

### Snapshot Test Failures

**Problem**: Snapshots fail on different machines

**Solution**: Run on same OS version, use fixed frame sizes

```swift
// Always specify explicit frame
let view = MyView()
    .frame(width: 390, height: 844)

assertSnapshot(matching: view, as: .image)
```

### Test Target Membership

**Problem**: Test can't find app code

**Solution**: Ensure test target has `@testable import`

```swift
@testable import PeptideFox
```

And verify test target in Xcode project settings.

---

## Additional Resources

- [Apple XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [swift-snapshot-testing GitHub](https://github.com/pointfreeco/swift-snapshot-testing)
- [Apple Accessibility Testing Guide](https://developer.apple.com/documentation/accessibility)
- [WWDC: Testing in Xcode](https://developer.apple.com/videos/play/wwdc2022/110357/)

---

## Test Checklist

Before submitting PR:

- [ ] All unit tests pass (`PeptideFoxTests`)
- [ ] All UI tests pass (`PeptideFoxUITests`)
- [ ] Code coverage >70% overall, >90% for engines
- [ ] New features have corresponding tests
- [ ] Snapshot tests updated if UI changed
- [ ] Accessibility tests pass
- [ ] No test warnings or deprecations

---

## Contributing

When adding new features:

1. **Write tests first** (TDD approach) or alongside implementation
2. **Cover happy path and edge cases**
3. **Add UI tests for new user flows**
4. **Update snapshots if UI changed**
5. **Document complex test scenarios**

---

**Last Updated**: October 2025  
**Test Framework**: XCTest, swift-snapshot-testing  
**Minimum iOS Version**: iOS 17.0  
**Xcode Version**: 15.0+
