# Tasks: Honest Advantages/Disadvantages Assessment for Spec Jedi Skills

**Input**: Design documents from `/specs/027-honest-pros-cons-doc/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md (pure
documentation, no executable logic). `quickstart.md`'s scenarios serve as
the verification step, run in the Polish phase below.

**Organization**: Tasks grouped by user story (spec.md P1/P1/P1).

## Path Conventions

Single new reference file (`references/honest-assessment.md`) plus one
`README.md` edit — no `src/`/`tests/` split applies, per plan.md.

---

## Phase 1: Setup

- [X] T001 Create `references/honest-assessment.md` with a title, purpose
      paragraph, and the "Last reviewed" marker line (FR-008), following
      `references/competitive-comparison.md`'s existing header structure.

## Phase 2: Foundational — Advantages section (US1)

- [X] T002 [US1] Write the Advantages section: 6 entries, each one claim
      + one citation to a specific shipped mechanism (plan.md's Design
      draft set), cross-checked against `references/principle-
      traceability.md` before finalizing.

## Phase 3: Disadvantages section (US2)

- [X] T003 [US2] Write the Disadvantages section: ≥5 entries (plan.md's
      draft set), each independently checkable against real repo state
      (git tag, `harness-capability-notes.md`, `skill-roadmap.md`).

## Phase 4: Improvement Points section (US3)

- [X] T004 [US3] Write the Improvement Points section: the
      competitor-grounded subset of Disadvantages, each naming a specific
      tool + capability gap, traced to `references/competitive-
      comparison.md`.

## Phase 5: Integration

- [X] T005 Add one link to `references/honest-assessment.md` from
      `README.md`, near the existing `competitive-comparison.md` link
      (FR-007).

## Phase 6: Polish

- [X] T006 Run `quickstart.md`'s 4 verification scenarios manually
      (grounding check on every Advantage/Disadvantage/Improvement
      Point).
- [X] T007 Run `scripts/validate.sh`; confirm PASSED.
