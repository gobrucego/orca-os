import SwiftUI
import Observation

// MARK: - Blend Types

enum BlendType {
    case glow
    case klow
    case custom
}

enum BlendVariant {
    case variant_5_10_30
    case variant_10_10_50
    case variant_10_10_70
    case variant_10_10_10_35
    case variant_10_10_10_50
    case custom
}

struct BlendComposition {
    let type: BlendType
    let variant: BlendVariant
    var bpc157: Double
    var tb500: Double
    var ghkCu: Double
    var kpv: Double?

    var totalMg: Double {
        bpc157 + tb500 + ghkCu + (kpv ?? 0)
    }

    var vialSize: Double {
        totalMg
    }

    var displayName: String {
        switch variant {
        case .variant_5_10_30: return "GLOW 5/10/30"
        case .variant_10_10_50: return "GLOW 10/10/50"
        case .variant_10_10_70: return "GLOW 10/10/70"
        case .variant_10_10_10_35: return "KLOW 10/10/10/35"
        case .variant_10_10_10_50: return "KLOW 10/10/10/50"
        case .custom: return "Custom Cocktail"
        }
    }

    static func fromVariant(_ type: BlendType, _ variant: BlendVariant) -> BlendComposition {
        switch variant {
        case .variant_5_10_30:
            return BlendComposition(type: .glow, variant: variant, bpc157: 5, tb500: 10, ghkCu: 30, kpv: nil)
        case .variant_10_10_50:
            return BlendComposition(type: .glow, variant: variant, bpc157: 10, tb500: 10, ghkCu: 50, kpv: nil)
        case .variant_10_10_70:
            return BlendComposition(type: .glow, variant: variant, bpc157: 10, tb500: 10, ghkCu: 70, kpv: nil)
        case .variant_10_10_10_35:
            return BlendComposition(type: .klow, variant: variant, bpc157: 10, tb500: 10, ghkCu: 10, kpv: 5)
        case .variant_10_10_10_50:
            return BlendComposition(type: .klow, variant: variant, bpc157: 10, tb500: 10, ghkCu: 10, kpv: 20)
        case .custom:
            return BlendComposition(type: .custom, variant: variant, bpc157: 5, tb500: 10, ghkCu: 30, kpv: nil)
        }
    }
}

// MARK: - Common Peptide Definition
struct CommonPeptide: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let defaultConcentration: Double
    let defaultVialSize: Double
    let defaultDose: Double
    let isCocktail: Bool
    let category: PeptideCategory

    enum PeptideCategory {
        case featured
        case cocktail
        case regular
    }
}

@MainActor
@Observable
public final class CalculatorViewModel {
    // Selected Compound
    var selectedCompound: CommonPeptide?

    // Blend State
    var selectedBlend: BlendComposition?
    var isBlendMode: Bool = false

    // Input State (smart defaults for calculator-only mode)
    var vialSize: Double = 10.0
    var concentration: Double = 5.0
    var desiredDose: Double = 0.25

    // Calculated State
    var bacWater: Double = 0.0
    var hasCalculated: Bool = false
    var error: String?

    // Computed Properties
    var injectionVolume: Double {
        guard concentration > 0 else { return 0 }
        return desiredDose / concentration
    }

    var dosesPerVial: Double {
        guard desiredDose > 0, vialSize > 0 else { return 0 }
        return vialSize / desiredDose
    }

    var maxDose: Double {
        guard vialSize > 0 else { return 10.0 }
        return vialSize
    }

    var canCalculate: Bool {
        vialSize > 0 && concentration > 0
    }

    public init() {}

    // MARK: - Actions

    func selectCompound(_ compound: CommonPeptide) {
        selectedCompound = compound
        vialSize = compound.defaultVialSize
        concentration = compound.defaultConcentration
        desiredDose = compound.defaultDose
        hasCalculated = false
        error = nil

        // Clear blend state when selecting regular compound
        isBlendMode = false
        selectedBlend = nil
    }

    func selectBlend(_ blendType: BlendType) {
        // Clear regular compound selection
        selectedCompound = nil

        // Set blend mode
        isBlendMode = true

        // Create default blend composition based on type
        switch blendType {
        case .glow:
            selectedBlend = BlendComposition.fromVariant(.glow, .variant_10_10_50)
        case .klow:
            selectedBlend = BlendComposition.fromVariant(.klow, .variant_10_10_10_50)
        case .custom:
            selectedBlend = BlendComposition.fromVariant(.custom, .custom)
        }

        // Auto-calculate vial size from blend
        if let blend = selectedBlend {
            vialSize = blend.vialSize
            concentration = 10.0 // Default concentration for blends
            desiredDose = 0.25 // Default dose
        }

        hasCalculated = false
        error = nil
    }

    func updateBlendComposition(bpc157: Double? = nil, tb500: Double? = nil, ghkCu: Double? = nil, kpv: Double? = nil) {
        guard var blend = selectedBlend else { return }

        if let bpc = bpc157 { blend.bpc157 = bpc }
        if let tb = tb500 { blend.tb500 = tb }
        if let ghk = ghkCu { blend.ghkCu = ghk }
        if let kpvValue = kpv { blend.kpv = kpvValue }

        selectedBlend = blend

        // Auto-update vial size based on new blend total
        vialSize = blend.vialSize
    }

    func calculateBacWater() {
        guard vialSize > 0, concentration > 0 else {
            error = "Please enter vial size and concentration"
            return
        }

        // Formula: bacWater (ml) = vialSize (mg) / concentration (mg/ml)
        bacWater = vialSize / concentration
        hasCalculated = true
        error = nil
    }

    func reset() {
        selectedCompound = nil
        selectedBlend = nil
        isBlendMode = false
        vialSize = 10.0
        concentration = 5.0
        desiredDose = 0.25
        bacWater = 0.0
        hasCalculated = false
        error = nil
    }
}

// MARK: - Common Peptides Database
extension CalculatorViewModel {
    static let commonPeptides: [CommonPeptide] = [
        // Featured Compounds
        CommonPeptide(name: "GLOW", defaultConcentration: 10.0, defaultVialSize: 80, defaultDose: 0.25, isCocktail: true, category: .featured),
        CommonPeptide(name: "Semaglutide", defaultConcentration: 5.0, defaultVialSize: 5, defaultDose: 0.5, isCocktail: false, category: .featured),
        CommonPeptide(name: "Tirzepatide", defaultConcentration: 10.0, defaultVialSize: 30, defaultDose: 5.0, isCocktail: false, category: .featured),
        CommonPeptide(name: "Retatrutide", defaultConcentration: 3.3, defaultVialSize: 10, defaultDose: 3.6, isCocktail: false, category: .featured),
        CommonPeptide(name: "NAD+", defaultConcentration: 100.0, defaultVialSize: 500, defaultDose: 100.0, isCocktail: false, category: .featured),
        CommonPeptide(name: "KLOW", defaultConcentration: 10.0, defaultVialSize: 90, defaultDose: 0.25, isCocktail: true, category: .featured),

        // Cocktails
        CommonPeptide(name: "GLOW 5/10/30", defaultConcentration: 4.5, defaultVialSize: 45, defaultDose: 0.25, isCocktail: true, category: .cocktail),
        CommonPeptide(name: "GLOW 10/10/50", defaultConcentration: 7.0, defaultVialSize: 70, defaultDose: 0.25, isCocktail: true, category: .cocktail),
        CommonPeptide(name: "KLOW 10/10/10/50", defaultConcentration: 8.0, defaultVialSize: 80, defaultDose: 0.25, isCocktail: true, category: .cocktail),

        // Regular Peptides
        CommonPeptide(name: "SS-31", defaultConcentration: 8.6, defaultVialSize: 25, defaultDose: 10.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "MOTS-c", defaultConcentration: 3.3, defaultVialSize: 10, defaultDose: 5.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "5-Amino-1MQ", defaultConcentration: 2.5, defaultVialSize: 5, defaultDose: 0.15, isCocktail: false, category: .regular),
        CommonPeptide(name: "BPC157", defaultConcentration: 4.0, defaultVialSize: 10, defaultDose: 0.5, isCocktail: false, category: .regular),
        CommonPeptide(name: "TB500/TB4", defaultConcentration: 4.5, defaultVialSize: 10, defaultDose: 3.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "GHK-Cu", defaultConcentration: 12.5, defaultVialSize: 50, defaultDose: 2.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "KPV", defaultConcentration: 4.0, defaultVialSize: 10, defaultDose: 1.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "Cartalax", defaultConcentration: 10.0, defaultVialSize: 20, defaultDose: 2.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "ARA-290", defaultConcentration: 2.0, defaultVialSize: 4, defaultDose: 4.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "Adamax", defaultConcentration: 3.6, defaultVialSize: 10, defaultDose: 0.1, isCocktail: false, category: .regular),
        CommonPeptide(name: "Semax", defaultConcentration: 3.3, defaultVialSize: 10, defaultDose: 0.3, isCocktail: false, category: .regular),
        CommonPeptide(name: "Selank", defaultConcentration: 3.3, defaultVialSize: 10, defaultDose: 0.3, isCocktail: false, category: .regular),
        CommonPeptide(name: "P21", defaultConcentration: 2.0, defaultVialSize: 5, defaultDose: 0.5, isCocktail: false, category: .regular),
        CommonPeptide(name: "Pinealon", defaultConcentration: 4.0, defaultVialSize: 10, defaultDose: 0.2, isCocktail: false, category: .regular),
        CommonPeptide(name: "Tesamorelin", defaultConcentration: 3.4, defaultVialSize: 10, defaultDose: 2.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "Sermorelin", defaultConcentration: 2.0, defaultVialSize: 5, defaultDose: 0.3, isCocktail: false, category: .regular),
        CommonPeptide(name: "Ipamorelin", defaultConcentration: 3.4, defaultVialSize: 10, defaultDose: 0.45, isCocktail: false, category: .regular),
        CommonPeptide(name: "hGH", defaultConcentration: 3.3, defaultVialSize: 10, defaultDose: 2.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "Kisspeptin-10", defaultConcentration: 1.0, defaultVialSize: 5, defaultDose: 0.3, isCocktail: false, category: .regular),
        CommonPeptide(name: "hCG", defaultConcentration: 1000.0, defaultVialSize: 5000, defaultDose: 500.0, isCocktail: false, category: .regular),
        CommonPeptide(name: "Thymosin α-1", defaultConcentration: 2.5, defaultVialSize: 5, defaultDose: 1.6, isCocktail: false, category: .regular),
        CommonPeptide(name: "VIP", defaultConcentration: 1.7, defaultVialSize: 5, defaultDose: 0.2, isCocktail: false, category: .regular),
        CommonPeptide(name: "Epitalon", defaultConcentration: 6.7, defaultVialSize: 20, defaultDose: 1.4, isCocktail: false, category: .regular),
        CommonPeptide(name: "DSIP", defaultConcentration: 2.0, defaultVialSize: 5, defaultDose: 0.3, isCocktail: false, category: .regular),
        CommonPeptide(name: "AOD9604", defaultConcentration: 2.0, defaultVialSize: 5, defaultDose: 0.4, isCocktail: false, category: .regular),
        CommonPeptide(name: "L-Carnitine", defaultConcentration: 200.0, defaultVialSize: 30, defaultDose: 1000.0, isCocktail: false, category: .regular)
    ]
}
