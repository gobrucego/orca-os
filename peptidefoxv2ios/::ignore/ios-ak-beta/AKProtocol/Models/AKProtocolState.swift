import Foundation
import SwiftUI

// MARK: - Journey State
class AKProtocolState: ObservableObject {
    @Published var selectedWeek: Int = 1  // 1-4
    @Published var selectedDay: Int = 0   // 0-6 (Sun-Sat)
    @Published var compoundAdjustments: [String: CompoundConfig] = [:]

    init() {
        loadAdjustments()
    }

    func loadAdjustments() {
        if let data = UserDefaults.standard.data(forKey: "compoundAdjustments"),
           let decoded = try? JSONDecoder().decode([String: CompoundConfig].self, from: data) {
            compoundAdjustments = decoded
        }
    }

    func saveAdjustments() {
        if let encoded = try? JSONEncoder().encode(compoundAdjustments) {
            UserDefaults.standard.set(encoded, forKey: "compoundAdjustments")
        }
    }

    func updateCompound(_ name: String, dose: String? = nil, concentration: String? = nil, notes: String? = nil) {
        var config = compoundAdjustments[name] ?? CompoundConfig(dose: "", concentration: "", notes: "")
        if let dose = dose { config.dose = dose }
        if let concentration = concentration { config.concentration = concentration }
        if let notes = notes { config.notes = notes }
        compoundAdjustments[name] = config
        saveAdjustments()
    }

    func resetCompound(_ name: String) {
        compoundAdjustments.removeValue(forKey: name)
        saveAdjustments()
    }

    func getAdjustedDose(for compoundName: String, defaultDose: String) -> String {
        return compoundAdjustments[compoundName]?.dose.isEmpty == false ? compoundAdjustments[compoundName]!.dose : defaultDose
    }

    func getAdjustedConcentration(for compoundName: String, defaultConcentration: String) -> String {
        return compoundAdjustments[compoundName]?.concentration.isEmpty == false ? compoundAdjustments[compoundName]!.concentration : defaultConcentration
    }

    func getAdjustedNotes(for compoundName: String, defaultNotes: String) -> String {
        return compoundAdjustments[compoundName]?.notes.isEmpty == false ? compoundAdjustments[compoundName]!.notes : defaultNotes
    }
}

// MARK: - Compound Config
struct CompoundConfig: Codable, Hashable {
    var dose: String
    var concentration: String
    var notes: String
}

// MARK: - Week Number
enum WeekNumber: Int, CaseIterable, Identifiable {
    case week1 = 1
    case week2 = 2
    case week3 = 3
    case week4 = 4

    var id: Int { rawValue }

    var displayName: String {
        "Week \(rawValue)"
    }
}

// MARK: - Day of Week
enum DayOfWeek: Int, CaseIterable, Identifiable {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6

    var id: Int { rawValue }

    var shortName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }
}

// MARK: - Time of Day
enum TimeOfDay: String, CaseIterable, Identifiable {
    case waking = "Waking"
    case am = "AM"
    case midday = "Mid-Day"
    case evening = "Evening"
    case sleep = "Sleep & Recovery"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .waking: return "🌅"
        case .am: return "🌞"
        case .midday: return "🧠"
        case .evening: return "🌙"
        case .sleep: return "😴"
        }
    }
}

// MARK: - Protocol Compound
struct ProtocolCompound: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var weeklySchedule: [Int: WeekSchedule]  // Week number -> schedule
    var defaultConcentration: String
    var timeOfDay: TimeOfDay
    var unit: String  // mg, µg, IU

    struct WeekSchedule: Hashable {
        var dose: String
        var days: [Int]  // 0-6 for Sun-Sat, empty array means all days
        var notes: String
    }

    // Check if compound is scheduled for a specific week and day
    func isScheduled(week: Int, day: Int) -> Bool {
        guard let schedule = weeklySchedule[week] else { return false }
        if schedule.days.isEmpty { return true }  // Empty = all days
        return schedule.days.contains(day)
    }

    // Get dose for specific week
    func getDose(for week: Int) -> String {
        return weeklySchedule[week]?.dose ?? ""
    }
}

// MARK: - Compound Display Info
struct CompoundDisplayInfo {
    let name: String
    let dose: String
    let concentration: String
    let notes: String
    let drawVolume: String
}
