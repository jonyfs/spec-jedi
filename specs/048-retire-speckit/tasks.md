---

description: "Task list for retiring speckit-* bootstrap tooling"
---

# Tasks: Retire `speckit-*` Bootstrap Tooling

**Input**: Design documents from `/specs/048-retire-speckit/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md

**Tests**: Not applicable — this is a removal-and-documentation feature (no code, no automated test suite); verification is `scripts/validate.sh` plus direct `git diff`/grep checks described in plan.md's Testing section.

**Organization**: Tasks are grouped by user story. User Story 1 MUST
fully complete before User Story 2 begins — deleting
`speckit-agent-context-update` while its hooks are still registered
would leave a dangling reference every `specjedi-*` pipeline skill's
own hook-dispatch check (specs/047) would try to surface.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

## Path Conventions

Single repository. Paths are repo-root-relative.

---

## Phase 1: Setup

**Purpose**: Capture the pre-removal baseline needed to prove FR-009/SC-005 (zero historical file touched) once this feature ships.

- [x] T001 Capture the pre-removal baseline: list all 11 `.claude/skills/speckit-*/` directory names, the current full content of `.specify/extensions.yml`, and the current constitution version (1.27.0), saved to `specs/048-retire-speckit/baseline-facts.md` (scratch reference for T015, not a shipped doc)

---

## Phase 2: User Story 1 - Stop relying on a `speckit-*` skill for the agent-context hook (Priority: P1) 🎯 MVP

**Goal**: Retire the two hooks currently dispatching to `speckit-agent-context-update`, and close the gap that retirement would otherwise leave (no documented way to keep `CLAUDE.md`'s plan pointer current).

**Independent Test**: After this phase, run any core `specjedi-*` pipeline skill for the `specify`/`plan` stages and confirm no `## Extension Hooks` block appears — because nothing is registered, not because the check silently failed.

### Implementation for User Story 1

- [x] T002 [US1] Confirmed the entire `.specify/extensions.yml` existed only to support the two `after_specify`/`after_plan` hooks (`installed:`/`settings:` had no other purpose) — deleted the file entirely rather than leaving an orphaned `installed: agent-context` declaration with zero hooks referencing it (depends on T001)
- [x] T003 [US1] Added a native "update `CLAUDE.md`'s plan-reference pointer" step (5.7) to `.claude/skills/specjedi-plan/SKILL.md`'s Step-by-step, right after the (now-inert) after-hook check step and before the final report step — mirrors `speckit-plan`'s own Phase 1 step 4, closing the gap the retired hook left (Acceptance Scenario 3, FR-011) (depends on T002)
- [x] T004 [US1] Verified: `.specify/extensions.yml` no longer exists — every `specjedi-*` pipeline skill's Pre-flight hook check ("skip silently if the file is missing") correctly finds nothing registered for any stage (Acceptance Scenarios 1-2) (depends on T002)

**Checkpoint**: The hook dependency on `speckit-*` is fully retired and its gap is closed — User Story 2 can now safely delete `speckit-*` files.

---

## Phase 3: User Story 2 - Remove the vendored `speckit-*` skills (Priority: P1)

**Goal**: Delete all 11 vendored `speckit-*` skill directories.

**Independent Test**: `.claude/skills/` contains zero `speckit-*` directories, and `scripts/validate.sh` still passes.

### Implementation for User Story 2

- [x] T005 [US2] Deleted all 11 `.claude/skills/speckit-*/` directories (`speckit-agent-context-update`, `speckit-analyze`, `speckit-checklist`, `speckit-clarify`, `speckit-constitution`, `speckit-converge`, `speckit-implement`, `speckit-plan`, `speckit-specify`, `speckit-tasks`, `speckit-taskstoissues`) — confirmed `ls .claude/skills/ | grep speckit- | wc -l` returns 0 (depends on T004 — User Story 1 checkpoint reached)
- [x] T006 [US2] Confirmed `scripts/install.sh`/`.ps1`/`package-release.sh`/`.ps1`/`bootstrap-install.sh`/`.ps1` reference zero `speckit-*` skills — the only matches are comment lines explicitly stating "never speckit-* bootstrap tooling," no actual script logic ever touched them (depends on T005)
- [x] T007 [US2] Ran `scripts/validate.sh`/`.ps1`: PASSED, no new failure caused by the removal (pre-existing i18n WARN unrelated) (Acceptance Scenario 3) (depends on T005)

**Checkpoint**: All vendored `speckit-*` tooling is removed from the repository; the project's own skill set is now `specjedi-*` only.

---

## Phase 4: User Story 3 - Documentation stops describing a workflow that no longer exists (Priority: P2)

**Goal**: Correct every current/forward-looking document that described `speckit-*` as this project's live internal-development mechanism, without touching any historical record.

**Independent Test**: Grep the whole repository for `/speckit-` command references in prose (excluding `specs/001-*` through `specs/047-*` and past CHANGELOG entries); confirm every remaining hit is either gone or explicitly historical.

### Implementation for User Story 3

- [x] T008 [US3] Self-invoked `specjedi-migrate` against `.specify/memory/constitution.md`: rewrote 6 live references (2 in Development Workflow lines 1953-1954, 2 in Governance lines 2025/2037) to their `/specjedi-*` equivalents; confirmed all 17 remaining `speckit-` mentions are either historical Sync Impact Report entries (13, citing specific past features/PRs) or Principle XV's own descriptive prose (4, out of this skill's literal-command scope, handled next in T009) — zero historical entries touched (research.md Decision 1) (depends on T007)
- [x] T009 [US3] Self-invoked `specjedi-constitution` to amend Principle XV: rewrote the prose to state the bootstrap phase is complete (feature 048) rather than ongoing, generalized the rule to "any vendored bootstrap tooling" (not `speckit-*` specifically, so it still applies if this ever recurs), added a Sync Impact Report entry (v1.27.0 → v1.27.1, PATCH), bumped the version line. Also updated 3 dependent templates (`plan-template.md`, `checklist-template.md`, `tasks-template.md`) whose own comments still said `/speckit-plan`/`/speckit-checklist`/`/speckit-tasks` — required by the Governance section's own amendment procedure, discovered while amending (research.md Decision 2) (depends on T008)
- [x] T010 [US3] Updated `README.md`'s "How Spec Jedi builds itself, in comic form" section: replaced all 8 `/speckit-*` command mentions with their `/specjedi-*` equivalents (research.md Decision 3); also rewrote the disclaimer box, since "this is internal bootstrap, not the product" would have directly contradicted panels now showing the actual `specjedi-*` product commands — it now states the migration is complete, citing feature 048; illustrated panels, epigraph, and PR citations otherwise unchanged (depends on T009)
- [x] T011 [US3] Updated `CONTRIBUTING.md`'s "Voice and naming" section: corrected the claim that `speckit-*` is tooling "this repo uses to build itself" — now states the bootstrap phase ended with feature 048, this repo's own development runs entirely on `specjedi-*` (depends on T010)
- [x] T012 [US3] Updated `references/principle-traceability.md`'s Principle II row (a live `speckit-plan` reference found while auditing), Principle XV row, and Development Workflow row — all now reflect the completed migration, citing feature 048 (depends on T011)
- [x] T013 [US3] Updated `specs/044-speckit-parity-audit/PARITY-LEDGER.md`: fixed one more live reference (`/speckit-specify` → `/specjedi-specify` in the Resolution section) and added a new "Migration Executed" section documenting what feature 048 actually did, citing it — original Recommendation/Resolution sections left untouched as historical record (depends on T012)
- [x] T014 [US3] Added a new entry under `CHANGELOG.md`'s `## Unreleased` section (a new `### Removed` subsection) describing this feature's changes (depends on T013)

**Checkpoint**: All three user stories are complete — the hook dependency is retired, `speckit-*` is removed, and documentation accurately reflects both.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Whole-feature verification spanning all three user stories.

- [x] T015 Ran `git diff --stat` against `main`: 29 files changed, all either the 11 deleted `speckit-*` skills, the deleted `extensions.yml`, the constitution + 3 dependent templates, the 5 named US3 docs (README/CONTRIBUTING/traceability/PARITY-LEDGER/CHANGELOG), routine pointer files (`CLAUDE.md`/`feature.json`), `specjedi-plan`'s new step, or the 5 additional legitimate fixes found in T016 — zero historical file touched (FR-009, SC-005) (depends on T014)
- [x] T016 Grepped the whole repository for `speckit-`, excluding `specs/` (all historical or this feature's own) and `docs/i18n/` (out of scope, synced on its own whole-project cadence per Principle I): found and fixed 5 more live references beyond the original plan.md scope — `references/star-wars-lexicon.md` (4 dead-command voice-guidance mentions), `references/competitive-comparison.md` (present-tense "bootstraps itself with" claim), `.github/ISSUE_TEMPLATE/bug-report.md` (a bug-category checkbox for a skill class that no longer exists), and `.specify/scripts/bash/check-prerequisites.sh`/`setup-tasks.sh` (user-facing error messages telling a user to run a now-nonexistent `/speckit-*` command — a real functional bug, since these scripts are actively invoked by `specjedi-*` skills). Remaining hits confirmed legitimate: historical/provenance notes, `specjedi-migrate`'s own designed capability to help other projects still on `speckit-*`, CI leak-guard tests, and vendored third-party extension content (depends on T014)
- [x] T017 Final `scripts/validate.sh`/`.ps1` re-run after all edits: PASSED — the only WARNs are the pre-existing (non-blocking, by-design per Principle I) localized-docs-sync notices, now also flagging CONTRIBUTING.md's translations, expected since it was edited too (depends on T015, T016)

**Checkpoint**: All success criteria (SC-001 through SC-006) are verified against the shipped state.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately.
- **User Story 1 (Phase 2)**: Depends on Setup — BLOCKS User Story 2 (the hook dependency must be retired before any `speckit-*` file is deleted).
- **User Story 2 (Phase 3)**: Depends on User Story 1's checkpoint.
- **User Story 3 (Phase 4)**: Depends on User Story 2's checkpoint — documentation can't truthfully describe a removal that hasn't happened yet.
- **Polish (Phase 5)**: Depends on all three user stories being complete.

### Parallel Opportunities

Minimal — this feature is a strict, ordered sequence by design (hooks
retired → files deleted → docs corrected), unlike specs/047's mostly-
parallel skill edits. T006/T007 (both verification, no file writes)
could run together; nearly everything else is sequential because each
step depends on the previous one's completed state.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: User Story 1 (hooks retired, gap closed)
3. **STOP and VALIDATE**: Confirm T004's verification passes
4. Continue to User Story 2 once validated

### Incremental Delivery

1. Complete Setup → baseline captured
2. Add User Story 1 → validate independently (hook dependency gone, gap closed)
3. Add User Story 2 → validate independently (`speckit-*` files gone, `validate.sh` passes)
4. Add User Story 3 → validate independently (documentation accurate)
5. Complete Polish phase → all Success Criteria verified

## Notes

- [Story] label maps task to specific user story for traceability.
- This feature is intentionally sequential, not parallel — each user story's checkpoint is a real precondition for the next, not just an organizational convenience.
- Commit after each user story phase, matching this project's own trunk-based workflow (Constitution Principle X) — the PR opens once all phases are complete.
- Historical artifacts (`specs/001-*` through `specs/047-*`, existing CHANGELOG entries) are explicitly out of scope for every task above — none of them touch those files.
