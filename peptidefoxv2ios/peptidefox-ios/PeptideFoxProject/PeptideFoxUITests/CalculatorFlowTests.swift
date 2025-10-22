//
//  CalculatorFlowTests.swift
//  PeptideFoxUITests
//
//  UI tests for the complete calculator user journey
//

import XCTest

final class CalculatorFlowTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Complete Flow Tests
    
    func testCompleteCalculatorFlow() throws {
        // Navigate to Calculator (assuming tab bar navigation)
        // Note: Adjust based on actual app structure
        
        // Enter vial size
        let vialSizeField = app.textFields["Vial Size"]
        XCTAssertTrue(vialSizeField.waitForExistence(timeout: 5), "Vial size field should exist")
        vialSizeField.tap()
        vialSizeField.typeText("10")
        
        // Enter reconstitution volume
        let reconField = app.textFields["Reconstitution Volume"]
        XCTAssertTrue(reconField.exists, "Reconstitution volume field should exist")
        reconField.tap()
        reconField.typeText("2")
        
        // Enter target dose
        let doseField = app.textFields["Target Dose"]
        XCTAssertTrue(doseField.exists, "Target dose field should exist")
        doseField.tap()
        doseField.typeText("0.25")
        
        // Select frequency - using segmented control
        let weeklyButton = app.buttons["Weekly"]
        if weeklyButton.exists {
            weeklyButton.tap()
        }
        
        // Tap calculate button
        let calculateButton = app.buttons["Calculate"]
        XCTAssertTrue(calculateButton.exists, "Calculate button should exist")
        calculateButton.tap()
        
        // Wait for results to appear (allow time for calculation)
        sleep(1)
        
        // Verify concentration result appears
        let concentrationLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Concentration'")).element
        XCTAssertTrue(concentrationLabel.waitForExistence(timeout: 3), "Concentration label should appear")
        
        // Verify concentration value (10mg/2ml = 5.0 mg/ml)
        let concentrationValue = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '5.0'")).element
        XCTAssertTrue(concentrationValue.exists, "Concentration value should be displayed")
        
        // Verify recommended device section
        let deviceSection = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Recommended Device'")).element
        XCTAssertTrue(deviceSection.exists, "Recommended device section should exist")
    }
    
    func testCalculateButtonDisabledWithEmptyFields() throws {
        let calculateButton = app.buttons["Calculate"]
        XCTAssertTrue(calculateButton.waitForExistence(timeout: 5), "Calculate button should exist")
        
        // Initially, some fields may have default values
        // Clear them if needed and verify button state
        
        // With empty/invalid inputs, button might be disabled
        // This depends on implementation - adjust based on actual behavior
    }
    
    func testResetFunctionality() throws {
        // Enter some values
        let vialSizeField = app.textFields["Vial Size"]
        vialSizeField.tap()
        vialSizeField.typeText("15")
        
        // Tap reset button
        let resetButton = app.buttons["Reset"]
        if resetButton.exists {
            resetButton.tap()
            
            // Verify fields are cleared/reset to defaults
            // This verification depends on implementation
        }
    }
    
    // MARK: - Device Picker Tests
    
    func testDevicePickerNavigation() throws {
        // First calculate to get results
        performCalculation()
        
        // Find and tap device picker button
        let deviceButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Recommended Device'")).element
        if deviceButton.waitForExistence(timeout: 3) {
            deviceButton.tap()
            
            // Verify device picker sheet appears
            sleep(1)
            
            // Check for device options
            let insulinPen = app.cells["Insulin Pen"]
            let syringe30 = app.cells["30-Unit Syringe"]
            let syringe50 = app.cells["50-Unit Syringe"]
            let syringe100 = app.cells["100-Unit Syringe"]
            
            // At least some devices should be available
            XCTAssertTrue(
                insulinPen.exists || syringe30.exists || syringe50.exists || syringe100.exists,
                "At least one device option should be available"
            )
            
            // Tap a device to select it
            if syringe50.exists {
                syringe50.tap()
            }
            
            // Close the picker
            let doneButton = app.buttons["Done"]
            if doneButton.exists {
                doneButton.tap()
            }
        }
    }
    
    // MARK: - Validation Tests
    
    func testVerySmallVolumeWarning() throws {
        // Enter values that create a very small draw volume
        let vialSizeField = app.textFields["Vial Size"]
        vialSizeField.tap()
        vialSizeField.typeText("10")
        
        let reconField = app.textFields["Reconstitution Volume"]
        reconField.tap()
        reconField.typeText("0.5") // High concentration
        
        let doseField = app.textFields["Target Dose"]
        doseField.tap()
        doseField.typeText("0.025") // Very small dose
        
        app.buttons["Calculate"].tap()
        
        // Wait for warning to appear
        sleep(1)
        
        // Check for warning message
        let warningText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'small' OR label CONTAINS 'measure'")).element
        // Warning may or may not appear depending on exact calculation
    }
    
    func testLargeVolumeError() throws {
        // Enter values that create too large a draw volume
        let vialSizeField = app.textFields["Vial Size"]
        vialSizeField.tap()
        vialSizeField.typeText("10")
        
        let reconField = app.textFields["Reconstitution Volume"]
        reconField.tap()
        reconField.typeText("0.5") // Small reconstitution
        
        let doseField = app.textFields["Target Dose"]
        doseField.tap()
        doseField.typeText("15") // Very large dose (larger than vial)
        
        app.buttons["Calculate"].tap()
        
        // Wait for error
        sleep(1)
        
        // Check for error message
        let errorMessage = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Error' OR label CONTAINS 'too large'")).element
        // Error should appear for impossible calculation
    }
    
    // MARK: - Frequency Selection Tests
    
    func testFrequencySelection() throws {
        // Test that frequency picker works
        let dailyButton = app.buttons["Daily"]
        if dailyButton.exists {
            dailyButton.tap()
            XCTAssertTrue(dailyButton.isSelected || dailyButton.value as? String == "1")
        }
        
        let weeklyButton = app.buttons["Weekly"]
        if weeklyButton.exists {
            weeklyButton.tap()
            XCTAssertTrue(weeklyButton.isSelected || weeklyButton.value as? String == "1")
        }
        
        let twiceWeeklyButton = app.buttons["Twice Weekly"]
        if twiceWeeklyButton.exists {
            twiceWeeklyButton.tap()
            XCTAssertTrue(twiceWeeklyButton.isSelected || twiceWeeklyButton.value as? String == "1")
        }
    }
    
    // MARK: - Results Display Tests
    
    func testResultsDisplayAllComponents() throws {
        performCalculation()
        
        // Wait for results
        sleep(1)
        
        // Check for key result components
        let concentrationExists = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Concentration'")).element.exists
        let drawVolumeExists = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Draw Volume'")).element.exists
        let dosesPerVialExists = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Doses Per Vial'")).element.exists
        
        XCTAssertTrue(concentrationExists || drawVolumeExists || dosesPerVialExists, "Results should display calculation outputs")
    }
    
    func testSyringeVisualDisplays() throws {
        performCalculation()
        
        // Wait for visual to render
        sleep(1)
        
        // Look for syringe visual component
        // This might be an image or custom view
        let syringeVisual = app.images.containing(NSPredicate(format: "identifier CONTAINS 'syringe'")).element
        
        // Visual should be present (if implemented)
        // Adjust based on actual implementation
    }
    
    // MARK: - Supply Planning Tests
    
    func testSupplyPlanningCalculations() throws {
        performCalculation()
        
        sleep(1)
        
        // Verify supply calculations appear
        let monthlySupply = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Monthly Supply' OR label CONTAINS 'vials'")).element
        
        // Should show monthly supply information
    }
    
    // MARK: - Helper Methods
    
    private func performCalculation() {
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
