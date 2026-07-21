# Implementation Plan: Agent Mapping for All specjedi-* Skills

**Branch**: `066-agent-mapping-all-skills` | **Date**: 2026-07-21 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/066-agent-mapping-all-skills/spec.md`

## Summary

Extend `specs/065-orchestrate-pipeline-integration/orchestration-plan.md`
with a complete agent disposition for all 32 installed `specjedi-*`
skills (not just the 7-stage pipeline core it already covers): mapped to
one of the 6 existing `orchestrate-*` agents, mapped to a newly-defined
agent for a genuine 2+-skill behavioral cluster, or explicitly
"no dedicated agent." Also closes the Principle XXIII wiring gap flagged
during feature 065's own `specjedi-govcheck` run (folded into this
feature per explicit user confirmation): `specjedi-implement` and
`specjedi-orchestrate` gain a formal Step-by-step item self-invoking
`specjedi-docs`'s drafting step, rather than relying on manual checking.

## Technical Context

**Language/Version**: N/A — Markdown-authored skill/agent edits and one
extended planning artifact, same as features 064/065.

**Primary Dependencies**: The 6 already-shipped `.claude/agents/
orchestrate-*.md` files (feature 065); `references/skill-authoring-
standard.md` for any new agent's frontmatter shape; every installed
`.claude/skills/specjedi-*/SKILL.md` (read for behavior classification,
not modified except `specjedi-implement`/`specjedi-orchestrate` for the
XXIII wiring).

**Storage**: N/A. Mapping lives in
`specs/065-orchestrate-pipeline-integration/orchestration-plan.md`
(extended in place) plus any new `.claude/agents/orchestrate-*.md` file.

**Testing**: No automated runner (prompt content). Validation: SC-001's
32/32 row count is directly checkable; SC-002's 2+-skill-per-new-agent
rule is checkable by reading each new agent file's own reasoning.

**Target Platform**: Claude Code (same scope boundary feature 065
established for its own dispatch mechanism — this mapping's agent
assignments are Claude Code `orchestrate-*` agents specifically, not a
cross-harness mapping).

**Project Type**: Single project, additive/extending edits only.

**Performance Goals**: N/A.

**Constraints**: FR-003/FR-004/FR-006 — new agents only for genuine 2+
skill clusters, real frontmatter fields only, propose-then-confirm before
any new agent file is written (same Step 9 discipline as feature 064).

**Scale/Scope**: One extended planning artifact (32-row table), an
estimated 2-4 new agent definitions (exact count depends on Story 1's
own clustering reasoning — not predetermined here), two skill edits for
the XXIII wiring gap.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II. Competitive Research Before Creation | Applies to genuinely new agent creation (Story 2) | ✅ Story 2's own FR-003 requires a real 2+-skill cluster before any new agent — internal-redundancy discipline against the 6 already-shipped agents is built into the requirement itself, not a separate research phase (this is an extension of feature 065's own agent set, not a new skill) |
| III. Universal LLM & Harness Compatibility | Mapping is explicitly Claude-Code-scoped (plan.md Target Platform) | ✅ Stated explicitly as an Assumption, matching feature 065's own identical scoping — never presented as if it applied to every harness |
| V. Specification Completeness for Autonomous Execution | Plan must name exact files/locations, not "figure it out" | ✅ Exact target artifact (`orchestration-plan.md`) and exact classification dimensions (read/write, judgment/mechanical, scope) named below |
| IX. Mandatory Skill Validation & Testing | Any new agent + any edited skill needs current Validation Coverage | ✅ Planned: `specjedi-implement`/`specjedi-orchestrate`'s Validation Coverage sections get the XXIII wiring's own Out-of-Bounds/External-Call notes updated |
| XIX. Skill Authoring & Prompt Engineering Standard | New agent frontmatter must match real fields | ✅ FR-004 — same 5-field set (`name`/`description`/`tools`/`model`/`color`) feature 065 already verified against every installed agent |
| XX. AI Discipline: Grounded, Honest Output | Every mapping row's reasoning must trace to real skill behavior | ✅ FR-002 is exactly this guarantee |
| XXIII. Post-Implementation Documentation Freshness Check | This feature closes its own wiring gap, so must actually wire it, not just describe it | ✅ Project Structure below names the exact Step insertion in both edited SKILL.md files |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/066-agent-mapping-all-skills/
├── plan.md              # This file
└── tasks.md             # Phase 2 output (specjedi-tasks)
```

No `research.md` — this is a classification/extension task grounded in
already-shipped project content (feature 065's 6 agents, every existing
skill's own SKILL.md), not new competitive research.

### Source Code (repository root)

```text
specs/065-orchestrate-pipeline-integration/orchestration-plan.md
  # EXTENDED — a new "## Skill-to-Agent Mapping" section: one row per
  # of the 32 installed specjedi-* skills, disposition + one-line
  # reasoning. The existing "## Roles" section (7-stage pipeline) and
  # "## Pipeline shape" section stay unchanged.

.claude/agents/orchestrate-<new-cluster-name>.md
  # NEW, 0-N files — only for a genuine 2+-skill cluster the existing 6
  # roles don't fit (Story 2); count and names determined by Story 1's
  # own classification pass, not predetermined here.

.claude/skills/specjedi-implement/SKILL.md
  # EXTENDED — Step 7's PR-opening flow gains a formal self-invocation
  # of specjedi-docs's drafting step (Constitution Principle XXIII),
  # alongside the existing Step 6.5/6.6 govcheck/analyze self-invocations
  # — same pattern, same non-blocking posture.

.claude/skills/specjedi-orchestrate/SKILL.md
  # EXTENDED — Step 9's artifact-drafting step gains the same XXIII
  # self-invocation when it writes a new agent file, matching
  # specjedi-implement's own treatment for consistency.
```

**Structure Decision**: Single project, additive/extending edits to
already-shipped feature 065 artifacts plus the two skills XXIII flagged.
No new skill, no new spec-jedi pipeline stage.

## Complexity Tracking

*No entries — Constitution Check found no violations requiring justification.*
