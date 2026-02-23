# Refactoring Standards

When refactoring code in this project:
- Never change behavior while restructuring — refactor and feature work are separate commits
- Run tests after every structural change
- When extracting shared utilities, place them in the nearest common ancestor directory
- Update imports in ALL consuming files, not just the one you're working on
- If a refactor touches >10 files, break it into smaller PRs
- Update the relevant CLAUDE.md if architecture changed
