---
description: "Task list for the specjedi-* SDD pipeline (Feature 001)"
---

# Tasks: The `specjedi-*` SDD Pipeline

**Input**: `specs/001-specjedi-pipeline/{spec.md, plan.md, research.md}`

**Scope**: P1 (`specjedi-constitution`), P2 (`specjedi-specify`), and P3
(`specjedi-clarify`) have shipped; P4 (`specjedi-plan`) is this cycle's
target, each its own cycle per spec.md's Assumptions (prove the pattern
incrementally). P5-P9 remain a scoped backlog.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: parallelizable (different files, no dependency on another
  unfinished task in this list)
- **[Story]**: which user story this task belongs to

## Phase 1: Setup

- [x] T001 Confirm `specs/001-specjedi-pipeline/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read; no automated tool
  needed for docs-only artifacts)

## Phase 2: User Story 1 — `specjedi-constitution` (P1) 🎯 MVP

**Goal**: A user can run `specjedi-constitution` in any project (this repo or
an end-user project) and get a fully valid, versioned `constitution.md`.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-constitution/SKILL.md`
  per plan.md's Design section: persona, task, format (constitution.md
  structure), chain-of-thought for version-bump classification, `--auto`
  flag behavior (FR-008), read-compatibility with an existing
  `speckit-*`-produced constitution (FR-009), guided next-step suggestion
  (Principle XIV) at the end of every run, proactive gap-check hook into
  `specjedi-find-skills` (Principle XVII).
- [x] T011 [US1] Add at least one full input→output worked example to
  `specjedi-constitution/SKILL.md` (Skill Authoring Standard requirement) —
  a plain-language principle description in, a resolved constitution excerpt
  + Sync Impact Report out.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success criteria
  sections to `specjedi-constitution/SKILL.md` per the Skill Authoring
  Standard checklist.
- [x] T013 [US1] Run `scripts/validate.sh` (and `scripts/validate.ps1` if on
  Windows) — structural lint must pass (frontmatter `name`/`description`,
  starts with `---`).
- [x] T014 [US1] Manual scenario dry run (Principle IX, "scenario-based dry
  run confirming the skill's elicitation questions and branching logic
  behave as documented"): exercise `specjedi-constitution` against a fresh
  throwaway directory with no existing constitution, and again against a
  directory with an existing `speckit-*`-produced one (FR-009 path); confirm
  both produce a valid result and the guided next-step suggestion appears.
- [x] T015 [US1] Review `specjedi-constitution/SKILL.md` against the full
  Skill Authoring Standard checklist in `references/skill-authoring-standard.md`
  before marking this story done.

**Checkpoint**: `specjedi-constitution` is independently usable and shippable
on its own even if nothing else in this feature lands.

## Phase 3: User Story 2 — `specjedi-specify` (P2)

**Goal**: A user can turn a one-sentence idea into a prioritized, testable
`spec.md` via `specjedi-specify`.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [P] [US2] Create `.claude/skills/specjedi-specify/SKILL.md` per
  plan.md's Design section: persona (welcomes rough ideas), task, format
  (spec.md structure — prioritized user stories, functional requirements,
  success criteria), chain-of-thought for prioritization judgment, explicit
  `NEEDS CLARIFICATION` marking discipline (Principle V), `--auto` behavior,
  guided next-step suggestion, proactive gap-check hook.
- [x] T021 [US2] Add at least one full input→output worked example — a
  one-sentence idea in, a `spec.md` excerpt with a P1 user story +
  acceptance scenarios out.
- [x] T022 [US2] Add Always/Never guardrails and verifiable success criteria
  per the Skill Authoring Standard checklist.
- [x] T023 [US2] Run `scripts/validate.sh`/`scripts/validate.ps1` — must pass.
- [x] T024 [US2] Manual scenario dry run: exercise `specjedi-specify` against
  a deliberately vague one-line idea and confirm it produces
  `NEEDS CLARIFICATION` markers rather than silently assuming; exercise
  against a clear idea and confirm no spurious markers appear.
- [x] T025 [US2] Review against the Skill Authoring Standard checklist.

**Checkpoint**: `specjedi-constitution` + `specjedi-specify` together prove
the full pattern P3-P9 will follow.

## Phase 4: User Story 3 — `specjedi-clarify` (P3)

**Goal**: A user can run `specjedi-clarify` on a spec with `NEEDS
CLARIFICATION` markers (or vaguer ambiguity) and get asked up to 5
targeted, calibrated questions whose answers are written back into
`spec.md`.

**Independent test**: See spec.md User Story 3 → Independent Test.

- [x] T040 [P] [US3] Create `.claude/skills/specjedi-clarify/SKILL.md` per
  plan.md's Design section: persona, task, `## Clarifications` format,
  chain-of-thought for impact×uncertainty question prioritization,
  Audience Calibration (Principle XIX — Recommended option + reasoning on
  every multiple-choice question), `--auto` behavior, proactive gap-check
  hook into `specjedi-find-skills`.
- [x] T041 [US3] Add a full input → output worked example: a spec with 2-3
  ambiguities in, the resulting `## Clarifications` block + integrated
  spec edits out.
- [x] T042 [US3] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist.
- [x] T043 [US3] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T044 [US3] Manual scenario dry run: exercise against a spec with
  genuine ambiguity (confirm targeted, prioritized questions with a
  Recommended option each) and against a spec with no ambiguity (confirm
  it reports nothing needs clarifying rather than inventing questions).
- [x] T045 [US3] Review against the Skill Authoring Standard checklist.

**Checkpoint**: `specjedi-constitution` → `specjedi-specify` →
`specjedi-clarify` is now a complete, usable slice through spec.md
readiness.

## Phase 5: User Story 4 — `specjedi-plan` (P4)

**Goal**: A user can run `specjedi-plan` against a clarified spec and get a
`plan.md` (plus `research.md`/`data-model.md` as applicable) detailed
enough that implementation never has to stop and search the codebase.

**Independent test**: See spec.md User Story 4 → Independent Test.

- [x] T050 [P] [US4] Create `.claude/skills/specjedi-plan/SKILL.md` per
  plan.md's Design section: persona, task, `plan.md` format (Summary,
  Technical Context, Constitution Check, Project Structure, Complexity
  Tracking), the golden-rule codebase-scan step, chain-of-thought for
  Constitution Check gate evaluation, audience calibration scoped to the
  skill's narration (not the plan's own field content), `--auto`
  behavior, proactive gap-check hook.
- [x] T051 [US4] Add a full input → output worked example: a clarified
  spec in, a `plan.md` excerpt (including a real Constitution Check gate
  entry) out.
- [x] T052 [US4] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist.
- [x] T053 [US4] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T054 [US4] Manual scenario dry run: exercise against a spec whose
  plan would violate a constitution principle without justification and
  confirm the skill either records it in Complexity Tracking with real
  justification or simplifies the plan — never silently passes a gate
  failure.
- [x] T055 [US4] Review against the Skill Authoring Standard checklist.

**Checkpoint**: `specjedi-constitution` → `specjedi-specify` →
`specjedi-clarify` → `specjedi-plan` is now a complete, usable slice
through technical planning.

## Phase 6: Documentation & Ship

- [x] T060 Update README.md's "What you get today" table: move
  `specjedi-plan` from the roadmap table to the "ships today" table;
  update the roadmap Mermaid diagram's live/roadmap markers to match
  (Principle XVI). Review the badge row per Principle X's pre-PR
  requirement — confirm the dynamic Constitution badge still resolves and
  decide if a new badge is warranted.
- [x] T061 Update `.specify/memory/constitution.md`'s TODO(SPECJEDI_PIPELINE)
  note to reflect P1-P4 shipped, P5-P9 remaining.
- [x] T062 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green across all five required
  jobs (four OS lint legs + `owner-gate`), confirm auto-merge (Principle X).

## Backlog (future cycle): User Stories 5-9

Not detailed task-by-task this cycle (spec.md Assumptions: prove the pattern
incrementally rather than all at once). Each becomes its own `[Story]`-tagged
task group later, following the exact shape of Phase 2-5 above:

- **US5** `specjedi-tasks` (P5).
- **US6** `specjedi-implement` (P6) — must enforce Principle X (branch+PR
  only, never direct-to-main) as a hard behavioral constraint, not just
  documentation.
- **US7** `specjedi-analyze` (P7) — non-destructive consistency checker.
- **US8** `specjedi-checklist` (P8).
- **US9** `specjedi-converge` (P9).

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) — both are `[P]`-eligible
  relative to each other structurally, but are being executed sequentially
  in this cycle for reviewability (one skill's worth of diff at a time).
- Phase 4 (US3) depends on Phase 3 (US2) — clarify operates on a spec that
  must already exist.
- Phase 5 (US4) depends on Phase 4 (US3) — plan operates on a clarified
  spec, per the pipeline's own intended order (spec → clarify → plan).
- Phase 6 (Documentation & Ship) depends on Phases 2 through 5 all being
  complete.
- US5-US9 (backlog) depend on US1 (a constitution must exist), US2 (a spec
  must exist), US3 (clarified), and US4 (planned) as each stage requires.
