# Escalation Model

## Tier 1 — Auto-resolve (agent handles silently)
- Commit, push, lint, format
- Update project_status.md
- Variable names, file structure within patterns
- Run tests, branch management

## Tier 2 — Escalate to executive agent
- Ambiguous story spec → HoP
- Multiple valid technical approaches → HoE
- Code error after 2 attempts → HoE
- Edge case not in story → HoP
- New dependency needed → HoE

## Tier 3 — Escalate to user
- Strategic direction changes
- Fundamentally different architecture choices
- Any assumption being made
- Conflicting HoP vs HoE recommendations
- Spending money (paid APIs, services)
