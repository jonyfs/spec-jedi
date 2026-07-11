# Feature Specification: `specjedi-diagram`

**Feature Branch**: `004-specjedi-diagram`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Build specjedi-diagram, the next item in
references/skill-roadmap.md's proposed-but-not-yet-built backlog: generates
a Mermaid diagram (flow, sequence, or ER as appropriate) from an existing
spec/plan on request, applying Principle XVI automatically instead of
requiring the user to ask for one by hand each time."

## Clarifications

### Session 2026-07-11

Run autonomously per the maintainer's standing instruction to proceed
through roadmap work and resolve what can reasonably be judged, deferring
only genuine blockers. Each answer applies research.md's findings rather
than guessing fresh.

- Q: How should `specjedi-diagram` decide which diagram type (flowchart,
  sequence, ER) to generate? → A: Infer from content, with an explicit
  reasoning step, not a fixed default — a spec dominated by prioritized
  user-story flow suggests a flowchart, a data model section suggests an
  ER diagram, a description of actor/system interaction over time
  suggests a sequence diagram. If genuinely ambiguous (the source content
  doesn't clearly favor one type), ask the user rather than guessing.
- Q: Must every generated diagram be render-verified before being shown
  to the user? → A: Yes — this is the skill's genuine contribution
  (research.md). A diagram presented without a render check is exactly
  the failure mode this skill exists to prevent.
- Q: Should `specjedi-diagram` ever replace the prose it visualizes? → A:
  No, never — Principle XVI is explicit that a diagram is a supplement,
  not a replacement. The skill always keeps (or points back to) the
  source prose; it augments a doc, it doesn't shrink one.
- Q: Where does a generated diagram get written — inline in the response
  only, or persisted to a file? → A: Inline in the response by default
  (matches how every diagram in this repo's own README/plan.md files has
  been produced this session — reviewed and placed by whoever's writing
  the doc); the skill offers to also write it into the target doc file at
  a specified location if the user confirms, but never silently inserts
  itself into a file without that confirmation.
- Q: Does this skill need its own `--auto` flag given every other pipeline
  skill has one? → A: Yes, for consistency (feature 001 FR-008
  precedent) — in `--auto` mode it still asks if the diagram type is
  genuinely ambiguous (per the first clarification above); auto mode
  narrows confirmation pauses, it doesn't replace a genuine unresolved
  choice with a guess.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Generate a diagram from an existing spec or plan (Priority: P1)

A user with an existing `spec.md` or `plan.md` asks for a diagram of the
feature's flow (or its data model, or an interaction sequence). The skill
determines the right diagram type from the source content, generates
Mermaid source grounded entirely in what the spec/plan actually says,
render-verifies it, and presents it alongside — never in place of — the
prose it visualizes.

**Why this priority**: The entire reason this skill exists — without it,
Principle XVI's mandate stays something each skill/session re-implements
by hand instead of a reusable mechanism.

**Independent Test**: Given a `spec.md` with 2+ prioritized user stories,
request a diagram and verify the output is a flowchart whose nodes trace
to the actual user stories, that it passed a render-verification check
before being presented, and that the original spec prose is still present
alongside it.

**Acceptance Scenarios**:

1. **Given** a `spec.md` with prioritized user stories and no explicit
   data model section, **When** the user asks for a diagram, **Then** the
   skill generates a flowchart (not an ER diagram) whose nodes trace to
   the actual stories, and reports that it render-verified the result
   before presenting it.
2. **Given** a `plan.md` with a clearly described data model section,
   **When** the user asks for a diagram, **Then** the skill generates an
   ER diagram reflecting the actual entities/relationships described, not
   a generic flowchart.

---

### User Story 2 - Ambiguous source content triggers a question, not a guess (Priority: P2)

A user asks for a diagram of content that doesn't clearly favor one
diagram type (e.g., a short spec excerpt with both story flow and a
data-model hint, roughly equal weight). The skill asks which type is
wanted rather than picking one and hoping.

**Why this priority**: Prevents the failure mode of a wrong-type diagram
that isn't obviously wrong until the user reads it and realizes it doesn't
show what they wanted.

**Independent Test**: Given source content with no clear single-type
signal, request a diagram and verify the skill asks for the type rather
than guessing, even in `--auto` mode.

**Acceptance Scenarios**:

1. **Given** source content with no dominant flow/data-model/sequence
   signal, **When** the user requests a diagram (including with `--auto`
   set), **Then** the skill asks which diagram type is wanted rather than
   picking one silently.

### Edge Cases

- A diagram fails render-verification: the skill MUST NOT present a
  broken diagram — it revises the Mermaid source and re-checks, reporting
  the retry if one was needed, rather than showing a diagram it knows is
  invalid (resolved, Clarifications Session 2026-07-11 — validate-before-
  presenting is non-negotiable).
- The Mermaid validation mechanism isn't available in the current harness:
  the skill states that plainly and offers the unverified diagram source
  with an explicit caveat, rather than silently skipping verification
  without saying so.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-diagram` MUST infer the diagram type (flowchart,
  sequence, or ER) from the actual source content, reasoning through the
  decision explicitly, rather than defaulting to one type.
- **FR-002**: `specjedi-diagram` MUST ask the user which diagram type is
  wanted when the source content doesn't clearly favor one, in both
  interactive and `--auto` modes.
- **FR-003**: `specjedi-diagram` MUST render-verify every generated
  diagram before presenting it to the user, and MUST NOT present a
  diagram known to fail that check.
- **FR-004**: `specjedi-diagram` MUST ground every node/edge in the
  generated diagram in content the source spec/plan actually states —
  never inventing detail to fill out the shape.
- **FR-005**: `specjedi-diagram` MUST present the diagram as a supplement
  alongside the source prose, never as a replacement for it (Principle
  XVI).
- **FR-006**: `specjedi-diagram` MUST NOT write a diagram into a target
  file without the user's explicit confirmation — inline presentation in
  the response is the default; persisting to a file is opt-in.
- **FR-007**: `specjedi-diagram` MUST support `--auto` (feature 001 FR-008
  precedent), narrowing confirmation pauses without replacing a genuinely
  ambiguous diagram-type decision with a guess.

### Key Entities

- **Diagram request**: one `specjedi-diagram` invocation, producing
  exactly one render-verified Mermaid diagram (or a clarifying question,
  if the type is ambiguous) grounded in a named source spec/plan.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every diagram presented to the user has passed a render-
  verification check — checkable by the skill's own reported confirmation
  of that check having run.
- **SC-002**: Every node/edge in a generated diagram traces to specific
  content in the named source spec/plan — verified by manual cross-check
  against the source during the dry run.
- **SC-003**: A diagram-type decision on ambiguous source content produces
  a question, not a silently-picked type, in 100% of ambiguous cases
  exercised during the dry run.

## Assumptions

- This is its own feature cycle, following the same incremental discipline
  as features 001-003 — `specjedi-diagram` ships alone; the remaining
  roadmap items (`specjedi-status`, `-retro`, `-security`, `-docs`) each
  get their own research pass per Principle II when their turn comes.
- The render-verification mechanism assumed available is whatever the
  current harness exposes for Mermaid validation (in this environment,
  `mcp__claude_ai_Mermaid_Chart__validate_and_render_mermaid_diagram`); a
  harness without an equivalent falls back to the stated-caveat path in
  Edge Cases above, per Principle III's per-harness mapping convention.
