# iOS Calculator - Quick Reference

## One-Line Summary
**Reconstitution-only calculator**: Select compound → Enter vial size & concentration → Calculate bac water → Adjust dose slider.

## File Locations

```
peptidefox-ios/PeptideFox/
├── Core/
│   ├── Presentation/
│   │   └── Calculator/
│   │       ├── CalculatorView.swift          ← Main view (MODIFIED)
│   │       └── CompoundPickerView.swift      ← Modal picker (NEW)
│   └── ViewModels/
│       └── CalculatorViewModel.swift         ← Logic + data (MODIFIED)
```

## Key Formulas

```swift
// Step 1: Calculate Bacteriostatic Water
bacWater (ml) = vialSize (mg) / concentration (mg/ml)

// Step 2: Calculate Injection Volume (from dose slider)
injectionVolume (ml) = desiredDose (mg) / concentration (mg/ml)

// Step 3: Calculate Doses per Vial
dosesPerVial = vialSize (mg) / desiredDose (mg)

// Unit Conversion
units = ml × 100  // (100 units = 1 ml)
```

## Example Calculations

### Tirzepatide
- Vial: 30 mg
- Concentration: 10 mg/ml
- **Bac Water**: 30 / 10 = **3.00 ml**
- Dose: 5 mg
- **Injection Volume**: 5 / 10 = **0.500 ml** (50 units)
- **Doses per Vial**: 30 / 5 = **6 doses**

### Semaglutide
- Vial: 5 mg
- Concentration: 5 mg/ml
- **Bac Water**: 5 / 5 = **1.00 ml**
- Dose: 0.5 mg
- **Injection Volume**: 0.5 / 5 = **0.100 ml** (10 units)
- **Doses per Vial**: 5 / 0.5 = **10 doses**

### NAD+
- Vial: 500 mg
- Concentration: 100 mg/ml
- **Bac Water**: 500 / 100 = **5.00 ml**
- Dose: 100 mg
- **Injection Volume**: 100 / 100 = **1.000 ml** (100 units)
- **Doses per Vial**: 500 / 100 = **5 doses**

## ViewModel API

```swift
class CalculatorViewModel {
    // Selection
    var selectedCompound: CommonPeptide?
    
    // Inputs
    var vialSize: Double
    var concentration: Double
    var desiredDose: Double
    
    // Outputs (Computed)
    var bacWater: Double { vialSize / concentration }
    var injectionVolume: Double { desiredDose / concentration }
    var dosesPerVial: Double { vialSize / desiredDose }
    
    // State
    var hasCalculated: Bool
    var canCalculate: Bool { vialSize > 0 && concentration > 0 }
    var error: String?
    
    // Actions
    func selectCompound(_ compound: CommonPeptide)
    func calculateBacWater()
    func reset()
}
```

## Peptide Categories

### Featured (5) - Grid Buttons
- Retatrutide, Tirzepatide, NAD+, GLOW, KLOW

### Cocktails (3) - Dropdown
- GLOW 5/10/30, GLOW 10/10/50, KLOW 10/10/10/50

### Regular (25) - Dropdown
- All other peptides (Semaglutide, BPC157, etc.)

## UI Components

```swift
// Main View
CalculatorView
├── Header: "f(x) Reconstitution Calculator"
├── Compound Selection Button
├── Input Fields (if compound selected)
│   ├── Vial Size (mg)
│   └── Concentration (mg/ml)
├── Calculate Button (if canCalculate)
└── Results (if hasCalculated)
    ├── Bacteriostatic Water (large display)
    ├── Dose Slider
    ├── Injection Volume (ml + units)
    └── Doses per Vial

// Modal
CompoundPickerView
├── Search Bar
├── Featured Compounds (2x2 grid)
├── Category Filter (All/Cocktails/Regular)
└── Compound List (scrollable)
```

## Common Issues & Solutions

### Issue: Calculate button disabled
**Solution**: Ensure vialSize > 0 AND concentration > 0

### Issue: No results showing after Calculate
**Solution**: Check `hasCalculated` flag is set to true

### Issue: Slider doesn't update values
**Solution**: Verify computed properties are reactive (@Observable)

### Issue: Compound selection doesn't auto-fill
**Solution**: Check `selectCompound()` method sets all values

### Issue: Math looks wrong
**Solution**: Verify formulas match above (especially division order)

## Testing Quick Checks

```bash
# Test 1: Tirzepatide
Compound: Tirzepatide
Vial: 30 mg, Concentration: 10 mg/ml
Expected Bac Water: 3.00 ml ✓
Dose: 5 mg → Injection: 0.500 ml, Doses: 6 ✓

# Test 2: Semaglutide
Compound: Semaglutide
Vial: 5 mg, Concentration: 5 mg/ml
Expected Bac Water: 1.00 ml ✓
Dose: 0.5 mg → Injection: 0.100 ml, Doses: 10 ✓

# Test 3: BPC157
Compound: BPC157
Vial: 10 mg, Concentration: 4 mg/ml
Expected Bac Water: 2.50 ml ✓
Dose: 0.5 mg → Injection: 0.125 ml, Doses: 20 ✓
```

## What's Removed (Don't Look For)

- ❌ Frequency picker (Daily/Weekly/etc.)
- ❌ Device type selection (Pen/Syringe)
- ❌ Monthly supply calculations
- ❌ Days per vial
- ❌ Syringe visual guide
- ❌ Suggestions card
- ❌ Warnings card
- ❌ "Peptide Dosing" heading
- ❌ Centered badges

## Design Tokens Quick Ref

```swift
// Spacing
DesignTokens.Spacing.sm      // 8pt
DesignTokens.Spacing.md      // 12pt
DesignTokens.Spacing.lg      // 16pt
DesignTokens.Spacing.xl      // 20pt

// Typography
DesignTokens.Typography.displaySmall    // 24pt light
DesignTokens.Typography.headlineSmall   // 16pt semibold
DesignTokens.Typography.bodyLarge       // 16pt regular
DesignTokens.Typography.labelMedium     // 12pt medium

// Colors
ColorTokens.backgroundGrouped     // Page background
ColorTokens.backgroundPrimary     // Card background
ColorTokens.foregroundPrimary     // Main text
ColorTokens.foregroundSecondary   // Label text
ColorTokens.brandPrimary          // Blue (buttons, highlights)

// Corner Radius
DesignTokens.CornerRadius.md      // 12pt
DesignTokens.CornerRadius.lg      // 16pt
```

## Debugging Commands

```bash
# Check file exists
ls -la peptidefox-ios/PeptideFox/Core/Presentation/Calculator/

# View ViewModel
cat peptidefox-ios/PeptideFox/Core/ViewModels/CalculatorViewModel.swift

# Count peptides in database
grep "CommonPeptide(name:" peptidefox-ios/PeptideFox/Core/ViewModels/CalculatorViewModel.swift | wc -l
# Should output: 36 (28 in array + 8 in struct definition)
```

## Next Steps After Testing

1. Verify all calculations match website exactly
2. Test with real peptide vials (if available)
3. Add analytics tracking (optional)
4. Consider saving last-used compound (optional)
5. Add haptic feedback for slider (optional)

---

**Version**: 1.0
**Last Updated**: 2025-10-21
**Status**: ✅ Ready for Testing
