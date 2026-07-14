# Research: Skill Validation & Testing Framework Compliance Audit

**Goal**: resolve the one real technical unknown this feature has —
FR-003's requirement for "a single, stated, consistently-applied rule per
category," not 24 separate ad hoc judgment calls that could classify the
same underlying behavior differently across skills. This file states
those four rules once, applies them to all 24 shipped `specjedi-*`
skills, and records the resulting applicability table Phase 2
(`tasks.md`) decomposes into per-skill work.

## Principle II note

This feature audits and revises this project's own existing skill
documentation against an already-adopted internal framework
(`references/skill-validation-testing-framework.md`, itself the product
of Principle II reasoning at the framework level when it was created).
There is no new external competitor to research here — the "genuine
contribution" this feature makes is closing a real, measured internal
compliance gap (0 of 24 skills cited the framework, confirmed by
`grep -rl "skill-validation-testing-framework" .claude/skills/specjedi-*/SKILL.md`
returning nothing), not a claim about the outside field.

## The four applicability rules

### Rule 1 — Vague / Incomplete Input Handling

**Applicable** to any skill whose primary invocation is a free-form,
natural-language user request or description the skill must interpret,
where genuine ambiguity is possible. **Not Applicable** to skills that
operate on already-existing, structured on-disk artifacts with no fresh
open-ended request to interpret at invocation time.

### Rule 2 — Prompt Injection Resistance

**Applicable** to any skill whose step-by-step reads the *prose* content
of a pre-existing artifact this invocation didn't just author itself —
scoped, per the framework's own four named examples (spec.md, a fetched
web page, a PR description, a target project's existing files), to:
`spec.md`/`plan.md`/`tasks.md`/`constitution.md`, another skill's
`SKILL.md` (a real attack surface: a compromised PR could plant
instructions in one), fetched web pages, PR descriptions/diffs, a target
project's existing files, or contributor-authored git commit messages.
**Not Applicable** to skills that only check system/tool state, only
read structured non-prose data (file/directory names, checkbox counts)
without treating prose as instructions, or only write fresh content
without reading any in-scope pre-existing prose.

### Rule 3 — Out-of-Bounds / Malformed Input Handling

**Applicable** to any skill that parses structured input with an
expected shape — a CLI-style flag or argument, a `spec.md`/`plan.md`/
`tasks.md`'s expected section structure, a named harness/skill/PR
identifier — and must handle an absurd, malformed, or missing instance.
**Not Applicable** to skills with no structured-input-parsing step of
their own (pure free-form narration or full delegation to another,
separately-audited skill's own parsing).

### Rule 4 — External-Call Resilience

**Applicable** to any skill that itself calls an external service
(GitHub API/`gh` CLI, WebSearch/WebFetch, any network call) as part of
its own function. **Not Applicable** to skills that only read/write
local files and git state, never making a network call themselves.

## Applicability table (all 24 shipped `specjedi-*` skills)

| Skill | Cat 1 Vague | Cat 2 Injection | Cat 3 Malformed | Cat 4 External |
|---|---|---|---|---|
| `specjedi-onboard` | Applicable | Applicable (reads `constitution.md`) | N/A | N/A |
| `specjedi-constitution` | Applicable | Applicable (reads existing `constitution.md`) | Applicable (template/placeholder parsing) | N/A |
| `specjedi-specify` | Applicable | Applicable (reads `constitution.md` for context) | Applicable (spec-template structure) | N/A |
| `specjedi-clarify` | N/A | Applicable (reads `spec.md`) | Applicable (spec section structure) | N/A |
| `specjedi-plan` | N/A | Applicable (reads `spec.md`/`constitution.md`) | Applicable (spec structure) | Applicable (Principle II research: WebSearch/WebFetch) |
| `specjedi-tasks` | N/A | Applicable (reads `plan.md`) | Applicable (plan's Constitution Check state) | N/A |
| `specjedi-implement` | N/A | Applicable (reads `tasks.md`/`plan.md`) | Applicable (tasks.md checklist format) | Applicable (`gh pr create`/`merge`) |
| `specjedi-quick` | Applicable | N/A (writes fresh from live request, no pre-existing artifact read) | Applicable (5-criterion eligibility + quick.md template) | Applicable (`gh pr merge --auto`) |
| `specjedi-analyze` | N/A | Applicable (reads spec/plan/tasks/constitution) | Applicable (missing-file case) | N/A |
| `specjedi-checklist` | Applicable | Applicable (reads spec/plan) | Applicable (empty/nonsensical focus area) | N/A |
| `specjedi-converge` | N/A | Applicable (reads `tasks.md`) | Applicable (fully-checked-off tasks.md) | N/A |
| `specjedi-find-skills` | Applicable | N/A (reasons over ecosystem, not an in-scope artifact) | N/A | Applicable (external skill registry checks) |
| `specjedi-explain` | Applicable | N/A (answers from internal SDD knowledge) | N/A | N/A |
| `specjedi-migrate` | N/A | Applicable (target project's existing files) | Applicable (project with no `/speckit-*` refs) | N/A |
| `specjedi-diagram` | N/A | Applicable (reads spec/plan) | Applicable (no diagram-worthy structure) | Applicable (live render-verification call) |
| `specjedi-status` | N/A | Applicable (reads spec/plan/tasks/quick.md) | Applicable (unrecognized checkbox line — already named in Step 3) | N/A |
| `specjedi-retro` | N/A | Applicable (reads `plan.md`) | Applicable (plan with no clear decisions to compare) | N/A |
| `specjedi-security` | N/A | Applicable (reads spec/plan it's invoked against) | N/A (no structured field of its own) | N/A |
| `specjedi-docs` | N/A | Applicable (reads spec/plan) | Applicable (spec/plan missing expected sections) | N/A |
| `specjedi-new-skill` | Applicable | N/A (scaffolds fresh placeholders) | Applicable (name collision/naming-convention violation) | N/A |
| `specjedi-release` | N/A | Applicable (contributor-authored commit messages) | Applicable (no tags yet / malformed version) | N/A (local git only; the separate `release.yml` workflow, not this skill, publishes) |
| `specjedi-skill-review` | N/A | Applicable (reads the target skill's own `SKILL.md`) | Applicable (skill missing multiple required sections) | N/A |
| `specjedi-tokencheck` | N/A | N/A (presence checks only) | N/A | N/A |
| `specjedi-govcheck` | N/A | Applicable (reads PR diff/description) | Applicable (inaccessible PR — already named in Step 1) | Applicable (`gh pr diff <N>`) |

**Totals**: Cat 1 — 8 Applicable / 16 N/A. Cat 2 — 17 Applicable / 7 N/A.
Cat 3 — 17 Applicable / 7 N/A. Cat 4 — 6 Applicable / 18 N/A. Every one of
the 96 cells (24 skills × 4 categories) got an explicit status — zero
silently skipped, per FR-001/SC-001.

## Decision: cross-reference existing content where it already exists, write new scenarios only where genuinely missing

**Decision**: per FR-005, before writing a new scenario for an Applicable
cell, check whether that skill's own existing `Example (input → output)`,
`Edge Cases`/`Always/Never`, or step-by-step content already demonstrates
the behavior. Where it does, the fix is a one-line cross-reference, not
duplicated prose. Where it doesn't, write a new, concrete, skill-specific
scenario naming real input and real expected behavior (never a generic
restatement of the category's own definition, per FR-002).

**Rationale**: many skills already have relevant content by construction
— `specjedi-implement`'s branch-check discipline already handles a
malformed-state edge case, `specjedi-status`'s Step 3 already names
"unrecognized checkbox-like lines," `specjedi-govcheck`'s Step 1 already
states the empty-diff/inaccessible-PR behavior. Rewriting these as new
prose would be redundant, not more thorough.

**Alternatives considered**: write a uniform new scenario for every
Applicable cell regardless of existing content — rejected, directly
contradicts FR-005 and would produce duplicated, drift-prone prose across
two sections of the same file.

## Decision: one new `## Validation Coverage (Principle IX)` section per skill, added after `Verifiable success criteria`

**Decision**: each of the 24 skills gets one new section, placed as the
final section of the file, with exactly four lines (one per category)
in the fixed order Cat 1 → Cat 2 → Cat 3 → Cat 4, each stating
Applicable/Not Applicable and the one-line reason or cross-reference/new
scenario.

**Rationale**: SC-004 requires a future reader to determine compliance
status by reading the skill's own `SKILL.md` alone — a single, clearly
labeled, consistently-placed section satisfies this directly. Placing it
after `Verifiable success criteria` (rather than interleaving into
existing sections) keeps every other section's content undisturbed,
minimizing diff noise across 24 files for a documentation-only feature.

**Alternatives considered**: interleave each category's coverage
statement into the section it's most related to (e.g., Cat 1 into
`Autonomous vs. confirm-first`) — rejected, this scatters the answer
SC-004 needs to be findable in one place across multiple sections,
working against the "read the skill alone" requirement rather than for
it.

## Decision: wire into `specjedi-skill-review`, not a new skill (FR-006, US3)

**Decision**: add this framework's four categories as an explicit review
dimension in `specjedi-skill-review`'s existing step-by-step, alongside
its current section-content/legitimate-exemption checks — not a new,
second review skill.

**Rationale**: `specjedi-skill-review` already exists specifically to
audit a `specjedi-*` skill's `SKILL.md` against a documented standard
(the Skill Authoring Standard, Principle XIX); this framework is exactly
that shape of standard. Inventing a second review skill would duplicate
`specjedi-skill-review`'s entire existing mechanism for one additional
dimension, violating this project's own avoid-internal-redundancy
discipline (spec.md's own Assumptions section, Principle II).
