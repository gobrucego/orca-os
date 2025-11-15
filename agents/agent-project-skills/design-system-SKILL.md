---
name: orchids-design-system
description: >
  Design system for the Orchids web app. Defines visual tokens, layout rules,
  and component primitives that all UI implementation must follow.
---

# Orchids Design System Skill (Skeleton)

This file is the single source of truth for the Orchids project's visual and interaction design.
All frontend agents must obey these rules when designing or implementing UI.

> NOTE: This is a skeleton/template. Fill in the concrete values for this project.

## 1. Brand & Visual Personality

- Brand adjectives: e.g. calm, minimal, premium, botanical, editorial
- Overall feel: e.g. generous whitespace, soft gradients, low-noise interface
- Visual priorities: e.g. focus on imagery, legible typography, low chroma accents

## 2. Color System

Define semantic tokens rather than raw colors. All colors should be referenced
via these names in code (e.g. Tailwind config or CSS variables), not literals.

### 2.1. Core Palette

- `color.background`: main app background
- `color.surface`: card / panel background
- `color.surface-alt`: subtle alternative surface
- `color.text`: primary text
- `color.text-muted`: secondary/tertiary text
- `color.accent`: primary action/brand accent
- `color.accent-soft`: subtle accent backgrounds
- `color.border`: standard borders/dividers
- `color.destructive`: destructive actions/alerts
- `color.success`: positive states

_For each token, document: hex value, contrast assumptions, and usage notes._

## 3. Typography System

Define a clear hierarchy and limit the number of styles.

- Base font family: e.g. `Inter`, `Satoshi`, etc.
- Line-height strategy: e.g. 1.4–1.6 for body, 1.1–1.3 for headings

### 3.1. Scales

- `text.display`: large marketing hero titles
- `text.h1`: primary page titles
- `text.h2`: section titles
- `text.h3`: sub-section titles
- `text.body`: default body copy
- `text.small`: secondary text, captions
- `text.mono`: numeric/data or code if used

For each: font-size, weight, tracking, and usage examples.

## 4. Spacing & Layout

Adopt a strict spacing grid (prefer 4px).

- Base unit: `4px`
- Scale: `4, 8, 12, 16, 20, 24, 32, 40, 48, 64` (example – tune as needed)

Guidelines:

- Vertical rhythm: typical vertical gaps between sections/components
- Horizontal padding for cards/containers
- Page max-widths and content columns (e.g. 960px content, 1200px shell)
- Breakpoints: e.g. `sm`, `md`, `lg`, `xl` and how layout shifts at each

## 5. Shape, Borders & Shadows

- Border radius scale: e.g. `none, 4px, 8px, 9999px (pill)`
- Which radii apply where (inputs vs cards vs modals)
- Shadow usage:
  - `shadow.none`: default
  - `shadow.soft`: cards & hover elevation
  - `shadow.strong`: modals/dropdowns only

## 6. Component Primitives

Define a small set of reusable primitives. For each, describe:
- Purpose
- Allowed variants
- Required/optional content
- Typical spacing and token usage

Suggested primitives:

### 6.1. Buttons

- Variants: `primary`, `secondary`, `ghost`, `outline`, `destructive`
- States: default, hover, active, disabled, loading
- Token mapping: which colors/typography/spacing each variant uses

### 6.2. Cards / Surfaces

- Standard padding, radius, and shadow
- Header/body/footer patterns
- Optional media (image, icon) treatment

### 6.3. Forms & Inputs

- Inputs, textareas, selects, toggles
- Label, helper text, error message placement
- Validation states and colors

### 6.4. Layout Sections

- Page shell: header, footer, navigation, content area
- Standard section components: hero, content block, feature grid, gallery, etc.

## 7. Interaction Patterns

- Navigation:
  - Primary nav placement and behavior (sticky vs static)
  - Mobile nav behavior (drawer, bottom bar, etc.)

- Feedback components:
  - Toasts (e.g. using `sonner` or equivalent)
  - Dialogs and confirmations
  - Empty states and skeletons

- Motion:
  - Allowed animation types (e.g. fade/slide only)
  - Duration/easing defaults
  - Where to avoid motion (performance/clarity)

## 8. Accessibility & Content

- Minimum contrast ratios and how they map to tokens
- Focus state requirements (visible focus indicators)
- Keyboard navigation expectations for interactive components
- Content tone: concise, friendly, and clear messaging style

## 9. Dos & Don'ts

Summarize key guardrails in a quick checklist:

- ✅ DO:
  - Use only defined color/spacing/typography tokens
  - Reuse primitives before inventing new patterns
  - Maintain clear visual hierarchy and whitespace

- ❌ DO NOT:
  - Use inline styles or arbitrary color literals
  - Mix multiple radii/shadows outside the defined scale
  - Introduce new patterns without documenting them here

## 10. Linked References

If you have additional design files for this project, list them here so agents
know where to look:

- `tokens.md`: concrete token values and Tailwind/CSS mapping
- `components.md`: examples of implemented components
- `layout-examples.md`: annotated layout screenshots or descriptions
- `content-guidelines.md`: tone, voice, microcopy patterns

