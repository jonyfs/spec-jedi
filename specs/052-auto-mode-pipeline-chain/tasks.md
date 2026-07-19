---

description: "Task list for specs/052-auto-mode-pipeline-chain"
---

# Tasks: `--auto` Mode Verification & Chained Pipeline Execution

**Input**: Design documents from `/specs/052-auto-mode-pipeline-chain/`

**Tests**: No CI job. Verification: `scripts/validate.sh` + manual
dry-run.

## Phase 1: User Story 1 - Evidence-backed --auto verification (P1) 🎯 MVP

- [x] T001 [US1] Amend `specjedi-skill-review`: add Step 2.6
  (`--auto`-vs-Always/Never contradiction check) and a Format table row.
- [x] T002 [US1] Dry-run against `specjedi-release` (known-consistent
  case); confirm PASS with cited matching language.

**Checkpoint**: User Story 1 independently complete.

## Phase 2: User Story 2 - Chained --auto pipeline execution (P2)

- [x] T003 [US2] Confirm `specjedi-chain` doesn't collide with any
  existing skill name.
- [x] T004 [US2] Write `specjedi-chain/SKILL.md`: frontmatter, Persona,
  Task, Step-by-step (artifact-detection/resume per FR-004, per-stage
  `--auto` reuse per FR-003, halt-on-ambiguity per FR-002), Format,
  Example, Autonomous vs. confirm-first, `--auto` mode section, Always/
  Never, Verifiable success criteria, Validation Coverage.

**Checkpoint**: User Story 2 independently complete.

## Phase 3: User Story 3 - Surfacing existing quality gates (P3)

- [x] T005 [US3] Extend `specjedi-chain`'s own summary format to surface
  each artifact's already-existing quality gate status (FR-005) — no
  new self-invocation timing.

**Checkpoint**: All three user stories complete.

## Phase 4: Polish

- [x] T006 Self-check `specjedi-chain`'s own token count (Principle
  XIX).
- [x] T007 Confirm `scripts/validate.sh` passes.
- [x] T008 Manual dry-run: a hypothetical fully-resolvable spec chains
  through cleanly; a hypothetical ambiguous one halts at the right
  stage.

## Dependencies

- Phase 1 and Phase 2/3 are independent (different files).
- Phase 3 depends on Phase 2 (extends the same new skill).
- Phase 4 depends on all three.
