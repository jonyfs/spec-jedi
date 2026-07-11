# Implementation Plan: `specjedi-release`

**Branch**: `010-specjedi-release` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/010-specjedi-release/spec.md`

## Summary

Build `specjedi-release`, wrapping the existing, already-correct
`scripts/suggest-release.sh`/`.ps1` with Spec Jedi's own voice and guided
next-step suggestions — never reimplementing the commit-classification
logic, never tagging or publishing, matching Principle XI's suggest-only
boundary exactly.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: `scripts/suggest-release.sh`/`.ps1` (already
shipped, unchanged by this feature) — no new dependencies.

**Storage**: Reads git tag/log history via the existing scripts; writes
nothing itself.

**Testing**: Structural lint via `scripts/validate.sh`/`.ps1` plus a
scenario-based dry run — run the actual script against this repository's
real (tagless) history as the test corpus.

**Target Platform**: Claude Code today (Principle III).

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle XI (suggest-only releases)**: PASS — FR-002 makes the
  zero-write-surface boundary absolute; the skill wraps, never
  reimplements or extends, the existing suggest-only script.
- **Principle II (competitive research)**: PASS — `research.md`
  benchmarks 10 tools, notes the broader `semantic-release`-style
  ecosystem context, and names the genuine contribution (giving an
  already-correct, constitutionally-mandated capability a real product
  surface).
- No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/010-specjedi-release/
├── plan.md              # This file
├── research.md          # Phase 0 output (already written)
├── spec.md              # Feature spec (already written, with Clarifications)
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — not applicable; this
skill has no data model or external API surface.

### Source Code (repository root)

```text
.claude/skills/specjedi-release/
└── SKILL.md
```

**Structure Decision**: single skill file. `scripts/suggest-release.sh`/
`.ps1` are read-only dependencies, not modified by this feature.

## Design: `specjedi-release`

- **Persona**: a calm town crier — announces exactly what the record
  shows, never embellishes toward "you should ship now," never quietly
  does the shipping itself.
- **Task**: run the existing release-suggestion script, present its
  output narrated in Spec Jedi's voice, and end with a guided next step
  that is always the correct manual command — never an action the skill
  takes on the user's behalf.
- **Wrap, never reimplement** (the core design constraint, FR-001): the
  skill's own logic is invocation and narration only. If the script's
  classification logic ever needs to change, that's a change to the
  script, not a second implementation living inside this skill's prompt.
- **The absolute write boundary** (FR-002/FR-003): even when explicitly
  asked to "cut" or "ship" the suggested release, the skill declines and
  states the exact manual command — this is not a confirm-then-proceed
  gate like most other skills' file writes, it is a hard boundary with no
  override path from within the skill itself.
- **Format**: the script's own output (last tag, suggested version/bump,
  contributing commits), wrapped in one or two sentences of narration and
  the standing "suggestion only, cutting requires an explicit maintainer
  step" reminder the script itself already prints — the skill doesn't
  invent new structure, it presents what's already there.
- **The FR-006 scope, resolved via clarify**: `specjedi-docs/SKILL.md`'s
  existing next-step reference to `scripts/suggest-release.sh` gets
  updated to point at `specjedi-release` instead — a bulleted-list
  reference update, explicitly *not* a proactive self-invoke wiring
  (Clarifications session resolved this: a release check has no urgency
  comparable to a security gap, and this project's own multi-feature-per-
  session pace would make a proactive trigger noisy).
- **Chain-of-thought**: minimal — this skill's only real judgment call is
  distinguishing "asking about release readiness" (proceed) from "asking
  to actually cut the release" (decline, per FR-003) — reason through
  which one a request actually is before responding, since the two can
  be phrased similarly ("is a release due?" vs. "ship a release").
- **Audience calibration**: the script's own output stays exact and
  unmodified (Principle V/XII exemption); calibration (Principle XIX)
  applies only to the skill's own narration around it.
- **Proactive gap-check**: not typically applicable — this skill's scope
  (wrapping an already-correct, already-shipped script) doesn't usually
  surface a domain gap needing `specjedi-find-skills`.
