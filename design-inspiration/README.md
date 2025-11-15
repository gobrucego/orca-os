# Design Inspiration Gallery

**Global location:** `~/.claude/design-inspiration/`

This is a globally accessible inspiration gallery used by `/discover` and `/inspire` commands across all Claude Code sessions.

---

## Structure

```
~/.claude/design-inspiration/
├── landing/          # Landing pages, hero sections
├── protocols/        # Protocol pages, reference sheets, data-dense layouts
├── components/       # UI components, design systems
├── interactions/     # Micro-interactions, animations, UI patterns
├── typography/       # Typography-focused examples
├── COLLECTIONS.md    # Curated design collections to browse
├── AESTHETIC_PRINCIPLES.md  # Core aesthetic sophistication principles
└── README.md        # This file
```

---

## How It Works

### `/discover [project description]`

**Purpose:** Hunt for NEW design examples relevant to your project.

**What it does:**
1. Browses design collections in COLLECTIONS.md
2. Uses chrome-devtools MCP to visually browse sites
3. Takes viewport screenshots of relevant examples
4. Saves screenshots to appropriate category folders
5. Analyzes screenshots with vision
6. Creates discovery report with extracted principles

**Example:**
```
/discover dense information page with data tables and interactive controls
```

### `/inspire [category]`

**Purpose:** Analyze EXISTING screenshots in your gallery to build taste.

**What it does:**
1. Loads screenshots from the specified category (or all categories)
2. Analyzes each screenshot with vision
3. Extracts aesthetic principles and what makes them beautiful
4. Applies that understanding to your current work

**Example:**
```
/inspire protocols
/inspire landing
/inspire  (analyzes all categories)
```

---

## Populating the Gallery

### Method 1: Use /discover (Automated)

Run `/discover` with your project description and it will:
- Browse curated collections
- Screenshot relevant examples
- Save to appropriate folders
- Analyze with vision

### Method 2: Manual Screenshot Addition

1. Find beautiful design examples
2. Take screenshots
3. Save to `~/.claude/design-inspiration/[category]/[sitename].png`
4. Name descriptively (e.g., `vaayu-hero.png`, `stripe-docs-table.png`)

---

## Categories Guide

**landing/** - Use for:
- Hero sections
- Landing page layouts
- Product presentation
- Brand aesthetics

**protocols/** - Use for:
- Reference sheets
- Data-dense layouts
- Protocol pages
- Documentation with tables
- Information architecture

**components/** - Use for:
- UI component examples
- Design system patterns
- Buttons, cards, forms
- Micro-UI elements

**interactions/** - Use for:
- Hover states
- Animations
- Transitions
- Interactive patterns
- State changes

**typography/** - Use for:
- Type-focused layouts
- Font pairing examples
- Typography scales
- Text hierarchy patterns

---

## Reference Documents

### COLLECTIONS.md

Curated list of design galleries to browse:
- **Aspirational Excellence** - Vaayu, MOHEIM, DeepJudge, Fey, Endex
- **Black & White Awwwards** - Sophistication through restraint
- **UX Excellence** - Apple, OpenWeb
- **Discovery Collections** - AREA 17, SEESAW, CSS Design Awards, SiteInspire, Bento Grids
- **Mobile Collections** - Mobbin, Page Flows, Cosmos, Handheld Design, Website Vice

### AESTHETIC_PRINCIPLES.md

Core principles extracted from aspirational design:
1. Restraint as sophistication
2. Whitespace as luxury
3. Typography dominance
4. Material depth
5. Color as accent
6. Progressive disclosure
7. Interaction as reward
8. Mathematical grid
9. Decisive hierarchy
10. Performance as polish

---

## Best Practices

**When browsing:**
- Focus on AESTHETIC sophistication, not just functional patterns
- Look beyond your industry (universal design principles apply everywhere)
- Screenshot viewport, not full page (faster, no timeouts)
- Save with descriptive names

**When analyzing:**
- Use vision analysis, not just text description
- Extract PRINCIPLES, not just copy layouts
- Understand WHY it works, not just WHAT it looks like
- Apply principles thoughtfully to your context

**Remember:**
> "What you withhold often matters more than what you display." - Apple

Design by subtraction, not addition.

---

**Last Updated:** 2025-10-21
