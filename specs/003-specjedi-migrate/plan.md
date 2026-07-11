# Implementation Plan: `specjedi-migrate`

**Branch**: `003-specjedi-migrate` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/003-specjedi-migrate/spec.md`

## Summary

Build `specjedi-migrate`, the next `references/skill-roadmap.md` backlog
item after `specjedi-onboard`: rewrites literal `/speckit-*` tooling
references in a target project's own artifacts to their shipped
`specjedi-*` equivalents, leaving all substantive content untouched, and
reports exactly what changed (and what couldn't be, for lack of an
equivalent).

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: None beyond what the harness already provides.
Assumes `specjedi-*` skills are already installed in the target project
(via `scripts/install.sh`/`.ps1`, shipped) — checks for this rather than
assuming it.

**Storage**: Rewrites whatever project files the target project already
has (typically `.specify/memory/constitution.md` and `specs/*/spec.md`,
`plan.md`, `tasks.md`) in place — no new files created beyond the
in-response migration report.

**Testing**: Principle VI exemption — this feature's deliverable is `SKILL.md` prompt content (and any supporting script), not application code with unit-testable business logic, so test-first (TDD) execution does not apply; verification is structural lint via `scripts/validate.sh`/`.ps1` plus a
scenario-based dry run per the Skill Authoring Standard's review checklist
— same as every prior pipeline/roadmap skill.

**Target Platform**: Claude Code today (Principle III), same per-harness
mapping convention as prior features.

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

- **Principle II (competitive research)**: satisfied — `research.md`
  benchmarks 11 tools specifically for migration/switching-cost tooling,
  names a genuine contribution (a working migration mechanism rather than
  a manual doc page, honestly scoped to what actually needs migrating).
- **Principle XX (hallucination resistance)**: the scoping decision itself
  (FR-001 — rewrite references only, never claim a format conversion that
  isn't needed) is a direct application of this principle's overclaiming
  prohibition, not just its literal-fabrication one.
- **Principle XIV (guided next step)**: the migration report itself serves
  this role — it's the skill's entire output, and ends by pointing at
  whatever pipeline stage makes sense next.
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

```
.claude/skills/specjedi-migrate/
└── SKILL.md
specs/003-specjedi-migrate/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

## Design: `specjedi-migrate`

- **Persona**: an honest mover — packs exactly what needs to move, leaves
  everything else exactly where it was. Never re-labels a box just to look
  busy.
- **Task**: given a target project, find every literal `/speckit-*`
  command reference in prose across its constitution/spec/plan/tasks
  files, rewrite each one with a shipped `specjedi-*` equivalent when one
  exists, flag it when one doesn't, and report every action taken —
  without touching a single word of substantive content.
- **The scoping discipline, made concrete** (FR-001): before rewriting
  anything, distinguish a live tooling reference ("run `/speckit-plan`
  next") from a quoted/historical mention (inside a code fence, or prose
  explicitly describing past state, e.g., "this project used to use
  speckit-plan before switching"). Only the former gets rewritten; the
  latter gets flagged for human judgment, never silently altered — an
  automated rewrite of historical text would fabricate a project's own
  history (Principle XX).
- **The prerequisite check** (FR-004): before rewriting any reference to a
  `specjedi-*` skill name, confirm that skill is actually present in the
  target project's `.claude/skills/` — rewriting a reference to a skill
  that doesn't exist there yet would leave the project pointing at
  nothing. If missing, stop and recommend the installer first.
- **Format**: a migration report — two lists, "Rewritten" (old reference →
  new reference, file + line) and "Flagged, unchanged" (reference, file +
  line, reason) — never a separate persisted file unless the user asks to
  keep one.
- **Chain-of-thought**: distinguishing live-prose references from quoted/
  historical mentions is the skill's one real judgment call — reason
  through each candidate explicitly (is this instructing a workflow right
  now, or describing something that already happened / is inside an
  example block?) rather than pattern-matching the bare substring
  "speckit".
- **Audience calibration**: the migration report itself stays precise
  (same exemption as every other pipeline artifact); calibration applies
  only to the skill's own narration introducing/summarizing the report.
- **Proactive gap-check**: if a project's tooling references point at a
  `speckit-*` command this project doesn't vendor at all (a fork or
  third-party extension), self-invoke `specjedi-find-skills` rather than
  guessing at an equivalent (Principle XVII).
