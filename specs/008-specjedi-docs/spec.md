# Feature Specification: `specjedi-docs`

**Feature Branch**: `008-specjedi-docs`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Build specjedi-docs, the final item in
references/skill-roadmap.md's proposed-but-not-yet-built backlog: generates
end-user-facing documentation (README sections, changelog entries) from a
shipped spec/plan, kept in sync instead of drifting from what actually got
built."

## Clarifications

### Session 2026-07-11

Run autonomously per the maintainer's standing instruction to proceed
through roadmap work and resolve what can reasonably be judged, deferring
only genuine blockers. Each answer applies research.md's findings rather
than guessing fresh.

- Q: Does "generates documentation" mean open-ended doc generation, or a
  bounded set of surfaces? → A: Bounded, per research.md's scoping —
  specifically this project's own README skill-table row, Quickstart
  step, and a new `CHANGELOG.md` entry. Open-ended generation risks
  inventing content a spec doesn't actually support (Principle XX
  overclaiming discipline).
- Q: When does this skill run? → A: On request, against an already-
  shipped feature (spec/plan complete, matching `specjedi-retro`'s
  completion-gated timing) — documenting an unfinished feature risks
  documenting something that might still change before it ships.
- Q: Where does the changelog live? → A: `CHANGELOG.md` at the repo root
  (standard open-source convention), a new file distinct from
  `.specify/memory/skill-gaps.md` and `.specify/memory/retro-log.md` —
  those are internal cross-session signal logs for this project's own
  development; `CHANGELOG.md` is end-user-facing, matching this feature's
  own "end-user-facing documentation" framing.
- Q: How does the skill avoid inventing content? → A: Every generated doc
  line MUST trace to something the shipped spec/plan actually states —
  the same grounding discipline `specjedi-checklist`/`specjedi-diagram`
  already apply to their own artifact types.
- Q: Does this skill need `--auto`? → A: Yes, for consistency (feature 001
  FR-008 precedent) — `--auto` narrows confirmation pauses but never
  applies a generated doc edit to a file without it being shown first,
  matching every other file-writing `specjedi-*` skill's confirm-before-
  write discipline where one exists.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Document a shipped feature (Priority: P1)

A user whose feature just shipped (spec/plan complete, code merged) asks
for its documentation to be generated. The skill reads the spec/plan,
drafts a README skill-table row and Quickstart step grounded in what the
spec actually describes, and a `CHANGELOG.md` entry — presenting all three
for confirmation before writing.

**Why this priority**: The entire reason this skill exists — without it,
every shipped feature needs the exact manual doc-sync work this project's
own development has required by hand for every prior roadmap item.

**Independent Test**: Given a shipped feature's spec/plan describing a
specific capability, run `specjedi-docs` and verify the drafted README
row and Quickstart step accurately reflect what the spec describes (no
invented capability, no missing one), and a properly-formatted
`CHANGELOG.md` entry is drafted.

**Acceptance Scenarios**:

1. **Given** a shipped feature's spec.md describing a specific, bounded
   capability, **When** `specjedi-docs` runs, **Then** the drafted
   README skill-table row describes that capability accurately, tracing
   to specific spec content, not a generic capability description.
2. **Given** the same shipped feature, **When** `specjedi-docs` runs,
   **Then** it drafts a `CHANGELOG.md` entry (creating the file if it
   doesn't exist yet) and presents it for confirmation before writing.

---

### User Story 2 - Drafts require confirmation before writing (Priority: P2)

A user runs `specjedi-docs` and reviews the drafted README/changelog
changes before they're applied — the skill never silently commits doc
changes without the user seeing them first.

**Why this priority**: Prevents the failure mode of a doc-generation tool
that quietly rewrites project-facing documentation without a review step,
risking an inaccurate or oddly-worded doc change landing unreviewed.

**Independent Test**: Run `specjedi-docs` against a shipped feature and
verify the drafted changes are presented before any file is actually
modified, requiring explicit confirmation.

**Acceptance Scenarios**:

1. **Given** a drafted README/changelog update, **When** the user has not
   yet confirmed it, **Then** no file has been modified — confirmed via
   `git status` showing no changes until after confirmation.

### Edge Cases

- A feature's spec/plan is incomplete or still `tasks.md`-in-progress: the
  skill declines to generate documentation for it and explains why,
  mirroring `specjedi-retro`'s own completion-gate behavior.
- `CHANGELOG.md` doesn't exist yet: created on first use with a minimal
  standard header, then the new entry appended.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-docs` MUST generate documentation only for a
  feature whose spec/plan is complete — declining with an explanation for
  an in-progress feature.
- **FR-002**: `specjedi-docs` MUST scope its output to this project's
  bounded doc surfaces: a README skill-table row, a Quickstart step, and
  a `CHANGELOG.md` entry — never open-ended documentation generation.
- **FR-003**: `specjedi-docs` MUST ground every generated doc line in
  content the shipped spec/plan actually states — never inventing a
  capability or claim the spec doesn't support.
- **FR-004**: `specjedi-docs` MUST present every drafted change for
  confirmation before writing it to README.md or CHANGELOG.md — never a
  silent write.
- **FR-005**: `specjedi-docs` MUST create `CHANGELOG.md` with a minimal
  standard header on first use if it doesn't already exist.
- **FR-006**: `specjedi-docs` MUST support `--auto` (feature 001 FR-008
  precedent), narrowing pauses without skipping the confirm-before-write
  step for either file.

### Key Entities

- **Doc draft**: one `specjedi-docs` invocation's output — a proposed
  README skill-table row, a proposed Quickstart step, and a proposed
  `CHANGELOG.md` entry, each traceable to specific spec/plan content,
  presented together for confirmation before any file is written.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every drafted doc line traces to specific content in the
  shipped spec/plan — verified by manual cross-check during the dry run.
- **SC-002**: Zero files modified until the user explicitly confirms the
  draft — verified via `git status`.
- **SC-003**: A run against an incomplete feature declines with an
  explanation rather than generating speculative documentation.

## Assumptions

- This is the final roadmap-item feature cycle in the current
  `references/skill-roadmap.md` backlog (features 001-008 complete the
  original list) — future roadmap items would restart this same
  incremental-shipping discipline from a freshly-proposed list.
- `CHANGELOG.md` is additive to, not a replacement for, this project's
  existing `scripts/suggest-release.sh` mechanism (Principle XI) — the
  changelog documents what shipped in end-user terms; the release-suggest
  script remains the mechanism for version-bump recommendations from
  Conventional Commits.
