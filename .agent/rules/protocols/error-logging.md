# Error Logging Protocol

> **Inherited by all agents.** Do not duplicate in agent files.

When a command fails with an error AND you resolve it:

1. **Append** a new `ERR-XXX` entry to `obsidian-vault/Tech Specs/Known Errors/Known Errors Log.md`
2. **Increment** the ERR number from the last entry in the file
3. **Include**: Date, Context, Error message (truncated), Root Cause, Resolution, Affected code
4. **Use** the template at the bottom of that file
5. **Do this inline** with the edit tool -- no sub-tasks needed

## Purpose

Institutional memory. The same error should never be debugged twice across sessions.
