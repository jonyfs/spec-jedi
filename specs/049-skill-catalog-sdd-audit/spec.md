# Feature Specification: `specjedi-*` Skill Catalog Completeness & SDD Coverage Audit

**Feature Branch**: `049-skill-catalog-sdd-audit`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "revise suas próprias skills para ver se
estão OK completas e atende SDD" (review your own skills to see if
they're OK, complete, and satisfy SDD). Interpreted concretely: with
`speckit-*` now fully removed (specs/048) and this project's own
development running entirely on its 27 shipped `specjedi-*` skills, a
maintainer wants a repeatable way to confirm — with evidence, not
impression — that (a) the skill catalog as a whole still genuinely
implements Spec-Driven Development end-to-end, with no missing stage
now that there's no vendored `speckit-*` reference left to compare
against, and (b) every individual skill still meets this project's own
authoring standard.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Confirm the skill catalog still covers all of SDD, with no vendored fallback left (Priority: P1)

A maintainer wants to know, with evidence, whether the 27 shipped
`specjedi-*` skills still cover every core Spec-Driven Development
activity end-to-end — now that `speckit-*` (the last thing this project
could ever fall back to, or compare itself against) has been fully
removed. If a core SDD stage were silently missing a real skill behind
it, this project's own development would have no way to execute that
stage at all.

**Why this priority**: This is the single most critical question the
whole request is really asking. Every other check (individual skill
quality, redundancy) is secondary to "does the pipeline as a whole
still actually work end-to-end."

**Independent Test**: Cross-reference `references/what-is-sdd.md`'s own
stated phase sequence (establish rules, specify, clarify, plan, break
into tasks, implement, verify) against the current skill catalog;
confirm each phase has at least one real, shipped skill behind it, or
report the specific phase that doesn't.

**Acceptance Scenarios**:

1. **Given** the current 27-skill catalog, **When** each of
   `references/what-is-sdd.md`'s 7 phase-sequence activities is
   checked, **Then** every one resolves to a real, named, shipped
   `specjedi-*` skill — no phase left without a corresponding skill.
2. **Given** a phase that turns out to have no corresponding skill,
   **When** this is reported, **Then** it's named as a concrete
   coverage gap with the specific missing capability — never a vague
   "something might be missing."
3. **Given** `speckit-*` no longer exists in this project (specs/048),
   **When** SDD coverage is judged, **Then** it's judged against
   `references/what-is-sdd.md`'s own definition directly — never
   against a vendored tool that isn't there anymore to compare to.

---

### User Story 2 - Confirm every individual skill still meets this project's own authoring standard (Priority: P2)

A maintainer wants every one of the 27 `specjedi-*` skills individually
checked against `references/skill-authoring-standard.md` (Constitution
Principle XIX) — the same structural, content, voice, and token-budget
checks `specjedi-skill-review` already performs one skill at a time —
applied across the whole catalog at once, so a maintainer doesn't have
to remember to invoke it separately against all 27.

**Why this priority**: P2 — this is the "individually complete" half of
the request. It depends on knowing which skills exist (User Story 1's
catalog enumeration) but is otherwise independently checkable per
skill, using an already-proven methodology rather than a new one.

**Independent Test**: Run the same structural/content/voice/token-
budget check `specjedi-skill-review` already performs against a single
skill, across all 27; confirm a per-skill PASS/finding table results,
with no skill silently skipped.

**Acceptance Scenarios**:

1. **Given** the 27-skill catalog, **When** each skill is checked
   individually, **Then** every skill appears in the report with an
   explicit PASS or a named finding — none omitted.
2. **Given** a skill with a documented, legitimate exemption in its own
   matching `specs/NNN-<skill-name>/plan.md` (the precedent
   `specjedi-skill-review` already established for
   `specjedi-status`/`specjedi-diagram`), **When** that skill is
   checked, **Then** the exemption is honored — never flagged as a
   false finding.

---

### User Story 3 - One report that tells the two kinds of gap apart (Priority: P3)

A maintainer reading the combined output needs to immediately tell
"the skill *set* is missing something" (User Story 1) apart from "one
*specific* skill has a quality problem" (User Story 2) apart from "two
or more skills do the same job" (a third, distinct class — redundancy)
— because each of the three demands a different fix (build a new
skill, fix an existing skill's own text, or consolidate/document an
intentional overlap).

**Why this priority**: P3 — the synthesis layer. Valuable, but it only
has something to synthesize once User Story 1 and User Story 2's own
findings actually exist.

**Independent Test**: Given a report containing at least one finding of
each kind, confirm each finding states which of the three categories it
belongs to, and that the stated category matches what the finding
actually describes.

**Acceptance Scenarios**:

1. **Given** the combined report, **When** any finding is read,
   **Then** it's labeled exactly one of: SDD-Coverage Gap,
   Skill-Quality Finding, or Redundancy — never left uncategorized.
2. **Given** two skills that appear to overlap (e.g., a full-ceremony
   path and a lightweight path for the same general activity), **When**
   this is evaluated, **Then** an already-documented, deliberate design
   split (like `specjedi-implement` vs. `specjedi-quick`, specs/028) is
   recognized as such and not reported as a Redundancy finding.

### Edge Cases

- **What if one SDD phase is deliberately covered by more than one
  skill at different weight classes** (e.g., `specjedi-implement` for
  full ceremony, `specjedi-quick` for small changes)? Not a coverage
  gap and not a redundancy — an already-documented, deliberate design
  choice (specs/028); recognized as Covered, not flagged either way.
- **What if a skill is genuinely redundant with another** (two skills
  solving the identical problem with no documented reason for both)?
  Reported as a Redundancy finding, distinct from both other
  categories, naming both skills and the overlapping capability.
- **What if a skill has a documented chain-of-thought exemption in its
  own `plan.md`** (the existing `specjedi-status`/`specjedi-diagram`
  precedent)? Honored, not flagged as a Skill-Quality finding — same
  discipline `specjedi-skill-review` already applies one skill at a
  time.
- **What happens when a new, 28th skill ships later?** The same checks
  apply to it structurally — this capability is sized to "however many
  skills currently exist," not hardcoded to 27, so a re-run after any
  future skill ships produces an updated report without needing a
  redesign.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The audit MUST enumerate every currently-shipped
  `specjedi-*` skill (27 as of this writing) and classify each into its
  discipline (Core Pipeline, Onboarding & Guidance, Quality & Review,
  Meta & Tooling — the categories already established in
  `references/quickstart-guide.md`'s own catalog).
- **FR-002**: The audit MUST cross-check every core SDD activity stated
  in `references/what-is-sdd.md`'s own phase sequence against the
  current skill catalog, and report any activity with no corresponding
  shipped skill as an SDD-Coverage Gap finding.
- **FR-003**: The audit MUST apply `specjedi-skill-review`'s own
  existing structural/content/voice/token-budget checks to every one of
  the 27 skills individually, producing a per-skill PASS/finding
  table — reusing that methodology, never re-implementing a second
  version of it.
- **FR-004**: Every finding MUST be classified into exactly one of
  three categories — SDD-Coverage Gap, Skill-Quality Finding, or
  Redundancy — never left uncategorized.
- **FR-005**: The audit MUST cross-reference each skill's own matching
  `specs/NNN-<skill-name>/plan.md` before reporting a chain-of-thought
  or exemption-shaped finding, matching `specjedi-skill-review`'s own
  established discipline — never flag a documented, legitimate
  exemption as a gap.
- **FR-006**: The audit MUST be re-runnable as the skill catalog grows
  — not a one-time, throwaway analysis — since this project's own
  skill count has already grown (25 → 27) since the last time a
  catalog-wide review happened.
- **FR-007**: The audit MUST NOT judge SDD coverage by comparing
  against `speckit-*` — that comparison point no longer exists
  (specs/048) — coverage is judged directly against
  `references/what-is-sdd.md`'s own stated definition instead.
- **FR-008**: The audit MUST NOT report an already-documented,
  deliberate multi-skill design split for the same SDD phase (e.g.,
  `specjedi-implement`/`specjedi-quick`) as either a coverage gap or a
  redundancy finding.

### Key Entities

*(Not applicable — this feature produces a report from existing
skill/spec artifacts; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every one of the 27 currently-shipped `specjedi-*` skills
  appears in the report with an explicit PASS/finding classification —
  none silently omitted.
- **SC-002**: Every core SDD activity named in
  `references/what-is-sdd.md`'s phase sequence has a stated
  disposition (Covered, with the specific skill named; or Gap, named
  explicitly) — verifiable by cross-referencing the report against that
  document directly.
- **SC-003**: Zero findings are misclassified across the three
  categories (SDD-Coverage Gap / Skill-Quality Finding / Redundancy) —
  verifiable by checking each finding's stated category against its own
  described problem.
- **SC-004**: A re-run after a hypothetical new skill ships produces an
  updated report reflecting the new catalog size, without requiring the
  capability itself to be redesigned — verifiable by construction (the
  check applies structurally to however many skills exist, not
  hardcoded to today's count).

## Assumptions

- Scope is the 27 currently-shipped `specjedi-*` skills only —
  `speckit-*` no longer exists in this project (specs/048) and is not
  back in scope here, and no third-party/vendored skill outside this
  project's own `specjedi-*` namespace is included.
- This capability is built as a durable, repeatable addition to the
  `specjedi-*` pipeline — matching this project's own established
  pattern for every prior meta-capability (`specjedi-skill-review`,
  `specjedi-constitution-audit`, `specjedi-govcheck`) — not a one-time,
  undocumented analysis, since the request was made through the formal
  `/specjedi-specify` pipeline rather than as an ad-hoc question.
- Whether this ships as a new, distinct skill or as an extended mode of
  an existing skill (most plausibly `specjedi-skill-review`, given
  FR-003's direct reuse of its methodology) is a technical design
  decision, resolved during planning — matching this project's own
  precedent for exactly this kind of "extend vs. create new" question
  (specs/043's Decision 1; specs/045's Decisions 1/4/5/6).
- "Atende SDD" (satisfies SDD) is measured against this project's own
  existing definition of Spec-Driven Development
  (`references/what-is-sdd.md`), not against any external tool's own
  feature set.
