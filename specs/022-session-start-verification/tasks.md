# Tasks: Session-Start Live-Render Verification Closure

**Input**: Design documents from `/specs/022-session-start-verification/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Not requested — Principle VI exemption. `quickstart.md`'s 4
scenarios serve as this feature's actual verification.

**Organization**: Tasks grouped by user story (spec.md priorities P1/P1).

---

## Phase 1: Setup

- [X] T001 Re-confirm the exact `SessionStart:compact` payload text from
      this session's own transcript before citing it anywhere (research.md)

---

## Phase 2: User Story 1 - The constitution accurately reflects what's verified (Priority: P1) 🎯 MVP

- [X] T002 [US1] Update `specs/015-session-start-hook/tasks.md` T020:
      replace the "honestly NOT completed" language with the real,
      quoted `SessionStart:compact` evidence (research.md), explicitly
      noting it was a `compact` firing, not a from-scratch `startup`
      (depends on T001)
- [X] T003 [US1] Update `references/principle-traceability.md`'s
      Principle XXI row: mechanism confirmed via the real firing, still
      distinguished from the separate render-precedence question
      (depends on T002)
- [X] T004 [US1] Real check: `grep` both updated files, confirm neither
      still contains the stale "not yet observed"/"cannot be observed
      from within the same session" language (quickstart.md Scenarios
      1-2) (depends on T003)

**Checkpoint**: The stale claim is replaced with cited evidence — User
Story 1 (MVP) is independently satisfied.

---

## Phase 3: User Story 2 - The instruction conflict gets an honest resolution (Priority: P1)

- [X] T005 [US2] Add a precedence-rule paragraph to `CLAUDE.md`'s
      session-start orientation section: continuation/no-preface
      instructions win over a literal verbatim render, but the agent
      still surfaces real status information naturally in its response
      (depends on nothing — independent of Phase 2)
- [X] T006 [US2] Amend `.specify/memory/constitution.md`'s Principle
      XXI with the same precedence clarification, MINOR version bump,
      Sync Impact Report documenting the real observation that prompted
      it (depends on T005)
- [X] T007 [US2] Real check: `grep` `CLAUDE.md` for the precedence
      statement, confirm it's present and unambiguous (quickstart.md
      Scenario 3) (depends on T006)

**Checkpoint**: The discovered conflict has a documented, checkable
answer — User Story 2 is independently satisfied.

---

## Phase 4: Polish & Cross-Cutting Concerns

- [X] T008 Run `bash scripts/validate.sh`, confirm `PASSED` with zero
      unexpected WARN lines (quickstart.md Scenario 4)
- [X] T009 Add a new `## Unreleased` → `### Added` entry to
      `CHANGELOG.md`
- [X] T010 Review the README badge row — determine no change needed and
      document in the PR description

---

## Dependencies & Execution Order

- **Setup (Phase 1)**: No dependencies
- **User Story 1 (Phase 2)**: Depends on Setup
- **User Story 2 (Phase 3)**: Independent of Phase 2 — can run in parallel
- **Polish (Phase 4)**: Depends on Phases 2-3

## Notes

- This closure exists specifically because real evidence sat unused in
  the transcript — T002/T003 make that evidence actionable rather than
  leaving a true claim undocumented.
- Commit after each phase, not after every single task
