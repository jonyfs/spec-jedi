---
description: "Task list for specjedi-migrate (Feature 003)"
---

# Tasks: `specjedi-migrate`

**Input**: `specs/003-specjedi-migrate/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature, following the exact incremental-shipping
discipline established across features 001 and 002.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm `specs/003-specjedi-migrate/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Migrate a spec-kit project's tooling references (P1) 🎯 MVP

**Goal**: A team's constitution/spec/plan/tasks with literal `/speckit-*`
command references gets those references rewritten to `specjedi-*`
equivalents, with a migration report and zero substantive-content changes.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-migrate/SKILL.md` per
  plan.md's Design section: persona, task, the prerequisite installed-
  skills check (FR-004), the live-prose-vs-quoted/historical distinction
  as an explicit judgment call, the migration-report format (Rewritten /
  Flagged lists), `--auto` behavior, proactive gap-check hook. Explicit
  request only — never proactively triggered (FR-003).
- [x] T011 [US1] Add a full input → output worked example: a constitution
  excerpt with several live `/speckit-*` references in, the rewritten
  excerpt plus migration report out — including one flagged reference with
  no shipped equivalent (`/speckit-taskstoissues`).
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never rewrite a reference inside a code fence or historical/
  quoted context" as a Never guardrail.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: exercise against a constitution
  excerpt with a mix of live references, a historical/quoted mention, and
  a reference with no shipped equivalent; confirm only the live references
  get rewritten, the historical mention is flagged not altered, and the
  no-equivalent reference is flagged not dropped.

**Checkpoint**: `specjedi-migrate` correctly handles the core rewrite case
and its two hardest edge cases (historical mentions, no-equivalent
references) without over- or under-rewriting.

## Phase 3: User Story 2 — Nothing to migrate is a clean, honest result (P2)

**Goal**: A project with zero `speckit-*` references gets an honest "nothing
to migrate" result and zero file changes.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: exercise against a constitution
  with no `speckit-*` mentions at all and confirm the skill reports
  "nothing to migrate" and touches no file — verified via `git status`
  showing no changes.
- [x] T021 [US2] Review `specjedi-migrate/SKILL.md` against the full Skill
  Authoring Standard checklist in `references/skill-authoring-standard.md`
  before marking this story done.

**Checkpoint**: both user stories complete — `specjedi-migrate` is safe to
ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-migrate`;
  update `references/skill-roadmap.md` to move it from "Proposed, not yet
  built" to "Shipped," renumbering the remaining backlog items.
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-migrate` shipped (feature 003, second roadmap item
  beyond the core P1-P9 pipeline).
- [x] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
