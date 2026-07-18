---

description: "Task list for specs/045-sdd-friction-reduction"
---

# Tasks: SDD Friction Reduction — Closing Researched Community Pain Points

**Input**: Design documents from `/specs/045-sdd-friction-reduction/`

**Prerequisites**: plan.md, spec.md, research.md (all present; no
data-model.md/contracts/quickstart.md — see plan.md's Project Structure)

**Tests**: No CI job for this feature (plan.md Testing, research.md's
own precedent from `specjedi-govcheck`/`specjedi-constitution-audit`) —
every touched skill is reasoning-driven. Verification is: real dry-run
scenarios against each enhanced skill (write the scenario, confirm it
fails before the change, confirm it passes after), `scripts/validate.sh`'s
existing structural lint, and a Principle XIX self-check on the five
touched skill files' own sizes.

**Organization**: Tasks are grouped by user story (US1 = P1, US2 = P2,
US3 = P3) per spec.md's priorities. All three stories touch disjoint
skill pairs (US1: `specjedi-analyze` + `specjedi-implement`; US2:
`specjedi-skill-review` + `specjedi-plan`; US3: `specjedi-quick` alone)
— no Foundational phase content is needed since there's no shared
code/contract across them beyond each skill's own existing structure.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, or independent sections
  within the same file)
- **[Story]**: US1, US2, or US3 per spec.md
- File paths are exact, per plan.md's Project Structure and
  Implementation notes

---

## Phase 1: Setup

**Purpose**: Capture a "before" baseline so the Principle XIX self-check
in Polish has something real to compare against.

- [X] T001 Record each touched skill's current size — `wc -c` and
  `wc -l` for `.claude/skills/specjedi-analyze/SKILL.md`,
  `specjedi-implement/SKILL.md`, `specjedi-skill-review/SKILL.md`,
  `specjedi-plan/SKILL.md`, `specjedi-quick/SKILL.md` — before any edits
  in this feature.

---

## Phase 2: Foundational

**Purpose**: N/A for this feature — all three user stories touch
disjoint skill files with no shared code or contract between them (per
plan.md's own Technical Context). Proceeding directly to User Story 1.

---

## Phase 3: User Story 1 - Requirement-to-verification traceability check (Priority: P1) 🎯 MVP

**Goal**: Every FR/Acceptance Scenario in a completed feature's `spec.md`
is classified Verified/Unverified/Not Applicable with named evidence,
self-invoked automatically before every PR-open.

**Independent Test**: Take a completed feature with a deliberately-
introduced gap (one FR with no test and no manual-verification note) and
confirm the enhanced `specjedi-analyze` flags exactly that requirement,
naming it specifically.

### Tests for User Story 1 (write failing first, per Principle IX)

- [X] T002 [P] [US1] Write a dry-run scenario: a requirement with no
  automated test and no manual-verification note anywhere — confirm the
  (not-yet-enhanced) `specjedi-analyze` currently has no way to catch
  this (establishing the "before" gap this feature closes).
- [X] T003 [P] [US1] Write a dry-run scenario: substantial new code/test
  content with no traceable FR/Scenario origin — same "before" gap
  confirmation as T002, for FR-002's reverse-direction check.
- [X] T004 [P] [US1] Write a dry-run scenario: a requirement whose only
  evidence is an explicit manual-verification note in `tasks.md`
  (matching this project's own `specs/042/043` precedent) — confirms the
  Edge Case ("no natural test shape") is handled as Verified, not
  Unverified, once implemented.

### Implementation for User Story 1

- [X] T005 [US1] Implement the evidence-based traceability step in
  `.claude/skills/specjedi-analyze/SKILL.md`, inserted after the existing
  FR-to-task cross-reference step per plan.md's Implementation notes:
  classify each FR/Acceptance Scenario Verified (named passing test, or
  explicit manual-verification note per research.md Decision 2) /
  Unverified (neither found, name what was searched for) / Not
  Applicable (FR-001, FR-003, FR-003a).
- [X] T006 [US1] Implement the orphaned-code/test detection (FR-002,
  research.md Decision 3) in the same skill — flagged only when
  genuinely unexplained, per `specjedi-analyze`'s own existing
  never-fabricate-a-finding guardrail.
- [X] T007 [US1] Run T002-T004 against the updated
  `specjedi-analyze/SKILL.md` and confirm all three now produce the
  correct classification.
- [X] T008 [US1] Add Step 6.6 to
  `.claude/skills/specjedi-implement/SKILL.md`, self-invoking the
  enhanced `specjedi-analyze` immediately after the existing Step 6.5
  `specjedi-govcheck` self-invoke (FR-003a, research.md Decision 1) —
  identical advisory-only posture: surfaces findings prominently, never
  blocks the PR. Depends on T005, T006.
- [X] T009 [US1] Update `specjedi-implement`'s existing Step 8 next-step
  bullet (which currently suggests `specjedi-analyze` as an optional
  post-ship check) to reflect that the pre-PR check is now automatic at
  Step 6.6 — keep the Step 8 suggestion only for its existing
  once-a-slice-is-shipped, post-merge drift-detection use case. Depends
  on T008.

**Checkpoint**: User Story 1 is fully functional and independently
demonstrable — a real PR-opening flow now automatically surfaces
unverified requirements. This is the shippable MVP slice.

---

## Phase 4: User Story 2 - Spec and skill context-budget governance (Priority: P2)

**Goal**: `specjedi-skill-review` measures a skill's own token count
against Principle XIX's budget; `specjedi-plan` compares a new
`spec.md`/`plan.md`'s size against this project's own historical median.

**Independent Test**: Compare a deliberately oversized `spec.md`/
`plan.md` (or an oversized `specjedi-*` `SKILL.md`) against this
project's own historical sizes and confirm the check flags it with a
specific comparison.

### Tests for User Story 2 (write failing first, per Principle IX)

- [X] T010 [P] [US2] Write a dry-run scenario: a skill file padded past
  Principle XIX's 5,000-token hard cap (using the `wc -c ÷ 4`
  approximation) — confirm the current (not-yet-enhanced)
  `specjedi-skill-review` has no mechanism to catch this today.
- [X] T011 [P] [US2] Write a dry-run scenario: a `spec.md`/`plan.md` pair
  more than double this project's real historical median (193 lines,
  computed directly via `wc -l specs/*/spec.md` before this plan was
  written) — same "before" gap confirmation for `specjedi-plan`.

### Implementation for User Story 2

- [X] T012 [US2] Implement the token-budget check in
  `.claude/skills/specjedi-skill-review/SKILL.md` per plan.md's exact
  `wc -c ÷ 4` snippet — report the approximate count and Principle XIX's
  limit explicitly labeled as an approximation; flag only when over the
  5,000-token hard cap, per Clarification Q2 (FR-005, FR-005a, research.md
  Decision 4).
- [X] T013 [US2] Implement the spec/plan size-outlier check in
  `.claude/skills/specjedi-plan/SKILL.md` as a new final step after
  `plan.md` is written, using plan.md's exact `median_lines()` bash
  function (fallback to 400 lines with fewer than 5 prior features) —
  flag as an outlier when more than double the median, with a concrete
  next step (FR-004, FR-006, research.md Decision 5).
- [X] T014 [US2] Run T010-T011 against the updated skills and confirm
  both now produce the correct flagged finding.

**Checkpoint**: User Story 2 is fully functional and independently
demonstrable — both context-budget checks run automatically as part of
each host skill's existing pass, advisory-only.

---

## Phase 5: User Story 3 - Dedicated bug-fix fast path (Priority: P3)

**Goal**: `specjedi-quick` gains a bug-shaped eligibility branch and
`bugfix.md` artifact shape, sharing every quality gate identically with
its existing `quick.md` shape.

**Independent Test**: Submit a genuine bug report and confirm the
resulting artifact captures reproduction/root cause/fix/regression test
— distinct from `specjedi-quick`'s existing concrete-changes shape,
without forcing unrelated feature-planning ceremony.

### Tests for User Story 3 (write failing first, per Principle IX)

- [X] T015 [P] [US3] Write a dry-run scenario: a genuine bug report
  (existing correct behavior now broken) submitted to the current
  (not-yet-enhanced) `specjedi-quick` — confirm it's forced through the
  generic small-feature `quick.md` shape today (establishing the "before"
  gap).
- [X] T016 [P] [US3] Write a dry-run scenario: a request with no prior
  correct behavior to regress to (a genuine new capability) — confirm
  this must be classified feature-shaped, never forced into the bug
  shape once T017 ships (FR-008).

### Implementation for User Story 3

- [X] T017 [US3] Implement the bug-vs-feature eligibility branch in
  `.claude/skills/specjedi-quick/SKILL.md`'s existing Step 1, per
  research.md Decision 6's test ("is there existing, previously-correct
  behavior to regress to?").
- [X] T018 [US3] Implement the `bugfix.md` artifact shape (reproduction
  steps, root cause, the fix, a regression test) as a sibling output to
  the existing `quick.md` shape — every other step (worktree offer,
  test-first implementation, `specjedi-govcheck` self-invoke, PR-only
  delivery) stays identical between both shapes (FR-007, FR-009).
  Depends on T017.
- [X] T019 [US3] Run T015-T016 against the updated `specjedi-quick` and
  confirm both now produce the correct classification and artifact
  shape.

**Checkpoint**: User Story 3 is fully functional and independently
demonstrable — the full feature (all three user stories) is now
complete end-to-end.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Confirm this context-budget feature didn't blow its own
hosts' context budget, and that everything still lints clean.

- [X] T020 [P] Re-measure all five touched `SKILL.md` files' actual size
  (`wc -c`/`wc -l`) against the T001 baseline and against Principle
  XIX's 5,000-token hard cap. If any file now exceeds it, split the new
  addition into a `references/<topic>.md` file per
  `references/skill-authoring-standard.md`'s progressive-disclosure
  guidance, per plan.md's own self-check gate — never ship a
  context-budget feature that itself blows a context budget.
- [X] T021 [P] Run `scripts/validate.sh` and confirm the structural lint
  still passes for all five modified skills.
- [X] T022 Update each modified skill's own Format/Example and
  Verifiable-success-criteria sections (Principle IX/XIX) to document
  the new checks, matching the pattern already established in
  `specjedi-govcheck`/`specjedi-constitution-audit`.
- [X] T023 Add a one-line note to `references/principle-traceability.md`'s
  Principle XIX row noting that `specjedi-skill-review` now automatically
  measures the token budget it already documents, rather than leaving it
  purely aspirational text.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately.
- **Foundational (Phase 2)**: N/A — skipped, no shared code/contract.
- **User Story 1 (Phase 3)**: Depends on Setup (T001's baseline).
  Independently shippable (MVP).
- **User Story 2 (Phase 4)**: Depends on Setup only — no dependency on
  User Story 1.
- **User Story 3 (Phase 5)**: Depends on Setup only — no dependency on
  User Story 1 or 2.
- **Polish (Phase 6)**: Depends on all three user stories being complete
  (T020's re-measurement covers all five files touched across all three
  stories).

### Parallel Opportunities

- T002-T004 (US1 tests), T010-T011 (US2 tests), and T015-T016 (US3
  tests) can all be written in parallel — three entirely independent
  skill pairs.
- Once Setup completes, User Stories 1, 2, and 3 can proceed fully in
  parallel (different skill files, no shared state) if staffed.
- T020 and T021 (Polish) can run in parallel — independent checks.

---

## Parallel Example: All Three User Stories

```bash
# Launch all three stories' independent test-writing tasks together:
Task: "Write dry-run scenarios for specjedi-analyze's traceability gap (T002-T004)"
Task: "Write dry-run scenarios for specjedi-skill-review/specjedi-plan's budget gap (T010-T011)"
Task: "Write dry-run scenarios for specjedi-quick's bug-fix gap (T015-T016)"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 3: User Story 1
3. **STOP and VALIDATE**: Confirm a real PR-opening flow now surfaces an
   unverified requirement automatically
4. This alone closes the single most heavily-corroborated pain point
   found in research (the "missing testing layer") — a real,
   demonstrable increment even before context-budget governance or the
   bug-fix path exist

### Incremental Delivery

1. Setup → baseline captured
2. User Story 1 → validate independently → MVP (traceability gap closed)
3. User Story 2 → validate independently → context-budget governance
   added
4. User Story 3 → validate independently → full feature complete
5. Polish → confirm no skill blew its own context budget, lint clean

### Parallel Team Strategy

With multiple developers: once Setup completes, three people can take
one user story each — they touch entirely disjoint files (Technical
Context above), so there's no merge-conflict risk between them.

---

## Notes

- No CI job, no test framework — verification is real dry-run scenarios
  against each enhanced skill, matching this project's own established
  posture for every reasoning-driven skill
- Every new check stays advisory-only per both Clarification answers —
  none may block a PR or fail a CI run
- Commit after each user story's checkpoint
