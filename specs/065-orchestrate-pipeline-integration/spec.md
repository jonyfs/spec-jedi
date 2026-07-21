# Feature Specification: specjedi-orchestrate Pipeline Integration

**Feature Branch**: `065-orchestrate-pipeline-integration`

**Created**: 2026-07-21

**Status**: Draft

**Input**: User description: "veja como /specjedi-orchestrate deve estar
integradas as outras skills de sdd do specjedi para saber organizar a
orquestração para que o resultado seja mais eficiente usando diferentes
agentes neste projeto, crie orquestração e agentes para este projeto
usando a nova skills mencionada de orquestração"

## Clarifications

### Session 2026-07-21

- Q: FR-003: should this feature implement real team-mode dispatch, or just surface the choice? → A: Implement full dispatch now — `specjedi-implement` also calls the real per-role mechanism (Claude Code's `Agent`/`Workflow` tool) per the plan's role mapping, not just a choice prompt.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - specjedi-tasks points to specjedi-orchestrate when a plan is team-shaped (Priority: P1)

A user finishes `specjedi-tasks` for a feature whose `tasks.md` has
several genuinely independent `[P]`-marked tasks across multiple user
stories. Today, `specjedi-tasks`' closing next-step only offers
`specjedi-implement` (single-agent) or `specjedi-analyze`. The user has
no signal that this feature's own shape — multiple independent tasks —
is exactly what `specjedi-orchestrate` exists to plan for.

**Why this priority**: Without this, `specjedi-orchestrate` is an
undiscoverable island — a user has to already know it exists and
remember to invoke it manually. P1 because it's the only story that
makes the other two reachable through the pipeline's own normal flow
rather than tribal knowledge.

**Independent Test**: Given a `tasks.md` with 3+ `[P]`-marked tasks
spanning 2+ user stories, running `specjedi-tasks` ends with
`specjedi-orchestrate` offered as a next-step option alongside
`specjedi-implement`. Given a `tasks.md` with no meaningful parallelism
(a small, mostly-sequential feature), `specjedi-orchestrate` is not
offered — verifiable by reading the closing next-step list in both cases.

**Acceptance Scenarios**:

1. **Given** a `tasks.md` with `[P]` tasks in 2+ user story phases,
   **When** `specjedi-tasks` finishes, **Then** its next-step list
   includes `specjedi-orchestrate` with a one-line reason ("this plan has
   genuinely parallel work across stories").
2. **Given** a `tasks.md` with a single user story and no `[P]` tasks,
   **When** `specjedi-tasks` finishes, **Then** `specjedi-orchestrate` is
   not offered — offering it here would be noise, not a real option.

---

### User Story 2 - specjedi-implement recognizes an existing orchestration-plan.md (Priority: P2)

A user has already run `specjedi-orchestrate` for a feature and has an
approved `orchestration-plan.md` sitting in that feature's `specs/`
directory. Today, `specjedi-implement` has no awareness of that file — it
always executes `tasks.md` itself, single-agent, ignoring any team plan
that already exists.

**Why this priority**: Real value, but only reachable once Story 1 makes
`specjedi-orchestrate` discoverable in the first place — a user who never
finds the skill never produces a plan for this story to react to. P2.

**Independent Test**: Given a feature directory containing both
`tasks.md` and an `orchestration-plan.md`, invoking `specjedi-implement`
notices the plan, asks whether to follow it, and — on acceptance —
dispatches each `tasks.md` task group to the plan's assigned role via
that role's real Claude Code mechanism (`Agent` tool `subagent_type`, or
`Workflow` tool for a multi-stage pipeline), each running at its assigned
model tier; declining proceeds with today's default single-agent
execution. Never silently picks a mode.

**Acceptance Scenarios**:

1. **Given** an `orchestration-plan.md` exists alongside `tasks.md`,
   **When** `specjedi-implement` starts, **Then** it surfaces the plan's
   existence and asks which execution mode to use, rather than ignoring
   it.
2. **Given** the user accepts team-mode, **When** `specjedi-implement`
   executes a task group assigned to a given role, **Then** it dispatches
   that group via the role's named mechanism and model tier from the
   plan — e.g. an `Agent` tool call with the plan's `subagent_type` and
   model, not a generic single-agent pass.
3. **Given** the user accepts team-mode but a role's plan entry names a
   mechanism `references/multi-agent-capability-notes.md` doesn't confirm
   for the current harness (a stale or hand-edited plan), **When**
   dispatch reaches that role, **Then** `specjedi-implement` falls back to
   executing that role's tasks itself (single-agent) and says so, rather
   than failing the whole run or inventing a call.
4. **Given** no `orchestration-plan.md` exists, **When**
   `specjedi-implement` starts, **Then** behavior is unchanged from
   today — single-agent execution, no new prompt.

---

### User Story 3 - Produce a real orchestration plan for this project's own SDD pipeline work (Priority: P1)

The maintainer wants `specjedi-orchestrate` run for real, against this
repository's own ongoing feature-development work (not a hypothetical
example) — a concrete `orchestration-plan.md` naming which specjedi
pipeline stages map to which agent roles and model tiers on this
project's own harness (Claude Code), usable for the project's next
several features.

**Why this priority**: This is the second half of what was actually
asked — not just designing the integration, but using
`specjedi-orchestrate` to produce a real, usable artifact for this
project today. P1 alongside Story 1: both are required for this feature
to be "done" in the sense the request actually means.

**Independent Test**: Running `specjedi-orchestrate` against this
project's own SDD pipeline (spec → clarify → plan → tasks → implement →
govcheck/analyze → retro) produces a written orchestration plan naming a
role per pipeline stage, each with Claude Code's real mechanism
(`Agent`/`Workflow` tool) and a justified model tier, grounded in this
project's own `constitution.md` (PR-only commit discipline) and actual
skill set — not a generic example.

**Acceptance Scenarios**:

1. **Given** this project's own constitution and installed `specjedi-*`
   skill set, **When** `specjedi-orchestrate` runs against it, **Then**
   the resulting plan names real roles (e.g. a planning role covering
   spec/clarify/plan, an implementation role, a governance-check role)
   each mapped to Claude Code's actual `Agent`/`Workflow` mechanism.
2. **Given** this project's constitution requires PR-only commits
   (Principle X), **When** the plan proposes any code-writing role,
   **Then** that role's mechanism respects branch+PR discipline — no
   role proposed to commit directly to `main`.

---

### Edge Cases

- What happens when `specjedi-tasks`' parallelism check (Story 1) is
  itself ambiguous — e.g. `[P]` tasks exist but only within a single
  user story, not across stories? Treat "across 2+ stories" as the bar
  for offering `specjedi-orchestrate`; within-story parallelism alone
  isn't enough to justify a multi-agent team plan over just running the
  tasks in whatever order.
- What happens when a user declines Story 2's prompt and an
  `orchestration-plan.md` is stale (written against an older `tasks.md`)?
  `specjedi-implement` proceeds with default single-agent execution for
  that run — it does not attempt to reconcile or update the stale plan
  itself; that remains `specjedi-orchestrate`'s job on a fresh invocation.
- What happens when `specjedi-orchestrate` (Story 3) is run against this
  project but a stage has no clean single-role mapping (e.g. governance
  checks span both `specjedi-govcheck` and `specjedi-analyze`)? The plan
  may group both under one role if their harness mechanism and model
  tier genuinely match — never force them into two roles just to keep a
  one-stage-one-role appearance.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-tasks`' closing next-step step MUST offer
  `specjedi-orchestrate` when the generated `tasks.md` has `[P]`-marked
  tasks spanning 2 or more user story phases, with a one-line reason;
  MUST NOT offer it otherwise (spec.md Acceptance Scenarios 1-2).
- **FR-002**: `specjedi-implement`'s Step 2 ("Confirm `tasks.md` is
  ready") MUST also check for a sibling `orchestration-plan.md` in the
  same feature directory; if found, MUST surface its existence and ask
  which execution mode to use before proceeding, never silently ignoring
  it and never silently switching to team-mode without asking.
- **FR-003**: When a user selects team-mode execution (FR-002),
  `specjedi-implement` MUST dispatch each `tasks.md` task group to its
  `orchestration-plan.md`-assigned role via that role's real Claude Code
  mechanism (`Agent` tool with the plan's `subagent_type` and model tier,
  or `Workflow` tool for a plan describing a multi-stage pipeline) —
  never a generic single-agent pass once team-mode is accepted (spec.md
  Story 2 Acceptance Scenario 2).
- **FR-003a**: If a role's mechanism can't be confirmed against
  `references/multi-agent-capability-notes.md` for the current harness at
  dispatch time (a stale/hand-edited plan), `specjedi-implement` MUST
  fall back to single-agent execution for that role's tasks only, stating
  why, rather than failing the run or fabricating a call (Story 2
  Acceptance Scenario 3).
- **FR-003b**: Branch/PR/test-first discipline (Principle X/VI) applies
  identically under team-mode dispatch — a dispatched role never commits
  directly, and test-before-implementation sequencing within a task group
  is preserved regardless of which agent executes it.
- **FR-004**: This feature MUST produce a real, written
  `orchestration-plan.md` for this project's own SDD pipeline (Story 3),
  using `specjedi-orchestrate` itself — not a hypothetical example in
  documentation.
- **FR-005**: The Story 3 plan MUST name Claude Code's real mechanism
  (`Agent` tool + `subagent_type`, or `Workflow` tool) per role, grounded
  in `references/multi-agent-capability-notes.md`'s own Claude Code row —
  never inventing a mechanism that file doesn't confirm.
- **FR-006**: The Story 3 plan MUST respect this project's own
  `constitution.md` Principle X (trunk-protected, PR-only commits) for
  any role capable of writing code — no role proposed to bypass that
  discipline.

### Key Entities

- **Orchestration-aware next-step**: the specific next-step bullet
  `specjedi-tasks` adds when Story 1's parallelism threshold is met.
- **Execution-mode choice**: the prompt `specjedi-implement` surfaces
  when an `orchestration-plan.md` exists alongside `tasks.md`.
- **This project's own orchestration plan**: the concrete
  `orchestration-plan.md` Story 3 produces, scoped to this repository's
  SDD pipeline stages, not a template.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A `tasks.md` with cross-story `[P]` parallelism triggers the
  `specjedi-orchestrate` next-step offer in 100% of `specjedi-tasks` runs
  against it; a `tasks.md` without that parallelism triggers it in 0%.
- **SC-002**: `specjedi-implement` surfaces the execution-mode choice in
  100% of runs where an `orchestration-plan.md` sibling file exists, and
  in 0% of runs where it doesn't.
- **SC-002a**: In a team-mode run, 100% of task groups whose role
  resolves to a confirmed mechanism are dispatched via that mechanism
  (not executed inline by the orchestrating session) — checkable by
  confirming each dispatched role's own `Agent`/`Workflow` call names the
  plan's `subagent_type`/model.
- **SC-003**: This project's own `orchestration-plan.md` (Story 3) names
  at least one role per major pipeline stage (planning, implementation,
  governance/consistency checking) with a real Claude Code mechanism and
  a justified model tier for each — checkable by reading the file
  directly.

## Assumptions

- "Different agents in this project" (the request's own phrasing) means
  Claude Code's own `Agent`/`Workflow` tools, since that's this session's
  and this project's harness — Story 3's plan is scoped to Claude Code,
  not a cross-harness plan (that breadth already exists at the
  `specjedi-orchestrate` skill level itself, per feature 064).
- Story 3's plan is a planning artifact, not a runtime change — producing
  it doesn't require modifying any existing `specjedi-*` skill; only
  Stories 1-2 touch `specjedi-tasks`/`specjedi-implement` themselves.
- Team-mode dispatch (FR-003) ships in this feature, scoped to Claude
  Code's own `Agent`/`Workflow` mechanisms — dispatch logic for a harness
  whose row in `references/multi-agent-capability-notes.md` isn't
  "Yes" falls back to single-agent per FR-003a, it isn't built out for
  every harness in this pass.
