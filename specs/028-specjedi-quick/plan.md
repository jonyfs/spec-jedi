# Implementation Plan: `specjedi-quick`

**Branch**: `028-specjedi-quick` | **Date**: 2026-07-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/028-specjedi-quick/spec.md`

## Summary

Ship `specjedi-quick`, the 24th `specjedi-*` skill: a lightweight,
one-artifact path for small, well-understood changes, validated by
BMAD-METHOD's Quick Flow and OpenSpec's three-command model
(research.md). Produces a single `quick.md` (What & Why, Concrete
Changes, Acceptance Checks, Status) instead of the full `spec.md`+
`research.md`+`plan.md`+`tasks.md` set, then proceeds straight to
implementation — while still enforcing an explicit eligibility check,
Principle VI test-first, and the same `specjedi-govcheck`/PR discipline
`specjedi-implement` already uses. Also extends `specjedi-status` to
recognize `quick.md` (FR-006), closing a real cross-skill compatibility
gap this new artifact type would otherwise create.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill.

**Primary Dependencies**: None beyond `git` (matches `specjedi-implement`'s
own compatibility line) — self-invokes `specjedi-govcheck` before opening
a PR, same as `specjedi-implement`.

**Storage**: Writes `specs/NNN-name/quick.md`; writes code/config per its
own Concrete Changes section; updates `quick.md`'s `Status:` line in
place, mirroring how `specjedi-implement` updates `tasks.md` checkboxes
in place.

**Testing**: Principle VI applies in full on the fast path (FR-004) — NOT
exempted. Where the eligible change involves code, test-first execution
is required exactly as `specjedi-implement` already requires it. This
feature's own deliverable (the skill file + the `specjedi-status`
compatibility edit) is prompt content, not application code, so *this
feature's own* Principle VI applicability follows the same exemption
precedent as every other skill-content feature this repo has shipped
(features 004, 025, 026) — verified instead via a manually-constructed
`quick.md` fixture (spec.md SC-003) and a scenario dry run per Principle
IX.

**Target Platform**: Claude Code today (Principle III), same per-harness
convention as every other skill.

**Project Type**: Skill pack (single project) — one new skill, one small
compatibility edit to an existing skill.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle II (competitive research, NON-NEGOTIABLE)**: satisfied in
  full — `research.md` benchmarks BMAD-METHOD's Quick Flow and OpenSpec's
  three-command model specifically for this feature (not reused from an
  older pass), names what's adopted/rejected from each, and states a
  genuine contribution (a lightweight path that's still constitution-
  gated, which neither competitor's own fast path is).
- **Principle XV (`specjedi-` naming)**: `specjedi-quick` — a Spec-Jedi-
  authored product skill, named per convention.
- **Principle XIX (Skill Authoring Standard)**: full structure applies —
  frontmatter, persona, step-by-step, example, `--auto` mode, Always/
  Never, verifiable success criteria — this is a new skill, the full bar
  applies, not the lighter revision bar used for features 025/026.
- **Principle XVII (Skill Discovery)**: `specjedi-quick` self-invokes
  `specjedi-find-skills` if a request needs implementation expertise
  nothing installed covers, matching `specjedi-implement`'s own existing
  wiring.
- **Principle IX (validation battery)**: structural lint (`scripts/
  validate.sh`) plus a scenario dry run covering both an eligible request
  (produces `quick.md`, implements) and an ineligible one (declines,
  redirects) — the "vague/incomplete input" and "out-of-bounds input"
  categories from `references/skill-validation-testing-framework.md`
  (v1.24.0) applied directly to eligibility-boundary testing.
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

### Documentation (this feature)

```text
specs/028-specjedi-quick/
├── plan.md              # This file
├── research.md           # Phase 0 — BMAD Quick Flow + OpenSpec citations
├── spec.md               # Feature specification
├── checklists/requirements.md
└── tasks.md              # Phase 2 output (/speckit-tasks — not created here)
```

No `data-model.md`/`contracts/` — no data entities, no external
interface (a new skill's own internal `quick.md` template is documented
directly in this plan's Design section instead).

### Source Code (repository root)

```text
.claude/skills/specjedi-quick/
└── SKILL.md                              # NEW
.claude/skills/specjedi-status/
└── SKILL.md                              # revised: recognizes quick.md
README.md                                  # +1 skill-table row, +quickstart mention
references/skill-roadmap.md                # Shipped entry
CHANGELOG.md                               # +1 entry
specs/028-specjedi-quick/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

**Structure Decision**: single project, one new skill + one small
compatibility edit — same shape as every prior `specjedi-*` skill
addition (features 009-013).

## Design: `specjedi-quick`

- **Persona**: a triage medic — decides fast whether this needs the full
  operating theater or a bandage, and never pretends a bandage will hold
  when it won't.
- **Task**: given a change request, run the eligibility checklist
  (FR-001); if eligible, write one `quick.md`, implement it test-first
  where code is involved, self-invoke `specjedi-govcheck`, open a PR; if
  not eligible, decline and redirect to `specjedi-specify`.
- **Eligibility checklist, made concrete** (FR-001): five explicit,
  checkable criteria — (a) fits in roughly one page of notes, (b)
  single-subsystem, (c) no genuine unresolved ambiguity, (d) not a new
  `specjedi-*` skill, (e) not a constitution amendment. All five MUST
  pass; any single failure redirects.
- **`quick.md` template** (FR-002):
  ```markdown
  # Quick: <one-line title>

  **Status**: Proposed

  ## What & why
  <one paragraph>

  ## Concrete changes
  - <file/behavior touched>

  ## Acceptance checks
  - [ ] <checkable item>
  ```
- **Straight to implementation** (FR-003): no separate plan/tasks
  invocation — the agent reasons directly from `quick.md`'s Concrete
  Changes list to actual edits, the same "reason from the artifact, don't
  re-derive it" discipline `specjedi-implement` already applies to
  `tasks.md`.
- **Quality gates preserved** (FR-004): mirrors `specjedi-implement`'s
  own Step 1 (branch check before first edit), test-first sequencing
  where code is involved, Step 6.5 (`specjedi-govcheck` self-invoke
  before opening a PR), and Step 7's honest auto-merge-request language
  verbatim ("requests merge... whether it happens is the target repo's
  own CI/branch-protection decision, never this skill's to claim or
  force") — no new PR/merge behavior invented, the existing one reused.
- **Mid-flight escalation** (FR-005): if the change grows past
  eligibility while `quick.md` is being written or implemented, state
  this plainly, stop, and hand off `quick.md`'s content to
  `specjedi-specify` as a starting point.
- **`Status: Implemented`** (FR-007): set once implementation completes
  and the PR opens — read by `specjedi-status`'s new detection branch.

## Design: `specjedi-status` compatibility edit

Add one new branch to Step 3's existing derivation list (research.md's
Cross-skill compatibility section): a directory containing only
`quick.md` reports status from that file's own `Status:` line and
Acceptance Checks `- [x]`/`- [ ]` count, using the exact same 0%/1-99%/
100% → not-started/in-progress/complete mapping `tasks.md` already uses
— one more branch in an existing derivation rule, not a second detection
mechanism.
