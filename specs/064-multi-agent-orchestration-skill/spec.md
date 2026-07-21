# Feature Specification: Multi-Agent Orchestration Skill

**Feature Branch**: `064-multi-agent-orchestration-skill`

**Created**: 2026-07-20

**Status**: Draft

**Input**: User description: "crie uma skill que sabe criar orquestração multi agent que sabe organizar multi agentes conforme harness selecionado... deve saber criar os agentes de acordo com as múltiplas áreas conforme o projeto... modelos mais potentes para pensar e os mais baratos para executar... funcionar como uma startup de software com agentes por especialização (planejar, implementar, testar, documentar...)"

## Clarifications

### Session 2026-07-20

- Q: FR-008: how many harnesses should this skill support at launch? → A: Full 20+ harness set — every harness this project already ships installers for (specs/023-027), not a Claude-Code-only start.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Generate a harness-appropriate orchestration plan (Priority: P1)

A user running Spec Jedi on a feature with a spec.md/plan.md (and ideally
tasks.md) wants a concrete multi-agent team plan for building it: which
roles exist (plan/architect, implement, test, document, review), which
concrete harness mechanism each role maps to (e.g. Claude Code's Agent
tool + subagent types, or Workflow tool for deterministic fan-out; a
different harness's equivalent sub-agent/task mechanism), and which model
tier each role should run at.

**Why this priority**: Without a harness-aware plan grounded in the
project's actual tech stack, this is just generic advice indistinguishable
from asking an LLM cold — the entire value is in it being concrete and
actionable for *this* project on *this* harness. P1 by elimination: no
other story is useful without this one existing first.

**Independent Test**: Given a feature directory with spec.md and plan.md,
when the user asks this skill to plan the team for it, then the skill
detects the current harness, reads the plan's tech stack/domain, and
produces a written orchestration plan naming each role, its harness-native
mechanism, and its model tier — without installing or executing anything.

**Acceptance Scenarios**:

1. **Given** a feature with plan.md naming a specific tech stack (e.g.
   Go backend + React frontend) on a harness with native sub-agent support,
   **When** the user requests an orchestration plan, **Then** the output
   names domain-appropriate roles (e.g. go-reviewer-equivalent,
   frontend-patterns-equivalent) rather than generic "coder"/"tester" only.
2. **Given** a harness with no native sub-agent/parallel-task mechanism,
   **When** the user requests a plan, **Then** the skill says so plainly
   and offers the closest available fallback (e.g. sequential
   single-agent execution with explicit role-switching prompts) instead
   of silently assuming a mechanism that doesn't exist.
3. **Given** a feature directory with no plan.md yet,
   **When** the user requests an orchestration plan,
   **Then** the skill explains a plan.md is needed first and suggests
   `specjedi-plan` rather than guessing the tech stack.

---

### User Story 2 - Recommend model-tier assignment per role (Priority: P2)

A user wants guidance on which roles should run on a stronger/more
expensive model (planning, architecture, adversarial review — where
reasoning quality matters most) versus a cheaper/faster model (mechanical
implementation, formatting, repetitive test-running — where volume and
cost matter more), for the models actually available in their harness.

**Why this priority**: Valuable on its own — a user can apply tiering
advice to an orchestration they already run — but it depends on knowing
what roles exist, which User Story 1 establishes. P2, not P1: useful in
isolation but incomplete without a role list to attach tiers to.

**Independent Test**: Given a list of roles (from Story 1's output or
supplied directly), when the user asks how to tier models, then the skill
returns a per-role tier recommendation with the reasoning ("plan/review
roles: strongest available; mechanical build/test roles: cheapest capable
tier") that adapts to whatever model names the current harness actually
exposes, never hardcoding a specific vendor's lineup as if it were
universal.

**Acceptance Scenarios**:

1. **Given** a harness exposing multiple model tiers,
   **When** the user asks for tiering guidance,
   **Then** each proposed role gets an explicit tier recommendation and a
   one-line reason tied to that role's cognitive load, not a blanket
   "use the best model everywhere."
2. **Given** a harness exposing only one model (no tier choice available),
   **When** the user asks for tiering guidance,
   **Then** the skill says tiering doesn't apply here rather than
   fabricating a distinction that doesn't exist.

---

### User Story 3 - Produce ready-to-review harness-native agent artifacts (Priority: P3)

A user who has an approved orchestration plan wants the actual
harness-native files it implies (e.g., for Claude Code: `.claude/agents/*.md`
subagent definitions, or a `Workflow` script skeleton) drafted for review —
not installed or run automatically.

**Why this priority**: Highest leverage once trusted, but it's a
downstream convenience on top of Stories 1-2's plan; a user can act on the
written plan manually without this. P3: nice-to-have acceleration, not
required for the skill to deliver its core value.

**Independent Test**: Given an accepted orchestration plan from Story 1,
when the user asks to draft the concrete agent files, then the skill
writes harness-appropriate draft file(s) reflecting the plan's roles and
tiers, presents them for confirmation, and makes no filesystem change
beyond the draft location until the user explicitly approves.

**Acceptance Scenarios**:

1. **Given** an accepted plan on a harness with a documented sub-agent
   definition format, **When** the user asks for artifacts,
   **Then** the skill drafts one file per proposed role in that harness's
   format and lists them for review before anything is treated as final.
2. **Given** the user declines after reviewing the drafts,
   **When** they say no, **Then** nothing beyond the draft is created or
   modified — no silent partial application.

---

### Edge Cases

- What happens when the project spans multiple unrelated domains (e.g. a
  monorepo with backend, frontend, and infra all in one plan.md)? The
  skill should propose a role per domain area rather than one generic
  "implementer" role covering all of them.
- How does the skill handle a harness it doesn't recognize at all (no
  documented sub-agent mechanism, no known model-tier concept)? It must
  say so explicitly and fall back to a single-agent sequential plan
  rather than inventing harness capabilities.
- What happens if the user's constitution.md sets governance principles
  that constrain how agents may commit code or open PRs (e.g. this
  project's own "feature branch + PR only" rule)? The generated plan must
  respect those constraints for any implement/commit-capable role rather
  than proposing direct-to-trunk automation.
- How does the skill handle a request for a team plan when tasks.md
  doesn't exist yet (only spec.md/plan.md)? It should still produce a
  role/tier plan grounded in plan.md's tech stack, noting that per-task
  assignment sharpens once `specjedi-tasks` has run.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The skill MUST detect which harness the current session is
  running on before proposing any mechanism-specific orchestration
  detail, and MUST NOT assume a specific harness's sub-agent API when it
  cannot confirm one.
- **FR-002**: The skill MUST ground proposed roles in the current
  project's actual domain/tech stack — read from plan.md, constitution.md,
  and/or repository content — never a generic fixed role list applied
  unchanged across unrelated projects.
- **FR-003**: The skill MUST propose, at minimum, roles covering planning,
  implementation, testing, documentation, and review, adding
  domain-specific roles (e.g. security, database, a specific language) only
  when the project's own content supports them.
- **FR-004**: The skill MUST recommend a model tier per proposed role,
  favoring the strongest available tier for planning/architecture/adversarial-review
  roles and the cheapest capable tier for mechanical, high-volume,
  low-ambiguity roles, and MUST explain the reasoning per role rather than
  asserting it without justification.
- **FR-005**: The skill MUST NOT install, execute, or commit any generated
  orchestration artifact without explicit user confirmation (Constitution
  autonomy boundary — plan/propose is autonomous, execute/install is not).
- **FR-006**: When the current harness has no native multi-agent or
  sub-agent mechanism, the skill MUST say so plainly and propose the
  closest viable fallback rather than presenting an orchestration plan
  the harness cannot actually run.
- **FR-007**: The skill MUST respect any relevant constraint already
  established by the project's constitution.md (e.g. commit/PR workflow
  rules) when proposing roles capable of writing code or opening PRs.
- **FR-008**: The skill MUST support, at launch, every harness this
  project already ships installers for (20+, per specs/023-027) — not a
  Claude-Code-only initial scope. For a harness without a documented
  sub-agent/parallel-task mechanism, the skill applies FR-006's fallback
  (state the limitation, propose sequential single-agent execution)
  rather than skipping the harness entirely.
- **FR-009**: The skill's output MUST be a written orchestration plan
  artifact (not just chat narration) that a user can hand to
  `specjedi-implement` or execute manually, so the plan survives beyond
  the conversation that produced it.

### Key Entities

- **Orchestration Plan**: The artifact this skill produces — an ordered
  list of proposed roles, each with a name, responsibility, harness-native
  mechanism, recommended model tier, and reasoning; scoped to one feature
  or one project.
- **Role**: A single specialization within the plan (e.g. planner,
  implementer, tester, documenter, reviewer, or a domain-specific
  variant) with a defined responsibility boundary.
- **Harness Profile**: What this skill knows about the current harness's
  actual sub-agent/parallel-task capabilities and available model tiers,
  used to ground every mechanism-specific recommendation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Given a feature with an existing plan.md, the skill produces
  a written orchestration plan naming at least one role per of
  plan/implement/test/document, each with an explicit model-tier
  recommendation, in a single skill invocation.
- **SC-002**: 100% of proposed roles in any generated plan trace to
  content actually present in the project's spec.md/plan.md/constitution.md
  or repository — zero roles invented from a generic template unconnected
  to the project.
- **SC-003**: When run against a harness with no documented sub-agent
  mechanism, the skill's output explicitly states the limitation in the
  first paragraph of its response, never presenting an unusable plan as
  if it were actionable.
- **SC-004**: Zero orchestration artifacts (agent definition files,
  workflow scripts) are written to disk without a prior explicit user
  confirmation step in the same interaction.

## Assumptions

- Claude Code (this session's own harness) is the reference implementation
  for validation, since it has the richest documented sub-agent (Agent
  tool + subagent_type) and deterministic multi-agent (Workflow tool)
  mechanisms of any harness this project supports — per FR-008 the skill
  still targets the full installer-supported harness set at launch, with
  per-harness mechanism detail varying by what each harness documents.
- "Model tier" means whatever coarse strong/cheap distinction the current
  harness's own model-selection surface exposes (e.g. Claude Code's
  model/effort parameters) — this skill does not maintain its own
  hardcoded list of model names or prices, since those go stale.
- This skill produces planning/drafting artifacts only; it does not
  itself execute the orchestration it proposes — that remains the job of
  `specjedi-implement` or the user directly invoking the harness's own
  Agent/Workflow tools per the plan.
- Existing specjedi-* skills (`specjedi-worktree` for parallel checkouts,
  `specjedi-implement` for task execution, `specjedi-govcheck` for
  pre-PR compliance) remain the mechanisms actually invoked once an
  orchestration plan names them as a role's tool — this skill does not
  duplicate their logic.
