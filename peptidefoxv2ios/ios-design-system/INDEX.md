# Peptide Fox iOS Design System
**Complete Web → SwiftUI Translation Documentation**

---

## 📚 Documentation Index

### Quick Start
- **[README.md](README.md)** - Quick reference guide, common patterns, testing checklist

### Complete Specifications
- **[DESIGN_SYSTEM_TRANSLATION.md](DESIGN_SYSTEM_TRANSLATION.md)** - Complete design token mapping, component translation, platform adaptations
- **[TRANSLATION_SUMMARY.md](TRANSLATION_SUMMARY.md)** - Design decisions, architecture rationale, implementation challenges

### Implementation Files
- **[DesignTokens.swift](DesignTokens.swift)** - Spacing, typography, colors, shadows, animations
- **[CustomFonts.swift](CustomFonts.swift)** - Brown LL & Sharp Sans extensions, Dynamic Type support
- **[ComponentStyles.swift](ComponentStyles.swift)** - Cards, badges, buttons, inputs, ViewModifiers
- **[ExampleComponents.swift](ExampleComponents.swift)** - Reference implementations (PeptideCard, GLPComparisonCard, etc.)

---

## 🎯 Quick Navigation

### By Task

**I want to...**
- **Get started quickly** → [README.md](README.md)
- **Understand design decisions** → [TRANSLATION_SUMMARY.md](TRANSLATION_SUMMARY.md)
- **Look up a color/spacing value** → [DesignTokens.swift](DesignTokens.swift)
- **Add custom typography** → [CustomFonts.swift](CustomFonts.swift)
- **Style a card or button** → [ComponentStyles.swift](ComponentStyles.swift)
- **See example implementations** → [ExampleComponents.swift](ExampleComponents.swift)
- **Understand complete system** → [DESIGN_SYSTEM_TRANSLATION.md](DESIGN_SYSTEM_TRANSLATION.md)

### By Role

**Designer** → Start with [DESIGN_SYSTEM_TRANSLATION.md](DESIGN_SYSTEM_TRANSLATION.md) to understand token mapping
**iOS Developer** → Start with [README.md](README.md) for quick patterns, then [ExampleComponents.swift](ExampleComponents.swift)
**Design System Maintainer** → Read [TRANSLATION_SUMMARY.md](TRANSLATION_SUMMARY.md) for architecture decisions
**QA/Tester** → Use testing checklist in [README.md](README.md)

---

## 📊 Design System Overview

### Core Principles
1. **Mathematical Precision** - 4pt base grid, zero arbitrary values
2. **Brand Consistency** - Brown LL + Sharp Sans custom fonts
3. **Type Safety** - Enum-based tokens prevent violations
4. **Accessibility** - WCAG AAA compliance, Dynamic Type, VoiceOver
5. **Platform Adaptation** - iOS conventions with web fidelity

### Statistics
- **Spacing Scale**: 12 values (4pt grid)
- **Typography Styles**: 11 content + 4 functional roles
- **Color Tokens**: 40+ semantic colors (light/dark)
- **Badge Styles**: 7 pre-approved combinations
- **Components**: 15+ reusable patterns
- **Cardinal Sins**: 10 critical design violations to avoid

---

## 🔍 Feature Comparison

| Feature | Web Implementation | iOS Implementation | Notes |
|---------|-------------------|-------------------|-------|
| **Spacing** | CSS variables (px) | Swift enum (pt) | 1:1 mapping |
| **Typography** | CSS @font-face | Custom font registration | Brown LL + Sharp Sans |
| **Colors** | CSS variables | Swift Color structs | Light/dark mode |
| **Components** | CSS classes | ViewModifiers | Type-safe patterns |
| **Grid Layouts** | CSS Grid | LazyVGrid | Explicit columns |
| **Animations** | CSS transitions | SwiftUI animations | Same timing/limits |
| **Dark Mode** | `.dark` class | `@Environment` | Automatic adaptation |

---

## 🚀 Implementation Checklist

### Setup (30 minutes)
- [ ] Add font files to Xcode project
- [ ] Register fonts in Info.plist
- [ ] Copy design system Swift files
- [ ] Call `FontRegistration.registerCustomFonts()` in app init
- [ ] Test typography preview

### Integration (1-2 hours)
- [ ] Replace hardcoded spacing with `Spacing` enum
- [ ] Replace system fonts with `.typography()` modifiers
- [ ] Replace custom buttons with `ButtonStyle` implementations
- [ ] Replace custom cards with `.card()` modifiers
- [ ] Test dark mode colors

### Validation (1 hour)
- [ ] Accessibility audit (VoiceOver labels)
- [ ] Contrast validation (AA/AAA compliance)
- [ ] Dynamic Type scaling test
- [ ] Design review (compare with web)

---

## 📖 Code Examples

### Typography
```swift
// Hero headline
Text("Peptide Protocol Builder")
    .typography(.hero)

// Card title
Text("Semaglutide")
    .typography(.cardTitle)

// Functional label
Text("Dosage")
    .functionalTypography(.uiLabel)
```

### Cards
```swift
// Standard card
VStack {
    Text("Content")
        .typography(.body)
}
.card()

// Elevated card
VStack { ... }
    .elevatedCard()
```

### Badges
```swift
Badge("Featured", style: .featured)
Badge("Alert", style: .alert)
Badge("Info", style: .info)
```

### Buttons
```swift
Button("Continue") { }
    .buttonStyle(PrimaryButtonStyle())

Button("Cancel") { }
    .buttonStyle(OutlineButtonStyle())
```

---

## ⚠️ The 10 Cardinal Sins

Design violations that must NEVER occur:

1. **Grid Misalignment** - Use fixed heights for sibling cards
2. **Unequal Comparison Cards** - Document height calculations
3. **Decorative Effects** - ONLY use `Shadows.card` token
4. **Badge Color Invention** - Use `BadgeStyle` enum exclusively
5. **Animation Excess** - Max 200ms, ≤1pt hover, ≤8pt modal
6. **All White Stack** - Add background tints for hierarchy
7. **Huge Icons** - Icons ≤20pt, text leads
8. **Redundant Wrappers** - Minimize nesting
9. **Synergy Badge Layout** - (Not yet implemented)
10. **Left-Border Accents** - (Not yet implemented)

See [DESIGN_SYSTEM_TRANSLATION.md](DESIGN_SYSTEM_TRANSLATION.md) for complete details.

---

## 🛠️ Troubleshooting

### Fonts Not Loading
1. Verify font files in Xcode project
2. Check Info.plist registration
3. Ensure `FontRegistration.registerCustomFonts()` is called
4. Check console for registration errors

### Badge Colors Don't Match Web
- Use `BadgeStyle` enum exclusively
- Never create custom badge color combinations
- All combinations pre-validated for contrast

### Spacing Looks Off
- Verify all spacing uses `Spacing` enum
- Check for arbitrary padding/spacing values
- Use `.opticalOffset()` for text next to rounded elements

### Dark Mode Colors Incorrect
- Use `Colors.Dark.*` tokens for dark mode
- Verify `@Environment(\.colorScheme)` handling
- Test with dark mode enabled on device

---

## 📞 Support

### External Resources
- [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/)
- [WCAG 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

### Web Design System Sources
- `../app/globals.css` - Complete token definitions
- `../docs/ai-agent/design-system/DESIGN_SYSTEM_V4_AI_AGENT.md` - Implementation guide
- `../docs/ai-agent/instructions/CLAUDE_INSTRUCTIONS.md` - Cardinal sins
- `../docs/ai-agent/design-system/UNIVERSAL_ALIGNMENT_RULES.md` - Optical alignment

---

## 📈 Version History

- **v1.0** (2025-10-20) - Initial web → iOS translation
  - Complete design token extraction
  - Custom font integration
  - Component library implementation
  - Example components and documentation

---

**Last Updated**: 2025-10-20
**Status**: Production Ready
**Maintained By**: Design System Team
