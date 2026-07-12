# Phase 1 Data Model: Session-Start Live-Render Verification Closure

## Entity: SessionStart Observation

The specific, transcript-verifiable evidence this closure cites — not a
paraphrase or a claim without the underlying quoted content.

| Field | Value |
|---|---|
| Trigger | `SessionStart:compact` (a context-compaction event, not a from-scratch `startup`) |
| Banner | The exact box-drawing ASCII banner from `scripts/session-start.sh` |
| Status summary | `18 feature(s): 15 complete, 3 in progress, 0 planned, 0 specified, 0 not started.` |
| Yoda line | `A project with a plan, you have. Proceed, you may.` |
| Verified against | This session's own tool-result/system-reminder history (directly quotable, not reconstructed from memory) |
| Closes | The mechanism-correctness half of feature 015's T020 / SC-003 |
| Does NOT close | Whether a from-scratch `startup` firing behaves identically (untested; same registered hook/script, no known reason to expect divergence, but not separately observed) |

## Entity: Render-Precedence Rule (new, added to CLAUDE.md)

| Field | Value |
|---|---|
| Conflict | `SessionStart` payload present AND an explicit continuation/no-preface instruction present in the same turn |
| Winner | The continuation/no-preface instruction |
| Preserved obligation | The agent still works real session-status information into its first substantive response naturally, rather than dropping Principle XXI's orientation goal entirely |
