# Feature Specification: `specjedi-quick` — Lightweight Path for Small, Well-Understood Changes

**Feature Branch**: `028-specjedi-quick`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description: "Faça o item 2" — referring to
`references/honest-assessment.md`'s top improvement point: *"Build the
lightweight/quick path. Two independently-researched competitors validate
this is worth having: BMAD-METHOD's 'Quick Flow' ... and OpenSpec's
three-command, brownfield-focused model."*

## Problem

Every Spec Jedi feature, however small, currently goes through the full
research → `specjedi-specify` → `specjedi-clarify` → `specjedi-plan` →
`specjedi-tasks` → `specjedi-implement` pipeline, producing four separate
files (`spec.md`, `research.md`, `plan.md`, `tasks.md`). For a one-line
fix or a small, already-well-understood change, this ceremony is real
overhead with no corresponding benefit — `references/competitive-
comparison.md` recorded Spec Jedi as having "adopted" BMAD-METHOD's
Quick Flow idea back in feature 001, but no such lightweight path has
ever shipped.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A small, well-understood change gets a fast path (Priority: P1)

A developer with a small, clearly-scoped change (a bug fix, a copy
change, a one-file tweak) wants to skip the full four-artifact ceremony
and go from idea to shipped code through one lightweight step instead.

**Why this priority**: The entire point of this feature — the gap named
directly in `references/honest-assessment.md`.

**Independent Test**: Invoke `specjedi-quick` with a small, concrete
change description; confirm it produces one combined artifact
(`quick.md`) instead of four separate files, then proceeds to
implementation without requiring separate `specjedi-plan`/`specjedi-tasks`
invocations.

**Acceptance Scenarios**:

1. **Given** a small, well-understood change request, **When**
   `specjedi-quick` is invoked, **Then** it produces a single
   `specs/NNN-name/quick.md` file (not `spec.md`+`research.md`+
   `plan.md`+`tasks.md`) and proceeds directly to implementation.
2. **Given** a completed quick-path change, **When** a reader opens
   `quick.md`, **Then** they can understand what changed and why without
   consulting any other artifact — the "fits on one page of notes" bar
   BMAD's own Quick Flow docs state directly.
3. **Given** the plan calls for code, **When** `specjedi-quick`
   implements it, **Then** it still follows Principle VI's test-first
   default and still self-invokes `specjedi-govcheck` before opening a
   PR — "quick" shortens planning ceremony, never quality gates.

---

### User Story 2 - Genuinely large or ambiguous changes get redirected, not force-fit (Priority: P1)

A developer whose request turns out to be bigger or more ambiguous than
they thought wants `specjedi-quick` to say so and redirect to the full
pipeline, rather than silently producing an inadequate `quick.md` for
something that actually needed real planning.

**Why this priority**: Equal priority to US1 — a fast path that silently
mishandles work too big for it would undermine trust in the whole
mechanism, the same failure mode Principle V already guards against for
the full pipeline (never let an agent guess through real ambiguity).

**Independent Test**: Invoke `specjedi-quick` with a request that fails
one or more eligibility criteria (e.g., touches multiple subsystems, has
genuine unresolved ambiguity, or is itself a new `specjedi-*` skill);
confirm it declines and redirects to `specjedi-specify` rather than
producing a `quick.md` anyway.

**Acceptance Scenarios**:

1. **Given** a request that fails the eligibility checklist (spec.md
   FR-001), **When** `specjedi-quick` evaluates it, **Then** it states
   plainly which criterion failed and redirects to `specjedi-specify`
   rather than proceeding on the fast path.
2. **Given** a request for a brand-new `specjedi-*` skill, **When**
   `specjedi-quick` is invoked, **Then** it always declines — new skills
   require Principle II's full competitive-research rigor and Principle
   XIX's full authoring standard, never the fast path, regardless of how
   small the skill might seem.

---

### User Story 3 - `specjedi-status` correctly reports quick-path features (Priority: P2)

A developer running `specjedi-status` wants quick-path features to show
up with an accurate status, the same as full-pipeline features do —
never silently invisible or misreported as "not started."

**Why this priority**: Lower than US1/US2 because it's a compatibility
fix enabling correct reporting, not the core new capability — but without
it, `specjedi-quick` would create a real, silent gap in an already-shipped
skill's coverage.

**Independent Test**: Run `specjedi-status` against a project containing
both full-pipeline and quick-path features; confirm both report an
accurate status derived from their own on-disk artifacts.

**Acceptance Scenarios**:

1. **Given** a feature directory containing only `quick.md`, **When**
   `specjedi-status` runs, **Then** it reports that feature's status
   derived from `quick.md`'s own `Status:` line and Acceptance Checks
   checkbox count — not "no artifacts found."

### Edge Cases

- What happens when a quick-path change, once started, turns out to be
  bigger than expected? → `specjedi-quick` states this explicitly and
  offers to hand off to `specjedi-specify` (carrying forward what
  `quick.md` already captured as a starting point), rather than either
  forcing the oversized change through `quick.md` or silently abandoning
  the work already done.
- What happens if a user explicitly asks for the fast path on something
  that clearly fails eligibility (e.g., "quick, just build a new skill
  for X")? → the explicit request doesn't override the hard exclusions
  in FR-001 (new skill, constitution amendment, multi-subsystem change) —
  those apply unconditionally, unlike a genuine judgment-call criterion
  the user might reasonably override.
- What happens to `quick.md` once implemented — does it get deleted or
  moved? → no; `specs/NNN-name/` stays permanent history for every
  feature regardless of which path produced it, matching this project's
  existing convention (research.md's "what Spec Jedi rejects" — no
  separate archive step or directory).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-quick` MUST evaluate an explicit eligibility
  checklist before proceeding on the fast path — MUST decline (and
  redirect to `specjedi-specify`) if any of: (a) the change is not
  describable in roughly one page of notes (BMAD's own stated bar); (b)
  the change touches more than one subsystem/directory concern; (c) the
  request contains genuine unresolved ambiguity (the same bar
  `specjedi-specify`'s NEEDS CLARIFICATION discipline already uses); (d)
  the request is for a new `specjedi-*` skill (always requires the full
  pipeline, per Principle II/XIX, regardless of apparent size); (e) the
  request is a constitution amendment (has its own `/speckit-constitution`
  path already).
- **FR-002**: For an eligible change, `specjedi-quick` MUST produce
  exactly one artifact, `specs/NNN-name/quick.md`, with four sections:
  What & Why, Concrete Changes, Acceptance Checks, and Status
  (`Proposed`/`Implemented`) — never the separate `spec.md`/`research.md`/
  `plan.md`/`tasks.md` set the full pipeline produces.
- **FR-003**: `specjedi-quick` MUST proceed directly to implementation
  after writing `quick.md`, without requiring separate `specjedi-plan`/
  `specjedi-tasks` invocations — the single-step-to-shipped-code property
  both researched competitors validate.
- **FR-004**: Implementation via `specjedi-quick` MUST still follow
  Principle VI's test-first default where the change involves code, and
  MUST still self-invoke `specjedi-govcheck` before opening a PR — quality
  gates are never part of what "quick" shortens.
- **FR-005**: If a change grows beyond eligibility mid-flight (Edge
  Cases), `specjedi-quick` MUST state this explicitly and offer a
  hand-off to `specjedi-specify`, carrying forward `quick.md`'s content
  as a starting point rather than discarding it.
- **FR-006**: `specjedi-status/SKILL.md`'s existing artifact-detection
  logic MUST be extended to recognize `quick.md` (its `Status:` line and
  Acceptance Checks checkbox count) as a valid, independently-reportable
  artifact — not a new parallel tracking mechanism, an extension of the
  one that already exists.
- **FR-007**: `specjedi-quick` MUST update `Status: Implemented` in
  `quick.md` once implementation completes and a PR is opened — the
  OpenSpec-style completion signal `specjedi-status` (FR-006) reads.

### Key Entities

- **`quick.md`**: the single combined artifact a quick-path change
  produces — replaces `spec.md`+`research.md`+`plan.md`+`tasks.md` for
  eligible work only.
- **Eligibility checklist**: the explicit, checkable set of criteria
  (FR-001) determining whether a request qualifies for the fast path.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An eligible small change goes from request to a shipped PR
  through exactly one artifact file and one skill invocation, not four
  files and up to five separate command invocations.
- **SC-002**: 100% of requests failing any FR-001 eligibility criterion
  are declined and redirected — zero quick-path artifacts produced for
  ineligible requests, verified by testing at least one deliberately
  ineligible request per criterion during this feature's own
  implementation.
- **SC-003**: `specjedi-status` correctly reports a quick-path-only
  feature's status with the same accuracy bar as a full-pipeline feature
  — verified by manually constructing a representative `quick.md` test
  fixture and confirming `specjedi-status` reports its status correctly
  (this feature itself is built via the full pipeline, not its own fast
  path — see Assumptions).
- **SC-004**: `scripts/validate.sh`'s existing structural lint passes for
  the new `specjedi-quick/SKILL.md` and the revised `specjedi-status/
  SKILL.md`.

## Assumptions

- **This feature itself is built via the full pipeline, not
  `specjedi-quick`** — building a brand-new `specjedi-*` skill is exactly
  what FR-001(d)'s hard exclusion forbids the fast path from handling,
  and Principle II's competitive-research rigor for new skills doesn't
  bend for the feature that introduces the shortcut. This is deliberate,
  not an oversight.
- **`quick.md` lives under the same `specs/NNN-name/` convention** as
  full-pipeline features (not a separate directory) — keeps every
  existing skill that scans `specs/` (`specjedi-status`, `specjedi-
  analyze`, `specjedi-converge`) working against one convention, with
  only the file-presence check needing to broaden (FR-006).
- **No new eligibility-detection tooling** — the checklist (FR-001) is
  reasoned through by the invoking agent, the same way `specjedi-specify`
  already reasons through NEEDS CLARIFICATION detection without a
  separate classifier tool.
- **Scope boundary**: this feature does not change how `specjedi-status`
  aggregates/labels the *dashboard* view's summary counts beyond
  correctly counting quick-path features — no new dashboard section is
  introduced.
