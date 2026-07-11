# Implementation Plan: `specjedi-govcheck`

**Branch**: `013-specjedi-govcheck` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/013-specjedi-govcheck/spec.md`

## Summary

Build `specjedi-govcheck`, a strictly read-only skill that diffs the
current branch (or a named open PR) against `main`, reasons per Core
Principle (all 20 plus the two cross-cutting sections) whether the
changeset is Not Applicable, Compliant, or Non-Compliant, and reports any
constitution conflict as CRITICAL — mechanizing the Development Workflow
section's own "review MUST explicitly check compliance with every Core
Principle" requirement, closing CHK005. Proactively self-invoked by
`specjedi-implement` right before opening a PR, surfacing CRITICAL
findings without blocking PR-opening itself.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: `git diff main` (default mode); `gh pr diff <N>`
(named-PR mode, requires `gh` CLI, already a project-wide dependency for
every shipped feature's own PR workflow). Reads
`references/principle-traceability.md` for per-principle mechanism
context.

**Storage**: Read-only; writes nothing (FR-004's absolute boundary).

**Testing**: Principle VI exemption — this feature's deliverable is
`SKILL.md` prompt content, not executable code, so test-first (TDD)
execution doesn't apply; verification is scenario-based dry runs instead
(the same exemption class this project's own governance-checklist run
against this very PR flagged as under-cited in every prior feature's
plan.md — CHK007 — stated explicitly here as the fix). Scenario-based dry
run — construct a real, minimal test
branch with a known Principle XIII violation (a `.sh` script with no
`.ps1` counterpart) and confirm the report catches it by name (SC-001);
run against a documentation-only diff and confirm most principles report
Not Applicable (SC-003).

**Target Platform**: Claude Code today (Principle III).

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Development Workflow section (per-PR principle compliance review)**:
  PASS — this feature's entire purpose is mechanizing this requirement.
- **Principle II (competitive research)**: PASS — `research.md`
  benchmarks 10 tools plus internal redundancy against `specjedi-analyze`,
  `specjedi-skill-review`, `specjedi-checklist`.
- **Report-only boundary (FR-004)**: PASS — mirrors `specjedi-analyze`/
  `specjedi-skill-review`'s existing read-only precedent; no violations
  requiring Complexity Tracking.
- **Principle X (CI is the merge gate, not a skill)**: PASS — FR-008
  explicitly preserves this: a CRITICAL finding is surfaced, never
  enforced by this skill itself.

## Project Structure

### Documentation (this feature)

```text
specs/013-specjedi-govcheck/
├── plan.md              # This file
├── research.md          # Phase 0 output (already written)
├── spec.md              # Feature spec (already written, with Clarifications)
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — not applicable; this
skill has no persistent data model or external API surface.

### Source Code (repository root)

```text
.claude/skills/specjedi-govcheck/
└── SKILL.md
```

**Structure Decision**: single skill file, matching every other
`specjedi-*` skill's structure exactly. `specjedi-implement/SKILL.md`
gets a scoped edit to wire in the proactive self-invoke (FR-008).

## Design: `specjedi-govcheck`

- **Persona**: an unhurried constitutional clerk — reads the actual
  record (the diff), checks it against the actual text (the constitution),
  and reports exactly what's there — never editorializes about whether a
  rule itself is a good idea, only whether the change follows it.
- **Task**: given the current branch's diff (or a named PR's), assess all
  20 principles plus the 2 cross-cutting sections as N/A, Compliant, or
  Non-Compliant, mark any real conflict CRITICAL, and report — never edit
  anything.
- **Report, never fix** (FR-004, mirroring `specjedi-analyze`/`specjedi-
  skill-review`'s established boundary): a hard, unconditional read-only
  guarantee.
- **Three-state, never binary** (FR-002, the core design constraint): the
  report's whole value collapses if N/A gets conflated with Compliant (a
  false "everything's fine" signal) or with Non-Compliant (alert fatigue
  from principles the change never touched) — reasoning per principle
  which of the three actually applies is this skill's central judgment
  call.
- **CRITICAL is absolute** (FR-003): no severity downgrade, matching
  `specjedi-analyze`'s existing rule for constitution conflicts exactly.
- **Read the traceability index, don't re-derive it** (FR-005): every
  principle assessment opens by checking
  `references/principle-traceability.md`'s known-mechanism entry for that
  principle, so a principle already marked 🟡 Partial there (e.g.,
  Principle III) doesn't get treated as a fresh discovery each run.
- **Proactive wiring into `specjedi-implement`, non-blocking** (FR-008,
  resolved via clarify): a real, literal self-invoke added to
  `specjedi-implement/SKILL.md` step 6.5 (between marking tasks `[x]` and
  opening the PR) — surfaces CRITICAL findings in the PR-opening
  narration, but explicitly does not gate PR-opening itself, preserving
  `specjedi-implement`'s own existing autonomy statement and Principle
  X's CI-is-the-gate design.
- **Format**: a per-principle table (Principle #, name, status, evidence/
  mechanism reference) — mirrors `specjedi-analyze`'s existing findings-
  table shape for consistency across this project's audit-type skills.
- **Chain-of-thought**: the applicability judgment (N/A vs. Compliant vs.
  Non-Compliant) is the one real, per-principle judgment call — reason
  through what the diff actually touches before assigning a status,
  rather than pattern-matching keyword mentions.
- **Audience calibration**: the report table stays precise (Principle V/
  XII exemption, same as every other pipeline artifact); calibration
  applies only to the skill's own narration.
- **Proactive gap-check**: not typically applicable — this skill's scope
  (checking an existing, fixed principle set) doesn't usually surface a
  domain gap needing `specjedi-find-skills`.
