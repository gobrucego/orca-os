# iOS Calculator - Visual Flow Guide

## Before (WRONG) ❌

```
┌─────────────────────────────────────┐
│  Navigation: "Calculator"           │
├─────────────────────────────────────┤
│                                     │
│  [RECONSTITUTION CALCULATOR]        │ ← Centered badge
│        Peptide Dosing               │ ← Extra heading
│                                     │
│  ┌───────────────────────────┐     │
│  │ 🧪 Vial Size              │     │
│  │ [10] mg                   │     │
│  └───────────────────────────┘     │
│                                     │
│  ┌───────────────────────────┐     │
│  │ 💧 Reconstitution Volume  │     │
│  │ [2.0] ml                  │     │
│  └───────────────────────────┘     │
│                                     │
│  ┌───────────────────────────┐     │
│  │ 🎯 Target Dose            │     │
│  │ [0.25] mg                 │     │
│  └───────────────────────────┘     │
│                                     │
│  Frequency                          │
│  [ Daily | Weekly | 2x Week ]       │ ← WRONG (removed)
│                                     │
│  [     Calculate     ]              │
│                                     │
│  Results:                           │
│  • Concentration                    │
│  • Draw Volume                      │
│  • Syringe Units                    │
│  • Recommended Device               │ ← WRONG (removed)
│  • Doses Per Vial                   │
│  • Monthly Supply                   │ ← WRONG (removed)
│                                     │
│  [Syringe Visual Guide]             │ ← WRONG (removed)
│  [Suggestions]                      │ ← WRONG (removed)
│                                     │
└─────────────────────────────────────┘
```

## After (CORRECT) ✅

```
┌─────────────────────────────────────┐
│                          [ Reset ]  │
├─────────────────────────────────────┤
│                                     │
│  f(x) Reconstitution Calculator     │ ← Left-aligned, function icon
│                                     │
│  Compound                           │
│  ┌───────────────────────────┐     │
│  │ Select Compound        ▼  │     │ ← Opens modal
│  └───────────────────────────┘     │
│                                     │
│  Vial Size                          │
│  ┌───────────────────────────┐     │
│  │ [10]               mg     │     │
│  └───────────────────────────┘     │
│                                     │
│  Desired Concentration              │
│  ┌───────────────────────────┐     │
│  │ [5.0]              mg/ml  │     │
│  └───────────────────────────┘     │
│                                     │
│  ┌───────────────────────────┐     │
│  │      Calculate            │     │
│  └───────────────────────────┘     │
│                                     │
│  ┌───────────────────────────┐     │
│  │ Bacteriostatic Water      │     │
│  │                           │     │
│  │    2.00 ml                │     │ ← Large, prominent
│  └───────────────────────────┘     │
│                                     │
│  ─────────────────────────────     │
│                                     │
│  Desired Dose           0.50 mg    │
│  ●━━━━━━━━━━━━━━━○━━━━━━━━        │ ← Slider
│                                     │
│  Injection Volume                   │
│    0.100 ml • 10.0 units           │
│                                     │
│  Doses per Vial                     │
│    20.0 doses                       │
│                                     │
└─────────────────────────────────────┘
```

## Compound Picker Modal

```
┌─────────────────────────────────────┐
│  Select Compound        [ Cancel ]  │
├─────────────────────────────────────┤
│  🔍 Search peptides...              │
│                                     │
│  Featured                           │
│  ┌──────────┬──────────┐           │
│  │Retatru-  │Tirzepa-  │           │
│  │  tide    │  tide    │           │
│  └──────────┴──────────┘           │
│  ┌──────────┬──────────┐           │
│  │  NAD+    │   GLOW   │           │
│  │          │ Cocktail │           │
│  └──────────┴──────────┘           │
│  ┌──────────┐                      │
│  │  KLOW    │                      │
│  │ Cocktail │                      │
│  └──────────┘                      │
│                                     │
│  ─────────────────────────────     │
│                                     │
│  [ All | Cocktails | Regular ]     │ ← Category filter
│                                     │
│  ┌───────────────────────────┐     │
│  │ Semaglutide            ›  │     │
│  │ 5 mg vial • 5 mg/ml       │     │
│  └───────────────────────────┘     │
│                                     │
│  ┌───────────────────────────┐     │
│  │ BPC157                 ›  │     │
│  │ 10 mg vial • 4 mg/ml      │     │
│  └───────────────────────────┘     │
│                                     │
│  ┌───────────────────────────┐     │
│  │ GLOW 10/10/50  [Cocktail] │     │
│  │ 70 mg vial • 7 mg/ml   ›  │     │
│  └───────────────────────────┘     │
│                                     │
│  ... (scrollable list)              │
│                                     │
└─────────────────────────────────────┘
```

## Key Visual Changes

### Typography
- **Before**: Centered badge "RECONSTITUTION CALCULATOR" + "Peptide Dosing" heading
- **After**: Left-aligned "f(x) Reconstitution Calculator" (single heading)

### Input Fields
- **Before**: Icons (syringe, drop, target) with labels
- **After**: Simple labels with inline units (mg, mg/ml)

### Results Display
- **Before**: Multiple rows (concentration, draw volume, units, device, doses, monthly)
- **After**: Large bac water result, dose slider, injection volume, doses per vial

### Removed Elements
- ❌ Frequency segmented control
- ❌ Device picker button
- ❌ Monthly supply calculation
- ❌ Syringe visual guide
- ❌ Suggestions card
- ❌ Warnings card
- ❌ Complex result rows

### New Elements
- ✅ Compound selection button
- ✅ Large bacteriostatic water display
- ✅ Dose slider with live updates
- ✅ Compound picker modal with search

## User Interaction Flow

```
1. TAP "Select Compound"
   └─→ Modal opens

2. CHOOSE peptide (featured button OR search)
   └─→ Modal closes
   └─→ Vial size & concentration auto-fill

3. (Optional) EDIT vial size or concentration

4. TAP "Calculate"
   └─→ Bacteriostatic water displays

5. SLIDE dose slider
   └─→ Injection volume updates live
   └─→ Doses per vial updates live
```

## Screen States

### Initial State
```
f(x) Reconstitution Calculator

Compound
┌─────────────────────┐
│ Select Compound  ▼  │
└─────────────────────┘
```

### After Compound Selected
```
f(x) Reconstitution Calculator

Compound
┌─────────────────────┐
│ Tirzepatide      ▼  │
└─────────────────────┘

Vial Size
┌─────────────────────┐
│ [30]           mg   │
└─────────────────────┘

Desired Concentration
┌─────────────────────┐
│ [10.0]         mg/ml│
└─────────────────────┘

┌─────────────────────┐
│     Calculate       │
└─────────────────────┘
```

### After Calculation
```
(All above, plus:)

┌─────────────────────┐
│ Bacteriostatic Water│
│                     │
│    3.00 ml          │
└─────────────────────┘

────────────────────────

Desired Dose    5.00 mg
●━━━━━━○━━━━━━━━━━━━━

Injection Volume
  0.500 ml • 50.0 units

Doses per Vial
  6.0 doses
```

## Design Tokens Used

### Spacing
- `DesignTokens.Spacing.sm` (8pt)
- `DesignTokens.Spacing.md` (12pt)
- `DesignTokens.Spacing.lg` (16pt)
- `DesignTokens.Spacing.xl` (20pt)
- `DesignTokens.Spacing.sectionSpacing` (24pt)

### Typography
- Header: `.system(size: 28, weight: .bold)`
- Labels: `DesignTokens.Typography.labelMedium`
- Values: `DesignTokens.Typography.displaySmall`
- Captions: `DesignTokens.Typography.caption`

### Colors
- Background: `ColorTokens.backgroundGrouped`
- Cards: `ColorTokens.backgroundPrimary`
- Primary text: `ColorTokens.foregroundPrimary`
- Secondary text: `ColorTokens.foregroundSecondary`
- Brand: `ColorTokens.brandPrimary`
- Borders: `ColorTokens.borderPrimary`

### Corner Radius
- Fields: `DesignTokens.CornerRadius.md` (12pt)
- Cards: `DesignTokens.CornerRadius.lg` (16pt)
- Pills: `DesignTokens.CornerRadius.pill` (100pt)

---

**Visual Guide Version**: 1.0
**Last Updated**: 2025-10-21
