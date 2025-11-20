---
name: mm-comps
description: >
  Marina Moscone competitor-dossier skill. Guides structured competitor research
  for the MM minisite: prices, lookbooks, e‑comm visuals, press/story arcs, and
  positioning synthesis. Use when running /mm-comps or doing MM competitor work.
license: internal
allowed-tools:
  - Read
  - WebSearch
  - WebFetch
metadata:
  project: "marina-moscone-minisite"
  os2_domain: "brand"
---

# MM Comps – Marina Moscone Competitor Dossiers Skill

This skill encodes the **competitor analysis playbook** used by the Marina
Moscone minisite. It is designed to pair with the `/mm-comps` command and the
`competitive-analyst` agent.

Use it to create **per-brand dossiers** and a master synthesis that respect the
MM brand lens and evidence standards.

---

## 1. When to Use

Load this skill when:
- Running `/mm-comps` for Marina Moscone.
- Performing structured competitor research for the MM minisite.
- Building or updating competitor dossiers (prices, visuals, story arcs).

Do not use it generically for non-MM brands; it assumes MM-specific strategy,
voice, and goals.

---

## 2. Dossier Components (Per Competitor)

For each competitor (e.g., Khaite, Toteme, The Row, Atlein, Bevza, Interior,
Cecilie Bahnsen, Anna Quan), aim to produce:

- **Prices / Ladders**
  - Representative price points in key categories (outerwear, dresses, knitwear,
    tailoring, accessories).
  - A short “price ladder” snapshot:
    - Entry, core, hero, and extreme bands (if present).

- **Editorial Lookbook**
  - Summary of editorial aesthetic:
    - Pose, expression, composition, motion.
    - Lighting and color language.
    - Casting vibe (age, diversity, attitude).

- **E‑comm Visuals**
  - PDP and listing conventions:
    - Number and type of images.
    - Shooting angles, zoom/detail shots.
    - Use of motion (video, GIF).
    - On-model vs flat-lay vs still-life.

- **Press & Reviews**
  - Key quotes and summaries from:
    - Vogue Runway shows and reviews.
    - WWD, BoF, and similar fashion press.
  - Themes: silhouette evolution, fabric/textile signatures, references, critical
    reception, commercial reception.

- **Timeline / Story Arc**
  - Dated milestones and inflection points:
    - Launch, first big stockists, signature items, awards, directional shifts,
      collaborations.
  - A short narrative of how the brand’s story has evolved.

---

## 3. Data Collection Heuristics

Use `WebSearch` and `WebFetch` to collect:

- **Official Sites**
  - “About” pages, brand stories.
  - Lookbooks/campaigns.
  - E‑comm listings for representative categories.

- **Press & Reviews**
  - `site:vogue.com/runway <brand>`
  - `site:wwd.com <brand> review`
  - `site:businessoffashion.com <brand>`
  - Additional: “collection review”, “show review”, “interview”, “profile”.

- **Price Sampling**
  - For each key category:
    - Sample 5–10 products.
    - Record high/low/median where possible.
  - Focus on *current* collections unless explicitly analyzing archive.

Keep notes in a consistent, easy-to-skim format so `/mm-comps` can turn them
into `.orchestration/evidence/competitors/...` files.

---

## 4. Analysis & Synthesis Patterns

### 4.1 Per-Brand Dossiers

When drafting per-brand notes (even before writing files), use:

```markdown
## [Brand]

### Prices / Ladder
- Categories and representative price bands.
- Notable extremes (entry/hero pieces).

### Lookbook Aesthetic
- Poses, expression, pacing.
- Motion vs stillness.
- Color and composition themes.

### E‑comm Visuals
- PDP/listing formats.
- Model vs flat-lay usage.
- Detail/texture treatment.

### Press & Reviews
- Key quotes with dates and sources.
- Repeated themes or descriptions.

### Story Arc
- Timeline of key milestones.
- Inflection points and direction shifts.
```

### 4.2 Master Summary

The master summary should:
- Map competitors on axes that matter to MM:
  - Price (entry → hero).
  - Attitude (inviting vs intimidating).
  - Editorial vs commercial emphasis.
- Identify white-space and overlap.
- Suggest strategic implications for Marina Moscone:
  - Where to push harder.
  - Where to zag vs competitors.
  - Where to avoid getting stuck in the middle.

---

## 5. Integration with Agents & Commands

When `/mm-comps` is invoked:
- The orchestrator should:
  - Use `competitive-analyst` as the main analysis agent.
  - Treat this skill as the **playbook** for what to collect and how to structure
    outputs.

When other agents need MM competitor context:
- They can load this skill to:
  - Understand what evidence already exists.
  - Align their own analysis (e.g. creative strategy, copy) with the same
    competitor framing.

