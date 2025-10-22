import Foundation
import Combine

// MARK: - Journey State
class GLPJourneyState: ObservableObject {
    @Published var agent: GLPAgent?
    @Published var frequency: DosingFrequency?
    @Published var phases: [ProtocolPhase] = []
    @Published var protocolDuration: Int = 16

    func reset() {
        agent = nil
        frequency = nil
        phases = []
        protocolDuration = 16
    }
}

// MARK: - GLP Agent
enum GLPAgent: String, CaseIterable, Identifiable {
    case semaglutide
    case tirzepatide
    case retatrutide

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .semaglutide: return "Semaglutide"
        case .tirzepatide: return "Tirzepatide"
        case .retatrutide: return "Retatrutide"
        }
    }

    var subtitle: String {
        switch self {
        case .semaglutide: return "Ozempic / Wegovy"
        case .tirzepatide: return "Mounjaro / Zepbound"
        case .retatrutide: return "Research compound"
        }
    }

    var description: String {
        switch self {
        case .semaglutide:
            return "Pure GLP-1 agonist. Well-studied, predictable, FDA-approved."
        case .tirzepatide:
            return "Dual GLP-1/GIP agonist. More effective than semaglutide."
        case .retatrutide:
            return "Triple agonist (GLP-1/GIP/Glucagon). Most powerful, research phase."
        }
    }

    var bestFor: [String] {
        switch self {
        case .semaglutide:
            return [
                "First-time GLP-1 users",
                "Moderate weight loss goals (10-15%)",
                "Prefer proven, FDA-approved option"
            ]
        case .tirzepatide:
            return [
                "Greater weight loss desired (15-20%)",
                "Metabolic health improvement",
                "Willing to pay premium"
            ]
        case .retatrutide:
            return [
                "Aggressive fat loss (20-25%)",
                "Advanced users",
                "Research/experimental use"
            ]
        }
    }

    var intensity: Double {
        switch self {
        case .semaglutide: return 0.50
        case .tirzepatide: return 0.75
        case .retatrutide: return 1.00
        }
    }

    var tolerability: Double {
        switch self {
        case .semaglutide: return 0.75
        case .tirzepatide: return 0.78
        case .retatrutide: return 0.72
        }
    }

    var metabolicScope: Double {
        switch self {
        case .semaglutide: return 0.35
        case .tirzepatide: return 0.70
        case .retatrutide: return 1.00
        }
    }

    var color: String {
        switch self {
        case .semaglutide: return "blue"
        case .tirzepatide: return "teal"
        case .retatrutide: return "purple"
        }
    }
}

// MARK: - Dosing Frequency
enum DosingFrequency: String, CaseIterable, Identifiable {
    case weekly
    case twiceWeekly = "twice-weekly"
    case q3d
    case q2d

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .weekly: return "Weekly"
        case .twiceWeekly: return "Twice Weekly (2x/week)"
        case .q3d: return "Every 3 Days (q3d)"
        case .q2d: return "Every Other Day (q2d)"
        }
    }

    var injectionCount: String {
        switch self {
        case .weekly: return "52 injections/year"
        case .twiceWeekly: return "104 injections/year"
        case .q3d: return "~120 injections/year"
        case .q2d: return "~180 injections/year"
        }
    }

    var stability: Double {
        switch self {
        case .weekly: return 0.60
        case .twiceWeekly: return 0.90
        case .q3d: return 0.80
        case .q2d: return 0.95
        }
    }

    var sideEffects: Double {
        switch self {
        case .weekly: return 0.70
        case .twiceWeekly: return 0.40
        case .q3d: return 0.50
        case .q2d: return 0.30
        }
    }

    var convenience: Double {
        switch self {
        case .weekly: return 0.95
        case .twiceWeekly: return 0.75
        case .q3d: return 0.70
        case .q2d: return 0.60
        }
    }

    var pros: [String] {
        switch self {
        case .weekly:
            return [
                "Convenient (same day each week)",
                "FDA-approved pattern",
                "Simple to remember"
            ]
        case .twiceWeekly:
            return [
                "40% more stable drug levels",
                "Fewer side effects",
                "Better appetite control",
                "Improved results"
            ]
        case .q3d:
            return [
                "Very stable levels",
                "Flexible schedule",
                "Better than weekly"
            ]
        case .q2d:
            return [
                "Maximum stable levels",
                "Minimal side effects",
                "Steady appetite control",
                "Best results"
            ]
        }
    }

    var cons: [String] {
        switch self {
        case .weekly:
            return [
                "Higher side effects initially",
                "Hunger returns end of week",
                "Less stable drug levels"
            ]
        case .twiceWeekly:
            return [
                "More injections",
                "Requires tracking"
            ]
        case .q3d:
            return [
                "More frequent than 2x/week",
                "Requires planning"
            ]
        case .q2d:
            return [
                "Most frequent injections",
                "Requires discipline"
            ]
        }
    }

    var bestFor: String {
        switch self {
        case .weekly:
            return "Busy schedules, beginners, maximum convenience"
        case .twiceWeekly:
            return "Best overall results with manageable schedule"
        case .q3d:
            return "Users wanting high stability with flexibility"
        case .q2d:
            return "Advanced users prioritizing optimal results over convenience"
        }
    }
}

// MARK: - Protocol Phase
struct ProtocolPhase: Identifiable {
    let id = UUID()
    var name: String
    var startWeek: Int
    var endWeek: Int
    var dose: Double
    var frequency: DosingFrequency

    var durationWeeks: Int {
        endWeek - startWeek + 1
    }
}
