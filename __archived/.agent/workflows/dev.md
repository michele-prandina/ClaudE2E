---
description: Code the next backend user story from the backlog
---

## Steps

### 1. Load Context
- Read `.agent/rules/project-instructions.md` for project context
- Read `.agent/rules/agents/developer.md` persona and workflow

### 2. Find Next Story
- Check `obsidian-vault/Backlog/Backlog Status.md` -- find next unclaimed backend story (marked `[ ]`)

### 3. Claim Story
- Mark the story `[~]` in the backlog to indicate it is in progress

### 4. Analyze Story
- Read the full story from `obsidian-vault/Backlog/Stories/`
- Critique for security, performance, and pattern issues
- Check Known Errors Log before starting

### 5. Create Feature Branch
- `git checkout main && git pull && git checkout -b feat/S{XX}-{desc}`

### 6. Implement
- Write production code + tests
- Follow story acceptance criteria exactly
- Use parameterized queries, validate input, never hardcode secrets

### 7. Verify
- Run tests specified in the story
- Run lint and format checks

### 8. Commit
- `git add {files} && git commit -m "feat(S{XX}): {title}"`

### 9. Push and Merge
- Push feature branch to remote
- Merge to main
- Delete feature branch

### 10. Complete
- Mark story `[x]` in backlog
- Update project state
- Log any resolved errors to Known Errors Log
