import SwiftUI
import Observation

// MARK: - Protocol Peptide
public struct ProtocolPeptide: Identifiable, Hashable {
    public let id = UUID()
    public let peptide: Peptide
    public var dose: Double
    public var frequency: FrequencySchedule
    public var phase: ProtocolPhase
    
    public init(peptide: Peptide, dose: Double, frequency: FrequencySchedule, phase: ProtocolPhase = .foundation) {
        self.peptide = peptide
        self.dose = dose
        self.frequency = frequency
        self.phase = phase
    }
    
    public var doseDisplay: String {
        "\(formatDose(dose)) \(peptide.typicalDose.unit) \(frequency.pattern)"
    }
    
    private func formatDose(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else if value < 1 {
            return String(format: "%.2f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
}

// MARK: - Protocol Phase
public enum ProtocolPhase: String, CaseIterable, Identifiable {
    case foundation = "Foundation"
    case build = "Build"
    case maintain = "Maintain"
    
    public var id: String { rawValue }
    
    public var description: String {
        switch self {
        case .foundation: return "Initial 4-6 weeks: Establish baseline"
        case .build: return "Weeks 7-12: Intensify protocol"
        case .maintain: return "Week 13+: Long-term optimization"
        }
    }
    
    public var color: Color {
        switch self {
        case .foundation: return .blue
        case .build: return .purple
        case .maintain: return .green
        }
    }
}

// MARK: - Validation Result
public struct ValidationResult {
    public let isValid: Bool
    public let warnings: [ValidationWarning]
    public let errors: [ValidationError]
    
    public var canActivate: Bool {
        isValid && errors.isEmpty
    }
}

public struct ValidationWarning: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String
    public let severity: Severity
    
    public enum Severity {
        case info
        case caution
        case warning
    }
}

public struct ValidationError: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String
}

@MainActor
@Observable
public final class ProtocolBuilderViewModel {
    // Input State
    var protocolName: String = ""
    var goal: String = "Fat Loss"
    var peptides: [ProtocolPeptide] = []
    var validationResult: ValidationResult?
    
    // UI State
    var showingPeptideSelector: Bool = false
    var showingValidation: Bool = false
    
    // Goals
    let availableGoals = ["Fat Loss", "Muscle Gain", "Recovery", "Longevity", "Performance", "General Health"]
    
    public init() {}
    
    // MARK: - Actions
    
    func addPeptide(_ peptide: Peptide) {
        // Set default dose and frequency based on peptide
        let defaultDose = peptide.typicalDose.min
        let defaultFrequency = inferFrequency(from: peptide.frequency)
        
        let protocolPeptide = ProtocolPeptide(
            peptide: peptide,
            dose: defaultDose,
            frequency: defaultFrequency,
            phase: .foundation
        )
        
        peptides.append(protocolPeptide)
        showingPeptideSelector = false
        validate()
    }
    
    func removePeptide(at index: Int) {
        guard index < peptides.count else { return }
        peptides.remove(at: index)
        validate()
    }
    
    func removePeptide(_ protocolPeptide: ProtocolPeptide) {
        peptides.removeAll { $0.id == protocolPeptide.id }
        validate()
    }
    
    func updatePeptideDose(_ protocolPeptide: ProtocolPeptide, dose: Double) {
        if let index = peptides.firstIndex(where: { $0.id == protocolPeptide.id }) {
            peptides[index] = ProtocolPeptide(
                peptide: protocolPeptide.peptide,
                dose: dose,
                frequency: protocolPeptide.frequency,
                phase: protocolPeptide.phase
            )
            validate()
        }
    }
    
    func updatePeptidePhase(_ protocolPeptide: ProtocolPeptide, phase: ProtocolPhase) {
        if let index = peptides.firstIndex(where: { $0.id == protocolPeptide.id }) {
            peptides[index] = ProtocolPeptide(
                peptide: protocolPeptide.peptide,
                dose: protocolPeptide.dose,
                frequency: protocolPeptide.frequency,
                phase: phase
            )
        }
    }
    
    func validate() {
        var warnings: [ValidationWarning] = []
        var errors: [ValidationError] = []
        
        // Check protocol name
        if protocolName.isEmpty {
            warnings.append(ValidationWarning(
                title: "No Protocol Name",
                message: "Consider naming your protocol for easy reference",
                severity: .info
            ))
        }
        
        // Check if empty
        if peptides.isEmpty {
            errors.append(ValidationError(
                title: "No Peptides",
                message: "Add at least one peptide to your protocol"
            ))
        }
        
        // Check dose ranges
        for protocolPeptide in peptides {
            let peptide = protocolPeptide.peptide
            let dose = protocolPeptide.dose
            
            if dose < peptide.typicalDose.min {
                warnings.append(ValidationWarning(
                    title: "\(peptide.name) Below Range",
                    message: "Dose \(dose) \(peptide.typicalDose.unit) is below typical minimum",
                    severity: .caution
                ))
            }
            
            if dose > peptide.typicalDose.max {
                errors.append(ValidationError(
                    title: "\(peptide.name) Exceeds Maximum",
                    message: "Dose \(dose) \(peptide.typicalDose.unit) exceeds safe maximum of \(peptide.typicalDose.max)"
                ))
            }
        }
        
        // Check for drug interactions (simplified)
        let glp1Count = peptides.filter { $0.peptide.category == .glp1 }.count
        if glp1Count > 1 {
            warnings.append(ValidationWarning(
                title: "Multiple GLP-1 Agonists",
                message: "Using multiple GLP-1s simultaneously is not recommended",
                severity: .warning
            ))
        }
        
        validationResult = ValidationResult(
            isValid: errors.isEmpty,
            warnings: warnings,
            errors: errors
        )
    }
    
    func saveAsDraft() {
        // In a real app, save to UserDefaults or CoreData
        print("Saving protocol as draft: \(protocolName)")
    }
    
    func activate() {
        guard validationResult?.canActivate == true else { return }
        // In a real app, transition to active protocol state
        print("Activating protocol: \(protocolName)")
    }
    
    func reset() {
        protocolName = ""
        goal = "Fat Loss"
        peptides = []
        validationResult = nil
    }
    
    // MARK: - Helpers
    
    private func inferFrequency(from frequencyString: String) -> FrequencySchedule {
        let lower = frequencyString.lowercased()
        
        if lower.contains("daily") {
            return FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        } else if lower.contains("weekly") {
            return FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1, pattern: "weekly")
        } else if lower.contains("2-3") || lower.contains("twice") {
            return FrequencySchedule(intervalDays: 3, injectionsPerWeek: 2, pattern: "2-3x per week")
        } else {
            return FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        }
    }
}
