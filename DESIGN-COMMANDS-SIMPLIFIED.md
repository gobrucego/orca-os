# Simplified Design Command System

**Date:** 2025-10-21
**Status:** Simplified and Clarified

---

## Quick Reference

### `/inspire` - Three Clear Sources + Auto Mode

```bash
# Your global taste folder (default)
/inspire
/inspire --taste

# Custom folder
/inspire --folder ~/Desktop/design-refs/

# Search by tags
/inspire --tag dashboard,premium

# Auto mode (fast, no interaction)
/inspire --taste --auto
/inspire --folder ~/Desktop/refs/ --auto
/inspire --tag dashboard --auto
```

**What it does:**
- Loads screenshots from specified source
- Vision analysis
- Extracts aesthetic principles
- No more confusing filters!

**Auto mode:**
- ⚡ Fast analysis, principles only
- ⚡ No user interaction or questions
- ⚡ Perfect for idea dumps, creative blocks
- ⚡ Outputs: 5 core principles + what to do + what to avoid

---

### `/design` - With Management

```bash
# Regular design work
/design "landing page hero"

# Management commands
/design --list                    # List all saved briefs
/design --clear                   # Clear all briefs (with confirmation)
/design --remove landing-hero     # Remove specific brief (with confirmation)
```

**What it does:**
- Pre-flight: Design system + flexibility + optional /inspire
- Main: Your refs + vision + clarifying questions
- Output: Actionable design brief
- Saves to: `docs/design-briefs/[name]-[date].md`

**Management:**
- List all saved briefs
- Clear all with confirmation
- Remove specific brief with confirmation

---

### `/save-inspiration` - Unchanged

```bash
# Save with description
/save-inspiration "This shows good spacing"
*paste image*
```

**What it does:**
- Vision analysis → Extract principles
- Categorize + Tag
- Save image + metadata + INDEX.json
- Available for `/inspire --tag` searches

---

## The Simplified Flow

### 1. Build Your Library

```bash
# Save examples you like
/save-inspiration "engaging dashboard UI"
/save-inspiration "minimal navigation"
/save-inspiration "generous whitespace"

# Each saves:
# - Image: ~/.claude/design-inspiration/[category]/[name].png
# - Metadata: ~/.claude/design-inspiration/[category]/[name].json
# - Updates: ~/.claude/design-inspiration/INDEX.json
```

---

### 2. Review Your Taste

```bash
# Global taste folder
/inspire
/inspire --taste

# Custom folder
/inspire --folder ~/Desktop/my-refs/

# Search by tags
/inspire --tag dashboard
/inspire --tag premium,minimal
```

**No more:**
- ~~`/inspire components`~~
- ~~`/inspire --recent`~~
- ~~`/inspire --saved`~~

**Just three simple options:**
- `--taste` (default)
- `--folder [path]`
- `--tag [tags]`

---

### 3. Design With Your Refs

```bash
# Start new design
/design "dashboard app"

# Agent auto-searches your library
# Offers saved examples if found
# Conversational brainstorming
# Generates brief

# Later: manage briefs
/design --list
/design --remove old-dashboard-brief
/design --clear
```

---

## Key Simplifications

### Before (Confusing):
```bash
# Too many overlapping options
/inspire components
/inspire --tags engaging,minimal
/inspire --recent
/inspire --saved
/inspire navigation
```

### After (Clear):
```bash
# Three explicit sources
/inspire --taste              # Your taste folder
/inspire --folder [path]      # Custom folder
/inspire --tag [tags]         # Tag search
```

---

### Before (No Management):
```bash
# No way to manage saved briefs
# Had to manually delete files
# No list command
```

### After (Full Management):
```bash
/design --list                # See all briefs
/design --remove [name]       # Remove one (with confirmation)
/design --clear               # Remove all (with confirmation)
```

---

## File Locations

```
~/.claude/design-inspiration/           ← Your taste folder
├── INDEX.json                          ← Searchable index
├── components/
│   ├── dashboard-ui.png
│   └── dashboard-ui.json              ← Metadata with tags
├── navigation/
└── [other categories]/

docs/design-briefs/                     ← Saved design briefs
├── landing-hero-20251021.md
├── dashboard-ui-20251020.md
└── [other briefs]/
```

---

## Usage Examples

### Example 1: Build and Search Library

```bash
# Save a dashboard example
User: *pastes dashboard screenshot*
"This is an example of engaging UI"

/save-inspiration
  Category: components ✅
  Tags: engaging, dashboard, UI ✅
  Saved ✅

# Later: find it
/inspire --tag dashboard
  Found: components/dashboard-ui.png ✅
  Vision analysis + saved principles ✅
```

---

### Example 2: Use Custom Folder

```bash
# You have refs in ~/Desktop/landing-refs/
/inspire --folder ~/Desktop/landing-refs/

# Loads all PNGs from that folder
# Vision analysis
# Extracts principles
# No need to save to taste folder
```

---

### Example 3: Manage Design Briefs

```bash
# Create some briefs
/design "landing hero" → Saved to docs/design-briefs/landing-hero-20251021.md
/design "dashboard" → Saved to docs/design-briefs/dashboard-20251020.md

# List them
/design --list
  📄 landing-hero-20251021.md
  📄 dashboard-20251020.md

# Remove one
/design --remove dashboard-20251020.md
  Confirm? Yes
  ✅ Removed

# Clear all
/design --clear
  Delete 1 brief? Yes
  ✅ All cleared
```

---

### Example 4: Auto Mode (Fast Idea Dump)

```bash
# Hit a creative wall, need quick inspiration
/inspire --folder ~/Desktop/refs/ --auto

⚡ INSPIRE AUTO - QUICK PRINCIPLES

Source: folder
Analyzed: 8 examples
💾 Cached folder path for /design to use

CORE PRINCIPLES:
1. Generous whitespace creates breathing room (80px+ sections)
2. Single focal point per screen (one hero element)
3. Color used sparingly for emphasis only
4. Typography creates hierarchy (3-4 sizes max)
5. Restraint over decoration (minimal effects)

WHAT TO DO:
→ Increase spacing between major sections to 80px+
→ Remove secondary CTAs, keep one primary
→ Limit accent color to <10% of screen

AVOID:
✗ Multiple competing focal points
✗ Decorative gradients or effects
```

**Use auto mode when:**
- Quick idea dump needed
- Hitting creative block
- No time for detailed analysis
- Just want actionable principles

---

### Example 5: /inspire → /design Flow (Cached Refs)

```bash
# Step 1: Quick inspiration analysis
/inspire --folder ~/Desktop/calc-refs/ --auto

⚡ INSPIRE AUTO - QUICK PRINCIPLES
Source: folder
Analyzed: 5 examples
💾 Cached folder path for /design to use

CORE PRINCIPLES:
1. Color coding creates hierarchy
2. Generous button spacing (16px+)
3. Large touch targets (60x60px)
...

# Step 2: Start design work (within 30 minutes)
/design "dashboard app"

🔍 DETECTED RECENT /inspire SESSION

You recently analyzed: ~/Desktop/calc-refs/
Found: 5 screenshots
Time: 3 minutes ago

Where are your design references?
  → "Use recent /inspire folder" ✅  ← Auto-offered!
  → "Folder path"
  → "Paste into Claude Code"
  → "URLs"

User selects: "Use recent /inspire folder"

✅ Using cached folder from /inspire
Path: ~/Desktop/calc-refs/
Found: 5 screenshots

[Proceeds with conversational brainstorming using those refs]
```

**How it works:**
- `/inspire --folder` saves folder path to cache
- Cache lasts 30 minutes
- `/design` detects cache and auto-offers it
- One-click to use the same refs
- No need to specify path twice!

---

## Summary

**Simplified `/inspire`:**
- Three clear sources: `--taste`, `--folder`, `--tag`
- Auto mode: `--auto` for fast, no-interaction analysis
- Caches folder path for `/design` integration
- No more confusing category vs tag vs recent filters
- Explicit about where you're loading from

**Enhanced `/design`:**
- Auto-detects recent `/inspire --folder` (30 min cache)
- Offers cached folder as first option
- Added `--list` to see saved briefs
- Added `--clear` to remove all (with confirmation)
- Added `--remove [name]` to remove one (with confirmation)
- Better brief management

**Integrated Workflow:**
```
/inspire --folder ~/refs/ --auto  → Analyze + cache
/design "dashboard"               → Auto-offers cached folder ✅
```

**Result:**
- Clearer mental model
- Seamless inspire → design flow
- No need to specify path twice
- Easier to remember commands
- Better file management
- Less confusion about sources
