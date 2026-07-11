---
description: "Task list for specjedi-security (Feature 007)"
---

# Tasks: `specjedi-security`

**Input**: `specs/007-specjedi-security/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature plus a small, real proactive-trigger
integration into `specjedi-plan`, following the exact incremental-shipping
discipline established across features 001-006.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm `specs/007-specjedi-security/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Proactive security prompt during planning (P1) 🎯 MVP

**Goal**: A spec/plan with security-relevant content that leaves a
taxonomy category unaddressed gets a targeted question about it; an
already-addressed category never gets a redundant question.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `references/security-question-bank.md`: a
  maintained taxonomy organized by category (authentication, input
  validation, secrets/credentials, data privacy, dependency/supply-chain
  risk), each entry a specific, answerable question — mirroring
  `references/star-wars-lexicon.md`'s own structure and "extend, don't
  invent inline" convention.
- [x] T011 [P] [US1] Create `.claude/skills/specjedi-security/SKILL.md`
  per plan.md's Design section: persona, task, the grounding discipline
  (check whether the spec/plan already addresses a category before
  surfacing a question about it), the honesty discipline (never implies
  comprehensive coverage), `--auto` behavior, proactive gap-check hook.
- [x] T012 [US1] Add a full input → output worked example: a spec/plan
  excerpt describing a login flow with credential storage unaddressed in,
  the resulting targeted question (grounded in the taxonomy's "secrets"
  category) out.
- [x] T013 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never surface a question for a category the spec/plan
  already addresses" and "Never claim or imply comprehensive security
  review coverage" as Never guardrails.
- [x] T014 [US1] Wire the proactive trigger into
  `.claude/skills/specjedi-plan/SKILL.md`: add an explicit self-invoke
  instruction for `specjedi-security` when spec/plan content is
  security-relevant (authentication, external input, secrets, data
  handling), following the exact same pattern already used for
  `specjedi-find-skills` in that file (FR-007).
- [x] T015 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T016 [US1] Manual scenario dry run: exercise against a spec/plan
  excerpt describing authentication with credential storage unaddressed,
  and confirm a targeted question surfaces for that category only — not a
  generic list, not a redundant question for categories the excerpt
  already covers.

**Checkpoint**: `specjedi-security` is independently usable and correctly
wired to trigger proactively from `specjedi-plan`.

## Phase 3: User Story 2 — Never overclaims comprehensive coverage (P2)

**Goal**: Asked directly, the skill states plainly it isn't a security
review and points to `specjedi-checklist` (security focus) for
comprehensive coverage.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: pose the direct "does this mean
  it's secure?" question against the skill's documented response pattern
  and confirm it states plainly this is a lightweight prompt, not an
  audit, and names `specjedi-checklist` (security focus) as the
  comprehensive-coverage path.
- [x] T021 [US2] Review `specjedi-security/SKILL.md` against the full
  Skill Authoring Standard checklist in
  `references/skill-authoring-standard.md` before marking this story
  done.

**Checkpoint**: both user stories complete — `specjedi-security` is safe
to ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-security`;
  update `references/skill-roadmap.md` to move it from "Proposed, not yet
  built" to "Shipped," renumbering the remaining backlog items.
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-security` shipped (feature 007, sixth roadmap item
  beyond the core P1-P9 pipeline).
- [x] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- T014 (the `specjedi-plan` edit) depends on T011 (`specjedi-security`
  itself existing) so the self-invoke reference is real, not forward-
  referencing a skill that doesn't exist yet.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
