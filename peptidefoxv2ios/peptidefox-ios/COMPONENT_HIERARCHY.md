# PeptideFox Component Hierarchy

## Application Structure

```
PeptideFoxApp
    │
    └── ContentView (TabView)
            │
            ├── Tab 1: CalculatorView
            │       │
            │       ├── Header
            │       │   └── Badge ("RECONSTITUTION CALCULATOR")
            │       │
            │       ├── Input Form (PFCard)
            │       │   ├── PFNumberField (Vial Size)
            │       │   ├── PFNumberField (Reconstitution Volume)
            │       │   ├── PFNumberField (Target Dose)
            │       │   └── Picker (Frequency)
            │       │
            │       ├── PFButton.primary (Calculate)
            │       │
            │       ├── Results View (if calculated)
            │       │   ├── PFCard (Results)
            │       │   │   ├── ResultRow (Concentration)
            │       │   │   ├── ResultRow (Draw Volume) [highlighted]
            │       │   │   ├── ResultRow (Syringe Units)
            │       │   │   ├── Device Button → DevicePickerView (sheet)
            │       │   │   ├── ResultRow (Doses Per Vial)
            │       │   │   └── ResultRow (Monthly Supply)
            │       │   │
            │       │   ├── SyringeVisualView (PFCard)
            │       │   │   ├── Header
            │       │   │   ├── Syringe Drawing (GeometryReader)
            │       │   │   │   ├── Barrel outline
            │       │   │   │   ├── Fill level indicator
            │       │   │   │   ├── Markings (0, 10, 20...)
            │       │   │   │   └── Fill level label
            │       │   │   └── Instructions list
            │       │   │
            │       │   ├── Suggestions (if any)
            │       │   │   └── PFCard
            │       │   │       └── SuggestionRow (for each)
            │       │   │           ├── Icon + Title
            │       │   │           ├── Message
            │       │   │           └── Action cards
            │       │   │
            │       │   └── Warnings (if any)
            │       │       └── PFCard
            │       │           └── Warning rows
            │       │
            │       └── Error View (if error)
            │           └── PFCard
            │               ├── Error message
            │               └── Recovery suggestion
            │
            ├── Tab 2: PeptideLibraryView
            │       │
            │       ├── Category Filter (horizontal scroll)
            │       │   ├── CategoryChip (All)
            │       │   └── CategoryChip (for each category)
            │       │       ├── Title
            │       │       └── Count badge
            │       │
            │       ├── SearchBar (native SwiftUI)
            │       │
            │       ├── Peptide Grid (LazyVGrid)
            │       │   └── PeptideCardView (for each peptide)
            │       │       ├── PFBadge (category)
            │       │       ├── Name
            │       │       ├── Description (3 lines)
            │       │       └── Footer
            │       │           ├── Evidence level
            │       │           └── Chevron
            │       │
            │       └── Empty State (if no results)
            │           └── PFEmptyState
            │               ├── Icon
            │               ├── Title
            │               ├── Message
            │               └── Action button
            │
            ├── Tab 3: Protocols (placeholder)
            │       └── PFEmptyState
            │
            └── Tab 4: Profile (placeholder)
                    └── PFEmptyState
```

## Detail View Hierarchy

```
PeptideDetailView
    │
    ├── Hero Section (PFCard)
    │   ├── Header row
    │   │   ├── PFBadge (category)
    │   │   └── Evidence level
    │   ├── Name (display size)
    │   └── Description
    │
    ├── Mechanism Section (PFCard)
    │   ├── PFSectionHeader
    │   └── Mechanism text
    │
    ├── Dosing Section (PFCard)
    │   ├── PFSectionHeader
    │   └── Info rows
    │       ├── InfoRow (Typical Dose)
    │       ├── InfoRow (Frequency)
    │       └── InfoRow (Cycle Length)
    │
    ├── Benefits Section (PFCard)
    │   ├── PFSectionHeader
    │   └── Benefit rows
    │       └── Checkmark + Text (for each)
    │
    ├── Protocol Section (PFCard, collapsible)
    │   ├── Toggle button
    │   └── Content (if expanded)
    │       ├── Description
    │       ├── Divider
    │       └── Info rows
    │
    ├── Contraindications Section (PFCard, collapsible)
    │   ├── Toggle button (warning icon)
    │   └── Content (if expanded)
    │       └── X-mark + Text (for each)
    │
    ├── Signals Section (PFCard)
    │   ├── PFSectionHeader
    │   └── Signal rows
    │       └── Sparkles + Text (for each)
    │
    ├── Synergies Section (PFCard, if has synergies)
    │   ├── PFSectionHeader
    │   └── Horizontal scroll
    │       └── SynergyChip (NavigationLink)
    │           ├── Peptide name
    │           └── Category
    │
    └── Action Button
        └── PFButton.primary (Add to Protocol)
```

## Sheet/Modal Hierarchy

```
DevicePickerView (sheet)
    │
    └── NavigationStack
        ├── Title ("Injection Devices")
        ├── Toolbar (Done button)
        └── List (inset grouped)
            └── DeviceRow (for each device)
                ├── Device icon (circle)
                ├── Info column
                │   ├── Name
                │   ├── Specs (max volume, units)
                │   └── Precision
                └── Checkmark (if selected)
```

## Component Reusability Map

```
PFCard
├── Used in: CalculatorView (input form, results, suggestions, warnings)
├── Used in: PeptideDetailView (all sections)
└── Used in: SyringeVisualView

PFButton
├── .primary → CalculatorView (calculate), PeptideDetailView (add to protocol)
├── .outline → (available for future use)
└── .secondary → (available for future use)

PFBadge
├── Used in: CalculatorView (header)
├── Used in: PeptideCardView
└── Used in: PeptideDetailView (hero)

PFNumberField
└── Used in: CalculatorView (3x: vial, water, dose)

PFSectionHeader
└── Used in: PeptideDetailView (5x: mechanism, dosing, benefits, signals, synergies)

PFEmptyState
├── Used in: PeptideLibraryView (no results)
├── Used in: ProtocolsPlaceholderView
└── Used in: ProfilePlaceholderView

ResultRow
└── Used in: CalculatorView (5x: concentration, draw volume, units, doses, vials)

InfoRow
└── Used in: PeptideDetailView (6x: dose, frequency, cycle, duration, frequency again)

SuggestionRow
└── Used in: CalculatorView (suggestions section)

CategoryChip
└── Used in: PeptideLibraryView (category filter)

SynergyChip
└── Used in: PeptideDetailView (synergies section)
```

## State Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    User Interaction                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  View (SwiftUI)                             │
│  - CalculatorView                                           │
│  - PeptideLibraryView                                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ @State binding
                              │
┌─────────────────────────────────────────────────────────────┐
│               ViewModel (@Observable)                       │
│  - CalculatorViewModel                                      │
│    • vialSize: Double                                       │
│    • reconstitutionVolume: Double                           │
│    • targetDose: Double                                     │
│    • output: CalculatorOutput?                              │
│                                                              │
│  - PeptideLibraryViewModel                                  │
│    • searchQuery: String                                    │
│    • selectedCategory: PeptideCategory?                     │
│    • filteredPeptides: [Peptide] (computed)                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ async call
                              │
┌─────────────────────────────────────────────────────────────┐
│                Engine (Actor)                               │
│  - CalculatorEngine                                         │
│    func calculate(input:) async throws -> CalculatorOutput │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ data access
                              │
┌─────────────────────────────────────────────────────────────┐
│              Database (Struct)                              │
│  - PeptideDatabase                                          │
│    static let all: [Peptide]                                │
│    static func search(query:) -> [Peptide]                  │
│    static func peptides(in:) -> [Peptide]                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ result
                              │
┌─────────────────────────────────────────────────────────────┐
│             ViewModel (state update)                        │
│  @Observable property changed                               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ automatic
                              │
┌─────────────────────────────────────────────────────────────┐
│              View (re-render)                               │
│  Only affected views update                                 │
└─────────────────────────────────────────────────────────────┘
```

## Dependency Graph

```
Views
  │
  ├── CalculatorView
  │   ├── depends on: CalculatorViewModel
  │   ├── depends on: DesignTokens
  │   ├── depends on: ColorTokens
  │   ├── depends on: PFCard
  │   ├── depends on: PFButton
  │   ├── depends on: PFNumberField
  │   ├── uses: DevicePickerView (sheet)
  │   ├── uses: SyringeVisualView
  │   └── uses: ResultRow, SuggestionRow
  │
  ├── PeptideLibraryView
  │   ├── depends on: PeptideLibraryViewModel
  │   ├── depends on: DesignTokens
  │   ├── depends on: ColorTokens
  │   ├── depends on: PFEmptyState
  │   ├── uses: CategoryChip
  │   └── uses: PeptideCardView
  │
  └── PeptideDetailView
      ├── depends on: Peptide (model)
      ├── depends on: PeptideDatabase
      ├── depends on: DesignTokens
      ├── depends on: ColorTokens
      ├── depends on: PFCard
      ├── depends on: PFButton
      ├── depends on: PFBadge
      ├── depends on: PFSectionHeader
      ├── uses: InfoRow
      └── uses: SynergyChip

ViewModels
  │
  ├── CalculatorViewModel
  │   ├── depends on: CalculatorEngine
  │   ├── depends on: CalculatorInput
  │   ├── depends on: CalculatorOutput
  │   ├── depends on: FrequencySchedule
  │   └── depends on: CalculatorError
  │
  └── PeptideLibraryViewModel
      ├── depends on: PeptideDatabase
      ├── depends on: Peptide
      └── depends on: PeptideCategory

Engines
  │
  └── CalculatorEngine (actor)
      ├── depends on: CalculatorInput
      ├── depends on: CalculatorOutput
      ├── depends on: Device
      ├── depends on: FrequencySchedule
      └── depends on: Suggestion

Data
  │
  └── PeptideDatabase
      ├── depends on: Peptide
      ├── depends on: PeptideCategory
      ├── depends on: DoseRange
      └── depends on: EvidenceLevel

Design System
  │
  ├── DesignTokens
  │   └── NO dependencies (base layer)
  │
  ├── ColorTokens
  │   └── NO dependencies (base layer)
  │
  └── ComponentStyles
      ├── depends on: DesignTokens
      ├── depends on: ColorTokens
      └── depends on: PeptideCategory (for PFBadge)
```

## Navigation Flow

```
App Launch
    │
    └─→ ContentView (TabView)
            │
            ├─→ Tab 1: CalculatorView
            │       │
            │       └─→ Sheet: DevicePickerView
            │
            ├─→ Tab 2: PeptideLibraryView
            │       │
            │       └─→ NavigationLink → PeptideDetailView
            │               │
            │               └─→ NavigationLink → PeptideDetailView (synergy)
            │
            ├─→ Tab 3: Protocols (placeholder)
            │
            └─→ Tab 4: Profile (placeholder)
```

## Accessibility Tree

```
CalculatorView
├─ Header (accessibility: informative)
│  └─ "Reconstitution Calculator" badge
├─ Form (accessibility: grouped)
│  ├─ Number Field: "Vial size in milligrams"
│  ├─ Number Field: "Reconstitution volume in milliliters"
│  ├─ Number Field: "Target dose in milligrams"
│  └─ Picker: "Dosing frequency"
├─ Button: "Calculate dose" (hint: "Tap to calculate reconstitution")
└─ Results (accessibility: article region)
   ├─ ResultRow: "Concentration: 5.0 mg/ml, 10 mg in 2 ml"
   ├─ ResultRow: "Draw Volume: 0.05 ml, For 0.25 mg dose"
   └─ etc.

PeptideLibraryView
├─ Category Filter (accessibility: tab list)
│  ├─ "All category, 8 peptides, selected"
│  ├─ "GLP-1 category, 2 peptides"
│  └─ etc.
├─ Search Field: "Search peptides"
└─ Grid (accessibility: list)
   └─ Card: "Semaglutide, GLP-1, GLP-1 receptor agonist..., Tap to view details"
```

This comprehensive hierarchy shows how all 13 view files, 2 view models, design system, and data layer connect to create the complete PeptideFox iOS application.
