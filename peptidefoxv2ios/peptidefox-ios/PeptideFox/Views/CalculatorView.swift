import SwiftUI

struct CalculatorView: View {
    @StateObject private var state = CalculatorState()
    @State private var showingResults = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "function")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text("Reconstitution Calculator")
                            .font(.system(size: 10, weight: .medium))
                            .tracking(0.5)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(20)

                    Text("Peptide Dosing")
                        .font(.system(size: 36, weight: .light))
                        .tracking(-0.5)
                }
                .padding(.top, 20)

                // Step 1: Select Compound
                VStack(alignment: .leading, spacing: 12) {
                    StepHeader(number: 1, title: "Select Peptide")

                    ForEach([
                        ("GLP-1 Agonists", [PeptideCompound.semaglutide, .tirzepatide, .retatrutide]),
                        ("Healing & Recovery", [PeptideCompound.bpc157, .tb500, .ghkCu]),
                        ("Longevity", [PeptideCompound.nad])
                    ], id: \.0) { category, compounds in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(category)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(.leading, 4)

                            HStack(spacing: 8) {
                                ForEach(compounds) { compound in
                                    CompoundPill(
                                        compound: compound,
                                        isSelected: state.compound == compound
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            state.compound = compound
                                            showingResults = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                if let compound = state.compound {
                    // Step 2: Vial Size
                    VStack(alignment: .leading, spacing: 12) {
                        StepHeader(number: 2, title: "Vial Size")

                        VStack(spacing: 12) {
                            HStack(spacing: 8) {
                                ForEach(compound.commonVialSizes, id: \.self) { size in
                                    QuickSelectButton(
                                        value: size,
                                        unit: "mg",
                                        isSelected: state.vialSize == size
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            state.vialSize = size
                                            showingResults = false
                                        }
                                    }
                                }
                            }

                            HStack(spacing: 8) {
                                Image(systemName: "syringe")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                TextField("Custom (mg)", value: $state.vialSize, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                                    .onChange(of: state.vialSize) { _ in
                                        showingResults = false
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Step 3: Bacteriostatic Water
                    VStack(alignment: .leading, spacing: 12) {
                        StepHeader(number: 3, title: "Bacteriostatic Water")

                        VStack(spacing: 12) {
                            HStack(spacing: 8) {
                                ForEach(compound.commonWaterVolumes, id: \.self) { volume in
                                    QuickSelectButton(
                                        value: volume,
                                        unit: "mL",
                                        isSelected: state.bacteriostaticWater == volume
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            state.bacteriostaticWater = volume
                                            showingResults = false
                                        }
                                    }
                                }
                            }

                            HStack(spacing: 8) {
                                Image(systemName: "drop")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                TextField("Custom (mL)", value: $state.bacteriostaticWater, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                                    .onChange(of: state.bacteriostaticWater) { _ in
                                        showingResults = false
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Step 4: Desired Dose
                    VStack(alignment: .leading, spacing: 12) {
                        StepHeader(number: 4, title: "Desired Dose")

                        if !compound.typicalDoses.isEmpty {
                            HStack(spacing: 8) {
                                ForEach(compound.typicalDoses, id: \.self) { dose in
                                    QuickSelectButton(
                                        value: dose,
                                        unit: "mg",
                                        isSelected: state.desiredDose == dose
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            state.desiredDose = dose
                                            showingResults = false
                                        }
                                    }
                                }
                            }
                        }

                        HStack(spacing: 8) {
                            Image(systemName: "target")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            TextField("Custom (mg)", value: $state.desiredDose, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .onChange(of: state.desiredDose) { _ in
                                    showingResults = false
                                }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Calculate Button
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showingResults = true
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "function")
                            Text("Calculate")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            canCalculate ? Color.blue : Color.gray
                        )
                        .cornerRadius(12)
                    }
                    .disabled(!canCalculate)
                    .padding(.horizontal, 20)

                    // Results
                    if showingResults && canCalculate {
                        ResultsCard(state: state, compound: compound)
                            .padding(.horizontal, 20)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }

                Spacer(minLength: 20)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    private var canCalculate: Bool {
        state.compound != nil &&
        state.vialSize > 0 &&
        state.bacteriostaticWater > 0 &&
        state.desiredDose > 0
    }
}

struct StepHeader: View {
    let number: Int
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 28, height: 28)
                .overlay(
                    Text("\(number)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                )

            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
}

struct CompoundPill: View {
    let compound: PeptideCompound
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            Text(compound.displayName)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickSelectButton: View {
    let value: Double
    let unit: String
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            Text("\(formatValue(value)) \(unit)")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func formatValue(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.2f", value).trimmingCharacters(in: CharacterSet(charactersIn: "0")).trimmingCharacters(in: CharacterSet(charactersIn: "."))
        }
    }
}

struct ResultsCard: View {
    let state: CalculatorState
    let compound: PeptideCompound

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 20))
                Text("Your Results")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
            }

            Divider()

            // Concentration
            ResultRow(
                icon: "flask",
                label: "Concentration",
                value: String(format: "%.2f mg/mL", state.concentration),
                subtitle: "\(formatValue(state.vialSize)) mg in \(formatValue(state.bacteriostaticWater)) mL"
            )

            // Draw Volume
            ResultRow(
                icon: "syringe",
                label: "Draw Volume",
                value: String(format: "%.3f mL", state.drawVolume),
                subtitle: "For \(formatValue(state.desiredDose)) mg dose",
                highlight: true
            )

            // Units
            ResultRow(
                icon: "number",
                label: "Syringe Units",
                value: String(format: "%.0f units", state.units),
                subtitle: "On a 100-unit insulin syringe"
            )

            // Doses per Vial
            ResultRow(
                icon: "list.number",
                label: "Doses Per Vial",
                value: String(format: "%.1f doses", state.dosesPerVial),
                subtitle: "At \(formatValue(state.desiredDose)) mg per dose"
            )
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    private func formatValue(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.2f", value)
        }
    }
}

struct ResultRow: View {
    let icon: String
    let label: String
    let value: String
    let subtitle: String
    var highlight: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(highlight ? .blue : .secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.system(size: 18, weight: highlight ? .bold : .semibold))
                    .foregroundColor(highlight ? .blue : .primary)

                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CalculatorView()
}
