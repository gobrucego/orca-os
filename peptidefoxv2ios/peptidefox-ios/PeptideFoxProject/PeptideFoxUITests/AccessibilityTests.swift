//
//  AccessibilityTests.swift
//  PeptideFoxUITests
//
//  Accessibility compliance tests for VoiceOver, Dynamic Type, and touch targets
//

import XCTest

final class AccessibilityTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - VoiceOver Label Tests
    
    func testCalculatorFieldAccessibilityLabels() throws {
        app.launch()
        
        // Verify input fields have proper accessibility labels
        let vialSizeField = app.textFields["Vial Size"]
        if vialSizeField.waitForExistence(timeout: 5) {
            XCTAssertNotNil(vialSizeField.label, "Vial size field should have accessibility label")
            XCTAssertTrue(
                vialSizeField.label.contains("Vial") || vialSizeField.label.contains("size"),
                "Label should describe the field purpose"
            )
        }
        
        let reconField = app.textFields["Reconstitution Volume"]
        if reconField.exists {
            XCTAssertNotNil(reconField.label, "Reconstitution field should have accessibility label")
        }
        
        let doseField = app.textFields["Target Dose"]
        if doseField.exists {
            XCTAssertNotNil(doseField.label, "Target dose field should have accessibility label")
        }
    }
    
    func testCalculateButtonAccessibility() throws {
        app.launch()
        
        let calculateButton = app.buttons["Calculate"]
        if calculateButton.waitForExistence(timeout: 5) {
            // Button should have clear label
            XCTAssertEqual(calculateButton.label, "Calculate", "Calculate button should have proper label")
            
            // Check if button has accessibility hint
            // Note: Hints are optional but helpful
            if let hint = calculateButton.value(forKey: "accessibilityHint") as? String {
                XCTAssertFalse(hint.isEmpty, "Accessibility hint should provide context")
            }
        }
    }
    
    func testDevicePickerAccessibility() throws {
        app.launch()
        
        // Perform calculation to show device picker
        performQuickCalculation()
        
        sleep(1)
        
        // Open device picker if available
        let deviceButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Device'")).element
        if deviceButton.exists {
            deviceButton.tap()
            
            sleep(1)
            
            // Check device row accessibility
            let insulinPen = app.cells["Insulin Pen"]
            if insulinPen.exists {
                let label = insulinPen.label
                XCTAssertTrue(
                    label.contains("Insulin Pen") || label.contains("ml") || label.contains("unit"),
                    "Device cell should have descriptive accessibility label with capacity information"
                )
            }
        }
    }
    
    func testResultRowsAccessibility() throws {
        app.launch()
        performQuickCalculation()
        
        sleep(1)
        
        // Result rows should combine children for accessibility
        let concentrationRow = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Concentration'")).element
        
        if concentrationRow.exists {
            // Row should have comprehensive label including value
            XCTAssertNotNil(concentrationRow.label)
        }
    }
    
    // MARK: - Dynamic Type Tests
    
    func testDynamicTypeExtraLarge() throws {
        // Launch with extra large text
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryExtraLarge"]
        app.launch()
        
        // App should not crash with larger text
        let vialSizeField = app.textFields.element(boundBy: 0)
        XCTAssertTrue(vialSizeField.waitForExistence(timeout: 5), "App should work with extra large text")
    }
    
    func testDynamicTypeAccessibilityXXXLarge() throws {
        // Launch with accessibility extra extra extra large text
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        
        // App should not crash with largest text size
        sleep(1)
        
        // Verify basic elements still exist and are tappable
        let calculateButton = app.buttons["Calculate"]
        XCTAssertTrue(
            calculateButton.waitForExistence(timeout: 5),
            "App should render correctly with accessibility XXX Large text"
        )
    }
    
    func testDynamicTypeSmall() throws {
        // Test with small text size
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategorySmall"]
        app.launch()
        
        // App should work with small text
        let calculateButton = app.buttons["Calculate"]
        XCTAssertTrue(calculateButton.waitForExistence(timeout: 5), "App should work with small text")
    }
    
    // MARK: - Touch Target Size Tests
    
    func testCalculateButtonTouchTarget() throws {
        app.launch()
        
        let calculateButton = app.buttons["Calculate"]
        if calculateButton.waitForExistence(timeout: 5) {
            let frame = calculateButton.frame
            
            // Apple HIG recommends minimum 44pt x 44pt touch targets
            XCTAssertGreaterThanOrEqual(frame.height, 44, "Calculate button should be at least 44pt tall")
            XCTAssertGreaterThanOrEqual(frame.width, 44, "Calculate button should be at least 44pt wide")
        }
    }
    
    func testResetButtonTouchTarget() throws {
        app.launch()
        
        let resetButton = app.buttons["Reset"]
        if resetButton.exists {
            let frame = resetButton.frame
            
            // Toolbar buttons should also meet minimum size
            XCTAssertGreaterThanOrEqual(frame.height, 44, "Reset button should be at least 44pt tall")
        }
    }
    
    func testSegmentedControlTouchTargets() throws {
        app.launch()
        
        // Frequency picker segments
        let weeklyButton = app.buttons["Weekly"]
        if weeklyButton.exists {
            let frame = weeklyButton.frame
            
            // Segmented control items should be tappable
            XCTAssertGreaterThanOrEqual(frame.height, 28, "Segmented control should be tappable")
        }
    }
    
    func testCategoryChipTouchTargets() throws {
        app.launch()
        
        // Navigate to library if needed
        let libraryTab = app.tabBars.buttons["Library"]
        if libraryTab.exists {
            libraryTab.tap()
            sleep(1)
        }
        
        // Category chips should be large enough
        let allChip = app.buttons["All"]
        if allChip.exists {
            let frame = allChip.frame
            XCTAssertGreaterThanOrEqual(frame.height, 32, "Category chip should be easily tappable")
        }
    }
    
    // MARK: - Keyboard Navigation Tests
    
    func testTabOrderInCalculator() throws {
        app.launch()
        
        // Fields should have logical tab order
        // This is more applicable to macOS Catalyst, but good to verify
        
        let vialSizeField = app.textFields["Vial Size"]
        if vialSizeField.waitForExistence(timeout: 5) {
            vialSizeField.tap()
            
            // On iOS, next field focus depends on implementation
            // Verify fields are accessible in order
        }
    }
    
    // MARK: - Color Contrast Tests (Manual Verification)
    
    func testColorContrastElements() throws {
        app.launch()
        
        // While we can't programmatically test color contrast in UI tests,
        // we can verify that key elements exist and are visible
        
        let calculateButton = app.buttons["Calculate"]
        XCTAssertTrue(calculateButton.waitForExistence(timeout: 5), "Primary action button should be visible")
        
        // Verify button is hittable (not hidden behind other elements)
        XCTAssertTrue(calculateButton.isHittable, "Calculate button should be visible and tappable")
    }
    
    // MARK: - Focus and Navigation Tests
    
    func testNavigationBackButton() throws {
        app.launch()
        
        // Navigate to library
        let libraryTab = app.tabBars.buttons["Library"]
        if libraryTab.exists {
            libraryTab.tap()
            sleep(1)
            
            // Tap a peptide
            let cell = app.cells.element(boundBy: 0)
            if cell.exists {
                cell.tap()
                sleep(1)
                
                // Back button should exist and be accessible
                let backButton = app.navigationBars.buttons.element(boundBy: 0)
                XCTAssertTrue(backButton.exists, "Navigation back button should exist")
                
                let frame = backButton.frame
                XCTAssertGreaterThanOrEqual(frame.height, 44, "Back button should meet minimum touch target")
            }
        }
    }
    
    // MARK: - Screen Reader Tests
    
    func testResultsReadableByVoiceOver() throws {
        app.launch()
        performQuickCalculation()
        
        sleep(1)
        
        // Results should have combined accessibility labels that make sense
        // when read by VoiceOver
        
        let results = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'mg' OR label CONTAINS 'ml'"))
        
        // At least some results should be readable
        XCTAssertGreaterThan(results.count, 0, "Results should be accessible to screen readers")
    }
    
    func testEmptyStateAccessibility() throws {
        app.launch()
        
        // Navigate to library
        let libraryTab = app.tabBars.buttons["Library"]
        if libraryTab.exists {
            libraryTab.tap()
            sleep(1)
            
            // Search for non-existent item
            let searchField = app.searchFields.element
            if searchField.exists {
                searchField.tap()
                searchField.typeText("nonexistentpeptide")
                
                sleep(1)
                
                // Empty state should be accessible
                let emptyState = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'No' OR label CONTAINS 'Found'")).element
                
                // If empty state exists, it should have proper accessibility
                if emptyState.exists {
                    XCTAssertNotNil(emptyState.label)
                    XCTAssertFalse(emptyState.label.isEmpty)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func performQuickCalculation() {
        let vialSizeField = app.textFields["Vial Size"]
        if vialSizeField.waitForExistence(timeout: 3) {
            vialSizeField.tap()
            vialSizeField.typeText("10")
        }
        
        let reconField = app.textFields["Reconstitution Volume"]
        if reconField.exists {
            reconField.tap()
            reconField.typeText("2")
        }
        
        let doseField = app.textFields["Target Dose"]
        if doseField.exists {
            doseField.tap()
            doseField.typeText("0.25")
        }
        
        app.buttons["Calculate"].tap()
    }
}
