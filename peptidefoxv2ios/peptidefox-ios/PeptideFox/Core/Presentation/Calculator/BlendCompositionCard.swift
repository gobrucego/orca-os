import SwiftUI

struct BlendCompositionCard: View {
    let blend: BlendComposition
    let onUpdate: (Double?, Double?, Double?, Double?) -> Void
    
    @State private var bpc157Value: Double
    @State private var tb500Value: Double
    @State private var ghkCuValue: Double
    @State private var kpvValue: Double
    
    init(blend: BlendComposition, onUpdate: @escaping (Double?, Double?, Double?, Double?) -> Void) {
        self.blend = blend
        self.onUpdate = onUpdate
        _bpc157Value = State(initialValue: blend.bpc157)
        _tb500Value = State(initialValue: blend.tb500)
        _ghkCuValue = State(initialValue: blend.ghkCu)
        _kpvValue = State(initialValue: blend.kpv ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
            // Header
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text("Cocktail Composition")
                    .font(DesignTokens.Typography.headlineSmall)
                    .foregroundColor(ColorTokens.foregroundPrimary)
                
                Text(blend.displayName)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundColor(ColorTokens.foregroundSecondary)
            }
            
            Divider()
            
            // BPC-157 Slider
            peptideSlider(
                name: "BPC-157",
                value: $bpc157Value,
                range: 1.0...10.0,
                step: 0.5,
                onChange: { newValue in
                    onUpdate(newValue, nil, nil, nil)
                }
            )
            
            // TB-500 Slider
            peptideSlider(
                name: "TB-500",
                value: $tb500Value,
                range: 1.0...10.0,
                step: 0.5,
                onChange: { newValue in
                    onUpdate(nil, newValue, nil, nil)
                }
            )
            
            // GHK-Cu Slider
            peptideSlider(
                name: "GHK-Cu",
                value: $ghkCuValue,
                range: 5.0...100.0,
                step: 5.0,
                onChange: { newValue in
                    onUpdate(nil, nil, newValue, nil)
                }
            )
            
            // KPV Slider (KLOW only)
            if blend.type == .klow {
                peptideSlider(
                    name: "KPV",
                    value: $kpvValue,
                    range: 10.0...50.0,
                    step: 5.0,
                    onChange: { newValue in
                        onUpdate(nil, nil, nil, newValue)
                    }
                )
            }
            
            Divider()
            
            // Total mg display
            HStack {
                Text("Total Vial Size")
                    .font(DesignTokens.Typography.labelMedium)
                    .foregroundColor(ColorTokens.foregroundSecondary)
                
                Spacer()
                
                Text(String(format: "%.0f mg", blend.totalMg))
                    .font(DesignTokens.Typography.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTokens.brandPrimary)
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .background(ColorTokens.backgroundPrimary)
        .cornerRadius(DesignTokens.CornerRadius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.lg)
                .stroke(ColorTokens.borderPrimary, lineWidth: 1)
        )
    }
    
    private func peptideSlider(
        name: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double,
        onChange: @escaping (Double) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack {
                Text(name)
                    .font(DesignTokens.Typography.labelMedium)
                    .foregroundColor(ColorTokens.foregroundSecondary)
                
                Spacer()
                
                Text(String(format: "%.1f mg", value.wrappedValue))
                    .font(DesignTokens.Typography.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTokens.foregroundPrimary)
            }
            
            Slider(value: Binding(
                get: { value.wrappedValue },
                set: { newValue in
                    value.wrappedValue = newValue
                    onChange(newValue)
                }
            ), in: range, step: step)
                .tint(ColorTokens.brandPrimary)
        }
    }
}

#Preview {
    BlendCompositionCard(
        blend: BlendComposition.fromVariant(.glow, .variant_10_10_50),
        onUpdate: { _, _, _, _ in }
    )
    .padding()
    .background(ColorTokens.backgroundGrouped)
}
