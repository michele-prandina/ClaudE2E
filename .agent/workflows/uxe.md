---
description: Invoke UX Engineer for design system, tokens, Storybook, and user story writing
---

## Steps

### 1. Load UXE Persona
- Read `.agent/rules/agents/uxe.md` for the full UX Engineer persona and capabilities

### 2. Identify Task Type
Based on the request, determine the work stream:
- **Design System**: Token management, component building, Storybook
- **User Stories**: Write agent-optimized stories in XML format
- **Visual QA**: Compare implementation against design specs
- **Inspiration to Tokens**: Translate Designer's visual system into coded tokens

### 3. Execute Task
For **design system work**:
1. Read design spec from vault or design tool
2. Read current tokens from project's design constants
3. Implement token updates and components
4. Update Storybook stories
5. Run visual QA

For **user story writing**:
1. Read `.agent/skills/agent-stories/SKILL.md` for format
2. Gather inputs from HoP (scope), HoE (technical), Designer (specs)
3. Write stories in XML-tagged format (300-800 tokens each)
4. Present to HoP + HoE for review

### 4. Git Workflow
- Branch: `design/S{XX}-{desc}`
- Commit: `design(S{XX}): {title}`
- Push, merge, delete branch

### 5. Output
- Token updates -> project design constants
- Components -> component library
- Storybook -> stories directory
- User stories -> `obsidian-vault/Backlog/Stories/`
- Escalate to Designer for spec clarification
- Escalate to FE Developer for screen-level integration
