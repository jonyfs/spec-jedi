# Implementation Plan: `specjedi-docs`

**Branch**: `008-specjedi-docs` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/008-specjedi-docs/spec.md`

## Summary

Build `specjedi-docs`, the seventh and final `references/skill-roadmap.md`
backlog item shipped: generates a README skill-table row, a Quickstart
step, and a `CHANGELOG.md` entry from a shipped feature's spec/plan —
grounded, confirm-before-write, scoped to this project's own bounded doc
surfaces rather than open-ended documentation generation.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: None beyond what the harness already provides.

**Storage**: Reads the target feature's `spec.md`/`plan.md`; writes to
`README.md` (skill table, Quickstart) and `CHANGELOG.md` (creating it if
missing) — only after explicit confirmation of the drafted change.

**Testing**: Principle VI exemption — this feature's deliverable is `SKILL.md` prompt content (and any supporting script), not application code with unit-testable business logic, so test-first (TDD) execution does not apply; verification is structural lint via `scripts/validate.sh`/`.ps1` plus a
scenario-based dry run per the Skill Authoring Standard's review checklist
— run against this project's own README/skill-roadmap.md update pattern,
already exercised by hand seven times this session, as the real reference
behavior to match.

**Target Platform**: Claude Code today (Principle III).

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

- **Principle II (competitive research)**: satisfied — `research.md`
  benchmarks 11 tools for doc-generation tooling, names a genuine
  contribution (deriving README/changelog updates from the SDD pipeline's
  own artifacts, scoped to bounded surfaces rather than open-ended
  generation).
- **Principle XVI (this project's own README discipline)**: this skill
  directly automates the exact manual README-sync work Distribution &
  Ecosystem Standards already requires before every PR — a genuine
  reduction in the manual burden this project's own constitution imposes
  on every contributor.
- **Principle XX (hallucination/overclaiming resistance)**: FR-003 is a
  direct application — every doc line traces to actual spec/plan content.
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

```
.claude/skills/specjedi-docs/
└── SKILL.md
specs/008-specjedi-docs/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

## Design: `specjedi-docs`

- **Persona**: a precise archivist — writes down exactly what shipped, in
  the project's own established doc voice, never embellishing.
- **Task**: given a shipped feature's spec/plan, draft a README
  skill-table row, a Quickstart step, and a `CHANGELOG.md` entry, each
  grounded in actual spec/plan content, and present all three for
  confirmation before writing.
- **The completion gate** (FR-001): mirrors `specjedi-retro`'s own
  100%-complete check — decline with an explanation for an in-progress
  feature.
- **Grounding discipline** (FR-003): the same "does this trace to the
  source" test `specjedi-checklist` and `specjedi-diagram` already apply
  to their own artifact types — a drafted skill-table description that
  claims a capability the spec doesn't actually describe fails this
  check before it ever reaches the confirm step.
- **Confirm-before-write** (FR-004): draft all three doc pieces, present
  them together, and wait for explicit confirmation — never apply an
  edit silently, matching every other file-writing `specjedi-*` skill's
  discipline where a confirm gate exists (e.g., `specjedi-diagram`'s own
  file-write confirmation, feature 004).
- **Format**: matches this project's own established README conventions
  exactly — a skill-table row (`| \`name\` emoji | description |`), a
  numbered Quickstart step, and a `CHANGELOG.md` entry following [Keep a
  Changelog](https://keepachangelog.com/)'s standard shape (version-less
  "Unreleased" section, bullet per change) since this project's actual
  version-bump suggestions come from `scripts/suggest-release.sh`
  (Principle XI), not from this skill.
- **Chain-of-thought**: drafting an accurate, non-inflated description of
  what a feature does is the skill's one real judgment call — reason
  through the spec's actual scope explicitly before wording the drafted
  line, the same discipline this session's own manual README updates
  have applied by hand seven times already.
- **Audience calibration**: the drafted doc content stays precise, same
  exemption as every other generated artifact (Principle V/XII);
  calibration (Principle XIX) applies only to the skill's own narration
  presenting the draft.
- **Proactive gap-check**: if a feature's domain needs expertise this
  skill's general doc-drafting competence doesn't cover (e.g., a
  feature requiring specialized regulatory-disclosure language),
  self-invoke `specjedi-find-skills` rather than guessing at unfamiliar
  conventions (Principle XVII).
