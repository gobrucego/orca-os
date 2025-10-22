# Native iOS App for Peptide Fox Calculator & GLP-1 Dosing Tools

## Objective

Build a production-ready native iOS application (iOS 17+) featuring two core tools: the Peptide Fox reconstitution calculator and GLP-1 dosing planner, with complete brand design system translation from web to iOS-native SwiftUI.

## Context

PeptideFox is a Next.js web application serving research professionals with precision peptide dosing tools. The business logic includes complex mg/mL conversions, injection volume calculations, device compatibility checks, supply planning, and protocol management. The web app has an established design system with custom fonts (Brown LL, Sharp Sans No2), fox branding, and strict design rules prohibiting decorative effects in favor of functional minimalism.

This iOS port must preserve all calculation accuracy, medical data integrity, and brand identity while adopting iOS-native patterns and Apple Human Interface Guidelines.

## Approach

Using intelligent analysis, I've selected 12 enhancement steps focusing on:

- **Medical accuracy & safety** (Steps 8, 10, 15, 16)
- **Design system translation** (Steps 1, 2, 7)
- **iOS architecture** (Steps 3, 5, 11, 18)
- **Production readiness** (Steps 13, 23)

## Requirements

### 1. Web Analysis & Data Extraction 🔄

- Analyze existing Next.js codebase to extract:
  - `lib/protocol/calculator.ts` - Reconstitution math and device logic
  - `lib/protocol/types.ts` - Core data models (ProtocolRecord, PeptideDosePlan, FrequencySchedule)
  - `lib/peptide-data.ts` - Complete peptide database (30+ peptides with clinical data)
  - `app/globals.css` - Design system tokens (spacing scale, typography, colors)
- Map business logic to Swift 6.0 data structures
- Extract validation rules from `lib/protocol/validation.ts`

### 2. Design System Translation 🔄

- Port custom fonts (Brown LL for content, Sharp Sans No2 for UI) to iOS
- Translate CSS design tokens to SwiftUI:
  - Spacing scale (4px grid: 0.25rem → 4pt increments)
  - Type scale (10px labels → 48px hero)
  - Border radius system (6px → 12px)
  - Color palette (light & dark mode support)
- Adapt "10 Cardinal Sins" design rules to iOS:
  - NO decorative gradients or glows
  - Minimal animations (≤200ms, ≤8pt displacement)
  - Explicit grid templates (NO auto-sizing)
  - Icons ≤20pt, text-first hierarchy

### 3. Calculator Implementation

**Reconstitution Calculator:**
- Vial size (mg) → Reconstitution volume (mL) → Concentration (mg/mL)
- Target dose (mg) → Draw volume (mL) → Device units
- Device compatibility (pen, 30/50/100-unit syringes)
- Visual syringe guide with fill levels
- Real-time validation and suggestions

**Supply Planner:**
- Doses per vial calculation
- Days per vial (frequency-aware)
- Monthly supply estimation
- Cost projections

### 4. GLP-1 Dosing Planner

- Support for Semaglutide, Tirzepatide, Retatrutide
- Dose escalation protocols (e.g., 0.25mg → 2.4mg over 16 weeks)
- Frequency scheduling (daily, q2d, weekly, custom)
- Titration timeline visualization
- Contraindications & safety warnings
- Success signal tracking

### 5. Data Models & Architecture

- Swift 6.0 patterns: async/await, actor isolation, Sendable conformance
- **Core models:**
  - `Peptide` struct (id, name, category, mechanism, dosing, synergies, colors)
  - `ProtocolRecord` enum (draft, active, completed states)
  - `CalculatorInput` & `CalculatorOutput` structs
  - `Device` enum (pen, syringe30, syringe50, syringe100)
- Clean architecture: Domain → Data → Presentation layers
- Persistence: SwiftData or Core Data for protocol storage

### 6. iOS-Native UX Patterns

- Tab bar navigation (Calculator, GLP-1 Planner, Protocols, Library)
- Navigation stacks for deep content
- iOS form controls (steppers, pickers, segmented controls)
- Adaptive layouts (iPhone/iPad split views)
- Keyboard handling (decimal pad for doses, number pad for frequencies)
- Pull-to-refresh, haptic feedback

### 7. Dark Mode & Accessibility

- Full dark mode support matching web design tokens
- Dynamic Type support (all text scales)
- VoiceOver labels for all interactive elements
- Minimum 44pt touch targets
- Color contrast compliance (WCAG AA)

## Key Considerations

- **Medical Data Integrity:** NEVER fabricate peptide data. Port ONLY from `lib/peptide-data.ts` and existing blog content. All dosing calculations must match web implementation exactly.
- **Calculation Accuracy:** Property-based testing for mg/mL conversions, device compatibility, and supply planning math.
- **Brand Consistency:** Fox mascot integration, custom typography licensing/embedding, strict adherence to minimal design rules.
- **Device Limits:** Validate injection volumes against device constraints (pen: 0.5mL max, syringe100: 1.0mL max).
- **Safety Warnings:** Display contraindications, drug interactions, and validation errors prominently.

## Tools & Resources

- **Primary MCP Tools:** context7 for SwiftUI documentation, sequential-thinking for architecture decisions
- **Memory:** Search past iOS projects for calculator UI patterns, form validation flows
- **Fallback:** Read existing TypeScript files, Glob for component patterns

## Project Rules (from CLAUDE.md)

### Medical Data
- Use `lib/peptide-data.ts` as single source of truth
- Never duplicate or fabricate peptide information
- Maintain existing validation rules from `lib/protocol/validation.ts`

### Design System
- Custom fonts: Brown LL (primary), Sharp Sans No2 (functional)
- NO decorative effects (gradients, glows, halos)
- Minimal animations (hover ≤1px web → ≤1pt iOS, duration ≤200ms)
- 4px grid spacing system

### Testing
- Co-locate unit tests with source files
- Property-based tests for mathematical functions
- Golden file tests for protocol JSONs

## Deliverables

### 1. Xcode Project Structure
- SwiftUI app with minimum deployment target iOS 17.0
- Modular architecture (Core, Data, Presentation layers)
- SwiftData/Core Data persistence layer

### 2. Core Modules
- `CalculatorEngine.swift` - Reconstitution & dose math
- `GLP1Planner.swift` - Dose escalation protocols
- `PeptideDatabase.swift` - 30+ peptide cards with clinical data
- `ProtocolManager.swift` - Draft/Active/Completed state management

### 3. SwiftUI Views
- `ReconstitutionCalculatorView` - Main calculator interface
- `GLP1PlannerView` - Dosing timeline & titration
- `DevicePickerView` - Syringe/pen selection with visuals
- `SupplyPlannerView` - Monthly supply calculator
- `PeptideLibraryView` - Scrollable peptide cards

### 4. Design System
- `DesignTokens.swift` - Spacing, typography, colors
- `CustomFonts` - Brown LL & Sharp Sans No2 embedded
- `ComponentLibrary` - Reusable cards, badges, pills, buttons
- Dark mode theme definitions

### 5. Testing & Validation
- Unit tests for CalculatorEngine (dosing accuracy)
- UI tests for critical flows (calculator input → results)
- Accessibility audit (VoiceOver, Dynamic Type)

### 6. App Store Readiness
- App icons (all sizes)
- Launch screen (fox branding)
- Privacy manifest (data usage declarations)
- TestFlight beta configuration

## Success Criteria

- ✅ All reconstitution calculations match web implementation exactly (±0.001mL precision)
- ✅ GLP-1 protocols display correct escalation timelines for all 3 variants
- ✅ Design system tokens match web CSS variables within 1pt/1% tolerance
- ✅ Dark mode renders correctly across all views
- ✅ VoiceOver navigation passes Apple accessibility audit
- ✅ App builds without warnings, passes all unit tests
- ✅ TestFlight build ready for internal testing
- ✅ App size ≤50MB (realistic for embedded fonts + peptide data)

## Measurable Outcomes

- Port 30+ peptide cards from `PEPTIDE_DATA` array to Swift models
- Implement 4 core calculation flows (reconstitution, GLP-1 dosing, supply planning, device selection)
- Achieve 90%+ code coverage on calculation engines
- Support iPhone (compact) and iPad (regular) size classes
- Complete dark mode implementation for 100% of views
- Pass Apple App Store review guidelines checklist

---

## Summary

This enhanced prompt provides:
- Clear technical specifications extracted from your codebase
- Realistic scope based on actual web app complexity
- Specific file references for porting logic
- Design constraints matching your brand identity
- Production-ready deliverables for App Store submission