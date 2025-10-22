//
//  Supply.swift
//  PeptideFox
//
//  Supply planning models for vial calculations and reordering.
//  All types are Sendable for Swift 6.0 concurrency compliance.
//

import Foundation

// MARK: - Supply Input

/// Input parameters for supply planning calculations
public struct SupplyInput: Codable, Sendable, Hashable {
    public let vialSize: Double // mg
    public let reconstitutionVolume: Double // ml
    public let dosePerInjection: Double // mg
    public let frequency: FrequencySchedule
    public let buffer: Double // percentage (e.g., 10 for 10%)
    public let costPerVial: Double?
    public let leadTimeDays: Int? // days to receive order
    
    public init(
        vialSize: Double,
        reconstitutionVolume: Double,
        dosePerInjection: Double,
        frequency: FrequencySchedule,
        buffer: Double = 10,
        costPerVial: Double? = nil,
        leadTimeDays: Int? = nil
    ) {
        self.vialSize = vialSize
        self.reconstitutionVolume = reconstitutionVolume
        self.dosePerInjection = dosePerInjection
        self.frequency = frequency
        self.buffer = buffer
        self.costPerVial = costPerVial
        self.leadTimeDays = leadTimeDays
    }
    
    /// Calculate concentration (mg/ml)
    public var concentration: Double {
        guard reconstitutionVolume > 0 else { return 0 }
        return vialSize / reconstitutionVolume
    }
    
    /// Calculate volume per injection (ml)
    public var volumePerInjection: Double {
        guard concentration > 0 else { return 0 }
        return dosePerInjection / concentration
    }
    
    /// Calculate doses per vial
    public var dosesPerVial: Int {
        guard dosePerInjection > 0 else { return 0 }
        return Int(floor(vialSize / dosePerInjection))
    }
    
    /// Buffer as multiplier (e.g., 1.1 for 10% buffer)
    public var bufferMultiplier: Double {
        1.0 + (buffer / 100.0)
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
        if dosePerInjection <= 0 {
            errors.append("Dose per injection must be greater than 0")
        }
        if dosePerInjection > vialSize {
            errors.append("Dose per injection cannot exceed vial size")
        }
        if buffer < 0 || buffer > 100 {
            errors.append("Buffer must be between 0% and 100%")
        }
        if let cost = costPerVial, cost < 0 {
            errors.append("Cost per vial cannot be negative")
        }
        if let leadTime = leadTimeDays, leadTime < 0 {
            errors.append("Lead time cannot be negative")
        }
        
        return errors
    }
    
    /// Check if input is valid
    public var isValid: Bool {
        validate().isEmpty
    }
}

// MARK: - Supply Output

/// Complete supply planning calculations
public struct SupplyOutput: Codable, Sendable, Hashable {
    // Per vial calculations
    public let concentration: Double // mg/ml
    public let dosesPerVial: Int
    public let daysPerVial: Int
    public let weeksPerVial: Double
    
    // Monthly calculations
    public let vialsPerMonth: Double // exact calculation
    public let monthlyVials: Int // rounded up with buffer
    public let monthlyDoses: Int
    
    // Draw volumes
    public let drawVolume: Double // ml per injection
    public let drawUnits: Int // syringe units
    
    // Reorder alerts
    public let reorderPoint: Int // days before running out
    public let reorderAmount: Int // vials to order
    
    // Cost estimates
    public let costPerVial: Double?
    public let monthlyCost: Double?
    public let annualCost: Double?
    
    // Warnings
    public let warnings: [String]
    
    public init(
        concentration: Double,
        dosesPerVial: Int,
        daysPerVial: Int,
        weeksPerVial: Double,
        vialsPerMonth: Double,
        monthlyVials: Int,
        monthlyDoses: Int,
        drawVolume: Double,
        drawUnits: Int,
        reorderPoint: Int,
        reorderAmount: Int,
        costPerVial: Double? = nil,
        monthlyCost: Double? = nil,
        annualCost: Double? = nil,
        warnings: [String] = []
    ) {
        self.concentration = concentration
        self.dosesPerVial = dosesPerVial
        self.daysPerVial = daysPerVial
        self.weeksPerVial = weeksPerVial
        self.vialsPerMonth = vialsPerMonth
        self.monthlyVials = monthlyVials
        self.monthlyDoses = monthlyDoses
        self.drawVolume = drawVolume
        self.drawUnits = drawUnits
        self.reorderPoint = reorderPoint
        self.reorderAmount = reorderAmount
        self.costPerVial = costPerVial
        self.monthlyCost = monthlyCost
        self.annualCost = annualCost
        self.warnings = warnings
    }
    
    // MARK: - Formatted Outputs
    
    /// Formatted concentration
    public var formattedConcentration: String {
        String(format: "%.1f mg/ml", concentration)
    }
    
    /// Formatted vial duration
    public var formattedVialDuration: String {
        if daysPerVial == 1 {
            return "1 day"
        } else if daysPerVial < 7 {
            return "\(daysPerVial) days"
        } else if weeksPerVial == 1 {
            return "1 week"
        } else if weeksPerVial < 4 {
            return String(format: "%.1f weeks", weeksPerVial)
        } else {
            let months = weeksPerVial / 4.33
            return String(format: "%.1f months", months)
        }
    }
    
    /// Formatted monthly supply
    public var formattedMonthlySupply: String {
        if monthlyVials == 1 {
            return "1 vial per month"
        } else {
            return "\(monthlyVials) vials per month"
        }
    }
    
    /// Formatted reorder point
    public var formattedReorderPoint: String {
        if reorderPoint == 1 {
            return "Reorder with 1 day remaining"
        } else if reorderPoint < 7 {
            return "Reorder with \(reorderPoint) days remaining"
        } else {
            let weeks = reorderPoint / 7
            return "Reorder with \(weeks) week\(weeks == 1 ? "" : "s") remaining"
        }
    }
    
    /// Formatted monthly cost
    public var formattedMonthlyCost: String? {
        guard let cost = monthlyCost else { return nil }
        return String(format: "$%.2f/month", cost)
    }
    
    /// Formatted annual cost
    public var formattedAnnualCost: String? {
        guard let cost = annualCost else { return nil }
        return String(format: "$%.0f/year", cost)
    }
    
    // MARK: - Checks
    
    /// Check if supply is expensive
    public var isExpensive: Bool {
        guard let monthly = monthlyCost else { return false }
        return monthly > 500
    }
    
    /// Check if reorder is needed soon
    public var needsReorderSoon: Bool {
        reorderPoint <= 7
    }
    
    /// Check if this is a high-volume protocol
    public var isHighVolume: Bool {
        monthlyVials >= 5
    }
    
    /// Check if vials last less than a week
    public var isShortVialLife: Bool {
        daysPerVial < 7
    }
}

// MARK: - Supply Plan

/// Complete supply plan for a protocol
public struct SupplyPlan: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public let protocolId: String
    public let peptides: [PeptideSupplyPlan]
    public let totalMonthlyVials: Int
    public let totalMonthlyCost: Double?
    public let createdAt: Date
    public let notes: String?
    
    public init(
        id: String = UUID().uuidString,
        protocolId: String,
        peptides: [PeptideSupplyPlan],
        totalMonthlyVials: Int,
        totalMonthlyCost: Double? = nil,
        createdAt: Date = Date(),
        notes: String? = nil
    ) {
        self.id = id
        self.protocolId = protocolId
        self.peptides = peptides
        self.totalMonthlyVials = totalMonthlyVials
        self.totalMonthlyCost = totalMonthlyCost
        self.createdAt = createdAt
        self.notes = notes
    }
    
    /// Check if plan has cost information
    public var hasCostData: Bool {
        totalMonthlyCost != nil
    }
    
    /// Formatted total monthly cost
    public var formattedTotalCost: String? {
        guard let cost = totalMonthlyCost else { return nil }
        return String(format: "$%.2f/month", cost)
    }
    
    /// Estimated annual cost
    public var estimatedAnnualCost: Double? {
        guard let monthly = totalMonthlyCost else { return nil }
        return monthly * 12
    }
    
    /// Check if this is an expensive protocol
    public var isExpensive: Bool {
        guard let cost = totalMonthlyCost else { return false }
        return cost > 1000
    }
}

// MARK: - Inventory Item

/// Represents a vial in inventory
public struct InventoryItem: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public let peptideId: String
    public let peptideName: String
    public let vialSize: Double // mg
    public let remainingDoses: Int
    public let expirationDate: Date?
    public let lotNumber: String?
    public let notes: String?
    
    public init(
        id: String = UUID().uuidString,
        peptideId: String,
        peptideName: String,
        vialSize: Double,
        remainingDoses: Int,
        expirationDate: Date? = nil,
        lotNumber: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.peptideId = peptideId
        self.peptideName = peptideName
        self.vialSize = vialSize
        self.remainingDoses = remainingDoses
        self.expirationDate = expirationDate
        self.lotNumber = lotNumber
        self.notes = notes
    }
    
    /// Check if vial is expired
    public var isExpired: Bool {
        guard let expiration = expirationDate else { return false }
        return expiration < Date()
    }
    
    /// Check if vial expires soon (within 30 days)
    public var expiresSoon: Bool {
        guard let expiration = expirationDate else { return false }
        let thirtyDaysFromNow = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        return expiration < thirtyDaysFromNow && !isExpired
    }
    
    /// Check if vial is empty
    public var isEmpty: Bool {
        remainingDoses <= 0
    }
    
    /// Days until expiration
    public var daysUntilExpiration: Int? {
        guard let expiration = expirationDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: expiration).day
    }
}

// MARK: - Reorder Alert

/// Alert for when to reorder supplies
public struct ReorderAlert: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public let peptideId: String
    public let peptideName: String
    public let currentStock: Int // vials
    public let daysRemaining: Int
    public let recommendedOrderQuantity: Int
    public let urgency: Urgency
    public let createdAt: Date
    
    public enum Urgency: String, Codable, Sendable, CaseIterable {
        case low
        case medium
        case high
        case critical
        
        public var displayName: String {
            rawValue.capitalized
        }
        
        public var color: String {
            switch self {
            case .low: return "#10b981"      // green
            case .medium: return "#f59e0b"    // amber
            case .high: return "#ef4444"      // red
            case .critical: return "#dc2626"  // dark red
            }
        }
    }
    
    public init(
        id: String = UUID().uuidString,
        peptideId: String,
        peptideName: String,
        currentStock: Int,
        daysRemaining: Int,
        recommendedOrderQuantity: Int,
        urgency: Urgency,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.peptideId = peptideId
        self.peptideName = peptideName
        self.currentStock = currentStock
        self.daysRemaining = daysRemaining
        self.recommendedOrderQuantity = recommendedOrderQuantity
        self.urgency = urgency
        self.createdAt = createdAt
    }
    
    /// Check if immediate action is needed
    public var needsImmediateAction: Bool {
        urgency == .critical || urgency == .high
    }
    
    /// Formatted message for the alert
    public var message: String {
        switch urgency {
        case .critical:
            return "Order immediately - only \(daysRemaining) days remaining"
        case .high:
            return "Order soon - \(daysRemaining) days of supply left"
        case .medium:
            return "Consider ordering - \(daysRemaining) days remaining"
        case .low:
            return "Stock is adequate - \(daysRemaining) days remaining"
        }
    }
}
