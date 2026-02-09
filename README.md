# Claude Code E2E Boilerplate

A reusable Claude Code configuration with a 6-agent team, Obsidian vault SSOT, 6 MCP servers, agent teams support, and a 7-phase project lifecycle with hard-enforced rules via hooks.

## Quick Start

1. Clone this repo into your project root
2. Make hooks executable: `chmod +x .claude/hooks/*.sh`
3. Configure MCP servers (see below)
4. Start Claude Code and ask it to initialize the workspace — it will walk you through filling in all `{{Project}}` and `{fill in}` placeholders across agent files and CLAUDE.md

## What's Included

| Component | Description |
|-----------|-------------|
| `CLAUDE.md` | Orchestrator + Chief of Staff (routes requests, guards SSOT) |
| `.claude/agents/` | 6 agents: Developer, Frontend Developer, Designer, UX Engineer, Head of Product, Head of Engineering |
| `.claude/skills/` | Skills: Deep Research (multi-phase pipeline), Maestro (UI testing) |
| `.claude/protocols/` | Shared protocols: vault-sync, error-logging |
| `.claude/hooks/` | Hard enforcement: phase gating, commit format, vault ownership |
| `.claude/scripts/` | Vault maintenance: rebuild index, audit wikilinks |
| `obsidian-vault/` | Obsidian vault — SSOT with research notes, sources, and project docs |

## How It Works

This boilerplate gives you a team of 6 AI agents that collaborate through an Obsidian vault (the single source of truth). Each agent has a defined role, owns specific vault folders, and is structurally prevented from overstepping via shell hooks.

**The agents:**

| Agent | Role | Think of it as... |
|-------|------|-------------------|
| Head of Product | Defines *what* to build and *why* | Your CPO — owns scope, user stories, research |
| Head of Engineering | Defines *how* to build it | Your CTO — owns architecture, tech specs, ADRs |
| Designer | Designs *how it looks and feels* | Your product designer — owns service design, visual design, branding |
| UX Engineer | Bridges design and code | Your design engineer — owns tokens, design system, writes user stories |
| Developer | Builds the backend | Your senior backend dev — owns server-side code, implements stories |
| Frontend Developer | Builds the frontend | Your senior frontend dev — owns client-side code, implements UI stories |

**Agent Teams:** Head of Engineering can spawn teams of Developers, Frontend Developers, and UX Engineers for parallel work. Head of Product can spawn teams of Designers and UX Engineers. This requires the `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` environment variable (pre-configured in settings.json).

**Skills:**

| Skill | Trigger | Description |
|-------|---------|-------------|
| Deep Research | `/deep-research <topic>` | Multi-phase pipeline: planner, parallel retrievers, gap analysis, writer, verifier |
| Maestro | `/maestro` | Create and run Maestro UI test flows |
| Dynamic Skills | `npx skills find [keywords]` | All agents can discover and install skills from skills.sh |

**The workflow:**
1. Start in **Discovery** (Phase 0) — HoP interviews you across 7 dimensions
2. Progress through **Strategy** > **Product Spec** > **Architecture** > **Backlog**
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
- Java 17+ (for Maestro UI testing, optional)
- iOS Simulator or Android Emulator (for Maestro, optional)
- [Figma](https://www.figma.com/) account (for design workflows, optional)
- Figma Desktop + Talk-to-Figma plugin (for direct Figma manipulation, optional)

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

### 5. Configure MCP servers

Update `.mcp.json` with your credentials:

- **obsidian** — Set `OBSIDIAN_API_KEY` to your Local REST API key
- **context7** — No configuration needed
- **maestro** — Set `<HOME_DIR>` to your home directory path
- **figma** — No configuration needed (uses Figma account auth)
- **github** — Set `<YOUR_GITHUB_TOKEN>` to your GitHub token
- **talk-to-figma** — Set `<PATH_TO_TALK_TO_FIGMA_SERVER>` to the server.js location

### 6. Initialize the workspace

Start Claude Code and ask it to initialize the workspace. It will walk you through:
1. Setting your project name (replaces `{{Project}}` placeholders)
2. Defining your tech stack and languages
3. Filling in developer/frontend commands (test, lint, start)
4. Setting up project structure
5. Configuring language-specific rules
6. Setting the initial project phase

## MCP Server Configuration

| Server | Requirement | Default |
|--------|-------------|---------|
| Obsidian | App running with Local REST API plugin | Port 27124 |
| Context7 | No config needed | — |
| Maestro | Java 17+, iOS Simulator or Android Emulator booted | — |
| Figma | Figma account authentication | — |
| Talk-to-Figma | Figma Desktop + plugin + WebSocket server | — |
| GitHub | GitHub token | — |

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
| `Design/` | Designer, UX Engineer |
| `Backlog/` | HoP, HoE, Developer, UXE |
| Source code (outside vault) | Developer, Frontend Developer, UXE |

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

### Removing optional MCP servers

Maestro, Figma, Talk-to-Figma, and GitHub are optional. If your project doesn't need them:
1. Remove the server from `.mcp.json`
2. Remove from `enabledMcpjsonServers` in `.claude/settings.local.json`
3. Remove related prerequisites
4. Everything else works without them

## Verification

After setup, verify each agent loads correctly:

```bash
claude --agent head-of-product      # Should show HoP header
claude --agent head-of-engineering   # Should show HoE header
claude --agent developer             # Should show Developer header
claude --agent frontend-developer    # Should show FE Developer header
claude --agent designer              # Should show Designer header
claude --agent uxe                   # Should show UXE header
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
| Agent teams not working | Verify `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set in `.claude/settings.json` under `env`. |
