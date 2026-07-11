---
description: "Task list for specjedi-govcheck (Feature 013)"
---

# Tasks: `specjedi-govcheck`

**Input**: `specs/013-specjedi-govcheck/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature plus a scoped edit to
`specjedi-implement/SKILL.md`, built via literal `/speckit-*` invocation
per the established discipline since feature 009.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm
  `specs/013-specjedi-govcheck/{research.md,spec.md,plan.md}` are
  complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Get a per-principle compliance report (P1) 🎯 MVP

**Goal**: `specjedi-govcheck` diffs the current branch (or a named PR)
and reports all 20 principles + 2 cross-cutting sections as N/A,
Compliant, or Non-Compliant, with zero writes.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-govcheck/SKILL.md`
  per plan.md's Design section: persona, task, three-state assessment
  discipline (FR-002), report-only boundary (FR-004), traceability-index
  read-first behavior (FR-005), evidence-citing requirement (FR-006),
  empty-diff/inaccessible-PR handling (FR-007), format, chain-of-thought
  for the applicability judgment, `--auto` behavior, proactive gap-check
  hook.
- [x] T011 [US1] Add a full input → output worked example: constructing a
  real, minimal scratch branch with a genuine Principle XIII violation (a
  `.sh` script with no `.ps1` counterpart) and running the documented
  check logic against it by hand.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never modify any file" and "Never collapse N/A into
  Compliant or Non-Compliant" as Never guardrails.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: build the scratch branch
  described in T011 for real, apply the documented check logic by hand,
  and confirm the Principle XIII finding names the exact missing
  counterpart file (SC-001).
- [x] T015 [US1] Manual scenario dry run: apply the documented check
  logic against a real documentation-only diff (e.g., this repo's own
  recent doc-only commits) and confirm the clear majority of principles
  report Not Applicable rather than a forced Compliant/Non-Compliant
  (SC-003).

**Checkpoint**: `specjedi-govcheck` is independently usable — a user gets
an accurate three-state compliance report with zero side effects.

## Phase 3: User Story 2 — CRITICAL severity is absolute (P2)

**Goal**: A confirmed constitution conflict is always reported CRITICAL,
never downgraded.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: construct a clear constitution
  conflict (e.g., a hypothetical direct commit to `main`) and confirm the
  documented logic marks it CRITICAL unconditionally.
- [x] T021 [US2] Wire the proactive, non-blocking self-invoke into
  `specjedi-implement/SKILL.md` between step 6 (mark tasks `[x]`) and
  step 7 (open PR) (FR-008) — verified by directly reading
  `specjedi-implement/SKILL.md` first (Principle XVII discipline),
  matching the `specjedi-plan` → `specjedi-security` precedent (feature
  007). Explicitly preserve the existing "PR-opening is autonomous"
  statement — this wiring surfaces findings, it does not gate.
- [x] T022 [US2] Review `specjedi-govcheck/SKILL.md` against the full
  Skill Authoring Standard checklist in
  `references/skill-authoring-standard.md` before marking this story
  done.

**Checkpoint**: both user stories complete — `specjedi-govcheck` is safe
to ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-govcheck`;
  update Quickstart numbering; update `references/skill-roadmap.md`'s
  "Shipped (second wave)" section; add a `CHANGELOG.md` entry; review the
  badge row per the Distribution & Ecosystem Standards requirement.
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-govcheck` shipped (feature 013, fifth second-wave
  addition) — PATCH bump per established pattern for routine second-wave
  shipments.
- [x] T032 Update `checklists/project-completeness.md` CHK005 to note
  partial resolution (a real per-PR governance-checklist skill now
  exists, closing the "no mechanism" half of that finding).
- [x] T033 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge —
  and, since `specjedi-govcheck` now exists, actually run it against this
  very PR's own diff as a real dogfood dry run before opening it.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- T021 (the `specjedi-implement` wiring) depends on T010
  (`specjedi-govcheck` itself existing) so the cross-reference is real,
  not forward-referencing a skill that doesn't exist yet.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
