# Peptide Fox iOS Design System Translation
**Complete Design System v4 → SwiftUI Native Implementation**

---

## Executive Summary

This document specifies the complete translation of Peptide Fox's web design system (v4) to SwiftUI for native iOS implementation. The design maintains pixel-perfect brand identity while adapting to Apple Human Interface Guidelines and iOS platform conventions.

### Key Translation Principles

1. **Mathematical Precision**: 4px base grid → 4pt iOS spacing scale
2. **Typography Fidelity**: Brown LL + Sharp Sans No2 → Custom font registration with Dynamic Type support
3. **Color Consistency**: CSS variables → SwiftUI Color structs with light/dark mode
4. **Component Parity**: Web components → SwiftUI ViewModifiers with equivalent behavior
5. **Platform Adaptation**: Grid alignment rules → LazyVGrid with explicit column counts

---

## Design Token Mapping

### Spacing System (4pt Grid)

| Web Token | CSS Value | iOS Constant | SwiftUI Usage |
|-----------|-----------|--------------|---------------|
| `--space-0` | 0px | `Spacing.space0` | 0pt |
| `--space-1` | 4px | `Spacing.space1` | 4pt |
| `--space-2` | 8px | `Spacing.space2` | 8pt |
| `--space-3` | 12px | `Spacing.space3` | 12pt |
| `--space-4` | 16px | `Spacing.space4` | 16pt |
| `--space-5` | 20px | `Spacing.space5` | 20pt |
| `--space-6` | 24px | `Spacing.space6` | 24pt |
| `--space-7` | 28px | `Spacing.space7` | 28pt |
| `--space-8` | 32px | `Spacing.space8` | 32pt |
| `--space-9` | 40px | `Spacing.space9` | 40pt |
| `--space-10` | 48px | `Spacing.space10` | 48pt |
| `--space-12` | 60px | `Spacing.space12` | 60pt |

**Semantic Spacing Mappings:**
- Card padding (compact): `space5` (20pt)
- Card padding (regular): `space8` (32pt)
- Grid gap (standard): `space6` (24pt)
- Grid gap (dense): `space4` (16pt)
- Optical offset: `space1` (4pt) - Applied when text sits next to rounded elements

**iOS Adaptation Notes:**
- Safe area insets automatically handled by SwiftUI
- Keyboard avoidance: Use `.ignoresSafeArea(.keyboard)` sparingly
- Spacing responsive to size classes: Compact (iPhone) vs Regular (iPad)

---

## Typography System

### Font Family Mapping

| Web Font | Usage | iOS Font Name | Weights |
|----------|-------|---------------|---------|
| Brown LL | Primary content, numbers, data | `BrownLL-{weight}` | Light (300), Regular (400), Medium (500), Bold (700) |
| Sharp Sans No2 | Functional UI, labels, badges | `SharpSansNo2-{weight}` | Regular (400), Medium (500), Semibold (600) |

### Typography Role Map

| Web Class | Size | Weight | Line Height | iOS Enum | Dynamic Type |
|-----------|------|--------|-------------|----------|--------------|
| `hero` / `text-5xl` | 48px | Light 300 | 1.1 | `BrownLLStyle.hero` | `.largeTitle` |
| `large-number` / `text-2xl` | 24px | Light 300 | 1.2 | `BrownLLStyle.largeNumber` | `.title2` |
| `section-h2` / `text-2xl` | 24px | Regular 400 | 1.3 | `BrownLLStyle.sectionH2` | `.title2` |
| `card-title-h4` / `text-2xl` | 24px | Medium 500 | 1.3 | `BrownLLStyle.cardTitle` | `.title2` |
| `output` / `text-xl` | 20px | Medium 500 | 1.4 | `BrownLLStyle.output` | `.title3` |
| `subsection-h3` / `text-base` | 16px | Medium 500 | 1.3 | `BrownLLStyle.subsectionH3` | `.body` |
| `card-highlight-h5` / `text-xl` | 20px | Light 300 | 1.3 | `BrownLLStyle.cardHighlight` | `.title3` |
| `body-lead` / `text-base` | 16px | Light 300 | 1.6 | `BrownLLStyle.bodyLead` | `.body` |
| `body` / `text-sm` | 14px | Regular 400 | 1.6 | `BrownLLStyle.body` | `.callout` |
| `body-small` / `text-xs` | 13px | Regular 400 | 1.5 | `BrownLLStyle.bodySmall` | `.callout` |
| `subtext` / `text-xs` | 12px | Light 300 | 1.5 | `BrownLLStyle.subtext` | `.caption` |
| `ui-label` / `text-[10px]` | 10px | Sharp Medium 500 | 1.2 | `SharpSansStyle.uiLabel` | `.caption2` |

### Line Height Translation

**Web CSS `line-height` → SwiftUI `lineSpacing`:**

```swift
// Formula: lineSpacing = (lineHeight - 1) × fontSize
// Example: 14pt text with line-height 1.6
lineSpacing = (1.6 - 1) × 14 = 8.4pt
```

**Implemented in `TypographyModifier`:**
- Tight (1.1): Hero headlines
- Snug (1.3): Headings, card titles
- Relaxed (1.6): Body text, paragraphs

### Letter Spacing (Tracking)

| Web Value | CSS | SwiftUI | Usage |
|-----------|-----|---------|-------|
| Tight | `-0.01em` | `-0.01` | Hero text only |
| Normal | `0` | `0` | Most text |
| Wide | `+0.05em` | `+0.05` | Uppercase labels, badges |

---

## Color System

### Base Colors (Light Mode)

| Web Variable | Hex | iOS Constant | Usage |
|--------------|-----|--------------|-------|
| `--color-page` | `#ffffff` | `Colors.pageBg` | Page background |
| `--color-page-muted` | `#f8fafc` | `Colors.pageBgMuted` | Subtle page background |
| `--color-surface` | `#ffffff` | `Colors.surfaceBg` | Card background |
| `--color-surface-subtle` | `#f1f5f9` | `Colors.surfaceSubtle` | Tinted card background |
| `--color-border-soft` | `#e2e8f0` | `Colors.borderSoft` | Soft borders |
| `--color-border` | `#cbd5e1` | `Colors.border` | Default borders |
| `--color-border-bold` | `#94a3b8` | `Colors.borderBold` | Strong borders |
| `--color-body` | `#0f172a` | `Colors.textBody` | Primary text (slate-900) |
| `--color-muted` | `#475569` | `Colors.textMuted` | Secondary text (slate-600) |
| `--color-subtle` | `#64748b` | `Colors.textSubtle` | Tertiary text (slate-500) |
| `--color-inverse` | `#ffffff` | `Colors.textInverse` | Text on dark backgrounds |

### Semantic Colors

| Web Variable | Hex | iOS Constant | Usage |
|--------------|-----|--------------|-------|
| `--color-primary` | `#2563eb` | `Colors.primary` | Primary actions (blue-600) |
| `--color-primary-hover` | `#1d4ed8` | `Colors.primaryHover` | Hover state (blue-700) |
| `--color-success` | `#10b981` | `Colors.success` | Success states (green-500) |
| `--color-warning` | `#f97316` | `Colors.warning` | Warning states (orange-500) |
| `--color-info` | `#0ea5e9` | `Colors.info` | Info states (sky-500) |
| `--color-critical` | `#ef4444` | `Colors.critical` | Error states (red-500) |

### Approved Badge Color Combinations

**CRITICAL: Only use these exact combinations. DO NOT invent new badge colors.**

| Badge Style | Background | Border | Text | Web Classes |
|-------------|------------|--------|------|-------------|
| **Blue/Info** | `#dbeafe` | `#60a5fa` | `#1e3a8a` | `bg-blue-100 border-blue-300 text-blue-800` |
| **Purple** | `#e9d5ff` | `#c084fc` | `#6b21a8` | `bg-purple-100 border-purple-300 text-purple-800` |
| **Slate/Neutral** | `#e2e8f0` | `#94a3b8` | `#1e293b` | `bg-slate-100 border-slate-300 text-slate-800` |
| **Teal/Featured** | `#ccfbf1` | `#2dd4bf` | `#134e4a` | `bg-teal-100 border-teal-300 text-teal-900` |
| **Red/Alert** | `#fee2e2` | `#f87171` | `#991b1b` | `bg-red-100 border-red-300 text-red-800` |
| **Emerald** | `#d1fae5` | `#6ee7b7` | `#065f46` | `bg-emerald-100 border-emerald-300 text-emerald-800` |
| **Amber** | `#ffedd5` | `#fb923c` | `#9a3412` | `bg-amber-100 border-amber-300 text-amber-800` |

**iOS Implementation:**
```swift
// Use BadgeStyle enum for type safety
Badge("Featured", style: .featured) // Teal combination
Badge("Alert", style: .alert)       // Red combination
Badge("Info", style: .info)         // Blue combination
```

### Dark Mode Colors

| Web Variable (`.dark`) | Hex | iOS Constant | Usage |
|------------------------|-----|--------------|-------|
| `--color-page` | `#0b1220` | `Colors.Dark.pageBg` | Dark page background |
| `--color-surface` | `#10172a` | `Colors.Dark.surfaceBg` | Dark card background |
| `--color-border` | `#1f2937` | `Colors.Dark.border` | Dark borders |
| `--color-body` | `#e2e8f0` | `Colors.Dark.textBody` | Dark mode text |
| `--color-primary` | `#60a5fa` | `Colors.Dark.primary` | Dark mode primary (blue-400) |

**SwiftUI Dark Mode Support:**
```swift
// Automatic color adaptation
@Environment(\.colorScheme) var colorScheme

var backgroundColor: Color {
    colorScheme == .dark ? Colors.Dark.surfaceBg : Colors.surfaceBg
}
```

**Contrast Compliance:**
- Light mode: AA minimum (4.5:1), AAA preferred (7:1)
- Dark mode: Adjusted for OLED displays, maintaining readability
- All badge combinations pre-validated for contrast

---

## Border Radius Scale

| Web Token | CSS Value | iOS Constant | Usage |
|-----------|-----------|--------------|-------|
| `--radius-xs` | 6px | `BorderRadius.xs` | Minimal rounding |
| `--radius-sm` | 8px | `BorderRadius.sm` | Small elements |
| `--radius-md` | 10px | `BorderRadius.md` | Inputs, buttons |
| `--radius-card` | 12px | `BorderRadius.card` | Standard cards |
| `--radius-pill` | 999px | `BorderRadius.pill` | Badges, pills, chips |

**Additional iOS Values:**
- `BorderRadius.cardLarge` = 18pt (GLP comparison cards)

**iOS Implementation:**
```swift
.cornerRadius(BorderRadius.card) // 12pt
```

---

## Shadow System

### Card Shadows

| Web Token | Offset | Blur Radius | Color | iOS Implementation |
|-----------|--------|-------------|-------|-------------------|
| `--shadow-card` | `0 18px` | 40px | `rgba(15,23,42,0.08)` | `Shadows.card` |
| `--shadow-hover` | `0 20px` | 48px | `rgba(15,23,42,0.12)` | `Shadows.hover` |

**SwiftUI Shadow Application:**
```swift
.shadow(
    color: Shadows.card,
    radius: Shadows.cardRadius,
    x: Shadows.cardOffset.width,
    y: Shadows.cardOffset.height
)
```

**CRITICAL CONSTRAINT:**
- ONLY use official shadow tokens
- NO custom shadow values
- NO decorative glows, halos, or heavy shadows
- Subtle elevation only for card hierarchy

---

## Animation Constraints

### Web Animation Limits → iOS

| Interaction | Web Limit | iOS Translation | Timing |
|-------------|-----------|-----------------|--------|
| Hover translation | ≤1px | ≤1pt | 0.2s ease-out |
| Modal entry | ≤8px | ≤8pt | 0.2s ease-out |
| Press feedback | `scale(0.95)` | `.scaleEffect(0.98)` | 0.2s ease-out |

**SwiftUI Implementation:**
```swift
// Hover translation (macOS/iPadOS pointer)
.offset(y: isHovered ? -1 : 0)
.animation(.easeOut(duration: 0.2), value: isHovered)

// Press feedback
.scaleEffect(isPressed ? 0.98 : 1.0)
.animation(.easeOut(duration: 0.2), value: isPressed)
```

**FORBIDDEN ANIMATIONS:**
- ✗ Zoom effects (scale > 1.05)
- ✗ Bounce animations
- ✗ Parallax scrolling
- ✗ Rotation animations (except loading spinners)
- ✗ Custom keyframe animations
- ✗ Durations > 200ms (except page transitions)

---

## Component Translation Guide

### Cards

#### Standard Card (`.ds-card`)

**Web:**
```css
.ds-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border-bold);
  border-radius: var(--radius-card);
  padding: var(--space-7);
}
```

**iOS:**
```swift
VStack {
    // Content
}
.card(padding: Spacing.cardPaddingRegular)

// Or with modifier:
.modifier(CardModifier())
```

#### Elevated Card (`.ds-surface-elevated`)

**Web:**
```css
.ds-surface-elevated {
  background: var(--color-surface);
  border: 1px solid rgba(15, 23, 42, 0.08);
  border-radius: var(--radius-card);
  padding: var(--space-7);
  box-shadow: var(--shadow-card);
}
```

**iOS:**
```swift
VStack {
    // Content
}
.elevatedCard()
```

### Badges

#### Badge Pattern

**Web:**
```html
<div class="ds-badge ds-badge--info">
  <span>Featured</span>
</div>
```

**iOS:**
```swift
Badge("Featured", style: .info)

// With icon
Badge("Alert", style: .alert, icon: Image(systemName: "exclamationmark.triangle"))
```

**CRITICAL RULES:**
- Text ALWAYS uppercase (handled automatically)
- Sharp Sans Semibold 10pt
- Pill shape (999pt corner radius)
- 1px border
- ONLY approved color combinations

### Buttons

#### Primary Button (`.ds-button-primary`)

**Web:**
```css
.ds-button-primary {
  background: var(--color-primary);
  color: var(--color-inverse);
  padding: 0.75rem 1.5rem;
  border-radius: var(--radius-md);
}
```

**iOS:**
```swift
Button("Action") {
    // Action
}
.buttonStyle(PrimaryButtonStyle())
```

#### Outline Button (`.ds-button-outline`)

**Web:**
```css
.ds-button-outline {
  border: 1px solid var(--color-border);
  background: var(--color-surface);
  color: var(--color-body);
}
```

**iOS:**
```swift
Button("Cancel") {
    // Action
}
.buttonStyle(OutlineButtonStyle())
```

**Button Design Rules:**
- Intrinsic width (NO full-width buttons)
- Minimum touch target: 44pt × 44pt (iOS HIG)
- Text: Brown LL Medium 14pt
- Padding: horizontal 24pt, vertical 12pt
- Corner radius: 10pt

### Input Fields

#### Standard Input (`.ds-input`)

**Web:**
```css
.ds-input {
  border: 2px solid var(--color-border);
  border-radius: var(--radius-md);
  padding: var(--space-3) var(--space-5);
  font-family: var(--font-primary);
  font-size: var(--text-base);
}
```

**iOS:**
```swift
@State private var email = ""
@FocusState private var isEmailFocused: Bool

TextField("Enter email", text: $email)
    .focused($isEmailFocused)
    .inputField(isFocused: isEmailFocused)
```

#### Number Input (`.ds-input-number`)

**Web:**
```css
.ds-input-number {
  font-family: var(--font-mono);
  /* Same styling as .ds-input */
}
```

**iOS:**
```swift
TextField("Dose", text: $dose)
    .keyboardType(.decimalPad)
    .numberInputField(isFocused: isFocused)
```

**Input Field States:**
- Default: 2pt border, border color
- Focused: 2pt border, primary color
- Error: 2pt border, critical color
- Disabled: 1pt border, surface-subtle background

---

## Grid Alignment System

### CRITICAL: No `auto 1fr auto` Pattern

**Web Problem:**
```css
/* ❌ WRONG - Cards misalign with different content */
.card {
  grid-template-rows: auto 1fr auto;
}
```

**Web Solution:**
```css
/* ✅ CORRECT - Explicit row templates */
.card {
  grid-template-rows:
    auto    /* Title */
    4px     /* Spacer */
    auto    /* Subtitle */
    16px    /* Spacer */
    auto    /* Description */
    24px    /* Spacer */
    1fr     /* Flexible content */
    32px    /* Spacer */
    auto;   /* CTA */
}
```

**iOS Translation:**

SwiftUI doesn't use explicit grid-template-rows, but we achieve the same effect with:

```swift
VStack(spacing: 0) {
    // Title
    Text("Card Title")
        .typography(.cardTitle)

    Spacer().frame(height: 4)

    // Subtitle
    Text("Subtitle")
        .typography(.bodySmall)

    Spacer().frame(height: 16)

    // Description
    Text("Description text...")
        .typography(.body)

    Spacer().frame(height: 24)

    // Flexible content
    Spacer()

    Spacer().frame(height: 32)

    // CTA
    Button("Action") {}
        .buttonStyle(PrimaryButtonStyle())
}
.frame(minHeight: 480) // Fixed height for sibling alignment
```

### Grid Layout Patterns

#### Two-Column Grid (`.ds-grid-2`)

**Web:**
```css
.ds-grid-2 {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: var(--space-6);
}
```

**iOS:**
```swift
LazyVGrid(
    columns: [
        GridItem(.flexible(), spacing: Spacing.gridGap),
        GridItem(.flexible(), spacing: Spacing.gridGap)
    ],
    spacing: Spacing.gridGap
) {
    // Grid items
}
```

**iOS Adaptation:**
- iPhone (Compact): Single column
- iPad (Regular): Two or three columns
- Use `@Environment(\.horizontalSizeClass)` for responsive layouts

---

## Optical Alignment Rules

### Bullet List Alignment

**Web Implementation:**
```css
.ds-bullet-list li::before {
  content: "•";
  position: absolute;
  left: 0;
  top: 0.175rem; /* For 14px text */
  font-size: 0.75em;
}
```

**iOS Implementation:**
```swift
HStack(alignment: .top, spacing: 8) {
    Text("•")
        .font(.brownLL(size: Typography.textBase * 0.75, weight: .regular))
        .offset(y: 2.5) // 0.175rem optical alignment

    Text("Bullet text content")
        .typography(.body)
}
```

**Text Size → Offset Mapping:**
- 12pt text: `offset(y: 1.8)` (0.125rem)
- 13pt text: `offset(y: 2.1)` (0.15rem)
- 14pt text: `offset(y: 2.5)` (0.175rem)
- 16pt text: `offset(y: 3.5)` (0.25rem)

### Icon-to-Text Alignment

**Web:**
```css
.icon-text-pair .icon {
  position: relative;
  top: -1px; /* Nudge upward */
}
```

**iOS:**
```swift
HStack(spacing: 12) {
    Image(systemName: "checkmark.circle")
        .resizable()
        .frame(width: 16, height: 16)
        .offset(y: -1) // Optical lift

    Text("Text content")
        .typography(.body)
}
```

### Optical Offset for Rounded Elements

**Web:**
```css
.ds-align-offset {
  padding-left: var(--align-offset); /* 4px */
}
```

**iOS:**
```swift
Text("Text next to rounded card")
    .opticalOffset() // Adds 4pt leading padding
```

**When to Apply:**
- Text sitting next to rounded card edges
- Labels adjacent to circular badges
- Copy aligned with pill-shaped elements

---

## Platform-Specific Adaptations

### Size Class Responsiveness

```swift
@Environment(\.horizontalSizeClass) var horizontalSizeClass

var cardPadding: CGFloat {
    horizontalSizeClass == .compact
        ? Spacing.cardPaddingCompact   // 20pt (iPhone)
        : Spacing.cardPaddingRegular   // 32pt (iPad)
}
```

### Dynamic Type Support

All typography styles support iOS Dynamic Type scaling:

```swift
// Automatically scales with user's text size preferences
Text("Hero Headline")
    .typography(.hero)

// Limits scaling for layout stability
Text("Data Value")
    .typography(.output)
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
```

### Safe Area Integration

```swift
ScrollView {
    VStack {
        // Content
    }
    .padding(.horizontal, Spacing.space6)
}
.ignoresSafeArea(edges: .bottom) // Only if needed
```

### Accessibility

#### VoiceOver Support

```swift
Badge("Featured", style: .featured)
    .accessibilityLabel("Featured peptide")
    .accessibilityHint("This peptide is highlighted")

Button("Add to Protocol") {}
    .accessibilityLabel("Add peptide to protocol")
```

#### Contrast Compliance

All badge combinations pre-validated:
- AA compliance: 4.5:1 minimum
- AAA preferred: 7:1

**Testing:**
- Xcode Accessibility Inspector
- SF Symbols Color Contrast tool
- Real device testing with Increase Contrast enabled

---

## The 10 Cardinal Sins (iOS Translation)

### 1. Grid Misalignment
**Web:** Never use `auto 1fr auto`
**iOS:** Use explicit `Spacer().frame(height:)` and fixed `minHeight` for sibling cards

### 2. Unequal Comparison Cards
**Web:** All comparison cards must match height
**iOS:**
```swift
.frame(minHeight: 480) // Document the calculation
```

### 3. Decorative Effects
**Web:** No gradients, glows, halos
**iOS:** Only use `Shadows.card` token. NO custom `.shadow()` values

### 4. Badge Contrast Violations
**Web:** Only approved color combos
**iOS:** Use `BadgeStyle` enum exclusively

### 5. Animation Excess
**Web:** ≤1px hover, ≤8px modal, ≤200ms
**iOS:**
```swift
.animation(.easeOut(duration: 0.2), value: state)
```

### 6. All White, No Hierarchy
**Web:** Add background tints
**iOS:** Use `.tintedCard()` or `Colors.surfaceSubtle`

### 7. Huge Icons, Tiny Text
**Web:** Icons ≤20px, text 14px+
**iOS:**
```swift
Image(systemName: "icon")
    .resizable()
    .frame(width: 20, height: 20) // Max size
```

### 8. Box Inside Box
**Web:** Remove redundant wrappers
**iOS:** Minimize `VStack` / `HStack` nesting, use `.padding()` directly

### 9. Synergy Badge Layout
**Web:** Fixed 54px height, flex-wrap
**iOS:**
```swift
// Not yet implemented - requires custom layout
```

### 10. Left-Border Accent Violations
**Web:** Left square, right rounded
**iOS:** Custom shape required (not in base system)

---

## File Organization

```
ios-design-system/
├── DesignTokens.swift          # Spacing, colors, typography constants
├── CustomFonts.swift           # Brown LL & Sharp Sans extensions
├── ComponentStyles.swift       # ViewModifiers, button/badge styles
├── ExampleComponents.swift     # Reference implementations
└── DESIGN_SYSTEM_TRANSLATION.md # This document
```

### Integration Steps

1. **Add Font Files to Xcode Project:**
   - Brown LL: Light, Regular, Medium, Bold (.otf)
   - Sharp Sans No2: Regular, Medium, Semibold (.otf)

2. **Register Fonts in Info.plist:**
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

3. **Register Fonts on App Launch:**
```swift
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

4. **Import Design System:**
```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Peptide Fox")
                .typography(.hero)

            Badge("Featured", style: .featured)
        }
        .card()
    }
}
```

---

## Testing & Validation

### Design Token Verification

```swift
// Spacing scale test
VStack(spacing: 0) {
    ForEach([4, 8, 12, 16, 20, 24, 28, 32, 40, 48, 60], id: \.self) { value in
        Rectangle()
            .fill(Colors.primary)
            .frame(height: CGFloat(value))
    }
}
```

### Typography Scale Preview

```swift
VStack(alignment: .leading, spacing: Spacing.space4) {
    Text("Hero (48pt)").typography(.hero)
    Text("Section H2 (24pt)").typography(.sectionH2)
    Text("Card Title (24pt)").typography(.cardTitle)
    Text("Body (14pt)").typography(.body)
    Text("Subtext (12pt)").typography(.subtext)
    Text("UI Label (10pt)").functionalTypography(.uiLabel)
}
```

### Color Contrast Testing

Use Xcode Accessibility Inspector:
1. Product → Analyze → Accessibility
2. Verify all text/background combinations meet AA (4.5:1) or AAA (7:1)

### Device Testing Matrix

| Device | Size Class | Typography | Spacing | Notes |
|--------|------------|------------|---------|-------|
| iPhone SE | Compact | 14pt base | Compact padding | Smallest screen |
| iPhone 14 Pro | Compact | 14pt base | Compact padding | Standard |
| iPhone 14 Pro Max | Compact | 14pt base | Compact padding | Large phone |
| iPad Air | Regular | 16pt base | Regular padding | Tablet |
| iPad Pro 12.9" | Regular | 16pt base | Regular padding | Largest |

---

## Migration Checklist

- [ ] Font files added to Xcode project
- [ ] Fonts registered in Info.plist
- [ ] `DesignTokens.swift` integrated
- [ ] `CustomFonts.swift` integrated
- [ ] `ComponentStyles.swift` integrated
- [ ] Font registration called in app init
- [ ] Typography preview tested
- [ ] Badge color combinations validated
- [ ] Input field states tested (focus, error)
- [ ] Button styles tested (primary, outline)
- [ ] Card shadows verified (match web)
- [ ] Grid layouts tested (2-column, 3-column)
- [ ] Dark mode colors tested
- [ ] Dynamic Type scaling verified
- [ ] VoiceOver labels added
- [ ] Contrast ratios validated (AA/AAA)
- [ ] Animation timings tested (≤200ms)

---

## Decision Log

### Why SwiftUI Native (Not UIKit)?

- **Declarative paradigm** matches web component structure
- **Automatic Dark Mode** support via environment
- **Dynamic Type** integration out-of-box
- **Preview canvas** for rapid iteration
- **Type-safe** design tokens via enums

### Why Custom Fonts (Not SF Pro)?

- **Brand consistency** with web app critical
- **Brown LL** establishes premium, clinical aesthetic
- **Sharp Sans** for functional UI creates hierarchy
- SF Pro fallback for system components (alerts, pickers)

### Why Explicit Spacing Enum (Not SwiftUI Defaults)?

- **Pixel-perfect** alignment with web design
- **4pt grid** ensures mathematical precision
- **Prevents** arbitrary spacing values
- **Documents** design decisions

### Why Badge Enum (Not Raw Colors)?

- **Prevents** color combination violations
- **Type-safe** badge styling
- **Pre-validated** contrast compliance
- **Matches** web approved palette exactly

---

## Future Enhancements

### Not Yet Implemented

1. **Left-Border Accent Pattern** (Cardinal Sin #10)
   - Requires custom `Shape` conformance
   - Web: `rounded-l-none rounded-r-md border-l-4`

2. **Synergy Badge Layout** (Cardinal Sin #9)
   - Fixed 54pt height with flex-wrap
   - Requires custom `Layout` protocol (iOS 16+)

3. **Bullet List Component**
   - Reusable component with proper optical alignment
   - Text-size-dependent offset calculation

4. **Number Input Formatter**
   - Decimal pad with unit suffix
   - Real-time validation

5. **Device Picker Multi-Select**
   - Checkbox-based selection
   - Grouped sections (pens vs syringes)

### Performance Optimizations

- **LazyVGrid** for large peptide library
- **Image caching** for peptide icons
- **Debounced search** for filtering
- **Pagination** for protocol history

---

## Support & Maintenance

### Design System Owner
Contact design system maintainer for:
- New color combination approvals
- Typography scale additions
- Component pattern reviews

### Breaking Changes
Major version updates require:
1. Design token audit
2. Component regression testing
3. Accessibility revalidation
4. Migration guide documentation

### Version History
- **v4.0**: Initial web → iOS translation (this document)
- **v3.0**: Web design system baseline (DESIGN_SYSTEM_V4_AI_AGENT.md)

---

## References

- **Web Design System**: `app/globals.css`
- **Typography Guide**: `DESIGN_SYSTEM_V4_AI_AGENT.md`
- **Cardinal Sins**: `CLAUDE_INSTRUCTIONS.md` (#1-10)
- **Alignment Rules**: `UNIVERSAL_ALIGNMENT_RULES.md`
- **Apple HIG**: https://developer.apple.com/design/human-interface-guidelines/
- **WCAG 2.1**: https://www.w3.org/WAI/WCAG21/quickref/

---

**Document Version**: 1.0
**Last Updated**: 2025-10-20
**Status**: Complete - Ready for Implementation
