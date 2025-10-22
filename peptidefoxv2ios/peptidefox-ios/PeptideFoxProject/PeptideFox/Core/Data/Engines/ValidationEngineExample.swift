import Foundation

/// Example usage of ValidationEngine for protocol safety checks
struct ValidationEngineExample {
    
    static func runExamples() {
        print("=== ValidationEngine Examples ===\n")
        
        example1_BasicValidation()
        example2_MaxWeeklyDoseViolation()
        example3_DeviceLimitViolation()
        example4_DrugInteraction()
        example5_MultipleIssues()
        example6_ProtocolHashing()
    }
    
    // MARK: - Example 1: Basic Validation
    
    static func example1_BasicValidation() {
        print("Example 1: Basic Validation")
        
        let engine = ValidationEngine()
        
        // Create a safe protocol
        let protocol = ProtocolBase(
            id: "proto-001",
            version: 1,
            state: .draft,
            name: "Safe GLP-1 Protocol",
            metadata: ProtocolMetadata(goal: "Weight loss"),
            peptides: [
                ProtocolPeptide(
                    id: "pep-001",
                    name: "Semaglutide",
                    dose: PeptideDosePlan(
                        perInjection: 1.0,
                        unit: .mg,
                        weeklyTotal: 1.0,
                        device: .pen,
                        schedule: FrequencySchedule(
                            intervalDays: 7,
                            injectionsPerWeek: 1.0,
                            pattern: .weekly
                        )
                    ),
                    timing: PeptideTiming(timeOfDay: .morning),
                    supply: PeptideSupplyPlan(
                        vialSizeMg: 5.0,
                        reconstitutionMl: 2.0,
                        concentrationMgPerMl: 2.5
                    ),
                    phases: []
                )
            ],
            phases: [],
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
        
        let result = engine.validate(protocol: `protocol`)
        
        print("Valid: \(result.valid)")
        print("Hash: \(result.hash)")
        print("Issues: \(result.issues.count)")
        print("Evaluated at: \(result.evaluatedAt)\n")
    }
    
    // MARK: - Example 2: Max Weekly Dose Violation
    
    static func example2_MaxWeeklyDoseViolation() {
        print("Example 2: Max Weekly Dose Violation")
        
        let engine = ValidationEngine()
        
        // Create protocol with excessive Semaglutide dose
        let protocol = ProtocolBase(
            id: "proto-002",
            version: 1,
            state: .draft,
            name: "Unsafe High-Dose Protocol",
            metadata: ProtocolMetadata(goal: "Aggressive weight loss"),
            peptides: [
                ProtocolPeptide(
                    id: "pep-002",
                    name: "Semaglutide",
                    dose: PeptideDosePlan(
                        perInjection: 3.0, // Exceeds 2.4mg/week limit
                        unit: .mg,
                        weeklyTotal: 3.0,
                        device: .pen,
                        schedule: FrequencySchedule(
                            intervalDays: 7,
                            injectionsPerWeek: 1.0,
                            pattern: .weekly
                        )
                    ),
                    timing: PeptideTiming(timeOfDay: .morning),
                    supply: PeptideSupplyPlan(concentrationMgPerMl: 5.0),
                    phases: []
                )
            ],
            phases: [],
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
        
        let result = engine.validate(protocol: `protocol`)
        
        print("Valid: \(result.valid)")
        print("Issues:")
        for issue in result.issues {
            print("  - [\(issue.severity.rawValue)] \(issue.message)")
            if let meta = issue.meta {
                print("    Meta: \(meta)")
            }
        }
        print()
    }
    
    // MARK: - Example 3: Device Limit Violation
    
    static func example3_DeviceLimitViolation() {
        print("Example 3: Device Limit Violation")
        
        let engine = ValidationEngine()
        
        // Create protocol with excessive injection volume for pen
        let protocol = ProtocolBase(
            id: "proto-003",
            version: 1,
            state: .draft,
            name: "Pen Volume Violation",
            metadata: ProtocolMetadata(goal: "High-dose therapy"),
            peptides: [
                ProtocolPeptide(
                    id: "pep-003",
                    name: "BPC-157",
                    dose: PeptideDosePlan(
                        perInjection: 5.0,
                        unit: .mg,
                        weeklyTotal: 35.0,
                        device: .pen,
                        schedule: FrequencySchedule(
                            intervalDays: 1,
                            injectionsPerWeek: 7.0,
                            pattern: .daily
                        )
                    ),
                    timing: PeptideTiming(timeOfDay: .morning),
                    supply: PeptideSupplyPlan(
                        vialSizeMg: 10.0,
                        reconstitutionMl: 2.0,
                        concentrationMgPerMl: 5.0 // 5mg / 5mg/ml = 1.0ml (exceeds 0.5ml pen limit)
                    ),
                    phases: []
                )
            ],
            phases: [],
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
        
        let result = engine.validate(protocol: `protocol`)
        
        print("Valid: \(result.valid)")
        print("Issues:")
        for issue in result.issues {
            print("  - [\(issue.severity.rawValue)] \(issue.type.rawValue)")
            print("    \(issue.message)")
        }
        print()
    }
    
    // MARK: - Example 4: Drug Interaction
    
    static func example4_DrugInteraction() {
        print("Example 4: Drug Interaction Detection")
        
        let engine = ValidationEngine()
        
        // Create protocol combining incompatible GLP-1 agonists
        let protocol = ProtocolBase(
            id: "proto-004",
            version: 1,
            state: .draft,
            name: "Dangerous Combination",
            metadata: ProtocolMetadata(goal: "Maximum weight loss"),
            peptides: [
                ProtocolPeptide(
                    id: "pep-004a",
                    name: "Semaglutide",
                    dose: PeptideDosePlan(
                        perInjection: 1.0,
                        unit: .mg,
                        weeklyTotal: 1.0,
                        device: .pen,
                        schedule: FrequencySchedule(
                            intervalDays: 7,
                            injectionsPerWeek: 1.0,
                            pattern: .weekly
                        )
                    ),
                    timing: PeptideTiming(timeOfDay: .morning),
                    supply: PeptideSupplyPlan(concentrationMgPerMl: 2.0),
                    phases: []
                ),
                ProtocolPeptide(
                    id: "pep-004b",
                    name: "Tirzepatide",
                    dose: PeptideDosePlan(
                        perInjection: 5.0,
                        unit: .mg,
                        weeklyTotal: 5.0,
                        device: .pen,
                        schedule: FrequencySchedule(
                            intervalDays: 7,
                            injectionsPerWeek: 1.0,
                            pattern: .weekly
                        )
                    ),
                    timing: PeptideTiming(timeOfDay: .morning),
                    supply: PeptideSupplyPlan(concentrationMgPerMl: 10.0),
                    phases: []
                )
            ],
            phases: [],
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
        
        let result = engine.validate(protocol: `protocol`)
        
        print("Valid: \(result.valid)")
        print("Issues:")
        for issue in result.issues {
            print("  - [\(issue.severity.rawValue)] \(issue.type.rawValue)")
            print("    \(issue.message)")
        }
        print()
    }
    
    // MARK: - Example 5: Multiple Issues
    
    static func example5_MultipleIssues() {
        print("Example 5: Multiple Validation Issues")
        
        let engine = ValidationEngine()
        
        // Create protocol with multiple violations
        let protocol = ProtocolBase(
            id: "proto-005",
            version: 1,
            state: .draft,
            name: "Multiple Violations",
            metadata: ProtocolMetadata(goal: "Problematic protocol"),
            peptides: [
                // Excessive Semaglutide (dose violation)
                ProtocolPeptide(
                    id: "pep-005a",
                    name: "Semaglutide",
                    dose: PeptideDosePlan(
                        perInjection: 3.0,
                        unit: .mg,
                        weeklyTotal: 3.0,
                        device: .pen,
                        schedule: FrequencySchedule(
                            intervalDays: 7,
                            injectionsPerWeek: 1.0,
                            pattern: .weekly
                        )
                    ),
                    timing: PeptideTiming(timeOfDay: .morning),
                    supply: PeptideSupplyPlan(concentrationMgPerMl: 2.0),
                    phases: []
                ),
                // Tirzepatide (interaction violation)
                ProtocolPeptide(
                    id: "pep-005b",
                    name: "Tirzepatide",
                    dose: PeptideDosePlan(
                        perInjection: 5.0,
                        unit: .mg,
                        weeklyTotal: 5.0,
                        device: .pen,
                        schedule: FrequencySchedule(
                            intervalDays: 7,
                            injectionsPerWeek: 1.0,
                            pattern: .weekly
                        )
                    ),
                    timing: PeptideTiming(timeOfDay: .morning),
                    supply: PeptideSupplyPlan(concentrationMgPerMl: 5.0),
                    phases: []
                )
            ],
            phases: [],
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
        
        let result = engine.validate(protocol: `protocol`)
        
        print("Valid: \(result.valid)")
        print("Total Issues: \(result.issues.count)")
        
        let errors = result.issues.filter { $0.severity == .error }
        let warnings = result.issues.filter { $0.severity == .warn }
        
        print("Errors: \(errors.count)")
        for issue in errors {
            print("  - \(issue.message)")
        }
        
        print("Warnings: \(warnings.count)")
        for issue in warnings {
            print("  - \(issue.message)")
        }
        print()
    }
    
    // MARK: - Example 6: Protocol Hashing
    
    static func example6_ProtocolHashing() {
        print("Example 6: Protocol Hashing")
        
        let engine = ValidationEngine()
        
        // Create two identical protocols
        let protocol1 = ProtocolBase(
            id: "proto-006",
            version: 1,
            state: .draft,
            name: "Hash Test Protocol",
            metadata: ProtocolMetadata(goal: "Testing"),
            peptides: [
                ProtocolPeptide(
                    id: "pep-006",
                    name: "Semaglutide",
                    dose: PeptideDosePlan(
                        perInjection: 1.0,
                        unit: .mg,
                        weeklyTotal: 1.0,
                        device: .pen,
                        schedule: FrequencySchedule(
                            intervalDays: 7,
                            injectionsPerWeek: 1.0,
                            pattern: .weekly
                        )
                    ),
                    timing: PeptideTiming(timeOfDay: .morning),
                    supply: PeptideSupplyPlan(concentrationMgPerMl: 2.0),
                    phases: []
                )
            ],
            phases: [],
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
        
        let protocol2 = ProtocolBase(
            id: "proto-006",
            version: 1,
            state: .draft,
            name: "Hash Test Protocol",
            metadata: ProtocolMetadata(goal: "Testing"),
            peptides: [
                ProtocolPeptide(
                    id: "pep-006",
                    name: "Semaglutide",
                    dose: PeptideDosePlan(
                        perInjection: 1.0,
                        unit: .mg,
                        weeklyTotal: 1.0,
                        device: .pen,
                        schedule: FrequencySchedule(
                            intervalDays: 7,
                            injectionsPerWeek: 1.0,
                            pattern: .weekly
                        )
                    ),
                    timing: PeptideTiming(timeOfDay: .morning),
                    supply: PeptideSupplyPlan(concentrationMgPerMl: 2.0),
                    phases: []
                )
            ],
            phases: [],
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
        
        let hash1 = engine.computeProtocolHash(protocol: protocol1)
        let hash2 = engine.computeProtocolHash(protocol: protocol2)
        
        print("Protocol 1 Hash: \(hash1)")
        print("Protocol 2 Hash: \(hash2)")
        print("Hashes Match: \(hash1 == hash2)")
        print("Hash Format: Starts with 'pf_': \(hash1.hasPrefix("pf_"))")
        print()
    }
}
