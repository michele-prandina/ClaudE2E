#!/usr/bin/env bash
# Hook: SessionStart
# Reads JSON stdin, extracts agent_type, writes to .claude/.current-agent

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AGENT_FILE="$PROJECT_DIR/.claude/.current-agent"

# Read JSON from stdin
INPUT=$(cat)

# Extract agent_type from JSON (uses python for reliable JSON parsing)
AGENT_TYPE=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # SessionStart hook receives session info
    # agent_type may be in the top-level or nested
    agent = data.get('agent_type', '') or data.get('agent', '') or ''
    print(agent)
except Exception:
    print('')
" 2>/dev/null || echo "")

# Default to orchestrator if no agent specified
if [ -z "$AGENT_TYPE" ]; then
    AGENT_TYPE="orchestrator"
fi

# Write current agent to file
mkdir -p "$(dirname "$AGENT_FILE")"
echo "$AGENT_TYPE" > "$AGENT_FILE"
