#!/usr/bin/env bash
# Hook: PostToolUse (Edit|Write)
# Vault ownership: blocks agents from editing files outside their domain
# Project state validation: ensures project_state.md stays well-formed

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AGENT_FILE="$PROJECT_DIR/.claude/.current-agent"

# Read JSON from stdin
INPUT=$(cat)

# Extract file path from JSON
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # PostToolUse hook receives tool_input with file_path field
    tool_input = data.get('tool_input', data)
    print(tool_input.get('file_path', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

# Read current agent
AGENT=""
if [ -f "$AGENT_FILE" ]; then
    AGENT=$(cat "$AGENT_FILE" 2>/dev/null || echo "")
fi

# Normalize file path relative to project dir
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"

# --- VAULT OWNERSHIP ENFORCEMENT ---

# Check if file is in obsidian-vault/
if echo "$REL_PATH" | grep -q "^obsidian-vault/"; then
    VAULT_REL="${REL_PATH#obsidian-vault/}"

    # Strategy/, Product/, Research/ → head-of-product only
    if echo "$VAULT_REL" | grep -qE "^(Strategy|Product|Research)/"; then
        if [ "$AGENT" != "head-of-product" ] && [ "$AGENT" != "orchestrator" ]; then
            echo "BLOCKED: Only head-of-product can edit $VAULT_REL"
            echo "Current agent: $AGENT"
            exit 2
        fi
    fi

    # Design/ → designer, uxe, or orchestrator only
    if echo "$VAULT_REL" | grep -q "^Design/"; then
        if [ "$AGENT" != "designer" ] && [ "$AGENT" != "uxe" ] && [ "$AGENT" != "orchestrator" ]; then
            echo "BLOCKED: Only designer or uxe can edit Design/"
            echo "Current agent: $AGENT"
            exit 2
        fi
    fi

    # Tech Specs/ → head-of-engineering only (except Known Errors/)
    if echo "$VAULT_REL" | grep -q "^Tech Specs/"; then
        # Exception: Known Errors/ is writable by developer
        if ! echo "$VAULT_REL" | grep -q "^Tech Specs/Known Errors/"; then
            if [ "$AGENT" != "head-of-engineering" ] && [ "$AGENT" != "orchestrator" ]; then
                echo "BLOCKED: Only head-of-engineering can edit Tech Specs/ (except Known Errors/)"
                echo "Current agent: $AGENT"
                exit 2
            fi
        else
            # Known Errors/ → developer and head-of-engineering allowed
            if [ "$AGENT" != "developer" ] && [ "$AGENT" != "head-of-engineering" ] && [ "$AGENT" != "orchestrator" ]; then
                echo "BLOCKED: Only developer or head-of-engineering can edit Known Errors/"
                echo "Current agent: $AGENT"
                exit 2
            fi
        fi
    fi

    # Decision Log/ → head-of-engineering only
    if echo "$VAULT_REL" | grep -q "^Decision Log/"; then
        if [ "$AGENT" != "head-of-engineering" ] && [ "$AGENT" != "orchestrator" ]; then
            echo "BLOCKED: Only head-of-engineering can edit Decision Log/"
            echo "Current agent: $AGENT"
            exit 2
        fi
    fi

    # Backlog/ → uxe, head-of-product, head-of-engineering, developer
    if echo "$VAULT_REL" | grep -q "^Backlog/"; then
        if [ "$AGENT" != "uxe" ] && [ "$AGENT" != "head-of-product" ] && [ "$AGENT" != "head-of-engineering" ] && [ "$AGENT" != "developer" ] && [ "$AGENT" != "orchestrator" ]; then
            echo "BLOCKED: Only uxe, head-of-product, head-of-engineering, or developer can edit Backlog/"
            echo "Current agent: $AGENT"
            exit 2
        fi
    fi
fi

# Source code files (not in obsidian-vault/, not in .claude/) → developer only
if ! echo "$REL_PATH" | grep -qE "^(obsidian-vault/|\.claude/)"; then
    if [ "$AGENT" != "developer" ] && [ "$AGENT" != "orchestrator" ] && [ -n "$AGENT" ]; then
        echo "BLOCKED: Only developer can edit source code files"
        echo "File: $REL_PATH"
        echo "Current agent: $AGENT"
        exit 2
    fi
fi

# --- PROJECT_STATE VALIDATION ---
if echo "$REL_PATH" | grep -q "project_state.md"; then
    VALIDATION=$(python3 -c "
import sys

with open('$FILE_PATH') as f:
    content = f.read()

errors = []

# Check Phase field exists
if '**Phase**' not in content:
    errors.append('Missing Phase field')
else:
    # Validate Phase value
    valid_phases = ['Setup', 'Research & Discovery', 'Strategy', 'Product Spec', 'Architecture', 'Backlog', 'Implementation', 'Integration', '{current phase}']
    found_phase = False
    for line in content.split('\n'):
        if '**Phase**' in line:
            for phase in valid_phases:
                if phase in line:
                    found_phase = True
                    break
            break
    if not found_phase:
        errors.append(f'Phase must be one of: {valid_phases}')

# Check Status field exists
if '**Status**' not in content:
    errors.append('Missing Status field')

if errors:
    print('INVALID: ' + '; '.join(errors))
else:
    print('valid')
" 2>/dev/null || echo "valid")

    if echo "$VALIDATION" | grep -q "^INVALID"; then
        echo "BLOCKED: project_state.md validation failed"
        echo "$VALIDATION"
        exit 2
    fi
fi
