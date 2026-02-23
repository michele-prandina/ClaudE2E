Check for responses from Antigravity in the file-based communication channel.

1. Read docs/agent-comms/ag-to-cc.md
2. Check the status in frontmatter:
   - If COMPLETE: Parse and present the response, then reset status to IDLE
   - If PENDING: "Antigravity has a pending request for you" - read and respond
   - If IDLE: "No messages from Antigravity"
   - If ERROR: Report the error details
