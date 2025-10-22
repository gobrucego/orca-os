import SwiftUI

struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()
    @State private var showCompoundPicker = false
    @State private var isOutputExpanded = false

    private var displayName: String {
        if let compound = viewModel.selectedCompound {
            return compound.name
        } else if let blend = viewModel.selectedBlend {
            return blend.displayName
        } else {
            return "Select Compound (Optional)"
        }
    }

    private var hasSelection: Bool {
        viewModel.selectedCompound != nil || viewModel.selectedBlend != nil
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Main scrollable content
                ScrollView {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sectionSpacing) {
                        // Header
                        headerView

                        // Compound Selection (Optional)
                        compoundSelectionView

                        // Blend Composition (only shown in blend mode)
                        // Temporarily commented out due to missing BlendCompositionCard component
                        // if viewModel.isBlendMode, let blend = viewModel.selectedBlend {
                        //     BlendCompositionCard(blend: blend) { bpc, tb, ghk, kpv in
                        //         viewModel.updateBlendComposition(bpc157: bpc, tb500: tb, ghkCu: ghk, kpv: kpv)
                        //     }
                        // }

                        // Input Form (ALWAYS shown - calculator-only mode enabled)
                        inputFormView

                        // Calculate Button
                        if viewModel.canCalculate {
                            calculateButtonView
                        }

                        // Error
                        if let error = viewModel.error {
                            errorView(error: error)
                        }

                        // Spacer to prevent content from being hidden by floating card
                        if viewModel.hasCalculated {
                            Spacer()
                                .frame(height: isOutputExpanded ? 400 : 160)
                        }
                    }
                    .padding(DesignTokens.Layout.screenPadding)
                }
                .background(ColorTokens.backgroundGrouped)

                // Floating BAC Water Output Card (always visible when calculated)
                if viewModel.hasCalculated {
                    BACWaterOutputCard(
                        bacWater: viewModel.bacWater,
                        desiredDose: viewModel.desiredDose,
                        concentration: viewModel.concentration,
                        vialSize: viewModel.vialSize,
                        isExpanded: $isOutputExpanded
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        withAnimation(AnimationTokens.spring) {
                            viewModel.reset()
                            isOutputExpanded = false
                        }
                    }
                    .font(DesignTokens.Typography.labelMedium)
                }
            }
            .sheet(isPresented: $showCompoundPicker) {
                CompoundPickerView(
                    selectedCompound: $viewModel.selectedCompound,
                    onSelect: { compound in
                        viewModel.selectCompound(compound)
                        showCompoundPicker = false
                    },
                    onSelectBlend: { blendType in
                        viewModel.selectBlend(blendType)
                        showCompoundPicker = false
                    }
                )
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: "function")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(ColorTokens.brandPrimary)

            Text("Reconstitution Calculator")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(ColorTokens.foregroundPrimary)

            Spacer()
        }
        .padding(.bottom, DesignTokens.Spacing.sm)
    }
    
    // MARK: - Compound Selection

    private var compoundSelectionView: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Compound")
                .font(DesignTokens.Typography.labelMedium)
                .foregroundColor(ColorTokens.foregroundSecondary)

            Button {
                print("🔍 DEBUG: Select Compound button tapped")
                print("🔍 DEBUG: showCompoundPicker before: \(showCompoundPicker)")
                showCompoundPicker = true
                print("🔍 DEBUG: showCompoundPicker after: \(showCompoundPicker)")
            } label: {
                HStack {
                    Text(displayName)
                        .font(DesignTokens.Typography.bodyLarge)
                        .foregroundColor(hasSelection ? ColorTokens.foregroundPrimary : ColorTokens.foregroundSecondary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(DesignTokens.Typography.caption)
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
            .accessibilityLabel("Select compound")
        }
    }

    // MARK: - Input Form

    private var inputFormView: some View {
        VStack(spacing: DesignTokens.Spacing.xxl) {
            // Vial Size - Clean minimal input (auto-calculated in blend mode)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                HStack {
                    Text("VIAL SIZE")
                        .font(DesignTokens.InputTypography.label)
                        .foregroundColor(ColorTokens.foregroundTertiary)
                        .tracking(0.5)

                    if viewModel.isBlendMode {
                        Text("(auto-calculated)")
                            .font(DesignTokens.Typography.caption)
                            .foregroundColor(ColorTokens.foregroundTertiary)
                    }
                }

                HStack(alignment: .firstTextBaseline, spacing: DesignTokens.Spacing.sm) {
                    if viewModel.isBlendMode {
                        Text(String(format: "%.0f", viewModel.vialSize))
                            .font(DesignTokens.InputTypography.numeric)
                            .foregroundColor(ColorTokens.foregroundSecondary)
                            .padding(.vertical, DesignTokens.Spacing.sm)
                    } else {
                        TextField("10", value: $viewModel.vialSize, format: .number)
                            .keyboardType(.decimalPad)
                            .font(DesignTokens.InputTypography.numeric)
                            .foregroundColor(ColorTokens.foregroundPrimary)
                            .textFieldStyle(.plain)
                            .padding(.vertical, DesignTokens.Spacing.sm)
                            .frame(maxWidth: 120)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(ColorTokens.borderPrimary),
                                alignment: .bottom
                            )
                    }

                    Text("mg")
                        .font(DesignTokens.Typography.bodyMedium)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                }
            }
            .accessibilityLabel("Vial size in milligrams")

            // Desired Concentration - Clean minimal input
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text("CONCENTRATION")
                    .font(DesignTokens.InputTypography.label)
                    .foregroundColor(ColorTokens.foregroundTertiary)
                    .tracking(0.5)

                HStack(alignment: .firstTextBaseline, spacing: DesignTokens.Spacing.sm) {
                    TextField("5.0", value: $viewModel.concentration, format: .number)
                        .keyboardType(.decimalPad)
                        .font(DesignTokens.InputTypography.numeric)
                        .foregroundColor(ColorTokens.foregroundPrimary)
                        .textFieldStyle(.plain)
                        .padding(.vertical, DesignTokens.Spacing.sm)
                        .frame(maxWidth: 120)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(ColorTokens.borderPrimary),
                            alignment: .bottom
                        )

                    Text("mg/ml")
                        .font(DesignTokens.Typography.bodyMedium)
                        .foregroundColor(ColorTokens.foregroundSecondary)
                }
            }
            .accessibilityLabel("Desired concentration in milligrams per milliliter")
        }
    }
    
    // MARK: - Calculate Button

    private var calculateButtonView: some View {
        Button {
            viewModel.calculateBacWater()
        } label: {
            Text("Calculate")
                .font(DesignTokens.Typography.labelLarge)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(DesignTokens.Spacing.md)
                .background(ColorTokens.brandPrimary)
                .cornerRadius(DesignTokens.CornerRadius.md)
        }
        .disabled(!viewModel.canCalculate)
        .opacity(viewModel.canCalculate ? 1.0 : 0.5)
        .accessibilityLabel("Calculate bacteriostatic water amount")
    }

    
    // MARK: - Error View

    private func errorView(error: String) -> some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(ColorTokens.error)
                .font(.system(size: 20))

            Text(error)
                .font(DesignTokens.Typography.bodyMedium)
                .foregroundColor(ColorTokens.foregroundPrimary)

            Spacer()
        }
        .padding(DesignTokens.Spacing.md)
        .background(ColorTokens.error.opacity(0.1))
        .cornerRadius(DesignTokens.CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                .stroke(ColorTokens.error.opacity(0.3), lineWidth: 1)
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

// MARK: - BAC Water Output Card

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
#Preview {
    CalculatorView()
}
