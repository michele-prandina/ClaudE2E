# Shared Project Standards

(Synced with CLAUDE.md)

## Codebase Overview
- **Languages**: {{languages}}
- **Stack**: {{framework, database, etc.}}

## Module Knowledge
- {{module}}: `{{path}}/CLAUDE.md`

## Code Standards
- **Style**: KISS — Keep It Simple, Stupid
- **Scope**: Minimal changes — only what's directly requested
- **Abstraction**: No premature abstraction — 3 similar lines > helper
- **Typing**: Type hints on all functions
- **Git**: One commit per story: `feat(S{XX}): {description}`

## Code Quality Enforcement
- Max file length: 300 lines. If longer, split into focused modules.
- Max function length: 50 lines. If longer, decompose.
- No duplicated logic across files — extract into shared utilities.
- No dead code. Delete unused functions, imports, and variables.
- No workarounds for problems in other files — fix the root cause.
- No TODO/HACK without a linked issue — every shortcut is tracked.

## Communication Rules
- **One topic at a time**: Focus each response on a single decision or topic.
- **Ask to understand**: Use focused follow-up questions across multiple turns — never bundle decisions.
- **Be proactive**: Present your best recommendation with WHY. Do NOT list options for the user to pick.

## Cairo Protocol
- For any non-trivial build task: Spec → Test → Build (see `.agent/rules/cairo-protocol.md`)
- Never write implementation before spec approval and tests exist

## MCP Servers Available
- `context7` — Real-time library documentation
- `maestro` — UI test automation
- `github` — PR, issue, code review operations

## Dual-Agent Awareness
This workspace uses Claude Code (Opus 4.6) + Antigravity (Gemini 3 Pro).
- Do NOT modify `CLAUDE.md` or `.claude/` files — those belong to Claude Code
- Always commit after completing a task
- Check git status before starting work to see what Claude Code changed
