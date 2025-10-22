//
//  ProtocolCompound.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import Foundation

/// Represents a compound/peptide in a protocol with its dosing configuration
struct ProtocolCompound: Identifiable, Hashable {
    let id = UUID()
    let category: String  // Emoji (💊, 🧬, 🧠, 🦵, 😴)
    let name: String
    let dose: String
    let concentration: String
    let unit: String
    let notes: String
    let schedule: String  // "Daily", "Mon/Wed/Fri", "Mon-Sat", etc.
    
    /// Checks if this compound should be shown on the given day
    func isScheduledFor(dayIndex: Int) -> Bool {
        // Daily compounds always show
        if schedule == "Daily" {
            return true
        }
        
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let dayName = dayNames[dayIndex]
        
        // Check if day abbreviation is in schedule string
        return schedule.contains(dayName)
    }
}

/// Master compound configuration data
struct CompoundConfig {
    let category: String
    let baseDose: String
    let concentration: String
    let unit: String
    let notes: String
}

/// All compound configurations matching the web implementation
let COMPOUND_CONFIGS: [String: CompoundConfig] = [
    // Medications
    "Vyvanse": CompoundConfig(
        category: "💊",
        baseDose: "30mg",
        concentration: "oral",
        unit: "mg",
        notes: "Stimulant - take 60-90 min after VIP if used previous day"
    ),
    "Wellbutrin": CompoundConfig(
        category: "💊",
        baseDose: "300mg",
        concentration: "oral",
        unit: "mg",
        notes: "Eliminate 450mg days"
    ),
    
    // HPTA
    "Enclomiphene": CompoundConfig(
        category: "🧬",
        baseDose: "50mg",
        concentration: "oral",
        unit: "mg",
        notes: "SERM support for LH/FSH and testosterone"
    ),
    "hCG": CompoundConfig(
        category: "🧬",
        baseDose: "500 IU",
        concentration: "SC",
        unit: "IU",
        notes: "Mon/Wed/Fri only"
    ),
    "Kisspeptin-10": CompoundConfig(
        category: "🧬",
        baseDose: "750µg",
        concentration: "SC",
        unit: "µg",
        notes: "Sun/Tue/Thu/Sat only"
    ),
    
    // Metabolic
    "Retatrutide": CompoundConfig(
        category: "🧬",
        baseDose: "2.2mg",
        concentration: "SC",
        unit: "mg",
        notes: "Mon only"
    ),
    "AOD-9604": CompoundConfig(
        category: "🧬",
        baseDose: "500µg",
        concentration: "SC",
        unit: "µg",
        notes: "Daily"
    ),
    "MOTS-C": CompoundConfig(
        category: "🧬",
        baseDose: "5mg",
        concentration: "SC",
        unit: "mg",
        notes: "Mon/Wed/Fri only"
    ),
    "VIP": CompoundConfig(
        category: "🧬",
        baseDose: "100µg",
        concentration: "SC",
        unit: "µg",
        notes: "Daily"
    ),
    "SS-31": CompoundConfig(
        category: "🧬",
        baseDose: "8mg",
        concentration: "SC",
        unit: "mg",
        notes: "Daily"
    ),
    "NAD+": CompoundConfig(
        category: "🧬",
        baseDose: "200mg IM",
        concentration: "200 mg/mL",
        unit: "mg",
        notes: "Daily"
    ),
    
    // Reprogramming
    "Semax": CompoundConfig(
        category: "🧠",
        baseDose: "600µg",
        concentration: "IN",
        unit: "µg",
        notes: "Mon-Sat only"
    ),
    "Selank": CompoundConfig(
        category: "🧠",
        baseDose: "300µg",
        concentration: "IN",
        unit: "µg",
        notes: "Tue-Sat only"
    ),
    "P21": CompoundConfig(
        category: "🧠",
        baseDose: "1000µg",
        concentration: "SC",
        unit: "µg",
        notes: "Mon-Sat only"
    ),
    
    // Healing
    "BPC-157 (L Knee)": CompoundConfig(
        category: "🦵",
        baseDose: "750µg",
        concentration: "SC",
        unit: "µg",
        notes: "Mon/Wed/Fri only"
    ),
    "BPC-157 (R Leg)": CompoundConfig(
        category: "🦵",
        baseDose: "500µg",
        concentration: "SC",
        unit: "µg",
        notes: "Sun/Tue/Thu/Sat only"
    ),
    "TB-500 (L Knee)": CompoundConfig(
        category: "🦵",
        baseDose: "2mg",
        concentration: "SC",
        unit: "mg",
        notes: "Mon/Wed/Fri only"
    ),
    "TB-500 (R Leg)": CompoundConfig(
        category: "🦵",
        baseDose: "2mg",
        concentration: "SC",
        unit: "mg",
        notes: "Sun/Tue/Thu/Sat only"
    ),
    "GHK-Cu (L Knee)": CompoundConfig(
        category: "🦵",
        baseDose: "2mg",
        concentration: "SC",
        unit: "mg",
        notes: "Mon/Wed/Fri only"
    ),
    "GHK-Cu (R Leg)": CompoundConfig(
        category: "🦵",
        baseDose: "2mg",
        concentration: "SC",
        unit: "mg",
        notes: "Sun/Tue/Thu/Sat only"
    ),
    "KPV": CompoundConfig(
        category: "🦵",
        baseDose: "500µg",
        concentration: "SC",
        unit: "µg",
        notes: "Daily"
    ),
    "hGH": CompoundConfig(
        category: "🦵",
        baseDose: "2 IU",
        concentration: "SC",
        unit: "IU",
        notes: "Daily"
    ),
    
    // Rest
    "DSIP": CompoundConfig(
        category: "😴",
        baseDose: "300µg",
        concentration: "SC",
        unit: "µg",
        notes: "Daily"
    ),
    "Pinealon": CompoundConfig(
        category: "😴",
        baseDose: "150µg",
        concentration: "SC",
        unit: "µg",
        notes: "Daily"
    )
]

/// Helper to create a ProtocolCompound from config
/// Returns nil if compound name is not found in COMPOUND_CONFIGS
func createCompound(name: String, schedule: String) -> ProtocolCompound? {
    guard let config = COMPOUND_CONFIGS[name] else {
        print("⚠️ Warning: Compound '\(name)' not found in COMPOUND_CONFIGS")
        return nil
    }

    return ProtocolCompound(
        category: config.category,
        name: name,
        dose: config.baseDose,
        concentration: config.concentration,
        unit: config.unit,
        notes: config.notes,
        schedule: schedule
    )
}
