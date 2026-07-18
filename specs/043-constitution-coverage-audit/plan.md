# Implementation Plan: Whole-Project Constitution Coverage Audit

**Branch**: `043-constitution-coverage-audit` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/043-constitution-coverage-audit/spec.md`

## Summary

Ships a new, standalone skill — `specjedi-constitution-audit` — that
evaluates all 22 Core Principles plus the Distribution & Ecosystem
Standards and Development Workflow sections against the **entire current
project tree** (never a diff), reusing `specjedi-govcheck`'s exact
three-state taxonomy and report format for vocabulary consistency, and
cross-checking every claim in `references/principle-traceability.md`
against what actually exists today rather than trusting it at face
value. A new, separate skill rather than a mode on `specjedi-govcheck`
(research.md Decision 1), since the two skills' core reasoning models —
diff-scoped vs. whole-tree-scoped — are structurally different enough
that forcing one skill to do both would dilute rather than serve this
project's own single-purpose-skill convention.

## Technical Context

**Language/Version**: N/A — a Claude Code skill (`SKILL.md`, itself a
structured prompt), not executable code. No new language, runtime, or
script introduced.

**Primary Dependencies**: `git` (optional, only to confirm the branch/HEAD
being audited — no diff is computed). No `gh` CLI dependency, unlike
`specjedi-govcheck`'s named-PR mode: this feature has no PR concept at
all, only the current project tree.

**Storage**: N/A — reads `.specify/memory/constitution.md`,
`references/principle-traceability.md`, and the project tree; writes
nothing (FR-007, strictly read-only).

**Testing**: No new CI job (research.md Decision 4) — this is a
reasoning-driven skill, the same posture `specjedi-govcheck` already
established (no CI job of its own either). Validated via: (1) `scripts/
validate.sh`'s existing structural lint (frontmatter `name`/`description`
present — the only machine-checkable property of a `SKILL.md`), and (2)
a documented "Validation Coverage" section inside the new `SKILL.md`
itself, following the same four categories from `references/skill-
validation-testing-framework.md` that `specjedi-govcheck` already uses,
backed by one real, manual dry-run of this skill against this repository
itself before shipping (this repo's own constitution is the first real
test subject).

**Target Platform**: Any harness capable of running `specjedi-*` skills
— no OS-specific code, so Principle XIII (cross-platform `.sh`/`.ps1`
parity) does not apply; there is no script to pair.

**Project Type**: New `specjedi-*` skill, same class of addition as
`specjedi-govcheck`/`specjedi-skill-review`/`specjedi-status` — no new
project structure.

**Performance Goals**: N/A — a single on-demand reasoning pass over the
current project tree; no throughput or latency target beyond what any
other `specjedi-*` skill already implies.

**Constraints**: Must stay strictly read-only (FR-007) — no step may
write to the constitution, the traceability index, or any source file.
Must reuse `specjedi-govcheck`'s exact taxonomy/format rather than
inventing a new one (spec.md Assumptions, research.md Decision 2). Must
NOT be proactively self-invoked by `specjedi-implement` (research.md
Decision 5) — that per-PR gating role stays exclusively
`specjedi-govcheck`'s.

**Scale/Scope**: One new skill file plus a one-line pointer added to an
existing reference file — the smallest change that satisfies every FR;
no data-model, no contracts, no new supporting scripts.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II (Competitive Research Before Creation, NON-NEGOTIABLE) | `research.md` Decision 0 confirms no existing skill (`specjedi-govcheck`, `specjedi-skill-review`, `specjedi-status`) already answers a whole-project constitution-coverage question — research happened before spec.md was written and is restated formally here. | ✅ Pass |
| IX (Mandatory Skill Validation & Testing) | No CI job, matching `specjedi-govcheck`'s own established precedent for reasoning-driven skills; validated via structural lint + documented Validation Coverage section + manual dry-run against this repo (Testing above, research.md Decision 4). | ✅ Pass |
| XII (Star Wars-Flavored End-User Voice) | New skill's chat narration follows the same voice calibration `specjedi-govcheck` already uses — precise report table, Star Wars-flavored narration only around it. | ✅ Pass — enforced when writing SKILL.md |
| XIV (Guided Next-Step Suggestion) | FR-009 requires every Non-Compliant/gap finding to suggest a concrete next step — directly satisfies this principle. | ✅ Pass |
| XV (`specjedi-` Skill Naming Convention) | New skill named `specjedi-constitution-audit` — confirmed no collision against the current skill list. | ✅ Pass |
| XVII (Skill Discovery & Gap-Filling) | Not applicable — this is a directly-authored new skill closing a confirmed internal gap, not a `specjedi-find-skills` external-skill install. | N/A |
| XIX (Skill Authoring & Prompt Engineering Standard) | New `SKILL.md` MUST follow the Required Structure (frontmatter, context, step-by-step, examples) and Quality Bar (ruthless literalness, verifiable assertions, Always/Never guardrails) from `references/skill-authoring-standard.md`. | ✅ Pass — enforced when writing SKILL.md |
| XX (AI Discipline: Grounded, Honest Output) | Every verdict MUST cite checkable evidence (FR-003); traceability claims are re-verified, never trusted at face value (FR-004, research.md Decision 3) — directly this principle's own discipline applied to this skill's own output. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/043-constitution-coverage-audit/
├── plan.md              # This file
├── research.md           # Phase 0 output — 5 decisions
└── tasks.md              # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — same reasoning as
`specs/041`: the "entities" (Constitution Principle, Coverage Verdict,
Traceability Entry) are already fully specified in spec.md's Key
Entities, and the new `SKILL.md`'s own Format/Example section (mirroring
`specjedi-govcheck`'s) serves as the validation guide — there is no
separate runnable artifact beyond the skill itself.

### Source Code (repository root)

```text
.claude/skills/
└── specjedi-constitution-audit/
    └── SKILL.md          # NEW — whole-project constitution coverage
                            #   audit skill (see Implementation notes)

references/
└── principle-traceability.md   # MODIFIED — one-line pointer noting
                                  #   specjedi-constitution-audit as this
                                  #   file's verification companion, per
                                  #   this file's own documented
                                  #   maintenance convention
```

### Implementation notes for `speckit-tasks`/`speckit-implement`

**New `SKILL.md` structure** — directly mirrors
`.claude/skills/specjedi-govcheck/SKILL.md`'s own proven shape, with the
scope substitution below:

```yaml
---
name: specjedi-constitution-audit
description: Strictly read-only whole-project governance coverage audit against all 22 Constitution Core Principles plus the Distribution & Ecosystem Standards and Development Workflow sections — evaluated against the entire current project tree, never a diff. Cross-checks every claim in references/principle-traceability.md against what actually exists today, flagging drift and undocumented gaps. Runs standalone, on demand; never proactively self-invoked (that per-PR role belongs to specjedi-govcheck).
compatibility: Requires git only to confirm the branch/HEAD being audited (no diff computed, no gh CLI needed). Reads references/principle-traceability.md; writes nothing.
---
```

**Step-by-step** (adapted from `specjedi-govcheck`'s own Step 2-6, scope
changed from "diff" to "whole project tree"):

1. Load `.specify/memory/constitution.md` for the authoritative current
   principle list (count and text may have changed since
   `references/principle-traceability.md` was last updated — the
   constitution itself is always the source of truth, never the index).
2. Load `references/principle-traceability.md`, building a working map of
   principle → claimed mechanism.
3. For each of the 22 principles plus the 2 cross-cutting sections,
   reason explicitly (never keyword-pattern-match): does *anything
   currently in the project* implement this principle? Assign Not
   Applicable / Compliant / Non-Compliant per FR-002, citing the specific
   file/script/CI-job checked (FR-003).
4. For each principle with a traceability entry, verify the cited
   mechanism still exists and still does what's claimed (FR-004) — flag
   any mismatch as drift, naming what was checked and what was actually
   found (User Story 2 Scenario 1).
5. For each principle with NO traceability entry at all, flag explicitly
   as an undocumented coverage gap (FR-005) — never silently omitted.
6. Any confirmed conflict between actual project state and the
   constitution's own text is CRITICAL, unconditionally (FR-006) — same
   rule as `specjedi-govcheck`'s own Step 4.
7. Build the report: same table shape as `specjedi-govcheck`'s Format
   section, with an added "Traceability" column noting Verified / Drift /
   Undocumented for each row.
8. For every Non-Compliant or gap finding, suggest a concrete next step
   (FR-009) — e.g., "update `references/principle-traceability.md`'s row
   for Principle IX," never left open-ended.

**Always/Never guardrails to include** (per `references/skill-authoring-
standard.md`'s Required Structure): never edit the constitution,
traceability index, or any source file; never proactively self-invoke
from `specjedi-implement`; never collapse Not Applicable into
Compliant/Non-Compliant; always cite specific evidence per verdict.

**`references/principle-traceability.md` pointer**: a single new line in
its own header/Maintenance section noting that
`specjedi-constitution-audit` exists to verify this file's own claims
on demand — closing the loop this file's own header already
acknowledges ("like any fact-bearing index in this project..., it drifts
silently if a shipping PR forgets it").
