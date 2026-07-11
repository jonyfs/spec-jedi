# Feature Specification: `specjedi-retro`

**Feature Branch**: `006-specjedi-retro`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Build specjedi-retro, the next item in
references/skill-roadmap.md's proposed-but-not-yet-built backlog:
post-specjedi-implement retrospective that diffs what shipped against what
was planned, captures what changed and why, and feeds genuine product
signal back into future specjedi-* skill research."

## Clarifications

### Session 2026-07-11

Run autonomously per the maintainer's standing instruction to proceed
through roadmap work and resolve what can reasonably be judged, deferring
only genuine blockers. Each answer applies research.md's findings rather
than guessing fresh.

- Q: How does `specjedi-retro` differ from `specjedi-analyze` and
  `specjedi-converge`, given all three compare artifacts to reality? → A:
  Scoped explicitly in research.md — `analyze` checks internal consistency
  between docs (no code, no history); `converge` remediates by appending
  tasks for undocumented code; `retro` is strictly read-only and
  backward-looking, producing narrative *why* a deviation happened and
  logging it as durable cross-feature signal. No overlap in write
  behavior — only `converge` writes to `tasks.md`; `retro` writes only to
  its own append-only log.
- Q: How does the skill determine "why" a deviation happened? → A: Only
  from traceable sources — commit messages, PR descriptions, or notes
  already present in `tasks.md`/`plan.md`. An untraceable deviation is
  reported as "cause not determinable from available history," never
  filled in with a plausible-sounding invention (Principle XX).
- Q: When does this skill run? → A: Only after a feature's `tasks.md`
  reaches 100% completion, or on explicit request — never mid-
  implementation, where a comparison would be premature and likely
  misleading.
- Q: Where does the durable signal log live, and what's its format? → A:
  `.specify/memory/retro-log.md`, mirroring `.specify/memory/
  skill-gaps.md`'s exact convention (dated, one-line-per-entry, created on
  first use) — consistency with an established pattern rather than a new
  parallel one.
- Q: Does this skill need `--auto`? → A: Yes, for consistency (feature 001
  FR-008 precedent) — in `--auto` mode it still reports "cause not
  determinable" rather than guessing when the cause isn't traceable; auto
  mode narrows pauses, not honesty.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Retrospect a completed feature (Priority: P1)

A user whose feature's `tasks.md` just reached 100% completion asks for a
retrospective. The skill compares the actual codebase/git history against
what `plan.md` described, identifies any deviations, states a grounded
cause for each traceable one (or explicitly says the cause isn't
determinable), and appends a dated entry to the durable retro log —
without editing any code, plan, or task file.

**Why this priority**: The entire reason this skill exists — without it,
"what changed from the plan and why" is a question nobody's tooling
answers, and the same category of deviation can recur invisibly across
features.

**Independent Test**: Given a completed feature whose actual implementation
diverged from its `plan.md` in a traceable way (e.g., a commit message
explaining a technical-approach change), run `specjedi-retro` and verify
the deviation is reported with its grounded cause, a dated entry lands in
`.specify/memory/retro-log.md`, and no other file is modified.

**Acceptance Scenarios**:

1. **Given** a completed feature where the plan specified approach A but a
   commit message shows the team switched to approach B mid-build with a
   stated reason, **When** `specjedi-retro` runs, **Then** the deviation
   is reported with that reason attributed to the commit it came from, and
   logged.
2. **Given** a completed feature with no deviation from its plan, **When**
   `specjedi-retro` runs, **Then** it reports "matched the plan, no
   deviations" and still logs a dated confirmation entry (a clean
   retrospective is real signal too, not just a deviation report).

---

### User Story 2 - An untraceable deviation is reported honestly (Priority: P2)

A user retrospects a feature where the actual code diverges from the plan
but no commit message, PR description, or note explains why. The skill
reports the deviation plainly and states the cause isn't determinable,
rather than inventing a plausible-sounding explanation.

**Why this priority**: Prevents the failure mode of a retrospective tool
that fabricates confident-sounding "why" narratives nobody can verify —
exactly the hallucination-resistance failure this project's own Principle
XX exists to prevent.

**Independent Test**: Given a feature with an undocumented deviation
(no traceable commit/PR/note explaining it), run `specjedi-retro` and
verify it reports the deviation with "cause not determinable from
available history" rather than a guessed explanation.

**Acceptance Scenarios**:

1. **Given** a deviation with zero traceable explanation in git history or
   project notes, **When** `specjedi-retro` runs, **Then** the report
   states the cause is not determinable, never a fabricated reason.

### Edge Cases

- A feature's `tasks.md` is not yet 100% complete: the skill declines to
  run a full retrospective and explains why (comparison would be
  premature), suggesting the user finish implementation or run
  `specjedi-status` to check progress first (resolved, Clarifications
  Session 2026-07-11).
- `.specify/memory/retro-log.md` doesn't exist yet: created on first use,
  mirroring `skill-gaps.md`'s own first-use behavior.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-retro` MUST run only against a feature whose
  `tasks.md` has reached 100% completion, or decline with an explanation
  if run against an incomplete one.
- **FR-002**: `specjedi-retro` MUST compare the actual codebase/git
  history against the feature's `plan.md` and identify deviations —
  technical approach changes, scope changes, added or dropped work.
- **FR-003**: `specjedi-retro` MUST state a deviation's cause only when
  traceable to an actual commit message, PR description, or existing
  project note — and MUST report "cause not determinable from available
  history" for any deviation it cannot trace, never inventing a
  plausible-sounding explanation.
- **FR-004**: `specjedi-retro` MUST be strictly read-only with respect to
  code, `spec.md`, `plan.md`, and `tasks.md` — its only write is an
  append to `.specify/memory/retro-log.md`.
- **FR-005**: `specjedi-retro` MUST append a dated entry to
  `.specify/memory/retro-log.md` for every run, including a clean
  retrospective with no deviations found — a clean result is real signal,
  not nothing to log.
- **FR-006**: `specjedi-retro` MUST support `--auto` (feature 001 FR-008
  precedent), narrowing confirmation pauses without ever replacing an
  untraceable cause with an invented one.

### Key Entities

- **Retrospective report**: one `specjedi-retro` invocation's output — a
  list of deviations (each with a grounded cause or an explicit
  "not determinable" marker) or a clean-match confirmation, plus the
  corresponding dated log entry appended to `.specify/memory/retro-log.md`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every reported deviation cause traces to an actual commit
  message, PR description, or project note cited alongside it — never an
  unattributed claim.
- **SC-002**: Every run appends exactly one dated entry to
  `.specify/memory/retro-log.md`, whether deviations were found or not.
- **SC-003**: Zero changes to code, `spec.md`, `plan.md`, or `tasks.md` as
  a result of running this skill — verified via `git status` showing only
  the log file touched.

## Assumptions

- This is its own feature cycle, following the same incremental discipline
  as features 001-005 — `specjedi-retro` ships alone; the remaining
  roadmap items (`specjedi-security`, `-docs`) each get their own research
  pass per Principle II when their turn comes.
- `git log` is assumed available (already a stated project prerequisite)
  for tracing deviation causes to commit messages.
