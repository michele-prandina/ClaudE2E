# Refactoring Sprint

Prerequisites: Run /slop-scan first and have a report ready.

1. Load the latest docs/slop-report-*.md
2. Start with CRITICAL items, then HIGH
3. For each item:
   a. Create a focused branch: refactor/[description]
   b. Make the structural change — NO behavior changes
   c. Run the test suite
   d. If tests pass, commit: "refactor: [what changed and why]"
   e. If tests fail, revert and flag for human review
4. After completing a category, run full test suite
5. Summarize what was cleaned and what was skipped
6. Update affected CLAUDE.md files

Use Gemini 3 Flash for quick items. Switch to Gemini 3 Pro for cross-module work.
