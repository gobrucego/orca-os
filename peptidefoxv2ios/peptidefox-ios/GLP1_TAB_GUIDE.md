# GLP-1 Tab Quick Reference Guide

## Tab Bar Structure

```
┌─────────────────────────────────────────────────┐
│                                                 │
│                    App Content                  │
│                                                 │
└─────────────────────────────────────────────────┘
┌─────────┬─────────┬─────────┬─────────┐
│    ∫    │  📚    │  ⚡︎⎺   │   👤   │
│Calculator│Library │ GLP-1  │ Profile│
│  Tab 0  │ Tab 1  │ Tab 2  │  Tab 3 │
└─────────┴─────────┴─────────┴─────────┘
```

## GLP-1 Journey Flow

### Navigation Flow
```
Tab Bar (GLP-1) 
    ↓
GLPJourneyView
    ↓
┌─────────────────────────────────────────┐
│  Step 1: Agent Selection                │
│  ├─ Semaglutide (Ozempic/Wegovy)       │
│  ├─ Tirzepatide (Mounjaro/Zepbound)    │
│  └─ Retatrutide (Research)             │
│                                         │
│  [Back]              [Continue] →       │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│  Step 2: Frequency Selection            │
│  ├─ Weekly (52/year)                   │
│  ├─ Twice Weekly (104/year)            │
│  ├─ Q3D - Every 3 Days (~120/year)     │
│  └─ Q2D - Every 2 Days (~180/year)     │
│                                         │
│  [Back]        [View Protocol] →        │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│  Step 3: Protocol Output                │
│  ┌────────────────────────────────┐    │
│  │ Protocol Summary               │    │
│  │ Agent: Semaglutide             │    │
│  │ Frequency: Twice Weekly        │    │
│  └────────────────────────────────┘    │
│                                         │
│  Protocol Phases:                       │
│  ├─ Initiation (Weeks 1-4): 0.25mg     │
│  ├─ Titration 1 (Weeks 5-8): 0.5mg     │
│  ├─ Titration 2 (Weeks 9-12): 1.0mg    │
│  └─ Maintenance (Weeks 13-16): 2.0mg   │
│                                         │
│  [Generate Default Protocol]            │
└─────────────────────────────────────────┘
```

## Code Structure

### Entry Point
**File**: `/PeptideFox/Core/Presentation/ContentView.swift`

```swift
GLPJourneyView()
    .tabItem {
        Label("GLP-1", systemImage: "waveform.path.ecg")
    }
    .tag(2)
```

### Main View
**File**: `/PeptideFox/Views/GLPJourneyView.swift`

```swift
struct GLPJourneyView: View {
    @StateObject private var state = GLPJourneyState()
    @State private var currentStep = 1
    
    var body: some View {
        // Step progress indicator
        // TabView for step content
        // Navigation buttons
    }
}
```

### State Management
**File**: `/PeptideFox/Models/GLPJourneyState.swift`

```swift
class GLPJourneyState: ObservableObject {
    @Published var agent: GLPAgent?
    @Published var frequency: DosingFrequency?
    @Published var phases: [ProtocolPhase] = []
    @Published var protocolDuration: Int = 16
}
```

## Data Models

### GLPAgent
```swift
enum GLPAgent: String, CaseIterable {
    case semaglutide      // Ozempic/Wegovy
    case tirzepatide      // Mounjaro/Zepbound
    case retatrutide      // Research compound
}
```

### DosingFrequency
```swift
enum DosingFrequency: String, CaseIterable {
    case weekly           // 52 injections/year
    case twiceWeekly      // 104 injections/year
    case q3d              // ~120 injections/year
    case q2d              // ~180 injections/year
}
```

### ProtocolPhase
```swift
struct ProtocolPhase: Identifiable {
    let id: UUID
    var name: String
    var startWeek: Int
    var endWeek: Int
    var dose: Double
    var frequency: DosingFrequency
}
```

## UI Components

### AgentCard
- Agent name and brand names
- Description text
- "Best For" bullet points
- Metrics bars (Intensity, Tolerability, Metabolic Scope)
- Selection indicator (checkmark)

### FrequencyCard
- Frequency name and annual injection count
- Metrics (Stability, Side Effects, Ease)
- Pros list
- "Best For" description
- Selection indicator

### PhaseCard
- Phase name
- Week range
- Dose amount
- Frequency badge
- Delete button

## Testing Checklist

### Tab Navigation
- [ ] Tab shows "GLP-1" label
- [ ] Tab shows waveform.path.ecg icon
- [ ] Tapping tab loads GLPJourneyView
- [ ] Tab highlight color matches brand primary

### Step 1: Agent Selection
- [ ] 3 agent cards visible
- [ ] Cards show all required info
- [ ] Tapping selects agent (visual feedback)
- [ ] Continue button enables after selection
- [ ] Selection banner appears

### Step 2: Frequency Selection  
- [ ] 4 frequency cards in 2x2 grid
- [ ] Cards show metrics and pros
- [ ] Tapping selects frequency
- [ ] View Protocol button enables
- [ ] Selection banner appears

### Step 3: Protocol Output
- [ ] Summary shows selected agent/frequency
- [ ] "Generate Default Protocol" works
- [ ] Phase cards display correctly
- [ ] Delete phase button works
- [ ] Correct titration schedule for agent

### Navigation
- [ ] Progress indicator shows current step
- [ ] Completed steps show checkmark
- [ ] Can navigate back to previous steps
- [ ] Back button disabled on step 1
- [ ] Continue button disabled without selection

### Visual
- [ ] Consistent spacing and padding
- [ ] Clean animations (0.2s duration)
- [ ] Proper shadows (minimal)
- [ ] Responsive to different screen sizes
- [ ] Typography hierarchy clear

## Quick Commands

### Build & Run
```bash
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios
open PeptideFox.xcodeproj
# In Xcode: Cmd+R to run
```

### View in Simulator
1. Launch Xcode
2. Select PeptideFox scheme
3. Choose iPhone 15 simulator
4. Press Cmd+R
5. Tap GLP-1 tab (3rd tab)

### Test Complete Flow
1. Tap GLP-1 tab
2. Select agent (e.g., Semaglutide)
3. Tap Continue
4. Select frequency (e.g., Twice Weekly)
5. Tap View Protocol
6. Tap Generate Default Protocol
7. Review phases
8. Test delete phase
9. Tap completed step to go back

## Files Changed

### Modified
- `PeptideFox/Core/Presentation/ContentView.swift` - Tab bar configuration

### Unchanged (Used)
- `PeptideFox/Views/GLPJourneyView.swift` - Main journey view
- `PeptideFox/Views/AgentSelectionView.swift` - Step 1
- `PeptideFox/Views/FrequencySelectionView.swift` - Step 2
- `PeptideFox/Views/ProtocolOutputView.swift` - Step 3
- `PeptideFox/Models/GLPJourneyState.swift` - State management
- `PeptideFox/Core/ViewModels/GLP1PlannerViewModel.swift` - View model

## Notes

- No persistence implemented (state resets on app restart)
- Future enhancement: Save protocols to UserDefaults/CoreData
- Future enhancement: Integration with calculator
- Future enhancement: Share protocols as PDF/image
- Protocols tab code still exists but not shown in tab bar
