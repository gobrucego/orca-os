# Fix: Duplicate Output Files Error

## The Problem

Xcode error: **Multiple commands produce 'CalculatorView.stringsdata'**

This happens when the same file is added to the build target multiple times in the Xcode project.

## Quick Fix (2 minutes)

### Option 1: Manual Fix in Xcode (RECOMMENDED)

1. **Open Xcode**:
   ```bash
   open PeptideFox.xcodeproj
   ```

2. **Select PeptideFox target** (left sidebar, top blue icon)

3. **Go to "Build Phases" tab**

4. **Expand "Compile Sources"** (▼ arrow)

5. **Look for DUPLICATE files** - You'll see files listed twice like:
   ```
   CalculatorView.swift
   CalculatorView.swift  ← duplicate!
   ```

6. **Remove duplicates**:
   - Click the duplicate entry
   - Press Delete (-)
   - Repeat for ALL duplicates

7. **Clean and Build**:
   ```
   Product → Clean Build Folder (⇧⌘K)
   Product → Build (⌘B)
   ```

### Option 2: Automated Script (if you see 20+ duplicates)

If manual removal is tedious:

```bash
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios

# Close Xcode first!

# Run fix script
./fix_project_duplicates.sh

# Reopen Xcode
open PeptideFox.xcodeproj
```

Then Clean Build Folder (⇧⌘K) and Build (⌘B).

---

## What Caused This?

The Xcode project was generated programmatically and accidentally added some files to the build target twice. This is harmless but prevents compilation.

---

## Expected Result

After fix, you should see:
- ✅ **0 errors** when building
- ✅ Each .swift file listed **exactly once** in Compile Sources
- ✅ App runs in simulator showing Calculator, Library, etc.

---

## If Manual Fix Doesn't Work

Try regenerating the Xcode project:

```bash
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios

# Backup current project
cp -r PeptideFox.xcodeproj PeptideFox.xcodeproj.backup

# Delete corrupted project
rm -rf PeptideFox.xcodeproj

# Regenerate (if script exists)
./create-xcode-project.sh

# Or create new Xcode project manually:
# 1. File → New → Project → iOS App
# 2. Name: PeptideFox, Bundle ID: com.peptidefox.app
# 3. Drag PeptideFox/ folder into project
# 4. Uncheck "Copy items if needed"
# 5. Select PeptideFox target
```

---

## Need Help?

Share the full error message and I'll provide specific file-by-file removal instructions.
