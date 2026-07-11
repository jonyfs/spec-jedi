---
description: "Task list for specjedi-skill-review (Feature 011)"
---

# Tasks: `specjedi-skill-review`

**Input**: `specs/011-specjedi-skill-review/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature, built via literal `/speckit-*`
invocation per the established discipline since feature 009.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm
  `specs/011-specjedi-skill-review/{research.md,spec.md,plan.md}` are
  complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Audit one skill and get a findings report (P1) 🎯 MVP

**Goal**: `specjedi-skill-review` checks a named skill's `SKILL.md`
against Principle XIX plus the three companion dimensions, distinguishing
missing from weak, and reports findings or an explicit clean pass.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-skill-review/SKILL.md`
  per plan.md's Design section: persona, task, the report-only discipline
  (FR-005), the missing-vs-weak distinction (FR-004), the `plan.md`
  cross-reference for exemptions (FR-006), the out-of-scope decline for
  `speckit-*` targets (FR-008), format, chain-of-thought for both real
  judgment calls, `--auto` behavior, proactive gap-check hook.
- [x] T011 [US1] Add a full input → output worked example: reviewing a
  scratch copy of a real shipped skill with a known, previously-real gap
  reintroduced (the `specjedi-docs` chain-of-thought sentence, stripped
  from a scratch copy) and the resulting findings report naming that
  exact gap and citing Principle XX.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never edit, fix, or otherwise modify the reviewed SKILL.md"
  as a Never guardrail.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: actually copy
  `specjedi-docs/SKILL.md` to a scratch path, strip its chain-of-thought
  sentence, run the review's documented check logic against it by hand,
  and confirm the finding names the exact gap and principle (SC-001).
- [x] T015 [US1] Manual scenario dry run: apply the review's documented
  check logic by hand against every currently shipped `specjedi-*` skill
  and confirm a clean pass for each (SC-003) — no false positives.
  **Result**: 18 of 20 skills clean pass. Two true findings surfaced —
  `specjedi-explain` (missing `Format` and `` `--auto` mode `` sections)
  and `specjedi-find-skills` (missing `` `--auto` mode `` section) — both
  pre-existing gaps in already-shipped skills, confirmed by full manual
  read (not grep false positives). `specjedi-constitution`/`specjedi-
  specify`'s `## Steps` heading (vs. `## Step-by-step`) checked and judged
  content-equivalent, not a finding. SC-003 concerns false positives, not
  zero findings — two true positives confirm the tool works; tracked as a
  follow-up fix (feature 011's own scope stays the review tool itself, per
  this project's established discipline of tracking cross-cutting gaps
  found on audit as their own follow-up rather than scope-creeping the
  triggering feature — e.g., the original GROUNDING_PASS/NEXT_STEP_PASS/
  VOICE_PASS/PROMPT_ENG_PASS passes).

**Checkpoint**: `specjedi-skill-review` is independently usable — a user
gets an accurate findings report or clean pass with zero side effects.

## Phase 3: User Story 2 — Never modifies the reviewed file (P2)

**Goal**: A request to fix a finding gets declined with the fix named as
a manual follow-up, and the reviewed file stays byte-for-byte unchanged.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: pose "fix that for me" against
  the skill's documented response pattern and confirm it declines, states
  the report-only boundary, and the reviewed file is unchanged.
- [x] T021 [US2] Review `specjedi-skill-review/SKILL.md` against the full
  Skill Authoring Standard checklist in
  `references/skill-authoring-standard.md` before marking this story
  done — dogfooding the standard this skill itself enforces.

**Checkpoint**: both user stories complete — `specjedi-skill-review` is
safe to ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-skill-review`;
  update Quickstart numbering; update `references/skill-roadmap.md`'s
  "Shipped (second wave)" section.
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-skill-review` shipped (feature 011, third second-wave
  addition) — PATCH bump per established pattern for routine second-wave
  shipments.
- [x] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- T021 (standard-checklist self-review) depends on T010
  (`specjedi-skill-review` itself existing) so the dogfood pass is real,
  not forward-referencing content that doesn't exist yet.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.
