import Foundation

enum BlendType {
    case glow
    case klow
    case custom
}

enum BlendVariant {
    case variant_5_10_30    // GLOW: BPC-157 5mg, TB-500 10mg, GHK-Cu 30mg
    case variant_10_10_50   // GLOW: BPC-157 10mg, TB-500 10mg, GHK-Cu 50mg
    case variant_10_10_70   // GLOW: BPC-157 10mg, TB-500 10mg, GHK-Cu 70mg
    case variant_10_10_10_35 // KLOW: BPC-157 10mg, TB-500 10mg, GHK-Cu 10mg, KPV 5mg (total 35mg)
    case variant_10_10_10_50 // KLOW: BPC-157 10mg, TB-500 10mg, GHK-Cu 10mg, KPV 20mg (total 50mg)
    case custom
}

struct BlendComposition {
    let type: BlendType
    let variant: BlendVariant
    var bpc157: Double  // mg
    var tb500: Double   // mg
    var ghkCu: Double   // mg
    var kpv: Double?    // mg (KLOW only)
    
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
