# SDD Test Workflow Reference

This document captures a successful baseline execution of the Subagent-Driven Development (SDD) workflow used to validate the skill in a clean environment.

## Setup
1. Create a dummy git repository and initialize `.superpowers/sdd/progress.md`.
2. Initialize an implementation plan file.

## Workflow Sequence Observed
1. **Orchestration:** Prepare task brief using `scripts/task-brief`.
2. **Dispatch (Implementer):** Call `delegate_task` with absolute paths to the Brief and Report files.
3. **Implementation & Self-Review:** Subagent implements code, commits, runs tests, writes a report, and returns status `DONE`.
4. **Verification (Reviewer):** A second subagent is dispatched (`Task Reviewer`) to compare implementer's diff against the original Brief requirements.
5. **Closing:** Once reviews pass, the orchestrator updates the progress log and finishes the session.

## Key Context Patterns
| Parameter | Requirement | Purpose |
| :--- | :--- | :--- |
| `[BRIEF_FILE]` | Absolute path required | Subagent must be able to read its source of truth without guessing. |
| `[REPORT_FILE]` | Absolute path required | Prevents loss of state when the subagent returns. |
| `Context` | Must include workdir/paths | Subagents run in a clean shell context; absolute paths are essential. |

## Pitfalls identified during testing
- **Orchestrator failure:** Calling the tool is mandatory; simply "preparing" the prompt is not enough to start background processes.
- **Path reliance:** Relative paths for `[BRIEF_FILE]` and `[REPORT_FILE]` can fail if the subagent starts in a different working directory than expected. Always use absolute paths.
