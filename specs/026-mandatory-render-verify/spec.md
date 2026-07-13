# Feature Specification: Mandatory, Failure-Aware Render Verification for `specjedi-diagram`

**Feature Branch**: `026-mandatory-render-verify`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description (Portuguese): "a skill /specjedi-diagram deve
sempre validar os gráficos mermaid gerados para evitar erros semelhantes
a este: Unable to render rich display" (The `specjedi-diagram` skill must
always validate generated Mermaid diagrams to avoid errors similar to
this: "Unable to render rich display".)

## Problem

`specjedi-diagram/SKILL.md`'s current Step 4 says: "Run the generated
source through the harness's Mermaid validation mechanism. If it fails,
revise and re-check." Two real gaps in that wording:

1. It's phrased as a conditional ("if it fails") rather than an
   unconditional gate — nothing explicitly forbids presenting a diagram
   for which verification was never actually attempted, or was attempted
   half-heartedly under real load. "Always validate" (the user's literal
   ask) is currently a convention the model is expected to follow, not a
   requirement the skill states as absolute.
2. It only names *syntax* failure ("If it fails" reads as "if the
   Mermaid parser rejects it"). A diagram can be syntactically valid
   Mermaid and still fail to actually display — this session's own
   render-verification tool call for a moderately complex three-subgraph
   flowchart returned "Error: result (54,892 characters) exceeds maximum
   allowed tokens" rather than a rendered diagram, a first-hand, this-
   session example of exactly the failure class the user is naming
   ("Unable to render rich display" is the same shape of problem: valid
   Mermaid source, but the rendering surface still can't produce a
   viewable result). Nothing in the skill's current wording treats "the
   render call itself failed/was truncated/errored" as a distinct
   failure mode from "the Mermaid parser reported a syntax error" — both
   currently fall under the same soft "if it fails, revise" language.

This feature makes render-verification an unconditional, always-attempted
gate, and makes it explicit that a rendering/display failure (not just a
syntax error) triggers the same revise-and-recheck loop.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Render-verification is never skipped (Priority: P1)

A user requesting any diagram from `specjedi-diagram` wants to be certain
a render-verification attempt happened before the diagram was presented
— not just for diagrams that "look complicated," but for every diagram,
every time.

**Why this priority**: This is the user's literal, primary ask —
"deve sempre validar" (must always validate) — and the gap that lets a
broken diagram reach the user in the first place.

**Independent Test**: Request several diagrams of varying complexity
(a trivial 3-node flowchart, a moderately complex multi-subgraph one) and
confirm each response states a verification attempt happened and its
result, with no diagram presented without that statement.

**Acceptance Scenarios**:

1. **Given** any request for a diagram, **When** `specjedi-diagram`
   generates Mermaid source, **Then** it attempts render-verification via
   the harness's available mechanism before presenting the diagram, with
   no code path that skips this step.
2. **Given** a harness with no render-verification mechanism available,
   **When** the skill runs, **Then** it still explicitly states
   verification wasn't available (the pre-existing documented fallback)
   rather than silently presenting the diagram as if it were checked.

---

### User Story 2 - A rendering/display failure (not just a syntax error) triggers revision (Priority: P1)

A user wants a diagram that fails to actually display — even if its
Mermaid syntax is technically valid — to be caught and revised before
being presented, the same way a syntax error already is today.

**Why this priority**: This directly targets the named failure
("Unable to render rich display") — a display-layer failure distinct
from, and not currently covered by, syntax-only validation.

**Independent Test**: Simulate (or genuinely trigger, per this session's
own prior example) a render call that errors or fails to produce a
displayable result for syntactically valid Mermaid source, and confirm
the skill treats this identically to a syntax failure — revise, re-check,
never present the broken result.

**Acceptance Scenarios**:

1. **Given** generated Mermaid source that is syntactically valid,
   **When** the render-verification call itself fails, errors, or cannot
   produce a displayable result (for any reason — including but not
   limited to size/complexity), **Then** the skill treats this as a
   verification failure requiring revision, not as an unrelated tooling
   error to route around silently.
2. **Given** a revision was made in response to a display failure,
   **When** the skill re-attempts verification, **Then** it reports
   which revision strategy was used (e.g., simplifying/splitting the
   diagram, per `specs/025-diagram-readability`'s complexity-threshold
   mechanism where applicable) so the user understands why the presented
   diagram differs from what a naive read of the source content might
   have produced.

---

### User Story 3 - Verification failure that can't be resolved is stated honestly, with a bounded retry (Priority: P2)

A user wants the skill to try to fix a failing diagram a reasonable,
bounded number of times — not loop forever, and not give up after one
attempt without trying an obvious fix — and to be told plainly if it
still can't produce a verified diagram.

**Why this priority**: Lower than P1 because it's the exception path,
not the common case, but necessary so "always validate" doesn't turn into
either an infinite retry loop or a one-shot give-up.

**Independent Test**: Construct a case designed to keep failing
verification even after one revision attempt; confirm the skill stops
after a bounded number of attempts and states plainly that it could not
produce a verified diagram, offering the unverified source with an
explicit caveat rather than pretending success.

**Acceptance Scenarios**:

1. **Given** a diagram that still fails verification after revision,
   **When** the skill has made 2 revision attempts (concrete bound, not
   "keep trying"), **Then** it stops, states plainly that verification
   could not succeed, and offers the last-attempted source with an
   explicit "unverified — may not render correctly" caveat rather than
   silently presenting it as checked.

### Edge Cases

- What happens when the render-verification mechanism itself is
  temporarily unreachable (network/tool error) versus the diagram
  genuinely being unrenderable? → both are treated the same way for this
  feature's purposes: verification did not succeed, so the same
  revise-and-bounded-retry-then-honest-caveat path applies. The skill
  does not need to (and generally cannot) distinguish "my tool is down"
  from "my diagram is broken" with certainty, so it doesn't pretend to.
- What happens when the first revision attempt (e.g., simplifying per
  feature 025) produces a diagram that loses essential content the user
  asked for? → the skill states this tradeoff explicitly rather than
  silently dropping content — "simplified from N to M nodes to pass
  verification" is exactly the kind of one-line disclosure User Story
  2's Acceptance Scenario 2 already requires.
- What happens for a trivial diagram (3 nodes) that obviously will
  render fine? → verification still runs (User Story 1 is unconditional
  by design) — the *cost* of always checking a simple diagram is
  negligible, and "obviously fine" is exactly the kind of assumption that
  produces the silently-broken-diagram failure mode this feature exists
  to close.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-diagram` MUST attempt render-verification for
  every generated diagram before presenting it — unconditionally, not
  only when the diagram "seems complex enough to warrant it."
  Never present a diagram for which verification was never attempted, when a verification mechanism is available in the current harness.
- **FR-002**: `specjedi-diagram` MUST treat a failure of the
  render-verification call itself (error, timeout, output too large to
  display, or any other failure to produce a displayable result) as a
  verification failure requiring revision — the same handling as a
  Mermaid syntax error — not as an unrelated tooling problem to be
  silently ignored or routed around.
- **FR-003**: On a verification failure, `specjedi-diagram` MUST revise
  the diagram and re-attempt verification, using the most applicable
  revision strategy for the failure's likely cause (e.g., a
  size/complexity-driven display failure → simplify or split, per
  `specs/025-diagram-readability`'s complexity-threshold mechanism where
  that feature is implemented; a syntax error → correct the syntax
  error).
- **FR-004**: `specjedi-diagram` MUST bound revision attempts to 2 before
  stopping — never an unbounded/infinite retry loop.
- **FR-005**: If verification still fails after the bound in FR-004,
  `specjedi-diagram` MUST state plainly that it could not produce a
  verified diagram and present the last-attempted source with an
  explicit "unverified — may not render correctly" caveat, rather than
  silently presenting it as if checked, or silently declining to show
  anything at all.
- **FR-006**: When a revision changes what the diagram shows relative to
  the source content (e.g., simplification per FR-003), `specjedi-diagram`
  MUST state that tradeoff in one line alongside the presented diagram.
- **FR-007**: When no render-verification mechanism is available in the
  current harness at all (pre-existing documented case), `specjedi-diagram`
  MUST continue to state that explicitly and offer the unverified source
  with a caveat — this feature does not change that existing fallback,
  only makes the *attempt* itself unconditional when a mechanism does
  exist.

### Key Entities

- **Verification failure**: any outcome of a render-verification attempt
  other than a confirmed-renderable result — covers both Mermaid syntax
  rejection and a rendering/display-layer failure (e.g., output too
  large, tool error) equally.
- **Revision attempt**: one bounded cycle of "diagnose likely cause of
  the verification failure → apply a targeted fix → re-verify." Capped
  at 2 per diagram (FR-004).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of diagrams presented by `specjedi-diagram` are
  accompanied by an explicit verification-result statement (verified /
  unverified-with-caveat) — never presented silently.
- **SC-002**: A render-verification call failure (error, timeout,
  output-too-large) triggers the same revise-and-recheck path as a
  syntax error in 100% of cases — verified via at least one deliberately
  induced failure during this feature's own implementation/testing.
- **SC-003**: No diagram generation ever enters an unbounded retry loop
  — every verification-failure path terminates within 2 revision
  attempts (FR-004), confirmed by the skill's own documented bound.
- **SC-004**: `scripts/validate.sh`'s existing structural lint continues
  to pass for `specjedi-diagram/SKILL.md` after the revision.

## Assumptions

- **Relationship to `specs/025-diagram-readability`**: that feature (also
  in progress, not yet implemented as of this spec) defines *how* to
  simplify an oversized diagram (the 20-node complexity threshold and
  splitting-along-a-seam mechanism) and *why* colors should never be
  hardcoded. This feature (026) is complementary, not overlapping: it
  makes the verification *gate* itself unconditional and
  failure-mode-aware, and calls into 025's revision mechanism (FR-003)
  as one applicable strategy once 025 ships — but 026's own core
  requirement (always verify; treat display failures like syntax
  failures; bounded retry; honest fallback) stands on its own even before
  025 lands, since it doesn't strictly require the complexity-threshold
  mechanism to exist to be independently true and testable (a syntax-
  error revision, for instance, doesn't depend on 025 at all).
- **Scope boundary**: like feature 025, this revises `specjedi-diagram`'s
  own generation/verification behavior only — not a project-wide
  enforcement mechanism for Mermaid content authored outside this skill
  (e.g., a diagram an agent hand-writes directly into a README edit
  without invoking `specjedi-diagram`). The user's request names the
  skill specifically ("a skill /specjedi-diagram deve sempre validar").
- **"Unable to render rich display" is treated as one instance of a
  general class** (render-verification-call failure), not chased down to
  one specific tool/vendor's exact error string — the fix (treat any
  failure to produce a displayable result as a verification failure)
  generalizes regardless of which specific message a given harness's
  render-verification mechanism happens to surface.
- 2 is chosen as the revision-attempt bound (FR-004) as a reasonable,
  concrete default consistent with Principle XIX's "quantifiable, not
  vague" requirement — a value the user did not specify and that has no
  single objectively-correct answer, but for which "unbounded" is clearly
  wrong (infinite loop risk) and "1" doesn't give a syntax-error fix and
  a fallback-simplification fix both a fair attempt within the same
  bound.
