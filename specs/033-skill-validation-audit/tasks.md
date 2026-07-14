# Tasks: Skill Validation & Testing Framework Compliance Audit

**Input**: Design documents from `/specs/033-skill-validation-audit/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's
Technical Context (this feature's deliverable is `SKILL.md` documentation
content, not application code). `quickstart.md`'s 5 scenarios — real
`grep`-based structural checks plus `scripts/validate.sh` — serve as this
feature's verification, run in Polish.

**Organization**: Tasks grouped by user story (spec.md priorities
P1/P1/P2). Per `research.md`'s own reasoning, US1 (state applicability)
and US2 (back it with a real scenario) converge into one edit per skill —
writing "Applicable" without a concrete scenario would already fail
FR-002/US2's own acceptance criteria, so each Phase 3 task below performs
both in one motion. Phase 4 is US2's own independent verification pass.

## Path Conventions

24 existing files modified, one per skill, at
`.claude/skills/specjedi-<name>/SKILL.md`. `specjedi-skill-review` gets
one additional edit (US3). `CHANGELOG.md` gains one entry.

---

## Phase 1: Setup

- [X] T001 Re-read `references/skill-validation-testing-framework.md`
      and `research.md`'s four applicability rules + full table in full
      — the grounding both Phase 3 and Phase 4 depend on (depends on
      nothing).

---

## Phase 2: Foundational

- [X] T002 Confirm the exact section heading/placement convention
      (`## Validation Coverage (Principle IX)`, final section, four
      fixed-order lines) against `research.md`'s Decision — this is the
      one shared structural contract every Phase 3 task must match
      identically for SC-004 to hold (depends on T001).

---

## Phase 3: User Story 1 + 2 — Every skill states applicability with a real scenario (P1) 🎯 MVP

**Goal**: Every one of the 24 shipped skills' `SKILL.md` explicitly
addresses all four framework categories, each Applicable finding backed
by a concrete, skill-specific scenario (cross-referenced from existing
content per FR-005, or newly written where genuinely missing).

**Independent Test**: `grep -L "Validation Coverage (Principle IX)"
.claude/skills/specjedi-*/SKILL.md` returns empty; a manual read of any
Applicable line shows concrete input/behavior, never a generic
restatement.

- [X] T003 [P] [US1] Read `.claude/skills/specjedi-onboard/SKILL.md` in
      full; add its Validation Coverage section per `research.md`'s row
      (Cat 1/2 Applicable, Cat 3/4 N/A), cross-referencing existing
      content where present (depends on T002).
- [X] T004 [P] [US1] Same for `specjedi-constitution` (Cat 1/2/3
      Applicable, Cat 4 N/A) (depends on T002).
- [X] T005 [P] [US1] Same for `specjedi-specify` (Cat 1/2/3 Applicable,
      Cat 4 N/A) (depends on T002).
- [X] T006 [P] [US1] Same for `specjedi-clarify` (Cat 2/3 Applicable, Cat
      1/4 N/A) (depends on T002).
- [X] T007 [P] [US1] Same for `specjedi-plan` (Cat 2/3/4 Applicable, Cat
      1 N/A) (depends on T002).
- [X] T008 [P] [US1] Same for `specjedi-tasks` (Cat 2/3 Applicable, Cat
      1/4 N/A) (depends on T002).
- [X] T009 [P] [US1] Same for `specjedi-implement` (Cat 2/3/4 Applicable,
      Cat 1 N/A) (depends on T002).
- [X] T010 [P] [US1] Same for `specjedi-quick` (Cat 1/3/4 Applicable, Cat
      2 N/A) (depends on T002).
- [X] T011 [P] [US1] Same for `specjedi-analyze` (Cat 2/3 Applicable, Cat
      1/4 N/A) (depends on T002).
- [X] T012 [P] [US1] Same for `specjedi-checklist` (Cat 1/2/3 Applicable,
      Cat 4 N/A) (depends on T002).
- [X] T013 [P] [US1] Same for `specjedi-converge` (Cat 2/3 Applicable,
      Cat 1/4 N/A) (depends on T002).
- [X] T014 [P] [US1] Same for `specjedi-find-skills` (Cat 1/4 Applicable,
      Cat 2/3 N/A) (depends on T002).
- [X] T015 [P] [US1] Same for `specjedi-explain` (Cat 1 Applicable, Cat
      2/3/4 N/A) (depends on T002).
- [X] T016 [P] [US1] Same for `specjedi-migrate` (Cat 2/3 Applicable, Cat
      1/4 N/A) (depends on T002).
- [X] T017 [P] [US1] Same for `specjedi-diagram` (Cat 2/3/4 Applicable,
      Cat 1 N/A) (depends on T002).
- [X] T018 [P] [US1] Same for `specjedi-status` (Cat 2/3 Applicable, Cat
      1/4 N/A) (depends on T002).
- [X] T019 [P] [US1] Same for `specjedi-retro` (Cat 2/3 Applicable, Cat
      1/4 N/A) (depends on T002).
- [X] T020 [P] [US1] Same for `specjedi-security` (Cat 2 Applicable, Cat
      1/3/4 N/A) (depends on T002).
- [X] T021 [P] [US1] Same for `specjedi-docs` (Cat 2/3 Applicable, Cat
      1/4 N/A) (depends on T002).
- [X] T022 [P] [US1] Same for `specjedi-new-skill` (Cat 1/3 Applicable,
      Cat 2/4 N/A) (depends on T002).
- [X] T023 [P] [US1] Same for `specjedi-release` (Cat 2/3 Applicable, Cat
      1/4 N/A) (depends on T002).
- [X] T024 [P] [US1] Same for `specjedi-skill-review` (Cat 2/3
      Applicable, Cat 1/4 N/A) — this task adds only the Validation
      Coverage section; the US3/FR-006 review-dimension step is a
      separate edit to the same file in Phase 5 (T026) (depends on T002).
- [X] T025 [P] [US1] Same for `specjedi-tokencheck` (all four N/A) and
      `specjedi-govcheck` (Cat 2/3/4 Applicable, Cat 1 N/A) (depends on
      T002).

**Checkpoint**: All 24 skills carry the new section — US1's independent
test (`grep -L` returns empty) passes.

---

## Phase 4: User Story 2 verification — No generic placeholders (P1)

**Goal**: Confirm every Applicable finding across all 24 skills carries
real, concrete content, not a restatement of the category's definition.

**Independent Test**: A read-through spot-check of every Applicable line
across all 24 files shows named input and named expected behavior or a
specific existing-content cross-reference.

- [X] T026 [US2] Read every Applicable line written in Phase 3 across all
      24 files; flag and immediately fix any that reads as a generic
      restatement rather than concrete content (SC-002) (depends on
      T003-T025).

**Checkpoint**: US2's independent test passes — every Applicable finding
is real, checkable content.

---

## Phase 5: User Story 3 — Future skills get checked automatically (P2)

**Goal**: `specjedi-skill-review`'s own review criteria name this
framework explicitly, so a newly-authored or newly-revised skill gets
checked against it going forward.

**Independent Test**: Read `specjedi-skill-review/SKILL.md`'s own
step-by-step; confirm the framework's four categories appear as an
explicit review dimension.

- [X] T027 [US3] Add a new step to
      `.claude/skills/specjedi-skill-review/SKILL.md`'s step-by-step:
      check whether the reviewed skill's `SKILL.md` carries a Validation
      Coverage (Principle IX) section addressing all four categories from
      `references/skill-validation-testing-framework.md`, reporting a gap
      the same way this skill already reports a missing/weak section
      (FR-006) (depends on T024).

**Checkpoint**: A future skill review run surfaces a missing/weak
Validation Coverage section the same way it already surfaces other
Skill Authoring Standard gaps.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T028 [P] Add the `CHANGELOG.md` entry.
- [X] T029 Run `quickstart.md`'s 5 scenarios in order (depends on T026,
      T027).
- [ ] T030 Run `specjedi-govcheck` against this branch before opening the
      PR (depends on T029).

---

## Dependencies & Execution Order

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Phase 1.
- **Phase 3**: Depends on Phase 2. T003-T025 each touch a different
  file and are genuinely parallel.
- **Phase 4**: Depends on all of Phase 3 completing (it reads every
  file Phase 3 wrote).
- **Phase 5**: Depends on T024 (same file, `specjedi-skill-review`) —
  sequenced after Phase 3's own edit to that file to avoid a
  same-file conflict.
- **Polish (Phase 6)**: T028 is independent. T029 depends on T026/T027.
  T030 depends on T029.

## Notes

- No task in this feature required a failing-test-first task per
  Principle VI — the exemption is stated in `plan.md`'s Constitution
  Check and re-stated in this file's header.
- Every applicability status traces to `research.md`'s table, which
  itself traces to the four stated rules — no task here re-derives
  applicability ad hoc; each task applies what Phase 0 already decided.
