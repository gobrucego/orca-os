---
name: design-with-precision
description: Apply obsessive, pixel-perfect design discipline to any content (READMEs, blogs, docs). Enforces mathematical spacing systems, typography scales, optical alignment, and zero-tolerance precision. Use for design review OR establishing new design systems.
---

# Design with Precision

**Philosophy:** Design is not creative expression. It is engineering discipline. Every value must derive from a system. Every spacing must follow a grid. Every violation must be caught and fixed.

**Tone:** Obsessive perfectionist (OCD mode). "This is 3px. Should be 4px from system." Zero tolerance for arbitrary values.

---

## When to Use This Skill

**Use for design review:**
- User asks to review UI/UX of existing content
- Analyzing READMEs, blog posts, documentation, landing pages
- Finding design violations and inconsistencies

**Use for design guidance:**
- Establishing design system for new content
- Creating style guides or documentation
- Setting up spacing, typography, and color systems

**Do NOT use when:**
- User explicitly asks for generic/casual design
- Quick prototyping where system will be applied later
- Content where design constraints don't apply (plain text logs, terminal output)

---

## Design System References

**CRITICAL:** Always check for project-specific design documentation first:

### Universal Design Guidelines
**Location:** Check project `docs/DESIGN-GUIDELINES.md`
**Reference:** `/Users/adilkalam/claude-vibe-code/docs/DESIGN-GUIDELINES.md`

Battle-tested design patterns covering:
- 4px base grid system
- Typography roles (Display, Heading, Body, Accent, Mono)
- Color system with semantic roles
- Optical alignment rules (triangles shift 5-8%, icons nudge 1-2px)
- Component patterns (cards, buttons, forms, tables)
- Animation guidelines (subtle, purposeful, max 0.3s)
- Quality checklist

**Use when:** Reviewing or establishing universal design systems for any project

### SwiftUI Design System
**Location:** Check project `docs/SWIFTUI-DESIGN-SYSTEM.md`
**Reference:** `/Users/adilkalam/claude-vibe-code/docs/SWIFTUI-DESIGN-SYSTEM.md`

iOS-specific implementation patterns:
- Font definitions using system fonts
- Semantic colors with dark mode support
- 4pt spacing system constants
- SwiftUI component patterns
- Alignment techniques with preference keys
- Accessibility requirements (VoiceOver, Dynamic Type)
- Common patterns (error states, empty states, loading)

**Use when:** Reviewing or establishing iOS/SwiftUI design systems

### How to Use These References

1. **First, check if project has these docs**
   - Look for `docs/DESIGN-GUIDELINES.md`
   - Look for `docs/SWIFTUI-DESIGN-SYSTEM.md`

2. **If found, ENFORCE those systems**
   - Reference specific sections when reviewing
   - Quote violations against documented patterns
   - Suggest fixes that align with documented system

3. **If not found, RECOMMEND establishing them**
   - "This project would benefit from documented design system"
   - "Consider adopting patterns from DESIGN-GUIDELINES.md"
   - "For iOS projects, see SWIFTUI-DESIGN-SYSTEM.md"

4. **Always cite specific rules**
   - ✗ "This spacing is wrong"
   - ✓ "Spacing is 14px but DESIGN-GUIDELINES.md requires 4px grid (12px or 16px)"

### Example Review with Design Doc References

**Scenario:** Reviewing SwiftUI card component

```swift
// Current implementation
struct CardView: View {
    var body: some View {
        VStack(spacing: 14) {  // ❌ VIOLATION
            Text("Title")
                .font(.system(size: 22))  // ❌ VIOLATION
                .padding(18)  // ❌ VIOLATION
        }
        .background(Color.gray.opacity(0.2))  // ❌ VIOLATION
    }
}
```

**Review Output:**

**VIOLATIONS FOUND:**

1. **Spacing: 14pt (arbitrary)**
   - SWIFTUI-DESIGN-SYSTEM.md § Spacing System requires 4pt grid
   - Fix: Use `Spacing.pt12` (12pt) or `Spacing.pt16` (16pt)
   - Deduction: -0.5

2. **Font size: 22pt (not in scale)**
   - SWIFTUI-DESIGN-SYSTEM.md § Typography System defines scale
   - Fix: Use `.heading3` (22pt if documented) or `.heading2` (28pt)
   - Deduction: -0.5

3. **Padding: 18pt (arbitrary)**
   - SWIFTUI-DESIGN-SYSTEM.md § Spacing System requires 4pt grid
   - Fix: Use `Spacing.pt16` (16pt) or `Spacing.pt20` (20pt)
   - Deduction: -0.5

4. **Color: Gray opacity 0.2 (not semantic)**
   - SWIFTUI-DESIGN-SYSTEM.md § Color System requires semantic colors
   - Fix: Use `Color.surfaceBase` for dark mode support
   - Deduction: -0.5

**CORRECTED:**
```swift
struct CardView: View {
    var body: some View {
        VStack(spacing: Spacing.pt16) {  // ✓ From system
            Text("Title")
                .font(.heading3)  // ✓ From system
                .padding(Spacing.pt20)  // ✓ From system
        }
        .background(Color.surfaceBase)  // ✓ Semantic + dark mode
    }
}
```

**Score: 8.0/10.0** (4 violations × -0.5 each = -2.0)

---

## Two Modes of Operation

### Mode 1: Review Existing Content

When reviewing existing design (README, blog, docs, landing page):

1. **Identify the context** (README vs blog vs docs vs UI)
2. **Detect current system** (or lack thereof)
3. **Find violations** with pixel-level precision
4. **Score systematically** with deduction breakdown
5. **Provide fixes** with exact values from proper system

### Mode 2: Establish New System

When creating new design system or guiding new content:

1. **Understand constraints** (markdown, web, print, etc.)
2. **Define base grid** (4px or 8px)
3. **Create type scale** (heading + body sizes)
4. **Establish spacing scale** (from base grid)
5. **Define color system** (with contrast ratios)
6. **Document tokens** (CSS variables or constants)

---

## Core Domains

**NOTE:** For projects with `docs/DESIGN-GUIDELINES.md` or `docs/SWIFTUI-DESIGN-SYSTEM.md`, enforce those documented systems first. The rules below are fallback patterns when no system exists.

### 1. Typography Systems

**Rules (Zero Tolerance):**

**Heading Depth:**
- Maximum depth: H4
- H5/H6 usage: **FORBIDDEN** (architectural violation)
- Each level must be semantically meaningful
- Deduction: -1.0 for H5/H6 usage, -0.5 per hierarchy violation

**Type Scale (Must Follow System):**
- Define scale based on context:
  - **README/Docs:** 48px, 32px, 24px, 20px, 16px, 14px
  - **Blog:** 56px, 40px, 28px, 20px, 18px, 16px
  - **UI:** 36px, 24px, 20px, 16px, 14px, 12px
- All sizes must derive from scale
- Random values (17px, 19px, 23px): **FORBIDDEN**
- Deduction: -0.5 per arbitrary size

**Line Heights (Must Be Specified):**
- Headings: 1.1-1.2 (tight)
- Body: 1.5-1.6 (readable)
- Small text: 1.4
- UI elements: 1.3-1.4
- Random values (1.43, 1.67): **FORBIDDEN**
- Deduction: -0.5 per missing or arbitrary line-height

**Letter Spacing (Context-Dependent):**
- Display headings: 0.02em - 0.05em
- Body text: 0.02em (or 0 for optimized fonts)
- Small/labels: 0.08em - 0.12em (uppercase)
- Deduction: -0.5 if missing for display text

**Line Length:**
- Optimal: 60-75 characters per line
- Maximum: 85 characters
- Markdown: Specify in prose guidelines
- Deduction: -0.5 if violates readability (>90 chars)

**Violations to Catch:**
```
✗ Font size 17px (not in system)
✗ Line height 1.43 (arbitrary)
✗ Using H6 (max depth H4)
✗ Letter spacing 0.03em (use 0.02em or 0.04em)
```

**Fixes to Provide:**
```
✓ Use 16px or 20px from scale
✓ Line height 1.4 or 1.5 from system
✓ Restructure to use H2-H4 only
✓ Letter spacing 0.02em or 0.04em
```

---

### 2. Spacing & Grid Systems

**Rules (Zero Tolerance):**

**Base Grid:**
- Define base unit: **4px or 8px**
- All spacing derives from base × multiplier
- **No random values ever**
- Deduction: -1.5 if no system defined, -0.5 per arbitrary value

**Spacing Scale:**
Example for 4px base:
```
--space-1:  4px   (1×)
--space-2:  8px   (2×)
--space-3:  12px  (3×)
--space-4:  16px  (4×)
--space-6:  24px  (6×)
--space-8:  32px  (8×)
--space-10: 40px  (10×)
--space-12: 48px  (12×)
--space-16: 64px  (16×)
--space-20: 80px  (20×)
```

**Usage Guidelines:**
- Section spacing: 48px-64px (--space-12 to --space-16)
- Paragraph spacing: 16px-24px (--space-4 to --space-6)
- Element padding: 8px-16px (--space-2 to --space-4)
- Inline spacing: 4px-8px (--space-1 to --space-2)

**Responsive Scaling:**
- Mobile: May use tighter scale (reduce by 25-50%)
- Desktop: Use full scale
- Define breakpoint adjustments explicitly

**Violations to Catch:**
```
✗ Margin: 17px (not from grid)
✗ Padding: 13px (arbitrary)
✗ Gap: 5px (use 4px or 8px)
✗ "Add visual separation" (not specific enough)
```

**Fixes to Provide:**
```
✓ Margin: 16px (--space-4) or 20px (--space-5)
✓ Padding: 12px (--space-3) or 16px (--space-4)
✓ Gap: 4px (--space-1) or 8px (--space-2)
✓ Section spacing: 64px (--space-16)
```

---

### 3. Optical vs Mathematical Alignment

**Rules (Judgment Required):**

Mathematical precision is the foundation. But visual perception matters.

**When to Break Mathematical Rules:**

**Large display text appears optically heavy:**
- H1 at 48px may feel too large next to 16px body
- Consider 44px or 46px for optical balance
- **BUT:** Document this as intentional optical adjustment
- Deduction: None if documented; -0.5 if arbitrary

**Monospace code optically appears larger:**
- Body text: 16px
- Code blocks: 14px (optically balanced)
- Inline code: 15px (between body and blocks)
- **Document why** sizes differ

**Icon alignment with text:**
- Icons at same px size as text appear misaligned
- Optically adjust by 1-2px
- **Document adjustment**

**When NOT to Break Rules:**
- Spacing (grid is sacred)
- Color values (contrast is measurable)
- Responsive breakpoints (device-based)
- Arbitrary "feels better" (unacceptable)

**How to Document Optical Adjustments:**
```
/* Optical adjustment: H1 reduced from 48px (mathematical)
   to 44px (optical) for better balance with 16px body */
--font-size-h1: 44px;
```

**Violations to Catch:**
```
✗ "This looks off" with no mathematical baseline
✗ Optical adjustment without documentation
✗ Breaking grid for "visual spacing"
```

**Approach:**
```
✓ Establish mathematical baseline first
✓ Identify optical imbalance
✓ Make minimal adjustment (1-4px)
✓ Document why adjustment was made
```

---

### 4. Color & Contrast

**Rules (Zero Tolerance):**

**WCAG Compliance (Required):**
- Body text (<24px): **Minimum 7:1 (AAA)** preferred, 4.5:1 acceptable
- Large text (≥24px): **Minimum 4.5:1 (AA)**
- UI elements: **Minimum 3:1**
- Deduction: -1.5 per contrast violation

**How to Verify:**
1. **Calculate contrast ratio** (don't guess)
2. **Document actual ratios** in style guide
3. **Test with tools** (WebAIM, Stark, etc.)

**Color System (Must Be Defined):**
```
--color-text-primary:   #E8E4EF  (HSL 264°, 25%, 91%)
--color-text-subdued:   #A89FB3  (HSL 264°, 15%, 66%)
--color-background:     #0C051C  (HSL 264°, 65%, 6%)

Contrast ratios (against background):
- Primary text: 13.2:1 ✓ (exceeds AAA)
- Subdued text: 5.8:1 ✓ (exceeds AA for body)
```

**Violations to Catch:**
```
✗ "Ensure good contrast" (vague, no verification)
✗ Gray #888 on white (ratio 2.9:1 - fails WCAG)
✗ No contrast ratios documented
✗ "Looks fine to me" (not measured)
```

**Fixes to Provide:**
```
✓ Calculate ratio: #888 on white = 2.9:1 (fails)
✓ Use #767676 (4.5:1) or #595959 (7:1)
✓ Document all ratios in color system
✓ Verify with WebAIM contrast checker
```

---

### 5. Context-Specific Rules

Different mediums have different constraints and requirements.

#### GitHub README

**Constraints:**
- Markdown-only (no custom CSS)
- System fonts (SF Pro, Segoe UI, Roboto)
- Limited styling (bold, italic, code, quotes)
- Emoji acceptable for scannability

**Typography Rules:**
- H1: Project name only (once)
- H2: Major sections (Installation, Usage, API, etc.)
- H3: Subsections (optional)
- H4: Rare (API sub-items)
- H5/H6: **FORBIDDEN**
- Code blocks: Always specify language for syntax highlighting

**Visual Elements:**
- Badges: Required (version, build, license)
- Tables: Use for API reference, options
- Emoji: Strategic use for section headers (optional)
- Horizontal rules: For major section breaks
- Images: Screenshots, diagrams (hosted externally)

**Information Architecture:**
1. Title + badges
2. One-sentence description
3. Key features (3-5 bullets)
4. Quick start (working example)
5. Installation
6. Usage
7. API Reference
8. Examples
9. Contributing
10. License

**Scoring Deductions:**
- H5/H6 usage: -1.0
- Missing badges: -0.5
- Poor IA (Installation nested wrong): -1.0
- No quick start: -1.0
- Vague description: -0.5

#### Blog Post

**Constraints:**
- Full CSS control
- Custom fonts (web fonts)
- Rich media (images, videos, embeds)
- Designed layouts

**Typography Rules:**
- Display font for headings (serif or geometric sans)
- Readable font for body (Charter, Georgia, or humanist sans)
- H1: Article title (once, 40-56px)
- H2: Major sections (28-40px)
- H3: Subsections (24-28px)
- H4: Rare (20-24px)
- Body: 18-20px (larger than README for reading comfort)
- Line height: 1.6-1.7 (more generous)

**Visual Elements:**
- Hero image: Required
- Section breaks: Designed (not just <hr>)
- Pull quotes: For key insights
- Image captions: Smaller text, subdued color
- Code blocks: Syntax highlighting + copy button

**Spacing:**
- Section spacing: 80px-120px (generous)
- Paragraph spacing: 24px-32px
- Element padding: 16px-24px

**Scoring Deductions:**
- Body text <18px: -0.5 (readability)
- Line height <1.6: -0.5
- No hero image: -1.0
- Poor visual hierarchy: -1.0

#### Documentation Site

**Constraints:**
- Navigation structure (sidebar, header)
- Search functionality
- Code examples (copy-paste ready)
- Reference tables

**Typography Rules:**
- Sans-serif (Inter, SF Pro, Segoe UI)
- H1: Page title (32-36px)
- H2: Major sections (24-28px)
- H3: Subsections (20-24px)
- H4: Details (18-20px)
- Body: 16px (scan-optimized)
- Code: 14px (monospace)

**Visual Elements:**
- Navigation: Clear hierarchy
- Code blocks: Line numbers + copy button
- Tables: For API reference (sortable if large)
- Callouts: Info, warning, danger boxes
- Breadcrumbs: For deep hierarchies

**Spacing:**
- Tighter than blog (scan-optimized)
- Section spacing: 48px-64px
- Paragraph spacing: 16px-20px

**Scoring Deductions:**
- Poor navigation: -1.5
- No code copy buttons: -0.5
- Missing search: -1.0
- Tables not used for reference: -0.5

---

### 6. Responsive & Mobile-First

**Rules (Required):**

**Breakpoints (Define Explicitly):**
```
--breakpoint-mobile:  320px - 767px
--breakpoint-tablet:  768px - 1023px
--breakpoint-desktop: 1024px - 1599px
--breakpoint-wide:    1600px+
```

**Mobile-First Approach:**
1. Design for 320px first
2. Scale up with media queries
3. Never assume desktop

**Typography Scaling:**
```
/* Mobile */
H1: 32px
H2: 24px
H3: 20px
Body: 16px

/* Desktop */
H1: 48px
H2: 32px
H3: 24px
Body: 16px
```

**Spacing Scaling:**
- Mobile: Reduce by 25-50%
- Desktop: Full scale
- Example: Section spacing 64px → 32px on mobile

**Touch Targets:**
- Minimum: 44px × 44px (mobile)
- Preferred: 48px × 48px
- Deduction: -1.0 if buttons <44px on mobile

**Violations to Catch:**
```
✗ No responsive specifications
✗ Fixed pixel widths (use %, rem, or max-width)
✗ Touch targets <44px
✗ Mobile font sizes same as desktop
```

**Fixes to Provide:**
```
✓ Define breakpoints explicitly
✓ Provide mobile + desktop type scales
✓ Scale spacing for mobile (32px → 16px)
✓ Touch targets: min 44px × 44px
```

---

### 7. Content Layout & Information Design

**Rules (Zero Tolerance):**

Content layout is not about making things "look nice." It's about **information architecture, scannability, and cognitive load reduction.**

#### Visual Rhythm & Variety

**FORBIDDEN: Monotonous layouts**

Using the same content pattern repeatedly creates visual fatigue and reduces scannability.

**Bad Patterns (Violations):**

```markdown
## Section 1
Lorem ipsum dolor sit amet, consectetur adipiscing elit...

## Section 2
Sed do eiusmod tempor incididunt ut labore et dolore...

## Section 3
Ut enim ad minim veniam, quis nostrud exercitation...

## Section 4
Duis aute irure dolor in reprehenderit in voluptate...
```

**✗ VIOLATION:** Same pattern repeated (heading → prose → heading → prose). No visual variety. Monotonous.
**Deduction:** -1.0 (poor information design)

**Good Pattern (Required):**

```
## Section 1
[Prose introduction]

## Section 2
[Bento card grid with icons]

## Section 3
[Comparison table]

## Section 4
[Prose with inline callout boxes]

## Section 5
[Step-by-step numbered cards]
```

**✓ CORRECT:** Mixed presentation styles. Visual variety maintains engagement.

---

#### Information Density Rules

**Match presentation to information type. Different content demands different layouts.**

| Content Type | Required Layout | FORBIDDEN Layout | Deduction if Wrong |
|--------------|-----------------|------------------|-------------------|
| **Feature list (3-6 items)** | Bento cards or icon grid | Bullet list, prose | -1.0 |
| **Detailed comparison** | Table with clear columns | Prose description, bullets | -1.0 |
| **Step-by-step process** | Numbered cards or timeline | Wall of text, nested bullets | -1.0 |
| **Technical reference** | Table or definition list | Prose paragraphs | -1.0 |
| **Conceptual explanation** | Prose with diagrams | Bullets, table | -0.5 |
| **Quick facts** | Stat cards or badge grid | Paragraph form | -1.0 |

**Example Violations:**

**✗ Feature list as bullets:**
```markdown
## Features
- Real-time collaboration
- End-to-end encryption
- Cross-platform sync
- Advanced analytics
- Custom workflows
- API access
```

**Why this is WRONG:**
- Boring wall of bullets
- No visual hierarchy within features
- No icons or visual differentiation
- Requires linear reading (not scannable)
- Wastes vertical space

**Deduction:** -1.0 (should use bento cards)

**✓ Feature list as bento cards:**
```jsx
<div className="bento-grid">
  <FeatureCard
    icon={<CollaborationIcon />}
    title="Real-time Collaboration"
    description="Edit together with live cursors and presence"
  />
  <FeatureCard
    icon={<SecurityIcon />}
    title="End-to-End Encryption"
    description="Zero-knowledge architecture. Your data stays yours."
  />
  // ... more cards
</div>
```

**CSS:**
```css
.bento-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: var(--space-6);
  margin-bottom: var(--space-12);
}
```

**Why this is CORRECT:**
- Scannable at a glance
- Visual icons provide instant recognition
- Grid layout uses space efficiently
- Each card is self-contained information unit
- Responsive (auto-wraps on mobile)

---

#### Bullet List Rules (Strict Enforcement)

**Bullets are NOT for everything. Use sparingly.**

**FORBIDDEN Patterns:**

**✗ Long bullets (>1 sentence):**
```markdown
- This is a really long bullet point that goes on and on explaining
  multiple concepts in a single item which makes it hard to scan and
  defeats the entire purpose of using bullets in the first place
```

**Deduction:** -0.5 per long bullet (>20 words)

**✗ Excessive nesting:**
```markdown
- Level 1
  - Level 2
    - Level 3
      - Level 4
        - Level 5 (WHY?)
```

**Maximum depth:** 2 levels
**Deduction:** -1.0 for nesting >2 levels

**✗ Bullet spam (>8 items without grouping):**
```markdown
## Installation Steps
- Step 1
- Step 2
- Step 3
- Step 4
- Step 5
- Step 6
- Step 7
- Step 8
- Step 9
- Step 10
```

**Deduction:** -1.0 (use numbered cards or grouped sections instead)

**CORRECT Bullet Usage:**

```markdown
## Key Benefits

**Performance:**
- 10x faster than alternatives
- Sub-100ms response time
- Handles 10M+ requests/day

**Developer Experience:**
- One-line setup
- TypeScript-first
- Zero config required
```

**Why this is CORRECT:**
- Grouped by category
- Short, scannable items (<10 words)
- No nesting beyond 1 level
- Each bullet is distinct, parallel fact

**Maximum bullets per list:** 8 items
**Maximum bullet length:** 20 words
**Maximum nesting:** 2 levels

---

#### Text Wall Violations

**FORBIDDEN: Long prose blocks without visual breaks**

**✗ Text wall:**
```markdown
## Overview

This is a long paragraph that goes on and on without any visual breaks or
whitespace. It talks about multiple concepts in a single block which makes
it exhausting to read. The reader's eyes glaze over because there's no
visual rhythm or pacing. This continues for another few sentences
discussing even more concepts that should probably be broken up into
separate sections or presented in a different format like cards or tables.
By the time you reach this sentence, you've already lost the reader's
attention because the cognitive load is too high.
```

**Violations:**
- Paragraph >150 words: -1.0
- No visual breaks in >300 words of prose: -1.0
- Discussing multiple concepts in one paragraph: -0.5

**✓ Correct approach:**

```markdown
## Overview

This tool solves three core problems: authentication, rate limiting, and caching.

### Authentication
[Focused paragraph, 75 words max]

### Rate Limiting
[Focused paragraph, 75 words max]

**Or use cards:**
<ConceptCard title="Authentication">
  Handles OAuth, API keys, and JWT out of the box.
</ConceptCard>
```

**Maximum prose block length:** 150 words
**Required:** Visual break every 200 words (heading, card, table, image, callout)

---

#### Good Layout Patterns (Required)

**1. Bento Card Grids**

**Use for:** Features, benefits, stat highlights, product tiers

```jsx
<div className="bento-grid">
  <Card size="large" highlight>
    <Stat value="99.99%" label="Uptime SLA" />
  </Card>
  <Card size="medium">
    <Icon name="shield" />
    <h3>Enterprise Security</h3>
    <p>SOC2, HIPAA, GDPR compliant</p>
  </Card>
  <Card size="medium">
    <Icon name="zap" />
    <h3>Lightning Fast</h3>
    <p>Sub-10ms p99 latency</p>
  </Card>
</div>
```

**CSS Requirements:**
```css
.bento-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: var(--space-6);
  grid-auto-flow: dense; /* Allow size variations */
}

.card-large {
  grid-column: span 2; /* Takes 2 columns */
}

/* Mobile: Single column */
@media (max-width: 767px) {
  .bento-grid {
    grid-template-columns: 1fr;
  }
  .card-large {
    grid-column: span 1;
  }
}
```

**Deduction if missing:** -1.0 (when features/stats presented as bullets)

---

**2. Comparison Tables**

**Use for:** Pricing tiers, feature comparison, technical specs, API parameters

```markdown
| Feature | Free | Pro | Enterprise |
|---------|------|-----|------------|
| Users | 5 | 50 | Unlimited |
| Storage | 10GB | 100GB | Custom |
| Support | Community | Email | 24/7 Phone |
| SLA | - | 99.9% | 99.99% |
```

**Or styled table component:**
```jsx
<ComparisonTable>
  <Column tier="free" highlight={false} />
  <Column tier="pro" highlight={true} />
  <Column tier="enterprise" highlight={false} />
</ComparisonTable>
```

**Required for:** Any content with 3+ comparable items with 3+ attributes

**Deduction if missing:** -1.0 (when comparison written in prose or bullets)

---

**3. Step-by-Step Cards/Timeline**

**Use for:** Installation process, tutorials, workflows, migration guides

```jsx
<StepTimeline>
  <Step number="1" title="Install CLI">
    <CodeBlock>npm install -g tool-name</CodeBlock>
  </Step>
  <Step number="2" title="Initialize Project">
    <CodeBlock>tool-name init</CodeBlock>
  </Step>
  <Step number="3" title="Deploy">
    <CodeBlock>tool-name deploy</CodeBlock>
    <Callout>Your app is live at https://your-app.com</Callout>
  </Step>
</StepTimeline>
```

**CSS:**
```css
.step-timeline {
  display: flex;
  flex-direction: column;
  gap: var(--space-8);
  position: relative;
}

.step-timeline::before {
  content: '';
  position: absolute;
  left: 20px;
  top: 40px;
  bottom: 40px;
  width: 2px;
  background: var(--color-border-default);
}

.step {
  position: relative;
  padding-left: var(--space-16);
}

.step-number {
  position: absolute;
  left: 0;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: var(--color-accent);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
}
```

**Deduction if missing:** -1.0 (when steps presented as numbered bullets)

---

**4. Callout Boxes / Info Panels**

**Use for:** Important notes, warnings, tips, asides

```jsx
<Callout type="info">
  <strong>Note:</strong> This feature requires API version 2.0+
</Callout>

<Callout type="warning">
  <strong>Warning:</strong> This action cannot be undone.
</Callout>

<Callout type="tip">
  <strong>Pro Tip:</strong> Use keyboard shortcut Cmd+K for faster navigation.
</Callout>
```

**CSS:**
```css
.callout {
  padding: var(--space-4);
  border-left: 4px solid;
  border-radius: var(--radius-md);
  margin: var(--space-6) 0;
}

.callout-info {
  border-color: var(--color-info);
  background: var(--color-info-bg);
}

.callout-warning {
  border-color: var(--color-warning);
  background: var(--color-warning-bg);
}
```

**Required:** When prose contains critical information, warnings, or side notes
**Deduction if missing:** -0.5 (when important info buried in prose)

---

**5. Stat Highlights / Badge Grid**

**Use for:** Key metrics, achievements, quick facts

```jsx
<StatGrid>
  <Stat value="10M+" label="API Requests/day" />
  <Stat value="99.99%" label="Uptime" />
  <Stat value="<10ms" label="P99 Latency" />
  <Stat value="150+" label="Countries" />
</StatGrid>
```

**CSS:**
```css
.stat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: var(--space-6);
  margin: var(--space-12) 0;
}

.stat {
  text-align: center;
  padding: var(--space-6);
  background: var(--color-surface-raised);
  border-radius: var(--radius-md);
}

.stat-value {
  font-size: var(--font-size-display);
  font-weight: 700;
  color: var(--color-accent);
  line-height: 1;
}

.stat-label {
  font-size: var(--font-size-small);
  color: var(--color-text-subdued);
  margin-top: var(--space-2);
}
```

**Deduction if missing:** -1.0 (when stats written as bullets or prose)

---

**6. Mixed Media Sections**

**Use for:** Feature explanations, product showcases

**Pattern:**
```
[Image/Diagram - Left 50%] [Explanation Text - Right 50%]
[Explanation Text - Left 50%] [Image/Diagram - Right 50%]
```

**Alternating layout prevents monotony.**

```jsx
<FeatureSection>
  <Image src="/feature-1.png" position="left" />
  <Content position="right">
    <h3>Real-time Collaboration</h3>
    <p>See changes as they happen with live cursors...</p>
  </Content>
</FeatureSection>

<FeatureSection>
  <Content position="left">
    <h3>End-to-End Encryption</h3>
    <p>Zero-knowledge architecture...</p>
  </Content>
  <Image src="/feature-2.png" position="right" />
</FeatureSection>
```

**Deduction if missing:** -0.5 (when features are text-only without visuals)

---

#### Layout Violation Scoring

**Add to deduction categories:**

**Content Layout Violations:**
- Monotonous pattern (same layout repeated 4+ times): **-1.0**
- Wrong layout for content type (features as bullets): **-1.0**
- Text wall (paragraph >150 words): **-1.0**
- No visual breaks in >300 words prose: **-1.0**
- Bullet spam (>8 items ungruoped): **-1.0**
- Excessive bullet nesting (>2 levels): **-1.0**
- Long bullets (>20 words): **-0.5 per violation**
- Missing callouts for critical info: **-0.5**
- Stats/metrics as prose (not card/badge grid): **-1.0**
- Comparison as prose (not table): **-1.0**
- Steps as bullets (not cards/timeline): **-1.0**
- Features with no visual variety: **-0.5**

---

#### Content Layout Checklist

When reviewing content layout:

- [ ] **Check visual rhythm:** Are different presentation styles used?
- [ ] **Identify content types:** Features, comparisons, steps, stats, concepts?
- [ ] **Match layout to type:** Correct pattern for each content type?
- [ ] **Scan for text walls:** Any paragraphs >150 words? Any >300 word blocks without breaks?
- [ ] **Count bullets:** Any lists >8 items? Any bullets >20 words? Nesting >2 levels?
- [ ] **Look for monotony:** Same pattern repeated 4+ times?
- [ ] **Check for callouts:** Critical info highlighted properly?
- [ ] **Verify tables used:** Comparisons, specs, parameters in table format?
- [ ] **Check step formatting:** Processes use cards/timeline (not bullets)?
- [ ] **Verify stat display:** Metrics use stat cards/badges (not prose)?

---

#### Examples: Good vs Bad Layouts

**BAD: Landing page with monotonous layout**

```markdown
## Fast
Our platform is extremely fast with sub-10ms latency and can handle millions of requests per day without breaking a sweat.

## Secure
Security is our top priority. We use end-to-end encryption, SOC2 compliance, and regular security audits to keep your data safe.

## Scalable
Built to scale from day one. Auto-scaling infrastructure handles traffic spikes automatically without any configuration needed.

## Reliable
99.99% uptime SLA backed by redundant systems across multiple regions with automatic failover and 24/7 monitoring.
```

**Violations:**
- ✗ Same pattern repeated 4 times (heading → prose block)
- ✗ Features should be bento cards, not prose
- ✗ Stats buried in prose ("sub-10ms", "99.99%") should be stat cards
- ✗ No visual variety
- ✗ Boring, hard to scan

**Deductions:** -1.0 (monotony) + -1.0 (wrong layout for features) + -1.0 (stats as prose) = **-3.0**

---

**GOOD: Same content with proper layout**

```jsx
{/* Hero stat badges */}
<StatGrid>
  <Stat value="<10ms" label="Latency" />
  <Stat value="99.99%" label="Uptime SLA" />
  <Stat value="10M+" label="Requests/day" />
</StatGrid>

{/* Bento card grid */}
<BentoGrid>
  <Card size="large" highlight>
    <Icon name="zap" size="xl" />
    <h3>Lightning Fast</h3>
    <p>Sub-10ms p99 latency. Handles millions of requests/day.</p>
    <Link>See performance benchmarks →</Link>
  </Card>

  <Card>
    <Icon name="shield" />
    <h3>Enterprise Security</h3>
    <p>SOC2, end-to-end encryption, regular audits.</p>
  </Card>

  <Card>
    <Icon name="trending-up" />
    <h3>Auto-Scaling</h3>
    <p>Handle traffic spikes without configuration.</p>
  </Card>

  <Card>
    <Icon name="check-circle" />
    <h3>99.99% Uptime</h3>
    <p>Redundant systems, automatic failover, 24/7 monitoring.</p>
  </Card>
</BentoGrid>
```

**Why this is CORRECT:**
- ✓ Stats displayed as stat cards (scannable at a glance)
- ✓ Features use bento grid with icons (visual variety)
- ✓ Mixed card sizes create visual interest
- ✓ Each card is self-contained information unit
- ✓ Responsive and scannable

---

**BAD: Documentation with wrong layouts**

```markdown
## API Reference

The sendMessage function sends a message to a user. It takes three parameters: userId which is the ID of the user to send to, message which is the text content, and options which is an optional object that can contain priority (high/normal/low) and timestamp settings.

The getUser function retrieves user information. It requires a userId parameter and returns an object containing name, email, created date, and status. You can optionally pass includeHistory to get the user's activity log.
```

**Violations:**
- ✗ API reference in prose form (should be table or definition list)
- ✗ Text wall (>150 words continuous prose)
- ✗ Parameters buried in prose (should be parameter table)
- ✗ Hard to scan for quick reference

**Deductions:** -1.0 (wrong layout for API reference) + -1.0 (text wall) = **-2.0**

---

**GOOD: Same API reference with proper layout**

```markdown
## API Reference

### sendMessage()

Sends a message to a user.

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| userId | string | Yes | ID of the user to send to |
| message | string | Yes | Text content of the message |
| options | object | No | Optional configuration |
| options.priority | enum | No | Message priority: `high`, `normal`, `low` |
| options.timestamp | number | No | Custom timestamp (Unix epoch) |

#### Returns

`Promise<MessageResponse>` - Contains message ID and delivery status

---

### getUser()

Retrieves user information.

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| userId | string | Yes | User ID to retrieve |
| includeHistory | boolean | No | Include activity log (default: false) |

#### Returns

`Promise<User>` - User object with name, email, created date, status
```

**Why this is CORRECT:**
- ✓ Table format for parameters (scannable)
- ✓ Clear structure (function name → description → parameters → returns)
- ✓ Type information visible at a glance
- ✓ No prose walls
- ✓ Easy to reference while coding

---

## Summary: Content Layout Philosophy

**Content layout is information architecture.**

- Match presentation to content type
- Use visual variety (no monotonous patterns)
- Break up text walls with mixed media
- Use tables for comparisons and references
- Use cards for features, benefits, stats
- Use callouts for important asides
- Limit bullets (max 8 items, max 20 words each)
- No nesting >2 levels

**Zero tolerance for:**
- Same layout pattern repeated 4+ times
- Features/stats as bullets or prose (use cards)
- Comparisons as prose (use tables)
- Text walls >150 words without breaks
- Bullet spam (>8 items ungrooped)
- API reference in prose form

**This is not decoration. This is information design engineering.**

---

## Scoring Methodology

**Use systematic deductions. No subjective scores.**

### Starting Score: 10.0

### Deduction Categories

**Typography Violations:**
- H5/H6 usage: **-1.0** (architectural violation)
- Each heading hierarchy violation: **-0.5**
- Arbitrary font size (17px, 19px): **-0.5 each**
- Missing or arbitrary line-height: **-0.5 each**
- Missing letter-spacing (display text): **-0.5**

**Spacing Violations:**
- No spacing system defined: **-1.5**
- Each arbitrary spacing value: **-0.5**
- Inconsistent spacing: **-1.0**

**Color Violations:**
- Contrast ratio fails WCAG: **-1.5 per violation**
- No color system documented: **-1.0**

**Information Architecture:**
- Illogical structure (Installation nested wrong): **-1.0**
- Missing critical sections: **-0.5 each**
- No clear value proposition: **-0.5**

**Responsive:**
- No mobile specifications: **-1.0**
- Touch targets too small: **-1.0**
- No breakpoint definitions: **-0.5**

**Context-Specific:**
- README: Missing badges **-0.5**, no quick start **-1.0**
- Blog: No hero image **-1.0**, body text <18px **-0.5**
- Docs: Poor navigation **-1.5**, no search **-1.0**

**Content Layout Violations:**
- Monotonous pattern (same layout repeated 4+ times): **-1.0**
- Wrong layout for content type (features as bullets): **-1.0**
- Text wall (paragraph >150 words): **-1.0**
- No visual breaks in >300 words prose: **-1.0**
- Bullet spam (>8 items ungrouped): **-1.0**
- Excessive bullet nesting (>2 levels): **-1.0**
- Long bullets (>20 words): **-0.5 per violation**
- Missing callouts for critical info: **-0.5**
- Stats/metrics as prose (not card/badge grid): **-1.0**
- Comparison as prose (not table): **-1.0**
- Steps as bullets (not cards/timeline): **-1.0**
- Features with no visual variety: **-0.5**

### Example Scoring

```
Starting score: 10.0

Typography violations:
- Uses H5 and H6: -1.0
- Arbitrary font size (17px): -0.5
- Missing line-height on H2: -0.5

Spacing violations:
- No spacing system: -1.5
- Margin 13px (arbitrary): -0.5
- Padding 5px (arbitrary): -0.5

Information architecture:
- Installation nested under Features: -1.0
- Vague project description: -0.5

README-specific:
- Missing badges: -0.5
- No quick start example: -1.0

Total deductions: -7.5
Final score: 2.5/10

**This is a failing grade. Unacceptable.**
```

---

## Enforcement Tone

**OCD-level obsessive perfectionist.**

### What to Say

**Violations:**
```
✗ "This is 17px. Should be 16px or 20px from system."
✗ "Line height 1.43 is arbitrary. Use 1.4 or 1.5."
✗ "Margin 13px not in grid. Use 12px or 16px."
✗ "H5 usage forbidden. Restructure to max H4 depth."
✗ "This is not a suggestion. This is a requirement."
```

**Not Suggestions, Requirements:**
```
"REQUIRED: Define base grid (4px or 8px)"
"REQUIRED: Type scale must follow system"
"FORBIDDEN: H5/H6 usage"
"FORBIDDEN: Random spacing values"
"FORBIDDEN: Unverified contrast ratios"
```

**Precision Language:**
```
"This spacing is 3px off. Fix it."
"Font size 19px does not exist in scale."
"Contrast ratio 4.2:1 fails WCAG AA (4.5:1 required)."
"Touch target is 42px. Minimum is 44px."
```

### What NOT to Say

**Avoid vague or permissive language:**
```
✗ "Consider improving spacing"
✗ "Maybe add some visual separation"
✗ "This could be better"
✗ "I suggest..."
```

**Instead:**
```
✓ "Spacing must be 16px (--space-4)"
✓ "Add 64px section spacing (--space-16)"
✓ "This violates the system. Fix it."
✓ "Required: Define typography scale"
```

---

## Workflow Checklist

When using this skill, follow this checklist. **Create TodoWrite todos for each item.**

### Review Mode Checklist

- [ ] **Identify context** (README / blog / docs / UI)
- [ ] **Read content thoroughly** (use Read tool)
- [ ] **Detect current system** (or lack thereof)
- [ ] **Typography audit:**
  - [ ] Check heading hierarchy (H1-H4 only)
  - [ ] Verify font sizes against scale
  - [ ] Check line heights (must be specified)
  - [ ] Verify letter spacing (display text)
  - [ ] Measure line lengths (60-75 chars)
- [ ] **Spacing audit:**
  - [ ] Identify base grid (or note absence)
  - [ ] Check all margins/padding values
  - [ ] Flag arbitrary values (17px, 13px, etc.)
- [ ] **Color audit:**
  - [ ] Calculate contrast ratios (use tools)
  - [ ] Verify WCAG compliance
  - [ ] Check color system exists
- [ ] **Responsive audit:**
  - [ ] Check breakpoint definitions
  - [ ] Verify mobile type scale
  - [ ] Check touch target sizes
- [ ] **Context-specific audit:**
  - [ ] README: Badges, quick start, IA
  - [ ] Blog: Hero image, body text size, spacing
  - [ ] Docs: Navigation, search, tables
- [ ] **Content layout audit:**
  - [ ] Check visual rhythm (different presentation styles used?)
  - [ ] Identify content types (features, comparisons, steps, stats)
  - [ ] Match layout to type (correct pattern for each?)
  - [ ] Scan for text walls (paragraphs >150 words? >300 word blocks?)
  - [ ] Count bullets (lists >8 items? bullets >20 words? nesting >2?)
  - [ ] Look for monotony (same pattern repeated 4+ times?)
  - [ ] Check for callouts (critical info highlighted?)
  - [ ] Verify tables used (comparisons, specs, parameters in tables?)
  - [ ] Check step formatting (processes use cards/timeline, not bullets?)
  - [ ] Verify stat display (metrics use stat cards/badges, not prose?)
- [ ] **Calculate score** (systematic deductions)
- [ ] **List violations** (with exact values)
- [ ] **Provide fixes** (with system values)

### Guidance Mode Checklist

- [ ] **Understand constraints** (markdown / CSS / framework)
- [ ] **Define base grid** (4px or 8px)
- [ ] **Create typography scale:**
  - [ ] Heading sizes (H1-H4)
  - [ ] Body text size
  - [ ] Small text size
  - [ ] Line heights (tight, base, loose)
  - [ ] Letter spacing (display, body, small)
- [ ] **Create spacing scale:**
  - [ ] Section spacing
  - [ ] Paragraph spacing
  - [ ] Element padding
  - [ ] Inline spacing
- [ ] **Define color system:**
  - [ ] Primary, subdued, accent colors
  - [ ] Calculate contrast ratios
  - [ ] Verify WCAG compliance
- [ ] **Define responsive scales:**
  - [ ] Mobile typography
  - [ ] Mobile spacing
  - [ ] Breakpoints
  - [ ] Touch targets
- [ ] **Document tokens** (CSS variables or constants)
- [ ] **Create usage guidelines**
- [ ] **Provide examples** (correct usage)

---

## Example Reviews

### Example 1: README Review

**Content:** Simple library README with poor hierarchy

**Review:**
```
## Design Review: MyProject README
**Context:** GitHub README (markdown constraints)
**Score: 2.5/10** (failing grade)

### Violations Found (Zero Tolerance)

**Typography (5 violations = -3.0):**
✗ Uses H5 for `doThing()` (max depth H4) → -1.0
✗ Uses H6 for `Parameters` (forbidden) → already counted
✗ Heading hierarchy jumps (H2 → H3 → H4 → H2 → H5 → H6) → -0.5
✗ No line heights specified → -0.5
✗ Installation (H3) nested under Features - should be H2 → -1.0

**Spacing (3 violations = -2.5):**
✗ No spacing system defined → -1.5
✗ Arbitrary spacing between sections → -0.5
✗ No visual rhythm → -0.5

**Information Architecture (3 violations = -2.0):**
✗ Installation nested under Features (illogical) → -1.0
✗ Vague description ("does things") → -0.5
✗ No quick start example → -1.0

**README-Specific (2 violations = -1.0):**
✗ Missing badges (version, build, license) → -0.5
✗ No value proposition → -0.5

**Responsive:**
✓ Markdown adapts naturally (no violations)

**Total Deductions:** -7.5
**Final Score:** 10.0 - 7.5 = 2.5/10

**This is failing. Unacceptable.**

### Required Fixes

**1. Fix Heading Hierarchy (REQUIRED):**
```markdown
# MyProject
## Installation
## Usage
### Basic Example
### Advanced Usage
## API Reference
### doThing()
#### Parameters
## Examples
## License
```

**2. Define Typography System (REQUIRED):**
- H1: 48px (GitHub default, line-height 1.2)
- H2: 32px (line-height 1.2)
- H3: 24px (line-height 1.2)
- H4: 20px (line-height 1.2)
- Body: 16px (line-height 1.6)
- Code: 14px (line-height 1.4)

**3. Add Spacing System (REQUIRED):**
- Section spacing: 64px (use `<br>` or `---` in markdown)
- Paragraph spacing: 16px (natural markdown)
- List item spacing: 8px (natural markdown)

**4. Fix Information Architecture (REQUIRED):**
- Restructure: Title → Description → Features → Quick Start → Installation → Usage → API → Examples → License
- Write specific description (not "does things")
- Add quick start with working code example

**5. Add README Elements (REQUIRED):**
- Badges: npm version, build status, license
- Tables: For API parameters
- Code blocks: Specify language for syntax highlighting

**After fixes, expected score: 8.5-9.0/10**
```

---

## Summary

**This skill is not about making things "prettier."**

This skill is about **engineering discipline in design.**

- Every value derives from a system
- Every spacing follows a grid
- Every size comes from a scale
- Every color has verified contrast
- Every violation gets caught
- Zero tolerance for arbitrary values

**Tone: OCD-level obsessive perfectionist.**
- "This is 3px. Should be 4px."
- "Line height 1.43 is arbitrary. Use 1.4 or 1.5."
- "This is not a suggestion. This is a requirement."

**Use this skill to hold design to the same rigor as code.**

No exceptions.
