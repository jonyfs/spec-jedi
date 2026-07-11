# Implementation Plan: The `specjedi-*` SDD Pipeline

**Branch**: `001-specjedi-pipeline` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/001-specjedi-pipeline/spec.md`

## Summary

Build the `specjedi-*` product skill pipeline that replaces the vendored
`speckit-*` bootstrap tooling as Spec Jedi's actual end-user-facing product
(Constitution Principle XV). This cycle implements **P1
(`specjedi-constitution`)** and **P2 (`specjedi-specify`)** fully, to the
project's own Skill Authoring & Prompt Engineering Standard (Principle XIX),
proving the pattern before P3-P9 are attempted in a later cycle (per spec.md's
Assumptions — better to ship two rigorous skills than nine rushed ones).

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format); Bash
(POSIX, per Principle XIII) for any backing scripts, with a PowerShell (`.ps1`)
counterpart required for every script per the same principle.

**Primary Dependencies**: None beyond what Claude Code (and, per Principle III,
eventually other harnesses) already provides — no new external services, no
API keys. Optional: `git` for any script that inspects repo state.

**Storage**: Plain files — `.specify/memory/constitution.md`,
`specs/NNN-feature/spec.md`, in whichever project has Spec Jedi installed (this
repo, or an end user's own project). No database.

**Testing**: Structural lint via `scripts/validate.sh`/`scripts/validate.ps1`
(extended in this feature — see below) plus scenario-based dry runs per the
Skill Authoring Standard's review checklist. No unit-test framework applies;
these are prompt artifacts, not executable application code.

**Target Platform**: Claude Code today (Principle III); designed with
per-harness `<runtime_note>`-style mapping (research.md #7) so a future
harness port doesn't require rewriting the skill body.

**Project Type**: Skill pack (not a web/mobile/service app) — single project
structure, skills live under `.claude/skills/`.

**Performance Goals**: N/A in the traditional sense — "performance" here means
the Skill Authoring Standard's token budget (core `SKILL.md` under ~500 tokens
ideal, ~5,000 hard cap, Principle XIX).

**Constraints**: Every requirement from spec.md's Functional Requirements
(FR-001 through FR-009) applies directly as a design constraint on both
skills. Must not modify or remove any existing `speckit-*` skill (spec.md
Assumptions).

**Scale/Scope**: 2 new skills this cycle (`specjedi-constitution`,
`specjedi-specify`), each a single `SKILL.md` plus optional `references/`
material, following the existing repo convention.

## Constitution Check

*GATE: Must pass before task breakdown. Re-checked after design below.*

| Principle | Check | Status |
|---|---|---|
| II (Competitive Research) | `research.md` written before any design work, benchmarks spec-kit + 10 others | ✅ Pass — see `research.md` |
| IV (Structured Elicitation) | Both skills must ask bulleted questions, never guess on ambiguity | ✅ Designed in (see Design sections below) |
| V (Spec Completeness) | `specjedi-specify` must mark unresolved ambiguity as `NEEDS CLARIFICATION`, never silently assume | ✅ Directly required (carried into skill body) |
| IX (Skill Validation) | Both skills need a lint + scenario dry run before merge | ✅ `scripts/validate.sh` structural check already covers frontmatter; scenario dry run performed manually pre-merge (documented in tasks.md) |
| XII (Voice) | End-user-facing output uses Spec Jedi's voice; literal spec/constitution field content stays precise | ✅ Designed in — voice confined to the skill's own chat responses, not generated file content |
| XIII (Cross-Platform) | Any new script ships `.sh` + `.ps1` | N/A this cycle — no new scripts required (skills are pure `SKILL.md`, reuse existing `scripts/validate.sh`) |
| XIV (Guided Next Step) | Every skill ends with a bulleted next-step suggestion | ✅ Designed in |
| XV (Naming & Positioning) | Skills named `specjedi-constitution`/`specjedi-specify`; never present `speckit-*` as the product | ✅ Directly enforced by this plan |
| XVII (Gap-Filling Contract) | Both skills must honor `specjedi-find-skills`' proactive self-check contract | ✅ Designed in |
| XIX (Skill Authoring Standard) | Persona, task, format, few-shot example, chain-of-thought, Always/Never, verifiable criteria | ✅ Applied to both skills (see Design below) |

No violations requiring a Complexity Tracking table — omitted (N/A, no gate
failures).

## Project Structure

### Documentation (this feature)

```text
specs/001-specjedi-pipeline/
├── plan.md              # This file
├── research.md          # Phase 0 output (competitive research, already written)
└── spec.md              # Feature spec with Clarifications integrated
```

(No `data-model.md`/`contracts/` — this feature produces prompt artifacts, not
a data-backed service; the "data model" is fully captured as Key Entities in
spec.md.)

### Source Code (repository root)

```text
.claude/skills/
├── specjedi-constitution/
│   └── SKILL.md          # NEW — this cycle
├── specjedi-specify/
│   └── SKILL.md          # NEW — this cycle
├── specjedi-find-skills/ # existing, unchanged
└── speckit-*/             # existing bootstrap tooling, unchanged (spec.md Assumptions)
```

**Structure Decision**: Single project, skills-only — matches every other
`specjedi-*`/`speckit-*` skill already in this repo. No new top-level
directories needed.

## Design: `specjedi-constitution`

- **Persona**: a governance-minded collaborator who pushes back on
  under-specified principles rather than rubber-stamping them (mirrors this
  very skill's own behavior throughout this session).
- **Task**: given a plain-language description of a project's rules, produce
  or amend a `.specify/memory/constitution.md` with correct versioning and a
  Sync Impact Report — the same job `speckit-constitution` does, reframed in
  Spec Jedi's own voice and with FR-008's `--auto` flag support.
- **Format**: exact `constitution.md` structure (Core Principles, Governance,
  Version line) — reuses the existing `.specify/templates/constitution-template.md`
  as the underlying contract, since that template is generic infrastructure,
  not `speckit-*`-branded content (FR-009's read-compatibility applies).
- **Chain-of-thought**: version-bump classification (MAJOR/MINOR/PATCH) is a
  judgment call — the skill must reason through it explicitly, not
  pattern-match.
- **Proactive gap-check**: if the user's described domain touches something
  clearly outside general SDD governance (e.g., detailed legal/compliance
  language), self-invoke `specjedi-find-skills`.
- **`--auto` behavior** (FR-008): ask any genuinely blocking questions (e.g.,
  project name if not inferable) up front; once answered, complete the
  constitution without further stops.

## Design: `specjedi-specify`

- **Persona**: a collaborator who welcomes a rough, one-sentence idea rather
  than expecting a fully-formed feature description (research.md #6,
  Superpowers' brainstorm-before-spec instinct, adapted without a separate
  mandatory meta-layer).
- **Task**: turn that idea into a prioritized (P1/P2/P3...), independently
  testable `spec.md`, per `.specify/templates/spec-template.md`.
- **Format**: exact `spec.md` structure (User Scenarios, Requirements, Success
  Criteria) — same template reuse rationale as above.
- **Chain-of-thought**: prioritization (what's P1 vs P2 vs P3) is a judgment
  call requiring explicit reasoning about independent value, not a lookup.
- **Ambiguity handling**: anything genuinely unclear MUST be marked `NEEDS
  CLARIFICATION` in the generated spec (Principle V) rather than assumed —
  mirrors this very plan's own spec.md, which had its markers resolved via
  `speckit-clarify` (the vendored bootstrap counterpart) earlier in this cycle.
- **Proactive gap-check**: if the described feature clearly needs a domain
  skill unrelated to spec-writing itself (e.g., "spec out a Stripe billing
  flow" when no billing-domain skill is installed), self-invoke
  `specjedi-find-skills`.

## Design: `specjedi-clarify`

- **Persona**: a precise interrogator, not a chatty one — asks exactly what
  materially changes the design, never pads the question count to look
  thorough. Mirrors the mechanics `speckit-clarify` already proved
  live this session (research.md decision #1: adopt the phase structure
  wholesale) — this feature's own `spec.md` had five ambiguities resolved
  through exactly this process, using `speckit-clarify`, earlier in this
  cycle.
- **Task**: scan `spec.md` for ambiguity/coverage gaps across a fixed
  taxonomy (functional scope, data model, UX flow, non-functional
  qualities, integration points, edge cases, terminology), ask up to 5
  targeted questions, and write accepted answers back into a
  `## Clarifications` / `### Session YYYY-MM-DD` block in `spec.md`,
  resolving each flagged `NEEDS CLARIFICATION` marker in place.
- **Format**: `- Q: <question> → A: <final answer>` per accepted answer,
  immediately followed by integrating that answer into the relevant
  spec section (Functional Requirements, Edge Cases, Success Criteria,
  etc.) — never batch all integration to the end, since a later question's
  answer might make an earlier draft answer obsolete.
- **Chain-of-thought**: which of the many possible ambiguities are worth
  one of the 5 question slots is a judgment call — reason through an
  impact × uncertainty ranking explicitly (a question that would reshape
  the data model outranks a cosmetic wording ambiguity), don't just ask
  in the order gaps were noticed.
- **Audience calibration** (Principle XIX): every multiple-choice question
  MUST present a **Recommended** option with one or two sentences of
  reasoning up front, before the options table. A beginner gets a safe
  default explained in plain terms; an advanced user can override in one
  word ("B") or accept the recommendation ("yes") without reading the
  reasoning at all — the same question serves both without a separate
  "beginner mode."
- **`--auto` behavior**: apply each question's own Recommended answer
  automatically, still writing the full `- Q: ... → A: ...` audit trail so
  the choices remain reviewable — never skip logging just because no
  human was asked in the moment.
- **Proactive gap-check**: if resolving an ambiguity clearly requires
  domain expertise outside general SDD scope (e.g., specific regulatory
  language), self-invoke `specjedi-find-skills` before finishing that
  question.
