"""
Data models for claude-workshop.
"""

from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional


@dataclass
class Entry:
    """A workshop memory entry."""

    id: int
    type: str  # 'decision', 'gotcha', 'note', 'preference'
    content: str
    reasoning: Optional[str] = None
    context: Optional[str] = None
    domain: Optional[str] = None
    created_at: datetime = field(default_factory=datetime.utcnow)
    updated_at: Optional[datetime] = None
    tags: list[str] = field(default_factory=list)

    def to_dict(self) -> dict:
        """Convert to dictionary for JSON serialization."""
        return {
            "id": self.id,
            "type": self.type,
            "content": self.content,
            "reasoning": self.reasoning,
            "context": self.context,
            "domain": self.domain,
            "timestamp": self.created_at.isoformat() + "Z",
            "tags": self.tags,
        }

    @classmethod
    def from_row(cls, row: tuple, tags: list[str] = None) -> "Entry":
        """Create Entry from database row."""
        return cls(
            id=row[0],
            type=row[1],
            content=row[2],
            reasoning=row[3],
            context=row[4],
            domain=row[5],
            created_at=datetime.fromisoformat(row[6]) if row[6] else datetime.utcnow(),
            updated_at=datetime.fromisoformat(row[7]) if row[7] else None,
            tags=tags or [],
        )


@dataclass
class ImportRecord:
    """Record of an imported JSONL file."""

    id: int
    file_path: str
    file_hash: str
    imported_at: datetime
    entries_extracted: int

    @classmethod
    def from_row(cls, row: tuple) -> "ImportRecord":
        """Create ImportRecord from database row."""
        return cls(
            id=row[0],
            file_path=row[1],
            file_hash=row[2],
            imported_at=datetime.fromisoformat(row[3]) if row[3] else datetime.utcnow(),
            entries_extracted=row[4],
        )
