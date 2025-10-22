# SwiftUI View Examples - Quick Reference

## GLP1PlannerView

### Key Features Demo

```swift
// View Model Usage
@State private var viewModel = GLP1PlannerViewModel()

// Peptide Selection with Auto-Schedule
viewModel.selectPeptide(semaglutide)
// Generates: Week 1-4: 0.25mg → Week 17+: 2.4mg

// Titration Schedule Display
ForEach(viewModel.weeklySchedule) { milestone in
    HStack {
        Text(milestone.weekRange)  // "Week 1-4"
        Spacer()
        Text("\(milestone.dose) mg")  // "0.25 mg"
    }
}
```

### Sample Output

**Semaglutide Schedule:**
- Week 1-4: 0.25 mg
- Week 5-8: 0.50 mg
- Week 9-12: 1.00 mg
- Week 13-16: 1.70 mg
- Week 17+: 2.40 mg

**Tirzepatide Schedule:**
- Week 1-4: 2.5 mg
- Week 5-8: 5.0 mg
- Week 9-12: 7.5 mg
- Week 13-16: 10.0 mg
- Week 17-20: 12.5 mg
- Week 21+: 15.0 mg

---

## ProtocolBuilderView

### Key Features Demo

```swift
// View Model Usage
@State private var viewModel = ProtocolBuilderViewModel()

// Add Peptides to Stack
viewModel.addPeptide(semaglutide)
viewModel.addPeptide(bpc157)

// Protocol Definition
viewModel.protocolName = "Fat Loss + Recovery Stack"
viewModel.goal = "Fat Loss"

// Validation
viewModel.validate()

// Check Validation Result
if let result = viewModel.validationResult {
    print("Valid: \(result.isValid)")
    print("Can Activate: \(result.canActivate)")
    print("Warnings: \(result.warnings.count)")
    print("Errors: \(result.errors.count)")
}
```

### Validation Examples

**Valid Protocol:**
```
✅ All checks passed
   Protocol is ready to activate
```

**Warning - Dose Low:**
```
⚠️ BPC-157 Below Range
   Dose 100 mcg is below typical minimum
```

**Error - Dose Exceeds:**
```
❌ Semaglutide Exceeds Maximum
   Dose 5.0 mg exceeds safe maximum of 2.4
```

**Warning - Multiple GLP-1s:**
```
⚠️ Multiple GLP-1 Agonists
   Using multiple GLP-1s simultaneously is not recommended
```

### Phase System

```swift
enum ProtocolPhase {
    case foundation  // Initial 4-6 weeks: Establish baseline
    case build       // Weeks 7-12: Intensify protocol
    case maintain    // Week 13+: Long-term optimization
}
```

---

## SupplyPlannerView

### Key Features Demo

```swift
// View Model Usage
@State private var viewModel = SupplyPlannerViewModel()

// Configure Supply Plan
viewModel.selectPeptide(bpc157)
viewModel.vialSize = 5.0           // 5mg vial
viewModel.reconVolume = 2.0        // 2ml BAC water
viewModel.dosePerInjection = 0.25  // 250mcg per dose
viewModel.frequency = .daily

// Calculate Supply
viewModel.calculateSupply()

// Access Results
if let output = viewModel.supplyOutput {
    print("Doses per Vial: \(output.dosesPerVial)")
    print("Days per Vial: \(output.daysPerVial)")
    print("Vials per Month: \(output.vialsPerMonth)")
    print("Monthly Cost: $\(output.estimatedMonthlyCost ?? 0)")
}
```

### Sample Calculation

**Input:**
- Peptide: BPC-157
- Vial Size: 5mg
- Reconstitution: 2ml
- Dose: 250mcg (0.25mg)
- Frequency: Daily
- Cost per Vial: $35

**Output:**
```
📊 Supply Estimate
   Doses per Vial: 20
   Days per Vial: 20
   Vials per Month: 2

📅 Reorder Schedule
   Day 1:  Vial #1
   Day 21: Vial #2 ⚠️
   Day 41: Vial #3

💰 Monthly Cost
   2 vials × $35 = $70
```

### Reorder Urgency Logic

```swift
struct ReorderPoint {
    let day: Int
    let vialNumber: Int
    let isUrgent: Bool  // true if day > 30 - 7
}

// Example:
// Day 21 reorder = NOT urgent (21 ≤ 23)
// Day 25 reorder = URGENT (25 > 23) ⚠️
```

---

## Common Patterns

### Observable View Model Pattern

```swift
@MainActor
@Observable
final class MyViewModel {
    var inputValue: Double = 0.0
    var outputValue: Double = 0.0
    
    func calculate() {
        outputValue = inputValue * 2
    }
}

// Usage in View
struct MyView: View {
    @State private var viewModel = MyViewModel()
    
    var body: some View {
        VStack {
            TextField("Input", value: $viewModel.inputValue, format: .number)
                .onChange(of: viewModel.inputValue) {
                    viewModel.calculate()
                }
            
            Text("Output: \(viewModel.outputValue)")
        }
    }
}
```

### PFCard Layout Pattern

```swift
PFCard {
    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
        // Header
        Text("Section Title")
            .font(DesignTokens.Typography.headlineSmall)
            .foregroundColor(ColorTokens.foregroundPrimary)
        
        // Content
        VStack(spacing: DesignTokens.Spacing.sm) {
            ForEach(items) { item in
                itemRow(item)
            }
        }
    }
}
```

### Bottom Sheet Selector Pattern

```swift
struct MyView: View {
    @State private var showingSelector = false
    @State private var selectedItem: Item?
    
    var body: some View {
        Button("Select Item") {
            showingSelector = true
        }
        .sheet(isPresented: $showingSelector) {
            NavigationStack {
                List(items) { item in
                    Button {
                        selectedItem = item
                        showingSelector = false
                    } label: {
                        Text(item.name)
                    }
                }
                .navigationTitle("Select Item")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingSelector = false
                        }
                    }
                }
            }
        }
    }
}
```

### Real-time Recalculation Pattern

```swift
PFNumberField(
    label: "Vial Size",
    value: $viewModel.vialSize,
    unit: "mg"
)
.onChange(of: viewModel.vialSize) {
    viewModel.calculateSupply()
}
```

### Conditional UI Pattern

```swift
// Show content only when data available
if let output = viewModel.supplyOutput {
    supplyEstimateCard(output)
}

// Show different content based on state
if viewModel.peptides.isEmpty {
    emptyPeptidesState
} else {
    peptidesList
}

// Conditional button enable
if viewModel.validationResult?.canActivate == true {
    PFButton.primary("Activate Protocol") {
        viewModel.activate()
    }
}
```

---

## Design System Usage

### Colors

```swift
// Semantic Colors
ColorTokens.foregroundPrimary      // Main text
ColorTokens.foregroundSecondary    // Secondary text
ColorTokens.backgroundPrimary      // Card background
ColorTokens.backgroundSecondary    // Input background
ColorTokens.brandPrimary           // Brand blue

// Status Colors
ColorTokens.success                // Green
ColorTokens.warning                // Orange
ColorTokens.error                  // Red
ColorTokens.info                   // Blue
```

### Spacing

```swift
DesignTokens.Spacing.xs           // 4pt
DesignTokens.Spacing.sm           // 8pt
DesignTokens.Spacing.md           // 12pt
DesignTokens.Spacing.lg           // 16pt
DesignTokens.Spacing.xl           // 20pt
DesignTokens.Spacing.xxl          // 24pt
DesignTokens.Spacing.xxxl         // 32pt

// Semantic
DesignTokens.Spacing.cardPadding      // 16pt
DesignTokens.Spacing.sectionSpacing   // 24pt
DesignTokens.Spacing.itemSpacing      // 12pt
```

### Typography

```swift
// Headlines
DesignTokens.Typography.headlineLarge    // 20pt semibold
DesignTokens.Typography.headlineMedium   // 18pt semibold
DesignTokens.Typography.headlineSmall    // 16pt semibold

// Body
DesignTokens.Typography.bodyLarge        // 16pt regular
DesignTokens.Typography.bodyMedium       // 14pt regular
DesignTokens.Typography.bodySmall        // 12pt regular

// Labels
DesignTokens.Typography.labelLarge       // 14pt medium
DesignTokens.Typography.labelMedium      // 12pt medium
```

### Animations

```swift
AnimationTokens.quick         // 0.2s ease
AnimationTokens.standard      // 0.3s ease
AnimationTokens.spring        // Spring with damping
AnimationTokens.springBouncy  // Bouncy spring

// Usage
withAnimation(AnimationTokens.spring) {
    viewModel.selectedPeptide = peptide
}
```

---

## Accessibility Best Practices

```swift
// Screen Reader Labels
Text("Settings")
    .accessibilityLabel("Open Settings")
    .accessibilityHint("Double tap to view settings")

// Hide Decorative Images
Image(decorative: "background")
    .accessibilityHidden(true)

// Group Related Elements
HStack {
    Image(systemName: "heart.fill")
    Text("Favorites")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("Favorites")

// Dynamic Type Scaling
@ScaledMetric private var imageSize: CGFloat = 200

Image("hero")
    .frame(height: imageSize)
```

---

## Preview Examples

```swift
#Preview("GLP-1 Planner - Default") {
    NavigationStack {
        GLP1PlannerView()
    }
}

#Preview("Protocol Builder - Empty") {
    NavigationStack {
        ProtocolBuilderView()
    }
}

#Preview("Supply Planner - BPC-157") {
    NavigationStack {
        SupplyPlannerView()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        GLP1PlannerView()
    }
    .preferredColorScheme(.dark)
}
```

---

## Integration Example

```swift
// ContentView.swift
struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Tools") {
                    NavigationLink {
                        GLP1PlannerView()
                    } label: {
                        Label("GLP-1 Planner", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    
                    NavigationLink {
                        ProtocolBuilderView()
                    } label: {
                        Label("Protocol Builder", systemImage: "square.stack.3d.up")
                    }
                    
                    NavigationLink {
                        SupplyPlannerView()
                    } label: {
                        Label("Supply Planner", systemImage: "calendar")
                    }
                }
            }
            .navigationTitle("PeptideFox")
        }
    }
}
```
