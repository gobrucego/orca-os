# 🎨 DESIGN BRIEF: PeptideFox Calculator Redesign

**Generated:** October 21, 2025
**Based on:** Session log design principles + 28 inspiration screenshots
**Design system:** DesignTokens.swift (iOS)
**Key requirement:** **Prominent output integration** (not elementary scroll pattern)

---

## 🎯 DESIGN CONCEPT

**The Calculator as a Living Tool**

Transform the calculator from a linear "input → submit → scroll → output" flow into an **integrated, real-time experience** where output is always prominent and accessible. The design uses **progressive disclosure** to guide users through compound selection, vial configuration, and dosing calculation while keeping results **immediately visible** without scrolling.

**Core Principle:**
> "Advanced users should see everything at once. New users should be guided progressively. Output is ALWAYS visible."

---

## 📐 BASELINE COMPLIANCE

### Design System Rules (DesignTokens.swift)

**LOCKED Elements:**
- **Typography Scale**: Display (36/28/24px light), Headlines (20/18/16px semibold), Body (16/14/12px regular)
- **Spacing Base Grid**: 4, 8, 12, 16, 20, 24, 32
- **Color System**: Adaptive light/dark, category colors (blue/green/purple/orange/cyan)
- **Semantic Spacing**: Card padding 16px, Section spacing 24px, Item spacing 12px

**ADAPTED from Inspiration:**
- **Search Bar Prominence**: Moved from hidden to top hero position (Session Log feedback: "I literally didn't see it")
- **Card Heights**: ALL cards uniform height (Session Log: "CRITICAL design violation")
- **Progressive Disclosure**: Collapsible cards for GLP journey and frequency pages
- **Output Integration**: Real-time display instead of scroll-to-see pattern

**Session Log Principles Applied:**
1. ✅ **Breathing Room & Hierarchy** → 24px section spacing, generous whitespace
2. ✅ **Consistent Sizing** → All compound cards same height (108px)
3. ✅ **Subtle Depth** → Light shadows (sm: 0.05 opacity, 2px radius)
4. ✅ **Color Strategy** → Category colors for compound types, monochrome base
5. ✅ **Interaction Patterns** → Search prominent, collapsible sections, profile in corner

---

## 🏗️ LAYOUT STRUCTURE

```
┌──────────────────────────────────────────────────────┐
│  [🔍 Search compounds...]                 [Profile] │ ← 60px header, always visible
└──────────────────────────────────────────────────────┘
                    ↕ 24px
┌──────────────────────────────────────────────────────┐
│  FEATURED                                             │ ← Headline 18px semibold
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │ GLOW     │  │ Sema     │  │ Tirz     │          │ ← 108px height (uniform)
│  │ Blend ⚡ │  │ GLP-1    │  │ GLP-1    │          │ ← 12px spacing between
│  └──────────┘  └──────────┘  └──────────┘          │
└──────────────────────────────────────────────────────┘
                    ↕ 24px
┌──────────────────────────────────────────────────────┐
│  CALCULATOR                                           │ ← LIVE OUTPUT always visible
│  ┌────────────────────┐  ┌───────────────────────┐  │
│  │ INPUT              │  │ OUTPUT (LIVE)         │  │ ← Side-by-side
│  │                    │  │                       │  │
│  │ Vial Size: 5mg     │  │ Doses per vial: 10   │  │ ← Real-time calculation
│  │ Desired: 0.5mg     │  │ Days supply: 20      │  │
│  │ Water: 2ml         │  │ Units: 10 units      │  │
│  │                    │  │                       │  │
│  │ [Slider: 0.5mg]    │  │ Total vials: 3       │  │ ← Updates as slider moves
│  └────────────────────┘  └───────────────────────┘  │
│                                                       │
│  [Add to Protocol ↗]                                 │ ← CTA only when complete
└──────────────────────────────────────────────────────┘
```

### Key Layout Decisions

**1. Search Bar - Top Hero Position**
- **Why:** Session Log user feedback: "I literally didn't see the search bar"
- **Implementation:** 60px header, search icon + placeholder always visible
- **Prominence:** First interactive element, impossible to miss

**2. Side-by-Side Input/Output**
- **Why:** Eliminates elementary "scroll to see output" pattern
- **Implementation:** 50/50 split on iPad, stacked on iPhone with output always in viewport
- **Benefit:** Real-time feedback, no CTA needed to see results

**3. Featured Compounds - Uniform Cards**
- **Why:** Session Log: "Cards different heights = CRITICAL design violation"
- **Implementation:** All cards 108px height (includes 16px padding + 76px content)
- **Spacing:** 12px between cards (from DesignTokens.itemSpacing)

---

## 🎨 VISUAL HIERARCHY

### Hero (Most Prominent)
**Search Bar - 60px height**
- Typography: Body 16px (placeholder)
- Background: backgroundSecondary with subtle border
- Icon: 20px magnifying glass (foregroundSecondary)
- **Always visible** - sticky at top

### Primary (Core Function)
**Calculator Output - Live Display**
- Typography: Headline 20px semibold (values), Body 14px (labels)
- Background: backgroundSecondary, light shadow (sm)
- Padding: 20px (more than standard 16px for prominence)
- Updates: Real-time as inputs change (no CTA needed)
- **Always visible** - right side on iPad, below inputs on iPhone (in viewport)

### Secondary (Supporting Input)
**Calculator Inputs**
- Typography: Body 16px (input text), Label 14px medium (field labels)
- Spacing: 16px between fields (DesignTokens.lg)
- Interactive: Sliders use brandPrimary (blue) for active state

### Tertiary (Selection)
**Compound Cards**
- Typography: Headline 16px semibold (compound name), Body 12px (category)
- Height: 108px (UNIFORM - all cards)
- Background: Category color with 0.1 opacity
- Border: Category color with 0.3 opacity
- Hover: Scale 1.02, shadow transition

---

## 🎛️ COMPONENT SPECIFICATIONS

### 1. Search Bar Component

```swift
// Specifications
Height: 60px
Padding: horizontal 20px, vertical 12px
Background: ColorTokens.backgroundSecondary
Border: 1px ColorTokens.borderPrimary
Corner radius: 12px (DesignTokens.CornerRadius.md)
Shadow: None (flat, prominent through size)

// Typography
Placeholder: DesignTokens.Typography.bodyLarge (16px regular)
Input text: DesignTokens.Typography.bodyLarge (16px regular)
Color: foregroundPrimary (input), foregroundSecondary (placeholder)

// Icon
Size: 20px
Color: foregroundSecondary
Position: Leading, 12px from input text

// States
- Default: Border borderPrimary
- Focus: Border brandPrimary, 2px width
- Active (typing): Border brandPrimary
```

### 2. Compound Card Component

```swift
// Specifications
Height: 108px (LOCKED - all cards uniform)
Width: Flexible (grid 2-3 columns based on screen)
Padding: 16px (DesignTokens.Spacing.cardPadding)
Background: Category color at 0.1 opacity
Border: 1px category color at 0.3 opacity
Corner radius: 12px (DesignTokens.CornerRadius.md)
Shadow: sm (black 0.05, radius 2px, y offset 1px)

// Typography
Name: DesignTokens.Typography.headlineSmall (16px semibold)
Category: DesignTokens.Typography.bodySmall (12px regular)
Badge: DesignTokens.Typography.labelSmall (10px medium, uppercase)

// Layout
VStack with 8px spacing:
- Badge (if blend): "BLEND" or category
- Name: Compound name
- Category: GLP-1, Healing, etc.
- Spacer
- Icon or indicator

// Interaction
- Tap: Select compound, navigate to calculator
- Hover: scale(1.02), shadow.md transition
- Selected: Border 2px brandPrimary

// Category Colors (from DesignTokens.ColorTokens.CategoryColors)
- GLP-1: blue (glp1Background, glp1Border, glp1Accent)
- Healing: green (healingBackground, healingBorder, healingAccent)
- Metabolic: purple
- Longevity: orange
- Cognitive: cyan
```

### 3. Calculator Input/Output Component

```swift
// Side-by-Side Layout (iPad)
HStack(spacing: 24) {
  // INPUT SIDE
  VStack(spacing: 16) { ... }

  // OUTPUT SIDE (LIVE)
  VStack(spacing: 12) { ... }
}

// Stacked Layout (iPhone)
VStack(spacing: 24) {
  // INPUT
  VStack(spacing: 16) { ... }

  // OUTPUT (Always in viewport - no scroll)
  VStack(spacing: 12) { ... }
}

// Input Container
Background: backgroundSecondary
Padding: 20px
Corner radius: 16px (lg)
Shadow: sm

// Output Container (More Prominent)
Background: backgroundTertiary (slightly elevated)
Padding: 24px (more generous)
Corner radius: 16px
Shadow: md (more elevation)
Border: 1px brandPrimary (subtle accent for prominence)

// Input Fields
- Label: Typography.labelLarge (14px medium), foregroundSecondary
- Value: Typography.headlineMedium (18px semibold), foregroundPrimary
- Field: 44px min height (Layout.minTouchTarget)
- Spacing: 16px between fields

// Output Values (Real-time)
- Label: Typography.bodyMedium (14px regular), foregroundSecondary
- Value: Typography.headlineLarge (20px semibold), brandPrimary
- Update: Animation.spring on value change
- Spacing: 12px between rows

// Slider
- Track: backgroundTertiary
- Active track: brandPrimary
- Thumb: 24px circle, white with shadow.md
- Updates: Trigger calculation onChange (realtime)
```

### 4. Cocktail Blend Multi-Compound Display

```swift
// For GLOW, KLOW blends
// Default: Shows total dose
// Tap to expand: Shows individual compounds

// Collapsed State
VStack(spacing: 8) {
  HStack {
    Text("GLOW Blend")
      .font(Typography.headlineSmall)
    Spacer()
    Image(systemName: "chevron.down") // Indicates expandable
  }
  Text("Total: 0.45mg")
    .font(Typography.headlineMedium)
    .foregroundColor(brandPrimary)
}

// Expanded State
VStack(spacing: 12) {
  HStack {
    Text("GLOW Blend")
      .font(Typography.headlineSmall)
    Spacer()
    Image(systemName: "chevron.up")
  }

  // Individual compounds (NO sliders, ratio-locked)
  ForEach(compounds) { compound in
    HStack {
      Circle()
        .fill(compound.categoryColor)
        .frame(width: 8, height: 8)
      Text(compound.name)
        .font(Typography.bodyMedium)
      Spacer()
      Text("\(compound.dose)mg")
        .font(Typography.labelLarge)
        .foregroundColor(foregroundSecondary)
    }
  }

  Divider()

  // Total (with slider - adjusts all compounds proportionally)
  HStack {
    Text("Total dose")
      .font(Typography.labelLarge)
    Spacer()
    Text("\(totalDose)mg")
      .font(Typography.headlineMedium)
      .foregroundColor(brandPrimary)
  }

  Slider(value: $totalDose) // Adjusts all compounds by ratio
}

// Ratios stored, user adjusts total, compounds scale automatically
// Example: GLOW 5/10/30 → If user sets total 0.45mg:
//   Semaglutide: 0.05mg (5/45 ratio)
//   Tirzepatide: 0.10mg (10/45 ratio)
//   Compound3: 0.30mg (30/45 ratio)
```

---

## 🎨 TYPOGRAPHY SYSTEM

**Following DesignTokens.Typography:**

| Element | Font | Size | Weight | Usage |
|---------|------|------|--------|-------|
| Calculator value (output) | headlineLarge | 20px | semibold | Prominent results |
| Compound name | headlineSmall | 16px | semibold | Card titles |
| Input value | headlineMedium | 18px | semibold | User-entered values |
| Section header | headlineMedium | 18px | semibold | FEATURED, CALCULATOR |
| Body text | bodyLarge | 16px | regular | Input fields, search |
| Labels | labelLarge | 14px | medium | Field labels |
| Secondary text | bodySmall | 12px | regular | Category, metadata |
| Badge | labelSmall | 10px | medium | BLEND, category badges |

**Hard Rules:**
- Minimum touch target: 44px (DesignTokens.Layout.minTouchTarget)
- Minimum body text: 12px
- Line height: 1.4 (system default for dynamic type support)

---

## 🎨 COLOR SYSTEM

**Following ColorTokens (Adaptive Light/Dark):**

**Backgrounds:**
- Primary: `backgroundPrimary` (system background)
- Secondary: `backgroundSecondary` (cards, inputs)
- Tertiary: `backgroundTertiary` (elevated output)
- Grouped: `backgroundGrouped` (sections)

**Text:**
- Primary: `foregroundPrimary` (main text, 100%)
- Secondary: `foregroundSecondary` (labels, 70%)
- Tertiary: `foregroundTertiary` (metadata, 50%)

**Interactive:**
- Brand: `brandPrimary` (blue) - selected states, output values
- Success: `success` (green) - confirmation, positive feedback
- Warning: `warning` (orange) - dose warnings
- Error: `error` (red) - validation errors

**Category Colors (for compound cards):**
- GLP-1: `glp1Background/Border/Accent` (blue family)
- Healing: `healingBackground/Border/Accent` (green family)
- Metabolic: `metabolicBackground/Border/Accent` (purple family)
- Longevity: `longevityBackground/Border/Accent` (orange family)
- Cognitive: `cognitiveBackground/Border/Accent` (cyan family)

---

## 📏 SPACING SYSTEM

**Following DesignTokens.Spacing:**

| Context | Value | Usage |
|---------|-------|-------|
| Section spacing | 24px (xxl) | Between major sections (Featured → Calculator) |
| Card padding | 16px (lg) | Inside compound cards |
| Item spacing | 12px (md) | Between cards in grid |
| Field spacing | 16px (lg) | Between input fields |
| Inline spacing | 8px (sm) | Between label and value |
| Tight spacing | 4px (xs) | Between badge and text |
| Screen padding | 20px | Edge margins (Layout.screenPadding) |

**Applied Rhythm:**
- Hero search → 24px → Featured section → 24px → Calculator section
- Within calculator: Input container ← 24px → Output container
- Within cards: 16px padding all sides
- Card grid: 12px gaps horizontal and vertical

---

## 🎭 INTERACTION PATTERNS

### 1. Real-Time Calculation (Output Prominence Solution)

**Problem:** Elementary pattern = "input → CTA → scroll → output"
**Solution:** Real-time calculation with always-visible output

```swift
// Input fields bound to @State
@State private var vialSize: Double = 5.0
@State private var desiredDose: Double = 0.5
@State private var waterVolume: Double = 2.0

// Computed property (updates automatically)
var calculatedOutput: CalculatorOutput {
  Calculator.compute(vialSize, desiredDose, waterVolume)
}

// Output view (always visible, no CTA)
VStack {
  OutputRow(label: "Doses per vial", value: calculatedOutput.dosesPerVial)
  OutputRow(label: "Days supply", value: calculatedOutput.daysSupply)
  OutputRow(label: "Units to draw", value: calculatedOutput.units)
}
.animation(.spring, value: calculatedOutput) // Smooth updates
```

**Benefits:**
- No CTA needed - calculation is instant
- No scrolling - output always in view (side-by-side or stacked in viewport)
- Immediate feedback - users see results as they type/slide

### 2. Progressive Disclosure for Blends

**Pattern:** Collapsed by default, tap to expand individual compounds

```swift
@State private var isExpanded = false

// Tap to toggle
VStack {
  if isExpanded {
    // Show individual compounds with ratios
  } else {
    // Show total only
  }
}
.onTapGesture { isExpanded.toggle() }
.animation(.standard) // From AnimationTokens
```

**Why:** Keeps interface clean for single compounds, reveals complexity only when needed

### 3. Search Filtering

**Pattern:** Instant filter as user types

```swift
@State private var searchText = ""

var filteredCompounds: [Compound] {
  if searchText.isEmpty {
    return allCompounds
  }
  return allCompounds.filter {
    $0.name.localizedCaseInsensitiveContains(searchText) ||
    $0.category.localizedCaseInsensitiveContains(searchText)
  }
}
```

**Prominence:** Search bar always visible at top (60px hero position)

### 4. Vial Size & Concentration Always Visible

**Pattern:** Fields always shown, greyed out when empty

```swift
// Always render fields, disable state based on selection
VStack(spacing: 16) {
  InputField(
    label: "Vial Size",
    value: $vialSize,
    placeholder: selectedCompound == nil ? "Select compound first" : "5mg",
    disabled: selectedCompound == nil
  )
  .foregroundColor(selectedCompound == nil ? foregroundTertiary : foregroundPrimary)

  InputField(
    label: "Desired Concentration",
    value: $concentration,
    placeholder: selectedCompound == nil ? "n/a" : "0.5mg",
    disabled: selectedCompound == nil
  )
}
```

**Why:** Advanced users want to calculate quickly - seeing disabled fields shows the flow without forcing dropdown interaction

---

## 📱 RESPONSIVE BEHAVIOR

### iPad / Landscape
```
Side-by-side calculator:
┌────────────────┐  ┌───────────────┐
│ INPUT          │  │ OUTPUT (LIVE) │
│ 50% width      │  │ 50% width     │
└────────────────┘  └───────────────┘
```

### iPhone / Portrait
```
Stacked calculator (output always in viewport):
┌────────────────┐
│ INPUT          │
│                │
└────────────────┘
       ↕ 24px
┌────────────────┐
│ OUTPUT (LIVE)  │ ← Appears as input is filled
│                │ ← No scroll needed to see
└────────────────┘
```

**Compound Grid:**
- iPad: 3 columns
- iPhone: 2 columns
- Gap: 12px

**Search Bar:**
- Fixed at top (sticky)
- Collapses to icon-only on scroll (optional enhancement)

---

## 🔧 IMPLEMENTATION NOTES

### Mapping to 10 Todos

This design brief addresses all 10 todos:

1. ✅ **CompoundPickerView UI** → Search bar hero position, uniform card heights
2. ✅ **Cocktail blend dosing** → Progressive disclosure with ratio system
3. ✅ **Vial fields always visible** → Greyed out disabled state when empty
4. ✅ **Remove glass effect** → Clean backgroundSecondary, subtle shadows only
5. ✅ **Profile to corner** → Top-right corner icon (not in tab bar)
6. ✅ **GLP cards collapsible** → Progressive disclosure pattern
7. ✅ **GLP header badge** → "GLP-1 Protocol Tool" with labelMedium badge
8. ✅ **Frequency card heights** → Uniform 108px (same as compound cards)
9. ✅ **Remove banner** → Banner removed, feature deferred
10. ✅ **Add to Protocol CTA** → Appears after calculator complete, links to placeholder

### Design System Compliance

**No departures needed:**
- All spacing uses DesignTokens.Spacing values
- All typography uses DesignTokens.Typography scale
- All colors use ColorTokens adaptive system
- All shadows use DesignTokens.Shadow tokens
- All corner radii use DesignTokens.CornerRadius values

**Session Log Principles Met:**
1. ✅ Breathing room: 24px section spacing, generous card padding
2. ✅ Consistent sizing: All cards 108px height
3. ✅ Subtle depth: Light shadows (sm: 0.05, md: 0.08)
4. ✅ Color strategy: Category colors for compounds, monochrome base
5. ✅ Interaction patterns: Prominent search, collapsible cards, progressive disclosure

---

## ✅ READY FOR IMPLEMENTATION

**Files to modify:**
1. `PeptideFox/Core/Presentation/Calculator/CompoundPickerView.swift`
2. `PeptideFox/Core/Presentation/Calculator/CalculatorView.swift`
3. `PeptideFox/Core/Presentation/ContentView.swift` (profile to corner)
4. `PeptideFox/Views/Protocol/ProtocolOutputView.swift` (remove glass, add placeholder)
5. GLP-1 Journey page files (collapsible cards, header badge)
6. Dosing frequency page files (uniform card heights)

**Component creation needed:**
- `SearchBarView.swift` - Hero search component
- `CompoundCardView.swift` - Uniform 108px cards
- `CalculatorOutputView.swift` - Live real-time display
- `BlendExpandableView.swift` - Cocktail progressive disclosure

**Testing checklist:**
- [ ] Search bar visible and functional
- [ ] All compound cards exactly 108px height
- [ ] Calculator output updates in real-time
- [ ] Side-by-side on iPad, stacked on iPhone
- [ ] Cocktail blends expand/collapse correctly
- [ ] Vial fields always visible (greyed when disabled)
- [ ] Profile moved to corner icon
- [ ] All spacing uses DesignTokens values
- [ ] All typography uses DesignTokens fonts
- [ ] Glass effects removed throughout

---

**Design brief saved:** `docs/design-briefs/calculator-redesign-20251021.md`
