# Research: `specjedi-quick` (feature 028)

**Goal**: close `references/honest-assessment.md`'s top improvement point —
a lightweight path for small, well-understood changes, validated
independently by two researched competitors, never built despite
`references/competitive-comparison.md` recording it as "Adopted" from
BMAD-METHOD back in feature 001.

## Principle II: competitive research before creation (NON-NEGOTIABLE)

This is a new skill and a new structural pattern (a second, shorter
pipeline alongside the existing full one), so Principle II's benchmarking
gate applies in full — not the lighter bar used for revisions to
already-shipped skills.

### BMAD-METHOD's Quick Flow (2026-07-13 research)

Quick Flow is BMAD Method's "lean path... that skips the full planning
ceremony (PRD → Architecture → Epics → Sprint Planning) and gets you from
idea to shipped code in as few steps as possible." A single agent role
(the "Solo Dev") runs three steps: **Quick Spec** (a simplified tech-spec
or story — one artifact, not four), **Quick Dev** (implements the work),
**Code Review** (approves the result). Critically: *"Quick Flow doesn't
skip quality gates — tests, build, and type-check are still required."*
The eligibility heuristic given directly in BMAD's own docs: *"If the
change fits on one page of notes, Quick Flow is the right tool."*
([BMAD Quick Flow — DEV Community](https://dev.to/jacktt/bmad-quick-flow-15en),
[BMAD Method Workflow Map](https://docs.bmad-method.org/reference/workflow-map/))

### OpenSpec's three-command model (2026-07-13 research)

OpenSpec is "brownfield-first," "delta-based," philosophy stated as
*"fluid not rigid, iterative not waterfall, easy not complex."* Its
entire workflow is three commands: `/opsx:propose` (generates a full
change proposal), `/opsx:apply` (executes the tasks), `/opsx:archive`
(files the completed change away, date-prefixed) — propose → apply →
archive. ([OpenSpec docs/concepts.md](https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md),
[OpenSpec vs Spec Kit — codemyspec.com](https://codemyspec.com/blog/openspec-vs-spec-kit))

### What Spec Jedi adopts

- **One combined artifact, not four** (from BMAD's "Quick Spec"): replaces
  `spec.md` + `research.md` + `plan.md` + `tasks.md` with a single
  `quick.md` for eligible work — the genuine ceremony reduction both
  competitors independently validate.
- **A concrete, quotable eligibility bar** (from BMAD directly): "fits on
  one page of notes" is adapted into `specjedi-quick`'s own checkable
  eligibility checklist (spec.md FR-001) rather than a vague "small
  enough" judgment call — Principle XIX forbids the latter.
- **Quality gates never skip, even on the fast path** (from BMAD
  directly): test-first where the plan calls for code (Principle VI),
  `specjedi-govcheck` before opening a PR, and CI validation all still
  apply — "quick" shortens planning ceremony, never verification.
- **An explicit archive/complete signal** (from OpenSpec's `archive`
  step): `quick.md` carries a `Status: Proposed → Implemented` line so a
  quick change's completion is as visible on disk as a full-pipeline
  feature's `tasks.md` checkbox state — closes the `specjedi-status`
  compatibility gap this feature also has to solve (Design section,
  plan.md).

### What Spec Jedi rejects

- **A separate "Solo Dev" persona/role system** (BMAD) — this project
  already has one skill-per-concern model (Principle II's own prior
  rejection of BMAD's 12+-persona orchestration, `competitive-
  comparison.md` row 27); `specjedi-quick` is one more skill in that same
  model, not a new persona-switching mechanism.
- **A dedicated `archive` command/step** (OpenSpec) — `specs/NNN-name/`
  already is Spec Jedi's permanent, append-only history (every prior
  feature's directory stays in the repo forever); a separate archival
  step/directory would duplicate what git history and the existing
  `specs/` convention already provide, the same "avoid internal
  redundancy" reasoning `references/principle-traceability.md` already
  applies elsewhere (Principle XXI's own "no parallel status system"
  clause is the precedent for this exact judgment call).

### Genuine contribution (Principle II's "what does Spec Jedi add" requirement)

Neither BMAD's Quick Flow nor OpenSpec's three-command model runs inside
a project that *also* maintains a rigorous, versioned constitution
governing every artifact — `specjedi-quick` is the first researched
lightweight-path mechanism required to still satisfy a live, enforced
constitution (Principle II research citation, Principle VI test-first
default, Principle IX validation battery, Principle X trunk-based PR
workflow) on its fast path, not just on the full one. No competitor's
lightweight mode was found to be constitution-gated in this way.

## Design decision: `quick.md` structure

One file, four sections (mirrors BMAD's single "Quick Spec" artifact,
scaled to what Spec Jedi's own constitution requires a spec-adjacent
artifact to carry):
1. **What & why** (one paragraph) — the "fits on one page" test applies
   to the whole file, not just this section.
2. **Concrete changes** (a short bullet list of files/behavior touched) —
   replaces `plan.md`'s Design section at quick-path scale.
3. **Acceptance checks** (a short checklist, each traceable to a bullet
   above) — replaces `tasks.md` at quick-path scale.
4. **Status**: `Proposed` → `Implemented` (OpenSpec's archive-equivalent
   signal, read by the `specjedi-status` compatibility update).

## Cross-skill compatibility: `specjedi-status`

`specjedi-status/SKILL.md`'s current detection logic (step 3) only
recognizes `spec.md`/`plan.md`/`tasks.md` presence and `tasks.md`'s own
checkbox percentage — a `quick.md`-only feature directory would report as
having zero artifacts, a real, false "not started" reading for a feature
that may already be fully implemented. This feature's plan.md includes a
small, targeted addition to `specjedi-status`'s existing step 3 (not a
new mechanism) to also recognize `quick.md` and its `Status:` line and
Acceptance Checks checkbox count, reported the same way `tasks.md`'s
percentage already is.
