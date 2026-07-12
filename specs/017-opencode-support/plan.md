# Implementation Plan: OpenCode Harness Support

**Branch**: `017-opencode-support` | **Date**: 2026-07-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/017-opencode-support/spec.md`

## Summary

Verify (not build) that OpenCode is already satisfied by this project's
existing `claude-code` and `codex-cli` install paths — confirmed via
OpenCode's own official docs that it scans `.claude/skills/` and
`.agents/skills/` directly, with an identical `SKILL.md` format. Add a CI
job proving this against OpenCode's specific documented rules, then
update README. No new installer code.

## Technical Context

**Language/Version**: bash + PowerShell for the new CI verification
logic; no changes to existing installer scripts

**Primary Dependencies**: none new

**Storage**: N/A

**Testing**: N/A — **Principle VI exemption**: this feature's deliverable
is CI verification logic and documentation, not application code.
Verification is the CI job itself running for real on all three OSes
(SC-001), the same model as feature 016.

**Target Platform**: Linux, macOS, Windows (Principle XIII) — matches
existing CI matrix

**Project Type**: CI configuration + documentation extension — smaller
in scope than feature 016 since no installer script changes are needed

**Performance Goals**: N/A

**Constraints**: **MUST NOT add a new branch to `scripts/install.sh`/
`.ps1`** (FR-004) — this is the central constraint distinguishing this
feature from feature 016; adding one would be redundant, unnecessary
code duplicating what already works

**Scale/Scope**: 1 new CI job (matrix, no separate native-PowerShell
job needed since this only re-inspects existing install output rather
than exercising harness-specific PowerShell parameters), 1 README row
update, 0 lines changed in `scripts/install.sh`/`.ps1`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Assessment |
|---|---|---|
| I. English-Source, Globally-Localized Documentation | Yes | README status-cell update, same localization follow-up pattern as feature 016. |
| II. Competitive Research Before Creation | Yes | `research.md` verifies OpenCode's exact discovery convention and naming rule from its own official docs rather than assuming compatibility from the earlier desk-research pass in `references/harness-capability-notes.md`. |
| III. Universal LLM & Harness Compatibility | Yes — this feature's whole purpose | OpenCode becomes the third harness with real, CI-proven support — at zero installer-code cost, since it's satisfied by paths already built. |
| IV. Structured, Opinionated Elicitation | N/A | Zero `NEEDS CLARIFICATION` markers in spec.md. |
| V. Specification Completeness for Autonomous Execution | Yes | Checklist passed cleanly. |
| VI. Test-First Delivery, AI-First Posture | Yes — exemption | See Technical Context; CI job is the real verification, matching feature 016's own model. |
| VII. Full-Stack Technical Depth On Demand | N/A | No application surface. |
| VIII. Token-Economy Tooling Integration | N/A | Not a scaffolding trigger point. |
| IX. Mandatory Skill Validation & Testing | Yes — load-bearing | The new CI job is exactly this principle's "prove it, don't assert it" mandate, applied to a claim ("OpenCode already works") that's cheap to state but easy to get subtly wrong (e.g. a naming-rule edge case) without a real check. |
| X. Trunk-Based Git Workflow with Self-Validating PRs | Yes | Standard branch → PR → `ci-gate` → auto-merge. |
| XI. Semantic-Versioned Releases | N/A | Normal changelog entry only. |
| XII. Star Wars-Flavored End-User Voice | N/A | No new user-facing skill prose. |
| XIII. Cross-Platform Support | Yes | New CI job matrixed across the same three OSes. |
| XIV. Guided Next-Step Suggestion | N/A | Not a `specjedi-*` skill. |
| XV. `specjedi-` Skill Naming Convention | N/A | No new skill; this feature verifies existing skills already comply with a *different* tool's naming rule, which turned out to already hold. |
| XVI. Efficient Documentation & Mermaid Diagram Literacy | N/A | No diagram/documentation-format decision here. |
| XVII. Skill Discovery & Gap-Filling | N/A | No domain gap. |
| XVIII. Zero-Footprint Installer with Harness Selection | Yes, by explicit non-action | This principle is satisfied by *not* adding redundant installer code — the existing harness selection already produces a result OpenCode can use; FR-004 makes this an explicit constraint, not an oversight. |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A | No `SKILL.md` content changes — confirmed compliant already. |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Yes — load-bearing | `research.md` grounds every claim (discovery paths, naming rule, format compatibility) in OpenCode's own docs, verified via a real audit script run against all 23 skills before the spec was even written — not asserted from the earlier, less-precise desk research. |
| XXI. Session-Start Orientation & the Master Yoda Greeting | N/A | Unrelated. |

No violations identified. **Complexity Tracking is not needed.**

## Project Structure

### Documentation (this feature)

```text
specs/017-opencode-support/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

`contracts/` not generated — no external interface.

### Source Code (repository root)

```text
.github/workflows/validate.yml   # MODIFIED — new opencode-compatibility
                                  # verification job (matrix, no separate
                                  # native-PowerShell job needed)
README.md                        # MODIFIED — OpenCode compatibility row

scripts/install.sh                # UNCHANGED (explicit constraint, FR-004)
scripts/install.ps1                # UNCHANGED (explicit constraint, FR-004)
```

**Structure Decision**: the smallest-footprint feature this session has
shipped — one CI job, one README row, zero installer-script changes,
matching spec.md's own framing precisely.

## Complexity Tracking

Not applicable.
