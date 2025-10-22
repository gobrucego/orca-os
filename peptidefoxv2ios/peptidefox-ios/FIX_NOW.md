# QUICK FIX: Remove Duplicates Manually in Xcode

## The Error

```
Multiple commands produce 'CalculatorView.stringsdata'
duplicate output file on task: SwiftDriver Compilation
```

## 2-Minute Manual Fix (EASIEST)

1. **Open Xcode**:
   ```bash
   cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios
   open PeptideFox.xcodeproj
   ```

2. **Click "PeptideFox" project** (top of left sidebar, blue icon)

3. **Select "PeptideFox" target** (under TARGETS, not PROJECT)

4. **Click "Build Phases" tab** (top tabs)

5. **Click to expand "Compile Sources" (▼)**

6. **Look for ANY file listed TWICE**:
   - Scroll through the list
   - If you see same filename twice, one is duplicate
   - Example: You'll see `CalculatorView.swift` appear twice

7. **Remove duplicates**:
   - Select the **second occurrence** (leave first)
   - Click the **minus (-)** button
   - Repeat for EVERY duplicate you find

8. **Clean & Rebuild**:
   - Menu: Product → Clean Build Folder (⇧⌘K)
   - Menu: Product → Build (⌘B)
   - Should now succeed!

---

## If You See MANY Duplicates (20+)

The easier way:

1. **Close Xcode completely** (⌘Q)

2. **Delete the Xcode project**:
   ```bash
   cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios
   rm -rf PeptideFox.xcodeproj
   ```

3. **Create NEW project in Xcode**:
   - Open Xcode
   - File → New → Project
   - Choose: **iOS → App**
   - Product Name: **PeptideFox**
   - Organization Identifier: **com.peptidefox**
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Save in: `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/`

4. **Add all source files**:
   - Delete the default `ContentView.swift` and `PeptideFoxApp.swift` Xcode created
   - Drag entire **PeptideFox/** folder from Finder into Xcode project navigator
   - When dialog appears:
     - ✅ Check "Create groups"
     - ❌ UN-check "Copy items if needed" (important!)
     - ✅ Check "PeptideFox" under "Add to targets"
     - Click "Add"

5. **Add test target files**:
   - File → New → Target → iOS Unit Testing Bundle
   - Name it "PeptideFoxTests"
   - Drag PeptideFoxTests/ folder into test target

6. **Build**:
   - Product → Clean Build Folder (⇧⌘K)
   - Product → Build (⌘B)
   - Should work perfectly!

---

## Why This Happened

The automated Xcode project generation script added files twice. This is a common Xcode issue when programmatically creating projects.

---

## What You Should See After Fix

✅ Build succeeds with 0 errors
✅ App runs in simulator
✅ Shows tabs: Calculator, Library, Protocols, Profile
✅ Calculator accepts input and calculates
✅ Library shows peptide cards

---

## Still Getting Errors?

**Share the error message and I'll provide exact fix!**

Common remaining issues:
- Missing font files → Copy from `/assets/` folder
- Import errors → Missing file in target
- Type errors → Let me know which type
