# Implementation Plan: `specjedi-*` Skill Catalog Completeness & SDD Coverage Audit

**Branch**: `049-skill-catalog-sdd-audit` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/049-skill-catalog-sdd-audit/spec.md`

## Summary

Adds a new skill, `specjedi-catalog-audit`, that (1) cross-checks
`references/what-is-sdd.md`'s own 7-phase SDD sequence against the
current 27-skill catalog to confirm no stage is missing now that
`speckit-*` (the last vendored comparison point) is gone, (2) reuses
`specjedi-skill-review`'s already-proven per-skill methodology across
every skill at once rather than one at a time, and (3) classifies every
finding into exactly one of three categories — SDD-Coverage Gap,
Skill-Quality Finding, or Redundancy — so the two different problem
classes never get conflated.

## Technical Context

**Language/Version**: N/A — a new Claude Code skill (`SKILL.md` prompt
file), reasoning-driven like every other `specjedi-*` audit skill.

**Primary Dependencies**: None new. Reuses three already-shipped
artifacts directly: `specjedi-skill-review`'s own per-skill check
methodology (self-invoked once per skill, not re-implemented),
`references/what-is-sdd.md`'s own stated phase sequence (the SDD-
coverage cross-reference source), and
`references/quickstart-guide.md`'s own discipline categorization
(Core Pipeline / Onboarding & Guidance / Quality & Review / Meta &
Tooling).

**Storage**: N/A — read-only, same guarantee `specjedi-skill-review`/
`specjedi-constitution-audit` already provide; writes nothing.

**Testing**: No new CI job — reasoning-driven, matching
`specjedi-govcheck`/`specjedi-constitution-audit`/`specjedi-skill-
review`'s own established precedent. Validated via a real dry-run
against this project's own actual 27-skill catalog before shipping
(Principle IX).

**Target Platform**: N/A — no script involved.

**Project Type**: One new skill added to `.claude/skills/`. No new
project structure.

**Performance Goals**: N/A — a single, on-demand audit pass; not
proactively self-invoked by any other skill (matching
`specjedi-constitution-audit`'s own precedent — re-checking the whole
catalog on every PR would duplicate `specjedi-govcheck`'s per-PR job
for a question that doesn't change on every commit).

**Constraints**: Strictly read-only — never edits a reviewed skill,
matching `specjedi-skill-review`'s own absolute guarantee. Must not
flag an already-documented, legitimate exemption (a skill's own
matching `specs/NNN-<skill-name>/plan.md`) as a false finding — same
discipline `specjedi-skill-review` already applies one skill at a time.
Every finding MUST resolve to exactly one of three categories (FR-004)
— never left uncategorized. The new skill's own token count MUST stay
under Constitution Principle XIX's 5,000-token hard cap (specs/045
precedent) — reusing `specjedi-skill-review`'s methodology by
self-invocation rather than restating its full checklist inline is
what keeps this feasible.

**Scale/Scope**: One new skill file
(`.claude/skills/specjedi-catalog-audit/SKILL.md`), zero new scripts or
reference docs — the three source-of-truth documents this audit reads
against (`references/what-is-sdd.md`, `references/quickstart-guide.md`,
`references/skill-authoring-standard.md`) all already exist.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II (Competitive Research Before Creation) | No new mechanism invented — reuses `specjedi-skill-review`'s already-shipped per-skill methodology and `references/what-is-sdd.md`'s already-established SDD definition, confirmed by reading both directly before writing this plan. | ✅ Pass |
| IX (Mandatory Skill Validation & Testing) | No CI job, matching the established precedent for reasoning-driven audit skills; validated via a real dry-run against the actual current 27-skill catalog before shipping. | ✅ Pass |
| XII (Star Wars-Flavored Voice) | New skill gets its own genuine Persona/voice, consistent with sibling audit skills (`specjedi-constitution-audit`'s unhurried-clerk framing, `specjedi-skill-review`'s exacting-instructor framing) — not a copy of either. | ✅ Pass — enforced during implementation |
| XV (`specjedi-` Naming Convention) | New skill named `specjedi-catalog-audit`, correct prefix, subject-specific name. | ✅ Pass |
| XVII (Skill Discovery & Gap-Filling) | Self-invokes `specjedi-find-skills` if a finding needs domain expertise nothing installed covers, matching every other audit skill's own established pattern. | ✅ Pass |
| XIX (Skill Authoring & Prompt Engineering Standard) | The new skill's own token count is checked before shipping (target: comparable to sibling audit skills, ~3,000-3,500 tokens, comfortably under the 5,000 hard cap) — achievable specifically because Step 3 self-invokes `specjedi-skill-review` rather than re-stating its full checklist inline. | ✅ Pass — enforced during implementation |
| XX (AI Discipline: Grounded, Honest Output) | Every SDD-Coverage Gap/Skill-Quality/Redundancy finding must cite the specific skill, phase, or file it's grounded in — never a vague impression. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/049-skill-catalog-sdd-audit/
├── plan.md              # This file
├── research.md          # Phase 0 output — the new-skill-vs-extend decision
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — same reasoning as
`specjedi-constitution-audit`/`specjedi-skill-review` themselves and
every recent meta-capability feature in this project: no entities, no
interface contract, and verification is a real dry-run against the
actual current skill catalog, not a separate runnable scenario doc.

### Source Code (repository root)

```text
.claude/skills/
└── specjedi-catalog-audit/
    └── SKILL.md          # NEW — whole-catalog completeness + SDD
                           #   coverage audit
```

### Implementation notes for `speckit-tasks`/`speckit-implement`

**Step-by-step shape for the new skill**:

1. **Enumerate the catalog**: `ls .claude/skills/ | grep '^specjedi-'`
   (27 as of this writing), classify each into its discipline
   (Core Pipeline / Onboarding & Guidance / Quality & Review / Meta &
   Tooling) per `references/quickstart-guide.md`'s own existing
   categorization — never invent a new taxonomy.
2. **SDD-coverage cross-reference** (User Story 1, FR-002/FR-007): map
   each of `references/what-is-sdd.md`'s 7 phase-sequence activities
   (establish rules, specify, clarify, plan, break into tasks,
   implement, verify) to the skill(s) that perform it. Report each
   phase Covered (naming the skill) or Gap (naming the missing
   capability specifically). Judge coverage against this document
   alone — never against `speckit-*`, which no longer exists
   (specs/048).
3. **Per-skill quality pass** (User Story 2, FR-003/FR-005): for each
   of the 27 skills, apply the same structural-presence, content-depth,
   voice, chain-of-thought-exemption-cross-reference, and token-budget
   checks `specjedi-skill-review` already performs (self-invoke it, or
   apply its exact documented method inline — either way, never
   redefine a second version of that methodology). Cross-reference each
   skill's own matching `specs/NNN-<skill-name>/plan.md` before
   reporting an exemption-shaped finding, exactly as
   `specjedi-skill-review`'s own Step 5 already requires. Aggregate
   into one combined per-skill PASS/finding table, not 27 separate
   reports.
4. **Redundancy pass** (User Story 3, FR-004/FR-008): look for two or
   more skills solving the identical need with no documented design
   rationale for the split. Recognize already-documented, deliberate
   multi-skill splits (e.g., `specjedi-implement`/`specjedi-quick`,
   specs/028) as Covered, not Redundant — cross-reference the relevant
   `plan.md`/`research.md` before calling anything redundant.
5. **Classify and report**: every finding gets exactly one label —
   SDD-Coverage Gap / Skill-Quality Finding / Redundancy — plus a
   concrete next step (Principle XIV).

**Self-check before shipping (Principle XIX gate)**: run `wc -c`
against the new `SKILL.md`, confirm it stays comfortably under the
5,000-token hard cap (÷4 approximation) — if it's creeping close,
tighten Step 3's description to a pointer at `specjedi-skill-review`'s
own method rather than restating any part of it.

**Real dry-run before shipping (Principle IX)**: run the new skill
against this project's own actual 27-skill catalog once fully written;
confirm the report's own SDD-coverage table and per-skill table both
look correct against what's really installed today, and that the
already-known `specjedi-implement`/`specjedi-quick` split is correctly
recognized as Covered, not Redundant.
