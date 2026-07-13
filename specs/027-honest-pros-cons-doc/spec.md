# Feature Specification: Honest Advantages/Disadvantages Assessment for Spec Jedi Skills

**Feature Branch**: `027-honest-pros-cons-doc`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description (Portuguese): "crie uma documentacao
informando ao usuário quais são as vantagens e desvantagens de usar a
specjedi skills, seja bem sincero e busque nos concorrentes para
entender quais seriam os futuros pontos de melhoria para aumentar a
qualide das skills specjedi" (Create documentation telling the user the
advantages and disadvantages of using specjedi skills, be very honest,
and look at competitors to understand what the future improvement points
would be to raise specjedi skills' quality.)

## Problem

Today, a prospective user has no single, candid document answering "why
would/wouldn't I use this." `references/competitive-comparison.md`
(feature 014) is close but answers a different question: a per-tool
adopted/rejected-mechanism table, written from this project's own design
rationale, not an outward-facing "here's where we're genuinely weaker
than the field" assessment. `references/genuine-contributions-log.md`
only tracks claimed strengths, never limitations. No existing document
does what the user is asking for: an honest pros/cons page plus a
competitor-grounded forward-looking improvement list.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A prospective user reads genuine, verifiable advantages (Priority: P1)

A developer evaluating whether to adopt Spec Jedi wants to know what it
actually does well — grounded in real, shipped mechanisms, not
aspirational marketing claims — so they can judge fit for their own
project.

**Why this priority**: The baseline half of "vantagens e desvantagens"
the user explicitly asked for; without this, the doc reads as pure
criticism with no context for why anyone would use the tool at all.

**Independent Test**: Read the advantages section and independently
verify each claim against something checkable in this repo (a shipped
file, a passing CI job, a `references/principle-traceability.md` ✅ row) —
every claim should be confirmable without trusting the doc's own prose.

**Acceptance Scenarios**:

1. **Given** the published document, **When** a reader checks any listed
   advantage, **Then** it cites a specific, currently-shipped mechanism
   (not a planned/aspirational one) verifiable in this repository.
2. **Given** an advantage that's only partially true (e.g., "supports 20
   harnesses" when several are desk-research-grounded rather than
   hands-on-tested per `references/harness-capability-notes.md`),
   **When** the doc states it, **Then** it states the real, current
   nuance rather than the strongest possible framing.

---

### User Story 2 - A prospective user reads genuine, unhedged disadvantages (Priority: P1)

The same developer wants the honest limitations stated plainly — no
disadvantage omitted because it's uncomfortable, no real gap softened
into vague, unfalsifiable language.

**Why this priority**: This is the user's explicit, primary ask ("seja
bem sincero") — the half most documentation of this kind skips or
sandbags, and the one that actually earns a reader's trust.

**Independent Test**: Read the disadvantages section and confirm each
item names a specific, real, currently-true limitation (not a strawman)
— e.g., no `v0.1.0` release has been cut yet, several harness install
paths are desk-research-grounded rather than hands-on-verified, the
process carries more ceremony (constitution → spec → clarify → plan →
tasks → implement) than lightweight competitors like OpenSpec's
three-command model, single-maintainer scale versus funded/AWS-backed
competitors (Tessl, Kiro).

**Acceptance Scenarios**:

1. **Given** the published document, **When** a reader looks for a known,
   real limitation of this project (checked against this session's own
   verified state — e.g., no git tag exists yet), **Then** the doc states
   it plainly rather than omitting or euphemizing it.
2. **Given** a disadvantage that has a partial mitigation already in
   place, **When** the doc states it, **Then** it names the mitigation
   honestly (e.g., "5 harnesses are hands-on CI-tested; the other 15 are
   desk-research-grounded per a cited source, not yet hands-on verified")
   rather than either hiding the mitigation or overstating it as fully
   solved.

---

### User Story 3 - A reader sees concrete, competitor-grounded improvement points (Priority: P1)

A developer (or the maintainer, planning future work) wants to know
specifically what capability a named competitor already has that Spec
Jedi doesn't yet, so limitations translate into an actionable forward
signal rather than just criticism.

**Why this priority**: The user's explicit second ask — "busque nos
concorrentes para entender quais seriam os futuros pontos de melhoria."
Equal priority to User Story 2 because an honest limitation without a
grounded "here's what would close it" is only half of what was
requested.

**Independent Test**: Read the improvement-points section and confirm
each entry names a specific competitor (from the 11 already researched
in `references/competitive-comparison.md`, or a new targeted citation
where that file doesn't already cover the gap) and the specific
capability that competitor has that Spec Jedi lacks.

**Acceptance Scenarios**:

1. **Given** a listed improvement point, **When** a reader checks its
   citation, **Then** it names a real, specific competitor capability
   (e.g., "Tessl operates a shared cross-project pattern registry;
   `specjedi-find-skills` only searches the current session's known
   ecosystem") — never a vague "could be more polished" with no
   competitor grounding.
2. **Given** the full set of improvement points, **When** compared
   against `references/competitive-comparison.md`'s existing per-tool
   rows, **Then** each point traces back to (or meaningfully extends) that
   existing research rather than fabricating a new, uncited competitor
   claim.

### Edge Cases

- What happens when a listed disadvantage gets resolved later (e.g.,
  `v0.1.0` is finally cut)? → the document carries a visible "last
  reviewed" date/commit marker (mirroring the `i18n-sync` marker
  convention already used elsewhere in this project) so staleness is
  detectable rather than silently misleading a reader indefinitely.
- What happens if an advantage the maintainer wants highlighted turns out
  to only be aspirational (stated in the constitution, not yet actually
  shipped by any mechanism)? → it does not appear in the Advantages
  section; the spec's own grounding requirement (FR-001) is an
  unconditional filter, not a suggestion.
- What happens when a disadvantage has no known competitor doing better
  (a genuinely unsolved-industry-wide gap)? → it's still listed in
  Disadvantages (User Story 2 doesn't require a competitor citation) but
  is not forced into the Improvement Points section (User Story 3's
  competitor-grounding requirement means an ungrounded item stays out of
  that specific section rather than being stretched to fit).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The document MUST state each advantage as a claim citing a
  specific, currently-shipped mechanism (a file, a CI job, a
  `references/principle-traceability.md` ✅/🟡 status) — never an
  aspirational or constitution-only claim with no shipped mechanism
  behind it.
- **FR-002**: The document MUST state at least 5 genuine, specific
  disadvantages — not vague hedges ("there's always room for
  improvement") — each naming a real, checkable current limitation.
- **FR-003**: Where a stated disadvantage has a partial, real mitigation
  already shipped, the document MUST state that mitigation honestly
  (neither hidden nor overstated as fully resolved), cross-checked
  against the actual `references/principle-traceability.md` status
  (✅ Mechanized vs. 🟡 Partial) rather than the doc's own unchecked
  assertion.
- **FR-004**: The document MUST include a dedicated "Where competitors
  are ahead" / improvement-points section, and every entry in it MUST
  name a specific competitor and the specific capability gap, built on
  `references/competitive-comparison.md`'s existing 11-tool research
  (extended with new targeted citations only where that file doesn't
  already cover a real, relevant gap).
- **FR-005**: The document's tone MUST be candid, not promotional —
  reads as a genuine self-assessment, consistent with Constitution
  Principle XX's hallucination-resistance discipline and the user's
  explicit "seja bem sincero" instruction.
- **FR-006**: The document MUST live under `references/` (not `docs/`) —
  Constitution Principle I's ten-language localization mandate applies to
  top-level onboarding documentation (README, CONTRIBUTING, installation
  guides), not a researched-analysis reference doc; this matches
  `references/competitive-comparison.md`'s own existing precedent (also
  `references/`, also linked from, but not embedded in, the README).
- **FR-007**: `README.md` MUST link to the new document from a
  discoverable location, mirroring the existing
  `references/competitive-comparison.md` link pattern.
- **FR-008**: The document MUST carry a visible "last reviewed"
  date/commit marker, so a reader (or a future maintainer) can tell
  whether a given claim might be stale (Edge Cases).

### Key Entities

- **Advantage**: a claim about Spec Jedi's current capability, always
  paired with a citation to a specific shipped mechanism.
- **Disadvantage**: a claim about a current, real limitation, optionally
  paired with a partial-mitigation note if one exists.
- **Improvement point**: a disadvantage specifically paired with a named
  competitor's capability that addresses it — the actionable subset of
  disadvantages, not a duplicate list.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of advantages listed trace to a specific, currently
  verifiable shipped mechanism — zero aspirational or constitution-only
  claims present.
- **SC-002**: At least 5 genuine, specific disadvantages are listed, each
  independently checkable against this repository's actual current state.
- **SC-003**: 100% of entries in the improvement-points section name a
  specific competitor and a specific capability gap — zero vague,
  uncited "could be better" entries in that section.
- **SC-004**: A reader with no prior context on this project's internals
  can, after reading the document, correctly state at least three
  concrete reasons to adopt Spec Jedi and at least three concrete current
  limitations, without needing to read any other project document first.

## Assumptions

- **Builds on, does not duplicate, existing research**: this feature
  reuses `references/competitive-comparison.md`'s 11-tool research
  (feature 014, itself grounded in `specs/001-specjedi-pipeline/
  research.md`) as its primary grounding for the improvement-points
  section, rather than re-researching all competitors from scratch.
  Additional targeted research (a small number of new, specific
  citations) is performed only where that file doesn't already cover a
  real, relevant capability gap this feature needs to name — decided
  during Phase 0 research at planning time, not pre-committed to a fixed
  count here.
- **5 is the minimum disadvantage count (FR-002/SC-002)**: a
  maintainer-unspecified, reasonable default chosen to guarantee genuine
  candor (a token 1-2-item list would satisfy the letter of "be honest"
  without its spirit) without being an arbitrarily large, padding-inviting
  number.
- **Scope boundary**: this document assesses `specjedi-*` skills as a
  whole (the product surface, per Principle XV), not a per-skill
  breakdown of all 23 individual skills — a per-skill assessment would be
  `specjedi-skill-review`'s job (internal, per-skill authoring-standard
  audit), a different, already-existing mechanism this feature doesn't
  duplicate.
- This is a new reference document, not a revision to an existing skill
  — Principle IX's skill-validation-battery requirements don't apply the
  same way they would to a `SKILL.md` change; `scripts/validate.sh`'s
  existing Markdown/structural checks still apply where relevant.
