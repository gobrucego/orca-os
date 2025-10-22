# PeptideFox Screenshot Capture Guide

Step-by-step instructions for capturing professional App Store screenshots.

---

## Prerequisites

### Required Software
- Xcode 15.0+ with iOS 17.0+ simulators
- macOS Sonoma 14.0+ (for latest simulators)
- Optional: Figma or Sketch for overlay design

### Required Simulators
1. iPhone 15 Pro Max (6.7" display)
2. iPad Pro 12.9" (6th generation)

Install via Xcode > Settings > Platforms > iOS > [+] Download simulator

---

## Phase 1: Environment Setup

### 1. Build Configuration

```bash
# Navigate to iOS project
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios

# Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData

# Build in Release mode
xcodebuild -scheme PeptideFox \
  -configuration Release \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max' \
  clean build
```

### 2. Simulator Preparation

**iPhone 15 Pro Max Setup:**
```bash
# Launch simulator
open -a Simulator

# Select: Hardware > Device > iPhone 15 Pro Max

# Reset simulator to factory state
xcrun simctl erase "iPhone 15 Pro Max"

# Set to Light Mode
xcrun simctl ui "iPhone 15 Pro Max" appearance light

# Set time to 9:41 (Apple standard)
# Manually via Settings > General > Date & Time
# Set to: 9:41 AM

# Set status bar
xcrun simctl status_bar "iPhone 15 Pro Max" override \
  --time "9:41" \
  --dataNetwork wifi \
  --wifiMode active \
  --wifiBars 3 \
  --cellularMode active \
  --cellularBars 4 \
  --batteryState charged \
  --batteryLevel 100
```

**iPad Pro 12.9" Setup:**
```bash
# Launch iPad simulator
xcrun simctl boot "iPad Pro 12.9-inch (6th generation)"

# Same status bar setup as iPhone
xcrun simctl status_bar "iPad Pro 12.9-inch (6th generation)" override \
  --time "9:41" \
  --dataNetwork wifi \
  --wifiMode active \
  --wifiBars 3 \
  --batteryState charged \
  --batteryLevel 100
```

### 3. Install Fresh App

```bash
# Install app on iPhone simulator
xcrun simctl install "iPhone 15 Pro Max" \
  ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Build/Products/Release-iphonesimulator/PeptideFox.app

# Install app on iPad simulator
xcrun simctl install "iPad Pro 12.9-inch (6th generation)" \
  ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Build/Products/Release-iphonesimulator/PeptideFox.app

# Launch app
xcrun simctl launch "iPhone 15 Pro Max" com.peptidefox.app
```

### 4. Display Settings

**Simulator Window:**
- Window > Physical Size (Cmd+1)
- Ensure full device frame visible
- Center window on screen for capture

**Brightness:**
- Maximum brightness in simulator
- Disable night shift/true tone

---

## Phase 2: Data Population

### Sample Data Setup

Launch app and populate with realistic sample data:

#### Calculator Sample Data
```
Vial Size: 10mg
Reconstitution Volume: 2.0mL
Target Dose: 0.25mg
Frequency: Weekly (1x/week)
```

#### Protocol Builder Sample Stack
Create a draft protocol named "Metabolic Optimization":

**Peptide 1: Semaglutide**
- Dose: 0.25mg weekly (Week 1-4)
- Dose: 0.5mg weekly (Week 5-8)
- Device: Injectable Pen
- Phase: Foundation (Week 1-8)

**Peptide 2: BPC-157**
- Dose: 250mcg daily
- Device: 50-unit syringe
- Phase: Foundation (Week 1-12)

**Peptide 3: Tirzepatide** (for interaction warning)
- Dose: 2.5mg weekly
- Device: Injectable Pen
- Phase: Enhancement (Week 9-16)
- NOTE: This triggers drug interaction warning with Semaglutide

#### Supply Planner Sample
```
Peptide: BPC-157
Vial size: 5mg
Dose: 250mcg (0.25mg)
Frequency: Daily
Duration: 30 days
```

#### Library Data
No setup needed - uses built-in peptide database

---

## Phase 3: Screenshot Capture

### iPhone 6.7" Screenshots

#### Screenshot 1: Hero Calculator

**Setup:**
1. Navigate to Calculator tab
2. Enter sample data:
   - Vial: 10mg
   - Recon: 2mL
   - Dose: 0.25mg
   - Frequency: Weekly
3. Tap "Calculate"
4. Wait for animation to complete
5. Ensure device recommendation shows "100-unit syringe"
6. Verify syringe guide is visible

**Capture:**
```bash
# Method 1: Simulator menu
Simulator > File > Save Screen (Cmd+S)
Save as: 01_hero_calculator_raw.png

# Method 2: Screenshot command
xcrun simctl io "iPhone 15 Pro Max" screenshot \
  ~/Desktop/01_hero_calculator_raw.png
```

**Verify:**
- Resolution: 1290 x 2796 pixels
- Calculator results clearly visible
- Device recommendation badge present
- Syringe guide showing correct markings

---

#### Screenshot 2: Device Picker

**Setup:**
1. From calculator results, tap "Choose Different Device"
2. Wait for bottom sheet to fully animate open
3. Ensure all 4 device options visible:
   - Injectable Pen
   - 30-Unit Syringe
   - 50-Unit Syringe
   - 100-Unit Syringe (RECOMMENDED)
4. Verify recommended badge is green
5. Ensure capacity indicators show

**Capture:**
```bash
xcrun simctl io "iPhone 15 Pro Max" screenshot \
  ~/Desktop/02_device_picker_raw.png
```

**Verify:**
- All 4 devices visible
- "RECOMMENDED" badge prominent
- Technical specs readable
- Bottom sheet fully open

---

#### Screenshot 3: Peptide Library

**Setup:**
1. Navigate to Library tab (bottom nav)
2. Ensure "All Categories" selected (or no filter)
3. Scroll to show mix of peptide categories:
   - Row 1: Semaglutide (blue), Tirzepatide (blue)
   - Row 2: BPC-157 (green), TB-500 (green)
   - Row 3: Tesamorelin (orange), CJC-1295 (orange)
   - Row 4+: Additional peptides
4. Verify badge colors clearly visible
5. Ensure evidence level indicators show

**Capture:**
```bash
xcrun simctl io "iPhone 15 Pro Max" screenshot \
  ~/Desktop/03_peptide_library_raw.png
```

**Verify:**
- 12-16 peptide cards visible
- Color-coded badges clear
- Grid layout balanced
- Search bar visible at top

---

#### Screenshot 4: Safety Validation

**Setup:**
1. Navigate to Protocol Builder (or Protocols tab)
2. Create/open protocol with drug interaction:
   - Add Semaglutide (0.25mg weekly)
   - Add Tirzepatide (2.5mg weekly)
3. Wait for validation to trigger
4. Verify warning banner appears:
   - "⚠️ Drug Interaction Detected"
   - "Both are GLP-1 receptor agonists"
   - "Consult physician before combining"
5. Ensure validation panel shows:
   - Green checkmarks for valid rules
   - Yellow/red warnings for violations

**Capture:**
```bash
xcrun simctl io "iPhone 15 Pro Max" screenshot \
  ~/Desktop/04_safety_validation_raw.png
```

**Verify:**
- Warning banner prominent at top
- Interaction explanation visible
- Validation checklist shows mixed status
- Safety-first messaging clear

---

#### Screenshot 5: Supply Planner

**Setup:**
1. Navigate to Supply Planner (Tools tab > Supply Planner)
2. Enter BPC-157 supply data:
   - Peptide: BPC-157
   - Vial size: 5mg
   - Dose: 250mcg (0.25mg)
   - Frequency: Daily
3. Tap "Calculate Supply"
4. Wait for results to load
5. Verify timeline shows:
   - 20 days per vial
   - Reorder recommendation at Day 15
   - Cost per injection
   - Monthly cost estimate

**Capture:**
```bash
xcrun simctl io "iPhone 15 Pro Max" screenshot \
  ~/Desktop/05_supply_planner_raw.png
```

**Verify:**
- Supply timeline chart visible
- Reorder alert indicator clear
- Cost breakdown panel showing
- All calculations displayed

---

### iPad 12.9" Screenshots

#### Screenshot 6: Split View (iPad only)

**Setup:**
1. Launch app on iPad simulator
2. Ensure device is in Landscape orientation
   - Rotate simulator: Device > Rotate Left (Cmd+Left)
3. If app supports split view natively, activate it
4. Otherwise, capture two views separately:
   - Left: Calculator with completed calculation
   - Right: Peptide Library showing grid

**Capture:**
```bash
xcrun simctl io "iPad Pro 12.9-inch (6th generation)" screenshot \
  ~/Desktop/06_ipad_split_view_raw.png
```

**Verify:**
- Resolution: 2048 x 2732 pixels
- Both panes clearly visible
- Landscape orientation
- Professional UI density

---

#### Screenshot 7: Peptide Detail (iPad)

**Setup:**
1. Navigate to Library tab
2. Tap on Semaglutide card
3. Full detail view opens
4. Scroll to show comprehensive information:
   - Clinical mechanism
   - Benefits and indications
   - Contraindications
   - Success signals
   - Synergies
   - Dosing protocols
   - Research references
5. Ensure all sections visible or scroll to "sweet spot"

**Capture:**
```bash
xcrun simctl io "iPad Pro 12.9-inch (6th generation)" screenshot \
  ~/Desktop/07_ipad_peptide_detail_raw.png
```

**Verify:**
- Large readable text
- Organized sections with icons
- Evidence level badges visible
- Reference citations showing

---

#### Screenshot 8: Protocol Builder (iPad)

**Setup:**
1. Navigate to Protocol Builder
2. Create/open protocol with 3-4 peptide stack:
   - Semaglutide (GLP-1 base)
   - BPC-157 (healing)
   - MOTS-c (mitochondrial)
   - TB-500 (joint health)
3. Ensure phase timeline visible
4. Show dosing schedule table
5. Validation status panel displayed

**Capture:**
```bash
xcrun simctl io "iPad Pro 12.9-inch (6th generation)" screenshot \
  ~/Desktop/08_ipad_protocol_builder_raw.png
```

**Verify:**
- Multiple peptides visible
- Phase timeline showing
- Frequency schedules clear
- Validation indicators present

---

## Phase 4: Image Processing

### 1. Verify Raw Screenshots

```bash
# Check dimensions
cd ~/Desktop
sips -g pixelWidth -g pixelHeight *.png

# Expected output:
# 01-05: 1290 x 2796 (iPhone)
# 06-08: 2048 x 2732 (iPad)
```

### 2. Organize Files

```bash
# Create directories
mkdir -p ~/Desktop/PeptideFox_Screenshots/Raw
mkdir -p ~/Desktop/PeptideFox_Screenshots/Processed

# Move raw files
mv ~/Desktop/*_raw.png ~/Desktop/PeptideFox_Screenshots/Raw/
```

### 3. Add Text Overlays (Figma/Sketch)

**Figma Template Setup:**

1. Create new Figma file: "PeptideFox Screenshots"
2. Create frame: 1290 x 2796 (iPhone) or 2048 x 2732 (iPad)
3. Import raw screenshot as background
4. Add overlay layers:

**Layer structure:**
```
Frame: iPhone_01_Hero
├── Background: [Raw screenshot]
├── Gradient (optional):
│   └── Linear gradient (0deg)
│       - Stop 1: rgba(0,0,0,0.7) at 0%
│       - Stop 2: rgba(0,0,0,0.3) at 40%
│       - Stop 3: transparent at 60%
│   Height: 300px from top
├── Icon:
│   └── PeptideFox icon (80x80px)
│   Position: Top-left (32px, 32px)
├── Text Group:
│   ├── Headline:
│   │   - Font: Brown LL Medium
│   │   - Size: 36px
│   │   - Color: #FFFFFF
│   │   - Letter-spacing: -0.02em
│   │   - Text: "Medical-Grade Precision"
│   │   - Position: (64px, 140px)
│   ├── Subhead:
│   │   - Font: Brown LL Regular
│   │   - Size: 20px
│   │   - Color: #FFFFFF at 80% opacity
│   │   - Letter-spacing: 0
│   │   - Text: "Calculate exact injection volumes"
│   │   - Text: "with ±0.001mL accuracy"
│   │   - Position: (64px, 190px)
│   └── Drop Shadow:
│       - X: 0, Y: 2, Blur: 8
│       - Color: rgba(0,0,0,0.3)
```

**Text overlay content for each screenshot:**

**Screenshot 1 (Hero):**
- Headline: "Medical-Grade Precision"
- Subhead: "Calculate exact injection volumes\nwith ±0.001mL accuracy"

**Screenshot 2 (Device):**
- Headline: "Smart Device Matching"
- Subhead: "Automatic recommendations\nbased on your dose"

**Screenshot 3 (Library):**
- Headline: "Complete Peptide Library"
- Subhead: "Research-backed protocols\nwith clinical data"

**Screenshot 4 (Safety):**
- Headline: "Medical-Grade Safety"
- Subhead: "Automatic validation and\ninteraction detection"

**Screenshot 5 (Supply):**
- Headline: "Smart Supply Planning"
- Subhead: "Calculate exactly when\nto reorder"

**iPad Screenshots:**
- iPad 1: "iPad-Optimized Workflow" / "Calculator and library side-by-side"
- iPad 2: "Complete Clinical Information" / "Evidence-based protocols at your fingertips"
- iPad 3: "Advanced Protocol Builder" / "Create and track multi-peptide stacks"

### 4. Export Settings (Figma)

**Export configuration:**
```
Format: PNG
Scale: 1x (actual pixels)
Color profile: sRGB IEC61966-2.1
Constraints: Scale
Compression: Optimized

Settings:
☑ Include "id" attribute
☐ Outline text
☑ Flatten transforms
```

**Export each frame:**
1. Select frame
2. Export settings (right panel)
3. Add export: PNG, 1x
4. Export as:
   - `01_hero_calculator_1290x2796.png`
   - `02_device_picker_1290x2796.png`
   - etc.

### 5. Optimize File Sizes

```bash
# Install ImageOptim (if not installed)
brew install --cask imageoptim

# Optimize PNGs
cd ~/Desktop/PeptideFox_Screenshots/Processed
open -a ImageOptim *.png

# Or use command line
find . -name "*.png" -exec pngquant --quality=85-95 --ext .png --force {} \;

# Verify file sizes (must be < 500KB)
ls -lh *.png

# If still too large, use TinyPNG API or manual compression
```

### 6. Final Validation

```bash
# Check all specs
for file in *.png; do
  echo "File: $file"
  sips -g pixelWidth -g pixelHeight "$file"
  echo "Size: $(ls -lh "$file" | awk '{print $5}')"
  echo "---"
done

# Expected output:
# iPhone files: 1290x2796, < 500KB each
# iPad files: 2048x2732, < 500KB each
```

---

## Phase 5: Upload to App Store Connect

### 1. Login to App Store Connect

1. Visit: appstoreconnect.apple.com
2. Login with Apple Developer account
3. Navigate to: My Apps > PeptideFox > App Store tab

### 2. Upload Screenshots

**For iPhone 6.7" Display:**
1. Scroll to "6.7" Display" section
2. Click "+" to add screenshots
3. Upload all 5 iPhone screenshots in order:
   - 01_hero_calculator_1290x2796.png
   - 02_device_picker_1290x2796.png
   - 03_peptide_library_1290x2796.png
   - 04_safety_validation_1290x2796.png
   - 05_supply_planner_1290x2796.png
4. Drag to reorder if needed (hero should be first)

**For iPad Pro 12.9" Display:**
1. Scroll to "12.9" Display (3rd Gen)" section
2. Upload all 3 iPad screenshots:
   - 01_split_view_2048x2732.png
   - 02_peptide_detail_2048x2732.png
   - 03_protocol_builder_2048x2732.png

### 3. Preview Screenshots

- Click preview button to see thumbnail view
- Verify text is readable at small sizes
- Check screenshot order makes sense
- Test on actual device sizes

### 4. Save Changes

- Click "Save" in top-right
- Review all screenshots in context
- Make adjustments if needed

---

## Troubleshooting

### Issue: Screenshot has wrong dimensions

**Solution:**
```bash
# Check actual dimensions
sips -g pixelWidth -g pixelHeight screenshot.png

# Resize if needed (not recommended, recapture instead)
sips -z 2796 1290 screenshot.png --out resized.png
```

### Issue: File size too large (> 500KB)

**Solution:**
```bash
# Compress with pngquant
pngquant --quality=80-90 --ext .png --force screenshot.png

# Or use ImageOptim
open -a ImageOptim screenshot.png

# Or online: tinypng.com
```

### Issue: Status bar shows wrong time

**Solution:**
```bash
# Reset status bar
xcrun simctl status_bar "iPhone 15 Pro Max" override \
  --time "9:41"

# Or clear override and set manually
xcrun simctl status_bar "iPhone 15 Pro Max" clear
# Then set time via Settings app
```

### Issue: App shows debug data

**Solution:**
- Ensure building in Release mode (not Debug)
- Clean build folder and rebuild
- Delete app and reinstall fresh

### Issue: Simulator won't capture screenshot

**Solution:**
```bash
# Reset simulator
xcrun simctl shutdown "iPhone 15 Pro Max"
xcrun simctl erase "iPhone 15 Pro Max"
xcrun simctl boot "iPhone 15 Pro Max"

# Try alternative capture method
screencapture -x -C -T 0 ~/Desktop/screenshot.png
# Then crop to device bounds
```

### Issue: Text overlay not aligned

**Solution:**
- Use Figma rulers and grids (8px grid recommended)
- Set up guides at 32px from edges
- Use auto-layout frames for consistent spacing
- Test at thumbnail size (150px width)

---

## Quality Checklist

### Before Finalizing
- [ ] All screenshots at correct resolution
- [ ] All files under 500KB
- [ ] No personal or debug data visible
- [ ] Status bar shows 9:41, full battery, WiFi
- [ ] Text overlays readable at thumbnail size
- [ ] Brand colors consistent (#2563EB blue)
- [ ] Typography uses Brown LL font
- [ ] PeptideFox icon visible on each
- [ ] Screenshots tell a story (flow makes sense)
- [ ] No UI glitches or rendering errors
- [ ] Tested upload to App Store Connect
- [ ] Previewed on actual devices if possible

### Accessibility Check
- [ ] Text contrast ratio > 4.5:1 (WCAG AA)
- [ ] Important info not only in overlay
- [ ] Screenshots understandable without color
- [ ] Text size readable for vision impaired

---

## Timeline

**Total estimated time: 4-6 hours**

1. **Setup** (30 minutes)
   - Configure simulators
   - Build and install app
   - Prepare sample data

2. **Capture** (1.5 hours)
   - iPhone screenshots (5 screens)
   - iPad screenshots (3 screens)
   - Verify dimensions and quality

3. **Design overlays** (2 hours)
   - Create Figma templates
   - Add text and graphics
   - Refine typography and spacing

4. **Optimize and export** (30 minutes)
   - Compress images
   - Validate specifications
   - Upload to App Store Connect

5. **QA and iteration** (1 hour)
   - Review on devices
   - Make adjustments
   - Final approval

---

## Resources

### Screenshot Dimensions Reference
- iPhone 6.7": 1290 x 2796 (iPhone 15 Pro Max, 14 Pro Max)
- iPhone 6.5": 1284 x 2778 (iPhone 13 Pro Max, 12 Pro Max)
- iPhone 5.5": 1242 x 2208 (iPhone 8 Plus, 7 Plus)
- iPad Pro 12.9": 2048 x 2732 (3rd gen and later)
- iPad Pro 11": 1668 x 2388 (1st gen and later)

### Tools
- Xcode: developer.apple.com/xcode
- Simulator: Included with Xcode
- ImageOptim: imageoptim.com
- TinyPNG: tinypng.com
- Figma: figma.com
- Sketch: sketch.com

### Apple Documentation
- Screenshot specs: developer.apple.com/help/app-store-connect/reference/screenshot-specifications
- HIG: developer.apple.com/design/human-interface-guidelines
- App Store Connect: appstoreconnect.apple.com

---

## Next Steps

After completing screenshots:

1. **Update App Store copy** (see APP_STORE_COPY.md)
2. **Create preview videos** (optional but recommended)
3. **Localize screenshots** for international markets
4. **A/B test variations** if possible
5. **Monitor conversion rates** post-launch

---

## Support

Questions? Contact peptidefox.com/support

Design system reference: `/peptidefoxv2/CLAUDE.md`
Screenshot specifications: `SCREENSHOT_SPECIFICATIONS.md`
