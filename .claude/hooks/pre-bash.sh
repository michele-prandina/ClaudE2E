#!/usr/bin/env bash
# Hook: PreToolUse (Bash)
# Commit format: enforces conventional commit messages

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AGENT_FILE="$PROJECT_DIR/.claude/.current-agent"

# Read JSON from stdin
INPUT=$(cat)

# Extract command from JSON
COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # PreToolUse hook receives tool_input with command field
    tool_input = data.get('tool_input', data)
    print(tool_input.get('command', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

# Read current agent
AGENT=""
if [ -f "$AGENT_FILE" ]; then
    AGENT=$(cat "$AGENT_FILE" 2>/dev/null || echo "")
fi

# --- COMMIT FORMAT ENFORCEMENT ---
if echo "$COMMAND" | grep -q "git commit"; then
    # Extract and validate commit message using env var to avoid quoting issues
    IS_VALID=$(COMMIT_CMD="$COMMAND" python3 -c "
import os, re
cmd = os.environ.get('COMMIT_CMD', '')
# Match -m followed by quoted string (double or single quotes)
match = re.search(r'-m\s+[\\x22\\x27](.*?)[\\x22\\x27]', cmd)
if not match:
    print('valid')
    exit(0)
msg = match.group(1)
pattern = r'^(feat|fix|docs|refactor|test|chore|style|perf|ci|build)\(.*\):\s+.+'
if re.match(pattern, msg):
    print('valid')
else:
    print('invalid')
" 2>/dev/null || echo "valid")

    if [ "$IS_VALID" = "invalid" ]; then
        echo "BLOCKED: Commit message must follow conventional format."
        echo "Pattern: (feat|fix|docs|refactor|test|chore|style|perf|ci|build)(scope): description"
        echo "Example: feat(S01): Add user authentication endpoint"
        exit 2
    fi
fi
