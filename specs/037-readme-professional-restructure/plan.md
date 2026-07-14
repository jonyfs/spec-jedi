# Implementation Plan: Restructure README as an SDD Primer With a Professional-But-Themed Voice

**Branch**: `037-readme-professional-restructure` | **Date**: 2026-07-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/037-readme-professional-restructure/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Restructure `README.md` to lead with a condensed, third-person SDD
primer (what-is-SDD → specjedi-mapping → installation → honest-
assessment teasers), keeping only a single retained "letter" hook line
from feature 036 (FR-001), and relocate — never delete — the skill
catalog table, both Mermaid diagrams, the 23 Quickstart steps,
"Recommended companions," and "Versioning & releases" into two new
reference docs and an expanded `CONTRIBUTING.md`, per the doc-split
decision in [research.md](research.md).

## Technical Context

**Language/Version**: N/A — Markdown documentation only, no code

**Primary Dependencies**: N/A

**Storage**: N/A — files under version control only

**Testing**: Manual fact-preservation check (badge/table/code-block
counts before vs. after — see research.md) plus `scripts/validate.sh`/
`.ps1` structural lint; no automated test suite applies to prose content

**Target Platform**: N/A — static Markdown rendered by GitHub and any
Markdown viewer

**Project Type**: Documentation restructure (single repository, no
source code changes)

**Performance Goals**: N/A

**Constraints**: FR-008 — zero fact loss (every badge, link, table row,
code block, install/release command must remain present and accurate,
either still in the README or relocated per FR-009)

**Scale/Scope**: One file rewritten (`README.md`), two new reference
docs created (`references/quickstart-guide.md`,
`references/recommended-companions.md`), one existing file extended
(`CONTRIBUTING.md`), all 10 i18n `docs/i18n/*/README.md` translations
left untouched (out of scope — see Assumptions below)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Applicability | Assessment |
|---|---|---|---|
| I | English-Source, Globally-Localized Documentation | Applicable | English `README.md` is the canonical source being restructured; the 10 `docs/i18n/*/README.md` translations are explicitly out of scope for this feature (Assumptions) — they fall behind until a follow-up translation pass, the same pattern features 032/036 already established for README-only changes. No violation: Principle I requires English-source-first, not simultaneous translation on every English edit. |
| II | Competitive Research Before Creation | N/A | No new `specjedi-*` skill or capability is introduced — this is a documentation reorganization. |
| V | Specification Completeness for Autonomous Execution | Compliant | spec.md's FR-001 through FR-010 and SC-001 through SC-005 are concrete and testable enough to execute without further guessing (verified during `/speckit-specify` validation). |
| VIII | Token-Economy Tooling Integration | N/A | No tooling change. |
| IX | Mandatory Skill Validation & Testing | N/A | No `SKILL.md` touched. |
| X | Trunk-Based Git Workflow | Applicable | Ships via feature branch `037-readme-professional-restructure` + PR, per the pattern every prior feature this session followed — no direct `main` commit. |
| XI | Semantic-Versioned Releases | Applicable | The relocated "Versioning & releases" section's content is functionally unchanged (research.md) — no policy change, just a new location inside `CONTRIBUTING.md`. |
| XII | Star Wars-Flavored End-User Voice | Applicable | FR-006 requires dialing back the sustained first-person "letter" narrator to third-person, professional-but-informal voice while keeping Star Wars references drawn from `references/star-wars-lexicon.md`'s curated pool as decorative seasoning — never invented ad hoc. Every new sentence written for this feature draws only from the lexicon. |
| XV | `specjedi-` Skill Naming Convention | N/A | No skill naming touched. |
| XVI | Efficient Documentation & Mermaid Diagram Literacy | Applicable | Both relocated Mermaid diagrams (skills mindmap, pipeline flowchart) move verbatim — no diagram content changes, only location (research.md). |
| XX | AI Discipline: Grounded, Efficient, Honest Output | Applicable | FR-004/SC-002 require the condensed honest-assessment/harness-capability teasers to keep a genuine limitation, not just an advantage — directly enforces this principle's own honesty bar on the condensed prose. |

No violations requiring Complexity Tracking — this is a content
reorganization with no architectural tradeoffs.

## Project Structure

### Documentation (this feature)

```text
specs/037-readme-professional-restructure/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output — doc-split decision, section order, verbatim-vs-tightened calls
├── quickstart.md         # Phase 1 output — validation scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks command — not created by /speckit-plan)
```

`data-model.md` and `contracts/` are skipped — this feature introduces
no entities and no interfaces (spec.md's own Key Entities section: "Not
applicable").

### Source Code (repository root)

```text
README.md                              # rewritten per research.md's new section order
CONTRIBUTING.md                        # gains "## Versioning & releases" + letter-path.jpg
references/
├── quickstart-guide.md                # NEW — skill catalog table, both diagrams, 23 Quickstart steps
└── recommended-companions.md          # NEW — rtk/graphify content, relocated verbatim
docs/comic/
├── letter-open.jpg                    # stays, README opening hook anchor (unchanged)
└── letter-path.jpg                    # relocates into CONTRIBUTING.md (moved, not duplicated)
```

**Structure Decision**: Single-repository documentation restructure —
no `src/`/`tests/` layout applies. Three files change
(`README.md`, `CONTRIBUTING.md`, and the `letter-path.jpg` move), two
new reference docs are created under `references/`, matching this
project's existing flat `references/*.md` convention (see
`references/honest-assessment.md`, `references/skill-roadmap.md`, etc.
for the established shape).

## Complexity Tracking

*No violations — table intentionally omitted per the template's own "Fill ONLY if Constitution Check has violations" instruction.*

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
