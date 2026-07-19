---

description: "Task list for specs/056-parallel-spec-execution"
---

# Tasks: Safe Parallel Spec Execution Across Distinct Agents

**Input**: Design documents from `/specs/056-parallel-spec-execution/`

**Tests**: No CI job. Verification: `scripts/validate.sh` + manual
dry-run (constructed overlap case + real non-overlap pair).

## Phase 1: Setup

- [x] T001 Confirm `specjedi-parallel` doesn't collide with any existing
  skill name.

## Phase 2: User Story 1 - Safe-set determination (P1) 🎯 MVP

- [x] T002 [US1] Write Step 1 (candidate enumeration) and Step 2 (overlap
  check cross-referencing `plan.md`'s own "Source Code" sections,
  excluding `CLAUDE.md`/`.specify/feature.json` per FR-002) in
  `specjedi-parallel/SKILL.md`.
- [x] T003 [US1] Dry-run: construct two hypothetical `plan.md`s with a
  genuine overlapping file; confirm it's flagged by name.
- [x] T004 [US1] Dry-run: check two real recent features' own `plan.md`s
  (both touching `CLAUDE.md`/`.specify/feature.json`) are reported safe,
  not falsely flagged.

**Checkpoint**: User Story 1 independently complete.

## Phase 3: User Story 2 - Parallel dispatch (P2)

- [x] T005 [US2] Write Step 3: for each safe feature, self-invoke
  `specjedi-worktree`'s own creation mechanism unchanged; dispatch a
  distinct agent per worktree if the harness supports it (FR-005),
  otherwise report prepared worktrees honestly without claiming
  dispatch.

**Checkpoint**: User Story 2 independently complete.

## Phase 4: User Story 3 - Status visibility (P3)

- [x] T006 [US3] Write Step 4: point directly at `specjedi-status`'s own
  existing multi-worktree report; no new dashboard logic.

**Checkpoint**: All three user stories complete.

## Phase 5: Polish

- [x] T007 Write frontmatter, Persona, Task, Format, Example, Autonomous
  vs. confirm-first, `--auto` mode, Always/Never, Verifiable success
  criteria, Validation Coverage sections.
- [x] T008 Self-check token count (Principle XIX).
- [x] T009 Confirm `scripts/validate.sh` passes.

## Dependencies

- T001 blocks everything.
- Phase 2/3/4 write different sections of the same one file — sequential
  in practice, not `[P]`.
- Phase 5 depends on Phases 2-4.
