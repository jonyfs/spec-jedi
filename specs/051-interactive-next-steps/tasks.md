---

description: "Task list for specs/051-interactive-next-steps"
---

# Tasks: Interactive Next-Step Selection for `specjedi-*` Skills

**Input**: Design documents from `/specs/051-interactive-next-steps/`

**Prerequisites**: plan.md, spec.md (clarified, zero markers remaining)

**Tests**: No CI job — reasoning-driven content change. Verification is
`scripts/validate.sh` plus a manual cross-discipline spot-check.

**Organization**: Tasks grouped by user story (US1 = P1, US2 = P2) per
spec.md's priorities.

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Foundational

- [x] T001 Write `references/next-step-interaction.md`: the
  interactive-when-available/plain-list-fallback mechanism, the
  always-present "something else" escape hatch (FR-003), and the
  harness-agnostic framing (FR-005) — grounded in Constitution
  Principle III/XX.

**Checkpoint**: The reference doc exists; both user stories can proceed.

---

## Phase 2: User Story 1 - Pick the next step without typing (P1) 🎯 MVP

- [x] T002 [US1] Amend Constitution Principle XIV: add one paragraph
  citing `references/next-step-interaction.md`, preserving existing text
  unchanged. Sync Impact Report, MINOR version bump.
- [x] T003 [US1] Update `specjedi-specify`'s own Principle XIV citation
  line with the added clause (Core Pipeline discipline sample).
- [x] T004 [US1] Update `specjedi-plan`, `specjedi-tasks`,
  `specjedi-implement`, `specjedi-analyze`, `specjedi-checklist`,
  `specjedi-converge`, `specjedi-clarify` (its own Next-Step moment only,
  never its question-format, per FR-006) — remaining Core Pipeline
  skills.

**Checkpoint**: Core Pipeline skills demonstrate the convention —
independently testable per spec.md's own Acceptance Scenarios.

---

## Phase 3: User Story 2 - Consistent across the whole catalog (P2)

- [x] T005 [P] [US2] Update Onboarding & Guidance skills:
  `specjedi-onboard`, `specjedi-explain`, `specjedi-find-skills`,
  `specjedi-master`.
- [x] T006 [P] [US2] Update Quality & Review skills: `specjedi-security`,
  `specjedi-skill-review`, `specjedi-govcheck`, `specjedi-retro`,
  `specjedi-constitution-audit`, `specjedi-catalog-audit`.
- [x] T007 [P] [US2] Update Meta & Tooling skills:
  `specjedi-diagram`, `specjedi-status`, `specjedi-docs`,
  `specjedi-migrate`, `specjedi-new-skill`, `specjedi-release`,
  `specjedi-tokencheck`, `specjedi-worktree`, `specjedi-constitution`.
  **Finding, out of scope**: `specjedi-quick` has no Principle XIV
  next-step instruction at all today — a separate, pre-existing
  compliance gap discovered incidentally, not this feature's to fix
  (this feature updates existing citations, it doesn't add missing
  ones). Flagged in the PR description as a follow-up candidate.
- [x] T008 Confirm `scripts/validate.sh` passes.
- [x] T009 Spot-check one skill per discipline
  (`specjedi-specify`/`specjedi-onboard`/`specjedi-skill-review`/
  `specjedi-status`) for the added clause's presence and wording,
  satisfying User Story 2's own Independent Test.

**Checkpoint**: All 28 skills carry the same convention.

---

## Dependencies & Execution Order

- Phase 1 blocks Phase 2 and Phase 3 (the reference doc must exist
  before any skill points to it).
- Phase 2 (US1, MVP) can ship independently once T001-T004 land.
- Phase 3's T005-T007 are `[P]` — different files, no shared state.

## Notes

- No `[P]` on T003/T004 (Core Pipeline) since T002's constitution
  amendment is a shared prerequisite reasoning point, kept sequential
  for clarity; T005-T007 (Phase 3) are safely parallel.
- Commit after each phase checkpoint.
