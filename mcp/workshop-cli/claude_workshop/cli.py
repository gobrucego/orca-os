"""
CLI interface for claude-workshop.
"""

import json
import os
import sys
from datetime import datetime
from typing import Optional

import click
from rich.console import Console
from rich.table import Table

from . import __version__
from .db import Database
from .import_jsonl import import_transcripts
from .search import extract_domain, rank_entries, strip_domain_prefix

console = Console()


def get_default_workspace() -> str:
    """Get default workspace path (.claude/memory in current directory)."""
    return os.path.join(os.getcwd(), ".claude", "memory")


@click.group(invoke_without_command=True)
@click.option(
    "--workspace",
    "-w",
    default=None,
    help="Path to workshop workspace (default: .claude/memory)",
)
@click.option("--version", is_flag=True, help="Show version")
@click.pass_context
def main(ctx, workspace: Optional[str], version: bool):
    """claude-workshop: Persistent project memory for Claude Code sessions."""
    if version:
        click.echo(f"claude-workshop {__version__}")
        return

    # Store workspace in context for subcommands
    ctx.ensure_object(dict)
    ctx.obj["workspace"] = workspace or get_default_workspace()

    # If no subcommand, show help
    if ctx.invoked_subcommand is None:
        click.echo(ctx.get_help())


@main.command()
@click.pass_context
def init(ctx):
    """Initialize workshop database."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    created = db.init()
    db.close()

    if created:
        console.print(f"[green]Created workshop database at {db.db_path}[/green]")
    else:
        console.print(f"[yellow]Workshop database already exists at {db.db_path}[/yellow]")


@main.command()
@click.argument("text")
@click.option("-r", "--reason", required=True, help="Reasoning for this decision")
@click.option("-t", "--tag", multiple=True, help="Tags (can be repeated)")
@click.pass_context
def decision(ctx, text: str, reason: str, tag: tuple):
    """Record an architectural decision."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        console.print("[red]Database not initialized. Run: claude-workshop init[/red]")
        sys.exit(1)

    # Extract domain from [domain] prefix if present
    domain = extract_domain(text)
    content = strip_domain_prefix(text) if domain else text

    entry_id = db.add_entry(
        type="decision",
        content=content,
        reasoning=reason,
        domain=domain,
        tags=list(tag),
    )
    db.close()

    console.print(f"[green]Decision recorded (ID: {entry_id})[/green]")


@main.command()
@click.argument("text")
@click.option("-t", "--tag", multiple=True, help="Tags (can be repeated)")
@click.pass_context
def gotcha(ctx, text: str, tag: tuple):
    """Record a gotcha/warning/pitfall."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        console.print("[red]Database not initialized. Run: claude-workshop init[/red]")
        sys.exit(1)

    # Extract domain from [domain] prefix if present
    domain = extract_domain(text)
    content = strip_domain_prefix(text) if domain else text

    entry_id = db.add_entry(
        type="gotcha",
        content=content,
        domain=domain,
        tags=list(tag),
    )
    db.close()

    console.print(f"[green]Gotcha recorded (ID: {entry_id})[/green]")


@main.command()
@click.argument("text")
@click.option("--tags", multiple=True, help="Tags")
@click.pass_context
def note(ctx, text: str, tags: tuple):
    """Add a general note."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        console.print("[red]Database not initialized. Run: claude-workshop init[/red]")
        sys.exit(1)

    # Extract domain from [domain] prefix if present
    domain = extract_domain(text)
    content = strip_domain_prefix(text) if domain else text

    entry_id = db.add_entry(
        type="note",
        content=content,
        domain=domain,
        tags=list(tags),
    )
    db.close()

    console.print(f"[green]Note recorded (ID: {entry_id})[/green]")


@main.command()
@click.argument("query")
@click.option("--json", "as_json", is_flag=True, help="Output as JSON")
@click.option("--limit", default=10, help="Maximum results")
@click.pass_context
def why(ctx, query: str, as_json: bool, limit: int):
    """Query past decisions (THE KILLER FEATURE)."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        if as_json:
            click.echo("[]")
        else:
            console.print("[red]Database not initialized. Run: claude-workshop init[/red]")
        sys.exit(0)

    entries = db.get_decisions(query, limit=limit * 2)  # Get more for ranking
    entries = rank_entries(entries, query)[:limit]
    db.close()

    if as_json:
        click.echo(json.dumps([e.to_dict() for e in entries], indent=2))
    else:
        if not entries:
            console.print(f"[yellow]No decisions found for '{query}'[/yellow]")
            return

        console.print(f"\n[bold]Decisions matching '{query}':[/bold]\n")
        for entry in entries:
            date_str = entry.created_at.strftime("%Y-%m-%d")
            domain_str = f"[{entry.domain}] " if entry.domain else ""
            console.print(f"  [{date_str}] {domain_str}{entry.content}")
            if entry.reasoning:
                console.print(f"    [dim]Reason: {entry.reasoning}[/dim]")
            console.print()


@main.command()
@click.argument("query")
@click.option("--json", "as_json", is_flag=True, help="Output as JSON")
@click.option("--type", "entry_type", help="Filter by type (decision/gotcha/note)")
@click.option("--limit", default=20, help="Maximum results")
@click.pass_context
def search(ctx, query: str, as_json: bool, entry_type: Optional[str], limit: int):
    """Search all entries."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        if as_json:
            click.echo("[]")
        else:
            console.print("[red]Database not initialized. Run: claude-workshop init[/red]")
        sys.exit(0)

    entries = db.search_entries(query, type=entry_type, limit=limit * 2)
    entries = rank_entries(entries, query)[:limit]
    db.close()

    if as_json:
        click.echo(json.dumps([e.to_dict() for e in entries], indent=2))
    else:
        if not entries:
            console.print(f"[yellow]No results for '{query}'[/yellow]")
            return

        console.print(f"\n[bold]Results for '{query}':[/bold]\n")
        for entry in entries:
            date_str = entry.created_at.strftime("%Y-%m-%d")
            type_color = {
                "decision": "blue",
                "gotcha": "red",
                "note": "green",
            }.get(entry.type, "white")

            domain_str = f"[{entry.domain}] " if entry.domain else ""
            console.print(
                f"  [{date_str}] [{type_color}]{entry.type}[/{type_color}] {domain_str}{entry.content}"
            )
            if entry.reasoning:
                console.print(f"    [dim]Reason: {entry.reasoning}[/dim]")
            console.print()


@main.command()
@click.option("--limit", default=10, help="Number of entries to show")
@click.pass_context
def recent(ctx, limit: int):
    """Show recent entries."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        console.print("[red]Database not initialized. Run: claude-workshop init[/red]")
        return

    entries = db.get_recent_entries(limit=limit)
    db.close()

    if not entries:
        console.print("[yellow]No entries yet.[/yellow]")
        return

    # Group by type
    by_type = {}
    for entry in entries:
        by_type.setdefault(entry.type, []).append(entry)

    console.print("\n[bold]Recent Entries:[/bold]\n")

    for entry_type, type_entries in by_type.items():
        type_color = {
            "decision": "blue",
            "gotcha": "red",
            "note": "green",
        }.get(entry_type, "white")

        console.print(f"[{type_color}]{entry_type.title()}s:[/{type_color}]")
        for entry in type_entries[:5]:  # Max 5 per type
            date_str = entry.created_at.strftime("%Y-%m-%d")
            domain_str = f"[{entry.domain}] " if entry.domain else ""
            console.print(f"  [{date_str}] {domain_str}{entry.content[:80]}")
        console.print()


@main.command()
@click.pass_context
def context(ctx):
    """Get session context summary."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        console.print("Workshop not initialized. Run: claude-workshop init")
        return

    stats = db.get_stats()
    decisions = db.get_entries_by_type("decision", limit=5)
    gotchas = db.get_entries_by_type("gotcha", limit=5)
    recent = db.get_recent_entries(limit=3)
    db.close()

    console.print("\n[bold]Workshop Context Summary[/bold]\n")
    console.print(f"Total entries: {stats['total']}")
    for t, count in stats.get("by_type", {}).items():
        console.print(f"  - {t}s: {count}")
    console.print()

    if decisions:
        console.print("[blue]Recent Decisions:[/blue]")
        for d in decisions[:3]:
            domain_str = f"[{d.domain}] " if d.domain else ""
            console.print(f"  - {domain_str}{d.content[:60]}")
        console.print()

    if gotchas:
        console.print("[red]Active Gotchas:[/red]")
        for g in gotchas[:3]:
            domain_str = f"[{g.domain}] " if g.domain else ""
            console.print(f"  - {domain_str}{g.content[:60]}")
        console.print()

    if recent:
        console.print("[green]Latest Activity:[/green]")
        for r in recent:
            date_str = r.created_at.strftime("%Y-%m-%d %H:%M")
            console.print(f"  [{date_str}] {r.type}: {r.content[:50]}")
        console.print()


@main.command("import")
@click.option("--execute", is_flag=True, help="Actually import (default: preview)")
@click.option("--path", default=None, help="Path to search for JSONL files")
@click.pass_context
def import_cmd(ctx, execute: bool, path: Optional[str]):
    """Import from JSONL transcripts."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        console.print("[red]Database not initialized. Run: claude-workshop init[/red]")
        sys.exit(1)

    summary = import_transcripts(db, base_path=path, execute=execute)
    db.close()

    if execute:
        console.print(f"\n[green]Import complete![/green]")
        console.print(f"  Files processed: {summary['files_found']}")
        console.print(f"  Files skipped (already imported): {summary['files_skipped']}")
        console.print(f"  Entries imported: {summary['entries_imported']}")
    else:
        console.print(f"\n[yellow]Import preview (use --execute to import):[/yellow]")
        console.print(f"  Files found: {summary['files_found']}")
        console.print(f"  Files to skip: {summary['files_skipped']}")
        console.print(f"  Entries to import: {summary['entries_found']}")

        if summary["details"]:
            console.print("\n  Details:")
            for detail in summary["details"][:5]:  # Show first 5
                console.print(f"    {detail['file']}")
                console.print(f"      {detail['entries']} entries ({detail['types']})")


@main.command()
@click.pass_context
def info(ctx):
    """Show database info and statistics."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        console.print("[red]Database not initialized. Run: claude-workshop init[/red]")
        return

    stats = db.get_stats()
    import_history = db.get_import_history(limit=5)
    db.close()

    console.print("\n[bold]Workshop Database Info[/bold]\n")
    console.print(f"Database: {db.db_path}")
    console.print(f"Total entries: {stats['total']}")
    console.print()

    console.print("[bold]Entries by type:[/bold]")
    for t, count in stats.get("by_type", {}).items():
        console.print(f"  {t}: {count}")
    console.print()

    if import_history:
        console.print("[bold]Recent imports:[/bold]")
        for record in import_history:
            date_str = record.imported_at.strftime("%Y-%m-%d %H:%M")
            console.print(f"  [{date_str}] {record.entries_extracted} entries from {record.file_path[-50:]}")


@main.command()
@click.argument("entry_id", type=int)
@click.pass_context
def delete(ctx, entry_id: int):
    """Delete an entry by ID."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        console.print("[red]Database not initialized.[/red]")
        sys.exit(1)

    # Show entry first
    entry = db.get_entry(entry_id)
    if not entry:
        console.print(f"[red]Entry {entry_id} not found.[/red]")
        sys.exit(1)

    console.print(f"\n[yellow]Entry to delete:[/yellow]")
    console.print(f"  ID: {entry.id}")
    console.print(f"  Type: {entry.type}")
    console.print(f"  Content: {entry.content}")
    if entry.reasoning:
        console.print(f"  Reasoning: {entry.reasoning}")
    console.print()

    if click.confirm("Delete this entry?"):
        db.delete_entry(entry_id)
        console.print(f"[green]Entry {entry_id} deleted.[/green]")
    else:
        console.print("[yellow]Cancelled.[/yellow]")

    db.close()


@main.command()
@click.option("-t", "--type", "entry_type", help="Filter by type")
@click.option("--full", is_flag=True, help="Show full content")
@click.option("--limit", default=50, help="Maximum entries")
@click.pass_context
def read(ctx, entry_type: Optional[str], full: bool, limit: int):
    """Read entries with optional filters."""
    workspace = ctx.obj["workspace"]
    db = Database(workspace)

    if not db.exists():
        console.print("[red]Database not initialized.[/red]")
        return

    if entry_type:
        entries = db.get_entries_by_type(entry_type, limit=limit)
    else:
        entries = db.get_recent_entries(limit=limit)

    db.close()

    if not entries:
        console.print("[yellow]No entries found.[/yellow]")
        return

    # Create table
    table = Table(title=f"Entries ({len(entries)})")
    table.add_column("ID", style="cyan", width=6)
    table.add_column("Date", style="green", width=12)
    table.add_column("Type", style="blue", width=10)
    table.add_column("Content", style="white")
    if full:
        table.add_column("Reasoning", style="dim")

    for entry in entries:
        date_str = entry.created_at.strftime("%Y-%m-%d")
        content = entry.content if full else entry.content[:60]

        if full:
            table.add_row(
                str(entry.id),
                date_str,
                entry.type,
                content,
                entry.reasoning or "",
            )
        else:
            table.add_row(str(entry.id), date_str, entry.type, content)

    console.print(table)


if __name__ == "__main__":
    main()
