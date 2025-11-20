---
name: peptidefox-mobile-ux
description: >
  PeptideFox mobile UX & UI design skill for Expo/React Native. Applies PeptideFox
  design-dna, layout patterns, and interaction rules so peptidefox-mobile screens
  feel like first-class Fox surfaces rather than generic AI UI. Use when designing
  or implementing Expo screens/flows for PeptideFox.
license: internal
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  os2_domain: "expo"
  project: "peptidefox"
  pipeline_phase: "implementation"
---

# PeptideFox Mobile UX – Expo Skill

You are loading the **PeptideFox Mobile UX** skill: a focused guide for building
and reviewing the Expo/React Native app (`peptidefox-mobile`) so it feels
distinctly PeptideFox, not like generic AI-generated mobile UI.

This skill is meant to be used by:
- `expo-builder-agent`
- `expo-aesthetics-specialist`
- Other Expo lane agents working on **peptidefox-mobile** UI/UX.

It encodes the core of PeptideFox’s design-dna for mobile and how it should
influence layout, interaction, and visual decisions.

---

## 1. When to Use This Skill

Load this skill whenever:
- You are implementing or refining screens/flows in `peptidefox-mobile`.
- You are reviewing Expo UI for PeptideFox and want to avoid generic patterns.
- You are making decisions about:
  - Layout and information density.
  - Component hierarchy and grouping.
  - Visual styling, typography, and motion.
  - Navigation structure within the mobile app.

Do **not** use this skill for:
- Non-PeptideFox apps.
- Backend-only or data-only tasks with no UI impact.

---

## 2. Source of Truth – Design DNA

Before making visual/UX decisions for PeptideFox Mobile, know where the
design-dna lives:

In the PeptideFox repo (desktop project root):
- `design-dna/design-system-v7.0.md`
- `design-dna/DESIGN_RULES_v7.0.md`
- Any additional design notes under `design-dna/` or design-dna archives.

When working from the Expo project in `~/Desktop/peptidefox`:
- You may also see `EXPO-AESTHETICS-REVIEW-GUIDE.md` and other mobile-specific
  documents; treat them as extensions of the core design-dna for mobile.

If you have time and context, skim those docs before making major changes. The
summary below is a distilled reference for use inside constrained contexts.

---

## 3. Design DNA Summary (For Mobile)

### 3.1 Ethos – Scientific Premium Minimalism™

PeptideFox UI expresses:
- Scientific rigor (clarity, precision, grounded data).
- Premium minimalism (restraint, focus, no visual noise).
- Calm confidence (no shouting; composed but not sterile).

For mobile, this means:
- Clean, breathable layouts—not dense dashboards.
- Clear relationships between data, controls, and explanations.
- Visuals that support reading concentration and comprehension.

### 3.2 Color Discipline

Treat color as a **small, deliberate system**:
- Primary accent: **Clean Future Blue** (`#336CFF`).
- Lavender: atmospheric/background only, not a primary functional accent.
- Neutrals: careful light/dark palettes for surfaces and text; avoid random
  greys that aren’t mapped to tokens.

Guidelines:
- Use tokens (e.g., `colors.primary`, `colors.surface`, `colors.text`, etc.)
  rather than hard-coded HEX values wherever possible.
- Reserve Blue and any bright accent colors for:
  - Primary actions.
  - High-salience state indicators.
  - Key data highlights.
- Backgrounds should feel intentional:
  - Layered surfaces (cards/panels) rather than big flat rectangles.
  - Lavender and neutrals used to create depth and breathing room.

### 3.3 Typography

Core roles:
- **Brown LL** – primary font for body and headings.
- **Brown Mono LL** – for navigation, labels, and step indicators.
- **Brown LL Inline** – only for peptide titles / peptide identity roles.

On mobile:
- Use typography tokens to define:
  - Screen titles vs section headings vs body copy.
  - Labels and meta text.
- Avoid:
  - Arbitrary font sizes like `15`/`17` with no token mapping.
  - Overuse of mono or inline variants outside their intended roles.

### 3.4 Spacing & Rhythm

- All spacing should be **token-based**, not ad-hoc pixel values.
- Follow the design rules for:
  - Vertical rhythm across sections.
  - Horizontal padding in containers.
  - Hairline rules (dividers, borders) where appropriate.

On mobile:
- Use a consistent base unit (e.g., 4px or 8px grid) via tokens.
- Prioritize readability and tapability:
  - Enough vertical breathing room around interactive elements.
  - Clear separation between content blocks.

---

## 4. Mobile Layout & Interaction Patterns

### 4.1 Preferred Layout Patterns

For key screens (e.g., tools, peptide library, protocol flows, education):
- **Tiered layout**:
  - Clear top section for identity/context (what screen is this, what’s the
    user doing).
  - Middle section for primary interactive content (lists, charts, controls).
  - Bottom or overlays for secondary actions or contextual helpers.

For lists (peptides, protocols, history):
- Use card-like rows with clear left-to-right information hierarchy:
  - Identity (name/title) → key metrics / tags → secondary details.
- Support scanning:
  - Align metrics across items.
  - Use tokens for spacing and typography to make patterns obvious.

### 4.2 Navigation & Information Architecture

- Navigation should feel **predictable and legible**:
  - Clear entry points for core surfaces (e.g. Home, Library, Tools, Profile).
  - Consistent back behavior and header patterns.
- Avoid:
  - Deep nesting without breadcrumbs or cues.
  - Surprise modals that radically change context without warning.

When adding new screens:
- Fit them into the existing IA:
  - Is this a detail view off an existing list?
  - A new axis under a known feature (e.g. new analysis mode)?
  - A one-off tool that should live under “Tools” rather than top-level?

---

## 5. UX Rules for PeptideFox Mobile

### 5.1 Focus on Readability & Comprehension

PeptideFox content is scientific and dense by nature. Mobile UI should:
- Favor **chunking** over long, continuous text blocks.
- Use headings and labels to explain what each section represents.
- Provide brief, inline explanations where confusion is likely.

### 5.2 Interaction & Feedback

- Make every interaction clearly feel **instant and intentional**:
  - Buttons and key controls should have responsive states.
  - Navigations and data loads should show progress or skeletons when needed.
- Avoid:
  - Ambiguous tap targets with no feedback.
  - “Dead” areas that look interactive but are not.

### 5.3 Empty/Error/Edge States

- Treat empty states as first-class design surfaces:
  - Explain why the state is empty.
  - Provide clear next actions (e.g. “Add a peptide”, “Import protocol”).
- For error states:
  - Avoid cryptic messages.
  - Provide actionable guidance (“Try again”, “Check connection”, etc.).

---

## 6. Anti-Patterns (What to Avoid)

When working on PeptideFox Mobile, **avoid**:

1. **Generic AI Dashboards**
   - Centered hero with big headline + two buttons.
   - 3-column feature grids or generic card grids copied from templates.
   - Heavy bordered tables with visual weight but poor readability.

2. **Off-Brand Visuals**
   - Random bright colors not mapped to tokens.
   - Overly playful or cartoonish elements that clash with scientific premium.

3. **Typography Noise**
   - Many font sizes and weights with no clear hierarchy.
   - Overuse of mono or inline fonts outside their roles.

4. **Layout Incoherence**
   - Inconsistent spacing between structurally similar elements.
   - Content squeezed edge-to-edge with no breathing room.

Whenever you find yourself drifting toward a generic pattern, re-center on:
- The design-dna.
- The specific data and stories PeptideFox needs to tell on that screen.

---

## 7. Using This Skill with OS 2.0 Agents

### 7.1 Expo Builder & Aesthetics Specialist

When `expo-builder-agent` or `expo-aesthetics-specialist` are working on
PeptideFox Mobile:
- Load this skill early in the task.
- Use it to:
  - Check that typography, color, and spacing align with PeptideFox rules.
  - Avoid generic AI UI patterns.
  - Make sure new screens/flows feel like natural extensions of the existing
    PeptideFox experience.

### 7.2 Interaction with Pipelines

In the Expo pipeline (`docs/pipelines/expo-pipeline.md`) and `/orca-expo`:
- For tasks that target `~/Desktop/peptidefox` and the mobile app:
  - Mention this skill as a recommended context for implementation and
    aesthetics phases.
- Gate agents (`design-token-guardian`, `expo-aesthetics-specialist`) can:
  - Use this skill when evaluating PeptideFox Mobile surfaces specifically.

---

## 8. Output Expectations (for Agents Using This Skill)

When an agent has loaded this skill and is asked to design/implement/review
PeptideFox Mobile UI:

- Reference **design-dna** explicitly when making decisions:
  - “This screen uses Clean Future Blue as the primary action color via token X.”
- Call out **PeptideFox-specific patterns**:
  - “This flow follows the tiered layout pattern (identity → primary content → helpers).”
- Highlight and avoid **generic patterns**:
  - “We avoided a generic 3-card feature grid and instead used a peptide-centric card layout.”

The goal is that future reviewers (human or agent) can see, at a glance,
how the mobile UI aligns with PeptideFox’s visual and UX law, not just with
generic mobile best practices.

