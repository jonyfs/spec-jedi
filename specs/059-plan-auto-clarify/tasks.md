# Tasks: specjedi-plan Auto-Invokes specjedi-clarify on NEEDS CLARIFICATION

**Input**: Design documents from `specs/059-plan-auto-clarify/`

**Prerequisites**: plan.md (done), spec.md (done)

**Tests**: Not applicable — this feature edits a `SKILL.md` prose
instruction file, not executable code (Constitution Principle VI, plan.md
Constitution Check row). Verification instead uses the scenario-based dry
run already walked in plan.md, re-confirmed at T005 below.

**Organization**: All three user stories touch the same single file
(`.claude/skills/specjedi-plan/SKILL.md`), at three distinct, non-
overlapping sections within it. No task is marked `[P]` — same-file edits
are sequenced, not parallel, per this project's own `[P]` discipline
(different files required for genuine independence).

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: None required — no new dependency, script, or scaffolding;
the target file and edit sites already exist and were confirmed by direct
read during planning.

*(No tasks — plan.md's Technical Context confirmed zero new
infrastructure is needed.)*

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: None — the three user stories below have no shared
prerequisite beyond the file already existing, which it does.

*(No tasks.)*

---

## Phase 3: User Story 1 - Plan auto-resolves spec-level ambiguity before planning starts (Priority: P1) 🎯 MVP

**Goal**: `specjedi-plan` Step 1 invokes `specjedi-clarify` automatically
when `spec.md` has `NEEDS CLARIFICATION` markers, instead of merely
recommending it, and resumes planning in the same run once resolved.

**Independent Test**: Given a `spec.md` with markers, running
`/specjedi-plan` invokes `specjedi-clarify` automatically before Technical
Context is written; given a `spec.md` with zero markers, `specjedi-clarify`
is never invoked.

- [x] T001 [US1] Rewrite Step 1 in
  `.claude/skills/specjedi-plan/SKILL.md` (currently lines 58-60) to
  automatically invoke `specjedi-clarify` when `NEEDS CLARIFICATION`
  markers are present in `spec.md` at the start of the run, and resume
  planning directly (Technical Context next) once `specjedi-clarify`
  finishes with zero markers remaining — exact replacement text specified
  in plan.md's "Exact edit sites" §1.

**Checkpoint**: Story 1 alone is a complete, demonstrable improvement —
the manual-recommendation friction is gone.

---

## Phase 4: User Story 2 - Bounded resolution: plan reports honestly if markers survive clarification (Priority: P2)

**Goal**: If `specjedi-clarify` (auto-invoked by Story 1) finishes with
markers still unresolved, `specjedi-plan` stops and names them — it never
loops `specjedi-clarify` again automatically in the same run, and never
proceeds to plan against unresolved ambiguity.

**Independent Test**: Given `specjedi-clarify` auto-runs and the user
skips one of its questions, `specjedi-plan` re-checks `spec.md`, finds the
marker still present, and stops — reporting the specific remaining
question, without re-invoking `specjedi-clarify`.

- [x] T002 [US2] Extend Step 1's rewritten text (same location as T001,
  building directly on it — not a separate edit site) in
  `.claude/skills/specjedi-plan/SKILL.md` with the bounded-recheck
  behavior: re-check `spec.md` once `specjedi-clarify` finishes; zero
  remaining markers resumes planning; any marker still present stops the
  run (no `plan.md` written) with the specific question(s) named;
  `specjedi-clarify` is invoked at most once per `specjedi-plan` run —
  exact text specified in plan.md's "Exact edit sites" §1 (same paragraph
  as T001; both land in one edit).
- [x] T003 [US2] Update the two "Never" bullets in the Always/Never
  section of `.claude/skills/specjedi-plan/SKILL.md` (currently line 217)
  to state the bounded-invocation rule and the auto-invocation rule as a
  paired Always/Never per Principle XIX — exact text specified in
  plan.md's "Exact edit sites" §2.

**Checkpoint**: Stories 1+2 together make the automation trustworthy, not
just faster — matching plan.md's own stated rationale for prioritizing
this story second.

---

## Phase 5: User Story 3 - Plan-level (Technical Context) markers are unaffected (Priority: P3)

**Goal**: Confirm and document that a `NEEDS CLARIFICATION` marker
`specjedi-plan` itself writes into `plan.md`'s Technical Context during
Step 3 does not trigger the new auto-invocation — that scope boundary
stays exactly as it is today.

**Independent Test**: Given `specjedi-plan` reaches Step 3 and marks a
Technical Context field `NEEDS CLARIFICATION`, `specjedi-clarify` is never
invoked for that marker.

- [x] T004 [US3] Add the scope-boundary sentence to Step 1's rewritten
  text in `.claude/skills/specjedi-plan/SKILL.md` (same edit as T001/T002
  — the final sentence of the rewritten Step 1 paragraph) stating that
  this check is scoped to markers already in `spec.md` at the start of
  the run, and does not apply to a marker Step 3 later writes into
  `plan.md`'s own Technical Context — exact text specified in plan.md's
  "Exact edit sites" §1. Also add the corresponding third "Never" bullet
  to the Always/Never section (plan.md "Exact edit sites" §2, third
  bullet).

**Checkpoint**: All three stories complete — the scope boundary is
explicit, preventing a plausible-but-wrong future extension of this
feature.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Documentation consistency, dry-run verification, and landing
the change per this project's own Trunk-Based workflow (Principle X).

- [x] T005 [P] Update the Validation Coverage → Out-of-Bounds/Malformed
  Input Handling bullet in `.claude/skills/specjedi-plan/SKILL.md`
  (currently lines 249-253) to describe the new automatic-invocation-then-
  bounded-recheck behavior instead of the old "stop and recommend" text —
  exact text specified in plan.md's "Exact edit sites" §3. Marked `[P]`:
  a distinct section of the file from T001-T004's Step 1/Always-Never
  edits, genuinely independent.
- [x] T006 Re-walk the four scenario-based dry-run cases plan.md already
  worked through by hand against the actual edited file text (not the
  planned text) — confirm all four still hold true post-edit.
- [x] T007 Confirm `.claude/skills/specjedi-plan/SKILL.md`'s frontmatter
  (`name: specjedi-plan`) still matches its directory name, and the file
  still parses as valid Markdown with YAML frontmatter — the same
  structural-lint check this session's CI already runs on every
  `specjedi-*` skill (Principle IX battery item (a)).
- [x] T008 Confirm no other file in the repository references the
  now-stale "stop and recommend `specjedi-clarify`" wording — re-run the
  same `grep -rl` check plan.md's Technical Context already performed,
  confirming it still returns exactly one match (the file just edited).
- [ ] T009 Commit the three-file change set (`specs/059-plan-auto-
  clarify/spec.md`, `plan.md`, `tasks.md`, and
  `.claude/skills/specjedi-plan/SKILL.md`, plus `CLAUDE.md`'s already-
  updated plan pointer) on the `059-plan-auto-clarify` branch and open a
  PR against `main` (Constitution Principle X) — never commit directly to
  `main`.
- [ ] T010 Self-invoke `specjedi-govcheck` against the PR's diff before
  considering the PR complete (matching this session's own established
  practice for the caveman-mode-skill PR) — surface any finding, never
  block PR opening on it (CI `ci-gate` remains the actual merge gate).

**Checkpoint**: Feature complete, PR open, CI running.

---

## Dependencies & Execution Order

- **Phase 1 (Setup)** → none, empty.
- **Phase 2 (Foundational)** → none, empty.
- **Phase 3 (US1, T001)** blocks **Phase 4 (US2, T002-T003)**: T002 extends
  the exact same Step 1 paragraph T001 creates — T002 cannot be written
  against text that doesn't exist yet.
- **Phase 4 (T002-T003)** blocks **Phase 5 (US3, T004)**: T004 adds the
  final sentence to the same paragraph T001/T002 build, and a third bullet
  to the Always/Never section T003 already edited.
- **T001 → T002 → T004** are, in practice, three additions to *one*
  continuous paragraph — implemented as a single edit in execution, but
  kept as separate task IDs here because each maps to a distinct user
  story with its own independent test, per this skill's own "group by
  user story" discipline even when the underlying file edit is one
  contiguous block.
- **Phase 6 (Polish)** depends on **Phases 3-5** being complete: T005
  (Validation Coverage) documents behavior T001/T002/T004 just
  implemented; T006-T008 verify the finished file; T009-T010 land it.
- **T005** is the only `[P]` task — a different section of the same file,
  genuinely independent of T001-T004's Step 1/Always-Never edits.

## Implementation Strategy

### MVP First (User Story 1 Only)

T001 alone already delivers the core value (auto-invocation replaces
manual recommendation) and is independently demonstrable — but per plan.md
and spec.md's own reasoning, Story 2's bounded-recheck (T002-T003) is what
keeps that automation trustworthy rather than a foot-gun, so this feature
ships all three stories together in one PR rather than an MVP-then-follow-
up split. The stories remain independently *testable* (each has its own
acceptance scenarios), even though execution lands them as one contiguous
text edit.

### Incremental Delivery

Given the single-file, single-contiguous-edit nature of this change
(confirmed in Dependencies above), incremental *delivery* (separate PRs
per story) is not warranted here — it would fragment one coherent
paragraph across three PRs for no independent-deployability benefit, the
opposite of what incremental delivery is for. One PR, sequenced tasks.
