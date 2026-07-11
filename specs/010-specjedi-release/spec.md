# Feature Specification: `specjedi-release`

**Feature Branch**: `010-specjedi-release`

**Created**: 2026-07-11

**Status**: Draft

## Clarifications

### Session 2026-07-11

Run via the actual `/speckit-clarify` skill, one targeted question,
self-resolved per the maintainer's standing instruction to proceed
automatically and document the reasoning rather than pause.

- Q: Should `specjedi-docs` *proactively self-invoke* `specjedi-release`
  after drafting a `CHANGELOG.md` entry (mirroring how `specjedi-plan`
  self-invokes `specjedi-security`), or just name it as a next-step
  option? → A: Next-step option only, never proactive self-invocation.
  Unlike a security gap (where missing a check has a real cost worth
  interrupting for), a release check has no such urgency, and this
  project's own recent history (ten features shipped back-to-back in one
  session) shows a release-suggestion firing after every single
  documented feature would be noisy, not helpful. FR-006 is scoped to
  updating `specjedi-docs`'s existing next-step reference to point at
  `specjedi-release` instead of the bare script — the same bulleted-list
  mechanism every skill already uses, not a new proactive trigger.

**Input**: User description: "Build specjedi-release, a skill that wraps
scripts/suggest-release.sh (and its .ps1 counterpart) with Spec Jedi's own
voice, guided next-step suggestions, and confirm-before-any-write
discipline. Constitution Principle XI ('Semantic-Versioned Releases with
Proactive Cut Suggestions') already mandates this capability, but
currently only a bare script exists — no specjedi-* skill gives it a
proper product surface, narration, or integration with the rest of the
pipeline. This is the same class of gap TODO(INSTALLER) closed for
Principle XVIII."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Get a narrated release suggestion (Priority: P1)

A user asks whether a release is due. `specjedi-release` runs the
existing `scripts/suggest-release.sh` (or `.ps1` on Windows), presents
its output — last tag, suggested next version and bump type, the commits
that justify it — in Spec Jedi's own voice, and ends with a guided next
step. It never tags or publishes anything itself.

**Why this priority**: The entire reason this skill exists — without it,
Principle XI's mandate stays a script only a user who already knows to
run it benefits from.

**Independent Test**: Given a repository with commits since its last tag
matching Conventional Commits prefixes, run `specjedi-release` and verify
it reports the same suggested version and bump type the underlying script
would produce on its own, narrated rather than raw script output, with no
tag or publish action taken.

**Acceptance Scenarios**:

1. **Given** commits since the last tag include at least one
   `feat:`-prefixed commit and no breaking-change marker, **When**
   `specjedi-release` runs, **Then** it reports a MINOR version bump
   suggestion, matching what `scripts/suggest-release.sh` alone would
   output, narrated in Spec Jedi's voice.
2. **Given** a repository with no tags yet, **When** `specjedi-release`
   runs, **Then** it reports the first-release guidance the underlying
   script already provides (a suggested starting version), not an error.

---

### User Story 2 - Never tags or publishes (Priority: P2)

A user asks `specjedi-release` to "cut" or "ship" the suggested release.
The skill declines to perform the tag/publish step itself, explains that
this requires an explicit maintainer action per Principle XI, and states
exactly what command would do it.

**Why this priority**: Prevents the failure mode of a "helpful" skill
that quietly crosses the suggest-only boundary Principle XI deliberately
draws.

**Independent Test**: Ask the skill to actually cut the suggested
release and verify it declines, explains why, and names the manual step
required — without running `git tag` or any publish action itself.

**Acceptance Scenarios**:

1. **Given** a user asks `specjedi-release` to tag and publish the
   suggested version, **When** the skill responds, **Then** it declines,
   cites Principle XI's suggest-only design, and states the manual `git
   tag`/publish step the maintainer would take — without executing either
   itself.

### Edge Cases

- Commits since the last tag don't match any known Conventional Commits
  prefix: the skill reports that plainly (mirroring the underlying
  script's own "no automatic suggestion — review manually" path) rather
  than guessing a bump type.
- Neither `scripts/suggest-release.sh` nor `.ps1` is present or
  executable in the current environment: the skill states this
  explicitly rather than silently failing or fabricating a suggestion.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-release` MUST run the existing
  `scripts/suggest-release.sh` (or `.ps1` on Windows) rather than
  reimplementing commit-classification logic itself.
- **FR-002**: `specjedi-release` MUST NOT execute `git tag`, publish, or
  any other release-cutting action — its entire write surface is zero;
  Principle XI's suggest-only boundary is absolute.
- **FR-003**: `specjedi-release` MUST decline, with an explanation and
  the correct manual command, when asked to actually cut or publish a
  release.
- **FR-004**: `specjedi-release` MUST present the underlying script's
  output (last tag, suggested version, bump type, contributing commits)
  narrated in Spec Jedi's own voice, never altering the substantive
  version/bump recommendation itself.
- **FR-005**: `specjedi-release` MUST report plainly when commits don't
  match a known Conventional Commits prefix, mirroring the underlying
  script's own manual-review fallback, rather than guessing a bump type.
- **FR-006**: `specjedi-docs`'s own `SKILL.md` MUST be updated to point
  its existing release-suggestion reference at `specjedi-release` instead
  of the bare script, following the verified actual proactive-reference
  convention already used elsewhere in this project (a literal
  cross-reference in the referring skill's own file).

### Key Entities

- **Release suggestion**: one `specjedi-release` invocation's output —
  the underlying script's suggested version/bump type and contributing
  commit list, narrated, with zero side effects on the repository.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The suggested version and bump type `specjedi-release`
  reports always matches what `scripts/suggest-release.sh`/`.ps1` alone
  would produce for the same repository state.
- **SC-002**: Zero tag or publish actions occur as a result of any
  `specjedi-release` invocation, including when explicitly asked to cut a
  release.
- **SC-003**: A repository with no matching-prefix commits since its last
  tag gets an honest "review manually" report, never a guessed bump type.

## Assumptions

- This is its own feature cycle — `specjedi-release` ships alone,
  following the same incremental discipline as every prior feature.
- `scripts/suggest-release.sh`/`.ps1` are assumed correct and unchanged by
  this feature — this skill wraps them, it does not modify their
  underlying logic.
