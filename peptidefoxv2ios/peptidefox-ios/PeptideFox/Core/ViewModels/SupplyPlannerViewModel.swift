import SwiftUI
import Observation

// MARK: - Supply Output
public struct SupplyOutput {
    public let dosesPerVial: Int
    public let daysPerVial: Int
    public let vialsPerMonth: Int
    public let monthlyVials: Int
    public let reorderSchedule: [ReorderPoint]
    public let estimatedMonthlyCost: Double?
    
    public init(
        dosesPerVial: Int,
        daysPerVial: Int,
        vialsPerMonth: Int,
        monthlyVials: Int,
        reorderSchedule: [ReorderPoint],
        estimatedMonthlyCost: Double? = nil
    ) {
        self.dosesPerVial = dosesPerVial
        self.daysPerVial = daysPerVial
        self.vialsPerMonth = vialsPerMonth
        self.monthlyVials = monthlyVials
        self.reorderSchedule = reorderSchedule
        self.estimatedMonthlyCost = estimatedMonthlyCost
    }
}

// MARK: - Reorder Point
public struct ReorderPoint: Identifiable {
    public let id = UUID()
    public let day: Int
    public let vialNumber: Int
    public let isUrgent: Bool
    
    public var displayDay: String {
        "Day \(day)"
    }
    
    public var displayVial: String {
        "Vial #\(vialNumber)"
    }
}

@MainActor
@Observable
public final class SupplyPlannerViewModel {
    // Input State
    var selectedPeptide: Peptide?
    var vialSize: Double = 5.0
    var reconVolume: Double = 2.0
    var dosePerInjection: Double = 0.25
    var frequency: FrequencySchedule = FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
    var costPerVial: Double = 35.0
    
    // Output State
    var supplyOutput: SupplyOutput?
    
    // UI State
    var showingPeptideSelector: Bool = false
    
    public init() {
        // Set default to BPC-157
        selectedPeptide = PeptideDatabase.peptide(withId: "bpc-157")
        calculateSupply()
    }
    
    // MARK: - Actions
    
    func selectPeptide(_ peptide: Peptide) {
        selectedPeptide = peptide
        
        // Update defaults based on peptide
        dosePerInjection = peptide.typicalDose.min
        
        switch peptide.id {
        case "semaglutide", "tirzepatide":
            frequency = FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        case "bpc-157", "ghk-cu", "semax":
            frequency = FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        case "tb-500", "mots-c":
            frequency = FrequencySchedule(intervalDays: 3, injectionsPerWeek: 2, pattern: "2-3x per week")
        default:
            frequency = FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        }
        
        calculateSupply()
    }
    
    func calculateSupply() {
        guard let peptide = selectedPeptide else {
            supplyOutput = nil
            return
        }
        
        // Core calculations
        let dosesPerVial = Int(floor(vialSize / dosePerInjection))
        let daysPerVial = dosesPerVial * frequency.intervalDays
        let vialsPerMonth = Int(ceil(30.0 / Double(daysPerVial)))
        
        // Generate reorder schedule
        let reorderSchedule = generateReorderSchedule(
            daysPerVial: daysPerVial,
            vialsNeeded: vialsPerMonth + 1 // Extra for continuity
        )
        
        // Calculate monthly cost
        let monthlyCost = Double(vialsPerMonth) * costPerVial
        
        supplyOutput = SupplyOutput(
            dosesPerVial: dosesPerVial,
            daysPerVial: daysPerVial,
            vialsPerMonth: vialsPerMonth,
            monthlyVials: vialsPerMonth,
            reorderSchedule: reorderSchedule,
            estimatedMonthlyCost: monthlyCost
        )
    }
    
    func generateReorderSchedule(daysPerVial: Int, vialsNeeded: Int) -> [ReorderPoint] {
        var schedule: [ReorderPoint] = []
        
        for vialNum in 1...vialsNeeded {
            let day = 1 + (vialNum - 1) * daysPerVial
            let isUrgent = day > 30 - 7 // Warn if running out within a week
            
            schedule.append(ReorderPoint(
                day: day,
                vialNumber: vialNum,
                isUrgent: isUrgent
            ))
        }
        
        return schedule
    }
    
    func updateFrequency(_ pattern: String) {
        switch pattern.lowercased() {
        case "daily":
            frequency = FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        case "every other day":
            frequency = FrequencySchedule(intervalDays: 2, injectionsPerWeek: 3, pattern: "every other day")
        case "weekly":
            frequency = FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        case "2-3x per week":
            frequency = FrequencySchedule(intervalDays: 3, injectionsPerWeek: 2, pattern: "2-3x per week")
        default:
            frequency = FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        }
        
        calculateSupply()
    }
    
    func reset() {
        selectedPeptide = PeptideDatabase.peptide(withId: "bpc-157")
        vialSize = 5.0
        reconVolume = 2.0
        dosePerInjection = 0.25
        frequency = FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        costPerVial = 35.0
        calculateSupply()
    }
}
