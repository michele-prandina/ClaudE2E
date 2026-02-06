"""Audit vault wikilinks via the Obsidian Local REST API.

Connects to the same REST API used by the MCP server (MarkusPfundstein/mcp-obsidian).
Reports: missing wikilinks, orphan notes, and cross-reference gaps.

Usage: python3 .claude/scripts/audit-vault-wikilinks.py
Env:   OBSIDIAN_API_KEY (optional, falls back to plugin data.json)
       OBSIDIAN_PORT    (optional, default 27124)
"""

import json
import os
import re
import ssl
import urllib.request

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.join(SCRIPT_DIR, "..", "..")
PLUGIN_DATA = os.path.join(
    PROJECT_ROOT,
    "obsidian-vault",
    ".obsidian",
    "plugins",
    "obsidian-local-rest-api",
    "data.json",
)

# Folders/files to skip in orphan detection (structural, not content)
SKIP_PREFIXES = (
    ".obsidian/",
    "Backlog/Stories/",
    "Backlog/Templates/",
    "Tech Specs/Known Errors/",
)

SKIP_FILES = {"README.md"}

# Wikilink regex: [[Target]] or [[Target|Alias]]
WIKILINK_RE = re.compile(r"\[\[([^\]\|]+)(?:\|[^\]]+)?\]\]")
# Code block regex: ```...``` (multiline) and inline `...`
CODE_BLOCK_RE = re.compile(r"```[\s\S]*?```")
INLINE_CODE_RE = re.compile(r"`[^`]+`")


def get_config() -> tuple[str, int]:
    """Get API key and port from env or plugin config."""
    api_key = os.environ.get("OBSIDIAN_API_KEY", "")
    port = int(os.environ.get("OBSIDIAN_PORT", "27124"))

    if not api_key and os.path.exists(PLUGIN_DATA):
        with open(PLUGIN_DATA) as f:
            data = json.load(f)
        api_key = data.get("apiKey", "")
        port = data.get("port", port)

    return api_key, port


def api_get(path: str, api_key: str, port: int) -> dict | list | str:
    """Make a GET request to the Obsidian REST API."""
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    url = f"https://127.0.0.1:{port}{path}"
    req = urllib.request.Request(
        url,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Accept": "application/json",
        },
    )
    with urllib.request.urlopen(req, context=ctx) as resp:
        content_type = resp.headers.get("Content-Type", "")
        body = resp.read().decode("utf-8")
        if "json" in content_type:
            return json.loads(body)
        return body


def list_dir(dirpath: str, api_key: str, port: int) -> list[str]:
    """List files in a vault directory via API. Returns relative paths."""
    safe = urllib.request.quote(dirpath, safe="/")
    endpoint = f"/vault/{safe}/" if dirpath else "/vault/"
    result = api_get(endpoint, api_key, port)
    if isinstance(result, dict) and "files" in result:
        return result["files"]
    return []


def list_all_files(api_key: str, port: int) -> list[str]:
    """Recursively list all vault files via API."""
    all_files: list[str] = []
    dirs_to_visit = [""]
    while dirs_to_visit:
        d = dirs_to_visit.pop()
        entries = list_dir(d, api_key, port)
        for entry in entries:
            path = f"{d}/{entry}" if d else entry
            if entry.endswith("/"):
                dirs_to_visit.append(path.rstrip("/"))
            else:
                all_files.append(path)
    return all_files


def get_file_content(path: str, api_key: str, port: int) -> str:
    """Get file content via API."""
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    url = f"https://127.0.0.1:{port}/vault/{urllib.request.quote(path, safe='/')}"
    req = urllib.request.Request(
        url,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Accept": "text/markdown",
        },
    )
    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            return resp.read().decode("utf-8")
    except Exception as e:
        return f"[ERROR reading {path}: {e}]"


def stem(filepath: str) -> str:
    """Get the note name (stem) from a path: 'Folder/My Note.md' -> 'My Note'."""
    return os.path.splitext(os.path.basename(filepath))[0]


def should_skip(filepath: str) -> bool:
    """Check if file should be skipped in orphan analysis."""
    if os.path.basename(filepath) in SKIP_FILES:
        return True
    return any(filepath.startswith(p) for p in SKIP_PREFIXES)


def extract_wikilinks(content: str) -> set[str]:
    """Extract all wikilink targets from markdown content, ignoring inline code."""
    stripped = CODE_BLOCK_RE.sub("", content)
    stripped = INLINE_CODE_RE.sub("", stripped)
    return set(WIKILINK_RE.findall(stripped))


def main() -> None:
    api_key, port = get_config()
    if not api_key:
        print("ERROR: No API key found. Set OBSIDIAN_API_KEY or check plugin config.")
        return

    print("Connecting to Obsidian REST API...")
    all_files = list_all_files(api_key, port)
    md_files = [f for f in all_files if f.endswith(".md")]
    print(f"Found {len(md_files)} markdown files\n")

    # Build lookup: note stem -> filepath
    stem_to_path: dict[str, str] = {}
    for f in md_files:
        s = stem(f)
        stem_to_path[s] = f

    # Collect all wikilinks and which notes are linked to
    all_outgoing: dict[str, set[str]] = {}
    all_linked_stems: set[str] = set()

    for filepath in md_files:
        if filepath.startswith(".obsidian/"):
            continue
        content = get_file_content(filepath, api_key, port)
        links = extract_wikilinks(content)
        all_outgoing[filepath] = links
        all_linked_stems.update(links)

    # === REPORT ===
    print("=" * 70)
    print("VAULT WIKILINK AUDIT REPORT")
    print("=" * 70)

    # 1. Broken links
    print("\n## BROKEN LINKS (wikilink target doesn't exist)")
    broken_count = 0
    for filepath, links in sorted(all_outgoing.items()):
        broken = [lnk for lnk in sorted(links) if lnk not in stem_to_path]
        if broken:
            broken_count += len(broken)
            print(f"  {filepath}:")
            for b in broken:
                print(f"    -> [[{b}]] NOT FOUND")
    if broken_count == 0:
        print("  None found.")
    else:
        print(f"  Total: {broken_count} broken links")

    # 2. Orphan notes
    print("\n## ORPHAN NOTES (not linked from any other note)")
    orphans = []
    for filepath in sorted(md_files):
        if should_skip(filepath) or filepath.startswith(".obsidian/"):
            continue
        s = stem(filepath)
        if s not in all_linked_stems and filepath != "Home.md":
            orphans.append(filepath)
    if orphans:
        for o in orphans:
            print(f"  {o}")
        print(f"  Total: {len(orphans)} orphan notes")
    else:
        print("  None found.")

    # 3. Notes with zero outgoing links
    print("\n## NOTES WITH NO OUTGOING LINKS (islands)")
    islands = []
    for filepath, links in sorted(all_outgoing.items()):
        if should_skip(filepath):
            continue
        if len(links) == 0:
            islands.append(filepath)
    if islands:
        for i in islands:
            print(f"  {i}")
        print(f"  Total: {len(islands)} island notes")
    else:
        print("  None found.")

    print("\n" + "=" * 70)
    print("END OF REPORT")
    print("=" * 70)


if __name__ == "__main__":
    main()
