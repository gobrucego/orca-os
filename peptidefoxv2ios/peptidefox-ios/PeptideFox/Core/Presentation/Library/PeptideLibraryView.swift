import SwiftUI

struct PeptideLibraryView: View {
    @State private var viewModel = PeptideLibraryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                categoryFilterView
                
                // Peptide Grid
                if viewModel.filteredPeptides.isEmpty {
                    emptyStateView
                } else {
                    peptideGridView
                }
            }
            .navigationTitle("Peptide Library")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search peptides..."
            )
        }
    }
    
    // MARK: - Category Filter
    
    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.Spacing.md) {
                // All category
                CategoryChip(
                    title: "All",
                    count: PeptideDatabase.all.count,
                    isSelected: viewModel.selectedCategory == nil,
                    backgroundColor: ColorTokens.backgroundSecondary,
                    accentColor: ColorTokens.brandPrimary
                ) {
                    withAnimation(AnimationTokens.spring) {
                        viewModel.selectCategory(nil)
                    }
                }
                
                // Category chips
                ForEach(PeptideCategory.allCases) { category in
                    if let count = viewModel.categoryCounts[category], count > 0 {
                        CategoryChip(
                            title: category.rawValue,
                            count: count,
                            isSelected: viewModel.selectedCategory == category,
                            backgroundColor: category.backgroundColor,
                            accentColor: category.accentColor
                        ) {
                            withAnimation(AnimationTokens.spring) {
                                viewModel.selectCategory(
                                    viewModel.selectedCategory == category ? nil : category
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, DesignTokens.Layout.screenPadding)
            .padding(.vertical, DesignTokens.Spacing.md)
        }
        .background(ColorTokens.backgroundPrimary)
    }
    
    // MARK: - Peptide Grid
    
    private var peptideGridView: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 160, maximum: 200), spacing: DesignTokens.Spacing.md)
                ],
                spacing: DesignTokens.Spacing.md
            ) {
                ForEach(viewModel.filteredPeptides) { peptide in
                    NavigationLink(destination: PeptideDetailView(peptide: peptide)) {
                        PeptideCardView(peptide: peptide)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(DesignTokens.Layout.screenPadding)
        }
        .background(ColorTokens.backgroundGrouped)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            
            PFEmptyState(
                icon: "magnifyingglass",
                title: "No Peptides Found",
                message: "Try adjusting your search or filter criteria",
                actionTitle: "Clear Search",
                action: {
                    viewModel.clearSearch()
                    viewModel.selectCategory(nil)
                }
            )
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTokens.backgroundGrouped)
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let backgroundColor: Color
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                Text(title)
                    .font(DesignTokens.Typography.labelMedium)
                
                Text("\(count)")
                    .font(DesignTokens.Typography.labelSmall)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(isSelected ? accentColor.opacity(0.2) : ColorTokens.backgroundTertiary)
                    .cornerRadius(8)
            }
            .foregroundColor(isSelected ? accentColor : ColorTokens.foregroundPrimary)
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(isSelected ? backgroundColor : ColorTokens.backgroundSecondary)
            .cornerRadius(DesignTokens.CornerRadius.pill)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.pill)
                    .stroke(isSelected ? accentColor.opacity(0.3) : .clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibilityLabel("\(title) category, \(count) peptides\(isSelected ? ", selected" : "")")
    }
}

// MARK: - Preview
#Preview {
    PeptideLibraryView()
}
