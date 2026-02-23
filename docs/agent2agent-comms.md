# Agent Communication — Implementation Plan

## Summary

Bidirectional communication between Claude Code (CC) and Antigravity (AG):
- **CC → AG**: File-based (`docs/agent-comms/cc-to-ag.md`)
- **AG → CC**: Auto-start MCP (`claude mcp serve`)

---

## Architecture

```
Claude Code                              Antigravity
     │                                        │
     │──── file write ────▶ cc-to-ag.md ─────▶│
     │                                        │
     │◀──── MCP call ◀──── claude-code MCP ───│
```

---

## CC → AG (File-based)

```
docs/agent-comms/
├── README.md        # Protocol docs
├── cc-to-ag.md      # CC writes requests here
└── ag-to-cc.md      # AG writes responses here

.claude/commands/
├── ask-ag.md        # /ask-ag <prompt>
└── check-ag.md      # /check-ag

.agent/workflows/
└── check-cc.md      # /check-cc
```

### Usage (Claude Code)
- `/ask-ag <prompt>` — Write request for Antigravity
- `/check-ag` — Check for response from Antigravity

### Usage (Antigravity)
- `/check-cc` — Check for pending requests from Claude Code
- **Auto-check**: AG's Session Start Protocol runs `/check-cc` automatically

---

## AG → CC (MCP)

Antigravity calls Claude Code via MCP server (`claude mcp serve`), auto-started on session start.

### Files
- `.agent/scripts/ensure-claude-mcp.sh` — Auto-start script
- `.agent/hooks/session-start.sh` — Triggers on AG session start
- `.agent/mcp_config.json` — MCP server config

### Usage (Antigravity)
MCP tools available after session start - no manual setup needed.

---

## Verification

1. Start new Antigravity session
2. Check `/tmp/claude-mcp-serve.pid` exists
3. Verify `ps aux | grep "claude mcp serve"` shows process
4. Test MCP call from Antigravity to Claude Code
5. Test `/ask-ag` from Claude Code writes to file
6. Test `/check-ag` from Claude Code reads response
