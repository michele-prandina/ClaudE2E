# Claude Code E2E Boilerplate

A reusable Claude Code configuration with a 3-agent team, Obsidian vault SSOT, 3 MCP servers, and a 7-phase project lifecycle with hard-enforced rules via hooks.

## Quick Start

After cloning this repo into your project, run Claude Code and paste the initialization prompt below. Claude will walk you through filling in all placeholders.

### Initialization Prompt

```
Initialize this workspace for my project. Walk me through the setup:

1. Ask me for my project name, then replace all {{Project}} placeholders across CLAUDE.md, .claude/project_state.md, and obsidian-vault/Home.md.
2. Ask me for my primary languages and tech stack, then fill in the "Codebase Overview" section in CLAUDE.md and the "Tech Stack" section in .claude/project_state.md.
3. Ask me for my developer commands (test, lint, app start), then fill in the placeholders in .claude/agents/developer.md.
4. Ask me for my project directory structure, then fill in that placeholder in .claude/agents/developer.md.
5. Ask me for any language-specific format rules, then fill in that placeholder in .claude/agents/developer.md.
6. Set the project phase to "Discovery" and status to "Starting Discovery phase" in .claude/project_state.md with today's date.
7. Run `python3 .claude/scripts/rebuild-vault-index.py` to generate the vault index.
8. Show me a summary of all changes made.

Ask me one question at a time. Do not assume anything.
```

## What's Included

| Component | Description |
|-----------|-------------|
| `CLAUDE.md` | Orchestrator + Chief of Staff (routes requests, guards SSOT) |
| `.claude/agents/` | 3 agents: Developer, Head of Product, Head of Engineering |
| `.claude/skills/` | Skills: `/deep-research` (full research pipeline with synthesis and validation) |
| `.claude/protocols/` | Shared protocols: vault-sync, error-logging |
| `.claude/hooks/` | Hard enforcement: phase gating, commit format, vault ownership |
| `.claude/scripts/` | Vault maintenance: rebuild index, audit wikilinks |
| `obsidian-vault/` | Obsidian vault — SSOT with research notes, sources, and project docs |

## How It Works

This boilerplate gives you a team of 3 AI agents that collaborate through an Obsidian vault (the single source of truth). Each agent has a defined role, owns specific vault folders, and is structurally prevented from overstepping via shell hooks.

**The agents:**

| Agent | Role | Think of it as... |
|-------|------|-------------------|
| Head of Product | Defines *what* to build and *why* | Your CPO — owns scope, user stories, research. Defaults to `/deep-research` for any topic not in the vault. |
| Head of Engineering | Defines *how* to build it | Your CTO — owns architecture, tech specs, ADRs |
| Developer | Builds it | Your senior dev — owns source code, implements stories |

**Skills:**

| Skill | Trigger | Description |
|-------|---------|-------------|
| Deep Research | `/deep-research <topic>` | Full pipeline: keyword generation, web search, optional user supplement, synthesis into vault note, cross-vault validation |

**The workflow:**
1. Start in **Discovery** (Phase 0) — HoP interviews you across 7 dimensions
2. Progress through **Strategy** → **Product Spec** → **Architecture** → **Backlog**
3. Only in **Implementation** (Phase 5) can anyone write code or commit
4. Each phase transition requires your explicit approval

**The enforcement:**
- `pre-bash.sh` — blocks code/git operations until Implementation phase; enforces conventional commit format
- `post-edit.sh` — blocks agents from editing vault folders they don't own; validates project_state.md
- `session-start.sh` — tracks which agent is active for ownership checks

## Vault Structure

```
obsidian-vault/
├── Home.md
├── Research/
│   ├── Research Index.md          # Hub page linking all deliverables
│   ├── <Synthesized notes>.md     # One per research topic
│   └── Sources/                   # Raw research (Perplexity + agent-generated)
│       └── YYYY-MM-DD-<topic>/    # Created by /deep-research runs
│           ├── keywords.md
│           ├── raw-findings.md
│           └── validation-log.md
├── Strategy/
├── Product/
├── Backlog/
├── Tech Specs/
├── Decision Log/
└── Claude Code/
```

Synthesized vault notes link to their raw sources via `[[wikilinks]]` in `## Sources` sections.

## Prerequisites

- Node.js 18+
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed
- [Obsidian](https://obsidian.md/) app installed
- Java 17+ (for Maestro UI testing)
- iOS Simulator or Android Emulator (for Maestro)

## Setup Steps

### 1. Clone or copy to your project root

```bash
git clone <this-repo> your-project
cd your-project
```

### 2. Make hooks executable

```bash
chmod +x .claude/hooks/*.sh
```

### 3. Install Obsidian Local REST API plugin

1. Open Obsidian
2. Settings > Community Plugins > Browse > Search "Local REST API"
3. Install and Enable
4. Note the API key (Settings > Local REST API > API Key)
5. Default port: 27124

### 4. Configure Obsidian vault path

Point your Obsidian vault to the `obsidian-vault/` directory in your project root.

### 5. Install MCP servers

Add to your Claude Code MCP configuration:

- **obsidian** — `MarkusPfundstein/mcp-obsidian` (vault SSOT operations)
- **context7** — `@upstash/context7-mcp` (real-time library documentation)
- **maestro** — `mobile-next/maestro-mcp` (UI test automation)

### 6. Run the initialization prompt

Start Claude Code and paste the initialization prompt from the Quick Start section above. Claude will walk you through filling in all placeholders for your project.

## MCP Server Configuration

| Server | Requirement | Default |
|--------|-------------|---------|
| Obsidian | App running with Local REST API plugin | Port 27124 |
| Context7 | No config needed | — |
| Maestro | Java 17+, iOS Simulator or Android Emulator booted | — |

## Project Lifecycle

This boilerplate enforces a 7-phase lifecycle via hooks:

| Phase | Owner | Gate |
|-------|-------|------|
| 0. Discovery | HoP | User confirms each of 7 dimensions |
| 1. Strategy | HoP | User approves direction |
| 2. Product Spec | HoP | User approves PRD |
| 3. Architecture | HoE | User approves architecture |
| 4. Backlog | HoP + HoE | User approves backlog |
| 5. Implementation | Developer | Tests pass per story |
| 6. Integration | Developer + HoE | User approves release |

Source code and git operations are **blocked** until Phase 5 (Implementation). This is enforced by the `pre-bash.sh` hook.

## Vault Ownership

Enforced by the `post-edit.sh` hook:

| Vault Folder | Owner |
|--------------|-------|
| `Strategy/`, `Product/`, `Research/` | Head of Product |
| `Tech Specs/`, `Decision Log/` | Head of Engineering |
| `Tech Specs/Known Errors/` | Developer (exception) |
| `Backlog/` | HoP, HoE, Developer |
| Source code (outside vault) | Developer only |

## Customization

### Adding agents

1. Create `.claude/agents/{name}.md` with YAML frontmatter
2. Add to the Agents table in `CLAUDE.md`
3. Update `post-edit.sh` if the agent owns vault folders

### Adding protocols

1. Create `.claude/protocols/{name}.md`
2. Reference in agent files under `<protocols>` section
3. Add to Protocols table in `CLAUDE.md`

### Changing phases

Edit `.claude/project_state.md` — the Phase field is read by hooks to gate actions.
Valid phases: Discovery, Strategy, Product Spec, Architecture, Backlog, Implementation, Integration.

### Removing Maestro (if not doing mobile)

Maestro is optional. If your project doesn't need UI test automation:
1. Remove the `maestro` MCP server from your config
2. Remove Java 17+ and simulator from prerequisites
3. Everything else works without it

## Verification

After setup, verify each agent loads correctly:

```bash
claude --agent head-of-product    # Should show HoP header
claude --agent head-of-engineering # Should show HoE header
claude --agent developer           # Should show Developer header
```

Check hooks are executable:

```bash
ls -la .claude/hooks/
# All .sh files should have -rwxr-xr-x permissions
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Hook blocked unexpectedly | Check `.claude/.current-agent` — it may be stale. Delete it and restart session. |
| "No API key found" from audit script | Ensure Obsidian is running with Local REST API enabled. Set `OBSIDIAN_API_KEY` env var. |
| Phase gating too restrictive during setup | Temporarily set Phase to "Implementation" in `project_state.md`, then reset when done. |
| Hooks not triggering | Verify `settings.json` is in `.claude/` (not `.claude/settings/`). Check `chmod +x` on `.sh` files. |
| Agent can't edit a file it should own | Check `post-edit.sh` — the orchestrator is always allowed. Run as default session to bypass. |
| Python not found in hooks | Hooks use `python3`. Ensure it's in your PATH. |
