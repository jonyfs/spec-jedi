# Feature Specification: `specjedi-onboard`

**Feature Branch**: `002-specjedi-onboard`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Build specjedi-onboard, the #1 highest-impact
item in references/skill-roadmap.md's proposed-but-not-yet-built backlog: an
interactive first-run walkthrough that produces a user's actual first
constitution + spec together, teaching each concept at the moment it's
needed rather than front-loading a wall of docs."

## Clarifications

### Session 2026-07-11

Run autonomously per the maintainer's standing instruction to proceed
through remaining roadmap work and resolve what can reasonably be judged,
deferring only genuine blockers. Each answer applies research.md's findings
and feature 001's established precedent rather than guessing fresh.

- Q: Should `specjedi-onboard` implement its own constitution/spec
  generation logic, or orchestrate the existing `specjedi-constitution`/
  `specjedi-specify` skills? → A: Orchestrate — self-invoke the existing
  skills with extra first-run narration wrapped around them, per
  research.md's "must hand off cleanly" design implication. Duplicating
  validation logic in two places is exactly the maintenance trap Principle
  XVII's proactive gap-check exists to avoid creating.
- Q: How should `specjedi-onboard` behave if a `constitution.md` already
  exists in the target project? → A: Detect and step aside immediately —
  report that onboarding already happened and suggest `specjedi-explain` or
  whichever pipeline stage is next, never re-running the walkthrough
  unprompted. Mirrors feature 001's own precedent for "don't block, don't
  silently proceed, don't force a redo."
- Q: Should the walkthrough require a real project idea from the user
  before starting, or offer a generic example first? → A: Require a real
  idea — even one sentence — before starting. A generic example produces
  throwaway output the user discards, which research.md explicitly
  identifies as the Spec-Kitty/config-wizard failure mode to avoid. If the
  user has no idea yet, `specjedi-onboard` asks for one rather than
  substituting a placeholder.
- Q: Does `specjedi-onboard` need its own `--auto` flag given it's
  inherently interactive/educational? → A: Yes, for consistency with FR-008
  in feature 001 (every `specjedi-*` skill supports `--auto` from day one),
  but its `--auto` behavior narrows scope rather than skipping teaching
  entirely — it still produces the real constitution+spec, just without
  pausing to confirm each concept explanation, matching how every other
  `specjedi-*` skill's `--auto` mode already works.
- Q: Should `specjedi-onboard` be a separate skill from `specjedi-explain`,
  given both serve beginners? → A: Yes, distinct skills — `specjedi-explain`
  answers on-demand questions at any point in a project's life (reactive,
  works even for advanced users mid-project); `specjedi-onboard` is a
  one-time, proactive, sequenced walkthrough specifically for a project's
  very first run. Merging them would force an advanced user's quick
  question through a walkthrough flow, and force a genuine first-timer's
  walkthrough through a Q&A skill not built for sequencing.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - First-time user produces a real first constitution + spec (Priority: P1)

A user who has never used Spec Jedi (or any SDD tool) installs it, has a
one-sentence idea for a project, and runs `specjedi-onboard`. The skill
walks them through establishing their project's constitution and writing
their first spec — teaching each concept (what a constitution is, why a
spec marks ambiguity instead of guessing) at the exact moment it becomes
relevant, not before — and ends with two real, usable artifacts, not a
throwaway tutorial example.

**Why this priority**: This is the entire reason the skill exists — the
"first five minutes" gap research.md identifies as the highest-abandonment
point for any dev tool (Principle I, "reach thousands of people").

**Independent Test**: In a fresh project directory with no existing
`.specify/`, run `specjedi-onboard` with a one-sentence project idea and
verify it produces a valid `constitution.md` and a valid `spec.md` (each
passing the same validation `specjedi-constitution`/`specjedi-specify`
would independently require), with narration explaining each concept
inline as it's introduced.

**Acceptance Scenarios**:

1. **Given** a fresh project with no `.specify/memory/constitution.md`,
   **When** the user runs `specjedi-onboard` with a real one-sentence
   project idea, **Then** the skill produces a versioned constitution and a
   prioritized spec, narrating what each artifact is and why it matters as
   it's produced — not as an upfront wall of text before any output exists.
2. **Given** a user who provides no project idea when prompted, **When**
   `specjedi-onboard` reaches the point where one is needed, **Then** it
   asks for one explicitly rather than substituting a generic placeholder
   idea.

---

### User Story 2 - Returning user is never re-onboarded (Priority: P2)

A user who already has a `constitution.md` in their project accidentally
runs `specjedi-onboard` again (or a teammate joining an existing project
runs it, unaware one already exists). The skill detects this immediately
and steps aside rather than re-running the walkthrough or overwriting
anything.

**Why this priority**: Prevents the single most damaging failure mode for
an onboarding skill — silently clobbering or redundantly re-explaining a
project a team has already invested real work into.

**Independent Test**: In a project with an existing valid
`constitution.md`, run `specjedi-onboard` and verify it detects the
existing artifact, makes no changes to any file, and suggests the
appropriate next pipeline step instead.

**Acceptance Scenarios**:

1. **Given** a project with an existing `constitution.md`, **When** the
   user runs `specjedi-onboard`, **Then** the skill reports that onboarding
   already happened, modifies no file, and suggests `specjedi-explain` or
   the next relevant pipeline stage.

### Edge Cases

- A user runs `specjedi-onboard` with `--auto` and no project idea supplied
  anywhere in the invocation: `--auto` narrows scope (skips pausing to
  confirm each concept explanation) but never substitutes a placeholder
  idea — the skill still asks, even in `--auto` mode (resolved,
  Clarifications Session 2026-07-11).
- A harness without `AskUserQuestion`-style structured prompts: falls back
  to the same plain numbered-question pattern established in feature 001's
  Edge Cases, not a special case for this skill.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-onboard` MUST detect whether `.specify/memory/
  constitution.md` already exists in the target project before doing
  anything else, and MUST step aside (report, suggest next step, modify
  nothing) if it does.
- **FR-002**: `specjedi-onboard` MUST require a real, user-provided project
  idea (minimum one sentence) before producing any artifact — it MUST NOT
  substitute a generic or placeholder idea to keep the walkthrough moving.
- **FR-003**: `specjedi-onboard` MUST orchestrate the existing
  `specjedi-constitution` and `specjedi-specify` skills to produce its
  artifacts rather than reimplementing their validation or output format —
  avoiding two independently-maintained definitions of "valid constitution"
  or "valid spec."
- **FR-004**: `specjedi-onboard` MUST narrate each SDD concept (what a
  constitution is, what a spec is, why ambiguity gets marked rather than
  guessed) at the point in the walkthrough where that concept first becomes
  relevant, not as upfront documentation before any output exists.
- **FR-005**: `specjedi-onboard` MUST end its walkthrough with a guided
  next-step suggestion (Principle XIV), pointing to `specjedi-clarify` as
  the natural next pipeline stage.
- **FR-006**: `specjedi-onboard` MUST support `--auto` (Principle
  XIX/feature 001 FR-008 precedent) — narrowing to skip pausing for
  concept-explanation confirmation, while still requiring a real project
  idea and still producing both real artifacts.
- **FR-007**: `specjedi-onboard`'s own narration MUST use Spec Jedi's voice
  (Principle XII) and MUST NOT assume prior SDD familiarity — every concept
  it introduces gets a plain-language explanation, per this project's
  "beginner through advanced" mandate (Principle I).

### Key Entities

- **First-run walkthrough**: a single `specjedi-onboard` invocation,
  producing exactly one `constitution.md` and one `spec.md` for the user's
  stated project idea, with inline concept narration as a side effect, not
  a separate artifact.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A first-time user with a one-sentence idea and no prior SDD
  exposure completes `specjedi-onboard` with a valid constitution and spec
  in a single sitting, with no file needing manual correction afterward to
  pass `scripts/validate.sh`.
- **SC-002**: Re-running `specjedi-onboard` against a project that already
  has a constitution never modifies any file — verified by `git status`
  (or equivalent) showing zero changes after the run.
- **SC-003**: Every SDD concept introduced during the walkthrough is
  explained at the point it's used, not before — verified by the SKILL.md's
  own step ordering having no "explain everything up front" step preceding
  the first real question asked of the user.

## Assumptions

- This is its own feature cycle, following the same "prove the pattern
  incrementally" discipline feature 001 used across P1-P9 — `specjedi-
  onboard` ships alone rather than bundled with other roadmap items
  (`specjedi-migrate`, `specjedi-diagram`, etc.), each of which gets its own
  research pass per Principle II when its turn comes.
