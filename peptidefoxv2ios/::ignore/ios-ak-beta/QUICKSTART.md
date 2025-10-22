# Quick Start Guide - AK Protocol iOS App

Get the app running in 5 minutes!

## Prerequisites

- Mac with Xcode 14+ installed
- Basic familiarity with Xcode

## Fast Setup

### 1. Open Xcode
Launch Xcode from Applications or Spotlight.

### 2. Create New Project
- **File** → **New** → **Project**
- Choose **iOS** → **App**
- Click **Next**

### 3. Configure Project
- **Product Name**: `AKProtocol`
- **Interface**: SwiftUI
- **Language**: Swift
- Click **Next**, choose location, **Create**

### 4. Add Files

**Delete these auto-generated files:**
- `ContentView.swift` (delete → Move to Trash)

**Create folder structure:**
Right-click `AKProtocol` folder → New Group:
- `Models`
- `Views` (with sub-group `Components`)
- `Data`
- `Utilities`

**Add files by right-click → New File → Swift File:**

In `Models/`:
- `AKProtocolState.swift`

In `Data/`:
- `ProtocolData.swift`

In `Utilities/`:
- `DrawVolumeCalculator.swift`

In `Views/`:
- `AKProtocolView.swift`
- `MasterConfigSheet.swift`
- `CompoundAdjustSheet.swift`

In `Views/Components/`:
- `WeekSelector.swift`
- `DaySelector.swift`
- `TimeSectionCard.swift`
- `CompoundTableView.swift`

**Copy file contents** from `ios-ak-beta/AKProtocol/` matching paths.

### 5. Update App Entry Point

Replace contents of `AKProtocolApp.swift`:

```swift
import SwiftUI

@main
struct AKProtocolApp: App {
    var body: some Scene {
        WindowGroup {
            AKProtocolView()
        }
    }
}
```

### 6. Run!

- Select simulator: **iPhone 15 Pro** from scheme menu
- Press **⌘R** or click Play ▶️
- App launches! 🎉

## Quick Test

1. ✅ **Week selector** - Tap Week 1, 2, 3, 4
2. ✅ **Day selector** - Tap different days
3. ✅ **Expand sections** - Tap section headers
4. ✅ **Configure** - Tap Configure button in nav bar
5. ✅ **Adjust compound** - Tap Adjust on any compound

## Troubleshooting

**Build errors?**
- Clean build: **⌘⇧K**
- Rebuild: **⌘B**

**Missing files?**
- Check each file's Target Membership checkbox
- File Inspector (right sidebar) → Target Membership → `AKProtocol`

**Preview not working?**
- Refresh: **⌘⌥P**
- Or just run in simulator

## What's Included

✅ **30+ compounds** across all protocol categories
✅ **4 weeks** of complete protocol data
✅ **Dynamic dosing** for Vyvanse, NAD+, Wellbutrin, etc.
✅ **Auto-calculated** draw volumes
✅ **Persistent settings** via UserDefaults
✅ **Master + Individual** compound configuration

## Next Steps

- Explore different weeks and days
- Adjust compound doses and see draw volumes update
- Check persistence by closing and reopening the app
- Review [README.md](README.md) for full documentation
- See [SETUP.md](SETUP.md) for detailed setup guide

## Features to Try

1. **Navigate weeks** - See how compounds change across weeks
2. **Configure Vyvanse** - Note how dose varies by day (30mg vs 60mg)
3. **Adjust NAD+** - See different dosing in Week 1 vs Week 4
4. **Collapsible sections** - Organize your view by time of day
5. **Master config** - Batch adjust multiple compounds at once

---

That's it! You now have a fully functional AK Protocol iOS app. 🚀
