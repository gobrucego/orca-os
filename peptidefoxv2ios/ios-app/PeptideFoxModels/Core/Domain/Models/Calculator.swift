//
//  Calculator.swift
//  PeptideFox
//
//  Calculator models for dosing calculations and reconstitution.
//  All types are Sendable for Swift 6.0 concurrency compliance.
//

import Foundation

// MARK: - Calculator Input

/// Input parameters for dosing calculations
public struct CalculatorInput: Codable, Sendable, Hashable {
    public let vialSize: Double // mg
    public let reconstitutionVolume: Double // ml
    public let targetDose: Double // mg per injection
    public let frequency: FrequencySchedule
    public let peptideName: String?
    public let considerBuffer: Bool
    
    public init(
        vialSize: Double,
        reconstitutionVolume: Double,
        targetDose: Double,
        frequency: FrequencySchedule,
        peptideName: String? = nil,
        considerBuffer: Bool = true
    ) {
        self.vialSize = vialSize
        self.reconstitutionVolume = reconstitutionVolume
        self.targetDose = targetDose
        self.frequency = frequency
        self.peptideName = peptideName
        self.considerBuffer = considerBuffer
    }
    
    /// Calculate concentration (mg/ml)
    public var concentration: Double {
        guard reconstitutionVolume > 0 else { return 0 }
        return vialSize / reconstitutionVolume
    }
    
    /// Calculate volume per injection (ml)
    public var volumePerInjection: Double {
        guard concentration > 0 else { return 0 }
        return targetDose / concentration
    }
    
    /// Calculate weekly total dose
    public var weeklyDose: Double {
        targetDose * Double(frequency.injectionsPerWeek)
    }
    
    /// Validate input parameters
    public func validate() -> [String] {
        var errors: [String] = []
        
        if vialSize <= 0 {
            errors.append("Vial size must be greater than 0")
        }
        if reconstitutionVolume <= 0 {
            errors.append("Reconstitution volume must be greater than 0")
        }
        if targetDose <= 0 {
            errors.append("Target dose must be greater than 0")
        }
        if targetDose > vialSize {
            errors.append("Target dose cannot exceed vial size")
        }
        if volumePerInjection > 3.0 {
            errors.append("Volume per injection exceeds 3ml maximum")
        }
        
        return errors
    }
    
    /// Check if input is valid
    public var isValid: Bool {
        validate().isEmpty
    }
}

// MARK: - Calculator Output

/// Complete calculation results for dosing
public struct CalculatorOutput: Codable, Sendable, Hashable {
    public let concentration: Double // mg/ml
    public let drawVolume: Double // ml per injection
    public let drawUnits: Int // device units per injection
    public let compatibleDevices: [Device]
    public let recommendedDevice: Device
    public let dosesPerVial: Int
    public let daysPerVial: Int
    public let vialsPerMonth: Double
    public let monthlyVials: Int // rounded up with buffer
    public let syringeVisual: SyringeVisual
    public let suggestions: [Suggestion]
    public let warnings: [String]
    
    public init(
        concentration: Double,
        drawVolume: Double,
        drawUnits: Int,
        compatibleDevices: [Device],
        recommendedDevice: Device,
        dosesPerVial: Int,
        daysPerVial: Int,
        vialsPerMonth: Double,
        monthlyVials: Int,
        syringeVisual: SyringeVisual,
        suggestions: [Suggestion] = [],
        warnings: [String] = []
    ) {
        self.concentration = concentration
        self.drawVolume = drawVolume
        self.drawUnits = drawUnits
        self.compatibleDevices = compatibleDevices
        self.recommendedDevice = recommendedDevice
        self.dosesPerVial = dosesPerVial
        self.daysPerVial = daysPerVial
        self.vialsPerMonth = vialsPerMonth
        self.monthlyVials = monthlyVials
        self.syringeVisual = syringeVisual
        self.suggestions = suggestions
        self.warnings = warnings
    }
    
    // MARK: - Formatted Outputs
    
    /// Formatted concentration string
    public var formattedConcentration: String {
        String(format: "%.1f mg/ml", concentration)
    }
    
    /// Formatted draw volume string
    public var formattedDrawVolume: String {
        if drawVolume < 0.1 {
            return String(format: "%.3f ml", drawVolume)
        } else {
            return String(format: "%.2f ml", drawVolume)
        }
    }
    
    /// Formatted draw units string
    public var formattedDrawUnits: String {
        "\(drawUnits) units"
    }
    
    /// Formatted doses per vial
    public var formattedDosesPerVial: String {
        "\(dosesPerVial) doses"
    }
    
    /// Formatted vial duration
    public var formattedVialDuration: String {
        if daysPerVial == 1 {
            return "1 day"
        } else if daysPerVial < 7 {
            return "\(daysPerVial) days"
        } else {
            let weeks = daysPerVial / 7
            let days = daysPerVial % 7
            if days == 0 {
                return weeks == 1 ? "1 week" : "\(weeks) weeks"
            } else {
                return "\(weeks) week\(weeks == 1 ? "" : "s") \(days) day\(days == 1 ? "" : "s")"
            }
        }
    }
    
    /// Formatted monthly supply
    public var formattedMonthlySupply: String {
        if monthlyVials == 1 {
            return "1 vial/month"
        } else {
            return "\(monthlyVials) vials/month"
        }
    }
    
    // MARK: - Checks
    
    /// Check if dose requires precise measurement
    public var requiresPrecision: Bool {
        drawVolume < 0.1
    }
    
    /// Check if dose is too small for accurate measurement
    public var isTooSmall: Bool {
        drawUnits < 5
    }
    
    /// Check if dose is approaching device limit
    public var isNearDeviceLimit: Bool {
        drawUnits > recommendedDevice.maxUnits * 9 / 10 // >90% of capacity
    }
    
    /// Check if there are optimization opportunities
    public var hasOptimizations: Bool {
        suggestions.contains { $0.type == .optimization }
    }
    
    /// Check if there are warnings
    public var hasWarnings: Bool {
        !warnings.isEmpty || suggestions.contains { $0.type == .warning }
    }
    
    /// Get all warning messages (from both warnings and suggestions)
    public var allWarnings: [String] {
        var result = warnings
        result.append(contentsOf: suggestions
            .filter { $0.type == .warning }
            .map { $0.message }
        )
        return result
    }
}

// MARK: - Calculator Error

/// Errors that can occur during calculation
public enum CalculatorError: LocalizedError, Sendable {
    case invalidInput(String)
    case noCompatibleDevice
    case volumeTooLarge(Double)
    case volumeTooSmall(Double)
    case concentrationTooHigh(Double)
    case divisionByZero
    case calculationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .noCompatibleDevice:
            return "No compatible device found for this dose volume"
        case .volumeTooLarge(let volume):
            return String(format: "Volume of %.2fml exceeds maximum device capacity", volume)
        case .volumeTooSmall(let volume):
            return String(format: "Volume of %.3fml is too small for accurate measurement", volume)
        case .concentrationTooHigh(let concentration):
            return String(format: "Concentration of %.1fmg/ml is too high for safe use", concentration)
        case .divisionByZero:
            return "Cannot calculate: division by zero"
        case .calculationFailed(let reason):
            return "Calculation failed: \(reason)"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidInput:
            return "Check your input values and try again"
        case .noCompatibleDevice:
            return "Adjust reconstitution volume to achieve a measurable dose"
        case .volumeTooLarge:
            return "Increase reconstitution volume to reduce draw volume"
        case .volumeTooSmall:
            return "Decrease reconstitution volume to increase draw volume"
        case .concentrationTooHigh:
            return "Increase reconstitution volume to reduce concentration"
        case .divisionByZero:
            return "Ensure all values are greater than zero"
        case .calculationFailed:
            return "Verify all input parameters are correct"
        }
    }
}

// MARK: - Calculation Presets

/// Common calculation presets for quick access
public struct CalculationPreset: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let peptideId: String
    public let vialSize: Double
    public let reconstitutionVolume: Double
    public let typicalDose: Double
    public let frequency: FrequencySchedule
    public let description: String?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        peptideId: String,
        vialSize: Double,
        reconstitutionVolume: Double,
        typicalDose: Double,
        frequency: FrequencySchedule,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.peptideId = peptideId
        self.vialSize = vialSize
        self.reconstitutionVolume = reconstitutionVolume
        self.typicalDose = typicalDose
        self.frequency = frequency
        self.description = description
    }
    
    /// Convert preset to calculator input
    public func toInput() -> CalculatorInput {
        CalculatorInput(
            vialSize: vialSize,
            reconstitutionVolume: reconstitutionVolume,
            targetDose: typicalDose,
            frequency: frequency,
            peptideName: name
        )
    }
}

// MARK: - Common Presets

extension CalculationPreset {
    /// BPC-157 standard protocol
    public static let bpc157Standard = CalculationPreset(
        name: "BPC-157 Standard",
        peptideId: "bpc-157",
        vialSize: 5.0,
        reconstitutionVolume: 2.0,
        typicalDose: 0.25,
        frequency: .daily,
        description: "Standard daily BPC-157 protocol"
    )
    
    /// Semaglutide starter dose
    public static let semaglutideStarter = CalculationPreset(
        name: "Semaglutide Starter",
        peptideId: "semaglutide",
        vialSize: 3.0,
        reconstitutionVolume: 1.5,
        typicalDose: 0.25,
        frequency: .weekly,
        description: "Semaglutide starting dose (0.25mg weekly)"
    )
    
    /// Tirzepatide maintenance dose
    public static let tirzepatideMaintenance = CalculationPreset(
        name: "Tirzepatide Maintenance",
        peptideId: "tirzepatide",
        vialSize: 10.0,
        reconstitutionVolume: 2.0,
        typicalDose: 5.0,
        frequency: .weekly,
        description: "Tirzepatide maintenance dose (5mg weekly)"
    )
}
