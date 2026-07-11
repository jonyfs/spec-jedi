---
description: "Task list for specjedi-retro (Feature 006)"
---

# Tasks: `specjedi-retro`

**Input**: `specs/006-specjedi-retro/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature, following the exact incremental-shipping
discipline established across features 001-005.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm `specs/006-specjedi-retro/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Retrospect a completed feature (P1) 🎯 MVP

**Goal**: A user with a 100%-complete feature gets an honest retrospective
— deviations grounded in traceable sources, a dated log entry appended,
zero other files touched.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-retro/SKILL.md` per
  plan.md's Design section: persona, task, the 100%-completion gate
  (reusing `specjedi-status`'s checkbox-counting logic), the grounding
  discipline for deviation causes (cite the actual commit or say
  undeterminable), the log-entry format mirroring `skill-gaps.md`,
  `--auto` behavior, proactive gap-check hook.
- [x] T011 [US1] Add a full input → output worked example: a completed
  feature with a traceable deviation in, the narrative report plus the
  exact `.specify/memory/retro-log.md` entry out.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never invent a deviation's cause — cite a traceable source
  or say undeterminable" as a Never guardrail.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: run the comparison logic against
  one of this repo's own completed features (e.g.,
  `specs/005-specjedi-status/`) and confirm the report accurately
  reflects whether its actual implementation matched `plan.md`, using
  real `git log` output as the grounding source.

**Checkpoint**: `specjedi-retro` is independently usable — a user can
retrospect a completed feature with grounded, honest output.

## Phase 3: User Story 2 — An untraceable deviation is reported honestly (P2)

**Goal**: A deviation with no traceable explanation gets reported as
"cause not determinable," never a fabricated reason.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: exercise against a hypothetical
  deviation with no corresponding commit message/PR description/note and
  confirm the skill's documented step sequence reports it as
  undeterminable rather than inventing a plausible cause.
- [x] T021 [US2] Review `specjedi-retro/SKILL.md` against the full Skill
  Authoring Standard checklist in `references/skill-authoring-standard.md`
  before marking this story done.

**Checkpoint**: both user stories complete — `specjedi-retro` is safe to
ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-retro`; update
  `references/skill-roadmap.md` to move it from "Proposed, not yet built"
  to "Shipped," renumbering the remaining backlog items.
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-retro` shipped (feature 006, fifth roadmap item beyond
  the core P1-P9 pipeline).
- [x] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
