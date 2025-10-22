import SwiftUI

// MARK: - Design Tokens
/// Central design system tokens for PeptideFox
/// Provides spacing, colors, typography, and layout values
public struct DesignTokens {
    
    // MARK: - Spacing System
    public struct Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let xxl: CGFloat = 24
        public static let xxxl: CGFloat = 32
        
        // Semantic spacing
        public static let cardPadding: CGFloat = lg
        public static let sectionSpacing: CGFloat = xxl
        public static let itemSpacing: CGFloat = md
    }
    
    // MARK: - Corner Radius
    public struct CornerRadius {
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let pill: CGFloat = 100
    }
    
    // MARK: - Shadow
    public struct Shadow {
        public static let sm = (color: Color.black.opacity(0.05), radius: CGFloat(2), x: CGFloat(0), y: CGFloat(1))
        public static let md = (color: Color.black.opacity(0.08), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        public static let lg = (color: Color.black.opacity(0.1), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
    }
    
    // MARK: - Typography
    public struct Typography {
        // Display
        public static let displayLarge = Font.system(size: 36, weight: .light)
        public static let displayMedium = Font.system(size: 28, weight: .light)
        public static let displaySmall = Font.system(size: 24, weight: .light)

        // Headline
        public static let headlineLarge = Font.system(size: 20, weight: .semibold)
        public static let headlineMedium = Font.system(size: 18, weight: .semibold)
        public static let headlineSmall = Font.system(size: 16, weight: .semibold)

        // Body
        public static let bodyLarge = Font.system(size: 16, weight: .regular)
        public static let bodyMedium = Font.system(size: 14, weight: .regular)
        public static let bodySmall = Font.system(size: 12, weight: .regular)

        // Label
        public static let labelLarge = Font.system(size: 14, weight: .medium)
        public static let labelMedium = Font.system(size: 12, weight: .medium)
        public static let labelSmall = Font.system(size: 10, weight: .medium)

        // Caption
        public static let caption = Font.system(size: 11, weight: .regular)
        public static let captionBold = Font.system(size: 11, weight: .semibold)
    }

    // MARK: - Output Display Typography
    /// Specialized typography for prominent calculator outputs
    public struct OutputDisplay {
        public static let hero = Font.system(size: 72, weight: .light)      // Primary output (bac water)
        public static let large = Font.system(size: 64, weight: .light)     // Variant
        public static let medium = Font.system(size: 56, weight: .light)    // Secondary
        public static let standard = Font.system(size: 36, weight: .regular) // Current size
    }

    // MARK: - Input Typography
    /// Clean, minimal typography for form inputs
    public struct InputTypography {
        public static let numeric = Font.system(size: 24, weight: .light)   // Number inputs
        public static let text = Font.system(size: 18, weight: .regular)    // Text inputs
        public static let label = Font.system(size: 12, weight: .medium)    // Field labels (uppercase)
    }
    
    // MARK: - Layout
    public struct Layout {
        public static let minTouchTarget: CGFloat = 44
        public static let maxContentWidth: CGFloat = 680
        public static let screenPadding: CGFloat = 20
    }
}

// MARK: - Color Tokens
/// Adaptive color tokens that support light and dark mode
public struct ColorTokens {
    
    // MARK: - Semantic Colors
    
    // Background
    public static let backgroundPrimary = Color(UIColor.systemBackground)
    public static let backgroundSecondary = Color(UIColor.secondarySystemBackground)
    public static let backgroundTertiary = Color(UIColor.tertiarySystemBackground)
    public static let backgroundGrouped = Color(UIColor.systemGroupedBackground)
    
    // Foreground
    public static let foregroundPrimary = Color(UIColor.label)
    public static let foregroundSecondary = Color(UIColor.secondaryLabel)
    public static let foregroundTertiary = Color(UIColor.tertiaryLabel)
    public static let foregroundQuaternary = Color(UIColor.quaternaryLabel)
    
    // Brand
    public static let brandPrimary = Color.blue
    public static let brandSecondary = Color.cyan
    
    // Semantic
    public static let success = Color.green
    public static let warning = Color.orange
    public static let error = Color.red
    public static let info = Color.blue
    
    // Border
    public static let borderPrimary = Color(UIColor.separator)
    public static let borderSecondary = Color(UIColor.opaqueSeparator)
    
    // MARK: - Category Colors
    
    public struct CategoryColors {
        // GLP-1 Family
        public static let glp1Background = Color.blue.opacity(0.1)
        public static let glp1Border = Color.blue.opacity(0.3)
        public static let glp1Accent = Color.blue
        
        // Healing & Recovery
        public static let healingBackground = Color.green.opacity(0.1)
        public static let healingBorder = Color.green.opacity(0.3)
        public static let healingAccent = Color.green
        
        // Metabolic
        public static let metabolicBackground = Color.purple.opacity(0.1)
        public static let metabolicBorder = Color.purple.opacity(0.3)
        public static let metabolicAccent = Color.purple
        
        // Longevity
        public static let longevityBackground = Color.orange.opacity(0.1)
        public static let longevityBorder = Color.orange.opacity(0.3)
        public static let longevityAccent = Color.orange
        
        // Cognitive
        public static let cognitiveBackground = Color.cyan.opacity(0.1)
        public static let cognitiveBorder = Color.cyan.opacity(0.3)
        public static let cognitiveAccent = Color.cyan
    }
}

// MARK: - Animations
public struct AnimationTokens {
    public static let quick = Animation.easeInOut(duration: 0.2)
    public static let standard = Animation.easeInOut(duration: 0.3)
    public static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    public static let springBouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
}
