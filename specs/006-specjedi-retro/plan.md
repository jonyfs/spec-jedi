# Implementation Plan: `specjedi-retro`

**Branch**: `006-specjedi-retro` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/006-specjedi-retro/spec.md`

## Summary

Build `specjedi-retro`, the fifth `references/skill-roadmap.md` backlog
item shipped: a strictly read-only, backward-looking retrospective that
compares a completed feature's actual implementation against its
`plan.md`, states a grounded cause for any deviation (or says plainly the
cause isn't determinable), and logs a durable, dated entry to
`.specify/memory/retro-log.md` — the second cross-session signal log this
project ships, alongside `skill-gaps.md`.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: `git` (for commit-message tracing) — already a
stated project prerequisite.

**Storage**: Reads the target feature's `plan.md`/`tasks.md` and codebase/
git history; writes only an append to `.specify/memory/retro-log.md`.

**Testing**: Structural lint via `scripts/validate.sh`/`.ps1` plus a
scenario-based dry run per the Skill Authoring Standard's review checklist
— run against one of this repo's own completed features as a real test
corpus.

**Target Platform**: Claude Code today (Principle III).

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

- **Principle II (competitive research)**: satisfied — `research.md`
  benchmarks 11 tools for retrospective tooling, names a genuine
  contribution (a durable cross-feature signal log, extending the
  `skill-gaps.md` pattern to a new signal type).
- **Principle XVII (skill-gap logging precedent)**: `specjedi-retro`'s log
  mechanism explicitly mirrors `skill-gaps.md`'s established convention
  rather than inventing a parallel one.
- **Principle XX (hallucination resistance)**: FR-003 is a direct,
  central application — a deviation's cause is reported only when
  traceable, never invented to fill a narrative gap.
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

```
.claude/skills/specjedi-retro/
└── SKILL.md
specs/006-specjedi-retro/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

## Design: `specjedi-retro`

- **Persona**: an honest debrief officer — reports what happened and why,
  when the why is actually known; says "unknown" plainly rather than
  filling the silence with a good story.
- **Task**: given a completed feature, compare its actual codebase/git
  history against `plan.md`, identify deviations, ground each cause in a
  traceable source or mark it undeterminable, and log a dated entry.
- **The completion gate** (FR-001): before comparing anything, confirm
  `tasks.md` is at 100% (reuse the same checkbox-counting logic
  `specjedi-status`, feature 005, already established) — decline with an
  explanation otherwise, since a partial implementation makes "did this
  match the plan" an unanswerable, premature question.
- **The grounding discipline, made concrete** (FR-003): for each detected
  deviation, search the actual `git log` for commits touching the
  relevant file(s) and read their messages; if one plausibly explains the
  deviation, cite it directly (commit SHA/date/message excerpt); if
  nothing found explains it, report "cause not determinable from
  available history" — never bridge the gap with a guess, even a
  reasonable-sounding one.
- **Format**: a narrative report — one paragraph per deviation (or one
  line: "matched the plan, no deviations") — each grounded claim citing
  its source, followed by the exact log entry appended.
- **The log entry** (FR-004/FR-005): mirrors `skill-gaps.md`'s exact
  shape — a dated, one-line-per-entry append to
  `.specify/memory/retro-log.md`, created on first use if it doesn't
  exist. A clean retrospective still gets a one-line "no deviations"
  entry — silence in the log would be indistinguishable from "never run,"
  which defeats the log's purpose as a durable signal.
- **Chain-of-thought**: distinguishing a traceable cause from an
  untraceable one is the skill's one real judgment call — reason through
  it explicitly for every candidate deviation (does a specific commit
  message actually explain *this* change, or does it just happen to
  touch the same file for an unrelated reason?) rather than citing the
  nearest commit by proximity alone.
- **Audience calibration**: the report and log entry stay precise, same
  exemption as every other generated artifact (Principle V/XII);
  calibration (Principle XIX) applies only to the skill's own narration
  introducing the retrospective.
- **Proactive gap-check**: if a deviation's domain needs expertise nothing
  installed covers to properly assess (e.g., a security-relevant
  architecture change), self-invoke `specjedi-find-skills` rather than
  guessing at implications outside this skill's competence (Principle
  XVII).
