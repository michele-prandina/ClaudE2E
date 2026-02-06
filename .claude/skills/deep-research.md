---
name: deep-research
description: "Full research pipeline — web search, synthesis, validation, vault integration"
user_invocable: true
---

# /deep-research

Run a full research pipeline on a given topic. Produces raw research files, a synthesized vault note, and validates findings against the existing vault.

## Input

The user provides a research topic after invoking `/deep-research`. Example:

```
/deep-research push notification strategies for mobile apps
```

If no topic is provided, ask the user for one before proceeding.

## Workflow

Execute the following steps **in order**, confirming completion of each phase with the user before moving to the next.

---

### Phase 1: Setup

1. Slugify the topic (e.g., "push notification strategies" → `push-notification-strategies`)
2. Get today's date as `YYYY-MM-DD`
3. Create the research folder:
   ```
   obsidian-vault/Research/Sources/YYYY-MM-DD-<topic-slug>/
   ```
4. Confirm folder created to the user.

---

### Phase 2: Keyword Generation

1. Based on the topic, generate **10-15 research keywords/queries** spanning:
   - Direct queries (the topic itself)
   - Adjacent concepts (related tools, techniques, competitors)
   - Pain points and complaints (Reddit, G2, forums)
   - Market data (sizing, trends, benchmarks)
   - Technical implementation (how it works, best practices)
2. Write keywords to:
   ```
   obsidian-vault/Research/Sources/YYYY-MM-DD-<topic-slug>/keywords.md
   ```
   Format:
   ```markdown
   # Research Keywords: <Topic>

   Generated: YYYY-MM-DD

   ## Search Queries

   1. <query>
   2. <query>
   ...

   ## Status

   - [ ] Web search completed
   - [ ] User supplement received (optional)
   - [ ] Synthesis complete
   - [ ] Validation complete
   ```
3. Present keywords to user. Ask: "Want to adjust these keywords before I start searching?"

---

### Phase 3: Web Research

1. Run web searches using the keywords from Phase 2. Use **WebSearch** for each query.
2. For each meaningful result, extract:
   - Key findings and data points
   - Direct quotes with attribution
   - Source URL
3. Write raw findings to:
   ```
   obsidian-vault/Research/Sources/YYYY-MM-DD-<topic-slug>/raw-findings.md
   ```
   Format:
   ```markdown
   # Raw Findings: <Topic>

   Generated: YYYY-MM-DD

   ## Finding 1: <Title>

   **Source:** <URL>

   <Key data, quotes, insights>

   ---

   ## Finding 2: <Title>
   ...
   ```
4. After completing all searches, ask the user:
   > "Web research complete. Do you have additional research to add? (e.g., Perplexity Deep Search output, articles, reports). Paste it here or say 'skip' to proceed to synthesis."
5. If user provides supplementary research, append it to `raw-findings.md` under a `## User-Provided Research` section. Label each entry with its source.

---

### Phase 4: Synthesis

Create a synthesized vault note following the established pattern in `obsidian-vault/Research/`.

1. Read 2-3 existing vault notes in `obsidian-vault/Research/` to match the format pattern:
   - YAML frontmatter: `tags`, `description`, `updated`
   - Blockquote summary after title
   - Structured sections with tables where appropriate
   - `## Sources` section with wikilinks to raw files
   - `## Related` section with wikilinks to relevant existing vault notes
2. Write the synthesis note to:
   ```
   obsidian-vault/Research/<Topic Title>.md
   ```
   Use title case for the filename.
3. The `## Sources` section must use wikilinks:
   ```markdown
   ## Sources

   - [[raw-findings]]
   - [[keywords]]
   ```
4. The `## Related` section must link to existing vault notes that are relevant. Read `.claude/vault-index.md` to find candidates.
5. Present the synthesis to the user for review before proceeding.

---

### Phase 5: Validation (Cross-Reference Vault)

1. Read all existing vault notes in `obsidian-vault/Research/` (use `.claude/vault-index.md` to identify them).
2. For each existing note, check:
   - **Contradictions**: Does the new research contradict any existing finding? Flag with severity.
   - **Reinforcements**: Does the new research add supporting evidence to existing claims?
   - **Updates needed**: Should any existing note be updated based on new findings?
   - **New connections**: Should existing notes add a wikilink to the new note?
3. Write a validation log to:
   ```
   obsidian-vault/Research/Sources/YYYY-MM-DD-<topic-slug>/validation-log.md
   ```
   Format:
   ```markdown
   # Validation Log: <Topic>

   Validated: YYYY-MM-DD

   ## Contradictions

   | Existing Note | Existing Claim | New Finding | Severity |
   |---------------|---------------|-------------|----------|
   | (none or entries) |

   ## Reinforcements

   | Existing Note | Claim Reinforced | New Evidence |
   |---------------|-----------------|--------------|

   ## Suggested Updates

   | Note | Suggested Change | Reason |
   |------|-----------------|--------|

   ## New Connections

   | Note | Suggested Wikilink | Context |
   |------|-------------------|---------|
   ```
4. Present validation results to the user. Ask:
   > "Validation complete. Should I apply the suggested updates to existing vault notes? (Review the changes above first.)"
5. If user approves, apply the updates surgically using the Edit tool.

---

### Phase 6: Finalize

1. Update `obsidian-vault/Research/Research Index.md`:
   - Add the new note to the research notes table
2. Update `keywords.md` status checklist — mark all completed steps
3. Run: `python3 .claude/scripts/rebuild-vault-index.py` to update the vault index
4. Report completion:
   ```
   Research complete: <Topic>

   Files created:
   - obsidian-vault/Research/<Topic Title>.md (synthesis)
   - obsidian-vault/Research/Sources/YYYY-MM-DD-<topic-slug>/keywords.md
   - obsidian-vault/Research/Sources/YYYY-MM-DD-<topic-slug>/raw-findings.md
   - obsidian-vault/Research/Sources/YYYY-MM-DD-<topic-slug>/validation-log.md

   Vault notes updated: <list if any>
   ```

## Constraints

- Every claim in the synthesis must trace back to a source in `raw-findings.md`. If a claim has no source, flag it as "UNSOURCED: <claim>" and ask the user whether to keep or remove it.
- Never produce "representative reconstructions" of quotes. If you cannot find the exact quote, paraphrase and mark as `(paraphrased)`.
- Follow the vault-sync protocol (`.claude/protocols/vault-sync.md`) for all vault writes.
- Use Edit tool for surgical updates to existing notes, not full rewrites.
- One confirmation checkpoint per phase — do not bundle phases.

## Response Header

```
🔬 **Deep Research**
📍 **Topic**: <topic>
└─ **Phase**: <current phase>
---
```
