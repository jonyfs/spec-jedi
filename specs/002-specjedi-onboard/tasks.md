---
description: "Task list for specjedi-onboard (Feature 002)"
---

# Tasks: `specjedi-onboard`

**Input**: `specs/002-specjedi-onboard/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature, following the exact incremental-shipping
discipline established across feature 001's P1-P9.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm `specs/002-specjedi-onboard/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — First-time user produces a real first constitution + spec (P1) 🎯 MVP

**Goal**: A first-time user with a one-sentence idea and no prior SDD
exposure gets a real, valid constitution and spec from a single
`specjedi-onboard` run, with concept narration inline.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-onboard/SKILL.md` per
  plan.md's Design section: persona, task, the first-run detection gate as
  Step 1 (before any narration), the real-idea gate (never substitute a
  placeholder), orchestration of `specjedi-constitution` then
  `specjedi-specify` rather than reimplementing their logic, point-of-use
  concept narration, `--auto` behavior (narrows pausing, never skips the
  real-idea gate), guided next-step suggestion pointing to
  `specjedi-clarify`, proactive gap-check hook.
- [x] T011 [US1] Add a full input → output worked example: a one-sentence
  project idea in, the narrated hand-off sequence (constitution concept →
  invoke specjedi-constitution → spec concept → invoke specjedi-specify →
  next-step suggestion) out.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: exercise against a fresh
  throwaway directory with a real one-sentence idea and confirm the
  documented step sequence produces both artifacts with narration
  preceding each hand-off, never a wall of explanation before the first
  question is asked.

**Checkpoint**: `specjedi-onboard` is independently usable — a first-timer
can go from zero to a real constitution + spec in one run.

## Phase 3: User Story 2 — Returning user is never re-onboarded (P2)

**Goal**: A user with an existing `constitution.md` never gets the
walkthrough re-run against their project.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Verify (as part of the same SKILL.md from T010) that the
  first-run detection gate is truly Step 1 — no narration, no file access
  beyond the existence check, precedes it.
- [x] T021 [US2] Manual scenario dry run: exercise against a directory with
  an existing valid `constitution.md` and confirm the skill reports
  onboarding already happened, suggests the next pipeline stage, and the
  directory's files are unchanged (`git status` / diff shows nothing).
- [x] T022 [US2] Review `specjedi-onboard/SKILL.md` against the full Skill
  Authoring Standard checklist in
  `references/skill-authoring-standard.md` before marking this story done.

**Checkpoint**: both user stories complete — `specjedi-onboard` is safe to
ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-onboard`; update
  `references/skill-roadmap.md` to move it from "Proposed, not yet built"
  to "Shipped."
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-onboard` shipped (feature 002, first roadmap item beyond
  the core P1-P9 pipeline).
- [x] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill
  rather than being sequenced across separate PRs.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
