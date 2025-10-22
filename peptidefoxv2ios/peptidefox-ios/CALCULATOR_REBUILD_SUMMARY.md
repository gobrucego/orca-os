# iOS Calculator Rebuild - Summary

## What Changed

The iOS Calculator tab has been completely rebuilt to match the website's **Reconstitution Calculator** design and functionality.

## Key Changes

### 1. Removed Features (Incorrect for Reconstitution Calculator)
- ❌ Frequency selection (Daily/Weekly/Twice Weekly)
- ❌ Device picker (Pen/Syringe selection)
- ❌ Supply planning features
- ❌ "Peptide Dosing" heading
- ❌ Centered "RECONSTITUTION CALCULATOR" badge
- ❌ Monthly supply calculations
- ❌ Syringe visual guide

### 2. New Features (Correct Flow)

#### Step 1: Compound Selection
- **Featured buttons**: Retatrutide, Tirzepatide, NAD+, GLOW, KLOW (2x2 grid)
- **Searchable dropdown**: All other peptides with category filters
  - All / Cocktails / Regular filter tabs
  - Search functionality
  - Shows vial size and concentration hints

#### Step 2: Reconstitution Calculator
1. **Vial Size** (mg) - editable, pre-populated from compound selection
2. **Desired Concentration** (mg/ml) - user enters target concentration
3. **Calculate button** → Shows **Bacteriostatic Water** amount (ml)

**Formula**: `bacWater (ml) = vialSize (mg) / concentration (mg/ml)`

#### Step 3: Dosing Info (after calculation)
- **Dose Slider** - user adjusts desired dose (mg)
- Shows **Injection Volume** (ml and units)
- Shows **Doses per Vial**

**Formulas**:
- `injectionVolume = desiredDose / concentration`
- `dosesPerVial = vialSize / desiredDose`

### 3. Typography/Layout Updates
- ✅ **Single heading**: "f(x) Reconstitution Calculator" (left-aligned with function icon)
- ✅ All content left-aligned (no centered badges)
- ✅ Clean, minimal design matching website

## Files Modified

### Core Files
1. **CalculatorView.swift** (`/peptidefox-ios/PeptideFox/Core/Presentation/Calculator/CalculatorView.swift`)
   - Completely rebuilt UI with new flow
   - Removed device picker, frequency selection, supply planning
   - Added compound selection button
   - Simplified results to show: Bac Water, Dose Slider, Injection Volume, Doses per Vial

2. **CalculatorViewModel.swift** (`/peptidefox-ios/PeptideFox/Core/ViewModels/CalculatorViewModel.swift`)
   - Removed CalculatorEngine dependency
   - Added CommonPeptide struct with 28 peptides from website
   - New properties: selectedCompound, concentration, bacWater, hasCalculated
   - New methods: selectCompound(), calculateBacWater()
   - Removed frequency-based calculations

### New Files
3. **CompoundPickerView.swift** (`/peptidefox-ios/PeptideFox/Core/Presentation/Calculator/CompoundPickerView.swift`)
   - Modal sheet for compound selection
   - Featured compounds in 2x2 grid
   - Category filter tabs (All / Cocktails / Regular)
   - Searchable list with compound details
   - Auto-populates vial size and concentration on selection

## Peptide Database

Added 28 common peptides with defaults (matching website's `commonPeptides` array):

### Featured (5)
- Retatrutide, Tirzepatide, NAD+, GLOW, KLOW

### Cocktails (3)
- GLOW 5/10/30, GLOW 10/10/50, KLOW 10/10/10/50

### Regular Peptides (25)
- Semaglutide, SS-31, MOTS-c, 5-Amino-1MQ
- BPC157, TB500/TB4, GHK-Cu, KPV, Cartalax, ARA-290
- Adamax, Semax, Selank, P21, Pinealon
- Tesamorelin, Sermorelin, Ipamorelin, hGH
- Kisspeptin-10, hCG
- Thymosin α-1, VIP, Epitalon, DSIP
- AOD9604, L-Carnitine

## User Flow

1. **Tap "Select Compound"** → Opens CompoundPickerView
2. **Choose peptide** → Auto-fills vial size & concentration
3. **Adjust values if needed** (vial size & concentration are editable)
4. **Tap "Calculate"** → Shows Bacteriostatic Water amount
5. **Adjust dose slider** → See injection volume & doses per vial update

## Testing Checklist

- [x] Compound picker opens with featured buttons
- [x] Search and filter work correctly
- [x] Selecting compound auto-fills vial size and concentration
- [x] Calculate button shows bacteriostatic water amount
- [x] Dose slider updates injection volume and doses per vial
- [x] Typography is clean (f(x) heading, left-aligned)
- [x] No frequency, device, or supply features visible
- [x] Reset button clears all state

## Technical Notes

### Design Patterns
- **@Observable** for ViewModel (Swift 6.0)
- **@State** for view-local state
- **@Binding** for CompoundPickerView
- **Computed properties** for reactive calculations

### Calculations
All calculations are done in ViewModel computed properties:
- `bacWater = vialSize / concentration`
- `injectionVolume = desiredDose / concentration`
- `dosesPerVial = vialSize / desiredDose`

### Data Structure
```swift
struct CommonPeptide {
    let name: String
    let defaultConcentration: Double
    let defaultVialSize: Double
    let defaultDose: Double
    let isCocktail: Bool
    let category: PeptideCategory // .featured, .cocktail, .regular
}
```

## Migration Notes

### Old Approach (Removed)
- Used `CalculatorEngine` actor with complex device compatibility logic
- Frequency schedules with injection patterns
- Supply planning with monthly vial calculations
- Device picker with syringe/pen types
- Suggestions and warnings system

### New Approach (Current)
- Simple reconstitution-only calculator
- Direct formula calculations in ViewModel
- Compound selection with auto-population
- Dose slider for dosing info
- Clean, minimal UI

## Future Enhancements

Potential additions (NOT in current scope):
- Save favorite compounds
- Calculation history
- Custom compound creation
- Unit conversion (IU, mcg, etc.)
- Storage instructions per compound
- Cocktail composition breakdown

---

**Built**: 2025-10-21
**Reference**: Website calculator at `/app/tools/calculator/page.tsx`
**Peptide data**: From `features/peptide/lib/peptideCalculations.ts` (commonPeptides array)
