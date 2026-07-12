# Implementation Plan: Codex CLI Install Path

**Branch**: `016-codex-cli-install` | **Date**: 2026-07-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/016-codex-cli-install/spec.md`

## Summary

Extend `scripts/install.sh`/`.ps1` to support `--harness codex-cli`,
copying the same unmodified `specjedi-*` skill directories to
`.agents/skills/` instead of `.claude/skills/` — verified via Codex CLI's
own official docs to use the same `name`/`description` frontmatter
convention, and via a direct grep audit that zero skills hardcode
Claude-Code-specific content. Update README's compatibility table and add
a matching CI job pair proving the install path works on all three OSes,
mirroring the existing `install-test`/`install-test-windows-native` jobs.

## Technical Context

**Language/Version**: bash + PowerShell 7+, extending the existing
`scripts/install.sh`/`.ps1` files directly (not new files) — same
language/tooling those files already use

**Primary Dependencies**: none new

**Storage**: N/A — copies files into a target directory, same as the
existing installer already does

**Testing**: N/A — **Principle VI exemption**: this feature's deliverable
is installer-script logic and CI configuration, not application code with
unit-testable business logic. Verification is a real CI job actually
reinstalling into a scratch directory on all three OSes and asserting the
result (SC-002), the same verification model the existing
`install-test` job already uses — not a unit test suite.

**Target Platform**: Linux, macOS, Windows (Principle XIII) — the
installer itself already supports all three; this feature adds a second
harness branch to that same cross-platform logic, not a new platform
surface

**Project Type**: extension to an existing repo-local CLI script
(`scripts/install.sh`/`.ps1`), same category as feature 015 — not a
`specjedi-*` product skill

**Performance Goals**: N/A — a one-shot install operation, same
performance profile as the existing Claude Code path

**Constraints**: MUST NOT touch the existing `claude-code` harness path's
behavior — this is a strictly additive branch, not a refactor of the
working path (spec.md's Edge Cases require the installer to only ever
touch `specjedi-*`-named subdirectories, never wipe a pre-existing
`.agents/skills/` directory wholesale)

**Scale/Scope**: 1 new harness branch in 2 existing scripts, 1 README
table row update, 2 new CI jobs (matrix + native-PowerShell), 1
`ci-gate` `needs:` list update

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Assessment |
|---|---|---|
| I. English-Source, Globally-Localized Documentation | Yes | README's compatibility table is top-level project documentation — the Codex CLI row status change (📋→✅) is a single-cell factual update, not new prose content requiring a fresh localization pass; the existing localized READMEs' harness tables will need the same cell updated in a same-pattern follow-up, consistent with how prior harness-table edits were handled. |
| II. Competitive Research Before Creation | Yes | `research.md` verifies (not assumes) Codex CLI's exact frontmatter requirement and directory convention from its own official docs, catches and corrects a real discrepancy between a third-party blog and the official source, and grounds the "no content rewrite needed" claim in a direct grep audit rather than an assumption. ✅ Compliant. |
| III. Universal LLM & Harness Compatibility | Yes — this feature's whole purpose | Upgrades Codex CLI from 📋 Planned to ✅ Supported with a real, CI-proven install path — the first harness beyond Claude Code to reach that bar. |
| IV. Structured, Opinionated Elicitation | N/A | No skill asking the user anything; `spec.md` had zero `NEEDS CLARIFICATION` markers (pre-spec research already resolved what would have needed them). |
| V. Specification Completeness for Autonomous Execution | Yes | `spec.md`'s checklist passed cleanly. ✅ Compliant. |
| VI. Test-First Delivery, AI-First Posture | Yes — exemption | See Technical Context's Testing line; verification is a real CI job, not a unit test suite, matching the existing installer's own verification model. ✅ Compliant via stated exemption. |
| VII. Full-Stack Technical Depth On Demand | N/A | No application surface. |
| VIII. Token-Economy Tooling Integration | N/A | Not a scaffolding/session-trigger point. |
| IX. Mandatory Skill Validation & Testing | Yes — load-bearing | The new CI job pair (FR-007) is exactly this principle's own "prove it, don't just assert it" mandate applied to a new capability — mirrors the existing `install-test` job pattern precisely rather than inventing a new verification style. |
| X. Trunk-Based Git Workflow with Self-Validating PRs | Yes | Feature branch → PR → `ci-gate` → auto-merge, same as every other change. ✅ Compliant. |
| XI. Semantic-Versioned Releases | N/A | Not a release-triggering change beyond the normal changelog entry. |
| XII. Star Wars-Flavored End-User Voice | N/A | Installer script output (echo statements) already exists and stays in its current lightly-voiced style (e.g. "📜 Installing..."); this feature adds a branch to existing logic, not new user-facing prose requiring a fresh voice pass. |
| XIII. Cross-Platform Support | Yes — load-bearing | Both `.sh` and `.ps1` gain the new harness branch together, in the same PR, verified via a real dry run on this machine before the CI job proves the rest. |
| XIV. Guided Next-Step Suggestion | N/A | Installer output, not a `specjedi-*` skill with its own next-step narration contract. |
| XV. `specjedi-` Skill Naming Convention | N/A | Not a `specjedi-*` skill. |
| XVI. Efficient Documentation & Mermaid Diagram Literacy | N/A | No diagram/documentation-format decision in this feature's deliverable. |
| XVII. Skill Discovery & Gap-Filling | N/A | No domain gap encountered. |
| XVIII. Zero-Footprint Installer with Harness Selection | Yes — load-bearing | This principle already mandates "MUST let the user choose which harness(es), from the Principle III compatibility matrix, to configure for" — today's installer only actually honors one choice (`claude-code`), rejecting every other named harness. This feature is the first real fulfillment of that "choose" language beyond a single hardcoded case. |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A | No `SKILL.md` content changes — confirmed by the grep audit in `research.md` that no skill needs rewriting for this harness. |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Yes — load-bearing | `research.md` explicitly catches and corrects a discrepancy between a third-party source and Codex CLI's own official docs, and honestly scopes what this feature does NOT verify (actually running Codex CLI itself, unavailable in this environment) rather than overclaiming end-to-end behavioral proof. |
| XXI. Session-Start Orientation & the Master Yoda Greeting | N/A | Unrelated to this feature. |

No violations identified. **Complexity Tracking is not needed.**

## Project Structure

### Documentation (this feature)

```text
specs/016-codex-cli-install/
├── plan.md              # This file
├── research.md          # Phase 0 output — Codex CLI docs verification + grep audit
├── data-model.md         # Phase 1 output — the Harness Target mapping
├── quickstart.md         # Phase 1 output — verification scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not this command)
```

`contracts/` is intentionally **not generated**: this feature exposes no
external interface — it extends an existing CLI script's internal branch
logic, already fully specified by `spec.md`'s functional requirements.

### Source Code (repository root)

```text
scripts/
├── install.sh             # MODIFIED — new codex-cli harness branch
└── install.ps1             # MODIFIED — same, PowerShell counterpart

README.md                   # MODIFIED — Codex CLI compatibility row
.github/workflows/validate.yml  # MODIFIED — new install-test-codex-cli
                                 # job pair, added to ci-gate's needs:
```

**Structure Decision**: no new files beyond the documentation set above —
this feature extends three existing files' internal logic rather than
introducing a new directory structure, matching spec.md's own framing
("same-content, different-target-directory," not new scaffolding).

## Complexity Tracking

Not applicable — no Constitution Check violation was identified above.
