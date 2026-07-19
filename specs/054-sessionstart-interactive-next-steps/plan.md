# Implementation Plan: SessionStart Orientation Gains a Next-Step Suggestion

**Branch**: `054-sessionstart-interactive-next-steps` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/054-sessionstart-interactive-next-steps/spec.md`

## Summary

Extends `scripts/session-start.sh`/`.ps1`'s own existing status
computation (Part 2) with a 4th orientation element: a specific
next-step suggestion, computed via a bash/PowerShell reimplementation of
`specjedi-status`'s own "most relevant" reasoning (matching Principle
XXI's own established precedent for the status-summary portion) — never
a literal skill invocation, since a hook script cannot invoke an
LLM-interpreted skill. Because feature 051 already amended Constitution
Principle XIV to render *any* next-step moment through the harness's own
interactive mechanism when available, this new suggestion automatically
inherits that rendering — no separate interactive-rendering work is
needed here (User Story 2 is satisfied by 051 already having shipped).

## Technical Context

**Language/Version**: Bash (`session-start.sh`) + PowerShell
(`session-start.ps1`), matching the existing hook's own dual
implementation (Principle XIII cross-platform requirement).

**Primary Dependencies**: None new.

**Storage**: N/A.

**Testing**: No CI job for the reasoning; validated via a manual dry-run
of the hook against this project's own actual current `specs/` state,
confirming the suggestion names a real, specific feature/skill pair
matching what `specjedi-status` itself would say.

**Constraints**: The combined orientation payload MUST stay under the
10,000-character `additionalContext` cap (Principle XXI's own documented
fact) — FR-006.

**Scale/Scope**: One addition to each of `session-start.sh` and
`session-start.ps1` (~20-30 lines each); no new file.

## Constitution Check

| Principle | Check | Status |
|---|---|---|
| II | No new mechanism — reuses `specjedi-status`'s own already-established status-derivation rules, reimplemented in shell per Principle XXI's own existing precedent (documented directly in this plan, not a separate research.md). | ✅ Pass |
| XIII | Both `session-start.sh` and `session-start.ps1` gain the identical addition — cross-platform parity maintained. | ✅ Pass — enforced during implementation |
| XIV | This new suggestion is a genuine Next-Step Suggestion moment — it inherits feature 051's own interactive-mechanism amendment automatically, no separate work needed. | ✅ Pass |
| XX | The suggestion is grounded in the same real on-disk artifact state the existing status summary already reads — never fabricated. | ✅ Pass |
| XXI | This plan directly extends Principle XXI's own "no parallel status system" rule to the new element, and respects the documented 10,000-character cap. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/054-sessionstart-interactive-next-steps/
├── plan.md
└── tasks.md
```

### Source Code (repository root)

```text
scripts/
├── session-start.sh    # AMENDED — Part 2.5: next-step suggestion
└── session-start.ps1   # AMENDED — identical addition, PowerShell
```

### Implementation notes

1. **Bash**: after Part 2's existing per-feature loop (which already
   tracks `n_complete`/`n_in_progress`/`n_planned`/`n_specified`), add
   tracking for the *specific* most-recently-touched feature in each
   category (by `tasks.md`/`plan.md`/`spec.md` mtime respectively).
   Priority: an in-progress feature (suggest `specjedi-implement` or
   `specjedi-tasks` depending on state) > a planned-not-tasked feature
   (suggest `specjedi-tasks`) > a specified-not-planned feature (suggest
   `specjedi-clarify`/`specjedi-plan`) > no candidate (suggest
   `specjedi-specify`). Emit as a new `next_step_line` variable.
2. **PowerShell**: identical logic, `Get-ChildItem`-based, matching
   `session-start.ps1`'s own existing per-feature loop shape exactly.
3. **Assemble**: append `next_step_line` to the existing
   banner/status/Yoda/freshness assembly (Part 5), respecting the
   10,000-character budget (FR-006) — if the combined payload would
   exceed it, drop the freshness line first (already the lowest-priority,
   optional element), never the new suggestion or the core three.
4. **Validate**: manual dry-run against this project's own actual
   `specs/` state; confirm the suggestion names a specific real feature
   and skill, matching what `specjedi-status` itself would currently say.
