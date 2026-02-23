# Full Codebase Slop Scan

Use Gemini 3 Pro's full context window for this scan.

1. Ingest the entire project source directories
2. Identify and report:
   a. DUPLICATED LOGIC: Functions/patterns in multiple files with minor variations
   b. DEAD CODE: Exported functions with zero imports, unused variables
   c. GOD FILES: Files over 300 lines (with line count)
   d. GOD FUNCTIONS: Functions over 50 lines (with line count)
   e. INCONSISTENT PATTERNS: Same problem solved differently across modules
   f. WORKAROUND DEBT: TODO, FIXME, HACK comments or bug workarounds
   g. DEPENDENCY SPRAWL: Multiple libraries doing the same job

3. Rank by severity: CRITICAL | HIGH | LOW
4. Output prioritized cleanup plan. Estimate: quick (<5 min) | medium (15-30 min) | heavy (1hr+)
5. Save results to docs/slop-report-[date].md
