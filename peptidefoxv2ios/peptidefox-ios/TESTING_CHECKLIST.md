# iOS Calculator Testing Checklist

## Pre-Testing Setup
- [ ] Build project in Xcode
- [ ] Verify no compilation errors
- [ ] Run on simulator (iOS 17+)
- [ ] Run on actual device (optional)

## Unit Tests (If Applicable)
- [ ] Verify bacWater calculation: `vialSize / concentration`
- [ ] Verify injectionVolume calculation: `desiredDose / concentration`
- [ ] Verify dosesPerVial calculation: `vialSize / desiredDose`

## UI Testing

### Initial State
- [ ] Calculator tab opens
- [ ] Shows "f(x) Reconstitution Calculator" heading (left-aligned)
- [ ] Shows "Select Compound" button
- [ ] NO input fields visible until compound selected
- [ ] Reset button visible in navigation bar

### Compound Selection
- [ ] Tap "Select Compound" opens modal
- [ ] Modal shows navigation title "Select Compound"
- [ ] Cancel button works
- [ ] Featured section shows 5 compounds in grid
  - [ ] Retatrutide
  - [ ] Tirzepatide
  - [ ] NAD+
  - [ ] GLOW (labeled as Cocktail)
  - [ ] KLOW (labeled as Cocktail)
- [ ] Category filter shows: All, Cocktails, Regular
- [ ] Search bar functional
- [ ] List shows compound details (vial size, concentration)

### Featured Compound Selection
- [ ] Tap "Retatrutide" → modal closes
- [ ] Vial size auto-fills to 10 mg
- [ ] Concentration auto-fills to 3.3 mg/ml
- [ ] Input fields become visible
- [ ] Calculate button appears

### Cocktail Selection
- [ ] Tap "GLOW" → modal closes
- [ ] Vial size shows 80 mg
- [ ] Concentration shows 10 mg/ml
- [ ] "Cocktail" badge visible in list

### Regular Peptide Selection
- [ ] Filter to "Regular" category
- [ ] GLOW and KLOW not visible
- [ ] Tap "Semaglutide" → auto-fills 5mg vial, 5mg/ml
- [ ] Tap "BPC157" → auto-fills 10mg vial, 4mg/ml

### Search Functionality
- [ ] Type "Sema" → filters to Semaglutide
- [ ] Type "BPC" → shows BPC157
- [ ] Type "GLOW" → shows GLOW variants
- [ ] Clear search → shows all

### Input Editing
- [ ] Vial size field is editable after selection
- [ ] Concentration field is editable after selection
- [ ] Values persist after editing
- [ ] Keyboard appears for decimal pad

### Calculation Flow
- [ ] With Tirzepatide (30mg @ 10mg/ml) selected
- [ ] Tap "Calculate"
- [ ] Bacteriostatic Water shows: 3.00 ml
- [ ] Result displays prominently in large card
- [ ] Divider appears below

### Dose Slider (Post-Calculation)
- [ ] Dose slider appears after calculation
- [ ] Default dose shows (e.g., 5.0 mg for Tirzepatide)
- [ ] Slider range: 0 to vial size (30mg)
- [ ] Dragging slider updates value smoothly
- [ ] Injection volume updates live
- [ ] Doses per vial updates live

### Live Calculations
- [ ] At 5.0 mg dose:
  - [ ] Injection volume: 0.500 ml (50.0 units)
  - [ ] Doses per vial: 6.0 doses
- [ ] At 10.0 mg dose:
  - [ ] Injection volume: 1.000 ml (100.0 units)
  - [ ] Doses per vial: 3.0 doses
- [ ] At 2.5 mg dose:
  - [ ] Injection volume: 0.250 ml (25.0 units)
  - [ ] Doses per vial: 12.0 doses

### Reset Functionality
- [ ] Tap "Reset" button
- [ ] Selected compound clears
- [ ] Vial size resets to 0
- [ ] Concentration resets to 0
- [ ] Desired dose resets to 0.25
- [ ] Calculation results disappear
- [ ] "Select Compound" button shows again

### Edge Cases
- [ ] Select compound, edit vial size to 0 → Calculate button disabled
- [ ] Select compound, edit concentration to 0 → Calculate button disabled
- [ ] Enter very small dose (0.05 mg) → shows correct injection volume
- [ ] Enter very large dose (equal to vial size) → shows 1.0 doses per vial
- [ ] Switch compounds after calculation → clears previous results

### Accessibility
- [ ] VoiceOver reads "f(x) Reconstitution Calculator"
- [ ] VoiceOver reads "Select Compound" button
- [ ] VoiceOver reads input field labels
- [ ] VoiceOver reads calculation results
- [ ] Dose slider accessible with VoiceOver gestures
- [ ] All buttons have accessibility labels

### UI/UX Verification
- [ ] NO centered badges
- [ ] NO "Peptide Dosing" heading
- [ ] NO frequency picker
- [ ] NO device picker
- [ ] NO monthly supply info
- [ ] NO syringe visual guide
- [ ] NO suggestions card
- [ ] NO warnings card
- [ ] Typography is left-aligned
- [ ] Design is clean and minimal
- [ ] Spacing consistent with DesignTokens

### Performance
- [ ] Compound picker opens quickly
- [ ] Search is responsive
- [ ] Calculations instant
- [ ] Slider smooth (60fps)
- [ ] No lag when switching compounds

### Different Peptides Tests

#### Semaglutide (5mg @ 5mg/ml)
- [ ] Bac water: 1.00 ml
- [ ] At 0.5mg dose: 0.100 ml, 10 doses

#### NAD+ (500mg @ 100mg/ml)
- [ ] Bac water: 5.00 ml
- [ ] At 100mg dose: 1.000 ml, 5 doses

#### BPC157 (10mg @ 4mg/ml)
- [ ] Bac water: 2.50 ml
- [ ] At 0.5mg dose: 0.125 ml, 20 doses

#### GLOW (80mg @ 10mg/ml)
- [ ] Bac water: 8.00 ml
- [ ] At 0.25mg dose: 0.025 ml, 320 doses

### Dark Mode
- [ ] Toggle to dark mode
- [ ] Background colors adapt
- [ ] Text remains readable
- [ ] Brand colors consistent
- [ ] Borders visible

### Landscape Orientation
- [ ] Rotate device to landscape
- [ ] Layout adjusts properly
- [ ] All elements visible
- [ ] No clipping

## Bugs to Watch For

### Common Issues
- [ ] Calculation doesn't show after pressing Calculate
- [ ] Slider doesn't update values
- [ ] Compound selection doesn't auto-fill
- [ ] Reset doesn't clear all fields
- [ ] Search doesn't filter correctly
- [ ] Category filter doesn't work
- [ ] Units conversion incorrect (ml to units)
- [ ] Doses per vial shows decimal when should be integer

### Math Validation
- [ ] Verify: `bacWater = vialSize / concentration`
- [ ] Verify: `injectionVolume = desiredDose / concentration`
- [ ] Verify: `dosesPerVial = vialSize / desiredDose`
- [ ] Verify: units = ml × 100

### State Management
- [ ] Selecting new compound clears previous calculation
- [ ] Reset clears ALL state
- [ ] Navigation away and back preserves nothing (fresh state)

## Regression Testing

### Verify Removals
- [ ] NO frequency controls anywhere
- [ ] NO device type selection
- [ ] NO monthly supply calculations
- [ ] NO "days per vial" display
- [ ] NO "vials per month" display
- [ ] NO syringe visual component
- [ ] NO suggestions section
- [ ] NO warnings section
- [ ] NO device compatibility logic

## Sign-Off

- [ ] All critical tests pass
- [ ] No blocking bugs
- [ ] Calculations verified against website
- [ ] UI matches design specs
- [ ] Ready for production

---

**Test Date**: __________
**Tester**: __________
**Device/Simulator**: __________
**iOS Version**: __________
**Build**: __________
**Result**: ☐ Pass  ☐ Fail  ☐ Blocked

**Notes**:
_______________________________________________
_______________________________________________
_______________________________________________
