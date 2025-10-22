import XCTest
@testable import PeptideFox

final class ValidationEngineTests: XCTestCase {
    
    var engine: ValidationEngine!
    
    override func setUp() {
        super.setUp()
        engine = ValidationEngine()
    }
    
    override func tearDown() {
        engine = nil
        super.tearDown()
    }
    
    // MARK: - Max Weekly Dose Tests
    
    func testMaxWeeklyDose_Semaglutide_Violation() {
        // Given: Protocol with Semaglutide exceeding 2.4mg/week
        let protocol = createProtocol(
            peptides: [
                createPeptide(
                    name: "Semaglutide",
                    weeklyTotal: 3.0,
                    unit: .mg
                )
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertFalse(result.valid, "Protocol should be invalid")
        XCTAssertEqual(result.issues.count, 1)
        XCTAssertEqual(result.issues.first?.type, .maxWeeklyDose)
        XCTAssertEqual(result.issues.first?.severity, .error)
        XCTAssertTrue(result.issues.first?.message.contains("2.4mg") ?? false)
    }
    
    func testMaxWeeklyDose_Tirzepatide_Violation() {
        // Given: Protocol with Tirzepatide exceeding 15mg/week
        let protocol = createProtocol(
            peptides: [
                createPeptide(
                    name: "Tirzepatide",
                    weeklyTotal: 16.0,
                    unit: .mg
                )
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertFalse(result.valid)
        XCTAssertEqual(result.issues.count, 1)
        XCTAssertEqual(result.issues.first?.severity, .error)
    }
    
    func testMaxWeeklyDose_Retatrutide_Violation() {
        // Given: Protocol with Retatrutide exceeding 12mg/week
        let protocol = createProtocol(
            peptides: [
                createPeptide(
                    name: "Retatrutide",
                    weeklyTotal: 13.0,
                    unit: .mg
                )
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertFalse(result.valid)
        XCTAssertEqual(result.issues.first?.type, .maxWeeklyDose)
    }
    
    func testMaxWeeklyDose_Tesamorelin_Warning() {
        // Given: Protocol with Tesamorelin exceeding 14mg/week (warning only)
        let protocol = createProtocol(
            peptides: [
                createPeptide(
                    name: "Tesamorelin",
                    weeklyTotal: 15.0,
                    unit: .mg
                )
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertTrue(result.valid, "Should be valid with warning")
        XCTAssertEqual(result.issues.count, 1)
        XCTAssertEqual(result.issues.first?.severity, .warn)
    }
    
    func testMaxWeeklyDose_WithinLimits() {
        // Given: Protocol with safe dosing
        let protocol = createProtocol(
            peptides: [
                createPeptide(
                    name: "Semaglutide",
                    weeklyTotal: 1.0,
                    unit: .mg
                )
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertTrue(result.valid)
        XCTAssertEqual(result.issues.count, 0)
    }
    
    // MARK: - Device Limit Tests
    
    func testDeviceLimit_Pen_Violation() {
        // Given: Pen injection exceeding 0.5ml
        let protocol = createProtocol(
            peptides: [
                createPeptide(
                    name: "TestPeptide",
                    perInjection: 5.0,
                    concentrationMgPerMl: 8.0, // 5mg / 8mg/ml = 0.625ml
                    device: .pen
                )
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertFalse(result.valid)
        XCTAssertEqual(result.issues.count, 1)
        XCTAssertEqual(result.issues.first?.type, .deviceLimit)
        XCTAssertEqual(result.issues.first?.severity, .error)
        XCTAssertTrue(result.issues.first?.message.contains("0.5ml") ?? false)
    }
    
    func testDeviceLimit_InsulinSyringe_Warning() {
        // Given: Insulin syringe exceeding 1.0ml
        let protocol = createProtocol(
            peptides: [
                createPeptide(
                    name: "TestPeptide",
                    perInjection: 10.0,
                    concentrationMgPerMl: 8.0, // 10mg / 8mg/ml = 1.25ml
                    device: .insulinSyringe
                )
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertTrue(result.valid, "Should be valid with warning")
        XCTAssertEqual(result.issues.count, 1)
        XCTAssertEqual(result.issues.first?.severity, .warn)
    }
    
    func testDeviceLimit_WithinLimits() {
        // Given: Safe injection volume
        let protocol = createProtocol(
            peptides: [
                createPeptide(
                    name: "TestPeptide",
                    perInjection: 2.0,
                    concentrationMgPerMl: 5.0, // 2mg / 5mg/ml = 0.4ml
                    device: .pen
                )
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertTrue(result.valid)
        XCTAssertEqual(result.issues.count, 0)
    }
    
    // MARK: - Timing Separation Tests
    
    func testTimingSeparation_Violation() {
        // Given: Tesamorelin and Ipamorelin too close together
        let protocol = createProtocol(
            peptides: [
                createPeptide(name: "Tesamorelin", timeOfDay: .morning),
                createPeptide(name: "Ipamorelin", timeOfDay: .morning)
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertTrue(result.valid, "Should be valid with warning")
        XCTAssertEqual(result.issues.count, 1)
        XCTAssertEqual(result.issues.first?.type, .separation)
        XCTAssertEqual(result.issues.first?.severity, .warn)
        XCTAssertTrue(result.issues.first?.message.contains("3 hours") ?? false)
    }
    
    func testTimingSeparation_Adequate() {
        // Given: Tesamorelin and Ipamorelin properly separated
        let protocol = createProtocol(
            peptides: [
                createPeptide(name: "Tesamorelin", timeOfDay: .morning),
                createPeptide(name: "Ipamorelin", timeOfDay: .evening)
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertTrue(result.valid)
        XCTAssertEqual(result.issues.count, 0)
    }
    
    func testTimingSeparation_CJC1295_Sermorelin() {
        // Given: CJC-1295 and Sermorelin require 12hr separation
        let protocol = createProtocol(
            peptides: [
                createPeptide(name: "CJC-1295", timeOfDay: .morning),
                createPeptide(name: "Sermorelin", timeOfDay: .afternoon)
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertTrue(result.valid, "Should be valid with warning")
        XCTAssertEqual(result.issues.count, 1)
        XCTAssertEqual(result.issues.first?.type, .separation)
        XCTAssertTrue(result.issues.first?.message.contains("12 hours") ?? false)
    }
    
    // MARK: - Drug Interaction Tests
    
    func testInteraction_Semaglutide_Tirzepatide() {
        // Given: Both GLP-1 agonists in protocol
        let protocol = createProtocol(
            peptides: [
                createPeptide(name: "Semaglutide"),
                createPeptide(name: "Tirzepatide")
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertFalse(result.valid)
        XCTAssertEqual(result.issues.count, 1)
        XCTAssertEqual(result.issues.first?.type, .interaction)
        XCTAssertEqual(result.issues.first?.severity, .error)
        XCTAssertTrue(result.issues.first?.message.contains("Do not combine GLP-1 agonists") ?? false)
    }
    
    func testInteraction_Tirzepatide_Retatrutide() {
        // Given: Both GLP-1 agonists in protocol
        let protocol = createProtocol(
            peptides: [
                createPeptide(name: "Tirzepatide"),
                createPeptide(name: "Retatrutide")
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertFalse(result.valid)
        XCTAssertEqual(result.issues.first?.type, .interaction)
    }
    
    func testInteraction_Semaglutide_Retatrutide() {
        // Given: Both GLP-1 agonists in protocol
        let protocol = createProtocol(
            peptides: [
                createPeptide(name: "Semaglutide"),
                createPeptide(name: "Retatrutide")
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertFalse(result.valid)
        XCTAssertEqual(result.issues.first?.type, .interaction)
    }
    
    func testInteraction_NoConflict() {
        // Given: Compatible peptides
        let protocol = createProtocol(
            peptides: [
                createPeptide(name: "Semaglutide"),
                createPeptide(name: "BPC-157")
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertTrue(result.valid)
        XCTAssertEqual(result.issues.count, 0)
    }
    
    // MARK: - Hash Determinism Tests
    
    func testProtocolHash_Deterministic() {
        // Given: Same protocol created twice
        let protocol1 = createProtocol(
            peptides: [createPeptide(name: "TestPeptide")]
        )
        let protocol2 = createProtocol(
            peptides: [createPeptide(name: "TestPeptide")]
        )
        
        // When
        let hash1 = engine.computeProtocolHash(protocol: protocol1)
        let hash2 = engine.computeProtocolHash(protocol: protocol2)
        
        // Then
        XCTAssertEqual(hash1, hash2, "Identical protocols should have same hash")
        XCTAssertTrue(hash1.hasPrefix("pf_"), "Hash should have pf_ prefix")
    }
    
    func testProtocolHash_DifferentForDifferentDoses() {
        // Given: Protocols with different doses
        let protocol1 = createProtocol(
            peptides: [createPeptide(name: "TestPeptide", weeklyTotal: 1.0)]
        )
        let protocol2 = createProtocol(
            peptides: [createPeptide(name: "TestPeptide", weeklyTotal: 2.0)]
        )
        
        // When
        let hash1 = engine.computeProtocolHash(protocol: protocol1)
        let hash2 = engine.computeProtocolHash(protocol: protocol2)
        
        // Then
        XCTAssertNotEqual(hash1, hash2, "Different protocols should have different hashes")
    }
    
    func testProtocolHash_Format() {
        // Given
        let protocol = createProtocol(
            peptides: [createPeptide(name: "TestPeptide")]
        )
        
        // When
        let hash = engine.computeProtocolHash(protocol: `protocol`)
        
        // Then
        XCTAssertTrue(hash.hasPrefix("pf_"), "Hash should start with pf_")
        XCTAssertTrue(hash.count > 3, "Hash should contain hex value")
        
        // Check hex format
        let hexPart = String(hash.dropFirst(3))
        XCTAssertNotNil(UInt32(hexPart, radix: 16), "Hash should be valid hex")
    }
    
    // MARK: - Complex Scenarios
    
    func testComplexProtocol_MultipleViolations() {
        // Given: Protocol with multiple safety violations
        let protocol = createProtocol(
            peptides: [
                createPeptide(
                    name: "Semaglutide",
                    weeklyTotal: 3.0, // Exceeds max
                    perInjection: 5.0,
                    concentrationMgPerMl: 8.0, // Will exceed pen limit
                    device: .pen
                ),
                createPeptide(name: "Tirzepatide") // Interaction with Semaglutide
            ]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertFalse(result.valid)
        XCTAssertGreaterThan(result.issues.count, 1, "Should detect multiple violations")
        
        let errorIssues = result.issues.filter { $0.severity == .error }
        XCTAssertGreaterThan(errorIssues.count, 0, "Should have error-level issues")
    }
    
    func testValidationResult_Timestamp() {
        // Given
        let protocol = createProtocol(
            peptides: [createPeptide(name: "TestPeptide")]
        )
        
        // When
        let result = engine.validate(protocol: `protocol`)
        
        // Then
        XCTAssertFalse(result.evaluatedAt.isEmpty, "Should have timestamp")
        
        let formatter = ISO8601DateFormatter()
        XCTAssertNotNil(formatter.date(from: result.evaluatedAt), "Should be valid ISO8601 date")
    }
    
    // MARK: - Helper Methods
    
    private func createProtocol(peptides: [ProtocolPeptide]) -> ProtocolBase {
        ProtocolBase(
            id: "test-protocol-\(UUID().uuidString)",
            version: 1,
            state: .draft,
            name: "Test Protocol",
            metadata: ProtocolMetadata(goal: "Testing"),
            peptides: peptides,
            phases: [],
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
    }
    
    private func createPeptide(
        name: String,
        weeklyTotal: Double = 1.0,
        perInjection: Double = 1.0,
        unit: DoseUnit = .mg,
        concentrationMgPerMl: Double? = nil,
        device: DeviceType = .insulinSyringe,
        timeOfDay: TimeOfDay? = nil
    ) -> ProtocolPeptide {
        ProtocolPeptide(
            id: "peptide-\(UUID().uuidString)",
            name: name,
            dose: PeptideDosePlan(
                perInjection: perInjection,
                unit: unit,
                weeklyTotal: weeklyTotal,
                device: device,
                schedule: FrequencySchedule(
                    intervalDays: 1,
                    injectionsPerWeek: 7.0,
                    pattern: .daily
                )
            ),
            timing: PeptideTiming(timeOfDay: timeOfDay),
            supply: PeptideSupplyPlan(
                vialSizeMg: 10.0,
                reconstitutionMl: 2.0,
                concentrationMgPerMl: concentrationMgPerMl
            ),
            phases: []
        )
    }
}
