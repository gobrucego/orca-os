# Adding Protocol View Files to Xcode

## Files Created (8 new files)

1. `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Models/ProtocolCompound.swift` (6.1KB)
2. `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Core/Extensions/Color+Hex.swift` (1.5KB)
3. `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Views/Protocol/DaySelector.swift` (1.3KB)
4. `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Views/Protocol/CompoundCard.swift` (2.9KB)
5. `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Views/Protocol/CompoundEditSheet.swift` (4.5KB)
6. `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Views/Protocol/QuickReferenceCard.swift` (4.3KB)
7. `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Views/Protocol/CombinationGuidanceCard.swift` (2.2KB)
8. `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Views/Protocol/ProtocolOutputView.swift` (7.8KB)

## Quick Add Instructions

### Option 1: Drag and Drop (Recommended)
1. Open Xcode project:
   ```bash
   open /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox.xcodeproj
   ```

2. In Finder, navigate to:
   - `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Models/`
   - `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Core/Extensions/`
   - `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Views/Protocol/`

3. Drag all new files into corresponding Xcode groups:
   - Drag `ProtocolCompound.swift` → "Models" group in Xcode
   - Drag `Color+Hex.swift` → "Core/Extensions" group (create if needed)
   - Drag all Protocol/*.swift files → "Views/Protocol" group (create if needed)

4. In the dialog that appears:
   - ✅ Check "Copy items if needed" (IMPORTANT)
   - ✅ Check "Create groups"
   - ✅ Select "PeptideFox" target
   - Click "Finish"

### Option 2: Add Files Menu
1. Open Xcode project
2. Right-click "PeptideFox" group in project navigator
3. Select "Add Files to PeptideFox..."
4. Navigate to each file location and add:
   - Add `ProtocolCompound.swift` to Models
   - Add `Color+Hex.swift` to Core/Extensions
   - Add all Protocol/*.swift to Views/Protocol
5. Ensure options:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to targets: PeptideFox

## Build and Test

After adding files:

1. Clean build folder: Cmd+Shift+K
2. Build: Cmd+B
3. Run: Cmd+R
4. Navigate to "Protocol" tab (4th tab)

## Expected Result

You should see:
- Dark themed protocol view (#0b1220 background)
- Header: "AK 4-Week Intensive Recovery Protocol"
- Day selector with 7 day pills
- Collapsible Quick Reference card
- 5 time sections (Waking, AM, Mid-Day, Evening, Sleep)
- Compound cards within each section
- Footer with Combination Guidance

## Troubleshooting

**Build errors?**
- Ensure all files are added to target "PeptideFox"
- Check Build Phases → Compile Sources includes all .swift files
- Clean build folder (Cmd+Shift+K) and rebuild

**Files not showing?**
- Check Project Navigator → ensure files are in correct groups
- Verify target membership in File Inspector (right panel)

**Import errors?**
- Ensure SwiftUI is imported in all files
- Check that Color extension is compiled before use

**ContentView error?**
- Verify ContentView.swift was updated correctly
- Check that ProtocolOutputView is imported/visible
