import SwiftUI
import Observation

// MARK: - Frequency Pattern
public enum FrequencyPattern: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case everyOtherDay = "Every Other Day"
    case weekly = "Weekly"
    
    public var id: String { rawValue }
    
    var intervalDays: Int {
        switch self {
        case .daily: return 1
        case .everyOtherDay: return 2
        case .weekly: return 7
        }
    }
}

// MARK: - Dose Milestone
public struct DoseMilestone: Identifiable {
    public let id = UUID()
    public let weekRange: String
    public let dose: Double
    public let weekStart: Int
    public let weekEnd: Int
    
    public init(weekRange: String, dose: Double, weekStart: Int, weekEnd: Int) {
        self.weekRange = weekRange
        self.dose = dose
        self.weekStart = weekStart
        self.weekEnd = weekEnd
    }
}

@MainActor
@Observable
public final class GLP1PlannerViewModel {
    // Input State
    var selectedPeptide: Peptide?
    var startingDose: Double = 0.25
    var frequency: FrequencyPattern = .weekly
    var weeklySchedule: [DoseMilestone] = []
    
    // Computed
    var totalWeeks: Int {
        weeklySchedule.last?.weekEnd ?? 0
    }
    
    var currentDoseDisplay: String {
        guard let peptide = selectedPeptide else { return "—" }
        return "\(formatDose(startingDose)) \(peptide.typicalDose.unit)"
    }
    
    public init() {
        // Set default to Semaglutide
        selectedPeptide = PeptideDatabase.peptide(withId: "semaglutide")
        generateTitrationSchedule()
    }
    
    // MARK: - Actions
    
    func selectPeptide(_ peptide: Peptide) {
        selectedPeptide = peptide
        
        // Set appropriate starting dose based on peptide
        switch peptide.id {
        case "semaglutide":
            startingDose = 0.25
        case "tirzepatide":
            startingDose = 2.5
        default:
            startingDose = peptide.typicalDose.min
        }
        
        generateTitrationSchedule()
    }
    
    func updateFrequency(_ newFrequency: FrequencyPattern) {
        frequency = newFrequency
    }
    
    func generateTitrationSchedule() {
        guard let peptide = selectedPeptide else {
            weeklySchedule = []
            return
        }
        
        weeklySchedule = generateScheduleForPeptide(peptide)
    }
    
    // MARK: - Schedule Generation
    
    private func generateScheduleForPeptide(_ peptide: Peptide) -> [DoseMilestone] {
        switch peptide.id {
        case "semaglutide":
            return [
                DoseMilestone(weekRange: "Week 1-4", dose: 0.25, weekStart: 1, weekEnd: 4),
                DoseMilestone(weekRange: "Week 5-8", dose: 0.50, weekStart: 5, weekEnd: 8),
                DoseMilestone(weekRange: "Week 9-12", dose: 1.00, weekStart: 9, weekEnd: 12),
                DoseMilestone(weekRange: "Week 13-16", dose: 1.70, weekStart: 13, weekEnd: 16),
                DoseMilestone(weekRange: "Week 17+", dose: 2.40, weekStart: 17, weekEnd: 24)
            ]
            
        case "tirzepatide":
            return [
                DoseMilestone(weekRange: "Week 1-4", dose: 2.5, weekStart: 1, weekEnd: 4),
                DoseMilestone(weekRange: "Week 5-8", dose: 5.0, weekStart: 5, weekEnd: 8),
                DoseMilestone(weekRange: "Week 9-12", dose: 7.5, weekStart: 9, weekEnd: 12),
                DoseMilestone(weekRange: "Week 13-16", dose: 10.0, weekStart: 13, weekEnd: 16),
                DoseMilestone(weekRange: "Week 17-20", dose: 12.5, weekStart: 17, weekEnd: 20),
                DoseMilestone(weekRange: "Week 21+", dose: 15.0, weekStart: 21, weekEnd: 28)
            ]
            
        default:
            // Generic escalation
            let minDose = peptide.typicalDose.min
            let maxDose = peptide.typicalDose.max
            let increment = (maxDose - minDose) / 4
            
            return [
                DoseMilestone(weekRange: "Week 1-4", dose: minDose, weekStart: 1, weekEnd: 4),
                DoseMilestone(weekRange: "Week 5-8", dose: minDose + increment, weekStart: 5, weekEnd: 8),
                DoseMilestone(weekRange: "Week 9-12", dose: minDose + (increment * 2), weekStart: 9, weekEnd: 12),
                DoseMilestone(weekRange: "Week 13-16", dose: minDose + (increment * 3), weekStart: 13, weekEnd: 16),
                DoseMilestone(weekRange: "Week 17+", dose: maxDose, weekStart: 17, weekEnd: 24)
            ]
        }
    }
    
    func calculateTotalWeeks() -> Int {
        return weeklySchedule.last?.weekEnd ?? 0
    }
    
    // MARK: - Helpers
    
    private func formatDose(_ dose: Double) -> String {
        if dose.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", dose)
        } else if dose < 1 {
            return String(format: "%.2f", dose)
        } else {
            return String(format: "%.1f", dose)
        }
    }
}
