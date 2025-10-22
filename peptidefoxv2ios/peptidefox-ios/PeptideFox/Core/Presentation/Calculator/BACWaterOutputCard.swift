import SwiftUI

/// Floating card that shows BAC water calculation
/// Collapsed: Shows BAC water amount only (hero typography)
/// Expanded: Shows BAC water + injection info (pull-up gesture)
/// Always visible at bottom of screen, floats above scrollable content
struct BACWaterOutputCard: View {
    let bacWater: Double
    let desiredDose: Double
    let concentration: Double
    let vialSize: Double

    @Binding var isExpanded: Bool
    @State private var dragOffset: CGFloat = 0

    // Computed properties for injection info
    private var injectionVolume: Double {
        guard concentration > 0 else { return 0 }
        return desiredDose / concentration
    }

    private var dosesPerVial: Double {
        guard desiredDose > 0, vialSize > 0 else { return 0 }
        return vialSize / desiredDose
    }

    private var injectionUnits: Double {
        injectionVolume * 100 // Convert mL to units (assuming 100u syringe)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Drag handle indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(ColorTokens.foregroundTertiary.opacity(0.3))
                .frame(width: 36, height: 5)
                .padding(.top, DesignTokens.Spacing.sm)

            if isExpanded {
                expandedContent
            } else {
                collapsedContent
            }
        }
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xl)
                .fill(ColorTokens.backgroundTertiary) // Elevated background
                .shadow(color: .black.opacity(0.15), radius: 20, y: -5)
        )
        .offset(y: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Only allow dragging within reasonable bounds
                    let translation = value.translation.height
                    if (isExpanded && translation > 0) || (!isExpanded && translation < 0) {
                        dragOffset = translation
                    }
                }
                .onEnded { value in
                    let translation = value.translation.height
                    let velocity = value.predictedEndTranslation.height

                    // Determine if user wants to expand or collapse
                    if isExpanded {
                        // Currently expanded - check if user wants to collapse
                        if translation > 50 || velocity > 500 {
                            withAnimation(AnimationTokens.spring) {
                                isExpanded = false
                            }
                        }
                    } else {
                        // Currently collapsed - check if user wants to expand
                        if translation < -50 || velocity < -500 {
                            withAnimation(AnimationTokens.spring) {
                                isExpanded = true
                            }
                        }
                    }

                    // Reset drag offset with animation
                    withAnimation(AnimationTokens.spring) {
                        dragOffset = 0
                    }
                }
        )
        .animation(AnimationTokens.spring, value: isExpanded)
    }

    // MARK: - Collapsed Content (BAC Water Only)

    private var collapsedContent: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Label
            Text("BAC WATER")
                .font(DesignTokens.Typography.labelSmall)
                .foregroundColor(ColorTokens.foregroundSecondary)
                .tracking(1.0)

            // Hero number - 72pt light
            HStack(alignment: .firstTextBaseline, spacing: DesignTokens.Spacing.sm) {
                Text(String(format: "%.1f", bacWater))
                    .font(DesignTokens.OutputDisplay.hero)
                    .foregroundColor(ColorTokens.brandPrimary)

                Text("mL")
                    .font(DesignTokens.Typography.labelLarge)
                    .foregroundColor(ColorTokens.foregroundSecondary)
            }

            // Hint to expand
            HStack(spacing: DesignTokens.Spacing.xs) {
                Image(systemName: "chevron.up")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(ColorTokens.foregroundTertiary)

                Text("Swipe up to see injection info")
                    .font(DesignTokens.Typography.caption)
                    .foregroundColor(ColorTokens.foregroundTertiary)
            }
            .padding(.bottom, DesignTokens.Spacing.sm)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, DesignTokens.Spacing.xxl)
        .padding(.vertical, DesignTokens.Spacing.xl)
    }

    // MARK: - Expanded Content (BAC Water + Injection Info)

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxl) {
            // BAC Water (collapsed to header when expanded)
            HStack {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("BAC WATER")
                        .font(DesignTokens.Typography.labelSmall)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                        .tracking(1.0)

                    HStack(alignment: .firstTextBaseline, spacing: DesignTokens.Spacing.xs) {
                        Text(String(format: "%.1f", bacWater))
                            .font(DesignTokens.OutputDisplay.standard) // Smaller when expanded (36pt)
                            .foregroundColor(ColorTokens.brandPrimary)

                        Text("mL")
                            .font(DesignTokens.Typography.bodyMedium)
                            .foregroundColor(ColorTokens.foregroundSecondary)
                    }
                }

                Spacer()

                // Collapse button
                Button {
                    withAnimation(AnimationTokens.spring) {
                        isExpanded = false
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorTokens.foregroundSecondary)
                        .frame(width: 32, height: 32)
                        .background(ColorTokens.backgroundPrimary)
                        .cornerRadius(DesignTokens.CornerRadius.sm)
                }
            }

            Divider()

            // Injection Info Section
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("INJECTION INFO")
                    .font(DesignTokens.Typography.labelSmall)
                    .foregroundColor(ColorTokens.foregroundSecondary)
                    .tracking(1.0)

                // Three metric cards in equal height (based on inspiration)
                VStack(spacing: DesignTokens.Spacing.md) {
                    // Card 1: Draw Volume
                    metricCard(
                        label: "Draw volume",
                        value: String(format: "%.3f", injectionVolume),
                        unit: "mL"
                    )

                    // Card 2: Doses per Vial
                    metricCard(
                        label: "Doses per vial",
                        value: String(format: "%.1f", dosesPerVial),
                        unit: "doses"
                    )

                    // Card 3: Units (100u syringe)
                    metricCard(
                        label: "Units (100u syringe)",
                        value: String(format: "%.1f", injectionUnits),
                        unit: "units"
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignTokens.Spacing.xxl)
    }

    // MARK: - Metric Card Component

    @ViewBuilder
    private func metricCard(label: String, value: String, unit: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(label)
                    .font(DesignTokens.Typography.bodySmall)
                    .foregroundColor(ColorTokens.foregroundSecondary)

                HStack(alignment: .firstTextBaseline, spacing: DesignTokens.Spacing.xs) {
                    Text(value)
                        .font(DesignTokens.Typography.headlineLarge)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorTokens.foregroundPrimary)

                    Text(unit)
                        .font(DesignTokens.Typography.bodySmall)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                }
            }

            Spacer()
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity)
        .frame(height: 72) // Equal height for all cards (visual rhythm)
        .background(ColorTokens.backgroundPrimary)
        .cornerRadius(DesignTokens.CornerRadius.md)
    }
}

// MARK: - Preview

#Preview("Collapsed") {
    VStack {
        Spacer()

        BACWaterOutputCard(
            bacWater: 2.0,
            desiredDose: 0.5,
            concentration: 5.0,
            vialSize: 10.0,
            isExpanded: .constant(false)
        )
    }
    .ignoresSafeArea()
}

#Preview("Expanded") {
    VStack {
        Spacer()

        BACWaterOutputCard(
            bacWater: 2.0,
            desiredDose: 0.5,
            concentration: 5.0,
            vialSize: 10.0,
            isExpanded: .constant(true)
        )
    }
    .ignoresSafeArea()
}
