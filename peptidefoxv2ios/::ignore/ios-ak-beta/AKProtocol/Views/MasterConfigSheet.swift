import SwiftUI

struct MasterConfigSheet: View {
    @ObservedObject var state: AKProtocolState
    @Binding var isPresented: Bool

    let allCompounds = ProtocolData.getAllCompounds()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(allCompounds, id: \.id) { compound in
                        CompoundConfigCard(compound: compound, state: state)
                    }
                }
                .padding(16)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Compound Configuration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct CompoundConfigCard: View {
    let compound: ProtocolCompound
    @ObservedObject var state: AKProtocolState

    @State private var dose: String = ""
    @State private var concentration: String = ""
    @State private var notes: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(displayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Spacer()

                Button(action: resetToDefault) {
                    Text("Reset")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.red)
                }
            }

            // Dose
            VStack(alignment: .leading, spacing: 4) {
                Text("Dose")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                TextField("Dose", text: $dose)
                    .font(.system(size: 13))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: dose) { newValue in
                        state.updateCompound(compound.name, dose: newValue)
                    }
            }

            // Concentration
            VStack(alignment: .leading, spacing: 4) {
                Text("Concentration")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                TextField("Concentration", text: $concentration)
                    .font(.system(size: 13))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: concentration) { newValue in
                        state.updateCompound(compound.name, concentration: newValue)
                    }
            }

            // Notes
            VStack(alignment: .leading, spacing: 4) {
                Text("Notes")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                TextField("Notes", text: $notes)
                    .font(.system(size: 13))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: notes) { newValue in
                        state.updateCompound(compound.name, notes: newValue)
                    }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .onAppear {
            loadCurrentValues()
        }
    }

    private var displayName: String {
        compound.name.replacingOccurrences(of: #"\s*\([^)]*\)$"#, with: "", options: .regularExpression)
    }

    private func loadCurrentValues() {
        let defaultDose = compound.weeklySchedule[1]?.dose ?? ""
        dose = state.getAdjustedDose(for: compound.name, defaultDose: defaultDose)
        concentration = state.getAdjustedConcentration(for: compound.name, defaultConcentration: compound.defaultConcentration)
        notes = state.getAdjustedNotes(for: compound.name, defaultNotes: compound.weeklySchedule[1]?.notes ?? "")
    }

    private func resetToDefault() {
        state.resetCompound(compound.name)
        loadCurrentValues()
    }
}

#Preview {
    MasterConfigSheet(state: AKProtocolState(), isPresented: .constant(true))
}
