# App Store Screenshot Planning Guide

## Screenshot Requirements

### iPhone 6.7" Display (Required)
**Dimensions**: 1290 x 2796 pixels  
**Devices**: iPhone 15 Pro Max, iPhone 14 Pro Max, iPhone 13 Pro Max

**Required**: 3-10 screenshots  
**Recommended**: 5 screenshots

### iPad Pro 12.9" Display (Required)
**Dimensions**: 2048 x 2732 pixels  
**Device**: iPad Pro 12.9" (6th generation)

**Required**: 3-10 screenshots  
**Recommended**: 3 screenshots

---

## Screenshot Strategy

### Goal
Communicate app value in first 3 screenshots (most users only see these).

### Key Messages
1. **Medical-Grade Calculations** - Precision and accuracy
2. **Comprehensive Protocol Planning** - Full workflow support
3. **Privacy-First Design** - Local data, no tracking
4. **Professional UI** - Clean, modern, trustworthy

---

## iPhone Screenshots (Priority Order)

### Screenshot 1: GLP-1 Journey (Hero)
**Screen**: `GLPJourneyView`  
**Purpose**: Show primary use case - GLP-1 dose escalation  
**What to Show**:
- GLP-1 Journey interface with sample dose schedule
- Week-by-week progression visible
- Clean, professional UI
- Clear call-to-action buttons

**Sample Data**:
- Peptide: Semaglutide
- Starting dose: 0.25mg
- Current week: Week 4 (0.5mg)
- Next dose highlighted

**Caption** (optional):
> "GLP-1 Dose Escalation Made Simple"

---

### Screenshot 2: Reconstitution Calculator
**Screen**: `ReconstitutionCalculatorView` (need to implement)  
**Purpose**: Show core calculation functionality  
**What to Show**:
- Peptide selection (e.g., BPC-157)
- Vial size: 5mg
- Desired dose: 250mcg
- Bacteriostatic water: 2.0ml
- Device: Insulin syringe (100 unit)
- Result: "Draw to 5 units" with visual

**Sample Data**:
- Peptide: BPC-157
- Vial: 5mg
- Dose: 250mcg
- BAC water: 2.0ml
- Result clearly visible

**Caption**:
> "Precise Reconstitution Calculations"

---

### Screenshot 3: Supply Planner
**Screen**: `SupplyPlannerView` (need to implement)  
**Purpose**: Show planning capabilities  
**What to Show**:
- Multi-peptide protocol
- 30-day supply calculation
- Vial quantities optimized
- Cost estimation
- Timeline view

**Sample Data**:
- Protocol: "Recovery Stack"
- Peptides: BPC-157, TB-500
- Duration: 30 days
- Vials needed: BPC-157 (2x 5mg), TB-500 (1x 5mg)
- Total cost estimate

**Caption**:
> "Plan Your Peptide Supply with Confidence"

---

### Screenshot 4: Protocol Builder
**Screen**: `ProtocolBuilderView` (need to implement)  
**Purpose**: Show advanced features  
**What to Show**:
- Multi-peptide protocol interface
- Phase planning (loading, maintenance)
- Timing and frequency settings
- Visual timeline
- Professional layout

**Sample Data**:
- Protocol: "GLOW Stack"
- Peptides: GHK-Cu, Thymosin Beta-4, Cerebrolysin
- Phases: 8-week loading, 4-week maintenance
- Injection schedule visible

**Caption**:
> "Build Custom Multi-Peptide Protocols"

---

### Screenshot 5: Peptide Library
**Screen**: `PeptideLibraryView` (need to implement)  
**Purpose**: Show comprehensive database  
**What to Show**:
- Grid of peptide cards
- Search bar
- Filter options
- Colorful, organized layout
- 6-8 peptides visible

**Sample Data**:
- Featured peptides: Semaglutide, BPC-157, TB-500, GHK-Cu, Thymosin Beta-4, Cerebrolysin
- Dark mode view (if Screenshot 5)
- Clean card design

**Caption**:
> "30+ Research Peptides with Clinical Data"

---

## iPad Screenshots

### iPad Screenshot 1: GLP-1 Journey (Landscape)
**Purpose**: Show iPad-optimized layout  
**What to Show**:
- Same content as iPhone Screenshot 1
- Utilize wider screen with side-by-side content
- Show iPad-specific UI adaptations

---

### iPad Screenshot 2: Protocol Builder (Split View)
**Purpose**: Show iPad productivity features  
**What to Show**:
- Protocol builder with side panels
- More information visible simultaneously
- Professional multi-column layout

---

### iPad Screenshot 3: Supply Planner (Landscape)
**Purpose**: Show data-rich views  
**What to Show**:
- Supply planner with detailed tables
- Charts and graphs (if implemented)
- Multi-peptide comparison view

---

## Screenshot Creation Workflow

### Method 1: Xcode Simulator (Free)
```bash
1. Build and run app in Xcode
2. Select iPhone 15 Pro Max simulator
3. Navigate to screen you want to capture
4. Cmd+S to save screenshot
5. Screenshots saved to Desktop
6. Open in Preview, resize to 1290x2796 if needed
```

### Method 2: Actual Device (Best Quality)
```bash
1. Install app on iPhone 15 Pro Max or 14 Pro Max
2. Navigate to desired screen
3. Press Volume Up + Side Button to screenshot
4. AirDrop to Mac
5. Open in Preview
6. Verify dimensions: 1290 x 2796
```

### Method 3: Design Tool Mockups (Professional)
```bash
Tools:
- Figma: Free tier, device frames available
- Sketch: $99/year, comprehensive mockup tools
- Adobe XD: Free tier available
- Screenshot.rocks: Free web-based tool

Process:
1. Take basic screenshots from simulator
2. Import into design tool
3. Add device frame
4. Add captions/annotations if desired
5. Export at correct dimensions
```

---

## Screenshot Design Guidelines

### Apple's Requirements
- No device frames required (Apple adds them)
- Can add text overlays and graphics
- Must show actual app UI (no mockups without real UI)
- Must be actual screenshots (can be enhanced)
- No misleading content
- No competitor references

### Best Practices
1. **Use Real Data**: No "Lorem Ipsum" or placeholder text
2. **Light Mode First**: Screenshots 1-3 in light mode
3. **Dark Mode Option**: Screenshot 4-5 can show dark mode
4. **Status Bar**: Clean status bar (full battery, good signal, 9:41 AM)
5. **Content Hierarchy**: Most important info visible first
6. **Consistency**: Similar data/style across screenshots
7. **Accessibility**: High contrast, readable text

### Common Mistakes to Avoid
- Screenshot with debug mode enabled
- Low battery in status bar
- Notifications visible
- Empty or incomplete data
- Typos or errors in UI
- Misaligned UI elements
- Blurry or low-resolution images

---

## Screenshot Checklist

### Before Taking Screenshots
- [ ] App built in Release mode (not Debug)
- [ ] Sample data loaded and realistic
- [ ] UI polished and bug-free
- [ ] Status bar clean (9:41 AM, full battery)
- [ ] No debug overlays visible
- [ ] Dark mode tested (if showing dark screenshots)
- [ ] All text proofread for typos
- [ ] Navigation state correct (no back buttons if hero screen)

### During Screenshot Capture
- [ ] Device/simulator set to correct size
- [ ] Screenshot taken at exact moment (no animations mid-flight)
- [ ] All UI elements fully loaded
- [ ] No loading spinners visible
- [ ] Proper orientation (portrait for iPhone, landscape option for iPad)

### After Screenshot Capture
- [ ] Dimensions verified (1290x2796 for iPhone, 2048x2732 for iPad)
- [ ] File format: PNG or JPG
- [ ] File size < 5MB per screenshot
- [ ] Color profile: sRGB
- [ ] No transparency (solid background)
- [ ] Previewed on actual device to verify quality

### App Store Connect Upload
- [ ] Screenshots uploaded in correct order
- [ ] Same screenshots for all iOS 6.7" devices
- [ ] iPad screenshots uploaded separately
- [ ] Preview on App Store Connect to verify
- [ ] Tested on multiple devices in App Store preview

---

## Sample Data for Screenshots

### GLP-1 Journey
```
User Profile:
- Starting weight: 185 lbs
- Goal weight: 165 lbs
- Week: 4 of 16

Semaglutide Schedule:
- Week 1-4: 0.25mg weekly
- Week 5-8: 0.5mg weekly
- Week 9-12: 1.0mg weekly
- Week 13-16: 1.7mg weekly

Current Status:
- Current dose: 0.5mg
- Next dose: In 4 days
- Weight lost: -8 lbs
- Side effects: Mild nausea (managed)
```

### Reconstitution Calculator
```
Peptide: BPC-157
Vial Size: 5mg
Target Dose: 250mcg
BAC Water: 2.0ml
Device: Insulin syringe (100 unit / 1ml)

Result:
"Draw to 5 units on insulin syringe"
Visual: Syringe with marking at 5 units
```

### Supply Planner
```
Protocol: "Recovery Stack"
Duration: 30 days
Frequency: Daily

BPC-157:
- Dose: 250mcg/day
- Total needed: 7.5mg
- Vials: 2x 5mg vials
- Cost: ~$80

TB-500:
- Dose: 2mg twice weekly
- Total needed: 16mg
- Vials: 4x 5mg vials
- Cost: ~$160

Total: $240 for 30-day supply
```

### Protocol Builder
```
Protocol: "GLOW Skin Stack"
Duration: 12 weeks

Phase 1 - Loading (8 weeks):
- GHK-Cu: 2mg daily
- Thymosin Beta-4: 2mg twice weekly

Phase 2 - Maintenance (4 weeks):
- GHK-Cu: 1mg daily
- Thymosin Beta-4: 2mg once weekly

Expected Results:
- Improved skin texture
- Reduced fine lines
- Enhanced collagen production
```

### Peptide Library
```
Featured Peptides Visible:
1. Semaglutide (GLP-1) - Blue card
2. BPC-157 (Recovery) - Green card
3. TB-500 (Healing) - Teal card
4. GHK-Cu (Anti-Aging) - Purple card
5. Thymosin Beta-4 (Tissue Repair) - Orange card
6. Cerebrolysin (Cognitive) - Indigo card

Each card shows:
- Peptide name
- Primary benefit tag
- Dosing frequency
- Evidence level badge
```

---

## Professional Screenshot Service

### DIY Timeline
- Implement missing screens: 2-3 days
- Create sample data: 1 day
- Capture screenshots: 1 day
- Edit and optimize: 1 day
- **Total**: 5-7 days

### Professional Service (Recommended for Quality)
- **Fiverr**: $50-150 for App Store screenshot set
- **99designs**: $200-500 for premium screenshots
- **Freelancer**: $100-300 depending on complexity

**What they provide**:
- Device mockups with frames
- Text overlays and captions
- Optimized for conversion
- Multiple revisions
- All required sizes
- Professional design

---

## Caption Ideas (Optional Overlay Text)

### Screenshot 1 - GLP-1 Journey
- "Your GLP-1 Journey, Simplified"
- "Dose Escalation Made Easy"
- "Track Your Weight Loss Progress"

### Screenshot 2 - Calculator
- "Medical-Grade Calculations"
- "Precise. Accurate. Reliable."
- "Never Second-Guess Your Dose"

### Screenshot 3 - Supply Planner
- "Plan Ahead, Save Money"
- "Optimize Your Peptide Supply"
- "30-90 Day Supply Planning"

### Screenshot 4 - Protocol Builder
- "Build Custom Protocols"
- "Multi-Peptide Stack Design"
- "From Research to Results"

### Screenshot 5 - Library
- "30+ Research-Backed Peptides"
- "Your Peptide Encyclopedia"
- "Evidence-Based Information"

---

## A/B Testing Strategy (Post-Launch)

Once you have initial screenshots, consider testing variations:

### Test 1: Captions vs No Captions
- Version A: Clean screenshots only
- Version B: Screenshots with text overlays

### Test 2: Light vs Dark Mode
- Version A: All light mode screenshots
- Version B: Mix of light and dark mode

### Test 3: Screenshot Order
- Version A: GLP-1 first (current plan)
- Version B: Calculator first (if GLP-1 less popular)

**Use App Store Product Page Optimization** (available in App Store Connect) to test variations without app updates.

---

## Next Steps

1. **Week 1**: Implement missing views (Calculator, Planner, Builder, Library)
2. **Week 2**: Create sample data and polish UI for screenshots
3. **Week 3**: Capture screenshots from iPhone 15 Pro Max simulator
4. **Week 4**: Capture iPad screenshots
5. **Week 5**: Edit and optimize screenshots
6. **Week 6**: Upload to App Store Connect

**Shortcut**: Use existing web app screenshots as reference and recreate in iOS app style.

---

**Last Updated**: 2025-10-20  
**Status**: Planning phase - views need implementation  
**Priority**: High (required for App Store submission)
