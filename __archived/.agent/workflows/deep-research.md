---
description: Full multi-phase research pipeline with synthesis and validation
---

## Steps

### 1. Load Research Pipeline
- Read `.agent/skills/DeepResearch/SKILL.md` for the full research pipeline specification

### 2. Plan
- Define research questions and scope
- Identify search domains and sources
- Create research plan with specific queries

### 3. Retrieve (Parallel)
- Execute web searches across multiple sources in parallel
- Target results from the past 1 year maximum
- Collect diverse perspectives and authoritative sources

### 4. Gap Analysis
- Review collected data for completeness
- Identify missing perspectives or unanswered questions
- Run additional targeted searches to fill gaps

### 5. Write
- Synthesize findings into a structured research report
- Include source citations for all claims
- Use Mermaid diagrams for visual representations
- Organize by themes, not by source

### 6. Verify
- Cross-check key claims across multiple sources
- Flag any contradictions or low-confidence findings
- Ensure research freshness (max 1 year old data)

### 7. Deliver
- Save output to `obsidian-vault/Research/`
- Add YAML frontmatter with tags and description
- Link to related vault notes
- Present summary with "Here's what we found and why it matters"
