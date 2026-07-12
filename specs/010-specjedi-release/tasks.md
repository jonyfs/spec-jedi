---
description: "Task list for specjedi-release (Feature 010)"
---

# Tasks: `specjedi-release`

**Input**: `specs/010-specjedi-release/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature, built via literal `/speckit-*`
invocation per the established discipline since feature 009.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm `specs/010-specjedi-release/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Get a narrated release suggestion (P1) 🎯 MVP

**Goal**: `specjedi-release` runs the existing suggestion script and
presents its output narrated in Spec Jedi's voice, with zero writes.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-release/SKILL.md`
  per plan.md's Design section: persona, task, the wrap-never-reimplement
  discipline (FR-001), the absolute write boundary (FR-002/FR-003),
  format (present script output, don't invent structure), chain-of-
  thought for "asking about" vs. "asking to cut" a release, `--auto`
  behavior, proactive gap-check hook.
- [x] T011 [US1] Add a full input → output worked example: running the
  skill against this repository's own real (tagless) history — the
  actual first-release guidance `scripts/suggest-release.sh` produces
  when run for real — narrated in Spec Jedi's voice.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never execute git tag, publish, or any release-cutting
  action" as a Never guardrail.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: actually run
  `scripts/suggest-release.sh` against this repository's real state and
  confirm the skill's documented narration wraps that exact output
  without altering the substantive suggestion.

**Checkpoint**: `specjedi-release` is independently usable — a user gets
an accurate, narrated release suggestion with zero side effects.

## Phase 3: User Story 2 — Never tags or publishes (P2)

**Goal**: A request to actually cut a release gets declined with the
correct manual command named.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: pose "ship this release" against
  the skill's documented response pattern and confirm it declines, cites
  Principle XI, and names the manual `git tag` step — never executing it.
- [x] T021 [US2] Update `.claude/skills/specjedi-docs/SKILL.md`'s
  existing next-step reference (`specjedi-docs` step 7) to point at
  `specjedi-release` instead of the bare `scripts/suggest-release.sh` —
  a next-step bullet update only, explicitly not a proactive self-invoke
  wiring (FR-006, resolved via Clarifications).
- [x] T022 [US2] Review `specjedi-release/SKILL.md` against the full
  Skill Authoring Standard checklist in
  `references/skill-authoring-standard.md` before marking this story
  done.

**Checkpoint**: both user stories complete — `specjedi-release` is safe
to ship.

## Phase 4: Documentation & Ship

- [X] T030 Update README.md's skill table to add `specjedi-release`;
  update `references/skill-roadmap.md`'s "Shipped (second wave)" section.
  **Stale checkbox, corrected 2026-07-12** (project-wide `/speckit-converge`
  sweep): verified done — `specjedi-release` is present in README.md's
  skill table (and Quickstart) and `references/skill-roadmap.md`'s
  Shipped section ("feature 010, shipped 2026-07-11"); the checkbox was
  simply never ticked at the time.
- [X] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-release` shipped (feature 010, second second-wave
  addition).
  **Stale checkbox, corrected 2026-07-12**: verified done — the
  constitution's Sync Impact Report history records `specjedi-release`
  shipping (feature 010-specjedi-release, 2026-07-11).
- [X] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.
  **Stale checkbox, corrected 2026-07-12**: verified done — the feature
  is live on `main` today (skill ships, referenced throughout the
  codebase), confirming the original PR merged; only the checkbox itself
  was never updated.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- T021 (the `specjedi-docs` edit) depends on T010 (`specjedi-release`
  itself existing) so the cross-reference is real, not forward-
  referencing a skill that doesn't exist yet.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
