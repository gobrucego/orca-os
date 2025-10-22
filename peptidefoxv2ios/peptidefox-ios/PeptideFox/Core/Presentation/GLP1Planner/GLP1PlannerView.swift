import SwiftUI

struct GLP1PlannerView: View {
    @State private var viewModel = GLP1PlannerViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
                // Header
                PFSectionHeader(
                    title: "GLP-1 Dose Planner",
                    subtitle: "Plan your GLP-1 titration schedule with evidence-based escalation"
                )
                
                // Peptide Selection
                peptideSelectionCard
                
                // Frequency Selection
                frequencySelectionCard
                
                // Timeline
                if !viewModel.weeklySchedule.isEmpty {
                    titrationTimelineCard
                }
                
                // Contraindications
                if let peptide = viewModel.selectedPeptide {
                    contraindicationsCard(for: peptide)
                }
                
                // Success Signals
                if let peptide = viewModel.selectedPeptide {
                    successSignalsCard(for: peptide)
                }
            }
            .padding(DesignTokens.Spacing.screenPadding)
        }
        .background(ColorTokens.backgroundGrouped)
        .navigationTitle("GLP-1 Planner")
    }
    
    // MARK: - Peptide Selection Card
    
    private var peptideSelectionCard: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Select Peptide")
                    .font(DesignTokens.Typography.headlineSmall)
                    .foregroundColor(ColorTokens.foregroundPrimary)
                
                VStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(glp1Peptides) { peptide in
                        peptideOption(peptide)
                    }
                }
            }
        }
    }
    
    private func peptideOption(_ peptide: Peptide) -> some View {
        Button {
            withAnimation(AnimationTokens.spring) {
                viewModel.selectPeptide(peptide)
            }
        } label: {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: viewModel.selectedPeptide?.id == peptide.id ? "checkmark.circle.fill" : "circle")
                    .font(DesignTokens.Typography.headlineSmall)
                    .foregroundColor(viewModel.selectedPeptide?.id == peptide.id ? ColorTokens.brandPrimary : ColorTokens.foregroundTertiary)
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(peptide.name)
                        .font(DesignTokens.Typography.bodyLarge)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                    
                    Text(peptide.description)
                        .font(DesignTokens.Typography.bodySmall)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(DesignTokens.Spacing.md)
            .background(ColorTokens.backgroundSecondary)
            .cornerRadius(DesignTokens.CornerRadius.sm)
        }
    }
    
    // MARK: - Frequency Selection
    
    private var frequencySelectionCard: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Frequency")
                    .font(DesignTokens.Typography.headlineSmall)
                    .foregroundColor(ColorTokens.foregroundPrimary)
                
                Picker("Frequency", selection: $viewModel.frequency) {
                    ForEach(FrequencyPattern.allCases) { pattern in
                        Text(pattern.rawValue).tag(pattern)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.frequency) {
                    viewModel.updateFrequency(viewModel.frequency)
                }
            }
        }
    }
    
    // MARK: - Titration Timeline
    
    private var titrationTimelineCard: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                HStack {
                    Text("Titration Schedule")
                        .font(DesignTokens.Typography.headlineSmall)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                    
                    Spacer()
                    
                    Text("\(viewModel.totalWeeks) weeks")
                        .font(DesignTokens.Typography.labelMedium)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                }
                
                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(viewModel.weeklySchedule) { milestone in
                        milestoneRow(milestone)
                    }
                }
            }
        }
    }
    
    private func milestoneRow(_ milestone: DoseMilestone) -> some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            // Week indicator
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(milestone.weekRange)
                    .font(DesignTokens.Typography.labelLarge)
                    .foregroundColor(ColorTokens.foregroundPrimary)
            }
            
            Spacer()
            
            // Dose badge
            if let peptide = viewModel.selectedPeptide {
                Text("\(formatDose(milestone.dose)) \(peptide.typicalDose.unit)")
                    .font(DesignTokens.Typography.labelMedium)
                    .foregroundColor(peptide.category.accentColor)
                    .padding(.horizontal, DesignTokens.Spacing.md)
                    .padding(.vertical, DesignTokens.Spacing.xs)
                    .background(peptide.category.backgroundColor)
                    .cornerRadius(DesignTokens.CornerRadius.pill)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.pill)
                            .stroke(peptide.category.borderColor, lineWidth: 1)
                    )
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(ColorTokens.backgroundSecondary)
        .cornerRadius(DesignTokens.CornerRadius.sm)
    }
    
    // MARK: - Contraindications
    
    private func contraindicationsCard(for peptide: Peptide) -> some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(ColorTokens.warning)
                    
                    Text("Contraindications")
                        .font(DesignTokens.Typography.headlineSmall)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                }
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    ForEach(peptide.contraindications, id: \.self) { contraindication in
                        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                            Text("•")
                                .foregroundColor(ColorTokens.foregroundSecondary)
                            Text(contraindication)
                                .font(DesignTokens.Typography.bodyMedium)
                                .foregroundColor(ColorTokens.foregroundSecondary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Success Signals
    
    private func successSignalsCard(for peptide: Peptide) -> some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ColorTokens.success)
                    
                    Text("Success Signals")
                        .font(DesignTokens.Typography.headlineSmall)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                }
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    ForEach(peptide.signals, id: \.self) { signal in
                        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                            Image(systemName: "checkmark")
                                .font(DesignTokens.Typography.bodySmall)
                                .foregroundColor(ColorTokens.success)
                            Text(signal)
                                .font(DesignTokens.Typography.bodyMedium)
                                .foregroundColor(ColorTokens.foregroundSecondary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private var glp1Peptides: [Peptide] {
        PeptideDatabase.peptides(in: .glp1)
    }
    
    private func formatDose(_ dose: Double) -> String {
        if dose.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", dose)
        } else if dose < 1 {
            return String(format: "%.2f", dose)
        } else {
            return String(format: "%.1f", dose)
        }
    }
}

#Preview {
    NavigationStack {
        GLP1PlannerView()
    }
}
