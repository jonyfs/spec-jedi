# Implementation Plan: `specjedi-security`

**Branch**: `007-specjedi-security` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/007-specjedi-security/spec.md`

## Summary

Build `specjedi-security`, the sixth `references/skill-roadmap.md`
backlog item shipped: a lightweight, proactive threat-modeling prompt —
never a comprehensive audit — surfacing targeted "did we think about X"
questions grounded in a maintained taxonomy, self-invoked by
`specjedi-plan` when spec/plan content is security-relevant.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: `references/security-question-bank.md` (new,
this feature) — the maintained taxonomy this skill draws from, mirroring
`references/star-wars-lexicon.md`'s pattern.

**Storage**: Reads the target feature's `spec.md`/`plan.md`; writes
nothing itself (a prompt, not a persisted artifact) — the taxonomy file is
part of this feature's own shipped reference material, not something the
skill writes at runtime.

**Testing**: Structural lint via `scripts/validate.sh`/`.ps1` plus a
scenario-based dry run per the Skill Authoring Standard's review checklist.

**Target Platform**: Claude Code today (Principle III).

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

- **Principle II (competitive research)**: satisfied — `research.md`
  resolves the redundancy question against this project's own
  `specjedi-checklist` explicitly (not just external competitors), and
  names a genuine contribution (proactive security prompting during
  planning, which no researched competitor's mechanism does — GSD's
  closest analog verifies after the fact, this prompts before).
- **Principle XVII (proactive gap-scout pattern)**: FR-007 wires the
  proactive trigger into `specjedi-plan/SKILL.md` for real, following the
  verified actual convention (a literal self-invoke instruction), not an
  assumed implicit one.
- **Principle XX (hallucination/overclaiming resistance)**: FR-004 is a
  direct application — never implies comprehensive coverage the skill
  doesn't actually provide.
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

```
.claude/skills/specjedi-security/
└── SKILL.md
.claude/skills/specjedi-plan/
└── SKILL.md (modified: adds proactive self-invoke of specjedi-security)
references/
└── security-question-bank.md (new)
specs/007-specjedi-security/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

## Design: `specjedi-security`

- **Persona**: a paranoid-but-honest colleague — asks the question you'd
  rather not have to answer, but never pretends asking it was a full
  review.
- **Task**: scan a spec/plan against the maintained security-question
  taxonomy, surface targeted questions only for unaddressed categories,
  and explicitly disclaim comprehensive coverage.
- **The taxonomy file** (`references/security-question-bank.md`):
  organized by category (authentication, input validation, secrets/
  credentials, data privacy, dependency/supply-chain risk), each entry a
  specific, answerable question — not a vague "is this secure?" prompt.
  Extended over time, mirroring the lexicon file's own "extend, don't
  invent inline" convention.
- **Grounding discipline** (FR-003): before surfacing any question,
  check whether the spec/plan's actual text already answers it — the
  same "does this trace to the source" discipline `specjedi-checklist`
  applies, inverted: here it's checking whether the source already
  covers a candidate concern, to avoid a redundant question.
- **The proactive trigger, made real** (FR-007): add an explicit
  self-invoke instruction to `specjedi-plan/SKILL.md`'s own step
  sequence — verified against the actual pattern already used for
  `specjedi-find-skills` in that same file, not invented differently.
- **The honesty discipline** (FR-004): every response — proactive or
  requested — states plainly this is a lightweight prompt, never a
  security review, and names `specjedi-checklist` (security focus) as the
  path to comprehensive coverage.
- **Chain-of-thought**: matching taxonomy categories against spec/plan
  content, and judging whether a category is already addressed, is the
  skill's one real judgment call — reason through each category
  explicitly rather than keyword-matching superficially (a spec that
  mentions "password" isn't automatically addressing credential storage
  just because the word appears).
- **Audience calibration**: the taxonomy and questions stay precise, same
  exemption as every other generated content (Principle V/XII);
  calibration (Principle XIX) applies only to the skill's own narration.
- **Proactive gap-check**: if a security concern surfaced needs deeper
  domain expertise this skill's lightweight scope doesn't cover (e.g., a
  compliance-specific regulatory question), self-invoke
  `specjedi-find-skills` rather than attempting a real audit outside its
  own honest scope (Principle XVII).
