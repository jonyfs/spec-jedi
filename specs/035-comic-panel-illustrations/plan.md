# Implementation Plan: Original Illustrations for the Internal-Bootstrap Comic

**Branch**: `035-comic-panel-illustrations` | **Date**: 2026-07-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/035-comic-panel-illustrations/spec.md`

## Summary

Adds one original illustration per existing comic panel (8 total) to
README.md's "How Spec Jedi builds itself, in comic form" section, via
Pollinations.ai's free, no-account image API (verified reachable and
watermark-free this session via two real test requests). Every prompt
shares one style-descriptor clause for visual consistency (FR-002) and
is constructed to never name or depict Star Wars' specific recognizable
signatures (FR-003) — enforced by careful original word choice at
prompt-construction time plus a mandatory visual review after
generation, bounded to 2 regeneration attempts per panel before an
honest text-only fallback (Clarifications, Session 2026-07-13). One
sample is generated and approved before the remaining 7 proceed (US2).
Images are generated once, at implementation time, and committed as
static files — no runtime dependency on the external service for
anyone reading the shipped README. Constitution Principle XII gains a
new guardrail reflecting that generated artwork now exists in this
project, with rules for what it must never depict.

## Technical Context

**Language/Version**: N/A — Markdown documentation edit (`README.md`)
plus static JPEG image assets; no application code.

**Primary Dependencies**: Pollinations.ai's public image-generation
endpoint (`https://image.pollinations.ai/prompt/{prompt}`), reachable
over plain HTTPS with no SDK, account, or API key — confirmed this
session via two real requests (research.md).

**Storage**: 8 static JPEG files under `docs/comic/` (~50 KB each,
observed from the verified test image), committed to the repository
like any other tracked asset.

**Testing**: Principle VI exemption — this feature's deliverable is
static image assets plus a `README.md` prose edit, not application code
with a meaningful red/green cycle. Verification takes the form of a
mandatory visual review per image against FR-003's exclusion list
(battery item analogous to a manual acceptance check, the same class of
discipline `specjedi-diagram`'s render-verification already applies to
generated Mermaid output) plus `quickstart.md`'s scenarios confirming
the README actually renders the images on GitHub.

**Target Platform**: Static Markdown rendering on GitHub (and any other
Markdown viewer) — no runtime/browser-side dependency introduced; the
external image-generation service is only ever called during
implementation, never by a reader's own request.

**Project Type**: Single project — documentation/asset addition, no new
source directories beyond one new `docs/comic/` asset folder.

**Performance Goals**: N/A (static assets, generated once).

**Constraints**: FR-003's Star-Wars-signature exclusion is
non-negotiable and reviewed twice (prompt construction, then the
rendered image) — no image ships without passing that review. FR-004's
sample-approval gate MUST complete before the remaining 7 are
generated. The bounded 2-regeneration-attempt limit (Clarifications)
applies per panel, with an explicit text-only fallback if still failing
after that.

**Scale/Scope**: 8 panel illustrations (up to 24 total generation calls
in the worst case: 8 × [original + 2 regenerations]), plus 1 style-
sample generation, plus a `README.md` prose/markup edit and a
Constitution Principle XII amendment.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I**: N/A directly for the images themselves (no embedded
  text, per FR-005/Assumptions — language-agnostic). The English
  `README.md`'s own surrounding prose is unchanged in meaning; no
  localized-doc translation is triggered by this feature.
- **Principle II**: Not triggered fresh — this revises an already-
  shipped README section (feature 029), not a new skill/workflow/
  structural pattern. Same exemption class as features 025/026.
- **Principle III/XV/XVII/XVIII/XIX/XXI**: N/A — no skill authored or
  modified, no installer touched.
- **Principle IV**: FR-004's sample-approval gate is exactly this
  principle's elicitation discipline applied to a genuinely consequential,
  hard-to-reverse-in-spirit decision (a visual identity, once 8 images
  exist around it) — checked before committing, not after.
- **Principle V**: Satisfied — `spec.md` carries zero open
  `[NEEDS CLARIFICATION]` markers after `/speckit-clarify` (the one
  raised question was resolved via the stated Recommended default,
  applied when the session moved directly to `/speckit-plan`, and is
  recorded as such in the Clarifications trail rather than silently
  assumed).
- **Principle VI**: Exemption stated above in Technical Context.
- **Principle IX**: Satisfied via the mandatory two-stage FR-003 review
  (prompt-construction check + post-generation visual check) as this
  feature's actual validation battery item, plus `quickstart.md`'s
  real-render confirmation — no new CI job invented for a one-time
  static-asset addition.
- **Principle X**: Standard feature-branch → PR → `ci-gate` → auto-merge
  flow.
- **Principle XII**: This is the principle FR-008 directly amends —
  see the Sync Impact Report this feature's constitution PATCH/MINOR
  bump will carry. The amendment adds a guardrail (original visual
  identity required, Star-Wars-signature list named explicitly) rather
  than removing or weakening the existing non-affiliation/no-
  copyrighted-art commitment, which stays fully intact.
- **Principle XIII**: N/A — no script added; the one external call
  (image generation) happens during implementation from whatever OS the
  implementer is using, not as a per-reader runtime dependency needing
  cross-platform script parity.
- **Principle XIV**: N/A to this content itself (not a skill
  interaction flow).
- **Principle XVI**: N/A — this is illustrative art, not a diagram
  encoding a process; Principle XVI's diagram-format-choice guidance
  doesn't govern narrative illustration.
- **Principle XX**: Directly modeled throughout this plan and
  `research.md` — every technical claim (watermark behavior, available
  parameters, no negative-prompt field) is grounded in a real fetched
  doc or a real executed test request this session, never assumed from
  training-data memory of how such APIs "usually" work.
- **Distribution & Ecosystem Standards**: README's badge row reviewed
  per the standing pre-PR requirement (this feature doesn't change
  skill count, roadmap status, or any badge-bearing fact — expected
  outcome is "nothing to update," confirmed rather than assumed).
- **Development Workflow**: This exact pipeline (specify → clarify →
  plan → tasks → implement → validation → PR) is being followed live.

No violations requiring justification. Complexity Tracking table is
empty by design.

## Project Structure

### Documentation (this feature)

```text
specs/035-comic-panel-illustrations/
├── plan.md              # This file
├── research.md          # Phase 0 output — Pollinations.ai verification, prompt design, consistency strategy
├── quickstart.md         # Phase 1 output — render/review validation scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not created by /speckit-plan)
```

`data-model.md` and `contracts/` are intentionally omitted: no data
entities (spec.md's Key Entities section is explicitly not applicable)
and no external interface this project itself exposes — the one
external call is outbound, to a third-party service, during
implementation only.

### Source Code (repository root)

```text
docs/comic/                 # NEW directory
├── panel-1.jpg             # NEW — one file per panel, only for panels that pass FR-003 review
├── panel-2.jpg
├── ...
└── panel-8.jpg

README.md                   # MODIFIED — one image embed per panel, immediately below its existing text
.specify/memory/constitution.md  # MODIFIED — Principle XII amendment (FR-008)
```

A prompt record satisfying FR-007 lives in `research.md` itself (the
per-panel prompt list already documented there) — no separate file
invented for a requirement `research.md` already satisfies durably.

**Structure Decision**: One new asset directory (`docs/comic/`,
mirroring the existing `docs/i18n/` convention for auxiliary docs
content), one `README.md` edit, and one constitution amendment. No new
scripts, no new skills, no source code.

## Complexity Tracking

*No Constitution Check violations — this section is intentionally empty.*
