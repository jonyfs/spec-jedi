# Feature Specification: Competitive Comparison Table

**Feature Branch**: `014-competitive-comparison`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Create references/competitive-comparison.md, a markdown table comparing specjedi-* against the other SDD/agent-skill tools already researched and cited in this project (spec-kit baseline plus the ten competitors in specs/001-specjedi-pipeline/research.md: BMAD-METHOD, OpenSpec, Kiro, Tessl, Spec Kitty, Superpowers, GSD, PRP, Traycer, codemyspec.com), grounded in that existing research rather than new unverified claims. Link the new file from README.md so it's discoverable."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Prospective adopter compares tools at a glance (Priority: P1)

A developer evaluating whether to adopt Spec Jedi already knows one or more
of spec-kit, BMAD-METHOD, OpenSpec, Kiro, Tessl, or another SDD tool. They
want to see, in one place, how Spec Jedi differs — without reading a
research document written for a different purpose (justifying design
decisions to a maintainer, not helping a newcomer compare products).

**Why this priority**: This is the actual audience-facing purpose of the
document — without it, the comparison only exists buried in
`research.md`, which nothing in the project's public-facing docs
(`README.md`) currently surfaces to a reader who isn't building a new
`specjedi-*` skill.

**Independent Test**: Open `references/competitive-comparison.md` with no
other context and confirm every named competitor tool has a row showing
how Spec Jedi differs from it, sourced from real prior research rather
than freshly invented claims.

**Acceptance Scenarios**:

1. **Given** a reader who has never seen `research.md`, **When** they open
   the new comparison document, **Then** they can identify which of the 11
   researched tools (spec-kit + 10 competitors) offer a given capability
   and which don't, without needing to cross-reference another file.
2. **Given** a comparative claim in the table (e.g., "no competitor ties
   its rules document to an actual CI gate"), **When** a skeptical reader
   asks "says who?", **Then** the claim traces back to a specific,
   already-existing citation in `specs/001-specjedi-pipeline/research.md`
   (Principle XX hallucination-resistance — no new unverified claims).

---

### User Story 2 - Maintainer keeps the comparison from going stale (Priority: P2)

As this project researches new competitors (Principle II, mandatory
before any new skill ships) or ships a capability that closes a gap the
table currently shows as Spec-Jedi-only, a maintainer needs to know the
comparison document is a live artifact to update, not a one-time snapshot
that silently drifts out of date.

**Why this priority**: Without an explicit maintenance instruction, this
document risks the same class of drift this project has already found
and fixed twice this session (stale badges, stale skill counts) — a
fact-bearing document with no stated update trigger.

**Independent Test**: Read the document's own maintenance note and
confirm it names a concrete trigger (a new `research.md` entry, or a
shipped feature that changes one of the compared dimensions) rather than
leaving "keep this updated" implicit.

**Acceptance Scenarios**:

1. **Given** a future feature's `research.md` adds an 11th competitor,
   **When** a maintainer reads this document's maintenance note, **Then**
   they know to add a row for it in the same PR, mirroring the pattern
   `references/genuine-contributions-log.md` already established.

---

### User Story 3 - Reader discovers the comparison from the README (Priority: P3)

A visitor reading `README.md` — the project's front door — should be able
to find the comparison document without already knowing it exists.

**Why this priority**: A comparison document nobody can find delivers
none of User Story 1's value; discoverability is the delivery mechanism,
not a nice-to-have.

**Independent Test**: Starting from `README.md` alone, follow a link and
land on the comparison document within one click.

**Acceptance Scenarios**:

1. **Given** `README.md` as rendered on GitHub, **When** a reader looks
   for how Spec Jedi compares to tools they may already know, **Then**
   they find a working link to `references/competitive-comparison.md`.

### Edge Cases

- What happens when a compared dimension can't be verified for a given
  tool (e.g., Traycer is closed-source, so internal mechanism details
  aren't inspectable)? The table MUST mark that cell as not verifiable
  rather than guessing — consistent with `research.md`'s own treatment of
  Traycer ("evaluated at the philosophy level only").
- How does the document handle a competitor `research.md` marks as
  "reject — out of scope" (e.g., Kiro's IDE-lock-in, Tessl's
  spec-replaces-code stance)? These still get a row — the comparison
  value is in showing *why* Spec Jedi didn't adopt that tool's approach,
  not only rows where an idea was adopted.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The comparison MUST live in a single new file at
  `references/competitive-comparison.md`.
- **FR-002**: The document MUST include a row for every tool in Principle
  II's already-researched competitor set: the spec-kit baseline plus the
  ten tools named in `specs/001-specjedi-pipeline/research.md` (BMAD-METHOD,
  OpenSpec, Kiro, Tessl, Spec Kitty, Superpowers, GSD, PRP, Traycer,
  codemyspec.com) — eleven rows total, no more, no fewer, matching the
  existing research scope exactly.
- **FR-003**: Every comparative claim MUST be traceable to
  `specs/001-specjedi-pipeline/research.md` (or another artifact already
  shipped in this repo, e.g. `references/genuine-contributions-log.md`) —
  no new competitor capability claims researched or invented for this
  document alone.
- **FR-004**: The comparison MUST be presented as a scannable table
  (tool × dimension), not prose-only, per this project's own README
  precedent for the harness-compatibility and skill-roadmap tables.
- **FR-005**: The document MUST distinguish, per tool, which mechanism
  Spec Jedi **adopted** from it, which it explicitly **rejected** (and
  why), and — separately — which of Spec Jedi's own capabilities remain
  a **genuine contribution** no researched tool has, reusing
  `research.md`'s own recorded adopt/reject decisions rather than
  re-deriving new ones.
- **FR-006**: `README.md` MUST link to the new document from a
  discoverable location (e.g., near the existing "Supported harnesses" or
  roadmap sections) so a reader doesn't need prior knowledge of
  `references/` to find it.
- **FR-007**: The document MUST state its own maintenance trigger (when a
  future `research.md` adds a new competitor, or a shipped feature closes
  a gap a row currently claims as Spec-Jedi-only) — mirroring
  `references/genuine-contributions-log.md`'s existing "How to use
  this"/"Maintenance" pattern rather than inventing a new convention.

### Key Entities

- **Compared Tool**: one of the 11 researched SDD/agent-skill tools
  (name, category/model — e.g., IDE vs. skill-pack vs. commercial layer,
  the adopt/reject decision already recorded in `research.md`, and any
  dimension that isn't verifiable for it).
- **Comparison Dimension**: an axis of comparison drawn from what
  `research.md` already evaluated per tool (e.g., phase-gate rigidity,
  lightweight/quick-path support, cross-harness portability, governance/
  CI enforcement, proactive gap-detection, voice/identity layer) — not a
  new taxonomy invented independently of the existing research.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A reader with no prior exposure to `research.md` can name,
  for each of the 11 researched tools, at least one concrete way Spec
  Jedi differs from it, using only the new document.
- **SC-002**: 100% of comparative claims in the new document trace to an
  already-existing citation in this repo — zero net-new, unverified
  competitor claims introduced solely for this document (Principle XX).
- **SC-003**: The document is reachable within one link-click starting
  from `README.md`.

## Assumptions

- The comparison scope is exactly the 11 tools already researched under
  Principle II for feature 001 (spec-kit + 10 named competitors) — not an
  invitation to research additional, previously-unresearched tools as
  part of this feature. Expanding the researched field is a separate,
  future `research.md`-driving decision, not scope creep for a
  documentation task.
- This document is a new `references/*.md` reference artifact (like
  `references/genuine-contributions-log.md` and
  `references/harness-capability-notes.md`, both shipped earlier this
  session), not a new `specjedi-*` product skill — it ships no executable
  behavior and needs no install-path/harness-compatibility considerations
  of its own.
- "Grounded in existing research" means the document may reorganize,
  summarize, and tabulate claims `research.md` already makes — it does
  not require re-verifying each competitor's current state via fresh
  WebSearch, since `research.md` itself is the authoritative, already-
  cited source of record for this project's Principle II compliance.
