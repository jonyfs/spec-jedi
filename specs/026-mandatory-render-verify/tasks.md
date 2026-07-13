# Tasks: Mandatory, Failure-Aware Render Verification for `specjedi-diagram`

**Input**: Design documents from `/specs/026-mandatory-render-verify/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md. Feature
025 implemented first (branch rebased onto it) so these edits apply
against the already-revised Step 4.

**Tests**: Not requested — Principle VI exemption stated in plan.md.
`quickstart.md`'s scenarios serve as verification, run in Polish.

**Organization**: Tasks grouped by user story (spec.md P1/P1/P2).

## Path Conventions

One existing file revised: `.claude/skills/specjedi-diagram/SKILL.md`
(the same file feature 025 also revises — 025 lands first).

---

## Phase 1: Unconditional verification (US1)

- [X] T001 [US1] Revise Step 4's opening line: verification runs for
      *every* diagram, no skip branch, even for a "simple enough"
      diagram.

## Phase 2: Unified failure handling (US2)

- [X] T002 [US2] Add the "Verification failure — one category, two
      possible causes" subsection to Step 4: syntax rejection and a
      render-call failure (error/timeout/output-too-large) both trigger
      the same revise-and-recheck cycle.
- [X] T003 [US2] Document cause-based revision-strategy selection
      (syntax → fix syntax; size-driven → apply the Complexity check
      directly).

## Phase 3: Bounded retry + honest fallback (US3)

- [X] T004 [US3] Add the "Bounded retry, then an honest fallback"
      subsection: 2-attempt cap, explicit "⚠️ unverified" caveat if still
      failing.
- [X] T005 [US3] Extend `--auto` mode section: the 2-attempt bound and
      honest fallback apply identically in `--auto`.
- [X] T006 [US3] Extend Always/Never and Verifiable success criteria with
      the new unconditional-attempt, unified-failure, and bounded-retry
      requirements.

## Phase 4: Polish

- [X] T007 Run `quickstart.md`'s 4 scenarios manually (dry-run reasoning
      through each, including the induced-failure scenarios).
- [X] T008 Run `scripts/validate.sh`; confirm PASSED.
