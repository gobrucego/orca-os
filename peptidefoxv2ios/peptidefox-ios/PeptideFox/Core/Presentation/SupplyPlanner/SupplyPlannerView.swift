import SwiftUI

struct SupplyPlannerView: View {
    @State private var viewModel = SupplyPlannerViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
                // Header
                PFSectionHeader(
                    title: "Supply Planner",
                    subtitle: "Calculate monthly supply needs and reorder timeline"
                )
                
                // Peptide Selection
                peptideSelectionCard
                
                // Input Parameters
                inputParametersCard
                
                // Supply Estimate
                if let output = viewModel.supplyOutput {
                    supplyEstimateCard(output)
                }
                
                // Reorder Schedule
                if let output = viewModel.supplyOutput {
                    reorderScheduleCard(output)
                }
                
                // Cost Estimate
                if let output = viewModel.supplyOutput {
                    costEstimateCard(output)
                }
                
                // Actions
                actionsCard
            }
            .padding(DesignTokens.Spacing.screenPadding)
        }
        .background(ColorTokens.backgroundGrouped)
        .navigationTitle("Supply Planner")
        .sheet(isPresented: $viewModel.showingPeptideSelector) {
            peptideSelectorSheet
        }
    }
    
    // MARK: - Peptide Selection Card
    
    private var peptideSelectionCard: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Peptide")
                    .font(DesignTokens.Typography.headlineSmall)
                    .foregroundColor(ColorTokens.foregroundPrimary)
                
                Button {
                    viewModel.showingPeptideSelector = true
                } label: {
                    HStack {
                        if let peptide = viewModel.selectedPeptide {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                                Text(peptide.name)
                                    .font(DesignTokens.Typography.bodyLarge)
                                    .foregroundColor(ColorTokens.foregroundPrimary)
                                
                                Text(peptide.category.rawValue)
                                    .font(DesignTokens.Typography.bodySmall)
                                    .foregroundColor(ColorTokens.foregroundSecondary)
                            }
                        } else {
                            Text("Select peptide")
                                .font(DesignTokens.Typography.bodyLarge)
                                .foregroundColor(ColorTokens.foregroundTertiary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(ColorTokens.foregroundTertiary)
                    }
                    .padding(DesignTokens.Spacing.md)
                    .background(ColorTokens.backgroundSecondary)
                    .cornerRadius(DesignTokens.CornerRadius.sm)
                }
            }
        }
    }
    
    // MARK: - Input Parameters Card
    
    private var inputParametersCard: some View {
        PFCard {
            VStack(spacing: DesignTokens.Spacing.lg) {
                if let peptide = viewModel.selectedPeptide {
                    PFNumberField(
                        label: "Vial Size",
                        value: $viewModel.vialSize,
                        unit: peptide.typicalDose.unit,
                        icon: "flask"
                    )
                    .onChange(of: viewModel.vialSize) {
                        viewModel.calculateSupply()
                    }
                }
                
                PFNumberField(
                    label: "Reconstitution Volume",
                    value: $viewModel.reconVolume,
                    unit: "ml",
                    icon: "drop"
                )
                .onChange(of: viewModel.reconVolume) {
                    viewModel.calculateSupply()
                }
                
                if let peptide = viewModel.selectedPeptide {
                    PFNumberField(
                        label: "Dose Per Injection",
                        value: $viewModel.dosePerInjection,
                        unit: peptide.typicalDose.unit,
                        icon: "syringe"
                    )
                    .onChange(of: viewModel.dosePerInjection) {
                        viewModel.calculateSupply()
                    }
                }
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    Text("Frequency")
                        .font(DesignTokens.Typography.labelMedium)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                    
                    Picker("Frequency", selection: Binding(
                        get: { viewModel.frequency.pattern },
                        set: { viewModel.updateFrequency($0) }
                    )) {
                        Text("Daily").tag("daily")
                        Text("Every Other Day").tag("every other day")
                        Text("2-3x per week").tag("2-3x per week")
                        Text("Weekly").tag("weekly")
                    }
                    .pickerStyle(.menu)
                    .tint(ColorTokens.brandPrimary)
                }
            }
        }
    }
    
    // MARK: - Supply Estimate Card
    
    private func supplyEstimateCard(_ output: SupplyOutput) -> some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(ColorTokens.brandPrimary)
                    
                    Text("Supply Estimate")
                        .font(DesignTokens.Typography.headlineSmall)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                }
                
                VStack(spacing: DesignTokens.Spacing.md) {
                    supplyMetricRow(
                        label: "Doses per Vial",
                        value: "\(output.dosesPerVial)",
                        icon: "syringe"
                    )
                    
                    supplyMetricRow(
                        label: "Days per Vial",
                        value: "\(output.daysPerVial)",
                        icon: "calendar"
                    )
                    
                    supplyMetricRow(
                        label: "Vials per Month",
                        value: "\(output.vialsPerMonth)",
                        icon: "flask.fill",
                        highlighted: true
                    )
                }
            }
        }
    }
    
    private func supplyMetricRow(label: String, value: String, icon: String, highlighted: Bool = false) -> some View {
        HStack {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: icon)
                    .foregroundColor(highlighted ? ColorTokens.brandPrimary : ColorTokens.foregroundTertiary)
                    .font(DesignTokens.Typography.bodyMedium)
                
                Text(label)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundColor(ColorTokens.foregroundSecondary)
            }
            
            Spacer()
            
            Text(value)
                .font(highlighted ? DesignTokens.Typography.headlineMedium : DesignTokens.Typography.bodyLarge)
                .foregroundColor(highlighted ? ColorTokens.brandPrimary : ColorTokens.foregroundPrimary)
        }
        .padding(DesignTokens.Spacing.md)
        .background(highlighted ? ColorTokens.brandPrimary.opacity(0.1) : ColorTokens.backgroundSecondary)
        .cornerRadius(DesignTokens.CornerRadius.sm)
    }
    
    // MARK: - Reorder Schedule Card
    
    private func reorderScheduleCard(_ output: SupplyOutput) -> some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "calendar.badge.clock")
                        .foregroundColor(ColorTokens.info)
                    
                    Text("Reorder Schedule")
                        .font(DesignTokens.Typography.headlineSmall)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                }
                
                VStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(output.reorderSchedule.prefix(4)) { reorderPoint in
                        reorderPointRow(reorderPoint)
                    }
                }
            }
        }
    }
    
    private func reorderPointRow(_ point: ReorderPoint) -> some View {
        HStack {
            Text(point.displayDay)
                .font(DesignTokens.Typography.labelLarge)
                .foregroundColor(ColorTokens.foregroundPrimary)
            
            Spacer()
            
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text(point.displayVial)
                    .font(DesignTokens.Typography.labelMedium)
                    .foregroundColor(point.isUrgent ? ColorTokens.warning : ColorTokens.foregroundSecondary)
                
                if point.isUrgent {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(ColorTokens.warning)
                        .font(DesignTokens.Typography.bodySmall)
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(point.isUrgent ? ColorTokens.warning.opacity(0.1) : ColorTokens.backgroundSecondary)
        .cornerRadius(DesignTokens.CornerRadius.sm)
    }
    
    // MARK: - Cost Estimate Card
    
    private func costEstimateCard(_ output: SupplyOutput) -> some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(ColorTokens.success)
                    
                    Text("Monthly Cost")
                        .font(DesignTokens.Typography.headlineSmall)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                }
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Text("Cost per Vial")
                            .font(DesignTokens.Typography.bodyMedium)
                            .foregroundColor(ColorTokens.foregroundSecondary)
                        
                        Spacer()
                        
                        TextField("35", value: $viewModel.costPerVial, format: .number)
                            .font(DesignTokens.Typography.bodyLarge)
                            .foregroundColor(ColorTokens.foregroundPrimary)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .onChange(of: viewModel.costPerVial) {
                                viewModel.calculateSupply()
                            }
                    }
                    .padding(DesignTokens.Spacing.md)
                    .background(ColorTokens.backgroundSecondary)
                    .cornerRadius(DesignTokens.CornerRadius.sm)
                    
                    if let monthlyCost = output.estimatedMonthlyCost {
                        HStack {
                            Text("\(output.vialsPerMonth) vials × $\(Int(viewModel.costPerVial))")
                                .font(DesignTokens.Typography.bodyMedium)
                                .foregroundColor(ColorTokens.foregroundSecondary)
                            
                            Spacer()
                            
                            Text("$\(Int(monthlyCost))")
                                .font(DesignTokens.Typography.headlineLarge)
                                .foregroundColor(ColorTokens.success)
                        }
                        .padding(DesignTokens.Spacing.lg)
                        .background(ColorTokens.success.opacity(0.1))
                        .cornerRadius(DesignTokens.CornerRadius.md)
                    }
                }
            }
        }
    }
    
    // MARK: - Actions Card
    
    private var actionsCard: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            PFButton.outline("Reset", icon: "arrow.counterclockwise") {
                viewModel.reset()
            }
        }
    }
    
    // MARK: - Peptide Selector Sheet
    
    private var peptideSelectorSheet: some View {
        NavigationStack {
            List {
                ForEach(PeptideCategory.allCases) { category in
                    Section(header: Text(category.rawValue)) {
                        ForEach(PeptideDatabase.peptides(in: category)) { peptide in
                            Button {
                                viewModel.selectPeptide(peptide)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                                        Text(peptide.name)
                                            .font(DesignTokens.Typography.bodyLarge)
                                            .foregroundColor(ColorTokens.foregroundPrimary)
                                        
                                        Text(peptide.typicalDose.displayRange)
                                            .font(DesignTokens.Typography.bodySmall)
                                            .foregroundColor(ColorTokens.foregroundSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if viewModel.selectedPeptide?.id == peptide.id {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(ColorTokens.brandPrimary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Peptide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        viewModel.showingPeptideSelector = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SupplyPlannerView()
    }
}
