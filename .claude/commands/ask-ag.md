Write a request to Antigravity (Gemini 3 Pro) via the file-based communication channel.

1. Read docs/agent-comms/ag-to-cc.md to check for any pending response first
2. Write the following request to docs/agent-comms/cc-to-ag.md:

```markdown
---
status: PENDING
from: cc
timestamp: [current ISO8601]
request_id: [generate UUID]
---

$ARGUMENTS
```

3. Inform the user: "Request sent to Antigravity. Check docs/agent-comms/ag-to-cc.md for response, or switch to Antigravity to process."
