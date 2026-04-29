#!/usr/bin/env python3
"""Preliminary sync check between chunks/ and a rendered CLAUDE.md.

Output is advisory ("maybe needs sync"), not authoritative. The agent should
re-read individual chunks for anything flagged DRIFT, and resolve conditional
include markers itself.

Usage:
    check-sync.py [path-to-live-claude-md]

Defaults to ~/.claude/CLAUDE.md.
"""

from __future__ import annotations

import os
import re
import sys
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
CHUNKS_DIR = SCRIPT_DIR / "chunks"

FRONTMATTER_RE = re.compile(r"\A---\n(.*?)\n---\n(.*)\Z", re.DOTALL)
ID_RE = re.compile(r"^id:\s*(\S+)\s*$", re.MULTILINE)


def parse_chunk(path: Path) -> tuple[str, str]:
    text = path.read_text()
    m = FRONTMATTER_RE.match(text)
    if not m:
        raise ValueError(f"{path}: missing frontmatter")
    id_match = ID_RE.search(m.group(1))
    if not id_match:
        raise ValueError(f"{path}: missing id in frontmatter")
    return id_match.group(1), m.group(2).strip()


def extract_block(live: str, chunk_id: str) -> str | None:
    open_tag = f"<!-- chunk:{chunk_id} -->"
    close_tag = f"<!-- /chunk:{chunk_id} -->"
    start = live.find(open_tag)
    if start == -1:
        return None
    end = live.find(close_tag, start)
    if end == -1:
        return None
    return live[start + len(open_tag):end].strip()


def find_orphan_h2s(live: str) -> list[str]:
    sentinel_re = re.compile(
        r"<!-- chunk:[^ ]+ -->.*?<!-- /chunk:[^ ]+ -->", re.DOTALL
    )
    masked = sentinel_re.sub("", live)
    return [line for line in masked.splitlines() if line.startswith("## ")]


def main() -> int:
    live_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(
        os.path.expanduser("~/.claude/CLAUDE.md")
    )

    chunk_files = sorted(p for p in CHUNKS_DIR.glob("*.md") if p.name != "INDEX.md")
    chunks = [parse_chunk(p) for p in chunk_files]

    print(f"live: {live_path}")
    if not live_path.exists():
        print("status: live file does not exist — skill should create it from scratch")
        print(f"chunks available: {len(chunks)}")
        return 0

    live = live_path.read_text()

    matches: list[str] = []
    drifts: list[str] = []
    missing: list[str] = []

    for chunk_id, chunk_body in chunks:
        live_body = extract_block(live, chunk_id)
        if live_body is None:
            missing.append(chunk_id)
        elif live_body == chunk_body:
            matches.append(chunk_id)
        else:
            drifts.append(chunk_id)

    orphans = find_orphan_h2s(live)

    print(f"matches: {len(matches)}")
    for cid in matches:
        print(f"  MATCH    {cid}")
    print(f"drifts: {len(drifts)} (re-read these chunks; conditional markers may cause false positives)")
    for cid in drifts:
        print(f"  DRIFT    {cid}")
    print(f"missing: {len(missing)}")
    for cid in missing:
        print(f"  MISSING  {cid}")
    print(f"orphan H2 sections (outside sentinels, leave untouched): {len(orphans)}")
    for h in orphans:
        print(f"  ORPHAN   {h}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
