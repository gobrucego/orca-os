import XCTest
@testable import PeptideFox

/// Comprehensive tests for CalculatorEngine
/// Validates calculation accuracy, device compatibility, and edge cases
final class CalculatorEngineTests: XCTestCase {
    
    var engine: CalculatorEngine!
    
    override func setUp() async throws {
        engine = CalculatorEngine()
    }
    
    override func tearDown() async throws {
        engine = nil
    }
    
    // MARK: - Core Calculation Tests
    
    func testBasicConcentrationCalculation() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Concentration = 10mg / 2ml = 5mg/ml
        XCTAssertEqual(result.concentration, 5.0, accuracy: 0.001)
        
        // DrawVolume = 0.25mg / 5mg/ml = 0.05ml
        XCTAssertEqual(result.drawVolume, 0.05, accuracy: 0.001)
    }
    
    func testSemaglutideTypicalDose() async throws {
        // Typical semaglutide setup: 5mg vial, 2ml reconstitution, 0.5mg dose
        let input = CalculatorInput(
            vialSize: 5.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.5,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Concentration = 5mg / 2ml = 2.5mg/ml
        XCTAssertEqual(result.concentration, 2.5, accuracy: 0.001)
        
        // DrawVolume = 0.5mg / 2.5mg/ml = 0.2ml
        XCTAssertEqual(result.drawVolume, 0.2, accuracy: 0.001)
        
        // DrawUnits = 0.2ml * 100 = 20 units
        XCTAssertEqual(result.drawUnits, 20.0, accuracy: 0.1)
    }
    
    func testTirzepatideTypicalDose() async throws {
        // Typical tirzepatide: 10mg vial, 2ml water, 5mg dose
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 5.0,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Concentration = 10mg / 2ml = 5mg/ml
        XCTAssertEqual(result.concentration, 5.0, accuracy: 0.001)
        
        // DrawVolume = 5mg / 5mg/ml = 1.0ml
        XCTAssertEqual(result.drawVolume, 1.0, accuracy: 0.001)
    }
    
    func testBPC157TypicalDose() async throws {
        // BPC-157: 5mg vial, 2ml water, 0.25mg dose
        let input = CalculatorInput(
            vialSize: 5.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Concentration = 5mg / 2ml = 2.5mg/ml
        XCTAssertEqual(result.concentration, 2.5, accuracy: 0.001)
        
        // DrawVolume = 0.25mg / 2.5mg/ml = 0.1ml
        XCTAssertEqual(result.drawVolume, 0.1, accuracy: 0.001)
        
        // DrawUnits = 0.1ml * 100 = 10 units
        XCTAssertEqual(result.drawUnits, 10.0, accuracy: 0.1)
    }
    
    // MARK: - Device Compatibility Tests
    
    func testGetCompatibleDevices_SmallVolume() async throws {
        // 0.05ml should work with all devices
        let devices = await engine.getCompatibleDevices(volume: 0.05)
        XCTAssertEqual(devices.count, 4)
    }
    
    func testGetCompatibleDevices_MediumVolume() async throws {
        // 0.4ml should work with pen, syringe50, and syringe100
        let devices = await engine.getCompatibleDevices(volume: 0.4)
        XCTAssertEqual(devices.count, 3)
        XCTAssertTrue(devices.contains { $0.type == .pen })
        XCTAssertTrue(devices.contains { $0.type == .syringe50 })
        XCTAssertTrue(devices.contains { $0.type == .syringe100 })
    }
    
    func testGetCompatibleDevices_LargeVolume() async throws {
        // 0.8ml should only work with syringe100
        let devices = await engine.getCompatibleDevices(volume: 0.8)
        XCTAssertEqual(devices.count, 1)
        XCTAssertEqual(devices[0].type, .syringe100)
    }
    
    func testGetCompatibleDevices_TooLarge() async throws {
        // 1.5ml should not work with any device
        let devices = await engine.getCompatibleDevices(volume: 1.5)
        XCTAssertEqual(devices.count, 0)
    }
    
    func testRecommendedDevice_SmallestFirst() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.25,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        let result = try await engine.calculate(input: input)
        
        // 0.05ml draw volume - smallest compatible device should be pen
        XCTAssertEqual(result.recommendedDevice.type, .pen)
    }
    
    // MARK: - Unit Conversion Tests
    
    func testMlToUnits_Syringe30() async throws {
        let device = Device(
            type: .syringe30,
            name: "30-Unit Syringe",
            maxVolume: 0.3,
            precision: 0.01,
            units: "units",
            maxUnits: 30,
            image: "/devices/syringe-30.svg"
        )
        
        let units = await engine.mlToUnits(ml: 0.1, device: device)
        XCTAssertEqual(units, 10.0, accuracy: 0.1)
    }
    
    func testMlToUnits_Syringe50() async throws {
        let device = Device(
            type: .syringe50,
            name: "50-Unit Syringe",
            maxVolume: 0.5,
            precision: 0.01,
            units: "units",
            maxUnits: 50,
            image: "/devices/syringe-50.svg"
        )
        
        let units = await engine.mlToUnits(ml: 0.2, device: device)
        XCTAssertEqual(units, 20.0, accuracy: 0.1)
    }
    
    func testMlToUnits_Syringe100() async throws {
        let device = Device(
            type: .syringe100,
            name: "100-Unit Syringe",
            maxVolume: 1.0,
            precision: 0.02,
            units: "units",
            maxUnits: 100,
            image: "/devices/syringe-100.svg"
        )
        
        let units = await engine.mlToUnits(ml: 0.5, device: device)
        XCTAssertEqual(units, 50.0, accuracy: 0.1)
    }
    
    func testMlToUnits_Pen() async throws {
        let device = Device(
            type: .pen,
            name: "Insulin Pen",
            maxVolume: 0.5,
            precision: 0.01,
            units: "clicks",
            maxUnits: 50,
            image: "/devices/pen.svg"
        )
        
        // 0.2ml = 20 clicks (each click = 0.01ml)
        let units = await engine.mlToUnits(ml: 0.2, device: device)
        XCTAssertEqual(units, 20.0, accuracy: 0.1)
    }
    
    // MARK: - Supply Calculation Tests
    
    func testSupplyCalculation_DailyDosing() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.5, // 0.5mg per dose
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Doses per vial = floor(10mg / 0.5mg) = 20 doses
        XCTAssertEqual(result.dosesPerVial, 20)
        
        // Days per vial = 20 doses * 1 day = 20 days
        XCTAssertEqual(result.daysPerVial, 20)
        
        // Vials per month = ceil(30 / 20) = 2 vials
        XCTAssertEqual(result.vialsPerMonth, 2)
    }
    
    func testSupplyCalculation_WeeklyDosing() async throws {
        let input = CalculatorInput(
            vialSize: 5.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.5,
            frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Doses per vial = floor(5mg / 0.5mg) = 10 doses
        XCTAssertEqual(result.dosesPerVial, 10)
        
        // Days per vial = 10 doses * 7 days = 70 days
        XCTAssertEqual(result.daysPerVial, 70)
        
        // Vials per month = ceil(30 / 70) = 1 vial
        XCTAssertEqual(result.vialsPerMonth, 1)
    }
    
    func testSupplyCalculation_TwiceWeekly() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 1.0,
            frequency: FrequencySchedule(intervalDays: 3, injectionsPerWeek: 2)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Doses per vial = floor(10mg / 1mg) = 10 doses
        XCTAssertEqual(result.dosesPerVial, 10)
        
        // Days per vial = 10 doses * 3 days = 30 days
        XCTAssertEqual(result.daysPerVial, 30)
        
        // Vials per month = ceil(30 / 30) = 1 vial
        XCTAssertEqual(result.vialsPerMonth, 1)
    }
    
    // MARK: - Syringe Visual Tests
    
    func testSyringeVisual_Markings_Pen() async throws {
        let device = Device(
            type: .pen,
            name: "Insulin Pen",
            maxVolume: 0.5,
            precision: 0.01,
            units: "clicks",
            maxUnits: 50,
            image: "/devices/pen.svg"
        )
        
        let visual = await engine.generateSyringeVisual(drawVolume: 0.2, device: device)
        
        // Pen markings should be in steps of 5
        XCTAssertTrue(visual.markings.contains(0))
        XCTAssertTrue(visual.markings.contains(5))
        XCTAssertTrue(visual.markings.contains(10))
        XCTAssertTrue(visual.markings.contains(50))
    }
    
    func testSyringeVisual_Markings_Syringe() async throws {
        let device = Device(
            type: .syringe50,
            name: "50-Unit Syringe",
            maxVolume: 0.5,
            precision: 0.01,
            units: "units",
            maxUnits: 50,
            image: "/devices/syringe-50.svg"
        )
        
        let visual = await engine.generateSyringeVisual(drawVolume: 0.2, device: device)
        
        // Syringe markings should be in steps of 10
        XCTAssertTrue(visual.markings.contains(0))
        XCTAssertTrue(visual.markings.contains(10))
        XCTAssertTrue(visual.markings.contains(20))
        XCTAssertTrue(visual.markings.contains(50))
    }
    
    func testSyringeVisual_SmallVolumeWarning() async throws {
        let device = Device(
            type: .pen,
            name: "Insulin Pen",
            maxVolume: 0.5,
            precision: 0.01,
            units: "clicks",
            maxUnits: 50,
            image: "/devices/pen.svg"
        )
        
        let visual = await engine.generateSyringeVisual(drawVolume: 0.03, device: device)
        
        // Should include "Go slow" instruction for small volumes
        XCTAssertTrue(visual.instructions.contains { $0.contains("Go slow") })
    }
    
    // MARK: - Suggestion Tests
    
    func testSuggestions_SmallVolume() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.1,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Draw volume = 0.1 / 5 = 0.02ml (< 0.05ml)
        XCTAssertTrue(result.suggestions.contains { $0.type == .warning })
        XCTAssertTrue(result.suggestions.contains { $0.title == "Very small volume" })
    }
    
    func testSuggestions_NearPenLimit() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 2.1,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Draw volume = 2.1 / 5 = 0.42ml (> 0.4 and <= 0.5)
        XCTAssertTrue(result.suggestions.contains { $0.type == .info })
        XCTAssertTrue(result.suggestions.contains { $0.title == "Near pen limit" })
    }
    
    func testSuggestions_OptimalReconstitution() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 3.5, // Non-optimal
            targetDose: 0.5,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        let result = try await engine.calculate(input: input)
        
        // Should suggest a more optimal reconstitution volume
        XCTAssertTrue(result.suggestions.contains { $0.type == .optimization })
    }
    
    // MARK: - Warning Tests
    
    func testWarnings_VolumeTooSmall() async throws {
        let warnings = await engine.checkWarnings(drawVolume: 0.02)
        XCTAssertTrue(warnings.contains { $0.contains("too small") })
    }
    
    func testWarnings_VolumeTooLarge() async throws {
        let warnings = await engine.checkWarnings(drawVolume: 0.85)
        XCTAssertTrue(warnings.contains { $0.contains("consider splitting") })
    }
    
    func testWarnings_NormalVolume() async throws {
        let warnings = await engine.checkWarnings(drawVolume: 0.2)
        XCTAssertTrue(warnings.isEmpty)
    }
    
    // MARK: - Error Cases
    
    func testError_VolumeTooLarge() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 0.5, // Very concentrated
            targetDose: 15.0, // Very high dose
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        do {
            _ = try await engine.calculate(input: input)
            XCTFail("Should throw volumeTooLarge error")
        } catch let error as CalculatorError {
            if case .volumeTooLarge(let suggestions) = error {
                XCTAssertFalse(suggestions.isEmpty)
                XCTAssertTrue(error.localizedDescription.contains("too large"))
            } else {
                XCTFail("Wrong error type")
            }
        }
    }
    
    func testError_InvalidVialSize() async throws {
        let input = CalculatorInput(
            vialSize: 0,
            reconstitutionVolume: 2.0,
            targetDose: 0.5,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        do {
            _ = try await engine.calculate(input: input)
            XCTFail("Should throw invalidInput error")
        } catch let error as CalculatorError {
            if case .invalidInput(let message) = error {
                XCTAssertTrue(message.contains("Vial size"))
            } else {
                XCTFail("Wrong error type")
            }
        }
    }
    
    func testError_InvalidReconstitutionVolume() async throws {
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 0,
            targetDose: 0.5,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        do {
            _ = try await engine.calculate(input: input)
            XCTFail("Should throw invalidInput error")
        } catch let error as CalculatorError {
            if case .invalidInput(let message) = error {
                XCTAssertTrue(message.contains("Reconstitution volume"))
            } else {
                XCTFail("Wrong error type")
            }
        }
    }
    
    // MARK: - Optimal Reconstitution Tests
    
    func testOptimalReconstitution_RoundNumbers() async throws {
        let optimal = await engine.calculateOptimalReconstitution(
            vialSize: 10.0,
            targetDose: 0.5
        )
        
        // Should suggest a reconstitution that results in round unit numbers
        XCTAssertGreaterThan(optimal, 0)
        
        // Verify it produces round numbers
        let concentration = 10.0 / optimal
        let drawVolume = 0.5 / concentration
        let units = drawVolume * 100
        
        // Units should be divisible by 5
        XCTAssertEqual(units.truncatingRemainder(dividingBy: 5), 0, accuracy: 0.01)
    }
    
    func testOptimalReconstitution_Fallback() async throws {
        // Edge case where no optimal solution exists
        let optimal = await engine.calculateOptimalReconstitution(
            vialSize: 10.0,
            targetDose: 9.0 // Very high dose
        )
        
        // Should fallback to vialSize / 2
        XCTAssertEqual(optimal, 5.0, accuracy: 0.001)
    }
    
    // MARK: - Property-Based Tests
    
    func testProperty_ConcentrationIsInverse() async throws {
        // Property: concentration * reconstitutionVolume = vialSize
        let vialSizes: [Double] = [5.0, 10.0, 15.0, 30.0]
        let volumes: [Double] = [1.0, 2.0, 3.0, 5.0]
        
        for vialSize in vialSizes {
            for volume in volumes {
                let input = CalculatorInput(
                    vialSize: vialSize,
                    reconstitutionVolume: volume,
                    targetDose: 0.5,
                    frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
                )
                
                let result = try await engine.calculate(input: input)
                let reconstructed = result.concentration * volume
                XCTAssertEqual(reconstructed, vialSize, accuracy: 0.001)
            }
        }
    }
    
    func testProperty_DrawVolumeCalculation() async throws {
        // Property: drawVolume * concentration = targetDose
        let doses: [Double] = [0.25, 0.5, 1.0, 2.5, 5.0]
        
        for dose in doses {
            let input = CalculatorInput(
                vialSize: 10.0,
                reconstitutionVolume: 2.0,
                targetDose: dose,
                frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
            )
            
            let result = try await engine.calculate(input: input)
            let reconstructed = result.drawVolume * result.concentration
            XCTAssertEqual(reconstructed, dose, accuracy: 0.001)
        }
    }
    
    // MARK: - Thread Safety Tests
    
    func testConcurrentAccess() async throws {
        // Test that the actor properly isolates concurrent access
        let input = CalculatorInput(
            vialSize: 10.0,
            reconstitutionVolume: 2.0,
            targetDose: 0.5,
            frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
        )
        
        // Run 100 concurrent calculations
        await withTaskGroup(of: CalculatorOutput?.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    try? await self.engine.calculate(input: input)
                }
            }
            
            var results: [CalculatorOutput] = []
            for await result in group {
                if let result = result {
                    results.append(result)
                }
            }
            
            // All results should be identical
            XCTAssertEqual(results.count, 100)
            for result in results {
                XCTAssertEqual(result.concentration, 5.0, accuracy: 0.001)
                XCTAssertEqual(result.drawVolume, 0.1, accuracy: 0.001)
            }
        }
    }
}
