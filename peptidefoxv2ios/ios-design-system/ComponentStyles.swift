//
//  ComponentStyles.swift
//  Peptide Fox Design System v4
//
//  SwiftUI component styles and view modifiers
//  Translates web design patterns to native iOS components
//

import SwiftUI

// MARK: - Card Styles

/// Standard card modifier matching web `.ds-card`
/// Web: `bg-white border-2 border-slate-400 rounded-[12px] p-7`
struct CardModifier: ViewModifier {
    let padding: CGFloat
    let borderWidth: CGFloat

    init(padding: CGFloat = Spacing.cardPaddingRegular, borderWidth: CGFloat = 2) {
        self.padding = padding
        self.borderWidth = borderWidth
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Colors.surfaceBg)
            .cornerRadius(BorderRadius.card)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.card)
                    .stroke(Colors.borderBold, lineWidth: borderWidth)
            )
    }
}

/// Elevated card with shadow (`.ds-surface-elevated`)
/// Web: Card with official shadow token
struct ElevatedCardModifier: ViewModifier {
    let padding: CGFloat

    init(padding: CGFloat = Spacing.cardPaddingRegular) {
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Colors.surfaceBg)
            .cornerRadius(BorderRadius.card)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.card)
                    .stroke(Colors.borderSoft, lineWidth: 1)
            )
            .shadow(
                color: Shadows.card,
                radius: Shadows.cardRadius,
                x: Shadows.cardOffset.width,
                y: Shadows.cardOffset.height
            )
    }
}

/// Tinted card with colored background (`.ds-surface-tinted`)
/// Web: `bg-blue-50 border-blue-300`
struct TintedCardModifier: ViewModifier {
    let backgroundColor: Color
    let borderColor: Color
    let padding: CGFloat

    init(
        backgroundColor: Color = Colors.BlueBadge.background,
        borderColor: Color = Colors.BlueBadge.border,
        padding: CGFloat = Spacing.cardPaddingRegular
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(BorderRadius.card)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.card)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

// MARK: - Badge Styles

/// Badge style enum matching approved web badge combinations
/// Web: `.ds-badge--info`, `.ds-badge--featured`, etc.
enum BadgeStyle {
    case info       // Blue
    case featured   // Teal
    case alert      // Red
    case neutral    // Slate
    case purple     // Purple
    case emerald    // Green/Success
    case amber      // Warning

    var colors: (background: Color, border: Color, text: Color) {
        switch self {
        case .info:
            return (Colors.BlueBadge.background, Colors.BlueBadge.border, Colors.BlueBadge.text)
        case .featured:
            return (Colors.TealBadge.background, Colors.TealBadge.border, Colors.TealBadge.text)
        case .alert:
            return (Colors.RedBadge.background, Colors.RedBadge.border, Colors.RedBadge.text)
        case .neutral:
            return (Colors.SlateBadge.background, Colors.SlateBadge.border, Colors.SlateBadge.text)
        case .purple:
            return (Colors.PurpleBadge.background, Colors.PurpleBadge.border, Colors.PurpleBadge.text)
        case .emerald:
            return (Colors.EmeraldBadge.background, Colors.EmeraldBadge.border, Colors.EmeraldBadge.text)
        case .amber:
            return (Colors.AmberBadge.background, Colors.AmberBadge.border, Colors.AmberBadge.text)
        }
    }
}

/// Badge view matching web pill pattern
/// Web: `.ds-badge` - `inline-flex px-2.5 py-1 rounded-full border`
struct Badge: View {
    let text: String
    let style: BadgeStyle
    let icon: Image?

    init(_ text: String, style: BadgeStyle = .neutral, icon: Image? = nil) {
        self.text = text
        self.style = style
        self.icon = icon
    }

    var body: some View {
        HStack(spacing: Spacing.space1) {
            if let icon = icon {
                icon
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(style.colors.text)
            }

            Text(text)
                .functionalTypography(.badge, color: style.colors.text)
        }
        .padding(.horizontal, 10) // px-2.5 = 10pt
        .padding(.vertical, 4)    // py-1 = 4pt
        .background(style.colors.background)
        .cornerRadius(BorderRadius.pill)
        .overlay(
            Capsule()
                .stroke(style.colors.border, lineWidth: 1)
        )
    }
}

// MARK: - Button Styles

/// Primary button style
/// Web: `.ds-button-primary` - `bg-primary text-inverse`
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.brownLL(size: Typography.textBase, weight: .medium))
            .foregroundColor(Colors.textInverse)
            .padding(.horizontal, Spacing.space6)
            .padding(.vertical, Spacing.space3)
            .background(configuration.isPressed ? Colors.primaryHover : Colors.primary)
            .cornerRadius(BorderRadius.md)
            .animation(Animation.easingCurve, value: configuration.isPressed)
    }
}

/// Outline button style
/// Web: `.ds-button-outline` - `border bg-surface text-body`
struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.brownLL(size: Typography.textBase, weight: .medium))
            .foregroundColor(Colors.textBody)
            .padding(.horizontal, Spacing.space6)
            .padding(.vertical, Spacing.space3)
            .background(configuration.isPressed ? Colors.surfaceSubtle : Colors.surfaceBg)
            .cornerRadius(BorderRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.md)
                    .stroke(
                        configuration.isPressed ? Colors.borderBold : Colors.border,
                        lineWidth: 1
                    )
            )
            .animation(Animation.easingCurve, value: configuration.isPressed)
    }
}

// MARK: - Input Field Styles

/// Standard text field style
/// Web: `.ds-input` - `border-2 border-slate-300 rounded-[10px] py-3 px-4`
struct InputFieldModifier: ViewModifier {
    let isFocused: Bool
    let hasError: Bool

    func body(content: Content) -> some View {
        content
            .font(.brownLL(size: Typography.textBase, weight: .medium))
            .foregroundColor(Colors.textBody)
            .padding(.horizontal, Spacing.space4)
            .padding(.vertical, Spacing.space3)
            .background(Colors.surfaceBg)
            .cornerRadius(BorderRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.md)
                    .stroke(borderColor, lineWidth: 2)
            )
    }

    private var borderColor: Color {
        if hasError {
            return Colors.critical
        } else if isFocused {
            return Colors.primary
        } else {
            return Colors.border
        }
    }
}

/// Number input field style (uses monospace)
/// Web: `.ds-input-number` - Similar to input but with mono font
struct NumberInputFieldModifier: ViewModifier {
    let isFocused: Bool
    let hasError: Bool

    func body(content: Content) -> some View {
        content
            .font(.system(size: Typography.textBase, weight: .medium, design: .monospaced))
            .foregroundColor(Colors.textBody)
            .padding(.horizontal, Spacing.space4)
            .padding(.vertical, Spacing.space3)
            .background(Colors.surfaceBg)
            .cornerRadius(BorderRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.md)
                    .stroke(borderColor, lineWidth: 2)
            )
    }

    private var borderColor: Color {
        if hasError {
            return Colors.critical
        } else if isFocused {
            return Colors.primary
        } else {
            return Colors.border
        }
    }
}

// MARK: - Chip/Pill Styles

/// Chip component (smaller than badge, used for tags)
/// Web: `.ds-chip` - Similar to badge but slightly different sizing
struct Chip: View {
    let text: String
    let onTap: (() -> Void)?

    init(_ text: String, onTap: (() -> Void)? = nil) {
        self.text = text
        self.onTap = onTap
    }

    var body: some View {
        Button(action: { onTap?() }) {
            Text(text)
                .functionalTypography(.uiLabel, color: Colors.textMuted)
                .padding(.horizontal, 14) // 0.9rem ≈ 14pt
                .padding(.vertical, 6)    // 0.4rem ≈ 6pt
                .background(Colors.surfaceBg)
                .cornerRadius(BorderRadius.pill)
                .overlay(
                    Capsule()
                        .stroke(Colors.border, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(onTap == nil)
    }
}

// MARK: - Divider Styles

/// Standard divider matching web design system
/// Web: `.ds-divider` - `h-px bg-slate-400/70`
struct DividerModifier: ViewModifier {
    let color: Color
    let opacity: Double

    init(color: Color = Colors.borderBold, opacity: Double = 0.7) {
        self.color = color
        self.opacity = opacity
    }

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            Rectangle()
                .fill(color.opacity(opacity))
                .frame(height: 1)
        }
    }
}

// MARK: - Hover/Press Effects

/// Hover lift effect (press scales down slightly)
/// Web: `.ds-hover-lift` - `transform: scale(1.02)` on hover
struct PressEffectModifier: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(Animation.easingCurve, value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

/// Subtle elevation on hover (adds shadow)
/// Web: `.ds-hover-glow` - Adds shadow on hover
struct HoverElevationModifier: ViewModifier {
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .shadow(
                color: isHovered ? Shadows.hover : Shadows.card,
                radius: isHovered ? Shadows.hoverRadius : Shadows.cardRadius,
                x: isHovered ? Shadows.hoverOffset.width : Shadows.cardOffset.width,
                y: isHovered ? Shadows.hoverOffset.height : Shadows.cardOffset.height
            )
            .animation(Animation.easingCurve, value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

// MARK: - Grid Layout Helpers

/// Standard 2-column grid layout
/// Web: `.ds-grid-2` - `grid-cols-2 gap-6`
struct TwoColumnGrid<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Spacing.gridGap),
                GridItem(.flexible(), spacing: Spacing.gridGap)
            ],
            spacing: Spacing.gridGap
        ) {
            content
        }
    }
}

/// Standard 3-column grid layout
/// Web: `.ds-grid-3` - `grid-cols-3 gap-6`
struct ThreeColumnGrid<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Spacing.gridGap),
                GridItem(.flexible(), spacing: Spacing.gridGap),
                GridItem(.flexible(), spacing: Spacing.gridGap)
            ],
            spacing: Spacing.gridGap
        ) {
            content
        }
    }
}

// MARK: - View Extensions

extension View {
    /// Apply standard card styling
    func card(padding: CGFloat = Spacing.cardPaddingRegular) -> some View {
        modifier(CardModifier(padding: padding))
    }

    /// Apply elevated card with shadow
    func elevatedCard(padding: CGFloat = Spacing.cardPaddingRegular) -> some View {
        modifier(ElevatedCardModifier(padding: padding))
    }

    /// Apply tinted card background
    func tintedCard(
        backgroundColor: Color = Colors.BlueBadge.background,
        borderColor: Color = Colors.BlueBadge.border
    ) -> some View {
        modifier(TintedCardModifier(
            backgroundColor: backgroundColor,
            borderColor: borderColor
        ))
    }

    /// Apply input field styling
    func inputField(isFocused: Bool = false, hasError: Bool = false) -> some View {
        modifier(InputFieldModifier(isFocused: isFocused, hasError: hasError))
    }

    /// Apply number input field styling
    func numberInputField(isFocused: Bool = false, hasError: Bool = false) -> some View {
        modifier(NumberInputFieldModifier(isFocused: isFocused, hasError: hasError))
    }

    /// Apply divider below content
    func divider(color: Color = Colors.borderBold, opacity: Double = 0.7) -> some View {
        modifier(DividerModifier(color: color, opacity: opacity))
    }

    /// Apply press effect (scales down on press)
    func pressEffect() -> some View {
        modifier(PressEffectModifier())
    }

    /// Apply hover elevation (macOS/iPadOS pointer)
    func hoverElevation() -> some View {
        modifier(HoverElevationModifier())
    }

    /// Apply optical offset for text next to rounded elements
    /// Web: `pl-1` for +4px optical alignment
    func opticalOffset() -> some View {
        self.padding(.leading, Spacing.opticalOffset)
    }
}

// MARK: - Usage Examples & Preview Components

#if DEBUG
struct ComponentStyles_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: Spacing.space8) {
                // Cards
                Group {
                    Text("Standard Card")
                        .typography(.cardTitle)
                        .card()

                    Text("Elevated Card with Shadow")
                        .typography(.body)
                        .elevatedCard()

                    Text("Tinted Card (Blue)")
                        .typography(.body, color: Colors.BlueBadge.text)
                        .tintedCard()
                }

                // Badges
                HStack(spacing: Spacing.space2) {
                    Badge("Info", style: .info)
                    Badge("Featured", style: .featured)
                    Badge("Alert", style: .alert)
                    Badge("Neutral", style: .neutral)
                }

                // Buttons
                VStack(spacing: Spacing.space2) {
                    Button("Primary Action") {}
                        .buttonStyle(PrimaryButtonStyle())

                    Button("Secondary Action") {}
                        .buttonStyle(OutlineButtonStyle())
                }

                // Input Fields
                VStack(spacing: Spacing.space2) {
                    Text("Email")
                        .functionalTypography(.uiLabel)
                    TextField("Enter email", text: .constant(""))
                        .inputField()

                    Text("Dose (mg)")
                        .functionalTypography(.uiLabel)
                    TextField("0", text: .constant("250"))
                        .numberInputField(isFocused: true)
                }

                // Chips
                HStack(spacing: Spacing.space2) {
                    Chip("GLP-1")
                    Chip("Healing")
                    Chip("Metabolic")
                }

                // Typography Samples
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    Text("Typography Hierarchy")
                        .typography(.hero)

                    Text("Card Title Example")
                        .typography(.cardTitle)

                    Text("This is body text with proper line height and spacing for comfortable reading.")
                        .typography(.body)
                        .frame(maxWidth: 75 * 14)

                    Text("Functional Label")
                        .functionalTypography(.uiLabel)
                }
            }
            .padding()
        }
    }
}
#endif

/*
 COMPONENT USAGE GUIDELINES:

 1. CARDS
    - Use .card() for standard bordered cards
    - Use .elevatedCard() for featured/important cards
    - Use .tintedCard() for categorized/colored sections

 2. BADGES
    - ONLY use approved BadgeStyle variants
    - Always uppercase text (handled automatically)
    - Use 10pt Sharp Sans Semibold

 3. BUTTONS
    - PrimaryButtonStyle: Main CTAs, destructive actions
    - OutlineButtonStyle: Secondary actions, cancel buttons
    - Intrinsic sizing by default (no full-width)

 4. INPUTS
    - Use .inputField() for text inputs
    - Use .numberInputField() for numeric values
    - Pass isFocused/hasError states for proper styling

 5. GRID LAYOUTS
    - TwoColumnGrid: Library cards, comparison views
    - ThreeColumnGrid: Dense content browsing
    - Always use explicit column counts (no auto-fit on iOS)

 CARDINAL SINS TO AVOID:
 ─────────────────────────
 ✗ Creating new badge color combinations
 ✗ Using arbitrary padding values outside Spacing enum
 ✗ Mixing Brown LL with Sharp Sans in same text block
 ✗ Full-width buttons (use intrinsic sizing)
 ✗ Custom shadow values (use Shadows.card only)
 ✗ Animations exceeding 200ms duration
 */
