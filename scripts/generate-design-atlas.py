#!/usr/bin/env python3
import os
import re
import sys
from pathlib import Path
from collections import defaultdict

ROOT = Path(os.getcwd())
DOCS = ROOT / "docs"
ATLAS_DIR = DOCS / "atlas"

SOURCE_DIRS = [
    ROOT / "app",
    ROOT / "src",
    ROOT / "pages",
    ROOT / "components",
    ROOT / "styles",
    ROOT / "lib",
    ROOT / "ui",
]

WEB_EXTS = {".tsx", ".jsx", ".ts", ".js", ".css", ".scss", ".sass", ".html"}

DNA_TOKEN_PREFIXES = [
    "var(--",
    "tokens.",
    "theme.",
]


def list_source_files():
    files = []
    for d in SOURCE_DIRS:
        if d.exists():
            for p in d.rglob("*"):
                if p.is_file() and p.suffix in WEB_EXTS:
                    files.append(p)
    return files


def list_static_routes_from_out():
    out = ROOT / "out"
    routes = []
    if out.exists():
        for p in out.rglob("*.html"):
            routes.append(p)
    return routes


def extract_classes(line: str):
    classes = set()
    # className="..." or class="..." or className={'...'}
    for m in re.finditer(r"\bclass(Name)?\s*=\s*([\"\'])(.*?)\2", line):
        content = m.group(3)
        # naive split by whitespace
        for c in re.split(r"\s+", content.strip()):
            if c:
                classes.add(c)
    return classes


def extract_tokens(line: str):
    tokens = set()
    for prefix in DNA_TOKEN_PREFIXES:
        if prefix == "var(--":
            for m in re.finditer(r"var\(--([a-zA-Z0-9-_]+)\)", line):
                tokens.add(f"--{m.group(1)}")
        else:
            for m in re.finditer(re.escape(prefix) + r"([a-zA-Z0-9_./-]+)", line):
                tokens.add(prefix + m.group(1))
    return tokens


def gather_css_variables():
    """Parse CSS variables across styles/ and out/, resolve var() chains with fallback,
    and consider @layer precedence (utilities > components > base)."""
    css_dirs = [ROOT / "styles", ROOT / "out"]
    layer_order = {"base": 1, "components": 2, "utilities": 3}
    defs = {}  # name -> list of (value, file, layer_rank, seq)
    seq = 0

    for d in css_dirs:
        if not d.exists():
            continue
        for p in d.rglob("*.css"):
            try:
                text = p.read_text(encoding="utf-8", errors="ignore")
            except Exception:
                continue
            current_layer = 0
            for raw in text.splitlines():
                line = raw.strip()
                mlayer = re.search(r"@layer\s+([a-zA-Z-]+)", line)
                if mlayer:
                    current_layer = layer_order.get(mlayer.group(1), current_layer)
                m = re.search(r"--([a-zA-Z0-9-_]+)\s*:\s*([^;]+);", line)
                if m:
                    name = f"--{m.group(1)}"
                    val = re.sub(r"\s+", " ", m.group(2).strip())
                    defs.setdefault(name, []).append((val, p, current_layer, seq))
                    seq += 1

    # choose best def per token by (layer, seq) where higher layer wins, later seq wins
    chosen = {}
    for name, entries in defs.items():
        best = sorted(entries, key=lambda t: (t[2], t[3]))[-1]
        chosen[name] = best[0]

    # resolve var() recurisvely with fallback
    var_pat = re.compile(r"var\(\s*--([a-zA-Z0-9-_]+)\s*(?:,\s*([^\)]+))?\)")

    def resolve_value(val: str, seen=None):
        if seen is None:
            seen = set()
        out = val
        for _ in range(10):  # limit recursion
            changed = False
            def repl(m):
                nonlocal changed
                key = f"--{m.group(1)}"
                if key in seen:
                    return m.group(0)
                seen.add(key)
                ref = chosen.get(key)
                if ref is not None:
                    changed = True
                    return ref
                fb = m.group(2)
                if fb:
                    changed = True
                    return fb.strip()
                return m.group(0)

            out2 = var_pat.sub(repl, out)
            if out2 == out:
                break
            out = out2
        return out

    resolved = {k: resolve_value(v) for k, v in chosen.items()}
    return resolved


def file_refs_for_pattern(path: Path, pattern: re.Pattern):
    refs = []
    try:
        for i, line in enumerate(path.read_text(encoding="utf-8", errors="ignore").splitlines(), start=1):
            if pattern.search(line):
                refs.append(f"{path}:{i}")
                if len(refs) >= 20:
                    break
    except Exception:
        pass
    return refs


def detect_routes_web(files):
    # Next.js app/ pages or legacy pages/ mapping
    routes = defaultdict(list)
    for p in files:
        rel = p.relative_to(ROOT)
        if rel.parts and rel.parts[0] == "app":
            # app/(group)/route/page.*
            if p.name.startswith("page."):
                route = "/" + "/".join(rel.parts[1:-1])
                if route == "/":
                    route = "/"
                routes[route].append(p)
        elif rel.parts and rel.parts[0] == "pages":
            if p.suffix in {".tsx", ".jsx", ".ts", ".js", ".html"}:
                route = "/" + "/".join(rel.parts[1:])
                route = re.sub(r"index\.(tsx|jsx|ts|js|html)$", "", route)
                route = re.sub(r"\.(tsx|jsx|ts|js|html)$", "", route)
                routes[route or "/"].append(p)
    return routes


def scan_files(files):
    classes = set()
    tokens = set()
    class_refs = defaultdict(list)
    token_refs = defaultdict(list)

    for p in files:
        try:
            lines = p.read_text(encoding="utf-8", errors="ignore").splitlines()
        except Exception:
            continue
        for i, line in enumerate(lines, start=1):
            for c in extract_classes(line):
                classes.add(c)
                if len(class_refs[c]) < 10:
                    class_refs[c].append(f"{p}:{i}")
            for t in extract_tokens(line):
                tokens.add(t)
                if len(token_refs[t]) < 10:
                    token_refs[t].append(f"{p}:{i}")
    return classes, tokens, class_refs, token_refs


def ensure_dirs():
    ATLAS_DIR.mkdir(parents=True, exist_ok=True)
    DOCS.mkdir(parents=True, exist_ok=True)


def write_overview(routes, classes, tokens, class_refs, token_refs, static_out_routes, token_map):
    path = DOCS / "design-atlas.md"
    with open(path, "w", encoding="utf-8") as f:
        f.write("# Design Atlas\n\n")
        f.write("Purpose: Map tokens, classes, and route-level usage to aid design/system reviews.\n\n")
        f.write("## Summary\n")
        f.write(f"- Routes detected: {len(routes)}\n")
        f.write(f"- Static pages in out/: {len(static_out_routes)}\n")
        f.write(f"- Unique classes: {len(classes)}\n")
        f.write(f"- Unique tokens: {len(tokens)}\n\n")

        if routes:
            f.write("## Routes\n")
            for route, files in sorted(routes.items()):
                slug = route.strip("/") or "root"
                f.write(f"- {route} → docs/atlas/route-{slug.replace('/', '-')}.md\n")
            f.write("\n")
        elif static_out_routes:
            f.write("## Routes (from out/)\n")
            for p in static_out_routes[:20]:
                f.write(f"- /{p.relative_to(ROOT / 'out').as_posix()} → {p}\n")
            f.write("\n")

        if classes:
            f.write("## Classes (sample)\n")
            for c in sorted(list(classes))[:50]:
                refs = ", ".join(class_refs.get(c, [])[:2])
                f.write(f"- `{c}` — {refs}\n")
            f.write("\n")

        if tokens:
            f.write("## Tokens (sample)\n")
            for t in sorted(list(tokens))[:50]:
                refs = ", ".join(token_refs.get(t, [])[:2])
                val = token_map.get(t)
                if val:
                    f.write(f"- `{t}` = {val} — {refs}\n")
                else:
                    f.write(f"- `{t}` — {refs}\n")
            f.write("\n")

        # Link to evidence screenshots if present
        evidence_dir = ROOT / ".orchestration" / "evidence"
        if evidence_dir.exists():
            imgs = list(evidence_dir.rglob("*.png")) + list(evidence_dir.rglob("*.jpg"))
            if imgs:
                f.write("## Evidence Screenshots (sample)\n")
                for img in imgs[:10]:
                    f.write(f"- {img}\n")
                f.write("\n")


def write_route_pages(routes, token_map):
    for route, files in routes.items():
        slug = route.strip("/") or "root"
        rt_path = ATLAS_DIR / f"route-{slug.replace('/', '-')}.md"
        used_classes = set()
        used_tokens = set()
        refs_classes = defaultdict(list)
        refs_tokens = defaultdict(list)

        for p in files:
            try:
                lines = p.read_text(encoding="utf-8", errors="ignore").splitlines()
            except Exception:
                continue
            for i, line in enumerate(lines, start=1):
                for c in extract_classes(line):
                    used_classes.add(c)
                    if len(refs_classes[c]) < 10:
                        refs_classes[c].append(f"{p}:{i}")
                for t in extract_tokens(line):
                    used_tokens.add(t)
                    if len(refs_tokens[t]) < 10:
                        refs_tokens[t].append(f"{p}:{i}")

        with open(rt_path, "w", encoding="utf-8") as f:
            f.write(f"# Route: {route}\n\n")
            f.write("## Files\n")
            for p in files:
                f.write(f"- {p}\n")
            f.write("\n")
            if used_classes:
                f.write("## Classes\n")
                for c in sorted(used_classes):
                    refs = ", ".join(refs_classes.get(c, [])[:3])
                    f.write(f"- `{c}` — {refs}\n")
                f.write("\n")
            if used_tokens:
                f.write("## Tokens\n")
                for t in sorted(used_tokens):
                    refs = ", ".join(refs_tokens.get(t, [])[:3])
                    val = token_map.get(t)
                    if val:
                        f.write(f"- `{t}` = {val} — {refs}\n")
                    else:
                        f.write(f"- `{t}` — {refs}\n")
                f.write("\n")


def main():
    ensure_dirs()
    files = list_source_files()
    routes = detect_routes_web(files)
    classes, tokens, class_refs, token_refs = scan_files(files)
    static_routes = list_static_routes_from_out()
    token_map = gather_css_variables()
    # Also scan out/ HTML to enrich class/token lists
    if static_routes:
        classes_out, tokens_out, class_refs_out, token_refs_out = scan_files(static_routes)
        for c in classes_out:
            if c not in classes:
                classes.add(c)
                class_refs[c] = class_refs_out.get(c, [])
            else:
                # merge refs up to 10
                merged = (class_refs.get(c, []) + class_refs_out.get(c, []))[:10]
                class_refs[c] = merged
        for t in tokens_out:
            if t not in tokens:
                tokens.add(t)
                token_refs[t] = token_refs_out.get(t, [])
            else:
                merged = (token_refs.get(t, []) + token_refs_out.get(t, []))[:10]
                token_refs[t] = merged

    write_overview(routes, classes, tokens, class_refs, token_refs, static_out_routes=static_routes, token_map=token_map)
    if routes:
        write_route_pages(routes, token_map)

    print(
        f"Design Atlas generated: routes={len(routes)} classes={len(classes)} tokens={len(tokens)}"
    )


if __name__ == "__main__":
    sys.exit(main())
