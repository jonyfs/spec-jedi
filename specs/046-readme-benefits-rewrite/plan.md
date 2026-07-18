# Implementation Plan: README Objectivity & Evidence-Based Benefits Rewrite

**Branch**: `046-readme-benefits-rewrite` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/046-readme-benefits-rewrite/spec.md`

## Summary

Rewrites `README.md`'s substantive prose (opening SDD explanation, "How
Spec Jedi Implements SDD," Who this is for, Prerequisites, Installation,
Supported harnesses, Honest assessment, Contributing, License) into
cited, verifiable claims, and adds a new evidence-based comparison of
`specjedi-*` against the vendored `speckit-*` pipeline — citing
`specs/044-speckit-parity-audit/PARITY-LEDGER.md`'s real parity ratio
(8/11 full parity, 1/11 favorable divergence, 2/11 no equivalent) and
its 16-skill count of `specjedi-*`-only capabilities. The "How Spec Jedi
builds itself, in comic form" section and the single opening epigraph
line are explicitly left untouched, per precedent already settled twice
for this exact document (specs/036, specs/037).

## Technical Context

**Language/Version**: N/A — Markdown documentation only, no code.

**Primary Dependencies**: None new. Cites existing project artifacts
directly (`specs/044-speckit-parity-audit/PARITY-LEDGER.md`,
`references/principle-traceability.md`) rather than introducing any
new tooling.

**Storage**: N/A.

**Testing**: No new CI job. Verified the same way specs/037's own
README restructure was verified: a manual before/after content-
preservation check (badges, harness table rows, install commands, both
settled asides) plus a manual claim-by-claim citation check (every
comparative claim traced to its cited source) — matching this project's
existing precedent for documentation-only features (no unit-testable
code, integration surface, or web UI is introduced, so
`scripts/validate.sh`'s Principle IX battery-growth-trigger check does
not fire).

**Target Platform**: N/A — Markdown rendered by GitHub/any Markdown
viewer; no OS-specific behavior, so Principle XIII (cross-platform
`.sh`/`.ps1` parity) does not apply — nothing here is a script.

**Project Type**: Documentation-only change to a single existing file
(`README.md`); no new project structure.

**Performance Goals**: N/A.

**Constraints**: Every restated or newly-added claim MUST be traceable
to an existing project artifact (spec's FR-008, Constitution Principle
XX) — no invented capability language. The rewrite MUST NOT touch the
comic-panel section or the opening epigraph line (spec's FR-006,
Edge Cases) — both are settled, out-of-scope exceptions carried forward
from specs/036/037. The rewrite MUST NOT remove Constitution Principle
XII's required Star-Wars-flavored voice (spec's FR-005).

**Scale/Scope**: One file (`README.md`), substantive-prose sections
only — the largest-footprint alternative (splitting comparison content
into a new dedicated reference doc) was considered and rejected in
research.md Decision 2, since the evidence already lives in
`PARITY-LEDGER.md` and duplicating it into a new file would create a
second copy to keep in sync for no benefit over citing it directly.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I (English-Source, Globally-Localized Documentation) | `README.md` is the canonical English source; this change will trigger `scripts/validate.sh`'s existing (non-blocking) localized-docs-sync WARN for the 10 `docs/i18n/*/README.md` translations, same as any other English README edit — not a new gate, the existing mechanism already covers it. | ✅ Pass |
| II (Competitive Research Before Creation, NON-NEGOTIABLE) | No new capability is being invented — every claim this feature adds is a citation to research/evidence that already exists (`specs/044-speckit-parity-audit/PARITY-LEDGER.md`, itself built on real competitive research per its own Principle II gate). | ✅ Pass |
| XII (Star Wars-Flavored End-User Voice) | Explicitly preserved by spec FR-005/SC-004 — the objectivity pass targets unverifiable claims, not thematic voice; the comic-panel section and epigraph (both carrying this voice) are untouched by FR-006. | ✅ Pass |
| XX (AI Discipline: Grounded, Efficient, Honest Output) | Every restated or new claim must cite a real, existing artifact (spec FR-004/FR-008) — this feature is a direct application of this principle to the project's own most user-facing document. | ✅ Pass |
| IX (Mandatory Skill Validation & Testing) | Not Applicable — no code, no skill, no unit-testable surface introduced; `scripts/validate.sh`'s battery-growth-trigger check does not fire for a Markdown-only content edit. | N/A |
| XIII (Cross-Platform Support) | Not Applicable — no script is added or modified. | N/A |
| XV (`specjedi-` Skill Naming Convention) | Not Applicable — no new skill is created. | N/A |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/046-readme-benefits-rewrite/
├── plan.md              # This file
├── research.md          # Phase 0 output — 2 decisions
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — same reasoning as
specs/037/041/043/045: this feature revises existing prose and adds
citations; it introduces no entities, no interface contract, and no
runnable validation scenario beyond the manual content-preservation and
citation checks already described under Testing above.

### Source Code (repository root)

```text
README.md                # MODIFIED — substantive prose sections revised
                          #   for objectivity + evidence-based benefits
                          #   comparison (US1/US2/US3). Comic-panel
                          #   section and opening epigraph unchanged
                          #   (FR-006).
```

No other file is modified — this feature cites existing artifacts
(`specs/044-speckit-parity-audit/PARITY-LEDGER.md`,
`references/principle-traceability.md`) rather than editing them.

### Implementation notes for `speckit-tasks`/`speckit-implement`

**US1 — opening sections**: Rewrite "What Is Spec-Driven Development?"
and "How Spec Jedi Implements SDD" so a reader can pass spec.md's own
Acceptance Scenarios (name the four core artifacts, name 3+ real
skills, correctly state specjedi-* is a competitor rather than a
reskin) without leaving the section. Keep the existing Mermaid diagram
(skills-by-discipline flowchart) — it is already factual, not
marketing prose.

**US2 — comparison content**: Add a new subsection (or extend "How
Spec Jedi Implements SDD") stating the exact parity ratio and the
16-skill count, each citing
`specs/044-speckit-parity-audit/PARITY-LEDGER.md` directly (a relative
link, not a restated copy of the ledger's own prose). State the one
favorable-divergence claim (`specjedi-implement`'s trunk-based PR
discipline) using the ledger's own worded verdict, not a stronger
claim.

**US3 — remaining sections pass**: Read every remaining section (Who
this is for, Prerequisites, Installation, Supported harnesses, Honest
assessment, Contributing, License) and: (a) re-verify every number
against current project state (skill count, harness count, pipeline
stage count — FR-007) before restating it, (b) replace or remove any
unverifiable superlative per FR-004, (c) leave the "How Spec Jedi
builds itself, in comic form" section and the opening epigraph line
byte-for-byte unchanged (FR-006).

**Verification before shipping**: run a before/after diff limited to
the sections actually in scope (confirm the comic section and epigraph
are unchanged), grep the final document for common marketing
superlatives to confirm SC-002, and manually check every new/restated
comparative claim against its cited source to confirm SC-001. Confirm
every existing `#anchor`/relative-link target the file uses still
resolves (SC-006).
