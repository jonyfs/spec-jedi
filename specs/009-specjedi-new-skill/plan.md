# Implementation Plan: `specjedi-new-skill`

**Branch**: `009-specjedi-new-skill` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/009-specjedi-new-skill/spec.md`

## Summary

Build `specjedi-new-skill`, a meta-skill that scaffolds a new `specjedi-*`
skill's file structure — the `specs/NNN-specjedi-<name>/`
research/spec/plan/tasks set plus the `.claude/skills/specjedi-<name>/
SKILL.md` skeleton — following this project's own Skill Authoring
Standard (Principle XIX) and baking in Principle II's competitive-research
checklist, with every generated section a clearly-marked placeholder,
never invented content.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: `.specify/init-options.json` (feature-numbering
scheme), `.specify/templates/spec-template.md` (the same template this
skill's own scaffold structure derives from) — no external services.

**Storage**: Creates new directories/files under `specs/` and
`.claude/skills/`; never modifies an existing skill's files.

**Testing**: Principle VI exemption — this feature's deliverable is `SKILL.md` prompt content (and any supporting script), not application code with unit-testable business logic, so test-first (TDD) execution does not apply; verification is structural lint via `scripts/validate.sh`/`.ps1` (the
scaffolded `SKILL.md` skeleton must itself pass frontmatter validation
even as a placeholder) plus a scenario-based dry run.

**Target Platform**: Claude Code today (Principle III).

**Project Type**: Skill pack (single project) — not an API/service, so
`data-model.md`/`contracts/`/`quickstart.md` don't apply (spec-kit's own
template guidance: skip for purely internal tooling); this project's
established `plan.md`-with-Design-section shape (features 001-008) is
used instead.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle II (competitive research)**: PASS — `research.md` benchmarks
  spec-kit + ten competitors, includes an internal-redundancy check
  against this project's own shipped skills (the `specjedi-security`
  precedent, feature 007), and names a genuine contribution (a
  placeholders-only scaffolding meta-skill, adapted from Superpowers'
  `meta-agent` instinct but never generating finished content).
- **Principle XIX (Skill Authoring Standard)**: PASS — FR-002 requires the
  scaffolded `SKILL.md` to contain every required section as a
  placeholder; this plan's own Design section below specifies exactly
  which sections.
- **Principle XX (hallucination/overclaiming resistance)**: PASS — FR-005
  is a direct application: the skill scaffolds structure and prompts,
  never invents research findings or design content on the contributor's
  behalf.
- No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/009-specjedi-new-skill/
├── plan.md              # This file
├── research.md          # Phase 0 output (already written)
├── spec.md              # Feature spec (already written)
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — not applicable to a
skill-pack meta-tool with no external API surface or complex data model.

### Source Code (repository root)

```text
.claude/skills/specjedi-new-skill/
└── SKILL.md
```

**Structure Decision**: single skill file, matching every other shipped
`specjedi-*` skill's own structure (no sub-directories needed — the
skill's own `references/` subfolder is not required since it has no
supporting material beyond the `SKILL.md` itself).

## Design: `specjedi-new-skill`

- **Persona**: a meticulous onboarding officer — hands a new contributor
  exactly the right paperwork, pre-labeled, never pre-filled with answers
  that aren't theirs to give.
- **Task**: given a one-sentence idea for a new `specjedi-*` skill, create
  the `specs/NNN-specjedi-<name>/` directory (research/spec/plan/tasks,
  numbered per `.specify/init-options.json`'s scheme) and the
  `.claude/skills/specjedi-<name>/SKILL.md` skeleton, every section
  clearly marked `[PLACEHOLDER: ...]`, never invented content.
- **The placeholders-only discipline, made concrete** (FR-005): the
  scaffolded `research.md` gets the Principle II checklist as literal
  unfilled prompts (spec-kit + 10 competitors table, internal-redundancy
  check, genuine-contribution question) — not a guess at what the
  research might find. The scaffolded `SKILL.md` gets every Skill
  Authoring Standard section (persona, task, format, worked example,
  `--auto` mode, autonomous vs. confirm-first, Always/Never, verifiable
  success criteria) as a labeled placeholder — not invented behavior.
- **Collision detection** (FR-004): before creating anything, check
  `.claude/skills/specjedi-<name>/` doesn't already exist — decline with
  an explanation if it does, rather than overwriting a shipped skill's
  files.
- **Numbering, grounded in actual config** (Assumptions): read
  `.specify/init-options.json`'s `feature_numbering` field and scan
  `specs/` for the highest existing number, rather than assuming a fixed
  scheme — this project's own config is `"sequential"`, but the skill
  reads it rather than hardcoding that assumption.
- **Chain-of-thought**: distinguishing a genuinely novel skill name from
  one that collides (exact match) or nearly collides (a name close enough
  to an existing skill that it risks confusion, e.g. proposing
  `specjedi-check` when `specjedi-checklist` already ships) is the
  skill's one real judgment call — reason through it explicitly rather
  than only checking exact string equality.
- **Audience calibration**: the scaffolded placeholder text stays precise
  and instructional (Principle V/XII exemption, same as every generated
  artifact); calibration (Principle XIX) applies only to the skill's own
  narration when presenting the finished scaffold.
- **Proactive gap-check**: if the requested skill idea clearly needs
  domain expertise this project's own skill-authoring competence doesn't
  cover (e.g., scaffolding a skill for a highly specialized regulatory
  domain), self-invoke `specjedi-find-skills` before finishing the
  scaffold (Principle XVII).
