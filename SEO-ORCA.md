# SEO-ORCA: Agentic SEO Content Automation

**Status:** Rep 1 (SERP scrape + foundation)
**Orchestration:** n8n → Agent Framework (migration after Rep 3)
**Quality Philosophy:** 100% human review pre-publication with automated prioritization

---

## Executive Summary

SEO-ORCA is a five-stage agentic workflow that automates SEO content research, brief generation, and multi-agent drafting while maintaining rigorous quality gates. The system combines SERP scraping, AI research (Perplexity), keyword analysis (RapidAPI), and specialized writing agents to produce long-form, citation-backed content optimized for search ranking and E-E-A-T signals.

### The Problem

Traditional SEO content creation faces a scaling paradox: high-quality, well-researched articles that rank require 8-12 hours of human work per piece, but maintaining competitive SERP presence demands publishing 4-8 articles weekly. Teams choose between:

1. **Quality at low volume** — 2-3 excellent articles/month that rank but can't capture enough keywords
2. **Volume at low quality** — 10+ thin articles/month that damage domain authority and fail to convert
3. **Expensive hybrid** — Large content teams ($15-25K/month) producing 15-20 mixed-quality pieces

None of these approaches solve the core tension: **search engines reward depth, freshness, and authority, but producing those signals at scale is prohibitively expensive.**

### The SEO-ORCA Solution

SEO-ORCA resolves this paradox by **automating the research-intensive foundation while preserving human editorial control over final output.** The system executes the time-consuming, repeatable work (competitor analysis, keyword research, outline structuring, citation gathering) and surfaces high-quality briefs for human writers—or generates complete drafts that humans review and approve.

**Key Innovation:** Multi-layered research depth combined with enforced quality gates at every stage.

- **Stage 1-3 (Research):** Scrape top-ranking competitor content, extract structure and key points, layer AI research (Perplexity for market trends) and keyword data (search volume, competition scores). Output: comprehensive brief with citations, target keywords, and E-E-A-T requirements.
- **Stage 4 (Brief Generation):** Structured content blueprint with meta optimization (title, description, schema), governance flags (missing citations, weak authority signals), and outline validated against SEO best practices.
- **Stage 5 (Multi-Agent Drafting):** Specialized agents (headline, intro, body, conclusion, editor) produce long-form content following the brief, citing research, and maintaining natural keyword density.
- **Quality Pod:** Content Auditor + Authority Builder run automated checks (citation coverage, E-E-A-T gaps, keyword stuffing, readability) and flag issues for human review.
- **Human Review Gate:** 100% pre-publication approval with automated prioritization (YMYL content, competitor mentions, low audit scores escalate to HIGH priority; standard content flows through MEDIUM queue).

**Result:** Research depth of a senior content strategist + writing consistency of a trained editor + quality control of a brand guardian—at $2.30-$4.00 per article vs. $200-$400 for equivalent human-produced work.

### Why This Approach Works

**1. Research Grounding Prevents AI Hallucination**

Most AI content tools generate from training data alone, producing plausible-sounding but factually dubious output. SEO-ORCA grounds every article in three data layers:
- **SERP scraping:** What's currently ranking (real-time competitive intelligence)
- **Perplexity research:** Market trends, emerging terms, entity relationships
- **Keyword APIs:** Search volume, competition scores, related queries

Agents cite sources for factual claims, enabling human reviewers to verify accuracy efficiently. This research-first architecture mirrors how expert human writers work—understand the landscape before writing.

**2. Quality Gates at Pipeline Stages (Not Post-Hoc)**

Traditional automation workflows generate content first, then audit quality. SEO-ORCA builds quality checks into the pipeline:
- **Stage 2:** Outline validation (H1 → H2 → H3 hierarchy, semantic keyword integration)
- **Stage 3:** Citation capture (research findings linked to authoritative sources)
- **Stage 4:** E-E-A-T gap analysis before drafting begins (missing author credentials, weak trust signals flagged)
- **Stage 5:** Keyword density checks during generation (prevent stuffing)
- **Quality Pod:** Automated audit before human review (surface issues proactively)

This staged approach catches problems early when they're cheap to fix, rather than discovering broken content after 3000 words have been generated.

**3. Human-in-the-Loop Governance for Brand Safety**

SEO-ORCA enforces 100% human review pre-publication—automated flags prioritize attention rather than replace judgment. This prevents the catastrophic failure mode of pure automation: technically correct content that damages brand reputation or violates Google guidelines.

- **YMYL content** (health, finance, legal) requires expert reviewer with relevant credentials
- **Competitor mentions** trigger legal review for claims accuracy
- **First 10 articles** in new topic verticals undergo full editorial calibration
- **Automated flags** (missing citations, weak authority, keyword stuffing risk) escalate to HIGH priority queue with 24-hour SLA

The system generates efficiently; humans approve strategically.

**4. Cost Model Enables Experimentation**

At $2.30-$4.00 per article (vs. $200-$400 human baseline), teams can afford to:
- **Test 10 keyword variations** to identify highest-converting topics
- **Publish defensive content** for competitor terms (protect market share)
- **Build topic clusters** (30+ interlinked articles around core pillar page)
- **Refresh stale content** quarterly (maintain ranking freshness)

Low marginal cost transforms SEO from "bet on 3 hero articles" to "saturate search landscape systematically."

**5. Continuous Improvement Through Telemetry**

Every run logs cost breakdown, quality scores, execution time, and human feedback. Post-publication monitoring tracks ranking changes, traffic, and conversion. This telemetry feeds back into the system:
- **Keyword targeting refinement:** Which low-competition terms actually convert?
- **Quality threshold tuning:** Do articles scoring 7.5+ on audit rank better than 6.5+?
- **Agent prompt optimization:** Which intro structures drive higher engagement?

The system gets smarter with each article published—learning what works for your specific domain and audience.

### What Makes SEO-ORCA Novel

**Most SEO automation tools are single-stage:** keyword research OR content generation OR optimization. SEO-ORCA is **end-to-end pipeline automation** with enforced quality gates.

**Most AI writing tools are black boxes:** input keyword, output article, hope it's good. SEO-ORCA is **transparent and auditable:** every stage produces inspectable artifacts (scraped HTML, research summaries, outlines, briefs, quality scorecards). Humans review evidence, not just final output.

**Most content workflows are fire-and-forget:** publish and pray. SEO-ORCA includes **post-publication monitoring:** ranking drops trigger refresh workflows, data staleness flags articles for updates, competitor SERP feature captures prompt gap analysis.

**Most automation systems are rigid:** built for one use case, breaks when requirements change. SEO-ORCA is **composable:** n8n prototype (Rep 1-3) validates workflow logic quickly, then migrates to agent framework (Rep 4+) for unified orchestration with existing quality systems. You're not locked into a vendor—you own the architecture.

### Strategic Value

SEO-ORCA transforms SEO from a cost center to a growth engine:

- **Capture long-tail keywords** at scale (100+ articles/month economically feasible)
- **Respond to competitor content** within days (not weeks)
- **Build topical authority** systematically (comprehensive coverage signals expertise)
- **Maintain content freshness** without manual tracking (automated refresh triggers)
- **Reduce content team overhead** by 60-70% (shift humans from research to strategic review)

For organizations where organic search drives significant revenue (SaaS, e-commerce, media, professional services), SEO-ORCA compounds competitive advantage: **more content, higher quality, better targeting, faster iteration—at a fraction of traditional cost.**

### Core Principle

**Automated research + human-curated quality = scalable content that ranks.**

The system handles what machines do well (data aggregation, pattern matching, consistent execution). Humans handle what requires judgment (brand voice, strategic positioning, editorial nuance). Neither replaces the other—both operate at the top of their capability range.

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          AIRTABLE COMMAND CENTER                        │
│  Record: [Topic | Keyword | Competitors | Language | Status | Cost]    │
└────────────────┬────────────────────────────────────────────────────────┘
                 │ Button Trigger → Webhook
                 ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                        n8n ORCHESTRATION LAYER                          │
│              (Rep 1–3: Prototype | Rep 4+: Migrate to Agents)           │
└─────────────────────────────────────────────────────────────────────────┘
                 │
                 ↓
        ┌────────────────────────────────────┐
        │     FIVE-STAGE PIPELINE            │
        └────────────────────────────────────┘
                 │
    ┌────────────┼────────────┬────────────┬────────────┐
    ↓            ↓            ↓            ↓            ↓
┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐
│ Stage 1 │ │ Stage 2 │ │ Stage 3 │ │ Stage 4 │ │ Stage 5 │
│  SERP   │ │Summarize│ │ Deep    │ │ Brief   │ │Multi-   │
│ Scrape  │ │Outline  │ │Research │ │  Gen    │ │Agent    │
│         │ │         │ │         │ │         │ │ Draft   │
└────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘
     │           │           │           │           │
     └───────────┴───────────┴───────────┴───────────┘
                             │
                             ↓
                    ┌─────────────────┐
                    │   QUALITY POD   │
                    │  Auditor + Auth │
                    │     Builder     │
                    └────────┬────────┘
                             │
                             ↓
                    ┌─────────────────┐
                    │  HUMAN REVIEW   │
                    │  (100% Gate)    │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  APPROVED       │  FLAGGED
                    ↓                 ↓
            ┌──────────────┐   ┌──────────────┐
            │  Meta/Schema │   │  Review      │
            │  Optimization│   │  Queue       │
            └──────┬───────┘   └──────────────┘
                   │
                   ↓
            ┌──────────────┐
            │  Publish to  │
            │ Google Docs  │
            └──────────────┘
```

---

## Five-Stage Pipeline

### Stage 1: SERP Scrape (Rep 1)

**Objective:** Retrieve top-ranking competitor articles for target keyword.

**Implementation:**
- **Provider:** Jina (Rep 1 baseline), benchmark SerpAPI/Bright Data MCP later
- **Scrape logic:** Top 3 URLs for primary keyword
- **Storage:** Raw HTML → Airtable `raw_content` field
- **Telemetry:** Log API cost, response time, content length per run

**Agent Mapping:**
- None yet (n8n node handles scraping)
- Future: `seo-competitor-analyzer` (analyze SERP features, backlinks)

**Success Criteria:**
- ✅ 3 articles retrieved with >500 words each
- ✅ API cost logged per run
- ✅ HTML stored for inspection

---

### Stage 2: Summarization & Outline (Rep 2)

**Objective:** Extract key points, structure, and content angles from scraped articles.

**Implementation:**
- **Summarizer:** GPT-4 extracts main arguments, supporting points, citations
- **Outliner:** Generates hierarchical structure (H1 → H2 → H3 breakdown)
- **Storage:** Summary + outline → Airtable `research_summary`, `outline_json`

**Agent Mapping:**
- `seo-structure-architect` (header hierarchy, schema recommendations)
- `seo-cannibalization-detector` (flag overlapping topics)

**Success Criteria:**
- ✅ Human review of first 5 summaries confirms accuracy
- ✅ Outline follows logical H1 → H2 → H3 hierarchy
- ✅ Citations captured for factual claims

---

### Stage 3: Deep Research (Rep 3)

**Objective:** Layer Perplexity market insights + RapidAPI keyword data for comprehensive research.

**Implementation:**
- **Perplexity:** Market trends, emerging terms, related entities
- **RapidAPI Keywords:** Search volume, competition score, related queries
- **Context Enrichment:** Store findings + citations for downstream agents

**Agent Mapping:**
- `seo-keyword-strategist` (low-competition, high-volume targeting)
- `seo-authority-builder` (E-E-A-T signal identification)

**Success Criteria:**
- ✅ 10+ related keywords with volume/competition data
- ✅ 3+ external citations for authority building
- ✅ Perplexity insights stored in structured JSON

**Migration Checkpoint:** After Rep 3, evaluate orchestration migration to agent framework.

---

### Stage 4: Brief Generation (Rep 4)

**Objective:** Create structured brief with target keywords, outline, research findings, and E-E-A-T requirements.

**Implementation:**
- **Brief Schema:**
  ```json
  {
    "topic": "Primary keyword",
    "target_keywords": ["kw1", "kw2"],
    "outline": { "H1": "...", "H2": [...] },
    "research_findings": [...],
    "citations": [...],
    "eeat_requirements": {
      "author_credentials": "Required",
      "case_studies": "2 minimum",
      "trust_signals": ["SSL", "Privacy Policy"]
    },
    "meta": {
      "title": "...",
      "description": "...",
      "schema_type": "Article"
    }
  }
  ```
- **Governance Gates:** Add Content Auditor + Authority Builder checkpoints NOW
- **Storage:** Brief → Airtable `content_brief` field

**Agent Mapping:**
- `seo-meta-optimizer` (title, description, schema markup)
- `seo-content-auditor` (detect missing citations, keyword stuffing)
- `seo-authority-builder` (E-E-A-T gap analysis)

**Success Criteria:**
- ✅ Brief validates against JSON schema
- ✅ Governance flags populate (missing citations, weak authority)
- ✅ Meta fields optimized for CTR

---

### Stage 5: Multi-Agent Drafting (Rep 5)

**Objective:** Specialized agents (headline, intro, body, conclusion, editor) produce long-form content.

**Implementation:**
- **Agent Workflow:**
  1. **Headline Writer:** Generate 5 title variations (SEO + CTR optimized)
  2. **Intro Writer:** Hook + problem statement + preview (150-200 words)
  3. **Body Writers:** Section-by-section based on outline (cite research)
  4. **Conclusion Writer:** Summary + CTA
  5. **Editor Agent:** Final pass (flow, grammar, keyword density check)

**Prompt Library (Stored for Rep 5):**
- System roles, objectives, formatting rules per agent
- Example: "Body Writer: Write 300-500 words for H2 section. Include 1-2 citations. Use LSI keywords naturally."

**Agent Mapping:**
- Custom writer agents (headline, intro, body, conclusion)
- `seo-content-refresher` (update stale sections based on ranking drops)

**Success Criteria:**
- ✅ First 10 articles compared to human baseline (quality score ≥80%)
- ✅ Keyword density ≤2% (avoid stuffing)
- ✅ All factual claims have citations

---

## Quality Pod (Rep 4+)

**Purpose:** Automated checks that feed human review prioritization (not bypass).

### Content Auditor

**Checks:**
- Missing citations for factual claims
- Keyword density exceeds 2%
- Readability score below target (Flesch-Kincaid)
- Duplicate content vs. existing articles
- Header hierarchy violations (H1 → H3 without H2)

**Output:** Audit scorecard → Airtable `audit_flags` field

### Authority Builder

**Checks:**
- Author credentials missing or weak
- E-E-A-T signals incomplete (no case studies, testimonials, certifications)
- External links to low-authority domains
- Schema markup missing or invalid

**Output:** E-E-A-T scorecard → Airtable `eeat_score` field

---

## Human Review Gate (100% Mandatory)

**Philosophy:** Automated flags prioritize attention; humans approve all content pre-publication.

### Review Workflow

```
Quality Pod Output
       │
       ↓
┌──────────────────────────────────────────────────┐
│  Airtable Status: "Pending Review"              │
│  Flags: [Missing Citations, Weak Authority]     │
└────────────┬─────────────────────────────────────┘
             │
             ↓
┌──────────────────────────────────────────────────┐
│  Slack Notification to Reviewer Roster           │
│  Priority: HIGH (YMYL) | MEDIUM (Standard)       │
└────────────┬─────────────────────────────────────┘
             │
    ┌────────┴────────┐
    │ APPROVED        │  REJECTED
    ↓                 ↓
┌─────────┐      ┌─────────┐
│ Publish │      │ Revise  │
│ Queue   │      │ Queue   │
└─────────┘      └─────────┘
```

### Flagging Logic

**Automatic HIGH Priority:**
- YMYL topics (health, finance, legal)
- First 10 articles in new topic vertical
- Competitor mentions, pricing, product claims

**Automatic MEDIUM Priority:**
- Audit flags: 2+ missing citations
- E-E-A-T score <6/10
- Keyword density >1.5%

**Review SLA:**
- HIGH: 24 hours
- MEDIUM: 48 hours

**Reviewer Roster:** [Define team + escalation path]

---

## Post-Publication Monitoring (Rep 5+)

**Objective:** Detect ranking drops, penalties, or data staleness to trigger refresh cycles.

### Monitoring Triggers

| Trigger | Action | SLA |
|---------|--------|-----|
| Ranking drop >10 positions | Route to review queue for refresh | 72 hours |
| Google manual action alert | Immediate review + potential unpublish | 12 hours |
| Content age >6 months | Flag for freshness audit | 7 days |
| Competitor SERP feature capture | Analyze gap + recommend update | 14 days |

**Implementation:**
- Weekly ranking scrape (same keyword used for article creation)
- Google Search Console API for manual actions
- Airtable `last_updated` field for age tracking

**Agent Mapping:**
- `seo-content-refresher` (update stale sections)
- `seo-competitor-analyzer` (gap analysis)

---

## Ship-Learn-Next Roadmap

### Rep 1 (Week 1): SERP Scrape Foundation

**Goal:** Prove Jina scraping + Airtable integration works.

**Tasks:**
- [ ] Install n8n locally
- [ ] Wire Airtable webhook trigger
- [ ] Implement Jina SERP scraper (top 3 URLs)
- [ ] Store raw HTML in Airtable `raw_content`
- [ ] Log API cost, response time per run
- [ ] Manual inspection: Are scraped articles relevant?

**Success Metric:** 3 articles retrieved with >500 words, cost logged.

---

### Rep 2 (Week 2): Summarization & Outline

**Goal:** Extract key points and structure from scraped articles.

**Tasks:**
- [ ] Add GPT-4 summarizer node
- [ ] Generate hierarchical outline (H1 → H2 → H3)
- [ ] Store summary + outline in Airtable
- [ ] Human review first 5 summaries (calibration)
- [ ] Lock brief schema (JSON validation rules)

**Success Metric:** 5 human-approved summaries, outline follows hierarchy.

---

### Rep 3 (Week 3): Deep Research

**Goal:** Layer Perplexity + RapidAPI keyword data.

**Tasks:**
- [ ] Integrate Perplexity API (market trends, entities)
- [ ] Add RapidAPI keyword endpoint (volume, competition)
- [ ] Store findings + citations in structured JSON
- [ ] Human spot-check: Are keywords relevant? Citations valid?

**Success Metric:** 10+ keywords with data, 3+ external citations.

**Migration Checkpoint:** Evaluate orchestration migration to agent framework.

---

### Rep 4 (Week 4): Brief Generation + Quality Gates

**Goal:** Generate structured briefs with governance checkpoints.

**Tasks:**
- [ ] Implement brief generation logic (schema from Stage 4)
- [ ] Add Content Auditor checks (citations, keyword density)
- [ ] Add Authority Builder checks (E-E-A-T gaps)
- [ ] Wire Slack notifications for review queue
- [ ] Define reviewer roster + SLA

**Success Metric:** Briefs validate against schema, flags populate correctly.

---

### Rep 5 (Week 5): Multi-Agent Drafting

**Goal:** Specialized agents produce long-form content.

**Tasks:**
- [ ] Deploy headline, intro, body, conclusion, editor agents
- [ ] Load prompt library (system roles, formatting)
- [ ] Generate first 10 articles
- [ ] A/B test against human baseline (quality score)
- [ ] Enforce meta/schema tasks (Meta Optimizer, Structure Architect)

**Success Metric:** First 10 articles ≥80% quality vs. human baseline.

---

### Rep 6+ (Future): SEO MCP Integration + Migration

**Goal:** Upgrade keyword data to Ahrefs-grade, finalize orchestration migration.

**Tasks:**
- [ ] Swap RapidAPI for SEO MCP (backlinks, difficulty data)
- [ ] Migrate orchestration from n8n to agent framework
- [ ] Consolidate quality gates with existing verification systems
- [ ] Add competitor content loops
- [ ] Implement scheduling + publishing automation
- [ ] Build analytics dashboard (rankings, traffic, conversions)

**Success Metric:** Full pipeline running in agent framework with unified logging.

---

## Cost & Scale Model

### Per-Article Cost Estimate (Rep 1-3)

| Component | API/Service | Cost Range |
|-----------|-------------|------------|
| SERP Scrape (3 URLs) | Jina | $0.10 - $0.30 |
| Summarization | GPT-4 (3 articles) | $0.15 - $0.25 |
| Perplexity Research | Perplexity API | $0.20 - $0.40 |
| Keyword Data | RapidAPI | $0.05 - $0.10 |
| Brief Generation | GPT-4 | $0.10 - $0.15 |
| **Total (before drafting)** | | **$0.60 - $1.20** |

### Per-Article Cost Estimate (Rep 5+)

| Component | API/Service | Cost Range |
|-----------|-------------|------------|
| Research (Stages 1-4) | See above | $0.60 - $1.20 |
| Multi-Agent Drafting (5 agents) | GPT-4 (2000-3000 tokens/agent) | $1.50 - $2.50 |
| Quality Pod Checks | GPT-4 (audit + authority) | $0.20 - $0.30 |
| **Total (end-to-end)** | | **$2.30 - $4.00** |

**Acceptable Threshold:** $5/article (leaves room for SEO MCP upgrade in Rep 6).

---

## Migration Strategy (After Rep 3)

### Why Migrate to Agent Framework?

**Current State (n8n):**
- ✅ Visual workflow builder (accessible to non-developers)
- ✅ Fast prototyping for Reps 1-3
- ❌ Parallel orchestration system (fragmented from main agents)
- ❌ Quality gates not unified with existing verification systems
- ❌ Logging/telemetry duplicated

**Future State (Agent Framework):**
- ✅ Unified orchestration with `/orca`
- ✅ Quality gates shared with verification-agent, quality-validator
- ✅ Workshop memory integration (decisions, gotchas tracked)
- ✅ ACE Playbooks (learn from SEO workflow outcomes)
- ❌ Requires developer setup (less accessible than n8n UI)

### Migration Checklist

**Pre-Migration (Rep 3 Completion):**
- [ ] Document n8n workflow logic (node configs, API keys)
- [ ] Export Airtable schema (fields, relationships)
- [ ] Archive Rep 1-3 telemetry (cost logs, quality scores)
- [ ] Define agent roles (map n8n nodes → agent specialists)

**Migration Phase (Rep 4):**
- [ ] Create `seo-orca-orchestrator` agent (coordinates 5 stages)
- [ ] Port SERP scrape logic to `seo-competitor-analyzer` agent
- [ ] Port summarization to `seo-structure-architect` agent
- [ ] Port research to `seo-keyword-strategist` + `seo-authority-builder`
- [ ] Wire Airtable sync to context-manager (bidirectional)

**Post-Migration Validation:**
- [ ] Run parallel workflows (n8n vs. agent framework) for 5 articles
- [ ] Compare cost, quality, completion time
- [ ] Human review confirms output parity
- [ ] Decommission n8n if parity achieved

**Rollback Plan:** Keep n8n workflow as backup for Rep 4-5 if migration blockers emerge.

---

## Integration Points

### Airtable ↔ Context Manager

**Sync Logic:**
- Airtable record triggers webhook → `/orca` reads context from Airtable
- Context Manager enriches with business goals, personas, KPIs
- Agents write back: status, flags, cost, output → Airtable fields update

**Schema Alignment:**
```
Airtable Fields         Context Manager Fields
─────────────────       ──────────────────────
topic                → target_keyword
keyword              → primary_term
competitors          → competitor_urls[]
language             → locale
status               → workflow_state
research_summary     → context.research
content_brief        → context.brief
audit_flags          → quality_checks[]
eeat_score           → authority_score
cost_total           → telemetry.cost
```

### SEO MCP Integration (Rep 6)

**Current:** RapidAPI provides basic keyword volume/competition.

**Future:** SEO MCP provides:
- Backlink profiles
- Domain authority scores
- Keyword difficulty (Ahrefs-grade)
- SERP feature analysis
- Content gap detection

**Agent Mapping:**
- `seo-keyword-strategist` upgrades from RapidAPI → SEO MCP
- `seo-competitor-analyzer` gains backlink analysis

---

## Governance & Compliance

### YMYL (Your Money Your Life) Content

**Definition:** Health, finance, legal, safety topics where incorrect information causes harm.

**Mandatory Controls:**
1. **100% human review** (no auto-publish)
2. **Expert reviewer required** (credentials in relevant field)
3. **Citation verification** (all facts traced to authoritative sources)
4. **Medical/legal disclaimer** (auto-inserted by Meta Optimizer)

**Flagging Logic:**
- Topic keywords match YMYL list → Auto-flag HIGH priority
- Content Auditor detects medical/financial claims → Escalate to expert reviewer

### Brand-Critical Content

**Definition:** Competitor mentions, pricing, product comparisons.

**Mandatory Controls:**
1. **Legal review** for competitor claims
2. **Fact-checking** for pricing accuracy
3. **Tone audit** (brand voice consistency)

**Flagging Logic:**
- Competitor name detected → Flag for legal review
- Pricing mentioned → Verify against product team source of truth

### Google Guidelines Compliance

**Automated Checks:**
- Keyword density ≤2% (avoid stuffing)
- No cloaking (content matches meta description)
- No scraped content (plagiarism check vs. SERP sources)
- Mobile-friendly (schema validation)

**Manual Checks:**
- Helpful content (human confirms value add)
- Original insights (not rehashed competitor content)

---

## Agent Roster (Mapped to Pipeline)

### Research Pod (Stages 1-3)

| Agent | Role | Tools | Rep |
|-------|------|-------|-----|
| `seo-competitor-analyzer` | SERP scrape + backlink analysis | Jina, Bright Data MCP | Rep 1 |
| `seo-structure-architect` | Summarization + outline generation | GPT-4, Header hierarchy rules | Rep 2 |
| `seo-keyword-strategist` | Keyword research + low-comp targeting | RapidAPI → SEO MCP (Rep 6) | Rep 3 |
| `seo-authority-builder` | E-E-A-T signal identification | Perplexity, Citation validator | Rep 3 |

### Brief Generation Pod (Stage 4)

| Agent | Role | Tools | Rep |
|-------|------|-------|-----|
| `seo-meta-optimizer` | Title, description, schema markup | GPT-4, Schema.org validator | Rep 4 |
| `seo-content-auditor` | Detect quality issues (citations, stuffing) | GPT-4, Readability analyzer | Rep 4 |
| `seo-cannibalization-detector` | Flag overlapping topics | Vector similarity search | Rep 4 |

### Writing Pod (Stage 5)

| Agent | Role | Tools | Rep |
|-------|------|-------|-----|
| Custom writer agents | Headline, intro, body, conclusion, editor | GPT-4, Prompt library | Rep 5 |
| `seo-content-refresher` | Update stale sections (post-pub) | GPT-4, Ranking delta analysis | Rep 6 |

### Orchestration Pod

| Agent | Role | Tools | Rep |
|-------|------|-------|-----|
| `seo-orca-orchestrator` | Coordinates 5-stage pipeline | `/orca`, Airtable sync | Rep 4 (migration) |
| `workflow-orchestrator` | Generic multi-agent dispatch | Task tool, verification gates | Rep 4 (migration) |

---

## Telemetry & Observability

### Per-Run Metrics (Logged to Airtable)

```json
{
  "run_id": "uuid",
  "keyword": "target keyword",
  "stage_completed": "Stage 3: Deep Research",
  "cost_breakdown": {
    "serp_scrape": 0.25,
    "summarization": 0.20,
    "research": 0.35,
    "total": 0.80
  },
  "quality_scores": {
    "audit_score": 7.5,
    "eeat_score": 6.2
  },
  "flags": ["missing_citations", "weak_authority"],
  "execution_time_sec": 142,
  "timestamp": "2025-11-05T10:30:00Z"
}
```

### Dashboard Metrics (Rep 6+)

**Research Quality:**
- Average citations per article
- Keyword relevance score (human-rated first 10)
- Research depth (Perplexity insights used %)

**Content Quality:**
- Audit score distribution (histogram)
- E-E-A-T score trend (over time)
- Human approval rate (% approved first pass)

**Operational:**
- Cost per article (trend)
- Execution time per stage (bottleneck analysis)
- API failure rate (Jina, Perplexity, RapidAPI)

**SEO Performance (Post-Publication):**
- Average ranking position (weeks 1, 4, 12)
- Click-through rate (from GSC)
- Ranking drop incidents (>10 positions)

---

## Risk Mitigation

### Risk 1: False Confidence in Automated Quality

**Symptom:** Content passes Quality Pod but fails to rank or damages brand.

**Mitigation:**
- **Human baseline:** A/B test first 10 articles vs. human-written (Rep 5)
- **Calibration loop:** Update Quality Pod thresholds based on human feedback
- **100% review gate:** No auto-publish, even if scores are high

**Success Metric:** <5% of published articles require major revisions post-publication.

---

### Risk 2: Data Staleness

**Symptom:** SERP rankings shift; scraped "top 3" outdated within weeks.

**Mitigation:**
- **Refresh triggers:** Weekly ranking scrape → flag if article drops >10 positions
- **Content age monitoring:** Flag articles >6 months for freshness audit
- **Competitor alerts:** New SERP features trigger gap analysis

**Success Metric:** Articles maintain top-10 ranking for 90 days (or refresh cycle triggered).

---

### Risk 3: Orchestration Fragmentation

**Symptom:** n8n runs in parallel to agent framework; logs/quality gates duplicated.

**Mitigation:**
- **Migration checkpoint:** Hard cutoff after Rep 3 to evaluate migration
- **Parallel validation:** Run both systems for 5 articles to confirm parity
- **Rollback plan:** Keep n8n as backup if migration blockers emerge

**Success Metric:** Single orchestration layer by Rep 6 (or documented decision to keep both).

---

### Risk 4: Cost Overrun

**Symptom:** $5/article threshold exceeded due to API call bloat.

**Mitigation:**
- **Per-run telemetry:** Log cost breakdown by stage (catch spikes early)
- **Provider benchmarking:** Rep 1 tests Jina; swap to cheaper provider if needed
- **Token budgets:** Set max tokens per agent (prevent runaway generation)

**Success Metric:** Average cost per article ≤$4 by Rep 5 (leaves buffer for Rep 6 upgrades).

---

### Risk 5: YMYL Compliance Failure

**Symptom:** Medical/legal content published without expert review.

**Mitigation:**
- **YMYL keyword list:** Auto-flag topics (health, finance, legal)
- **Expert reviewer roster:** Credentials verified for YMYL reviews
- **Mandatory disclaimer:** Meta Optimizer auto-inserts legal boilerplate

**Success Metric:** Zero YMYL articles published without expert approval.

---

## Open Questions (Updated)

### Resolved

✅ **Orchestration Layer:** Build Rep 1-3 in n8n, migrate to agent framework after Rep 3.
✅ **SERP Provider:** Start with Jina (Rep 1), benchmark SerpAPI/Bright Data MCP later.
✅ **Human Review:** 100% mandatory pre-publication; automated flags prioritize attention.

### Pending

- **Reviewer Roster:** Who owns YMYL reviews? What credentials required?
- **Review SLA:** Can we commit to 24-hour turnaround for HIGH priority?
- **Migration Timing:** Migrate during Rep 4 or wait until Rep 6 (SEO MCP integration)?
- **Post-Pub Monitoring:** Which ranking tracker API (SEMrush, Ahrefs, custom)?

---

## Next Actions (This Week)

### Rep 1 Tasks

1. **Spin up n8n + Jina workflow**
   - [ ] Install n8n locally
   - [ ] Configure Airtable webhook
   - [ ] Implement Jina scraper (top 3 URLs)
   - [ ] Test with 3 keywords, capture telemetry

2. **Draft migration plan outline**
   - [ ] Map n8n nodes → agent roles
   - [ ] Define Airtable ↔ Context Manager schema
   - [ ] Document rollback strategy

3. **Define reviewer workflow**
   - [ ] Identify reviewer roster + credentials
   - [ ] Wire review state into Airtable
   - [ ] Set up Slack notifications (HIGH/MEDIUM priority)

4. **Set up post-publication monitors**
   - [ ] Weekly ranking scrape (same keyword as article)
   - [ ] Google Search Console API for manual actions
   - [ ] Airtable `last_updated` field for age tracking

---

## Documentation Index

**Core System:**
- Main README: `/README.md` (Vibe Code orchestration overview)
- This Document: `/SEO-ORCA.md` (SEO workflow specifics)

**Agent Definitions:**
- Research Pod: `_explore/_AGENTS/Marketing-SEO/`
- Quality Pod: `agents/specialists/seo-*`

**Workflow References:**
- n8n Workflow: `_explore/_AGENTS/Marketing-SEO/AI Content Research and SEO on Auto-Pilot with n8n.txt`
- Ship-Learn-Next Plan: `_explore/_AGENTS/Marketing-SEO/Ship-Learn-Next Plan - Build AI Content Automation System.md`

**Integration Guides:**
- SEO MCP: `_explore/_AGENTS/marketing-SEO/seo-mcp/README.md`
- Context Manager: `.orchestration/context-manager/`
- Airtable Schema: [TBD - document after Rep 1]

---

## Key Principles

1. **Automated research, human-curated quality** — Let agents gather data; humans approve output.
2. **Evidence-based decisions** — Log cost, quality, time; optimize based on telemetry.
3. **Incremental validation** — Ship-Learn-Next reps prove each stage before building next.
4. **Quality gates early** — Add governance in Rep 4 (before drafting), not after Rep 5.
5. **Migration at stable point** — Move orchestration when foundation is proven (Rep 3 checkpoint).

---

**Last Updated:** 2025-11-05
**Status:** Rep 1 in progress
**Next Review:** After Rep 3 (migration checkpoint)
