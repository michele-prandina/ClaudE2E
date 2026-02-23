# Quick Code Health Check

Run after every feature branch merge.

1. Check files changed in the last 5 commits: `git diff --name-only HEAD~5`
2. For each changed file:
   - Does it exceed 300 lines now?
   - Were any functions added that exceed 50 lines?
   - Is there duplicated logic with other files?
   - Are there new TODOs or HACKs?
3. Report findings. If >3 issues found, recommend a refactoring sprint.
