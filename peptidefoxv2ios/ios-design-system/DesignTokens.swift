//
//  DesignTokens.swift
//  Peptide Fox Design System v4
//
//  Complete design token system extracted from globals.css
//  Maintains pixel-perfect translation from web to iOS
//

import SwiftUI

// MARK: - Spacing Scale (4px Grid System)

/// Spacing tokens following strict 4px grid alignment
/// Web source: `--space-*` tokens in globals.css
enum Spacing {
    /// 0px - No spacing
    static let space0: CGFloat = 0

    /// 4px - Minimal spacing, optical offsets
    static let space1: CGFloat = 4

    /// 8px - Compact spacing between related elements
    static let space2: CGFloat = 8

    /// 12px - Small gaps, label-to-content
    static let space3: CGFloat = 12

    /// 16px - Standard element spacing
    static let space4: CGFloat = 16

    /// 20px - Card padding (compact)
    static let space5: CGFloat = 20

    /// 24px - Section spacing, card padding
    static let space6: CGFloat = 24

    /// 28px - Large element spacing
    static let space7: CGFloat = 28

    /// 32px - Card padding (standard)
    static let space8: CGFloat = 32

    /// 40px - Major section spacing
    static let space9: CGFloat = 40

    /// 48px - Page section spacing
    static let space10: CGFloat = 48

    /// 60px - Hero section spacing
    static let space12: CGFloat = 60

    // MARK: Semantic Spacing

    /// Optical offset for text next to rounded elements (+4px)
    /// Applied as padding-left when copy sits next to rounded cards
    static let opticalOffset: CGFloat = 4

    /// Standard card padding (mobile)
    static let cardPaddingCompact: CGFloat = 20 // space5

    /// Standard card padding (desktop/tablet)
    static let cardPaddingRegular: CGFloat = 32 // space8

    /// Gap between grid items (2-3 column layouts)
    static let gridGap: CGFloat = 24 // space6

    /// Gap between grid items (4 column dense layouts)
    static let gridGapDense: CGFloat = 16 // space4

    /// Vertical spacing between page sections
    static let sectionSpacing: CGFloat = 48 // space10
}

// MARK: - Typography Scale

/// Typography system using Brown LL and Sharp Sans No2 fonts
/// Web source: `--text-*` tokens and typography roles in DESIGN_SYSTEM_V4
enum Typography {

    // MARK: Font Sizes

    /// 10px - UI labels, functional text
    static let textXS: CGFloat = 10

    /// 12px - Body small, helper text
    static let textSM: CGFloat = 12

    /// 14px - Body text (primary reading size)
    static let textBase: CGFloat = 14

    /// 16px - Lead text, subsection headings
    static let textLG: CGFloat = 16

    /// 18px - H3 headings
    static let textXL: CGFloat = 18

    /// 20px - Card titles, output values
    static let text2XL: CGFloat = 20

    /// 24px - H2 section headers, card titles
    static let text3XL: CGFloat = 24

    /// 48px - Hero headlines, page titles
    static let text4XL: CGFloat = 48

    // MARK: Line Heights

    /// 1.1 - Tight (headings, display text)
    static let lineHeightTight: CGFloat = 1.1

    /// 1.3 - Snug (card titles, subheadings)
    static let lineHeightSnug: CGFloat = 1.3

    /// 1.6 - Relaxed (body text, paragraphs)
    static let lineHeightRelaxed: CGFloat = 1.6

    // MARK: Letter Spacing

    /// -0.01em - Tight tracking for hero text
    static let trackingTight: CGFloat = -0.01

    /// 0 - Normal tracking
    static let trackingNormal: CGFloat = 0

    /// +0.05em - Wide tracking for uppercase labels
    static let trackingWide: CGFloat = 0.05

    // MARK: Font Weights (Brown LL)

    /// 300 - Light (hero, large numbers, featured text)
    static let weightLight: Font.Weight = .light

    /// 400 - Regular (body text, paragraphs)
    static let weightRegular: Font.Weight = .regular

    /// 500 - Medium (card titles, data values, headings)
    static let weightMedium: Font.Weight = .medium

    /// 700 - Bold (rare, only for emphasis)
    static let weightBold: Font.Weight = .bold

    // MARK: Font Weights (Sharp Sans No2 - Functional UI)

    /// 400 - Regular (functional labels)
    static let weightSharpRegular: Font.Weight = .regular

    /// 500 - Medium (UI labels, badges)
    static let weightSharpMedium: Font.Weight = .medium

    /// 600 - Semibold (strong labels, navigation)
    static let weightSharpSemibold: Font.Weight = .semibold
}

// MARK: - Border Radius Scale

/// Border radius tokens for consistent rounded corners
/// Web source: `--radius-*` tokens in globals.css
enum BorderRadius {
    /// 6px - Extra small radius
    static let xs: CGFloat = 6

    /// 8px - Small radius
    static let sm: CGFloat = 8

    /// 10px - Medium radius (inputs, buttons)
    static let md: CGFloat = 10

    /// 12px - Card radius (standard)
    static let card: CGFloat = 12

    /// 18px - Large card radius (GLP comparison cards)
    static let cardLarge: CGFloat = 18

    /// 999px - Pill shape (badges, pills, chips)
    static let pill: CGFloat = 999
}

// MARK: - Color Tokens (Light Mode)

/// Semantic color system with light/dark mode support
/// Web source: `:root` and `.dark` color variables in globals.css
enum Colors {

    // MARK: Base Colors (Light Mode)

    /// Page background - #ffffff
    static let pageBg = Color(hex: "#ffffff")

    /// Page background muted - #f8fafc
    static let pageBgMuted = Color(hex: "#f8fafc")

    /// Surface background (cards) - #ffffff
    static let surfaceBg = Color(hex: "#ffffff")

    /// Surface background subtle - #f1f5f9
    static let surfaceSubtle = Color(hex: "#f1f5f9")

    // MARK: Borders

    /// Soft border - #e2e8f0
    static let borderSoft = Color(hex: "#e2e8f0")

    /// Default border - #cbd5e1
    static let border = Color(hex: "#cbd5e1")

    /// Bold border - #94a3b8
    static let borderBold = Color(hex: "#94a3b8")

    // MARK: Text Colors

    /// Primary text - #0f172a (slate-900)
    static let textBody = Color(hex: "#0f172a")

    /// Muted text - #475569 (slate-600)
    static let textMuted = Color(hex: "#475569")

    /// Subtle text - #64748b (slate-500)
    static let textSubtle = Color(hex: "#64748b")

    /// Inverse text (on dark backgrounds) - #ffffff
    static let textInverse = Color(hex: "#ffffff")

    // MARK: Semantic Colors

    /// Primary action color - #2563eb (blue-600)
    static let primary = Color(hex: "#2563eb")

    /// Primary hover state - #1d4ed8 (blue-700)
    static let primaryHover = Color(hex: "#1d4ed8")

    /// Success state - #10b981 (green-500)
    static let success = Color(hex: "#10b981")

    /// Warning state - #f97316 (orange-500)
    static let warning = Color(hex: "#f97316")

    /// Info state - #0ea5e9 (sky-500)
    static let info = Color(hex: "#0ea5e9")

    /// Critical/error state - #ef4444 (red-500)
    static let critical = Color(hex: "#ef4444")

    // MARK: Badge Color Combinations
    // APPROVED GOLDILOCKS COMBOS ONLY - DO NOT INVENT NEW ONES

    /// Blue badge: bg-blue-100, border-blue-300, text-blue-800
    struct BlueBadge {
        static let background = Color(hex: "#dbeafe")
        static let border = Color(hex: "#60a5fa")
        static let text = Color(hex: "#1e3a8a")
    }

    /// Purple badge: bg-purple-100, border-purple-300, text-purple-800
    struct PurpleBadge {
        static let background = Color(hex: "#e9d5ff")
        static let border = Color(hex: "#c084fc")
        static let text = Color(hex: "#6b21a8")
    }

    /// Slate badge: bg-slate-100, border-slate-300, text-slate-800
    struct SlateBadge {
        static let background = Color(hex: "#e2e8f0")
        static let border = Color(hex: "#94a3b8")
        static let text = Color(hex: "#1e293b")
    }

    /// Teal badge: bg-teal-100, border-teal-300, text-teal-900
    struct TealBadge {
        static let background = Color(hex: "#ccfbf1")
        static let border = Color(hex: "#2dd4bf")
        static let text = Color(hex: "#134e4a")
    }

    /// Red/Alert badge: bg-red-100, border-red-300, text-red-800
    struct RedBadge {
        static let background = Color(hex: "#fee2e2")
        static let border = Color(hex: "#f87171")
        static let text = Color(hex: "#991b1b")
    }

    /// Emerald badge: bg-emerald-100, border-emerald-300, text-emerald-800
    struct EmeraldBadge {
        static let background = Color(hex: "#d1fae5")
        static let border = Color(hex: "#6ee7b7")
        static let text = Color(hex: "#065f46")
    }

    /// Amber badge: bg-amber-100, border-amber-300, text-amber-800
    struct AmberBadge {
        static let background = Color(hex: "#ffedd5")
        static let border = Color(hex: "#fb923c")
        static let text = Color(hex: "#9a3412")
    }

    // MARK: Chart Colors

    /// Chart color 1 - Blue
    static let chart1 = Color(hex: "#2563eb")

    /// Chart color 2 - Green
    static let chart2 = Color(hex: "#22c55e")

    /// Chart color 3 - Purple
    static let chart3 = Color(hex: "#a855f7")

    /// Chart color 4 - Orange
    static let chart4 = Color(hex: "#f97316")

    /// Chart color 5 - Sky
    static let chart5 = Color(hex: "#0ea5e9")
}

// MARK: - Dark Mode Colors

/// Dark mode color overrides
/// Web source: `.dark` class in globals.css
extension Colors {
    struct Dark {
        // MARK: Base Colors (Dark Mode)

        /// Page background - #0b1220
        static let pageBg = Color(hex: "#0b1220")

        /// Surface background (cards) - #10172a
        static let surfaceBg = Color(hex: "#10172a")

        /// Surface subtle - #1f2a3a
        static let surfaceSubtle = Color(hex: "#1f2a3a")

        // MARK: Borders (Dark)

        /// Border - #1f2937
        static let border = Color(hex: "#1f2937")

        /// Border subtle - #374151
        static let borderSubtle = Color(hex: "#374151")

        // MARK: Text (Dark)

        /// Primary text - #e2e8f0
        static let textBody = Color(hex: "#e2e8f0")

        /// Muted text - #94a3b8
        static let textMuted = Color(hex: "#94a3b8")

        /// Subtle text - #64748b
        static let textSubtle = Color(hex: "#64748b")

        // MARK: Semantic (Dark)

        /// Primary action - #60a5fa (blue-400)
        static let primary = Color(hex: "#60a5fa")

        /// Primary foreground - #0f172a
        static let primaryForeground = Color(hex: "#0f172a")

        /// Success - #34d399
        static let success = Color(hex: "#34d399")

        /// Critical - #ef4444
        static let critical = Color(hex: "#ef4444")
    }
}

// MARK: - Shadow Tokens

/// Shadow definitions matching web card shadows
/// Web source: `--shadow-*` tokens in globals.css
enum Shadows {
    /// Standard card shadow: 0 18px 40px rgba(15, 23, 42, 0.08)
    static let card = Color.black.opacity(0.08)
    static let cardOffset = CGSize(width: 0, height: 18)
    static let cardRadius: CGFloat = 40

    /// Hover card shadow: 0 20px 48px rgba(15, 23, 42, 0.12)
    static let hover = Color.black.opacity(0.12)
    static let hoverOffset = CGSize(width: 0, height: 20)
    static let hoverRadius: CGFloat = 48
}

// MARK: - Animation Constants

/// Animation timing matching web design system
/// Web source: DESIGN_SYSTEM_V4 animation limits
enum Animation {
    /// Hover animation duration (200ms max)
    static let hoverDuration: Double = 0.2

    /// Modal/dialog entry duration (200ms max)
    static let modalDuration: Double = 0.2

    /// Maximum translation for hover effects (1px)
    static let hoverTranslation: CGFloat = 1

    /// Maximum translation for modal entry (8px)
    static let modalTranslation: CGFloat = 8

    /// Standard easing curve
    static let easingCurve = Animation.easeOut(duration: hoverDuration)
}

// MARK: - Color Extension for Hex Support

extension Color {
    /// Initialize Color from hex string
    /// - Parameter hex: Hex color string (e.g., "#ffffff" or "ffffff")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Usage Guidelines

/*
 DESIGN SYSTEM CONSTRAINTS (CARDINAL SINS):

 1. GRID ALIGNMENT
    - NEVER use arbitrary spacing values
    - ALWAYS use Spacing enum values
    - Apply opticalOffset (+4pt) when text sits next to rounded elements

 2. TYPOGRAPHY
    - Brown LL: All content, numbers, data (weights: 300, 400, 500, 700)
    - Sharp Sans No2: Functional UI only (labels, badges, navigation)
    - NO arbitrary font sizes - use Typography enum only

 3. COLORS
    - ONLY use approved badge combinations from Colors struct
    - DO NOT invent new color combinations
    - Validate contrast: AA minimum (4.5:1), AAA preferred (7:1)

 4. ANIMATIONS
    - Max hover translation: 1pt
    - Max modal translation: 8pt
    - Max duration: 200ms
    - NO zoom, bounce, parallax effects

 5. BORDERS & SHADOWS
    - Use BorderRadius enum values only
    - Standard card shadow: Shadows.card
    - NO decorative gradients, glows, or halos

 6. ICONS
    - Maximum size: 20pt (24pt for hero sections only)
    - Icons support text, never dominate
    - Always pair with 14pt+ text minimum
 */
