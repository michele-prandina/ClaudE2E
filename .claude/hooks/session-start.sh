#!/usr/bin/env bash
# Hook: SessionStart
# Reads JSON stdin, tracks current agent, auto-starts MCP serve

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AGENT_FILE="$PROJECT_DIR/.claude/.current-agent"

# Read JSON from stdin
INPUT=$(cat)

# Extract agent_type from JSON
AGENT_TYPE=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    agent = data.get('agent_type', '') or data.get('agent', '') or ''
    print(agent)
except Exception:
    print('')
" 2>/dev/null || echo "")

if [ -z "$AGENT_TYPE" ]; then
    AGENT_TYPE="orchestrator"
fi

mkdir -p "$(dirname "$AGENT_FILE")"
echo "$AGENT_TYPE" > "$AGENT_FILE"

# Check for unresolved placeholders
CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"
if [ -f "$CLAUDE_MD" ]; then
    if grep -q "{{Project}}" "$CLAUDE_MD"; then
        echo "WARNING: Setup incomplete — CLAUDE.md contains {{Project}} placeholders." >&2
    fi
fi

# --- AUTO-START claude mcp serve ---
MCP_PID_FILE="/tmp/claude-mcp-serve.pid"
MCP_LOG_FILE="/tmp/claude-mcp-serve.log"

start_mcp_serve() {
    if [ -f "$MCP_PID_FILE" ]; then
        local pid
        pid=$(cat "$MCP_PID_FILE" 2>/dev/null || echo "")
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            return 0
        fi
        rm -f "$MCP_PID_FILE"
    fi

    if pgrep -f "claude mcp serve" >/dev/null 2>&1; then
        return 0
    fi

    (
        unset CLAUDE_PROJECT_DIR CLAUDE_SESSION_ID CLAUDE_CODE_ENTRY_POINT
        nohup claude mcp serve > "$MCP_LOG_FILE" 2>&1 &
        echo $! > "$MCP_PID_FILE"
    )
}

start_mcp_serve
