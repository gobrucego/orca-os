#!/usr/bin/env python3
import argparse
import json
import os
import sqlite3
from pathlib import Path
from datetime import datetime

ROOT = Path(os.getcwd())
WS_DIR = ROOT / ".workshop"
DB_PATH = WS_DIR / "workshop.db"


def ensure_db(conn: sqlite3.Connection):
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS finalize_outcomes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ts TEXT NOT NULL,
            status TEXT NOT NULL,
            score INTEGER,
            build TEXT,
            tests TEXT,
            zero_tag TEXT,
            screenshots INTEGER,
            design_guard_violations INTEGER,
            profile TEXT,
            report TEXT,
            notes TEXT
        )
        """
    )
    conn.commit()


def cmd_finalize(args):
    WS_DIR.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(DB_PATH) as conn:
        ensure_db(conn)
        conn.execute(
            """
            INSERT INTO finalize_outcomes
            (ts, status, score, build, tests, zero_tag, screenshots, design_guard_violations, profile, report, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                datetime.utcnow().isoformat() + "Z",
                args.status,
                args.score,
                args.build,
                args.tests,
                args.zero_tag,
                args.screenshots,
                args.design_guard,
                args.profile,
                args.report,
                args.notes,
            ),
        )
        conn.commit()
    print("Workshop: recorded finalize outcome")


def cmd_query(args):
    if not DB_PATH.exists():
        print("No workshop DB yet", flush=True)
        return
    with sqlite3.connect(DB_PATH) as conn:
        cur = conn.execute(
            "SELECT ts, status, score, build, tests, screenshots FROM finalize_outcomes ORDER BY id DESC LIMIT ?",
            (args.limit,),
        )
        rows = cur.fetchall()
        for r in rows:
            print(
                f"- {r[0]} status={r[1]} score={r[2]} build={r[3]} tests={r[4]} screenshots={r[5]}"
            )


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd")

    fz = sub.add_parser("finalize")
    fz.add_argument("--status", required=True)
    fz.add_argument("--score", type=int, default=0)
    fz.add_argument("--build", default="")
    fz.add_argument("--tests", default="")
    fz.add_argument("--zero-tag", dest="zero_tag", default="")
    fz.add_argument("--screenshots", type=int, default=0)
    fz.add_argument("--design-guard", dest="design_guard", type=int, default=0)
    fz.add_argument("--profile", default="")
    fz.add_argument("--report", default="")
    fz.add_argument("--notes", default="")
    fz.set_defaults(func=cmd_finalize)

    q = sub.add_parser("query")
    q.add_argument("--limit", type=int, default=10)
    q.set_defaults(func=cmd_query)

    args = ap.parse_args()
    if not hasattr(args, "func"):
        ap.print_help()
        return 2
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())

