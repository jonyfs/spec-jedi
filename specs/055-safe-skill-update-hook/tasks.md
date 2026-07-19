---

description: "Task list for specs/055-safe-skill-update-hook"
---

# Tasks: Interactive Update Prompt & Loss-Safe Skill Update

**Input**: Design documents from `/specs/055-safe-skill-update-hook/`

**Tests**: No CI job. Verification: manual dry-run (hand-edit a skill
file, re-run install.sh, confirm backup).

## Phase 1: User Story 1 - Loss-safe overwrite (P1) 🎯 MVP

- [x] T001 [US1] Amend `scripts/install.sh`: before the skill-copy
  loop's `rm -rf`+`cp -R`, check if the target exists and differs
  (`diff -rq`) from the source; if so, copy it to
  `.specify/backups/<UTC-timestamp>/` first (FR-001/002).
- [x] T002 [US1] Extend the same backup check to the template-copy loop
  (`.specify/templates/*.md`), per the FR-008 Clarification.
- [x] T003 [US1] Confirm no backup triggers on a fresh install (no prior
  target to compare against) — FR-003.
- [x] T004 [US1] Port identical logic to `scripts/install.ps1`
  (Principle XIII).
- [x] T005 [US1] Manual dry-run: hand-edit a skill file, re-run
  `install.sh`, confirm the edit is backed up before being overwritten.

**Checkpoint**: User Story 1 independently complete.

## Phase 2: User Story 2 - Interactive update trigger (P2)

- [x] T006 [US2] Amend `scripts/session-start.sh`'s `freshness_line`:
  change from purely informational to a directive prompt naming both
  the update and that the agent should ask the user (FR-004).
- [x] T007 [US2] Port identical change to `scripts/session-start.ps1`.
- [x] T008 [US2] Add one sentence to `CLAUDE.md`'s own Session-start
  orientation section: when a freshness/update line is present, ask the
  user directly (yes/no); on yes, run the named script via Bash; on no,
  proceed normally (FR-005/006).
- [x] T009 [US2] Amend Constitution Principle XXII (PATCH): reconcile
  "advisory only" with the new interactive trigger — clarify "advisory"
  means never blocking/forcing, not never asking; confirm no second
  update flow is invented.

**Checkpoint**: User Story 2 independently complete.

## Phase 3: User Story 3 - Interactive rendering (P3)

- [x] T010 [US3] No new work — already satisfied by feature 051 (merged)
  the same way feature 054 already confirmed: any next-step/prompt
  moment inherits the interactive mechanism automatically once
  available.

## Phase 4: Polish

- [x] T011 Confirm `scripts/validate.sh` passes.
- [x] T012 Re-verify FR-009: `.specify/memory/constitution.md` and
  `CLAUDE.md`'s own non-managed content remain untouched by the backup
  logic itself (only read for comparison, never backed-up-and-replaced
  the way skill/template files are).

## Dependencies

- T001-T003 before T004 (bash reference implementation first); T004
  before T005.
- T006-T007 before T008; T008 before T009 (constitution amendment
  reflects the now-implemented behavior).
- T011-T012 depend on all prior phases.
