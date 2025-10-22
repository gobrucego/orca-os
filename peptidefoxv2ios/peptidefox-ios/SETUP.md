# PeptideFox iOS Setup Guide

## Quick Start (Recommended)

### Create Project in Xcode

1. **Open Xcode**

2. **Create a new project:**
   - File → New → Project
   - Select **iOS** tab
   - Choose **App** template
   - Click **Next**

3. **Configure the project:**
   - Product Name: `PeptideFox`
   - Team: (Select your team or leave blank)
   - Organization Identifier: `com.peptidefox` (or your own)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
   - Click **Next**

4. **Save location:**
   - Navigate to: `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/`
   - Click **Create**

5. **Add the source files:**

   **Delete the default files:**
   - Delete `ContentView.swift` (Xcode creates this by default)

   **Add the Models folder:**
   - Right-click on `PeptideFox` folder in Xcode
   - Select "Add Files to PeptideFox..."
   - Navigate to `peptidefox-ios/PeptideFox/Models/`
   - Select `GLPJourneyState.swift`
   - Make sure "Copy items if needed" is checked
   - Click Add

   **Add the Views folder:**
   - Right-click on `PeptideFox` folder in Xcode
   - Select "Add Files to PeptideFox..."
   - Navigate to `peptidefox-ios/PeptideFox/Views/`
   - Select all view files:
     - `GLPJourneyView.swift`
     - `AgentSelectionView.swift`
     - `FrequencySelectionView.swift`
     - `ProtocolOutputView.swift`
   - Make sure "Copy items if needed" is checked
   - Click Add

6. **Update the App file:**
   - Open `PeptideFoxApp.swift`
   - Replace its contents with the content from our `PeptideFox/PeptideFoxApp.swift`:

   ```swift
   import SwiftUI

   @main
   struct PeptideFoxApp: App {
       var body: some Scene {
           WindowGroup {
               GLPJourneyView()
           }
       }
   }
   ```

7. **Run the app:**
   - Select a simulator (iPhone 14 Pro recommended)
   - Press **⌘R** or click the Play button
   - The app should build and run!

## Alternative: Use Terminal Script

I can create a script that does this automatically. Would you like me to create a setup script?

## Project Structure

After setup, your Xcode project should look like:

```
PeptideFox/
├── PeptideFoxApp.swift              ← Entry point (modified)
├── Models/
│   └── GLPJourneyState.swift        ← State & data models
└── Views/
    ├── GLPJourneyView.swift         ← Main coordinator
    ├── AgentSelectionView.swift     ← Step 1
    ├── FrequencySelectionView.swift ← Step 2
    └── ProtocolOutputView.swift     ← Step 3
```

## Troubleshooting

### "Cannot find GLPJourneyView in scope"
- Make sure all view files are added to the project
- Check that files have the correct target membership (PeptideFox target)

### Preview crashes
- Previews work for individual views
- Some previews need the state object initialized
- Use the simulators for full testing

### Build errors
- Make sure deployment target is iOS 16.0+
- Check that all files are included in the target

## Next Steps

Once running, you can:
- Test the flow by selecting different agents and frequencies
- Customize the colors and styling
- Add persistence with UserDefaults
- Integrate with your backend API
- Add more features (calendar, tracking, etc.)
