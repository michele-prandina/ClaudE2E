---
description: Write agent-optimized user stories in XML-tagged format for AI coding agents
---

## Steps

### 1. Load Story Format
- Read `.agent/skills/agent-stories/SKILL.md` for the agent-optimized story format specification

### 2. Load UXE Process
- Read `.agent/rules/agents/uxe.md` for the full story writing process and guidelines

### 3. Gather Inputs
- Read PRD/feature proposal from HoP (`obsidian-vault/Product/`)
- Read tech constraints from HoE (`obsidian-vault/Tech Specs/`)
- Read design specs from Designer (`obsidian-vault/Design/`)

### 4. Break Down Features
- Decompose features into implementable stories (300-800 tokens each)
- Each story should touch 1-5 files maximum
- If a story requires more than 2-3 architectural decisions, split it

### 5. Write Stories
- Use the XML-tagged format (story, intent, context, requirements, acceptance_criteria, tests, constraints, escalation)
- Include states matrix for EVERY story (loading, loaded, empty, error)
- Include file paths to modify AND file paths to reference (read-only)
- Include constraints section (what NOT to do)
- Include escalation criteria (when to stop and ask)

### 6. Review
- Present stories to HoP for scope alignment review
- Present stories to HoE for technical accuracy and sizing (S/M/L)

### 7. Save
- Save approved stories to `obsidian-vault/Backlog/Stories/`
- Update `obsidian-vault/Backlog/Backlog Status.md` with new stories
