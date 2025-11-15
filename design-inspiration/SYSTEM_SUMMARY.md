# Complete Design Inspiration & Visual QA System

**Last Updated:** 2025-10-21

---

## Overview

This is a complete system for:
1. **Discovering** design inspiration from curated collections
2. **Building** a global visual library with screenshots
3. **Analyzing** beautiful design with vision to extract aesthetic principles
4. **Applying** those principles to your work
5. **Validating** implementations with visual QA before shipping

**Global Location:** `~/.claude/design-inspiration/`

---

## The Three Commands

### 1. `/discover [project description]`

**Purpose:** Hunt for NEW design examples relevant to your project.

**What it does:**
1. Reads COLLECTIONS.md to find relevant galleries
2. Uses chrome-devtools MCP or Chrome headless to browse sites
3. Takes viewport screenshots (1440x900)
4. Saves to global inspiration gallery
5. Analyzes with vision to extract aesthetic principles
6. Creates discovery report

**Example:**
```
/discover dense information page with data tables
```

**Output:**
- Screenshots saved to appropriate category folders
- Vision analysis of aesthetic sophistication
- Extracted design principles
- Discovery report

---

### 2. `/inspire [category]`

**Purpose:** Analyze EXISTING screenshots in your gallery to build taste.

**What it does:**
1. Lists all screenshots in specified category (or all)
2. Reads each screenshot with vision analysis
3. Extracts what makes them beautiful and sophisticated
4. Identifies common aesthetic patterns
5. Applies those principles to current work

**Example:**
```
/inspire protocols
/inspire landing
/inspire  (all categories)
```

**Output:**
- Visual analysis of each example
- Aesthetic principles extracted
- Guidance for applying to your work

---

### 3. `/visual-review [page-url]`

**Purpose:** Visual QA of your implementation before shipping.

**What it does:**
1. Screenshots your implemented design (Chrome headless)
2. Analyzes with vision
3. Checks against AESTHETIC_PRINCIPLES.md
4. Compares to design system standards
5. Compares to inspiration gallery examples
6. Creates detailed QA report with violations
7. Recommends: APPROVED / NEEDS FIXES / REDESIGN

**Example:**
```
/visual-review http://localhost:8080/protocols/injury
```

**Output:**
- Screenshot of implementation
- Visual QA checklist results
- Specific violations with fixes needed
- Approval status

---

## The Gallery Structure

```
~/.claude/design-inspiration/
├── landing/               # 10 screenshots
│   ├── vaayu.png
│   ├── moheim.png
│   ├── deepjudge.png
│   ├── fey.png
│   ├── endex.png
│   ├── apple.png
│   ├── openweb.png
│   ├── area17.png
│   ├── linear.png
│   └── notion.png
├── protocols/             # 6 screenshots (elegant information design)
│   ├── pudding-data-story.png         # Visual data journalism
│   ├── distill-ml-concepts.png        # Interactive ML explanations
│   ├── ncase-interactive-explainer.png # Playful game theory explainer
│   ├── bartosz-gps-explainer.png      # Physics with 3D interactivity
│   ├── openai-research.png            # Complex AI concepts
│   └── stripe-press-technical.png     # Technical topics elegantly
├── components/            # 4 screenshots
│   ├── figma-pricing.png
│   ├── chakra-ui.png
│   ├── airtable.png
│   └── intercom.png
├── typography/            # 2 screenshots
│   ├── fontshare.png
│   └── google-fonts.png
├── interactions/          # (empty, ready for future)
├── COLLECTIONS.md         # Curated design galleries
├── AESTHETIC_PRINCIPLES.md # 10 core sophistication principles
├── README.md              # This guide
└── SYSTEM_SUMMARY.md      # This file
```

**Total:** 22 curated screenshots across 4 categories

**Note on "protocols" category:**
NOT technical documentation (API references, docs sites). These are examples of **elegant information design** - complex topics explained in visually stunning, digestible, UX-friendly ways. Think: visual data journalism, interactive explainers, playful learning experiences.

---

## Reference Documents

### COLLECTIONS.md (36k)

Curated design galleries to browse:

**Aspirational Excellence:**
- Vaayu, MOHEIM, DeepJudge, Fey, Endex (sophistication examples)

**Design Collections:**
- Awwwards (Black & White collection)
- AREA 17, SEESAW, CSS Design Awards, SiteInspire, Bento Grids

**UX Excellence:**
- Apple, OpenWeb

**Mobile:**
- Mobbin, Page Flows, Cosmos, Handheld Design, Website Vice

### AESTHETIC_PRINCIPLES.md (12k)

10 core principles for sophisticated design:

1. **Restraint as Sophistication** - Design by subtraction
2. **Whitespace as Luxury** - Intentional allocation (48-80px sections)
3. **Typography Dominance** - 2 fonts, 5 sizes, 3 weights max
4. **Material Depth** - Subtle gradients, shadows, blur
5. **Color as Accent** - One accent for <10% of elements
6. **Progressive Disclosure** - Overview first, depth on demand
7. **Interaction as Reward** - 300ms purposeful transitions
8. **Mathematical Grid** - 8px base, systematic rhythm
9. **Decisive Hierarchy** - 4 levels maximum
10. **Performance as Polish** - Fast = premium feel

Each principle includes:
- What the best sites do
- How to apply it
- What to avoid
- Code examples

---

## Integration with Workflows

### Design Request Flow

```
User: "Redesign the protocol page"
  ↓
/concept (studies references, creates brief)
  ↓
User approves concept
  ↓
/enhance (builds implementation)
  ↓
/visual-review (validates before shipping) ← NEW
  ↓
Violations found? → Fix → Re-review
  ↓
✅ APPROVED → Ship
```

### Feedback Iteration Flow

```
User: /agentfeedback "Fix spacing and typography"
  ↓
Agents fix issues
  ↓
code-reviewer-pro approval
  ↓
/visual-review (for design work) ← NEW
  ↓
Check against:
- AESTHETIC_PRINCIPLES.md
- Design system
- Inspiration gallery
- Original feedback
  ↓
✅ PASSES → Present to user
```

---

## Visual Review Checklist

When `/visual-review` runs, it checks:

### Aesthetic Sophistication:
- [ ] Restraint: 30% of elements removed?
- [ ] Whitespace: 48-80px between sections?
- [ ] Typography: 2 fonts, 5 sizes, 3 weights max?
- [ ] Material: Subtle gradients/shadows/blur?
- [ ] Color: Accent for <10% of elements?
- [ ] Hierarchy: Only 4 levels?
- [ ] Spacing: All from 8px grid?
- [ ] Interactions: 300ms transitions?

### Design System:
- [ ] Only authorized fonts?
- [ ] Only authorized weights (not 300)?
- [ ] Only design system color tokens?
- [ ] Following mathematical spacing?

### Comparison:
- [ ] As sophisticated as inspiration examples?
- [ ] Same level of restraint?
- [ ] Comparable spacing generosity?
- [ ] Similar premium feel?

---

## Utility Scripts

### populate-gallery.sh

```bash
~/.claude/scripts/populate-gallery.sh
```

Systematically screenshots curated sites and saves to inspiration gallery.

**Usage:**
- Run manually to refresh gallery
- Add new sites to script
- Already populated with 20 sites

### screenshot-site.sh

```bash
~/.claude/scripts/screenshot-site.sh <url> <category> <name>
```

Screenshot a single site and save to gallery.

**Example:**
```bash
~/.claude/scripts/screenshot-site.sh "https://stripe.com" "landing" "stripe"
```

---

## How Chrome Headless Screenshotting Works

All visual browsing uses Chrome headless:

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

"$CHROME" --headless --disable-gpu \
  --screenshot="/path/to/output.png" \
  --window-size=1440,900 \
  --hide-scrollbars \
  --virtual-time-budget=5000 \
  "https://example.com"
```

**Key parameters:**
- `--window-size=1440,900` - Consistent viewport
- `--hide-scrollbars` - Clean screenshots
- `--virtual-time-budget=5000` - Wait for page load
- Viewport only (not fullPage) - Avoids timeouts

---

## When to Use Each Command

### Use `/discover` when:
- Starting a new design project
- Need examples for specific patterns
- Looking for industry-specific inspiration
- Want to see current design trends
- Building your visual library

### Use `/inspire` when:
- About to design something
- Need to understand aesthetic sophistication
- Want to build taste before creating
- Studying what makes design beautiful
- Comparing your work to excellence

### Use `/visual-review` when:
- Finished implementing design
- After fixing design feedback
- Before presenting to user
- After code-reviewer-pro approval
- Whenever UI/UX work is "done"

**Rule:** NEVER ship UI work without `/visual-review`

---

## Expected Outcomes

### After `/discover`:
- 5-10 new screenshots in gallery
- Vision analysis of aesthetic sophistication
- Extracted design principles
- Discovery report document
- Populated inspiration library

### After `/inspire`:
- Understanding of what makes design beautiful
- Extracted aesthetic patterns
- Principles to apply to your work
- Comparison framework for quality
- Elevated taste

### After `/visual-review`:
- Screenshot of implementation
- Detailed QA report
- List of specific violations
- Priority fixes needed
- Approval status: ✅ / ⚠️ / ❌

---

## The Philosophy

> "What you withhold often matters more than what you display." - Apple

**Key insights:**

1. **Restraint creates sophistication** - Remove 30% of planned elements
2. **Whitespace is allocated, not leftover** - 48-80px between sections
3. **Typography carries the design** - 2 fonts, 5 sizes, 3 weights
4. **One accent color** - Used for <10% of elements
5. **Progressive disclosure** - Don't show everything at once
6. **4 hierarchy levels maximum** - More = chaos
7. **300ms transitions** - Deliberate, not instant
8. **8px grid** - Mathematical rhythm
9. **Vision analysis is mandatory** - Don't trust "looks good"
10. **Compare to excellence** - Gallery sets the bar

---

## Common Anti-Patterns Prevented

### Before This System:
❌ "I didn't look at references before designing"
❌ "I just built something generic"
❌ "I thought it looked good" (without visual check)
❌ "Spacing is arbitrary" (12px, 17px, 23px...)
❌ "Using 7 font sizes for hierarchy"
❌ "Bright accent colors everywhere"
❌ "Showing everything at once"
❌ "No comparison to excellent examples"

### After This System:
✅ `/discover` finds relevant examples automatically
✅ `/inspire` analyzes sophistication before designing
✅ `/visual-review` validates with vision before shipping
✅ 8px mathematical grid enforced
✅ 2 fonts, 5 sizes, 3 weights maximum
✅ One accent color, <10% usage
✅ Progressive disclosure enforced
✅ Constant comparison to curated excellence

---

## Maintenance

### Adding New Collections:
1. Edit `COLLECTIONS.md`
2. Add URL and description
3. Categorize by type
4. Document when to use

### Adding New Screenshots:
**Method 1 - Automated:**
```bash
~/.claude/scripts/screenshot-site.sh <url> <category> <name>
```

**Method 2 - Manual:**
1. Take screenshot (1440x900)
2. Save to `~/.claude/design-inspiration/[category]/[name].png`
3. Name descriptively

### Updating Principles:
1. Edit `AESTHETIC_PRINCIPLES.md`
2. Add new insights from design analysis
3. Update examples and code snippets
4. Keep aligned with latest sophistication trends

---

## Troubleshooting

### Screenshots failing?
- Check Chrome path: `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`
- Reduce timeout if site is slow
- Use viewport screenshots (not fullPage)

### /discover not working?
- Check `COLLECTIONS.md` exists
- Verify Chrome headless accessible
- Check category folders exist

### /inspire shows no screenshots?
- Run `populate-gallery.sh` to populate
- Check category name matches folder
- Verify screenshots are .png format

### /visual-review not analyzing?
- Check dev server running (localhost:8080)
- Verify screenshot captured successfully
- Check Read tool can access PNG files

---

## Success Metrics

**Gallery Population:**
- ✅ 22 screenshots across 4 categories
- ✅ All Aspirational Excellence sites captured
- ✅ Elegant information design examples (NOT technical docs)
- ✅ Component and typography samples ready

**System Integration:**
- ✅ `/discover` command configured
- ✅ `/inspire` command configured
- ✅ `/visual-review` command created
- ✅ Integrated into `/agentfeedback`
- ✅ Integrated into `/concept`
- ✅ AESTHETIC_PRINCIPLES.md documented
- ✅ COLLECTIONS.md curated

**Workflow Coverage:**
- ✅ Design requests include visual review
- ✅ Feedback iterations include visual QA
- ✅ No UI ships without visual validation
- ✅ Inspiration library available globally
- ✅ Aesthetic standards documented

---

## The Complete Flow

```
1. User requests design work
      ↓
2. /discover finds relevant examples → Saves to gallery
      ↓
3. /inspire analyzes aesthetics → Builds taste
      ↓
4. Agent implements design
      ↓
5. code-reviewer-pro validates code
      ↓
6. /visual-review validates aesthetics ← CRITICAL
      ↓
7. If violations found → Fix → Re-review (loop)
      ↓
8. ✅ APPROVED → Ship to user
```

**Every step uses vision analysis. Nothing is "trusted to look good."**

---

**This system ensures every design decision is:**
- Informed by excellence (inspiration gallery)
- Guided by principles (AESTHETIC_PRINCIPLES.md)
- Validated visually (vision analysis)
- Compared to standards (visual review)
- Sophisticated through restraint (design by subtraction)

**Result:** Consistently beautiful, elegant, sophisticated UI.

---

**Last Updated:** 2025-10-21
**Status:** ✅ Complete and operational
**Gallery Size:** 22 screenshots (protocols category updated with elegant information design)
**Commands:** 3 (/discover, /inspire, /visual-review)
**Documentation:** 4 files (COLLECTIONS, PRINCIPLES, README, SUMMARY)
