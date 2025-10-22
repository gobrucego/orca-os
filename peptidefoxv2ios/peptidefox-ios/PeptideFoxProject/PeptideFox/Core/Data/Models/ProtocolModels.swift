import Foundation

// MARK: - Core Types

public enum ProtocolState: String, Codable, Sendable {
    case draft = "DRAFT"
    case active = "ACTIVE"
    case completed = "COMPLETED"
}

public enum DoseUnit: String, Codable, Sendable {
    case mg
    case mcg
    case iu
}

public enum DeviceType: String, Codable, Sendable {
    case insulinSyringe = "insulin-syringe"
    case luerLock = "luer-lock"
    case pen
    case autoInjector = "auto-injector"
    case unknown
    
    public var maxVolume: Double {
        switch self {
        case .pen: return 0.5
        case .insulinSyringe: return 1.0
        case .luerLock: return 3.0
        case .autoInjector: return 2.0
        case .unknown: return 1.0
        }
    }
}

public enum TimeOfDay: String, Codable, Sendable {
    case morning
    case afternoon
    case evening
    case bedtime
    
    public var hourOfDay: Int {
        switch self {
        case .morning: return 8
        case .afternoon: return 14
        case .evening: return 18
        case .bedtime: return 22
        }
    }
}

public enum FrequencyPattern: String, Codable, Sendable {
    case daily
    case weekly
    case custom
}

// MARK: - Structures

public struct FrequencySchedule: Codable, Sendable, Hashable {
    public let intervalDays: Int
    public let injectionsPerWeek: Double
    public let pattern: FrequencyPattern
    public let specificDays: [String]?
    
    public init(
        intervalDays: Int,
        injectionsPerWeek: Double,
        pattern: FrequencyPattern,
        specificDays: [String]? = nil
    ) {
        self.intervalDays = intervalDays
        self.injectionsPerWeek = injectionsPerWeek
        self.pattern = pattern
        self.specificDays = specificDays
    }
}

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
}

public struct PeptideTiming: Codable, Sendable, Hashable {
    public let timeOfDay: TimeOfDay?
    public let withMeals: Bool?
    public let fasted: Bool?
    public let separation: TimingSeparation?
    
    public init(
        timeOfDay: TimeOfDay? = nil,
        withMeals: Bool? = nil,
        fasted: Bool? = nil,
        separation: TimingSeparation? = nil
    ) {
        self.timeOfDay = timeOfDay
        self.withMeals = withMeals
        self.fasted = fasted
        self.separation = separation
    }
}

public struct TimingSeparation: Codable, Sendable, Hashable {
    public let from: String
    public let hours: Int
    
    public init(from: String, hours: Int) {
        self.from = from
        self.hours = hours
    }
}

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
}

public struct PhaseAssignment: Codable, Sendable, Hashable {
    public let phaseId: String
    public let intensity: String?
    
    public init(phaseId: String, intensity: String? = nil) {
        self.phaseId = phaseId
        self.intensity = intensity
    }
}

public struct ProtocolPeptide: Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let libraryId: String?
    public let dose: PeptideDosePlan
    public let timing: PeptideTiming
    public let supply: PeptideSupplyPlan
    public let phases: [PhaseAssignment]
    
    public init(
        id: String,
        name: String,
        libraryId: String? = nil,
        dose: PeptideDosePlan,
        timing: PeptideTiming,
        supply: PeptideSupplyPlan,
        phases: [PhaseAssignment]
    ) {
        self.id = id
        self.name = name
        self.libraryId = libraryId
        self.dose = dose
        self.timing = timing
        self.supply = supply
        self.phases = phases
    }
}

public struct ProtocolPhase: Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let weeks: String
    public let description: String
    
    public init(id: String, name: String, weeks: String, description: String) {
        self.id = id
        self.name = name
        self.weeks = weeks
        self.description = description
    }
}

public struct ProtocolMetadata: Codable, Sendable, Hashable {
    public let goal: String
    public let description: String?
    public let tags: [String]?
    
    public init(goal: String, description: String? = nil, tags: [String]? = nil) {
        self.goal = goal
        self.description = description
        self.tags = tags
    }
}

// MARK: - Protocol Base

public struct ProtocolBase: Codable, Sendable, Hashable {
    public let id: String
    public let version: Int
    public let state: ProtocolState
    public let name: String
    public let metadata: ProtocolMetadata
    public let peptides: [ProtocolPeptide]
    public let phases: [ProtocolPhase]
    public let createdAt: String
    public let updatedAt: String
    public let parentId: String?
    
    public init(
        id: String,
        version: Int,
        state: ProtocolState,
        name: String,
        metadata: ProtocolMetadata,
        peptides: [ProtocolPeptide],
        phases: [ProtocolPhase],
        createdAt: String,
        updatedAt: String,
        parentId: String? = nil
    ) {
        self.id = id
        self.version = version
        self.state = state
        self.name = name
        self.metadata = metadata
        self.peptides = peptides
        self.phases = phases
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.parentId = parentId
    }
}
