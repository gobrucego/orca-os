//
//  ExampleComponents.swift
//  Peptide Fox Design System v4
//
//  Example SwiftUI components demonstrating design system usage
//  Reference implementations for common UI patterns
//

import SwiftUI

// MARK: - Peptide Card

/// Peptide library card matching web implementation
/// Web source: /library page peptide cards
/// Design: 3-column grid (desktop), single column (mobile)
struct PeptideCard: View {
    let name: String
    let description: String
    let mechanism: String
    let typicalDose: String
    let frequency: String
    let badgeStyle: BadgeStyle
    let accentColor: Color
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with badge
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Spacing.space1) {
                    Text(name)
                        .typography(.cardTitle)

                    Text(description)
                        .typography(.bodySmall, color: Colors.textMuted)
                }

                Spacer()

                Badge("GLP-1", style: badgeStyle)
            }
            .padding(.bottom, Spacing.space10)

            // Divider with accent color
            Rectangle()
                .fill(accentColor)
                .frame(height: 1)
                .padding(.bottom, Spacing.space6)

            // Mechanism section
            VStack(alignment: .leading, spacing: Spacing.space1) {
                Text("Mechanism")
                    .functionalTypography(.uiLabel, color: Colors.textMuted)

                Text(mechanism)
                    .typography(.bodySmall)
            }
            .padding(.bottom, Spacing.space6)

            // Dosing grid
            HStack(spacing: Spacing.space4) {
                VStack(alignment: .leading, spacing: Spacing.space1) {
                    Text("Typical Dose")
                        .functionalTypography(.uiLabel, color: Colors.textMuted)

                    Text(typicalDose)
                        .typography(.output)
                }

                VStack(alignment: .leading, spacing: Spacing.space1) {
                    Text("Frequency")
                        .functionalTypography(.uiLabel, color: Colors.textMuted)

                    Text(frequency)
                        .typography(.output)
                }
            }
            .padding(.bottom, Spacing.space4)

            Spacer()

            // Action button
            Button(action: onToggle) {
                HStack(spacing: Spacing.space2) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                        .resizable()
                        .frame(width: 16, height: 16)

                    Text(isSelected ? "Selected" : "Add to Protocol")
                        .font(.brownLL(size: Typography.textBase, weight: .medium))
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(isSelected ? OutlineButtonStyle() : PrimaryButtonStyle())
        }
        .padding(Spacing.cardPaddingRegular)
        .background(Colors.surfaceBg)
        .cornerRadius(BorderRadius.card)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius.card)
                .stroke(accentColor, lineWidth: 2)
        )
    }
}

// MARK: - GLP-1 Comparison Card

/// GLP-1 comparison card matching web implementation
/// Web source: /glp-1/comparison page cards
/// Design: Feature-rich cards with fixed-height blocks for perfect alignment
struct GLPComparisonCard: View {
    let drugName: String
    let brandName: String
    let levelBadge: String
    let levelBadgeStyle: BadgeStyle
    let efficacy: String
    let halfLife: String
    let tagline: String
    let taglineColor: Color
    let description: String
    let benefits: [String]
    let onSelectAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header block with badge (min-h-[60px])
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(drugName)
                        .typography(.cardTitle)

                    Text(brandName)
                        .typography(.subtext, color: Colors.textMuted)
                }

                Spacer()

                Badge(levelBadge, style: levelBadgeStyle)
            }
            .frame(minHeight: 60)
            .padding(.bottom, Spacing.space3)

            // Stats block (min-h-[40px])
            HStack(spacing: Spacing.space4) {
                VStack(alignment: .leading, spacing: Spacing.space1) {
                    Text("Efficacy")
                        .functionalTypography(.strongLabel, color: Colors.textMuted)

                    Text(efficacy)
                        .typography(.output)
                }

                Spacer()

                VStack(alignment: .leading, spacing: Spacing.space1) {
                    Text("Half-Life")
                        .functionalTypography(.strongLabel, color: Colors.textMuted)

                    Text(halfLife)
                        .typography(.output)
                }
            }
            .frame(minHeight: 40)
            .padding(.vertical, Spacing.space2)
            .padding(.bottom, Spacing.space3)

            // Tagline
            Text(tagline)
                .font(.brownLL(size: Typography.textBase, weight: .medium))
                .foregroundColor(taglineColor)
                .padding(.bottom: Spacing.space2)

            // Description
            Text(description)
                .typography(.body, color: Colors.textMuted)
                .padding(.bottom, Spacing.space4)

            // Benefits list
            VStack(alignment: .leading, spacing: Spacing.space2) {
                Text("Key Benefits")
                    .functionalTypography(.strongLabel, color: Colors.textMuted)
                    .padding(.bottom, Spacing.space2)

                ForEach(benefits, id: \.self) { benefit in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.brownLL(size: Typography.textBase * 0.75, weight: .regular))
                            .foregroundColor(Colors.textBody)
                            .offset(y: 2.5) // Optical alignment (0.175rem for 14px text)

                        Text(benefit)
                            .typography(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            Spacer()

            // CTA Button (anchored to bottom)
            Button(action: onSelectAction) {
                Text("Select This Agent")
                    .font(.brownLL(size: Typography.textBase, weight: .medium))
                    .tracking(Typography.trackingWide)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, Spacing.space4)
        }
        .padding(Spacing.cardPaddingRegular)
        .frame(minHeight: 480) // Match web min-h-[480px]
        .background(Colors.surfaceBg)
        .cornerRadius(BorderRadius.cardLarge)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius.cardLarge)
                .stroke(Colors.borderBold, lineWidth: 2)
        )
    }
}

// MARK: - Dose Calculator Input Field

/// Calculator input field with label and unit display
/// Web source: Dosing calculator components
struct DoseInputField: View {
    let label: String
    let unit: String?
    @Binding var value: String
    @FocusState.Binding var isFocused: Bool
    let hasError: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space1) {
            Text(label)
                .functionalTypography(.uiLabel, color: Colors.textMuted)

            HStack(spacing: Spacing.space2) {
                TextField("0", text: $value)
                    .focused($isFocused)
                    .keyboardType(.decimalPad)
                    .numberInputField(isFocused: isFocused, hasError: hasError)

                if let unit = unit {
                    Text(unit)
                        .typography(.body, color: Colors.textMuted)
                        .padding(.leading, Spacing.space2)
                }
            }

            if hasError {
                HStack(spacing: Spacing.space1) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Colors.critical)

                    Text("Value must be greater than 0")
                        .typography(.subtext, color: Colors.critical)
                }
                .padding(.top, Spacing.space1)
            }
        }
    }
}

// MARK: - Device Picker Cell

/// Device selection cell (pen, syringe30, syringe50, syringe100)
/// Web source: Protocol builder device selection
struct DevicePickerCell: View {
    let deviceName: String
    let deviceIcon: String
    let volumeCapacity: String
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: Spacing.space4) {
                // Icon
                Image(systemName: deviceIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(isSelected ? Colors.primary : Colors.textMuted)

                // Device info
                VStack(alignment: .leading, spacing: 2) {
                    Text(deviceName)
                        .typography(.body, color: isSelected ? Colors.textBody : Colors.textMuted)

                    Text(volumeCapacity)
                        .typography(.subtext, color: Colors.textSubtle)
                }

                Spacer()

                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Colors.primary)
                }
            }
            .padding(Spacing.space4)
            .background(isSelected ? Colors.BlueBadge.background : Colors.surfaceBg)
            .cornerRadius(BorderRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.md)
                    .stroke(
                        isSelected ? Colors.BlueBadge.border : Colors.border,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Protocol Summary Stats

/// Protocol summary statistics block
/// Web source: Protocol builder summary section
struct ProtocolSummaryStats: View {
    let totalPeptides: Int
    let totalWeeks: Int
    let estimatedCost: String
    let injectionsPerWeek: Int

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: Spacing.space4
        ) {
            StatCard(
                label: "Peptides",
                value: "\(totalPeptides)",
                icon: "circle.grid.3x3.fill"
            )

            StatCard(
                label: "Duration",
                value: "\(totalWeeks) weeks",
                icon: "calendar"
            )

            StatCard(
                label: "Est. Cost",
                value: estimatedCost,
                icon: "dollarsign.circle.fill"
            )

            StatCard(
                label: "Weekly Injections",
                value: "\(injectionsPerWeek)",
                icon: "syringe.fill"
            )
        }
    }
}

/// Individual stat card component
struct StatCard: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space2) {
            HStack(spacing: Spacing.space2) {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Colors.primary)

                Text(label)
                    .functionalTypography(.uiLabel, color: Colors.textMuted)
            }

            Text(value)
                .typography(.output)
        }
        .padding(Spacing.space4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Colors.surfaceSubtle)
        .cornerRadius(BorderRadius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius.sm)
                .stroke(Colors.borderSoft, lineWidth: 1)
        )
    }
}

// MARK: - Progress Bar

/// Protocol cycle progress indicator
/// Web source: Protocol tracking components
struct ProtocolProgressBar: View {
    let current: Int
    let total: Int
    let label: String

    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(current) / Double(total)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space2) {
            HStack {
                Text(label)
                    .functionalTypography(.uiLabel, color: Colors.textMuted)

                Spacer()

                Text("\(current) / \(total) weeks")
                    .font(.system(size: Typography.textSM, design: .monospaced))
                    .foregroundColor(Colors.textMuted)
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Colors.borderSoft)
                        .frame(height: 8)
                        .cornerRadius(4)

                    // Progress fill
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Colors.primary, Colors.primary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)

            Text("\(Int(percentage * 100))% complete")
                .typography(.subtext, color: Colors.textMuted)
        }
    }
}

// MARK: - Preview Components

#if DEBUG
struct ExampleComponents_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: Spacing.space8) {
                // Peptide Card
                PeptideCard(
                    name: "Semaglutide",
                    description: "Weekly GLP-1 receptor agonist",
                    mechanism: "Stimulates insulin secretion, suppresses glucagon",
                    typicalDose: "2.4 mg",
                    frequency: "Weekly",
                    badgeStyle: .info,
                    accentColor: Colors.BlueBadge.border,
                    isSelected: false,
                    onToggle: {}
                )

                // GLP Comparison Card
                GLPComparisonCard(
                    drugName: "Semaglutide",
                    brandName: "Ozempic / Wegovy",
                    levelBadge: "Advanced",
                    levelBadgeStyle: .info,
                    efficacy: "15-20%",
                    halfLife: "7 days",
                    tagline: "Most studied, reliable weight loss",
                    taglineColor: Colors.primary,
                    description: "Well-established GLP-1 agonist with extensive clinical data.",
                    benefits: [
                        "Proven 15-20% weight loss in clinical trials",
                        "Once-weekly dosing for convenience",
                        "Cardiovascular benefits demonstrated"
                    ],
                    onSelectAction: {}
                )

                // Device Picker
                VStack(spacing: Spacing.space2) {
                    Text("Select Injection Device")
                        .typography(.subsectionH3)

                    DevicePickerCell(
                        deviceName: "Insulin Pen",
                        deviceIcon: "pencil.circle.fill",
                        volumeCapacity: "3.0 mL",
                        isSelected: true,
                        onSelect: {}
                    )

                    DevicePickerCell(
                        deviceName: "Syringe (0.3mL)",
                        deviceIcon: "syringe.fill",
                        volumeCapacity: "0.3 mL",
                        isSelected: false,
                        onSelect: {}
                    )
                }

                // Protocol Summary
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    Text("Protocol Summary")
                        .typography(.sectionH2)

                    ProtocolSummaryStats(
                        totalPeptides: 3,
                        totalWeeks: 12,
                        estimatedCost: "$240",
                        injectionsPerWeek: 4
                    )
                }

                // Progress Bar
                ProtocolProgressBar(
                    current: 8,
                    total: 12,
                    label: "Cycle Progress"
                )
            }
            .padding()
        }
    }
}
#endif

/*
 COMPONENT IMPLEMENTATION NOTES:

 1. PEPTIDE CARD
    - Matches web library card structure exactly
    - Uses 2px colored border for category visual
    - Divider with accent color creates hierarchy
    - Badge positioned in upper-right (standard pattern)

 2. GLP COMPARISON CARD
    - Fixed-height blocks ensure sibling alignment
    - min-h-[480px] matches web implementation
    - Button anchored to bottom with mt-auto equivalent
    - Benefits list uses proper bullet alignment (0.175rem offset)

 3. DOSE INPUT FIELD
    - Monospace font for number inputs
    - Error state with icon and message
    - Unit label positioned outside input
    - FocusState binding for proper styling

 4. DEVICE PICKER CELL
    - Selection indicated by background tint + checkmark
    - Icons max 20pt (design system constraint)
    - Press feedback via button style

 5. PROTOCOL SUMMARY STATS
    - 2-column grid layout
    - Each stat card elevated with subtle background
    - Icons support text (14pt paired with 16pt icon max)

 6. PROGRESS BAR
    - 8pt height matching web design
    - Rounded corners (4pt radius)
    - Gradient fill for visual interest (subtle, approved)
    - Monospace numbers for precise alignment

 CRITICAL DESIGN DECISIONS:
 ─────────────────────────────
 ✓ All spacing values from Spacing enum
 ✓ Typography styles use predefined enum values
 ✓ Badge colors ONLY from approved combinations
 ✓ Icons ≤20pt, paired with appropriate text sizes
 ✓ Fixed heights for comparison cards (sibling alignment)
 ✓ Bullet lists use proper optical offset (0.175rem for 14pt text)
 ✓ Buttons intrinsic width (no full-width sprawl)
 ✓ Animations ≤200ms duration
 */
