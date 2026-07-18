# Implementation Plan: `specjedi-*`/`speckit-*` Parity Audit & Internal Migration Readiness

**Branch**: `044-speckit-parity-audit` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/044-speckit-parity-audit/spec.md`

## Summary

Produces a single evidence-based deliverable —
`specs/044-speckit-parity-audit/PARITY-LEDGER.md` — comparing all 11
`speckit-*` commands against `specjedi-*`'s command set by actual
described behavior (never name-matching alone), and a migration-
readiness recommendation. `research.md`'s real comparison (done during
this planning phase, since the comparison itself IS this feature's
central technical work) already found: 8 of 11 full parity, 1 partial
parity (`speckit-implement` vs. `specjedi-implement` — favorably
diverged, not a gap), 2 no-equivalent gaps (`speckit-taskstoissues`,
`speckit-agent-context-update` — the latter architecturally superseded,
not merely missing), plus one independent structural blocker: `specjedi-
*`'s pipeline skills have no equivalent of `.specify/extensions.yml`'s
hook-dispatch mechanism every `speckit-*` skill implements individually.
Shipped as a one-time analysis document, not a new skill (research.md
Decision 1) — the underlying question has a natural endpoint once acted
on, unlike specs/043's genuinely recurring constitution-coverage concern.

## Technical Context

**Language/Version**: N/A — a Markdown analysis deliverable, not
executable code. No new language, runtime, or script.

**Primary Dependencies**: None. The comparison work reads existing
`SKILL.md` files and `.specify/extensions.yml` directly; no external
tooling beyond what's already in this repository.

**Storage**: N/A — produces one new document
(`specs/044-speckit-parity-audit/PARITY-LEDGER.md`); reads but never
modifies any `speckit-*`/`specjedi-*` skill file or `.specify/
extensions.yml` as part of this feature itself (per spec.md Assumptions:
this audit doesn't perform the migration, only recommends it).

**Testing**: N/A in the conventional sense — there is no code to test.
Verification is: every one of the 11 `speckit-*` commands appears in the
ledger with an explicit verdict (SC-001, directly checkable by counting
table rows against `ls .claude/skills/ | grep speckit-`), and every
Partial Parity/No Equivalent finding cites the specific evidence checked
(SC-002), both already satisfied in research.md and carried into the
final deliverable unchanged.

**Target Platform**: N/A — a document, not a runtime artifact.

**Project Type**: One-time analysis/documentation deliverable — not a
new skill, script, or CI job (research.md Decision 1). Distinguishes
this feature's shape from specs/043's new-skill shape even though both
originated from the same `/speckit-specify` review session.

**Constraints**: The deliverable MUST NOT recommend or perform the
migration itself — only report findings and a recommendation (spec.md
Assumptions, FR-007/FR-008 scoped to reporting, not action). Every
finding MUST distinguish "blocks internal migration" from "would also be
a shippable product feature" per spec.md's own Edge Cases.

**Scale/Scope**: Eleven `speckit-*` commands compared against the full
`specjedi-*` catalog (27 skills as of this writing) plus one
configuration file (`.specify/extensions.yml`) — a bounded, one-time
comparison, not an ongoing mechanism.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II (Competitive Research Before Creation, NON-NEGOTIABLE) | This entire feature *is* the competitive-research act Principle II requires before any future decision to migrate — research.md's comparison is grounded in reading every actual `SKILL.md`, never assumed from naming. | ✅ Pass |
| XX (AI Discipline: Grounded, Honest Output) | Every Full/Partial/No-Equivalent verdict in research.md cites the specific file/behavior checked; the `speckit-agent-context-update` finding explicitly avoids overstating a gap that's actually superseded by a better mechanism, rather than inflating the blocker count. | ✅ Pass |
| XIV (Guided Next-Step Suggestion) | Every blocker in research.md Decision 5 pairs with a concrete next step (FR-008) — directly this principle's discipline. | ✅ Pass |
| X (Trunk-Based Git Workflow) | This feature's own work proceeds on branch `044-speckit-parity-audit`; the one finding that touches this principle directly (`speckit-implement` vs. `specjedi-implement`) confirms `specjedi-implement` already enforces this principle more strictly — no action needed here, noted as a favorable divergence. | ✅ Pass |

No violations requiring Complexity Tracking. No new skill, script, or CI
job is introduced by this feature — the smallest possible footprint for
what was asked: an audit and a recommendation, nothing more.

## Project Structure

### Documentation (this feature)

```text
specs/044-speckit-parity-audit/
├── plan.md              # This file
├── research.md           # Phase 0 output — the actual parity ledger,
│                         #   migration-readiness recommendation
├── PARITY-LEDGER.md      # Phase 2 output (speckit-tasks/speckit-implement) —
│                         #   the polished, standalone deliverable version
│                         #   of research.md's findings, meant to be read
│                         #   on its own without needing this plan's
│                         #   surrounding context
└── tasks.md              # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — this feature produces
one document, not a system with entities, interfaces, or a runnable
validation flow beyond reading the deliverable itself.

### Source Code (repository root)

No source code changes. This feature reads
`.claude/skills/speckit-*/SKILL.md`, `.claude/skills/specjedi-*/SKILL.md`,
and `.specify/extensions.yml` — it does not modify any of them (spec.md
Assumptions: the audit doesn't perform the migration).

### Implementation notes for `speckit-tasks`/`speckit-implement`

**`PARITY-LEDGER.md`** is research.md's Decision 2/3/4/5 tables and
findings, re-presented as a standalone, self-contained document (own
title, own intro sentence orienting a reader who hasn't seen this plan) —
not a mechanical copy-paste, but not a re-derivation either: the
findings are already correct and evidenced in research.md; this step is
presentation, not new analysis.

**No task should re-run the comparison from scratch** — research.md's
findings were produced by direct inspection during this planning phase
(reading actual `SKILL.md` frontmatter/bodies, actual
`.specify/extensions.yml` content, actual `scripts/install.sh` behavior)
and are already verified; `speckit-tasks`/`speckit-implement` tasks
should cite and reformat them, not redo the investigation.

**Recommended action items to surface prominently in the final
deliverable's opening summary** (per FR-007's "explicit recommendation"
requirement): (1) confirm with the maintainer whether
`speckit-taskstoissues`'s capability is truly unneeded internally (likely
yes, given zero historical use), (2) explicitly document
`speckit-agent-context-update`'s supersession rather than treating it as
open work, (3) decide whether to extend `specjedi-*` pipeline skills with
`extensions.yml` hook-dispatch support — the one blocker requiring actual
engineering — before any full internal migration.
