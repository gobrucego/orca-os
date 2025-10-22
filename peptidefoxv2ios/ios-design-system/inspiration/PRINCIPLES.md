# iOS Design Inspiration - Extracted Principles

**Date:** 2025-10-21
**Source:** User-saved inspiration examples
**Purpose:** Guide PeptideFox iOS calculator implementation

---

## 🎯 Core Principles for Calculator Design

### 1. Hero Data Uses Massive Scale
**Observed in:** Product Statistics (55%), Finance App (3,400 USD), Sleep Reports (90)

**Principle:** Primary data should be 3-5x larger than secondary metrics.

**Application to PeptideFox:**
- BAC water amount: 72pt (OutputDisplay.hero)
- Draw volume: 18pt (Typography.headlineMedium)
- Doses/vial: 16pt (Typography.headlineSmall)

**Why:** Creates instant visual hierarchy - user's eye goes to most important info immediately.

---

### 2. Whitespace Creates Hierarchy
**Observed in:** All examples - generous padding around hero data

**Principle:** Don't cram important data. Give it breathing room.

**Application to PeptideFox:**
- Floating BAC water card: 24px padding around hero number
- 16px padding between secondary metric cards
- 32px spacing above/below floating card

**Why:** Whitespace signals importance. Cramped = secondary, spacious = primary.

---

### 3. Corner Placement for Profile
**Observed in:** Finance App - "Profile" button in top-right corner, NOT tab bar

**Principle:** Profile/settings belong in corner, not in main navigation.

**Application to PeptideFox:**
- Move profile from tab bar to top-right corner icon
- Tab bar for: Calculator, Library, Protocols (core functions only)

**Why:** Profile is infrequent action, doesn't deserve tab bar real estate.

---

### 4. Minimal Color Accent
**Observed in:** Orange dot (Product Stats), Red checkmarks (Week Streak), Green bars (Finance)

**Principle:** Use color sparingly for emphasis, not decoration.

**Application to PeptideFox:**
- BAC water number: brandPrimary blue (emphasis)
- Category colors: Only on compound cards
- Rest: monochrome (foregroundPrimary/Secondary)

**Why:** Color loses impact when overused. Reserve for what matters.

---

### 5. Secondary Data in Equal-Height Cards
**Observed in:** Sleep Reports (4 metric cards), Finance App (donut charts)

**Principle:** Supporting metrics go in clean, uniform cards.

**Application to PeptideFox:**
- Expanded floating card shows 3 metrics in uniform height cards:
  - Draw volume: 0.10 mL
  - Doses per vial: 50
  - Units (100u syringe): 10

**Why:** Visual rhythm. Eye can scan secondary data quickly when consistently formatted.

---

### 6. Labels Small & Uppercase
**Observed in:** Sleep Reports ("hours/min.", "beats/min."), Finance ("USD", "For 12 days")

**Principle:** Context labels should be tiny, uppercase, muted color.

**Application to PeptideFox:**
- "BAC WATER" label: 10pt uppercase, foregroundSecondary
- "mL" unit: 14pt medium, foregroundSecondary
- Hero number dominates, label supports

**Why:** Labels provide context but shouldn't compete with data for attention.

---

### 7. Progressive Disclosure via Pull-Up Sheet
**Observed in:** Week Streak card, cosmos.so example

**Principle:** Primary info always visible, secondary info available on demand.

**Application to PeptideFox:**
- **Collapsed state:** BAC water amount only (2.0 mL)
- **Pull up gesture:** Reveals injection info (draw volume, doses, units)
- **Always visible:** Floating above page, can't scroll away

**Why:** Keeps primary function clean. Power users can access details without cluttering for casual users.

---

### 8. Text-First, Icons Secondary
**Observed in:** Audio Recording ("files", "pause", "transcribe" labels)

**Principle:** Readable text labels, icons support but don't replace.

**Application to PeptideFox:**
- Buttons have text labels ("Calculate", "Add to Protocol")
- Icons enhance (calculator icon, plus icon) but text is primary
- No icon-only buttons except universally understood (close X)

**Why:** Text is instantly readable. Icons require learning/recognition.

---

## 🏗️ Floating Card Pattern (Key Innovation)

**Inspired by:** cosmos.so example + Week Streak sheet + Finance App layout

**Implementation:**

```
┌─────────────────────────────────┐
│  INPUTS (Scrollable)             │
│  Vial Size: [5] [10] [20]       │
│  Concentration: 2.5 mg/mL       │
│  [More inputs...]               │
└─────────────────────────────────┘
           ↓ Always visible ↓
┌─────────────────────────────────┐
│  BAC WATER                       │  ← Floating card
│                                  │     (overlays page)
│         2.0 mL                   │  ← 72pt hero
│                                  │
│  [Swipe up to see more ↑]       │
└─────────────────────────────────┘
```

**SwiftUI Implementation:**
```swift
ZStack(alignment: .bottom) {
  // Main content (inputs)
  ScrollView {
    // Calculator inputs
  }

  // Floating BAC water card
  BACWaterOutputCard(
    bacWater: calculatedBacWater,
    isExpanded: $isExpanded
  )
  .offset(y: isExpanded ? -300 : 0)
  .animation(.spring(response: 0.3))
  .gesture(
    DragGesture()
      .onEnded { value in
        if value.translation.height < -50 {
          isExpanded = true
        } else if value.translation.height > 50 {
          isExpanded = false
        }
      }
  )
}
```

**States:**
1. **Collapsed (default):** Shows BAC water amount only, 120pt height
2. **Expanded (pulled up):** Shows BAC water + injection info, 400pt height
3. **Always visible:** Floats above scrollable content

**Why this works:**
- ✅ BAC water LITERALLY above page (prominence through position)
- ✅ Can't be missed (always visible, floats over content)
- ✅ Progressive disclosure (pull to see secondary info)
- ✅ Matches iOS patterns (native sheet gestures)
- ✅ Solves output hierarchy problem (primary output unmissable)

---

## 📏 Typography Scale for Calculator

**Based on inspiration examples' hierarchy:**

| Element | Font | Size | Weight | Usage |
|---------|------|------|--------|-------|
| BAC water amount | OutputDisplay.hero | 72pt | light | Primary output (floating card) |
| Draw volume value | OutputDisplay.standard | 36pt | regular | Secondary metric (expanded) |
| Doses per vial | Typography.headlineLarge | 20pt | semibold | Secondary metric |
| Labels | Typography.labelSmall | 10pt | medium | "BAC WATER", "mL" |
| Input values | Typography.headlineMedium | 18pt | semibold | User-entered data |
| Input labels | Typography.labelLarge | 14pt | medium | "Vial Size", "Concentration" |

**Ratio:** 72pt → 36pt → 20pt (3.6x → 1.8x → 1x)
Matches inspiration examples' dramatic scale differences.

---

## 🎨 Color Usage (Restrained)

**Based on minimal accent principle:**

**Backgrounds:**
- Page: backgroundPrimary (system background)
- Floating card: backgroundTertiary (elevated feel)
- Input fields: backgroundSecondary

**Text:**
- BAC water number: **brandPrimary blue** (emphasis)
- All other numbers: foregroundPrimary (black/white)
- Labels: foregroundSecondary (70% opacity)

**Accents:**
- Active compound: brandPrimary border
- Category badges: CategoryColors (low opacity backgrounds)

**NO color on:**
- Secondary metrics (draw volume, doses)
- Input labels
- Card backgrounds (use elevation via background tiers, not color)

**Why:** Color reserved for most important output (BAC water). Everything else monochrome creates focus.

---

## ✅ Design Checklist (Extracted from Inspirations)

Before presenting work, verify:

**Typography Hierarchy:**
- [ ] BAC water is 3-5x larger than secondary metrics
- [ ] Labels are tiny (10pt), uppercase, muted
- [ ] Scale creates instant visual hierarchy

**Whitespace:**
- [ ] 24px padding around hero number
- [ ] 16px between secondary metric cards
- [ ] NOT cramped - generous breathing room

**Color Restraint:**
- [ ] Only BAC water number uses brandPrimary
- [ ] Secondary metrics are monochrome
- [ ] Category colors only on compound cards

**Progressive Disclosure:**
- [ ] Floating card shows BAC water by default
- [ ] Pull up gesture reveals injection info
- [ ] Always visible (doesn't scroll away)

**Consistency:**
- [ ] All metric cards equal height
- [ ] All spacing uses DesignTokens.Spacing values
- [ ] Touch targets ≥44pt

**Quality Bar:**
- [ ] Matches inspiration examples' polish level
- [ ] NOT "good enough MVP" - premium feel
- [ ] Tested in simulator with screenshots

---

## 🔗 Reference Files

**Inspiration Sources:**
- ios-design-system/inspiration/product-statistics.png
- ios-design-system/inspiration/week-streak.png
- ios-design-system/inspiration/audio-recording.png
- ios-design-system/inspiration/finance-app.png
- ios-design-system/inspiration/sleep-reports.png

**Implementation Files:**
- CalculatorView.swift (main calculator)
- BACWaterOutputCard.swift (floating card component - TO CREATE)
- DesignTokens.swift (typography, spacing, colors)

**Design Brief:**
- docs/design-briefs/calculator-redesign-20251021.md

---

**These principles ensure the iOS calculator matches the quality and thoughtfulness of the inspiration examples.**
