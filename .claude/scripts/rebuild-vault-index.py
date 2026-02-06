"""Rebuild .claude/vault-index.md from obsidian-vault frontmatter.

Walks the obsidian-vault/ directory, reads YAML frontmatter from each .md file,
and generates a vault-index.md with file paths, descriptions, and tags.

Usage: python3 .claude/scripts/rebuild-vault-index.py
"""

import glob
import os


VAULT_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "obsidian-vault")
OUTPUT = os.path.join(os.path.dirname(__file__), "..", "vault-index.md")


def extract_frontmatter(filepath: str) -> tuple[str, str]:
    """Extract description and tags from YAML frontmatter."""
    with open(filepath) as f:
        content = f.read()

    if not content.startswith("---"):
        return "", ""

    end = content.index("---", 3)
    fm = content[3:end]

    desc = ""
    tags = ""
    for line in fm.strip().split("\n"):
        if line.startswith("description:"):
            desc = line.split(":", 1)[1].strip().strip('"').strip("'")
        elif line.startswith("tags:"):
            tags = line.split(":", 1)[1].strip()

    return desc, tags


def main() -> None:
    vault = os.path.abspath(VAULT_DIR)
    files = sorted(glob.glob(os.path.join(vault, "**/*.md"), recursive=True))

    rows: list[str] = []
    for filepath in files:
        rel = os.path.relpath(filepath, vault)
        desc, tags = extract_frontmatter(filepath)
        rows.append(f"| {rel} | {desc} | {tags} |")

    header = (
        "# Vault Index\n\n"
        "> Auto-generated from obsidian-vault frontmatter.\n"
        "> Rebuild: `python3 .claude/scripts/rebuild-vault-index.py`\n\n"
        "| Path | Description | Tags |\n"
        "|------|-------------|------|\n"
    )

    with open(os.path.abspath(OUTPUT), "w") as f:
        f.write(header + "\n".join(rows) + "\n")

    print(f"Generated vault-index.md with {len(rows)} entries")


if __name__ == "__main__":
    main()
