# Implementation Plan: README as a Wise Jedi's Letter

**Branch**: `036-readme-jedi-letter` | **Date**: 2026-07-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/036-readme-jedi-letter/spec.md`

## Summary

Reframe `README.md`'s narrative sections (the opening pitch, "Who this is
for," "What you get today"'s intro, and the Quickstart's connective
prose) as an actual letter — an addressed opening, a body making the
case for disciplined SDD practice as "the right side of the Force," and
a closing send-off — while every fact, badge, link, table, code block,
and the 5 existing Mermaid diagrams stay exactly as they are today
(Clarifications, spec.md). 2-3 new images mark real letter milestones,
generated via the same Pollinations.ai mechanism feature 035 already
verified, subject to the same Constitution Principle XII art guardrail
and review discipline that shipped 8/8 clean comic panels on the first
attempt.

## Technical Context

**Language/Version**: N/A — `README.md` prose plus new static JPEG
image assets; no code, no new script files.

**Primary Dependencies**: Pollinations.ai (`https://image.pollinations.ai`),
the same keyless HTTP image-generation mechanism verified working in
feature 035 — no new tool, no new research needed on the mechanism
itself.

**Storage**: N/A (static image files under `docs/`, same convention as
`docs/comic/panel-*.jpg`).

**Testing**: Principle VI exemption — documentation/content feature, not
application code with a meaningful red/green cycle (same exemption
class as features 029/035/README-informal-voice). Verification takes
the form of `quickstart.md`'s scenarios: a fact-preservation check
(badges/tables/code blocks byte-identical, same method used in the
just-merged README-informal-voice PR), a Mermaid-diagram-unchanged
check, and the Star-Wars-signature exclusion review each new image
must pass before being presented.

**Target Platform**: N/A.

**Project Type**: Single project — a documentation-content revision plus
2-3 new static image assets.

**Performance Goals**: N/A.

**Constraints**: FR-002/FR-004/FR-005 — zero loss of factual content,
zero change to the 5 existing Mermaid diagrams, letter-voice framing
scoped to narrative sections only (reference sections keep today's
voice). FR-003 — every new image must pass the Star-Wars-signature
exclusion review, no exception.

**Scale/Scope**: `README.md`'s narrative prose (opening, "Who this is
for," "What you get today" intro, Quickstart intro/closing) rewritten
as letter framing; 2-3 new images under `docs/comic/` (or a new
`docs/letter/` directory — decided in research.md); zero other files
touched except `CHANGELOG.md`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I**: N/A — English-source only, i18n untouched (same
  drift-flagging mechanism as every prior README edit this session).
- **Principle II**: N/A — this is a documentation/creative-content
  feature, not a new capability requiring competitive-tool benchmarking;
  the image-generation *mechanism* itself was already researched and
  verified in feature 035, reused here rather than re-researched.
- **Principle III**: N/A.
- **Principle IV**: N/A — no new user-facing elicitation moment (the
  3 real ambiguities were already resolved during `/speckit-specify`).
- **Principle V**: Satisfied — `spec.md` carries zero open
  `NEEDS CLARIFICATION` markers after the 3-question resolution.
- **Principle VI**: Exemption stated above.
- **Principle VII**: N/A.
- **Principle VIII**: N/A.
- **Principle IX**: N/A — no `SKILL.md`/CI-relevant file touched;
  `scripts/validate.sh`'s structural lint is unaffected by a README/
  image-only change.
- **Principle X**: Standard feature-branch → PR → `ci-gate` →
  auto-merge flow.
- **Principle XI**: N/A.
- **Principle XII**: Directly governs this feature's entire artwork
  scope — every new image MUST maintain an original visual identity and
  MUST NOT evoke Star Wars' specific recognizable visual signatures
  (the exact guardrail added this session after an identical prior
  request, feature 035). This plan's whole image-generation step is
  built around satisfying this gate, not around it.
- **Principle XIII**: Satisfied by construction — no new `.sh`/`.ps1`
  files.
- **Principle XIV**: N/A — no new skill invocation flow.
- **Principle XV**: N/A.
- **Principle XVI**: Directly relevant — per spec.md's Clarifications,
  the 5 existing Mermaid diagrams stay exactly as they are; this
  principle's "diagram is a supplement, never a replacement" reasoning
  is exactly why FR-004 resolved the way it did (an illustrative image
  cannot faithfully replace a diagram's precise branching logic without
  losing information).
- **Principle XVII**: N/A.
- **Principle XVIII**: N/A.
- **Principle XIX**: N/A — README.md is not a `SKILL.md`.
- **Principle XX**: Directly modeled — every new image's compliance
  with Principle XII is verified by actual visual review after
  generation, never assumed; every letter-voice prose claim stays
  grounded in facts already present in the README (no new capability
  claims introduced).
- **Principle XXI**: N/A.
- **Distribution & Ecosystem Standards**: The README's required content
  order and presence (badges → what/who → prerequisites → installation
  → quickstart → versioning pointer) is preserved unchanged per FR-005 —
  this feature changes voice in narrative sections only, never
  structure or required content.
- **Development Workflow**: This exact pipeline (research → specify →
  clarify [inline] → plan → tasks → implement → validation → PR) is
  being followed live for this feature.

No violations requiring justification. Complexity Tracking table is
empty by design.

## Project Structure

### Documentation (this feature)

```text
specs/036-readme-jedi-letter/
├── plan.md              # This file
├── research.md          # Phase 0 output — image placement, directory convention, prompt strategy
├── quickstart.md         # Phase 1 output — fact-preservation + diagram-unchanged + image-review validation scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not created by /speckit-plan)
```

`data-model.md` and `contracts/` are intentionally omitted — no data
entities, no external interface.

### Source Code (repository root)

```text
README.md                        # MODIFIED — narrative-section prose reframed as a letter
docs/comic/letter-1.jpg           # NEW — first letter-milestone image (exact count/names finalized in research.md)
docs/comic/letter-2.jpg           # NEW
docs/comic/letter-3.jpg           # NEW (if research.md's prompt pass warrants a 3rd; FR-008 caps at 2-3)
CHANGELOG.md                      # MODIFIED — new entry
```

**Structure Decision**: No new skill, no new top-level directory for
images (reuses the existing `docs/comic/` convention feature 035
established, since these images are thematically continuous with that
section rather than a new visual context). `README.md`'s section order
is unchanged; only narrative-section prose is rewritten.

## Complexity Tracking

*No Constitution Check violations — this section is intentionally empty.*
