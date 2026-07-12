# Research: Competitive Comparison Table

**Feature**: 014-competitive-comparison

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — normally
requires benchmarking against spec-kit plus at least ten other tools before any new
skill/workflow/structural pattern ships. This feature is explicitly exempt from
performing *new* research: it does not add a skill, workflow, or structural
pattern — it packages research already completed and cited for feature 001.

## Decision: reuse, don't re-research

**Decision**: this document intentionally contains no new competitor
research. The single source of truth for every comparative claim in
`references/competitive-comparison.md` is
[`specs/001-specjedi-pipeline/research.md`](../001-specjedi-pipeline/research.md),
which already benchmarks spec-kit (baseline) plus ten named competitors —
BMAD-METHOD, OpenSpec, Kiro, Tessl, Spec Kitty, Superpowers, GSD, PRP,
Traycer, and codemyspec.com — each with a documented Good/Poor assessment
and an explicit adopt/adapt/reject decision.

**Rationale**: `spec.md`'s Assumptions section already scopes this
feature to exactly that 11-tool field, not an invitation to expand it.
Performing fresh WebSearch research on each of the eleven tools' current
2026 state would risk two things this feature is specifically designed to
avoid: (1) introducing claims that drift from what `research.md` actually
says (a second, competing source of truth for the same comparisons), and
(2) violating Principle XX's grounding requirement by citing something
*newer but unverified* over something *older but already checked and
cited* in this repository. Reorganizing and tabulating an existing,
trustworthy source is the correct move here, not re-deriving it.

**Alternatives considered**: re-running WebSearch against each of the 11
tools to refresh the comparison with 2026-current details (e.g., version
numbers, star counts) — rejected for this feature. If any researched
tool's public information has materially changed since
`specs/001-specjedi-pipeline/research.md` was written, that's a signal
for a future, explicitly-scoped research refresh of *that document*
(the authoritative source), not something to silently fork into a second,
divergent comparison table.

## What Phase 0 would normally resolve — already resolved

There are no `NEEDS CLARIFICATION` markers in `spec.md` and no unknown
dependency, integration, or best-practice question this feature needs
resolved before Phase 1 — the entire technical surface is "write a table
that accurately reflects an existing document," which `spec.md`'s
Functional Requirements already define completely.
