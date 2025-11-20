---
name: mm-visual-audit
description: >
  Marina Moscone casting & visual audit skill. Applies the canonical MM visuals
  framework to evaluate ad and PDP imagery, focusing on invite vs intimidate
  and keep/crop/reshoot recommendations.
license: internal
allowed-tools:
  - Read
  - Glob
  - Grep
metadata:
  project: "marina-moscone-minisite"
  os2_domain: "brand"
---

# MM Visual Audit – Casting & Imagery Skill

This skill encodes the **visual audit framework** used by the Marina Moscone
minisite and the `/mm-visual-audit` command.

Use it when:
- Reviewing ad or e‑comm imagery for MM.
- Deciding which images to keep, crop (headless), or reshoot.
- Auditing whether images invite or intimidate the viewer relative to MM’s brand.

---

## 1. Source Frameworks & Context

For a full picture, this skill expects:
- `minisite/data/meta-api/ad-thumbnails/mm-visuals-framework.md`
- `minisite/reports/MM_STRATEGY_DIAGNOSTIC_CANONICAL.md`
- `minisite/reports/MM_STRATEGY_OUTLOOK_BLUEPRINT_CANONICAL.md`
- `minisite/MM-VOICE.md`
- `minisite/creative-strategist.md`
- `minisite/design-dna/design-system-v3.0.md`

When possible:
- Skim `mm-visuals-framework.md` to refresh the canonical rules.
- Skim casting/photography sections of the strategy docs.
- Use MM voice docs to calibrate tone when writing recommendations.

---

## 2. Evaluation Axes per Image

For each image, evaluate:

1. **Warmth**
   - Expression and body language.
   - Does the model feel approachable or distant?

2. **Expression**
   - Micro-expressions, gaze, emotional tone.
   - Direct, severe stare vs soft, contemplative, or neutral.

3. **Pose**
   - Power poses vs relaxed, inviting stances.
   - Balance between editorial drama and commercial readability.

4. **Product Clarity**
   - Can a viewer understand the garment’s structure, fabric, and fit in 0.5–1s?
   - Are key features visible (neckline, waist, hem, drape, hardware)?

5. **Composition**
   - Framing, cropping, negative space, background contrast.
   - Is the garment legible or lost in noise?

Each axis can be scored 1–5 to support downstream tools:
- 1–2: problematic.
- 3: acceptable, could be improved.
- 4–5: strong and aligned with MM visual goals.

---

## 3. Invite vs Intimidate

Use the **invite vs intimidate** lens:

- **Invites**
  - Warmth in expression or body language.
  - Compositions that make the garment feel wearable and relatable.
  - Clear product visibility, especially for hero SKUs.

- **Intimidates**
  - Severely direct stares or closed-off body language.
  - Dark-on-dark compositions that obscure the garment.
  - Angles that prioritize attitude over legibility.

For each image, decide:
- `invites` or `intimidates` (or borderline).
- Whether the issue is **face-driven**, **pose-driven**, or **composition-driven**.

This feeds into whether a **headless crop** could rescue the image:
- If the main issue is face/expression and the garment is clear → candidate for
  `keep_but_headless_crop`.
- If product clarity/composition are also weak → likely `reshoot_needed`.

---

## 4. Recommendations Taxonomy

For each image, recommend one of:

- `keep_as_is`
- `keep_but_headless_crop`
- `use_as_secondary`
- `reshoot_needed`

Guidelines:
- `keep_as_is`: strong warmth/product clarity/composition; aligned with MM tone.
- `keep_but_headless_crop`: product is strong but expression/presence is off.
- `use_as_secondary`: works in supporting roles (detail, alt angle, motion) but
  not as primary hero.
- `reshoot_needed`: fundamental issues with pose, lighting, composition, or
  garment clarity that cropping can’t solve.

Each recommendation should have a 1–3 sentence rationale referencing the
visuals framework (e.g. “0.5s comprehension”, “headless candidate”, “contrast”).

---

## 5. Per-Product & Batch Summaries

When images are tied to SKUs/products:

- Group by product/SKU:
  - Identify 1–2 hero candidates.
  - Identify useful secondary shots (back/side views, details).
  - Note missing imagery that would materially improve the decision architecture.

- For the batch:
  - Tally keep/crop/reshoot counts.
  - Highlight recurring issues:
    - e.g. “severe expressions in primary frames”, “insufficient contrast on black coats”.
  - Translate into 3–5 directives for future shoots or re-edit work.

---

## 6. Using This Skill with `/mm-visual-audit`

The `/mm-visual-audit` command:
- Handles:
  - Image discovery via globs/manifests.
  - Writing the final markdown report to
    `.orchestration/evidence/mm-visual-audit/<batch-label>.md`.
- Should rely on this skill for:
  - The evaluation axes.
  - Invite vs intimidate reasoning.
  - Recommendation taxonomy and rationales.

Other agents (e.g. creative strategy, brand) can load this skill to:
- Understand the same visual standards used in audits.
- Refer to shared language (“headless candidate”, “invites vs intimidates”)
  when discussing imagery.

