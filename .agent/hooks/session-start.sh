#!/bin/bash
# Antigravity session start hook
# Auto-starts Claude MCP server for AG → CC communication

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Ensure Claude MCP server is running
"$PROJECT_DIR/scripts/ensure-claude-mcp.sh"

echo "Session started. Claude MCP server ready."
