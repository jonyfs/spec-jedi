# Feature Specification: Session-Start Live-Render Verification Closure

**Feature Branch**: `022-session-start-verification`

**Created**: 2026-07-12

**Status**: Draft

**Input**: User description: "Audit .specify/memory/constitution.md and references/principle-traceability.md for what genuinely still needs to be done, and close it via the full speckit pipeline. The audit found Principle XXI (Session-Start Orientation & the Master Yoda Greeting) at 🟡 Partial, with a single named gap: feature 015's tasks.md T020, 'an actual live Claude Code session start rendering the greeting end to end (SC-003) — not observable from within the same session that built it; needs confirmation the next time a fresh session opens in this repo.' This current session's own transcript contains exactly that confirmation: a real SessionStart:compact hook firing produced the correct three-part payload (ASCII banner, an accurate feature-status summary matching the project's real state at that point, and a context-appropriate Yoda line), verifiably not fabricated since it's visible in the conversation's own tool-result history. Separately, the same transcript surfaces a genuinely new, previously-undocumented nuance: this project's CLAUDE.md instructs the agent to 'render [the SessionStart payload] verbatim as your opening reply,' but this session was a compact-triggered continuation carrying an explicit system-level instruction to 'resume directly... do not preface with an acknowledgment' -- the two instructions conflict, and in this real instance the continuation instruction was followed, not the verbatim-render one. This is a real, observed edge case, not a hypothetical, and needs an honest resolution (a precedence clarification) rather than being silently left unresolved."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The constitution accurately reflects what's actually been verified (Priority: P1) 🎯 MVP

A maintainer or future session reads `references/principle-traceability.md`'s
Principle XXI row and `specs/015-session-start-hook/tasks.md`'s T020 to
understand what's actually confirmed about the session-start mechanism.
Today both correctly say "not yet observed" — a claim that stopped being
true partway through this session, once a real `SessionStart:compact`
firing was captured in the transcript. Leaving the stale "not yet
observed" claim in place after real evidence exists would itself become
a fact-bearing drift, the exact class of gap this project has caught and
fixed before (badges, skill counts, principle rows).

**Why this priority**: This is the actual deliverable the audit surfaced
— a concrete, closeable claim gap with real evidence sitting unused in
the same conversation.

**Independent Test**: Read `specs/015-session-start-hook/tasks.md` T020
and `references/principle-traceability.md`'s Principle XXI row after this
feature ships; confirm both cite the real observed evidence (with its
specific, quoted content) rather than repeating the old "not yet
observed" language.

**Acceptance Scenarios**:

1. **Given** this feature has shipped, **When** a reader checks T020,
   **Then** it cites the specific real `SessionStart:compact` firing
   observed in this session (quoting its actual banner/status/Yoda-line
   content) as evidence the mechanism produces correct output when
   genuinely triggered by Claude Code, not a manual dry run.
2. **Given** the same shipped state, **When** a reader checks Principle
   XXI's row, **Then** it reflects the mechanism itself as confirmed
   working end-to-end, while still distinguishing that from the separate
   render-instruction-precedence nuance (User Story 2) rather than
   conflating the two into a single blanket "done."

---

### User Story 2 - A real, newly-discovered instruction conflict gets an honest resolution (Priority: P1)

This same session surfaced a genuine edge case no prior design
anticipated: the project's own render instruction ("render verbatim as
your opening reply") and a session-continuation instruction ("resume
directly, don't preface") can both apply to the same moment and point in
different directions. In the observed instance, the continuation
instruction won by default (no explicit precedence rule existed to
decide it). Leaving this unresolved means the next occurrence resolves
the same way by accident, not by decision.

**Why this priority**: An unresolved, silently-discovered conflict is
exactly the kind of gap Principle XX's honesty discipline exists to
surface rather than let quietly recur — this is a real governance
question the project hadn't yet had to answer.

**Independent Test**: Read `CLAUDE.md`'s session-start orientation section
after this feature ships; confirm it states which instruction takes
precedence when a session-continuation directive and the
render-verbatim instruction both apply to the same turn.

**Acceptance Scenarios**:

1. **Given** this feature has shipped, **When** a future session opens
   with both a `SessionStart` payload present and an explicit
   continuation/no-preface instruction in the same context, **Then**
   `CLAUDE.md` states unambiguously which one the agent should follow,
   resolving the exact conflict this session encountered rather than
   leaving it to accidental precedent.

### Edge Cases

- What if the "evidence" being cited were actually fabricated or
  misremembered rather than genuinely present in the transcript? Not
  applicable here — the specific quoted content (banner text, feature
  counts, Yoda line) is verifiable directly against this session's own
  tool-result history, the same bar `specjedi-retro`'s "ground any
  deviation's cause in real git history, never invent one" discipline
  already applies to feature retrospectives.
- What if a future session-start firing produces different, contradictory
  output (e.g. a crash, garbled content)? Out of scope for this
  closure — T020/SC-003 asked whether the mechanism *can* fire correctly
  in a real instance, which this session now answers; it does not claim
  every future firing will always succeed.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specs/015-session-start-hook/tasks.md`'s T020 MUST be
  updated to cite the real `SessionStart:compact` observation from this
  session (quoting its actual banner/status-summary/Yoda-line content),
  replacing the "honestly NOT completed" language with an honest
  "completed, with evidence" status — not silently marked done without
  citation.
- **FR-002**: `references/principle-traceability.md`'s Principle XXI row
  MUST be updated to reflect the mechanism as confirmed (banner + status
  + Yoda line all fire correctly via a real, harness-triggered
  `SessionStart` event), while explicitly distinguishing this from the
  separate render-precedence question (FR-003) rather than blending them
  into one status.
- **FR-003**: `CLAUDE.md`'s session-start orientation section MUST gain
  an explicit precedence rule for when a session-continuation/no-preface
  instruction and the render-verbatim instruction both apply to the same
  turn — resolving the real conflict this session observed rather than
  leaving future occurrences to accidental precedent.
- **FR-004**: The precedence rule (FR-003) MUST NOT silently discard
  Principle XXI's orientation goal — even when a continuation instruction
  takes precedence over a verbatim render, the resolution MUST still
  direct the agent to work the session's actual status into its response
  naturally where feasible, rather than dropping the orientation
  requirement entirely.
- **FR-005**: `.specify/memory/constitution.md` MUST be amended (Principle
  XXI) to reflect this precedence clarification, since it changes what
  "the agent renders it" actually requires in a previously-unanticipated
  case — a MINOR version bump (materially expanded guidance to an
  existing principle), following this session's own established
  amendment pattern.

### Key Entities

- **SessionStart Observation**: the specific, transcript-verifiable
  evidence (exact banner text, feature-status counts, selected Yoda
  line, and the fact it fired as `SessionStart:compact`) this closure
  cites — not a paraphrase or a claim without the underlying quoted
  content.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: T020 and Principle XXI's traceability row both cite real,
  quotable evidence instead of repeating a now-stale "not yet observed"
  claim.
- **SC-002**: `CLAUDE.md` states an explicit, checkable precedence rule
  for the continuation-vs-verbatim-render conflict — a future session
  encountering the same situation has a documented answer, not an
  accidental one.
- **SC-003**: The constitution amendment passes the same validation every
  prior amendment this session passed (`scripts/validate.sh`, no
  unexplained bracket tokens, version/date consistency).

## Assumptions

- This feature closes a verification gap and documents a governance
  clarification — it does not build new mechanism code. `scripts/
  session-start.sh`/`.ps1` themselves are unchanged.
- The `SessionStart:compact` observation is treated as satisfying SC-003
  (feature 015)'s intent — a real, harness-triggered firing of the exact
  registered hook mechanism — even though it was not a from-scratch
  `startup` matcher specifically. This distinction is stated explicitly
  in T020's update (FR-001) rather than glossed over.
