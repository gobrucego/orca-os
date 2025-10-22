import SwiftUI

struct TimeSectionCard: View {
    let timeOfDay: TimeOfDay
    let compounds: [ProtocolCompound]
    let week: Int
    let day: Int
    @ObservedObject var state: AKProtocolState
    @Binding var showingAdjustSheet: Bool
    @Binding var selectedCompound: ProtocolCompound?

    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    HStack(spacing: 8) {
                        Text(timeOfDay.icon)
                            .font(.system(size: 20))
                        Text(timeOfDay.rawValue)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(UIColor.systemBackground))
            }
            .buttonStyle(PlainButtonStyle())

            // Content
            if isExpanded {
                VStack(spacing: 12) {
                    ForEach(filteredCompounds, id: \.id) { compound in
                        CompoundRowCard(
                            compound: compound,
                            week: week,
                            day: day,
                            state: state,
                            showingAdjustSheet: $showingAdjustSheet,
                            selectedCompound: $selectedCompound
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }

    private var filteredCompounds: [ProtocolCompound] {
        compounds.filter { $0.isScheduled(week: week, day: day) }
    }
}

struct CompoundRowCard: View {
    let compound: ProtocolCompound
    let week: Int
    let day: Int
    @ObservedObject var state: AKProtocolState

    @Binding var showingAdjustSheet: Bool
    @Binding var selectedCompound: ProtocolCompound?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)

                Spacer()

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

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Draw")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(drawVolume)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Dose")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(dose)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Concentration")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(concentration)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }

            if !notes.isEmpty {
                Text(notes)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding(12)
        .background(Color(UIColor.systemGray6).opacity(0.5))
        .cornerRadius(10)
    }

    private var displayName: String {
        compound.name.replacingOccurrences(of: #"\s*\([^)]*\)$"#, with: "", options: .regularExpression)
    }

    private var dose: String {
        let defaultDose = DrawVolumeCalculator.getDoseForCompound(compound, week: week, day: day)
        return state.getAdjustedDose(for: compound.name, defaultDose: defaultDose)
    }

    private var concentration: String {
        state.getAdjustedConcentration(for: compound.name, defaultConcentration: compound.defaultConcentration)
    }

    private var notes: String {
        let defaultNotes = compound.weeklySchedule[week]?.notes ?? ""
        return state.getAdjustedNotes(for: compound.name, defaultNotes: defaultNotes)
    }

    private var drawVolume: String {
        DrawVolumeCalculator.calculate(dose: dose, concentration: concentration)
    }
}

#Preview {
    TimeSectionCard(
        timeOfDay: .waking,
        compounds: [
            ProtocolCompound(
                name: "VIP",
                weeklySchedule: [1: .init(dose: "200µg", days: [], notes: "Daily")],
                defaultConcentration: "2 mg/mL",
                timeOfDay: .waking,
                unit: "µg"
            )
        ],
        week: 1,
        day: 0,
        state: AKProtocolState(),
        showingAdjustSheet: .constant(false),
        selectedCompound: .constant(nil)
    )
}
