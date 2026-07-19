# Specification Quality Checklist: Voice/Persona, Classification Correctness & Reuse Discipline

**Purpose**: Requirements-quality check on `spec.md`/`plan.md` across three
focus areas the user asked to cover together — this checklist tests
whether the *English* of those two artifacts is complete and unambiguous
on each, never whether the shipped `SKILL.md` actually implements them.
**Created**: 2026-07-18
**Feature**: [spec.md](../spec.md) / [plan.md](../plan.md)

## Voice & Persona Consistency

- [x] CHK-001 Does `plan.md` define a concrete criterion for what makes
  the new skill's Persona "genuine" and "not a copy" — a defining trait,
  metaphor, or other observable marker — or is genuineness left to be
  judged only after the fact, with no way to check it before writing the
  skill? (plan.md Constitution Check, Principle XII row) — **Resolved**:
  plan.md's new "Clarifications" section (CHK-001/CHK-002) states the
  bar explicitly: one concrete role/metaphor distinct from sibling
  skills' own framings, plus at least one in-file narration instance.
- [x] CHK-002 Does `plan.md` specify what "consistent with sibling audit
  skills" concretely requires — a shared minimum bar every audit skill's
  Persona must meet (e.g., a distinct opening paragraph, a real-world
  metaphor) — or is consistency asserted without a checkable definition?
  (plan.md Constitution Check, Principle XII row) — **Resolved**: same
  Clarifications entry as CHK-001.

## Classification Correctness

- [x] CHK-003 Does `spec.md` define what evidence qualifies as
  "documented design rationale" for FR-008's multi-skill-split
  exemption — must the rationale live specifically in a `plan.md`/
  `research.md`, or does any project mention count — so the exemption
  isn't applied inconsistently across different findings? (spec.md
  FR-008) — **Resolved**: plan.md's Clarifications (CHK-003) requires a
  specific `plan.md`/`research.md` citation; a bare mention doesn't
  qualify. `SKILL.md` Step 4 tightened to match.
- [x] CHK-004 Does `spec.md` specify a tie-breaking rule for a finding
  that could plausibly fit two of the three categories at once (e.g., a
  redundancy between two skills that could also be read as an
  SDD-coverage gap for one of them) — or does FR-004's "exactly one"
  requirement leave that genuinely ambiguous case unresolved? (spec.md
  FR-004) — **Resolved**: plan.md's Clarifications (CHK-004) states the
  phase-level-question-wins rule. `SKILL.md` Step 5 tightened to match.
- [x] CHK-005 Does `spec.md` define the threshold for "identical need" in
  User Story 3's Redundancy definition — how much functional overlap
  between two skills counts as redundant versus a legitimate partial
  overlap that isn't? (spec.md User Story 3) — **Resolved**: plan.md's
  Clarifications (CHK-005) defines the threshold (same phase + same
  trigger + no stated scope/weight-class/audience difference).
  `SKILL.md` Step 4 tightened to match.

## Reuse Discipline

- [x] CHK-006 Does `plan.md` specify whether "reusing"
  `specjedi-skill-review`'s methodology (FR-003) requires a literal
  self-invocation of that skill per target, or whether "applying its
  exact documented method inline" is an equally acceptable alternative
  with no observable difference in output — or is the choice left
  unconstrained? (plan.md Implementation notes, step 3) — **Resolved**:
  plan.md's Clarifications (CHK-006/CHK-007) states self-invocation is
  preferred, inline is an accepted fallback only. `SKILL.md` Step 3
  tightened to match.
- [x] CHK-007 Does `spec.md`/`plan.md` address what happens if
  `specjedi-skill-review`'s own methodology changes after this skill
  ships (e.g., a new check dimension is added) — must
  `specjedi-catalog-audit` stay in sync automatically, or could an
  inline-copied version of the method silently drift out of date over
  time? (spec.md FR-003; plan.md Technical Context) — **Resolved**: same
  Clarifications entry as CHK-006 — inline copies carry an explicit
  re-sync obligation, now stated in `SKILL.md`'s own Always/Never too.
- [x] CHK-008 Does `spec.md` define what "matching" means for FR-005's
  requirement to cross-reference a skill's own
  `specs/NNN-<skill-name>/plan.md` before flagging an exemption-shaped
  finding — exact name match only, or is a fallback specified for a
  skill whose `plan.md` lives under a differently-numbered or
  differently-named spec folder? (spec.md FR-005) — **Resolved**:
  plan.md's Clarifications (CHK-008) specifies exact skill-name matching
  by folder suffix, with no-match meaning no exemption to honor.
  `SKILL.md` Step 3 tightened to match.

## Notes

- All 8 items trace to a specific `spec.md`/`plan.md` section; none would
  read unchanged as a checklist item for an unrelated project.
- None of these items were raised as findings by the earlier
  `specjedi-analyze` run (which checked cross-artifact traceability, not
  requirements-quality depth on these three specific dimensions) — this
  checklist is a complementary, deeper pass at the same two artifacts,
  not a re-run of that check.
- All 8 items resolved via a follow-up plan revisit: `plan.md` gained a
  "Clarifications (post-checklist)" section, and
  `.claude/skills/specjedi-catalog-audit/SKILL.md` was tightened in
  Steps 3-5 and Always/Never so the shipped skill's own text matches the
  plan's resolutions exactly — no lingering plan/implementation
  mismatch.
