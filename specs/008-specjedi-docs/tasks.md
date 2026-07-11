---
description: "Task list for specjedi-docs (Feature 008)"
---

# Tasks: `specjedi-docs`

**Input**: `specs/008-specjedi-docs/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature, following the exact incremental-shipping
discipline established across features 001-007. Final item in the
original `references/skill-roadmap.md` backlog.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm `specs/008-specjedi-docs/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Document a shipped feature (P1) 🎯 MVP

**Goal**: A shipped feature gets an accurate README skill-table row,
Quickstart step, and `CHANGELOG.md` entry, each grounded in its actual
spec/plan content.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-docs/SKILL.md` per
  plan.md's Design section: persona, task, the completion gate (mirroring
  `specjedi-retro`), the grounding discipline for drafted doc lines, the
  confirm-before-write step, the README/CHANGELOG.md format conventions,
  `--auto` behavior, proactive gap-check hook.
- [x] T011 [US1] Add a full input → output worked example: a shipped
  feature's spec.md excerpt in, the drafted README row + Quickstart step +
  CHANGELOG.md entry out — using this project's own actual `specjedi-docs`
  feature (008) as the real, self-referential worked example (the skill
  documenting itself).
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never write to README.md or CHANGELOG.md without explicit
  confirmation of the drafted change" as a Never guardrail.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: draft documentation for this
  repo's own `specs/007-specjedi-security/` feature (already shipped) and
  confirm the drafted skill-table row and Quickstart step accurately
  reflect its actual spec content, cross-checked against the real
  `specjedi-security` row/step already live in README.md.

**Checkpoint**: `specjedi-docs` is independently usable — a user can
generate accurate, grounded documentation for a shipped feature.

## Phase 3: User Story 2 — Drafts require confirmation before writing (P2)

**Goal**: No file is modified until the user explicitly confirms the
drafted doc changes.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: confirm the skill's documented
  step sequence presents the full draft (all three pieces) before any
  write step, and that no step writes to README.md/CHANGELOG.md ahead of
  the confirmation step.
- [x] T021 [US2] Review `specjedi-docs/SKILL.md` against the full Skill
  Authoring Standard checklist in `references/skill-authoring-standard.md`
  before marking this story done.

**Checkpoint**: both user stories complete — `specjedi-docs` is safe to
ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-docs`; update
  `references/skill-roadmap.md` to move it from "Proposed, not yet built"
  to "Shipped" — this empties the "Proposed, not yet built" section
  entirely, since `specjedi-docs` was the last item in the original
  backlog.
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-docs` shipped (feature 008, seventh and final original
  roadmap item beyond the core P1-P9 pipeline).
- [x] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
