---
description: "Task list for specjedi-tokencheck (Feature 012)"
---

# Tasks: `specjedi-tokencheck`

**Input**: `specs/012-specjedi-tokencheck/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature plus a scoped edit to
`specjedi-onboard/SKILL.md`, built via literal `/speckit-*` invocation
per the established discipline since feature 009.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm
  `specs/012-specjedi-tokencheck/{research.md,spec.md,plan.md}` are
  complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Detect and suggest a missing companion tool (P1) 🎯 MVP

**Goal**: `specjedi-tokencheck` checks `rtk`/`graphify` independently,
explains any missing tool's purpose and savings, and offers an install
walkthrough with zero unconfirmed writes.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-tokencheck/SKILL.md`
  per plan.md's Design section: persona, task, equal-treatment detection
  (FR-001), indeterminate-status handling (FR-006), no-redundant-
  suggestion discipline (FR-004), format, chain-of-thought for confirming
  vs. declining an install, `--auto` behavior, proactive gap-check hook.
- [x] T011 [US1] Add a full input → output worked example: running the
  skill against this repository's own real, mixed state (`graphify`
  present via `graphify-out/`, `rtk` status detected live) — the actual
  detection output, not a fabricated scenario.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never run an install/configure command without an explicit,
  unambiguous confirmation naming that specific tool" as a Never
  guardrail.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: actually check this
  repository's real environment for `rtk`/`graphify` and confirm the
  skill's documented detection logic reports each tool's true status
  correctly (SC-001/SC-003).

**Checkpoint**: `specjedi-tokencheck` is independently usable — a user
gets an accurate tooling report with zero side effects.

## Phase 3: User Story 2 — Never installs without explicit confirmation (P2)

**Goal**: A decline or ambiguous response to an install offer results in
zero installation action, with the manual command named instead.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: pose a decline and an ambiguous
  response against the skill's documented response pattern and confirm
  both result in no install action and a stated manual command.
- [x] T021 [US2] Wire the proactive self-invoke into
  `specjedi-onboard/SKILL.md` step 5 (FR-005) — verified by directly
  reading `specjedi-onboard/SKILL.md` first (Principle XVII discipline),
  matching the `specjedi-plan` → `specjedi-security` precedent (feature
  007).
- [x] T022 [US2] Review `specjedi-tokencheck/SKILL.md` against the full
  Skill Authoring Standard checklist in
  `references/skill-authoring-standard.md` before marking this story
  done.

**Checkpoint**: both user stories complete — `specjedi-tokencheck` is
safe to ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-tokencheck`;
  update Quickstart numbering; update `references/skill-roadmap.md`'s
  "Shipped (second wave)" section; add a `CHANGELOG.md` entry.
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-tokencheck` shipped (feature 012, fourth second-wave
  addition) — PATCH bump per established pattern for routine second-wave
  shipments.
- [x] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — the
  skill file ships as one unit.
- T021 (the `specjedi-onboard` wiring) depends on T010
  (`specjedi-tokencheck` itself existing) so the cross-reference is real,
  not forward-referencing a skill that doesn't exist yet.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
