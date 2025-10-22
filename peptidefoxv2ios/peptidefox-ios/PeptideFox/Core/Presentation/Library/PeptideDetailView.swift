import SwiftUI

struct PeptideDetailView: View {
    let peptide: Peptide
    @State private var showingProtocol = true
    @State private var showingContraindications = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
                // Hero Section
                heroSection
                
                // Mechanism
                mechanismSection
                
                // Dosing Info
                dosingSection
                
                // Benefits
                benefitsSection
                
                // Protocol Section
                protocolSection
                
                // Contraindications
                contraindicationsSection
                
                // Signals
                signalsSection
                
                // Synergies
                if !peptide.synergies.isEmpty {
                    synergiesSection
                }
                
                // Action Button
                addToProtocolButton
            }
            .padding(DesignTokens.Layout.screenPadding)
        }
        .background(ColorTokens.backgroundGrouped)
        .navigationTitle(peptide.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Hero Section
    
    private var heroSection: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                HStack {
                    PFBadge(text: peptide.category.rawValue, category: peptide.category)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(peptide.evidenceLevel.color)
                        
                        Text(peptide.evidenceLevel.rawValue)
                            .font(DesignTokens.Typography.labelMedium)
                            .foregroundColor(ColorTokens.foregroundSecondary)
                    }
                }
                
                Text(peptide.name)
                    .font(DesignTokens.Typography.displayMedium)
                    .foregroundColor(ColorTokens.foregroundPrimary)
                
                Text(peptide.description)
                    .font(DesignTokens.Typography.bodyLarge)
                    .foregroundColor(ColorTokens.foregroundSecondary)
            }
        }
    }
    
    // MARK: - Mechanism
    
    private var mechanismSection: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                PFSectionHeader(title: "Mechanism of Action")
                
                Text(peptide.mechanism)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundColor(ColorTokens.foregroundSecondary)
            }
        }
    }
    
    // MARK: - Dosing Info
    
    private var dosingSection: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                PFSectionHeader(title: "Dosing Information")
                
                VStack(spacing: DesignTokens.Spacing.md) {
                    InfoRow(
                        icon: "syringe",
                        label: "Typical Dose",
                        value: peptide.typicalDose.displayRange,
                        accentColor: peptide.category.accentColor
                    )
                    
                    InfoRow(
                        icon: "calendar",
                        label: "Frequency",
                        value: peptide.frequency,
                        accentColor: peptide.category.accentColor
                    )
                    
                    InfoRow(
                        icon: "clock",
                        label: "Cycle Length",
                        value: peptide.cycleLength,
                        accentColor: peptide.category.accentColor
                    )
                }
            }
        }
    }
    
    // MARK: - Benefits
    
    private var benefitsSection: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                PFSectionHeader(title: "Benefits")
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    ForEach(peptide.benefits, id: \.self) { benefit in
                        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(ColorTokens.success)
                            
                            Text(benefit)
                                .font(DesignTokens.Typography.bodyMedium)
                                .foregroundColor(ColorTokens.foregroundSecondary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Protocol Section
    
    private var protocolSection: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Button {
                    withAnimation(AnimationTokens.spring) {
                        showingProtocol.toggle()
                    }
                } label: {
                    HStack {
                        Text("Protocol Guidelines")
                            .font(DesignTokens.Typography.headlineSmall)
                            .foregroundColor(ColorTokens.foregroundPrimary)
                        
                        Spacer()
                        
                        Image(systemName: showingProtocol ? "chevron.up" : "chevron.down")
                            .font(DesignTokens.Typography.labelMedium)
                            .foregroundColor(ColorTokens.foregroundSecondary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                if showingProtocol {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("Recommended protocol based on current research and clinical experience.")
                            .font(DesignTokens.Typography.bodySmall)
                            .foregroundColor(ColorTokens.foregroundTertiary)
                            .italic()
                        
                        Divider()
                        
                        InfoRow(
                            icon: "calendar.badge.clock",
                            label: "Duration",
                            value: peptide.cycleLength,
                            accentColor: peptide.category.accentColor
                        )
                        
                        InfoRow(
                            icon: "arrow.triangle.2.circlepath",
                            label: "Frequency",
                            value: peptide.frequency,
                            accentColor: peptide.category.accentColor
                        )
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
    }
    
    // MARK: - Contraindications
    
    private var contraindicationsSection: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Button {
                    withAnimation(AnimationTokens.spring) {
                        showingContraindications.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(ColorTokens.warning)
                        
                        Text("Contraindications")
                            .font(DesignTokens.Typography.headlineSmall)
                            .foregroundColor(ColorTokens.foregroundPrimary)
                        
                        Spacer()
                        
                        Image(systemName: showingContraindications ? "chevron.up" : "chevron.down")
                            .font(DesignTokens.Typography.labelMedium)
                            .foregroundColor(ColorTokens.foregroundSecondary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                if showingContraindications {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        ForEach(peptide.contraindications, id: \.self) { contraindication in
                            HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(ColorTokens.error)
                                
                                Text(contraindication)
                                    .font(DesignTokens.Typography.bodyMedium)
                                    .foregroundColor(ColorTokens.foregroundSecondary)
                            }
                        }
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
    }
    
    // MARK: - Signals
    
    private var signalsSection: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                PFSectionHeader(
                    title: "Success Signals",
                    subtitle: "What to look for during treatment"
                )
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    ForEach(peptide.signals, id: \.self) { signal in
                        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 16))
                                .foregroundColor(peptide.category.accentColor)
                            
                            Text(signal)
                                .font(DesignTokens.Typography.bodyMedium)
                                .foregroundColor(ColorTokens.foregroundSecondary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Synergies
    
    private var synergiesSection: some View {
        PFCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                PFSectionHeader(
                    title: "Synergistic Peptides",
                    subtitle: "Works well in combination with"
                )
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignTokens.Spacing.md) {
                        ForEach(peptide.synergies, id: \.self) { synergyId in
                            if let synergyPeptide = PeptideDatabase.peptide(withId: synergyId) {
                                NavigationLink(destination: PeptideDetailView(peptide: synergyPeptide)) {
                                    SynergyChip(peptide: synergyPeptide)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Add to Protocol Button
    
    private var addToProtocolButton: some View {
        PFButton.primary("Add to Protocol", icon: "plus.circle.fill") {
            // Add to protocol action
            print("Add \(peptide.name) to protocol")
        }
        .accessibilityLabel("Add \(peptide.name) to protocol")
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: icon)
                .font(DesignTokens.Typography.bodyMedium)
                .foregroundColor(accentColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(DesignTokens.Typography.labelSmall)
                    .foregroundColor(ColorTokens.foregroundTertiary)
                
                Text(value)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundColor(ColorTokens.foregroundPrimary)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

// MARK: - Synergy Chip
struct SynergyChip: View {
    let peptide: Peptide
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text(peptide.name)
                .font(DesignTokens.Typography.labelMedium)
                .foregroundColor(ColorTokens.foregroundPrimary)
            
            Text(peptide.category.rawValue)
                .font(DesignTokens.Typography.caption)
                .foregroundColor(ColorTokens.foregroundTertiary)
        }
        .padding(DesignTokens.Spacing.md)
        .background(peptide.category.backgroundColor)
        .cornerRadius(DesignTokens.CornerRadius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                .stroke(peptide.category.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        PeptideDetailView(
            peptide: Peptide(
                id: "semaglutide",
                name: "Semaglutide",
                category: .glp1,
                description: "GLP-1 receptor agonist for weight loss and metabolic health",
                mechanism: "Mimics GLP-1 hormone to regulate appetite",
                benefits: ["Significant weight loss", "Improved glycemic control"],
                typicalDose: DoseRange(min: 0.25, max: 2.4, unit: "mg"),
                frequency: "Weekly",
                cycleLength: "Ongoing",
                contraindications: ["Thyroid cancer history"],
                signals: ["Reduced hunger within 1-2 weeks"],
                synergies: ["tirzepatide", "bpc-157"],
                evidenceLevel: .high
            )
        )
    }
}
