# Implementation Plan: Simplify README Installation to Bootstrap-Only

**Branch**: `031-simplify-install-bootstrap` | **Date**: 2026-07-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/031-simplify-install-bootstrap/spec.md`

## Summary

README.md's Installation section currently presents three separate
paths (open a clone directly in Claude Code; clone and run
`scripts/install.sh` against another project; or run
`scripts/bootstrap-install.sh`/`.ps1` with no clone). Both
`bootstrap-install.sh` and `.ps1` already exist, already work, and
already handle the "no release yet" case honestly (feature 024) — no
script changes are needed. This feature rewrites the Installation
section down to exactly one path: a single bash command block and a
single PowerShell command block, both forwarding `--harness`/`--auto`,
with the two clone-based subsections and their Mermaid flowchart/
numbered-steps removed entirely (per `/speckit-clarify`'s Session
2026-07-13 decision) in favor of a minimal command-block-plus-prose
format.

## Technical Context

**Language/Version**: N/A — Markdown documentation edit only
(`README.md`); no application code changes.

**Primary Dependencies**: N/A

**Storage**: N/A

**Testing**: N/A for TDD in the code sense — Principle VI exemption:
this feature's entire deliverable is `README.md` prose, no executable
logic. Verification takes the form of `scripts/validate.sh` (existing
localized-docs/anchor checks, per SC-004) plus a manual read-through
confirming the two command blocks are copy-pasteable and correct
(`quickstart.md`'s validation scenarios). Exemption stated explicitly
per the CHK007 precedent (features 001-027 already established this
pattern for non-code-TDD work).

**Target Platform**: Documentation read by end-users on Linux, macOS,
and Windows (native PowerShell) — Principle XIII requires both an `.sh`-
equivalent (bash command block) and a `.ps1`-equivalent (PowerShell
command block) with genuinely equivalent capability, not just visually
parallel.

**Project Type**: Single project — this is a documentation-only edit
within the existing repository; no new source directories.

**Performance Goals**: N/A

**Constraints**: `scripts/validate.sh` MUST continue to pass after the
edit (SC-004) — no broken internal anchor links, no leftover reference
to a removed subsection. No changes to `scripts/bootstrap-install.sh`/
`.ps1` themselves (research.md confirms both already do everything this
feature's requirements depend on).

**Scale/Scope**: One file (`README.md`), one section (`## Installation`)
rewritten from ~120 lines (three paths, a Mermaid flowchart, a four-step
numbered walkthrough) down to a minimal command-block-plus-prose format
per `/speckit-clarify`'s Session 2026-07-13 decision.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I (English-source, globally-localized docs)**: Satisfied.
  FR-007 explicitly scopes this feature to `README.md` (English,
  canonical) only; the ten localized translations follow their own
  existing whole-project localization cadence (Development Workflow
  section), not a per-feature step — consistent with the v1.18.1
  amendment that already corrected this exact expectation.
- **Principle II (competitive research before creation)**: Not
  triggered. This feature adds no new skill, workflow, or structural
  pattern — it edits prose describing an already-shipped, already-
  researched mechanism (`bootstrap-install.sh`/`.ps1`, feature 024's own
  Principle II research already covers why a bootstrap installer is a
  genuine contribution). Same exemption class as features 025/026
  (revision to already-shipped work, not new pattern) — stated
  explicitly rather than silently skipped.
- **Principle III (harness compatibility)**: Satisfied. FR-003 retains
  `--harness`/`--auto` guidance and the link to the full Supported
  harnesses table; the simplification doesn't touch harness coverage
  itself, only how the *entry point* to installation is presented.
- **Principle IV (structured elicitation)**: Satisfied. The one
  consequential open question this feature had — how to handle the
  "no release cut yet" gap — was resolved via an explicit,
  recommendation-first question before `spec.md` was drafted; the one
  remaining spec-level ambiguity (diagram/steps vs. minimal format) was
  resolved via `/speckit-clarify` with a Recommended option, both
  matching this principle's "mark one option Recommended" requirement.
- **Principle V (spec completeness)**: Satisfied. `spec.md` carries zero
  `[NEEDS CLARIFICATION]` markers after the clarification session.
- **Principle VI (test-first / AI-first posture)**: Exemption stated
  above in Technical Context — pure documentation change, no executable
  logic, no meaningful red/green cycle.
- **Principle IX (validation battery)**: Satisfied without growth. This
  feature introduces no new unit-testable logic, integration behavior,
  or web UI — the existing `scripts/validate.sh` localized-docs/anchor
  checks (already part of `ci-gate`) are the applicable, sufficient
  battery member; SC-004 names it directly rather than inventing a new
  check for a prose-only change.
- **Principle X (trunk-based workflow)**: Standard — implementation
  lands on this feature branch, opens a PR, `ci-gate` validates,
  auto-merges on green.
- **Principle XIII (cross-platform)**: Satisfied, and the central
  technical decision of this plan: research.md resolves exactly how the
  PowerShell command block achieves genuine parity with the bash one
  (forwarding `-TargetDir`/`-Harness`/`-Auto`), not just a visually
  similar but functionally weaker example.
- **Principle XVI (efficient documentation)**: Directly advanced by this
  feature — the `/speckit-clarify` decision to drop the Mermaid
  flowchart and numbered steps in favor of prose is exactly this
  principle's "don't pad a format past what the content needs" applied
  to a single-command flow that no longer needs a diagram to explain it.
- **Principle XX (grounded, honest output)**: Satisfied. FR-004 and the
  spec's Assumptions section state plainly that, until this project's
  first GitHub Release is cut, the simplified one-liner will fail on
  first use and recovery depends on the script's own printed message —
  not hidden or overclaimed as already fully working.
- **Distribution & Ecosystem Standards**: The badge-row pre-PR review
  this section requires is a Phase 2 task item (see tasks.md once
  generated), not a plan-level gate — this feature doesn't change skill
  count, roadmap status, or any other badge-bearing fact, so the review
  is expected to find nothing to update, but still runs per the
  standing requirement.

No violations requiring justification. Complexity Tracking table is
empty by design.

## Project Structure

### Documentation (this feature)

```text
specs/031-simplify-install-bootstrap/
├── plan.md              # This file
├── research.md          # Phase 0 output — PowerShell one-liner-with-args syntax
├── quickstart.md         # Phase 1 output — validation scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not created by /speckit-plan)
```

`data-model.md` and `contracts/` are intentionally omitted: this feature
has no data entities (spec.md's Key Entities section is explicitly
marked not applicable) and exposes no external interface — it edits
existing prose in `README.md`, nothing else.

### Source Code (repository root)

```text
README.md   # the only file this feature's implementation touches
```

No `src/`, `tests/`, `backend/`, `frontend/`, or platform-specific
directories are affected. `scripts/bootstrap-install.sh` and
`scripts/bootstrap-install.ps1` are read (to confirm their existing
parameters and behavior, per research.md) but not modified.

**Structure Decision**: Single-file documentation edit. No new
directories, no source code changes. The one design decision with real
content is the PowerShell command block's exact syntax (research.md),
which is embedded directly in `README.md`'s prose, not a separate
artifact.

## Complexity Tracking

*No Constitution Check violations — this section is intentionally empty.*
