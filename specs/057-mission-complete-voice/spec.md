# Feature Specification: A Distinct "Mission Complete" Closing Voice

**Feature Branch**: `057-mission-complete-voice`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "todas as jedi skills devem ser proativas
ao ponto de dizer o proximo passo caso exista ou terminar dizendo algo
inpiracional baseado em Star Wars falando que chegou no fim" (every
Spec Jedi skill should be proactive enough to state the next step when
one exists, or otherwise close with something inspirational, Star-Wars-
based, marking that it has reached the end).

Grounding read before drafting: Constitution Principle XIV already
mandates the first half of this request completely — "MUST NOT end an
interaction by leaving the user to guess what happens next... offer the
next step(s) as a short, selectable bulleted list" at every meaningful
stopping point. Principle XII already names "celebratory moments" as one
of six trigger types requiring genuine Star Wars voice. What's genuinely
missing, confirmed by scanning the catalog for any existing "nothing
left to suggest" convention: **no skill has a concrete, checkable
trigger condition for when a closing moment counts as "reached the end"
specifically**, distinct from a routine successful step — today,
`specjedi-skill-review`'s own "clean pass" moment, for example, closes
with plain functional text ("no action needed"), not an inspirational
line, and no skill anywhere defines when exactly a moment has truly
exhausted its own scope versus merely completed one more step with
another step still ahead.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A skill that has genuinely run out of next steps says so with real weight, not silence or dry text (Priority: P1)

A user finishes an interaction with a `specjedi-*` skill and, when that
skill's own scope is genuinely, verifiably exhausted (a clean audit pass
with zero findings, an eligibility check confirming there's truly
nothing further required, a fully-merged feature with no follow-up this
skill itself would suggest) — rather than a plain "no action needed" or
silence — the skill closes with a genuine, Star-Wars-flavored,
inspirational line marking that this arc has reached its end.

**Why this priority**: This is the entire literally-new value here —
Principle XIV already covers "say the next step when one exists";
Principle XII already requires Star Wars voice at celebratory moments in
general. What's missing is the concrete trigger and shape for this
*specific* moment, not a duplicate of either existing rule.

**Independent Test**: Given a skill run that ends in a genuinely
exhausted state (e.g. a clean audit pass), when the skill closes, then
its final line is a genuine Star-Wars-flavored inspirational statement
marking the end — not a bare status word, and not a next-step bulleted
list (since none genuinely applies).

**Acceptance Scenarios**:

1. **Given** a skill run where every dimension checked comes back clean
   (e.g. `specjedi-skill-review`'s own clean-pass case), **When** it
   closes, **Then** the closing includes a genuine, specific Star Wars
   reference marking the moment as concluded — never a generic
   "no action needed" standing alone.
2. **Given** a skill run where a genuine next step actually exists
   (the common case), **When** it closes, **Then** it uses today's
   existing Principle XIV bulleted next-step list exactly as before —
   this feature never replaces that with an inspirational line when
   real work remains.
3. **Given** a skill run that's ambiguous about whether more work
   remains (e.g. mid-pipeline, one stage done but a natural next stage
   clearly exists), **When** it closes, **Then** it uses the next-step
   list, never the inspirational closing — the closing is reserved for
   a *verifiably* exhausted scope, not a vague feeling of completion.

---

### User Story 2 - This applies consistently across the catalog, not a pilot few skills (Priority: P2)

A maintainer doesn't want this to depend on which specific skill they
happen to run — every `specjedi-*` skill with a genuine "nothing left in
my own scope" case should follow the same trigger condition and closing
convention, not a subset that got updated and a remainder that didn't.

**Why this priority**: P2 — a consistency pass on top of User Story 1's
mechanism, matching this project's own established pattern for
catalog-wide conventions (features 049, 051's own User Story 2s).

**Independent Test**: Sample at least one skill with a genuine
"exhausted scope" case from each applicable discipline (e.g.
`specjedi-skill-review`/`specjedi-catalog-audit`/`specjedi-constitution-
audit` from Quality & Review; `specjedi-quick` from Meta & Tooling) and
confirm each follows the same trigger condition and closing shape.

**Acceptance Scenarios**:

1. **Given** the full currently-shipped `specjedi-*` catalog, **When**
   each skill's own closing-moment text is checked, **Then** every skill
   with a genuine exhausted-scope case in its own logic follows the same
   trigger condition and closing convention — none silently left on
   today's plain text while others were updated.

### Edge Cases

- **What if a skill never has a genuine "exhausted scope" case at all**
  (e.g. `specjedi-explain`, which always has something more to explain
  or a next concept to offer)? Not every skill needs this convention —
  only those whose own logic can genuinely reach a verifiably-exhausted
  state; a skill without one is simply out of this feature's own scope,
  not a gap.
- **What if a skill's scope is exhausted but the wider project clearly
  isn't** (e.g. one feature's implementation finishes and merges, but
  other features remain in flight)? The closing line marks that this
  skill's own arc/interaction has concluded — it MUST NOT be read or
  phrased as a claim that the entire project is done, per Constitution
  Principle XX (grounded, honest output).
- **What if the inspirational line and the plain status word would say
  the same thing twice** (e.g. "clean pass" plus a redundant "nothing
  left" reference)? See Assumptions — Principle XII's own existing
  "English-only wordplay MUST be paired with a plain-language
  equivalent" pattern already resolves this: the plain status stays as
  the precise, substantive statement; the Star Wars line is additive
  flavor confirming the same fact, not a replacement for it.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A concrete, checkable trigger condition MUST define when a
  skill's own closing moment counts as "genuinely nothing left to
  suggest" — grounded in that specific skill's own actual scope (a
  clean audit pass, a satisfied eligibility check, a fully-completed and
  merged feature) — never a vague, generic sense of completion.
- **FR-002**: When that trigger fires, the skill's own closing text MUST
  include a genuine, specific Star-Wars-flavored inspirational line
  (Constitution Principle XII), reusing `references/star-wars-
  lexicon.md`'s existing reference pool — never a new, separate lexicon.
- **FR-003**: This closing line MUST NEVER fire when a genuine next step
  actually exists, or when the exhausted-scope determination is
  ambiguous rather than verified — Constitution Principle XX (grounded,
  honest output) takes precedence over a dramatic close; a skill MUST
  NOT fabricate a "reached the end" moment.
- **FR-004**: The closing line MUST be scoped honestly to the skill's own
  arc/interaction — it MUST NOT be phrased as a claim that an entire
  project or feature (beyond this one skill's own scope) is complete
  when it isn't.
- **FR-005**: This convention MUST apply consistently across every
  currently-shipped `specjedi-*` skill that has a genuine exhausted-scope
  case in its own logic — not a subset (User Story 2); a skill with no
  such case in its own logic is correctly out of scope, not a gap.

### Key Entities

*(Not applicable — this feature adds a closing-moment convention to
existing skill narration; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every applicable skill's genuinely-exhausted-scope case
  closes with a specific Star Wars reference marking the end — never a
  bare status word standing alone — verifiable by inspecting that
  skill's own closing text.
- **SC-002**: Zero instances of the inspirational closing line appearing
  when a genuine next step actually exists — verifiable by confirming
  every such run still shows today's existing Principle XIV bulleted
  list instead.
- **SC-003**: Zero instances of the closing line's phrasing implying an
  entire project or feature (beyond the one skill's own scope) is
  complete when it isn't — verifiable by reviewing the closing text's
  own wording against what actually finished.

## Assumptions

- Matching Principle XII's own existing "English-only wordplay MUST be
  paired with a plain-language equivalent, never used alone" rule, the
  inspirational closing line is additive to (never a replacement for)
  the plain, precise status statement a skill already produces (e.g.
  "clean pass") — resolved via this existing precedent rather than a
  fresh ambiguity.
- Whether this ships as new text duplicated per-skill or as a shared
  reference convention every applicable skill points to is a technical
  decision resolved during planning — matching this project's own
  established "new mechanism vs. per-skill duplication" precedent
  (specs/043, 049, 050, 052, 056).
- Not every `specjedi-*` skill needs this convention — only those whose
  own logic can reach a genuinely, verifiably exhausted state; which
  specific skills qualify is enumerated during planning by reading each
  skill's own actual closing-moment logic, not assumed from its name.
