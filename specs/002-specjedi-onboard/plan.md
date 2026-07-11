# Implementation Plan: `specjedi-onboard`

**Branch**: `002-specjedi-onboard` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/002-specjedi-onboard/spec.md`

## Summary

Build `specjedi-onboard`, the highest-impact item from
`references/skill-roadmap.md`'s backlog: a first-run walkthrough that
orchestrates the already-shipped `specjedi-constitution` and
`specjedi-specify` skills, adding inline concept narration so a genuine
first-timer ends the run with two real, usable artifacts instead of a
throwaway tutorial example.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: The already-shipped `specjedi-constitution` and
`specjedi-specify` skills (self-invoked, not reimplemented — FR-003). No new
external services or API keys.

**Storage**: `.specify/memory/constitution.md` and `specs/NNN-feature/
spec.md`, identical targets to what `specjedi-constitution`/`specjedi-
specify` already write.

**Testing**: Principle VI exemption — this feature's deliverable is `SKILL.md` prompt content (and any supporting script), not application code with unit-testable business logic, so test-first (TDD) execution does not apply; verification is structural lint via `scripts/validate.sh`/`.ps1` plus a
scenario-based dry run per the Skill Authoring Standard's review checklist
— same as every pipeline skill in feature 001.

**Target Platform**: Claude Code today (Principle III), same per-harness
mapping convention as feature 001.

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

- **Principle II (competitive research)**: satisfied — `research.md`
  benchmarks 11 tools specifically for onboarding UX, names a genuine
  contribution (a dedicated first-run skill producing real artifacts with
  point-of-use teaching, which no researched competitor ships).
- **Principle XVII (proactive gap-check contract)**: `specjedi-onboard`
  self-invokes `specjedi-constitution`/`specjedi-specify` rather than
  duplicating their logic — satisfies the same "don't maintain the same
  validation in two places" spirit this principle protects.
- **Principle XIX (Skill Authoring Standard, Audience Calibration)**: the
  entire skill exists to serve the beginner end of the calibration
  spectrum explicitly — narration is unavoidably beginner-first by design,
  which is itself a form of calibration (the skill's *purpose* is the
  calibration decision, not a per-question toggle like other pipeline
  skills).
- **Principle XIV (guided next step)**: FR-005 requires it explicitly.
- **Gate result**: PASS, no Complexity Tracking entries needed — this
  skill's scope (orchestrate two existing skills, add narration) stays
  within a single skill file with no architectural complexity to justify.

## Project Structure

```
.claude/skills/specjedi-onboard/
└── SKILL.md
specs/002-specjedi-onboard/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

No new directories beyond the standard `.claude/skills/<name>/SKILL.md` +
`specs/NNN-feature/` pattern every prior `specjedi-*` skill already used.

## Design: `specjedi-onboard`

- **Persona**: a patient first guide — the skill that meets a total
  beginner exactly where they are, never assuming prior SDD vocabulary,
  and never burying them in documentation before they've typed anything.
- **Task**: given a real one-sentence project idea, orchestrate
  `specjedi-constitution` then `specjedi-specify` to produce a genuine
  first constitution and spec, narrating each concept at the point it
  becomes relevant.
- **Orchestration, not reimplementation** (FR-003): this skill's own logic
  is sequencing and narration only — the actual constitution/spec
  generation and validation stay owned by `specjedi-constitution`/
  `specjedi-specify`. If either of those skills' behavior changes later,
  `specjedi-onboard` inherits the change automatically rather than drifting
  out of sync with a duplicated implementation.
- **Point-of-use teaching, made concrete**: before invoking
  `specjedi-constitution`, briefly explain what a constitution is and why
  it exists — one or two sentences, not a lecture — then hand off. Before
  invoking `specjedi-specify`, do the same for what a spec is and why
  ambiguity gets marked instead of guessed. No concept is explained before
  the step that needs it.
- **First-run detection gate** (FR-001): the very first action, before any
  narration, is checking whether `.specify/memory/constitution.md` already
  exists. If it does, stop immediately — report, suggest next step, touch
  nothing else.
- **The real-idea gate** (FR-002): if no project idea was supplied, ask for
  one explicitly and wait — never substitute a placeholder to keep the
  walkthrough moving, per research.md's explicit rejection of the
  Spec-Kitty "config wizard, not real output" pattern.
- **Chain-of-thought**: minimal for this skill relative to other pipeline
  stages — its judgment calls are mostly "has this already happened" (FR-
  001) and "do I have a real idea yet" (FR-002), both binary gates rather
  than open-ended reasoning; the actual content judgment calls (version
  bump classification, ambiguity prioritization) stay inside the
  orchestrated `specjedi-constitution`/`specjedi-specify` skills where they
  already live.
- **Audience calibration**: unlike other pipeline skills where calibration
  is a per-question toggle, this entire skill *is* the beginner-calibrated
  path — an advanced user with an already-clear mental model of SDD tools
  can skip straight to `specjedi-constitution` directly; `specjedi-onboard`
  exists for the user who wouldn't know to do that yet.
- **Proactive gap-check**: if the user's project idea clearly needs domain
  expertise nothing installed covers even to draft an initial constitution
  around (e.g., a highly regulated domain), self-invoke
  `specjedi-find-skills` before proceeding (Principle XVII).
