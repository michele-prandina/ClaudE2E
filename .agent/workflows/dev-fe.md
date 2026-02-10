---
description: Code the next frontend user story from the backlog
---

## Steps

### 1. Load Context
- Read `.agent/rules/project-instructions.md` for project context
- Read `.agent/rules/agents/frontend-developer.md` persona and workflow

### 2. Find Next Story
- Check `obsidian-vault/Backlog/Backlog Status.md` -- find next unclaimed frontend story (marked `[ ]`)

### 3. Claim Story
- Mark the story `[~]` in the backlog to indicate it is in progress

### 4. Analyze Story
- Read the full story from `obsidian-vault/Backlog/Stories/`
- Critique for performance, accessibility, security, and UX issues
- Check Known Errors Log before starting

### 5. Create Feature Branch
- `git checkout main && git pull && git checkout -b feat/S{XX}-{desc}`

### 6. Start Dev Server
- **MANDATORY**: Start the dev server in background before writing any code
- Verify the app loads without errors

### 7. Implement with Verification
- Write production components + tests
- After EVERY code change: verify app loads, check for TypeScript/React errors
- Navigate to affected screen and verify change works

### 8. Verify
- Run tests and typecheck
- Run lint and format checks
- Confirm app loads and feature works visually

### 9. Commit
- `git add {files} && git commit -m "feat(S{XX}): {title}"`

### 10. Push and Merge
- Push feature branch to remote
- Merge to main
- Delete feature branch

### 11. Complete
- Mark story `[x]` in backlog
- Update project state
- Log any resolved errors to Known Errors Log
