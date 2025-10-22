//
//  CalculatorEngineTests.swift
//  PeptideFoxTests
//
//  Unit tests for CalculatorEngine actor
//

import XCTest
@testable import PeptideFox

final class CalculatorEngineTests: XCTestCase {
    var calculator: CalculatorEngine!
    
    override func setUpWithError() throws {
        calculator = CalculatorEngine()
    }
    
    override func tearDownWithError() throws {
        calculator = nil
    }
    
    // MARK: - Basic Calculation Tests
    
    func testBasicConcentrationCalculation() async throws {
        // Test: 10mg vial in 2ml water = 5mg/ml
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        let output = try await calculator.calculate(input: input)
        
        XCTAssertEqual(output.concentration, 5.0, accuracy: 0.001, "Concentration should be 5.0 mg/ml")
    }
    
    func testDrawVolumeCalculation() async throws {
        // Test: 0.25mg dose at 5mg/ml = 0.05ml draw volume
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        let output = try await calculator.calculate(input: input)
        
        XCTAssertEqual(output.drawVolume, 0.05, accuracy: 0.001, "Draw volume should be 0.05 ml")
    }
    
    func testDosesPerVial() async throws {
        // Test: 10mg vial / 0.25mg dose = 40 doses
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        let output = try await calculator.calculate(input: input)
        
        XCTAssertEqual(output.dosesPerVial, 40, "Should get 40 doses from 10mg vial with 0.25mg doses")
    }
    
    func testDaysPerVialWeekly() async throws {
        // Test: 40 doses × 7 days/dose = 280 days per vial
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        let output = try await calculator.calculate(input: input)
        
        XCTAssertEqual(output.daysPerVial, 280, "40 doses × 7 days = 280 days")
    }
    
    func testDaysPerVialDaily() async throws {
        // Test: 40 doses × 1 day/dose = 40 days per vial
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        )
        
        let output = try await calculator.calculate(input: input)
        
        XCTAssertEqual(output.daysPerVial, 40, "40 doses × 1 day = 40 days")
    }
    
    func testVialsPerMonthWeekly() async throws {
        // Test: 30 days / 280 days per vial = 1 vial (ceil)
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        let output = try await calculator.calculate(input: input)
        
        XCTAssertEqual(output.vialsPerMonth, 1, "Should need 1 vial per month for weekly dosing")
    }
    
    func testVialsPerMonthDaily() async throws {
        // Test: 30 days / 40 days per vial = 1 vial (ceil)
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        )
        
        let output = try await calculator.calculate(input: input)
        
        XCTAssertEqual(output.vialsPerMonth, 1, "Should need 1 vial per month for daily dosing at 0.25mg")
    }
    
    // MARK: - Device Compatibility Tests
    
    func testSmallVolumeCompatibleDevices() async throws {
        // Test: 0.05ml should be compatible with all devices
        let compatibleDevices = await calculator.getCompatibleDevices(volume: 0.05)
        
        XCTAssertGreaterThan(compatibleDevices.count, 0, "Small volume should be compatible with at least one device")
        XCTAssertTrue(
            compatibleDevices.contains(where: { $0.type == .syringe30 }),
            "0.05ml should be compatible with 30-unit syringe"
        )
    }
    
    func testMediumVolumeCompatibleDevices() async throws {
        // Test: 0.25ml should be compatible with 30, 50, 100 unit syringes and pen
        let compatibleDevices = await calculator.getCompatibleDevices(volume: 0.25)
        
        XCTAssertGreaterThan(compatibleDevices.count, 0, "Medium volume should be compatible with multiple devices")
    }
    
    func testLargeVolumeCompatibleDevices() async throws {
        // Test: 0.9ml should only be compatible with 100-unit syringe
        let compatibleDevices = await calculator.getCompatibleDevices(volume: 0.9)
        
        XCTAssertTrue(
            compatibleDevices.contains(where: { $0.type == .syringe100 }),
            "0.9ml should be compatible with 100-unit syringe"
        )
        XCTAssertFalse(
            compatibleDevices.contains(where: { $0.type == .syringe30 }),
            "0.9ml should not be compatible with 30-unit syringe"
        )
    }
    
    func testVolumeTooLargeError() async throws {
        // Test: Volume larger than any device should throw error
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 0.1, // Very small reconstitution
            targetDose: 2.0, // Large dose = 2ml draw volume
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        do {
            _ = try await calculator.calculate(input: input)
            XCTFail("Should throw volumeTooLarge error")
        } catch let error as CalculatorError {
            if case .volumeTooLarge = error {
                // Expected error
                XCTAssertTrue(true)
            } else {
                XCTFail("Should throw volumeTooLarge, got different error")
            }
        }
    }
    
    // MARK: - Unit Conversion Tests
    
    func testMLToUnits30UnitSyringe() async throws {
        let device = Device(
            type: .syringe30,
            name: "30-Unit Syringe",
            maxVolume: 0.3,
            precision: 0.01,
            units: "units",
            maxUnits: 30,
            image: "/devices/syringe-30.svg"
        )
        
        let units = await calculator.mlToUnits(ml: 0.1, device: device)
        
        XCTAssertEqual(units, 10.0, accuracy: 0.1, "0.1ml should be 10 units on 30-unit syringe")
    }
    
    func testMLToUnits50UnitSyringe() async throws {
        let device = Device(
            type: .syringe50,
            name: "50-Unit Syringe",
            maxVolume: 0.5,
            precision: 0.01,
            units: "units",
            maxUnits: 50,
            image: "/devices/syringe-50.svg"
        )
        
        let units = await calculator.mlToUnits(ml: 0.25, device: device)
        
        XCTAssertEqual(units, 25.0, accuracy: 0.1, "0.25ml should be 25 units on 50-unit syringe")
    }
    
    func testMLToUnits100UnitSyringe() async throws {
        let device = Device(
            type: .syringe100,
            name: "100-Unit Syringe",
            maxVolume: 1.0,
            precision: 0.02,
            units: "units",
            maxUnits: 100,
            image: "/devices/syringe-100.svg"
        )
        
        let units = await calculator.mlToUnits(ml: 0.5, device: device)
        
        XCTAssertEqual(units, 50.0, accuracy: 0.1, "0.5ml should be 50 units on 100-unit syringe")
    }
    
    // MARK: - Validation Tests
    
    func testInvalidVialSizeZero() async throws {
        let input = CalculatorInput(
            vialSize: 0.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        do {
            _ = try await calculator.calculate(input: input)
            XCTFail("Should throw invalidInput error for zero vial size")
        } catch let error as CalculatorError {
            if case .invalidInput = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Should throw invalidInput error")
            }
        }
    }
    
    func testInvalidReconstitutionVolumeZero() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 0.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        do {
            _ = try await calculator.calculate(input: input)
            XCTFail("Should throw invalidInput error for zero reconstitution volume")
        } catch let error as CalculatorError {
            if case .invalidInput = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Should throw invalidInput error")
            }
        }
    }
    
    func testInvalidTargetDoseZero() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.0,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        do {
            _ = try await calculator.calculate(input: input)
            XCTFail("Should throw invalidInput error for zero target dose")
        } catch let error as CalculatorError {
            if case .invalidInput = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Should throw invalidInput error")
            }
        }
    }
    
    // MARK: - Warning Tests
    
    func testVerySmallVolumeWarning() async throws {
        let warnings = await calculator.checkWarnings(drawVolume: 0.02)
        
        XCTAssertTrue(
            warnings.contains(where: { $0.contains("small") || $0.contains("measure") }),
            "Should warn about very small volume"
        )
    }
    
    func testLargeVolumeWarning() async throws {
        let warnings = await calculator.checkWarnings(drawVolume: 0.9)
        
        XCTAssertTrue(
            warnings.contains(where: { $0.contains("Large") || $0.contains("split") }),
            "Should warn about large injection volume"
        )
    }
    
    func testNormalVolumeNoWarnings() async throws {
        let warnings = await calculator.checkWarnings(drawVolume: 0.25)
        
        XCTAssertTrue(warnings.isEmpty, "Normal volume should have no warnings")
    }
    
    // MARK: - Edge Case Tests
    
    func testVeryHighConcentration() async throws {
        // Test: 10mg in 0.1ml = 100mg/ml (very high concentration)
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 0.1,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        let output = try await calculator.calculate(input: input)
        
        XCTAssertEqual(output.concentration, 100.0, accuracy: 0.1, "High concentration should be calculated correctly")
        XCTAssertLessThan(output.drawVolume, 0.01, "Draw volume should be very small")
    }
    
    func testVeryLowConcentration() async throws {
        // Test: 1mg in 10ml = 0.1mg/ml (very low concentration)
        let input = CalculatorInput(
            vialSize: 1.0,
            reconstitutionVolume: 10.0,
            targetDose: 0.1,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        )
        
        let output = try await calculator.calculate(input: input)
        
        XCTAssertEqual(output.concentration, 0.1, accuracy: 0.01, "Low concentration should be calculated correctly")
    }
}
