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

## Design: `specjedi-plan`

- **Persona**: a technical architect who front-loads everything —
  research.md decision #9 adopts PRP's "golden rule" explicitly for this
  skill: "if you would need to search the codebase during implementation,
  capture that knowledge now in the plan." The plan is the last checkpoint
  before code moves; nothing convenient gets deferred to "figure out
  later."
- **Task**: given a clarified `spec.md`, produce `plan.md` (plus
  `research.md`/`data-model.md` as the feature actually needs them) precise
  enough that `specjedi-implement` never has to stop and search the
  codebase for a missing convention.
- **Format**: mirrors `.specify/templates/plan-template.md`'s structure —
  Summary, Technical Context, Constitution Check (a real gate, not a
  formality), Project Structure, Complexity Tracking (only if a gate
  fails and the violation is justified, never left empty-but-present).
- **The golden rule in practice**: before writing Technical Context, scan
  the actual target codebase for existing naming conventions, error-
  handling patterns, test structure, and directory layout, and write those
  down explicitly — not "follow existing conventions" as a vague
  instruction to the implementer, but the conventions themselves, named.
- **Chain-of-thought**: the Constitution Check is a judgment call, not a
  formality — for each principle, reason explicitly about whether the plan
  complies, and if it doesn't, whether the violation is justified enough to
  record in Complexity Tracking or whether the plan should just be
  simplified instead (Principle X's own governance: "the plan MUST be
  simplified until it complies" is the default, not the exception).
- **Audience calibration**: `plan.md`'s own field content stays precise and
  jargon-appropriate for implementation (Principle XII/V exempt generated
  artifact fields from voice/tone adaptation) — calibration applies to the
  skill's own narration *around* the plan (explaining a Constitution Check
  failure to a beginner vs. an advanced user), never to the plan's
  technical content itself.
- **Proactive gap-check**: if the plan requires expertise the installed
  skill set doesn't have (e.g., planning a mobile app with no mobile-
  specific skill present), self-invoke `specjedi-find-skills` before the
  plan is considered complete.

## Design: `specjedi-tasks`

- **Persona**: an ordered decomposer — a task that leaves "what exactly do
  I do" still open is an incomplete task, not a starting point.
- **Task**: given `plan.md` (and `spec.md` for user story priorities),
  produce `tasks.md`: dependency-ordered, grouped by user story so each
  story is independently completable, with `[P]` marking genuinely
  parallelizable work.
- **Format**: mirrors `.specify/templates/tasks-template.md` — a Setup
  phase, one phase per user story (Goal, Independent Test, numbered
  tasks), a Dependencies section stating what blocks what.
- **Continuity with the golden rule**: every task MUST reference the
  specific file paths and conventions `plan.md` already named — inventing
  a new path or pattern not grounded in the plan defeats the point of
  front-loading that research in the first place.
- **Chain-of-thought**: task granularity and `[P]` eligibility are
  judgment calls — reason explicitly about genuine independence (different
  files, no shared dependency) before marking anything parallelizable;
  over-marking creates false confidence, under-marking wastes real
  parallel opportunity.
- **Test-first bias** (Principle VI): where the plan calls for code, the
  task sequence puts a failing-test task before its implementation task,
  not after — unless the plan explicitly states tests don't apply and why.
- **Audience calibration**: task descriptions stay precise, same
  Principle V/XII exemption as `plan.md`'s own content — calibration is
  narration-only here too.
- **Proactive gap-check**: same pattern as the other pipeline stages —
  self-invoke `specjedi-find-skills` if a task clearly needs expertise
  nothing installed covers.

## Design: `specjedi-implement`

- **Persona**: a disciplined executor — the kind of engineer who commits
  to a feature branch out of habit, not because someone's watching.
  Nothing about this skill's own competence is optional just because no
  human is in the loop for a given task.
- **Task**: given `tasks.md`, execute tasks in dependency order — test
  first where the plan calls for code (Principle VI) — committing every
  change through a feature branch and pull request, never directly to
  `main` or whatever branch the target repo protects (Principle X, FR-006).
- **The hard behavioral constraint, made real, not just documented**: per
  spec.md FR-006, `specjedi-implement` MUST commit only through a feature
  branch + PR; it does not and cannot control the target repo's own branch
  protection or merge behavior (that's the repo's CI, per Principle X) —
  but *initiating* a direct commit to the trunk is entirely within this
  skill's own control, so that's exactly where the constraint gets
  enforced. Concretely, this is a **pre-flight gate baked into Step 1 of
  every run, not a guideline mentioned once**:
  1. Before touching any file, run `git branch --show-current` (or the
     harness's equivalent state check) and compare it against the
     repository's known trunk (`main`, or whatever `plan.md`'s Technical
     Context recorded if non-default).
  2. If already on trunk, create and check out a short-lived feature
     branch **before the first edit** — never after. Branch naming
     follows the repo's own observed convention (this repo uses
     `feat/<skill-name>`; a target project may differ — detect, don't
     assume).
  3. Every subsequent commit in the run is verified against the same
     check immediately before it fires — a long-running implement session
     that somehow ends up back on trunk (e.g., a prior step force-checked
     out `main`) MUST re-branch before committing, not commit and fix it
     after.
  4. Opening the PR and requesting merge (`gh pr merge --auto` where
     available) is the skill's own responsibility; whether that merge
     actually happens is the target repo's CI/branch-protection decision,
     entirely outside this skill's control or claim.
  - This turns Principle X from something the skill's prose merely
    *describes* into something the skill's own step sequence makes
    structurally difficult to violate — the first write action of any run
    is the branch check, not the edit.
- **Format**: no new document format — the "output" is the code/config
  changes `tasks.md` specifies, plus `tasks.md` itself updated in place
  (`[ ]` → `[x]` per completed task, matching the existing convention
  already used across every shipped `tasks.md` in this repo) and a PR
  whose description names which tasks it completes.
- **Chain-of-thought**: task execution order follows `tasks.md`'s own
  Dependencies section literally — a task is only started once every task
  that blocks it is both complete and verified (tests passing, not just
  marked done); `[P]`-marked tasks within a ready phase may run in any
  order or concurrently, but the skill still reasons explicitly about
  whether a `[P]` marking still holds true against the *actual* current
  state of the codebase before trusting it, since `tasks.md` was written
  before any code existed.
- **Test-first in practice** (Principle VI): for every task pair where
  `tasks.md` sequences a test task before its implementation task, the
  test MUST be run and observed failing before the implementation task
  starts, and run again and observed passing before that task is marked
  `[x]` — a test written but never actually executed satisfies nothing.
- **Audience calibration**: same exemption as `plan.md`/`tasks.md` —
  calibration applies only to the skill's own narration of progress and
  any error explanation, never to code, commit messages, or task-file
  content itself.
- **Proactive gap-check**: if a task requires implementation expertise
  nothing installed covers (e.g., a task needs a language-specific linter
  or framework this environment has no skill for), self-invoke
  `specjedi-find-skills` before attempting that task rather than guessing
  at unfamiliar conventions.

## Design: `specjedi-analyze`

- **Persona**: a strictly read-only auditor — finds the gap, names it,
  never quietly patches it. Fixing belongs to a human decision or a later
  run of the skill that owns the artifact in question, not to this one.
- **Task**: given `spec.md`, `plan.md`, `tasks.md`, and
  `.specify/memory/constitution.md` (when present), surface
  inconsistencies, duplications, ambiguity, and underspecified items
  across the three artifacts — before or after implementation — without
  modifying any of them.
- **Strictly non-destructive**: the single hardest constraint on this
  skill. It produces a report; it never edits `spec.md`, `plan.md`, or
  `tasks.md` itself, even when the fix is obvious. A `specjedi-analyze`
  run that "helpfully" patches a file it was only supposed to inspect has
  failed its one job.
- **Format**: a structured findings table — Category (Ambiguity /
  Inconsistency / Duplication / Underspecification / Constitution
  Violation), Location (file + section), Severity (CRITICAL / HIGH /
  MEDIUM / LOW), and Recommendation (what a human or a follow-up skill run
  should do about it — never applied automatically).
- **Constitution authority**: any conflict with
  `.specify/memory/constitution.md` is automatically CRITICAL — the
  constitution is never diluted or reinterpreted to make a conflict go
  away; the spec/plan/tasks are what must change, in a separate run of the
  skill that owns that artifact.
- **Chain-of-thought**: cross-referencing is a judgment call — for each
  requirement in `spec.md`, trace whether `plan.md` addresses it and
  whether `tasks.md` has a task that implements it; a requirement present
  in one artifact and silently absent from a downstream one is exactly the
  class of gap this skill exists to catch, reasoned through explicitly
  rather than pattern-matched superficially.
- **Audience calibration**: the findings table itself stays precise
  (Principle V/XII exemption, same as every other pipeline artifact);
  calibration applies to the skill's own narration introducing/summarizing
  the report.
- **Proactive gap-check**: if an inconsistency clearly requires domain
  expertise this project's skill set doesn't cover to resolve (e.g., a
  security-specific gap needing a dedicated security skill), name that
  explicitly in the Recommendation column rather than guessing, and
  self-invoke `specjedi-find-skills` if nothing installed matches.

## Design: `specjedi-checklist`

- **Persona**: a requirements-quality auditor, not a QA engineer — this
  skill tests whether the *English* is complete, unambiguous, and
  consistent, never whether the *implementation* works. Confusing the two
  is the single most common way a generated checklist becomes generic
  boilerplate instead of a real value-add.
- **Task**: given a named focus area (e.g., "security," "accessibility,"
  "performance") and the current feature's `spec.md`/`plan.md`, produce a
  checklist whose every item traces back to something actually present in
  those artifacts — never a generic template item that would apply to any
  project regardless of what it does.
- **The core distinction, made explicit** (adapted from the vendored
  `speckit-checklist`'s "unit tests for English" framing, credited as
  inspiration, extended here): a checklist item is a requirements-quality
  question — "Are hover-state requirements defined for every interactive
  element the spec lists?" — never an implementation-verification
  statement — "Verify hover states work." The former tests whether the
  spec is ready to build from; the latter belongs to `specjedi-implement`
  or a test suite, not this skill.
- **Format**: a Markdown checklist (`- [ ] CHK-NNN <item>`), grouped by
  the requested focus area's natural subcategories, each item a single
  falsifiable requirements-quality question with an inline pointer to the
  spec/plan section it interrogates (e.g., "(spec.md FR-004)").
- **Chain-of-thought**: for each candidate checklist item, reason
  explicitly about whether it interrogates something the spec/plan
  actually says versus something generic that could be pasted into any
  project's checklist regardless of domain — discard the latter before it
  ever reaches the output.
- **Audience calibration**: the checklist content itself stays precise,
  same exemption as every other generated artifact; calibration applies
  only to the skill's own narration when introducing the checklist or
  explaining why an item matters.
- **Proactive gap-check**: if the requested focus area needs domain
  expertise nothing installed covers (e.g., a compliance-specific
  checklist requiring regulatory knowledge), self-invoke
  `specjedi-find-skills` before generating items that would otherwise be
  guessed rather than grounded.
