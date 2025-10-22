# iOS Simulator Verification Guide

## Problem Identified

**Root Cause**: The issue was likely **stale DerivedData** and/or the app not being properly rebuilt after code changes.

## What Was Done

### 1. Clean Build Environment
```bash
# Uninstalled old app from simulator
xcrun simctl uninstall booted com.peptidefox.app

# Cleaned DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*

# Cleaned Xcode project
xcodebuild clean -project PeptideFox.xcodeproj -scheme PeptideFox -configuration Debug
```

### 2. Fresh Build
```bash
# Built from scratch for simulator
xcodebuild build -project PeptideFox.xcodeproj \
  -scheme PeptideFox \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,id=F223B876-5B50-4ABE-B792-32F179019217' \
  ONLY_ACTIVE_ARCH=YES
```

### 3. Fresh Install
```bash
# Installed fresh build
xcrun simctl install booted \
  /Users/adilkalam/Library/Developer/Xcode/DerivedData/PeptideFox-asmhzfgtznypkvdbpkuunfvzjqvv/Build/Products/Debug-iphonesimulator/PeptideFox.app

# Launched app
xcrun simctl launch booted com.peptidefox.app
```

## Verification Process

### Manual Verification Steps

1. **Open Simulator** (iPhone 17 Pro should be booted)
   ```bash
   open -a Simulator
   ```

2. **Launch PeptideFox**
   - App should be on home screen
   - Tap the app icon OR use:
   ```bash
   xcrun simctl launch booted com.peptidefox.app
   ```

3. **Navigate to Calculator Tab**
   - App launches to Calculator tab (f(x) icon)
   - You should see "Reconstitution Calculator" header

4. **Tap "Select Compound" Button**
   - Tap the button that says "Select Compound"
   - This should open a modal/sheet view

5. **Verify Changes in CompoundPickerView**
   Expected changes to see:
   - ✅ **60px search bar** at the top (prominent hero position)
   - ✅ **"FEATURED" section** with grid of featured compounds:
     - GLOW
     - Semaglutide (MOVED TO FEATURED)
     - Tirzepatide
     - Retatrutide
     - NAD+
     - KLOW
   - ✅ **2-column grid** layout for featured cards
   - ✅ **108px uniform card height** for featured compounds
   - ✅ **BLEND badge** on cocktails (GLOW, KLOW)
   - ✅ Debug console logs showing:
     ```
     🎯 CompoundPickerView appeared
     🎯 Featured peptides count: 6
     🎯 Filtered peptides count: 28
     ```

### Automated Screenshot Verification

```bash
# Take screenshot of picker view
xcrun simctl io booted screenshot /tmp/peptidefox-compound-picker.png

# Open screenshot to verify
open /tmp/peptidefox-compound-picker.png
```

## Known Issues & Solutions

### Issue: Changes not appearing after build

**Symptoms:**
- Code changes made but not visible in simulator
- Build succeeds but UI looks the same
- Xcode says "Build Succeeded" but app behavior unchanged

**Solutions (in order of severity):**

1. **Soft Reset** - Kill and relaunch app:
   ```bash
   xcrun simctl terminate booted com.peptidefox.app
   xcrun simctl launch booted com.peptidefox.app
   ```

2. **Clean DerivedData** - Remove cached build artifacts:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*
   ```

3. **Uninstall & Rebuild** - Full clean slate:
   ```bash
   # Uninstall app
   xcrun simctl uninstall booted com.peptidefox.app

   # Clean project
   xcodebuild clean -project PeptideFox.xcodeproj -scheme PeptideFox

   # Rebuild (use full path from project root)
   xcodebuild build -project PeptideFox.xcodeproj \
     -scheme PeptideFox \
     -configuration Debug \
     -sdk iphonesimulator \
     -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

   # Reinstall
   xcrun simctl install booted \
     ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Build/Products/Debug-iphonesimulator/PeptideFox.app
   ```

4. **Reset Simulator** - Nuclear option:
   ```bash
   xcrun simctl erase "iPhone 17 Pro"
   # Then rebuild and reinstall
   ```

### Issue: Can't interact with simulator via CLI

**Symptom:** `xcrun simctl ui tap` doesn't exist

**Solution:** Use manual interaction or Xcode UI tests. CLI tapping is limited in iOS Simulator 18+.

## Quick Reference

### Current Simulator
- **Device**: iPhone 17 Pro
- **UDID**: F223B876-5B50-4ABE-B792-32F179019217
- **OS**: iOS 26.0

### Current Build
- **DerivedData**: `/Users/adilkalam/Library/Developer/Xcode/DerivedData/PeptideFox-asmhzfgtznypkvdbpkuunfvzjqvv`
- **App Bundle**: `.../ Build/Products/Debug-iphonesimulator/PeptideFox.app`
- **Bundle ID**: com.peptidefox.app

### Console Logs
```bash
# View app logs
xcrun simctl launch --console booted com.peptidefox.app

# View all system logs
xcrun simctl spawn booted log stream --predicate 'processImagePath contains "PeptideFox"'
```

## Modified Files This Session

1. **CompoundPickerView.swift**
   - Added 60px search bar at hero position
   - Added FEATURED section with 2-column grid
   - Added 108px uniform card height
   - Added debug logging

2. **CalculatorViewModel.swift**
   - Moved Semaglutide from .regular to .featured category

3. **CalculatorView.swift**
   - Added debug logging for button taps

## Success Criteria

- ✅ DerivedData cleaned
- ✅ Fresh build completed successfully
- ✅ App installed on simulator
- ✅ App launches without crashing
- ⏳ Manual verification of CompoundPickerView changes (requires manual interaction)

## Next Steps for Team

1. **MANUAL STEP**: Open Simulator and tap "Select Compound" button
2. **VERIFY**: CompoundPickerView shows new 60px search bar + FEATURED section
3. **VERIFY**: Semaglutide appears in featured grid (not in regular list)
4. **SCREENSHOT**: Take screenshot of the picker for documentation
5. **TEST**: Search functionality works
6. **TEST**: Selecting a compound closes modal and populates calculator

## Reliable Workflow Going Forward

**Every time you make code changes:**

1. **Clean Build** (if changes aren't showing):
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*
   ```

2. **Build via Command Line** (faster than Xcode):
   ```bash
   xcodebuild build -project PeptideFox.xcodeproj \
     -scheme PeptideFox \
     -configuration Debug \
     -sdk iphonesimulator \
     -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
   ```

3. **Install** (no need to uninstall first if version numbers match):
   ```bash
   xcrun simctl install booted \
     ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Build/Products/Debug-iphonesimulator/PeptideFox.app
   ```

4. **Launch**:
   ```bash
   xcrun simctl launch booted com.peptidefox.app
   ```

5. **Verify**: Check console logs show your debug prints

**Sanity check timestamps:**
```bash
# Check source file modification time
stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" PeptideFox/Core/Presentation/Calculator/CompoundPickerView.swift

# Check built binary modification time
stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Build/Products/Debug-iphonesimulator/PeptideFox.app/PeptideFox

# Binary should be NEWER than source for changes to be included
```
