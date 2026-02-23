---
name: deep-research
description: >
  Multi-phase deep research with parallel retrieval agents. Use when the user
  asks for in-depth research, analysis, comparison, market intelligence, or any
  query that requires systematic evidence gathering from multiple sources with
  citations and confidence scoring. Triggers on: "deep research", "research this",
  "investigate", "comprehensive analysis", "compare X vs Y in depth",
  "what does the evidence say about", or any complex question needing 5+ sources.
---

# Deep Research Skill

A production-grade research workflow that decomposes complex queries into
parallel evidence-gathering tasks, synthesizes findings with claim-level
citations and confidence scores, and self-verifies before delivery.

## Architecture

```
User Query
    │
    ▼
┌─────────┐
│ PLANNER │ ── Decomposes query into subquestions + search plan
└────┬────┘
     │ plan.json
     ▼
┌──────────────────────────────────────────┐
│         PARALLEL RETRIEVERS              │
│  ┌───────────┐ ┌───────────┐ ┌────────┐ │
│  │Retriever 1│ │Retriever 2│ │  ... N │ │  ── Each handles 1-2 subquestions
│  └─────┬─────┘ └─────┬─────┘ └───┬────┘ │
│        │             │            │      │
│        ▼             ▼            ▼      │
│     evidence_1/   evidence_2/  evidence_N/│
└──────────────────────────────────────────┘
     │ all evidence artifacts
     ▼
┌────────────┐
│ GAP FINDER │ ── Checks coverage, spawns follow-up retrievers if needed
└─────┬──────┘
      │
      ▼
┌────────────┐
│   WRITER   │ ── Synthesizes into cited report with confidence scores
└─────┬──────┘
      │
      ▼
┌────────────┐
│  VERIFIER  │ ── Audits citations, checks hallucination, validates balance
└─────┬──────┘
      │
      ▼
  Final Report (Markdown)
```

## Execution Flow

### Phase 0: Setup workspace

Create a working directory for this research session:

```bash
RESEARCH_DIR="./research/$(date +%Y%m%d_%H%M%S)_$(echo "$QUERY" | tr ' ' '_' | head -c 40)"
mkdir -p "$RESEARCH_DIR"/{plan,evidence,gaps,report}
```

### Phase 1: PLANNER (sequential, single agent)

**Use agent**: `agents/planner.md`

The Planner receives the user's query and produces a structured research plan.

**Input**: User query (string)
**Output**: `$RESEARCH_DIR/plan/plan.json`

The plan contains:
- Restated query with scope boundaries
- Risk level assessment (low/medium/high)
- 3-7 prioritized subquestions with intent tags
- 3-5 search queries per subquestion
- Grouping of subquestions into retriever batches (for parallelism)

**Do NOT proceed to retrieval until the plan is saved to disk.**

If the user's query is ambiguous, ask one clarifying question before planning.
If the query is simple enough for 1-2 searches, skip this skill entirely and
just answer directly — don't over-engineer simple lookups.

### Phase 2: PARALLEL RETRIEVERS (spawn subagents)

**Use agent**: `agents/retriever.md` (one instance per batch)

Read `plan.json` and spawn one Retriever subagent per batch of 1-2 subquestions.
Subagents run in parallel — this is where the speed gain comes from.

Each Retriever:
1. Reads its assigned subquestions from the plan
2. Executes web searches (3-5 queries per subquestion)
3. Fetches full pages when snippets are insufficient
4. Extracts structured evidence artifacts
5. Writes results to `$RESEARCH_DIR/evidence/batch_N/`

**Spawning pattern** (pseudocode):

```
batches = plan.json.batches  # typically 2-4 batches

# Spawn all retrievers in parallel
for batch in batches:
    spawn subagent agents/retriever.md with:
        batch_id: batch.id
        subquestions: batch.subquestions
        research_dir: $RESEARCH_DIR
        output_dir: $RESEARCH_DIR/evidence/batch_{batch.id}/
```

Wait for all retrievers to complete before proceeding.

### Phase 3: GAP ANALYSIS (sequential)

After all retrievers finish, the orchestrator (you) performs gap analysis inline:

1. Read all evidence files from `$RESEARCH_DIR/evidence/*/`
2. For each P1 subquestion: count distinct credible sources
3. Check for:
   - P1 subquestions with < 2 credible sources → **gap**
   - Contradictions between sources on the same claim → **conflict to resolve**
   - Missing counter-arguments (all evidence is one-sided) → **balance gap**
   - Stale sources (> 12 months for market/tech data) → **recency gap**

4. If gaps exist in P1 or P2 subquestions:
   - Generate targeted follow-up queries
   - Write gap report to `$RESEARCH_DIR/gaps/gap_report.json`
   - Spawn 1-2 additional Retriever subagents for follow-up searches
   - Maximum 2 gap-filling rounds to prevent infinite loops

5. If no significant gaps, proceed to Writer.

### Phase 4: WRITER (sequential, single agent)

**Use agent**: `agents/writer.md`

The Writer consumes ALL evidence artifacts and produces the final report.

**Input**: 
- `$RESEARCH_DIR/plan/plan.json`
- `$RESEARCH_DIR/evidence/*/` (all evidence files)
- `$RESEARCH_DIR/gaps/gap_report.json` (if exists)

**Output**: `$RESEARCH_DIR/report/report.md`

The Writer:
1. Organizes findings by theme (not by subquestion — the report should read naturally)
2. Cites every factual claim with source references
3. Assigns confidence (High/Medium/Low/Unverified) per section and key claims
4. Surfaces contradictions and open questions in a dedicated section
5. Lists all sources with URLs

### Phase 5: VERIFIER (sequential, single agent)

**Use agent**: `agents/verifier.md`

The Verifier audits the Writer's report against the evidence.

**Input**:
- `$RESEARCH_DIR/report/report.md`
- `$RESEARCH_DIR/evidence/*/` (original evidence)

**Output**: 
- `$RESEARCH_DIR/report/verification.json` (audit results)
- `$RESEARCH_DIR/report/report_final.md` (corrected report, if needed)

The Verifier checks:
1. **Citation audit**: Every claim has a citation; every citation maps to real evidence
2. **Hallucination check**: No claims asserted beyond what sources actually say
3. **Balance check**: Counter-arguments present for controversial claims
4. **Recency check**: Most current sources used when available
5. **Confidence calibration**: Confidence labels match actual evidence strength

If issues found: Verifier corrects the report and saves as `report_final.md`.
If clean: Verifier copies report as `report_final.md` unchanged.

### Phase 6: Delivery

Present `$RESEARCH_DIR/report/report_final.md` to the user.

Also make available:
- The research plan (`plan.json`) for transparency
- The verification audit (`verification.json`) if the user wants to inspect rigor
- All evidence artifacts for drill-down

---

## Scaling Rules

| Query Complexity | Subquestions | Retriever Batches | Gap Rounds | Expected Searches |
|---|---|---|---|---|
| Focused question | 2-3 | 1-2 (can run sequentially) | 0-1 | 5-10 |
| Comparison / analysis | 4-5 | 2-3 parallel | 1 | 10-20 |
| Deep exploration | 5-7 | 3-4 parallel | 1-2 | 15-30 |

**Do NOT use this skill for simple factual lookups.** If the answer needs ≤2 searches,
just answer directly.

---

## Domain Adaptations

The Planner should detect the domain and pass a `domain_profile` field in `plan.json`:

### `high_stakes` (legal, medical, financial)
- Require 3+ sources per P1 claim
- Verifier applies strict hallucination check
- Writer includes professional-consultation disclaimer
- Prefer institutional/official sources exclusively

### `technical` (engineering, development, infrastructure)
- Prioritize official docs, release notes, GitHub repos
- Include version numbers and deprecation warnings
- Flag compatibility and breaking-change risks

### `market` (business intelligence, competitive analysis)
- Deprioritize sources older than 12 months
- Distinguish projections from confirmed data
- Cross-reference quantitative claims across sources

### `academic` (scientific research, papers)
- Prioritize peer-reviewed and preprint sources
- Note study limitations, sample sizes, replication
- Distinguish consensus vs emerging vs speculative

---

## File Structure Reference

```
research/
  20260209_143022_eu_ai_act_impact/
    plan/
      plan.json              # Structured research plan
    evidence/
      batch_1/
        evidence.json        # Structured evidence artifacts
        raw/                 # Fetched page contents (optional)
      batch_2/
        evidence.json
      batch_3/
        evidence.json
      followup_1/            # Gap-filling round
        evidence.json
    gaps/
      gap_report.json        # Coverage analysis
    report/
      report.md              # Writer's draft
      verification.json      # Verifier's audit
      report_final.md        # Final deliverable
```

---

## Error Handling

- **Search API failures**: Retriever retries once, then logs the failure and continues with remaining queries. Partial evidence is better than no evidence.
- **Subagent timeout**: If a retriever batch takes too long, the orchestrator proceeds with available evidence and notes the gap.
- **No evidence found**: Writer explicitly states "no evidence found" for that subquestion rather than fabricating content.
- **Contradictory evidence**: Writer presents both sides with citations; never silently resolves contradictions.

---

## JSON Schemas

### plan.json

```json
{
  "query": "original user query",
  "scope": "boundaries and assumptions",
  "risk_level": "low | medium | high",
  "domain_profile": "general | high_stakes | technical | market | academic",
  "subquestions": [
    {
      "id": "sq_1",
      "text": "What is...?",
      "priority": 1,
      "intent": "factual | comparative | rebuttal | timeline | statistical",
      "search_queries": ["query 1", "query 2", "query 3"],
      "batch_id": 1
    }
  ],
  "batches": [
    {
      "id": 1,
      "subquestion_ids": ["sq_1", "sq_2"],
      "description": "Core definitional questions"
    }
  ]
}
```

### evidence.json (per batch)

```json
{
  "batch_id": 1,
  "subquestion_id": "sq_1",
  "evidence": [
    {
      "claim": "paraphrased factual claim",
      "source_url": "https://...",
      "source_title": "Page Title",
      "source_date": "2025-11-15",
      "source_credibility": "high | medium | low",
      "supporting_snippet": "max 100 chars of context",
      "relevance": "high | medium | low",
      "agrees_with": ["other evidence IDs"],
      "contradicts": ["other evidence IDs"]
    }
  ],
  "searches_performed": 5,
  "pages_fetched": 2,
  "gaps_noted": ["No counter-argument sources found"]
}
```

### verification.json

```json
{
  "claims_audited": 24,
  "citations_valid": 22,
  "citations_missing": 1,
  "citations_unsupported": 1,
  "hallucinations_found": 0,
  "balance_issues": ["Section 3 lacks counter-argument"],
  "recency_issues": [],
  "confidence_adjustments": [
    {"section": "Section 2", "from": "High", "to": "Medium", "reason": "Single source"}
  ],
  "overall_verdict": "pass | pass_with_corrections | fail",
  "corrections_made": ["Added counter-argument note to Section 3"]
}
```
