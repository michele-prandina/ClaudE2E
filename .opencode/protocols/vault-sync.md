# Vault Sync Protocol

> **Inherited by all agents.** Do not duplicate in agent files.

After every meaningful action, update the Obsidian vault inline:

1. **Detect**: What changed? (code, decision, config, research, status)
2. **Route**: Which vault note needs updating?
3. **Write**: Edit the note surgically (edit tool, not full rewrite)
4. **Tag**: Ensure YAML frontmatter `tags:` exists -- add `type/*` + `domain/*` tags
5. **Describe**: Ensure YAML frontmatter `description:` exists -- a one-sentence semantic summary (10-25 words)
6. **Link**: Add `[[wikilinks]]` to related notes
7. **State**: Update AGENTS.md if status changed
8. **Index**: If vault files were added, removed, or renamed, rebuild the vault index

## Rules

- **Do this inline** -- NEVER delegate vault updates to sub-tasks
- **Vault is the second brain** -- If it's not in the vault, the next session won't know about it
- **Use edit tools** for surgical updates, not full file rewrites
