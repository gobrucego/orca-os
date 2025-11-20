---
name: mm-copy
description: >
  Marina Moscone ad-copy skill. Encodes the canonical MM ad-copy framework and
  Performance Voice so agents can generate SKU-level ad copy variants for the
  minisite that feel on-brand and performance-aware.
license: internal
allowed-tools:
  - Read
  - Grep
  - Glob
  - WebFetch
metadata:
  project: "marina-moscone-minisite"
  os2_domain: "marketing"
---

# MM Copy – Marina Moscone Ad Copy Skill

This skill captures the **MM ad-copy framework** and Performance Voice
principles used by the `/mm-copy` command.

Use it when:
- Generating ad copy variants for MM SKUs.
- Reviewing or refining existing MM ad copy.
- Designing new copy experiments for performance channels.

---

## 1. Canonical Inputs

This skill assumes the following MM-specific sources exist in the minisite:

- Ad copy framework:
  - `minisite/data/meta-api/ad-copy/mm-ad-copy-framework.md`
- Brand voice & design DNA:
  - `minisite/MM-VOICE.md` (especially **Performance Voice**)
  - `minisite/design-dna/design-system-v3.0.md`
  - `minisite/creative-strategist.md`
  - WebFetch: `https://www.marinamoscone.com/pages/about`
- Supporting evidence (analysis; read-only for context):
  - `minisite/data/meta-api/ad-copy/ad-copy-analysis-comprehensive.md`
  - `minisite/data/meta-api/ad-copy/ad-copy-comparison-quick-ref.md`
  - `minisite/data/meta-api/ad-copy/mm-copy-creative-analysis.md`
  - `minisite/data/project.ads-analysis/data-files/EXECUTIVE_SUMMARY.md`
  - `minisite/data/project.ads-analysis/ads-strategy/meta_ads_strategy.md`

Before heavy work, skim:
- The ad-copy framework.
- Performance Voice section of `MM-VOICE.md`.
- A sample of IG captions (for rhythm/tone).

---

## 2. Core Copy Framework

From the MM ad-copy framework, keep this distilled checklist:

- **Hooks**
  - Lead with **emotion, rotation, armor, or uniform**:
    - How this piece makes her feel.
    - Where and how it slots into her wardrobe (rotation).
  - Only then move to **craft + behavior + benefit**:
    - What it’s made of.
    - How it moves or behaves.
    - What it enables her to do or feel.

- **Winning Patterns**
  - `[Craft+Benefit]` – Concrete material / construction details tied directly
    to real-world benefits.
  - `[Editorial Quote]` – When a relevant press quote exists, paired with a
    short line tying it to everyday wear.
  - `[Occasion Hook]` – Occasion-first open (wedding, city winter, resort)
    then craft and behavior.
  - `[Situational Luxury]` / `[Retargeting]` – For retargeting, tie back to how
    this piece solves a specific moment or “wardrobe problem”.

- **Anti-Patterns**
  - Generic “artful luxury” adjectives with no proof.
  - Slogans in place of copy.
  - Self-referential philosophy that never gets to what the piece does for her.
  - Fabric dumps with no context or behavior (just lists of fibers).
  - Long, meandering sentences that bury the hook.

---

## 3. Per-SKU Copy Generation Pattern

When asked to generate or review copy per SKU:

1. **Context**
   - Determine:
     - Category (coat, dress, knit, etc.).
     - Season / collection.
     - Price band.
     - Primary occasions (wedding, city winter, work, travel, etc.).

2. **Pattern Selection**
   - Choose 2–3 pattern types from:
     - `[Craft+Benefit]`
     - `[Editorial Quote]` (if relevant quote exists).
     - `[Occasion Hook]`
     - `[Situational Luxury]` / `[Retargeting]`

3. **Variant Writing**
   - For each variant:
     - Tag with pattern type in square brackets at the start.
     - Keep to 1–3 short sentences.
     - First clause: feeling/positioning or real-world situation.
     - Second clause: one sharp craft/textile detail + behavior + benefit.
   - Always make craft details **checkable**:
     - Call out fabric/weave/finish in a way a human can verify.

4. **Funnel Mapping**
   - Annotate which funnel stage each variant suits best:
     - `prospecting`, `retargeting`, `sale/archive`.

---

## 4. Output Structure (Per SKU)

Aim for this structure before `/mm-copy` writes files:

```markdown
# [SKU] – MM Ad Copy Variants

## Context
- Category: [e.g., Basque Coat]
- Season: [e.g., FW25]
- Price Band: [e.g., Hero]
- Primary Occasions: [e.g., City winter, gallery openings]

## Variants

[Craft+Benefit]
[primary-text block]

[Occasion Hook]
[primary-text block]

[Editorial Quote] (if applicable)
[quote + tie-in line]

## Funnel Notes
- Prospecting: [which variants and why]
- Retargeting: [which variants and why]
- Sale/Archive: [if relevant]
```

---

## 5. Tone & Guardrails

Tone:
- Quiet, confident, believable.
- Editorial, but not obscure.
- Commercial enough for performance channels, but true to MM’s world.

Guardrails:
- Replace generic luxury phrases with specific, verifiable craft details.
- Avoid:
  - Standalone slogans (“Build your uniform”, “Shop now”).
  - Overly hypey language inconsistent with MM’s positioning.
- Use “throw on and go”, “special enough to turn heads”, etc. **only** when
  the user explicitly opts into more commercial language.

---

## 6. Using This Skill with `/mm-copy`

The `/mm-copy` command:
- Handles:
  - SKU selection (top performers or provided list).
  - File writing to `.orchestration/evidence/mm-copy/[SKU].md`.
- Should rely on this skill for:
  - Framework, patterns, anti-patterns.
  - Tone and performance-aware structure.

Other agents (creative strategy, performance analysis) can load this skill to:
- Keep copy critique aligned with the same framework.
- Suggest new experiments that still respect MM’s voice and craft focus.

