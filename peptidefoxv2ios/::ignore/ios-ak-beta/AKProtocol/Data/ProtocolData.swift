import Foundation

// MARK: - Protocol Data
class ProtocolData {

    // MARK: - Get All Compounds
    static func getAllCompounds() -> [ProtocolCompound] {
        return medications + hpta + metabolic + support + reprogramming + healing + rest
    }

    // MARK: - Get Compounds by Time of Day
    static func getCompounds(for timeOfDay: TimeOfDay, week: Int, day: Int) -> [ProtocolCompound] {
        return getAllCompounds().filter { compound in
            compound.timeOfDay == timeOfDay && compound.isScheduled(week: week, day: day)
        }
    }

    // MARK: - Medications
    private static let medications: [ProtocolCompound] = [
        // Vyvanse - 30mg on Sun/Tue/Thu/Sat, 60mg on Mon/Wed/Fri
        ProtocolCompound(
            name: "Vyvanse",
            weeklySchedule: [
                1: .init(dose: "varies", days: [], notes: "30mg (Sun/Tue/Thu/Sat), 60mg (Mon/Wed/Fri)"),
                2: .init(dose: "varies", days: [], notes: "30mg (Sun/Tue/Thu/Sat), 60mg (Mon/Wed/Fri)"),
                3: .init(dose: "varies", days: [], notes: "30mg (Sun/Tue/Thu/Sat), 60mg (Mon/Wed/Fri)"),
                4: .init(dose: "varies", days: [], notes: "30mg (Sun/Tue/Thu/Sat), 60mg (Mon/Wed/Fri)")
            ],
            defaultConcentration: "oral",
            timeOfDay: .waking,
            unit: "mg"
        ),

        // Wellbutrin - tapers from 300mg to 150mg
        ProtocolCompound(
            name: "Wellbutrin",
            weeklySchedule: [
                1: .init(dose: "300mg", days: [], notes: "2 × 150mg pills daily"),
                2: .init(dose: "varies", days: [], notes: "300mg (Sun/Tue/Thu/Sat), 150mg (Mon/Wed/Fri)"),
                3: .init(dose: "150mg", days: [], notes: "1 × 150mg pill daily"),
                4: .init(dose: "150mg", days: [], notes: "1 × 150mg pill daily")
            ],
            defaultConcentration: "oral",
            timeOfDay: .waking,
            unit: "mg"
        ),

        // Enclomiphene - daily
        ProtocolCompound(
            name: "Enclomiphene",
            weeklySchedule: [
                1: .init(dose: "50mg", days: [], notes: "SERM support for LH/FSH and testosterone"),
                2: .init(dose: "50mg", days: [], notes: "SERM support for LH/FSH and testosterone"),
                3: .init(dose: "50mg", days: [], notes: "SERM support for LH/FSH and testosterone"),
                4: .init(dose: "50mg", days: [], notes: "SERM support for LH/FSH and testosterone")
            ],
            defaultConcentration: "oral",
            timeOfDay: .waking,
            unit: "mg"
        )
    ]

    // MARK: - HPTA
    private static let hpta: [ProtocolCompound] = [
        // hCG - Mon/Wed/Fri
        ProtocolCompound(
            name: "hCG",
            weeklySchedule: [
                1: .init(dose: "500 IU", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                2: .init(dose: "500 IU", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                3: .init(dose: "500 IU", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                4: .init(dose: "500 IU", days: [1, 3, 5], notes: "Mon/Wed/Fri only")
            ],
            defaultConcentration: "750 IU/mL",
            timeOfDay: .waking,
            unit: "IU"
        ),

        // Kisspeptin-10 - Sun/Tue/Thu/Sat
        ProtocolCompound(
            name: "Kisspeptin-10",
            weeklySchedule: [
                1: .init(dose: "750µg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                2: .init(dose: "750µg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                3: .init(dose: "750µg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                4: .init(dose: "750µg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only")
            ],
            defaultConcentration: "2.2 mg/mL",
            timeOfDay: .waking,
            unit: "µg"
        )
    ]

    // MARK: - Metabolic
    private static let metabolic: [ProtocolCompound] = [
        // Retatrutide - varies by week
        ProtocolCompound(
            name: "Retatrutide",
            weeklySchedule: [
                1: .init(dose: "2.2mg", days: [0, 3, 6], notes: "Sun/Wed/Sat"),
                2: .init(dose: "2.2mg", days: [2, 5], notes: "Tue/Fri"),
                3: .init(dose: "2.2mg", days: [1, 4], notes: "Mon/Thu"),
                4: .init(dose: "2.2mg", days: [0, 3, 6], notes: "Sun/Wed/Sat")
            ],
            defaultConcentration: "4 mg/mL",
            timeOfDay: .am,
            unit: "mg"
        ),

        // AOD-9604 - daily
        ProtocolCompound(
            name: "AOD-9604",
            weeklySchedule: [
                1: .init(dose: "400µg", days: [], notes: "Daily"),
                2: .init(dose: "400µg", days: [], notes: "Daily"),
                3: .init(dose: "400µg", days: [], notes: "Daily"),
                4: .init(dose: "400µg", days: [], notes: "Daily")
            ],
            defaultConcentration: "2 mg/mL",
            timeOfDay: .am,
            unit: "µg"
        ),

        // MOTS-C - starts Week 2, Mon/Wed/Fri
        ProtocolCompound(
            name: "MOTS-C",
            weeklySchedule: [
                2: .init(dose: "5mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                3: .init(dose: "5mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                4: .init(dose: "5mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only")
            ],
            defaultConcentration: "20 mg/mL",
            timeOfDay: .am,
            unit: "mg"
        )
    ]

    // MARK: - Support
    private static let support: [ProtocolCompound] = [
        // VIP - daily, varies by week
        ProtocolCompound(
            name: "VIP",
            weeklySchedule: [
                1: .init(dose: "100µg", days: [], notes: "Daily - wait 60-90 min before Vyvanse"),
                2: .init(dose: "100µg", days: [], notes: "Daily - wait 60-90 min before Vyvanse"),
                3: .init(dose: "100µg", days: [], notes: "Daily - wait 60-90 min before Vyvanse"),
                4: .init(dose: "100µg", days: [], notes: "Daily - wait 60-90 min before Vyvanse")
            ],
            defaultConcentration: "2 mg/mL",
            timeOfDay: .waking,
            unit: "µg"
        ),

        // SS-31 - daily
        ProtocolCompound(
            name: "SS-31",
            weeklySchedule: [
                1: .init(dose: "8mg", days: [], notes: "Daily"),
                2: .init(dose: "8mg", days: [], notes: "Daily"),
                3: .init(dose: "8mg", days: [], notes: "Daily"),
                4: .init(dose: "8mg", days: [], notes: "Daily")
            ],
            defaultConcentration: "15 mg/mL",
            timeOfDay: .sleep,
            unit: "mg"
        ),

        // NAD+ - varies by week and day
        ProtocolCompound(
            name: "NAD+",
            weeklySchedule: [
                1: .init(dose: "varies", days: [], notes: "200mg IM (Sun-Tue), 150mg IM (Wed-Sat)"),
                2: .init(dose: "200mg IM", days: [], notes: "Daily"),
                3: .init(dose: "200mg IM", days: [], notes: "Daily"),
                4: .init(dose: "100mg IM", days: [1, 3, 5], notes: "Mon/Wed/Fri only")
            ],
            defaultConcentration: "100 mg/mL",
            timeOfDay: .am,
            unit: "mg"
        )
    ]

    // MARK: - Reprogramming
    private static let reprogramming: [ProtocolCompound] = [
        // N-Acetyl Semax - varies by week
        ProtocolCompound(
            name: "N-Acetyl-Semax",
            weeklySchedule: [
                1: .init(dose: "600µg", days: [1, 2, 3, 4, 5, 6], notes: "Mon-Sat only"),
                2: .init(dose: "900µg", days: [2, 3, 5, 6], notes: "Tue/Wed/Fri/Sat (Adamax on Mon/Thu)"),
                3: .init(dose: "900µg", days: [2, 3, 5, 6], notes: "Tue/Wed/Fri/Sat (Adamax on Mon/Thu)"),
                4: .init(dose: "600µg", days: [2, 3, 5, 6], notes: "Tue/Wed/Fri/Sat (Adamax on Mon/Thu)")
            ],
            defaultConcentration: "10 mg/mL",
            timeOfDay: .midday,
            unit: "µg"
        ),

        // Adamax - Mon/Thu only, starts Week 2
        ProtocolCompound(
            name: "Adamax",
            weeklySchedule: [
                2: .init(dose: "400-500µg", days: [1, 4], notes: "Mon/Thu only - replaces Semax"),
                3: .init(dose: "400-500µg", days: [1, 4], notes: "Mon/Thu only - replaces Semax"),
                4: .init(dose: "400-500µg", days: [1, 4], notes: "Mon/Thu only - replaces Semax")
            ],
            defaultConcentration: "4 mg/mL",
            timeOfDay: .midday,
            unit: "µg"
        ),

        // N-Acetyl Selank - varies by week
        ProtocolCompound(
            name: "N-Acetyl-Selank",
            weeklySchedule: [
                1: .init(dose: "300µg", days: [], notes: "Daily"),
                2: .init(dose: "400µg", days: [], notes: "Daily"),
                3: .init(dose: "varies", days: [], notes: "400µg (Mon-Thu), 300µg (Fri-Sun)"),
                4: .init(dose: "varies", days: [], notes: "300µg (Sun/Mon), 200µg (Tue/Fri/Sat), off Wed/Thu")
            ],
            defaultConcentration: "4 mg/mL",
            timeOfDay: .waking,
            unit: "µg"
        ),

        // P21 - varies by week
        ProtocolCompound(
            name: "P21",
            weeklySchedule: [
                1: .init(dose: "1000µg", days: [1, 2, 3, 4, 5, 6], notes: "Mon-Sat only"),
                2: .init(dose: "1000µg", days: [1, 2, 3, 4, 5, 6], notes: "Mon-Sat only"),
                3: .init(dose: "1000µg", days: [], notes: "Daily"),
                4: .init(dose: "750µg", days: [1, 2, 3, 4, 5, 6], notes: "Mon-Sat only")
            ],
            defaultConcentration: "8 mg/mL",
            timeOfDay: .midday,
            unit: "µg"
        )
    ]

    // MARK: - Healing
    private static let healing: [ProtocolCompound] = [
        // BPC-157 (L Knee) - Mon/Wed/Fri
        ProtocolCompound(
            name: "BPC-157 (L Knee)",
            weeklySchedule: [
                1: .init(dose: "750µg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                2: .init(dose: "750µg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                3: .init(dose: "750µg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                4: .init(dose: "500µg", days: [1, 3, 5], notes: "Mon/Wed/Fri only")
            ],
            defaultConcentration: "4 mg/mL",
            timeOfDay: .evening,
            unit: "µg"
        ),

        // BPC-157 (R Leg) - Sun/Tue/Thu/Sat
        ProtocolCompound(
            name: "BPC-157 (R Leg)",
            weeklySchedule: [
                1: .init(dose: "500µg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                2: .init(dose: "500µg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                3: .init(dose: "500µg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                4: .init(dose: "500µg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only")
            ],
            defaultConcentration: "4 mg/mL",
            timeOfDay: .evening,
            unit: "µg"
        ),

        // TB-500 (L Knee) - Mon/Wed/Fri
        ProtocolCompound(
            name: "TB-500 (L Knee)",
            weeklySchedule: [
                1: .init(dose: "2mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                2: .init(dose: "2mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                3: .init(dose: "2mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                4: .init(dose: "2mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only")
            ],
            defaultConcentration: "4 mg/mL",
            timeOfDay: .evening,
            unit: "mg"
        ),

        // TB-500 (R Leg) - Sun/Tue/Thu/Sat
        ProtocolCompound(
            name: "TB-500 (R Leg)",
            weeklySchedule: [
                1: .init(dose: "2mg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                2: .init(dose: "2mg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                3: .init(dose: "2mg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                4: .init(dose: "2mg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only")
            ],
            defaultConcentration: "4 mg/mL",
            timeOfDay: .evening,
            unit: "mg"
        ),

        // GHK-Cu (L Knee) - Mon/Wed/Fri
        ProtocolCompound(
            name: "GHK-Cu (L Knee)",
            weeklySchedule: [
                1: .init(dose: "2mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                2: .init(dose: "2mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                3: .init(dose: "2mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only"),
                4: .init(dose: "2mg", days: [1, 3, 5], notes: "Mon/Wed/Fri only")
            ],
            defaultConcentration: "20 mg/mL",
            timeOfDay: .evening,
            unit: "mg"
        ),

        // GHK-Cu (R Leg) - Sun/Tue/Thu/Sat
        ProtocolCompound(
            name: "GHK-Cu (R Leg)",
            weeklySchedule: [
                1: .init(dose: "2mg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                2: .init(dose: "2mg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                3: .init(dose: "2mg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only"),
                4: .init(dose: "2mg", days: [0, 2, 4, 6], notes: "Sun/Tue/Thu/Sat only")
            ],
            defaultConcentration: "20 mg/mL",
            timeOfDay: .evening,
            unit: "mg"
        ),

        // KPV - daily
        ProtocolCompound(
            name: "KPV",
            weeklySchedule: [
                1: .init(dose: "500µg", days: [], notes: "Daily"),
                2: .init(dose: "500µg", days: [], notes: "Daily"),
                3: .init(dose: "500µg", days: [], notes: "Daily"),
                4: .init(dose: "500µg", days: [], notes: "Daily")
            ],
            defaultConcentration: "6 mg/mL",
            timeOfDay: .evening,
            unit: "µg"
        ),

        // hGH - daily
        ProtocolCompound(
            name: "hGH",
            weeklySchedule: [
                1: .init(dose: "2 IU", days: [], notes: "Daily"),
                2: .init(dose: "2 IU", days: [], notes: "Daily"),
                3: .init(dose: "2 IU", days: [], notes: "Daily"),
                4: .init(dose: "2 IU", days: [], notes: "Daily")
            ],
            defaultConcentration: "4 IU/mL",
            timeOfDay: .waking,
            unit: "IU"
        )
    ]

    // MARK: - Rest
    private static let rest: [ProtocolCompound] = [
        // DSIP - varies by week
        ProtocolCompound(
            name: "DSIP",
            weeklySchedule: [
                1: .init(dose: "300µg", days: [0, 1, 2, 3, 4, 6], notes: "Sun-Fri (skip Sat)"),
                2: .init(dose: "400µg", days: [0, 1, 2, 3, 4, 6], notes: "Sun-Fri (skip Sat)"),
                3: .init(dose: "varies", days: [0, 1, 6], notes: "300µg (Sun/Mon/Sat), 400µg (Tue-Fri)"),
                4: .init(dose: "300µg", days: [0, 1, 2, 3, 4, 6], notes: "Sun-Fri (skip Sat)")
            ],
            defaultConcentration: "2 mg/mL",
            timeOfDay: .sleep,
            unit: "µg"
        ),

        // Pinealon - varies by week and time
        ProtocolCompound(
            name: "Pinealon",
            weeklySchedule: [
                1: .init(dose: "1mg", days: [], notes: "Daily (PM only)"),
                2: .init(dose: "1mg", days: [], notes: "Daily (PM only)"),
                3: .init(dose: "varies", days: [], notes: "1mg (Mon/Tue/Thu), off other days; 200µg AM on Sat"),
                4: .init(dose: "varies", days: [], notes: "150µg PM (Sun-Sat), 150µg AM on Sat")
            ],
            defaultConcentration: "4 mg/mL",
            timeOfDay: .sleep,
            unit: "mg"
        )
    ]
}
