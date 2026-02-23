#!/usr/bin/env bash
# Hook: PostToolUse (Edit|Write)
# Enforces agent ownership boundaries on files

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AGENT_FILE="$PROJECT_DIR/.claude/.current-agent"

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    tool_input = data.get('tool_input', data)
    print(tool_input.get('file_path', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

AGENT=""
if [ -f "$AGENT_FILE" ]; then
    AGENT=$(cat "$AGENT_FILE" 2>/dev/null || echo "")
fi

REL_PATH="${FILE_PATH#$PROJECT_DIR/}"

# Source code files → developer or orchestrator only
if ! echo "$REL_PATH" | grep -qE "^(docs/|\.claude/)"; then
    if [ "$AGENT" != "developer" ] && [ "$AGENT" != "frontend-developer" ] && [ "$AGENT" != "orchestrator" ] && [ -n "$AGENT" ]; then
        echo "BLOCKED: Only developer/frontend-developer can edit source code files"
        echo "File: $REL_PATH | Agent: $AGENT"
        exit 2
    fi
fi
