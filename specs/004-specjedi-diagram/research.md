# Research: `specjedi-diagram`

**Feature**: 004-specjedi-diagram

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

`references/skill-roadmap.md` ranks `specjedi-diagram` next after
`specjedi-onboard` (feature 002) and `specjedi-migrate` (feature 003):
"generates a Mermaid diagram... applying Principle XVI automatically
instead of requiring the user to ask for one by hand each time." Every
diagram in this repo's own README and `specs/*/plan.md` files has, until
now, been hand-authored by whichever skill/session produced it — there is
no dedicated, reusable mechanism a user (or another `specjedi-*` skill)
can call to turn a spec/plan into a diagram on demand. Principle XVI
already mandates Mermaid-first documentation; this skill is what makes
that mandate actually actionable rather than something each future skill
re-implements ad hoc.

## Genuine contribution beyond the researched field

None of the eleven tools researched (spec-kit + the ten from feature 001,
re-checked here for diagram-generation tooling) ship a dedicated
diagram-generation skill that **verifies the diagram actually renders
before presenting it** — every competitor that outputs Mermaid (a few do,
inconsistently) treats syntax validity as the model's problem, not
something checked. This project already has a working verification
mechanism available in this environment
(`mcp__claude_ai_Mermaid_Chart__validate_and_render_mermaid_diagram`,
used throughout this repo's own README updates this session) — no
researched competitor's diagram output goes through an equivalent
render-check step. `specjedi-diagram` is the first `specjedi-*` skill
built around "validate before presenting" for a non-textual artifact,
extending the same verification discipline Principle IX already requires
for skills in general to a new artifact type.

## Baseline: GitHub spec-kit

No diagram-generation command in its command surface (`constitution`,
`specify`, `clarify`, `plan`, `tasks`, `implement`, `analyze`,
`checklist`). Diagrams, if any, are hand-authored by the user. **Adopt**:
nothing (no mechanism to adopt). **Reject**: none applicable.

## Researched competitors (re-checked for diagram-generation tooling)

1. **BMAD-METHOD** — no dedicated diagram generation found in its agent
   command set.
2. **OpenSpec** — lightweight-path philosophy; no diagram tooling found.
3. **Kiro** — spec-driven with structured requirement docs; no diagram
   generation mechanism found in its public surface.
4. **Tessl** — no diagram tooling found.
5. **Spec Kitty** — CLI wizard scope; no diagram generation.
6. **Superpowers** (installed, inspected firsthand) — no diagram-generation
   skill in its set.
7. **GSD** (installed, inspected firsthand) — `gsd-roadmapper` and related
   agents produce structured roadmap docs, not diagrams; no Mermaid
   generation mechanism found.
8. **PRP** (installed, inspected firsthand) — no diagram tooling; the
   golden-rule pattern is orthogonal.
9. **codemyspec.com** — web UI may render diagrams visually, but no
   portable Mermaid-source generation mechanism comparable to a
   file-based skill.
10. **Traycer** — plan-review focused; no diagram-generation mechanism
    found.

Every researched tool leaves diagramming entirely to the user, same
finding pattern as feature 003's migration-tooling research. **Adopt**:
nothing directly transferable — this confirms the gap.

## Design implications for `specjedi-diagram`

- **Diagram type MUST match content, not default to one shape**: a spec's
  user-story flow suggests a flowchart, a data model suggests an ER
  diagram, an interaction between actors/systems suggests a sequence
  diagram. Guessing the wrong type produces a diagram nobody finds useful
  — this is a real judgment call, not a formality.
- **MUST validate before presenting** (the genuine contribution above) —
  render-check every generated diagram using the available Mermaid
  validation mechanism before showing it to the user; a diagram that
  fails to render is worse than no diagram, since it wastes the user's
  time debugging syntax that was never this skill's job to get wrong.
- **MUST stay a supplement, never diagram-only** (Principle XVI's own
  explicit requirement) — always accompanied by the prose it visualizes,
  never presented as a replacement for the spec/plan text itself.
- **Source of truth is the existing spec/plan, not invention** — every
  node/edge in a generated diagram MUST trace to something the spec/plan
  actually says, mirroring `specjedi-checklist`'s "grounded, not generic"
  discipline (feature 001) applied to a different artifact type.
