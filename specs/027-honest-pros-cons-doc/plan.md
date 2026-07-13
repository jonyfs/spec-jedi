# Implementation Plan: Honest Advantages/Disadvantages Assessment for Spec Jedi Skills

**Branch**: `027-honest-pros-cons-doc` | **Date**: 2026-07-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/027-honest-pros-cons-doc/spec.md`

## Summary

Write `references/honest-assessment.md`: a candid, three-section
document (Advantages / Disadvantages / Improvement Points) built
primarily on `references/competitive-comparison.md`'s existing 11-tool
research, re-read specifically for gaps rather than re-researched from
scratch. Phase 0 research already surfaced a genuinely important finding:
BMAD-METHOD's "Quick Flow" lightweight-path idea is recorded as
"Adopted" in the existing competitive research but was never actually
shipped as a skill — exactly the kind of aspirational-vs-shipped gap this
document's grounding requirement (FR-001) exists to catch, and now also
its leading Disadvantage/Improvement Point.

## Technical Context

**Language/Version**: Markdown — a new reference document, no code.

**Primary Dependencies**: `references/competitive-comparison.md` (primary
source), `references/principle-traceability.md` (✅/🟡 status
cross-checks for FR-003), `references/harness-capability-notes.md`
(honesty precedent for the harness-coverage disadvantage), git state
(`git tag -l` for the no-release disadvantage).

**Storage**: Writes one new file, `references/honest-assessment.md`;
edits `README.md` to add one link (FR-007).

**Testing**: Principle VI exemption — pure documentation, no
unit-testable logic. Verification is (a) `scripts/validate.sh`'s
existing Markdown checks, and (b) a manual cross-check of every
Advantages claim against a real file/CI job/traceability row (SC-001),
every Improvement Point against a named competitor citation (SC-003).

**Target Platform**: N/A — a Markdown reference document.

**Project Type**: Documentation (single project, no new subsystem).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I**: this document lives under `references/`, explicitly
  NOT `docs/` (FR-006) — avoids Principle I's ten-language localization
  mandate, which applies to top-level onboarding docs
  (README/CONTRIBUTING/installation guides), not a researched-analysis
  reference. Matches `competitive-comparison.md`'s own existing
  precedent exactly.
- **Principle II**: satisfied by reuse — `research.md` documents exactly
  which parts of the existing 11-tool research are reused vs. newly
  synthesized (Findings 1-3), not a fresh ten-competitor benchmark (not
  required for a documentation feature, not a new skill/pattern).
- **Principle XII (Star Wars voice)**: this document is explicitly a
  candid self-assessment, not marketing copy (FR-005) — Principle XII's
  voice guidance applies to end-user-facing skill *interaction* (chat
  responses, prompts); this is closer to the constitution's own
  documentation-content carve-out ("the literal content of generated
  spec.md/plan.md fields... MUST stay precise," applied here by analogy
  to a factual assessment document) — flavor doesn't belong in a document
  whose entire value proposition is unhedged honesty.
- **Principle XX (grounded, honest output)**: this document's entire
  purpose is applying Principle XX outward-facing — every claim in it
  must be as rigorously grounded as any other factual claim this project
  makes.
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

### Documentation (this feature)

```text
specs/027-honest-pros-cons-doc/
├── plan.md              # This file
├── research.md           # Phase 0 output — 3 findings, cited
├── spec.md               # Feature specification
└── tasks.md              # Phase 2 output (/speckit-tasks — not created here)
```

No `data-model.md`/`contracts/` — a documentation feature with no data
entities and no external interface.

### Source Code (repository root)

```text
references/
└── honest-assessment.md          # NEW: the three-section document
README.md                          # +1 link, mirroring the competitive-comparison.md pattern
specs/027-honest-pros-cons-doc/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

**Structure Decision**: single new reference file + one README link —
no new skill, no new subsystem, matches `competitive-comparison.md`'s own
precedent exactly (feature 014 shipped the same shape of change).

## Design: the document's three sections

- **Advantages** (FR-001): each entry is one claim + one citation to a
  specific shipped mechanism. Draft set (subject to final grounding
  check at write time): all-20-harness coverage with no equivalent among
  the 11 researched competitors; `specjedi-diagram`'s render-verification-
  before-presenting (feature 004's own still-true genuine-contribution
  claim); `specjedi-govcheck`'s automated 20-principle per-PR compliance
  check; `specjedi-status`'s zero-separately-maintained-tracking-system
  dashboard; the constitution's own real, versioned amendment history
  (now v1.24.0, real Sync Impact Reports back to v1.15.x); the CI-gated,
  cross-platform (3 OS × bash/pwsh) self-validating PR workflow.
- **Disadvantages** (FR-002/FR-003): at least 5, each real and checkable.
  Draft set: (1) BMAD's "Quick Flow" lightweight path recorded as
  adopted but never shipped (research.md Finding 1) — no fast path exists
  for small changes today; (2) no `v0.1.0`/any release cut yet; (3) the
  14 bridge-mode harnesses' underlying conventions are desk-research-
  grounded, not hands-on-verified inside the actual third-party product
  (stated with the same honesty `harness-capability-notes.md` already
  uses, not overstated as "fully tested"); (4) single-maintainer scale
  vs. funded/corporate-backed competitors; (5) Spec Kitty-style
  worktree-awareness stayed a documented option, never became a
  mechanized, tested feature.
- **Improvement Points** (FR-004): the competitor-grounded subset of
  Disadvantages, each re-stated with its specific named competitor and
  capability gap (research.md Finding 2): a lightweight/quick-path skill
  (BMAD's Quick Flow, OpenSpec's 3-command model — two competitors
  independently validate this gap is worth closing); a cross-project
  pattern registry (Tessl); a zero-setup/IDE-native experience (Kiro);
  mechanizing worktree-awareness into a real, tested feature (Spec
  Kitty).
- **Last-reviewed marker** (FR-008): a single line at the top of the
  document, `Last reviewed: 2026-07-13 (commit <short-sha>)`, mirroring
  the `i18n-sync` marker convention's spirit (a visible, checkable
  staleness signal) without inventing new tooling for a single document.
- **README link** (FR-007): one line near the existing
  `competitive-comparison.md` link, in the same "Curious how Spec Jedi
  stacks up" paragraph area.
