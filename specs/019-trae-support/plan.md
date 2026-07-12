# Implementation Plan: Trae Harness Support

**Branch**: `019-trae-support` | **Date**: 2026-07-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/019-trae-support/spec.md`

## Summary

Extend `scripts/install.sh`/`.ps1` to support `--harness trae`, copying
the same unmodified `specjedi-*` skill directories to `.trae/skills/`
instead of `.claude/skills/` or `.agents/skills/` — verified via Trae's
own official Skills docs, community documentation, and authoritatively
via Vercel's `skills` CLI source (`vercel-labs/skills`, `src/agents.ts`,
`skillsDir: '.trae/skills'`) to use the same `name`/`description`
frontmatter convention as the other four harnesses. A contradictory
GitHub bug report is investigated and traced to a path mismatch in the
reporter's own steps, not a real discovery-convention gap — documented
in `research.md` rather than silently discarded. Update README's
compatibility table and add a matching CI job pair proving the install
path works on all three OSes, mirroring the existing
`install-test-codex-cli`/`install-test-codex-cli-windows-native` jobs.

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
`install-test-codex-cli` job already uses — not a unit test suite.

**Target Platform**: Linux, macOS, Windows (Principle XIII) — the
installer itself already supports all three; this feature adds a third
harness branch to that same cross-platform logic, not a new platform
surface

**Project Type**: extension to an existing repo-local CLI script
(`scripts/install.sh`/`.ps1`), same category as feature 016 — not a
`specjedi-*` product skill

**Performance Goals**: N/A — a one-shot install operation, same
performance profile as the existing paths

**Constraints**: MUST NOT touch the existing `claude-code`/`codex-cli`
harness paths' behavior — this is a strictly additive branch, not a
refactor of the working paths (spec.md's Edge Cases require the
installer to only ever touch `specjedi-*`-named subdirectories, never
wipe a pre-existing `.trae/skills/` directory wholesale — relevant since
Trae also has its own separate `npx skills`-CLI-managed skill ecosystem
that could already occupy that directory)

**Scale/Scope**: 1 new harness branch in 2 existing scripts, 1 README
table row update, 2 new CI jobs (matrix + native-PowerShell), 1
`ci-gate` `needs:` list update

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Assessment |
|---|---|---|
| I. English-Source, Globally-Localized Documentation | Yes | README's compatibility table Trae-row status change (📋→✅) is a single-cell factual update; the 10 localized READMEs' harness tables need the same cell updated in a same-pattern follow-up PR, consistent with every prior harness-table edit this session. |
| II. Competitive Research Before Creation | Yes | `research.md` verifies Trae's exact frontmatter requirement and directory convention from official docs, community docs, and Vercel's own `skills` CLI source (a first-party executable specification), and explicitly investigates and resolves a contradictory GitHub bug report rather than ignoring it. ✅ Compliant. |
| III. Universal LLM & Harness Compatibility | Yes — this feature's whole purpose | Upgrades Trae from 📋 Planned to ✅ Supported with a real, CI-proven install path — the fifth harness to reach that bar, and the second (after Codex CLI) needing genuinely new installer code rather than being already satisfied. |
| IV. Structured, Opinionated Elicitation | N/A | No skill asking the user anything; `spec.md` had zero `NEEDS CLARIFICATION` markers. |
| V. Specification Completeness for Autonomous Execution | Yes | `spec.md`'s checklist passed cleanly. ✅ Compliant. |
| VI. Test-First Delivery, AI-First Posture | Yes — exemption | See Technical Context's Testing line; verification is a real CI job, not a unit test suite, matching the existing installer's own verification model. ✅ Compliant via stated exemption. |
| VII. Full-Stack Technical Depth On Demand | N/A | No application surface. |
| VIII. Token-Economy Tooling Integration | N/A | Not a scaffolding/session-trigger point. |
| IX. Mandatory Skill Validation & Testing | Yes — load-bearing | The new CI job pair (FR-007) is this principle's own "prove it, don't just assert it" mandate applied to a new capability — mirrors the existing `install-test-codex-cli` job pattern precisely. |
| X. Trunk-Based Git Workflow with Self-Validating PRs | Yes | Feature branch → PR → `ci-gate` → auto-merge, same as every other change. ✅ Compliant. |
| XI. Semantic-Versioned Releases | N/A | Not a release-triggering change beyond the normal changelog entry. |
| XII. Star Wars-Flavored End-User Voice | N/A | Installer script output already exists and stays in its current lightly-voiced style; this feature adds a branch to existing logic, not new user-facing prose requiring a fresh voice pass. |
| XIII. Cross-Platform Support | Yes — load-bearing | Both `.sh` and `.ps1` gain the new harness branch together, in the same PR, verified via a real dry run on this machine before the CI job proves the rest. |
| XIV. Guided Next-Step Suggestion | N/A | Installer output, not a `specjedi-*` skill with its own next-step narration contract. |
| XV. `specjedi-` Skill Naming Convention | N/A | Not a `specjedi-*` skill. |
| XVI. Efficient Documentation & Mermaid Diagram Literacy | N/A | No diagram/documentation-format decision in this feature's deliverable. |
| XVII. Skill Discovery & Gap-Filling | N/A | No domain gap encountered. |
| XVIII. Zero-Footprint Installer with Harness Selection | Yes — load-bearing | Extends the installer's harness-selection capability with a third real, working choice — the same principle feature 016 began fulfilling beyond a single hardcoded case. |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A | No `SKILL.md` content changes — the same grep audit from feature 016 (zero hardcoded harness-specific tool-name references) still holds; re-confirmed in Phase 0. |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Yes — load-bearing | `research.md` explicitly investigates a contradictory source (GitHub issue #2253), traces the discrepancy to a path mismatch in the bug report rather than dismissing or hiding it, and honestly scopes what this feature does NOT verify (actually running Trae itself, unavailable in this environment). |
| XXI. Session-Start Orientation & the Master Yoda Greeting | N/A | Unrelated to this feature. |

No violations identified. **Complexity Tracking is not needed.**

## Project Structure

### Documentation (this feature)

```text
specs/019-trae-support/
├── plan.md              # This file
├── research.md          # Phase 0 output — Trae docs verification +
│                         # bug-report investigation + grep audit
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
├── install.sh             # MODIFIED — new trae harness branch
└── install.ps1             # MODIFIED — same, PowerShell counterpart

README.md                   # MODIFIED — Trae compatibility row
.github/workflows/validate.yml  # MODIFIED — new install-test-trae
                                 # job pair, added to ci-gate's needs:
```

**Structure Decision**: no new files beyond the documentation set above —
this feature extends three existing files' internal logic rather than
introducing a new directory structure, matching spec.md's own framing.

## Complexity Tracking

Not applicable — no Constitution Check violation was identified above.
