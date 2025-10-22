import SwiftUI

struct ProtocolBuilderView: View {
    @State private var viewModel = ProtocolBuilderViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
                // Header
                PFSectionHeader(
                    title: "Protocol Builder",
                    subtitle: "Design your personalized peptide stack with safety validation"
                )
                
                // Protocol Info
                protocolInfoCard
                
                // Peptides Stack
                peptidesStackCard
                
                // Validation
                if let validation = viewModel.validationResult {
                    validationCard(validation)
                }
                
                // Actions
                actionsCard
            }
            .padding(DesignTokens.Spacing.screenPadding)
        }
        .background(ColorTokens.backgroundGrouped)
        .navigationTitle("Protocol Builder")
        .sheet(isPresented: $viewModel.showingPeptideSelector) {
            peptideSelectorSheet
        }
    }
    
    // MARK: - Protocol Info Card
    
    private var protocolInfoCard: some View {
        PFCard {
            VStack(spacing: DesignTokens.Spacing.md) {
                PFTextField(
                    label: "Protocol Name",
                    placeholder: "e.g., My Recomp Stack",
                    text: $viewModel.protocolName,
                    icon: "text.alignleft"
                )
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    Text("Goal")
                        .font(DesignTokens.Typography.labelMedium)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                    
                    Picker("Goal", selection: $viewModel.goal) {
                        ForEach(viewModel.availableGoals, id: \.self) { goal in
                            Text(goal).tag(goal)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(ColorTokens.brandPrimary)
                }
            }
        }
    }
    
    // MARK: - Peptides Stack Card
    
    private var peptidesStackCard: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    Text("Peptides")
                        .font(DesignTokens.Typography.headlineSmall)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                    
                    Text("(\(viewModel.peptides.count))")
                        .font(DesignTokens.Typography.labelMedium)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                    
                    Spacer()
                }
                
                if viewModel.peptides.isEmpty {
                    emptyPeptidesState
                } else {
                    VStack(spacing: DesignTokens.Spacing.md) {
                        ForEach(viewModel.peptides) { protocolPeptide in
                            protocolPeptideRow(protocolPeptide)
                        }
                    }
                }
                
                // Add Peptide Button
                Button {
                    viewModel.showingPeptideSelector = true
                } label: {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: "plus.circle.fill")
                            .font(DesignTokens.Typography.bodyLarge)
                        Text("Add Peptide")
                            .font(DesignTokens.Typography.labelLarge)
                    }
                    .foregroundColor(ColorTokens.brandPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: DesignTokens.Layout.minTouchTarget)
                    .background(ColorTokens.brandPrimary.opacity(0.1))
                    .cornerRadius(DesignTokens.CornerRadius.md)
                }
            }
        }
    }
    
    private var emptyPeptidesState: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: "doc.text")
                .font(.system(size: 40))
                .foregroundColor(ColorTokens.foregroundTertiary)
            
            Text("No peptides added yet")
                .font(DesignTokens.Typography.bodyMedium)
                .foregroundColor(ColorTokens.foregroundSecondary)
            
            Text("Tap 'Add Peptide' to build your stack")
                .font(DesignTokens.Typography.bodySmall)
                .foregroundColor(ColorTokens.foregroundTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(DesignTokens.Spacing.xl)
    }
    
    private func protocolPeptideRow(_ protocolPeptide: ProtocolPeptide) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(protocolPeptide.peptide.name)
                        .font(DesignTokens.Typography.bodyLarge)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                    
                    Text(protocolPeptide.doseDisplay)
                        .font(DesignTokens.Typography.bodySmall)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                }
                
                Spacer()
                
                // Phase badge
                Text(protocolPeptide.phase.rawValue)
                    .font(DesignTokens.Typography.labelSmall)
                    .foregroundColor(protocolPeptide.phase.color)
                    .padding(.horizontal, DesignTokens.Spacing.sm)
                    .padding(.vertical, DesignTokens.Spacing.xs)
                    .background(protocolPeptide.phase.color.opacity(0.1))
                    .cornerRadius(DesignTokens.CornerRadius.pill)
                
                // Remove button
                Button {
                    withAnimation(AnimationTokens.spring) {
                        viewModel.removePeptide(protocolPeptide)
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ColorTokens.foregroundTertiary)
                        .font(DesignTokens.Typography.headlineSmall)
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(ColorTokens.backgroundSecondary)
        .cornerRadius(DesignTokens.CornerRadius.sm)
    }
    
    // MARK: - Validation Card
    
    private func validationCard(_ validation: ValidationResult) -> some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: validation.canActivate ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                        .foregroundColor(validation.canActivate ? ColorTokens.success : ColorTokens.warning)
                    
                    Text("Validation")
                        .font(DesignTokens.Typography.headlineSmall)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                }
                
                // Errors
                if !validation.errors.isEmpty {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        ForEach(validation.errors) { error in
                            validationItem(
                                icon: "xmark.circle.fill",
                                color: ColorTokens.error,
                                title: error.title,
                                message: error.message
                            )
                        }
                    }
                }
                
                // Warnings
                if !validation.warnings.isEmpty {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        ForEach(validation.warnings) { warning in
                            validationItem(
                                icon: warningIcon(for: warning.severity),
                                color: warningColor(for: warning.severity),
                                title: warning.title,
                                message: warning.message
                            )
                        }
                    }
                }
                
                // All good
                if validation.canActivate && validation.warnings.isEmpty {
                    validationItem(
                        icon: "checkmark.circle.fill",
                        color: ColorTokens.success,
                        title: "All checks passed",
                        message: "Protocol is ready to activate"
                    )
                }
            }
        }
    }
    
    private func validationItem(icon: String, color: Color, title: String, message: String) -> some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.md) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(DesignTokens.Typography.bodyMedium)
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(title)
                    .font(DesignTokens.Typography.labelLarge)
                    .foregroundColor(ColorTokens.foregroundPrimary)
                
                Text(message)
                    .font(DesignTokens.Typography.bodySmall)
                    .foregroundColor(ColorTokens.foregroundSecondary)
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(color.opacity(0.1))
        .cornerRadius(DesignTokens.CornerRadius.sm)
    }
    
    // MARK: - Actions Card
    
    private var actionsCard: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            PFButton.outline("Save Draft") {
                viewModel.saveAsDraft()
            }
            
            if viewModel.validationResult?.canActivate == true {
                PFButton.primary("Activate Protocol", icon: "bolt.fill") {
                    viewModel.activate()
                }
            }
        }
    }
    
    // MARK: - Peptide Selector Sheet
    
    private var peptideSelectorSheet: some View {
        NavigationStack {
            List(PeptideDatabase.all) { peptide in
                Button {
                    viewModel.addPeptide(peptide)
                } label: {
                    HStack(spacing: DesignTokens.Spacing.md) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                            Text(peptide.name)
                                .font(DesignTokens.Typography.bodyLarge)
                                .foregroundColor(ColorTokens.foregroundPrimary)
                            
                            Text(peptide.category.rawValue)
                                .font(DesignTokens.Typography.bodySmall)
                                .foregroundColor(ColorTokens.foregroundSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "plus.circle")
                            .foregroundColor(ColorTokens.brandPrimary)
                    }
                }
            }
            .navigationTitle("Select Peptide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.showingPeptideSelector = false
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func warningIcon(for severity: ValidationWarning.Severity) -> String {
        switch severity {
        case .info: return "info.circle.fill"
        case .caution: return "exclamationmark.triangle.fill"
        case .warning: return "exclamationmark.circle.fill"
        }
    }
    
    private func warningColor(for severity: ValidationWarning.Severity) -> Color {
        switch severity {
        case .info: return ColorTokens.info
        case .caution: return ColorTokens.warning
        case .warning: return ColorTokens.error
        }
    }
}

#Preview {
    NavigationStack {
        ProtocolBuilderView()
    }
}
