import SwiftUI

struct CompoundPickerView: View {
    @Binding var selectedCompound: CommonPeptide?
    let onSelect: (CommonPeptide) -> Void
    let onSelectBlend: (BlendType) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var showBlendPicker = false
    @State private var selectedBlendType: BlendType?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Prominent Search Bar (60px hero position)
                searchBarView
                    .padding(DesignTokens.Layout.screenPadding)
                    .background(ColorTokens.backgroundPrimary)

                ScrollView {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxl) {
                        // Featured Compounds (only show when no search)
                        if searchText.isEmpty {
                            featuredCompoundsSection
                        }

                        if searchText.isEmpty && !filteredPeptides.isEmpty {
                            Divider()
                                .padding(.vertical, DesignTokens.Spacing.sm)
                        }

                        // All Peptides List
                        if !filteredPeptides.isEmpty {
                            compoundListView
                        } else if !searchText.isEmpty {
                            // No results message
                            VStack(spacing: DesignTokens.Spacing.md) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 48))
                                    .foregroundColor(ColorTokens.foregroundTertiary)
                                Text("No compounds found")
                                    .font(DesignTokens.Typography.bodyLarge)
                                    .foregroundColor(ColorTokens.foregroundSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, DesignTokens.Spacing.xxl)
                        }
                    }
                    .padding(DesignTokens.Layout.screenPadding)
                }
                .background(ColorTokens.backgroundGrouped)
            }
            .navigationTitle("Select Compound")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            // Temporarily commented out due to missing BlendVariantPickerView component
            // .sheet(isPresented: $showBlendPicker) {
            //     BlendVariantPickerView { blendType in
            //         onSelectBlend(blendType)
            //         showBlendPicker = false
            //         dismiss()
            //     }
            // }
        }
        .onAppear {
            print("🎯 CompoundPickerView appeared")
            print("🎯 Featured peptides count: \(featuredPeptides.count)")
            print("🎯 Filtered peptides count: \(filteredPeptides.count)")
        }
    }

    // MARK: - Search Bar (Hero Position)

    private var searchBarView: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .foregroundColor(ColorTokens.foregroundSecondary)

            TextField("Search compounds...", text: $searchText)
                .font(DesignTokens.Typography.bodyLarge)
                .foregroundColor(ColorTokens.foregroundPrimary)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.vertical, DesignTokens.Spacing.md)
        .frame(height: 60) // 60px hero height from design spec
        .background(ColorTokens.backgroundSecondary)
        .cornerRadius(DesignTokens.CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                .stroke(ColorTokens.borderPrimary, lineWidth: 1)
        )
    }
    
    // MARK: - Featured Compounds (Clean Minimal Design)

    private var featuredCompoundsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("FEATURED")
                .font(DesignTokens.Typography.headlineMedium)
                .foregroundColor(ColorTokens.foregroundPrimary)

            // 4-column grid with Retatrutide, Tirzepatide, NAD+, GLOW/KLOW
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: DesignTokens.Spacing.md) {
                // Card 1: Retatrutide
                Button {
                    if let peptide = CalculatorViewModel.commonPeptides.first(where: { $0.name == "Retatrutide" }) {
                        onSelect(peptide)
                    }
                } label: {
                    Text("Retatrutide")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(ColorTokens.foregroundPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 108)  // 108px uniform height (design spec)
                        .background(ColorTokens.backgroundPrimary)
                        .cornerRadius(DesignTokens.CornerRadius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                                .stroke(ColorTokens.borderPrimary, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)

                // Card 2: Tirzepatide
                Button {
                    if let peptide = CalculatorViewModel.commonPeptides.first(where: { $0.name == "Tirzepatide" }) {
                        onSelect(peptide)
                    }
                } label: {
                    Text("Tirzepatide")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(ColorTokens.foregroundPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 108)  // 108px uniform height
                        .background(ColorTokens.backgroundPrimary)
                        .cornerRadius(DesignTokens.CornerRadius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                                .stroke(ColorTokens.borderPrimary, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)

                // Card 3: NAD+
                Button {
                    if let peptide = CalculatorViewModel.commonPeptides.first(where: { $0.name == "NAD+" }) {
                        onSelect(peptide)
                    }
                } label: {
                    Text("NAD+")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(ColorTokens.foregroundPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 108)  // 108px uniform height
                        .background(ColorTokens.backgroundPrimary)
                        .cornerRadius(DesignTokens.CornerRadius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                                .stroke(ColorTokens.borderPrimary, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)

                // Card 4: GLOW/KLOW
                Button {
                    showBlendPicker = true
                } label: {
                    Text("GLOW/KLOW")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(ColorTokens.foregroundPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 108)  // 108px uniform height
                        .background(ColorTokens.backgroundPrimary)
                        .cornerRadius(DesignTokens.CornerRadius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                                .stroke(ColorTokens.borderPrimary, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Compound List (Compact 52px rows)

    private var compoundListView: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("ALL COMPOUNDS")
                .font(DesignTokens.Typography.headlineMedium)
                .foregroundColor(ColorTokens.foregroundPrimary)
                .padding(.bottom, DesignTokens.Spacing.xs)

            ForEach(filteredPeptides, id: \.id) { peptide in
                Button {
                    onSelect(peptide)
                } label: {
                    HStack(spacing: DesignTokens.Spacing.md) {
                        Text(peptide.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ColorTokens.foregroundPrimary)

                        Spacer()

                        // Category badge for cocktails
                        if peptide.isCocktail {
                            Text("Blend")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(ColorTokens.foregroundSecondary)
                                .padding(.horizontal, DesignTokens.Spacing.sm)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .cornerRadius(6)
                        }

                        Image(systemName: "chevron.right")
                            .font(.system(size: 13))
                            .foregroundColor(ColorTokens.foregroundTertiary)
                    }
                    .frame(height: 52)  // Compact 52px for simple content
                    .padding(.horizontal, DesignTokens.Spacing.md)
                    .background(ColorTokens.backgroundPrimary)
                    .cornerRadius(DesignTokens.CornerRadius.md)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Computed Properties

    private var featuredPeptides: [CommonPeptide] {
        // Return only the 3 featured peptides displayed in the grid
        CalculatorViewModel.commonPeptides.filter {
            $0.name == "Retatrutide" || $0.name == "Tirzepatide" || $0.name == "NAD+"
        }
    }

    private var filteredPeptides: [CommonPeptide] {
        // Exclude the 3 featured peptides (Retatrutide, Tirzepatide, NAD+) from the list
        let excludedNames = Set(["Retatrutide", "Tirzepatide", "NAD+"])
        var peptides = CalculatorViewModel.commonPeptides.filter { !excludedNames.contains($0.name) }

        // Filter by search
        if !searchText.isEmpty {
            peptides = peptides.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        return peptides
    }
    
    // MARK: - Helpers
    
    private func formatValue(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
}


// MARK: - Preview

#Preview {
    CompoundPickerView(
        selectedCompound: .constant(nil),
        onSelect: { _ in },
        onSelectBlend: { _ in }
    )
}
