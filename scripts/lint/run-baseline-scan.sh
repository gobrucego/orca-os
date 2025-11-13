#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

echo "Baseline scan: inline styles, utility classes, raw hex colors, px units"

has_rg() { command -v rg >/dev/null 2>&1; }
if ! has_rg; then
  echo "ripgrep (rg) not found. Please install rg to run baseline scan." >&2
  exit 2
fi

echo
echo "1) Inline styles (JSX/TSX/HTML)"
rg -n --no-ignore-vcs -S \
  --glob "!**/node_modules/**" --glob "!**/.next/**" --glob "!**/dist/**" --glob "!**/build/**" \
  --glob "**/*.{tsx,jsx,ts,js,html}" "\bstyle\s*=\s*(\{\{|\")" | tee /tmp/baseline_inline.txt || true
INLINE_COUNT=$(wc -l </tmp/baseline_inline.txt | tr -d ' ')
echo "Total inline style occurrences: $INLINE_COUNT"

echo
echo "2) Utility-like classes (Tailwind patterns)"
# Search only within class/className attribute values for common utility-like tokens
rg -n --no-ignore-vcs -S \
  --glob "!**/node_modules/**" --glob "!**/.next/**" --glob "!**/dist/**" --glob "!**/build/**" \
  --glob "**/*.{tsx,jsx,ts,js,html}" -e "\bclass(Name)?\s*=\s*['\"][^'\"]+" \
  | rg -e "\b(p|m|px|py|pt|pr|pb|pl|mx|my|text|bg|rounded|shadow|w|h|min-|max-|z-|leading|tracking|place-|content-|self-|order|col-|row-)[A-Za-z0-9\[\]-]+" \
  | tee /tmp/baseline_utils.txt || true
UTIL_COUNT=$(wc -l </tmp/baseline_utils.txt | tr -d ' ')
echo "Total utility-like class occurrences: $UTIL_COUNT"

echo
echo "3) Raw hex colors (#rrggbb/rgba hex) in CSS/JSX"
rg -n --no-ignore-vcs -S \
  --glob "!**/node_modules/**" --glob "!**/.next/**" --glob "!**/dist/**" --glob "!**/build/**" \
  --glob "**/*.{css,scss,sass,tsx,jsx,ts,js,html}" "#[0-9a-fA-F]{3,8}\b" | tee /tmp/baseline_hex.txt || true
HEX_COUNT=$(wc -l </tmp/baseline_hex.txt | tr -d ' ')
echo "Total raw hex occurrences: $HEX_COUNT"

echo
echo "4) px units in CSS files (may include legitimate cases)"
rg -n --no-ignore-vcs -S \
  --glob "!**/node_modules/**" --glob "!**/.next/**" --glob "!**/dist/**" --glob "!**/build/**" \
  --glob "**/*.{css,scss,sass}" ":\s*[^;]*\d+px\b" | tee /tmp/baseline_px.txt || true
PX_COUNT=$(wc -l </tmp/baseline_px.txt | tr -d ' ')
echo "Total px unit occurrences (CSS): $PX_COUNT"

echo
echo "Top offenders — inline styles (first 10 files):"
cut -d: -f1 /tmp/baseline_inline.txt | sort | uniq -c | sort -nr | head -10 || true

echo
echo "Top offenders — utility-like classes (first 10 files):"
cut -d: -f1 /tmp/baseline_utils.txt | sort | uniq -c | sort -nr | head -10 || true

echo
echo "Baseline scan complete. Use ESLint/Stylelint/html-validate for full gates when dependencies are installed."
