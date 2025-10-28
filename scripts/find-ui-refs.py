#!/usr/bin/env python3
import argparse
import os
import re
from pathlib import Path

ROOT = Path(os.getcwd())
SEARCH_DIRS = [ROOT/"app", ROOT/"src", ROOT/"pages", ROOT/"components", ROOT/"styles", ROOT/"lib", ROOT/"ui", ROOT/"out"]
EXTS = {".ts", ".tsx", ".js", ".jsx", ".css", ".scss", ".sass", ".html", ".swift"}

def scan(q: str):
    pat = re.compile(re.escape(q))
    for d in SEARCH_DIRS:
        if not d.exists():
            continue
        for p in d.rglob("*"):
            if p.is_file() and p.suffix in EXTS:
                try:
                    for i, line in enumerate(p.read_text(encoding="utf-8", errors="ignore").splitlines(), start=1):
                        if pat.search(line):
                            print(f"{p}:{i}: {line.strip()[:160]}")
                except Exception:
                    continue

def main():
    ap = argparse.ArgumentParser(description="Find UI refs (classes/tokens/selectors) across source and out/")
    ap.add_argument("query", help="String or class/token to search for, e.g., '--color-accent' or 'bento-card'")
    args = ap.parse_args()
    scan(args.query)

if __name__ == "__main__":
    main()
