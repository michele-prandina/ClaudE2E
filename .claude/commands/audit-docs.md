Scan the project for all CLAUDE.md files and .claude/rules/*.md files. For each one:
1. Check if any referenced paths point to files/directories that no longer exist
2. Check if the described patterns still match the actual code in that directory
3. Report any stale, orphaned, or contradictory documentation
4. Suggest specific updates

Output a summary of what needs fixing.
