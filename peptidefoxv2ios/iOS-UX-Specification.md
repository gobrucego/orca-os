# Peptide Fox iOS UX Specification
**iOS 17+ Native Translation**
**Version 1.0 | January 2025**

---

## Executive Summary

This document provides a comprehensive UX analysis and translation strategy for converting Peptide Fox (web app) into a native iOS application. Peptide Fox is a **medical precision tool** for peptide dosing calculations, GLP-1 therapy planning, and protocol management. The iOS translation must prioritize **safety, clarity, and rapid access** over aesthetic experimentation.

**Core Constraint**: This is a medical tool—clarity and precision matter more than clever interactions.

---

## 1. User Flow Analysis

### 1.1 Critical User Journeys (Web → iOS Translation)

#### **Journey A: Quick Dose Calculation** (Highest Frequency)
**Web Flow:**
1. Navigate to Calculator (`/tools/calculator`)
2. Select compound (Semaglutide, Tirzepatide, custom peptide)
3. Input vial size (5mg, 10mg, custom)
4. Choose input mode: Concentration OR Bacteriostatic water volume
5. Enter target dose (0.25mg - 15mg range)
6. Select device type (Insulin pen, 30/50/100-unit syringe)
7. View results: draw volume (mL), syringe units, concentration
8. View safety warnings (storage, reconstitution, clinical notes)

**iOS Improvements:**
- **Quick Action**: 3D Touch home screen → "Calculate Last Dose" (pre-fills previous calculation)
- **Widget**: Recent calculation card on home screen shows last dose + next injection date
- **Haptic Feedback**: Validation success (soft tap), error (double tap), calculation complete (success pattern)
- **Pain Points Solved**:
  - Web: Multi-step navigation through dropdown menus
  - iOS: Single-screen form with smart defaults + compound picker sheet
  - Web: Manual tracking of recent calculations
  - iOS: Automatic history saved to CloudKit, searchable via Spotlight

**iOS-Specific Flow:**
```
Tab: Calculator
  ├─ Compound Picker (Bottom Sheet)
  │   ├─ Recently Used (3 items)
  │   ├─ GLP-1s (Semaglutide, Tirzepatide, Retatrutide)
  │   └─ All Peptides (30+ searchable)
  │
  ├─ Vial Size Segmented Control (5mg | 10mg | Custom)
  ├─ Input Mode Toggle (Concentration ⟷ Water Volume)
  ├─ Target Dose Stepper + Decimal Pad
  ├─ Device Picker (Pen | Syringe 30 | 50 | 100)
  │
  └─ Results Card (Auto-updates)
      ├─ Concentration (mg/mL)
      ├─ Draw Volume (mL + units visual)
      ├─ Doses Per Vial
      └─ Safety Alerts (expandable)
```

---

#### **Journey B: GLP-1 Protocol Builder** (2nd Highest)
**Web Flow:**
1. `/glp-1/journey` → Stepped flow (3 steps)
2. Step 1: Select agent (Semaglutide | Tirzepatide | Retatrutide)
3. Step 2: Choose frequency (Weekly | Every 5 days | Twice weekly | Daily)
4. Step 3: View protocol with phases (Start → Build → Maintain)
5. Add support peptides (Tesamorelin, L-Carnitine, MOTS-c)
6. Export protocol (PDF/share)

**iOS Improvements:**
- **Modal Stack Navigation**: Step-by-step wizard with progress indicator
- **Interactive Protocol Timeline**: Drag to adjust phase durations
- **Health App Integration**: Export dose schedule to Health as "Medication" entries
- **Shortcuts Integration**:
  - "Start Semaglutide 0.25mg weekly" → Pre-fills calculator + adds to Health
  - "Next GLP dose" → Shows next scheduled injection + calculates dose

**Pain Points Solved:**
- Web: Linear flow, can't adjust after generation
- iOS: Editable protocol with live recalculation
- Web: No integration with device ecosystem
- iOS: Export to Calendar, Health, Reminders

---

#### **Journey C: Peptide Library Browsing**
**Web Flow:**
1. `/library` → Grid of 30+ peptide cards
2. Filter by category (GLP, Healing, Metabolic, Cognitive)
3. Tap card → Detail view (mechanism, dosing, synergies)

**iOS Improvements:**
- **Search**: Native iOS search bar with scope buttons (All | GLP | Healing | Metabolic)
- **Quick Actions**: Long-press peptide card → "Calculate Dose" | "Add to Protocol" | "Share"
- **iPad Split View**:
  - Master: Peptide list (filterable)
  - Detail: Full peptide reference with tabbed sections (Dosing | Safety | Synergies)

**Flow Optimization:**
```
Tab: Library
  ├─ Search Bar (scope: All, GLP, Healing, etc.)
  ├─ Category Chips (horizontal scroll)
  ├─ Peptide List (grouped by category)
  │   └─ Long-press → Context Menu
  │       ├─ Calculate Dose
  │       ├─ Add to Protocol
  │       └─ Share Reference
  │
  └─ Detail View (modal sheet)
      ├─ Header (name, category badge)
      ├─ Tabs: Dosing | Safety | Synergies | Research
      └─ Footer Actions: Calculate | Add to Protocol
```

---

### 1.2 User Journey Comparison Table

| Journey | Web Steps | iOS Steps | Key iOS Enhancement |
|---------|-----------|-----------|---------------------|
| Quick Calculation | 7 taps/inputs | 5 taps/inputs | Smart defaults, Widget access |
| GLP Protocol | 8 screens | 6 screens | Editable timeline, Health export |
| Peptide Browse | 3 taps | 2 taps | Native search, Context menus |
| Recent Calculation | Manual nav | 1 tap | Widget shows last 3 calculations |

---

## 2. iOS Navigation Architecture

### 2.1 Recommended Tab Structure

```
TabBar (5 tabs, bottom)
├─ Calculator (SF Symbol: function)
│   └─ Primary landing: Single-screen dose calculator
│
├─ GLP-1 (SF Symbol: waveform.path.ecg)
│   ├─ Comparison Tool (Semaglutide vs Tirzepatide vs Retatrutide)
│   ├─ Protocol Builder (Stepped flow)
│   └─ Journey Tracker (Active protocol timeline)
│
├─ Protocols (SF Symbol: calendar.badge.clock)
│   ├─ Active (Draft → Active → Completed state)
│   ├─ Templates (Pre-built stacks: GLOW, Wolverine, MITO)
│   └─ History (Archived protocols)
│
├─ Library (SF Symbol: books.vertical)
│   ├─ All Peptides (30+ cards, searchable)
│   └─ Favorites (user-saved peptides)
│
└─ Profile (SF Symbol: person.crop.circle)
    ├─ Recent Calculations (history)
    ├─ Settings (units, defaults, notifications)
    └─ Health Integration (connect to Apple Health)
```

### 2.2 Navigation Patterns

**Modal Presentations:**
- **Sheet (Default)**: Peptide detail views, safety warnings, protocol phases
  - Rationale: Quick dismiss, maintains context
  - Detent: Medium (50%) for safety warnings, Large (90%) for full details

- **Full-Screen**: Protocol Builder wizard, GLP Comparison deep dive
  - Rationale: Complex multi-step flows need focus
  - Navigation: Custom back/continue buttons (no swipe-to-dismiss)

**Navigation Stack:**
- Tab → List → Detail (standard pattern)
- Deep linking support: `peptidefox://calculator/semaglutide/0.25mg`

**iPad Split-View:**
```
Master (1/3 width)          Detail (2/3 width)
────────────────────        ────────────────────
Peptide List                Peptide Detail
 - BPC-157         →        ┌─────────────────┐
 - TB-500                   │ BPC-157         │
 - GHK-Cu                   │ Body Protection │
 - Semaglutide              │ ─────────────── │
                            │ [Dosing]        │
                            │ [Safety]        │
                            │ [Synergies]     │
                            └─────────────────┘
```

---

## 3. Input Method Optimization

### 3.1 Keyboard Types by Context

| Input Field | Keyboard Type | Rationale |
|-------------|---------------|-----------|
| Target Dose (mg) | `.decimalPad` | Medical precision: 0.25, 0.5, 1.0, 1.7, 2.4 |
| Vial Size (mg) | `.numberPad` | Whole numbers: 5, 10, 15 |
| Water Volume (mL) | `.decimalPad` | Precision: 1.0, 1.5, 2.0, 2.5 |
| Frequency Days | `.numberPad` | Whole numbers: 1, 2, 3, 5, 7 |
| Compound Search | `.default` | Text autocomplete |

**Keyboard Accessory View:**
```swift
Custom toolbar above keyboard:
[0.25] [0.5] [1.0] [1.7] [2.4] [Done]
       ↑ Common GLP doses as quick-tap buttons
```

### 3.2 Steppers vs Sliders

**Use Steppers for:**
- Target dose (0.25mg increments)
  - Increment: 0.25mg for GLP-1s, 0.1mg for others
  - Min: 0.1mg, Max: 15mg
  - Display: "0.25 mg" with 2 decimal precision

**Use Sliders for:**
- Protocol duration (4-24 weeks)
  - Haptic feedback at: 4, 8, 12, 16, 24 weeks
  - Visual markers at common intervals

**Use Pickers for:**
- Device selection (Pen | Syringe 30 | 50 | 100)
  - UIPickerView in sheet (iOS native, no custom wheels)
- Compound selection (30+ peptides)
  - Searchable sheet with sections (GLP | Healing | Metabolic)

### 3.3 Form Validation UX

**Inline Validation:**
```swift
Real-time feedback as user types:
  ┌─────────────────────────────┐
  │ Target Dose                 │
  │ ┌───────────────────────┐   │
  │ │ 25.0                  │ ✗ │ ← Red X icon
  │ └───────────────────────┘   │
  │ ⚠ Maximum dose is 15.0mg    │ ← Inline error, orange
  └─────────────────────────────┘

Successful validation:
  ┌─────────────────────────────┐
  │ Target Dose                 │
  │ ┌───────────────────────┐   │
  │ │ 2.4                   │ ✓ │ ← Green checkmark
  │ └───────────────────────┘   │
  └─────────────────────────────┘
```

**Submit Validation:**
- Calculate button disabled until all required fields valid
- Button states:
  - Disabled: Gray, 60% opacity
  - Active: Blue, pulsing subtle shadow
  - Loading: ActivityIndicator inside button

**Error Hierarchy:**
1. **Critical** (Red, blocks calculation): Dose > max, incompatible device
2. **Warning** (Orange, allows calculation): Volume < 0.05mL (hard to measure)
3. **Info** (Blue, suggestion): "Try 2.0mL water for easier measurement"

---

## 4. iOS-Specific Enhancements

### 4.1 Quick Actions (3D Touch / Haptic Touch)

**Home Screen Quick Actions:**
```swift
1. Calculate Last Dose
   - Pre-fills last used compound + dose
   - Deep link: peptidefox://calculator/recent

2. New GLP Calculation
   - Opens calculator with GLP-1 compounds preselected
   - Deep link: peptidefox://calculator/glp

3. View Active Protocol
   - Jumps to active protocol timeline
   - Deep link: peptidefox://protocols/active

4. Search Peptides
   - Opens Library tab with search bar focused
   - Deep link: peptidefox://library/search
```

### 4.2 Widget Opportunities

**Small Widget (2x2):**
```
┌──────────────────┐
│ Next Dose        │
│ ──────────────── │
│ Semaglutide      │
│ 1.0 mg           │
│ Tomorrow, 8 AM   │
└──────────────────┘
```

**Medium Widget (4x2):**
```
┌─────────────────────────────────────┐
│ Recent Calculations                 │
│ ─────────────────────────────────── │
│ Semaglutide  1.0mg → 0.40mL  (2hr)  │
│ BPC-157      250µg → 0.12mL  (5hr)  │
│ Tirzepatide  7.5mg → 0.30mL  (1d)   │
└─────────────────────────────────────┘
```

**Large Widget (4x4):**
```
┌─────────────────────────────────────┐
│ Active Protocol: Semaglutide        │
│ ─────────────────────────────────── │
│ Week 8 of 16 - Build Phase          │
│                                     │
│ ████████░░░░░░░░ 50%                │
│                                     │
│ Current Dose: 1.0mg weekly          │
│ Next Dose: Tomorrow, 8:00 AM        │
│ Next Increase: Week 12 → 1.7mg      │
│                                     │
│ [Tap to Open Protocol]              │
└─────────────────────────────────────┘
```

**Widget Update Strategy:**
- Small: Refreshes hourly (shows next dose countdown)
- Medium: On calculation (adds to recent list)
- Large: Daily + protocol state changes (dose increase, phase transition)

### 4.3 Siri Shortcuts Integration

**Built-in Intents:**

1. **"Calculate my [peptide] dose"**
   ```swift
   Shortcut: Calculate Dose
   Parameters:
     - Peptide Name (String, autocomplete from library)
     - Dose Amount (Decimal, optional)
   Action:
     → Opens calculator with peptide pre-selected
     → If dose provided, fills target dose field
   ```

2. **"When is my next GLP dose?"**
   ```swift
   Shortcut: Next GLP Dose
   Parameters: None
   Response:
     → Spoken: "Your next Semaglutide dose is tomorrow at 8 AM, 1.0 milligrams"
     → Shows card with calculation details
   ```

3. **"Log [peptide] injection"**
   ```swift
   Shortcut: Log Injection
   Parameters:
     - Peptide Name (String)
     - Dose (Decimal)
     - Time (Date, defaults to now)
   Action:
     → Saves to protocol history
     → Updates next dose date
     → Writes to Apple Health
   ```

**Custom Shortcuts (User-Created):**
- "Morning Protocol" → Calculate L-Carnitine + MOTS-c + show next GLP dose
- "Pre-Workout Stack" → Calculate BPC-157 + TB-500 doses
- "Weekly Check-In" → Show protocol progress + next dose schedule

### 4.4 Haptic Feedback Points

**Haptic Patterns (using UIImpactFeedbackGenerator):**

| Event | Haptic Pattern | Style | Rationale |
|-------|----------------|-------|-----------|
| Calculation Complete | Single Medium | `.medium` | Confirms action success |
| Validation Error | Double Light | `.light` | Attention without alarm |
| Dose Warning (>80% max) | Triple Heavy | `.heavy` | Critical safety alert |
| Phase Transition | Single Heavy | `.heavy` | Significant milestone |
| Stepper Increment | Single Light | `.light` | Tactile feedback per step |
| Slider Snap Point | Single Soft | `.soft` | Detent at common values |
| Device Selection Change | Single Medium | `.medium` | Confirms device switch |
| Protocol Save | Success Pattern | Custom | Celebration + confirmation |

**Safety-Critical Haptics:**
- **Dose > 90% max**: Triple vibration + red flash
- **Incompatible device**: Double vibration + amber highlight
- **Storage temperature warning**: Single long vibration

---

## 5. Accessibility Strategy

### 5.1 VoiceOver Label Patterns

**Medical Data Precision:**
```swift
// BAD:
label: "1.0"

// GOOD:
label: "One point zero milligrams"
hint: "Target dose for Semaglutide"

// BAD:
label: "0.40"

// GOOD:
label: "Zero point four zero milliliters"
hint: "Draw volume using insulin pen"
```

**Complex Calculations:**
```swift
Results Card VoiceOver:
"Calculation results.
 Concentration: Five milligrams per milliliter.
 Draw volume: Zero point four milliliters, or forty units.
 This gives you twenty doses per vial.
 Swipe right for safety warnings."
```

**Protocol Timeline:**
```swift
Phase Card VoiceOver:
"Week eight of sixteen. Build phase.
 Current dose: One point zero milligrams weekly.
 Next increase: Week twelve, increase to one point seven milligrams.
 Double tap to edit phase."
```

### 5.2 Dynamic Type Handling

**Text Scaling Support:**
- Base font: SF Pro Text 16pt → Scales to 53pt (Accessibility XXL)
- Layout: Stack views with flexible spacing (never fixed heights)
- Critical data: `.scaledFont` with max 28pt (readability + layout stability)

**Truncation Prevention:**
```swift
Problem zones:
- Peptide names in list cells (e.g., "Thymosin Alpha-1")
- Dose + unit labels ("0.25 mg" must stay together)
- Safety warnings (multi-line expansion)

Solution:
- Use `.lineLimit(nil)` for expandable content
- `.minimumScaleFactor(0.75)` for compact cells only
- Horizontal scrolling for wide data (dose tables)
```

**Layout Adaptation:**
```
Default (16pt):
┌─────────────────────┐
│ Semaglutide         │
│ 1.0 mg → 0.40 mL    │
└─────────────────────┘

XXL (53pt):
┌─────────────────────┐
│ Semaglutide         │
│                     │
│ 1.0 mg              │
│ ↓                   │
│ 0.40 mL             │
└─────────────────────┘
```

### 5.3 Color Contrast Plan

**Medical Data Readability:**

All text meets WCAG AA (4.5:1 minimum, 7:1 target):

| Element | Foreground | Background | Contrast Ratio |
|---------|------------|------------|----------------|
| Primary text | `#1e293b` (slate-900) | `#ffffff` (white) | 16.1:1 ✓ |
| Secondary text | `#475569` (slate-600) | `#ffffff` | 8.6:1 ✓ |
| Dose input | `#0f172a` (slate-950) | `#f8fafc` (slate-50) | 18.2:1 ✓ |
| Error text | `#dc2626` (red-600) | `#ffffff` | 5.9:1 ✓ |
| Warning text | `#d97706` (amber-600) | `#fffbeb` (amber-50) | 6.2:1 ✓ |
| Success text | `#059669` (emerald-600) | `#ffffff` | 4.7:1 ✓ |

**High Contrast Mode Support:**
- Increase border weights: 1pt → 2pt
- Replace subtle shadows with solid borders
- Button states: Outlined style with 3pt borders

### 5.4 Minimum Touch Target Verification

**44pt Rule Compliance:**

| Element | Web Size | iOS Size | Status |
|---------|----------|----------|--------|
| Calculate Button | 40px | 50pt | ✓ Exceeds |
| Device Picker Row | 36px | 44pt | ✓ Meets |
| Stepper Buttons | 32px | 44pt | ✓ Upgraded |
| Tab Bar Icons | 28px | 44pt | ✓ Meets |
| Context Menu Items | 40px | 48pt | ✓ Exceeds |
| Slider Thumb | 24px | 44pt | ✓ Upgraded |

**Compact Spacing Exceptions:**
- iPad landscape: Minimum 50pt (more room)
- Scrollable lists: 44pt minimum, 52pt recommended
- Toolbars: 44pt minimum (56pt for primary actions)

---

## 6. iOS Enhancement Opportunities (Unique to Mobile)

### 6.1 Camera Integration
**Barcode Scanning for Vial Info:**
```swift
Use Case: User receives peptide vial with barcode
Flow:
  1. Tap "Scan Vial" button in calculator
  2. Camera opens with overlay guide
  3. Scan barcode → Extracts vial size (5mg/10mg)
  4. Auto-fills vial size + compound name (if encoded)
  5. User continues with dose entry

OCR Fallback:
  - Text recognition for handwritten labels
  - Extracts: "Semaglutide 5mg" → Pre-fills calculator
```

### 6.2 Notifications Strategy
**Dose Reminders:**
```swift
Trigger: Protocol-based schedule (e.g., Weekly Semaglutide)
Notification:
  Title: "Semaglutide Dose Due"
  Body: "1.0 mg injection scheduled for today at 8:00 AM"
  Actions:
    - "Calculate Dose" → Deep link to calculator
    - "Snooze 1 Hour"
    - "Mark as Taken" → Log to history

Frequency:
  - 1 hour before scheduled time
  - On scheduled time
  - Daily reminder if missed (up to 3 days)
```

**Storage Expiry Alerts:**
```swift
Trigger: 28 days after vial reconstitution date
Notification:
  Title: "Peptide Expiring Soon"
  Body: "Semaglutide vial expires tomorrow (reconstituted 27 days ago)"
  Actions:
    - "View Details" → Shows storage guidelines
    - "Dispose" → Mark vial as expired
```

### 6.3 Apple Health Integration
**Write to Health:**
```swift
Data Types:
  - HKQuantityType.quantityType(forIdentifier: .dietaryVitaminB12)!
    → Repurposed for peptide injections (no native type)
  - HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
    → Track injection timing correlation with sleep quality

Metadata:
  - Peptide name: "Semaglutide"
  - Dose: 1.0 mg
  - Injection site: "Abdomen" (user-selected)
  - Device type: "Insulin Pen"
```

**Read from Health:**
```swift
Correlations:
  - Weight trend (HKQuantityType.bodyMass) → Chart vs GLP dose
  - Sleep quality (HKCategoryType.sleepAnalysis) → vs GH peptides
  - Heart rate (HKQuantityType.heartRate) → vs Retatrutide dose
```

### 6.4 iCloud Sync
**CloudKit Schema:**
```swift
Record Types:
  1. Calculation
     - id: UUID
     - compound: String
     - vialSize: Double
     - targetDose: Double
     - concentration: Double
     - drawVolume: Double
     - deviceType: String
     - timestamp: Date

  2. Protocol
     - id: UUID
     - name: String
     - agent: String (GLP agent)
     - frequency: String
     - phases: [Phase]
     - supportPeptides: [Peptide]
     - state: String (DRAFT | ACTIVE | COMPLETED)

  3. UserPreferences
     - defaultUnits: String
     - defaultDevice: String
     - notificationsEnabled: Bool
```

**Sync Strategy:**
- Calculations: Sync last 100 (30-day rolling window)
- Protocols: Sync all (unlimited)
- User preferences: Real-time sync

### 6.5 Spotlight Integration
**Indexed Content:**
```swift
1. Peptides (30+ searchable)
   - Title: "Semaglutide"
   - Description: "GLP-1 for weight loss & CV protection"
   - Keywords: ["GLP", "appetite", "weight loss", "diabetes"]
   - Deep link: peptidefox://library/semaglutide

2. Recent Calculations
   - Title: "Semaglutide 1.0mg calculation"
   - Description: "0.40 mL draw volume, calculated 2 hours ago"
   - Deep link: peptidefox://calculator/recent/[id]

3. Active Protocols
   - Title: "GLP-1 Protocol (Week 8)"
   - Description: "Build phase, 1.0mg weekly"
   - Deep link: peptidefox://protocols/active
```

**Search Experience:**
```
Spotlight Search: "semaglutide"

Results:
┌──────────────────────────────────────┐
│ 📱 Peptide Fox                       │
│ Semaglutide (Peptide)                │
│ GLP-1 for weight loss & CV protection│
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ 📱 Peptide Fox                       │
│ Semaglutide 1.0mg (Calculation)      │
│ 0.40 mL draw volume · 2 hours ago    │
└──────────────────────────────────────┘
```

---

## 7. Design System Adaptations

### 7.1 Typography (iOS Native)
**Replace Web Fonts with SF:**
- **Brown LL (Web)** → **SF Pro Display** (iOS)
  - Weights: Light (300) → Regular (400) → Semibold (600)
  - Use for: Headlines, hero text, protocol phase titles

- **Sharp Sans No2 (Web)** → **SF Pro Text** (iOS)
  - Weights: Regular (400) → Medium (500)
  - Use for: Body text, input labels, button labels

**Medical Precision Text:**
```swift
Dose values: SF Mono (monospaced numbers)
  - Prevents layout shift when values change
  - Example: "0.25" → "1.00" (same width)
```

### 7.2 Color Adaptation
**Web → iOS Mapping:**

| Web Token | iOS Dynamic Color | Light Mode | Dark Mode |
|-----------|-------------------|------------|-----------|
| `--color-page` (#f8fafc) | `.systemGroupedBackground` | #f2f2f7 | #000000 |
| `--slate-900` (#1e293b) | `.label` | #000000 | #ffffff |
| `--slate-600` (#475569) | `.secondaryLabel` | #3c3c43 (60%) | #ebebf5 (60%) |
| `--blue-600` (#2563eb) | `.systemBlue` | #007aff | #0a84ff |
| `--red-600` (#dc2626) | `.systemRed` | #ff3b30 | #ff453a |

**Peptide Category Colors (iOS Semantic):**
```swift
GLP-1:        .systemBlue
Healing:      .systemTeal
Metabolic:    .systemPurple
Cognitive:    .systemOrange
Growth:       .systemIndigo
Immune:       .systemGreen
```

### 7.3 Component Translation
**Web → iOS Native:**

| Web Component | iOS Equivalent | Notes |
|---------------|----------------|-------|
| `<Button>` | `UIButton` / SwiftUI `Button` | SF Symbols for icons |
| `<Card>` | `UIView` + rounded corners | 12pt radius, 1pt border |
| `<Input>` | `UITextField` | `.roundedBorder` style |
| `<Slider>` | `UISlider` | Tint color per peptide category |
| `<Badge>` | `UILabel` + capsule shape | 6pt padding, 12pt corner radius |
| `<Select>` | `UIPickerView` (sheet) | Native iOS picker in modal |
| `<Dialog>` | `UIAlertController` / Sheet | Prefer sheet for complex content |

---

## 8. Performance Targets

### 8.1 Launch Time
- **Cold Start**: < 1.2 seconds (to splash → calculator)
- **Warm Start**: < 0.5 seconds

**Optimization Strategy:**
- Preload peptide library (embedded JSON, not API call)
- Lazy load protocol history (fetch on-demand)
- Image assets: SF Symbols only (no custom images)

### 8.2 Calculation Responsiveness
- **Input → Result Update**: < 50ms
  - Use debouncing for real-time calculation (250ms delay on text input)
  - Instant update on stepper/picker changes

### 8.3 Memory Budget
- **Baseline**: < 50 MB (app idle)
- **Calculator Active**: < 70 MB
- **Protocol Timeline Rendered**: < 90 MB

---

## 9. Testing & Validation Checklist

### 9.1 Medical Precision Tests
- [ ] Dose calculations match web app (0.001mg precision)
- [ ] Device compatibility validation (pen max 0.5mL, syringe limits)
- [ ] Concentration calculations (5mg/2mL = 2.5mg/mL)
- [ ] Edge cases: 0.01mg dose, 100mg vial, 10mL water

### 9.2 Accessibility Tests
- [ ] VoiceOver: Complete calculator flow without vision
- [ ] Dynamic Type: XXL text scaling (all screens navigable)
- [ ] High Contrast: All text meets 7:1 ratio
- [ ] Reduce Motion: Disable all animations (protocol timeline still functional)

### 9.3 Platform Integration Tests
- [ ] Quick Actions: All 4 shortcuts functional
- [ ] Widgets: Update within 15 minutes of data change
- [ ] Siri Shortcuts: Voice commands execute correctly
- [ ] Health: Data writes successfully (dose logged)
- [ ] CloudKit: Sync within 30 seconds across devices
- [ ] Spotlight: Peptides + calculations indexed

### 9.4 Device Compatibility
- [ ] iPhone SE (small screen): All content visible without horizontal scroll
- [ ] iPhone 15 Pro Max: Optimized for 6.7" screen
- [ ] iPad Pro 12.9": Split-view functional
- [ ] Dark Mode: All screens readable (color contrast maintained)

---

## 10. Prioritization Matrix

### 10.1 MVP Features (Must-Have)
1. **Calculator Tab**: Single-peptide dose calculation
2. **GLP-1 Comparison**: Static content (no protocol builder)
3. **Peptide Library**: Browse + search (read-only)
4. **Recent Calculations**: History list (last 20)
5. **Basic Settings**: Units, default device

**Timeline**: 8-10 weeks

### 10.2 Phase 2 (High-Value)
1. **Protocol Builder**: GLP-1 journey (3-step flow)
2. **Widgets**: Small + Medium (recent calculations)
3. **Quick Actions**: 3D Touch shortcuts
4. **CloudKit Sync**: Cross-device calculation history

**Timeline**: 4-6 weeks post-MVP

### 10.3 Phase 3 (Differentiation)
1. **Siri Shortcuts**: Voice-driven calculations
2. **Apple Health**: Write dose logs
3. **Barcode Scanning**: Auto-fill vial info
4. **Dose Reminders**: Protocol-based notifications

**Timeline**: 6-8 weeks post-Phase 2

### 10.4 Future Enhancements
- iPad Pro Pencil support (annotate protocols)
- Apple Watch complication (next dose countdown)
- Live Activities (protocol phase transitions)
- SharePlay (consult with clinician)

---

## 11. Key Recommendations

### 11.1 Navigation
✅ **Use native tab bar** (not custom bottom sheet)
✅ **Modal sheets for details** (maintains context)
✅ **Searchable lists** (native iOS search patterns)
❌ Avoid web-style hamburger menus (non-native)

### 11.2 Input Optimization
✅ **Decimal pad for doses** (medical precision)
✅ **Steppers with haptics** (tactile feedback)
✅ **Quick-tap common values** (keyboard accessory)
❌ Avoid custom number pickers (use native UIPickerView)

### 11.3 Data Persistence
✅ **CloudKit for sync** (Apple-native, free tier sufficient)
✅ **Core Data for local cache** (calculations, protocols)
✅ **UserDefaults for preferences** (units, defaults)
❌ Avoid Firebase/Realm (adds complexity for static data)

### 11.4 Safety-First Design
✅ **Inline validation** (real-time dose limits)
✅ **Haptic warnings** (critical alerts)
✅ **Safety sheets** (storage, reconstitution guidelines)
✅ **VoiceOver precision** ("one point zero milligrams")
❌ Never auto-fill doses without explicit user confirmation

---

## 12. Risk Mitigation

### 12.1 Medical Liability
**Risk**: Incorrect dosing calculation harms user
**Mitigation**:
- Add disclaimer screen on first launch (explicit acknowledgment)
- "For informational purposes only" footer on all calculations
- Validation layer: Cross-check all calculations against reference tables
- User confirmation: "Calculate" button requires tap (no auto-execution)

### 12.2 Regulatory Compliance
**Risk**: FDA classification as medical device
**Mitigation**:
- Position as "educational tool" (not diagnostic/prescriptive)
- No medication recommendations (user inputs own prescriptions)
- No integration with pharmacy systems
- Clear labeling: "Consult healthcare provider"

### 12.3 Data Privacy
**Risk**: HIPAA concerns with dose tracking
**Mitigation**:
- On-device storage (no cloud backend for dose data)
- Optional CloudKit sync (user-controlled)
- No user accounts (no PII collected)
- Health data consent: Explicit opt-in with permission sheet

---

## Appendix A: Screen Wireframes (Text Descriptions)

### A.1 Calculator Tab (Primary Screen)
```
┌─────────────────────────────────────┐
│ ← Calculator              [Info] ⓘ │
├─────────────────────────────────────┤
│                                     │
│  Compound                           │
│  ┌─────────────────────────────┐   │
│  │ Semaglutide              ▾  │   │ ← Tap opens sheet
│  └─────────────────────────────┘   │
│                                     │
│  Vial Size                          │
│  [5mg] [10mg] [Custom]              │ ← Segmented control
│                                     │
│  Input Mode                         │
│  [Concentration ⟷ Water Volume]    │ ← Toggle
│                                     │
│  Target Dose (mg)                   │
│  ┌───────────────────┐  [- / +]    │ ← Decimal pad + stepper
│  │      1.0          │             │
│  └───────────────────┘             │
│                                     │
│  Device Type                        │
│  ┌─────────────────────────────┐   │
│  │ Insulin Pen (50 units)   ▾  │   │ ← Picker sheet
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [Calculate Dose]            │   │ ← Primary button
│  └─────────────────────────────┘   │
│                                     │
│  ─────── Results ───────            │
│  ┌─────────────────────────────┐   │
│  │ Concentration: 5.0 mg/mL    │   │
│  │ Draw Volume: 0.20 mL        │   │
│  │            = 20 units       │   │
│  │ Doses/Vial: 50              │   │
│  └─────────────────────────────┘   │
│                                     │
│  ⚠ Safety Guidelines  [View]       │ ← Expandable sheet
│                                     │
└─────────────────────────────────────┘
   [Calculator] [GLP-1] [Protocols] [Library] [Profile]
                  ↑ Active tab
```

### A.2 Peptide Library (Browse)
```
┌─────────────────────────────────────┐
│ Library                   [Filter]  │
├─────────────────────────────────────┤
│ [Search peptides...]                │ ← Native search bar
│ ┌─────────────────────────────────┐ │
│ │ [All] [GLP] [Healing] [Metabolic]│ ← Scope chips
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ GLP-1 AGONISTS                      │
│ ┌─────────────────────────────────┐ │
│ │ Semaglutide                  ▸  │ │ ← Tap opens detail sheet
│ │ GLP-1 for weight loss           │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Tirzepatide                  ▸  │ │
│ │ Dual GIP/GLP-1 agonist          │ │
│ └─────────────────────────────────┘ │
│                                     │
│ HEALING PEPTIDES                    │
│ ┌─────────────────────────────────┐ │
│ │ BPC-157                      ▸  │ │
│ │ Body protection compound        │ │
│ └─────────────────────────────────┘ │
│ ...                                 │
└─────────────────────────────────────┘
   [Calculator] [GLP-1] [Protocols] [Library] [Profile]
                                       ↑ Active tab
```

### A.3 GLP-1 Protocol Builder (Step 1)
```
┌─────────────────────────────────────┐
│ ← Back              Step 1 of 3     │
│ Select GLP Agent                    │
├─────────────────────────────────────┤
│ ● ─ ○ ─ ○  (Progress dots)          │
│                                     │
│  ┌─────────────────────────────────┐│
│  │ Semaglutide                     ││ ← Selection cards
│  │ [Beginner]                      ││
│  │ The gentle starter              ││
│  │                                 ││
│  │ ✓ Most forgiving               ││
│  │ ✓ Well-studied                 ││
│  │ ⚠ Slower fat loss              ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │ Tirzepatide                     ││
│  │ [Intermediate]                  ││
│  │ The fast track                  ││
│  │ ...                             ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │ Retatrutide                     ││
│  │ [Advanced]                      ││
│  │ The heavy hitter                ││
│  │ ...                             ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │ [Continue to Frequency]      ▸ ││ ← Disabled until selection
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

---

## Appendix B: Accessibility Test Script

### B.1 VoiceOver Calculator Flow
```
Step 1: Launch app
  VO announces: "Calculator tab selected"

Step 2: Focus on Compound picker
  VO announces: "Compound button. Semaglutide. Double tap to change."
  User double-taps → Sheet opens
  VO announces: "Compound selection. Heading. Recently used. Semaglutide selected."

Step 3: Select compound
  User swipes right → Focuses on Tirzepatide
  VO announces: "Tirzepatide. GLP-1 and GIP dual agonist."
  User double-taps → Selection confirmed
  VO announces: "Tirzepatide selected. Button."

Step 4: Navigate to dose input
  User swipes right repeatedly → Reaches dose field
  VO announces: "Target dose. One point zero milligrams. Text field. Double tap to edit."
  User double-taps → Keyboard appears
  VO announces: "Decimal pad keyboard. One."

Step 5: Enter dose
  User taps "2", ".", "4"
  VO announces each key: "Two. Decimal point. Four."
  User swipes right to Done button
  VO announces: "Done button"
  User double-taps → Keyboard dismisses
  VO announces: "Target dose. Two point four milligrams."

Step 6: Calculate
  User swipes right → Focuses on Calculate button
  VO announces: "Calculate dose button. Double tap to activate."
  User double-taps → Calculation runs
  VO announces: "Calculation complete. Concentration: four point eight milligrams per milliliter. Draw volume: zero point five milliliters, or fifty units. Twenty doses per vial."

Expected: User completes full calculation flow without vision.
```

### B.2 Dynamic Type Test
```
Settings → Accessibility → Display & Text Size → Larger Text → XXL

Open Peptide Fox:
1. Calculator tab: All labels visible, no truncation
2. Dose input: 1.0 mg scales but stays single-line
3. Results card: Multi-line expansion (concentration, volume, units stack vertically)
4. GLP Comparison: Cards expand vertically, timeline adapts to taller text
5. Library: Peptide names wrap to 2 lines if needed

Expected: All content readable at XXL size without horizontal scrolling.
```

---

## Document Version History
- **v1.0** (January 2025): Initial UX specification for iOS translation
- Next update: Prototype testing results (Q2 2025)

---

**END OF SPECIFICATION**
