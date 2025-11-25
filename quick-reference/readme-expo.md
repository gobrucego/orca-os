/opt/homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: Operation not permitted
# OS 2.3 Expo Lane Readme

**Lane:** Expo / React Native  
**Domain:** `expo`  
**Entrypoints:** `/plan`, `/orca`, `/orca-expo`, `/project-memory`, `/project-code`

This readme explains the Expo lane in Vibe OS 2.3:

- Planning & specs for Expo tasks
- Orchestration via `/orca` and `/orca-expo`
- Pipeline and phase configs
- Agents and specialists
- Skills and memory integration
- Response Awareness and gates

---

## 1. When to Use the Expo Lane

Use this lane for Expo/React Native mobile work:

- Components/screens under React Native/Expo directories
- Navigation flows (Expo Router)
- Platform‑specific behavior (iOS/Android through Expo)

Examples:

- “Add pull‑to‑refresh to the product list”
- “Implement deep linking for the onboarding flow”
- “Refactor auth flow to use SecureStore”

---

## 2. Core Commands and Flow

### 2.1 Planning – `/plan`

For non‑trivial Expo tasks:

- `/plan "..."` creates a spec under `requirements/`.
- Complex flows (multi‑screen auth, offline, sensitive data) should
  have a spec before the full Expo lane runs.

---

### 2.2 Global Orchestrator – `/orca`

`/orca`:

- Runs memory‑first search across Workshop + vibe.db.
- Detects `expo` domain.
- Checks for a requirements spec.
- Routes to `/orca-expo` with relevant context and spec info.

You can also call `/orca-expo` directly.

---

### 2.3 Expo Orchestrator – `/orca-expo`

File: `commands/orca-expo.md`

- Accepts:

  ```bash
  /orca-expo "add pull-to-refresh to product list"
  /orca-expo -tweak "fix button spacing"
  /orca-expo "implement requirement 2025-11-25-auth"
  ```

- Behavior:
  1. **Memory‑first** – queries Workshop/vibe.db for relevant Expo incidents and patterns.
  2. **Complexity classification**:
     - `simple` – small tweak, single file → light path.
     - `medium` – one screen/feature → full pipeline, spec optional.
     - `complex` – multi‑screen/architecture/security → full pipeline, spec required.
  3. **Spec gating**:
     - For `complex`, require `requirements/<id>/06-requirements-spec.md`.
  4. **Routing**:
     - `simple` or `-tweak` → `expo-light-orchestrator`.
     - `medium`/`complex` → full Expo pipeline with grand‑orchestrator and gates.

---

## 3. Pipeline and Phase State

### 3.1 Pipeline Spec

- `docs/pipelines/expo-pipeline.md`:
  - Describes Expo pipeline: context → planning → implementation → multiple gates (design tokens, accessibility, aesthetics) → verification.

### 3.2 Phase Config and `phase_state.json`

- `docs/reference/phase-configs/expo-phase-config.yaml`
- Uses `.claude/orchestration/phase_state.json` with `domain: "expo"`.
- Key phases:
  - `context_query`, `planning`, `implementation`, `design_tokens`, `accessibility`, `aesthetics`, and verification/summary.
- Expo implementation outputs `ra_events` to capture RA tags.

---

## 4. Agents

Heavy lane agents:

- `agents/expo/expo-grand-orchestrator.md`
  - Opus, coordinates full Expo lane.
  - Chooses architecture (Expo Router patterns, navigation structure).

- `agents/expo/expo-architect-agent.md`
  - Plans changes, including navigation/state decisions.
  - Uses RA tags for path decisions and tradeoffs.

- `agents/expo/expo-builder-agent.md`
  - Implements plan with localized diffs.
  - Emits `ra_events` for RA runtime.

- `agents/expo/expo-verification-agent.md`
  - Runs `expo`‑level verification (doctor, tests/lints where configured).

Specialists:

- `api-guardian`, `bundle-assassin`, `impact-analyzer`, `refactor-surgeon`, `test-generator`,
  `expo-aesthetics-specialist`, `a11y-enforcer`, `performance-enforcer`.

Light lane agent:

- `agents/expo/expo-light-orchestrator.md`
  - Handles simple tweaks via direct delegation to `expo-builder-agent` plus at most one specialist.

---

## 5. Skills and Memory

Skills:

- Expo uses general design and RA skills (design DNA, design QA, etc.).
  - `skills/design-dna-skill/SKILL.md`
  - `skills/design-qa-skill/SKILL.md`

Memory:

- `/project-memory`:
  - Records Expo incidents, gotchas (e.g. navigation pitfalls, performance issues).
- `/project-code`:
  - Indexed Expo/React Native code and integration points.

Unified memory search is used by `/orca` and `/orca-expo` before ProjectContext.

---

## 6. Response Awareness & Gates

Expo pipeline includes:

- RA tagging in planning and implementation (`ra_events`).
- Multiple gates (design tokens, accessibility, aesthetics) that can use RA
  context to prioritize or block issues.

---

## 7. Mental Model

- Quick tweak → `/orca-expo -tweak "..."` → `expo-light-orchestrator` → builder.
- Serious feature → `/plan` → `/orca` → `/orca-expo` → full Expo pipeline.

