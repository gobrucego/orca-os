#!/usr/bin/env python3
"""
Memory indexing and management for vibe.db
Creates and maintains the local SQLite database for code search
"""

import sqlite3
import json
import argparse
import sys
from pathlib import Path
from datetime import datetime

def create_database(db_path):
    """Create vibe.db with proper schema"""
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Create tables
    cursor.executescript("""
        -- Code chunks table (simple table for now, FTS5 can be added later)
        CREATE TABLE IF NOT EXISTS code_chunks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_path TEXT NOT NULL,
            content TEXT NOT NULL,
            language TEXT,
            chunk_type TEXT,
            metadata TEXT
        );

        -- Events table for tracking changes
        CREATE TABLE IF NOT EXISTS events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT NOT NULL,
            event_type TEXT NOT NULL,
            file_path TEXT,
            description TEXT,
            metadata TEXT
        );

        -- Decisions table (mirrors Workshop for redundancy)
        CREATE TABLE IF NOT EXISTS decisions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_at TEXT NOT NULL,
            decision TEXT NOT NULL,
            reasoning TEXT,
            tags TEXT
        );

        -- Index for events
        CREATE INDEX IF NOT EXISTS idx_events_timestamp ON events(timestamp);
        CREATE INDEX IF NOT EXISTS idx_events_type ON events(event_type);

        -- Metadata table
        CREATE TABLE IF NOT EXISTS metadata (
            key TEXT PRIMARY KEY,
            value TEXT,
            updated_at TEXT
        );
    """)

    # Set metadata
    now = datetime.utcnow().isoformat()
    cursor.execute("""
        INSERT OR REPLACE INTO metadata (key, value, updated_at)
        VALUES ('version', '1.0', ?)
    """, (now,))
    cursor.execute("""
        INSERT OR REPLACE INTO metadata (key, value, updated_at)
        VALUES ('created_at', ?, ?)
    """, (now, now))

    conn.commit()
    conn.close()
    print(f"✓ Created database: {db_path}")

def index_file(db_path, file_path, content=None):
    """Index a file into vibe.db"""
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Read content if not provided
    if content is None:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
            return

    # Detect language from extension
    ext_to_lang = {
        '.py': 'python',
        '.js': 'javascript',
        '.ts': 'typescript',
        '.jsx': 'javascript',
        '.tsx': 'typescript',
        '.sh': 'bash',
        '.md': 'markdown',
        '.json': 'json',
        '.yaml': 'yaml',
        '.yml': 'yaml',
    }

    file_ext = Path(file_path).suffix
    language = ext_to_lang.get(file_ext, 'text')

    # Insert into code_chunks
    cursor.execute("""
        INSERT INTO code_chunks (file_path, content, language, chunk_type, metadata)
        VALUES (?, ?, ?, 'file', ?)
    """, (str(file_path), content, language, json.dumps({'indexed_at': datetime.utcnow().isoformat()})))

    # Log event
    cursor.execute("""
        INSERT INTO events (timestamp, event_type, file_path, description)
        VALUES (?, 'index', ?, 'File indexed')
    """, (datetime.utcnow().isoformat(), str(file_path)))

    conn.commit()
    conn.close()
    print(f"✓ Indexed: {file_path}")

def search(db_path, query, limit=10):
    """Search vibe.db using LIKE for now"""
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Simple LIKE search for now
    results = cursor.execute("""
        SELECT file_path, substr(content, 1, 200) as snippet
        FROM code_chunks
        WHERE content LIKE ?
        LIMIT ?
    """, (f'%{query}%', limit)).fetchall()

    conn.close()
    return results

def main():
    parser = argparse.ArgumentParser(description='Manage vibe.db memory index')
    parser.add_argument('--init', action='store_true', help='Initialize database')
    parser.add_argument('--db', default='.claude/memory/vibe.db', help='Database path')
    parser.add_argument('--index', help='Index a file')
    parser.add_argument('--search', help='Search the database')
    parser.add_argument('--limit', type=int, default=10, help='Search result limit')

    args = parser.parse_args()

    if args.init:
        db_path = Path(args.db)
        db_path.parent.mkdir(parents=True, exist_ok=True)
        create_database(db_path)

    elif args.index:
        if not Path(args.db).exists():
            print(f"Error: Database {args.db} doesn't exist. Run with --init first.")
            sys.exit(1)
        index_file(args.db, args.index)

    elif args.search:
        if not Path(args.db).exists():
            print(f"Error: Database {args.db} doesn't exist. Run with --init first.")
            sys.exit(1)
        results = search(args.db, args.search, args.limit)
        for path, snippet in results:
            print(f"{path}:")
            print(f"  {snippet}\n")

    else:
        parser.print_help()

if __name__ == '__main__':
    main()