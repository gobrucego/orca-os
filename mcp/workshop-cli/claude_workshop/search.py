"""
Search and ranking logic for claude-workshop.
"""

from datetime import datetime
from typing import Optional

from .models import Entry


def rank_entries(entries: list[Entry], query: str) -> list[Entry]:
    """Rank entries by recency + keyword relevance.

    Args:
        entries: List of entries to rank
        query: Search query string

    Returns:
        Sorted list of entries (highest score first)
    """
    query_terms = [term.lower() for term in query.split() if len(term) > 1]

    scored = [(entry, _score_entry(entry, query_terms)) for entry in entries]
    scored.sort(key=lambda x: x[1], reverse=True)

    return [entry for entry, score in scored]


def _score_entry(entry: Entry, query_terms: list[str]) -> float:
    """Calculate relevance score for an entry.

    Scoring factors:
    - Recency: 0-100 points (newer = higher)
    - Content match: 50 points per term
    - Reasoning match: 30 points per term
    - Domain match: 20 points per term
    - Tag match: 15 points per term

    Args:
        entry: Entry to score
        query_terms: Lowercase query terms

    Returns:
        Relevance score
    """
    score = 0.0

    # Recency score: newer entries score higher (0-100)
    now = datetime.utcnow()
    age_days = (now - entry.created_at).days
    score += max(100 - age_days, 0)

    # Keyword matching
    content_lower = entry.content.lower()
    reasoning_lower = (entry.reasoning or "").lower()
    domain_lower = (entry.domain or "").lower()
    tags_lower = [t.lower() for t in entry.tags]

    for term in query_terms:
        # Content match (highest weight)
        if term in content_lower:
            score += 50

        # Reasoning match
        if term in reasoning_lower:
            score += 30

        # Domain match
        if term in domain_lower:
            score += 20

        # Tag match
        if any(term in tag for tag in tags_lower):
            score += 15

    return score


def extract_domain(content: str) -> Optional[str]:
    """Extract domain from content if present.

    Looks for pattern like "[domain] rest of content"

    Args:
        content: Entry content

    Returns:
        Domain string or None
    """
    if content.startswith("[") and "]" in content:
        end_bracket = content.index("]")
        return content[1:end_bracket].lower()
    return None


def strip_domain_prefix(content: str) -> str:
    """Remove domain prefix from content.

    Args:
        content: Entry content

    Returns:
        Content without [domain] prefix
    """
    if content.startswith("[") and "]" in content:
        end_bracket = content.index("]")
        return content[end_bracket + 1:].strip()
    return content
