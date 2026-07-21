# Feature Specification: Agent Mapping for All specjedi-* Skills

**Feature Branch**: `066-agent-mapping-all-skills`

**Created**: 2026-07-21

**Status**: Draft

**Input**: User description: "revise/configure agentes mais adequados
para todas as skills specjedi" (review/configure the most appropriate
agents for all specjedi skills)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Every specjedi-* skill has a documented, grounded agent assignment (Priority: P1)

A maintainer wants to know, for any of the 32 installed `specjedi-*`
skills — not just the 7 core pipeline stages feature 065 already covered
— which of the project's project-local agents (`.claude/agents/
orchestrate-*.md`) is the right one to dispatch it through under team
mode, or whether it has no dedicated agent and runs in the main
orchestrating session instead. Today, only 6 of 32 skills have a
documented mapping (via `specs/065-.../orchestration-plan.md`); the
other 26 are undocumented.

**Why this priority**: Without a complete mapping, `specjedi-orchestrate`
can only ever propose a team for the 7 pipeline-core skills it already
knows about — every other skill silently falls outside team-mode
dispatch with no visibility into why. P1: this is the entire point of
the request — completeness, not a nice-to-have refinement.

**Independent Test**: Given the full list of 32 installed `specjedi-*`
skills, produce a table where every skill has exactly one disposition:
mapped to an existing `orchestrate-*` agent (with reasoning), mapped to a
new agent this feature proposes (with reasoning), or explicitly marked
"no dedicated agent — runs in the main session" (with reasoning) — zero
skills left unaccounted for.

**Acceptance Scenarios**:

1. **Given** a read-only, judgment-heavy skill like
   `specjedi-constitution-audit`, **When** the mapping is built, **Then**
   it's assigned to `orchestrate-reviewer` (or a documented near-neighbor)
   with a reasoning line citing what about its behavior matches that
   role — never assigned by name-similarity alone.
2. **Given** a skill whose behavior doesn't cleanly fit any of the 6
   existing roles (e.g. `specjedi-master`'s external-catalog research
   behavior, `specjedi-diagram`'s Mermaid-rendering verification loop),
   **When** the mapping is built, **Then** the spec explicitly reasons
   about whether a new agent role is justified or an existing one is
   close enough, rather than force-fitting every skill into the 6 that
   already exist.
3. **Given** a skill that is inherently a main-session, conversational,
   one-shot interaction (e.g. `specjedi-explain`, `specjedi-status`),
   **When** the mapping is built, **Then** it's marked "no dedicated
   agent" with the reasoning that dispatching it wouldn't add value —
   never forced into an agent role just for table completeness.

---

### User Story 2 - New agent roles for skill clusters the existing 6 don't cover (Priority: P2)

Where Story 1's mapping finds a real cluster of skills sharing a
behavior pattern the existing 6 `orchestrate-*` roles don't fit (e.g., a
cluster of read-only audit skills with a genuinely different risk
profile than `orchestrate-reviewer`'s pre-PR check, or a cluster of
skill-authoring/meta skills), define new `.claude/agents/orchestrate-*.md`
files for those clusters — grounded in real shared behavior, not one
new agent per skill.

**Why this priority**: Depends on Story 1's mapping existing first to
even identify a real cluster; without it, "new agent roles" is a guess.
P2: valuable completion of the request, not reachable before P1.

**Independent Test**: Given Story 1's mapping table, any skill marked
"needs a new role" in 2+ instances sharing a real behavioral pattern
gets exactly one new agent definition (not one per skill), following the
same frontmatter/tiering/color discipline `specjedi-orchestrate`'s Step 6
and feature 065's own 6 agents already established.

**Acceptance Scenarios**:

1. **Given** 3+ skills share "strictly read-only, judgment-heavy,
   whole-project audit" behavior but a materially different scope than
   `orchestrate-reviewer`'s per-PR-diff scope (e.g.
   `specjedi-constitution-audit`, `specjedi-catalog-audit`,
   `specjedi-skill-review` all reason across the *entire* project, not
   one branch's diff), **When** Story 2 runs, **Then** one new agent
   (e.g. `orchestrate-auditor`) is defined for that cluster, not three.
2. **Given** no cluster of 2+ skills shares a genuinely distinct pattern,
   **When** Story 2 runs, **Then** no new agent is created — Story 1's
   6-agent mapping (extended to more skills) stands as sufficient.

---

### User Story 3 - Update the canonical mapping artifact and orchestration-plan.md (Priority: P1)

The completed mapping (Stories 1-2) is written to a durable, canonical
location `specjedi-orchestrate` itself can consult for *any* skill
request, not just the 7-stage pipeline — extending
`specs/065-orchestrate-pipeline-integration/orchestration-plan.md` (or a
new dedicated reference) rather than leaving the mapping only in this
feature's own `spec.md`.

**Why this priority**: Without this, Stories 1-2's reasoning is
documentation about a mapping, not a mapping `specjedi-orchestrate`
actually uses. P1 alongside Story 1 — the artifact is what makes the
mapping real, matching this project's own "written artifact, not just
chat narration" discipline (feature 064's own FR-009 precedent).

**Independent Test**: After this feature ships, reading
`orchestration-plan.md` (or its extension) answers "which agent handles
skill X?" for all 32 skills without needing this feature's own `spec.md`
open alongside it.

**Acceptance Scenarios**:

1. **Given** the completed mapping, **When** a user asks
   `specjedi-orchestrate` which agent to use for a named skill outside
   the original 7-stage pipeline, **Then** the answer traces to this
   feature's own written artifact, not an improvised answer.

---

### Edge Cases

- What happens to `specjedi-orchestrate` itself — does it need a
  self-referential agent mapping? No: it's the mechanism doing the
  mapping, not a pipeline stage being mapped; explicitly out of scope,
  stated as an Assumption rather than silently skipped without
  explanation.
- What happens to skills that are pure session-modifiers with no
  artifact output at all (e.g. `specjedi-caveman-mode`)? Same
  disposition as User Story 1 Acceptance Scenario 3 — "no dedicated
  agent," reasoning: nothing about a mode toggle benefits from
  delegation.
- What happens if two skills seem to fit the same existing role but at
  different tiers of judgment (e.g. `specjedi-checklist`'s generated
  checklist vs. `specjedi-security`'s threat-modeling prompt — both
  "review-adjacent" but different depth)? Reason through it explicitly
  per skill rather than batching by superficial category name — this is
  exactly the class of judgment call Story 1's own reasoning requirement
  exists to force.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: This feature MUST produce a complete disposition for all
  32 currently-installed `specjedi-*` skills — mapped to an existing
  `orchestrate-*` agent, mapped to a newly-defined one, or explicitly
  "no dedicated agent" — with a one-line reasoning per skill, zero
  skills silently omitted.
- **FR-002**: Every mapping decision MUST be grounded in the target
  skill's actual documented behavior (read vs. write, judgment vs.
  mechanical, scope) — never assigned by name-similarity or category
  guesswork.
- **FR-003**: A new agent role MUST only be created when 2 or more
  skills share a real behavioral pattern the existing 6 roles don't
  fit — never one new agent per single skill (spec.md Story 2
  Acceptance Scenario 2).
- **FR-004**: Every new agent definition MUST follow the same real
  frontmatter fields feature 065 already confirmed (`name`,
  `description`, `tools`, `model`, `color`) — no invented fields.
- **FR-005**: The completed mapping MUST be written to a durable
  artifact `specjedi-orchestrate` can consult — extending
  `orchestration-plan.md` or a clearly-linked new reference — not left
  only in this feature's own `spec.md`/`plan.md`.
- **FR-006**: This feature MUST NOT create, install, or modify any agent
  file without the same explicit-confirmation discipline
  `specjedi-orchestrate`'s own Step 9 already establishes (spec 064
  FR-005) — propose-then-confirm, never silent write.

### Key Entities

- **Skill Disposition**: one row per `specjedi-*` skill — its assigned
  agent (existing, new, or none) and the one-line reasoning behind that
  assignment.
- **New Agent Cluster**: a group of 2+ skills sharing real behavior that
  justifies one new `orchestrate-*` agent definition.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 32/32 installed `specjedi-*` skills appear in the final
  mapping table with an explicit disposition — checkable by counting
  table rows against `ls .claude/skills | grep specjedi | wc -l`.
- **SC-002**: Zero new agents are created for a cluster of fewer than 2
  skills — checkable by confirming each new `orchestrate-*.md` file's
  own reasoning cites at least 2 mapped skills.
- **SC-003**: `specjedi-orchestrate`'s own reference material (Step 5's
  mechanism lookup) can answer "which agent for skill X" for any of the
  32 skills by reading the written artifact alone.

## Assumptions

- `specjedi-orchestrate` itself is excluded from the mapping — it is the
  mechanism producing the mapping, not a pipeline stage being assigned
  one (Edge Cases).
- The 6 agents feature 065 already shipped
  (`orchestrate-planner/decomposer/implementer/reviewer/documentarian/
  narrator`) are the starting inventory Story 1 maps against before Story
  2 considers any new ones — not rebuilt from scratch.
- This feature extends `specs/065-.../orchestration-plan.md` rather than
  replacing it — the 7-stage pipeline mapping it already contains stays
  correct and is additive, not restated.
