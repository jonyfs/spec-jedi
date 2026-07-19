# Implementation Plan: Interactive Next-Step Selection for `specjedi-*` Skills

**Branch**: `051-interactive-next-steps` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/051-interactive-next-steps/spec.md`

## Summary

Adds one new reference document, `references/next-step-interaction.md`,
defining the interactive-when-available/plain-list-fallback mechanism
for every `specjedi-*` skill's existing Principle XIV Next-Step
Suggestion moment, and amends Constitution Principle XIV itself to
require it — every skill that already cites "(Principle XIV)" inherits
the new behavior through that citation. To satisfy User Story 2's own
verification method (reading each skill's own text, not just trusting
inheritance), each of the 28 skills' own Principle XIV citation line
also gets one short added clause pointing to the new reference doc —
never a full restatement, avoiding 28-way duplication of the mechanism
itself.

## Technical Context

**Language/Version**: N/A — markdown skill content and one constitution
amendment; no application code.

**Primary Dependencies**: None new. Reuses each skill's own existing,
already-cited "(Principle XIV)" line as the attachment point.

**Storage**: N/A.

**Testing**: No CI job — reasoning-driven content change, matching this
project's own established precedent for skill-text-only features.
Validated via `scripts/validate.sh` (structural lint, still passes with
no skill losing required sections) and a manual spot-check across one
skill per discipline (User Story 2's own Independent Test).

**Target Platform**: N/A.

**Project Type**: Skill catalog + one constitution amendment + one new
reference doc.

**Performance Goals**: N/A.

**Constraints**: Constitution Principle III (harness-agnostic lowest-
common-denominator) is non-negotiable — the reference doc and every
skill's added clause MUST describe the interactive mechanism
conditionally ("when available"), never as an assumed capability. FR-006
(resolved via Clarification) explicitly excludes `specjedi-clarify`'s own
question-format from this change.

**Scale/Scope**: One new file (`references/next-step-interaction.md`),
one amendment to `.specify/memory/constitution.md` (Principle XIV, MINOR
version bump — expands an existing principle's requirement, doesn't
redefine it incompatibly), and one short added clause to each of the 28
currently-shipped `specjedi-*` skills' own existing Principle XIV
citation line.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II (Competitive Research Before Creation) | No new mechanism invented — reuses the harness's own native structured-choice capability (already used directly by this session's own AskUserQuestion-shaped tool); research.md documents this. | ✅ Pass |
| III (Universal LLM & Harness Compatibility) | The entire design is conditional layering over the existing plain-list baseline — the central constraint this plan is built around, not an afterthought. | ✅ Pass |
| IX (Mandatory Skill Validation & Testing) | No CI job; validated via `scripts/validate.sh` plus a manual cross-discipline spot-check (User Story 2's own Independent Test). | ✅ Pass |
| XIV (Guided Next-Step Suggestion) | This plan amends this exact principle — the amendment itself is additive (conditional enhancement), not a redefinition of its core "always offer a next step" requirement. | ✅ Pass |
| XIX (Skill Authoring & Prompt Engineering Standard) | Per-skill additions are one short clause each — token budget impact per skill is negligible (a few dozen tokens), confirmed via `wc -c` after edits. | ✅ Pass — enforced during implementation |
| XX (AI Discipline: Grounded, Honest Output) | The reference doc explicitly states the mechanism degrades silently and honestly when unavailable — never a fabricated claim of interactivity. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/051-interactive-next-steps/
├── plan.md              # This file
└── tasks.md             # Phase 2 output
```

No `research.md`/`data-model.md`/`quickstart.md` — no new mechanism
requiring competitive research beyond what's already cited (the
harness's own native tool), no data model, no separate runnable
scenario doc needed beyond the manual spot-check already named above.

### Source Code (repository root)

```text
references/
└── next-step-interaction.md   # NEW — the interactive/fallback mechanism,
                                 #   the escape-hatch rule, and the
                                 #   harness-agnostic framing

.specify/memory/constitution.md  # AMENDED — Principle XIV gains the
                                  #   conditional-interactive-mechanism
                                  #   requirement (MINOR bump)

.claude/skills/specjedi-*/SKILL.md  # 28 files, one short added clause
                                      #   each on the existing Principle
                                      #   XIV citation line
```

### Implementation notes

1. **Write `references/next-step-interaction.md`** first (Foundational):
   states the rule precisely — when the current harness session exposes
   a native structured-choice tool, render Next-Step options through it
   with a distinct, always-present "something else" option; otherwise
   render today's existing plain bulleted markdown list, unchanged. States
   this degrades silently and never assumes a tool that isn't there
   (Principle III/XX).
2. **Amend Constitution Principle XIV** (MINOR bump): add one paragraph
   citing the new reference doc, preserving the existing "MUST NOT end an
   interaction by leaving the user to guess" text unchanged — this is an
   addition, not a redefinition. Sync Impact Report per
   `references/constitution-mechanics.md`.
3. **Update each of the 28 skills' own Principle XIV citation line**: add
   a short clause, e.g. "— via the harness's own interactive choice
   mechanism when available (`references/next-step-interaction.md`),
   falling back to a plain bulleted list otherwise" immediately after the
   existing "(Principle XIV)" parenthetical, preserving every skill's own
   surrounding phrasing untouched.
4. **Validate**: `scripts/validate.sh` passes; spot-check one skill per
   discipline (`specjedi-specify` Core Pipeline, `specjedi-onboard`
   Onboarding & Guidance, `specjedi-skill-review` Quality & Review,
   `specjedi-status` Meta & Tooling) for the added clause's presence and
   correct wording.
