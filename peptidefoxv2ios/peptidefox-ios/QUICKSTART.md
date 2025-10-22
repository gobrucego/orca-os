# 🚀 PeptideFox iOS - Quick Start

## The Fastest Way to Get Running

### Step 1: Open Xcode
```bash
open -a Xcode
```

### Step 2: Create New Project
1. File → New → Project (or press ⇧⌘N)
2. Select **iOS** → **App**
3. Click **Next**

### Step 3: Configure Project
- **Product Name:** `PeptideFox`
- **Team:** (Your team or leave blank)
- **Organization Identifier:** `com.peptidefox`
- **Interface:** **SwiftUI** ← Important!
- **Language:** **Swift** ← Important!
- **Storage:** None
- **Include Tests:** Unchecked (optional)

Click **Next**

### Step 4: Save Location
- Save anywhere you like (Desktop is fine)
- Click **Create**

### Step 5: Add Source Files

**In Xcode:**

1. **Delete** `ContentView.swift` (Xcode creates this, we don't need it)

2. **Create Models folder:**
   - Right-click `PeptideFox` (blue folder icon)
   - New Group
   - Name it `Models`

3. **Add Model files:**
   - Right-click the `Models` folder
   - Add Files to "PeptideFox"...
   - Navigate to: `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Models/`
   - Select **BOTH** files:
     - `GLPJourneyState.swift`
     - `CalculatorState.swift`
   - ✅ Make sure "Copy items if needed" is **CHECKED**
   - Click **Add**

4. **Create Views folder:**
   - Right-click `PeptideFox` (blue folder icon)
   - New Group
   - Name it `Views`

5. **Add all View files:**
   - Right-click the `Views` folder
   - Add Files to "PeptideFox"...
   - Navigate to: `/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/Views/`
   - **Select ALL 5 files:**
     - `AgentSelectionView.swift`
     - `FrequencySelectionView.swift`
     - `ProtocolOutputView.swift`
     - `GLPJourneyView.swift`
     - `CalculatorView.swift` ⭐ NEW!
   - ✅ Make sure "Copy items if needed" is **CHECKED**
   - Click **Add**

### Step 6: Update App Entry Point

1. Open `PeptideFoxApp.swift` in Xcode
2. Replace the entire file contents with:

```swift
import SwiftUI

@main
struct PeptideFoxApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            CalculatorView()
                .tabItem {
                    Label("Calculator", systemImage: "function")
                }

            GLPJourneyView()
                .tabItem {
                    Label("GLP Journey", systemImage: "map")
                }
        }
    }
}
```

### Step 7: Run! 🎉

1. Select a simulator: **iPhone 15 Pro** (or any iPhone)
2. Press **⌘R** or click the ▶️ Play button
3. Wait for build to complete
4. The app should launch in the simulator!

## What You'll See

The app has **2 tabs** at the bottom:

### Tab 1: Calculator 🧮
1. **Select Peptide** - Choose from GLP-1s, healing peptides, NAD+, etc.
2. **Vial Size** - Enter or select your vial size in mg
3. **Bacteriostatic Water** - How much water you're adding
4. **Desired Dose** - The dose you want to inject
5. **See Results** - Get concentration, draw volume, units, and doses per vial

### Tab 2: GLP Journey 🗺️
1. **Step 1:** Choose your GLP agent (Semaglutide, Tirzepatide, or Retatrutide)
2. **Step 2:** Select dosing frequency (Weekly, 2x/week, q3d, q2d)
3. **Step 3:** View your protocol with auto-generated phases

## Troubleshooting

### Build Error: "Cannot find 'GLPJourneyView' in scope"
- Make sure all `.swift` files are added to the project
- Check file inspector (⌥⌘1) → Target Membership → PeptideFox should be checked

### Files appear gray in Xcode
- They're not added to the target
- Select the file → File Inspector → Target Membership → Check PeptideFox

### Simulator doesn't open
- Xcode → Preferences → Locations → Command Line Tools should be set
- Try: Product → Clean Build Folder (⇧⌘K)

## Next Steps

Once it's running, you can:
- **Customize colors** - Edit the Color values in the view files
- **Add persistence** - Use UserDefaults to save selections
- **Add more features** - Calendar view, progress tracking, etc.
- **Test on device** - Connect your iPhone and select it as the run destination

---

**Need help?** Check [SETUP.md](SETUP.md) for detailed instructions with screenshots.
