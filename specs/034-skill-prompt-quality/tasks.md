# Tasks: Close Prompt-Engineering Gaps in 5 `specjedi-*` Skills

**Input**: Design documents from `/specs/034-skill-prompt-quality/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md.
`quickstart.md`'s 6 scenarios serve as this feature's verification, run
in Polish.

**Organization**: Tasks grouped by user story (spec.md priorities
P1/P1/P1/P2).

## Path Conventions

5 existing files modified, one per skill, at
`.claude/skills/specjedi-<name>/SKILL.md`. No other files touched
(FR-006).

---

## Phase 1: User Story 1 — Constitutional and spec-writing conversations calibrate to the asker (P1) 🎯 MVP

**Goal**: `specjedi-constitution` and `specjedi-specify` each gain an
explicit audience-calibration instruction in `specjedi-clarify`'s
already-shipped shape.

**Independent Test**: Read both files; confirm each has an explicit
audience-calibration boundary note.

- [X] T001 [P] [US1] Add the audience-calibration boundary note to
      `.claude/skills/specjedi-constitution/SKILL.md` per `research.md`'s
      Fix 1 (FR-001) (depends on nothing).
- [X] T002 [P] [US1] Add the audience-calibration boundary note to
      `.claude/skills/specjedi-specify/SKILL.md` per `research.md`'s
      Fix 2 (FR-002) (depends on nothing).

**Checkpoint**: US1's independent test passes — both files carry the
note.

---

## Phase 2: User Story 2 — Skill recommendations explain their own evidence at the right depth (P1)

**Goal**: `specjedi-find-skills` gains an audience-calibration
instruction specifically addressing its own verification-signal
reasoning.

**Independent Test**: Read the file; confirm the note names install
count/source/GitHub stars specifically, not a generic restatement.

- [X] T003 [US2] Add the scoped audience-calibration note to
      `.claude/skills/specjedi-find-skills/SKILL.md` per `research.md`'s
      Fix 3 (FR-003) (depends on nothing).

**Checkpoint**: US2's independent test passes.

---

## Phase 3: User Story 3 — Onboarding's own judgment call reasons out loud (P1)

**Goal**: `specjedi-onboard`'s directional-synthesis step gains an
explicit chain-of-thought instruction.

**Independent Test**: Read the file's Step 2; confirm a "reason through
this explicitly" instruction is present in the step itself.

- [X] T004 [US3] Add the chain-of-thought instruction to
      `.claude/skills/specjedi-onboard/SKILL.md`'s Step 2 per
      `research.md`'s Fix 4 (FR-004) (depends on nothing).

**Checkpoint**: US3's independent test passes.

---

## Phase 4: User Story 4 — Quick-path eligibility reasoning is instructed, not just demonstrated (P2)

**Goal**: `specjedi-quick`'s eligibility-checklist step gains an
explicit chain-of-thought instruction.

**Independent Test**: Read the file's Step 1; confirm the instruction is
present directly in that step.

- [X] T005 [US4] Add the chain-of-thought instruction to
      `.claude/skills/specjedi-quick/SKILL.md`'s Step 1 per
      `research.md`'s Fix 5 (FR-005) (depends on nothing).

**Checkpoint**: US4's independent test passes.

---

## Phase 5: Polish & Cross-Cutting Concerns

- [X] T006 Run `quickstart.md`'s 6 scenarios in order, including the
      per-file word-count check (SC-003/FR-007) and the "exactly 5 files
      touched" check (SC-002/FR-006) (depends on T001-T005).
- [X] T007 Run `specjedi-govcheck` against this branch before opening
      the PR (depends on T006).

---

## Dependencies & Execution Order

- **Phases 1-4**: Fully independent — each touches a different file
  with no shared state. All 5 tasks (T001-T005) are genuinely parallel.
- **Polish (Phase 5)**: T006 depends on all of T001-T005. T007 depends
  on T006.

## Notes

- No task in this feature required a failing-test-first task per
  Principle VI — the exemption is stated in `plan.md`'s Constitution
  Check.
- Every fix traces to `research.md`'s own stated pattern — no task
  invents new phrasing.
