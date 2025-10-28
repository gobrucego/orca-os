# Workshop (Phase 6)

Purpose: Persist per-project outcomes, decisions, and gotchas for learning and curation.

Artifacts:
- Database: `.workshop/workshop.db` (SQLite)
- Logger: `scripts/workshop_log.py` (records finalize outcomes)
- Curator: `scripts/workshop_curator.py` (summarizes outcomes; placeholder for apoptosis logic)

Schema (finalize_outcomes):
- ts (TEXT, ISO8601)
- status (PASS/FAIL)
- score (INT)
- build (TEXT)
- tests (TEXT)
- zero_tag (TEXT)
- screenshots (INT)
- design_guard_violations (INT)
- profile (TEXT)
- report (TEXT)
- notes (TEXT)

Usage:
- Automatically recorded by `scripts/finalize.sh` after each run
- Query last entries: `python3 scripts/workshop_log.py query --limit 10`
- Summarize trends: `python3 scripts/workshop_curator.py`

Future:
- Add playbook helpful/harmful tracking and apoptosis (deleting harmful patterns after grace)
- Optional MCP wrapper to expose Workshop search tools (index/full modes)

