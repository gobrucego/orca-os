//
//  Protocol.swift
//  PeptideFox
//
//  Protocol system models for managing peptide protocols through their lifecycle.
//  Implements a discriminated union pattern with state machine transitions.
//

import Foundation

// MARK: - Protocol Peptide

/// A peptide configured for use in a protocol with dosing and timing details
public struct ProtocolPeptide: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let libraryId: String?
    public let dose: PeptideDosePlan
    public let timing: PeptideTiming
    public let supply: PeptideSupplyPlan
    public let phases: [PhaseAssignment]
    public let reference: PeptideReference?
    
    public init(
        id: String,
        name: String,
        libraryId: String? = nil,
        dose: PeptideDosePlan,
        timing: PeptideTiming,
        supply: PeptideSupplyPlan,
        phases: [PhaseAssignment],
        reference: PeptideReference? = nil
    ) {
        self.id = id
        self.name = name
        self.libraryId = libraryId
        self.dose = dose
        self.timing = timing
        self.supply = supply
        self.phases = phases
        self.reference = reference
    }
    
    /// Check if peptide is assigned to a specific phase
    public func isInPhase(_ phaseId: String) -> Bool {
        phases.contains { $0.phaseId == phaseId }
    }
    
    /// Get intensity for a specific phase
    public func intensity(for phaseId: String) -> PhaseIntensity? {
        phases.first { $0.phaseId == phaseId }?.intensity
    }
    
    /// Check if this is a core peptide in any phase
    public var isCore: Bool {
        phases.contains { $0.intensity == .core }
    }
}

// MARK: - Protocol Phase

/// A phase within a protocol representing a time period with specific goals
public struct ProtocolPhase: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let weeks: String
    public let description: String
    
    public init(
        id: String,
        name: String,
        weeks: String,
        description: String
    ) {
        self.id = id
        self.name = name
        self.weeks = weeks
        self.description = description
    }
    
    /// Parse weeks string to get duration
    public var duration: Int? {
        let numbers = weeks.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .compactMap { Int($0) }
        return numbers.first
    }
    
    /// Check if this is a range (e.g., "4-8 weeks")
    public var isRange: Bool {
        weeks.contains("-")
    }
}

// MARK: - Protocol Metadata

/// Metadata describing the protocol's purpose and classification
public struct ProtocolMetadata: Codable, Sendable, Hashable {
    public let goal: String
    public let description: String?
    public let tags: [String]?
    
    public init(
        goal: String,
        description: String? = nil,
        tags: [String]? = nil
    ) {
        self.goal = goal
        self.description = description
        self.tags = tags
    }
    
    /// All tags as a set for efficient lookup
    public var tagSet: Set<String> {
        Set(tags ?? [])
    }
    
    /// Check if protocol has a specific tag
    public func hasTag(_ tag: String) -> Bool {
        tagSet.contains(tag)
    }
}

// MARK: - Protocol Base

/// Base protocol structure shared by all states
public struct ProtocolBase: Codable, Sendable, Hashable {
    public let id: String
    public let version: Int
    public let state: ProtocolState
    public let name: String
    public let metadata: ProtocolMetadata
    public let peptides: [ProtocolPeptide]
    public let phases: [ProtocolPhase]
    public let createdAt: Date
    public let updatedAt: Date
    public let parentId: String?
    
    public init(
        id: String = UUID().uuidString,
        version: Int = 1,
        state: ProtocolState,
        name: String,
        metadata: ProtocolMetadata,
        peptides: [ProtocolPeptide] = [],
        phases: [ProtocolPhase] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
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
    
    // MARK: - Computed Properties
    
    /// Total number of peptides in the protocol
    public var peptideCount: Int {
        peptides.count
    }
    
    /// Total number of phases
    public var phaseCount: Int {
        phases.count
    }
    
    /// Check if protocol is empty
    public var isEmpty: Bool {
        peptides.isEmpty
    }
    
    /// Get all unique peptide categories
    public var categories: Set<PeptideCategory> {
        Set(peptides.compactMap { peptide in
            // Try to parse category from reference if available
            if let categoryString = peptide.reference?.category {
                return PeptideCategory(rawValue: categoryString)
            }
            return nil
        })
    }
    
    /// Estimated total duration in weeks
    public var estimatedDuration: Int? {
        let durations = phases.compactMap { $0.duration }
        return durations.isEmpty ? nil : durations.reduce(0, +)
    }
}

// MARK: - Protocol Draft

/// A protocol in draft state that can be edited
public struct ProtocolDraft: Codable, Sendable, Hashable {
    public let base: ProtocolBase
    public let validation: ValidationResult
    public let lastValidatedHash: String?
    
    public init(
        base: ProtocolBase,
        validation: ValidationResult,
        lastValidatedHash: String? = nil
    ) {
        self.base = base
        self.validation = validation
        self.lastValidatedHash = lastValidatedHash
    }
    
    /// Check if draft needs revalidation
    public var needsValidation: Bool {
        lastValidatedHash != validation.hash
    }
    
    /// Check if draft can be activated
    public var canActivate: Bool {
        validation.valid && !needsValidation
    }
    
    /// Create a new draft with updated base
    public func with(base: ProtocolBase) -> ProtocolDraft {
        ProtocolDraft(
            base: base,
            validation: validation,
            lastValidatedHash: lastValidatedHash
        )
    }
    
    /// Create a new draft with updated validation
    public func with(validation: ValidationResult) -> ProtocolDraft {
        ProtocolDraft(
            base: base,
            validation: validation,
            lastValidatedHash: validation.hash
        )
    }
}

// MARK: - Protocol Active

/// An active protocol that is currently being followed
public struct ProtocolActive: Codable, Sendable, Hashable {
    public let base: ProtocolBase
    public let validation: ValidationResult
    public let snapshot: ActiveProtocolSnapshot
    
    public init(
        base: ProtocolBase,
        validation: ValidationResult,
        snapshot: ActiveProtocolSnapshot
    ) {
        self.base = base
        self.validation = validation
        self.snapshot = snapshot
    }
    
    /// Days since activation
    public var daysSinceActivation: Int {
        Calendar.current.dateComponents([.day], from: snapshot.activatedAt, to: Date()).day ?? 0
    }
    
    /// Weeks since activation
    public var weeksSinceActivation: Int {
        daysSinceActivation / 7
    }
    
    /// Check if protocol can be completed
    public var canComplete: Bool {
        // Could add minimum duration requirements here
        true
    }
    
    /// Current phase based on elapsed time
    public func currentPhase() -> ProtocolPhase? {
        // Simple implementation - could be enhanced with actual phase tracking
        base.phases.first
    }
}

// MARK: - Protocol Completed

/// A completed protocol with final snapshot
public struct ProtocolCompleted: Codable, Sendable, Hashable {
    public let base: ProtocolBase
    public let validation: ValidationResult
    public let snapshot: ActiveProtocolSnapshot
    public let completedAt: Date
    
    public init(
        base: ProtocolBase,
        validation: ValidationResult,
        snapshot: ActiveProtocolSnapshot,
        completedAt: Date = Date()
    ) {
        self.base = base
        self.validation = validation
        self.snapshot = snapshot
        self.completedAt = completedAt
    }
    
    /// Total duration of the protocol
    public var totalDuration: Int {
        Calendar.current.dateComponents([.day], from: snapshot.activatedAt, to: completedAt).day ?? 0
    }
    
    /// Total weeks of the protocol
    public var totalWeeks: Int {
        totalDuration / 7
    }
    
    /// Check if protocol was completed successfully
    public var wasSuccessful: Bool {
        // Could add success criteria here
        true
    }
}

// MARK: - Protocol Record (Discriminated Union)

/// Discriminated union representing a protocol in any state
public enum ProtocolRecord: Codable, Sendable, Hashable {
    case draft(ProtocolDraft)
    case active(ProtocolActive)
    case completed(ProtocolCompleted)
    
    // MARK: - Common Accessors
    
    /// Access the base protocol data regardless of state
    public var base: ProtocolBase {
        switch self {
        case .draft(let draft): return draft.base
        case .active(let active): return active.base
        case .completed(let completed): return completed.base
        }
    }
    
    /// Access validation result
    public var validation: ValidationResult {
        switch self {
        case .draft(let draft): return draft.validation
        case .active(let active): return active.validation
        case .completed(let completed): return completed.validation
        }
    }
    
    /// Current state of the protocol
    public var state: ProtocolState {
        base.state
    }
    
    /// Protocol ID
    public var id: String {
        base.id
    }
    
    /// Protocol name
    public var name: String {
        base.name
    }
    
    // MARK: - State Transitions
    
    /// Activate a draft protocol
    public func activate() -> ProtocolRecord? {
        guard case .draft(let draft) = self,
              draft.canActivate else { return nil }
        
        let snapshot = ActiveProtocolSnapshot(
            validationHash: draft.validation.hash,
            activatedAt: Date()
        )
        
        var updatedBase = draft.base
        updatedBase = ProtocolBase(
            id: updatedBase.id,
            version: updatedBase.version + 1,
            state: .active,
            name: updatedBase.name,
            metadata: updatedBase.metadata,
            peptides: updatedBase.peptides,
            phases: updatedBase.phases,
            createdAt: updatedBase.createdAt,
            updatedAt: Date(),
            parentId: updatedBase.parentId
        )
        
        let active = ProtocolActive(
            base: updatedBase,
            validation: draft.validation,
            snapshot: snapshot
        )
        
        return .active(active)
    }
    
    /// Complete an active protocol
    public func complete() -> ProtocolRecord? {
        guard case .active(let active) = self,
              active.canComplete else { return nil }
        
        var updatedBase = active.base
        updatedBase = ProtocolBase(
            id: updatedBase.id,
            version: updatedBase.version + 1,
            state: .completed,
            name: updatedBase.name,
            metadata: updatedBase.metadata,
            peptides: updatedBase.peptides,
            phases: updatedBase.phases,
            createdAt: updatedBase.createdAt,
            updatedAt: Date(),
            parentId: updatedBase.parentId
        )
        
        let completed = ProtocolCompleted(
            base: updatedBase,
            validation: active.validation,
            snapshot: active.snapshot,
            completedAt: Date()
        )
        
        return .completed(completed)
    }
    
    /// Create a new draft from this protocol (for cloning/editing)
    public func createDraft(withName name: String? = nil) -> ProtocolDraft {
        let newBase = ProtocolBase(
            id: UUID().uuidString,
            version: 1,
            state: .draft,
            name: name ?? "\(base.name) (Copy)",
            metadata: base.metadata,
            peptides: base.peptides,
            phases: base.phases,
            createdAt: Date(),
            updatedAt: Date(),
            parentId: base.id
        )
        
        // Create empty validation for new draft
        let validation = ValidationResult(
            hash: UUID().uuidString,
            issues: [],
            valid: false,
            evaluatedAt: Date()
        )
        
        return ProtocolDraft(
            base: newBase,
            validation: validation,
            lastValidatedHash: nil
        )
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case type
        case data
    }
    
    private enum RecordType: String, Codable {
        case draft, active, completed
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(RecordType.self, forKey: .type)
        
        switch type {
        case .draft:
            let draft = try container.decode(ProtocolDraft.self, forKey: .data)
            self = .draft(draft)
        case .active:
            let active = try container.decode(ProtocolActive.self, forKey: .data)
            self = .active(active)
        case .completed:
            let completed = try container.decode(ProtocolCompleted.self, forKey: .data)
            self = .completed(completed)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .draft(let draft):
            try container.encode(RecordType.draft, forKey: .type)
            try container.encode(draft, forKey: .data)
        case .active(let active):
            try container.encode(RecordType.active, forKey: .type)
            try container.encode(active, forKey: .data)
        case .completed(let completed):
            try container.encode(RecordType.completed, forKey: .type)
            try container.encode(completed, forKey: .data)
        }
    }
}

// MARK: - Protocol Storage Shape

/// Container for storing multiple protocols
public struct ProtocolStorageShape: Codable, Sendable {
    public let protocols: [ProtocolRecord]
    public let lastUpdated: Date
    
    public init(
        protocols: [ProtocolRecord] = [],
        lastUpdated: Date = Date()
    ) {
        self.protocols = protocols
        self.lastUpdated = lastUpdated
    }
    
    /// Get all draft protocols
    public var drafts: [ProtocolDraft] {
        protocols.compactMap {
            if case .draft(let draft) = $0 { return draft }
            return nil
        }
    }
    
    /// Get all active protocols
    public var active: [ProtocolActive] {
        protocols.compactMap {
            if case .active(let active) = $0 { return active }
            return nil
        }
    }
    
    /// Get all completed protocols
    public var completed: [ProtocolCompleted] {
        protocols.compactMap {
            if case .completed(let completed) = $0 { return completed }
            return nil
        }
    }
}
