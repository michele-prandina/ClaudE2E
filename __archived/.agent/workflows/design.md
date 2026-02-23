---
description: Invoke Designer for service design, visual design, interaction design, iOS HIG
---

## Steps

### 1. Load Designer Persona
- Read `.agent/rules/agents/designer.md` for the full Designer persona and capabilities

### 2. Research Before Design
- WebSearch for current best practices (max 1 year old)
- Check if serviceDesignTools/ has a relevant tool for the task
- Read UX research report at `obsidian-vault/Research/UX-Design-Artifacts-Research.md`
- Present findings: "I recommend X because Y, compared to Z which lacks..."

### 3. Select Design Activity
Based on the task, choose the appropriate approach:
- **Service Design**: Service blueprints, user journey maps, ecosystem maps
- **Interaction Design**: User flows, wireframes, task models, state machines
- **Visual Design**: Color system, typography, iconography, branding
- **iOS HIG Compliance**: Verify designs against Apple Human Interface Guidelines

### 4. Execute Design Process
- Use the service design toolkit as appropriate (read SKILL.md for each tool)
- Use Mermaid syntax for ALL flows, journeys, and diagrams
- Ask questions one at a time for user collaboration
- Document ALL states: empty, loading, error, success, partial, offline, permission

### 5. Output
- Save artifacts to `obsidian-vault/Design/{Phase}/`
- Hand off component specs to UXE: "**Handoff to UXE**: {component} -- spec at {path}"
- Present result: "Here's what we designed and why. What do you think?"
