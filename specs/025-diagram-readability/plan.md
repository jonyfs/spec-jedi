# Implementation Plan: Theme-Safe, Right-Sized Mermaid Diagrams for `specjedi-diagram`

**Branch**: `025-diagram-readability` | **Date**: 2026-07-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/025-diagram-readability/spec.md`

## Summary

Revise `specjedi-diagram/SKILL.md` and its canonical reference
`references/mermaid-diagram-catalog.md` to add two rules that don't exist
today: (1) never emit explicit Mermaid `style`/`classDef`/`theme` color
overrides, so every generated diagram inherits the rendering surface's
own light/dark theme automatically instead of breaking GitHub's (and most
harnesses') auto dark/light switching; (2) cap generated diagrams at 20
nodes (or "can't describe in one sentence"), splitting larger content
into multiple smaller diagrams along a natural seam instead of one
oversized diagram requiring zoom. Both checks fold into the skill's
existing render-verification step rather than becoming a separate,
skippable step.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo — this is a content
revision to an already-shipped skill (feature 004), not new code.

**Primary Dependencies**: Unchanged from feature 004 — a Mermaid
render-verification mechanism when the harness provides one (this
environment:
`mcp__claude_ai_Mermaid_Chart__validate_and_render_mermaid_diagram`);
falls back to an explicit unverified-caveat path when absent. The new
theme-safety/complexity self-checks (research.md, Decision 1/2) are
static source inspection, so they don't add a new dependency.

**Storage**: Unchanged — reads an existing `spec.md`/`plan.md`; writes
nothing by default.

**Testing**: Principle VI exemption, same as feature 004's own plan —
this feature's deliverable is `SKILL.md`/reference-doc prompt content,
not application code with unit-testable business logic. Verification is
(a) `scripts/validate.sh`/`.ps1`'s existing structural lint (SC-004), and
(b) a scenario-based dry run: regenerate a diagram for real spec/plan
content already in this repo and confirm the revised rules actually
changed the output (no color directives; a genuinely large source gets
split).

**Target Platform**: Unchanged — Claude Code today (Principle III), same
per-harness mapping convention as every other skill.

**Project Type**: Skill pack (single project, no new subsystem) —
revision only, no new files beyond the two already-existing ones this
feature touches.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle II (competitive research)**: N/A in the "benchmark against
  ten competitors" sense — this revises an already-shipped, already-
  benchmarked skill's content rather than introducing a new structural
  pattern. The two new rules are instead grounded directly in cited
  external documentation/community evidence (`research.md` Decisions
  1–2), satisfying Principle XX's grounding requirement, which is the
  applicable discipline for a content fix like this one.
- **Principle XVI (Efficient Documentation & Mermaid Diagram Literacy)**:
  this feature is a direct extension of that principle's own mandate —
  it doesn't just pick the right diagram *type*, it now also ensures the
  chosen diagram is actually legible once rendered (right-sized,
  theme-safe), which is squarely inside "documentation that conveys
  content most directly."
- **Principle XIX (Skill Authoring Standard, "ruthless literalness")**:
  the complexity threshold (research.md Decision 2) is a concrete,
  quantified number (20 nodes) specifically because Principle XIX
  forbids vague, unmeasurable requirements like "not too big."
- **Principle XX (grounded, honest output)**: both new rules trace to a
  cited source (GitHub Community discussions, Mermaid's own theming
  docs, a cited practitioner best-practices post) rather than asserted
  from memory — `research.md` documents the citations directly.
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

### Documentation (this feature)

```text
specs/025-diagram-readability/
├── plan.md              # This file
├── research.md           # Phase 0 output — theme-safety + complexity-threshold decisions, cited
├── spec.md               # Feature specification
└── tasks.md              # Phase 2 output (/speckit-tasks — not created by this command)
```

No `data-model.md` or `contracts/`: this feature has no data entities and
no external interface — same as feature 004's own plan, which also
omitted both for the same reason (a `SKILL.md` prompt-content feature,
not a data/API feature).

### Source Code (repository root)

```text
.claude/skills/specjedi-diagram/
└── SKILL.md                              # revised: theme-safety + complexity rules folded into Step 4
references/
└── mermaid-diagram-catalog.md            # revised: new canonical "Theme Safety" and "Complexity Threshold" sections
specs/025-diagram-readability/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

**Structure Decision**: single project, revision-only — two existing
files touched, no new skill, no new subsystem. Matches feature 004's own
"skill pack, single project" structure decision exactly, since this is a
revision to that same skill.

## Design: the two new rules, made concrete

- **Theme safety (FR-001/FR-002, research.md Decision 1)**: `SKILL.md`'s
  Step 4 (render-verification) gains an explicit self-check — before
  presenting, scan the generated source for `style `, `classDef `, or
  `%%{init` directives; if found, remove them and re-express any
  distinction they carried via shape, edge style, or label text/emoji
  instead. The skill's Always/Never list gains a paired
  Always ("rely on the rendering surface's own theme; never hardcode a
  color")/Never ("never emit an explicit style/classDef/theme color
  override") entry — matching this constitution's existing "every
  prohibition MUST be paired with the alternative" guardrail
  (Principle XIX).
- **Complexity threshold (FR-003/FR-004/FR-005, research.md Decision
  2)**: Step 2 (type inference) gains a companion complexity check run
  immediately after generation, before presenting: tally nodes (or the
  equivalent unit for non-flowchart types — tasks for Gantt, classes for
  a class diagram, etc.) and check the "one sentence to describe it"
  qualitative backstop. Above 20 (or failing the one-sentence test),
  identify the natural seam in the source content (one user story, one
  phase, one subsystem) and present multiple smaller diagrams instead,
  each carrying a one-line label naming which part of the whole it
  covers (FR-004's labeling requirement). FR-005's "don't force a split"
  and the Edge Cases' "no natural seam" / "user explicitly wants one big
  diagram" cases become explicit exceptions documented alongside the
  rule, not silently handled.
- **`references/mermaid-diagram-catalog.md` update (FR-007)**: gains two
  new sections, "Theme Safety" and "Complexity Threshold," mirroring the
  file's existing structure (a canonical reference other skills could
  also consult, not duplicated ad hoc per-skill) — `SKILL.md` references
  these sections rather than restating the full rationale inline, the
  same pattern it already uses for the diagram-type catalog itself.
- **Render-verification folding (FR-006, User Story 3)**: both self-checks
  are explicitly stated as part of Step 4, not a new Step 5 — so a
  harness without live Mermaid rendering still performs them (they're
  static source inspection), and a harness with live rendering performs
  them as part of the same "verify before presenting" gate the skill
  already has, rather than introducing a second, separately-skippable
  verification path.
- **Worked example update**: the existing Step-by-step "Example (input →
  output)" section's sample diagram is re-checked against both new rules
  (it already has zero `style`/`classDef` directives and is well under 20
  nodes, so it needs no content change — but the surrounding prose gains
  a one-line note confirming it already passes both checks, so the
  example stays internally consistent with the rules it's meant to
  illustrate).
