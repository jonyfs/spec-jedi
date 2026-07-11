# Implementation Plan: `specjedi-status`

**Branch**: `005-specjedi-status` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/005-specjedi-status/spec.md`

## Summary

Build `specjedi-status`, the fourth `references/skill-roadmap.md` backlog
item shipped: a project-wide dashboard deriving every feature's status
entirely from on-disk artifacts (`spec.md`/`plan.md`/`tasks.md` presence
and checkbox completion) — zero separately-maintained tracking system.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: `git` (for the recency signal, FR-004) — already
a stated project prerequisite; degrades gracefully if unavailable.

**Storage**: Reads `specs/NNN-feature-name/{spec,plan,tasks}.md`; writes
nothing — a point-in-time report only (FR-006).

**Testing**: Structural lint via `scripts/validate.sh`/`.ps1` plus a
scenario-based dry run per the Skill Authoring Standard's review checklist
— run against this repo's own `specs/` directory as the real test corpus.

**Target Platform**: Claude Code today (Principle III).

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

- **Principle II (competitive research)**: satisfied — `research.md`
  benchmarks 11 tools for status/dashboard tooling, names a genuine
  contribution (zero separately-tracked state, derived entirely from
  existing artifact conventions this project's other skills already
  maintain).
- **Principle XX (hallucination resistance)**: FR-004 is a direct
  application — report the objective recency signal, never assert a
  "stalled" judgment as fact.
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

```
.claude/skills/specjedi-status/
└── SKILL.md
specs/005-specjedi-status/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

## Design: `specjedi-status`

- **Persona**: a plain-spoken quartermaster — reports exactly what's on
  the shelf, never estimates what should be there.
- **Task**: scan every `specs/NNN-feature-name/` directory, derive each
  feature's status from its actual artifacts and `tasks.md` checkbox
  state, and present one table row per feature — no separate tracking
  system, no cached state.
- **Derivation rules, made concrete** (FR-001, FR-003): a directory with
  only `spec.md` reports "specified"; with `spec.md`+`plan.md` (no
  `tasks.md`) reports "planned"; with `tasks.md` present, count `- [x]`
  vs `- [ ]` lines and report a completion percentage — 0% reports "not
  started," 1-99% reports "in progress," 100% reports "complete."
- **The honesty discipline** (FR-004): report the most recent `git log`
  commit date touching that directory as a plain fact, never translate it
  into a "stalled" verdict — a feature completed the same day it started
  (this repo's own pattern, several times this session) would be
  wrongly flagged by any fixed-threshold staleness rule, so the skill
  doesn't attempt one.
- **Format**: a Markdown table — Feature | Artifacts | Completion | Last
  commit — one row per conforming directory, plus a one-line summary
  count (e.g., "5 features: 2 complete, 2 in progress, 1 specified").
- **Chain-of-thought**: minimal — this skill's actual judgment calls are
  binary derivations from observed file state (does `tasks.md` exist, what
  fraction of its checkboxes are checked), not open-ended reasoning; the
  one place genuine restraint matters is FR-004's discipline against
  overclaiming "stalled," which is a *guardrail* against inference more
  than a chain-of-thought step.
- **Audience calibration**: the status table itself stays precise, same
  exemption as every other generated artifact (Principle V/XII);
  calibration (Principle XIX) applies only to the skill's own narration
  introducing the report.
- **Proactive gap-check**: not typically applicable — this skill's scope
  (reading this project's own established artifact conventions) doesn't
  usually surface a domain gap; if a project's `tasks.md` uses a
  genuinely different checkbox convention this skill can't parse,
  self-invoke `specjedi-find-skills` rather than guessing at counts
  (Principle XVII).
