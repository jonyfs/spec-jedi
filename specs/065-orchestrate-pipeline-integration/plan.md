# Implementation Plan: specjedi-orchestrate Pipeline Integration

**Branch**: `065-orchestrate-pipeline-integration` | **Date**: 2026-07-21 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/065-orchestrate-pipeline-integration/spec.md`

## Summary

Wire `specjedi-orchestrate` (feature 064) into the pipeline at two real
points — `specjedi-tasks`' closing next-step (offers orchestration when a
plan has genuine cross-story parallelism) and `specjedi-implement`'s
readiness check (detects a sibling `orchestration-plan.md` and, on
acceptance, dispatches task groups to their assigned roles via Claude
Code's real `Agent`/`Workflow` mechanisms, falling back to single-agent
per role when a mechanism can't be confirmed) — then use
`specjedi-orchestrate` for real against this project's own SDD pipeline
to produce a genuine `orchestration-plan.md` for future feature work.
This is a documentation/prompt-authoring change to two existing
`SKILL.md` files, plus one generated planning artifact — no new source
code, no new skill.

## Technical Context

**Language/Version**: N/A — edits to existing Markdown-authored
`SKILL.md` prompt files, matching every prior `specjedi-*` change.

**Primary Dependencies**: `specjedi-orchestrate` (feature 064, already
shipped) and its `references/multi-agent-capability-notes.md`; the host
harness's own `Agent`/`Workflow` tools (this session's Claude Code has
both, confirmed directly — `Agent` tool with `subagent_type`, `Workflow`
tool for deterministic multi-stage fan-out).

**Storage**: N/A. `orchestration-plan.md` is a Markdown file under
`specs/<feature>/`, same convention as every other pipeline artifact.

**Testing**: No automated test runner for `specjedi-*` skills (prompt
content). Validation is the Validation Coverage section update in both
edited `SKILL.md` files, plus a real dry-run of Story 3 against this
project itself (verifiable by reading the produced
`orchestration-plan.md`).

**Target Platform**: Claude Code only for the dispatch mechanism itself
(FR-003/FR-003a scope, per spec.md Assumptions) — the choice-surfacing
UX (FR-002) and next-step offer (FR-001) are harness-agnostic prompt
text, same as every other `specjedi-*` skill.

**Project Type**: Single project — edits within this existing repository.

**Performance Goals**: N/A.

**Constraints**: FR-003b — dispatched roles never bypass Principle X
(branch+PR) or Principle VI (test-first); FR-003a — a stale/unconfirmed
mechanism falls back to single-agent rather than failing the run.

**Scale/Scope**: Two edited `SKILL.md` files
(`specjedi-tasks`, `specjedi-implement`), one new generated artifact
(this project's own `orchestration-plan.md`), zero new skills, zero
schema/data changes.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II. Competitive Research Before Creation | Applies to new skills/artifacts, not edits to two existing skills reusing feature 064's own already-researched grounding | N/A — no new skill created, `references/multi-agent-capability-notes.md` (064) is the grounding source, not re-derived |
| III. Universal LLM & Harness Compatibility | FR-001/FR-002 (offer + choice-surfacing) must stay harness-agnostic; FR-003 dispatch is explicitly scoped to Claude Code | ✅ FR-001/FR-002 are plain next-step/prompt text, no harness assumption; FR-003's Claude Code scoping is an explicit, spec-stated limitation (Assumptions), not a silent one |
| V. Specification Completeness for Autonomous Execution | Plan must name exact insertion points, not "add somewhere in the file" | ✅ Exact line-anchored insertion points confirmed by grep against both live `SKILL.md` files (see Project Structure) |
| VI. Test-First Delivery | Dispatched task groups must still get test-before-implementation sequencing | ✅ FR-003b requires this explicitly; `specjedi-implement`'s existing Step 4 (test-first) is preserved unchanged, dispatch only changes *who* executes a task group, not the sequencing discipline within it |
| IX. Mandatory Skill Validation & Testing | Every skill edit needs its Validation Coverage section kept current | ✅ Both edited `SKILL.md` files get their Validation Coverage sections extended to cover the new branch (orchestration-plan.md present/absent, mechanism confirmed/stale) |
| X. Trunk-Based Git Workflow | Dispatched roles must never commit directly | ✅ FR-003b is a direct restatement of this gate scoped to team-mode dispatch |
| XIV. Guided Next-Step Suggestion | FR-001's new next-step bullet must follow the existing mechanism | ✅ Uses `references/next-step-interaction.md`, same as every existing next-step bullet in both files |
| XIX. Skill Authoring & Prompt Engineering Standard | Edited sections must stay concise, action-oriented, chain-of-thought for judgment calls | ✅ FR-001's "2+ stories" threshold and FR-003a's fallback are concrete, checkable rules, not vague guidance |
| XX. AI Discipline: Grounded, Honest Output | FR-003 dispatch must never invent a mechanism the capability notes don't confirm | ✅ FR-003a is exactly this guarantee, load-bearing in the plan's own Constraints |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/065-orchestrate-pipeline-integration/
├── plan.md              # This file
├── research.md          # Phase 0 — confirms Agent/Workflow tool
│                         #   availability + exact insertion points (already
│                         #   grep-confirmed above, formalized here)
└── tasks.md             # Phase 2 output (specjedi-tasks)
```

### Source Code (repository root)

```text
.claude/skills/specjedi-tasks/SKILL.md
  # Insert a new sub-step after Step 6 ("Write the Dependencies
  # section"), before Step 6.5 (hook dispatch) and Step 7 (report/next-
  # step): a parallelism check (2+ [P] tasks across 2+ user story
  # phases) that adds specjedi-orchestrate to Step 7's next-step list
  # when met (FR-001).

.claude/skills/specjedi-implement/SKILL.md
  # Extend Step 2 ("Confirm tasks.md is ready") to also check for a
  # sibling orchestration-plan.md; on presence, ask execution-mode
  # (FR-002). Add a new Step 2.5: on team-mode acceptance, dispatch each
  # task group via the plan's role mechanism (Agent tool subagent_type +
  # model, or Workflow tool for a multi-stage plan), falling back to
  # single-agent per role when references/multi-agent-capability-
  # notes.md doesn't confirm the mechanism (FR-003/FR-003a). Step 4's
  # existing test-first discipline and Step 5's branch re-verification
  # apply unchanged within each dispatched role's own execution
  # (FR-003b) — no new step needed for this, just an explicit note.

specs/065-orchestrate-pipeline-integration/orchestration-plan.md
  # NEW — Story 3's real deliverable: this project's own SDD-pipeline
  # orchestration plan, produced by actually running
  # specjedi-orchestrate's own Step-by-step against this repository's
  # constitution.md + this feature's own plan.md, on this session's
  # real Claude Code harness. Not a template — a genuine plan a future
  # session can execute against.
```

**Structure Decision**: Single project, additive-plus-two-edits. No new
skill, no new directory beyond the standard `specs/065-.../` set and the
one Story 3 artifact. Both edited files keep their existing shape;
insertions are anchored to specific, already-confirmed line ranges.

## Complexity Tracking

*No entries — Constitution Check found no violations requiring justification.*
