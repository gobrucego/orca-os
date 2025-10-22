import SwiftUI

// MARK: - Peptide Category
public enum PeptideCategory: String, Codable, CaseIterable, Identifiable {
    case glp1 = "GLP-1"
    case healing = "Healing & Recovery"
    case metabolic = "Metabolic"
    case longevity = "Longevity"
    case cognitive = "Cognitive"
    case performance = "Performance"
    case growthHormone = "Growth Hormone"
    case immune = "Immune"
    case reproductive = "Reproductive"

    public var id: String { rawValue }

    public var backgroundColor: Color {
        switch self {
        case .glp1: return ColorTokens.CategoryColors.glp1Background
        case .healing: return ColorTokens.CategoryColors.healingBackground
        case .metabolic: return ColorTokens.CategoryColors.metabolicBackground
        case .longevity: return ColorTokens.CategoryColors.longevityBackground
        case .cognitive: return ColorTokens.CategoryColors.cognitiveBackground
        case .performance: return Color.pink.opacity(0.1)
        case .growthHormone: return Color.blue.opacity(0.1)
        case .immune: return Color.green.opacity(0.1)
        case .reproductive: return Color.pink.opacity(0.1)
        }
    }

    public var borderColor: Color {
        switch self {
        case .glp1: return ColorTokens.CategoryColors.glp1Border
        case .healing: return ColorTokens.CategoryColors.healingBorder
        case .metabolic: return ColorTokens.CategoryColors.metabolicBorder
        case .longevity: return ColorTokens.CategoryColors.longevityBorder
        case .cognitive: return ColorTokens.CategoryColors.cognitiveBorder
        case .performance: return Color.pink.opacity(0.3)
        case .growthHormone: return Color.blue.opacity(0.3)
        case .immune: return Color.green.opacity(0.3)
        case .reproductive: return Color.pink.opacity(0.3)
        }
    }

    public var accentColor: Color {
        switch self {
        case .glp1: return ColorTokens.CategoryColors.glp1Accent
        case .healing: return ColorTokens.CategoryColors.healingAccent
        case .metabolic: return ColorTokens.CategoryColors.metabolicAccent
        case .longevity: return ColorTokens.CategoryColors.longevityAccent
        case .cognitive: return ColorTokens.CategoryColors.cognitiveAccent
        case .performance: return Color.pink
        case .growthHormone: return Color.blue
        case .immune: return Color.green
        case .reproductive: return Color.pink
        }
    }
}

// MARK: - Peptide Model
public struct Peptide: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let category: PeptideCategory
    public let description: String
    public let mechanism: String
    public let benefits: [String]
    public let typicalDose: DoseRange
    public let frequency: String
    public let cycleLength: String
    public let contraindications: [String]
    public let signals: [String]
    public let synergies: [String]
    public let evidenceLevel: EvidenceLevel
}

// MARK: - Dose Range
public struct DoseRange: Codable, Hashable {
    public let min: Double
    public let max: Double
    public let unit: String
    
    public var displayRange: String {
        "\(formatValue(min))-\(formatValue(max)) \(unit)"
    }
    
    private func formatValue(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.2f", value)
        }
    }
}

// MARK: - Evidence Level
public enum EvidenceLevel: String, Codable {
    case high = "High"
    case moderate = "Moderate"
    case emerging = "Emerging"
    case anecdotal = "Anecdotal"
    
    public var color: Color {
        switch self {
        case .high: return .green
        case .moderate: return .blue
        case .emerging: return .orange
        case .anecdotal: return .gray
        }
    }
}
