---

description: "Task list for extending the 9 core specjedi-* pipeline skills with extensions.yml hook dispatch"
---

# Tasks: `specjedi-*` Pipeline Hook Dispatch

**Input**: Design documents from `/specs/047-specjedi-hook-dispatch/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md

**Tests**: Not applicable — every touched skill is reasoning-driven (no code, no automated test suite); verification is the real dry-run against this project's own live registered hooks described in plan.md's Testing section.

**Organization**: Tasks are grouped by user story. Unlike specs/046
(one shared file), each of the 9 target skills is its own separate
`SKILL.md` file, so most implementation tasks genuinely are
parallelizable against each other.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)

## Path Conventions

Single repository. All paths are repo-root-relative, under `.claude/skills/`.

---

## Phase 1: Setup

**Purpose**: Re-confirm the pre-edit token baseline immediately before editing, since plan.md's baseline was captured slightly earlier in this same session.

- [x] T001 Re-run `wc -c` against all 9 target `SKILL.md` files, confirm each still matches plan.md's captured baseline table (no drift since the plan was written) — confirmed identical: 7648/8733/7418/9928/6826/11417/10561/7358/7388

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Nail down the exact canonical hook-check reference text before any of the 9 skills are edited — every implementation task depends on copying this exactly, per FR-003's parity requirement.

**⚠️ CRITICAL**: No skill edit in Phase 3+ may begin until this reference text is confirmed.

- [x] T002 Re-read `speckit-specify/SKILL.md`'s "Pre-Execution Checks" and "Mandatory Post-Execution Hooks" sections and `speckit-plan/SKILL.md`'s equivalent sections in full, confirming the exact rule set to adapt into all 9 `specjedi-*` skills (missing/malformed-YAML handling, `enabled: false` filtering, non-empty-`condition` skipping, optional-vs-mandatory dispatch output format) — this is the single source of truth research.md Decision 1 references

**Checkpoint**: Reference text confirmed — skill edits can now begin.

---

## Phase 3: User Story 1 - Registered hooks keep firing regardless of which pipeline implementation runs (Priority: P1) 🎯 MVP

**Goal**: Prove the mechanism works end-to-end against this project's own two real, currently-registered hooks before rolling it out to every skill.

**Independent Test**: With `after_specify`/`after_plan` hooks already registered in this project's own `.specify/extensions.yml`, confirm `specjedi-specify`/`specjedi-plan` detect and surface them exactly as `speckit-specify`/`speckit-plan` would.

### Implementation for User Story 1

- [x] T003 [P] [US1] Added `before_specify`/`after_specify` hook-check to `.claude/skills/specjedi-specify/SKILL.md`: new "## Pre-flight hook check" section before "## Steps", and a new decimal Step 6.5 before the existing Step 7 next-step offer (depends on T001, T002)
- [x] T004 [P] [US1] Added `before_plan`/`after_plan` hook-check to `.claude/skills/specjedi-plan/SKILL.md`: new "## Pre-flight hook check" section before "## Step-by-step", and a new decimal Step 5.6 (fitting alongside the existing Step 5.5) before the existing Step 6 report/next-step offer (depends on T001, T002)
- [x] T005 [US1] Real dry-run against this project's own actual `.specify/extensions.yml`: both `after_specify` and `after_plan` have one registered hook each (`agent-context`, `enabled: true`, `optional: true`, `condition: null`) — confirmed both would surface the identical "## Extension Hooks" optional-hook block `speckit-specify`/`speckit-plan` themselves already produced when run for this exact feature earlier in this session (Acceptance Scenarios 1-2 satisfied) (depends on T003, T004)
- [x] T006 [US1] Confirmed `before_specify`/`before_plan` have no registered entries in `.specify/extensions.yml` today — the new Pre-flight hook check step stays silent for both skills, zero visible output change (Acceptance Scenario 3 satisfied) (depends on T003)

**Checkpoint**: User Story 1 is independently testable and proven — the mechanism works end-to-end against this project's own real hooks.

---

## Phase 4: User Story 2 - Confirm every pipeline stage is covered, not just some (Priority: P2)

**Goal**: Roll the proven mechanism out to the remaining 7 core pipeline skills and confirm full 9-of-9 coverage.

**Independent Test**: Grep all 9 core `specjedi-*` pipeline skills for hook-dispatch language; confirm none were skipped.

### Implementation for User Story 2

- [x] T007 [P] [US2] Added `before_constitution`/`after_constitution` hook-check to `.claude/skills/specjedi-constitution/SKILL.md` (new "Pre-flight hook check" section + decimal Step 5.5) (depends on T001, T002)
- [x] T008 [P] [US2] Added `before_clarify`/`after_clarify` hook-check to `.claude/skills/specjedi-clarify/SKILL.md` (new section + decimal Step 5.5) (depends on T001, T002)
- [x] T009 [P] [US2] Added `before_tasks`/`after_tasks` hook-check to `.claude/skills/specjedi-tasks/SKILL.md` (new section + decimal Step 6.5) (depends on T001, T002)
- [x] T010 [P] [US2] Added `before_implement`/`after_implement` hook-check to `.claude/skills/specjedi-implement/SKILL.md` (new section placed before Step 1's branch check + decimal Step 7.6) (depends on T001, T002)
- [x] T011 [P] [US2] Added `before_analyze`/`after_analyze` hook-check to `.claude/skills/specjedi-analyze/SKILL.md` (new section + decimal Step 5.5) (depends on T001, T002)
- [x] T012 [P] [US2] Added `before_checklist`/`after_checklist` hook-check to `.claude/skills/specjedi-checklist/SKILL.md` (new section + decimal Step 7.5) (depends on T001, T002)
- [x] T013 [P] [US2] Added `before_converge`/`after_converge` hook-check to `.claude/skills/specjedi-converge/SKILL.md` (new section + decimal Step 4.5) (depends on T001, T002)
- [x] T014 [US2] Grepped all 9 target `SKILL.md` files for "Pre-flight hook check" + their own `hooks.before_<stage>`/`hooks.after_<stage>` key — all 9 confirmed present, matching `speckit-*`'s own 9-of-9 coverage (SC-001, Acceptance Scenario 1) (depends on T003, T004, T007-T013)
- [x] T015 [US2] Updated `specs/044-speckit-parity-audit/PARITY-LEDGER.md`: Recommendation section now points to an updated status note, and item 3 in the Resolution section marks the `extensions.yml` hook-dispatch gap resolved, citing this feature and its T005 dry-run (SC-004) (depends on T014)

**Checkpoint**: All 9 core pipeline skills implement hook dispatch — full parity with `speckit-*` on this dimension is achieved.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Whole-feature verification spanning both user stories.

- [x] T016 Ran `wc -c` against all 9 modified `SKILL.md` files: constitution 8,715 (~2,178 tok), specify 9,781 (~2,445), clarify 8,455 (~2,113), plan 10,953 (~2,738), tasks 7,857 (~1,964), implement 12,560 (~3,140), analyze 11,598 (~2,899), checklist 8,401 (~2,100), converge 8,428 (~2,107) — all comfortably under the 5,000-token hard cap (Constitution Principle XIX) (depends on T014)
- [x] T017 Reviewed all 9 diffs via `git diff --stat`: every file shows insertions only, zero deletions — no existing Persona/Task/Step-by-step reasoning content was altered beyond the two new hook-check additions (FR-005 — purely additive, confirmed) (depends on T014)
- [x] T018 Ran `scripts/validate.sh`: PASSED, zero new warnings for any of the 9 modified skills (the pre-existing localized-docs-sync WARN is unrelated, triggered by feature 046's earlier README.md change) (depends on T017)

**Checkpoint**: All success criteria (SC-001 through SC-004) are verified against the shipped skills.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all skill edits (the exact reference text must be confirmed first).
- **User Story 1 (Phase 3)**: Depends on Foundational. Delivers and proves the MVP (2 skills, real dry-run against live hooks).
- **User Story 2 (Phase 4)**: Depends on Foundational; T007-T013 do not depend on Phase 3's completion (different files), but are sequenced after US1 in this list since US1 is the priority MVP that should be proven first.
- **Polish (Phase 5)**: Depends on all 9 skills being edited (Phase 3 + Phase 4).

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) — no dependency on US2.
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) in parallel with US1 if desired (different files) — sequenced after US1 here so the mechanism is proven against real hooks before being rolled out unverified to 7 more skills.

### Parallel Opportunities

- T003 and T004 (US1) touch different files — parallelizable.
- T007 through T013 (US2, 7 different skills) all touch different files — fully parallelizable against each other and against T003/T004.
- T005, T006, T014, T015 are verification/integration tasks that depend on the preceding edits and are not parallelizable with them.

---

## Parallel Example: User Story 2

```bash
# All 7 remaining skill edits can run together — different files, no shared state:
Task: "Add before_constitution/after_constitution hook-check steps to .claude/skills/specjedi-constitution/SKILL.md"
Task: "Add before_clarify/after_clarify hook-check steps to .claude/skills/specjedi-clarify/SKILL.md"
Task: "Add before_tasks/after_tasks hook-check steps to .claude/skills/specjedi-tasks/SKILL.md"
Task: "Add before_implement/after_implement hook-check steps to .claude/skills/specjedi-implement/SKILL.md"
Task: "Add before_analyze/after_analyze hook-check steps to .claude/skills/specjedi-analyze/SKILL.md"
Task: "Add before_checklist/after_checklist hook-check steps to .claude/skills/specjedi-checklist/SKILL.md"
Task: "Add before_converge/after_converge hook-check steps to .claude/skills/specjedi-converge/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (confirm the exact reference text)
3. Complete Phase 3: User Story 1 (2 skills, proven against real live hooks)
4. **STOP and VALIDATE**: Confirm the dry-run (T005) shows both real hooks firing correctly
5. Continue to User Story 2 once validated

### Incremental Delivery

1. Complete Setup + Foundational → reference text locked in
2. Add User Story 1 → validate independently (MVP: mechanism proven against real hooks)
3. Add User Story 2 → validate independently (full 9/9 coverage confirmed)
4. Complete Polish phase → all Success Criteria verified, `PARITY-LEDGER.md` updated

## Notes

- [Story] label maps task to specific user story for traceability.
- Unlike specs/046, most tasks here genuinely are parallelizable ([P]) — each skill is its own file.
- Commit after each user story phase, matching this project's own trunk-based workflow (Constitution Principle X) — the PR opens once all phases are complete.
