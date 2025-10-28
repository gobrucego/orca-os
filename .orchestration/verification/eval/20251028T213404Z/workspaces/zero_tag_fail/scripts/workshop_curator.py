#!/usr/bin/env python3
import os
import sqlite3
from pathlib import Path
from datetime import datetime, timedelta

ROOT = Path(os.getcwd())
WS_DIR = ROOT / ".workshop"
DB_PATH = WS_DIR / "workshop.db"
LOG_DIR = ROOT / ".orchestration" / "logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)
LOG_FILE = LOG_DIR / "curator.log"


def main():
    if not DB_PATH.exists():
        print("No workshop DB yet")
        return 0
    with sqlite3.connect(DB_PATH) as conn:
        cur = conn.execute(
            "SELECT status, COUNT(*) FROM finalize_outcomes GROUP BY status"
        )
        stats = {row[0]: row[1] for row in cur.fetchall()}
        total = sum(stats.values())
        pass_count = stats.get("PASS", 0)
        fail_count = stats.get("FAIL", 0)
        line = f"[{datetime.utcnow().isoformat()}Z] totals={total} pass={pass_count} fail={fail_count}"
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(line + "\n")
        print("Curator summary:", line)
    # Placeholder: No destructive actions in Phase 6. Future: evaluate playbooks helpful/harmful.
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

