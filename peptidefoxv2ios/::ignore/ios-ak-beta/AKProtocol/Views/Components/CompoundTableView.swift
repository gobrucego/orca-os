import SwiftUI

struct CompoundTableView: View {
    let compound: ProtocolCompound
    let week: Int
    let day: Int
    @ObservedObject var state: AKProtocolState
    @Binding var showingAdjustSheet: Bool
    @Binding var selectedCompound: ProtocolCompound?

    var body: some View {
        VStack(spacing: 0) {
            // Header Row
            HStack {
                Text("Compound")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 90, alignment: .leading)

                Text("Draw")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 60, alignment: .leading)

                Text("Dose")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 70, alignment: .leading)

                Spacer()

                Text("Actions")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 60, alignment: .trailing)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemGray6))

            // Compound Rows
            ForEach(filteredCompounds, id: \.id) { compound in
                CompoundRow(
                    compound: compound,
                    week: week,
                    day: day,
                    state: state,
                    showingAdjustSheet: $showingAdjustSheet,
                    selectedCompound: $selectedCompound
                )
                Divider()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    private var filteredCompounds: [ProtocolCompound] {
        [compound].filter { $0.isScheduled(week: week, day: day) }
    }
}

struct CompoundRow: View {
    let compound: ProtocolCompound
    let week: Int
    let day: Int
    @ObservedObject var state: AKProtocolState

    @Binding var showingAdjustSheet: Bool
    @Binding var selectedCompound: ProtocolCompound?

    var body: some View {
        HStack(spacing: 8) {
            // Compound Name
            Text(displayName)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 90, alignment: .leading)

            // Draw Volume
            Text(drawVolume)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.blue)
                .frame(width: 60, alignment: .leading)

            // Dose
            Text(dose)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .frame(width: 70, alignment: .leading)

            Spacer()

            // Adjust Button
            Button(action: {
                selectedCompound = compound
                showingAdjustSheet = true
            }) {
                Text("Adjust")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.orange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private var displayName: String {
        // Remove parenthetical suffixes like "(L Knee)" or "(R Leg)"
        compound.name.replacingOccurrences(of: #"\s*\([^)]*\)$"#, with: "", options: .regularExpression)
    }

    private var dose: String {
        let defaultDose = DrawVolumeCalculator.getDoseForCompound(compound, week: week, day: day)
        return state.getAdjustedDose(for: compound.name, defaultDose: defaultDose)
    }

    private var concentration: String {
        state.getAdjustedConcentration(for: compound.name, defaultConcentration: compound.defaultConcentration)
    }

    private var drawVolume: String {
        DrawVolumeCalculator.calculate(dose: dose, concentration: concentration)
    }
}

#Preview {
    CompoundTableView(
        compound: ProtocolCompound(
            name: "VIP",
            weeklySchedule: [1: .init(dose: "200µg", days: [], notes: "Daily")],
            defaultConcentration: "2 mg/mL",
            timeOfDay: .waking,
            unit: "µg"
        ),
        week: 1,
        day: 0,
        state: AKProtocolState(),
        showingAdjustSheet: .constant(false),
        selectedCompound: .constant(nil)
    )
}
