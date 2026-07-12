# Implementation Plan: Session-Start Orientation Hook

**Branch**: `015-session-start-hook` | **Date**: 2026-07-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/015-session-start-hook/spec.md`

## Summary

Build the `SessionStart` hook mechanism Constitution Principle XXI requires:
a fast bash/PowerShell script that derives a project status summary from
the same on-disk logic `specjedi-status` already implements, selects a
rotating Master Yoda line from `references/star-wars-lexicon.md`, embeds
an original ASCII Spec Jedi banner, and emits it all as `additionalContext`
per Claude Code's real `SessionStart` hook contract (verified in
`research.md`, not assumed) — paired with a `CLAUDE.md` render instruction,
since the hook alone cannot make the agent actually display the content.

## Technical Context

**Language/Version**: bash (POSIX-compatible, matching every other
`scripts/*.sh` in this repo) + a PowerShell 7+ counterpart (Principle
XIII), same dual-script convention already used by `scripts/validate.sh`/
`.ps1` and `scripts/install.sh`/`.ps1`

**Primary Dependencies**: none new — `grep`/`find`/`wc` (bash) and
`Get-ChildItem`/`Select-String` (PowerShell), the same primitives
`scripts/validate.sh`/`.ps1` already use

**Storage**: N/A — reads `specs/NNN-*/{spec,plan,tasks}.md` and
`references/star-wars-lexicon.md` directly each run; writes nothing,
persists nothing between sessions

**Testing**: N/A — **Principle VI exemption**: this feature's deliverable
is a shell script plus a `CLAUDE.md` prose instruction, not application
code with unit-testable business logic in the conventional sense. Given
this specific feature is *about* a runtime behavior (does a real session
actually render the greeting?), verification is a real, live dry run
(starting an actual fresh Claude Code session and confirming the
rendered output — SC-003) rather than a unit test suite, plus a
degrade-gracefully dry run (SC-004: deliberately break the hook, confirm
the session still starts).

**Target Platform**: Claude Code sessions in this repo specifically
(Principle III: only Claude Code is fully supported today; this feature
does not attempt a cross-harness equivalent)

**Project Type**: repo-local hook script + `CLAUDE.md` instruction —
same category as `scripts/validate.sh`, not a `specjedi-*` product skill
(no `SKILL.md`, no install-path/harness-compatibility surface of its own,
though the mechanism it enables is itself something a future installer
pass could consider bundling)

**Performance Goals**: sub-second hook execution — Claude Code's own
`SessionStart` performance guidance ("keep these hooks fast," per
`research.md`'s citation) is directly actionable here since the status
derivation reuses lightweight file-presence/checkbox-counting logic, not
an expensive scan

**Constraints**: `additionalContext` output MUST stay under Claude Code's
documented 10,000-character cap (FR-003); MUST degrade gracefully on any
error (FR-007) — a broken hook must never block a session from starting

**Scale/Scope**: 1 new script pair (`.sh`/`.ps1`), 1 `CLAUDE.md` edit, 1
`.claude/settings.json` hook registration entry

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Assessment |
|---|---|---|
| I. English-Source, Globally-Localized Documentation | Yes | Hook script and its output content are authored in English (source of truth); this is not top-level project documentation (README/CONTRIBUTING) so no localization mandate applies directly. ✅ Compliant. |
| II. Competitive Research Before Creation | Yes — the central gate for this feature | `research.md` benchmarks spec-kit + the 10 named competitors specifically on this capability, catches and corrects a real near-miss (a third-party repo's hook mistakenly attributable to official BMAD-METHOD), and names a genuine contribution (all three elements — status, branding, rotating persona line — combined at the harness-session level, which no researched tool does). ✅ Compliant. |
| III. Universal LLM & Harness Compatibility | Partial, by design | This feature is explicitly Claude-Code-specific (spec.md Assumptions) — `SessionStart` as documented is a Claude Code hook event; no other harness's equivalent is assumed. Consistent with Principle III's own current state (only Claude Code fully supported). |
| IV. Structured, Opinionated Elicitation | N/A | No skill asking the user anything; `spec.md` itself had zero `NEEDS CLARIFICATION` markers. |
| V. Specification Completeness for Autonomous Execution | Yes | `spec.md`'s quality checklist passed cleanly. ✅ Compliant. |
| VI. Test-First Delivery, AI-First Posture | Yes — exemption | See Technical Context's Testing line; explicit reason stated per this principle's own requirement, plus a stronger-than-usual live-verification bar (SC-003/SC-004) given this feature's own nature. ✅ Compliant via stated exemption. |
| VII. Full-Stack Technical Depth On Demand | N/A | No application surface. |
| VIII. Token-Economy Tooling Integration | N/A | Not a scaffolding/session-trigger point for `rtk`/`graphify`. |
| IX. Mandatory Skill Validation & Testing | Yes | This introduces a new script (`scripts/session-start.sh`/`.ps1`) — `scripts/validate.sh`/`.ps1`'s existing structural lint already covers new scripts generically; no new unit-testable logic, integration surface, or web UI is introduced that would trip the Principle IX battery-growth-trigger check. ✅ Compliant, no new CI job needed beyond what's already planned as a real dry-run verification task. |
| X. Trunk-Based Git Workflow with Self-Validating PRs | Yes | Feature branch → PR → `ci-gate` → auto-merge, same as every other change. ✅ Compliant. |
| XI. Semantic-Versioned Releases | N/A | Not a release-triggering change beyond the normal changelog entry. |
| XII. Star Wars-Flavored End-User Voice | Yes, narrowly | The greeting content itself uses the Master Yoda persona (Principle XXI's own narrower scope, not Principle XII's broad rotation) — the hook script's own code/comments stay plain, per the same "generated artifact vs. skill dialogue" boundary already established for `specjedi-diagram`. |
| XIII. Cross-Platform Support | Yes | `.sh` + `.ps1` pair, matching every other script in this repo. ✅ Compliant, verified via a real dry run on this machine (bash) plus `pwsh` where available. |
| XIV. Guided Next-Step Suggestion | N/A | Not a `specjedi-*` skill with user-facing next-step narration of its own; the hook's output is the orientation itself, not a skill report with a next-step list. |
| XV. `specjedi-` Skill Naming Convention | N/A | Not a `specjedi-*` skill — a repo-local hook script, same category as `scripts/validate.sh`. |
| XVI. Efficient Documentation & Mermaid Diagram Literacy | N/A | No diagram/documentation-format decision involved in this feature's own deliverable. |
| XVII. Skill Discovery & Gap-Filling | N/A | No domain gap encountered; the mechanism (Claude Code hooks) is already well-understood and cited from official docs. |
| XVIII. Zero-Footprint Installer | N/A | Not a `specjedi-*` product skill; whether a future installer pass should offer this hook as an option is out of scope for this feature (spec.md doesn't request it). |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A | Not a `SKILL.md`. |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Yes — load-bearing | `research.md` explicitly documents and corrects a near-miss grounding error (the third-party BMAD hook) rather than silently reporting it as official BMAD-METHOD behavior — exactly the discipline this principle requires. The "hook stdout becomes context, not a terminal print" claim is grounded in both official docs and a live inspection of this environment's own running `SessionStart` hook. |
| XXI. Session-Start Orientation & the Master Yoda Greeting | Yes — this feature's entire purpose | This feature is the deferred build the v1.20.0 amendment explicitly tracked as `TODO(SESSION_START_HOOK)`. |

No violations identified. **Complexity Tracking is not needed.**

## Project Structure

### Documentation (this feature)

```text
specs/015-session-start-hook/
├── plan.md              # This file
├── research.md          # Phase 0 output — real Principle II research
├── data-model.md         # Phase 1 output — the orientation payload shape
├── quickstart.md         # Phase 1 output — live verification scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not this command)
```

`contracts/` is intentionally **not generated**: this feature exposes no
external interface for another system to call — the hook's output is
consumed only by Claude Code's own `SessionStart` mechanism, which is
already fully specified by Claude Code's own documentation (cited in
`research.md`), not something this project defines a contract for.

### Source Code (repository root)

```text
scripts/
├── session-start.sh      # NEW — the hook script (bash)
└── session-start.ps1     # NEW — the hook script (PowerShell)

.claude/settings.json     # MODIFIED — registers the SessionStart hook
CLAUDE.md                 # MODIFIED — adds the render instruction (FR-006)
```

**Structure Decision**: matches this project's existing `scripts/*.sh` +
`*.ps1` convention exactly (same directory, same naming pattern as
`scripts/validate.sh`/`.ps1` and `scripts/install.sh`/`.ps1`) — no new
directory structure introduced.

## Complexity Tracking

Not applicable — no Constitution Check violation was identified above.
