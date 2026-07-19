# Research: `specjedi-*` Skill Catalog Completeness & SDD Coverage Audit

**Feature**: specs/049-skill-catalog-sdd-audit
**Date**: 2026-07-18

No `NEEDS CLARIFICATION` markers remain in spec.md. This document
resolves the one real technical design question the spec's own
Assumptions section deferred here: does this ship as a new skill, or
an extended mode of `specjedi-skill-review`?

## Decision 1: New skill (`specjedi-catalog-audit`), not an extended mode of `specjedi-skill-review`

**Decision**: This feature ships as a new, distinct skill —
`specjedi-catalog-audit` — rather than a "check all skills" flag or
mode bolted onto `specjedi-skill-review`.

**Rationale**: `specjedi-skill-review`'s own reasoning model, read
directly before this decision (Principle II applied to this project's
own existing tooling, not just external research), is built around a
single target: "given the name of a shipped `specjedi-*` skill, check
its `SKILL.md`..." — its Persona ("an exacting proving-ground
instructor") and every one of its steps assume one trainee under
review at a time. This feature needs three things that model cannot
naturally produce:

1. **Catalog enumeration** — nothing in `specjedi-skill-review` reads
   `.claude/skills/` as a whole; it's handed one name and starts there.
2. **Cross-artifact SDD-phase mapping** (User Story 1) — checking
   whether `references/what-is-sdd.md`'s 7 phases are each covered by
   *some* skill is a fundamentally different question from "is *this*
   skill's own `SKILL.md` well-formed" — the former reasons about the
   skill *set*, the latter about one file's own content.
3. **Cross-skill redundancy detection** (User Story 3) — determining
   whether two skills overlap requires holding both in view
   simultaneously; a single-target reviewer structurally cannot do
   this no matter how it's invoked.

This is the same reasoning specs/043 already used to justify
`specjedi-constitution-audit` as a distinct skill from
`specjedi-govcheck`: "needed a different skill specifically because its
reasoning model (whole-tree, never a diff) was structurally
incompatible with `specjedi-govcheck`'s diff-scoped model." Here, the
same structural incompatibility exists between a whole-catalog-plus-
cross-skill-comparison model and `specjedi-skill-review`'s
single-target model.

**What actually gets reused, not reinvented**: `specjedi-skill-review`'s
own per-skill methodology (structural presence, content depth, voice,
chain-of-thought-exemption cross-reference, token budget) is the
*literal* check `specjedi-catalog-audit` applies to each of the 27
skills in User Story 2 — by self-invocation or by applying its exact
documented method, never by writing a second, parallel version of the
same checklist. The new skill's own added value is the catalog-level
and cross-skill reasoning around that reused core, not a replacement
for it.

**Alternatives considered**:
- Add a `--all`/batch flag to `specjedi-skill-review` that loops it
  over every skill. Rejected: even if implemented, this would still
  only produce 27 independent single-skill reports — it has no natural
  place to put SDD-phase-coverage reasoning or cross-skill redundancy
  detection, since its own Persona and Format are built around judging
  one file against a standard, not judging a set against a methodology
  and against itself. Bolting those two additional reasoning models
  onto an existing single-purpose skill would dilute its own clarity,
  the exact concern specs/043's Decision 1 already raised about keeping
  `specjedi-govcheck` and `specjedi-constitution-audit` separate.
- Fold this into `specjedi-constitution-audit` instead, since it's also
  a whole-project, never-a-diff audit. Rejected: that skill's own scope
  is explicitly the 22 Constitution Principles plus the two
  cross-cutting sections — a governance-compliance question. Skill
  *authoring-standard* completeness and SDD-*phase* coverage are a
  different axis entirely (Principle XIX-shaped and
  methodology-shaped, not principle-compliance-shaped); conflating them
  would mean one report trying to answer two structurally different
  questions.

## Summary of touched files

| File | Change |
|---|---|
| `.claude/skills/specjedi-catalog-audit/SKILL.md` | NEW — whole-catalog completeness + SDD coverage audit |

No new scripts, no new reference files, no new dependencies — every
source-of-truth document this audit reads against
(`references/what-is-sdd.md`, `references/quickstart-guide.md`,
`references/skill-authoring-standard.md`,
`references/skill-validation-testing-framework.md`) already exists.
