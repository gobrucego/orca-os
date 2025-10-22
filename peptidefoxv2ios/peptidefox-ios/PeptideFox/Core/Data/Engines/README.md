# CalculatorEngine Usage Guide

## Overview

`CalculatorEngine` is a thread-safe actor that performs peptide dose calculations, device compatibility checking, and supply planning. It's a complete port of the TypeScript calculator from `lib/protocol/calculator.ts`.

## Basic Usage

```swift
import Foundation

let engine = CalculatorEngine()

// Define your calculation parameters
let input = CalculatorInput(
    vialSize: 10.0,              // 10mg vial
    reconstitutionVolume: 2.0,   // 2ml bacteriostatic water
    targetDose: 0.5,             // 0.5mg per injection
    frequency: FrequencySchedule(
        intervalDays: 7,         // Once per week
        injectionsPerWeek: 1
    )
)

// Perform calculation
do {
    let result = try await engine.calculate(input: input)
    
    print("Concentration: \(result.concentration)mg/ml")
    print("Draw Volume: \(result.drawVolume)ml")
    print("Draw Units: \(result.drawUnits) \(result.recommendedDevice.units)")
    print("Doses per Vial: \(result.dosesPerVial)")
    print("Vials per Month: \(result.vialsPerMonth)")
    
} catch let error as CalculatorError {
    print("Error: \(error.localizedDescription)")
    if case .volumeTooLarge(let suggestions) = error {
        print("Suggestions:")
        suggestions.forEach { print("  - \($0)") }
    }
}
```

## Common Protocols

### Semaglutide (Weekly)

```swift
let semaglutideInput = CalculatorInput(
    vialSize: 5.0,
    reconstitutionVolume: 2.0,
    targetDose: 0.5,
    frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1)
)

let result = try await engine.calculate(input: semaglutideInput)
// Concentration: 2.5mg/ml
// Draw Volume: 0.2ml = 20 units
```

### Tirzepatide (Weekly)

```swift
let tirzepatideInput = CalculatorInput(
    vialSize: 10.0,
    reconstitutionVolume: 2.0,
    targetDose: 5.0,
    frequency: FrequencySchedule(intervalDays: 7, injectionsPerWeek: 1)
)

let result = try await engine.calculate(input: tirzepatideInput)
// Concentration: 5mg/ml
// Draw Volume: 1.0ml = 100 units
```

### BPC-157 (Daily)

```swift
let bpcInput = CalculatorInput(
    vialSize: 5.0,
    reconstitutionVolume: 2.0,
    targetDose: 0.25,
    frequency: FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7)
)

let result = try await engine.calculate(input: bpcInput)
// Concentration: 2.5mg/ml
// Draw Volume: 0.1ml = 10 units
// Doses per Vial: 20
// Days per Vial: 20 days
```

### TB-500 (Twice Weekly)

```swift
let tbInput = CalculatorInput(
    vialSize: 10.0,
    reconstitutionVolume: 2.0,
    targetDose: 5.0,
    frequency: FrequencySchedule(intervalDays: 3, injectionsPerWeek: 2)
)

let result = try await engine.calculate(input: tbInput)
// Concentration: 5mg/ml
// Draw Volume: 1.0ml = 100 units
```

## Device Compatibility

The engine automatically selects the smallest compatible device:

```swift
// Check compatible devices for a specific volume
let devices = await engine.getCompatibleDevices(volume: 0.2)

// Devices (in priority order):
// 1. Insulin Pen (0.5ml max)
// 2. 30-Unit Syringe (0.3ml max)
// 3. 50-Unit Syringe (0.5ml max)
// 4. 100-Unit Syringe (1.0ml max)
```

## Device Specifications

| Device | Max Volume | Units | Precision |
|--------|-----------|-------|-----------|
| Insulin Pen | 0.5ml | clicks | 0.01ml |
| 30-Unit Syringe | 0.3ml | units | 0.01ml |
| 50-Unit Syringe | 0.5ml | units | 0.01ml |
| 100-Unit Syringe | 1.0ml | units | 0.02ml |

## Unit Conversion

```swift
let device = result.recommendedDevice

// Convert ml to device-specific units
let units = await engine.mlToUnits(ml: 0.2, device: device)

// Syringes: 0.2ml * 100 = 20 units
// Pen: 0.2ml / 0.01 = 20 clicks
```

## Supply Planning

The engine calculates supply needs based on frequency:

```swift
let result = try await engine.calculate(input: input)

print("Doses per Vial: \(result.dosesPerVial)")
print("Days per Vial: \(result.daysPerVial)")
print("Vials per Month: \(result.vialsPerMonth)")

// Example for daily 0.5mg from 10mg vial:
// Doses per Vial: 20
// Days per Vial: 20
// Vials per Month: 2
```

## Syringe Visual Guide

```swift
let visual = result.syringeVisual

print("Device: \(visual.deviceType)")
print("Fill to: \(visual.fillLevel) \(visual.maxLevel)")
print("Instructions:")
visual.instructions.forEach { print("  - \($0)") }

// Output:
// Device: pen
// Fill to: 20.0 / 50.0
// Instructions:
//   - Draw to 20 clicks
//   - Using Insulin Pen
```

## Suggestions and Warnings

The engine provides intelligent suggestions:

```swift
for suggestion in result.suggestions {
    switch suggestion.type {
    case .warning:
        print("⚠️ \(suggestion.title): \(suggestion.message)")
    case .info:
        print("ℹ️ \(suggestion.title): \(suggestion.message)")
    case .optimization:
        print("💡 \(suggestion.title): \(suggestion.message)")
    }
    
    for action in suggestion.actions {
        print("   → \(action.label)")
        print("      Impact: \(action.impact)")
    }
}

// Example warnings:
// - Very small volume (< 0.05ml)
// - Near pen limit (0.4-0.5ml)
// - Better reconstitution volume available
```

## Optimal Reconstitution

The engine can suggest optimal reconstitution volumes:

```swift
let optimal = await engine.calculateOptimalReconstitution(
    vialSize: 10.0,
    targetDose: 0.5
)

print("Optimal reconstitution: \(optimal)ml")
// Finds volume that produces round unit numbers (5, 10, 15, etc.)
```

## Error Handling

```swift
do {
    let result = try await engine.calculate(input: input)
} catch let error as CalculatorError {
    switch error {
    case .volumeTooLarge(let suggestions):
        print("Volume too large!")
        print("Try one of these:")
        suggestions.forEach { print("  - \($0)") }
        
    case .invalidInput(let message):
        print("Invalid input: \(message)")
    }
}
```

## Common Error Cases

1. **Volume Too Large**
   - Occurs when draw volume exceeds 1.0ml
   - Suggestions: increase reconstitution, split dose, or use multiple syringes

2. **Invalid Input**
   - Vial size ≤ 0
   - Reconstitution volume ≤ 0
   - Target dose ≤ 0

## Thread Safety

`CalculatorEngine` is an actor, ensuring thread-safe access:

```swift
// Safe concurrent access
Task {
    let result1 = try await engine.calculate(input: input1)
}

Task {
    let result2 = try await engine.calculate(input: input2)
}

// All methods are automatically isolated
```

## Integration with SwiftUI

```swift
@MainActor
class CalculationViewModel: ObservableObject {
    private let engine = CalculatorEngine()
    
    @Published var result: CalculatorOutput?
    @Published var error: String?
    
    func calculate(
        vialSize: Double,
        reconstitutionVolume: Double,
        targetDose: Double,
        frequency: FrequencySchedule
    ) async {
        let input = CalculatorInput(
            vialSize: vialSize,
            reconstitutionVolume: reconstitutionVolume,
            targetDose: targetDose,
            frequency: frequency
        )
        
        do {
            self.result = try await engine.calculate(input: input)
            self.error = nil
        } catch let error as CalculatorError {
            self.result = nil
            self.error = error.localizedDescription
        }
    }
}
```

## Testing

Run comprehensive tests:

```bash
swift test --filter CalculatorEngineTests
```

Test coverage includes:
- ✅ Core calculations (concentration, draw volume)
- ✅ Device compatibility
- ✅ Unit conversion (pen, syringes)
- ✅ Supply planning (daily, weekly, custom)
- ✅ Syringe visual generation
- ✅ Suggestion system
- ✅ Warning detection
- ✅ Error cases
- ✅ Property-based validation
- ✅ Thread safety (concurrent access)

## Performance

- **Thread-Safe**: Actor isolation prevents data races
- **Calculation Complexity**: O(1) for all operations
- **Device Filtering**: O(n) where n = 4 devices
- **Memory**: Minimal allocations, stateless calculations

## Accuracy

All calculations match TypeScript implementation with ±0.001 tolerance:

```swift
// TypeScript: concentration = vialSize / reconstitutionVolume
// Swift: concentration = input.vialSize / input.reconstitutionVolume
// Result: Identical to 3 decimal places
```

## Migration from Legacy CalculatorState

```swift
// OLD (CalculatorState)
class CalculatorState: ObservableObject {
    var concentration: Double {
        vialSize / bacteriostaticWater
    }
}

// NEW (CalculatorEngine)
let result = try await engine.calculate(input: input)
let concentration = result.concentration
```

Benefits:
- ✅ Thread-safe actor isolation
- ✅ Comprehensive error handling
- ✅ Device compatibility checking
- ✅ Supply planning
- ✅ Intelligent suggestions
- ✅ Full test coverage
- ✅ TypeScript parity

## API Reference

### CalculatorEngine

```swift
public actor CalculatorEngine {
    // Core calculation
    func calculate(input: CalculatorInput) throws -> CalculatorOutput
    
    // Device compatibility
    func getCompatibleDevices(volume: Double) -> [Device]
    
    // Unit conversion
    func mlToUnits(ml: Double, device: Device) -> Double
    
    // Visual generation
    func generateSyringeVisual(drawVolume: Double, device: Device) -> SyringeVisual
    
    // Suggestions
    func generateSuggestions(input: CalculatorInput, drawVolume: Double) -> [Suggestion]
    
    // Warnings
    func checkWarnings(drawVolume: Double) -> [String]
    
    // Optimization
    func calculateOptimalReconstitution(vialSize: Double, targetDose: Double) -> Double
}
```

### CalculatorInput

```swift
public struct CalculatorInput: Sendable {
    let vialSize: Double
    let reconstitutionVolume: Double
    let targetDose: Double
    let frequency: FrequencySchedule
}
```

### CalculatorOutput

```swift
public struct CalculatorOutput: Sendable {
    let concentration: Double
    let drawVolume: Double
    let drawUnits: Double
    let compatibleDevices: [Device]
    let recommendedDevice: Device
    let dosesPerVial: Int
    let daysPerVial: Int
    let vialsPerMonth: Int
    let monthlyVials: Int
    let syringeVisual: SyringeVisual
    let suggestions: [Suggestion]
    let warnings: [String]
}
```

## Support

For issues or questions:
1. Check test cases in `CalculatorEngineTests.swift`
2. Compare with TypeScript implementation in `lib/protocol/calculator.ts`
3. Review this README for usage patterns
