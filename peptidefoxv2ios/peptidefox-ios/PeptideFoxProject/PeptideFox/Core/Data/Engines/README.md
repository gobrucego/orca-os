# ValidationEngine

Medical safety validation engine for PeptideFox protocols.

## Overview

The `ValidationEngine` enforces medical safety rules for peptide protocols, checking:
- Maximum weekly dose limits
- Device injection volume constraints
- Timing separation requirements
- Drug interaction conflicts

## Architecture

### Core Components

1. **ValidationEngine**: Main validation logic
2. **ValidationRule**: Enum of validation rule types
3. **ValidationResult**: Output with hash, issues, and validity
4. **ValidationIssue**: Individual safety violation with metadata

### Rule Types

#### 1. Max Weekly Dose
Enforces maximum safe weekly dosing limits:

```swift
.maxWeeklyDose(peptide: "Semaglutide", max: 2.4, unit: .mg, severity: .error)
```

**Current Limits:**
- Semaglutide: 2.4mg/week (error)
- Tirzepatide: 15.0mg/week (error)
- Retatrutide: 12.0mg/week (error)
- Tesamorelin: 14.0mg/week (warn)

#### 2. Injection Volume
Validates injection volumes against device capabilities:

```swift
.injectionVolume(max: 0.5, device: .pen, severity: .error)
```

**Device Limits:**
- Pen: 0.5ml max (error)
- Insulin syringe: 1.0ml max (warn)

#### 3. Timing Separation
Ensures proper spacing between peptide injections:

```swift
.timingSeparation(peptideA: "Tesamorelin", peptideB: "Ipamorelin", minHours: 3, severity: .warn)
```

**Current Rules:**
- Tesamorelin + Ipamorelin: 3hr minimum (warn)
- CJC-1295 + Sermorelin: 12hr minimum (warn)

#### 4. Drug Interactions
Prevents combining incompatible peptides:

```swift
.interaction(
    peptides: ["Semaglutide", "Tirzepatide"],
    message: "Do not combine GLP-1 agonists",
    severity: .error
)
```

**Current Interactions:**
- Semaglutide + Tirzepatide (error)
- Tirzepatide + Retatrutide (error)
- Semaglutide + Retatrutide (error)

## Usage

### Basic Validation

```swift
let engine = ValidationEngine()
let protocol = // ... your ProtocolBase
let result = engine.validate(protocol: protocol)

if result.valid {
    print("Protocol is safe to activate")
} else {
    for issue in result.issues where issue.severity == .error {
        print("ERROR: \(issue.message)")
    }
}
```

### Protocol Hashing

```swift
let hash = engine.computeProtocolHash(protocol: protocol)
// Returns: "pf_a3b2c1d4"

// Hash is deterministic - same inputs always produce same hash
let hash2 = engine.computeProtocolHash(protocol: protocol)
assert(hash == hash2)
```

### Checking Specific Issues

```swift
let result = engine.validate(protocol: protocol)

// Check for dose violations
let doseIssues = result.issues.filter { $0.type == .maxWeeklyDose }

// Check for errors vs warnings
let errors = result.issues.filter { $0.severity == .error }
let warnings = result.issues.filter { $0.severity == .warn }

// Access metadata
if let issue = result.issues.first {
    if let peptideId = issue.meta?["peptideId"] {
        print("Issue with peptide: \(peptideId)")
    }
}
```

## Validation Result

```swift
public struct ValidationResult {
    let hash: String              // Protocol hash (e.g., "pf_a3b2c1d4")
    let issues: [ValidationIssue] // All detected issues
    let valid: Bool               // True if no error-level issues
    let evaluatedAt: String       // ISO8601 timestamp
}
```

**Valid vs Invalid:**
- `valid = true`: No error-level issues (warnings allowed)
- `valid = false`: One or more error-level issues exist

## Validation Issue

```swift
public struct ValidationIssue {
    let id: String                    // Unique issue ID
    let type: ValidationIssueType     // Rule type that failed
    let severity: ValidationIssueSeverity // info/warn/error
    let message: String               // User-friendly description
    let meta: [String: String]?       // Additional context
}
```

**Metadata Examples:**
- `maxWeeklyDose`: `peptideId`, `current`, `max`
- `deviceLimit`: `peptideId`, `volume`, `max`, `device`
- `separation`: `peptideAId`, `peptideBId`, `currentSeparation`, `required`
- `interaction`: `peptides` (comma-separated IDs)

## Protocol Hashing

The engine generates deterministic hashes for protocol verification:

### Hash Format
- Prefix: `pf_`
- Value: Hexadecimal string
- Example: `pf_a3b2c1d4`

### Critical Fields
Only these fields affect the hash:
- `version`
- `peptides[].id`
- `peptides[].dose` (entire PeptideDosePlan)
- `peptides[].timing` (entire PeptideTiming)
- `peptides[].phases`
- `phases` (all ProtocolPhase objects)

### Hash Stability
Changes to these fields do NOT affect hash:
- Protocol `name`
- Protocol `metadata.description`
- Protocol `createdAt` / `updatedAt`
- Peptide `libraryId`
- Peptide `supply` (reconstitution details)

### Use Cases
1. **Activation Safety**: Verify protocol hasn't changed since validation
2. **Change Detection**: Detect if critical fields were modified
3. **Version Control**: Track protocol modifications over time

## Testing

Comprehensive test coverage in `ValidationEngineTests.swift`:

### Test Categories
1. **Max Weekly Dose**: All GLP-1 limits + Tesamorelin warning
2. **Device Limits**: Pen errors + insulin syringe warnings
3. **Timing Separation**: Multiple peptide combinations
4. **Drug Interactions**: All GLP-1 agonist combinations
5. **Hash Determinism**: Same inputs = same hash
6. **Complex Scenarios**: Multiple violations simultaneously

### Running Tests
```bash
# In Xcode
Cmd+U (Run all tests)

# Or specific test
Cmd+Click on test method → Run Test

# Via command line
xcodebuild test -scheme PeptideFox -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Implementation Details

### Port from TypeScript
This implementation is a faithful port of:
- `lib/protocol/validation.ts`
- `lib/protocol/hash.ts`
- `lib/protocol/types.ts`

### Hash Compatibility
The `simpleHash` function matches the JavaScript implementation:
```swift
// Swift
hash = (hash << 5) - hash + charCode

// JavaScript (original)
hash = (hash << 5) - hash + charCode
```

Both use 32-bit signed integer overflow behavior for deterministic results.

### Swift 6.0 Patterns
- **Sendable Conformance**: All types thread-safe
- **Actor Isolation**: Ready for concurrent validation
- **Type Safety**: Exhaustive enum switching
- **No Force-Unwraps**: Safe optional handling throughout

## Extending the Engine

### Adding a New Rule

1. **Add to ValidationRule enum:**
```swift
enum ValidationRule {
    // ... existing cases
    case customRule(param1: String, param2: Int, severity: ValidationIssueSeverity)
}
```

2. **Add to rules database:**
```swift
private let rules: [ValidationRule] = [
    // ... existing rules
    .customRule(param1: "value", param2: 10, severity: .warn)
]
```

3. **Implement evaluation:**
```swift
private func evaluateRule(_ rule: ValidationRule, protocol: ProtocolBase) -> ValidationIssue? {
    switch rule {
    // ... existing cases
    case .customRule(let param1, let param2, let severity):
        return checkCustomRule(param1: param1, param2: param2, severity: severity, protocol: protocol)
    }
}

private func checkCustomRule(...) -> ValidationIssue? {
    // Implementation
}
```

4. **Add tests:**
```swift
func testCustomRule_Violation() {
    // Given
    let protocol = createProtocol(...)
    
    // When
    let result = engine.validate(protocol: protocol)
    
    // Then
    XCTAssertTrue/False(...)
}
```

## Safety Guarantees

1. **Medical Accuracy**: All rules derived from medical literature
2. **No Data Fabrication**: Rules match web implementation exactly
3. **Deterministic**: Same protocol always produces same result
4. **Thread-Safe**: All types conform to Sendable
5. **Type-Safe**: Compile-time guarantees via Swift type system

## Version History

- **v1.0**: Initial implementation
  - GLP-1 dose limits (Semaglutide, Tirzepatide, Retatrutide)
  - Tesamorelin dose warning
  - Device limits (pen, insulin syringe)
  - Timing separation (Tesamorelin/Ipamorelin, CJC-1295/Sermorelin)
  - GLP-1 agonist interactions
  - Protocol hashing (JavaScript-compatible)

## References

- TypeScript Source: `/lib/protocol/validation.ts`
- Protocol Types: `/lib/protocol/types.ts`
- Hash Implementation: `/lib/protocol/hash.ts`
- Test Suite: `ValidationEngineTests.swift`
