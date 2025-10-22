import SwiftUI

struct BlendVariantPickerView: View {
    let onSelect: (BlendType) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxl) {
                    // GLOW Section
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("GLOW Blends")
                            .font(DesignTokens.Typography.headlineMedium)
                            .foregroundColor(ColorTokens.foregroundPrimary)
                        
                        // GLOW 5/10/30
                        variantButton(
                            title: "GLOW 5/10/30",
                            subtitle: "BPC-157 5mg • TB-500 10mg • GHK-Cu 30mg",
                            totalMg: 45,
                            blendType: .glow,
                            variant: .variant_5_10_30
                        )
                        
                        // GLOW 10/10/50
                        variantButton(
                            title: "GLOW 10/10/50",
                            subtitle: "BPC-157 10mg • TB-500 10mg • GHK-Cu 50mg",
                            totalMg: 70,
                            blendType: .glow,
                            variant: .variant_10_10_50
                        )
                        
                        // GLOW 10/10/70
                        variantButton(
                            title: "GLOW 10/10/70",
                            subtitle: "BPC-157 10mg • TB-500 10mg • GHK-Cu 70mg",
                            totalMg: 90,
                            blendType: .glow,
                            variant: .variant_10_10_70
                        )
                    }
                    
                    Divider()
                    
                    // KLOW Section
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("KLOW Blends")
                            .font(DesignTokens.Typography.headlineMedium)
                            .foregroundColor(ColorTokens.foregroundPrimary)
                        
                        // KLOW 10/10/10/35
                        variantButton(
                            title: "KLOW 10/10/10/35",
                            subtitle: "BPC-157 10mg • TB-500 10mg • GHK-Cu 10mg • KPV 5mg",
                            totalMg: 35,
                            blendType: .klow,
                            variant: .variant_10_10_10_35
                        )
                        
                        // KLOW 10/10/10/50
                        variantButton(
                            title: "KLOW 10/10/10/50",
                            subtitle: "BPC-157 10mg • TB-500 10mg • GHK-Cu 10mg • KPV 20mg",
                            totalMg: 50,
                            blendType: .klow,
                            variant: .variant_10_10_10_50
                        )
                    }
                    
                    Divider()
                    
                    // Custom Cocktail
                    variantButton(
                        title: "Custom Cocktail",
                        subtitle: "Define your own blend composition",
                        totalMg: nil,
                        blendType: .custom,
                        variant: .custom
                    )
                }
                .padding(DesignTokens.Layout.screenPadding)
            }
            .background(ColorTokens.backgroundGrouped)
            .navigationTitle("Select Blend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func variantButton(
        title: String,
        subtitle: String,
        totalMg: Int?,
        blendType: BlendType,
        variant: BlendVariant
    ) -> some View {
        Button {
            onSelect(blendType)
        } label: {
            HStack(spacing: DesignTokens.Spacing.md) {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(title)
                        .font(DesignTokens.Typography.bodyLarge)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                    
                    Text(subtitle)
                        .font(DesignTokens.Typography.bodySmall)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if let total = totalMg {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(total) mg")
                            .font(DesignTokens.Typography.labelMedium)
                            .foregroundColor(ColorTokens.foregroundPrimary)
                        
                        Text("total")
                            .font(DesignTokens.Typography.caption)
                            .foregroundColor(ColorTokens.foregroundTertiary)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundColor(ColorTokens.foregroundTertiary)
            }
            .padding(DesignTokens.Spacing.md)
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

#Preview {
    BlendVariantPickerView { _ in }
}
