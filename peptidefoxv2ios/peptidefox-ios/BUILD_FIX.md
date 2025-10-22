# BUILD FIX GUIDE

## Common Build Errors and Solutions

This guide covers the most common build errors in the PeptideFox iOS project and how to fix them.

---

## Error Type 1: "Cannot find type 'X' in scope"

### Symptoms
```
Cannot find type 'PFCard' in scope
Cannot find type 'CalculatorViewModel' in scope
```

### Causes
1. File not added to target membership
2. Missing import statement
3. File deleted but still referenced

### Solutions

**Step 1: Check file exists**
```bash
find PeptideFox -name "*ViewModel.swift"
find PeptideFox -name "*ComponentStyles.swift"
```

**Step 2: Verify target membership**
- Open file in Xcode
- Open File Inspector (⌘⌥1)
- Check "PeptideFox" under Target Membership
- If unchecked, check it

**Step 3: Add missing import**
Common imports needed:
```swift
import SwiftUI          // For all UI files
import Foundation       // For model/utility files
```

**Step 4: Rebuild**
```bash
# Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*

# Build again
xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox build
```

---

## Error Type 2: "Use of undeclared type"

### Symptoms
```
Use of undeclared type 'FrequencySchedule'
Use of undeclared type 'PeptideCategory'
```

### Causes
1. Type defined in another file
2. Typo in type name
3. Wrong capitalization

### Solutions

**Step 1: Find where type is defined**
```bash
grep -r "struct FrequencySchedule" PeptideFox/
grep -r "enum PeptideCategory" PeptideFox/
```

**Step 2: Check spelling and capitalization**
Swift is case-sensitive:
- ✅ `FrequencySchedule`
- ❌ `frequencyschedule`
- ❌ `Frequencyschedule`

**Step 3: Ensure file is in target**
```bash
# Check if file is in project
ls -la PeptideFox/Core/Data/Models/
```

---

## Error Type 3: "No such module 'X'"

### Symptoms
```
No such module 'SwiftData'
No such module 'Charts'
```

### Causes
1. Framework not linked
2. Deployment target too low
3. Wrong SDK

### Solutions

**Step 1: Check deployment target**
```bash
# Should be iOS 17.0+
grep IPHONEOS_DEPLOYMENT_TARGET PeptideFox.xcodeproj/project.pbxproj
```

**Step 2: Verify framework availability**
- SwiftData: iOS 17.0+
- Charts: iOS 16.0+
- SwiftUI: iOS 13.0+

**Step 3: Remove framework if not needed**
Example: SwiftData not needed yet
```swift
// ❌ Remove
import SwiftData
let container = ModelContainer(...)

// ✅ Use
// Will add SwiftData in Phase 2
```

---

## Error Type 4: Syntax Errors

### Common Syntax Issues

**Issue: Missing comma in struct**
```swift
// ❌ Error
.padding(.vertical: DesignTokens.Spacing.xs)

// ✅ Correct
.padding(.vertical, DesignTokens.Spacing.xs)
```

**Issue: Wrong closure syntax**
```swift
// ❌ Error
Button("Click") -> {
    action()
}

// ✅ Correct
Button("Click") {
    action()
}
```

**Issue: Missing @escaping**
```swift
// ❌ Error
func doSomething(completion: () -> Void)

// ✅ Correct (if stored)
func doSomething(completion: @escaping () -> Void)
```

---

## Error Type 5: "@Observable requires iOS 17+"

### Symptoms
```
@Observable requires iOS 17.0 or newer
```

### Solutions

**Step 1: Check deployment target**
```bash
# In project.pbxproj, should be:
IPHONEOS_DEPLOYMENT_TARGET = 17.0;
```

**Step 2: Use @Observable correctly**
```swift
import Observation  // Required import

@Observable
class ViewModel {
    var property: String = ""
}
```

**Step 3: Alternative for older iOS**
If targeting iOS 16:
```swift
// Use @StateObject instead
class ViewModel: ObservableObject {
    @Published var property: String = ""
}
```

---

## Error Type 6: Custom Fonts Not Found

### Symptoms
```
Font 'Brown-LL-Regular' not found
```

### Solutions

**Step 1: Check font files in bundle**
```bash
ls -la PeptideFox/Resources/Fonts/
```

**Step 2: Verify Info.plist**
Should contain:
```xml
<key>UIAppFonts</key>
<array>
    <string>Brown-LL-Regular.otf</string>
    <string>Brown-LL-Medium.otf</string>
</array>
```

**Step 3: Check target membership**
- Select font file in Xcode
- File Inspector → Target Membership
- Check "PeptideFox"

**Step 4: Use fallback**
```swift
// Safe font loading
let customFont = UIFont(name: "Brown-LL-Regular", size: 16) ?? .systemFont(ofSize: 16)
```

---

## Error Type 7: Duplicate Symbol Errors

### Symptoms
```
Duplicate symbol '_$s12PeptideFox...'
```

### Causes
1. File added to project twice
2. Same file in multiple targets

### Solutions

**Step 1: Find duplicate**
```bash
# Check project for duplicates
find PeptideFox -name "CalculatorView.swift"
```

**Step 2: Remove duplicate from target**
- Select file in Project Navigator
- File Inspector → Target Membership
- Uncheck duplicate target

**Step 3: Clean build**
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*
```

---

## Error Type 8: Protocol Conformance Issues

### Symptoms
```
Type 'X' does not conform to protocol 'Y'
```

### Solutions

**Step 1: Check required methods**
```swift
// Protocol
protocol Themed {
    func applyTheme()
}

// Conformance
class MyView: UIView, Themed {
    func applyTheme() {
        // Implementation required
    }
}
```

**Step 2: Check associated types**
```swift
protocol Container {
    associatedtype Item
}

struct Box: Container {
    typealias Item = String  // Must specify
}
```

---

## Quick Fix Commands

### Clean Everything
```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*

# Clean project
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios
xcodebuild clean -project PeptideFox.xcodeproj -scheme PeptideFox
```

### Verify Swift Syntax
```bash
# Check individual file
xcrun swiftc -typecheck PeptideFox/Core/Presentation/ContentView.swift

# Check all files
find PeptideFox -name "*.swift" -exec xcrun swiftc -typecheck {} \;
```

### Check for Common Issues
```bash
# Find files not in target
find PeptideFox -name "*.swift" | while read f; do
    grep -q "$(basename "$f")" PeptideFox.xcodeproj/project.pbxproj || echo "Not in project: $f"
done

# Find duplicate files
find PeptideFox -name "*.swift" -exec basename {} \; | sort | uniq -d
```

---

## Prevention Checklist

Before committing code, check:

- [ ] All files added to correct target
- [ ] No duplicate files in project
- [ ] Import statements present
- [ ] Deployment target correct (iOS 17.0+)
- [ ] No syntax errors (commas, colons, closures)
- [ ] Protocol conformance complete
- [ ] Fonts/resources in bundle
- [ ] Clean build succeeds

---

## Getting Help

If none of these solutions work:

1. **Check exact error message**
   - Copy full error from Xcode
   - Look for file name and line number

2. **Check file location**
   ```bash
   find PeptideFox -name "ProblemFile.swift"
   ```

3. **Verify file content**
   ```bash
   cat PeptideFox/path/to/ProblemFile.swift | head -20
   ```

4. **Check project structure**
   ```bash
   tree PeptideFox/Core -L 3
   ```

5. **Use diagnostic script**
   ```bash
   ./fix_build.sh
   ```

---

## Related Files

- `COMMON_BUILD_ERRORS.md` - Detailed error examples
- `TROUBLESHOOTING_GUIDE.md` - Step-by-step debugging
- `fix_build.sh` - Automated diagnostic script
- `minimal-build-test.sh` - Test basic compilation
