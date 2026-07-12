# Implementation Plan: Competitive Comparison Table

**Branch**: `014-competitive-comparison` | **Date**: 2026-07-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/014-competitive-comparison/spec.md`

## Summary

Build `references/competitive-comparison.md`, a single scannable table
comparing Spec Jedi against the eleven SDD/agent-skill tools already
researched under Principle II (`spec-kit` baseline + BMAD-METHOD,
OpenSpec, Kiro, Tessl, Spec Kitty, Superpowers, GSD, PRP, Traycer,
codemyspec.com), reusing `specs/001-specjedi-pipeline/research.md`'s
existing citations rather than performing new competitor research, and
link it from `README.md` so it's discoverable. Structurally follows the
precedent already set this session by `references/genuine-contributions-log.md`
and `references/harness-capability-notes.md` — both are static,
data-derived reference tables with a stated maintenance trigger, not
`specjedi-*` skills.

## Technical Context

**Language/Version**: N/A — Markdown only, no executable code

**Primary Dependencies**: none new

**Storage**: N/A — a static file in the repo, no persistence layer

**Testing**: N/A — **Principle VI exemption**: this feature's sole
deliverable is a Markdown reference document (plus a one-line `README.md`
link edit), not application code with unit-testable business logic, so
test-first (TDD) execution does not apply. Verification is: (1) every row
traces to an actual citation in `specs/001-specjedi-pipeline/research.md`
(checked by direct comparison, not sampling), (2) the README link
resolves to the new file, (3) `scripts/validate.sh`/`.ps1` still passes
(structural lint covers the repo generally; this feature adds no new
constitution placeholders or skill files for it to flag).

**Target Platform**: N/A — rendered as GitHub-flavored Markdown, same as
every other `references/*.md` file

**Project Type**: documentation/reference artifact — same category as
`references/genuine-contributions-log.md` and
`references/harness-capability-notes.md`, not a `specjedi-*` product
skill (no install path, no harness-compatibility surface, no SKILL.md)

**Performance Goals**: N/A

**Constraints**: exactly the 11-tool scope already established in
`specs/001-specjedi-pipeline/research.md` (spec-kit baseline + 10 named
competitors) — no new competitor research performed for this feature
(spec.md Assumptions); every comparative claim MUST trace to that
existing document or another already-shipped artifact in this repo
(Principle XX)

**Scale/Scope**: 1 new file (~11 table rows) + 1 `README.md` edit (a
single new link)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Assessment |
|---|---|---|
| I. English-Source, Globally-Localized Documentation | Partial | The new file is authored in English (required, unconditional). The *localization* mandate only reaches "top-level project documentation (README, CONTRIBUTING, installation guides, and getting-started material)" per the principle's own text — `references/*.md` is not in that list, matching the precedent that neither `genuine-contributions-log.md` nor `harness-capability-notes.md` was localized. ✅ Compliant, not a gap. |
| II. Competitive Research Before Creation | Yes, satisfied by inheritance | This feature does not add "a new skill, workflow, or structural pattern" that itself requires fresh Principle II research — it packages research already performed and cited for feature 001. Scope is explicitly bounded to that existing field (spec.md Assumptions) rather than treated as license to research new competitors under this feature. ✅ Compliant. |
| III. Universal LLM & Harness Compatibility | N/A | No skill, no install path. |
| IV. Structured, Opinionated Elicitation | N/A | No skill asking a user anything; `spec.md` itself already went through `/speckit-specify`'s elicitation with zero `NEEDS CLARIFICATION` markers. |
| V. Specification Completeness for Autonomous Execution | Yes | `spec.md`'s own quality checklist passed with no clarifications needed — this plan can proceed without stopping to ask. ✅ Compliant. |
| VI. Test-First Delivery, AI-First Posture | Yes — exemption | See Technical Context's Testing line above; explicit reason stated per this principle's own requirement. ✅ Compliant via stated exemption. |
| VII. Full-Stack Technical Depth On Demand | N/A | No application surface. |
| VIII. Token-Economy Tooling Integration | N/A | Not a session/scaffolding trigger point. |
| IX. Mandatory Skill Validation & Testing | Yes | No new unit-testable logic, integration surface, or web UI is introduced — this feature does not trip `scripts/validate.sh`'s Principle IX battery-growth-trigger check, and shouldn't (there's nothing here that check exists to catch). ✅ Compliant, no new CI job needed. |
| X. Trunk-Based Git Workflow with Self-Validating PRs | Yes | Feature branch (`feat/competitive-comparison`) → PR → `ci-gate` → auto-merge, same as every other change. ✅ Compliant. |
| XI. Semantic-Versioned Releases | N/A | A reference-doc addition doesn't need special release handling beyond the existing `suggest-release.sh` mechanism. |
| XII. Star Wars-Flavored End-User Voice | N/A for the document body | Principle XII's text scopes the voice requirement to "whenever a Spec Jedi skill is actually talking to an end user" (prompts, chat, progress updates) — a static comparison table is generated reference content, not skill-user dialogue, matching the precedent that neither `genuine-contributions-log.md` nor `harness-capability-notes.md` carries in-body voice. The skill's own chat narration delivering this work may still use voice. |
| XIII. Cross-Platform Support | N/A | No scripts added. |
| XIV. Guided Next-Step Suggestion | Yes | Completion report to the user will close with a bulleted next-step list. ✅ Compliant. |
| XV. `specjedi-` Skill Naming Convention | N/A | Not a skill. |
| XVI. Mermaid-First Process Documentation | N/A | A tool×dimension comparison matrix is tabular data, not a process flow — a Markdown table is the correct format here, consistent with this project's own precedent of using tables (not Mermaid) for the README's harness-compatibility and skill-roadmap listings, which are the same "tool × status" shape as this feature's own output. |
| XVII. Skill Discovery & Gap-Filling | N/A | No domain gap encountered — this task needs no new external skill. |
| XVIII. Zero-Footprint Installer | N/A | Not a `specjedi-*` product skill; the installer never copies `references/*.md` files, consistent with existing reference docs. |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A | Not a `SKILL.md`. |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Yes — the load-bearing gate for this feature | Every comparative claim in the new document MUST trace to an existing citation in `specs/001-specjedi-pipeline/research.md` (FR-003, SC-002) — zero new, unverified competitor claims. This is the principle this whole feature exists to satisfy correctly, not a passive checkbox. |

No violations identified. **Complexity Tracking is not needed** — this
plan introduces no new pattern, dependency, or structural deviation for
the constitution to weigh.

## Project Structure

### Documentation (this feature)

```text
specs/014-competitive-comparison/
├── plan.md              # This file
├── research.md          # Phase 0 output — states explicitly that no new
│                         # competitor research is performed; points to
│                         # specs/001-specjedi-pipeline/research.md as the
│                         # authoritative source instead of duplicating it
├── quickstart.md         # Phase 1 output — how to verify the shipped table
└── tasks.md              # Phase 2 output (/speckit-tasks — not this command)
```

`data-model.md` and `contracts/` are intentionally **not generated**:
this feature has no persisted entities (the spec's "Compared Tool" /
"Comparison Dimension" Key Entities are markdown-table row/column
concepts, not a data model with relationships or state transitions) and
exposes no external interface for another system to consume (a
`references/*.md` file is read directly by humans, not called by other
code) — matching this plan's own Outline step 2 guidance to skip
`contracts/` "if project is purely internal."

### Source Code (repository root)

```text
references/
└── competitive-comparison.md   # NEW — the comparison table itself

README.md                       # MODIFIED — one new link added near the
                                 # existing "Supported harnesses"/roadmap
                                 # section, per FR-006
```

**Structure Decision**: single new reference file under `references/`
(matching `genuine-contributions-log.md`/`harness-capability-notes.md`'s
existing convention exactly — same directory, same "static, cited,
maintenance-note-bearing Markdown document" shape) plus a one-line
`README.md` edit for discoverability. No `src/`, `tests/`, `backend/`,
`frontend/`, or mobile structure applies — this project's documentation
lives at the repository root and under `references/`/`docs/i18n/`, not in
a language-specific source tree, consistent with every prior
`references/*.md` addition this project has shipped.

## Complexity Tracking

Not applicable — no Constitution Check violation was identified above.
