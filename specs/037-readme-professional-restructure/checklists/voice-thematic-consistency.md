# Checklist: Voice & Thematic Consistency

**Purpose**: Validate that `spec.md`/`plan.md` fully specify the voice and
Star-Wars-seasoning requirements this feature depends on, before treating
the shipped `README.md`/`CONTRIBUTING.md` prose as settled.
**Feature**: `037-readme-professional-restructure`

## Hook-Line Scoping (FR-001, FR-010, Amendment 1)

- [x] CHK-001 Does the spec define a clear, checkable boundary between
  "the hook line as a single evocative epigraph" and "the hook line
  functioning as the opening of a sustained first-person narrator,"
  beyond asserting the two are different in principle? (spec.md FR-001,
  Amendment 1) — **Resolved, Amendment 3**: the hook line stands as its
  own bolded paragraph after the opening image; zero first-person
  pronouns anywhere else in the document is the mechanical check.
- [x] CHK-002 Does the spec specify what visual/textual signal — if
  any — should mark the hook line as bounded (e.g., matching the
  existing italic epigraph quote's own formatting), so a future editor
  can verify the boundary holds without re-deriving the original intent?
  (spec.md FR-001) — **Resolved, Amendment 3**: positional/formatting
  identity with the existing italic epigraph quote, now stated directly
  in FR-001.

## Third-Person Dial-Back Scope (FR-006)

- [x] CHK-003 Does the spec name every voice element that counts as the
  "sustained first-person narrator conceit" (direct address, I/you
  framing, personal asides) precisely enough that a reviewer could check
  a given sentence against the list, rather than relying on a subjective
  read? (spec.md FR-006) — **Resolved, Amendment 3**: enumerated as
  first-person "I/we" narration, second-person "you" used as a
  rhetorical narrator device, and personal asides.
- [x] CHK-004 Does the spec (or plan) define what "professional-but-
  informal" third-person voice actually sounds like beyond citing PR
  #100 as precedent, for a reviewer who hasn't read that PR? (spec.md
  FR-006) — **Resolved, Amendment 3**: direct factual statements,
  contractions/informal connective tissue permitted, no corporate
  boilerplate, no narrator persona or direct-address rhetoric; the
  shipped "How Spec Jedi Implements SDD"/"Honest assessment" sections
  are the reference examples.
- [x] CHK-005 Does the spec address whether "Who this is for"'s direct
  second-person address ("you," "your non-negotiables" style phrasing
  used elsewhere in this project) counts as violating the third-person
  dial-back, or is second-person address distinct from the first-person
  "I/we" narrator FR-006 actually targets? (spec.md FR-006, "Who this is
  for" section) — **Resolved, Amendment 3**: plain third-person
  description of a section's audience is compliant, not an exception;
  the shipped "Who this is for" section in fact uses zero first- or
  second-person pronouns.

## Star Wars Seasoning Sourcing (FR-006, SC-004, `star-wars-lexicon.md`)

- [x] CHK-006 Does the spec require each retained or added Star Wars
  reference to cite which specific lexicon entry it draws from, or is
  "drawn from the curated pool" left to planning/implementation to
  self-certify without a traceable mapping? (spec.md FR-006, SC-004) —
  **Resolved, Amendment 3**: traceability is required at the
  artifact-review level (a follow-up `specjedi-analyze`/
  `specjedi-skill-review`-style pass), not as inline citations in the
  shipped prose.
- [x] CHK-007 Does SC-004's "at least one" threshold specify whether
  that's a floor or the intended final count — given the pre-restructure
  README carried several references (Jedi Code, "right side of the
  Force," the lightsaber-free mentor, Padawan → Knight → Master) — is
  reducing many references down to a bare minimum an acceptable reading
  of "professional... not overwrought," or an under-specified regression
  risk the spec doesn't actually bound? (spec.md SC-004, US3) —
  **Resolved, Amendment 3**: explicitly a floor, not a target; the
  shipped document retains more than one reference.

## Cross-File Voice Consistency (FR-010, `letter-path.jpg` relocation)

- [x] CHK-008 Does the spec specify whether Star-Wars-themed seasoning
  tied to the relocated discipline passage (the "right side of the
  Force" framing) is required to also survive somewhere in `README.md`
  itself, or is relocating it to `CONTRIBUTING.md` alone sufficient to
  satisfy FR-010's "relocates with that content" — given the Assumptions
  section separately states the underlying idea is "preserved and
  re-expressed... as part of the restructured flow" (which reads as
  implying it stays in the README)? (spec.md FR-010, Assumptions —
  flagged by `specjedi-analyze` as a MEDIUM finding) — **Resolved,
  Amendment 3**: relocation to `CONTRIBUTING.md` alone is sufficient;
  SC-004's README-side floor is independently satisfied via the Jedi
  Code framing in "What Is Spec-Driven Development?" The Assumptions
  section's ambiguous phrasing was rewritten to state this directly.
- [x] CHK-009 Does the spec define which document's voice conventions
  govern once thematic seasoning crosses from `README.md` into
  `CONTRIBUTING.md` — a file whose own pre-existing content is already
  written in a plainer, less-seasoned third-person voice than the
  README — or is a single new caption line sufficient seasoning there
  without `CONTRIBUTING.md` needing its own explicit voice bar? (plan.md
  Constitution Check row XII; `CONTRIBUTING.md`'s existing voice) —
  **Resolved, Amendment 3**: `CONTRIBUTING.md`'s own default voice is
  unchanged; the relocated image + one caption line are the sole scoped
  exception, not a general loosening.

## Notes

- Every item above interrogates whether `spec.md`/`plan.md` specify
  enough for a reviewer to check voice/thematic compliance objectively —
  none of these test whether the shipped prose "sounds right" by feel.
- CHK-008 traces directly to the MEDIUM finding `specjedi-analyze`
  surfaced against this feature; the rest are new gaps this checklist
  pass found independently.
- All 9 items resolved via `spec.md`'s Amendment 3 (Clarifications
  section) plus corresponding inline updates to FR-001, FR-006, FR-010,
  SC-004, and Assumptions. No `README.md`/`CONTRIBUTING.md` content
  changed — every resolution confirmed the already-shipped prose already
  matched the intended reading; this pass closed gaps in how precisely
  the *spec* stated that intent, not gaps in the implementation.
