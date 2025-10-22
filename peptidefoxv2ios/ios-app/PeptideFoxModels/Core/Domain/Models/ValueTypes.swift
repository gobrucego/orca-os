//
//  ValueTypes.swift
//  PeptideFox
//
//  Value types for protocol and peptide management.
//  All types are Sendable for Swift 6.0 concurrency compliance.
//

import Foundation

// MARK: - Frequency Schedule

/// Defines the injection frequency pattern for a peptide
public struct FrequencySchedule: Codable, Sendable, Hashable {
    public let intervalDays: Int
    public let injectionsPerWeek: Int
    public let pattern: FrequencyPattern
    public let specificDays: [DayOfWeek]?
    
    public init(
        intervalDays: Int,
        injectionsPerWeek: Int,
        pattern: FrequencyPattern,
        specificDays: [DayOfWeek]? = nil
    ) {
        self.intervalDays = intervalDays
        self.injectionsPerWeek = injectionsPerWeek
        self.pattern = pattern
        self.specificDays = specificDays
    }
    
    /// Daily schedule (7 injections per week)
    public static var daily: FrequencySchedule {
        FrequencySchedule(
            intervalDays: 1,
            injectionsPerWeek: 7,
            pattern: .daily,
            specificDays: nil
        )
    }
    
    /// Weekly schedule (1 injection per week)
    public static var weekly: FrequencySchedule {
        FrequencySchedule(
            intervalDays: 7,
            injectionsPerWeek: 1,
            pattern: .weekly,
            specificDays: nil
        )
    }
    
    /// Every other day schedule (3-4 injections per week)
    public static var everyOtherDay: FrequencySchedule {
        FrequencySchedule(
            intervalDays: 2,
            injectionsPerWeek: 3,
            pattern: .custom,
            specificDays: nil
        )
    }
}

// MARK: - Peptide Dose Plan

/// Complete dosing plan for a peptide including schedule and device
public struct PeptideDosePlan: Codable, Sendable, Hashable {
    public let perInjection: Double
    public let unit: DoseUnit
    public let weeklyTotal: Double
    public let device: DeviceType
    public let schedule: FrequencySchedule
    
    public init(
        perInjection: Double,
        unit: DoseUnit,
        weeklyTotal: Double,
        device: DeviceType,
        schedule: FrequencySchedule
    ) {
        self.perInjection = perInjection
        self.unit = unit
        self.weeklyTotal = weeklyTotal
        self.device = device
        self.schedule = schedule
    }
    
    /// Calculate the weekly total based on per-injection dose and frequency
    public static func calculateWeeklyTotal(
        perInjection: Double,
        schedule: FrequencySchedule
    ) -> Double {
        perInjection * Double(schedule.injectionsPerWeek)
    }
    
    /// Formatted dose string (e.g., "2.5 mg")
    public var formattedPerInjection: String {
        String(format: "%.1f %@", perInjection, unit.displayName)
    }
    
    /// Formatted weekly total string
    public var formattedWeeklyTotal: String {
        String(format: "%.1f %@/week", weeklyTotal, unit.displayName)
    }
}

// MARK: - Peptide Timing

/// Timing configuration for peptide administration
public struct PeptideTiming: Codable, Sendable, Hashable {
    public let timeOfDay: TimeOfDay?
    public let withMeals: Bool
    public let fasted: Bool
    public let separation: TimingSeparation?
    
    public init(
        timeOfDay: TimeOfDay? = nil,
        withMeals: Bool = false,
        fasted: Bool = false,
        separation: TimingSeparation? = nil
    ) {
        self.timeOfDay = timeOfDay
        self.withMeals = withMeals
        self.fasted = fasted
        self.separation = separation
    }
    
    /// Default timing (no specific requirements)
    public static var `default`: PeptideTiming {
        PeptideTiming()
    }
    
    /// Morning fasted timing
    public static var morningFasted: PeptideTiming {
        PeptideTiming(timeOfDay: .morning, fasted: true)
    }
    
    /// Bedtime timing
    public static var bedtime: PeptideTiming {
        PeptideTiming(timeOfDay: .bedtime)
    }
}

// MARK: - Timing Separation

/// Defines required separation from another peptide
public struct TimingSeparation: Codable, Sendable, Hashable {
    public let from: String // Peptide ID to separate from
    public let hours: Int
    
    public init(from: String, hours: Int) {
        self.from = from
        self.hours = hours
    }
    
    /// Formatted separation string (e.g., "4 hours from BPC-157")
    public func formattedSeparation(peptideName: String? = nil) -> String {
        let name = peptideName ?? from
        return "\(hours) hour\(hours == 1 ? "" : "s") from \(name)"
    }
}

// MARK: - Peptide Supply Plan

/// Supply planning information for a peptide
public struct PeptideSupplyPlan: Codable, Sendable, Hashable {
    public let vialSizeMg: Double?
    public let reconstitutionMl: Double?
    public let concentrationMgPerMl: Double?
    
    public init(
        vialSizeMg: Double? = nil,
        reconstitutionMl: Double? = nil,
        concentrationMgPerMl: Double? = nil
    ) {
        self.vialSizeMg = vialSizeMg
        self.reconstitutionMl = reconstitutionMl
        self.concentrationMgPerMl = concentrationMgPerMl
    }
    
    /// Calculate concentration from vial size and reconstitution volume
    public var calculatedConcentration: Double? {
        guard let vial = vialSizeMg, let recon = reconstitutionMl, recon > 0 else { return nil }
        return vial / recon
    }
    
    /// Standard 5mg vial with 2ml reconstitution
    public static var standard5mg: PeptideSupplyPlan {
        PeptideSupplyPlan(vialSizeMg: 5.0, reconstitutionMl: 2.0)
    }
    
    /// Standard 10mg vial with 2ml reconstitution
    public static var standard10mg: PeptideSupplyPlan {
        PeptideSupplyPlan(vialSizeMg: 10.0, reconstitutionMl: 2.0)
    }
}

// MARK: - Phase Assignment

/// Assigns a peptide to a protocol phase
public struct PhaseAssignment: Codable, Sendable, Hashable {
    public let phaseId: String
    public let intensity: PhaseIntensity?
    
    public init(phaseId: String, intensity: PhaseIntensity? = nil) {
        self.phaseId = phaseId
        self.intensity = intensity ?? .core
    }
    
    /// Core phase assignment
    public static func core(phaseId: String) -> PhaseAssignment {
        PhaseAssignment(phaseId: phaseId, intensity: .core)
    }
    
    /// Optional phase assignment
    public static func optional(phaseId: String) -> PhaseAssignment {
        PhaseAssignment(phaseId: phaseId, intensity: .optional)
    }
}

// MARK: - Peptide Color Scheme

/// Visual styling for peptide display
public struct PeptideColorScheme: Codable, Sendable, Hashable {
    public let bgColor: String
    public let borderColor: String
    public let accentColor: String
    public let bulletColor: String
    public let badgeBg: String
    public let badgeText: String
    public let badgeBorder: String
    
    public init(
        bgColor: String,
        borderColor: String,
        accentColor: String,
        bulletColor: String,
        badgeBg: String,
        badgeText: String,
        badgeBorder: String
    ) {
        self.bgColor = bgColor
        self.borderColor = borderColor
        self.accentColor = accentColor
        self.bulletColor = bulletColor
        self.badgeBg = badgeBg
        self.badgeText = badgeText
        self.badgeBorder = badgeBorder
    }
    
    /// Default gray color scheme
    public static var `default`: PeptideColorScheme {
        PeptideColorScheme(
            bgColor: "#f8fafc",
            borderColor: "#94a3b8",
            accentColor: "#475569",
            bulletColor: "#cbd5e1",
            badgeBg: "#e2e8f0",
            badgeText: "#1e293b",
            badgeBorder: "#cbd5e1"
        )
    }
    
    /// Blue color scheme for healing peptides
    public static var healing: PeptideColorScheme {
        PeptideColorScheme(
            bgColor: "#f0f9ff",
            borderColor: "#3b82f6",
            accentColor: "#1e3a8a",
            bulletColor: "#93c5fd",
            badgeBg: "#dbeafe",
            badgeText: "#1e3a8a",
            badgeBorder: "#93c5fd"
        )
    }
    
    /// Green color scheme for metabolic peptides
    public static var metabolic: PeptideColorScheme {
        PeptideColorScheme(
            bgColor: "#f0fdf4",
            borderColor: "#10b981",
            accentColor: "#14532d",
            bulletColor: "#86efac",
            badgeBg: "#d1fae5",
            badgeText: "#14532d",
            badgeBorder: "#86efac"
        )
    }
}

// MARK: - Peptide Reference

/// Reference information for a peptide from the library
public struct PeptideReference: Codable, Sendable, Hashable {
    public let primaryUse: String
    public let mechanism: String
    public let clinicalBenefits: [String]
    public let typicalDose: String
    public let frequency: String
    public let cycleLength: String
    public let riskProfile: String?
    public let riskNotes: String?
    public let synergies: [String]?
    public let category: String?
    public let level: String?
    public let color: String?
    public let summary: String?
    
    public init(
        primaryUse: String,
        mechanism: String,
        clinicalBenefits: [String],
        typicalDose: String,
        frequency: String,
        cycleLength: String,
        riskProfile: String? = nil,
        riskNotes: String? = nil,
        synergies: [String]? = nil,
        category: String? = nil,
        level: String? = nil,
        color: String? = nil,
        summary: String? = nil
    ) {
        self.primaryUse = primaryUse
        self.mechanism = mechanism
        self.clinicalBenefits = clinicalBenefits
        self.typicalDose = typicalDose
        self.frequency = frequency
        self.cycleLength = cycleLength
        self.riskProfile = riskProfile
        self.riskNotes = riskNotes
        self.synergies = synergies
        self.category = category
        self.level = level
        self.color = color
        self.summary = summary
    }
}

// MARK: - Active Protocol Snapshot

/// Snapshot of protocol state when activated
public struct ActiveProtocolSnapshot: Codable, Sendable, Hashable {
    public let validationHash: String
    public let activatedAt: Date
    
    public init(validationHash: String, activatedAt: Date = Date()) {
        self.validationHash = validationHash
        self.activatedAt = activatedAt
    }
    
    /// ISO-8601 formatted activation date
    public var formattedActivationDate: String {
        ISO8601DateFormatter().string(from: activatedAt)
    }
}
