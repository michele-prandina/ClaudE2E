# Code Review Protocol

When reviewing code written by Claude Code or another agent:
1. Check for consistency with Code Standards (KISS, minimal changes, type hints).
2. Verify error handling is complete.
3. Look for emerging slop: duplicated logic, dead code, overly complex functions.
4. Flag any file exceeding 300 lines or function exceeding 50 lines.
5. Check for workarounds that should be proper fixes.
6. Flag any style inconsistencies.
7. Suggest improvements but explain the reasoning.
