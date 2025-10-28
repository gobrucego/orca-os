# Phase 8 — Evaluation Harness

Purpose: Run repeatable scenarios, invoke `/finalize`, and collect evidence-based KPIs.

Artifacts
- Runner: `scripts/eval-run.sh`
- Output root: `.orchestration/verification/eval/<timestamp>/`
  - `summary.md` — compact human-readable results
  - `kpis.csv` — scenario CSV (status, score, build, tests, zeroTag, screenshots, designGuard, duration)
  - `workspaces/<scenario>/` — isolated copies where each run executes
  - `logs/eval.log` — run log

Usage
- Run all default scenarios: `bash scripts/eval-run.sh`
- View latest results:
  - `E=.orchestration/verification/eval/$(ls -1 .orchestration/verification/eval | tail -n 1)`
  - `sed -n '1,160p' "$E"/summary.md`

Scenarios (default)
- `pass_artifact`: out/ present, tags + screenshot → PASS
- `zero_tag_fail`: empty implementation log (tests gating) → expected FAIL
- `screenshot_missing_fail`: screenshot tag points to missing file → expected FAIL
- `design_violation_warn`: tags + out/ + CSS violations → PASS with Design Guard violations reported (warn-only)

Notes
- The harness creates isolated workspaces under `workspaces/` to avoid polluting the repo.
- Design Guard is warn-only in Phase 2, so it never blocks finalize; violations are summarized in the report.
- You can add your own scenarios by extending `scripts/eval-run.sh` with additional blocks.

