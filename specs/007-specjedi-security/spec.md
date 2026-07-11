# Feature Specification: `specjedi-security`

**Feature Branch**: `007-specjedi-security`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Build specjedi-security, the next item in
references/skill-roadmap.md's proposed-but-not-yet-built backlog: a
lightweight threat-modeling pass over a spec/plan before implementation —
not a full security audit tool, just the 'did we think about auth/input
validation/secrets' questions a spec often misses."

## Clarifications

### Session 2026-07-11

Run autonomously per the maintainer's standing instruction to proceed
through roadmap work and resolve what can reasonably be judged, deferring
only genuine blockers. Each answer applies research.md's findings rather
than guessing fresh.

- Q: Does this skill duplicate `specjedi-checklist`'s security-focus-area
  capability? → A: No — resolved explicitly in research.md. The two
  differ in trigger model (proactive self-invocation here vs. request-only
  for checklist) and output shape (a short targeted-question list here vs.
  a comprehensive persisted checklist file). They compose: this skill
  recommends `specjedi-checklist` (security focus) as the next step for
  anyone wanting the comprehensive treatment.
- Q: When does `specjedi-security` trigger? → A: Proactively,
  self-invoked by `specjedi-plan` when spec/plan content mentions
  authentication, external input, secrets/credentials, or data handling —
  the same "notice mid-task" contract Principle XVII already establishes
  for `specjedi-find-skills`. Also available on explicit request at any
  point.
- Q: Where does the security-question taxonomy live? → A:
  `references/security-question-bank.md`, mirroring
  `references/star-wars-lexicon.md`'s "maintained reference pool, not
  invented ad hoc" pattern — extended over time as new categories arise.
- Q: Does this skill ever claim to be a comprehensive security audit? →
  A: No, explicitly never — the roadmap's own framing ("not a full
  security audit tool") is stated directly in the skill's persona/scope,
  and every output reinforces that this is a lightweight prompt, not a
  substitute for a real security review.
- Q: Does this skill need `--auto`? → A: Yes, for consistency (feature 001
  FR-008 precedent) — in `--auto` mode it still asks its targeted
  questions rather than silently assuming answers, since the whole point
  is surfacing unconsidered gaps, not filling them in with guesses.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Proactive security prompt during planning (Priority: P1)

While `specjedi-plan` is producing a technical plan for a feature whose
spec mentions user authentication, it notices the security-relevant
content and self-invokes `specjedi-security`, which scans the
security-question taxonomy, identifies which categories the spec/plan
hasn't addressed, and surfaces a short, targeted list of questions —
before implementation starts, not after.

**Why this priority**: The entire reason this skill exists — without it,
"did we think about X" security gaps go unnoticed until they surface as
bugs or, worse, incidents.

**Independent Test**: Given a spec/plan that mentions authentication but
never addresses session handling or credential storage, run
`specjedi-security` (directly, simulating the proactive trigger) and
verify it surfaces targeted questions about the unaddressed categories
specifically, not a generic list unrelated to what the spec actually
describes.

**Acceptance Scenarios**:

1. **Given** a spec/plan describing a login flow with no mention of how
   credentials are stored, **When** `specjedi-security` runs, **Then** it
   surfaces a targeted question about credential storage, grounded in the
   taxonomy's "secrets" category, not a generic "is this secure?"
   platitude.
2. **Given** a spec/plan that already explicitly addresses input
   validation for every external input it describes, **When**
   `specjedi-security` runs, **Then** it does not surface a redundant
   question about input validation the spec already answers.

---

### User Story 2 - Never overclaims comprehensive coverage (Priority: P2)

A user asks whether running `specjedi-security` means their feature has
had a "security review." The skill answers honestly that it hasn't — it's
a lightweight prompt for commonly-missed categories, not a substitute for
one, and points to `specjedi-checklist` (security focus) or a real
security review for comprehensive coverage.

**Why this priority**: Prevents the failure mode of a lightweight tool
that gets mistaken for (or implicitly claims to be) a comprehensive
security review, giving false confidence.

**Independent Test**: Ask the skill directly whether its output
constitutes a security review, and verify the answer is an explicit no
with a pointer to what would provide more comprehensive coverage.

**Acceptance Scenarios**:

1. **Given** a user asks if `specjedi-security`'s output means the
   feature is "secure," **When** the skill responds, **Then** it states
   plainly that this is a lightweight prompt, not a security audit, and
   names `specjedi-checklist` (security focus) as the next step for
   comprehensive coverage.

### Edge Cases

- A spec/plan with no security-relevant content at all (no auth, no
  external input, no secrets, no data handling): the skill reports that
  plainly — no questions to surface — rather than inventing generic
  security questions unrelated to what the feature actually does.
- The taxonomy file (`references/security-question-bank.md`) is missing
  or empty in a target project that installed only some references: the
  skill states this explicitly and falls back to a minimal, clearly-
  labeled built-in set rather than failing silently.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-security` MUST maintain its security-question
  taxonomy in `references/security-question-bank.md`, never inventing
  categories ad hoc inline.
- **FR-002**: `specjedi-security` MUST be self-invoked proactively by
  `specjedi-plan` when spec/plan content mentions authentication,
  external input, secrets/credentials, or data handling, in addition to
  being available on explicit request.
- **FR-003**: `specjedi-security` MUST surface only targeted questions
  for taxonomy categories the spec/plan hasn't already addressed — never
  a redundant question about something the spec already answers, and
  never a generic question untethered to the taxonomy.
- **FR-004**: `specjedi-security` MUST NOT claim or imply it constitutes a
  comprehensive security review — every output states plainly that it's a
  lightweight prompt, and points to `specjedi-checklist` (security focus)
  for comprehensive coverage.
- **FR-005**: `specjedi-security` MUST report plainly when a spec/plan has
  no security-relevant content to prompt about, rather than inventing
  generic questions.
- **FR-006**: `specjedi-security` MUST support `--auto` (feature 001
  FR-008 precedent) — narrowing pauses without silently assuming answers
  to the questions it surfaces.
- **FR-007**: `specjedi-plan`'s own `SKILL.md` MUST be updated to
  explicitly self-invoke `specjedi-security` when spec/plan content is
  security-relevant — mirroring the actual, verified convention every
  other proactive contract in this project uses (a literal "self-invoke
  X" instruction written into the triggering skill's own file, not an
  implicit expectation).

### Key Entities

- **Security prompt**: one `specjedi-security` invocation's output — a
  short list of targeted questions (or a "nothing to surface" report),
  each traceable to an unaddressed taxonomy category and the specific
  spec/plan content that triggered it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every surfaced question traces to a specific taxonomy
  category and specific spec/plan content — never a generic, untethered
  security platitude.
- **SC-002**: Zero questions surfaced for a taxonomy category the
  spec/plan already explicitly addresses.
- **SC-003**: Every response, when asked whether this constitutes a
  security review, states plainly that it doesn't.

## Assumptions

- This is its own feature cycle, following the same incremental discipline
  as features 001-006 — `specjedi-security` ships alone; the remaining
  roadmap item (`specjedi-docs`) gets its own research pass per Principle
  II when its turn comes.
- The proactive trigger requires editing `specjedi-plan/SKILL.md` (FR-007)
  — verified against this project's actual convention: every skill that
  proactively self-invokes `specjedi-find-skills` has a literal
  "self-invoke `specjedi-find-skills`" instruction written into its own
  file (checked directly in `specjedi-plan/SKILL.md`), not an implicit,
  documented-once expectation. `specjedi-security`'s trigger follows the
  same real pattern.
