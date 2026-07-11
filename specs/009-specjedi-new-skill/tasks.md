---
description: "Task list for specjedi-new-skill (Feature 009)"
---

# Tasks: `specjedi-new-skill`

**Input**: `specs/009-specjedi-new-skill/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature, following the exact incremental-shipping
discipline established across features 001-008 — the first feature in
this repository's history run through the literal `/speckit-specify` →
`/speckit-clarify` → `/speckit-plan` → `/speckit-tasks` pipeline rather
than hand-authored artifacts matching that shape.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm `specs/009-specjedi-new-skill/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Scaffold a new skill's file structure (P1) 🎯 MVP

**Goal**: Given a one-sentence skill idea, produce a correctly-numbered
`specs/NNN-specjedi-<name>/` directory (four files) and a
`.claude/skills/specjedi-<name>/SKILL.md` skeleton with every Skill
Authoring Standard section as a labeled placeholder.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-new-skill/SKILL.md`
  per plan.md's Design section: persona, task, the placeholders-only
  discipline (FR-005), collision detection (FR-004), numbering read from
  `.specify/init-options.json` rather than assumed, chain-of-thought for
  near-collision judgment (not just exact-match), `--auto` behavior,
  proactive gap-check hook.
- [x] T011 [US1] Add a full input → output worked example: a one-sentence
  skill idea in, the resulting `specs/NNN-specjedi-<name>/` directory
  listing plus a `SKILL.md` skeleton excerpt (with explicit
  `[PLACEHOLDER: ...]` markers) out.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never write invented research findings, design rationale, or
  skill behavior — placeholders only" as a Never guardrail.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass, including against the scaffolded `SKILL.md`
  skeleton's own frontmatter (a placeholder `name:`/`description:` must
  still satisfy the lint's structural checks).
- [x] T014 [US1] Manual scenario dry run: exercise against a real
  one-sentence idea (e.g., "a skill that lints Mermaid diagrams for
  accessibility contrast") and confirm the scaffold produces the correct
  next-numbered directory, all four files, and a `SKILL.md` skeleton
  containing every required section — cross-checked against
  `references/skill-authoring-standard.md`'s own checklist.

**Checkpoint**: `specjedi-new-skill` is independently usable — a
contributor can go from an idea to a correctly-structured, placeholder-
only scaffold in one request.

## Phase 3: User Story 2 — Never skips the competitive research requirement (P2)

**Goal**: The scaffolded `research.md` contains Principle II's actual
checklist as explicit, unfilled prompts.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: inspect a freshly scaffolded
  `research.md` and confirm it contains the spec-kit + ten-competitor
  benchmarking prompt, the internal-redundancy check against already-
  shipped `specjedi-*` skills, and the genuine-contribution question —
  all as explicit placeholders, not left blank.
- [x] T021 [US2] Review `specjedi-new-skill/SKILL.md` against the full
  Skill Authoring Standard checklist in
  `references/skill-authoring-standard.md` before marking this story
  done.

**Checkpoint**: both user stories complete — `specjedi-new-skill` is safe
to ship.

## Phase 4: Documentation & Ship

- [ ] T030 Update README.md's skill table to add `specjedi-new-skill`;
  update `references/skill-roadmap.md` to add it under a new "Shipped
  (second wave)" grouping, since the original backlog's "Proposed, not
  yet built" section was already empty when this feature was proposed.
- [ ] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-new-skill` shipped (feature 009, first second-wave
  addition, and the first feature built via literal `/speckit-*`
  invocation rather than hand-authored matching artifacts).
- [ ] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.

## Parallel execution example

T010 and T011 both touch only `.claude/skills/specjedi-new-skill/
SKILL.md` sequentially (T011 extends what T010 creates), so they are not
actually parallelizable despite both being `[P]`-eligible by file-scope
alone — reasoned through explicitly per this project's own `[P]`
discipline (feature 001, `specjedi-tasks`'s own Never guardrail: "never
mark a task [P] without confirming genuine independence").

## Implementation strategy

MVP = Phase 2 (User Story 1) alone — a working scaffold generator with
correct structure and placeholders is independently valuable and
demonstrable even before Phase 3's research-checklist verification is
separately confirmed (which is largely already satisfied by T011's own
worked example, per the Independent Test's actual mechanics).
