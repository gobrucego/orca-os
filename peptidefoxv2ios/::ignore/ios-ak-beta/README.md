# AK: 4 Week Intensive Protocol - iOS App

A native iOS app built with SwiftUI that displays the comprehensive 4-week AK peptide protocol with day-by-day dosing schedules, configurable compound doses, and automatic draw volume calculations.

## Features

- **4 Week Support** - Complete protocol data for Weeks 1-4 with proper dosing variations
- **Day-by-Day Selector** - View protocol for any day of the week (Sun-Sat)
- **Time-Based Sections** - Organized by time of day (Waking, AM, Mid-Day, Evening, Sleep & Recovery)
- **Dynamic Dosing** - Handles compounds that vary by day/week (Vyvanse, NAD+, Wellbutrin, etc.)
- **Configuration** - Master and individual compound adjustment dialogs
- **Persistence** - UserDefaults storage for all custom doses/concentrations
- **Draw Calculation** - Automatic mL calculation based on dose ÷ concentration
- **Collapsible Sections** - Clean, organized UI with expandable time sections

## Requirements

- macOS with Xcode 14.0 or later
- iOS 16.0+ deployment target
- Swift 5.0+

## Getting Started

### Option 1: Manual Setup in Xcode (Recommended)

**See [SETUP.md](SETUP.md) for detailed step-by-step instructions.**

Quick version:
1. Open Xcode
2. File → New → Project → iOS App
3. Name it `AKProtocol`, Interface: SwiftUI, Language: Swift
4. Add all source files from `AKProtocol/` directory
5. Run!

### Option 2: Automated Setup (Requires xcodegen)

If you have [xcodegen](https://github.com/yonaskolb/XcodeGen) installed:

```bash
cd ios-ak-beta
./create-xcode-project.sh
open AKProtocolProject/AKProtocol.xcodeproj
```

Install xcodegen with:
```bash
brew install xcodegen
```

## Project Structure

```
AKProtocol/
├── Models/
│   └── AKProtocolState.swift       # State management & data models
├── Views/
│   ├── AKProtocolView.swift        # Main view with week/day selectors
│   ├── MasterConfigSheet.swift     # Master configuration dialog
│   ├── CompoundAdjustSheet.swift   # Individual compound adjustment
│   └── Components/
│       ├── WeekSelector.swift      # Week 1-4 selector
│       ├── DaySelector.swift       # Sun-Sat day selector
│       ├── TimeSectionCard.swift   # Collapsible time section cards
│       └── CompoundTableView.swift # Compound display table
├── Data/
│   └── ProtocolData.swift          # All 4 weeks of protocol data
├── Utilities/
│   └── DrawVolumeCalculator.swift  # Dose/concentration calculations
├── AKProtocolApp.swift              # App entry point
└── Info.plist                       # App configuration
```

## Architecture

- **SwiftUI** - Modern declarative UI framework
- **Observable Objects** - State management with `@StateObject` and `@ObservedObject`
- **UserDefaults** - Local persistence for compound adjustments
- **Reusable Components** - Modular card-based UI components

## Key Components

### AKProtocolState
Observable state object that tracks:
- Selected week (1-4) and day (0-6 for Sun-Sat)
- Compound adjustments (custom doses, concentrations, notes)
- UserDefaults persistence

### Protocol Data
Hard-coded protocol data including:
- **30+ compounds** across all categories
- **Week-by-week schedules** with varying doses
- **Time-of-day categorization** (5 sections)
- **Schedule patterns** (daily, Mon/Wed/Fri, Sun/Tue/Thu/Sat, etc.)

### Compound Categories
- **Medications**: Vyvanse, Wellbutrin, Enclomiphene
- **HPTA**: hCG, Kisspeptin-10
- **Metabolic**: Retatrutide, AOD-9604, MOTS-C
- **Support**: VIP, SS-31, NAD+
- **Reprogramming**: N-Acetyl Semax, Adamax, N-Acetyl Selank, P21
- **Healing**: BPC-157 (L/R), TB-500 (L/R), GHK-Cu (L/R), KPV, hGH
- **Rest**: DSIP, Pinealon

## Dynamic Dosing

The app handles complex dosing patterns:

- **Vyvanse**: 30mg (Sun/Tue/Thu/Sat), 60mg (Mon/Wed/Fri)
- **Wellbutrin**: Tapers from 300mg → 225mg → 150mg across weeks
- **NAD+**: 200mg/150mg variations by week and day
- **MOTS-C**: Starts Week 2 only
- **Adamax**: Mon/Thu only, Weeks 2-4 (replaces Semax on those days)
- **Pinealon**: AM/PM dosing variations in Weeks 3-4

## Customization

### Adjusting Compounds
- **Individual Adjust**: Tap "Adjust" on any compound to modify dose/concentration/notes
- **Master Config**: Tap "Configure" in navigation bar to adjust all compounds at once
- **Reset**: Each adjustment dialog has a "Reset" button to restore defaults
- **Persistence**: All changes are automatically saved to UserDefaults

### Modifying Protocol Data
Edit `ProtocolData.swift` to:
- Add new compounds
- Modify weekly schedules
- Change default doses/concentrations
- Update notes

## Draw Volume Calculation

The app automatically calculates draw volumes:
- **µg to mg conversion** for mixed-unit calculations
- **IU handling** for hGH and hCG
- **Precision formatting** (0.001-10+ mL ranges)
- **Oral compounds** displayed as "oral" instead of volume

## Next Steps

Consider adding:
- [ ] Export protocol as PDF
- [ ] Calendar integration for injection scheduling
- [ ] Progress tracking and dose logging
- [ ] Dark mode support
- [ ] iPad optimization with split view
- [ ] Compound search/filter
- [ ] Dosing reminders/notifications

## License

Proprietary - Part of the PeptideFox ecosystem
