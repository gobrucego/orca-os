---
description: "Audit recent tasks and agent behavior using Response Awareness (no implementation)"
argument-hint: "<scope description, e.g. 'last 10 tasks'>"
allowed-tools:
  ["Task", "Read", "Grep", "Glob", "Bash",
   "AskUserQuestion", "mcp__project-context__query_context", "mcp__project-context__save_standard", "mcp__project-context__save_task_history"]
---

# /audit – Response-Aware Behavior Audit

Use this command to run a **meta audit** over recent work in this project using
Response Awareness principles. It does not change code; it evaluates how the
pipeline behaved (skipped steps, scope creep, misused context, etc.) and
records learnings.

---
## 1. Choose Scope

Interpret `$ARGUMENTS` as an audit scope hint, for example:
- `"last 10 tasks"`
- `"recent Nextjs onboarding work"`
- `"all iOS tasks this week"`

If the scope is unclear:
- Ask the user via `AskUserQuestion` whether to:
  - Audit the **last N tasks** (e.g. last 5–10),
  - Focus on a particular domain (`nextjs`, `ios`, `expo`, `seo`, etc.),
  - Focus on a particular requirement ID.

---
## 2. Load History & Evidence

Using a combination of:
- `.claude/project/phase_state.json` (phase and gate history),
- Project-specific logs under `.claude/orchestration/evidence/`,
- ProjectContextServer (`mcp__project-context__query_context`) with a meta task such as:
  - `"Summarize recent task_history and standards for audit"`,

Gather:
- A list of recent tasks in the chosen scope,
- Their domains, outcomes, and gate results,
- Any notable standards or decisions already saved to `vibe.db`.

If helpful, you MAY use `Bash` to:
- List evidence files under `.claude/orchestration/evidence/`,
- Inspect recent logs for gate failures or warnings.

---
## 3. Apply Response Awareness Lens

For the selected tasks, analyze behavior using RA concepts from
`docs/reference/response-awareness.md`:

- Where did we rely on **COMPLETION** rather than solid context?
  - Tag as `#COMPLETION_DRIVE` in the audit report.
- Where were important architectural choices made without being surfaced?
  - Tag as `#PATH_DECISION` and note whether they were explicit or implicit.
- Where did the model follow or ignore:
  - ProjectContextServer (context),
  - Requirements specs (`06-requirements-spec.md`),
  - Lane standards and gates?
- Any signs of **scope creep**, skipped phases, or over-diffing?
- Any repeated violations that should become standards?

Summarize per-task and then across tasks.

---
## 4. Write Audit Report

Create an audit report under:
- `.claude/orchestration/evidence/audit-<timestamp>.md`

Include:
- Scope description and time window,
- List of tasks examined (with domains and outcomes),
- RA-tagged findings (`#PATH_DECISION`, `#COMPLETION_DRIVE`, `#POISON_PATH`, etc.),
- Patterns:
  - Good behavior (what to reinforce),
  - Problematic behavior (what to fix),
- Recommended standards or guardrails.

---
## 5. Persist Learnings

Where appropriate:

1. Use `mcp__project-context__save_standard` to codify recurring issues:
   - `what_happened`, `cost`, `rule`, `domain`.
2. Use `mcp__project-context__save_task_history` to record the audit itself:
   - `domain`: `"audit"` or the relevant domain,
   - `task`: description of the audit scope,
   - `outcome`: `"success"` (audit completed) or `"partial"`,
   - `learnings`: summary of key RA findings,
   - `files_modified`: include the audit report path.

These entries enrich `vibe.db` so future `/plan` and `/orca-*` runs can benefit
from the audit’s conclusions.

