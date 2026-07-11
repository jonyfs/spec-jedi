# Implementation Plan: `specjedi-skill-review`

**Branch**: `011-specjedi-skill-review` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/011-specjedi-skill-review/spec.md`

## Summary

Build `specjedi-skill-review`, a report-only audit skill that checks an
existing `specjedi-*` skill's `SKILL.md` against the Skill Authoring &
Prompt Engineering Standard (Principle XIX) plus the three companion
dimensions the manual audits already proved matter (Principle XIV bulleted
next-step format, Principle XX explicit chain-of-thought text, Principle
XII genuine voice) — distinguishing "section missing" from "section present
but weak," cross-referencing the skill's `specs/NNN-name/plan.md` when
findable, and never editing the reviewed file.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: None new — reads `.claude/skills/*/SKILL.md`,
`references/skill-authoring-standard.md`, and (per Clarifications) the
matching `specs/*/plan.md` when locatable. No script dependency, unlike
`specjedi-release`.

**Storage**: Read-only; writes nothing (FR-005's absolute boundary).

**Testing**: Principle VI exemption — this feature's deliverable is `SKILL.md` prompt content, not application code with unit-testable business logic, so test-first (TDD) execution does not apply; verification is a scenario-based dry run against real repo state — run the
review against a scratch copy of a skill with a reintroduced known gap
(SC-001), and against every currently shipped skill to confirm zero false
positives (SC-003).

**Target Platform**: Claude Code today (Principle III).

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle XIX (Skill Authoring & Prompt Engineering Standard)**: PASS —
  this feature's entire purpose is enforcing this principle mechanically;
  its own `SKILL.md` must also satisfy the standard it checks (dogfooded
  during T0-level review before shipping).
- **Principle II (competitive research)**: PASS — `research.md` benchmarks
  10 tools plus internal redundancy against `specjedi-analyze`,
  `specjedi-new-skill`, `scripts/validate.sh`.
- **Report-only boundary (FR-005)**: PASS — mirrors `specjedi-analyze`'s
  existing read-only precedent (feature 001); no violations requiring
  Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/011-specjedi-skill-review/
├── plan.md              # This file
├── research.md          # Phase 0 output (already written)
├── spec.md              # Feature spec (already written, with Clarifications)
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — not applicable; this
skill has no persistent data model or external API surface.

### Source Code (repository root)

```text
.claude/skills/specjedi-skill-review/
└── SKILL.md
```

**Structure Decision**: single skill file, matching every other
`specjedi-*` skill's structure exactly.

## Design: `specjedi-skill-review`

- **Persona**: an exacting proving-ground instructor — checks form against
  a known standard precisely, names every deviation plainly, never softens
  a real gap into a suggestion, and never touches the trainee's own work.
- **Task**: given a skill name, locate its `SKILL.md`, check it against
  every Principle XIX section plus the three companion dimensions (FR-002/
  FR-003), and produce a findings report or an explicit clean pass
  (FR-007) — never an edit.
- **Report, never fix** (FR-005, the core design constraint, mirroring
  `specjedi-analyze`'s established boundary): even when explicitly asked to
  apply a fix, the skill declines and names the fix as a manual follow-up —
  a hard boundary with no override path from within the skill itself, the
  same shape as `specjedi-release`'s FR-002/FR-003 write boundary.
- **Section-missing vs. section-weak** (FR-004, the second core design
  constraint): a naive "does this heading exist" grep is explicitly
  insufficient — this was the real gap class the manual `specjedi-docs`
  chain-of-thought audit found (a heading and step existed, but the
  required "reason through it" framing was never actually written into the
  step text). The skill's step-by-step MUST read section *content*, not
  just confirm headings are present.
- **Cross-reference `plan.md` for exemptions** (FR-006, resolved via
  clarify): when a skill under review has no genuine judgment call to
  reason through, the skill actively locates `specs/NNN-name/plan.md` by
  matching the skill's own name and cites it as supporting evidence for a
  clean exemption — the same cross-reference discipline that corrected the
  6-skill audit's initial grep-only false positives against
  `specjedi-status` and `specjedi-diagram` (PR #41).
- **Format**: a findings list — each entry names the file, the section or
  dimension, what's missing or weak, and the principle it maps to — or, if
  every dimension passes, an explicit "clean pass" statement naming every
  dimension checked (FR-007), never an empty or ambiguous report.
- **Decline out-of-scope targets** (FR-008): a named `speckit-*` bootstrap
  skill is declined with an explanation that Principle XIX governs this
  project's own `specjedi-*` product skills, not vendored upstream tooling
  — the same class of boundary `specjedi-new-skill` already draws around
  its own collision-detection scope.
- **Chain-of-thought**: this skill's own real judgment call is exactly
  FR-004's "missing vs. weak" distinction — reason through, for each
  checked dimension, whether the section's actual content satisfies the
  principle's intent or merely satisfies its heading, before recording a
  finding or a pass; a second judgment call is FR-006's exemption
  cross-reference — reason through whether an apparent gap is a real
  finding or a documented, legitimate exemption before reporting either.
- **Audience calibration**: findings are stated plainly and specifically
  (file, section, principle) — no hedging, no vague "consider improving"
  language, matching this project's existing voice standard for audit-type
  skills (Principle XII/XIX).
- **Proactive gap-check**: not typically applicable — this skill's scope
  (reviewing one already-named skill) doesn't usually surface a domain gap
  needing `specjedi-find-skills`.
