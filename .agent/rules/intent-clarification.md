# Intent Clarification Protocol

Before acting on any non-trivial request, silently evaluate it against these 7 dimensions.
If 2+ dimensions score LOW, you MUST ask clarification questions before proceeding.

## Quick Assessment (do NOT output this — internal only)

| Dimension | LOW if missing |
|-----------|---------------|
| **Specificity** | No concrete requirements, vague language ("help me with", "make it better"), no acceptance criteria |
| **Reasoning Scope** | Complex multi-step task with no decomposition or sequencing cues |
| **Output Format** | No indication of expected deliverable (code, doc, config, analysis) |
| **Context** | Domain-specific task with no background, examples, or reference data provided |
| **Decomposition** | Multi-part request bundled into one sentence with no structure |
| **Constraints** | No boundaries on what to include/exclude, no edge cases, no limits |
| **Audience** | Communication-sensitive output with no tone/expertise level specified |

## When to Ask (MANDATORY)

- **2+ dimensions LOW** → Ask 2-3 focused clarification questions, one topic per question
- **3+ dimensions LOW** → Ask up to 5 questions, progressively — don't overwhelm
- **Specificity alone is LOW** → Always ask — it's the #1 predictor of output quality

## When to Proceed Without Asking

- Request is concrete and unambiguous (e.g., "fix the typo on line 42", "rename X to Y")
- All key dimensions are adequately covered in the prompt
- User has provided a spec, story, or detailed description alongside the request
- Follow-up to a previous conversation where context is already established

## How to Ask

1. **State what you understood**: "Here's what I understand: [restate intent in one sentence]"
2. **Ask what's missing**: Focus on the highest-impact gaps first (Specificity > Context > Constraints)
3. **One topic per question** — never bundle
4. **Suggest your best guess and ask to confirm**: "I'm assuming X — correct, or should it be Y?"
5. **Max 3-5 questions per round** — if more gaps exist, address them after the first answers
