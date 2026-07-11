---
description: "Task list for the specjedi-* SDD pipeline (Feature 001)"
---

# Tasks: The `specjedi-*` SDD Pipeline

**Input**: `specs/001-specjedi-pipeline/{spec.md, plan.md, research.md}`

**Scope**: P1-P6 (`specjedi-constitution`, `specjedi-specify`,
`specjedi-clarify`, `specjedi-plan`, `specjedi-tasks`, `specjedi-implement`)
have shipped; P7 (`specjedi-analyze`) is this cycle's target, each its own
cycle per spec.md's Assumptions (prove the pattern incrementally). P8-P9
remain a scoped backlog.

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

## Phase 6: User Story 5 — `specjedi-tasks` (P5)

**Goal**: A user can run `specjedi-tasks` against a plan and get an
ordered, dependency-aware `tasks.md` organized by user story.

**Independent test**: See spec.md User Story 5 → Independent Test.

- [x] T070 [P] [US5] Create `.claude/skills/specjedi-tasks/SKILL.md` per
  plan.md's Design section: persona, task, `tasks.md` format (Setup +
  per-story phases + Dependencies), continuity requirement (tasks
  reference plan.md's actual named paths/conventions), chain-of-thought
  for `[P]` eligibility, test-first task ordering (Principle VI), audience
  calibration boundary, proactive gap-check hook.
- [x] T071 [US5] Add a full input → output worked example: a `plan.md`
  excerpt in, a `tasks.md` phase excerpt (with a test task before its
  implementation task) out.
- [x] T072 [US5] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist.
- [x] T073 [US5] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T074 [US5] Manual scenario dry run: exercise against a plan with 2+
  user stories and confirm tasks are grouped per story (each independently
  completable) and dependency-ordered; confirm a code-producing story gets
  its test task sequenced before implementation.
- [x] T075 [US5] Review against the Skill Authoring Standard checklist.

**Checkpoint**: `specjedi-constitution` → `specjedi-specify` →
`specjedi-clarify` → `specjedi-plan` → `specjedi-tasks` is now a complete,
usable slice through work breakdown.

## Phase 7: Documentation & Ship (P1-P5)

- [x] T080 Update README.md's "What you get today" table: move
  `specjedi-tasks` from the roadmap table to the "ships today" table;
  update the roadmap Mermaid diagram's live/roadmap markers to match
  (Principle XVI). Review the badge row per Principle X's pre-PR
  requirement.
- [x] T081 Update `.specify/memory/constitution.md`'s TODO(SPECJEDI_PIPELINE)
  note to reflect P1-P5 shipped, P6-P9 remaining.
- [x] T082 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Phase 8: User Story 6 — `specjedi-implement` (P6)

**Goal**: A user can run `specjedi-implement` against a `tasks.md` and have
it execute tasks in dependency order, test-first where the plan calls for
code, committing only through a feature branch + pull request — never
directly to `main` (Principle X, FR-006).

**Independent test**: See spec.md User Story 6 → Independent Test.

- [x] T090 [P] [US6] Create `.claude/skills/specjedi-implement/SKILL.md` per
  plan.md's Design section: persona, task, the pre-flight branch-check gate
  as Step 1 of every run (not a mentioned guideline — an executed check
  before the first edit and re-verified before every subsequent commit),
  chain-of-thought for dependency-ordered execution and re-validating `[P]`
  eligibility against actual current codebase state, test-first execution
  discipline (run the test, observe it fail, implement, run it again,
  observe it pass — never mark `[x]` on an unexecuted test), `--auto`
  behavior, proactive gap-check hook.
- [x] T091 [US6] Add a full input → output worked example: a `tasks.md`
  excerpt with a test-then-implementation task pair in, the branch-check
  gate firing + the test run/fail/implement/pass sequence + the task
  marked `[x]` out.
- [x] T092 [US6] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never commit while `git branch --show-current` reports the
  repo's trunk" as a Never guardrail, not just prose elsewhere in the file.
- [x] T093 [US6] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T094 [US6] Manual scenario dry run: exercise against a `tasks.md`
  with a test-first task pair and confirm the skill's documented sequence
  (branch check → test written & run failing → implementation → test run
  passing → commit on the feature branch, never trunk) is internally
  consistent and traceable step-by-step: no step in the SKILL.md permits
  a commit before the branch check, and no step permits marking a test
  task done without the test actually having been run.
- [x] T095 [US6] Review `specjedi-implement/SKILL.md` against the full
  Skill Authoring Standard checklist in
  `references/skill-authoring-standard.md` before marking this story done.

**Checkpoint**: `specjedi-constitution` → `specjedi-specify` →
`specjedi-clarify` → `specjedi-plan` → `specjedi-tasks` →
`specjedi-implement` is now a complete, usable slice from idea to shipped
code, entirely through feature branches and pull requests.

## Phase 9: Documentation & Ship (P6)

- [x] T096 Update README.md's "What you get today" table: move
  `specjedi-implement` from the roadmap table to the "ships today" table;
  update the roadmap Mermaid diagram's live/roadmap markers to match
  (Principle XVI). Review the badge row per Principle X's pre-PR
  requirement.
- [x] T097 Update `.specify/memory/constitution.md`'s TODO(SPECJEDI_PIPELINE)
  note to reflect P1-P6 shipped, P7-P9 remaining.
- [x] T098 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Phase 10: User Story 7 — `specjedi-analyze` (P7)

**Goal**: A user can run `specjedi-analyze` at any point to verify
`spec.md`, `plan.md`, and `tasks.md` remain consistent with each other and
with the constitution — strictly non-destructively.

**Independent test**: See spec.md User Story 7 → Independent Test.

- [x] T100 [P] [US7] Create `.claude/skills/specjedi-analyze/SKILL.md` per
  plan.md's Design section: persona, task, the structured findings-table
  format (Category/Location/Severity/Recommendation), the strictly
  read-only constraint made explicit as a step-sequence rule (no step
  writes to spec.md/plan.md/tasks.md), chain-of-thought for cross-artifact
  requirement tracing, constitution-conflict-is-always-CRITICAL rule,
  `--auto` behavior, proactive gap-check hook.
- [x] T101 [US7] Add a full input → output worked example: a spec/plan/
  tasks trio with one deliberately introduced inconsistency (a requirement
  with no corresponding task) in, the findings-table row that catches it
  out.
- [x] T102 [US7] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never modify spec.md/plan.md/tasks.md" as a Never guardrail.
- [x] T103 [US7] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T104 [US7] Manual scenario dry run: exercise against intentionally
  inconsistent spec/plan/tasks (a task referencing a requirement removed
  from the spec) and confirm the skill surfaces it in the findings table
  without modifying any file; exercise against consistent artifacts and
  confirm no false positives are reported.
- [x] T105 [US7] Review `specjedi-analyze/SKILL.md` against the full Skill
  Authoring Standard checklist in
  `references/skill-authoring-standard.md` before marking this story done.

**Checkpoint**: the pipeline now has a non-destructive safety net runnable
at any point after `specjedi-tasks` exists.

## Phase 11: Documentation & Ship (P7)

- [x] T106 Update README.md's "What you get today" table: move
  `specjedi-analyze` from the roadmap table to the "ships today" table;
  update the roadmap Mermaid diagram's live/roadmap markers to match
  (Principle XVI). Review the badge row per Principle X's pre-PR
  requirement.
- [x] T107 Update `.specify/memory/constitution.md`'s TODO(SPECJEDI_PIPELINE)
  note to reflect P1-P7 shipped, P8-P9 remaining.
- [x] T108 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Backlog (future cycle): User Stories 8-9

Not detailed task-by-task this cycle (spec.md Assumptions: prove the pattern
incrementally rather than all at once). Each becomes its own `[Story]`-tagged
task group later, following the exact shape of Phase 2-6/8/10 above:

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
- Phase 6 (US5) depends on Phase 5 (US4) — tasks decompose a plan that
  must already exist.
- Phase 7 (Documentation & Ship) depends on Phases 2 through 6 all being
  complete.
- Phase 8 (US6) depends on Phase 6 (US5) — implement executes a `tasks.md`
  that must already exist.
- Phase 9 (Documentation & Ship) depends on Phase 8 being complete.
- Phase 10 (US7) depends on Phase 6 (US5) — analyze reads a `tasks.md`
  that must already exist (it does not require implementation to have
  happened yet, per spec.md's own "at any point" framing).
- Phase 11 (Documentation & Ship) depends on Phase 10 being complete.
- US8-US9 (backlog) depend on US1-US7 as each stage requires.
