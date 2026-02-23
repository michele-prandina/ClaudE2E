# Review Recent Changes

1. Run `git log --oneline -10` to see recent commits
2. Run `git diff main..HEAD` to see all changes
3. Review each changed file for:
   - Consistency with project patterns
   - Error handling completeness
   - Edge cases
   - Emerging slop (duplication, dead code, complexity)
4. Create a review summary with findings
5. If issues found, create a TODO list of fixes
