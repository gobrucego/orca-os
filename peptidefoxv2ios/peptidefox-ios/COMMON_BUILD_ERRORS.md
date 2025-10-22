# COMMON BUILD ERRORS - Detailed Examples

## Syntax Error in ComponentStyles.swift

### Error Message
```
PeptideFox/Core/Design/ComponentStyles.swift:128:30: error: 
Expected ',' separator
.padding(.vertical: DesignTokens.Spacing.xs)
                  ^
```

### Location
File: `PeptideFox/Core/Design/ComponentStyles.swift`
Line: 128
Code:
```swift
.padding(.vertical: DesignTokens.Spacing.xs)  // ❌ Wrong
```

### Fix
Change colon to comma:
```swift
.padding(.vertical, DesignTokens.Spacing.xs)  // ✅ Correct
```

### Why This Happens
SwiftUI modifiers use labeled parameters, not dictionary syntax.
- Dictionary: `[key: value]`
- SwiftUI: `.modifier(parameter, value)`

---

## Missing Import Statement

### Error Message
```
PeptideFox/Core/Presentation/Calculator/CalculatorView.swift:88:17: error:
Cannot find 'PFCard' in scope
PFCard {
^~~~~~
```

### Location
File: `PeptideFox/Core/Presentation/Calculator/CalculatorView.swift`
Line: 88

### Diagnosis
1. Check if PFCard exists:
   ```bash
   grep -r "struct PFCard" PeptideFox/
   ```
   Result: Found in `PeptideFox/Core/Design/ComponentStyles.swift`

2. Check if file imports ComponentStyles:
   ```bash
   head -10 PeptideFox/Core/Presentation/Calculator/CalculatorView.swift
   ```
   Result: Only imports SwiftUI

### Fix
PFCard is defined in same module, so no import needed.
Check if ComponentStyles.swift is in the target:
1. Open Xcode
2. Select ComponentStyles.swift
3. File Inspector (⌘⌥1)
4. Check "PeptideFox" under Target Membership

### Alternative Cause
If ComponentStyles.swift doesn't exist, create it or check git:
```bash
git status PeptideFox/Core/Design/ComponentStyles.swift
```

---

## Undefined Type in Models

### Error Message
```
PeptideFox/Core/Data/Models/PeptideModels.swift:45:12: error:
Use of undeclared type 'FrequencySchedule'
    let frequency: FrequencySchedule
            ^~~~~~~~~~~~~~~~~
```

### Location
File: `PeptideFox/Core/Data/Models/PeptideModels.swift`
Line: 45

### Diagnosis
1. Find where FrequencySchedule is defined:
   ```bash
   grep -r "struct FrequencySchedule\|enum FrequencySchedule" PeptideFox/
   ```

2. Check if it's in same file:
   ```bash
   grep "FrequencySchedule" PeptideFox/Core/Data/Models/PeptideModels.swift
   ```

### Common Causes
1. **Type in different file**: Need to ensure both files in target
2. **Typo**: `FrequencySchedule` vs `FrequencySchedules`
3. **Case sensitivity**: `frequencyschedule` vs `FrequencySchedule`
4. **Not defined yet**: Need to create the type

### Fix Options

**Option 1: Type is defined elsewhere**
Check file is in target:
```bash
grep -A 5 "struct FrequencySchedule" PeptideFox/**/*.swift
```

**Option 2: Type needs to be defined**
Add to PeptideModels.swift:
```swift
public struct FrequencySchedule: Codable, Hashable, Sendable {
    public let intervalDays: Int
    public let injectionsPerWeek: Int
    public let pattern: String
    
    public init(intervalDays: Int, injectionsPerWeek: Int, pattern: String) {
        self.intervalDays = intervalDays
        self.injectionsPerWeek = injectionsPerWeek
        self.pattern = pattern
    }
}
```

---

## SwiftData Module Not Found

### Error Message
```
PeptideFox/PeptideFoxApp.swift:2:8: error:
No such module 'SwiftData'
import SwiftData
       ^~~~~~~~~
```

### Location
File: `PeptideFox/PeptideFoxApp.swift`
Line: 2

### Diagnosis
1. Check deployment target:
   ```bash
   grep IPHONEOS_DEPLOYMENT_TARGET PeptideFox.xcodeproj/project.pbxproj | head -1
   ```
   
2. SwiftData requires iOS 17.0+

### Fix

**Option 1: Remove SwiftData (recommended for MVP)**
```swift
// Before
import SwiftUI
import SwiftData

@main
struct PeptideFoxApp: App {
    let container: ModelContainer
    // ... SwiftData setup
}

// After
import SwiftUI

@main
struct PeptideFoxApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

**Option 2: Ensure iOS 17.0+ deployment**
1. Open project settings
2. Select PeptideFox target
3. General → Deployment Info → iOS 17.0

---

## Duplicate Symbol Error

### Error Message
```
duplicate symbol '_$s12PeptideFox14CalculatorViewV4bodyQrvp' in:
    /path/to/CalculatorView.o
    /path/to/old/CalculatorView.o
```

### Diagnosis
1. Find all instances:
   ```bash
   find PeptideFox -name "CalculatorView.swift"
   ```

2. Check if file added twice to target:
   ```bash
   grep -c "CalculatorView.swift" PeptideFox.xcodeproj/project.pbxproj
   ```

### Fix

**If file duplicated:**
1. Find duplicate files:
   ```bash
   find PeptideFox -name "CalculatorView.swift"
   ```
2. Delete old/backup files
3. Keep only one in correct location

**If file added to target twice:**
1. Open Xcode
2. Select CalculatorView.swift
3. File Inspector → Target Membership
4. Ensure only "PeptideFox" is checked (not PeptideFoxTests)

**Clean build:**
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*
```

---

## Protocol Conformance Error

### Error Message
```
PeptideFox/Core/Design/ComponentStyles.swift:116:15: error:
Type 'PFBadge' does not conform to protocol 'View'
public struct PFBadge: View {
              ^
```

### Diagnosis
View protocol requires `body` property:
```swift
protocol View {
    associatedtype Body: View
    var body: Body { get }
}
```

### Fix
Add body property:
```swift
public struct PFBadge: View {
    let text: String
    let category: PeptideCategory
    
    public var body: some View {  // ← Required
        Text(text)
            .font(DesignTokens.Typography.labelSmall)
            // ...
    }
}
```

---

## Observable Macro Error

### Error Message
```
PeptideFox/Core/ViewModels/CalculatorViewModel.swift:3:1: error:
'@Observable' requires iOS 17.0 or newer
@Observable
^~~~~~~~~~~
```

### Diagnosis
1. Check deployment target:
   ```bash
   grep IPHONEOS_DEPLOYMENT_TARGET PeptideFox.xcodeproj/project.pbxproj
   ```

2. Check import:
   ```swift
   import Observation  // Required for @Observable
   ```

### Fix

**Option 1: Ensure iOS 17+ (recommended)**
```swift
import Observation

@Observable
class CalculatorViewModel {
    var vialSize: Double = 0
    var targetDose: Double = 0
}
```

**Option 2: Use ObservableObject for iOS 16**
```swift
import Combine

class CalculatorViewModel: ObservableObject {
    @Published var vialSize: Double = 0
    @Published var targetDose: Double = 0
}
```

---

## Missing PeptideCategory Definition

### Error Message
```
PeptideFox/Core/Data/Models/PeptideModels.swift:12:17: error:
Cannot find type 'PeptideCategory' in scope
    let category: PeptideCategory
                  ^~~~~~~~~~~~~~~~
```

### Diagnosis
Search for definition:
```bash
grep -r "enum PeptideCategory" PeptideFox/
```

### Fix
Define the enum in PeptideModels.swift:
```swift
public enum PeptideCategory: String, Codable, CaseIterable, Sendable {
    case glp1 = "GLP-1"
    case healing = "Healing & Recovery"
    case metabolic = "Metabolic"
    case longevity = "Longevity"
    case cognitive = "Cognitive"
    
    var backgroundColor: Color {
        switch self {
        case .glp1: return ColorTokens.CategoryColors.glp1Background
        case .healing: return ColorTokens.CategoryColors.healingBackground
        case .metabolic: return ColorTokens.CategoryColors.metabolicBackground
        case .longevity: return ColorTokens.CategoryColors.longevityBackground
        case .cognitive: return ColorTokens.CategoryColors.cognitiveBackground
        }
    }
    
    var accentColor: Color {
        switch self {
        case .glp1: return ColorTokens.CategoryColors.glp1Accent
        case .healing: return ColorTokens.CategoryColors.healingAccent
        case .metabolic: return ColorTokens.CategoryColors.metabolicAccent
        case .longevity: return ColorTokens.CategoryColors.longevityAccent
        case .cognitive: return ColorTokens.CategoryColors.cognitiveAccent
        }
    }
    
    var borderColor: Color {
        switch self {
        case .glp1: return ColorTokens.CategoryColors.glp1Border
        case .healing: return ColorTokens.CategoryColors.healingBorder
        case .metabolic: return ColorTokens.CategoryColors.metabolicBorder
        case .longevity: return ColorTokens.CategoryColors.longevityBorder
        case .cognitive: return ColorTokens.CategoryColors.cognitiveBorder
        }
    }
}
```

---

## Device Types Not Found

### Error Message
```
PeptideFox/Core/Data/Engines/CalculatorEngine.swift:89:25: error:
Cannot find 'Device' in scope
let device = Device.insulin_100
             ^~~~~~
```

### Diagnosis
1. Find Device definition:
   ```bash
   grep -r "struct Device\|enum Device" PeptideFox/
   ```

2. Check if defined in same file:
   ```bash
   grep "Device" PeptideFox/Core/Data/Engines/CalculatorEngine.swift | head -5
   ```

### Fix
Add Device model to PeptideModels.swift:
```swift
public struct Device: Codable, Hashable, Identifiable, Sendable {
    public let id: String
    public let name: String
    public let units: Int
    public let volume: Double
    public let minUnits: Double
    public let maxUnits: Double
    
    public static let insulin_100 = Device(
        id: "insulin_100",
        name: "Insulin Syringe (U-100)",
        units: 100,
        volume: 1.0,
        minUnits: 1,
        maxUnits: 100
    )
    
    public static let insulin_50 = Device(
        id: "insulin_50",
        name: "Insulin Syringe (U-50)",
        units: 50,
        volume: 0.5,
        minUnits: 1,
        maxUnits: 50
    )
    
    public static let allDevices: [Device] = [
        .insulin_100,
        .insulin_50
    ]
}
```

---

## Quick Diagnostic Commands

### Find all build errors
```bash
xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox build 2>&1 | grep "error:"
```

### Check file exists and location
```bash
find PeptideFox -name "ComponentStyles.swift"
```

### Verify file in target
```bash
grep "ComponentStyles.swift" PeptideFox.xcodeproj/project.pbxproj | grep -c PBXBuildFile
```

### Find undefined types
```bash
# Get all error lines
xcodebuild build 2>&1 | grep "Cannot find.*in scope"
```

### Check import statements
```bash
find PeptideFox -name "*.swift" -exec grep -L "import SwiftUI" {} \;
```

---

## Error Prevention Tips

1. **Always add files to target when creating**
2. **Check imports in new files**
3. **Use consistent naming (PascalCase for types)**
4. **Define supporting types before use**
5. **Clean build after major changes**
6. **Test compile individual files**
7. **Keep deployment target consistent**
8. **Don't commit build artifacts**

---

## See Also

- `BUILD_FIX.md` - Solutions guide
- `TROUBLESHOOTING_GUIDE.md` - Step-by-step debugging
- `fix_build.sh` - Automated fixes
