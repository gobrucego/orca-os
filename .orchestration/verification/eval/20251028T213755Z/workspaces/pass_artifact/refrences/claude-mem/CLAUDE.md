# Project Memory: claude-vibe-code

**Project Type:** AI orchestration system for Claude Code
**Last Updated:** 2025-10-26

---

## Project Goal

Build a self-improving AI orchestration system with **<5% false completion rate** (down from ~80%).

**Core problem:** Claude doesn't remember context across sessions, makes same mistakes repeatedly, and has no learning mechanism.

---

## Architecture

### Agents (50 total)

**Orchestration (4):**
- workflow-orchestrator, orchestration-reflector, playbook-curator, meta-orchestrator

**Planning (3):**
- requirement-analyst, system-architect, plan-synthesis-agent

**Quality (3):**
- verification-agent, quality-validator, test-engineer

**Implementation (2):**
- backend-engineer, infrastructure-engineer

**Design (8), Frontend (5), iOS (21)**

### Commands (14)

/orca, /ultra-think, /enhance, /concept, /visual-review, /force, /completion-drive, /memory-learn, /clarify, /session-save

### ACE Playbook System

Generator-Reflector-Curator architecture (arXiv-2510.04618v1)
- Patterns with helpful_count/harmful_count
- Apoptosis: harmful > helpful × 3 → deleted
- Evidence-First Dispatch (HARD BLOCK until verification)

---

## Tech Stack

- Next.js 14 App Router
- TypeScript
- Tailwind v4 + daisyUI 5
- SQLite (playbooks, future Workshop)

---

## Design System

**Typography:**
- GT Pantheon: Text headings, taglines
- Domaine Sans: CARD HEADINGS ONLY
- Supreme LL: Body text
- Unica77 Mono: Monospace

**ASCII Diagrams:**
- Box widths: 20, 30, 40, 60 ONLY
- 4-space grid, mathematical centering
- Chars: ┌ ┐ └ ┘ ─ │ ┬ ┴ ├ ┤ ┼ ▼

---

## Quality Gates (MANDATORY)

1. verification-agent (grep/bash verification)
2. quality-validator (evidence budget ≥5 points)
3. design-reviewer (if UI changes)
4. SELF_AUDIT_PROTOCOL (if 3+ agents or deprecations)

---

## Known Issues from 21+ Sessions

1. False completions (claiming done without evidence)
2. Tool existence ≠ usage (/visual-review not used)
3. Incremental blindness (perfect parts, broken whole)
4. Documentation drift
5. Empty native memory (CLAUDE.md was 0 bytes!)

---

## Next: Install Workshop

Per-project memory with historical import. Zero cost, zero complexity.

