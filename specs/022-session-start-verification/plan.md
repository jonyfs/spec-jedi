# Implementation Plan: Session-Start Live-Render Verification Closure

**Branch**: `022-session-start-verification` | **Date**: 2026-07-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/022-session-start-verification/spec.md`

## Summary

A constitution/traceability audit (requested directly by the user) found
Principle XXI's single remaining named gap: feature 015's T020, "an
actual live Claude Code session start rendering the greeting end to end
— not observable from within the same session that built it." This
session's own transcript contains that exact confirmation: a real
`SessionStart:compact` firing produced the correct three-part payload,
verifiable against the conversation's own tool-result history. This
feature closes that gap with the real evidence cited, and separately
resolves a genuinely new conflict the same transcript surfaced: the
render-verbatim instruction and a session-continuation ("resume
directly, don't preface") instruction both applied to the same turn, and
in the observed instance the continuation instruction won by accident,
not by documented precedence. A constitution amendment (Principle XXI)
resolves that precedence explicitly.

## Technical Context

**Language/Version**: Markdown documentation only — no code changes.
`scripts/session-start.sh`/`.ps1` are unchanged (spec.md Assumptions);
this feature closes a verification claim and a governance question, not
mechanism code.

**Primary Dependencies**: none

**Storage**: N/A

**Testing**: N/A — **Principle VI exemption**: a documentation/
governance closure, not application code. Verification is direct
citation of real transcript content (FR-001) plus this project's
standard constitution-amendment validation (`scripts/validate.sh`).

**Target Platform**: N/A

**Project Type**: documentation/governance closure — same category as
the constitution-only amendments this session already shipped (v1.19.0,
v1.20.0, v1.21.0, v1.22.0)

**Performance Goals**: N/A

**Constraints**: The cited evidence (FR-001) MUST be the actual, quoted
content observed in this session's transcript — not a paraphrase, not a
reconstruction from memory. The precedence rule (FR-003/FR-004) MUST NOT
resolve the conflict by simply dropping Principle XXI's orientation
goal — it must still direct the agent to work real status into its
response where feasible even when a full verbatim render is
inappropriate.

**Scale/Scope**: 2 files updated (T020, principle-traceability.md), 1
file amended (`CLAUDE.md`'s session-start section), 1 constitution
amendment (Principle XXI, MINOR bump)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Assessment |
|---|---|---|
| I. English-Source, Globally-Localized Documentation | No | Internal governance/traceability documents, not the public README's user-facing content — no localization obligation. |
| II. Competitive Research Before Creation | N/A | Not creating new capability; closing a verification claim with real evidence already in hand. |
| III. Universal LLM & Harness Compatibility | N/A | Unrelated. |
| IV. Structured, Opinionated Elicitation | N/A | No skill asking the user anything in this feature. |
| V. Specification Completeness for Autonomous Execution | Yes | `spec.md`'s checklist passed cleanly. ✅ Compliant. |
| VI. Test-First Delivery, AI-First Posture | Yes — exemption | See Technical Context. ✅ Compliant via stated exemption. |
| VII-X, XIV, XV, XVII-XIX | N/A | No application surface, no new skill, no CI/PR-workflow change beyond the standard shipping cycle every feature already uses. |
| XI. Semantic-Versioned Releases | N/A | Not a release-triggering change beyond the normal changelog entry. |
| XII. Star Wars-Flavored End-User Voice | N/A | Internal governance documents, not user-facing skill narration. |
| XIII. Cross-Platform Support | N/A | No script changes. |
| XVI. Efficient Documentation & Mermaid Diagram Literacy | Yes | No diagram warranted — this is a short, factual claim-correction and a one-paragraph precedence rule, not structure a diagram would clarify. Applying Principle XVI's own judgment call correctly here means recognizing when *not* to add a diagram. |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Yes — this feature's whole purpose | The entire feature exists to replace a stale "not yet observed" claim with real, quoted evidence, and to surface (rather than silently accept) a genuinely discovered instruction conflict. This is Principle XX applied to the project's own governance documents, not just its skills. |
| XXI. Session-Start Orientation & the Master Yoda Greeting | Yes — this feature's subject | Directly closes this principle's own remaining gap and amends it with the newly-discovered precedence rule. |

No violations identified. **Complexity Tracking is not needed.**

## Project Structure

### Documentation (this feature)

```text
specs/022-session-start-verification/
├── plan.md              # This file
├── research.md          # Phase 0 output — the exact cited transcript evidence
├── data-model.md         # Phase 1 output — SessionStart Observation entity
├── quickstart.md         # Phase 1 output — verification of the citations
└── tasks.md              # Phase 2 output (/speckit-tasks — not this command)
```

`contracts/` is intentionally **not generated**: no external interface.

### Source Code (repository root)

```text
specs/015-session-start-hook/tasks.md  # MODIFIED — T020 closed with evidence
references/principle-traceability.md    # MODIFIED — Principle XXI row updated
CLAUDE.md                               # MODIFIED — precedence rule added
.specify/memory/constitution.md         # MODIFIED — Principle XXI amended (MINOR bump)
```

**Structure Decision**: no new files beyond the documentation set above —
this feature closes existing claims in existing files, matching the
shape of every prior constitution-only amendment this session shipped.

## Complexity Tracking

Not applicable — no Constitution Check violation was identified above.
