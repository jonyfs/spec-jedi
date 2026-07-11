# Implementation Plan: `specjedi-tokencheck`

**Branch**: `012-specjedi-tokencheck` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/012-specjedi-tokencheck/spec.md`

## Summary

Build `specjedi-tokencheck`, mechanizing Principle VIII's mandate:
proactively detect whether `rtk` and `graphify` are present, explain
what's missing and its expected savings, and offer an install walkthrough
gated behind explicit confirmation — never installing anything itself.
Wired as a proactive self-invoke at the end of `specjedi-onboard`'s
first-run flow, and independently runnable for any session that skipped
onboarding.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: None new — detection uses standard environment
lookup (`which`/`where`, or `graphify-out/` as a secondary signal for
`graphify`). No script dependency of its own.

**Storage**: Read-only detection; writes nothing unless the user
explicitly confirms an install, at which point installation is handled by
each tool's own documented installer, not by this skill's own logic.

**Testing**: Scenario-based dry run against real repo state — this
repository already has `graphify` integrated (`graphify-out/` exists) but
`rtk` availability varies by environment, giving a real mixed-state test
case for SC-001/SC-003 without needing a fabricated scenario.

**Target Platform**: Claude Code today (Principle III).

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle VIII (Token-Economy Tooling Integration)**: PASS — this
  feature's entire purpose is mechanizing this principle's proactive
  check-and-suggest mandate with an unconditional confirm-before-install
  boundary.
- **Principle II (competitive research)**: PASS — `research.md`
  benchmarks 10 tools plus internal redundancy against `specjedi-onboard`,
  `specjedi-plan`, `specjedi-converge`.
- **Principle XVII (proactive gap-scout contract)**: applies by analogy —
  the self-invoke wiring into `specjedi-onboard` follows the same literal,
  verified "self-invoke X" discipline (a real edit to `specjedi-onboard/
  SKILL.md`, not an assumed contract), matching the `specjedi-plan` →
  `specjedi-security` precedent (feature 007).
- No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/012-specjedi-tokencheck/
├── plan.md              # This file
├── research.md          # Phase 0 output (already written)
├── spec.md              # Feature spec (already written, with Clarifications)
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — not applicable; this
skill has no persistent data model or external API surface.

### Source Code (repository root)

```text
.claude/skills/specjedi-tokencheck/
└── SKILL.md
```

**Structure Decision**: single skill file, matching every other
`specjedi-*` skill's structure exactly. `specjedi-onboard/SKILL.md` gets
a scoped edit to wire in the proactive self-invoke (FR-005).

## Design: `specjedi-tokencheck`

- **Persona**: a practical quartermaster — checks the kit before the
  mission starts, names exactly what's missing and why it'd help, never
  hands over new gear without a nod first.
- **Task**: given the current environment, check `rtk` and `graphify`
  independently, explain any missing tool's purpose and expected savings,
  offer an install walkthrough, and take no installation action without
  explicit confirmation.
- **Equal treatment of both tools** (FR-001, resolved via clarify): no
  asymmetry between `rtk` and `graphify` in the check itself, even though
  this project's own skills already consume `graphify` when present —
  that consumption relationship doesn't change whether the *target*
  project being scaffolded has `graphify` installed.
- **Detection, not assumption** (FR-006): use `which rtk`/`where rtk` and
  `which graphify`/`where graphify` (or the `graphify-out/` directory as
  a secondary signal specific to this ecosystem's own convention) —
  report "indeterminate" rather than guessing when the detection
  mechanism itself isn't available, mirroring `specjedi-status`'s existing
  "never assert a fact you can't verify" discipline.
- **Confirm-before-install, absolute boundary** (FR-003, the core design
  constraint): mirrors `specjedi-find-skills`' own install gate (step 7 of
  that skill: "never run this from a 'sounds like yes' inference") — this
  skill draws the identical line for `rtk`/`graphify`.
- **No redundant suggestions** (FR-004): a tool already detected gets a
  clean "present" line, never a suggestion to install something that's
  already there — this is what makes SC-002/SC-003 meaningfully testable
  against this very repository's own mixed state.
- **Proactive wiring into `specjedi-onboard`** (FR-005, resolved via the
  same Principle XVII discipline as `specjedi-security`): add a real,
  literal self-invoke line to `specjedi-onboard/SKILL.md`'s step 5, right
  after the constitution/spec artifacts land and alongside the existing
  next-step report — not before, matching `specjedi-onboard`'s own
  established "never front-load before the user has produced anything"
  discipline (its own Never guardrail), now extended to tooling
  suggestions as well as SDD concepts.
- **Standalone-runnable** (FR-005's second half): the skill's own
  detection logic makes no assumption about being invoked from
  `specjedi-onboard` — a direct, explicit run works identically.
- **Format**: a short per-tool status line (present/missing/
  indeterminate), and for each missing tool, a one-to-two-sentence
  purpose+savings explanation plus an install offer — never a single
  blurb covering both tools identically.
- **Chain-of-thought**: minimal — the one real judgment call is
  distinguishing an unambiguous install confirmation from a decline or
  an ambiguous response (FR-003) — reason through which one a reply
  actually is before running or declining any install action, the same
  class of judgment `specjedi-find-skills` step 7 already makes explicit.
- **Audience calibration**: the tool-savings explanation stays concise
  and concrete (a number or a stated mechanism, not "makes things
  faster") per this project's own ruthless-literalness standard
  (Principle XIX/`references/skill-authoring-standard.md`).
- **Proactive gap-check**: not typically applicable — this skill's scope
  (checking two named, already-identified tools) doesn't surface a domain
  gap needing `specjedi-find-skills`.
