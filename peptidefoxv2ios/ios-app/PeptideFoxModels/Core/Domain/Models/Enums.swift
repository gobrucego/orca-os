//
//  Enums.swift
//  PeptideFox
//
//  Core enumerations used throughout the PeptideFox iOS application.
//  All enums are Sendable for Swift 6.0 concurrency compliance.
//

import Foundation

// MARK: - Protocol State

/// Represents the lifecycle state of a peptide protocol
public enum ProtocolState: String, Codable, Sendable, CaseIterable {
    case draft = "DRAFT"
    case active = "ACTIVE"
    case completed = "COMPLETED"

    public var displayName: String {
        switch self {
        case .draft: return "Draft"
        case .active: return "Active"
        case .completed: return "Completed"
        }
    }

    public var canEdit: Bool {
        self == .draft
    }

    public var canActivate: Bool {
        self == .draft
    }

    public var canComplete: Bool {
        self == .active
    }
}

// MARK: - Dose Unit

/// Units of measurement for peptide dosing
public enum DoseUnit: String, Codable, Sendable, CaseIterable {
    case milligrams = "mg"
    case micrograms = "mcg"
    case internationalUnits = "iu"

    public var displayName: String {
        switch self {
        case .milligrams: return "mg"
        case .micrograms: return "mcg"
        case .internationalUnits: return "IU"
        }
    }

    public var fullName: String {
        switch self {
        case .milligrams: return "Milligrams"
        case .micrograms: return "Micrograms"
        case .internationalUnits: return "International Units"
        }
    }

    /// Conversion factor to milligrams (for calculations)
    public var toMilligrams: Double {
        switch self {
        case .milligrams: return 1.0
        case .micrograms: return 0.001
        case .internationalUnits: return 1.0 // IU conversion varies by substance
        }
    }
}

// MARK: - Device Type

/// Types of injection devices
public enum DeviceType: String, Codable, Sendable, CaseIterable {
    case insulinSyringe = "insulin-syringe"
    case luerLock = "luer-lock"
    case pen = "pen"
    case autoInjector = "auto-injector"
    case unknown = "unknown"

    public var displayName: String {
        switch self {
        case .insulinSyringe: return "Insulin Syringe"
        case .luerLock: return "Luer Lock Syringe"
        case .pen: return "Injection Pen"
        case .autoInjector: return "Auto-Injector"
        case .unknown: return "Unknown Device"
        }
    }

    public var maxVolume: Double? {
        switch self {
        case .insulinSyringe: return 1.0 // 1ml typical
        case .luerLock: return 3.0 // 3ml typical
        case .pen: return 3.0 // varies by pen
        case .autoInjector: return 1.0 // varies
        case .unknown: return nil
        }
    }
}

// MARK: - Time of Day

/// Preferred injection timing
public enum TimeOfDay: String, Codable, Sendable, CaseIterable {
    case morning
    case afternoon
    case evening
    case bedtime

    public var displayName: String {
        switch self {
        case .morning: return "Morning"
        case .afternoon: return "Afternoon"
        case .evening: return "Evening"
        case .bedtime: return "Bedtime"
        }
    }

    public var typicalHour: Int {
        switch self {
        case .morning: return 8
        case .afternoon: return 14
        case .evening: return 18
        case .bedtime: return 22
        }
    }
}

// MARK: - Frequency Pattern

/// Dosing frequency patterns
public enum FrequencyPattern: String, Codable, Sendable, CaseIterable {
    case daily
    case weekly
    case custom

    public var displayName: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .custom: return "Custom Schedule"
        }
    }
}

// MARK: - Day of Week

/// Days of the week for scheduling
public enum DayOfWeek: String, Codable, Sendable, CaseIterable {
    case monday = "mon"
    case tuesday = "tue"
    case wednesday = "wed"
    case thursday = "thu"
    case friday = "fri"
    case saturday = "sat"
    case sunday = "sun"

    public var displayName: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }

    public var abbreviation: String {
        rawValue.uppercased()
    }
}

// MARK: - Peptide Category

/// Categories of peptides based on primary function
public enum PeptideCategory: String, Codable, Sendable, CaseIterable {
    case glp = "glp"
    case metabolic = "metabolic"
    case healing = "healing"
    case cognitive = "cognitive"
    case growthHormone = "growth-hormone"
    case immune = "immune"
    case hpta = "hpta"

    public var displayName: String {
        switch self {
        case .glp: return "GLP-1 Agonist"
        case .metabolic: return "Metabolic"
        case .healing: return "Healing & Recovery"
        case .cognitive: return "Cognitive Enhancement"
        case .growthHormone: return "Growth Hormone"
        case .immune: return "Immune Support"
        case .hpta: return "HPTA"
        }
    }

    public var systemColor: String {
        switch self {
        case .glp: return "#94a3b8"
        case .metabolic: return "#f59e0b"
        case .healing: return "#10b981"
        case .cognitive: return "#8b5cf6"
        case .growthHormone: return "#3b82f6"
        case .immune: return "#ec4899"
        case .hpta: return "#6366f1"
        }
    }
}

// MARK: - Evidence Level

/// Clinical evidence strength
public enum EvidenceLevel: String, Codable, Sendable, CaseIterable {
    case strong = "Strong"
    case moderate = "Moderate"
    case limited = "Limited"
    case experimental = "Experimental"

    public var displayName: String {
        rawValue
    }

    public var description: String {
        switch self {
        case .strong: return "Multiple RCTs, meta-analyses available"
        case .moderate: return "Some RCTs, consistent observational data"
        case .limited: return "Case reports, animal studies primarily"
        case .experimental: return "Theoretical or early research only"
        }
    }

    public var sortOrder: Int {
        switch self {
        case .strong: return 1
        case .moderate: return 2
        case .limited: return 3
        case .experimental: return 4
        }
    }
}

// MARK: - Cost Level

/// Relative cost categories
public enum CostLevel: String, Codable, Sendable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case veryHigh = "Very High"

    public var displayName: String {
        rawValue
    }

    public var estimatedMonthlyRange: String {
        switch self {
        case .low: return "$50-150"
        case .medium: return "$150-400"
        case .high: return "$400-800"
        case .veryHigh: return "$800+"
        }
    }

    public var sortOrder: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        case .veryHigh: return 4
        }
    }
}

// MARK: - Phase Intensity

/// Intensity level for phase assignments
public enum PhaseIntensity: String, Codable, Sendable, CaseIterable {
    case core
    case optional

    public var displayName: String {
        switch self {
        case .core: return "Core"
        case .optional: return "Optional"
        }
    }

    public var priority: Int {
        switch self {
        case .core: return 1
        case .optional: return 2
        }
    }
}

// MARK: - Validation Issue Type

/// Types of validation issues
public enum ValidationIssueType: String, Codable, Sendable, CaseIterable {
    case maxWeeklyDose = "MAX_WEEKLY_DOSE"
    case deviceLimit = "DEVICE_LIMIT"
    case separation = "SEPARATION"
    case interaction = "INTERACTION"
    case missingData = "MISSING_DATA"
    case invalidSchedule = "INVALID_SCHEDULE"

    public var displayName: String {
        switch self {
        case .maxWeeklyDose: return "Weekly Dose Limit"
        case .deviceLimit: return "Device Capacity"
        case .separation: return "Timing Separation"
        case .interaction: return "Drug Interaction"
        case .missingData: return "Missing Data"
        case .invalidSchedule: return "Invalid Schedule"
        }
    }
}

// MARK: - Validation Severity

/// Severity levels for validation issues
public enum ValidationSeverity: String, Codable, Sendable, CaseIterable {
    case info
    case warning = "warn"
    case error

    public var displayName: String {
        switch self {
        case .info: return "Information"
        case .warning: return "Warning"
        case .error: return "Error"
        }
    }

    public var isBlocking: Bool {
        self == .error
    }

    public var systemImageName: String {
        switch self {
        case .info: return "info.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        }
    }
}

// MARK: - Suggestion Type

/// Types of optimization suggestions
public enum SuggestionType: String, Codable, Sendable, CaseIterable {
    case warning
    case info
    case optimization

    public var displayName: String {
        switch self {
        case .warning: return "Warning"
        case .info: return "Information"
        case .optimization: return "Optimization"
        }
    }

    public var systemImageName: String {
        switch self {
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        case .optimization: return "sparkles"
        }
    }
}

// MARK: - Calculator Device Type

/// Specific device types for calculator
public enum CalculatorDeviceType: String, Codable, Sendable, CaseIterable {
    case pen
    case syringe30
    case syringe50
    case syringe100

    public var displayName: String {
        switch self {
        case .pen: return "Injection Pen"
        case .syringe30: return "30-Unit Syringe"
        case .syringe50: return "50-Unit Syringe"
        case .syringe100: return "100-Unit Syringe"
        }
    }

    public var maxUnits: Int {
        switch self {
        case .pen: return 300
        case .syringe30: return 30
        case .syringe50: return 50
        case .syringe100: return 100
        }
    }

    public var maxVolume: Double {
        switch self {
        case .pen: return 3.0
        case .syringe30: return 0.3
        case .syringe50: return 0.5
        case .syringe100: return 1.0
        }
    }
}
