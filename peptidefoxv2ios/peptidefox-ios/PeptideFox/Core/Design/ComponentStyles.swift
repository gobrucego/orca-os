import SwiftUI

// MARK: - Card Style
public struct PFCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let cornerRadius: CGFloat
    let shadow: Bool
    
    public init(
        padding: CGFloat = DesignTokens.Spacing.cardPadding,
        cornerRadius: CGFloat = DesignTokens.CornerRadius.md,
        shadow: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }
    
    public var body: some View {
        content
            .padding(padding)
            .background(ColorTokens.backgroundPrimary)
            .cornerRadius(cornerRadius)
            .shadow(
                color: shadow ? DesignTokens.Shadow.md.color : .clear,
                radius: shadow ? DesignTokens.Shadow.md.radius : 0,
                x: shadow ? DesignTokens.Shadow.md.x : 0,
                y: shadow ? DesignTokens.Shadow.md.y : 0
            )
    }
}

// MARK: - Button Styles
public struct PFButton {
    
    public static func primary(_ title: String, icon: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(DesignTokens.Typography.labelMedium)
                }
                Text(title)
                    .font(DesignTokens.Typography.labelLarge)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: DesignTokens.Layout.minTouchTarget)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .background(ColorTokens.brandPrimary)
            .cornerRadius(DesignTokens.CornerRadius.md)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    public static func outline(_ title: String, icon: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(DesignTokens.Typography.labelMedium)
                }
                Text(title)
                    .font(DesignTokens.Typography.labelLarge)
            }
            .foregroundColor(ColorTokens.brandPrimary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: DesignTokens.Layout.minTouchTarget)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .background(ColorTokens.backgroundPrimary)
            .cornerRadius(DesignTokens.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .stroke(ColorTokens.brandPrimary, lineWidth: 1.5)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    public static func secondary(_ title: String, icon: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(DesignTokens.Typography.labelMedium)
                }
                Text(title)
                    .font(DesignTokens.Typography.labelLarge)
            }
            .foregroundColor(ColorTokens.foregroundPrimary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: DesignTokens.Layout.minTouchTarget)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .background(ColorTokens.backgroundSecondary)
            .cornerRadius(DesignTokens.CornerRadius.md)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(AnimationTokens.quick, value: configuration.isPressed)
    }
}

// MARK: - Badge
public struct PFBadge: View {
    let text: String
    let category: PeptideCategory
    
    public init(text: String, category: PeptideCategory) {
        self.text = text
        self.category = category
    }
    
    public var body: some View {
        Text(text)
            .font(DesignTokens.Typography.labelSmall)
            .foregroundColor(category.accentColor)
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(category.backgroundColor)
            .cornerRadius(DesignTokens.CornerRadius.pill)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.pill)
                    .stroke(category.borderColor, lineWidth: 1)
            )
    }
}

// MARK: - Text Field
public struct PFTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String?
    let keyboardType: UIKeyboardType
    
    public init(
        label: String,
        placeholder: String = "",
        text: Binding<String>,
        icon: String? = nil,
        keyboardType: UIKeyboardType = .default
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text(label)
                .font(DesignTokens.Typography.labelMedium)
                .foregroundColor(ColorTokens.foregroundSecondary)
            
            HStack(spacing: DesignTokens.Spacing.md) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(DesignTokens.Typography.bodyMedium)
                        .foregroundColor(ColorTokens.foregroundTertiary)
                }
                
                TextField(placeholder, text: $text)
                    .font(DesignTokens.Typography.bodyLarge)
                    .keyboardType(keyboardType)
            }
            .padding(DesignTokens.Spacing.md)
            .background(ColorTokens.backgroundSecondary)
            .cornerRadius(DesignTokens.CornerRadius.sm)
        }
    }
}

// MARK: - Number Field
public struct PFNumberField: View {
    let label: String
    let placeholder: String
    @Binding var value: Double
    let unit: String
    let icon: String?
    
    public init(
        label: String,
        placeholder: String = "0",
        value: Binding<Double>,
        unit: String,
        icon: String? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._value = value
        self.unit = unit
        self.icon = icon
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text(label)
                .font(DesignTokens.Typography.labelMedium)
                .foregroundColor(ColorTokens.foregroundSecondary)
            
            HStack(spacing: DesignTokens.Spacing.md) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(DesignTokens.Typography.bodyMedium)
                        .foregroundColor(ColorTokens.foregroundTertiary)
                }
                
                TextField(placeholder, value: $value, format: .number)
                    .font(DesignTokens.Typography.bodyLarge)
                    .keyboardType(.decimalPad)
                
                Text(unit)
                    .font(DesignTokens.Typography.labelMedium)
                    .foregroundColor(ColorTokens.foregroundSecondary)
            }
            .padding(DesignTokens.Spacing.md)
            .background(ColorTokens.backgroundSecondary)
            .cornerRadius(DesignTokens.CornerRadius.sm)
        }
    }
}

// MARK: - Section Header
public struct PFSectionHeader: View {
    let title: String
    let subtitle: String?
    
    public init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text(title)
                .font(DesignTokens.Typography.headlineMedium)
                .foregroundColor(ColorTokens.foregroundPrimary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(DesignTokens.Typography.bodySmall)
                    .foregroundColor(ColorTokens.foregroundSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Empty State
public struct PFEmptyState: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    public init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(ColorTokens.foregroundTertiary)
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                Text(title)
                    .font(DesignTokens.Typography.headlineMedium)
                    .foregroundColor(ColorTokens.foregroundPrimary)
                
                Text(message)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundColor(ColorTokens.foregroundSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                PFButton.primary(actionTitle, action: action)
                    .padding(.horizontal, DesignTokens.Spacing.xxxl)
            }
        }
        .padding(DesignTokens.Spacing.xxxl)
    }
}
