"""
JSONL transcript import for claude-workshop.

Parses Claude Code JSONL transcripts and extracts decisions, gotchas, and notes.
"""

import hashlib
import json
import os
import re
from pathlib import Path
from typing import Optional

from .db import Database


# Patterns to extract different entry types from assistant messages
DECISION_PATTERNS = [
    r"I (?:decided|chose|went with|selected) to (.+?)(?:\.|$)",
    r"(?:We|I) (?:should|will|are going to) use (.+?) (?:for|because|since)",
    r"The (?:decision|choice) (?:is|was) to (.+?)(?:\.|$)",
    r"(?:Using|Choosing|Going with) (.+?) (?:for|because|since|as)",
]

GOTCHA_PATTERNS = [
    r"(?:Watch out|Be careful|Note that|Warning|Caution)[:\s]+(.+?)(?:\.|$)",
    r"(?:Don't|Do not|Avoid|Never) (.+?)(?:\.|$)",
    r"(?:This can|This will|This might) (?:cause|break|fail) (.+?)(?:\.|$)",
    r"(?:Make sure to|Remember to|Always) (.+?)(?:\.|$)",
]

NOTE_PATTERNS = [
    r"(?:Note|FYI|For reference)[:\s]+(.+?)(?:\.|$)",
    r"(?:This is|It's) (?:important|worth noting) that (.+?)(?:\.|$)",
]


def find_jsonl_files(base_path: Optional[str] = None) -> list[Path]:
    """Find JSONL transcript files.

    Args:
        base_path: Base path to search (defaults to ~/.claude/projects/)

    Returns:
        List of JSONL file paths
    """
    if base_path is None:
        base_path = os.path.expanduser("~/.claude/projects")

    base = Path(base_path)
    if not base.exists():
        return []

    # Find all .jsonl files
    return list(base.rglob("*.jsonl"))


def compute_file_hash(file_path: Path) -> str:
    """Compute SHA256 hash of file content.

    Args:
        file_path: Path to file

    Returns:
        Hex digest of hash
    """
    hasher = hashlib.sha256()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            hasher.update(chunk)
    return hasher.hexdigest()


def extract_entries_from_jsonl(file_path: Path) -> list[dict]:
    """Extract entries from a JSONL transcript file.

    Args:
        file_path: Path to JSONL file

    Returns:
        List of extracted entries with type, content, reasoning
    """
    entries = []

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue

                try:
                    msg = json.loads(line)
                except json.JSONDecodeError:
                    continue

                # Only process assistant messages
                if msg.get("type") != "assistant":
                    continue

                message = msg.get("message", "")
                if not message or len(message) < 20:
                    continue

                # Try to extract decisions
                for pattern in DECISION_PATTERNS:
                    matches = re.findall(pattern, message, re.IGNORECASE)
                    for match in matches:
                        if len(match) > 10:  # Skip very short matches
                            entries.append({
                                "type": "decision",
                                "content": match.strip(),
                                "reasoning": _extract_reasoning(message, match),
                            })

                # Try to extract gotchas
                for pattern in GOTCHA_PATTERNS:
                    matches = re.findall(pattern, message, re.IGNORECASE)
                    for match in matches:
                        if len(match) > 10:
                            entries.append({
                                "type": "gotcha",
                                "content": match.strip(),
                                "reasoning": None,
                            })

                # Try to extract notes
                for pattern in NOTE_PATTERNS:
                    matches = re.findall(pattern, message, re.IGNORECASE)
                    for match in matches:
                        if len(match) > 10:
                            entries.append({
                                "type": "note",
                                "content": match.strip(),
                                "reasoning": None,
                            })

    except Exception:
        # Silently skip files that can't be read
        pass

    # Deduplicate by content
    seen = set()
    unique = []
    for entry in entries:
        key = entry["content"].lower()
        if key not in seen:
            seen.add(key)
            unique.append(entry)

    return unique


def _extract_reasoning(message: str, decision: str) -> Optional[str]:
    """Try to extract reasoning for a decision from the surrounding text.

    Args:
        message: Full message text
        decision: The extracted decision text

    Returns:
        Reasoning string or None
    """
    # Look for "because", "since", "reason" nearby
    patterns = [
        r"because (.+?)(?:\.|$)",
        r"since (.+?)(?:\.|$)",
        r"(?:The |the )?reason (?:is|was) (.+?)(?:\.|$)",
        r"(?:This |this )(?:is |was )(?:due to|because of) (.+?)(?:\.|$)",
    ]

    for pattern in patterns:
        matches = re.findall(pattern, message, re.IGNORECASE)
        for match in matches:
            if len(match) > 10:
                return match.strip()

    return None


def import_transcripts(
    db: Database,
    base_path: Optional[str] = None,
    execute: bool = False,
) -> dict:
    """Import entries from JSONL transcripts.

    Args:
        db: Database instance
        base_path: Base path to search for JSONL files
        execute: If True, actually import. If False, just preview.

    Returns:
        Summary dict with files_found, entries_found, entries_imported
    """
    files = find_jsonl_files(base_path)

    summary = {
        "files_found": len(files),
        "files_skipped": 0,
        "entries_found": 0,
        "entries_imported": 0,
        "details": [],
    }

    for file_path in files:
        file_str = str(file_path)

        # Check if already imported
        if db.is_file_imported(file_str):
            summary["files_skipped"] += 1
            continue

        # Extract entries
        entries = extract_entries_from_jsonl(file_path)
        summary["entries_found"] += len(entries)

        if entries:
            summary["details"].append({
                "file": file_str,
                "entries": len(entries),
                "types": {
                    "decision": sum(1 for e in entries if e["type"] == "decision"),
                    "gotcha": sum(1 for e in entries if e["type"] == "gotcha"),
                    "note": sum(1 for e in entries if e["type"] == "note"),
                },
            })

        if execute and entries:
            # Import entries
            for entry in entries:
                db.add_entry(
                    type=entry["type"],
                    content=entry["content"],
                    reasoning=entry.get("reasoning"),
                    tags=["auto-imported"],
                )
            summary["entries_imported"] += len(entries)

            # Record import
            file_hash = compute_file_hash(file_path)
            db.record_import(file_str, file_hash, len(entries))

    return summary
