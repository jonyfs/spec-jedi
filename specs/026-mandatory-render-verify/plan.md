# Implementation Plan: Mandatory, Failure-Aware Render Verification for `specjedi-diagram`

**Branch**: `026-mandatory-render-verify` | **Date**: 2026-07-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/026-mandatory-render-verify/spec.md`

## Summary

Revise `specjedi-diagram/SKILL.md`'s Step 4 (render-verification) to be
an unconditional gate — every generated diagram gets a verification
attempt, no exceptions — and to treat a render-verification *call*
failure (error, timeout, output too large to display) identically to a
Mermaid syntax failure: both trigger a bounded (2-attempt) revise-and-
recheck cycle, after which an unresolved failure is presented with an
explicit "unverified" caveat rather than silently or indefinitely.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format) —
a content revision to an already-shipped skill (feature 004), same as
feature 025.

**Primary Dependencies**: Unchanged from feature 004/025 — a Mermaid
render-verification mechanism when the harness provides one; falls back
to an explicit unverified-caveat path when absent (pre-existing, FR-007
reaffirms rather than changes this).

**Storage**: Unchanged — reads an existing `spec.md`/`plan.md`; writes
nothing by default.

**Testing**: Principle VI exemption, same reasoning as feature 025 — this
is `SKILL.md` prompt content, not application code. Verification is (a)
`scripts/validate.sh`/`.ps1`'s structural lint (SC-004), and (b) a
scenario dry run deliberately inducing both failure classes (a
syntactically broken diagram; a request large enough to risk an
oversized-output failure) and confirming the bounded-retry-then-honest-
fallback behavior in both.

**Target Platform**: Unchanged — Claude Code today (Principle III).

**Project Type**: Skill pack (single project) — revision only, building
directly on feature 025's already-landed Step 4 text (research.md's
"Implementation ordering note").

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle II**: N/A in the fresh-competitor-benchmark sense (skill
  revision, not new pattern) — grounded instead in this session's own
  first-hand verification-failure evidence (research.md Decision 1),
  satisfying Principle XX.
- **Principle IX (Mandatory Skill Validation & Testing, v1.24.0)**: this
  feature is a direct application of that principle's own newly-expanded
  scenario-dry-run categories (`references/skill-validation-testing-
  framework.md`) — specifically "external-call resilience," applied here
  to the render-verification tool call itself failing.
- **Principle XIX ("quantifiable, not vague")**: the 2-attempt bound
  (research.md Decision 2) exists specifically to satisfy this — "keep
  trying" would fail Principle XIX's own review checklist.
- **Principle XX (grounded, honest output)**: FR-005's honest fallback
  caveat is a direct instance of "don't present an unverified guess as
  fact."
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

### Documentation (this feature)

```text
specs/026-mandatory-render-verify/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── spec.md               # Feature specification
└── tasks.md              # Phase 2 output (/speckit-tasks — not created here)
```

No `data-model.md`/`contracts/` — same reasoning as feature 025 (no data
entities, no external interface; this is prompt-content revision).

### Source Code (repository root)

```text
.claude/skills/specjedi-diagram/
└── SKILL.md                              # revised: Step 4 becomes unconditional + failure-aware + bounded-retry
specs/026-mandatory-render-verify/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

**Structure Decision**: single project, revision-only — one file touched
(the same file feature 025 also revises; 025 lands first per research.md's
ordering note), no new skill, no new subsystem.

## Design: the revised Step 4

- **Unconditional attempt (FR-001)**: Step 4's opening line changes from
  "Run the generated source through the harness's Mermaid validation
  mechanism" (already imperative, but paired with a softer "if it fails,
  revise" downstream) to an explicit statement that this step runs for
  *every* diagram, with no branch that skips it when a mechanism is
  available.
- **Unified failure handling (FR-002, research.md Decision 1)**: Step 4
  states plainly that a verification failure includes both a syntax
  rejection *and* any failure of the verification call itself to produce
  a displayable result (error, timeout, output too large) — both route to
  the same revision cycle, no special-casing.
- **Revision strategy selection (FR-003)**: on failure, the skill
  diagnoses the likely cause from the verification tool's own error
  output — a syntax-specific error message → fix the syntax; a
  size/output-related failure → simplify (reduce node count directly, or
  — once feature 025 lands — apply its complexity-threshold/splitting
  mechanism by name).
- **Bounded retry (FR-004, research.md Decision 2)**: Step 4 states the
  2-attempt cap explicitly as a number, not "a few tries."
- **Honest fallback (FR-005)**: if still failing after 2 attempts, Step 4
  requires stating plainly that verification could not succeed and
  presenting the last-attempted source with an explicit "unverified — may
  not render correctly" caveat — reusing, not duplicating, the skill's
  pre-existing no-verification-mechanism-available fallback language.
- **Tradeoff disclosure (FR-006)**: when a revision changes diagram
  content (the simplify branch), the one-line disclosure requirement from
  feature 025's own Design section applies identically here — both
  features converge on the same "state what changed and why" pattern
  rather than each inventing its own phrasing.
- **No-mechanism case unchanged (FR-007)**: the pre-existing "state
  explicitly that verification wasn't available, offer the source with a
  caveat" path is explicitly preserved, not touched by this feature.
