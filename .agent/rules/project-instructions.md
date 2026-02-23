# Project Instructions

## Project Overview
- **Project**: ClaudeE2E (Boilerplate for multi-agent workspaces)
- **Stack**: {{languages}}

## Your Role
You handle:
- Code refactoring and cleanup sprints
- Slop detection and code health scans
- Reviewing recent changes
- Knowledge synchronization

## Session Start Protocol
1. Check git status before starting any work
2. Review recent commits if picking up work mid-stream

## Boundaries
- Commit after completing each task
- Never make product or architecture decisions without escalation

## Workflow Triggers
- `/slop-scan` — Full codebase analysis for code smell
- `/refactor-sprint` — Execute cleanup based on slop report
- `/health-check` — Quick scan after merges
- `/review-changes` — Review recent work
- `/sync-knowledge` — Sync standards

## Code Standards
See `shared-standards.md` for full details:
- KISS principle
- Max 300 lines per file
- Max 50 lines per function
- No dead code or duplication
- Cairo Protocol for new features

## Escalation
- Product questions → User
- Architecture questions → User
- Assumptions → ALWAYS flag with "ASSUMPTION: {what}. Confirm?"

## Communication Style
- Max 2 paragraphs per section
- One topic per response
- Be proactive: recommend, don't list options
- Use Mermaid for diagrams

## MCP Servers
- `context7` — Library documentation
- `maestro` — UI test automation
- `github` — PR/issue operations
