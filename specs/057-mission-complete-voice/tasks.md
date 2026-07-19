---

description: "Task list for specs/057-mission-complete-voice"
---

# Tasks: A Distinct "Mission Complete" Closing Voice

**Input**: Design documents from `/specs/057-mission-complete-voice/`

**Tests**: No CI job. Verification: `scripts/validate.sh` + manual
cross-discipline spot-check.

## Phase 1: User Story 1 - Define the trigger + closing convention (P1) 🎯 MVP

- [x] T001 [US1] Write `references/mission-complete-voice.md`: the
  exhausted-scope trigger condition (FR-001), the closing-line
  convention reusing `references/star-wars-lexicon.md` (FR-002), and
  the two hard guardrails — never fires with a real next step (FR-003),
  never implies project-wide completion (FR-004).
- [x] T002 [US1] Amend `specjedi-skill-review`'s own clean-pass closing
  text with the Mission Complete line, citing the new reference doc.

**Checkpoint**: User Story 1 independently demonstrable on one skill.

## Phase 2: User Story 2 - Apply consistently catalog-wide (P2)

- [x] T003 [P] [US2] Amend `specjedi-catalog-audit`'s own clean-audit
  closing text.
- [x] T004 [P] [US2] Amend `specjedi-constitution-audit`'s own
  clean-audit closing text.
- [x] T005 **Finding, out of scope**: `specjedi-quick` has no Principle
  XIV next-step/closing instruction at all today (same pre-existing gap
  flagged in specs/051's own PR) — no closing moment exists yet to add
  Mission Complete to. Not fixed here; flagged as a follow-up candidate
  alongside 051's own finding.
- [x] T006 Confirm `scripts/validate.sh` passes.
- [x] T007 Spot-check `specjedi-skill-review`'s updated closing text
  against the reference doc's trigger condition.

**Checkpoint**: All qualifying skills carry the same convention.

## Dependencies

- T001 blocks T002-T005 (the reference doc must exist first).
- T003-T005 are `[P]` — different files.
- T006-T007 depend on T002-T005.
