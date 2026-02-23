# Setup Workspace — Multi-Agent Boilerplate

> **Purpose**: Instruct Claude Code to recreate this workspace structure in a new project.
> **How to use**: Open Claude Code in a new project and paste:
> "Read `setup-workspace.md` from `<boilerplate-path>` and execute every step."

---

## Step 1: Prerequisites

Before starting, ensure:

- Claude Code CLI installed and authenticated
- Git initialized in the target project directory
- The boilerplate repo (ClaudeE2E) is cloned locally

```bash
BOILERPLATE="/path/to/ClaudeE2E"   # ← Set to your boilerplate checkout
TARGET="."                          # ← The new project directory
```

---

## Step 2: Create Directory Structure

```bash
mkdir -p .claude/rules
mkdir -p .claude/agents
mkdir -p .claude/commands
mkdir -p .claude/hooks
mkdir -p .claude/memory
mkdir -p .agent/rules
mkdir -p .agent/workflows
mkdir -p docs
```

---

## Step 3: Copy Project-Agnostic Files

These files work as-is with no project-specific customization needed.

```bash
# Claude Code rules
cp "$BOILERPLATE/.claude/rules/"*.md              .claude/rules/

# Claude Code agents (8 specialized agent definitions)
cp "$BOILERPLATE/.claude/agents/"*.md             .claude/agents/

# Claude Code commands (slash commands)
cp "$BOILERPLATE/.claude/commands/audit-docs.md"  .claude/commands/
cp "$BOILERPLATE/.claude/commands/compare-docs.md" .claude/commands/
cp "$BOILERPLATE/.claude/commands/shrink-doc.md"  .claude/commands/

# Claude Code hooks
cp "$BOILERPLATE/.claude/hooks/"*.sh              .claude/hooks/
chmod +x .claude/hooks/*.sh

# Claude Code settings + escalation
cp "$BOILERPLATE/.claude/settings.json"           .claude/
cp "$BOILERPLATE/.claude/escalation.md"           .claude/

# Agent rules (project-agnostic subset)
cp "$BOILERPLATE/.agent/rules/cairo-protocol.md"        .agent/rules/
cp "$BOILERPLATE/.agent/rules/intent-clarification.md"  .agent/rules/
cp "$BOILERPLATE/.agent/rules/review-mode.md"           .agent/rules/
cp "$BOILERPLATE/.agent/rules/refactoring-standards.md" .agent/rules/

# Agent workflows
cp "$BOILERPLATE/.agent/workflows/"*.md           .agent/workflows/
```

---

## Step 4: Global User-Level Files

These go in the user's home directory (outside the project). Create only if they don't already exist.

### `~/.claude/CLAUDE.md`

```markdown
# Global Preferences

## Coding Style
- Always use TypeScript strict mode unless workspace specifies otherwise
- Prefer functional patterns over classes
- Use descriptive variable names in business logic, concise in utilities
- Always handle errors explicitly — no silent catches
- Python scrapers: follow existing patterns in each project

## Communication
- Be direct and concise — one topic per response
- Ask focused follow-up questions across turns to understand intent before acting
- If a request is under-specified (vague requirements, missing context, no constraints), MUST ask clarification questions before proceeding — never guess intent on complex tasks
- Be proactive: present your best recommendation with WHY, don't list options for the user to pick
- When uncertain, say so and explain tradeoffs
- After fixing bugs, always explain the root cause

## Memory Behavior
- Proactively save patterns, gotchas, and corrections to auto-memory
- Keep MEMORY.md as a concise index; detailed notes go in topic files
- After major debugging sessions, capture the resolution unprompted

## Code Quality
- Actively resist slop: no duplicated logic, no dead code, no god files
- When you notice emerging mess, flag it — don't silently work around it
- Prefer refactoring existing code over adding workarounds
- Max file length: 300 lines — split if longer
- Max function length: 50 lines — decompose if longer
- No TODO/HACK without a linked issue — every shortcut is tracked

## Cairo Protocol
- For any non-trivial build task: Spec first → Tests second → Implementation third
- Never generate implementation code before the spec is approved and tests are written
- If you cannot describe how to test it, you cannot build it correctly
```

### `~/.gemini/GEMINI.md` (optional — for Gemini CLI users)

```markdown
# Global Preferences

## Coding Style
- Always use TypeScript strict mode unless workspace specifies otherwise
- Prefer functional patterns over classes
- Zero Assumptions — ask if unsure
- Retrieval-led reasoning — search before assuming
- No timelines without confirmation
- Max 2 paragraphs per response section
- Use Mermaid syntax for diagrams
- Always handle errors explicitly — no silent catches

## Code Standards
- **Style**: KISS — Keep It Simple, Stupid
- **Scope**: Minimal changes — only what's directly requested
- **Abstraction**: No premature abstraction — 3 similar lines > helper
- **Typing**: Type hints on all functions
- **Git**: One commit per story: `feat(S{XX}): {description}`

## Behavior
- Be concise and direct — one topic per response
- Ask focused follow-up questions across turns to understand intent before acting
- If a request is under-specified, MUST ask clarification questions before proceeding
- Be proactive: present your best recommendation with WHY, don't list options
- Always check git status first before starting work
- Commit after every completed task
- After fixing bugs, explain the root cause
- Codebase languages: {{languages}}

## MCP Servers Available
- context7 — Real-time library documentation
- maestro — UI test automation
- github — PR, issue, code review operations

## Code Quality
- Actively resist slop in every task — even feature work
- When you notice mess while implementing features, flag it
- Prefer fixing root causes over adding workarounds
- When touching a file, leave it cleaner than you found it
- Max file length: 300 lines — split if longer
- Max function length: 50 lines — decompose if longer

## Cairo Protocol
- For any non-trivial build task: Spec first → Tests second → Implementation third
- Never generate implementation code before the spec is approved and tests are written
- If you cannot describe how to test it, you cannot build it correctly
- See `.agent/rules/cairo-protocol.md` for full workflow

## When Reviewing Code
- Be constructive, not just critical
- Explain the "why" behind suggestions
- Prioritize correctness over style
- Check for consistency with project patterns
```

---

## Step 5: Project-Specific Templates

These files contain `{{placeholders}}` that must be replaced per project. Create them, then replace all placeholders.

### `CLAUDE.md` (project root)

```markdown
# {{Project}} — Claude Code Instructions

<system>
  <role>{{Project}} — routes requests to specialized agents, guards SSOT</role>
  <project>{{Project}}</project>
  <phase>{from project_state.md}</phase>
</system>

## Quick Start
| Hook | What it enforces |
|------|------------------|
| `/agent-stories` | Write agent-optimized user stories |
| `/hop` | Invoke Head of Product for planning, UX, scope |
| `/hoe` | Invoke Head of Engineering for architecture, tech specs |
| `/design` | Invoke Designer for service/visual/interaction design |
| `/uxe` | Invoke UX Engineer for tokens, design system, user stories |

## Knowledge Map

### Core Resources
- **Project Structure**: `.claude/lifecycle.md` (Phases)
- **Escalation**: `.claude/escalation.md` (Tiers)
- **Global Rules**: `.claude/rules/global.md`
- **Safety**: `.claude/rules/safety.md`
- **Cairo Protocol**: `.claude/rules/cairo-protocol.md` (Spec → Test → Build)
- **Intent Clarification**: `.claude/rules/intent-clarification.md` (Ask before building)
- **Agents**: `.claude/agents/*.md`

### Source of Truth
- **Project Status**: `.claude/memory/project_status.md`
- **Data Types**: `{{path-to-types}}`
- **Database Schema**: `{{path-to-migrations}}`

## Module Knowledge (read on-demand)
- {{module-1}}: see `{{path}}/CLAUDE.md`
- {{module-2}}: see `{{path}}/CLAUDE.md`

## Context Loading
1. Read `.claude/memory/project_status.md` — cached key facts
2. ONLY scan source code if docs are missing/outdated

### Subagent Preamble (MANDATORY)
When spawning ANY subagent, prepend:
> CONTEXT: Read .claude/memory/project_status.md first.
> Only scan source code if docs are missing/outdated.

## Code Standards

<constraints>
  <style>KISS — Keep It Simple, Stupid</style>
  <scope>Minimal changes — only what's directly requested</scope>
  <abstraction>No premature abstraction — 3 similar lines > helper</abstraction>
  <typing>Type hints on all functions</typing>
  <git>One commit per story: feat(S{XX}): {description}</git>
</constraints>

## Code Quality Hard Rules
- Max file length: 300 lines. If longer, split into focused modules.
- Max function length: 50 lines. If longer, decompose.
- No duplicated logic across files — extract into shared utilities.
- No dead code. Delete unused functions, imports, and variables.
- No workarounds for problems in other files — fix the root cause.
- No TODO/HACK without a linked issue — every shortcut is tracked.

## Workflow Preferences
- **Cairo Protocol**: Spec → Test → Build. See `.claude/rules/cairo-protocol.md`.
- **Multi-step tasks**: Confirm completion of each phase before proceeding
- **Codebase languages**: {{languages}}. Maintain consistency with existing patterns

## Self-Improvement Protocol
When during a session:
- You fix a bug: save error, root cause, and fix to auto-memory
- I correct your approach: save the correction immediately
- You discover a non-obvious behavior: document in a memory topic file
- A debugging session takes >2 attempts: capture the resolution
- You notice code smell or emerging slop: flag it explicitly

## Documentation Maintenance
When you modify, move, or delete files across directories:
1. Check if affected directories have CLAUDE.md files needing updates
2. If a module's scope changed, update its CLAUDE.md
3. Remove references to deprecated patterns

## Known Pitfalls

| Issue | Solution |
|-------|----------|
| Git filename casing mismatch | Check actual filename before `git add` |

## MCP Servers
- `context7` — Real-time library documentation
- `maestro` — UI test automation (run tests, simulator, screenshots)
- `github` — PR, issue, code review operations

## Response Header (MANDATORY)
```
{Emoji} **{Agent_Name}**
📍 **Current Phase**: {from project_state.md}
└─ **Status**: {from project_state.md}
---
```
Default: **{{Project}} Assistant**
```

### `.claude/lifecycle.md`

```markdown
# Project Lifecycle

| Phase | Name | Owner | Gate |
|-------|------|-------|------|
| 0 | Setup | Orchestrator | All {{Project}} placeholders replaced |
| 1 | Research & Discovery | HoP + Deep Research | User confirms understanding |
| 2 | Strategy | HoP | User approves direction |
| 3 | Product Spec | HoP + Designer + UXE | PRD approved |
| 4 | Architecture | HoE | User approves architecture |
| 5 | Backlog | UXE (informed by HoP + HoE) | User approves stories |
| 6 | Implementation | Developer + FE Developer | Tests pass per story |
| 7 | Integration | Developer + FE Developer + HoE | User approves release |

Phases 4-5 can run in parallel. User can jump between phases.
```

### `.claude/memory/project_status.md`

```markdown
# Project Status

**Project**: {{Project}}
**Phase**: Setup
**Status**: Initializing workspace

## Current Focus
- Setting up workspace infrastructure

## Key Decisions
- (none yet)

## Open Questions
- (none yet)
```

### `.agent/rules/shared-standards.md`

```markdown
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
- **Ask to understand**: Use focused follow-up questions across multiple turns.
- **Be proactive**: Present your best recommendation with WHY.

## Cairo Protocol
- For any non-trivial build task: Spec → Test → Build
- Never write implementation before spec approval and tests exist

## MCP Servers Available
- `context7` — Real-time library documentation
- `maestro` — UI test automation
- `github` — PR, issue, code review operations
```

### `.agent/rules/project-instructions.md`

```markdown
# Project Instructions

## Project Overview
- **Project**: {{Project}}
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
```

### Placeholder Replacement

After creating all template files, replace placeholders:

```bash
# Replace {{Project}} everywhere
find . -name "*.md" -not -path "./node_modules/*" \
  -exec grep -l '{{Project}}' {} \; \
  | xargs sed -i '' 's/{{Project}}/YourProjectName/g'

# Then manually update in each file:
# - {{languages}} → e.g., "TypeScript, Python"
# - {{path-to-types}}, {{path-to-migrations}} → actual paths
# - {{module-1}}, {{module-2}} → actual module names and paths
# - {{framework, database, etc.}} → actual stack description
```

---

## Step 6: Seed Auto-Memory

The auto-memory path is generated by Claude Code. Run `/memory` in a session to find it. Seed it with:

### `~/.claude/projects/{{project-hash}}/memory/MEMORY.md`

```markdown
# Project Memory Index

## Project Overview
- {{Project}}: {{one-line description}}
- Stack: {{languages and frameworks}}

## Key Patterns
- (populated as you work)

## Architecture Decisions
- (populated as you work)

## Gotchas
- (populated as you work)
```

---

## Step 7: Verification

After creating all files, verify:

```
.claude/rules/          → global.md, safety.md, cairo-protocol.md, intent-clarification.md
.claude/agents/         → researcher.md, bug-tracker.md, head-of-product.md,
                           head-of-engineering.md, developer.md, frontend-developer.md,
                           designer.md, uxe.md
.claude/commands/       → audit-docs.md, compare-docs.md, shrink-doc.md
.claude/hooks/          → session-start.sh, pre-bash.sh, post-edit.sh (all executable)
.claude/settings.json   → hooks wired, permissions set
.claude/lifecycle.md    → 8 phases
.claude/escalation.md   → 3 tiers
.claude/memory/         → project_status.md seeded
CLAUDE.md               → all {{Project}} placeholders replaced
.agent/rules/           → shared-standards.md, cairo-protocol.md, intent-clarification.md,
                           refactoring-standards.md, review-mode.md, project-instructions.md
.agent/workflows/       → slop-scan.md, refactor-sprint.md, health-check.md,
                           review-changes.md, sync-knowledge.md
docs/                   → directory exists for shared documentation
~/.claude/CLAUDE.md     → global preferences
~/.gemini/GEMINI.md     → global preferences (optional)
```

### File Ownership

```
FILE / DIRECTORY               OWNED BY           READ BY
──────────────────────────────────────────────────────────
CLAUDE.md (root)               Claude Code        Both
{{module}}/CLAUDE.md           Claude Code        Claude Code only
.claude/rules/*.md             Claude Code        Claude Code only
.claude/settings.json          Human              Claude Code
.claude/agents/*.md            Human              Claude Code
~/.claude/CLAUDE.md            Human              Claude Code (all projects)
~/.claude/projects/*/memory/   Claude Code        Claude Code only

.agent/rules/*.md              Human              Any LLM/CLI tool
.agent/workflows/*.md          Human              Any LLM/CLI tool
~/.gemini/GEMINI.md            Human              Gemini-based tools (all projects)

docs/                          Any agent          Any agent
git history                    Both               Both
```

### File Count Summary

| Category | Count |
|----------|-------|
| `.claude/rules/` | 4 |
| `.claude/agents/` | 8 |
| `.claude/commands/` | 3 |
| `.claude/hooks/` | 3 |
| `.claude/` (other) | 4 (settings.json, escalation.md, lifecycle.md, memory/project_status.md) |
| `.agent/rules/` | 6 |
| `.agent/workflows/` | 5 |
| Root | 1 (CLAUDE.md) |
| User-level | 2 (~/.claude/CLAUDE.md, auto-memory/MEMORY.md) |
| **Total** | **36** |
