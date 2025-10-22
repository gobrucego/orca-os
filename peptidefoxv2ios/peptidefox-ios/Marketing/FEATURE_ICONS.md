# PeptideFox Feature Icons

SVG icon specifications for website and marketing materials.

---

## Design System

### Icon Specifications
- **Format**: SVG (scalable vector graphics)
- **Viewbox**: 24x24 (can scale to any size)
- **Stroke width**: 2px
- **Color**: PeptideFox blue (#2563EB) primary, neutral (#6B7280) secondary
- **Style**: Outline icons (not filled)
- **Grid**: 4px alignment grid
- **Padding**: 2px safe area from edges

### Color Palette
```
Primary Blue: #2563EB (brand color)
Success Green: #10B981 (safety, success states)
Warning Orange: #F59E0B (alerts, attention)
Error Red: #EF4444 (warnings, errors)
Neutral Gray: #6B7280 (secondary elements)
```

---

## Icon 1: Calculator Icon

**Filename**: `calculator-icon.svg`

**Concept**: Minimalist calculator with peptide vial silhouette

**SVG Code**:
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Calculator frame -->
  <rect x="4" y="2" width="12" height="18" rx="2" stroke="#2563EB" stroke-width="2"/>

  <!-- Display screen -->
  <rect x="6" y="4" width="8" height="4" rx="1" fill="#2563EB" fill-opacity="0.1" stroke="#2563EB" stroke-width="1.5"/>

  <!-- Calculator buttons (grid) -->
  <circle cx="7" cy="12" r="1" fill="#6B7280"/>
  <circle cx="10" cy="12" r="1" fill="#6B7280"/>
  <circle cx="13" cy="12" r="1" fill="#6B7280"/>

  <circle cx="7" cy="15" r="1" fill="#6B7280"/>
  <circle cx="10" cy="15" r="1" fill="#6B7280"/>
  <circle cx="13" cy="15" r="1" fill="#6B7280"/>

  <circle cx="7" cy="18" r="1" fill="#6B7280"/>
  <circle cx="10" cy="18" r="1" fill="#6B7280"/>
  <circle cx="13" cy="18" r="1" fill="#2563EB"/>

  <!-- Vial silhouette overlay (top-right) -->
  <g transform="translate(16, 3)">
    <rect x="0" y="0" width="4" height="8" rx="1" fill="#2563EB" fill-opacity="0.2" stroke="#2563EB" stroke-width="1.5"/>
    <line x1="1" y1="2" x2="3" y2="2" stroke="#2563EB" stroke-width="1" stroke-linecap="round"/>
  </g>
</svg>
```

**Usage**:
- Website hero section
- App Store preview
- Marketing materials emphasizing calculation accuracy

---

## Icon 2: Safety Shield Icon

**Filename**: `safety-shield-icon.svg`

**Concept**: Shield with checkmark, representing validation and safety

**SVG Code**:
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Shield outline -->
  <path d="M12 2L4 6V12C4 16.42 7.2 20.34 12 22C16.8 20.34 20 16.42 20 12V6L12 2Z"
        stroke="#10B981"
        stroke-width="2"
        stroke-linejoin="round"/>

  <!-- Checkmark -->
  <path d="M9 12L11 14L15 10"
        stroke="#10B981"
        stroke-width="2.5"
        stroke-linecap="round"
        stroke-linejoin="round"/>

  <!-- Safety dots (optional detail) -->
  <circle cx="12" cy="7" r="0.5" fill="#10B981"/>
</svg>
```

**Alternative version** (with warning indicator):
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Shield outline -->
  <path d="M12 2L4 6V12C4 16.42 7.2 20.34 12 22C16.8 20.34 20 16.42 20 12V6L12 2Z"
        stroke="#F59E0B"
        stroke-width="2"
        stroke-linejoin="round"/>

  <!-- Exclamation mark -->
  <line x1="12" y1="8" x2="12" y2="13" stroke="#F59E0B" stroke-width="2.5" stroke-linecap="round"/>
  <circle cx="12" cy="16" r="1" fill="#F59E0B"/>
</svg>
```

**Usage**:
- Safety features section
- Validation messaging
- Trust indicators

---

## Icon 3: Peptide Library Icon

**Filename**: `library-icon.svg`

**Concept**: Stack of books/database with molecule overlay

**SVG Code**:
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Book stack (library) -->
  <rect x="4" y="14" width="10" height="2" rx="0.5" fill="#2563EB" fill-opacity="0.3"/>
  <rect x="4" y="16" width="10" height="2" rx="0.5" fill="#2563EB" fill-opacity="0.5"/>
  <rect x="4" y="18" width="10" height="3" rx="0.5" fill="#2563EB" fill-opacity="0.7"/>

  <!-- Database/grid representation -->
  <g transform="translate(2, 4)">
    <rect x="0" y="0" width="18" height="8" rx="1.5" stroke="#2563EB" stroke-width="2" fill="none"/>
    <line x1="0" y1="3" x2="18" y2="3" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
    <line x1="0" y1="6" x2="18" y2="6" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
    <line x1="6" y1="0" x2="6" y2="8" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
    <line x1="12" y1="0" x2="12" y2="8" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
  </g>
</svg>
```

**Alternative version** (molecular structure overlay):
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Open book -->
  <path d="M4 19.5C4 18.12 5.12 17 6.5 17H20" stroke="#2563EB" stroke-width="2" stroke-linecap="round"/>
  <path d="M6.5 2H20V22H6.5C5.12 22 4 20.88 4 19.5V4.5C4 3.12 5.12 2 6.5 2Z" stroke="#2563EB" stroke-width="2"/>
  <path d="M12 2V22" stroke="#2563EB" stroke-width="1" opacity="0.3"/>

  <!-- Molecule nodes -->
  <circle cx="8" cy="8" r="1.5" fill="#2563EB"/>
  <circle cx="12" cy="6" r="1.5" fill="#2563EB"/>
  <circle cx="16" cy="8" r="1.5" fill="#2563EB"/>
  <circle cx="10" cy="11" r="1.5" fill="#2563EB"/>
  <circle cx="14" cy="11" r="1.5" fill="#2563EB"/>

  <!-- Connecting lines -->
  <line x1="8" y1="8" x2="12" y2="6" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
  <line x1="12" y1="6" x2="16" y2="8" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
  <line x1="8" y1="8" x2="10" y2="11" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
  <line x1="16" y1="8" x2="14" y2="11" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
</svg>
```

**Usage**:
- Library feature highlights
- Research-backed messaging
- Content exploration sections

---

## Icon 4: Supply Chart Icon

**Filename**: `supply-chart-icon.svg`

**Concept**: Timeline/chart with alert indicator

**SVG Code**:
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Chart axes -->
  <line x1="4" y1="20" x2="20" y2="20" stroke="#6B7280" stroke-width="2" stroke-linecap="round"/>
  <line x1="4" y1="4" x2="4" y2="20" stroke="#6B7280" stroke-width="2" stroke-linecap="round"/>

  <!-- Declining supply line -->
  <path d="M6 8L10 10L14 14L18 18"
        stroke="#2563EB"
        stroke-width="2.5"
        stroke-linecap="round"
        stroke-linejoin="round"/>

  <!-- Alert bell (reorder notification) -->
  <g transform="translate(16, 2)">
    <path d="M1 4C1 2.9 1.9 2 3 2C4.1 2 5 2.9 5 4C5 5.1 4.1 6 3 6L1 6C1 5.1 1 4.9 1 4Z"
          fill="#F59E0B"/>
    <path d="M2 6V6.5C2 6.8 2.2 7 2.5 7H3.5C3.8 7 4 6.8 4 6.5V6"
          fill="#F59E0B"/>
    <circle cx="3" cy="1" r="0.8" fill="#EF4444"/>
  </g>

  <!-- Data points -->
  <circle cx="6" cy="8" r="2" fill="#2563EB"/>
  <circle cx="10" cy="10" r="2" fill="#2563EB"/>
  <circle cx="14" cy="14" r="2" fill="#2563EB"/>
  <circle cx="18" cy="18" r="2" fill="#F59E0B"/>
</svg>
```

**Alternative version** (calendar-based):
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Calendar frame -->
  <rect x="3" y="4" width="18" height="18" rx="2" stroke="#2563EB" stroke-width="2"/>
  <line x1="3" y1="9" x2="21" y2="9" stroke="#2563EB" stroke-width="2"/>
  <line x1="8" y1="2" x2="8" y2="6" stroke="#2563EB" stroke-width="2" stroke-linecap="round"/>
  <line x1="16" y1="2" x2="16" y2="6" stroke="#2563EB" stroke-width="2" stroke-linecap="round"/>

  <!-- Supply depletion visualization -->
  <rect x="6" y="12" width="3" height="6" rx="0.5" fill="#10B981"/>
  <rect x="10.5" y="12" width="3" height="6" rx="0.5" fill="#10B981"/>
  <rect x="15" y="12" width="3" height="6" rx="0.5" fill="#F59E0B"/>

  <!-- Alert indicator -->
  <circle cx="18" cy="14" r="3" fill="#EF4444"/>
  <text x="18" y="16" text-anchor="middle" font-size="6" fill="white" font-weight="bold">!</text>
</svg>
```

**Usage**:
- Supply planning features
- Reorder alert messaging
- Cost savings illustrations

---

## Icon 5: Device Recommendation Icon

**Filename**: `device-icon.svg`

**Concept**: Syringe with smart/AI indicator

**SVG Code**:
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Syringe body -->
  <rect x="8" y="10" width="12" height="4" rx="1" stroke="#2563EB" stroke-width="2"/>
  <rect x="4" y="11" width="4" height="2" fill="#2563EB" fill-opacity="0.3"/>

  <!-- Plunger -->
  <line x1="3" y1="12" x2="8" y2="12" stroke="#2563EB" stroke-width="2" stroke-linecap="round"/>
  <circle cx="3" cy="12" r="1.5" fill="#2563EB"/>

  <!-- Needle -->
  <path d="M20 10L22 8L20 6" stroke="#6B7280" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>

  <!-- Measurement markings -->
  <line x1="10" y1="10" x2="10" y2="14" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
  <line x1="12" y1="10" x2="12" y2="14" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
  <line x1="14" y1="10" x2="14" y2="14" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
  <line x1="16" y1="10" x2="16" y2="14" stroke="#2563EB" stroke-width="1" opacity="0.5"/>
  <line x1="18" y1="10" x2="18" y2="14" stroke="#2563EB" stroke-width="1" opacity="0.5"/>

  <!-- Smart/AI indicator (sparkle) -->
  <g transform="translate(16, 3)">
    <path d="M0 2L1 1L2 2L1 3Z" fill="#10B981"/>
    <path d="M2 0L3 1L2 2L1 1Z" fill="#10B981" opacity="0.7"/>
  </g>
</svg>
```

**Usage**:
- Device selection features
- Smart recommendation messaging
- Precision accuracy highlights

---

## Icon 6: Protocol Builder Icon

**Filename**: `protocol-icon.svg`

**Concept**: Layered stack with checkboxes/phases

**SVG Code**:
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Document stack -->
  <rect x="4" y="6" width="14" height="16" rx="2" stroke="#2563EB" stroke-width="2" fill="white"/>
  <rect x="6" y="4" width="14" height="2" rx="1" fill="#2563EB" fill-opacity="0.3"/>
  <rect x="8" y="2" width="14" height="2" rx="1" fill="#2563EB" fill-opacity="0.2"/>

  <!-- Checklist items -->
  <g transform="translate(7, 10)">
    <!-- Item 1 (checked) -->
    <rect x="0" y="0" width="3" height="3" rx="0.5" stroke="#10B981" stroke-width="1.5" fill="none"/>
    <path d="M0.8 1.5L1.5 2.2L2.2 0.8" stroke="#10B981" stroke-width="1.5" stroke-linecap="round"/>
    <line x1="4" y1="1.5" x2="10" y2="1.5" stroke="#6B7280" stroke-width="1.5" stroke-linecap="round"/>

    <!-- Item 2 (checked) -->
    <rect x="0" y="5" width="3" height="3" rx="0.5" stroke="#10B981" stroke-width="1.5" fill="none"/>
    <path d="M0.8 6.5L1.5 7.2L2.2 5.8" stroke="#10B981" stroke-width="1.5" stroke-linecap="round"/>
    <line x1="4" y1="6.5" x2="10" y2="6.5" stroke="#6B7280" stroke-width="1.5" stroke-linecap="round"/>

    <!-- Item 3 (in progress) -->
    <rect x="0" y="10" width="3" height="3" rx="0.5" stroke="#2563EB" stroke-width="1.5" fill="#2563EB" fill-opacity="0.1"/>
    <line x1="4" y1="11.5" x2="10" y2="11.5" stroke="#2563EB" stroke-width="1.5" stroke-linecap="round"/>
  </g>
</svg>
```

**Usage**:
- Protocol builder features
- Multi-peptide stack messaging
- Phase-based protocol highlights

---

## Icon Usage Guidelines

### Size Specifications

**Website**:
- Hero section: 64x64px (scale SVG to 64x64)
- Feature cards: 48x48px
- List items: 24x24px
- Footer: 20x20px

**Marketing Materials**:
- Print (business cards): 300dpi, scale appropriately
- Social media: 120x120px minimum
- Presentations: 96x96px

### Color Variations

**Primary** (default):
- Use brand blue #2563EB for primary elements

**Dark Mode**:
- Primary: #60A5FA (lighter blue)
- Neutral: #9CA3AF (lighter gray)
- Success: #34D399 (lighter green)

**Accessibility**:
- Ensure 3:1 contrast ratio minimum for icons
- Provide text labels alongside icons
- Use ARIA labels for screen readers

### Animation (Optional)

For interactive use (hover states, loading):

**Hover Animation** (CSS):
```css
.feature-icon {
  transition: transform 0.2s ease;
}

.feature-icon:hover {
  transform: translateY(-2px);
}
```

**Loading State**:
```css
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.feature-icon.loading {
  animation: pulse 1.5s ease-in-out infinite;
}
```

---

## Export Instructions

### Figma Export
1. Create 24x24 frame
2. Design icon within frame
3. Select frame
4. Export as SVG
5. Optimize with SVGO

### SVG Optimization
```bash
# Install SVGO
npm install -g svgo

# Optimize SVG
svgo calculator-icon.svg -o calculator-icon-optimized.svg

# Batch optimize
svgo -f ./icons -o ./icons-optimized
```

### PNG Fallbacks (if needed)
```bash
# Convert SVG to PNG at multiple sizes
for size in 24 48 64 96 128; do
  rsvg-convert -w $size -h $size calculator-icon.svg > calculator-icon-${size}.png
done
```

---

## Icon Set Deliverables

### Files to Create
```
Marketing/Icons/
├── calculator-icon.svg
├── safety-shield-icon.svg
├── library-icon.svg
├── supply-chart-icon.svg
├── device-icon.svg
├── protocol-icon.svg
├── dark-mode/
│   ├── calculator-icon-dark.svg
│   ├── safety-shield-icon-dark.svg
│   ├── library-icon-dark.svg
│   ├── supply-chart-icon-dark.svg
│   ├── device-icon-dark.svg
│   └── protocol-icon-dark.svg
└── png-fallbacks/
    ├── calculator-icon-48.png
    ├── calculator-icon-96.png
    └── ... (all icons at 48px and 96px)
```

---

## Questions?

For icon design questions or custom icon requests:
- Email: support@peptidefox.com
- Design system: See `/peptidefoxv2/CLAUDE.md`
- Brand assets: `/peptidefoxv2/assets/`
