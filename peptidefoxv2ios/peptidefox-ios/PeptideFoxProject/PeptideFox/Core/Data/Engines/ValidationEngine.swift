import Foundation
import CryptoKit

// MARK: - Validation Types

public enum ValidationIssueSeverity: String, Codable, Sendable {
    case info
    case warn
    case error
}

public enum ValidationIssueType: String, Codable, Sendable {
    case maxWeeklyDose = "MAX_WEEKLY_DOSE"
    case deviceLimit = "DEVICE_LIMIT"
    case separation = "SEPARATION"
    case interaction = "INTERACTION"
}

public struct ValidationIssue: Codable, Sendable, Hashable {
    public let id: String
    public let type: ValidationIssueType
    public let severity: ValidationIssueSeverity
    public let message: String
    public let meta: [String: String]?
    
    public init(
        id: String,
        type: ValidationIssueType,
        severity: ValidationIssueSeverity,
        message: String,
        meta: [String: String]? = nil
    ) {
        self.id = id
        self.type = type
        self.severity = severity
        self.message = message
        self.meta = meta
    }
}

public struct ValidationResult: Codable, Sendable {
    public let hash: String
    public let issues: [ValidationIssue]
    public let valid: Bool
    public let evaluatedAt: String
    
    public init(hash: String, issues: [ValidationIssue], valid: Bool, evaluatedAt: String) {
        self.hash = hash
        self.issues = issues
        self.valid = valid
        self.evaluatedAt = evaluatedAt
    }
}

// MARK: - Validation Rules

enum ValidationRule: Sendable {
    case maxWeeklyDose(peptide: String, max: Double, unit: DoseUnit, severity: ValidationIssueSeverity)
    case injectionVolume(max: Double, device: DeviceType, severity: ValidationIssueSeverity)
    case timingSeparation(peptideA: String, peptideB: String, minHours: Int, severity: ValidationIssueSeverity)
    case interaction(peptides: [String], message: String, severity: ValidationIssueSeverity)
}

// MARK: - Validation Engine

public struct ValidationEngine: Sendable {
    
    // MARK: - Rule Database
    
    private let rules: [ValidationRule] = [
        // GLP-1 Dose Limits
        .maxWeeklyDose(peptide: "Semaglutide", max: 2.4, unit: .mg, severity: .error),
        .maxWeeklyDose(peptide: "Tirzepatide", max: 15.0, unit: .mg, severity: .error),
        .maxWeeklyDose(peptide: "Retatrutide", max: 12.0, unit: .mg, severity: .error),
        .maxWeeklyDose(peptide: "Tesamorelin", max: 14.0, unit: .mg, severity: .warn),
        
        // Device Limits
        .injectionVolume(max: 0.5, device: .pen, severity: .error),
        .injectionVolume(max: 1.0, device: .insulinSyringe, severity: .warn),
        
        // Timing Separation
        .timingSeparation(peptideA: "Tesamorelin", peptideB: "Ipamorelin", minHours: 3, severity: .warn),
        .timingSeparation(peptideA: "CJC-1295", peptideB: "Sermorelin", minHours: 12, severity: .warn),
        
        // Drug Interactions
        .interaction(
            peptides: ["Semaglutide", "Tirzepatide"],
            message: "Do not combine GLP-1 agonists",
            severity: .error
        ),
        .interaction(
            peptides: ["Tirzepatide", "Retatrutide"],
            message: "Do not combine GLP-1 agonists",
            severity: .error
        ),
        .interaction(
            peptides: ["Semaglutide", "Retatrutide"],
            message: "Do not combine GLP-1 agonists",
            severity: .error
        )
    ]
    
    // MARK: - Public API
    
    public init() {}
    
    /// Validates a protocol against all safety rules
    public func validate(protocol protocolBase: ProtocolBase) -> ValidationResult {
        var issues: [ValidationIssue] = []
        
        // Evaluate all rules
        for rule in rules {
            if let issue = evaluateRule(rule, protocol: protocolBase) {
                issues.append(issue)
            }
        }
        
        // Compute protocol hash
        let hash = computeProtocolHash(protocol: protocolBase)
        
        // Protocol is valid if no error-level issues exist
        let valid = issues.allSatisfy { $0.severity != .error }
        
        // Current timestamp
        let evaluatedAt = ISO8601DateFormatter().string(from: Date())
        
        return ValidationResult(
            hash: hash,
            issues: issues,
            valid: valid,
            evaluatedAt: evaluatedAt
        )
    }
    
    // MARK: - Rule Evaluation
    
    private func evaluateRule(_ rule: ValidationRule, protocol: ProtocolBase) -> ValidationIssue? {
        switch rule {
        case .maxWeeklyDose(let peptide, let max, let unit, let severity):
            return checkWeeklyDose(peptideName: peptide, max: max, unit: unit, severity: severity, protocol: `protocol`)
            
        case .injectionVolume(let max, let device, let severity):
            return checkInjectionVolume(max: max, device: device, severity: severity, protocol: `protocol`)
            
        case .timingSeparation(let peptideA, let peptideB, let minHours, let severity):
            return checkTimingSeparation(
                peptideA: peptideA,
                peptideB: peptideB,
                minHours: minHours,
                severity: severity,
                protocol: `protocol`
            )
            
        case .interaction(let peptides, let message, let severity):
            return checkInteraction(peptides: peptides, message: message, severity: severity, protocol: `protocol`)
        }
    }
    
    // MARK: - Weekly Dose Validation
    
    private func checkWeeklyDose(
        peptideName: String,
        max: Double,
        unit: DoseUnit,
        severity: ValidationIssueSeverity,
        protocol: ProtocolBase
    ) -> ValidationIssue? {
        guard let peptide = `protocol`.peptides.first(where: { $0.name == peptideName }) else {
            return nil
        }
        
        let weeklyDose = peptide.dose.weeklyTotal
        
        if weeklyDose > max {
            return ValidationIssue(
                id: "weekly-dose-\(peptide.id)",
                type: .maxWeeklyDose,
                severity: severity,
                message: "\(peptideName) weekly dose (\(weeklyDose)\(unit.rawValue)) exceeds maximum safe dose (\(max)\(unit.rawValue))",
                meta: [
                    "peptideId": peptide.id,
                    "current": String(format: "%.2f", weeklyDose),
                    "max": String(format: "%.2f", max)
                ]
            )
        }
        
        return nil
    }
    
    // MARK: - Device Limit Validation
    
    private func checkInjectionVolume(
        max: Double,
        device: DeviceType,
        severity: ValidationIssueSeverity,
        protocol: ProtocolBase
    ) -> ValidationIssue? {
        for peptide in `protocol`.peptides {
            guard peptide.dose.device == device else { continue }
            guard let concentrationMgPerMl = peptide.supply.concentrationMgPerMl else { continue }
            
            let drawVolume = peptide.dose.perInjection / concentrationMgPerMl
            
            if drawVolume > max {
                return ValidationIssue(
                    id: "volume-\(peptide.id)",
                    type: .deviceLimit,
                    severity: severity,
                    message: "Injection volume (\(String(format: "%.2f", drawVolume))ml) exceeds \(device.rawValue) limit (\(max)ml)",
                    meta: [
                        "peptideId": peptide.id,
                        "volume": String(format: "%.2f", drawVolume),
                        "max": String(format: "%.2f", max),
                        "device": device.rawValue
                    ]
                )
            }
        }
        
        return nil
    }
    
    // MARK: - Timing Separation Validation
    
    private func checkTimingSeparation(
        peptideA: String,
        peptideB: String,
        minHours: Int,
        severity: ValidationIssueSeverity,
        protocol: ProtocolBase
    ) -> ValidationIssue? {
        guard let pA = `protocol`.peptides.first(where: { $0.name == peptideA }),
              let pB = `protocol`.peptides.first(where: { $0.name == peptideB }) else {
            return nil
        }
        
        let timeA = pA.timing.timeOfDay?.hourOfDay ?? 8
        let timeB = pB.timing.timeOfDay?.hourOfDay ?? 8
        
        let separation = abs(timeA - timeB)
        
        if separation < minHours {
            return ValidationIssue(
                id: "separation-\(pA.id)-\(pB.id)",
                type: .separation,
                severity: severity,
                message: "\(peptideA) and \(peptideB) should be separated by at least \(minHours) hours",
                meta: [
                    "peptideAId": pA.id,
                    "peptideBId": pB.id,
                    "currentSeparation": String(separation),
                    "required": String(minHours)
                ]
            )
        }
        
        return nil
    }
    
    // MARK: - Drug Interaction Validation
    
    private func checkInteraction(
        peptides: [String],
        message: String,
        severity: ValidationIssueSeverity,
        protocol: ProtocolBase
    ) -> ValidationIssue? {
        let foundPeptides = `protocol`.peptides.filter { peptides.contains($0.name) }
        
        if foundPeptides.count >= 2 {
            let ids = foundPeptides.map { $0.id }.joined(separator: "-")
            return ValidationIssue(
                id: "interaction-\(ids)",
                type: .interaction,
                severity: severity,
                message: message,
                meta: [
                    "peptides": foundPeptides.map { $0.id }.joined(separator: ",")
                ]
            )
        }
        
        return nil
    }
    
    // MARK: - Protocol Hashing
    
    /// Computes a deterministic hash of protocol's critical fields
    /// Format: "pf_[hex]"
    public func computeProtocolHash(protocol: ProtocolBase) -> String {
        // Extract critical fields for hashing
        struct CriticalProtocolData: Codable {
            let version: Int
            let peptides: [CriticalPeptideData]
            let phases: [ProtocolPhase]
        }
        
        struct CriticalPeptideData: Codable {
            let id: String
            let dose: PeptideDosePlan
            let timing: PeptideTiming
            let phases: [PhaseAssignment]
        }
        
        let criticalData = CriticalProtocolData(
            version: `protocol`.version,
            peptides: `protocol`.peptides.map { peptide in
                CriticalPeptideData(
                    id: peptide.id,
                    dose: peptide.dose,
                    timing: peptide.timing,
                    phases: peptide.phases
                )
            },
            phases: `protocol`.phases
        )
        
        // Encode to JSON
        guard let jsonData = try? JSONEncoder().encode(criticalData),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return "pf_invalid"
        }
        
        // Compute hash using simple JavaScript-compatible algorithm
        let hash = simpleHash(input: jsonString)
        return "pf_\(hash)"
    }
    
    /// Simple hash function compatible with TypeScript implementation
    /// Matches: hash = (hash << 5) - hash + charCode
    private func simpleHash(input: String) -> String {
        var hash: Int32 = 0
        
        for char in input.utf8 {
            hash = (hash &<< 5) &- hash &+ Int32(char)
        }
        
        let unsignedHash = UInt32(bitPattern: hash)
        return String(unsignedHash, radix: 16)
    }
}
