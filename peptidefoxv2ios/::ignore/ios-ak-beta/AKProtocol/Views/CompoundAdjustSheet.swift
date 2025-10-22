import SwiftUI

struct CompoundAdjustSheet: View {
    let compound: ProtocolCompound
    let week: Int
    let day: Int
    @ObservedObject var state: AKProtocolState
    @Binding var isPresented: Bool

    @State private var dose: String = ""
    @State private var concentration: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Compound Details")) {
                    HStack {
                        Text("Name")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(displayName)
                            .font(.system(size: 15, weight: .medium))
                    }

                    HStack {
                        Text("Week")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Week \(week)")
                    }

                    HStack {
                        Text("Day")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(dayName)
                    }
                }

                Section(header: Text("Current Draw Volume")) {
                    HStack {
                        Text("Draw")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(drawVolume)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                }

                Section(header: Text("Dosing Information")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dose")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                        TextField("Enter dose", text: $dose)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Concentration")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                        TextField("Enter concentration", text: $concentration)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                        TextField("Enter notes", text: $notes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }

                Section {
                    Button(action: resetToDefault) {
                        HStack {
                            Spacer()
                            Text("Reset to Default")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .background(Color.gray)
                        .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Adjust \(displayName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                        isPresented = false
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                loadCurrentValues()
            }
        }
    }

    private var displayName: String {
        compound.name.replacingOccurrences(of: #"\s*\([^)]*\)$"#, with: "", options: .regularExpression)
    }

    private var dayName: String {
        let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return days[day]
    }

    private var drawVolume: String {
        DrawVolumeCalculator.calculate(dose: dose, concentration: concentration)
    }

    private func loadCurrentValues() {
        let defaultDose = DrawVolumeCalculator.getDoseForCompound(compound, week: week, day: day)
        dose = state.getAdjustedDose(for: compound.name, defaultDose: defaultDose)
        concentration = state.getAdjustedConcentration(for: compound.name, defaultConcentration: compound.defaultConcentration)
        notes = state.getAdjustedNotes(for: compound.name, defaultNotes: compound.weeklySchedule[week]?.notes ?? "")
    }

    private func saveChanges() {
        state.updateCompound(compound.name, dose: dose, concentration: concentration, notes: notes)
    }

    private func resetToDefault() {
        state.resetCompound(compound.name)
        loadCurrentValues()
    }
}

#Preview {
    CompoundAdjustSheet(
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
        isPresented: .constant(true)
    )
}
