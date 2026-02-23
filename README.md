# ClaudeE2E — Dual-Agent Boilerplate (v2 Architecture)

A modern, robust workspace boilerplate designed for a **Dual-Agent System** using **Claude Code (Opus 4.6)** and **Google Antigravity (Gemini 3 Pro/Flash)**. 

This template enforces a structured 8-phase project lifecycle, strictly defined agent roles, safety boundaries via shell hooks, and cross-agent communication protocols.

## 🚀 Quick Start

1. Clone this repository into your project root.
2. Initialize your workspace by making Claude Code read the setup instructions:
   ```bash
   claude -p "Read \`setup-workspace.md\` and execute every step to set up this workspace."
   ```
3. Your workspace will be provisioned with all the necessary `.claude` and `.agent` infrastructure. Make sure to update the `{{Project}}` placeholders in `CLAUDE.md` to your actual project name!

---

## 🏗️ Architecture Overview

The workspace is split between the two AI assistants, keeping their memory, instructions, and workflows isolated but allowing them to collaborate effectively:

- **`.claude/`**: Infrastructure for Claude Code.
  - `agents/`: Specialized agent personas (e.g. Head of Product, Developer).
  - `rules/`: Hard rules like the Cairo Protocol, Safety, and Intent Clarification.
  - `hooks/`: Bash scripts tracking active agents, intercepting commits, and enforcing file ownership.
  - `commands/`: Custom scripts you can run via `/command` in Claude Code.
  - `memory/`: Auto-memory and project status.
- **`.agent/`**: Infrastructure for Google Antigravity.
  - `rules/`: Antigravity's behavior and standards.
  - `workflows/`: Antigravity's executable workflows (e.g. `/design`, `/dev`, `/hoe`).
- **`docs/`**: Shared knowledge directory containing handoff context and communication logs between Claude Code and Antigravity.
- **`CLAUDE.md`**: The orchestrator instructions for Claude Code.

---

## 🤖 The Agents 

This boilerplate defines specialized sub-agents with strict boundaries:

| Agent | Role / Focus |
|-------|--------------|
| **Head of Product (HoP)** | Owns the *What* and *Why* (Strategy, Planning, Scope). |
| **Head of Engineering (HoE)** | Owns the *How* (Architecture, Feasibility, Code Specs). |
| **Designer** | Service, Visual, and Interaction design. |
| **UX Engineer (UXE)** | Design tokens, component specs, and Agent-Optimized User Stories. |
| **Developer** | Backend/Core implementation. |
| **Frontend Developer** | UI and client-side implementation. |
| *Orchestrator* | The default routing agent handling context and lifecycle gates. |

---

## 🔄 Project Lifecycle

We enforce an 8-phase lifecycle to prevent AI agents from hallucinating code before requirements are set. Tracked in `.claude/lifecycle.md`.

| Phase | Description | Owner |
|-------|-------------|-------|
| **0. Setup** | Initializing workspace, templates, and tech stack. | Orchestrator |
| **1. Research** | Problem definition, discovery, competitor analysis. | HoP |
| **2. Strategy** | Target users, value proposition, and positioning. | HoP |
| **3. Product Spec** | PRD, wireframes, component specs. | HoP, Designer, UXE |
| **4. Architecture** | System design, APIs, data schemas. | HoE |
| **5. Backlog** | Agent-optimized user stories. | UXE |
| **6. Implementation** | Writing code, unit tests, following Cairo Protocol. | Developer, FE Developer |
| **7. Integration** | End-to-end tests, PR creation, release. | Developer, HoE |

---

## 🛡️ Core Rules & Protocols

1. **Cairo Protocol (Spec → Test → Build)**: Never generate implementation code before the technical specification is written and automated tests are provided that cover the edge cases.
2. **Intent Clarification**: If a prompt scores low on specificity, context, or constraints, agents *must* ask 2-3 clarification questions before acting.
3. **Escalation Model**: Agents auto-resolve formatting, linting, and tests (Tier 1). They escalate ambiguous specs or edge cases to Executives like HoE/HoP (Tier 2). They escalate architectural pivots, budgets, or destructive actions to the Human (Tier 3).
4. **Hook Enforcement**: Agents' tool usage (like bash commands or file edits) is intercepted. For instance, `post-edit.sh` prevents Head of Product from editing source code, and `pre-bash.sh` forces the conventional commit format `feat(SXX): description`.

---

## 🤝 Cross-Agent Collaboration

To hand off work from Claude Code to Antigravity (or vice-versa), agents write summaries and open tasks to `docs/agent-comms/`. 
The receiving agent starts its session by reading this handoff document to instantly gain context without rescanning the entire codebase.

See `docs/agent2agent-comms.md` for more details.
