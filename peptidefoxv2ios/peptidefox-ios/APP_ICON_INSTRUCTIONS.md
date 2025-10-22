# App Icon Creation Instructions

## Required Sizes

For iOS 17+, you only need ONE size:
- **1024x1024 pixels** (App Store icon)

Xcode will automatically generate all other required sizes from this single asset.

## Design Guidelines

### Apple Human Interface Guidelines
1. **No transparency**: Icon must have opaque background
2. **No rounded corners**: iOS automatically applies rounded corners
3. **Fill entire canvas**: Use all 1024x1024 pixels
4. **Test at small sizes**: Icon should be recognizable at 60x60 pixels
5. **Consistent with brand**: Match PeptideFox branding

### Design Options

#### Option 1: Fox Icon (Recommended)
- Simple fox silhouette or pawprint
- Blue gradient background (#007AFF to #5AC8FA)
- White fox/paw symbol
- Clean, modern, medical-professional aesthetic

#### Option 2: Medical Cross + Peptide
- Medical cross with peptide chain icon
- Professional color scheme (blue/teal)
- Represents both medical and scientific nature

#### Option 3: Molecule/Peptide Chain
- Simplified peptide chain structure
- Circular badge background
- Scientific but approachable

## Creating the Icon

### Using Design Tools

#### Figma (Free)
1. Create 1024x1024 artboard
2. Design icon following guidelines
3. Export as PNG at 1x (no @2x or @3x needed)
4. Ensure no transparency in export

#### Sketch
1. Create 1024x1024 artboard
2. Design icon
3. Export as PNG
4. Flatten transparency if any

#### Canva (Free)
1. Create custom size: 1024x1024 pixels
2. Use shapes and text to design
3. Download as PNG
4. Verify no transparency

### Using AI Tools

#### Midjourney/DALL-E
Prompt: "App icon for medical peptide calculator, minimalist fox icon, blue gradient background, 1024x1024, no text, iOS style, professional medical aesthetic"

#### Remove.bg + Photoshop
1. Find suitable fox/medical image
2. Remove background
3. Place on solid color background
4. Resize to 1024x1024
5. Flatten and export PNG

## Quick Placeholder (For Testing)

### System Symbol Icon (Temporary)
For immediate TestFlight submission, you can use this temporary approach:

```swift
// In Xcode, create a simple colored square:
1. Open Assets.xcassets/AppIcon.appiconset
2. Use macOS Preview or any image editor
3. Create 1024x1024 image:
   - Fill with #007AFF (iOS blue)
   - Add white "PF" text in center (400pt font)
   - Save as icon-1024.png
4. Drag into AppIcon.appiconset folder
```

### Using SF Symbols (Better Placeholder)
```swift
// Generate icon from SF Symbol:
1. Open SF Symbols app (free from Apple)
2. Find "pawprint.circle.fill"
3. Export at 1024x1024
4. Change background to blue
5. Use as temporary icon
```

## File Naming

Place your 1024x1024 icon in:
```
PeptideFoxProject/PeptideFox/Assets.xcassets/AppIcon.appiconset/icon-1024.png
```

## Validation Checklist

Before submitting to App Store:
- [ ] Icon is exactly 1024x1024 pixels
- [ ] Icon has NO transparency (no alpha channel)
- [ ] Icon has NO rounded corners (iOS adds them)
- [ ] Icon is PNG format
- [ ] Icon file size < 1MB
- [ ] Icon looks good on light AND dark backgrounds
- [ ] Icon is recognizable at 60x60 size
- [ ] Icon tested on actual device home screen
- [ ] Icon follows Apple HIG guidelines

## Testing Your Icon

### In Simulator
1. Build and run in Xcode
2. Press Cmd+Shift+H to go to home screen
3. View icon on home screen
4. Test in dark mode (Settings → Developer → Dark Appearance)

### On Device
1. Install via TestFlight or Xcode
2. View on actual home screen
3. Test in dark mode
4. Check in Settings app
5. Check in App Switcher

## Professional Icon Creation (Recommended for Production)

If you want a professional icon, consider:
- **Fiverr**: $20-50 for app icon design
- **99designs**: App icon contests starting at $299
- **Dribbble**: Hire designers from portfolio
- **Upwork**: Freelance designers

### Design Brief Template
```
PROJECT: PeptideFox iOS App Icon

DESCRIPTION:
Medical-grade calculator app for peptide therapy research.
Needs clean, professional, trustworthy icon.

STYLE:
- Modern iOS design aesthetic
- Medical/scientific feel
- Clean and minimalist
- Professional but approachable

CONCEPTS:
Option 1: Fox icon (brand name "PeptideFox")
Option 2: Peptide chain molecule
Option 3: Medical cross with scientific element

COLORS:
Primary: Blue (#007AFF iOS blue)
Secondary: Teal/Cyan (#5AC8FA)
Background: Solid color (no gradients if possible)

DELIVERABLES:
- 1024x1024 PNG (no transparency)
- Source file (Figma/Sketch/AI)

TIMELINE: 3-5 days
BUDGET: $50-100
```

## Temporary Testing Icon

For immediate testing, create this simple icon:

### Method 1: Solid Color + Text
```
1. Open any image editor
2. Create 1024x1024 canvas
3. Fill with #007AFF (iOS blue)
4. Add white "PF" text, centered, 400pt font
5. Save as PNG
6. Place in AppIcon.appiconset/icon-1024.png
```

### Method 2: Use Existing Asset
If you have the PeptideFox web logo:
```
1. Export web logo at high resolution
2. Resize to 1024x1024 (maintaining aspect ratio)
3. Center on solid background
4. Save as PNG
5. Place in AppIcon.appiconset/icon-1024.png
```

## Next Steps

1. **Immediate**: Create placeholder icon for TestFlight
2. **Within 1 week**: Design proper icon or hire designer
3. **Before App Store launch**: Have professional icon ready
4. **After launch**: Can update icon in app updates (users will see new icon)

## Resources

- [Apple HIG - App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [SF Symbols App](https://developer.apple.com/sf-symbols/)
- [Icon Generator Tools](https://appicon.co/)
- [Figma iOS Icon Template](https://www.figma.com/community/file/857303226040719719)

---

**Current Status**: Icon configuration ready, needs 1024x1024 PNG file
**Location**: `PeptideFoxProject/PeptideFox/Assets.xcassets/AppIcon.appiconset/icon-1024.png`
**Required Before**: TestFlight submission (can use placeholder)
**Professional Icon By**: App Store submission (recommended)
