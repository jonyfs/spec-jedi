---

description: "Task list for specs/054-sessionstart-interactive-next-steps"
---

# Tasks: SessionStart Orientation Gains a Next-Step Suggestion

**Input**: Design documents from `/specs/054-sessionstart-interactive-next-steps/`

**Tests**: No CI job. Verification: manual dry-run against this
project's own actual `specs/` state.

## Phase 1: User Story 1 - Name a concrete next step (P1) 🎯 MVP

- [x] T001 [US1] Amend `scripts/session-start.sh`: track the specific
  most-recently-touched feature per status category during the existing
  Part 2 loop; compute `next_step_line` per the priority order in
  plan.md (FR-001/002/003).
- [x] T002 [US1] Amend `scripts/session-start.ps1`: identical logic
  (Principle XIII).
- [x] T003 [US1] Append `next_step_line` to the existing assembly (Part
  5), respecting the 10,000-character cap — drop the freshness line
  first if over budget, never the new suggestion (FR-006).
- [x] T004 [US1] Manual dry-run against this project's own actual
  `specs/` state; confirm the suggestion names a specific real feature +
  skill.

**Checkpoint**: User Story 1 independently complete.

## Phase 2: User Story 2 - Interactive rendering (P2)

- [x] T005 [US2] No new work — feature 051 already amended Constitution
  Principle XIV to render any next-step moment through the harness's
  interactive mechanism when available; this new suggestion inherits it
  automatically. Confirmed by inspection: nothing in `CLAUDE.md`'s own
  Principle XXI render instruction restricts which next-step moments
  qualify.

**Checkpoint**: Both user stories complete.

## Dependencies

- T001/T002 before T003; T003 before T004.
- T005 has no dependency — already satisfied by feature 051.
