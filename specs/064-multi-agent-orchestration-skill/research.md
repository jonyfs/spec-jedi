# Research: Multi-Agent Orchestration Skill

**Feature**: 064-multi-agent-orchestration-skill
**Purpose**: Principle II (Competitive Research Before Creation,
NON-NEGOTIABLE) — benchmark against spec-kit + real competitors, confirm
no internal redundancy against any already-shipped `specjedi-*` skill,
and name the genuine contribution before writing `SKILL.md`.

## Spec-kit baseline

GitHub's `spec-kit` (the upstream project Spec Jedi's own `specjedi-*`
pipeline parallels/supersedes per this project's own migration history —
see `references/specjedi-and-sdd.md`) has no multi-agent orchestration
command in its own `speckit-*` set: `specify`, `clarify`, `plan`, `tasks`,
`implement`, `analyze`, `checklist`, `constitution`. None of these
proposes a team of specialized agents, assigns model tiers, or maps roles
to a harness's sub-agent mechanism. `speckit-implement` executes tasks
itself, single-agent, sequentially. This is a clean gap, not a
reimplementation of something spec-kit already does.

## Competitor scan

- **CrewAI** — a standalone Python framework for defining "crews" of
  role-based agents (each with a goal, backstory, and tools) that
  collaborate on a task, with sequential or hierarchical process modes.
  Closest conceptual match to "software startup with agents per
  specialization." Difference: CrewAI is a runtime framework a developer
  codes against (Python classes, `Agent`/`Task`/`Crew` objects); it does
  not operate as a prompt-level skill inside an existing coding-agent
  harness, and has no concept of "harness-native sub-agent mechanism
  detection" — the crew *is* the runtime.
- **AutoGen / AG2 (Microsoft)** — multi-agent conversation framework
  where agents (assistant, user-proxy, group-chat manager) exchange
  messages to solve a task, with configurable LLM backends per agent
  (which is where AutoGen gets closest to "different model per role").
  Same category difference as CrewAI: a library you build a script
  against, not a skill that inspects and adapts to whatever coding-agent
  harness is already running.
- **LangGraph multi-agent patterns** (LangChain) — graph-based
  orchestration where each node can be a distinct agent/LLM call, commonly
  used for supervisor/worker patterns. Same difference again: a
  developer-authored graph in a general-purpose orchestration library,
  not a skill invoked conversationally inside a spec-driven-development
  pipeline that already knows the project's spec/plan/constitution.

**What none of these three do**: read a project's own `spec.md`/`plan.md`/
`constitution.md` to ground role proposals in that project's actual
domain; detect which coding-agent harness is currently running and adapt
the proposed mechanism to what that harness genuinely supports (falling
back honestly when it doesn't); or respect an existing project's own
governance constraints (e.g. this project's trunk-protected,
PR-only commit discipline) when proposing which roles may write code.
That triad — spec-grounded, harness-adaptive, governance-aware — is this
skill's actual contribution, not "multi-agent orchestration" in the
abstract, which is a solved and crowded space at the framework level.

## Internal-redundancy check (this project's own installed `specjedi-*` set)

- **`specjedi-master`**: suggests skills/agents/commands/hooks a project
  *could* install from aitmpl.com, based on watching what a project is.
  Overlap risk: both skills touch "what agents should this project have."
  Distinction: `specjedi-master` recommends *installing new tooling*
  (skills, commands, hooks) from an external catalog; this new skill
  proposes *how to organize a coordinated multi-agent execution* for one
  specific feature's implementation, using whatever agent mechanism
  already exists in the current harness — it doesn't install anything
  from a catalog, and `specjedi-master` doesn't propose model tiers or
  per-role harness mechanisms for executing a feature. Complementary, not
  redundant: a project could use `specjedi-master` to discover this very
  skill, then use this skill to plan a feature's build.
- **`specjedi-worktree`**: creates isolated git worktrees for parallel
  development. Overlap risk: both relate to "parallel work." Distinction:
  `specjedi-worktree` solves the filesystem-isolation problem (multiple
  checkouts so parallel work doesn't collide); this skill solves the
  role-and-model-assignment problem (who does what, on what model tier).
  A generated orchestration plan may *reference* `specjedi-worktree` as
  the mechanism a parallel-implementation role uses, but doesn't
  duplicate its logic.
- **`specjedi-implement`**: executes `tasks.md` — the mechanism that
  actually *runs* work, single-agent by default. This new skill's output
  (an orchestration plan) is a proposal for how a team *could* attack a
  feature; `specjedi-implement` remains the default single-agent
  execution path a user can still choose. No overlap: one proposes
  organization, the other executes (with or without that organization
  applied).
- **`specjedi-govcheck`/`specjedi-analyze`**: read-only compliance/
  consistency checks, unrelated to team composition or model selection.
  No overlap.

No existing `specjedi-*` skill proposes agent-role composition,
model-tier assignment, or harness-native sub-agent mechanism selection.
Confirmed clean.

## Genuine contribution

A skill that (1) reads a project's own spec/plan/constitution to ground
proposed roles in that project's real domain rather than a generic
template, (2) detects the current harness's actual multi-agent capability
(citing real, sourced research — `references/multi-agent-capability-notes.md`
— rather than assuming one harness's API universally) and falls back
honestly when a harness has none, (3) recommends a model tier per role
based on cognitive load (planning/review = strongest; mechanical
execution = cheapest capable) without hardcoding a stale model-name list,
and (4) never installs, executes, or commits anything without explicit
confirmation. This is a coordination layer purpose-built for the
`specjedi-*` pipeline's own multi-harness, spec-grounded, governance-aware
posture — not available from any of the three competitor frameworks
surveyed, which all assume a single fixed runtime and no host project
context.
