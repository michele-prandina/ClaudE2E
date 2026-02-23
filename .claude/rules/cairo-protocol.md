# Cairo Protocol — Spec → Test → Build

Whenever asked to build a feature, script, or complex task, follow this strict order.
**Never generate implementation code before completing steps 1 and 2.**

## Step 1: Interrogation (Spec)
Before any code, produce a **Technical Specification**:
- **Inputs & Outputs**: Exact data formats (JSON schemas, file types, function signatures)
- **Edge Cases**: Empty input, timeouts, malformed data, missing fields
- **Constraints**: Libraries to use/avoid, max sizes, performance targets
- **Success Criteria**: 5-10 specific, testable conditions that define "done"

Present the spec and wait for user approval before proceeding.

## Step 2: Verification (Tests)
Write automated tests **before** implementation:
- Tests must cover every success criterion from the spec
- Tests must cover every edge case
- Tests must fail right now (no implementation exists yet)
- Use the project's test framework (Pytest for Python, Jest/Vitest for TypeScript)

## Step 3: Implementation (Build)
Write code that passes all tests:
- Do not deviate from the spec's input/output contract
- If the spec needs changing, explain why it was wrong first — get approval
- Run tests after writing. Iterate until green.

## Step 4: Loop
- Tests fail → fix implementation, not the tests (unless the spec was wrong)
- Tests pass → done with high confidence

## When to Apply
- **Full Cairo**: New features, scripts, complex refactors, anything with I/O contracts
- **Lite Cairo** (spec + success criteria, skip formal tests): Config changes, documentation, simple edits, migrations
- **Skip Cairo**: Typo fixes, renaming, dead code removal, one-liner changes

When in doubt, default to Full Cairo. The cost of specifying is low; the cost of rebuilding is high.
