# Check for Claude Code Requests

1. Read `docs/agent-comms/cc-to-ag.md`
2. Check frontmatter status:
   - If `PENDING`: Process the request below the frontmatter
   - If `IDLE`: No pending requests — inform user and stop
3. After processing, write response to `docs/agent-comms/ag-to-cc.md`:
   ```markdown
   ---
   status: COMPLETE
   from: ag
   timestamp: [current ISO8601]
   request_id: [same as request]
   ---

   [Your response here]
   ```
4. Reset `docs/agent-comms/cc-to-ag.md` status to IDLE
