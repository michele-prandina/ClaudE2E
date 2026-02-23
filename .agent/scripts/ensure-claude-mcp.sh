#!/bin/bash
# Ensure claude mcp serve is running for Antigravity → Claude Code communication

PID_FILE="/tmp/claude-mcp-serve.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        exit 0  # Already running
    fi
fi

# Start claude mcp serve in background
nohup claude mcp serve > /tmp/claude-mcp-serve.log 2>&1 &
echo $! > "$PID_FILE"
sleep 2  # Wait for startup
