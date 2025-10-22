//
//  Validation.swift
//  PeptideFox
//
//  Protocol validation models for ensuring safety and correctness.
//  All types are Sendable for Swift 6.0 concurrency compliance.
//

import Foundation

// MARK: - Validation Issue

/// Represents a single validation issue found in a protocol
public struct ValidationIssue: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public let type: ValidationIssueType
    public let message: String
    public let severity: ValidationSeverity
    public let meta: [String: String]?
    
    public init(
        id: String = UUID().uuidString,
        type: ValidationIssueType,
        message: String,
        severity: ValidationSeverity,
        meta: [String: String]? = nil
    ) {
        self.id = id
        self.type = type
        self.message = message
        self.severity = severity
        self.meta = meta
    }
    
    /// Check if this issue blocks protocol activation
    public var isBlocking: Bool {
        severity.isBlocking
    }
    
    /// Get the peptide ID associated with this issue (if any)
    public var peptideId: String? {
        meta?["peptideId"]
    }
    
    /// Get the phase ID associated with this issue (if any)
    public var phaseId: String? {
        meta?["phaseId"]
    }
    
    /// Formatted message with metadata
    public var formattedMessage: String {
        var result = message
        if let peptideName = meta?["peptideName"] {
            result = "\(peptideName): \(result)"
        }
        return result
    }
}

// MARK: - Validation Result

/// Complete validation result for a protocol
public struct ValidationResult: Codable, Sendable, Hashable {
    public let hash: String
    public let issues: [ValidationIssue]
    public let valid: Bool
    public let evaluatedAt: Date
    
    public init(
        hash: String,
        issues: [ValidationIssue],
        valid: Bool,
        evaluatedAt: Date = Date()
    ) {
        self.hash = hash
        self.issues = issues
        self.valid = valid
        self.evaluatedAt = evaluatedAt
    }
    
    /// Check if validation passed without any issues
    public var isPerfect: Bool {
        issues.isEmpty
    }
    
    /// Count of blocking issues
    public var blockingIssueCount: Int {
        issues.filter { $0.isBlocking }.count
    }
    
    /// Count of warnings
    public var warningCount: Int {
        issues.filter { $0.severity == .warning }.count
    }
    
    /// Count of info messages
    public var infoCount: Int {
        issues.filter { $0.severity == .info }.count
    }
    
    /// All error issues
    public var errors: [ValidationIssue] {
        issues.filter { $0.severity == .error }
    }
    
    /// All warning issues
    public var warnings: [ValidationIssue] {
        issues.filter { $0.severity == .warning }
    }
    
    /// All info issues
    public var infos: [ValidationIssue] {
        issues.filter { $0.severity == .info }
    }
    
    /// Issues grouped by severity
    public var issuesBySeverity: [ValidationSeverity: [ValidationIssue]] {
        Dictionary(grouping: issues, by: { $0.severity })
    }
    
    /// Issues grouped by type
    public var issuesByType: [ValidationIssueType: [ValidationIssue]] {
        Dictionary(grouping: issues, by: { $0.type })
    }
    
    /// Check if validation is stale (older than 24 hours)
    public var isStale: Bool {
        let hoursSinceValidation = Date().timeIntervalSince(evaluatedAt) / 3600
        return hoursSinceValidation > 24
    }
    
    /// Empty validation result
    public static var empty: ValidationResult {
        ValidationResult(
            hash: "",
            issues: [],
            valid: false,
            evaluatedAt: Date()
        )
    }
    
    /// Successful validation result
    public static func success(hash: String) -> ValidationResult {
        ValidationResult(
            hash: hash,
            issues: [],
            valid: true,
            evaluatedAt: Date()
        )
    }
}

// MARK: - Validation Rules

/// Safety limits for peptide dosing
public struct SafetyLimits: Sendable {
    /// Maximum weekly dose limits by peptide ID
    public static let maxWeeklyDose: [String: Double] = [
        "bpc-157": 3.5,      // 3.5mg/week max
        "tb-500": 10.0,      // 10mg/week max
        "semaglutide": 2.4,  // 2.4mg/week max
        "tirzepatide": 15.0, // 15mg/week max
        "retatrutide": 12.0, // 12mg/week max
        "ipamorelin": 2.1,   // 300mcg 3x daily = 2.1mg/week
        "cjc-1295": 2.0,     // 2mg/week max
        "tesamorelin": 14.0, // 2mg daily = 14mg/week
    ]
    
    /// Device volume limits in ml
    public static let deviceVolumeLimits: [DeviceType: Double] = [
        .insulinSyringe: 1.0,
        .luerLock: 3.0,
        .pen: 3.0,
        .autoInjector: 1.0
    ]
    
    /// Minimum separation hours between conflicting peptides
    public static let requiredSeparation: [(String, String, Int)] = [
        ("bpc-157", "tb-500", 4),
        ("ipamorelin", "cjc-1295", 0), // Can be combined
        ("semaglutide", "tirzepatide", 24), // Never combine GLP-1s
    ]
    
    /// Known drug interactions
    public static let interactions: [String: [String]] = [
        "semaglutide": ["tirzepatide", "retatrutide", "liraglutide"],
        "tirzepatide": ["semaglutide", "retatrutide", "liraglutide"],
        "retatrutide": ["semaglutide", "tirzepatide", "liraglutide"],
    ]
}

// MARK: - Validation Context

/// Context for performing validation with additional information
public struct ValidationContext: Sendable {
    public let userProfile: UserProfile?
    public let existingProtocols: [ProtocolRecord]
    public let checkInteractions: Bool
    public let strictMode: Bool
    
    public init(
        userProfile: UserProfile? = nil,
        existingProtocols: [ProtocolRecord] = [],
        checkInteractions: Bool = true,
        strictMode: Bool = false
    ) {
        self.userProfile = userProfile
        self.existingProtocols = existingProtocols
        self.checkInteractions = checkInteractions
        self.strictMode = strictMode
    }
    
    /// Default validation context
    public static var `default`: ValidationContext {
        ValidationContext()
    }
    
    /// Strict validation context (all checks enabled)
    public static var strict: ValidationContext {
        ValidationContext(checkInteractions: true, strictMode: true)
    }
}

// MARK: - User Profile (for validation context)

/// Basic user profile for validation context
public struct UserProfile: Codable, Sendable, Hashable {
    public let id: String
    public let age: Int?
    public let weight: Double? // in kg
    public let conditions: [String]
    public let medications: [String]
    public let allergies: [String]
    
    public init(
        id: String = UUID().uuidString,
        age: Int? = nil,
        weight: Double? = nil,
        conditions: [String] = [],
        medications: [String] = [],
        allergies: [String] = []
    ) {
        self.id = id
        self.age = age
        self.weight = weight
        self.conditions = conditions
        self.medications = medications
        self.allergies = allergies
    }
}

// MARK: - Validation Helpers

/// Helper methods for creating common validation issues
public enum ValidationHelpers {
    
    /// Create a max weekly dose exceeded issue
    public static func maxDoseExceeded(
        peptideName: String,
        actualDose: Double,
        maxDose: Double,
        unit: DoseUnit
    ) -> ValidationIssue {
        ValidationIssue(
            type: .maxWeeklyDose,
            message: String(
                format: "Weekly dose of %.1f%@ exceeds maximum of %.1f%@",
                actualDose, unit.displayName, maxDose, unit.displayName
            ),
            severity: .error,
            meta: ["peptideName": peptideName]
        )
    }
    
    /// Create a device capacity issue
    public static func deviceCapacityExceeded(
        peptideName: String,
        requiredVolume: Double,
        deviceCapacity: Double
    ) -> ValidationIssue {
        ValidationIssue(
            type: .deviceLimit,
            message: String(
                format: "Required volume of %.2fml exceeds device capacity of %.2fml",
                requiredVolume, deviceCapacity
            ),
            severity: .error,
            meta: ["peptideName": peptideName]
        )
    }
    
    /// Create a timing separation issue
    public static func timingSeparationRequired(
        peptide1: String,
        peptide2: String,
        requiredHours: Int
    ) -> ValidationIssue {
        ValidationIssue(
            type: .separation,
            message: "Requires \(requiredHours) hour separation from \(peptide2)",
            severity: .warning,
            meta: [
                "peptide1": peptide1,
                "peptide2": peptide2,
                "requiredHours": String(requiredHours)
            ]
        )
    }
    
    /// Create a drug interaction warning
    public static func drugInteraction(
        peptide1: String,
        peptide2: String
    ) -> ValidationIssue {
        ValidationIssue(
            type: .interaction,
            message: "Potential interaction with \(peptide2)",
            severity: .error,
            meta: [
                "peptide1": peptide1,
                "peptide2": peptide2
            ]
        )
    }
    
    /// Create a missing data issue
    public static func missingRequiredData(
        field: String,
        peptideName: String? = nil
    ) -> ValidationIssue {
        let message = peptideName != nil
            ? "Missing required field: \(field)"
            : "Protocol missing required field: \(field)"
        
        return ValidationIssue(
            type: .missingData,
            message: message,
            severity: .error,
            meta: peptideName != nil ? ["peptideName": peptideName!] : nil
        )
    }
    
    /// Create an invalid schedule issue
    public static func invalidSchedule(
        peptideName: String,
        reason: String
    ) -> ValidationIssue {
        ValidationIssue(
            type: .invalidSchedule,
            message: "Invalid schedule: \(reason)",
            severity: .error,
            meta: ["peptideName": peptideName]
        )
    }
}
