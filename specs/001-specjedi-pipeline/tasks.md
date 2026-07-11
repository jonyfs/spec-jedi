---
description: "Task list for the specjedi-* SDD pipeline (Feature 001)"
---

# Tasks: The `specjedi-*` SDD Pipeline

**Input**: `specs/001-specjedi-pipeline/{spec.md, plan.md, research.md}`

**Scope this cycle**: P1 (`specjedi-constitution`) and P2 (`specjedi-specify`)
are executed now. P3-P9 are listed as a scoped backlog for a future cycle,
per spec.md's Assumptions.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: parallelizable (different files, no dependency on another
  unfinished task in this list)
- **[Story]**: which user story this task belongs to

## Phase 1: Setup

- [ ] T001 Confirm `specs/001-specjedi-pipeline/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read; no automated tool
  needed for docs-only artifacts)

## Phase 2: User Story 1 — `specjedi-constitution` (P1) 🎯 MVP

**Goal**: A user can run `specjedi-constitution` in any project (this repo or
an end-user project) and get a fully valid, versioned `constitution.md`.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [ ] T010 [P] [US1] Create `.claude/skills/specjedi-constitution/SKILL.md`
  per plan.md's Design section: persona, task, format (constitution.md
  structure), chain-of-thought for version-bump classification, `--auto`
  flag behavior (FR-008), read-compatibility with an existing
  `speckit-*`-produced constitution (FR-009), guided next-step suggestion
  (Principle XIV) at the end of every run, proactive gap-check hook into
  `specjedi-find-skills` (Principle XVII).
- [ ] T011 [US1] Add at least one full input→output worked example to
  `specjedi-constitution/SKILL.md` (Skill Authoring Standard requirement) —
  a plain-language principle description in, a resolved constitution excerpt
  + Sync Impact Report out.
- [ ] T012 [US1] Add Always/Never guardrails and verifiable success criteria
  sections to `specjedi-constitution/SKILL.md` per the Skill Authoring
  Standard checklist.
- [ ] T013 [US1] Run `scripts/validate.sh` (and `scripts/validate.ps1` if on
  Windows) — structural lint must pass (frontmatter `name`/`description`,
  starts with `---`).
- [ ] T014 [US1] Manual scenario dry run (Principle IX, "scenario-based dry
  run confirming the skill's elicitation questions and branching logic
  behave as documented"): exercise `specjedi-constitution` against a fresh
  throwaway directory with no existing constitution, and again against a
  directory with an existing `speckit-*`-produced one (FR-009 path); confirm
  both produce a valid result and the guided next-step suggestion appears.
- [ ] T015 [US1] Review `specjedi-constitution/SKILL.md` against the full
  Skill Authoring Standard checklist in `references/skill-authoring-standard.md`
  before marking this story done.

**Checkpoint**: `specjedi-constitution` is independently usable and shippable
on its own even if nothing else in this feature lands.

## Phase 3: User Story 2 — `specjedi-specify` (P2)

**Goal**: A user can turn a one-sentence idea into a prioritized, testable
`spec.md` via `specjedi-specify`.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [ ] T020 [P] [US2] Create `.claude/skills/specjedi-specify/SKILL.md` per
  plan.md's Design section: persona (welcomes rough ideas), task, format
  (spec.md structure — prioritized user stories, functional requirements,
  success criteria), chain-of-thought for prioritization judgment, explicit
  `NEEDS CLARIFICATION` marking discipline (Principle V), `--auto` behavior,
  guided next-step suggestion, proactive gap-check hook.
- [ ] T021 [US2] Add at least one full input→output worked example — a
  one-sentence idea in, a `spec.md` excerpt with a P1 user story +
  acceptance scenarios out.
- [ ] T022 [US2] Add Always/Never guardrails and verifiable success criteria
  per the Skill Authoring Standard checklist.
- [ ] T023 [US2] Run `scripts/validate.sh`/`scripts/validate.ps1` — must pass.
- [ ] T024 [US2] Manual scenario dry run: exercise `specjedi-specify` against
  a deliberately vague one-line idea and confirm it produces
  `NEEDS CLARIFICATION` markers rather than silently assuming; exercise
  against a clear idea and confirm no spurious markers appear.
- [ ] T025 [US2] Review against the Skill Authoring Standard checklist.

**Checkpoint**: `specjedi-constitution` + `specjedi-specify` together prove
the full pattern P3-P9 will follow.

## Phase 4: Documentation & Ship

- [ ] T030 Update README.md's "What you get today" table: move
  `specjedi-constitution` and `specjedi-specify` from the roadmap table to
  the "ships today" table; update the roadmap Mermaid diagram's framing if
  it now undersells what's live (Principle XVI: diagram must stay accurate).
- [ ] T031 Update `.specify/memory/constitution.md`'s TODO(SPECJEDI_PIPELINE)
  note to reflect P1+P2 shipped, P3-P9 remaining (governance bookkeeping,
  consistent with how every prior amendment in this project tracked its own
  follow-up TODOs).
- [ ] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green across all four OS legs,
  confirm auto-merge (Principle X).

## Backlog (future cycle): User Stories 3-9

Not detailed task-by-task this cycle (spec.md Assumptions: prove the pattern
with P1+P2 first). Each becomes its own `[Story]`-tagged task group later,
following the exact shape of Phase 2/3 above:

- **US3** `specjedi-clarify` (P3) — ambiguity resolution, mirrors
  `speckit-clarify`'s mechanics, reframed per Principle XIX.
- **US4** `specjedi-plan` (P4) — applies PRP's "golden rule" (research.md #8)
  explicitly in its own design.
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
- Phase 4 depends on Phases 2 and 3 both being complete.
- US3-US9 (backlog) depend on US1 (a constitution must exist) and, for
  US4 onward, on US2 (a spec must exist) and US3 (clarified).
