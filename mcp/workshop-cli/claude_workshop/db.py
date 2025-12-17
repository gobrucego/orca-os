"""
Database operations for claude-workshop.
"""

import os
import sqlite3
from datetime import datetime
from pathlib import Path
from typing import Optional

from .models import Entry, ImportRecord

SCHEMA = """
-- Entries table
CREATE TABLE IF NOT EXISTS entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL CHECK(type IN ('decision', 'gotcha', 'note', 'preference')),
    content TEXT NOT NULL,
    reasoning TEXT,
    context TEXT,
    domain TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT
);

-- Tags table
CREATE TABLE IF NOT EXISTS tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id INTEGER NOT NULL,
    tag TEXT NOT NULL,
    FOREIGN KEY (entry_id) REFERENCES entries(id) ON DELETE CASCADE
);

-- Import history
CREATE TABLE IF NOT EXISTS import_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL UNIQUE,
    file_hash TEXT NOT NULL,
    imported_at TEXT NOT NULL DEFAULT (datetime('now')),
    entries_extracted INTEGER DEFAULT 0
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_entries_type ON entries(type);
CREATE INDEX IF NOT EXISTS idx_entries_created ON entries(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_entries_domain ON entries(domain);
CREATE INDEX IF NOT EXISTS idx_tags_entry ON tags(entry_id);
CREATE INDEX IF NOT EXISTS idx_tags_tag ON tags(tag);
"""


class Database:
    """SQLite database wrapper for workshop memory."""

    def __init__(self, workspace: str):
        """Initialize database connection.

        Args:
            workspace: Path to .claude/memory directory
        """
        self.workspace = Path(workspace)
        self.db_path = self.workspace / "workshop.db"
        self._conn: Optional[sqlite3.Connection] = None

    @property
    def conn(self) -> sqlite3.Connection:
        """Get database connection, creating if needed."""
        if self._conn is None:
            self._conn = sqlite3.connect(str(self.db_path))
            self._conn.execute("PRAGMA foreign_keys = ON")
        return self._conn

    def close(self):
        """Close database connection."""
        if self._conn:
            self._conn.close()
            self._conn = None

    def exists(self) -> bool:
        """Check if database file exists."""
        return self.db_path.exists()

    def init(self) -> bool:
        """Initialize database schema.

        Returns:
            True if created new, False if already existed
        """
        # Create workspace directory if needed
        self.workspace.mkdir(parents=True, exist_ok=True)

        created = not self.exists()
        self.conn.executescript(SCHEMA)
        self.conn.commit()
        return created

    def add_entry(
        self,
        type: str,
        content: str,
        reasoning: Optional[str] = None,
        context: Optional[str] = None,
        domain: Optional[str] = None,
        tags: Optional[list[str]] = None,
    ) -> int:
        """Add a new entry.

        Returns:
            Entry ID
        """
        cursor = self.conn.execute(
            """
            INSERT INTO entries (type, content, reasoning, context, domain, created_at)
            VALUES (?, ?, ?, ?, ?, ?)
            """,
            (type, content, reasoning, context, domain, datetime.utcnow().isoformat()),
        )
        entry_id = cursor.lastrowid

        if tags:
            for tag in tags:
                self.conn.execute(
                    "INSERT INTO tags (entry_id, tag) VALUES (?, ?)",
                    (entry_id, tag.lower()),
                )

        self.conn.commit()
        return entry_id

    def get_entry(self, entry_id: int) -> Optional[Entry]:
        """Get entry by ID."""
        cursor = self.conn.execute(
            "SELECT * FROM entries WHERE id = ?", (entry_id,)
        )
        row = cursor.fetchone()
        if not row:
            return None

        tags = self._get_tags(entry_id)
        return Entry.from_row(row, tags)

    def _get_tags(self, entry_id: int) -> list[str]:
        """Get tags for an entry."""
        cursor = self.conn.execute(
            "SELECT tag FROM tags WHERE entry_id = ?", (entry_id,)
        )
        return [row[0] for row in cursor.fetchall()]

    def get_entries_by_type(
        self, type: str, limit: int = 50
    ) -> list[Entry]:
        """Get entries of a specific type."""
        cursor = self.conn.execute(
            """
            SELECT * FROM entries
            WHERE type = ?
            ORDER BY created_at DESC
            LIMIT ?
            """,
            (type, limit),
        )
        entries = []
        for row in cursor.fetchall():
            tags = self._get_tags(row[0])
            entries.append(Entry.from_row(row, tags))
        return entries

    def get_recent_entries(self, limit: int = 10) -> list[Entry]:
        """Get most recent entries of all types."""
        cursor = self.conn.execute(
            """
            SELECT * FROM entries
            ORDER BY created_at DESC
            LIMIT ?
            """,
            (limit,),
        )
        entries = []
        for row in cursor.fetchall():
            tags = self._get_tags(row[0])
            entries.append(Entry.from_row(row, tags))
        return entries

    def search_entries(
        self,
        query: str,
        type: Optional[str] = None,
        limit: int = 20,
    ) -> list[Entry]:
        """Search entries by content, reasoning, domain."""
        query_lower = f"%{query.lower()}%"

        if type:
            cursor = self.conn.execute(
                """
                SELECT * FROM entries
                WHERE type = ?
                  AND (LOWER(content) LIKE ? OR LOWER(reasoning) LIKE ? OR LOWER(domain) LIKE ?)
                ORDER BY created_at DESC
                LIMIT ?
                """,
                (type, query_lower, query_lower, query_lower, limit),
            )
        else:
            cursor = self.conn.execute(
                """
                SELECT * FROM entries
                WHERE LOWER(content) LIKE ? OR LOWER(reasoning) LIKE ? OR LOWER(domain) LIKE ?
                ORDER BY created_at DESC
                LIMIT ?
                """,
                (query_lower, query_lower, query_lower, limit),
            )

        entries = []
        for row in cursor.fetchall():
            tags = self._get_tags(row[0])
            entries.append(Entry.from_row(row, tags))
        return entries

    def get_decisions(self, query: str, limit: int = 10) -> list[Entry]:
        """Get decisions matching query (for 'why' command)."""
        return self.search_entries(query, type="decision", limit=limit)

    def delete_entry(self, entry_id: int) -> bool:
        """Delete entry by ID.

        Returns:
            True if deleted, False if not found
        """
        cursor = self.conn.execute(
            "DELETE FROM entries WHERE id = ?", (entry_id,)
        )
        self.conn.commit()
        return cursor.rowcount > 0

    def get_stats(self) -> dict:
        """Get database statistics."""
        stats = {"total": 0, "by_type": {}}

        cursor = self.conn.execute(
            "SELECT type, COUNT(*) FROM entries GROUP BY type"
        )
        for row in cursor.fetchall():
            stats["by_type"][row[0]] = row[1]
            stats["total"] += row[1]

        return stats

    # Import history methods

    def is_file_imported(self, file_path: str) -> bool:
        """Check if file has been imported."""
        cursor = self.conn.execute(
            "SELECT 1 FROM import_history WHERE file_path = ?", (file_path,)
        )
        return cursor.fetchone() is not None

    def record_import(
        self, file_path: str, file_hash: str, entries_extracted: int
    ) -> int:
        """Record that a file was imported.

        Returns:
            Import record ID
        """
        cursor = self.conn.execute(
            """
            INSERT INTO import_history (file_path, file_hash, imported_at, entries_extracted)
            VALUES (?, ?, ?, ?)
            """,
            (file_path, file_hash, datetime.utcnow().isoformat(), entries_extracted),
        )
        self.conn.commit()
        return cursor.lastrowid

    def get_import_history(self, limit: int = 20) -> list[ImportRecord]:
        """Get recent import history."""
        cursor = self.conn.execute(
            """
            SELECT * FROM import_history
            ORDER BY imported_at DESC
            LIMIT ?
            """,
            (limit,),
        )
        return [ImportRecord.from_row(row) for row in cursor.fetchall()]
