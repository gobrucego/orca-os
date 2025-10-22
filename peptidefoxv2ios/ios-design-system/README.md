# Peptide Fox iOS Design System
**SwiftUI Native Implementation of Web Design System v4**

Complete, pixel-perfect translation of Peptide Fox's web design system to native iOS, maintaining brand identity while following Apple Human Interface Guidelines.

---

## Quick Start

### 1. Installation

Add font files to your Xcode project:
```
Fonts/
├── BrownLL-Light.otf
├── BrownLL-Regular.otf
├── BrownLL-Medium.otf
├── BrownLL-Bold.otf
├── SharpSansNo2-Regular.otf
├── SharpSansNo2-Medium.otf
└── SharpSansNo2-Semibold.otf
```

Update `Info.plist`:
```xml
<key>UIAppFonts</key>
<array>
    <string>BrownLL-Light.otf</string>
    <string>BrownLL-Regular.otf</string>
    <string>BrownLL-Medium.otf</string>
    <string>BrownLL-Bold.otf</string>
    <string>SharpSansNo2-Regular.otf</string>
    <string>SharpSansNo2-Medium.otf</string>
    <string>SharpSansNo2-Semibold.otf</string>
</array>
```

### 2. Register Fonts on App Launch

```swift
import SwiftUI

@main
struct PeptideFoxApp: App {
    init() {
        FontRegistration.registerCustomFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 3. Import Design System Files

Add to your project:
- `DesignTokens.swift` - Spacing, colors, typography constants
- `CustomFonts.swift` - Font extensions and typography styles
- `ComponentStyles.swift` - Reusable view modifiers and components
- `ExampleComponents.swift` - Reference implementations

---

## Core Design Principles

### 1. Mathematical Precision (4pt Grid)
All spacing uses 4pt increments. NO arbitrary values.

```swift
// ✅ CORRECT
VStack(spacing: Spacing.space4) { ... }
.padding(Spacing.cardPaddingRegular)

// ❌ WRONG
VStack(spacing: 15) { ... }
.padding(25)
```

### 2. Typography Hierarchy
Brown LL for content, Sharp Sans for functional UI.

```swift
// ✅ CORRECT - Content text
Text("Semaglutide")
    .typography(.cardTitle)

// ✅ CORRECT - Functional label
Text("Dosage")
    .functionalTypography(.uiLabel)

// ❌ WRONG - Mixed fonts
Text("Dose: ").font(.system(...)) + Text("2.4 mg")
```

### 3. Approved Badge Colors ONLY
Use `BadgeStyle` enum exclusively.

```swift
// ✅ CORRECT
Badge("Featured", style: .featured)
Badge("Alert", style: .alert)

// ❌ WRONG - Custom colors
Text("Badge")
    .padding()
    .background(Color.pink) // NOT APPROVED
```

### 4. Animation Constraints
Max 200ms duration, ≤1pt hover, ≤8pt modal entry.

```swift
// ✅ CORRECT
.offset(y: isHovered ? -1 : 0)
.animation(.easeOut(duration: 0.2), value: isHovered)

// ❌ WRONG - Excessive animation
.scaleEffect(isPressed ? 1.5 : 1.0)
.animation(.spring(response: 0.6), value: isPressed)
```

---

## Common Usage Patterns

### Cards

```swift
// Standard card
VStack {
    Text("Card Title")
        .typography(.cardTitle)

    Text("Description text")
        .typography(.body)
}
.card()

// Elevated card with shadow
VStack { ... }
    .elevatedCard()

// Tinted card (colored background)
VStack { ... }
    .tintedCard(
        backgroundColor: Colors.BlueBadge.background,
        borderColor: Colors.BlueBadge.border
    )
```

### Badges

```swift
// Standard badges
Badge("Info", style: .info)
Badge("Featured", style: .featured)
Badge("Alert", style: .alert)

// Badge with icon
Badge(
    "Alert",
    style: .alert,
    icon: Image(systemName: "exclamationmark.triangle")
)
```

### Buttons

```swift
// Primary action
Button("Continue") {
    // Action
}
.buttonStyle(PrimaryButtonStyle())

// Secondary action
Button("Cancel") {
    // Action
}
.buttonStyle(OutlineButtonStyle())
```

### Input Fields

```swift
// Text input
@State private var email = ""
@FocusState private var isEmailFocused: Bool

TextField("Enter email", text: $email)
    .focused($isEmailFocused)
    .inputField(isFocused: isEmailFocused)

// Number input
@State private var dose = ""
@FocusState private var isDoseFocused: Bool

TextField("Dose", text: $dose)
    .keyboardType(.decimalPad)
    .focused($isDoseFocused)
    .numberInputField(isFocused: isDoseFocused)

// Input with error state
TextField("Required field", text: $value)
    .inputField(hasError: value.isEmpty)
```

### Typography

```swift
// Headings
Text("Page Title")
    .typography(.hero)

Text("Section Header")
    .typography(.sectionH2)

Text("Card Title")
    .typography(.cardTitle)

// Body text
Text("Paragraph content with proper line height and spacing.")
    .typography(.body)
    .frame(maxWidth: 75 * 14) // 75ch approximation

// Labels
Text("Dosage")
    .functionalTypography(.uiLabel, color: Colors.textMuted)

// Data values
Text("2.4 mg")
    .typography(.output)
```

### Grids

```swift
// 2-column grid
LazyVGrid(
    columns: [
        GridItem(.flexible(), spacing: Spacing.gridGap),
        GridItem(.flexible(), spacing: Spacing.gridGap)
    ],
    spacing: Spacing.gridGap
) {
    ForEach(peptides) { peptide in
        PeptideCard(peptide: peptide)
    }
}

// Responsive grid (size class aware)
@Environment(\.horizontalSizeClass) var sizeClass

var columns: [GridItem] {
    sizeClass == .compact
        ? [GridItem(.flexible())]
        : [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
}
```

---

## Design Token Reference

### Spacing Scale (4pt Grid)

| Constant | Value | Usage |
|----------|-------|-------|
| `Spacing.space1` | 4pt | Optical offset, tight spacing |
| `Spacing.space2` | 8pt | Compact element spacing |
| `Spacing.space3` | 12pt | Label-to-content gap |
| `Spacing.space4` | 16pt | Standard element spacing |
| `Spacing.space6` | 24pt | Card padding, section spacing |
| `Spacing.space8` | 32pt | Card padding (regular) |
| `Spacing.space10` | 48pt | Page section spacing |

### Typography Styles

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `.hero` | 48pt | Light 300 | Page titles |
| `.cardTitle` | 24pt | Medium 500 | Card headers |
| `.output` | 20pt | Medium 500 | Data values |
| `.body` | 14pt | Regular 400 | Paragraphs |
| `.bodySmall` | 13pt | Regular 400 | Helper text |
| `.subtext` | 12pt | Light 300 | Fine print |
| `.uiLabel` | 10pt | Sharp Medium 500 | Functional labels |

### Color Tokens

```swift
// Page backgrounds
Colors.pageBg           // #ffffff
Colors.pageBgMuted      // #f8fafc
Colors.surfaceBg        // #ffffff (cards)
Colors.surfaceSubtle    // #f1f5f9 (tinted cards)

// Text colors
Colors.textBody         // #0f172a (primary)
Colors.textMuted        // #475569 (secondary)
Colors.textSubtle       // #64748b (tertiary)

// Semantic colors
Colors.primary          // #2563eb (blue-600)
Colors.success          // #10b981 (green-500)
Colors.warning          // #f97316 (orange-500)
Colors.critical         // #ef4444 (red-500)

// Borders
Colors.borderSoft       // #e2e8f0
Colors.border           // #cbd5e1
Colors.borderBold       // #94a3b8
```

### Badge Color Combinations

```swift
// Approved badge styles (pre-validated for contrast)
Badge("Info", style: .info)         // Blue
Badge("Featured", style: .featured) // Teal
Badge("Alert", style: .alert)       // Red
Badge("Neutral", style: .neutral)   // Slate
Badge("Purple", style: .purple)     // Purple
Badge("Success", style: .emerald)   // Green
Badge("Warning", style: .amber)     // Orange
```

---

## The 10 Cardinal Sins (iOS)

**NEVER violate these rules:**

### 1. Grid Misalignment
✅ Use explicit spacing: `Spacer().frame(height: Spacing.space6)`
✅ Fixed card heights: `.frame(minHeight: 480)`
❌ Variable-height sibling cards without alignment

### 2. Unequal Comparison Cards
✅ Document height calculations: `// Card height: 480pt`
✅ Match all sibling cards: `.frame(minHeight: 480)`
❌ Cards in same row with different heights

### 3. Decorative Effects
✅ Use official shadow: `Shadows.card`
❌ Custom shadows, glows, halos, gradients

### 4. Badge Contrast Violations
✅ Use `BadgeStyle` enum exclusively
❌ Custom badge color combinations

### 5. Animation Excess
✅ Max 200ms, ≤1pt hover, ≤8pt modal
❌ Zoom, bounce, parallax, long durations

### 6. All White, No Hierarchy
✅ Use `.tintedCard()` or `Colors.surfaceSubtle`
❌ Multiple white cards stacked without distinction

### 7. Huge Icons, Tiny Text
✅ Icons ≤20pt, text ≥14pt
❌ Icons > 20pt, icons dominating text

### 8. Box Inside Box
✅ Minimize nesting, use `.padding()` directly
❌ Redundant `VStack` / `HStack` wrappers

### 9. Synergy Badge Layout
✅ (Not yet implemented - pending custom layout)
❌ Grid-based badges, full-width badges

### 10. Left-Border Accent
✅ (Not yet implemented - pending custom shape)
❌ Fully rounded accents with left border

---

## Dark Mode Support

```swift
// Colors automatically adapt to dark mode
VStack {
    Text("Content")
        .typography(.body) // Uses Colors.textBody (auto-adapts)
}
.card() // Background adapts automatically

// Manual dark mode handling
@Environment(\.colorScheme) var colorScheme

var backgroundColor: Color {
    colorScheme == .dark
        ? Colors.Dark.surfaceBg
        : Colors.surfaceBg
}
```

---

## Accessibility

### VoiceOver

```swift
Badge("Featured", style: .featured)
    .accessibilityLabel("Featured peptide")
    .accessibilityHint("This item is highlighted")

Button("Add to Protocol") { }
    .accessibilityLabel("Add peptide to protocol")
    .accessibilityHint("Adds this peptide to your active protocol")
```

### Dynamic Type

```swift
// Automatically scales with user preferences
Text("Peptide Name")
    .typography(.cardTitle)

// Limit scaling for layout stability
Text("Fixed Size Label")
    .typography(.uiLabel)
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
```

### Contrast Validation

All badge combinations are pre-validated for WCAG AA (4.5:1) and AAA (7:1) compliance.

Test with:
- Xcode Accessibility Inspector
- Increase Contrast mode enabled
- Real device testing

---

## File Structure

```
ios-design-system/
├── README.md                        # This file - Quick reference
├── DESIGN_SYSTEM_TRANSLATION.md     # Complete specification
├── DesignTokens.swift               # Spacing, colors, typography
├── CustomFonts.swift                # Font extensions
├── ComponentStyles.swift            # ViewModifiers, button styles
└── ExampleComponents.swift          # Reference implementations
```

---

## Example Component Implementation

### Peptide Card (Complete)

```swift
struct PeptideCard: View {
    let name: String
    let description: String
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
            .padding(.bottom, Spacing.space6)

            // Divider
            Rectangle()
                .fill(accentColor)
                .frame(height: 1)
                .padding(.bottom, Spacing.space6)

            // Dosing grid
            HStack(spacing: Spacing.space4) {
                VStack(alignment: .leading, spacing: Spacing.space1) {
                    Text("Typical Dose")
                        .functionalTypography(.uiLabel)

                    Text(typicalDose)
                        .typography(.output)
                }

                VStack(alignment: .leading, spacing: Spacing.space1) {
                    Text("Frequency")
                        .functionalTypography(.uiLabel)

                    Text(frequency)
                        .typography(.output)
                }
            }

            Spacer()

            // Action button
            Button(action: onToggle) {
                HStack {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                        .frame(width: 16, height: 16)

                    Text(isSelected ? "Selected" : "Add to Protocol")
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
```

---

## Testing Checklist

- [ ] Fonts registered and loading correctly
- [ ] Typography scales with Dynamic Type
- [ ] Spacing follows 4pt grid (no arbitrary values)
- [ ] Badge colors use approved combinations only
- [ ] Dark mode colors validated
- [ ] VoiceOver labels added to interactive elements
- [ ] Contrast ratios meet AA/AAA standards
- [ ] Animations ≤200ms duration
- [ ] Icons ≤20pt (24pt max for heroes)
- [ ] Buttons have intrinsic width (not full-width)
- [ ] Cards use fixed heights for sibling alignment
- [ ] Input fields show focus/error states correctly

---

## Support & Resources

### Documentation
- **Complete Specification**: `DESIGN_SYSTEM_TRANSLATION.md`
- **Web Design System**: `../app/globals.css`
- **Cardinal Sins**: `../docs/ai-agent/instructions/CLAUDE_INSTRUCTIONS.md`
- **Alignment Rules**: `../docs/ai-agent/design-system/UNIVERSAL_ALIGNMENT_RULES.md`

### External References
- [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/)
- [WCAG 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

### Common Issues

**Problem**: Fonts not loading
**Solution**: Verify font files in Xcode project, check Info.plist, ensure `FontRegistration.registerCustomFonts()` is called

**Problem**: Badge colors don't match web
**Solution**: Use `BadgeStyle` enum exclusively, never create custom color combinations

**Problem**: Spacing looks off
**Solution**: Verify all spacing uses `Spacing` enum values, check for arbitrary padding/spacing values

**Problem**: Dark mode colors incorrect
**Solution**: Use `Colors.Dark.*` tokens, verify `@Environment(\.colorScheme)` handling

---

## Contributing

### Adding New Components
1. Follow existing patterns in `ExampleComponents.swift`
2. Use design tokens exclusively (no magic numbers)
3. Document typography and spacing decisions
4. Add accessibility labels
5. Test in light/dark mode
6. Verify Dynamic Type scaling

### Updating Design Tokens
1. Update web `globals.css` first
2. Sync iOS `DesignTokens.swift`
3. Update this documentation
4. Test all affected components
5. Validate contrast ratios

---

**Version**: 1.0
**Last Updated**: 2025-10-20
**Status**: Production Ready
