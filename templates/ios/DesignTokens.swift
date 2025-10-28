import SwiftUI

// Simple, CSS-like design tokens for SwiftUI projects
// Drop this file into your app target and replace color/font/spacing values as needed.

enum Spacing {
    static let s4: CGFloat = 4
    static let s8: CGFloat = 8
    static let s12: CGFloat = 12
    static let s16: CGFloat = 16
    static let s20: CGFloat = 20
    static let s24: CGFloat = 24
    static let s32: CGFloat = 32
}

enum FontWeightName: String {
    case light, regular, medium, semibold, bold

    var swift: Font.Weight {
        switch self {
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        }
    }
}

enum Typography {
    static func display(_ size: CGFloat, weight: FontWeightName = .semibold, tracking: CGFloat = 0) -> Font {
        Font.system(size: size, weight: weight.swift)
    }

    static func body(_ size: CGFloat = 16, weight: FontWeightName = .regular, tracking: CGFloat = 0) -> Font {
        Font.system(size: size, weight: weight.swift)
    }
}

enum Colors {
    // Map to asset catalog names or hex initializers wrapped in Color extension
    static let textPrimary = Color("TextPrimary")
    static let accentGold = Color("AccentGold")
    static let bg = Color("Background")
}

struct TokenPadding: ViewModifier {
    let amount: CGFloat
    func body(content: Content) -> some View {
        content.padding(amount)
    }
}

extension View {
    func tokenPadding(_ amount: CGFloat) -> some View { self.modifier(TokenPadding(amount: amount)) }
    func tokenSpacing(_ amount: CGFloat) -> some View { self.padding(amount) }
}

// Example usage:
// Text("Hello")
//   .font(Typography.display(20, weight: .semibold))
//   .foregroundStyle(Colors.textPrimary)
//   .tokenPadding(Spacing.s16)

