# Feature Specification: Theme-Safe, Right-Sized Mermaid Diagrams for `specjedi-diagram`

**Feature Branch**: `025-diagram-readability`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description (Portuguese): "revise /specjedi-diagram para criar
gráficos mermaid que funcionem bem tanto no dark mode quando light mode e
possam ser lidos sem precisar aumentar o tamanho, ou seja, gráficos muito
grandes devem ser repensados em gráficos menos para melhorar a
visualizacao de humano que irá ler o gráfico." (Revise `specjedi-diagram`
to produce Mermaid diagrams that work well in both dark mode and light
mode and can be read without needing to zoom in — i.e., overly large
diagrams should be rethought into fewer/smaller diagrams to improve
readability for the human viewing them.)

## Problem

`specjedi-diagram`'s current `SKILL.md` (156 lines) has no guidance at
all on two real, observed failure modes:

1. **Theme fragility**: nothing in the skill's Step-by-step, Always/Never,
   or Format sections addresses color choices. A generated diagram that
   hardcodes explicit `style`/`classDef` fill or text colors (a common
   Mermaid authoring habit) can render illegibly in whichever theme
   (GitHub light vs. dark, or a harness's own light/dark toggle) that
   diagram's hardcoded colors weren't chosen for — e.g. dark text on a
   dark-mode-transparent background, or a pale fill against a light
   background losing all contrast.
2. **Unbounded size**: nothing caps node count, subgraph count, or
   overall diagram complexity. A diagram can grow as large as the source
   content technically supports, with no point at which the skill
   reconsiders whether one large diagram should become two or three
   smaller, focused ones.

This spec revises `specjedi-diagram` (and its canonical reference,
`references/mermaid-diagram-catalog.md`, per the existing pattern where
that catalog already carries the type-selection guidance this skill
reads) to close both gaps.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A generated diagram stays legible in both light and dark mode (Priority: P1)

A user viewing a `specjedi-diagram` output on GitHub (which auto-switches
between light/dark per the viewer's OS/browser setting) or in a harness
with its own dark mode wants the diagram to remain readable regardless of
which theme is active, without the skill needing to ask which theme the
user prefers.

**Why this priority**: This is the core of the user's request and the
more universally-hit failure mode — every generated diagram is affected,
not just large ones.

**Independent Test**: Generate a diagram for a representative spec/plan,
inspect its Mermaid source for any explicit color directive, and confirm
either (a) no explicit fill/stroke/text color is set (the diagram
inherits the renderer's own theme, which is theme-safe by construction),
or (b) any explicit color used is verified to hold sufficient contrast
against both a light and a dark background.

**Acceptance Scenarios**:

1. **Given** a request for a diagram, **When** `specjedi-diagram`
   generates Mermaid source, **Then** the source contains no `style`/
   `classDef` node-fill or text-color override, so the diagram renders
   using the host renderer's own theme (light or dark) automatically.
2. **Given** a case where a color-coded distinction genuinely adds
   information (e.g., status coloring: done vs. blocked), **When** the
   skill uses an explicit color, **Then** it documents why plain
   shape/label distinction wasn't sufficient and uses a theme-neutral
   approach (Mermaid's own theme variables, not a single hardcoded hex
   pair) — resolved in Phase 0 research below.

---

### User Story 2 - An overly large diagram is split into smaller, focused diagrams (Priority: P1)

A user requesting a diagram for a large or complex spec/plan wants
several smaller, individually legible diagrams (each covering one
coherent sub-concern) rather than one sprawling diagram that only
becomes readable after zooming in.

**Why this priority**: Equally central to the user's request — "gráficos
muito grandes devem ser repensados em gráficos menos" is a direct,
explicit ask, not a nice-to-have.

**Independent Test**: Generate a diagram for a spec/plan whose content
would naturally produce a large single diagram (many user stories, many
steps); confirm the skill instead proposes multiple smaller diagrams,
each independently legible, with a one-line note on how they relate.

**Acceptance Scenarios**:

1. **Given** source content whose natural diagram would exceed a defined
   complexity threshold (concrete number resolved in Phase 0 research),
   **When** `specjedi-diagram` runs, **Then** it splits the content into
   multiple smaller diagrams along a natural seam in the source (e.g.,
   one per user story, one per phase) rather than presenting one
   oversized diagram.
2. **Given** source content that fits comfortably under the threshold,
   **When** the skill runs, **Then** it presents a single diagram as
   before — the threshold must not cause unnecessary splitting of
   already-legible diagrams.
3. **Given** a split into multiple diagrams, **When** they're presented,
   **Then** each carries a short label identifying which part of the
   whole it covers, so the set reads as one coherent picture across
   several frames, not disconnected fragments.

---

### User Story 3 - The complexity/theme rules are render-verified, not just asserted (Priority: P2)

A user trusts that `specjedi-diagram`'s theme-safety and size guidance
are actually checked, the same way render-verification already checks
syntax validity today.

**Why this priority**: Lower than P1 because the P1 stories already
define the *rules*; this story ensures the skill's own existing
render-verification step (Step 4 today) also becomes the enforcement
point for the new rules, rather than the rules existing only as prose
the model may or may not follow under real load.

**Independent Test**: Confirm the skill's Step-by-step section
explicitly folds a "no hardcoded theme-unsafe color" self-check and a
"under the complexity threshold" self-check into the existing
render-verification step, not as a separate, skippable step.

**Acceptance Scenarios**:

1. **Given** a generated diagram, **When** the skill reaches its
   render-verification step, **Then** it also confirms (self-check, not
   a new external tool) that no theme-unsafe explicit color was used and
   that the diagram is within the complexity threshold, revising before
   presenting if either check fails.

### Edge Cases

- What happens when the source content is inherently a single, tightly
  coupled unit (e.g., a 4-state state diagram) that's borderline over
  the node threshold but has no natural seam to split along? → the skill
  should not force an artificial split; the threshold is a trigger to
  *reconsider*, not an unconditional hard cap (documented explicitly so
  a future reader doesn't over-mechanize it).
- What happens when a user explicitly asks for "one big diagram anyway"?
  → an explicit user request overrides the default splitting behavior;
  the skill still applies the theme-safety rule (that one has no
  legitimate reason to override, unlike size).
- What happens when the harness's render-verification mechanism
  (`mcp__claude_ai_Mermaid_Chart__validate_and_render_mermaid_diagram` in
  this environment) is unavailable? → matches the skill's existing
  documented fallback (explicit unverified caveat) — the new self-checks
  for theme/size are still performed even when live rendering isn't
  available, since they're static source inspection, not a rendering
  capability.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-diagram` MUST NOT emit explicit `style`/`classDef`
  node-fill, background, or text-color overrides by default — generated
  Mermaid source relies on the rendering surface's own theme so it
  adapts automatically to light/dark mode.
- **FR-002**: When a color-coded distinction is genuinely load-bearing
  (not decorative), `specjedi-diagram` MUST use an approach verified
  (Phase 0 research) to remain legible in both a light and a dark
  background, and MUST NOT use a single hardcoded hex pair chosen for
  only one theme.
- **FR-003**: `specjedi-diagram` MUST evaluate generated diagram
  complexity (node count, subgraph count, and/or source line count —
  concrete metric and threshold defined in Phase 0 research) before
  presenting it.
- **FR-004**: When a diagram would exceed the complexity threshold,
  `specjedi-diagram` MUST split the content into multiple smaller
  diagrams along a natural seam in the source content, each labeled with
  which part of the whole it covers, rather than presenting one
  oversized diagram.
- **FR-005**: `specjedi-diagram` MUST NOT split content that is under the
  threshold or has no natural seam to split along — splitting is a
  readability tool, not a mandatory transformation applied unconditionally.
- **FR-006**: The skill's existing render-verification step MUST also
  perform the theme-safety and complexity self-checks from FR-001–FR-004,
  folded into that same step rather than added as a separate, skippable
  step.
- **FR-007**: `references/mermaid-diagram-catalog.md` MUST carry the
  canonical theme-safety and complexity-threshold guidance (mirroring
  how it already carries the canonical type-selection guidance this
  skill already reads), so the rule is defined once and referenced, not
  duplicated ad hoc inside `SKILL.md`.
- **FR-008**: An explicit user request for a single large diagram (Edge
  Cases) MUST override the default splitting behavior; the theme-safety
  rule (FR-001/FR-002) has no equivalent override, since there's no
  legitimate reason a user would want an illegible-in-one-theme diagram.

### Key Entities

- **Complexity threshold**: a concrete, numeric trigger point (defined in
  Phase 0 research) for reconsidering a single diagram as multiple
  smaller ones.
- **Theme-safe color policy**: the rule set governing when (rarely, if
  ever) an explicit color is permitted in generated Mermaid source, and
  what makes a chosen color "safe" across both themes.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of diagrams generated by the revised
  `specjedi-diagram` contain zero explicit theme-unsafe color overrides,
  verified by inspecting generated source for `style`/`classDef` fill/
  color directives.
- **SC-002**: 100% of diagrams generated for source content exceeding the
  defined complexity threshold are split into multiple smaller diagrams,
  each individually under the threshold.
- **SC-003**: A diagram generated under the revised skill, when rendered
  against both a light-background and a dark-background surface, remains
  legible (no text/fill contrast failure) in both — spot-checked via the
  render-verification tool's output during this feature's own
  implementation.
- **SC-004**: `scripts/validate.sh`'s existing structural lint continues
  to pass for `specjedi-diagram/SKILL.md` after the revision (frontmatter,
  required sections intact).

## Assumptions

- **Scope boundary**: this feature revises `specjedi-diagram`'s
  generation *rules* (`SKILL.md` + `mermaid-diagram-catalog.md`). It does
  NOT retroactively re-generate or audit diagrams already shipped
  elsewhere in this repository (e.g., README.md's existing Mermaid
  diagrams) — that would be a separate, explicitly-scoped follow-up, not
  implied by "revise `specjedi-diagram`."
- The complexity threshold is a single, documented number (not a range or
  a per-diagram-type table) unless Phase 0 research finds a strong reason
  a single number doesn't fit — simpler to state and check, consistent
  with Principle XIX's "quantifiable, not vague" requirement.
- "Dark mode" and "light mode" are interpreted broadly (GitHub's own
  auto-switching Mermaid rendering, and any harness/IDE with its own
  light/dark toggle) rather than one specific product's exact color
  values — the fix (avoid hardcoded theme-committed colors) is the same
  regardless of which specific dark/light pair is in play.
- This is a revision to an already-shipped, already-governed skill
  (feature 004), not a new skill — Principle XV naming/Principle XIX
  authoring-standard structure already apply and aren't re-litigated
  here, only the content addressed by this spec.
