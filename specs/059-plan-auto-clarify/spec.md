# Feature Specification: specjedi-plan Auto-Invokes specjedi-clarify on NEEDS CLARIFICATION

**Feature Branch**: `059-plan-auto-clarify`

**Created**: 2026-07-19

**Status**: Draft

**Input**: User description: "ajuste /specjedi-plan para executar automaticamente /specjedi-clarify quando marcadores NEEDS CLARIFICATION acontecerem"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Plan auto-resolves spec-level ambiguity before planning starts (Priority: P1)

A user runs `/specjedi-plan` against a `spec.md` that still carries one or
more `NEEDS CLARIFICATION` markers — left over from `specjedi-specify`, or
because the user skipped running `specjedi-clarify` manually. Today,
`specjedi-plan` Step 1 stops and merely *recommends* running
`specjedi-clarify` as a next step, requiring the user to type a second
command. This story makes `specjedi-plan` invoke `specjedi-clarify`
directly instead, mirroring the proactive self-invocation pattern
`specjedi-clarify` itself already documents for its trigger straight out of
`specjedi-specify`.

**Why this priority**: This is the entire feature — removing one manual
step (typing `/specjedi-clarify` after being told to) from the SDD
pipeline's most common friction point. Without this story there is no
feature.

**Independent Test**: Given a `spec.md` with at least one `NEEDS
CLARIFICATION` marker, when `/specjedi-plan` is run against it, then
`specjedi-clarify` runs automatically (asking its own up-to-5 targeted
questions) before any `plan.md` content is written — without the user
having to separately invoke `specjedi-clarify` themselves.

**Acceptance Scenarios**:

1. **Given** a `spec.md` with two `NEEDS CLARIFICATION` markers, **When**
   `/specjedi-plan` is run, **Then** `specjedi-clarify` is invoked
   automatically before Technical Context is written, asking the user
   targeted questions about the two markers.
2. **Given** a `spec.md` with zero `NEEDS CLARIFICATION` markers, **When**
   `/specjedi-plan` is run, **Then** `specjedi-clarify` is never invoked —
   planning proceeds directly as it does today.
3. **Given** `specjedi-clarify` runs (triggered by Story 1) and the user
   answers every question it asks, **When** `specjedi-clarify` finishes and
   `spec.md` now has zero remaining `NEEDS CLARIFICATION` markers, **Then**
   `specjedi-plan` resumes automatically and proceeds through Technical
   Context and the Constitution Check without requiring a second,
   separate invocation of `/specjedi-plan`.

---

### User Story 2 - Bounded resolution: plan reports honestly if markers survive clarification (Priority: P2)

`specjedi-clarify` asks at most 5 questions per run and a user can
explicitly skip a question. This story defines what `specjedi-plan` does
when, after auto-invoking `specjedi-clarify` once, `spec.md` still has one
or more unresolved `NEEDS CLARIFICATION` markers.

**Why this priority**: Without this story, Story 1's auto-invocation could
either loop `specjedi-clarify` indefinitely (never reaching a plan) or
silently proceed to plan against markers that are still there — both are
worse than today's honest "stop and recommend" behavior. This story is
what keeps the automation trustworthy rather than just faster.

**Independent Test**: Given `specjedi-clarify` was auto-invoked once by
`specjedi-plan` and finishes with at least one `NEEDS CLARIFICATION`
marker still unresolved in `spec.md`, when `specjedi-plan` re-checks the
spec, then it stops (does not write `plan.md`) and reports exactly which
marker(s) remain — without invoking `specjedi-clarify` a second time in
the same run.

**Acceptance Scenarios**:

1. **Given** `specjedi-clarify` auto-runs and the user explicitly skips one
   of its questions, **When** it finishes, **Then** `specjedi-plan` checks
   `spec.md` again, finds the skipped marker still present, and stops —
   reporting the specific unresolved marker rather than proceeding or
   re-invoking `specjedi-clarify` automatically a second time.
2. **Given** `specjedi-clarify` auto-runs and resolves every marker it
   found, **When** it finishes, **Then** `specjedi-plan` re-checks
   `spec.md`, finds zero remaining markers, and proceeds to Technical
   Context without stopping.

---

### User Story 3 - Plan-level (Technical Context) markers are unaffected (Priority: P3)

`specjedi-plan` Step 3 can itself mark a Technical Context field (e.g.
storage choice, target platform) `NEEDS CLARIFICATION` when it's genuinely
undeterminable from the codebase — this is separate from spec-level
requirement ambiguity, and `specjedi-clarify` is scoped to `spec.md`'s
requirements, not `plan.md`'s technical fields. This story confirms that
scope boundary stays intact: only pre-existing `spec.md` markers (checked
at Step 1, before Technical Context is written) trigger the new
auto-invocation — a marker `specjedi-plan` itself writes into
`plan.md`'s Technical Context during Step 3 does not.

**Why this priority**: Lowest priority because it's a boundary
clarification, not new behavior — it prevents a plausible but wrong
extension of Story 1 (routing every `NEEDS CLARIFICATION` marker anywhere
in the pipeline to `specjedi-clarify`, including ones it was never
designed to resolve).

**Independent Test**: Given `specjedi-plan` reaches Step 3 and marks a
Technical Context field `NEEDS CLARIFICATION` because it's genuinely
undeterminable from the codebase, when that happens, then `specjedi-clarify`
is not invoked for that marker — the plan proceeds with the field marked,
exactly as `specjedi-plan` behaves today for Technical Context gaps.

**Acceptance Scenarios**:

1. **Given** a `spec.md` with zero markers (Story 1 doesn't trigger),
   **When** `specjedi-plan` reaches Step 3 and cannot determine the
   storage layer from the codebase, **Then** it marks that Technical
   Context field `NEEDS CLARIFICATION` and continues — `specjedi-clarify`
   is never invoked for this plan-level marker.

---

### Edge Cases

- What happens when `specjedi-clarify` itself has nothing to ask (e.g.,
  the markers it scans turn out to already be answerable from context it
  finds)? `specjedi-clarify`'s own existing behavior governs this — it may
  resolve markers without asking, or ask fewer than 5 questions;
  `specjedi-plan`'s re-check (Story 2) still runs regardless of how many
  questions were actually asked.
- What happens when `spec.md` does not exist yet, or the target feature
  has no `spec.md` at all (an ad hoc plan-only flow)? Out of scope — this
  feature only changes behavior when a `spec.md` with markers is the
  planning input, which is `specjedi-plan`'s existing precondition.
- What happens if the user explicitly asked to skip clarification (e.g.,
  ran `/specjedi-plan --skip-clarify` or an equivalent explicit override)?
  No such flag exists in either skill today — out of scope for this
  feature; if a future skill revision adds one, it would need its own spec.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-plan` Step 1 MUST invoke `specjedi-clarify`
  automatically — not merely recommend it — when the target `spec.md`
  contains one or more `NEEDS CLARIFICATION` markers at the start of a
  `specjedi-plan` run.
- **FR-002**: `specjedi-plan` MUST NOT invoke `specjedi-clarify` when the
  target `spec.md` contains zero `NEEDS CLARIFICATION` markers — planning
  proceeds exactly as it does today in that case.
- **FR-003**: After `specjedi-clarify` finishes (whether it asked
  questions or not), `specjedi-plan` MUST re-check `spec.md` for remaining
  `NEEDS CLARIFICATION` markers before proceeding.
- **FR-004**: If the re-check (FR-003) finds zero remaining markers,
  `specjedi-plan` MUST proceed directly into Technical Context and the
  rest of its existing steps, in the same run — the user MUST NOT have to
  separately re-invoke `/specjedi-plan`.
- **FR-005**: If the re-check (FR-003) finds one or more markers still
  present, `specjedi-plan` MUST stop without writing `plan.md`, and MUST
  report the specific remaining marker(s) by name/question — matching
  Step 4 of `specjedi-govcheck`'s own "name the specific evidence, never a
  vague 'might be violated'" discipline, applied here to remaining
  ambiguity.
- **FR-006**: `specjedi-plan` MUST invoke `specjedi-clarify` at most once
  per `specjedi-plan` run — it MUST NOT loop, re-invoking
  `specjedi-clarify` again automatically within the same run if markers
  survive the first pass (bounded, not indefinite, matching the same
  "diagnose-and-fix loop MUST be bounded" discipline Constitution
  Principle X already requires elsewhere in this project).
- **FR-007**: A `NEEDS CLARIFICATION` marker that `specjedi-plan` itself
  writes into `plan.md`'s Technical Context during its own Step 3 MUST
  NOT trigger `specjedi-clarify` — the auto-invocation in FR-001 is scoped
  only to markers already present in `spec.md` at the start of the run,
  matching `specjedi-clarify`'s own documented scope (spec-level
  requirement ambiguity, not plan-level technical-field gaps).
- **FR-008**: The automatic invocation of `specjedi-clarify` (FR-001) MUST
  NOT require a separate "may I run clarify?" confirmation prompt before
  starting — this matches the existing, already-shipped precedent of
  `specjedi-clarify`'s own proactive self-invocation from
  `specjedi-specify`. The actual human-in-the-loop checkpoint is
  `specjedi-clarify`'s own questions themselves, which the user must
  still answer (or explicitly skip) — auto-invocation changes only which
  skill starts the conversation, not whether the user's input is required.
- **FR-009**: `specjedi-plan`'s own `SKILL.md` MUST document this
  auto-invocation behavior explicitly — updating its existing Step 1 text
  (today: "stop and recommend `specjedi-clarify`") and its "Always /
  Never" section (today: "Never proceed to plan a spec that still has
  unresolved `NEEDS CLARIFICATION` markers — recommend `specjedi-clarify`
  instead") to describe the new automatic-invocation-then-recheck
  behavior, so the skill's own documentation stays accurate per
  Constitution Principle XIX.

### Key Entities

- **`spec.md` NEEDS CLARIFICATION marker**: an inline marker in a feature's
  spec, each naming a specific unresolved question; the object this
  feature's auto-invocation logic scans for and reacts to.
- **`specjedi-plan` run**: one invocation of the `specjedi-plan` skill
  against a target feature's `spec.md`; the auto-invocation-then-recheck
  cycle (FR-001, FR-003, FR-006) is scoped to a single run, never
  persisted or resumed across separate runs.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Running `/specjedi-plan` against a `spec.md` with unresolved
  `NEEDS CLARIFICATION` markers results in `specjedi-clarify` starting
  automatically, with zero additional user-typed commands, in 100% of
  such runs.
- **SC-002**: Running `/specjedi-plan` against a `spec.md` with zero
  `NEEDS CLARIFICATION` markers never invokes `specjedi-clarify` — 0
  unnecessary invocations across all such runs.
- **SC-003**: `specjedi-clarify` is invoked at most once per
  `specjedi-plan` run, in 100% of runs — no observed case of a second,
  automatic re-invocation within the same run.
- **SC-004**: When every marker `specjedi-clarify` surfaces is answered,
  the user reaches a written `plan.md` without manually re-running
  `/specjedi-plan` a second time, in 100% of such runs.

## Assumptions

- `specjedi-clarify`'s own existing question-asking behavior (up to 5
  targeted, prioritized questions, writing accepted answers back into
  `spec.md`) is unchanged by this feature — this feature only changes
  *when* `specjedi-clarify` starts (automatically vs. as a recommended
  next step), never *what* it does once it starts.
- This feature targets `specjedi-plan`'s Step 1 check specifically (the
  pre-existing-markers-at-start-of-run case). It does not extend
  `specjedi-clarify`'s own scope to plan-level Technical Context markers
  (User Story 3) — those remain exactly as `specjedi-plan` already
  handles them today.
- No new CLI flag or opt-out mechanism (e.g., `--skip-clarify`) is in
  scope for this feature; if a future need for one arises, it would be a
  separate feature.
- This change is documentation/behavior-only within `specjedi-plan`'s own
  `SKILL.md` — no new script, hook, or CI job is required, since both
  skills already exist and this only changes the control flow connecting
  them.
