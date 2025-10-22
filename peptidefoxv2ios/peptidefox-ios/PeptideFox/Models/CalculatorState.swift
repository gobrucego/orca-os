import Foundation
import Combine

// MARK: - Calculator State
class CalculatorState: ObservableObject {
    @Published var compound: PeptideCompound?
    @Published var vialSize: Double = 0
    @Published var bacteriostaticWater: Double = 0
    @Published var desiredDose: Double = 0.25

    // Computed properties
    var concentration: Double {
        guard vialSize > 0, bacteriostaticWater > 0 else { return 0 }
        return vialSize / bacteriostaticWater
    }

    var drawVolume: Double {
        guard concentration > 0, desiredDose > 0 else { return 0 }
        return desiredDose / concentration
    }

    var units: Double {
        return drawVolume * 100 // Convert mL to units (100 units = 1mL)
    }

    var dosesPerVial: Double {
        guard desiredDose > 0, vialSize > 0 else { return 0 }
        return vialSize / desiredDose
    }

    func reset() {
        compound = nil
        vialSize = 0
        bacteriostaticWater = 0
        desiredDose = 0.25
    }
}

// MARK: - Peptide Compounds
enum PeptideCompound: String, CaseIterable, Identifiable {
    case semaglutide
    case tirzepatide
    case retatrutide
    case bpc157 = "bpc-157"
    case tb500 = "tb-500"
    case ghkCu = "ghk-cu"
    case nad
    case custom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .semaglutide: return "Semaglutide"
        case .tirzepatide: return "Tirzepatide"
        case .retatrutide: return "Retatrutide"
        case .bpc157: return "BPC-157"
        case .tb500: return "TB-500"
        case .ghkCu: return "GHK-Cu"
        case .nad: return "NAD+"
        case .custom: return "Custom Peptide"
        }
    }

    var commonVialSizes: [Double] {
        switch self {
        case .semaglutide:
            return [2.5, 5.0, 10.0, 15.0]
        case .tirzepatide:
            return [5.0, 10.0, 15.0, 30.0]
        case .retatrutide:
            return [5.0, 10.0, 12.0, 15.0]
        case .bpc157, .tb500:
            return [5.0, 10.0, 20.0]
        case .ghkCu:
            return [50.0, 75.0, 100.0]
        case .nad:
            return [100.0, 200.0, 500.0]
        case .custom:
            return []
        }
    }

    var commonWaterVolumes: [Double] {
        switch self {
        case .semaglutide, .tirzepatide, .retatrutide:
            return [1.0, 2.0, 3.0]
        case .bpc157, .tb500:
            return [2.0, 3.0, 5.0]
        case .ghkCu:
            return [5.0, 10.0]
        case .nad:
            return [2.0, 5.0, 10.0]
        case .custom:
            return [1.0, 2.0, 3.0, 5.0, 10.0]
        }
    }

    var typicalDoses: [Double] {
        switch self {
        case .semaglutide:
            return [0.25, 0.5, 1.0, 1.7, 2.4]
        case .tirzepatide:
            return [2.5, 5.0, 7.5, 10.0, 12.5, 15.0]
        case .retatrutide:
            return [2.0, 4.0, 8.0, 12.0]
        case .bpc157:
            return [0.25, 0.5, 1.0]
        case .tb500:
            return [2.0, 5.0, 10.0]
        case .ghkCu:
            return [1.0, 2.0, 3.0]
        case .nad:
            return [50.0, 100.0, 200.0]
        case .custom:
            return []
        }
    }

    var unit: String {
        switch self {
        case .semaglutide, .tirzepatide, .retatrutide:
            return "mg"
        case .bpc157, .tb500, .ghkCu:
            return "mg"
        case .nad:
            return "mg"
        case .custom:
            return "mg"
        }
    }

    var category: String {
        switch self {
        case .semaglutide, .tirzepatide, .retatrutide:
            return "GLP-1 Agonists"
        case .bpc157, .tb500, .ghkCu:
            return "Healing & Recovery"
        case .nad:
            return "Longevity"
        case .custom:
            return "Custom"
        }
    }
}
