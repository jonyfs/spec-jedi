# Implementation Plan: Warp Harness Support

**Branch**: `018-warp-support` | **Date**: 2026-07-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/018-warp-support/spec.md`

## Summary

Verify (not build) that Warp's Agent Mode is already satisfied by this
project's existing `claude-code` and `codex-cli` install paths — Warp's
separate Skills system (distinct from its `AGENTS.md`/`WARP.md` Rules
file) scans `.claude/skills/` and `.agents/skills/` directly among ten
supported directory names. Add a CI job proving this, update README. No
new installer code — exactly feature 017's shape, applied to a second
harness.

## Technical Context

**Language/Version**: bash + PowerShell for new CI verification logic
only; no installer script changes

**Primary Dependencies**: none new

**Storage**: N/A

**Testing**: N/A — **Principle VI exemption**, identical reasoning to
feature 017: CI verification logic, not application code; the CI job
itself is the real verification (SC-001).

**Target Platform**: Linux, macOS, Windows — matches existing CI matrix

**Project Type**: CI configuration + documentation extension, same
scope class as feature 017

**Performance Goals**: N/A

**Constraints**: **MUST NOT add a new branch to `scripts/install.sh`/
`.ps1`** (FR-004) — identical constraint to feature 017's own FR-004

**Scale/Scope**: 1 new CI job, 1 README row update, 0 lines changed in
`scripts/install.sh`/`.ps1`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Assessment |
|---|---|---|
| I. English-Source, Globally-Localized Documentation | Yes | README status-cell update, same localization follow-up pattern as features 016/017. |
| II. Competitive Research Before Creation | Yes | `research.md` documents a real grounding correction (initial Rules-only research was incomplete; Warp's separate Skills docs give the accurate picture) rather than silently proceeding on the first, wrong finding. |
| III. Universal LLM & Harness Compatibility | Yes — this feature's whole purpose | Warp becomes the fourth harness with real, CI-proven support, and the second (after OpenCode) at zero installer-code cost. |
| IV. Structured, Opinionated Elicitation | N/A | Zero `NEEDS CLARIFICATION` markers. |
| V. Specification Completeness for Autonomous Execution | Yes | Checklist passed cleanly. |
| VI. Test-First Delivery, AI-First Posture | Yes — exemption | See Technical Context. |
| VII. Full-Stack Technical Depth On Demand | N/A | No application surface. |
| VIII. Token-Economy Tooling Integration | N/A | Not a scaffolding trigger point. |
| IX. Mandatory Skill Validation & Testing | Yes — load-bearing | New CI job proves the claim per this principle's "prove it, don't assert it" mandate. |
| X. Trunk-Based Git Workflow with Self-Validating PRs | Yes | Standard branch → PR → `ci-gate` → auto-merge. |
| XI. Semantic-Versioned Releases | N/A | Normal changelog entry only. |
| XII. Star Wars-Flavored End-User Voice | N/A | No new user-facing skill prose. |
| XIII. Cross-Platform Support | Yes | New CI job matrixed across the same three OSes. |
| XIV. Guided Next-Step Suggestion | N/A | Not a `specjedi-*` skill. |
| XV. `specjedi-` Skill Naming Convention | N/A | No new skill. |
| XVI. Efficient Documentation & Mermaid Diagram Literacy | N/A | No diagram/documentation-format decision here. |
| XVII. Skill Discovery & Gap-Filling | N/A | No domain gap. |
| XVIII. Zero-Footprint Installer with Harness Selection | Yes, by explicit non-action | Same reasoning as feature 017 — satisfied by *not* adding redundant installer code. |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A | No `SKILL.md` content changes — confirmed compliant already. |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Yes — load-bearing | `research.md` explicitly documents and corrects a real research gap (checked only one of Warp's two relevant doc pages initially) — exactly the "catch your own near-miss" discipline this principle requires, not just a clean-on-first-try narrative. |
| XXI. Session-Start Orientation & the Master Yoda Greeting | N/A | Unrelated. |

No violations identified. **Complexity Tracking is not needed.**

## Project Structure

### Documentation (this feature)

```text
specs/018-warp-support/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

`contracts/` not generated — no external interface.

### Source Code (repository root)

```text
.github/workflows/validate.yml   # MODIFIED — new warp-compatibility
                                  # verification job
README.md                        # MODIFIED — Warp compatibility row

scripts/install.sh                # UNCHANGED (FR-004)
scripts/install.ps1                # UNCHANGED (FR-004)
```

**Structure Decision**: identical footprint class to feature 017 — one
CI job, one README row, zero installer-script changes.

## Complexity Tracking

Not applicable.
