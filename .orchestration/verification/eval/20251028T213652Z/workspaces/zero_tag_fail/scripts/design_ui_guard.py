#!/usr/bin/env python3
import json
import os
import re
import sys
from pathlib import Path

ROOT = Path(os.getcwd())
DNA_DIR = ROOT / ".claude" / "design-dna"
ORCH = ROOT / ".orchestration"
VER_DIR = ORCH / "verification"
REPORT_MD = VER_DIR / "design-guard-report.md"
SUMMARY_JSON = VER_DIR / "design-guard-summary.json"


def load_dna():
    if not DNA_DIR.exists():
        return None, None
    for p in DNA_DIR.glob("*.json"):
        try:
            with open(p, "r", encoding="utf-8") as f:
                return json.load(f), p
        except Exception:
            continue
    return None, None


def list_candidate_files():
    # Scan common source dirs only (avoid scanning docs or large artifacts)
    dirs = [
        ROOT / "src",
        ROOT / "app",
        ROOT / "components",
        ROOT / "styles",
        ROOT / "pages",
        ROOT / "lib",
        ROOT / "ui",
        ROOT / "Sources",
        ROOT / "Resources",
    ]
    exts = {".css", ".scss", ".sass", ".ts", ".tsx", ".js", ".jsx", ".swift"}
    files = []
    for d in dirs:
        if d.exists():
            for path in d.rglob("*"):
                if path.is_file() and path.suffix in exts:
                    files.append(path)
    return files


def scan_file(path: Path, dna: dict):
    violations = []
    base_grid = int(dna.get("base_grid", 4) or 4)
    disallow_raw_colors = bool(dna.get("disallow_raw_colors", True))
    allowed_weights = set(map(int, dna.get("allowed_font_weights", [300, 400, 500, 600, 700])))
    min_track = float(dna.get("typography", {}).get("min_letter_spacing_em", -0.02))
    max_track = float(dna.get("typography", {}).get("max_letter_spacing_em", 0.10))

    try:
        content = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    except Exception as e:
        return [f"{path}:0: Could not read file: {e}"]

    hex_color = re.compile(r"#[0-9a-fA-F]{3,8}\b")
    rgb_color = re.compile(r"\b(?:rgb|rgba|hsl|hsla)\(")
    px_val = re.compile(r"(?P<num>\d+)px\b")
    fw_num = re.compile(r"font-weight\s*:\s*(?P<val>\d{3})\b")
    letter_spacing = re.compile(r"letter-spacing\s*:\s*(?P<val>-?\d*\.?\d+)em\b")

    for i, line in enumerate(content, start=1):
        # 1) Raw color usage
        if disallow_raw_colors:
            if hex_color.search(line):
                violations.append(f"{path}:{i}: Raw hex color detected")
            if re.search(r"\b(?:rgb|rgba|hsl|hsla)\(", line):
                violations.append(f"{path}:{i}: Raw rgb/hsl color detected")

        # 2) 4px grid: px values should be multiples of base_grid (allow 1px hairlines)
        for m in px_val.finditer(line):
            try:
                n = int(m.group("num"))
                if n == 1:
                    continue  # allow hairlines
                if n % base_grid != 0:
                    violations.append(f"{path}:{i}: {n}px not multiple of {base_grid}")
            except ValueError:
                pass

        # 3) Font weight numeric enforcement
        for m in fw_num.finditer(line):
            v = int(m.group("val"))
            if v not in allowed_weights:
                violations.append(f"{path}:{i}: font-weight {v} not in allowed {sorted(allowed_weights)}")

        # 4) Letter-spacing sanity (em range)
        for m in letter_spacing.finditer(line):
            try:
                v = float(m.group("val"))
                if not (min_track <= v <= max_track):
                    violations.append(
                        f"{path}:{i}: letter-spacing {v}em outside [{min_track}, {max_track}]"
                    )
            except ValueError:
                pass

    return violations


def main():
    VER_DIR.mkdir(parents=True, exist_ok=True)
    dna, dna_path = load_dna()
    dna_present = dna is not None

    # Phase 2: warn-only regardless of DNA presence
    mode = "warn-only"
    all_violations = []

    files = list_candidate_files()
    if dna_present and files:
        for p in files:
            all_violations.extend(scan_file(p, dna))

    with open(REPORT_MD, "w", encoding="utf-8") as f:
        f.write("# Design UI Guard Report\n\n")
        f.write(f"- DNA present: {dna_present}\n")
        f.write(f"- Mode: {mode}\n")
        if dna_present:
            f.write(f"- DNA file: {dna_path}\n")
            f.write(f"- Base grid: {dna.get('base_grid', 4)}\n")
            f.write(f"- Disallow raw colors: {bool(dna.get('disallow_raw_colors', True))}\n")
        f.write(f"- Files scanned: {len(files)}\n")
        f.write(f"- Violations: {len(all_violations)}\n\n")
        if all_violations:
            f.write("## Violations\n")
            for v in all_violations:
                f.write(f"- {v}\n")
            f.write("\n")
        else:
            f.write("No violations found or no relevant source files present.\n")

    summary = {
        "mode": mode,
        "dna_present": dna_present,
        "files_scanned": len(files),
        "violations": len(all_violations),
        "report": str(REPORT_MD),
    }
    with open(SUMMARY_JSON, "w", encoding="utf-8") as f:
        json.dump(summary, f)

    # Print a short summary line (for logs)
    print(f"Design Guard: violations={summary['violations']} mode={mode} dna_present={dna_present}")

    # Warn-only exit
    sys.exit(0)


if __name__ == "__main__":
    main()

