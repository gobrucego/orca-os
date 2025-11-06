#!/usr/bin/env python3
"""
Lightweight SEO research pipeline.

Steps:
1. Retrieve top search results for the target keyword (DuckDuckGo).
2. Fetch and extract readable article text (trafilatura).
3. Generate concise summaries and heuristic insight phrases.
4. Aggregate keyword suggestions from extracted content.
5. Persist a structured JSON report for downstream agents.

This script intentionally avoids proprietary APIs so it can run end-to-end
without vendor credentials. It is a thin prototype for the richer multi-agent
workflow described in the marketing-SEO plan.
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import pathlib
import re
import sys
from collections import Counter
from typing import Any, Dict, List, Optional, Sequence, Tuple

import requests
import trafilatura
from anthropic import Anthropic
from ddgs import DDGS
from openai import OpenAI


ROOT = pathlib.Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "seo"
STOPWORDS = {
    "the",
    "and",
    "for",
    "with",
    "that",
    "from",
    "this",
    "into",
    "about",
    "your",
    "have",
    "their",
    "will",
    "such",
    "which",
    "when",
    "been",
    "within",
    "while",
    "where",
    "should",
    "these",
    "those",
    "because",
    "through",
    "using",
    "between",
    "during",
    "before",
    "after",
    "could",
    "would",
    "there",
    "other",
    "over",
    "even",
    "than",
    "each",
    "some",
    "most",
    "also",
    "more",
}
USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
    "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
)


OPENAI_CLIENT: Optional[OpenAI] = OpenAI() if os.getenv("OPENAI_API_KEY") else None
ANTHROPIC_CLIENT: Optional[Anthropic] = (
    Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY")) if os.getenv("ANTHROPIC_API_KEY") else None
)

GPT_SUMMARIZER_MODEL = os.getenv("SEO_GPT_SUMMARIZER_MODEL", "gpt-5")
GPT_RESEARCH_MODEL = os.getenv("SEO_GPT_RESEARCH_MODEL", "gpt-5")
SONNET_MODEL = os.getenv("SEO_SONNET_MODEL", "claude-3-5-sonnet-20241022")
MAX_SECTION_CHARACTERS = int(os.getenv("SEO_SUMMARY_CHAR_LIMIT", "6000"))


def log(msg: str) -> None:
    ts = dt.datetime.now().strftime("%H:%M:%S")
    print(f"[{ts}] {msg}", file=sys.stderr)


def search_articles(keyword: str, max_results: int = 10) -> List[Dict[str, str]]:
    """Fetch top search results using DuckDuckGo (no API key required)."""
    log(f"Searching DuckDuckGo for '{keyword}' …")
    records: List[Dict[str, str]] = []
    with DDGS(verify=False) as ddgs:
        generator = ddgs.text(
            keyword,
            region="wt-wt",
            safesearch="moderate",
            timelimit="m",
            max_results=max_results,
        )
        for result in generator:
            href = result.get("href")
            title = result.get("title") or ""
            snippet = result.get("body") or ""
            if not href or not title:
                continue
            records.append(
                {
                    "title": title.strip(),
                    "url": href.strip(),
                    "snippet": snippet.strip(),
                }
            )
    log(f"Retrieved {len(records)} search hits.")
    return records


def fetch_article_text(url: str) -> Optional[str]:
    """Download and extract the main article text from a URL."""
    try:
        response = requests.get(url, headers={"User-Agent": USER_AGENT}, timeout=20)
        response.raise_for_status()
    except requests.RequestException as exc:
        log(f"⚠️  Failed to fetch {url}: {exc}")
        return None

    downloaded = trafilatura.extract(
        response.text,
        include_comments=False,
        include_images=False,
        include_tables=False,
    )
    if not downloaded:
        log(f"⚠️  Could not extract readable text from {url}")
    return downloaded


def summarize_text(text: str, sentences: int = 5) -> str:
    """Basic summarization by selecting the most information-dense sentences."""
    sentence_candidates = re.split(r"(?<=[.!?])\s+", text.strip())
    unique_sentences: List[str] = []
    for sent in sentence_candidates:
        cleaned = sent.strip()
        if not cleaned:
            continue
        if cleaned.lower() not in (s.lower() for s in unique_sentences):
            unique_sentences.append(cleaned)
    if not unique_sentences:
        return ""
    # Rank sentences by length as a lightweight proxy for information density.
    ranked = sorted(unique_sentences, key=lambda s: len(s), reverse=True)
    selected = sorted(ranked[:sentences], key=lambda s: unique_sentences.index(s))
    return " ".join(selected)


def split_sentences(text: str) -> List[str]:
    sentences = re.split(r"(?<=[.!?])\s+", text.strip())
    return [s.strip() for s in sentences if s.strip()]


def simple_summary(text: str, max_sentences: int = 3) -> str:
    sentences = split_sentences(text)
    if not sentences:
        return text.strip()[:280]
    return " ".join(sentences[:max_sentences])


def parse_markdown_sections(text: str, max_sections: int = 12) -> List[Dict[str, Any]]:
    """
    Split markdown into sections keyed by headings.
    Returns up to `max_sections` entries with heading, level, summary, and raw content.
    """
    pattern = re.compile(r"^(#{1,6})\s+(.*)", re.MULTILINE)
    matches = list(pattern.finditer(text))
    sections: List[Dict[str, Any]] = []

    if not matches:
        return [
            {
                "heading": "Overview",
                "level": 1,
                "summary": simple_summary(text),
                "content": text.strip(),
            }
        ]

    for idx, match in enumerate(matches):
        heading_level = len(match.group(1))
        heading_text = match.group(2).strip()
        start = match.end()
        end = matches[idx + 1].start() if idx + 1 < len(matches) else len(text)
        section_body = text[start:end].strip()
        if not section_body:
            continue
        sections.append(
            {
                "heading": heading_text,
                "level": heading_level,
                "summary": simple_summary(section_body),
                "content": section_body,
            }
        )
        if len(sections) >= max_sections:
            break
    return sections


def extract_insights(text: str, max_phrases: int = 12) -> List[str]:
    """Extract n-gram based insight phrases from the corpus."""
    tokens = [
        tok for tok in re.findall(r"[A-Za-z][A-Za-z\-]+", text.lower()) if tok not in STOPWORDS
    ]
    phrase_counts: Counter[str] = Counter()

    def add_ngrams(n: int) -> None:
        for i in range(len(tokens) - n + 1):
            window = tokens[i : i + n]
            if any(len(word) <= 3 for word in window):
                continue
            phrase_counts[" ".join(window)] += 1

    add_ngrams(3)
    add_ngrams(2)

    candidates = [phrase for phrase, _ in phrase_counts.most_common(max_phrases * 3)]
    insights: List[str] = []
    for phrase in candidates:
        pretty = phrase.title()
        if pretty in insights:
            continue
        insights.append(pretty)
        if len(insights) >= max_phrases:
            break
    return insights


def suggest_keywords(text: str, top_n: int = 20) -> List[Dict[str, Any]]:
    """Generate keyword suggestions using word frequency heuristics."""
    tokens = re.findall(r"[A-Za-z][A-Za-z\-]+", text.lower())
    filtered = [tok for tok in tokens if tok not in STOPWORDS and len(tok) > 3]
    counts = Counter(filtered)
    suggestions = []
    for keyword, score in counts.most_common(top_n):
        suggestions.append(
            {
                "keyword": keyword,
                "score": score,
            }
        )
    return suggestions


def build_outline(keyword: str, insights: List[str]) -> List[str]:
    """Create a lightweight outline using the top insight phrases."""
    outline = [
        f"Introduction: Overview of {keyword}",
    ]
    for phrase in insights[:4]:
        title = phrase
        title = re.sub(r"^[0-9]+\s*", "", title)
        title = title.capitalize()
        outline.append(title)
    outline.append("Conclusion and next steps")
    return outline


def gpt_summarize_article(keyword: str, title: str, text: str) -> Optional[Dict[str, Any]]:
    """Use GPT-5 (or configured model) to generate summary and key takeaways."""
    if not OPENAI_CLIENT:
        return None
    snippet = text[:MAX_SECTION_CHARACTERS]
    prompt = (
        "You are an SEO content strategist. Read the article excerpt below and produce:\n"
        "1) A concise 4-6 sentence summary highlighting the central message.\n"
        "2) 5 bullet key takeaways (actionable, fact-oriented).\n"
        "3) Tone notes in 1-2 sentences (e.g., authoritative, clinical, promotional).\n\n"
        f"Target keyword: {keyword}\n"
        f"Article title: {title}\n"
        "Article content:\n"
        "-----------------\n"
        f"{snippet}\n"
        "-----------------\n"
        "Respond strictly as JSON with fields summary, key_takeaways (array), tone."
    )
    try:
        response = OPENAI_CLIENT.responses.create(
            model=GPT_SUMMARIZER_MODEL,
            input=prompt,
            max_output_tokens=600,
        )
        text_output = response.output_text
        data = json.loads(text_output)
        if not isinstance(data, dict):
            raise ValueError("Unexpected GPT summary format.")
        return {
            "summary": data.get("summary", "").strip(),
            "key_takeaways": data.get("key_takeaways", []),
            "tone": data.get("tone", "").strip(),
            "model": GPT_SUMMARIZER_MODEL,
        }
    except Exception as exc:  # pylint: disable=broad-except
        log(f"⚠️  GPT summarizer failed ({exc}); falling back to heuristic summary.")
        return None


def load_curated_research(keyword: str, research_paths: Optional[Sequence[str]]) -> List[Dict[str, Any]]:
    """Load curated research markdown docs and summarize their contents."""
    if not research_paths:
        return []
    entries: List[Dict[str, Any]] = []
    for raw_path in research_paths:
        path = pathlib.Path(raw_path).expanduser()
        if not path.exists():
            log(f"⚠️  Research doc not found: {path}")
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except Exception as exc:  # pylint: disable=broad-except
            log(f"⚠️  Failed to read research doc {path}: {exc}")
            continue

        gpt_summary = gpt_summarize_article(keyword, path.name, text)
        summary = gpt_summary["summary"] if gpt_summary and gpt_summary.get("summary") else summarize_text(text)
        entry = {
            "title": path.stem.replace("_", " ").title(),
            "path": str(path),
            "summary": summary,
            "key_takeaways": gpt_summary.get("key_takeaways", []) if gpt_summary else [],
            "tone_notes": gpt_summary.get("tone", "") if gpt_summary else "",
            "sections": parse_markdown_sections(text),
        }
        entries.append(entry)
    return entries


def load_file_excerpt(path: pathlib.Path, line_number: Optional[int], context: int = 2) -> Optional[str]:
    if not path or not path.exists():
        return None
    try:
        text = path.read_text(encoding="utf-8")
    except Exception:
        return None
    lines = text.splitlines()
    if not lines:
        return None
    if not line_number or line_number <= 0:
        return "\n".join(lines[: context * 2 + 1]).strip()
    idx = min(len(lines) - 1, max(0, line_number - 1))
    start = max(0, idx - context)
    end = min(len(lines), idx + context + 1)
    return "\n".join(lines[start:end]).strip()


def load_knowledge_graph(
    kg_path: Optional[str], focus_terms: Sequence[str], base_root: Optional[str] = None
) -> Optional[Dict[str, Any]]:
    """Extract knowledge graph nodes/edges relevant to focus terms."""
    if not kg_path:
        return None
    path = pathlib.Path(kg_path).expanduser()
    if not path.exists():
        log(f"⚠️  Knowledge graph file not found: {path}")
        return None

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:  # pylint: disable=broad-except
        log(f"⚠️  Failed to parse knowledge graph: {exc}")
        return None

    focus_terms_clean = sorted({term.lower() for term in focus_terms if term})
    if not focus_terms_clean:
        return None

    nodes = data.get("nodes", [])
    edges = data.get("edges", [])
    node_map = {node["id"]: node for node in nodes}

    def term_matches(value: str) -> bool:
        lower = value.lower()
        return any(term in lower for term in focus_terms_clean)

    relevant_nodes = {
        node_id: node
        for node_id, node in node_map.items()
        if term_matches(node_id) or term_matches(node.get("label", ""))
    }

    related_edges = []
    neighbor_ids = set()
    root_base = pathlib.Path(base_root).expanduser() if base_root else path.parents[2]

    for edge in edges:
        source = edge.get("source", "")
        target = edge.get("target", "")
        relation = edge.get("relation", "")
        edge_relevant = (
            source in relevant_nodes
            or target in relevant_nodes
            or term_matches(source)
            or term_matches(target)
            or term_matches(relation)
        )
        if not edge_relevant:
            continue

        neighbor_ids.add(source)
        neighbor_ids.add(target)

        evidence = edge.get("evidence")
        snippet = None
        if evidence:
            file_part, _, line_part = evidence.partition(":")
            try:
                line_number = int(line_part) if line_part else None
            except ValueError:
                line_number = None
            evidence_path = root_base / file_part if file_part else None
            snippet = load_file_excerpt(evidence_path, line_number) if evidence_path else None
        related_edges.append(
            {
                "source": source,
                "target": target,
                "relation": relation,
                "evidence": evidence,
                "evidence_excerpt": snippet,
            }
        )

    neighbor_nodes = {
        nid: node_map[nid]
        for nid in neighbor_ids
        if nid in node_map and nid not in relevant_nodes
    }

    def serialize_node(node: Dict[str, Any]) -> Dict[str, Any]:
        serialized = {
            "id": node.get("id"),
            "label": node.get("label"),
            "type": node.get("type"),
            "source": node.get("source"),
        }
        source = node.get("source")
        if source:
            file_part, _, line_part = source.partition(":")
            try:
                line_number = int(line_part) if line_part else None
            except ValueError:
                line_number = None
            evidence_path = root_base / file_part if file_part else None
            excerpt = load_file_excerpt(evidence_path, line_number) if evidence_path else None
            if excerpt:
                serialized["source_excerpt"] = excerpt
        return serialized

    return {
        "focus_terms": focus_terms_clean,
        "nodes": [serialize_node(node) for node in relevant_nodes.values()],
        "neighbor_nodes": [serialize_node(node) for node in neighbor_nodes.values()],
        "relations": related_edges,
        "notes": data.get("notes"),
        "generated_at": data.get("generated_at"),
    }


def gpt_research_brief(keyword: str, combined_summary: str, insights: List[str]) -> Optional[Dict[str, Any]]:
    """Generate deep-dive research prompts and POV using GPT-5 Pro (OpenAI)."""
    if not OPENAI_CLIENT:
        return None
    joined_insights = ", ".join(insights[:10])
    prompt = (
        "You are an SEO strategist preparing to brief a writer on an article.\n"
        "Given the existing research summary and insight list, produce:\n"
        "- A paragraph 'market_context' describing why the topic matters now.\n"
        "- A bullet list 'angles_to_cover' (<=5) focusing on differentiation opportunities.\n"
        "- A bullet list 'questions_to_answer' (3-5) that the article must address.\n"
        "- A bullet list 'data_points_to_hunt' suggesting statistics or proof points worth sourcing.\n"
        f"Primary keyword: {keyword}\n"
        f"Existing combined summary:\n{combined_summary}\n"
        f"Insight phrases: {joined_insights}\n"
        "Return strictly as JSON with the fields described above."
    )
    try:
        response = OPENAI_CLIENT.responses.create(
            model=GPT_RESEARCH_MODEL,
            input=prompt,
            max_output_tokens=700,
        )
        return json.loads(response.output_text)
    except Exception as exc:  # pylint: disable=broad-except
        log(f"⚠️  GPT research brief failed ({exc}); skipping.")
        return None


def sonnet_research_addendum(keyword: str, combined_summary: str, insights: List[str]) -> Optional[Dict[str, Any]]:
    """Use Claude 4.5 Sonnet to surface narrative hooks and caution flags."""
    if not ANTHROPIC_CLIENT:
        return None
    joined_insights = "; ".join(insights[:10])
    prompt = (
        "You are an editorial strategist partnering with a human writer on a long-form SEO article.\n"
        "Review the summary and insight list and respond in JSON with:\n"
        "- storytelling_hooks: array of up to 4 narrative angles, each 1 sentence.\n"
        "- risk_flags: array of cautions (compliance, medical, legal) the writer must note.\n"
        "- expert_sources: array naming people/roles or organizations worth quoting/interviewing.\n"
        "- refresh_triggers: array of signals that should prompt a future content update.\n"
        f"Keyword: {keyword}\n"
        f"Combined summary:\n{combined_summary}\n"
        f"Insight phrases: {joined_insights}\n"
        "Respond only with JSON."
    )
    try:
        response = ANTHROPIC_CLIENT.messages.create(
            model=SONNET_MODEL,
            max_output_tokens=700,
            system="You build thoughtful editorial plans that balance SEO ambition with brand integrity.",
            messages=[{"role": "user", "content": prompt}],
        )
        # Anthropic returns list of content blocks; pull text
        text_chunks = []
        for block in response.content:
            if block.type == "text":
                text_chunks.append(block.text)
        if not text_chunks:
            raise ValueError("Unexpected Sonnet response format.")
        return json.loads("".join(text_chunks))
    except Exception as exc:  # pylint: disable=broad-except
        log(f"⚠️  Sonnet research addendum failed ({exc}); skipping.")
        return None


def generate_brief(
    keyword: str,
    outline: List[str],
    combined_summary: str,
    combined_insights: List[str],
    keyword_suggestions: List[Dict[str, Any]],
    research_brief: Dict[str, Any],
    curated_research: List[Dict[str, Any]],
    knowledge_graph: Optional[Dict[str, Any]],
) -> Dict[str, Any]:
    """Assemble a structured brief for human review."""
    secondary_keywords = [entry["keyword"] for entry in keyword_suggestions[:8]]

    base_terms = [term for term in re.split(r"\s+", keyword) if term]
    pair_label = " & ".join(base_terms[:2]) if len(base_terms) >= 2 else keyword
    topic_label = keyword.title()

    title_options = [
        f"{topic_label}: Evidence-Based Alternatives for ADHD and Anxiety",
        f"How {pair_label} Support Focus and Calm Without Stimulants",
        f"{pair_label} Guide: Mechanisms, Dosing, and Safety for ADHD & Anxiety",
    ]

    meta_seed = combined_summary or " ".join(combined_insights[:3])
    meta_description = simple_summary(meta_seed, max_sentences=2)
    if len(meta_description) > 156:
        meta_description = meta_description[:153].rstrip() + "…"

    structure = []
    for idx, heading in enumerate(outline):
        note = combined_insights[idx] if idx < len(combined_insights) else ""
        structure.append({"heading": heading, "focus": note})

    angles = research_brief.get("angles_to_cover") or combined_insights[:4]
    questions = research_brief.get("questions_to_answer") or [
        "What clinical evidence supports Semax or Selank for ADHD symptoms?",
        "How do Semax and Selank differ mechanistically for anxiety relief?",
        "Where do these peptides fit alongside traditional ADHD/anxiety care?",
    ]
    data_points = research_brief.get("data_points_to_hunt") or [
        "BDNF or dopamine modulation data for Semax",
        "Clinical anxiety scales impacted by Selank",
        "Comparative dosing ranges and onset timelines",
    ]
    storytelling_hooks = research_brief.get("storytelling_hooks") or []

    source_material = []
    for entry in curated_research:
        section_names = [section["heading"] for section in entry["sections"][:8]]
        source_material.append(
            {
                "title": entry["title"],
                "path": entry["path"],
                "key_sections": section_names,
                "summary": entry["summary"],
            }
        )

    internal_links: List[Dict[str, Any]] = []
    if knowledge_graph:
        for node in knowledge_graph.get("neighbor_nodes", []):
            if node.get("type") in {"peptide", "protocol", "condition"}:
                internal_links.append(
                    {
                        "id": node.get("id"),
                        "label": node.get("label"),
                        "type": node.get("type"),
                        "source": node.get("source"),
                    }
                )

    review_checklist = [
        "Validate all clinical claims against cited studies (add inline references).",
        "Include medical supervision / FDA status disclaimer for peptide use.",
        "Ensure ADHD guidance positions peptides as adjuncts, not replacements, unless evidence supports otherwise.",
    ]
    if knowledge_graph and knowledge_graph.get("relations"):
        review_checklist.append("Cross-check synergy and mechanism statements with knowledge graph evidence excerpts.")
    if storytelling_hooks:
        review_checklist.append("Select at least one storytelling hook and ensure the narrative delivers on it.")

    return {
        "primary_keyword": keyword,
        "secondary_keywords": secondary_keywords,
        "title_options": title_options,
        "meta_description": meta_description,
        "angles_to_cover": angles,
        "questions_to_answer": questions,
        "data_points_to_hunt": data_points,
        "storytelling_hooks": storytelling_hooks,
        "structure": structure,
        "source_material": source_material,
        "internal_links": internal_links,
        "review_checklist": review_checklist,
    }


def render_brief_markdown(
    keyword: str,
    generated_at: str,
    brief: Dict[str, Any],
    curated_research: List[Dict[str, Any]],
    knowledge_graph: Optional[Dict[str, Any]],
    brief_json_path: Optional[pathlib.Path] = None,
    report_path: Optional[pathlib.Path] = None,
) -> str:
    lines: List[str] = []
    lines.append(f"# Content Brief · {keyword}\n")
    lines.append(f"- Generated at: {generated_at}")
    if report_path:
        lines.append(f"- Research pack: `{report_path}`")
    if brief_json_path:
        lines.append(f"- Brief JSON: `{brief_json_path}`")
    lines.append("")

    lines.append("## Targeting\n")
    lines.append(f"- **Primary keyword:** {brief.get('primary_keyword')}")
    if brief.get("secondary_keywords"):
        secondary = ", ".join(brief["secondary_keywords"])
        lines.append(f"- **Secondary keywords:** {secondary}")
    lines.append("")

    if brief.get("title_options"):
        lines.append("## Title Options\n")
        for title in brief["title_options"]:
            lines.append(f"- {title}")
        lines.append("")

    if brief.get("meta_description"):
        lines.append("## Meta Description\n")
        lines.append(brief["meta_description"])
        lines.append("")

    lines.append("## Outline & Section Focus\n")
    for item in brief.get("structure", []):
        heading = item.get("heading", "")
        focus = item.get("focus") or ""
        lines.append(f"- **{heading}** — {focus}")
    lines.append("")

    if brief.get("angles_to_cover") or brief.get("questions_to_answer"):
        lines.append("## Angles & Questions\n")
        if brief.get("angles_to_cover"):
            lines.append("**Angles to cover:**")
            for angle in brief["angles_to_cover"]:
                lines.append(f"- {angle}")
        if brief.get("questions_to_answer"):
            lines.append("")
            lines.append("**Questions to answer:**")
            for q in brief["questions_to_answer"]:
                lines.append(f"- {q}")
        lines.append("")

    if brief.get("data_points_to_hunt"):
        lines.append("## Data Points to Hunt\n")
        for point in brief["data_points_to_hunt"]:
            lines.append(f"- {point}")
        lines.append("")

    if brief.get("storytelling_hooks"):
        lines.append("## Storytelling Hooks\n")
        for hook in brief["storytelling_hooks"]:
            lines.append(f"- {hook}")
        lines.append("")

    if brief.get("review_checklist"):
        lines.append("## Review Checklist\n")
        for item in brief["review_checklist"]:
            lines.append(f"- [ ] {item}")
        lines.append("")

    if curated_research:
        lines.append("## Curated Research\n")
        for entry in curated_research:
            lines.append(f"- **{entry['title']}** `[source: {entry['path']}]`")
            if entry.get("key_sections"):
                section_list = ", ".join(entry["key_sections"])
                lines.append(f"  - Key sections: {section_list}")
        lines.append("")

    if knowledge_graph:
        lines.append("## Knowledge Graph Highlights\n")
        for node in knowledge_graph.get("nodes", []):
            label = node.get("label", node.get("id"))
            node_type = node.get("type", "")
            lines.append(f"- **{label}** ({node_type})")
            excerpt = node.get("source_excerpt")
            if excerpt:
                lines.append(f"  > {excerpt.replace('|', '')}")
        if knowledge_graph.get("relations"):
            lines.append("")
            lines.append("**Key relations:**")
            for rel in knowledge_graph["relations"][:10]:
                source = rel.get("source")
                target = rel.get("target")
                relation = rel.get("relation")
                lines.append(f"- {source} —[{relation}]→ {target}")
                snippet = rel.get("evidence_excerpt")
                if snippet:
                    lines.append(f"  > {snippet.replace('|', '')}")
        lines.append("")

    return "\n".join(lines).strip() + "\n"


def generate_initial_draft(
    keyword: str,
    brief: Dict[str, Any],
    curated_research: List[Dict[str, Any]],
    knowledge_graph: Optional[Dict[str, Any]],
) -> Optional[str]:
    def heuristic_draft() -> str:
        lines: List[str] = []
        title = brief.get("title_options", [keyword])[0]
        lines.append(f"# {title}\n")

        section_map: Dict[str, List[str]] = {}
        for entry in curated_research:
            for section in entry.get("sections", []):
                heading = section.get("heading", "")
                summary = section.get("summary", "")
                if not heading or not summary:
                    continue
                section_map.setdefault(heading.lower(), []).append(summary)

        for item in brief.get("structure", []):
            heading = item.get("heading", "Section")
            lines.append(f"## {heading}\n")
            focus = item.get("focus")
            if focus:
                lines.append(f"*Focus:* {focus}\n")

            key = heading.lower()
            matched = False
            for original_heading, summaries in section_map.items():
                if key in original_heading or original_heading in key:
                    for summary in summaries:
                        lines.append(summary.strip() + "\n")
                    matched = True
                    break
            if not matched and brief.get("angles_to_cover"):
                lines.append(f"{brief['angles_to_cover'][0]}\n")

        if knowledge_graph and knowledge_graph.get("relations"):
            lines.append("## Key Relationships & Evidence\n")
            for rel in knowledge_graph["relations"][:5]:
                lines.append(
                    f"- {rel.get('source')} —[{rel.get('relation')}]→ {rel.get('target')}"
                )
                snippet = rel.get("evidence_excerpt")
                if snippet:
                    lines.append(f"  > {snippet}\n")

        return "\n".join(lines).strip()

    if not OPENAI_CLIENT:
        log("⚠️  OPENAI_API_KEY not set; using heuristic draft generation.")
        return heuristic_draft()

    try:
        prompt = (
            "You are writing a long-form, evidence-aware article for educated readers. "
            "Use the provided brief to generate a markdown draft with meaningful H2/H3 structure. "
            "Cite sources inline when possible using simple references (e.g., [Source]). "
            "Maintain a professional, helpful tone and highlight key data points."
        )
        payload = {
            "brief": brief,
            "curated_research": curated_research,
            "knowledge_graph": knowledge_graph,
        }
        response = OPENAI_CLIENT.responses.create(
            model=GPT_SUMMARIZER_MODEL,
            input=[
                {"role": "system", "content": prompt},
                {
                    "role": "user",
                    "content": f"Keyword: {keyword}\n\nBrief JSON:\n{json.dumps(payload)[:16000]}",
                },
            ],
            max_output_tokens=2500,
        )
        return response.output_text.strip()
    except Exception as exc:  # pylint: disable=broad-except
        log(f"⚠️  Automated draft generation failed ({exc}); using heuristic draft.")
        return heuristic_draft()


def assemble_report(
    keyword: str,
    research_paths: Optional[Sequence[str]] = None,
    knowledge_graph_path: Optional[str] = None,
    knowledge_root: Optional[str] = None,
    max_results: int = 10,
    extra_terms: Optional[Sequence[str]] = None,
    include_draft: bool = False,
) -> Dict[str, Any]:
    """Run the pipeline and return a structured report."""
    records = search_articles(keyword, max_results=max_results)

    articles: List[Dict[str, Any]] = []
    combined_corpus_parts: List[str] = []

    for record in records:
        url = record["url"]
        text = fetch_article_text(url)
        if not text:
            continue
        combined_corpus_parts.append(text)
        gpt_summary = gpt_summarize_article(keyword, record["title"], text)
        summary = gpt_summary["summary"] if gpt_summary and gpt_summary.get("summary") else summarize_text(text)
        insights = extract_insights(text)
        key_takeaways = []
        tone = ""
        summary_model: Optional[str] = None
        if gpt_summary:
            key_takeaways = gpt_summary.get("key_takeaways", [])
            tone = gpt_summary.get("tone", "")
            summary_model = gpt_summary.get("model")

        articles.append(
            {
                **record,
                "summary": summary,
                "insights": insights,
                "word_count": len(text.split()),
                "key_takeaways": key_takeaways,
                "tone_notes": tone,
                "summary_model": summary_model or "heuristic",
            }
        )

    combined_corpus = "\n\n".join(combined_corpus_parts)
    combined_summary = summarize_text(combined_corpus, sentences=8) if combined_corpus else ""
    combined_insights = extract_insights(combined_corpus, max_phrases=15) if combined_corpus else []
    keyword_suggestions = suggest_keywords(combined_corpus) if combined_corpus else []
    outline = build_outline(keyword, combined_insights)
    gpt_research = gpt_research_brief(keyword, combined_summary, combined_insights) if combined_summary else None
    sonnet_research = sonnet_research_addendum(keyword, combined_summary, combined_insights) if combined_summary else None

    research_brief: Dict[str, Any] = {}
    if gpt_research:
        research_brief.update(gpt_research)
    if sonnet_research:
        research_brief["storytelling_hooks"] = sonnet_research.get("storytelling_hooks", [])
        research_brief["risk_flags"] = sonnet_research.get("risk_flags", [])
        research_brief["expert_sources"] = sonnet_research.get("expert_sources", [])
        research_brief["refresh_triggers"] = sonnet_research.get("refresh_triggers", [])
    research_models: Dict[str, Optional[str]] = {
        "openai": GPT_RESEARCH_MODEL if gpt_research else None,
        "anthropic": SONNET_MODEL if sonnet_research else None,
    }

    curated_research = load_curated_research(keyword, research_paths)

    keyword_terms = re.findall(r"[A-Za-z0-9\-\+]+", keyword.lower())
    focus_terms = [term for term in keyword_terms if term]
    if extra_terms:
        focus_terms.extend(term.lower() for term in extra_terms if term)
    for entry in curated_research:
        for token in re.findall(r"[A-Za-z0-9\-\+]+", entry["title"].lower()):
            if token not in focus_terms:
                focus_terms.append(token)
    focus_terms = sorted(dict.fromkeys(focus_terms))

    knowledge_graph = load_knowledge_graph(knowledge_graph_path, focus_terms, knowledge_root)

    brief = generate_brief(
        keyword=keyword,
        outline=outline,
        combined_summary=combined_summary,
        combined_insights=combined_insights,
        keyword_suggestions=keyword_suggestions,
        research_brief=research_brief,
        curated_research=curated_research,
        knowledge_graph=knowledge_graph,
    )

    initial_draft = generate_initial_draft(
        keyword=keyword,
        brief=brief,
        curated_research=curated_research,
        knowledge_graph=knowledge_graph,
    ) if include_draft else None

    report: Dict[str, Any] = {
        "keyword": keyword,
        "generated_at": dt.datetime.now(dt.timezone.utc).isoformat(),
        "source": "seo_auto_pipeline",
        "articles_analyzed": len(articles),
        "articles": articles,
        "combined_summary": combined_summary,
        "combined_insights": combined_insights,
        "outline": outline,
        "keyword_suggestions": keyword_suggestions,
        "research_brief": research_brief or None,
        "curated_research": curated_research,
        "knowledge_graph": knowledge_graph,
        "focus_terms": focus_terms,
        "brief": brief,
        "initial_draft": initial_draft,
        "openai_models": {
            "article_summarizer": GPT_SUMMARIZER_MODEL if OPENAI_CLIENT else None,
            "research_brief": GPT_RESEARCH_MODEL if gpt_research else None,
        },
        "anthropic_models": {
            "research_brief": SONNET_MODEL if sonnet_research else None,
        },
    }
    return report


def save_report(report: Dict[str, Any]) -> Tuple[pathlib.Path, Optional[pathlib.Path], Optional[pathlib.Path], Optional[pathlib.Path]]:
    """Persist report and brief to outputs/seo/."""
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    keyword_slug = re.sub(r"[^a-zA-Z0-9]+", "-", report["keyword"]).strip("-").lower()
    path = OUTPUT_DIR / f"{keyword_slug or 'keyword'}-report.json"
    path.write_text(json.dumps(report, indent=2), encoding="utf-8")
    log(f"Saved report to {path}")

    brief_path: Optional[pathlib.Path] = None
    brief_markdown_path: Optional[pathlib.Path] = None
    brief = report.get("brief")
    if brief:
        brief_payload = {
            "keyword": report["keyword"],
            "generated_at": report["generated_at"],
            "brief": brief,
            "focus_terms": report.get("focus_terms"),
            "knowledge_graph": report.get("knowledge_graph"),
            "source_report": str(path),
        }
        brief_path = OUTPUT_DIR / f"{keyword_slug or 'keyword'}-brief.json"
        brief_path.write_text(json.dumps(brief_payload, indent=2), encoding="utf-8")
        log(f"Saved brief to {brief_path}")

        brief_markdown = render_brief_markdown(
            keyword=report["keyword"],
            generated_at=report["generated_at"],
            brief=brief,
            curated_research=report.get("curated_research", []),
            knowledge_graph=report.get("knowledge_graph"),
            brief_json_path=brief_path,
            report_path=path,
        )
        brief_markdown_path = OUTPUT_DIR / f"{keyword_slug or 'keyword'}-brief.md"
        brief_markdown_path.write_text(brief_markdown, encoding="utf-8")
        log(f"Saved brief markdown to {brief_markdown_path}")

    draft_path: Optional[pathlib.Path] = None
    draft_content = report.get("initial_draft")
    if draft_content:
        draft_path = OUTPUT_DIR / f"{keyword_slug or 'keyword'}-draft.md"
        draft_path.write_text(draft_content, encoding="utf-8")
        log(f"Saved automated draft to {draft_path}")

    return path, brief_path, brief_markdown_path, draft_path


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the SEO automation pipeline.")
    parser.add_argument("keyword", help="Target keyword or topic to research.")
    parser.add_argument(
        "--max-results",
        type=int,
        default=10,
        help="Maximum number of search results to analyze.",
    )
    parser.add_argument(
        "--research-doc",
        action="append",
        dest="research_docs",
        help="Path to curated research markdown file (can be supplied multiple times).",
    )
    parser.add_argument(
        "--knowledge-graph",
        dest="knowledge_graph",
        help="Path to knowledge graph JSON file.",
    )
    parser.add_argument(
        "--knowledge-root",
        dest="knowledge_root",
        help="Root directory for resolving knowledge graph evidence paths.",
    )
    parser.add_argument(
        "--focus-term",
        action="append",
        dest="focus_terms",
        help="Additional focus terms to include when querying the knowledge graph.",
    )
    parser.add_argument(
        "--draft",
        action="store_true",
        dest="generate_draft",
        help="Generate an automated first-pass draft (requires OpenAI API key).",
    )
    args = parser.parse_args()

    report = assemble_report(
        keyword=args.keyword,
        research_paths=args.research_docs,
        knowledge_graph_path=args.knowledge_graph,
        knowledge_root=args.knowledge_root,
        max_results=args.max_results,
        extra_terms=args.focus_terms,
        include_draft=args.generate_draft,
    )
    report_path, brief_json_path, brief_markdown_path, draft_path = save_report(report)
    output_payload = {"report_path": str(report_path)}
    if brief_json_path:
        output_payload["brief_path"] = str(brief_json_path)
    if brief_markdown_path:
        output_payload["brief_markdown_path"] = str(brief_markdown_path)
    if draft_path:
        output_payload["draft_path"] = str(draft_path)
    print(json.dumps(output_payload, indent=2))


if __name__ == "__main__":
    main()
