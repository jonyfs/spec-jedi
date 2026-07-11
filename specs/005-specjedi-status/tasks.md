---
description: "Task list for specjedi-status (Feature 005)"
---

# Tasks: `specjedi-status`

**Input**: `specs/005-specjedi-status/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature, following the exact incremental-shipping
discipline established across features 001-004.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm `specs/005-specjedi-status/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — See project-wide status across multiple features (P1) 🎯 MVP

**Goal**: A user with multiple `specs/NNN-feature-name/` directories in
different completion states gets one accurate table row per feature,
derived entirely from on-disk artifacts.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-status/SKILL.md` per
  plan.md's Design section: persona, task, the derivation rules
  (specified/planned/percentage-complete), the honesty discipline against
  asserting "stalled" (FR-004), the table format, `--auto` no-op
  documentation, proactive gap-check hook.
- [x] T011 [US1] Add a full input → output worked example: a set of
  feature directories in different states in, the resulting status table
  out — using this repo's own `specs/001-specjedi-pipeline/` through
  `specs/004-specjedi-diagram/` (all complete) as one real, checkable
  example row set.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never assert a 'stalled' judgment — report the commit date
  and let the reader decide" as a Never guardrail.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: run the derivation rules against
  this repo's own actual `specs/` directory (a real, non-synthetic test
  corpus by this point in the project) and confirm every reported
  artifact/completion percentage matches the actual files exactly.

**Checkpoint**: `specjedi-status` is independently usable — a user can see
accurate cross-feature status without maintaining anything separately.

## Phase 3: User Story 2 — No features in flight is a clean, honest result (P2)

**Goal**: A project with no conforming feature directories gets a plain
"nothing here yet" result, not an unexplained empty table.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: exercise against a description
  of a project with no `specs/` directory and confirm the skill's
  documented step sequence reports "no features found yet" with a
  suggested next step (`specjedi-specify`), never a bare empty table.
- [x] T021 [US2] Review `specjedi-status/SKILL.md` against the full Skill
  Authoring Standard checklist in `references/skill-authoring-standard.md`
  before marking this story done.

**Checkpoint**: both user stories complete — `specjedi-status` is safe to
ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-status`;
  update `references/skill-roadmap.md` to move it from "Proposed, not yet
  built" to "Shipped," renumbering the remaining backlog items.
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-status` shipped (feature 005, fourth roadmap item
  beyond the core P1-P9 pipeline).
- [x] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
