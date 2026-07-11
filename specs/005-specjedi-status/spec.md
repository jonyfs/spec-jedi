# Feature Specification: `specjedi-status`

**Feature Branch**: `005-specjedi-status`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Build specjedi-status, the next item in
references/skill-roadmap.md's proposed-but-not-yet-built backlog: a
project-wide dashboard skill showing which features have a spec/plan/tasks,
which are mid-implementation, which are stalled."

## Clarifications

### Session 2026-07-11

Run autonomously per the maintainer's standing instruction to proceed
through roadmap work and resolve what can reasonably be judged, deferring
only genuine blockers. Each answer applies research.md's findings rather
than guessing fresh.

- Q: Should `specjedi-status` maintain its own tracked status file? → A:
  No — research.md's genuine-contribution finding is precisely that
  status derives entirely from existing artifacts (`spec.md`/`plan.md`/
  `tasks.md` presence, checkbox completion) with zero separate system to
  keep in sync. Creating a tracked status file would undermine the whole
  point.
- Q: What counts as "stalled"? → A: Research.md flags that a fixed
  time-based threshold isn't meaningful across different team paces (this
  repo shipped and completed a feature same-day multiple times this
  session). Rather than the skill asserting a "stalled" judgment the data
  doesn't clearly support, it reports the objective signal — last commit
  touching that feature directory (via `git log`) alongside completion
  percentage — and leaves the "is this actually stalled" call to the
  human reading the dashboard. Hallucination resistance (Principle XX)
  means not asserting a subjective judgment as if it were a fact the data
  proves.
- Q: Does the dashboard need real-time/live updates, or is a point-in-time
  snapshot sufficient? → A: Point-in-time snapshot, regenerated on each
  request — this matches every other `specjedi-*` skill's execution model
  (a run produces an answer for the current state, not a persistent
  watcher process), and avoids introducing a new "long-running skill"
  category this project doesn't otherwise have.
- Q: Should `specjedi-status` scan the whole repo, or only `specs/`? →
  A: Only `specs/NNN-feature-name/` directories — that's the established
  convention every `specjedi-*` pipeline skill already uses (Principle
  XV's naming discipline extends to this project's own directory
  structure); scanning the whole repo would risk false-positive "features"
  from unrelated directories.
- Q: Does this skill need `--auto`? → A: No confirmation gates exist to
  narrow — this is a read-only report with no judgment call requiring a
  pause, so `--auto` would be a no-op; the skill still accepts the flag
  for interface consistency with every other `specjedi-*` skill but
  documents that it changes nothing about its own behavior.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See project-wide status across multiple features (Priority: P1)

A user working across several features in flight (each its own
`specs/NNN-feature-name/` directory) asks for a status overview. The skill
scans every feature directory, derives its status purely from which
artifacts exist and `tasks.md`'s own checkbox completion, and presents a
single table — one row per feature — with no separately-maintained
tracking system behind it.

**Why this priority**: The entire reason this skill exists — without it,
"which features am I still working on" stays a manual memory exercise
even though the answer is already sitting on disk.

**Independent Test**: Given a project with 3+ `specs/NNN-feature-name/`
directories in different completion states (spec-only, planned-not-tasked,
partially-complete tasks, fully-complete tasks), run `specjedi-status` and
verify the reported state for each matches its actual on-disk artifacts
and checkbox ratio exactly.

**Acceptance Scenarios**:

1. **Given** a project with one feature that has only `spec.md`, one with
   `spec.md`+`plan.md` but no `tasks.md`, and one with `tasks.md` at 60%
   checkbox completion, **When** the user requests status, **Then** the
   dashboard reports each feature's actual state ("specified," "planned,"
   "60% complete") without inventing a state none of them are actually in.
2. **Given** a feature with `tasks.md` at 100% checkbox completion,
   **When** status is requested, **Then** that feature reports complete,
   distinguishable from a feature still in progress.

---

### User Story 2 - No features in flight is a clean, honest result (Priority: P2)

A user runs `specjedi-status` in a project with no `specs/` directory yet,
or an empty one. The skill reports that plainly rather than presenting an
empty table with no explanation.

**Why this priority**: Prevents the failure mode of a dashboard that looks
broken (empty table, no context) instead of a dashboard that correctly
reports "nothing here yet."

**Independent Test**: Given a project with no `specs/` directory, run
`specjedi-status` and verify it reports no features exist yet, with a
suggested next step, rather than an unexplained empty result.

**Acceptance Scenarios**:

1. **Given** no `specs/` directory exists, **When** `specjedi-status`
   runs, **Then** it reports "no features found yet" plainly and suggests
   `specjedi-specify` as the next step.

### Edge Cases

- A `tasks.md` with malformed or missing checkboxes (e.g., a task line
  that doesn't match the `- [ ]`/`- [x]` convention): the skill counts
  only recognizable checkbox lines and notes if any lines were
  unrecognized, rather than silently miscounting or crashing.
- A feature directory that doesn't follow the `NNN-feature-name` naming
  convention: excluded from the scan and, if the user seems to expect it
  included, noted as non-conforming rather than silently skipped with no
  explanation (resolved, Clarifications Session 2026-07-11 — only
  conforming directories are in scope).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-status` MUST derive every feature's status
  entirely from artifacts already on disk (`spec.md`/`plan.md`/
  `tasks.md` presence and checkbox state) — it MUST NOT create, read, or
  require a separately-maintained status-tracking file.
- **FR-002**: `specjedi-status` MUST scan only `specs/NNN-feature-name/`
  directories matching this project's established naming convention.
- **FR-003**: `specjedi-status` MUST report, per feature: which artifacts
  exist (spec/plan/tasks), and where `tasks.md` exists, its checkbox
  completion percentage.
- **FR-004**: `specjedi-status` MUST report the most recent commit
  touching each feature directory (via `git log`) as an objective
  recency signal, and MUST NOT assert a subjective "stalled" judgment the
  data doesn't clearly prove — the human reading the report makes that
  call.
- **FR-005**: `specjedi-status` MUST report "no features found yet" (with
  a suggested next step) when no conforming feature directories exist,
  rather than presenting an unexplained empty result.
- **FR-006**: `specjedi-status` produces a point-in-time snapshot on each
  invocation — it MUST NOT persist or cache results between runs in a way
  that could go stale.

### Key Entities

- **Status report**: one `specjedi-status` invocation's output — a table
  with one row per conforming feature directory (name, artifacts present,
  `tasks.md` completion percentage if applicable, most recent commit
  date), regenerated fresh every run.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every reported feature's artifact list and completion
  percentage matches its actual on-disk state exactly — verified by
  manual cross-check during the dry run.
- **SC-002**: A run against a project with zero conforming feature
  directories reports that plainly with a suggested next step, never an
  unexplained empty table.
- **SC-003**: No status report asserts "stalled" as a fact — every
  recency signal is reported as an objective commit date, letting the
  reader draw that conclusion.

## Assumptions

- This is its own feature cycle, following the same incremental discipline
  as features 001-004 — `specjedi-status` ships alone; the remaining
  roadmap items (`specjedi-retro`, `-security`, `-docs`) each get their
  own research pass per Principle II when their turn comes.
- `git log` is assumed available (already a stated prerequisite for this
  project, per README's Prerequisites section) for the recency signal in
  FR-004; if unavailable, the skill omits that column and says so rather
  than failing the whole report.
