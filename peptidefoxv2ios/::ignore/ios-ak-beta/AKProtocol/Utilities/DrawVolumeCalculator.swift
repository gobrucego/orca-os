import Foundation

// MARK: - Draw Volume Calculator
class DrawVolumeCalculator {

    /// Calculate draw volume in mL from dose and concentration
    /// Handles µg→mg, IU conversions automatically
    static func calculate(dose: String, concentration: String) -> String {
        // Parse dose
        guard let doseMatch = parseDose(dose) else { return "-" }
        let (doseValue, doseUnit) = doseMatch

        // Parse concentration
        guard let concMatch = parseConcentration(concentration) else { return "-" }
        let (concValue, concUnit) = concMatch

        // Handle special cases
        if concentration.lowercased() == "oral" || dose.lowercased().contains("oral") {
            return "oral"
        }

        // Convert dose to base unit matching concentration
        var doseInBaseUnit = doseValue

        if concUnit == "mg/mL" {
            // Convert µg to mg if needed
            if doseUnit == "µg" || doseUnit == "mcg" || doseUnit == "ug" {
                doseInBaseUnit = doseValue / 1000.0
            } else if doseUnit == "IU" {
                // For hGH: 1 IU ≈ 0.33 mg (approximate conversion)
                doseInBaseUnit = doseValue * 0.33
            }
            // else doseUnit == "mg", already correct
        } else if concUnit == "IU/mL" {
            // For IU/mL concentrations, use IU directly
            doseInBaseUnit = doseValue
        } else if concUnit == "µg/mL" || concUnit == "mcg/mL" || concUnit == "ug/mL" {
            // For µg/mL concentrations
            if doseUnit == "mg" {
                doseInBaseUnit = doseValue * 1000.0
            }
            // else doseUnit == "µg", already correct
        }

        // Calculate draw volume
        let drawVolume = doseInBaseUnit / concValue

        // Format output
        if drawVolume < 0.01 {
            return String(format: "%.3f mL", drawVolume)
        } else if drawVolume < 0.1 {
            return String(format: "%.2f mL", drawVolume)
        } else if drawVolume < 1.0 {
            return String(format: "%.2f mL", drawVolume)
        } else {
            return String(format: "%.1f mL", drawVolume)
        }
    }

    /// Parse dose string like "750µg" or "2mg" or "500 IU"
    private static func parseDose(_ dose: String) -> (value: Double, unit: String)? {
        // Handle "varies" or "-" or empty
        if dose.isEmpty || dose == "-" || dose.lowercased().contains("varies") {
            return nil
        }

        // Remove "IM" suffix if present
        var cleanDose = dose.replacingOccurrences(of: " IM", with: "", options: .caseInsensitive)
        cleanDose = cleanDose.trimmingCharacters(in: .whitespaces)

        // Pattern: number followed by optional space and unit
        let pattern = #"(\d+(?:\.\d+)?)\s*([a-zA-Zµ]+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: cleanDose, range: NSRange(cleanDose.startIndex..., in: cleanDose)) else {
            return nil
        }

        guard let valueRange = Range(match.range(at: 1), in: cleanDose),
              let unitRange = Range(match.range(at: 2), in: cleanDose) else {
            return nil
        }

        let valueString = String(cleanDose[valueRange])
        let unit = String(cleanDose[unitRange])

        guard let value = Double(valueString) else { return nil }

        return (value, unit)
    }

    /// Parse concentration string like "4 mg/mL" or "750 IU/mL"
    private static func parseConcentration(_ concentration: String) -> (value: Double, unit: String)? {
        // Handle special cases
        if concentration.lowercased() == "oral" {
            return nil
        }

        // Pattern: number followed by space and unit/mL
        let pattern = #"(\d+(?:\.\d+)?)\s*([a-zA-Zµ]+/mL)"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: concentration, range: NSRange(concentration.startIndex..., in: concentration)) else {
            return nil
        }

        guard let valueRange = Range(match.range(at: 1), in: concentration),
              let unitRange = Range(match.range(at: 2), in: concentration) else {
            return nil
        }

        let valueString = String(concentration[valueRange])
        let unit = String(concentration[unitRange])

        guard let value = Double(valueString) else { return nil }

        return (value, unit)
    }

    /// Get dose for specific compound on specific week and day
    static func getDoseForCompound(_ compound: ProtocolCompound, week: Int, day: Int) -> String {
        guard let schedule = compound.weeklySchedule[week] else { return "" }

        // Handle special cases with "varies" dose
        if schedule.dose == "varies" {
            // Vyvanse
            if compound.name == "Vyvanse" {
                return [0, 2, 4, 6].contains(day) ? "30mg" : "60mg"  // Sun/Tue/Thu/Sat = 30mg, else 60mg
            }

            // NAD+ Week 1
            if compound.name == "NAD+" && week == 1 {
                return [0, 1, 2].contains(day) ? "200mg" : "150mg"  // Sun-Tue = 200mg, Wed-Sat = 150mg
            }

            // Wellbutrin Week 2
            if compound.name == "Wellbutrin" && week == 2 {
                return [0, 2, 4, 6].contains(day) ? "300mg" : "150mg"  // Sun/Tue/Thu/Sat = 300mg, else 150mg
            }

            // N-Acetyl Selank Week 3
            if compound.name == "N-Acetyl-Selank" && week == 3 {
                return [1, 2, 3, 4].contains(day) ? "400µg" : "300µg"  // Mon-Thu = 400µg, else 300µg
            }

            // N-Acetyl Selank Week 4
            if compound.name == "N-Acetyl-Selank" && week == 4 {
                if [0, 1].contains(day) { return "300µg" }  // Sun/Mon
                if [2, 5, 6].contains(day) { return "200µg" }  // Tue/Fri/Sat
                return "-"  // Wed/Thu off
            }

            // DSIP Week 3
            if compound.name == "DSIP" && week == 3 {
                return [0, 1, 6].contains(day) ? "300µg" : "400µg"  // Sun/Mon/Sat = 300µg, else 400µg
            }

            // Pinealon Week 3
            if compound.name == "Pinealon" && week == 3 {
                if day == 6 { return "200µg (AM)" }  // Saturday AM
                if [1, 2, 4].contains(day) { return "1mg" }  // Mon/Tue/Thu
                return "-"  // Off other days
            }

            // Pinealon Week 4
            if compound.name == "Pinealon" && week == 4 {
                if day == 6 { return "150µg (PM) + 150µg (AM)" }
                return "150µg (PM)"
            }
        }

        return schedule.dose
    }
}
