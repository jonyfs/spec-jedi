# Implementation Plan: Release Packaging & Publishing Workflow

**Branch**: `020-release-packaging` | **Date**: 2026-07-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/020-release-packaging/spec.md`

## Summary

Add a manually-triggered (`workflow_dispatch`-only) `.github/workflows/release.yml`
that validates a version string and the existing `scripts/validate.sh` battery,
packages a single universal downloadable artifact via a new
`scripts/package-release.sh`/`.ps1` pair, and — only when `dry_run: false` —
tags, publishes a GitHub Release with the artifact attached, and rewrites
`CHANGELOG.md`'s `## Unreleased` section into a versioned one. `dry_run: true`
(the default) performs every step except the three durable side effects,
so the mechanism can be rehearsed safely before the real first cut (`v0.1.0`).
Sub-Project A of a 3-part decomposition (release packaging → standalone
bootstrap installer → harness auto-detection) identified during
`/superpowers:brainstorming`; B and C are out of scope here.

## Technical Context

**Language/Version**: bash + PowerShell 7+ (`scripts/package-release.sh`/`.ps1`,
new files, matching every other `scripts/` pair in this repo — Principle
XIII); GitHub Actions workflow YAML (`.github/workflows/release.yml`, new
file, matching `validate.yml`'s existing job style)

**Primary Dependencies**: `gh` CLI (already used by every prior PR-shipping
cycle this session; `gh release create` is the actual publish mechanism —
no new dependency introduced, just a new invocation site), `tar` (already
present on all three target OSes)

**Storage**: N/A — the workflow produces a git tag, a GitHub Release, and a
`CHANGELOG.md` commit; no database or persistent service state

**Testing**: N/A — **Principle VI exemption**: this feature's deliverable is
CI workflow configuration and packaging-script logic, not application code
with unit-testable business logic. Verification is a real `dry_run: true`
execution of the actual workflow (SC-001, SC-003) — the same
"prove it with a real CI run, don't just assert it" model every prior
installer/harness feature this session used, not a unit test suite.

**Target Platform**: the workflow itself runs on `ubuntu-latest` (matching
every other job in `validate.yml`); the packaging script gets a genuine
`.ps1` counterpart per Principle XIII since spec.md's Assumptions state it
must also be runnable locally by the maintainer, whose machine could be any
of the three supported OSes

**Project Type**: extension to this repo's existing CI/release tooling
(`.github/workflows/`, `scripts/`) — not a `specjedi-*` product skill

**Performance Goals**: N/A — a one-shot, manually-triggered operation

**Constraints**: MUST NOT trigger automatically on push/merge (spec.md
FR-001, Constitution Principle XI) — `workflow_dispatch` only, no `push`/
`pull_request` trigger ever added to this workflow. MUST NOT publish
anything if `scripts/validate.sh` fails (FR-004) or if the `## Unreleased`
section is empty (FR-006) — both are hard gates before any packaging step
runs, not warnings.

**Scale/Scope**: 1 new GitHub Actions workflow, 1 new script pair
(`.sh`/`.ps1`), 1 new artifact format (a `.tar.gz` containing a known,
bounded file set), 1 `CHANGELOG.md` rewrite operation (real-run path only)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Assessment |
|---|---|---|
| I. English-Source, Globally-Localized Documentation | No | This feature produces no new user-facing README/docs content — it's a CI mechanism. `README.md`'s eventual "how to download a release" section is out of scope here (belongs to Sub-Project B, the bootstrap installer, which is what actually tells end users to use this). |
| II. Competitive Research Before Creation | Yes | `research.md` grounds the `workflow_dispatch` + `dry_run` input pattern and the `gh release create` invocation shape against GitHub Actions' and `gh` CLI's own official documentation before writing the workflow. |
| III. Universal LLM & Harness Compatibility | No | Not a harness-install feature — this is upstream infrastructure the eventual bootstrap installer (a separate, harness-relevant feature) will depend on. |
| IV. Structured, Opinionated Elicitation | Yes | Every scope/mechanism decision (dry-run mode, universal vs per-harness artifact, starting version, cutting mechanism) was resolved via `/superpowers:brainstorming`'s one-question-at-a-time, multiple-choice-preferred flow before this spec was written — zero `NEEDS CLARIFICATION` markers needed as a result. ✅ Compliant. |
| V. Specification Completeness for Autonomous Execution | Yes | `spec.md`'s checklist passed cleanly on first pass. ✅ Compliant. |
| VI. Test-First Delivery, AI-First Posture | Yes — exemption | See Technical Context's Testing line; verification is a real `dry_run: true` workflow execution, not a unit test suite. ✅ Compliant via stated exemption. |
| VII. Full-Stack Technical Depth On Demand | N/A | No application surface. |
| VIII. Token-Economy Tooling Integration | N/A | Not a scaffolding/session-trigger point. |
| IX. Mandatory Skill Validation & Testing | Yes — load-bearing | FR-004 makes `scripts/validate.sh` a hard release gate — this feature actively strengthens this principle's reach (a broken validation state can no longer reach a published release) rather than merely complying with it. |
| X. Trunk-Based Git Workflow with Self-Validating PRs | Yes | This feature itself ships via feature branch → PR → `ci-gate` → auto-merge, same as every other change. The *workflow this feature builds* is a separate, deliberately-manual mechanism (release cutting), not a relaxation of this principle's PR-merge discipline. ✅ Compliant. |
| XI. Semantic-Versioned Releases with Proactive Cut Suggestions | Yes — this feature's whole purpose | Closes the long-standing gap between `suggest-release.sh` (suggests only) and an actual cutting mechanism — `workflow_dispatch`-only, `dry_run`-gated, matching this principle's "deliberate, maintainer-driven step" requirement exactly. |
| XII. Star Wars-Flavored End-User Voice | No | CI workflow output (GitHub Actions step summaries), not `specjedi-*` skill narration — no established precedent in this repo for voicing raw CI log output, and forcing one here would be decorative rather than meaningful. |
| XIII. Cross-Platform Support | Yes — load-bearing | `scripts/package-release.sh` ships with a real `.ps1` counterpart, both real-dry-run tested on this machine before the workflow's own CI proof. |
| XIV. Guided Next-Step Suggestion | N/A | CI workflow, not a `specjedi-*` skill with its own next-step narration contract. |
| XV. `specjedi-` Skill Naming Convention | N/A | Not a `specjedi-*` skill. |
| XVI. Efficient Documentation & Mermaid Diagram Literacy | Yes | The brainstorming design used a Mermaid flowchart (already presented and approved) to show the dry-run/real-run branching — carried into `quickstart.md` below rather than re-derived. |
| XVII. Skill Discovery & Gap-Filling | N/A | No domain gap encountered — `gh` CLI and `tar` are both already in use/available. |
| XVIII. Zero-Footprint Installer with Harness Selection | No — but load-bearing for future work | This feature doesn't touch the installer itself; it produces the artifact a *future* standalone bootstrap installer (Sub-Project B) will download instead of requiring a repository clone. Explicitly named as follow-on scope in spec.md's Assumptions, not silently implied. |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A | No `SKILL.md` content in this feature. |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Yes — load-bearing | `research.md` grounds every mechanism choice in official `gh`/GitHub Actions documentation rather than assumption, and spec.md's Assumptions section explicitly states this feature does NOT itself cut the real `v0.1.0` — that remains a separate, deliberate maintainer action, not silently implied as "done" by this feature shipping. |
| XXI. Session-Start Orientation & the Master Yoda Greeting | N/A | Unrelated to this feature. |

No violations identified. **Complexity Tracking is not needed.**

## Project Structure

### Documentation (this feature)

```text
specs/020-release-packaging/
├── plan.md              # This file
├── research.md          # Phase 0 output — gh CLI / workflow_dispatch
│                         # / release-asset-upload mechanism verification
├── data-model.md         # Phase 1 output — Release Artifact, Release Run
├── quickstart.md         # Phase 1 output — dry-run and real-run scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not this command)
```

`contracts/` is intentionally **not generated**: this feature's only
external interface is the `workflow_dispatch` input schema itself, already
fully specified by `spec.md`'s FR-002 — a dedicated `contracts/` directory
would duplicate that without adding information.

### Source Code (repository root)

```text
scripts/
├── package-release.sh      # NEW — builds the universal .tar.gz artifact
└── package-release.ps1     # NEW — PowerShell counterpart (Principle XIII)

.github/workflows/
└── release.yml              # NEW — workflow_dispatch, dry_run-gated

CHANGELOG.md                  # MODIFIED at real-run time only (not by this
                               # PR itself) — ## Unreleased -> ## [vX.Y.Z]
```

**Structure Decision**: two new files under `scripts/` (following the
established `.sh`/`.ps1` pairing convention) plus one new workflow file
under `.github/workflows/` — no new top-level directory, matching the
"extends existing tooling categories" shape of features 015/016/019.

## Complexity Tracking

Not applicable — no Constitution Check violation was identified above.
