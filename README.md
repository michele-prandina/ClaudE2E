# Claude Code Boilerplate

A reusable Claude Code configuration with a 3-agent team, Obsidian vault SSOT, 3 MCP servers, and a 7-phase project lifecycle with hard-enforced rules via hooks.

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

### 1. Copy to your project root

```bash
cp -r exported_claude_config/* your-project/
cp -r exported_claude_config/.claude your-project/
```

### 2. Install Obsidian Local REST API plugin

1. Open Obsidian
2. Settings > Community Plugins > Browse > Search "Local REST API"
3. Install and Enable
4. Note the API key (Settings > Local REST API > API Key)
5. Default port: 27124

### 3. Configure Obsidian vault path

Point your Obsidian vault to the `obsidian-vault/` directory in your project root.

### 4. Install MCP servers

Add to your Claude Code MCP configuration:

- **obsidian** — `MarkusPfundstein/mcp-obsidian` (vault SSOT operations)
- **context7** — `@upstash/context7-mcp` (real-time library documentation)
- **maestro** — `mobile-next/maestro-mcp` (UI test automation)

### 5. Install skills CLI (optional)

```bash
npx skills add https://github.com/vercel-labs/skills --skill find-skills
```

### 6. Make hooks executable

```bash
chmod +x .claude/hooks/*.sh
```

### 7. Fill in placeholders

Edit `CLAUDE.md` and replace all `{placeholders}` with your project info:

- `{Project Name}` — your project name
- `{fill in}` — your primary languages and stack

### 8. Set initial project state

Edit `.claude/project_state.md`:
- Set Phase to "Discovery"
- Set Status to your starting status

### 9. Update vault Home

Edit `obsidian-vault/Home.md`:
- Replace `{Project Name}` with your project name

## MCP Server Configuration

| Server | Requirement | Default |
|--------|-------------|---------|
| Obsidian | App running with Local REST API plugin | Port 27124 |
| Context7 | No config needed | — |
| Maestro | Java 17+, iOS Simulator or Android Emulator booted | — |

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

Verify settings.json is valid:

```bash
python3 -c "import json; json.load(open('.claude/settings.json')); print('Valid JSON')"
```

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

## Placeholder Checklist

All files that need customization before first use:

| File | Placeholder | What to fill in |
|------|------------|-----------------|
| `CLAUDE.md` | `{Project Name}` | Your project name (appears 4 times) |
| `CLAUDE.md` | `{fill in your primary languages}` | e.g., "TypeScript, Python" |
| `.claude/project_state.md` | `{current milestone}` | Your first milestone name |
| `.claude/project_state.md` | `{progress summary}` | e.g., "Starting Discovery phase" |
| `.claude/project_state.md` | `{date}` | Today's date |
| `.claude/agents/developer.md` | `{fill in test command}` | e.g., "pytest tests/ -v" |
| `.claude/agents/developer.md` | `{fill in lint command}` | e.g., "eslint . --fix" |
| `.claude/agents/developer.md` | `{fill in app start command}` | e.g., "npm run dev" |
| `.claude/agents/developer.md` | `{fill in your tech stack}` | e.g., "Next.js, PostgreSQL, Prisma" |
| `.claude/agents/developer.md` | `{fill in your project directory structure}` | e.g., "src/app/ (pages), src/lib/ (utils)" |
| `.claude/agents/developer.md` | `{fill in language-specific format rules}` | e.g., "PEP 8, max 100 chars" |
| `obsidian-vault/Home.md` | `{Project Name}` | Your project name |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Hook blocked unexpectedly | Check `.claude/.current-agent` — it may be stale. Delete it and restart session. |
| "No API key found" from audit script | Ensure Obsidian is running with Local REST API enabled. Set `OBSIDIAN_API_KEY` env var. |
| Phase gating too restrictive during setup | Temporarily set Phase to "Implementation" in `project_state.md`, then reset when done. |
| Hooks not triggering | Verify `settings.json` is in `.claude/` (not `.claude/settings/`). Check `chmod +x` on `.sh` files. |
| Agent can't edit a file it should own | Check `post-edit.sh` — the orchestrator is always allowed. Run as default session to bypass. |
| Python not found in hooks | Hooks use `python3`. Ensure it's in your PATH. |
