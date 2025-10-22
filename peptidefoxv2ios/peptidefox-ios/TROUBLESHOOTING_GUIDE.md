# TROUBLESHOOTING GUIDE

Step-by-step guide to debug and fix PeptideFox iOS build errors.

---

## Step 1: Identify the Error Type

### Read the Error Message Carefully

Xcode errors follow this format:
```
[File Path]:[Line]:[Column]: error: [Message]
[Code snippet]
[Pointer to issue]
```

Example:
```
PeptideFox/Core/Design/ComponentStyles.swift:128:30: error: Expected ',' separator
.padding(.vertical: DesignTokens.Spacing.xs)
                  ^
```

### Common Error Categories

1. **Syntax Errors**: Missing punctuation, wrong operators
   - Keywords: "Expected", "unexpected token"
   
2. **Type Errors**: Undefined types, wrong types
   - Keywords: "Cannot find type", "Use of undeclared"
   
3. **Module Errors**: Missing frameworks
   - Keywords: "No such module"
   
4. **Conformance Errors**: Protocol requirements
   - Keywords: "does not conform"
   
5. **Build Errors**: File not found, duplicate symbols
   - Keywords: "duplicate symbol", "not found in bundle"

---

## Step 2: Locate the Problem

### Find the Exact File and Line

```bash
# Navigate to project directory
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios

# View the problematic file
cat -n PeptideFox/[path/to/file].swift | sed -n '[line-5],[line+5]p'
```

Example:
```bash
# If error is at line 128
cat -n PeptideFox/Core/Design/ComponentStyles.swift | sed -n '123,133p'
```

### Check if File Exists

```bash
# Find file location
find PeptideFox -name "ComponentStyles.swift"

# Check file status
ls -la PeptideFox/Core/Design/ComponentStyles.swift
```

---

## Step 3: Diagnose the Root Cause

### For "Cannot find type X in scope" Errors

**Question 1: Does the type exist?**
```bash
grep -r "struct [TypeName]\|enum [TypeName]\|class [TypeName]" PeptideFox/
```

Example:
```bash
grep -r "struct PFCard\|enum PFCard\|class PFCard" PeptideFox/
```

**If found:**
- Note the file path
- Continue to Question 2

**If not found:**
- Type needs to be created
- See `COMMON_BUILD_ERRORS.md` for type definitions

**Question 2: Is the file in the target?**
```bash
# Check project file references
grep "[FileName].swift" PeptideFox.xcodeproj/project.pbxproj | grep PBXBuildFile
```

**If not found:**
1. Open Xcode
2. Select the file in Project Navigator
3. File Inspector (⌘⌥1)
4. Check "PeptideFox" under Target Membership

**Question 3: Are imports correct?**
```bash
# Check imports in the error file
head -20 PeptideFox/[path/to/error/file].swift | grep "import"
```

For same-module types (both in PeptideFox):
- No import needed
- Just ensure both files in target

For framework types:
- SwiftUI: `import SwiftUI`
- Foundation: `import Foundation`
- Observation: `import Observation`

---

### For Syntax Errors

**Common Issues:**

1. **Wrong separator in function calls**
   ```swift
   // ❌ Wrong - colon instead of comma
   .padding(.vertical: value)
   
   // ✅ Correct
   .padding(.vertical, value)
   ```

2. **Missing comma in parameter lists**
   ```swift
   // ❌ Wrong
   func doSomething(a: Int b: String)
   
   // ✅ Correct
   func doSomething(a: Int, b: String)
   ```

3. **Wrong closure syntax**
   ```swift
   // ❌ Wrong
   Button("Click") -> {
   }
   
   // ✅ Correct
   Button("Click") {
   }
   ```

**Fix Process:**
1. Read error message for expected token
2. Compare with your code
3. Add/change the punctuation
4. Save and rebuild

---

### For Module Errors

**"No such module" means:**
- Framework not available
- Wrong deployment target
- Framework not linked

**Check deployment target:**
```bash
grep IPHONEOS_DEPLOYMENT_TARGET PeptideFox.xcodeproj/project.pbxproj | head -1
```

**Framework requirements:**
- SwiftUI: iOS 13.0+
- Charts: iOS 16.0+
- SwiftData: iOS 17.0+
- Observation: iOS 17.0+

**Quick Fix:**
If framework not needed yet (like SwiftData):
1. Remove the import
2. Remove code using the framework
3. Add TODO comment for later

---

## Step 4: Apply the Fix

### Syntax Fix Template

1. **Locate the line**
   ```bash
   sed -n '[line]p' PeptideFox/path/to/file.swift
   ```

2. **Make the change**
   - Open file in editor
   - Navigate to line number
   - Apply fix from error message

3. **Verify syntax**
   ```bash
   xcrun swiftc -typecheck PeptideFox/path/to/file.swift
   ```

### Type Definition Fix Template

1. **Find where type should be defined**
   - Models: `PeptideFox/Core/Data/Models/PeptideModels.swift`
   - UI Components: `PeptideFox/Core/Design/ComponentStyles.swift`
   - View Models: `PeptideFox/Core/ViewModels/`

2. **Add type definition**
   See `COMMON_BUILD_ERRORS.md` for templates

3. **Ensure file in target**
   ```bash
   grep "[FileName].swift" PeptideFox.xcodeproj/project.pbxproj
   ```

### Target Membership Fix

**Via Xcode (recommended):**
1. Open PeptideFox.xcodeproj in Xcode
2. Select file in Project Navigator
3. Show File Inspector (⌘⌥1)
4. Under "Target Membership", check "PeptideFox"

**Via command line (advanced):**
```bash
# This is complex - use Xcode instead
# Or use the fix_build.sh script
./fix_build.sh
```

---

## Step 5: Clean and Rebuild

### Clean Build Artifacts

```bash
# Clean derived data (cached builds)
rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*

# Clean project (if using xcodebuild)
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios
xcodebuild clean -project PeptideFox.xcodeproj -scheme PeptideFox
```

### Rebuild

**Option 1: Xcode**
1. Open project in Xcode
2. Product → Clean Build Folder (⇧⌘K)
3. Product → Build (⌘B)

**Option 2: Command Line**
```bash
xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox build
```

---

## Step 6: Verify the Fix

### Check for Remaining Errors

```bash
# Build and capture errors
xcodebuild build 2>&1 | grep "error:" | tee build_errors.txt
```

### Test Individual Files

```bash
# Test syntax of specific file
xcrun swiftc -typecheck PeptideFox/Core/Presentation/ContentView.swift

# Test all view files
find PeptideFox/Core/Presentation -name "*.swift" -exec xcrun swiftc -typecheck {} \;
```

### Verify in Xcode

1. Open project in Xcode
2. Check Issue Navigator (⌘5)
3. Ensure no errors remain
4. Build succeeds (⌘B)

---

## Common Workflows

### Workflow 1: New File Not Recognized

**Symptoms:**
- Just created a file
- Other files can't find types from it

**Steps:**
1. Check file exists:
   ```bash
   ls -la PeptideFox/path/to/NewFile.swift
   ```

2. Add to target in Xcode:
   - Select file
   - File Inspector (⌘⌥1)
   - Check "PeptideFox"

3. Verify:
   ```bash
   grep "NewFile.swift" PeptideFox.xcodeproj/project.pbxproj
   ```

4. Clean and rebuild:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*
   xcodebuild build
   ```

---

### Workflow 2: Syntax Error in Generated Code

**Symptoms:**
- Error in file you didn't write
- Generated by Xcode/SwiftUI

**Steps:**
1. Don't edit generated files
2. Find source of generation
3. Fix source, regenerate

**Example: SwiftData Schema Error**
```
Error in ModelContainer initialization
```

**Fix:**
1. Remove SwiftData if not needed
2. Or fix schema definition
3. See `COMMON_BUILD_ERRORS.md` → SwiftData section

---

### Workflow 3: Type Exists But Not Found

**Symptoms:**
- You can see the type definition
- Compiler says it doesn't exist

**Steps:**
1. Check both files in same target:
   ```bash
   grep "File1.swift" PeptideFox.xcodeproj/project.pbxproj | grep PBXBuildFile
   grep "File2.swift" PeptideFox.xcodeproj/project.pbxproj | grep PBXBuildFile
   ```

2. Check access level:
   ```swift
   // ❌ Private - not visible
   private struct MyType { }
   
   // ❌ Internal - only in same module
   struct MyType { }
   
   // ✅ Public - visible everywhere
   public struct MyType { }
   ```

3. Check spelling/capitalization:
   ```bash
   grep -i "mytype" PeptideFox/Core/Data/Models/*.swift
   ```

4. Clean and rebuild:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*
   ```

---

### Workflow 4: Multiple Errors

**Symptoms:**
- Dozens of errors
- Cascading from one root cause

**Steps:**
1. **Don't panic** - often one fix solves many
2. **Fix in order:**
   - First: Module import errors
   - Second: Type definition errors
   - Third: Syntax errors
   - Fourth: Conformance errors
   - Last: Warning-level issues

3. **Focus on first error:**
   ```bash
   xcodebuild build 2>&1 | grep "error:" | head -1
   ```

4. **Fix and rebuild:**
   - Fix one error
   - Clean and rebuild
   - Check how many remain

5. **Repeat** until clean build

---

## Automation Tools

### Use fix_build.sh

```bash
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios
chmod +x fix_build.sh
./fix_build.sh
```

**What it checks:**
- File existence
- Target membership
- Common syntax errors
- Import statements
- Deployment target

### Use minimal-build-test.sh

```bash
chmod +x minimal-build-test.sh
./minimal-build-test.sh
```

**What it does:**
- Tests if Swift toolchain works
- Compiles minimal SwiftUI app
- Helps isolate project vs tooling issues

---

## Getting More Help

### Collect Diagnostic Info

```bash
# Get Xcode version
xcodebuild -version

# Get Swift version
xcrun swift --version

# Get deployment target
grep IPHONEOS_DEPLOYMENT_TARGET PeptideFox.xcodeproj/project.pbxproj | head -1

# List all Swift files
find PeptideFox -name "*.swift" -type f

# Get build errors
xcodebuild build 2>&1 | grep "error:" > build_errors.txt
```

### Check Documentation

- `BUILD_FIX.md` - Solutions for each error type
- `COMMON_BUILD_ERRORS.md` - Detailed examples with fixes
- `README.md` - Project overview
- `FILE_STRUCTURE.md` - Where files should be

---

## Emergency Fixes

### Nuclear Option: Clean Everything

```bash
# WARNING: This removes all build artifacts and Xcode state
rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*
rm -rf ~/Library/Caches/com.apple.dt.Xcode
killall Xcode
```

Then:
1. Restart Mac (sometimes needed)
2. Open Xcode
3. Open project fresh
4. Build

### Last Resort: Revert Recent Changes

```bash
# See recent changes
git log --oneline -10

# See what changed in last commit
git diff HEAD~1

# Revert if needed
git revert HEAD
```

---

## Prevention

### Before Making Changes

1. **Ensure current build works**
   ```bash
   xcodebuild build
   ```

2. **Create branch for experiments**
   ```bash
   git checkout -b experiment/new-feature
   ```

3. **Commit working state**
   ```bash
   git add .
   git commit -m "Working state before changes"
   ```

### After Making Changes

1. **Build frequently**
   - Build after each file
   - Don't wait until "done"

2. **Test compile individual files**
   ```bash
   xcrun swiftc -typecheck path/to/NewFile.swift
   ```

3. **Check target membership immediately**
   - New files default to NO target
   - Always check File Inspector

---

## Quick Reference

| Error Pattern | First Thing to Check |
|--------------|---------------------|
| Cannot find type | File in target? |
| No such module | Deployment target? |
| Expected ',' | Function call syntax? |
| Does not conform | Body property exists? |
| Duplicate symbol | Duplicate files? |
| Use of undeclared | Type defined somewhere? |

---

## See Also

- `BUILD_FIX.md` - Error type solutions
- `COMMON_BUILD_ERRORS.md` - Detailed examples
- `fix_build.sh` - Automated diagnostics
- `minimal-build-test.sh` - Toolchain test
