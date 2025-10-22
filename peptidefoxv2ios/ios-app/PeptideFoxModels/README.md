# PeptideFox iOS Data Models

Complete Swift 6.0 data model implementation with strict concurrency compliance for the PeptideFox iOS application.

## Architecture Overview

All models are designed with Swift 6.0 concurrency in mind:
- ✅ All types conform to `Sendable`
- ✅ Value types (structs/enums) used throughout
- ✅ No force-unwraps or implicitly unwrapped optionals
- ✅ Comprehensive `Codable` implementations
- ✅ Proper error handling with typed errors

## File Structure

```
PeptideFoxModels/
└── Core/
    └── Domain/
        └── Models/
            ├── Enums.swift         # Core enumerations
            ├── ValueTypes.swift     # Value type definitions
            ├── Peptide.swift        # Peptide entity
            ├── Protocol.swift       # Protocol system & state machine
            ├── Validation.swift     # Validation models
            ├── Device.swift         # Injection device models
            ├── Calculator.swift     # Dosing calculator models
            └── Supply.swift         # Supply planning models
```

## Core Models

### 1. **Enums.swift**
Essential enumerations used throughout the app:
- `ProtocolState`: Draft, Active, Completed states
- `DoseUnit`: mg, mcg, IU measurements
- `DeviceType`: Syringe and pen types
- `TimeOfDay`: Injection timing preferences
- `FrequencyPattern`: Daily, weekly, custom schedules
- `PeptideCategory`: Classification by function
- `EvidenceLevel`: Clinical evidence strength
- `CostLevel`: Relative cost categories
- Validation and suggestion types

### 2. **ValueTypes.swift**
Core value types for protocol configuration:
- `FrequencySchedule`: Injection frequency patterns
- `PeptideDosePlan`: Complete dosing configuration
- `PeptideTiming`: Administration timing rules
- `PeptideSupplyPlan`: Supply and reconstitution info
- `PhaseAssignment`: Protocol phase assignments
- `PeptideColorScheme`: Visual styling
- `ActiveProtocolSnapshot`: Activation state capture

### 3. **Peptide.swift**
The core `Peptide` struct representing peptide compounds:
- Clinical data (mechanism, benefits, contraindications)
- Dosing information (typical dose, frequency, cycle length)
- Safety data (evidence level, cost, risk profile)
- Visual styling (color scheme for UI)
- Relationship data (synergies with other peptides)
- Full `Identifiable`, `Codable`, `Sendable`, `Hashable` conformance

### 4. **Protocol.swift**
Complete protocol system with state machine:
- `ProtocolPeptide`: Peptide configured for protocol use
- `ProtocolPhase`: Time-based protocol phases
- `ProtocolMetadata`: Goals and classification
- `ProtocolBase`: Shared protocol structure
- `ProtocolDraft`, `ProtocolActive`, `ProtocolCompleted`: State-specific types
- `ProtocolRecord`: Discriminated union for any state
- State transition methods (activate, complete, createDraft)

### 5. **Validation.swift**
Protocol validation and safety checking:
- `ValidationIssue`: Individual validation problems
- `ValidationResult`: Complete validation outcome
- `SafetyLimits`: Maximum doses, device limits, interactions
- `ValidationContext`: Context for validation rules
- `ValidationHelpers`: Factory methods for common issues
- `UserProfile`: User data for personalized validation

### 6. **Device.swift**
Injection device models and recommendations:
- `Device`: Complete device specifications
- `SyringeVisual`: Visual representation for UI
- `Suggestion`: Optimization suggestions
- `SuggestionAction`: Actionable improvements
- `DeviceRecommendation`: Device selection logic
- Common device presets (30/50/100 unit syringes, pens)

### 7. **Calculator.swift**
Dosing calculation models:
- `CalculatorInput`: Calculation parameters
- `CalculatorOutput`: Complete calculation results
- `CalculatorError`: Typed calculation errors with recovery suggestions
- `CalculationPreset`: Common calculation templates
- Formatted output helpers for UI display

### 8. **Supply.swift**
Supply planning and inventory management:
- `SupplyInput`/`SupplyOutput`: Supply calculations
- `SupplyPlan`: Complete protocol supply plan
- `InventoryItem`: Vial inventory tracking
- `ReorderAlert`: Smart reorder notifications
- Cost estimation and budget tracking

## Key Features

### Swift 6.0 Concurrency
- All types are `Sendable` for safe concurrent access
- No `@MainActor` annotations on data models (only on UI-bound types)
- Value semantics throughout for thread safety

### Type Safety
- Comprehensive enum cases with associated values
- No stringly-typed APIs
- Proper optional handling
- Typed errors with recovery suggestions

### Codable Compliance
- Custom coding keys where needed
- Proper handling of nested types
- Backwards compatibility considerations
- ISO-8601 date formatting

### Computed Properties
- Formatted display strings
- Validation helpers
- State checks
- Derived calculations

## Usage Examples

```swift
// Create a peptide
let bpc157 = Peptide(
    id: "bpc-157",
    name: "BPC-157",
    category: .healing,
    description: "Body Protective Compound",
    // ... other properties
)

// Create a protocol
let protocolBase = ProtocolBase(
    name: "Healing Protocol",
    metadata: ProtocolMetadata(goal: "Tissue Recovery"),
    peptides: [protocolPeptide],
    phases: [healingPhase]
)

// Create a draft
let draft = ProtocolDraft(
    base: protocolBase,
    validation: ValidationResult.empty
)

// Wrap in discriminated union
let record = ProtocolRecord.draft(draft)

// State transitions
if let activated = record.activate() {
    // Protocol is now active
}
```

## Testing Considerations

All models include:
- Sample data for previews (`Peptide.sampleBPC157`)
- Validation methods for input checking
- Error cases with descriptive messages
- Formatted output helpers for UI testing

## Next Steps

With these models complete, the next implementation phases would be:
1. **Services Layer**: Validators, calculators, storage managers
2. **Repository Layer**: Data persistence with UserDefaults/CoreData
3. **ViewModels**: ObservableObject implementations for SwiftUI
4. **Views**: SwiftUI components using the models
5. **Networking**: API integration for peptide data updates

## Compatibility

- **Swift**: 6.0+
- **iOS**: 17.0+ (for latest SwiftUI features)
- **macOS**: 14.0+ (if building for Mac)
- **Xcode**: 16.0+
