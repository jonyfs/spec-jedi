# Implementation Plan: Close Prompt-Engineering Gaps in 5 `specjedi-*` Skills

**Branch**: `034-skill-prompt-quality` | **Date**: 2026-07-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/034-skill-prompt-quality/spec.md`

## Summary

An earlier audit this session read all 24 shipped `specjedi-*` skills
against Constitution Principle XIX's five prompt-engineering dimensions
and found two narrow, real gaps: audience calibration missing in
`specjedi-constitution`/`specjedi-specify`/`specjedi-find-skills`, and
chain-of-thought missing or weak in `specjedi-onboard`/`specjedi-quick`.
This feature closes exactly those 5 gaps — no more, no less — each fix
matching the already-shipped pattern a sibling skill already carries
(`specjedi-clarify`'s audience-calibration boundary note;
`specjedi-checklist`/`specjedi-converge`/`specjedi-migrate`/
`specjedi-diagram`/`specjedi-plan`'s "reason through this explicitly"
chain-of-thought framing), not an invented new phrasing.

## Technical Context

**Language/Version**: N/A — `SKILL.md` prompt content only; no code, no
new script files.

**Primary Dependencies**: None beyond the already-shipped sibling skills
whose existing audience-calibration/chain-of-thought sections this
feature's fixes are patterned on.

**Storage**: N/A.

**Testing**: Principle VI exemption — documentation content, not
application code (same exemption class as feature 033). Verification
takes the form of `quickstart.md`'s read-through scenarios (SC-001/
SC-004) plus a token-count check per edited file (SC-003).

**Target Platform**: N/A.

**Project Type**: Single project — a narrow, 5-file documentation-content
revision.

**Performance Goals**: N/A.

**Constraints**: FR-006 — no skill other than these 5 may be modified.
FR-007 — every edited file must stay within Principle XIX's ~5,000-token
ceiling.

**Scale/Scope**: 5 existing `specjedi-*` `SKILL.md` files each gain one
small, targeted addition (3 audience-calibration notes, 2 chain-of-thought
instructions). No README/skill-count changes (no new skill ships).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I**: N/A — no README/localized-docs content touched.
- **Principle II**: Satisfied — see `research.md`. This is a targeted fix
  for gaps an internal audit already found this session; per spec.md's
  own Input note, no new external competitor research is needed (the
  fix pattern is "match an already-shipped sibling skill's own version,"
  not invent a new approach).
- **Principle III**: N/A.
- **Principle IV**: N/A — this feature adds calibration/reasoning
  instructions to existing skills, it doesn't introduce a new elicitation
  moment of its own.
- **Principle V**: Satisfied — `spec.md` carries zero open
  `NEEDS CLARIFICATION` markers.
- **Principle VI**: Exemption stated above.
- **Principle VII**: N/A.
- **Principle VIII**: N/A.
- **Principle IX**: N/A — this feature doesn't touch validation-testing-
  framework coverage (that's feature 033's distinct scope, per spec.md's
  own Assumptions).
- **Principle X**: Standard feature-branch → PR → `ci-gate` → auto-merge
  flow.
- **Principle XI**: N/A.
- **Principle XII**: N/A — the additions are structured instruction
  content (calibration/reasoning notes), matching the existing exemption
  for precise generated-artifact/instruction content over narration voice.
- **Principle XIII**: Satisfied by construction — no new `.sh`/`.ps1`
  files.
- **Principle XIV**: N/A — each skill's existing next-step section is
  untouched.
- **Principle XV**: N/A — no new skill named.
- **Principle XVI**: N/A — no diagram-worthy content.
- **Principle XVII**: N/A.
- **Principle XVIII**: N/A.
- **Principle XIX**: Directly relevant — this feature *is* Principle
  XIX's own compliance mechanism catching up with itself, the same class
  of self-referential fix as feature 033 for Principle IX. FR-007's
  token-ceiling constraint is this principle's own bound, verified per
  file.
- **Principle XX**: Directly modeled — every fix traces to the specific
  audit finding spec.md's Problem section already named, and to the
  specific sibling skill's own existing pattern being matched, never
  invented.
- **Principle XXI**: N/A.
- **Distribution & Ecosystem Standards**: N/A — no new skill, no badge/
  skill-count change.
- **Development Workflow**: This exact pipeline (research → specify →
  clarify → plan → tasks → implement → validation → PR) is being
  followed live for this feature.

No violations requiring justification. Complexity Tracking table is
empty by design.

## Project Structure

### Documentation (this feature)

```text
specs/034-skill-prompt-quality/
├── plan.md              # This file
├── research.md          # Phase 0 output — the 5 fix patterns, each grounded in an existing sibling skill
├── quickstart.md         # Phase 1 output — read-through + token-count validation scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not created by /speckit-plan)
```

`data-model.md` and `contracts/` are intentionally omitted — no data
entities, no external interface.

### Source Code (repository root)

```text
.claude/skills/
├── specjedi-constitution/SKILL.md    # MODIFIED — audience-calibration note (FR-001)
├── specjedi-specify/SKILL.md         # MODIFIED — audience-calibration note (FR-002)
├── specjedi-find-skills/SKILL.md     # MODIFIED — audience-calibration note, scoped to verification-signal reasoning (FR-003)
├── specjedi-onboard/SKILL.md         # MODIFIED — chain-of-thought instruction at the directional-synthesis step (FR-004)
└── specjedi-quick/SKILL.md           # MODIFIED — chain-of-thought instruction in the eligibility-checklist step (FR-005)
```

**Structure Decision**: No new skill, no new directory. 5 existing skill
files each gain one small, targeted addition. FR-006 bounds this
explicitly — no other file changes.

## Complexity Tracking

*No Constitution Check violations — this section is intentionally empty.*
