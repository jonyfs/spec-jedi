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

### Amendment 1 (same session, following re-invocation with one added instruction)

- Q: Given FR-006's "dial back to third-person" resolution, should the
  literal opening line "**A letter, from one Master to whoever picks up
  this scroll next:**" (feature 036) be dropped along with the rest of
  the sustained personal narrator, or kept? → A: Kept, explicitly, per
  direct user instruction — but scoped narrowly: it stands alone as a
  single evocative opening hook (the same epigraph-style role the
  existing italic quote line already plays), not as the first line of a
  sustained first-person narrator. Everything else in FR-006's original
  resolution (dialing the body prose back to third-person) still holds.

### Amendment 2 (same session, following re-invocation clarifying FR-005's "consolidate" as "relocate, never delete")

- Q: Does the "How Spec Jedi builds itself, in comic form" section
  (feature 035's 8 illustrated panels) get relocated to extra docs too,
  or does it stay in the README, since it's already explicitly labeled
  as a separate internal-bootstrap aside? → A: Stays in the README —
  it's already self-contained and clearly marked as a separate aside,
  and removing a recently-commissioned, real illustrated feature from
  the homepage would be a bigger, likely-unintended side effect of a
  general instruction that wasn't really targeting it.
- Q: Where should the content FR-005 consolidates out of the README
  (skill catalog table, mindmap/pipeline diagrams, Quickstart's 23
  numbered steps, Recommended companions, Versioning & releases) go? →
  A: Split across purpose-fitting docs — the skill catalog/diagrams/
  Quickstart steps go into a new dedicated reference doc; Recommended
  companions and Versioning & releases each get a home in whichever
  existing or new reference doc best fits that topic (exact target
  file(s) decided during `/speckit-plan`, using `/brainstorming` per
  FR-005 — a "which specific file" decision belongs in planning, not
  the spec).
- Q: What happens to the two letter images (`letter-open.jpg`,
  `letter-path.jpg`) now that the surrounding letter body text is being
  dialed back/relocated? → A: `letter-open.jpg` stays in the README as
  the retained opening hook line's visual anchor; `letter-path.jpg`
  (tied to the now-relocated discipline passage) relocates with that
  content to wherever it lands.

### Amendment 3 (post-implementation, resolving `specjedi-checklist`'s voice-and-thematic-consistency findings against the shipped feature)

- Q (CHK-001/CHK-002): What checkable signal distinguishes the FR-001
  hook line as a single evocative epigraph from it being the opening of
  a sustained first-person narrator? → A: Positional and formatting
  identity with the existing italic epigraph quote — the hook line sits
  as its own bolded paragraph immediately after the opening image, and
  the sentence(s) immediately following it use third-person phrasing
  with no first-person pronoun ("I"/"me"/"my"/"we") anywhere else in the
  document. A reviewer can check this mechanically: grep the rendered
  README for first-person pronouns outside the hook line's own sentence;
  zero hits confirms the boundary held.
- Q (CHK-003/CHK-005): Which specific voice elements count as the
  "sustained first-person narrator conceit" FR-006 dials back, and does
  that include second-person ("you"/"your") address, not just
  first-person? → A: Yes — the conceit being dialed back is direct
  address in general (both first-person "I/we" narration and
  second-person "you" used as the narrator's rhetorical device, e.g.
  "Let me be straight with you," "I promise it's short") plus personal
  asides. It does NOT include plain third-person description of who a
  section's audience is (e.g., "anyone who wants X is the intended
  reader here") — that's compliant third-person phrasing, not direct
  address, and "Who this is for" is written entirely in this compliant
  form with zero first- or second-person pronouns.
- Q (CHK-004): What does "professional-but-informal" third-person voice
  mean beyond citing PR #100 as precedent? → A: Direct factual
  statements, contractions and informal connective tissue (em-dashes,
  parentheticals) permitted, no corporate boilerplate — but no narrator
  persona and no direct reader address used as a rhetorical device. The
  shipped "How Spec Jedi Implements SDD" and "Honest assessment"
  sections are the reference examples of this register.
- Q (CHK-006): Must each retained Star Wars reference cite which
  specific `star-wars-lexicon.md` entry it draws from, inline in the
  README's own prose? → A: No — traceability is required at the
  artifact-review level (a `specjedi-skill-review`/`specjedi-analyze`-
  style pass can cross-reference a given reference against the lexicon
  file), not as inline citations in the shipped prose, which would
  clutter it and contradict FR-006's own "decorative seasoning" framing.
- Q (CHK-007): Is SC-004's "at least one" Star Wars reference a floor or
  the intended final count? → A: A floor for acceptance testing, not a
  target to minimize toward. The actual shipped README retains more than
  one (the Jedi Code/discipline framing in "What Is Spec-Driven
  Development?", the lightsaber-free mentor callback in the comic
  section, "right side of the Force, mechanized" now living in
  `CONTRIBUTING.md` beside `letter-path.jpg`) — reducing further would
  need to still clear US3's "professional, not overwrought" bar on its
  own merits, not merely clear the SC-004 floor.
- Q (CHK-008): Does the "right side of the Force" framing tied to the
  relocated discipline passage need to also appear somewhere in
  `README.md` itself, or is its relocation to `CONTRIBUTING.md` (beside
  `letter-path.jpg`, per FR-010) sufficient? → A: Relocation to
  `CONTRIBUTING.md` alone is sufficient — it is not required to also
  appear in the README. SC-004's floor for the README itself is
  satisfied independently via the Jedi Code/discipline framing already
  present in "What Is Spec-Driven Development?" Duplicating the same
  metaphor in both files would work against FR-005's "fewer, more
  purposeful sections" consolidation goal. This supersedes the
  Assumptions section's earlier "re-expressed... as part of the
  restructured flow" phrasing, which read ambiguously as requiring the
  metaphor to reappear verbatim in the README — see the amended
  Assumptions entry below.
- Q (CHK-009): Does `CONTRIBUTING.md` need its own explicit Star-Wars-
  seasoning voice bar now that thematic content has crossed into it? →
  A: No — `CONTRIBUTING.md`'s own pre-existing default voice (plain,
  factual, third-person) is unchanged by this feature. The single
  relocated image and its one-line caption are the sole, explicitly
  scoped exception carrying thematic seasoning into that file; this is
  not a general loosening of `CONTRIBUTING.md`'s own voice convention.

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
  section? → Stays in the README as-is (Amendment 2, confirmed) — it is
  already explicitly labeled as a separate internal-bootstrap aside
  (Principle XV) rather than part of the home-page product narrative
  this feature restructures.
- What happens to the skill catalog table, the two Mermaid diagrams
  (skills mindmap, pipeline flowchart), and the 23 numbered Quickstart
  steps? → Relocated (never deleted) to a new dedicated reference doc
  per Amendment 2 — the README's own new flow (FR-001/FR-002) covers
  the SDD-primer/specjedi-mapping content at a conceptual level; the
  full step-by-step walkthrough and complete skill catalog move to
  where a reader wanting that depth can still find all of it.
- What if condensing a reference document's summary would require
  dropping a caveat to keep it short? → Never — per FR-004, a
  shortened summary MUST preserve every genuine caveat/limitation the
  source states, even if that means the summary runs slightly longer
  than an idealized "one paragraph" target.
- What happens to "Recommended companions" and "Versioning & releases"?
  → Relocated (never deleted) per Amendment 2, each to whichever
  existing or new reference doc best fits its own topic — the specific
  target file(s) are a planning-phase decision (`/speckit-plan`, via
  `/brainstorming` per FR-005), not fixed in this spec.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The README MUST present a condensed summary of
  `references/what-is-sdd.md` (the general SDD practice, no
  Spec-Jedi-specific branding) before any Spec-Jedi-specific claim. The
  document MUST open with the line "**A letter, from one Master to
  whoever picks up this scroll next:**" (feature 036) retained verbatim
  as a single evocative hook, positioned the same way the existing
  italic epigraph quote already functions — not as the opening of a
  sustained first-person narrator (Amendment, Session 2026-07-14).
  Checkable boundary (Amendment 3): the hook line stands as its own
  bolded paragraph immediately after the opening image, and no
  first-person pronoun ("I"/"me"/"my"/"we") appears anywhere else in the
  document.
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
  2026-07-14). "Consolidates" MUST mean relocated, never deleted — see
  FR-009 (Amendment 2).
- **FR-006**: The README MUST read as professional and well-organized,
  dialing back feature 036's first-person "letter" conceit (direct
  address, "I/you" narrator, personal asides) toward the standard
  third-person, professional-but-informal voice PR #100 established —
  while retaining Star Wars-themed references that specifically pun on
  or illuminate an SDD concept as decorative seasoning (quotes, emoji,
  brief thematic asides), drawn from
  `references/star-wars-lexicon.md`'s curated pool, never invented
  ad hoc (Clarifications, Session 2026-07-14). The single exception is
  FR-001's retained opening hook line — everything else in the body
  prose dials back to third-person (Amendment, Session 2026-07-14). The
  conceit being dialed back covers both first-person ("I/we") narration
  and second-person ("you") used as a rhetorical narrator device —
  plain third-person description of a section's audience (e.g. "anyone
  who wants X is the intended reader here") is compliant, not an
  exception (Amendment 3). Lexicon traceability for any retained
  reference is required at the artifact-review level, not as inline
  citations in the shipped prose (Amendment 3, CHK-006).
- **FR-007**: The "Contributing" and "License" sections MUST remain the
  final two sections of the README, in that order.
- **FR-008**: Every fact, badge, link, table row, code block, and
  install/release command currently accurate in `README.md` MUST remain
  present and accurate — either still in the README, or relocated to
  its new home per FR-009 — after this restructure. Reorganizing,
  condensing, and relocating changes structure and location, never
  facts, and never deletes content outright.
- **FR-009**: Content consolidated out of the README by FR-005 (the
  skill catalog table, both Mermaid diagrams — skills mindmap and
  pipeline flowchart —, the 23 numbered Quickstart steps, "Recommended
  companions," and "Versioning & releases") MUST be relocated, in full,
  into existing or new reference documentation — split across
  whichever doc(s) best fit each piece's own topic, not dumped into one
  undifferentiated file — never simply deleted (Amendment 2, Session
  2026-07-14). The "How Spec Jedi builds itself, in comic form" section
  is explicitly out of scope for relocation — it stays in the README
  (Amendment 2).
- **FR-010**: `letter-open.jpg` (feature 036) MUST remain in the README
  as the retained opening hook line's (FR-001) visual anchor.
  `letter-path.jpg` MUST relocate together with the discipline-passage
  content it illustrated, to wherever that content lands per FR-009
  (Amendment 2, Session 2026-07-14). The relocated discipline framing
  (e.g. "right side of the Force, mechanized") is NOT required to also
  reappear in `README.md` itself — relocating it alongside
  `letter-path.jpg` is sufficient (Amendment 3, CHK-008). The
  destination file's own pre-existing default voice is otherwise
  unchanged by this relocation; the relocated image and its caption are
  the sole scoped exception (Amendment 3, CHK-009).

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
  commands, harness table) is lost relative to today's README,
  verifiable by the same fact-preservation check used in the two prior
  README features this session (badge/table/code-block counts).
- **SC-004**: A reader can identify at least one Star Wars reference
  tied to a specific SDD concept still present in the final document.
  This is a floor for acceptance testing, not a target to minimize
  toward — the shipped document may (and does) retain more than one
  (Amendment 3, CHK-007).
- **SC-005**: Every piece of content FR-009 relocates (skill catalog,
  both diagrams, all 23 Quickstart steps, Recommended companions,
  Versioning & releases) is verifiably present, in full, somewhere in
  the project's documentation after this feature ships — checkable by
  confirming each item's real content (not just a stub or a "see X"
  pointer) exists in its new home.

## Assumptions

- Scope is primarily `README.md`, plus whichever reference doc(s)
  FR-009 relocates content into — this feature touches more than one
  file by design, not a README-only change. The already-shipped comic
  section (feature 035) is kept in the README as-is (Amendment 2).
  Feature 036's first-person letter conceit is intentionally dialed
  back per the resolved Clarifications (FR-006), with one explicit
  exception: the opening line "A letter, from one Master to whoever
  picks up this scroll next:" is kept verbatim as a single evocative
  hook, paired with `letter-open.jpg` (FR-010). The underlying facts/
  ideas the rest of the letter prose carried are preserved, not deleted
  — only the sustained personal-narrator conceit itself goes, apart from
  that one retained opening line. Specifically: the constitution's role
  is re-expressed in third-person voice within the new SDD-primer
  sections of the README itself; the discipline-as-"right side of the
  Force" framing relocates to `CONTRIBUTING.md` alongside
  `letter-path.jpg` (FR-010) rather than being duplicated back into the
  README — this is a deliberate resolution, not an open question
  (Amendment 3, CHK-008).
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
