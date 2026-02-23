# Agent Communication Channel

File-based communication between Claude Code (CC) and Antigravity (AG).

## Protocol

### CC → AG (Request)
1. CC writes request to `cc-to-ag.md`
2. CC sets status to `PENDING`
3. AG processes and writes response to `ag-to-cc.md`
4. AG sets status to `COMPLETE`

### AG → CC (Request)
1. AG writes request to `ag-to-cc.md`
2. AG sets status to `PENDING`
3. CC processes and writes response to `cc-to-ag.md`
4. CC sets status to `COMPLETE`

## File Format

```markdown
---
status: PENDING | COMPLETE | ERROR
from: cc | ag
timestamp: ISO8601
request_id: uuid
---

[Message content here]
```

## Usage

**Claude Code**: Check `ag-to-cc.md` for pending requests. Write responses to `cc-to-ag.md`.

**Antigravity**: Check `cc-to-ag.md` for pending requests. Write responses to `ag-to-cc.md`.
