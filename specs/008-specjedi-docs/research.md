# Research: `specjedi-docs`

**Feature**: 008-specjedi-docs

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

`references/skill-roadmap.md` ranks `specjedi-docs` last in the original
backlog: "generates end-user-facing documentation (README sections,
changelog entries) from a shipped spec/plan, kept in sync instead of
drifting from what actually got built." This is the final roadmap item —
and unusually well-evidenced by this very project's own development
history: every one of the seven prior roadmap-item ships this session
(features 002-007) required manually updating README.md's skill table,
Quickstart numbering, and roadmap references by hand, plus
`references/skill-roadmap.md`'s own proposed→shipped migration — the
exact category of repetitive, easy-to-drift-from-reality work
`specjedi-docs` exists to automate. This project is its own best case
study for the problem.

## Genuine contribution beyond the researched field

None of the eleven tools researched (spec-kit + the ten from feature 001,
re-checked here for doc-generation tooling) ship a mechanism that derives
README/changelog updates **from the same artifacts the SDD pipeline
already produces** — every researched tool treats documentation as a
separate, manually-maintained surface with no structural link back to
spec/plan. The genuine contribution here is narrower and more honest than
"generate all your docs": `specjedi-docs` updates only the specific,
bounded doc surfaces this project's own README already has a stable shape
for (a skill-table row, a Quickstart step, a changelog entry) — grounded
in what a shipped spec/plan actually states, never inventing marketing
copy or feature claims the spec doesn't support.

## Baseline: GitHub spec-kit

No end-user-doc-generation command in its surface. **Adopt**: nothing (no
mechanism to adopt). **Reject**: none applicable.

## Researched competitors (re-checked for doc-generation tooling)

1. **BMAD-METHOD** — no doc-generation mechanism found in its agent set.
2. **OpenSpec** — no doc-generation tooling found.
3. **Kiro** — no doc-generation mechanism found in its public surface.
4. **Tessl** — no doc-generation tooling found.
5. **Spec Kitty** — CLI wizard scope; no doc-generation mechanism.
6. **Superpowers** (installed, inspected firsthand) — has a general
   `doc-updater`-style pattern in some configurations for internal
   codemaps, but not end-user-facing README/changelog generation from SDD
   artifacts specifically.
7. **GSD** (installed, inspected firsthand) — `gsd-doc-writer` writes and
   updates project documentation from a `doc_assignment` block — the
   closest researched analog. **Adopt**: the instinct that doc generation
   should be a distinct, structured skill role rather than folded into
   implementation; **adapt, don't copy**: GSD's mechanism is driven by an
   explicit assignment block a human or orchestrator constructs, while
   `specjedi-docs` here derives its update directly from a shipped
   spec/plan with no separate assignment step, and is scoped specifically
   to this project's own bounded README/changelog surfaces rather than
   general project documentation.
8. **PRP** (installed, inspected firsthand) — no doc-generation mechanism.
9. **codemyspec.com** — no comparable doc-generation-from-artifacts
   mechanism found.
10. **Traycer** — plan-review focused; no doc-generation mechanism found.

**Adopt**: GSD's "doc generation is its own skill role" instinct, adapted
to derive directly from spec/plan rather than a separately-constructed
assignment.

## Design implications for `specjedi-docs`

- **Scope to this project's own bounded doc surfaces** — a skill-table
  row, a Quickstart step, and a changelog entry — not open-ended
  "generate documentation," which risks inventing content a spec doesn't
  support.
- **Grounding discipline**: every generated doc line MUST trace to
  something the shipped spec/plan actually states — the same discipline
  `specjedi-checklist` and `specjedi-diagram` already apply to their own
  artifact types, applied here to doc prose.
- **Changelog is a new, durable append-only log** (`CHANGELOG.md` at repo
  root, standard convention, distinct from `.specify/memory/skill-gaps.md`
  and `.specify/memory/retro-log.md`, which are internal signal logs, not
  end-user-facing) — created on first use.
- **Triggers on request, post-completion** — like `specjedi-retro`, this
  operates on a feature that's actually shipped, not a work-in-progress
  one, since documenting an unfinished feature risks documenting
  something that might still change.
