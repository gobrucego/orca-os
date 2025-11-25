/opt/homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: Operation not permitted
# OS 2.3 iOS Lane Readme

**Lane:** iOS / Native Apple Platforms  
**Domain:** `ios`  
**Entrypoints:** `/plan`, `/orca`, `/orca-ios`, `/project-memory`, `/project-code`

This document explains how the iOS lane works in Vibe OS 2.3:

- Planning & specs (`/plan`)
- Orchestration (`/orca`, `/orca-ios`)
- Pipeline & phases
- Agents and specialists
- Skills and memory integration
- Response Awareness and gates

---

## 1. When to Use the iOS Lane

Use this lane for native Apple platform work:

- Swift/SwiftUI/UIKit code under `*.swift`
- Xcode projects/workspaces, schemes, targets
- iOS app behavior, UI, navigation, networking, persistence

Examples:

- “Add haptic feedback to save button”
- “Implement offline caching for article list”
- “Refactor networking layer to use async/await”

---

## 2. Core Commands and Flow

### 2.1 Planning – `/plan`

For non‑trivial iOS work:

- Run `/plan "..."` to create a spec:
  - `requirements/YYYY-MM-DD-HHMM-<slug>/`
  - Q/A files (`01–05-*`) and final spec `06-requirements-spec.md`
  - RA tags in the spec indicate important decisions and assumptions.

Complex features (multi‑screen, architecture/data changes, auth/payments,
offline) must have a spec before the iOS lane runs in full.

---

### 2.2 Global Orchestrator – `/orca`

`/orca`:

- Runs memory‑first search (Workshop + vibe.db).
- Checks for existing requirements/specs.
- Detects the iOS domain for the task.
- Routes to `/orca-ios` with:
  - Task summary
  - Memory context
  - Spec information (if any)

You can also call `/orca-ios` directly.

---

### 2.3 iOS Orchestrator – `/orca-ios`

File: `commands/orca-ios.md`

- Accepts:

  ```bash
  /orca-ios "add haptic feedback to save button"
  /orca-ios -tweak "fix button padding"
  /orca-ios "implement requirement 2025-11-25-0930-workspace-sharing"
  ```

- Behavior:
  1. **Memory‑first** – searches Workshop and unified memory for `domain: "ios"` decisions and code.
  2. **Complexity classification**:
     - `simple` – one file, minor tweak → light path.
     - `medium` – one screen/feature → full pipeline, spec recommended.
     - `complex` – multi‑screen, architecture, security, offline, migrations → full pipeline, spec required.
  3. **Spec gating** (for `complex`):
     - Requires `requirements/<id>/06-requirements-spec.md`.
  4. **Routing**:
     - `simple` or `-tweak` → `ios-light-orchestrator`.
     - `medium`/`complex` → full iOS lane with grand‑architect and gates.

---

## 3. Pipeline and Phase State

### 3.1 Pipeline Spec

- `docs/pipelines/ios-pipeline.md` – describes:
  - Context → requirements & impact → architecture & plan
  - Implementation → standards gate → UI review gate
  - Verification → completion & learning

### 3.2 Phase Config and `phase_state.json`

- `docs/reference/phase-configs/ios-phase-config.yaml`
- Uses `.claude/orchestration/phase_state.json`
- Key phases:
  - `context_query` – ProjectContext query for `domain: "ios"`.
  - `requirements_impact` – change_type, impact, risks.
  - `planning` – architecture path (SwiftUI vs UIKit vs MVVM/TCA), data strategy.
  - `implementation_pass1` – `ios-builder` output + `ra_events`.
  - `standards_gate` – `ios-standards-enforcer` results (RA‑aware).
  - `ui_review_gate` – `ios-ui-reviewer` for design tokens/UI.
  - `implementation_pass2` – corrective pass when gates fail.
  - `verification` – `ios-verification` build/tests.

Response Awareness:
- Implementation phases include `ra_events`.
- Standards gate outputs include `ra_audit`/RA findings.

---

## 4. Agents

### 4.1 Heavy Lane Agents

Core agents:

- `agents/iOS/ios-grand-architect.md`
  - Opus grand architect for iOS.
  - Chooses architecture (SwiftUI vs existing MVVM/TCA/UIKit).
  - Chooses data strategy (SwiftData vs Core Data vs GRDB).
  - Assembles task force and coordinates phases.

- `agents/iOS/ios-architect.md`
  - Architecture planner and impact analyst.
  - Fills `requirements_impact` and `planning`.
  - Uses RA tags for major architecture/data decisions.

- `agents/iOS/ios-builder.md`
  - Plan‑driven implementation.
  - Enforces design DNA, Swift 6 concurrency, architecture fidelity.
  - Emits `ra_events` in implementation phases.

- `agents/iOS/ios-standards-enforcer.md`
  - Standards gate:
    - Architecture adherence, concurrency, safety, tests, persistence rules.
    - RA‑aware: scans for RA tags and includes them in decisions.

- `agents/iOS/ios-ui-reviewer.md`
  - UI/UX and design token compliance, multi‑device layout checks.

- `agents/iOS/ios-verification.md`
  - Build/test gate using Xcode/xcodebuild/XcodeBuildMCP.

Specialists:

- `ios-swiftui-specialist`, `ios-uikit-specialist`,
  `ios-persistence-specialist`, `ios-networking-specialist`,
  `ios-testing-specialist`, `ios-ui-testing-specialist`,
  `ios-performance-specialist`, `ios-security-specialist`,
  `ios-accessibility-specialist`, `ios-spm-config-specialist`,
  `ios-fastlane-specialist`.

### 4.2 Light Lane Agent

- `agents/iOS/ios-light-orchestrator.md`
  - Coordinates simple tweaks.
  - Minimal context (grep/quick reads or small ProjectContext query).
  - Routes directly to `ios-builder` (+ one specialist if needed).
  - No phase_state, no heavy gates, no verification agent.

---

## 5. Skills and Knowledge

Relevant skills:

- `skills/ios-knowledge-skill/SKILL.md`
  - iOS architecture/data patterns, concurrency, testing.
- `skills/design-dna-skill/SKILL.md`
  - Design tokens and design DNA rules, including iOS surfaces.
- `skills/design-qa-skill/SKILL.md`
  - General design QA standards.

Architects and grand‑architects load and summarize these as needed rather
than stuffing them into every prompt.

---

## 6. Memory Integration

Same pattern as other lanes:

- `/project-memory` (Workshop):
  - Records iOS architecture decisions, gotchas, and standards.
  - Frequently appears in ContextBundle as `relatedStandards` and `pastDecisions`.

- `/project-code` (vibe.db + Context7):
  - Indexes Swift/SwiftUI/UIKit code and test targets.
  - Can fetch Apple/Point‑Free/other docs via Context7 libraries for deeper iOS patterns.

Unified memory search is used by `/orca` and `/orca-ios` before
ProjectContext for fast recall.

---

## 7. Response Awareness & Gates

- RA tags:
  - `ios-architect` tags `#PATH_DECISION` and assumptions around architecture/data.
  - `ios-builder` tags assumptions and path choices in `ra_events`.
- `ios-standards-enforcer`:
  - Reads RA signals and treats unresolved safety/architecture RA tags
    as at least CAUTION, potentially blocking.

This provides the RA runtime context that `/audit` and OS‑Dev can use to
promote standards and refine lane behavior over time.

---

## 8. Mental Model

- Small UI tweak → `/orca-ios -tweak "..."` → light orchestrator → builder.
- Medium/complex feature → `/plan` → `/orca` → `/orca-ios`:
  - memory → ProjectContext → spec gating (if complex) → grand‑architect → full pipeline with gates and verification.

