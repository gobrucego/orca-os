//
//  TestHelpers.swift
//  PeptideFoxTests
//
//  Common test utilities and helpers
//

import Foundation
@testable import PeptideFox

// MARK: - Test Data Builders

struct TestDataBuilder {
    
    /// Create standard calculator input for testing
    static func standardCalculatorInput() -> CalculatorInput {
        return CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
    }
    
    /// Create calculator input with custom values
    static func calculatorInput(
        vialSize: Double = 10.0,
        reconstitutionVolume: Double = 2.0,
        targetDose: Double = 0.25,
        intervalDays: Int = 7,
        pattern: String = "weekly"
    ) -> CalculatorInput {
        return CalculatorInput(
            vialSize: vialSize,
            reconstitutionVolume: reconstitutionVolume,
            targetDose: targetDose,
            frequency: FrequencySchedule(
                intervalDays: intervalDays,
                injectionsPerWeek: intervalDays == 1 ? 7 : (intervalDays == 7 ? 1 : 2),
                pattern: pattern
            )
        )
    }
    
    /// Create standard frequency schedule
    static func weeklyFrequency() -> FrequencySchedule {
        return FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
    }
    
    static func dailyFrequency() -> FrequencySchedule {
        return FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
    }
    
    static func twiceWeeklyFrequency() -> FrequencySchedule {
        return FrequencySchedule(intervalDays: 3, injectionsPerWeek: 2, pattern: "twice-weekly")
    }
    
    /// Create test device
    static func standardDevice(type: DeviceType = .syringe50) -> Device {
        switch type {
        case .pen:
            return Device(
                type: .pen,
                name: "Insulin Pen",
                maxVolume: 0.5,
                precision: 0.01,
                units: "clicks",
                maxUnits: 50,
                image: "/devices/pen.svg"
            )
        case .syringe30:
            return Device(
                type: .syringe30,
                name: "30-Unit Syringe",
                maxVolume: 0.3,
                precision: 0.01,
                units: "units",
                maxUnits: 30,
                image: "/devices/syringe-30.svg"
            )
        case .syringe50:
            return Device(
                type: .syringe50,
                name: "50-Unit Syringe",
                maxVolume: 0.5,
                precision: 0.01,
                units: "units",
                maxUnits: 50,
                image: "/devices/syringe-50.svg"
            )
        case .syringe100:
            return Device(
                type: .syringe100,
                name: "100-Unit Syringe",
                maxVolume: 1.0,
                precision: 0.02,
                units: "units",
                maxUnits: 100,
                image: "/devices/syringe-100.svg"
            )
        }
    }
}

// MARK: - Assertion Helpers

extension XCTestCase {
    
    /// Assert that a value is within a percentage tolerance
    func XCTAssertApproximatelyEqual(
        _ actual: Double,
        _ expected: Double,
        percentTolerance: Double = 1.0,
        _ message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let tolerance = abs(expected * percentTolerance / 100.0)
        let difference = abs(actual - expected)
        
        XCTAssertLessThanOrEqual(
            difference,
            tolerance,
            "\(message)\nExpected \(expected) ± \(percentTolerance)%, got \(actual) (difference: \(difference))",
            file: file,
            line: line
        )
    }
    
    /// Assert async throws specific error type
    func XCTAssertAsyncThrows<T, E: Error>(
        _ expression: @autoclosure () async throws -> T,
        errorType: E.Type,
        _ message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected error of type \(errorType) to be thrown", file: file, line: line)
        } catch is E {
            // Expected error type
        } catch {
            XCTFail("Expected error of type \(errorType), got \(type(of: error))", file: file, line: line)
        }
    }
}

// MARK: - Mock Data

struct MockPeptideData {
    static let semaglutide = Peptide(
        id: "test-semaglutide",
        name: "Test Semaglutide",
        category: .glp1,
        description: "Test GLP-1 peptide",
        mechanism: "Test mechanism",
        benefits: ["Weight loss", "Improved glycemic control"],
        typicalDose: DoseRange(min: 0.25, max: 2.4, unit: "mg"),
        frequency: "Weekly",
        cycleLength: "Ongoing",
        contraindications: ["Test contraindication"],
        signals: ["Test signal"],
        synergies: [],
        evidenceLevel: .high
    )
    
    static let bpc157 = Peptide(
        id: "test-bpc157",
        name: "Test BPC-157",
        category: .healing,
        description: "Test healing peptide",
        mechanism: "Test mechanism",
        benefits: ["Accelerated healing"],
        typicalDose: DoseRange(min: 250, max: 1000, unit: "mcg"),
        frequency: "Daily",
        cycleLength: "4-8 weeks",
        contraindications: [],
        signals: ["Reduced pain within 1-2 weeks"],
        synergies: ["tb-500"],
        evidenceLevel: .moderate
    )
}

// MARK: - Performance Testing

extension XCTestCase {
    
    /// Measure performance with custom metrics
    func measurePerformance(
        iterations: Int = 100,
        warmup: Int = 10,
        operation: () -> Void
    ) {
        // Warmup
        for _ in 0..<warmup {
            operation()
        }
        
        // Actual measurement
        measure {
            for _ in 0..<iterations {
                operation()
            }
        }
    }
    
    /// Measure async performance
    func measureAsyncPerformance(
        iterations: Int = 100,
        warmup: Int = 10,
        operation: @escaping () async -> Void
    ) async {
        // Warmup
        for _ in 0..<warmup {
            await operation()
        }
        
        // Actual measurement
        let start = Date()
        for _ in 0..<iterations {
            await operation()
        }
        let duration = Date().timeIntervalSince(start)
        
        print("Average time per iteration: \(duration / Double(iterations) * 1000)ms")
    }
}

// MARK: - UI Test Helpers

#if canImport(XCTest)
import XCTest

extension XCUIElement {
    
    /// Wait for element to exist and be hittable
    func waitForHittable(timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "exists == true AND hittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    /// Tap element after waiting for it to exist
    func tapAfterWaiting(timeout: TimeInterval = 5, file: StaticString = #filePath, line: UInt = #line) {
        guard waitForExistence(timeout: timeout) else {
            XCTFail("Element \(self) did not exist after \(timeout)s", file: file, line: line)
            return
        }
        tap()
    }
    
    /// Type text after clearing existing text
    func clearAndTypeText(_ text: String) {
        guard let stringValue = self.value as? String else {
            self.typeText(text)
            return
        }
        
        // Clear existing text
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}

extension XCTestCase {
    
    /// Helper to perform calculator input in UI tests
    func performCalculatorInput(
        app: XCUIApplication,
        vialSize: String,
        reconVolume: String,
        targetDose: String,
        frequency: String = "Weekly"
    ) {
        let vialField = app.textFields["Vial Size"]
        if vialField.waitForExistence(timeout: 3) {
            vialField.tap()
            vialField.typeText(vialSize)
        }
        
        let reconField = app.textFields["Reconstitution Volume"]
        if reconField.exists {
            reconField.tap()
            reconField.typeText(reconVolume)
        }
        
        let doseField = app.textFields["Target Dose"]
        if doseField.exists {
            doseField.tap()
            doseField.typeText(targetDose)
        }
        
        let frequencyButton = app.buttons[frequency]
        if frequencyButton.exists {
            frequencyButton.tap()
        }
    }
}
#endif
