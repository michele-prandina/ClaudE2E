#!/usr/bin/env bash
# Hook: PreToolUse (Bash)
# Phase gating: blocks code/git operations outside Implementation/Integration
# Commit format: enforces conventional commit messages

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
STATE_FILE="$PROJECT_DIR/.claude/project_state.md"
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

# Read current phase from project_state.md
PHASE=""
if [ -f "$STATE_FILE" ]; then
    PHASE=$(python3 -c "
import sys
with open('$STATE_FILE') as f:
    for line in f:
        if '**Phase**' in line:
            # Extract value after last |
            parts = line.strip().split('|')
            if len(parts) >= 3:
                print(parts[2].strip())
            break
" 2>/dev/null || echo "")
fi

# Read current agent
AGENT=""
if [ -f "$AGENT_FILE" ]; then
    AGENT=$(cat "$AGENT_FILE" 2>/dev/null || echo "")
fi

# --- PHASE GATING ---
# Only allow code/git operations during Implementation or Integration
if [ "$PHASE" != "Implementation" ] && [ "$PHASE" != "Integration" ]; then

    # Check for blocked commands (code execution, git write operations)
    IS_BLOCKED=$(echo "$COMMAND" | python3 -c "
import sys, re
cmd = sys.stdin.read().strip()

# Always allowed regardless of phase
always_allowed = [
    r'^git\s+(status|log|diff|branch|show)',
    r'^npx\s+skills',
    r'^curl\s',
    r'^wget\s',
    r'^which\s',
    r'^echo\s',
    r'^cat\s',
    r'^ls\b',
    r'^pwd\b',
    r'^head\s',
    r'^tail\s',
]

for pattern in always_allowed:
    if re.match(pattern, cmd):
        print('allowed')
        sys.exit(0)

# Blocked during non-implementation phases
blocked = [
    r'^git\s+(commit|push|add|merge|rebase|checkout\s+-b)',
    r'^python',
    r'^node\b',
    r'^npm\s+(install|run|start|build|test)',
    r'^yarn\b',
    r'^pnpm\b',
    r'^pip\b',
    r'^cargo\b',
    r'^go\s+(build|run|test)',
    r'^make\b',
    r'^docker\b',
]

for pattern in blocked:
    if re.match(pattern, cmd):
        print('blocked')
        sys.exit(0)

print('allowed')
" 2>/dev/null || echo "allowed")

    if [ "$IS_BLOCKED" = "blocked" ]; then
        echo "BLOCKED: Code/git operations are only allowed during Implementation or Integration phase."
        echo "Current phase: $PHASE"
        echo "Update .claude/project_state.md to change phase."
        exit 2
    fi
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
