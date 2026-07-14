# Feature Specification: Restructure README as an SDD Primer With a Professional-But-Themed Voice

**Feature Branch**: `037-readme-professional-restructure`

**Created**: 2026-07-14

**Status**: Draft

**Input**: User description: "refaça o README.md ajustando para usar
references/what-is-sdd.md e logo em seguida apresentar
references/specjedi-and-sdd.md, depois fale de como fazer a instalacao,
references/honest-assessment.md, references/harness-capability-notes.md
tudo de forma resumida na pagina inicial, use /brainstorming para
organizar o README.md para que fique profissional mas sem perter as
referencias interessantes sobre Star Wars que podem ter trocadilhos com
SDD e references/star-wars-lexicon.md, no final mantenha a seçao
Contributing e license" (rework README.md to lead with a summary of
what-is-sdd.md, then present specjedi-and-sdd.md, then cover
installation, then summarize honest-assessment.md and
harness-capability-notes.md — all condensed on the home page. Use
`/brainstorming` to organize the README so it reads as professional
without losing the Star Wars references that pun on SDD concepts, per
star-wars-lexicon.md. Keep Contributing and License at the end.)

## Clarifications

### Session 2026-07-14

- Q: Should the new SDD-primer-first structure REPLACE today's existing
  sections by folding their substance into the new flow, or INSERT the
  new anchors around those sections, keeping all of them intact but
  reordered? → A: Replace & consolidate — fold existing sections'
  substance into the new SDD-primer → specjedi-mapping → install →
  honest-summary flow, fewer and more purposeful sections.
- Q: Does "professional" mean dialing back feature 036's first-person
  "letter" conceit toward a standard third-person product-document
  voice, or keeping the letter's voice intact and only tightening
  organization? → A: Dial back to third-person, thematic seasoning —
  drop the sustained personal narrator, write in the same
  professional-but-informal third-person voice PR #100 established,
  Star Wars references as decorative flavor.
- Q: How condensed should the honest-assessment.md and
  harness-capability-notes.md summaries be? → A: Short teaser + link —
  2-4 sentences per document (one real advantage, one real limitation),
  matching today's existing link-out pattern.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A reader learns what SDD is before being asked to adopt a tool for it (Priority: P1)

A visitor who has never heard of Spec-Driven Development lands on the
README and, before anything else asks them to install or trust
anything, gets a condensed, honest explanation of what SDD actually is
and the problem it solves — then immediately sees how Spec Jedi's own
skills implement that practice specifically, so the general concept and
the concrete product are connected in one continuous read rather than
requiring two separate page visits.

**Why this priority**: This is the structural core of the request — SDD
literacy has to come first, or every claim that follows ("genuine
competitor," "20 harnesses supported") has no grounding for a reader who
doesn't yet know what problem any of it solves.

**Independent Test**: Read the README from the top; confirm a condensed
what-is-SDD explanation appears before the specjedi-specific mapping,
and confirm the specjedi-specific mapping appears before any
installation instructions.

**Acceptance Scenarios**:

1. **Given** the restructured README, **When** a reader with zero SDD
   background reads from the top, **Then** they encounter a condensed
   explanation of SDD's core problem/practice before any Spec-Jedi-
   specific claim.
2. **Given** that same reader continuing down the page, **When** they
   reach the specjedi-specific section, **Then** it explicitly maps SDD
   activities to real, currently-shipped `specjedi-*` skills — the same
   grounding bar `references/specjedi-and-sdd.md` already holds itself
   to.

---

### User Story 2 - A reader gets an honest, self-aware summary without leaving the page (Priority: P1)

A reader evaluating whether to adopt Spec Jedi gets a condensed,
genuinely honest summary of real advantages, real current limitations,
and the actual grounding behind the harness-compatibility claims —
inline on the home page, not gated behind a click-through to a separate
document — while the full, unabridged versions remain linked for anyone
who wants the complete picture.

**Why this priority**: Equal to US1 — the whole reason
`honest-assessment.md` and `harness-capability-notes.md` exist is
candor; summarizing them on the home page only has value if the summary
stays genuinely honest, not marketing-flavored, and if it doesn't quietly
drop the caveats that make the original documents credible.

**Independent Test**: Read the summarized sections; confirm each real
limitation/caveat from the source documents (not just the advantages)
survives into the condensed version, and confirm a link to the full
document is present for depth.

**Acceptance Scenarios**:

1. **Given** the condensed honest-assessment summary, **When** it is
   read, **Then** at least one genuine current limitation (not just an
   advantage) is stated plainly, matching the source document's own
   candor standard.
2. **Given** the condensed harness-capability-notes summary, **When** it
   is read, **Then** it states plainly that most harness install paths
   are desk-research-grounded rather than hands-on-verified — the exact
   caveat the source document itself leads with — not silently omitted
   for a cleaner-sounding pitch.

---

### User Story 3 - The README reads as professional while keeping its Star Wars-themed personality (Priority: P2)

A reader forms a professional first impression of the project — the
document reads as credible, organized, and not overwrought — while the
established Star Wars-themed references that pun specifically on SDD
concepts (per `references/star-wars-lexicon.md`'s own curated pool)
remain present as seasoning, not removed wholesale.

**Why this priority**: Lower than US1/US2 — this is a voice/organization
quality bar layered on top of the structural and content work above,
not a separate structural requirement; a well-organized, content-
complete README still delivers most of the value even if this bar isn't
hit perfectly on the first pass.

**Independent Test**: A reader can point to the README's overall
organization as clear and professional, and can also point to at least
one Star Wars-themed reference that specifically puns on an SDD concept
(not a generic aside) still present in the final document.

**Acceptance Scenarios**:

1. **Given** the restructured README, **When** a new reader skims its
   headings and structure, **Then** it reads as an organized, credible
   product document, not a stream-of-consciousness narrative.
2. **Given** that same README, **When** read for tone, **Then** at least
   one Star Wars reference tied specifically to an SDD concept (e.g.,
   the Jedi Code ↔ the constitution, the Force's light/dark side ↔
   disciplined practice vs. shortcuts) is still present, drawn from
   `references/star-wars-lexicon.md`'s own curated pool rather than
   invented ad hoc.

### Edge Cases

- What happens to the "How Spec Jedi builds itself, in comic form"
  section? → Not named in this request; kept as-is, since it is already
  explicitly labeled as a separate internal-bootstrap aside (Principle
  XV) rather than part of the home-page product narrative this feature
  restructures.
- What happens to the skill catalog table and the numbered Quickstart
  steps? → Not named for removal; kept, repositioned within the new flow
  as the concrete "here's what you actually get / how you actually use
  it" continuation of the specjedi-and-sdd mapping (User Story 1),
  rather than deleted.
- What if condensing a reference document's summary would require
  dropping a caveat to keep it short? → Never — per FR-004, a
  shortened summary MUST preserve every genuine caveat/limitation the
  source states, even if that means the summary runs slightly longer
  than an idealized "one paragraph" target.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The README MUST present a condensed summary of
  `references/what-is-sdd.md` (the general SDD practice, no
  Spec-Jedi-specific branding) before any Spec-Jedi-specific claim.
- **FR-002**: Immediately following that summary, the README MUST
  present a condensed summary of `references/specjedi-and-sdd.md`
  (mapping SDD activities to real, shipped `specjedi-*` skills) before
  any installation instructions.
- **FR-003**: Installation instructions (prerequisites, install
  commands, supported-harness list) MUST follow the SDD-primer content,
  functionally unchanged from what's shipped today.
- **FR-004**: The README MUST include a condensed summary of
  `references/honest-assessment.md` and a condensed summary of
  `references/harness-capability-notes.md` — a short teaser (2-4
  sentences per document: one real advantage, one real limitation),
  matching today's existing link-out pattern — each preserving at least
  one genuine limitation/caveat from its source document, never a
  purely positive digest, with a link to the full document for depth
  (Clarifications, Session 2026-07-14).
- **FR-005**: The README's overall organization MUST be produced using
  the `/brainstorming` process to explore structural options before
  committing to a final layout. The new SDD-primer-first structure
  REPLACES and consolidates today's existing sections (the letter
  opening, "Who this is for," "What you get today," Quickstart,
  Recommended companions, Versioning) by folding their substance into
  the new flow — fewer, more purposeful sections, not new anchors
  layered around six pre-existing ones (Clarifications, Session
  2026-07-14).
- **FR-006**: The README MUST read as professional and well-organized,
  dialing back feature 036's first-person "letter" conceit (direct
  address, "I/you" narrator, personal asides) toward the standard
  third-person, professional-but-informal voice PR #100 established —
  while retaining Star Wars-themed references that specifically pun on
  or illuminate an SDD concept as decorative seasoning (quotes, emoji,
  brief thematic asides), drawn from
  `references/star-wars-lexicon.md`'s curated pool, never invented
  ad hoc (Clarifications, Session 2026-07-14).
- **FR-007**: The "Contributing" and "License" sections MUST remain the
  final two sections of the README, in that order.
- **FR-008**: Every fact, badge, link, table row, code block, and
  install/release command currently accurate in `README.md` MUST remain
  present and accurate after this restructure — reorganizing and
  condensing changes structure and voice, never facts.

### Key Entities

*(Not applicable — this feature reorganizes and condenses existing
documentation content; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A reader with no prior SDD knowledge encounters a
  condensed SDD explanation, then a Spec-Jedi-specific mapping, before
  reaching any installation instruction — verifiable by reading order
  alone.
- **SC-002**: The condensed honest-assessment and harness-capability
  summaries each retain at least one genuine limitation from their
  source document, verifiable by cross-referencing the summary against
  the source.
- **SC-003**: Zero functional or reference content (badges, install
  commands, harness table, skill catalog) is lost relative to today's
  README, verifiable by the same fact-preservation check used in the
  two prior README features this session (badge/table/code-block
  counts).
- **SC-004**: A reader can identify at least one Star Wars reference
  tied to a specific SDD concept still present in the final document.

## Assumptions

- Scope is `README.md` only. The already-shipped comic section
  (feature 035) is kept as-is per its own Edge Case above. Feature 036's
  first-person letter conceit is intentionally dialed back per the
  resolved Clarifications (FR-006) — its two new images
  (`letter-open.jpg`, `letter-path.jpg`) and the underlying facts/ideas
  they and the letter prose carried (the constitution's role, the
  discipline-as-"right side of the Force" framing) are preserved and
  re-expressed in the new third-person voice, not deleted outright; only
  the sustained personal-narrator conceit itself goes.
- "Resumido" (condensed/summarized) means genuinely new, shorter prose
  written for the README's own flow — not simply copy-pasting each
  source document's full text inline.
- The full, unabridged reference documents (`what-is-sdd.md`,
  `specjedi-and-sdd.md`, `honest-assessment.md`,
  `harness-capability-notes.md`) remain the authoritative, complete
  versions; the README's own condensed versions always link back to
  them for depth, per this project's existing pattern.
- `/brainstorming` (FR-005) is used during the planning phase to
  explore structural/ordering options for the README before committing
  to one — its output informs `plan.md`'s own structural decision, it
  does not replace the standard `/speckit-plan` artifact.
