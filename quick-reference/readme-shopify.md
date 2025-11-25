/opt/homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: Operation not permitted
# OS 2.3 Shopify Lane Readme

**Lane:** Shopify Themes  
**Domain:** `shopify`  
**Entrypoints:** `/plan`, `/orca`, `/orca-shopify`, `/project-memory`, `/project-code`

This readme describes the Shopify lane, which handles Shopify theme
development (Liquid, sections, theme structure).

---

## 1. When to Use the Shopify Lane

Use for Shopify theme work:

- Liquid templates (`layout/theme.liquid`, `sections/*.liquid`, `snippets/*.liquid`)
- Section schema changes
- Theme CSS/JS used in Shopify

Examples:

- “Add a new hero section with configurable background”
- “Fix cart drawer behavior on mobile”
- “Update product grid styling”

---

## 2. Core Commands

### 2.1 Planning – `/plan`

- For larger theme changes:
  - Use `/plan "..."` to create a spec under `requirements/`.
  - Complex theme features should have specs.

### 2.2 Global Orchestrator – `/orca`

- Detects Shopify work and routes to `/orca-shopify` after memory and
  ProjectContext.

### 2.3 Shopify Orchestrator – `/orca-shopify`

File: `commands/orca-shopify.md`

- Routes theme work to `shopify-grand-architect` and specialists:
  - `shopify-css-specialist`
  - `shopify-liquid-specialist`
  - `shopify-section-builder`
  - `shopify-js-specialist`
  - `shopify-theme-checker`

Pipeline doc:

- `docs/pipelines/shopify-pipeline.md`
- `docs/reference/phase-configs/shopify-phase-config.yaml`

The Shopify lane is OS 2.2‑style (no light path yet) but still respects
role boundaries and uses gates (theme check, design token warnings).

---

## 3. Agents and Skills

Agents:

- `agents/shopify/shopify-grand-architect.md` (if present)
- `agents/shopify/shopify-css-specialist.md`
- `agents/shopify/shopify-liquid-specialist.md`
- `agents/shopify/shopify-section-builder.md`
- `agents/shopify/shopify-js-specialist.md`
- `agents/shopify/shopify-theme-checker.md`

Skills:

- `skills/liquid-quick/SKILL.md`
- `skills/shopify-theme/SKILL.md`

---

## 4. Memory & RA

- `/project-memory` collects theme incidents and decisions.
- `/project-code` indexes theme files and can be used to quickly find
  reusable section/snippet patterns.
- RA integration is lighter here today than in Next.js/iOS/Expo but can
  be extended using the same patterns.

---

## 5. Mental Model

- Use Shopify lane when you’re touching Shopify theme files.
- For deeper RA/gating behavior, refer to how Next.js/iOS lanes are
  structured.

