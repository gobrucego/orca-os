# AK Protocol iOS App - Setup Guide

This guide will walk you through setting up the AK Protocol iOS app in Xcode.

## Prerequisites

- macOS 12.0 or later
- Xcode 14.0 or later
- iOS 16.0+ deployment target

## Step 1: Create New Xcode Project

1. Open **Xcode**
2. Click **File** → **New** → **Project** (or press `⌘⇧N`)
3. Select **iOS** tab at the top
4. Choose **App** template
5. Click **Next**

## Step 2: Configure Project Settings

On the project options screen, enter:

- **Product Name**: `AKProtocol`
- **Team**: Select your development team (or leave as "None" for simulator only)
- **Organization Identifier**: `com.peptidefox` (or your own)
- **Bundle Identifier**: Will auto-generate as `com.peptidefox.AKProtocol`
- **Interface**: Select **SwiftUI**
- **Language**: Select **Swift**
- **Storage**: Leave **None** selected
- **Include Tests**: Unchecked (optional)

Click **Next**, choose a location to save, then click **Create**.

## Step 3: Add Source Files

### 3.1 Delete Default Files

In the Project Navigator (left sidebar), delete these auto-generated files:
- `ContentView.swift` (select and press Delete, choose "Move to Trash")
- Keep `AKProtocolApp.swift` - we'll replace its contents

### 3.2 Add Models

1. Right-click on the `AKProtocol` folder in Project Navigator
2. Select **New Group**, name it `Models`
3. Right-click on `Models` folder
4. Select **New File** → **Swift File**
5. Name it `AKProtocolState.swift`
6. Copy the contents from `ios-ak-beta/AKProtocol/Models/AKProtocolState.swift`

### 3.3 Add Data

1. Create a new group called `Data`
2. Add file `ProtocolData.swift`
3. Copy contents from `ios-ak-beta/AKProtocol/Data/ProtocolData.swift`

### 3.4 Add Utilities

1. Create a new group called `Utilities`
2. Add file `DrawVolumeCalculator.swift`
3. Copy contents from `ios-ak-beta/AKProtocol/Utilities/DrawVolumeCalculator.swift`

### 3.5 Add Views

1. Create a new group called `Views`
2. Inside `Views`, create a sub-group called `Components`

Add these files to `Views/`:
- `AKProtocolView.swift`
- `MasterConfigSheet.swift`
- `CompoundAdjustSheet.swift`

Add these files to `Views/Components/`:
- `WeekSelector.swift`
- `DaySelector.swift`
- `TimeSectionCard.swift`
- `CompoundTableView.swift`

Copy contents from corresponding files in `ios-ak-beta/AKProtocol/Views/`

### 3.6 Update App Entry Point

Replace the contents of `AKProtocolApp.swift` with:

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

## Step 4: Add Info.plist (Optional)

The Info.plist is automatically managed in modern Xcode projects, but you can add custom keys if needed.

1. Click on the project in Project Navigator (top-level blue icon)
2. Select the `AKProtocol` target
3. Go to the **Info** tab
4. Add custom keys as needed

## Step 5: Configure Deployment Target

1. Click on the project in Project Navigator
2. Select the `AKProtocol` target
3. In the **General** tab, set:
   - **Minimum Deployments**: iOS 16.0

## Step 6: Build and Run

1. Select a simulator from the scheme menu (e.g., "iPhone 15 Pro")
2. Press `⌘R` or click the Play button to build and run
3. The app should launch in the simulator

## Troubleshooting

### Build Errors

**Missing imports**: Make sure all files are added to the target
- Right-click file → **Show File Inspector**
- Check "Target Membership" box for `AKProtocol`

**SwiftUI Preview issues**:
- Use `⌘⌥P` to refresh previews
- Sometimes need to clean build folder (`⌘⇧K`)

### Common Issues

**"Cannot find type 'X' in scope"**
- Make sure the file containing that type is added to the project
- Check that there are no typos in type names
- Verify all files are in the correct groups

**Preview crashes**
- Try building the project first (`⌘B`)
- Restart Xcode
- Clear derived data: `⌘⇧K` then `⌘B`

**Simulator not launching**
- Quit and restart Simulator app
- Try a different simulator device
- Check Xcode → Preferences → Platforms for simulator installation

## File Organization Checklist

Your Project Navigator should look like this:

```
AKProtocol/
├── Models/
│   └── AKProtocolState.swift
├── Views/
│   ├── AKProtocolView.swift
│   ├── MasterConfigSheet.swift
│   ├── CompoundAdjustSheet.swift
│   └── Components/
│       ├── WeekSelector.swift
│       ├── DaySelector.swift
│       ├── TimeSectionCard.swift
│       └── CompoundTableView.swift
├── Data/
│   └── ProtocolData.swift
├── Utilities/
│   └── DrawVolumeCalculator.swift
├── Assets.xcassets/
├── AKProtocolApp.swift
└── Info.plist
```

## Next Steps

Once the app is running:

1. Test week selector (Week 1-4)
2. Test day selector (Sun-Sat)
3. Verify compounds display correctly
4. Test "Configure" button for master config
5. Test "Adjust" buttons on individual compounds
6. Verify draw volume calculations
7. Test persistence by adjusting a compound, closing app, and reopening

## Development Tips

- Use **Live Previews** for rapid UI iteration (`⌘⌥P`)
- Test on multiple simulators (iPhone SE, iPhone 15 Pro, iPad)
- Use **Console** to debug state changes
- Check UserDefaults in Console: `defaults read com.peptidefox.AKProtocol`

## Support

If you encounter issues:
1. Clean build folder: `⌘⇧K`
2. Rebuild: `⌘B`
3. Restart Xcode
4. Check that all files are properly added to the target

For more help, refer to the main [README.md](README.md).
