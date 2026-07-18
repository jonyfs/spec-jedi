# Research: README Objectivity & Evidence-Based Benefits Rewrite

**Feature**: specs/046-readme-benefits-rewrite
**Date**: 2026-07-18

This feature has no unresolved `NEEDS CLARIFICATION` markers (see
spec.md's own Clarifications-free path — the user's instruction was
already concrete enough to proceed directly). This document resolves
the two remaining *design* questions: how to cite evidence without
duplicating it, and how the settled comic-section/epigraph exceptions
were confirmed rather than assumed.

## Decision 1: Cite `PARITY-LEDGER.md` directly, never restate its full prose

**Decision**: The new comparison content in `README.md` states the
exact parity ratio (8/11 full, 1/11 favorable divergence, 2/11 no
equivalent) and the 16-skill count as short, precise sentences with a
relative link to `specs/044-speckit-parity-audit/PARITY-LEDGER.md` —
it does not copy the ledger's own per-command table or its longer
reasoning into the README.

**Rationale**: The ledger already exists, is already evidence-grounded
(built under its own Principle II research gate), and is version-
controlled independently. Copying its content into the README would
create a second copy that can silently drift out of sync the next time
the ledger is updated — the exact failure mode Constitution Principle
XXII (skill/mechanism freshness) exists to catch elsewhere in this
project. Citing it directly means the README's claim is automatically
current whenever the ledger itself is current, with zero duplicate
maintenance.

**Alternatives considered**:
- Copying the full parity table into the README. Rejected: duplicates
  content that already has a canonical home, and doubles the surface
  area a future ledger update would need to touch.
- Summarizing the parity finding in vaguer language ("mostly at
  parity") without the exact ratio. Rejected: this is precisely the
  kind of unverifiable-adjective drift this feature exists to remove
  (spec FR-004) — the exact numbers are already known and citable, so
  there's no reason to soften them into an adjective.

## Decision 2: Confirm the comic-section/epigraph exceptions by reading prior specs, not by assuming precedent applies

**Decision**: Before writing spec.md's Edge Cases, `specs/036-readme-
jedi-letter/spec.md` and `specs/037-readme-professional-restructure/
spec.md` were read directly (their Clarifications, Edge Cases, and
Assumptions sections) to confirm both exceptions were actually settled,
rather than inferring from this feature's own general "revise every
section" instruction that they should also be revisited.

**Rationale**: specs/037's own Amendment 2 already reasoned through this
exact tension once — a general instruction ("consolidate/reorganize")
that wasn't specifically targeting the comic section, and removing a
deliberately-commissioned illustrated feature would have been a bigger,
likely-unintended side effect. Applying that same reasoning silently
without re-confirming the prior spec's actual text would risk
misremembering or overstating what was actually settled. Reading both
specs directly (not just recalling "there was a decision here somewhere")
confirmed: (a) the comic section is explicitly labeled a Principle-XV
internal-bootstrap aside, out of scope for both effects; (b) the
epigraph line's retention was a direct, explicit user instruction in
specs/037's Amendment 1, scoped narrowly as a single hook line, not a
sustained narrator.

**Alternatives considered**:
- Treating "revise every section" literally and re-opening both
  questions. Rejected: this would re-litigate a decision already made
  twice for this exact document without new information justifying it
  — the current feature's actual goal (verifiable facts, evidence-based
  comparison) doesn't touch either exception's content in any way that
  would change the prior reasoning.
- Silently leaving both sections alone without documenting why.
  Rejected: an undocumented scope boundary reads as an oversight to a
  future reviewer; citing the specific prior specs makes the boundary
  a traceable decision, not a gap (Constitution Principle XX).

## Summary of touched files

| File | Change |
|---|---|
| `README.md` | MODIFIED — substantive prose sections revised for objectivity + new evidence-based comparison content (Decisions 1-2). Comic-panel section and opening epigraph untouched. |

No new scripts, no new reference files, no new dependencies.
