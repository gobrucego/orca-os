//
//  Peptide.swift
//  PeptideFox
//
//  Core peptide model representing a single peptide compound.
//  Conforms to Identifiable, Codable, Sendable, and Hashable for SwiftUI and concurrency.
//

import Foundation

/// Complete peptide information including clinical data, dosing, and visual styling
public struct Peptide: Identifiable, Codable, Sendable, Hashable {
    
    // MARK: - Core Properties
    
    public let id: String
    public let name: String
    public let category: PeptideCategory
    public let description: String
    public let mechanism: String
    public let typicalDose: String
    public let cycleLength: String
    public let frequency: String
    public let benefits: [String]
    
    // MARK: - Enhanced Clinical Fields
    
    /// Detailed dosing protocol instructions
    public let protocol: String?
    
    /// Clinical rationale for this approach
    public let rationale: String?
    
    /// Safety warnings and contraindications
    public let contraindications: [String]?
    
    /// Success indicators to monitor
    public let signals: [String]?
    
    /// Relative cost level
    public let cost: CostLevel?
    
    /// Clinical evidence strength
    public let evidence: EvidenceLevel?
    
    /// Additional clinical notes
    public let notes: String?
    
    // MARK: - Relationships
    
    /// Peptides that work well in combination
    public let synergies: [String]
    
    // MARK: - Visual Styling
    
    public let colorScheme: PeptideColorScheme
    
    // MARK: - Initialization
    
    public init(
        id: String,
        name: String,
        category: PeptideCategory,
        description: String,
        mechanism: String,
        typicalDose: String,
        cycleLength: String,
        frequency: String,
        benefits: [String],
        protocol: String? = nil,
        rationale: String? = nil,
        contraindications: [String]? = nil,
        signals: [String]? = nil,
        cost: CostLevel? = nil,
        evidence: EvidenceLevel? = nil,
        notes: String? = nil,
        synergies: [String] = [],
        colorScheme: PeptideColorScheme? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.mechanism = mechanism
        self.typicalDose = typicalDose
        self.cycleLength = cycleLength
        self.frequency = frequency
        self.benefits = benefits
        self.protocol = `protocol`
        self.rationale = rationale
        self.contraindications = contraindications
        self.signals = signals
        self.cost = cost
        self.evidence = evidence
        self.notes = notes
        self.synergies = synergies
        self.colorScheme = colorScheme ?? .default
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case description
        case mechanism
        case typicalDose
        case cycleLength
        case frequency
        case benefits
        case `protocol`
        case rationale
        case contraindications
        case signals
        case cost
        case evidence
        case notes
        case synergies
        case bgColor
        case borderColor
        case accentColor
        case bulletColor
        case badgeBg
        case badgeText
        case badgeBorder
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Core properties
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(PeptideCategory.self, forKey: .category)
        description = try container.decode(String.self, forKey: .description)
        mechanism = try container.decode(String.self, forKey: .mechanism)
        typicalDose = try container.decode(String.self, forKey: .typicalDose)
        cycleLength = try container.decode(String.self, forKey: .cycleLength)
        frequency = try container.decode(String.self, forKey: .frequency)
        benefits = try container.decode([String].self, forKey: .benefits)
        
        // Enhanced clinical fields
        `protocol` = try container.decodeIfPresent(String.self, forKey: .protocol)
        rationale = try container.decodeIfPresent(String.self, forKey: .rationale)
        contraindications = try container.decodeIfPresent([String].self, forKey: .contraindications)
        signals = try container.decodeIfPresent([String].self, forKey: .signals)
        cost = try container.decodeIfPresent(CostLevel.self, forKey: .cost)
        evidence = try container.decodeIfPresent(EvidenceLevel.self, forKey: .evidence)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        
        // Relationships
        synergies = try container.decodeIfPresent([String].self, forKey: .synergies) ?? []
        
        // Visual styling - decode individual color properties
        let bgColor = try container.decode(String.self, forKey: .bgColor)
        let borderColor = try container.decode(String.self, forKey: .borderColor)
        let accentColor = try container.decode(String.self, forKey: .accentColor)
        let bulletColor = try container.decode(String.self, forKey: .bulletColor)
        let badgeBg = try container.decode(String.self, forKey: .badgeBg)
        let badgeText = try container.decode(String.self, forKey: .badgeText)
        let badgeBorder = try container.decode(String.self, forKey: .badgeBorder)
        
        colorScheme = PeptideColorScheme(
            bgColor: bgColor,
            borderColor: borderColor,
            accentColor: accentColor,
            bulletColor: bulletColor,
            badgeBg: badgeBg,
            badgeText: badgeText,
            badgeBorder: badgeBorder
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Core properties
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(description, forKey: .description)
        try container.encode(mechanism, forKey: .mechanism)
        try container.encode(typicalDose, forKey: .typicalDose)
        try container.encode(cycleLength, forKey: .cycleLength)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(benefits, forKey: .benefits)
        
        // Enhanced clinical fields
        try container.encodeIfPresent(`protocol`, forKey: .protocol)
        try container.encodeIfPresent(rationale, forKey: .rationale)
        try container.encodeIfPresent(contraindications, forKey: .contraindications)
        try container.encodeIfPresent(signals, forKey: .signals)
        try container.encodeIfPresent(cost, forKey: .cost)
        try container.encodeIfPresent(evidence, forKey: .evidence)
        try container.encodeIfPresent(notes, forKey: .notes)
        
        // Relationships
        try container.encode(synergies, forKey: .synergies)
        
        // Visual styling - encode individual color properties
        try container.encode(colorScheme.bgColor, forKey: .bgColor)
        try container.encode(colorScheme.borderColor, forKey: .borderColor)
        try container.encode(colorScheme.accentColor, forKey: .accentColor)
        try container.encode(colorScheme.bulletColor, forKey: .bulletColor)
        try container.encode(colorScheme.badgeBg, forKey: .badgeBg)
        try container.encode(colorScheme.badgeText, forKey: .badgeText)
        try container.encode(colorScheme.badgeBorder, forKey: .badgeBorder)
    }
    
    // MARK: - Computed Properties
    
    /// Check if peptide has clinical warnings
    public var hasWarnings: Bool {
        !(contraindications?.isEmpty ?? true)
    }
    
    /// Check if peptide has strong evidence
    public var hasStrongEvidence: Bool {
        evidence == .strong || evidence == .moderate
    }
    
    /// Risk assessment based on evidence and contraindications
    public var riskLevel: String {
        if hasWarnings && evidence == .experimental {
            return "High Risk"
        } else if hasWarnings || evidence == .limited {
            return "Moderate Risk"
        } else {
            return "Low Risk"
        }
    }
    
    /// Formatted typical dose range
    public var formattedDoseRange: String {
        typicalDose
    }
    
    /// Check if this is a GLP-1 agonist
    public var isGLP1: Bool {
        category == .glp
    }
    
    /// Check if this is a healing peptide
    public var isHealing: Bool {
        category == .healing
    }
    
    /// All unique benefits (deduplicated)
    public var uniqueBenefits: [String] {
        Array(Set(benefits)).sorted()
    }
    
    /// Summary text for display
    public var summary: String {
        if let notes = notes, !notes.isEmpty {
            return notes
        }
        return "\(description). \(mechanism)"
    }
}

// MARK: - Sample Data

extension Peptide {
    /// Sample BPC-157 peptide for previews and testing
    public static let sampleBPC157 = Peptide(
        id: "bpc-157",
        name: "BPC-157",
        category: .healing,
        description: "Body Protective Compound for tissue healing",
        mechanism: "Enhances angiogenesis, modulates growth factors",
        typicalDose: "250-500mcg",
        cycleLength: "4-8 weeks",
        frequency: "Daily or twice daily",
        benefits: [
            "Accelerates wound healing",
            "Reduces inflammation",
            "Protects gut lining",
            "Enhances tendon/ligament repair"
        ],
        protocol: "Start 250mcg daily, can increase to 500mcg or split into twice daily dosing",
        rationale: "Stable gastric pentadecapeptide with proven tissue regeneration effects",
        contraindications: ["Cancer history"],
        signals: ["Reduced pain", "Improved mobility", "Faster recovery"],
        cost: .medium,
        evidence: .moderate,
        synergies: ["TB-500", "GHK-Cu"],
        colorScheme: .healing
    )
    
    /// Sample Semaglutide peptide for previews and testing
    public static let sampleSemaglutide = Peptide(
        id: "semaglutide",
        name: "Semaglutide",
        category: .glp,
        description: "GLP-1 for weight loss & CV protection",
        mechanism: "GLP-1R agonism with long half-life",
        typicalDose: "0.25-2.4mg",
        cycleLength: "16-24 weeks",
        frequency: "Weekly",
        benefits: [
            "Weight loss",
            "Glycemic control",
            "CV risk reduction"
        ],
        protocol: "Start 0.25mg weekly, titrate up every 4 weeks",
        rationale: "FDA-approved GLP-1 agonist with robust clinical data",
        contraindications: [
            "Personal/family history MTC or MEN2",
            "Pregnancy",
            "Pancreatitis history"
        ],
        signals: ["Appetite suppression", "Stable gym performance"],
        cost: .veryHigh,
        evidence: .strong,
        synergies: ["Tesamorelin", "NAD+"]
    )
}
