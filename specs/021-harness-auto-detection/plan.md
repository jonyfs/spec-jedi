# Implementation Plan: Harness Auto-Detection

**Branch**: `021-harness-auto-detection` | **Date**: 2026-07-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/021-harness-auto-detection/spec.md`

## Summary

Extend `scripts/install.sh`/`.ps1` so `--harness` becomes optional: when
omitted, the installer checks three ranked signal types (target-local
directory > `PATH` binary > global config directory) for each of the
three real harness values, auto-installs on a single match, and resolves
multiple matches via the just-shipped Constitution v1.22.0
Recommended-option standard — an interactive lettered prompt when a real
TTY is available, an automatic Recommended-selection (stated explicitly)
otherwise or when a new `--auto` flag is passed. Any explicit `--harness`
value bypasses detection entirely, preserving byte-for-byte behavior for
every existing CI job. Sub-Project C of the 3-part decomposition
identified during feature 020's brainstorming.

## Technical Context

**Language/Version**: bash + PowerShell 7+, extending
`scripts/install.sh`/`.ps1` directly (Principle XIII). Bash logic MUST
stay bash-3.2-compatible (no associative arrays, no `mapfile`) since
macOS ships bash 3.2 by default and this project's own scripts already
target that floor.

**Primary Dependencies**: none new — `command -v` (POSIX), `read` (bash
builtin), `[ -t 0 ]` (TTY check, POSIX test); `Get-Command`,
`[Console]::IsInputRedirected` (PowerShell built-ins)

**Storage**: N/A — no new persistent state; detection is a read-only scan
of the filesystem/`PATH` at install time

**Testing**: N/A — **Principle VI exemption**: installer-script logic,
not application code with unit-testable business logic. Verification is
real dry runs with stubbed detection signals (single-match and
multi-match-with-`--auto` cases) plus a new CI job proving both on all
three OSes (FR-010) — the interactive-TTY prompt path is honestly
documented as manually-verified only, since GitHub Actions runners have
no real TTY (spec.md Assumptions).

**Target Platform**: Linux, macOS, Windows (Principle XIII)

**Project Type**: extension to existing repo-local CLI scripts
(`scripts/install.sh`/`.ps1`), same category as features 016/019/020

**Performance Goals**: N/A — detection adds a handful of filesystem/PATH
checks to a one-shot install operation

**Constraints**: MUST NOT change behavior for any explicit `--harness`
invocation (FR-001, FR-009) — every existing `install-test*` CI job must
pass completely unmodified. MUST NOT hang indefinitely in a
non-interactive context (FR-006) — a `read` with no TTY and no `--auto`
flag would block forever in CI/piped usage, so the TTY check itself is
load-bearing, not optional polish.

**Scale/Scope**: detection logic added to 2 existing scripts, 1 new
`--auto` flag in both, 1 new CI job (matrix + native-PowerShell) proving
the single-match and `--auto` multi-match paths, 0 new files

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Assessment |
|---|---|---|
| I. English-Source, Globally-Localized Documentation | No | No new README prose beyond a `--auto`/detection mention in the existing Installation section's flag list — a small factual addition, not new conceptual content requiring a fresh localization pass on its own (bundled into the next README-touching PR's usual sync). |
| II. Competitive Research Before Creation | Yes | `research.md` grounds the TTY-detection approach (`[ -t 0 ]`, `[Console]::IsInputRedirected`) and the `command -v`/`Get-Command` binary-detection approach against POSIX/PowerShell's own documented behavior, and re-confirms bash 3.2 compatibility constraints (macOS's shipped default) before writing array-free detection logic. |
| III. Universal LLM & Harness Compatibility | Yes | Directly serves this principle's own installer-selection mandate — makes the existing 3-harness selection easier to use correctly, not a new harness. |
| IV. Structured, Opinionated Elicitation | Yes — this feature's core mechanism | The first feature built specifically to exercise Constitution v1.22.0's project-wide Recommended-option standard outside the two skills that originated it (`specjedi-clarify`, `specjedi-onboard`) — proves the pattern generalizes to non-skill tooling (an installer script), not just conversational skills. |
| V. Specification Completeness for Autonomous Execution | Yes | `spec.md`'s checklist passed cleanly, zero `NEEDS CLARIFICATION`. ✅ Compliant. |
| VI. Test-First Delivery, AI-First Posture | Yes — exemption | See Technical Context's Testing line. ✅ Compliant via stated exemption. |
| VII. Full-Stack Technical Depth On Demand | N/A | No application surface. |
| VIII. Token-Economy Tooling Integration | N/A | Not a scaffolding/session-trigger point. |
| IX. Mandatory Skill Validation & Testing | Yes — load-bearing | FR-010's new CI job proves detection actually works, not just that the code exists — same "prove it, don't assert it" bar every prior installer feature met. |
| X. Trunk-Based Git Workflow with Self-Validating PRs | Yes | Feature branch → PR → `ci-gate` → auto-merge. ✅ Compliant. |
| XI. Semantic-Versioned Releases | N/A | Not a release-triggering change beyond the normal changelog entry. |
| XII. Star Wars-Flavored End-User Voice | Yes — light touch | The installer's existing lightly-voiced echo statements (📜/🔭/✅) get a few new lines in the same established style (detection results, Recommended marking) — not a new voice pass, just consistency with what's already there. |
| XIII. Cross-Platform Support | Yes — load-bearing | Both `.sh` and `.ps1` gain identical detection logic, same signal types, same priority order, real-dry-run tested on this machine before CI proves the rest. |
| XIV. Guided Next-Step Suggestion | N/A | Installer output, not a `specjedi-*` skill. |
| XV. `specjedi-` Skill Naming Convention | N/A | Not a `specjedi-*` skill. |
| XVI. Efficient Documentation & Mermaid Diagram Literacy | No | No diagram-worthy new structure — detection is a short priority-ranked checklist, clearer as prose/pseudocode in `research.md` than as a diagram. |
| XVII. Skill Discovery & Gap-Filling | N/A | No domain gap encountered. |
| XVIII. Zero-Footprint Installer with Harness Selection | Yes — this feature's whole purpose | Directly extends this principle's "let the user choose which harness" mandate — from "the user must already know and type the right value" to "the installer helps figure it out," while keeping explicit choice fully authoritative. |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A | No `SKILL.md` content in this feature. |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Yes — load-bearing | `research.md` grounds every mechanism in documented shell/PowerShell behavior; spec.md's Assumptions explicitly scope out the 17 not-yet-installable harnesses and honestly flag the interactive-TTY path as manually-verified only, not CI-proven. |
| XXI. Session-Start Orientation & the Master Yoda Greeting | N/A | Unrelated. |

No violations identified. **Complexity Tracking is not needed.**

## Project Structure

### Documentation (this feature)

```text
specs/021-harness-auto-detection/
├── plan.md              # This file
├── research.md          # Phase 0 output — TTY/binary-detection grounding
├── data-model.md         # Phase 1 output — Detection Signal, Detection Result
├── quickstart.md         # Phase 1 output — single-match, multi-match, zero-match scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not this command)
```

`contracts/` is intentionally **not generated**: no external interface
beyond the new `--auto` CLI flag, already fully specified by spec.md's
FR-008.

### Source Code (repository root)

```text
scripts/
├── install.sh             # MODIFIED — detection logic + --auto flag
└── install.ps1             # MODIFIED — same, PowerShell counterpart

.github/workflows/validate.yml  # MODIFIED — new harness-detection job
                                 # pair, added to ci-gate's needs:
```

**Structure Decision**: no new files — extends the same two existing
scripts (and the CI workflow) this feature's three predecessors
(016/019/020) already touched, matching that established shape.

## Complexity Tracking

Not applicable — no Constitution Check violation was identified above.
