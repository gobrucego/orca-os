# SEO-ORCA

Elite SEO orchestration that mirrors our iOS and data-analysis stacks: a deterministic research pipeline feeds a dedicated agent team, all mediated through ORCA’s confirmation gate. The goal is to let automation do the grinding (SERP, knowledge graph, outline, draft) so humans can focus on POV, compliance, and final polish—about 3–4 flagship pieces a month.

---

## Architecture Overview

```
Keyword / Brief Idea
        │
        ▼
┌───────────────────────────┐
│  `/seo-orca` (slash cmd)  │  ← ORCA prompts for inputs & confirms team
└─────────────┬─────────────┘
              │
              ▼
┌────────────────────────────────────────────┐
│  Specialist Pod (in execution order)       │
│  1. seo-research-specialist                │
│     • runs python pipeline                 │
│     • merges SERP + curated research + KG  │
│     • exports report / brief / draft       │
│                                             │
│  2. seo-brief-strategist                   │
│     • refines brief.md with marketing play │
│                                             │
│  3. seo-draft-writer                       │
│     • generates draft.md (LLM or heuristic)│
│                                             │
│  4. seo-quality-guardian                   │
│     • audits brief + draft, writes qa.md   │
└─────────────┬──────────────────────────────┘
              │
              ▼
┌──────────────────────────────┐
│  Human Review & Publishing   │
│  • check QA notes & TODOs    │
│  • edit draft, add citations │
│  • publish / schedule        │
└──────────────────────────────┘
```

Outputs land in `outputs/seo/<slug>-{report|brief|draft|qa}.(json|md)`.

---

## Quick Start

### The ORCA way (recommended)
Inside Claude Code run:

```bash
/seo-orca
```

When prompted, provide:
- **Primary keyword** (e.g., `Semax Selank ADHD`)
- **Research docs** (one or more paths such as `/Users/adilkalam/Desktop/OBDN/obdn_site/docs/semax-selank.md`)
- **Knowledge graph JSON** (default: `/Users/adilkalam/Desktop/OBDN/obdn_site/docs/meta/kg.json`)
- **Knowledge root directory** (default: `/Users/adilkalam/Desktop/OBDN/obdn_site`)
- **Extra focus terms** (`anxiety`, `neuroprotective`, etc.)

ORCA will propose the specialist team, you confirm, and the workflow executes automatically.

### Manual fallback (no ORCA)

```bash
python3 scripts/seo_auto_pipeline.py \
  "Semax Selank ADHD" \
  --research-doc /Users/adilkalam/Desktop/OBDN/obdn_site/docs/semax-selank.md \
  --knowledge-graph /Users/adilkalam/Desktop/OBDN/obdn_site/docs/meta/kg.json \
  --knowledge-root /Users/adilkalam/Desktop/OBDN/obdn_site \
  --focus-term anxiety \
  --focus-term neuroprotective \
  --draft
```

This produces the same artifacts without the ORCA check, useful for quick experiments or debugging.

---

## Specialist Team

| Agent | Responsibilities | Key references |
|-------|-----------------|----------------|
| **seo-research-specialist** | Runs `seo_auto_pipeline.py`, merges SERP + curated research + KG, writes report/brief/draft files | `AI Content Research and SEO on Auto-Pilot with n8n.txt`, `seo-content-planner`, KG docs |
| **seo-brief-strategist** | Polishes `*-brief.md` (outline, angles, compliance) | `seo-content-planner`, `seo-keyword-strategist`, `seo-meta-optimizer`, `seo-authority-builder` |
| **seo-draft-writer** | Generates review-ready Markdown draft with inline citations/TODOs | `seo-content-writer`, knowledge graph evidence |
| **seo-quality-guardian** | Audits brief + draft (keywords, E‑E‑A‑T, freshness), logs findings in `*-qa.md` | `seo-content-auditor`, `seo-content-refresher`, `seo-authority-builder` |

All instructions live in `agents/specialists/seo-*.md`.

---

## Outputs & Locations

After a successful run you’ll find:

| File | Purpose |
|------|---------|
| `outputs/seo/<slug>-report.json` | Full research pack (SERP summaries, insights, KG data, raw brief data) |
| `outputs/seo/<slug>-brief.json` | Structured brief for downstream tooling |
| `outputs/seo/<slug>-brief.md` | Human-friendly brief (drop into Obsidian or share with partner) |
| `outputs/seo/<slug>-draft.md` | First-pass article draft (LLM or heuristic fallback) |
| `outputs/seo/<slug>-qa.md` | QA summary & outstanding TODOs from the quality guardian |

LLM quotas: if OpenAI/Anthropic APIs are unavailable, the pipeline automatically falls back to heuristic summaries/drafts so automation never fails silently—the QA file will note the fallback.

---

## Human Responsibilities

1. **Review QA notes & TODOs** – fix flagged sections, validate claims, add missing citations.
2. **Edit the draft** – ensure tone, POV, and compliance match brand standards.
3. **Publish** – once satisfied, move the article into your CMS/Obsidian workflow, schedule social promos, etc.

Optional: record key decisions in Workshop (`/memory-search`, `/memory-learn`) so the system remembers learnings for future runs.

---

## Roadmap / Enhancements
- Swap DuckDuckGo with a Google SERP provider (SerpAPI or Bright Data) once credentials are ready.
- Add MCP integrations (Ahrefs, GSC) for richer keyword/traffic data.
- Hook the QA summary into your validation checklist (Notion/Obsidian template).
- Build “refresh” mode that reruns the workflow for existing pieces and compares against the last brief/draft.

---

## References
- `_explore/_AGENTS/marketing-SEO/*`  
- `_explore/_AGENTS/marketing-SEO/AI Content Research and SEO on Auto-Pilot with n8n.txt`  
- `_explore/_AGENTS/marketing-SEO/Ship-Learn-Next Plan - Build AI Content Automation System.md`  
- Knowledge graph: `/Users/adilkalam/Desktop/OBDN/obdn_site/docs/meta/kg.json`
