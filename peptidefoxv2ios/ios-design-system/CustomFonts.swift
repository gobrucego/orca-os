//
//  CustomFonts.swift
//  Peptide Fox Design System v4
//
//  Custom font extensions for Brown LL and Sharp Sans No2
//  Maintains web app typography hierarchy in SwiftUI
//

import SwiftUI

// MARK: - Font Extensions

extension Font {

    // MARK: - Brown LL (Primary Content Font)

    /// Brown LL Light 300 - Hero text, large numbers, featured content
    /// Web: font-light (300)
    static func brownLL(size: CGFloat, weight: BrownLLWeight = .regular) -> Font {
        return .custom(weight.fontName, size: size)
    }

    /// Brown LL with Dynamic Type support
    /// Scales with system text size while maintaining design hierarchy
    static func brownLLDynamic(_ style: BrownLLStyle) -> Font {
        return .custom(style.weight.fontName, size: style.size, relativeTo: style.textStyle)
    }

    // MARK: - Sharp Sans No2 (Functional UI Font)

    /// Sharp Sans No2 - Functional UI, labels, badges, navigation
    /// Web: font-functional (Sharp Sans)
    static func sharpSans(size: CGFloat, weight: SharpSansWeight = .medium) -> Font {
        return .custom(weight.fontName, size: size)
    }

    /// Sharp Sans with Dynamic Type support
    static func sharpSansDynamic(_ style: SharpSansStyle) -> Font {
        return .custom(style.weight.fontName, size: style.size, relativeTo: style.textStyle)
    }
}

// MARK: - Brown LL Weight Mapping

/// Brown LL weight variants
/// Maps to web font-weight values
enum BrownLLWeight {
    case light      // 300
    case regular    // 400
    case medium     // 500
    case bold       // 700

    var fontName: String {
        switch self {
        case .light:    return "BrownLL-Light"
        case .regular:  return "BrownLL-Regular"
        case .medium:   return "BrownLL-Medium"
        case .bold:     return "BrownLL-Bold"
        }
    }
}

// MARK: - Sharp Sans No2 Weight Mapping

/// Sharp Sans No2 weight variants
/// Maps to web font-weight values for functional UI
enum SharpSansWeight {
    case regular    // 400
    case medium     // 500
    case semibold   // 600

    var fontName: String {
        switch self {
        case .regular:  return "SharpSansNo2-Regular"
        case .medium:   return "SharpSansNo2-Medium"
        case .semibold: return "SharpSansNo2-Semibold"
        }
    }
}

// MARK: - Brown LL Typography Styles

/// Predefined Brown LL typography styles matching web design system
/// Web source: DESIGN_SYSTEM_V4 typography role map
enum BrownLLStyle {
    /// Hero headlines (48pt, Light 300, line 1.1, -0.01em)
    /// Web: `text-3xl md:text-4xl lg:text-5xl font-light`
    case hero

    /// Large numbers (24pt, Light 300, line 1.2)
    /// Web: `text-2xl font-light`
    case largeNumber

    /// Section H2 (24pt, Regular 400, line 1.3)
    /// Web: `text-xl md:text-2xl font-normal`
    case sectionH2

    /// Card title H4 (24pt, Medium 500, line 1.3)
    /// Web: `text-2xl font-medium`
    case cardTitle

    /// Output values (20pt, Medium 500, line 1.4)
    /// Web: `text-xl font-medium`
    case output

    /// Subsection H3 (16pt, Medium 500, line 1.3)
    /// Web: `text-base font-medium`
    case subsectionH3

    /// Card highlight H5 (20pt, Light 300, line 1.3)
    /// Web: `text-xl font-light`
    case cardHighlight

    /// Body lead (16pt, Light 300, line 1.6)
    /// Web: `text-sm md:text-base font-light`
    case bodyLead

    /// Body text (14pt, Regular 400, line 1.6)
    /// Web: `text-xs md:text-sm font-normal`
    case body

    /// Body small (13pt, Regular 400, line 1.5)
    /// Web: `text-[13px] font-normal`
    case bodySmall

    /// Subtext (12pt, Light 300, line 1.5)
    /// Web: `text-[11px] md:text-xs font-light`
    case subtext

    var size: CGFloat {
        switch self {
        case .hero:             return Typography.text4XL
        case .largeNumber:      return Typography.text3XL
        case .sectionH2:        return Typography.text3XL
        case .cardTitle:        return Typography.text3XL
        case .output:           return Typography.text2XL
        case .subsectionH3:     return Typography.textLG
        case .cardHighlight:    return Typography.text2XL
        case .bodyLead:         return Typography.textLG
        case .body:             return Typography.textBase
        case .bodySmall:        return 13 // Custom size for helper text
        case .subtext:          return Typography.textSM
        }
    }

    var weight: BrownLLWeight {
        switch self {
        case .hero, .largeNumber, .cardHighlight, .bodyLead, .subtext:
            return .light
        case .sectionH2, .body, .bodySmall:
            return .regular
        case .cardTitle, .output, .subsectionH3:
            return .medium
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .hero:
            return Typography.lineHeightTight
        case .largeNumber:
            return 1.2
        case .sectionH2, .cardTitle, .subsectionH3, .cardHighlight:
            return Typography.lineHeightSnug
        case .output:
            return 1.4
        case .bodyLead, .body:
            return Typography.lineHeightRelaxed
        case .bodySmall, .subtext:
            return 1.5
        }
    }

    var tracking: CGFloat {
        switch self {
        case .hero:
            return Typography.trackingTight
        default:
            return Typography.trackingNormal
        }
    }

    var textStyle: Font.TextStyle {
        switch self {
        case .hero:             return .largeTitle
        case .largeNumber, .sectionH2, .cardTitle:  return .title2
        case .output, .cardHighlight:               return .title3
        case .subsectionH3, .bodyLead:              return .body
        case .body, .bodySmall:                     return .callout
        case .subtext:                              return .caption
        }
    }
}

// MARK: - Sharp Sans No2 Typography Styles

/// Predefined Sharp Sans typography styles for functional UI
/// Web source: DESIGN_SYSTEM_V4 functional UI patterns
enum SharpSansStyle {
    /// UI labels (10pt, Medium 500, uppercase, +0.05em)
    /// Web: `text-[8px] md:text-[10px] font-medium uppercase tracking-wide`
    case uiLabel

    /// Badge text (10pt, Semibold 600, uppercase, +0.05em)
    /// Web: `text-[10px] font-[600] uppercase tracking-[0.05em]`
    case badge

    /// Navigation text (12pt, Medium 500)
    /// Web: `text-sm font-medium`
    case navigation

    /// Strong label (10pt, Semibold 600, uppercase, +0.05em)
    /// Web: `text-[10px] font-semibold uppercase tracking-wide`
    case strongLabel

    var size: CGFloat {
        switch self {
        case .uiLabel, .badge, .strongLabel:
            return Typography.textXS
        case .navigation:
            return Typography.textSM
        }
    }

    var weight: SharpSansWeight {
        switch self {
        case .uiLabel, .navigation:
            return .medium
        case .badge, .strongLabel:
            return .semibold
        }
    }

    var tracking: CGFloat {
        return Typography.trackingWide // 0.05em for all Sharp Sans styles
    }

    var textStyle: Font.TextStyle {
        switch self {
        case .uiLabel, .badge, .strongLabel:
            return .caption2
        case .navigation:
            return .caption
        }
    }
}

// MARK: - ViewModifier for Typography Styles

/// Apply complete typography styling including line height and tracking
struct TypographyModifier: ViewModifier {
    let style: BrownLLStyle
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(.brownLLDynamic(style))
            .foregroundColor(color)
            .lineSpacing(calculateLineSpacing(for: style))
            .tracking(style.tracking)
    }

    private func calculateLineSpacing(for style: BrownLLStyle) -> CGFloat {
        // Convert line-height to SwiftUI lineSpacing
        // lineSpacing = (lineHeight - 1) * fontSize
        return (style.lineHeight - 1) * style.size
    }
}

/// Apply functional typography styling (Sharp Sans)
struct FunctionalTypographyModifier: ViewModifier {
    let style: SharpSansStyle
    let color: Color
    let uppercase: Bool

    func body(content: Content) -> some View {
        let styledContent = content
            .font(.sharpSansDynamic(style))
            .foregroundColor(color)
            .tracking(style.tracking)

        if uppercase {
            return AnyView(styledContent.textCase(.uppercase))
        } else {
            return AnyView(styledContent)
        }
    }
}

// MARK: - View Extensions

extension View {
    /// Apply Brown LL typography style
    /// - Parameters:
    ///   - style: Typography style (hero, body, cardTitle, etc.)
    ///   - color: Text color (default: textBody)
    func typography(_ style: BrownLLStyle, color: Color = Colors.textBody) -> some View {
        modifier(TypographyModifier(style: style, color: color))
    }

    /// Apply Sharp Sans functional typography style
    /// - Parameters:
    ///   - style: Functional style (uiLabel, badge, navigation)
    ///   - color: Text color (default: textMuted)
    ///   - uppercase: Force uppercase (default: true for labels/badges)
    func functionalTypography(
        _ style: SharpSansStyle,
        color: Color = Colors.textMuted,
        uppercase: Bool = true
    ) -> some View {
        modifier(FunctionalTypographyModifier(style: style, color: color, uppercase: uppercase))
    }
}

// MARK: - Font Registration Helper

/// Helper to register custom fonts in app
/// Call this in AppDelegate or App init
struct FontRegistration {
    static func registerCustomFonts() {
        // Register Brown LL fonts
        registerFont(name: "BrownLL-Light", extension: "otf")
        registerFont(name: "BrownLL-Regular", extension: "otf")
        registerFont(name: "BrownLL-Medium", extension: "otf")
        registerFont(name: "BrownLL-Bold", extension: "otf")

        // Register Sharp Sans No2 fonts
        registerFont(name: "SharpSansNo2-Regular", extension: "otf")
        registerFont(name: "SharpSansNo2-Medium", extension: "otf")
        registerFont(name: "SharpSansNo2-Semibold", extension: "otf")
    }

    private static func registerFont(name: String, extension ext: String) {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: ext),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("❌ Failed to register font: \(name).\(ext)")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("❌ Error registering font \(name): \(error.debugDescription)")
        } else {
            print("✅ Successfully registered font: \(name)")
        }
    }
}

// MARK: - Usage Examples

/*
 TYPOGRAPHY USAGE EXAMPLES:

 // Hero headline
 Text("Peptide Protocol Builder")
     .typography(.hero)

 // Card title
 Text("BPC-157")
     .typography(.cardTitle, color: Colors.textBody)

 // Body text with max width
 Text("Long paragraph text for reading...")
     .typography(.body)
     .frame(maxWidth: 75 * 14) // 75ch approximation (75 chars * 14pt)

 // UI label (Sharp Sans, uppercase)
 Text("Dosage")
     .functionalTypography(.uiLabel, color: Colors.textMuted)

 // Badge text (Sharp Sans, uppercase, semibold)
 Text("Featured")
     .functionalTypography(.badge, color: Colors.BlueBadge.text)

 // Navigation link (Sharp Sans, no uppercase)
 Text("Library")
     .functionalTypography(.navigation, uppercase: false)

 FONT WEIGHT DECISION GUIDE:
 ─────────────────────────
 Brown LL Light (300):    Hero text, large numbers, featured content
 Brown LL Regular (400):  Body paragraphs, descriptions
 Brown LL Medium (500):   Card titles, data values, headings
 Brown LL Bold (700):     Rare - only for strong emphasis

 Sharp Sans Medium (500):     UI labels, navigation
 Sharp Sans Semibold (600):   Badges, strong labels

 NEVER:
 - Use italic variants (not in design system)
 - Mix Brown LL with Sharp Sans in same text block
 - Use arbitrary font sizes outside Typography enum
 - Apply custom line heights - use TypographyModifier
 */
