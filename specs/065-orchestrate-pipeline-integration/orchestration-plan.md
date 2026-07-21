# Orchestration Plan: spec-jedi's own SDD pipeline

**Harness**: Claude Code (Yes/Yes — `references/multi-agent-capability-notes.md`'s own row: `Agent` tool + `subagent_type`, `Workflow` tool for deterministic multi-stage fan-out, per-call model/effort override confirmed)

**Grounding**: `.specify/memory/constitution.md` (Principles VI test-first,
VIII token-economy, IX validation, X trunk-based PR-only workflow, XIV
next-step, XIX skill authoring, XX honest output, XXIII post-implementation
doc freshness) and this feature's own `plan.md`. Every role below maps to
a real stage in this project's own pipeline — `specjedi-specify` →
`specjedi-clarify` → `specjedi-plan` → `specjedi-tasks` →
`specjedi-implement` → `specjedi-govcheck`/`specjedi-analyze` →
`specjedi-retro`/`specjedi-release` — never a generic planner/coder/tester
template unconnected to how this repository actually works.

## Roles

### Planner — turns a rough idea into spec.md/plan.md (specjedi-specify, specjedi-clarify, specjedi-plan)
- **Mechanism**: `Agent` tool, `subagent_type: planner` (or `architect` for
  plan.md's Technical Context/Constitution Check reasoning) — a single
  delegated role per feature; escalate to the `Workflow` tool only when
  running this stage across several features at once (`pipeline()` over a
  feature list, each stage `specify → clarify → plan`).
- **Model tier**: Strongest available. **Reasoning**: priority ordering
  (Principle IV judgment call on P1), Constitution Check gating, and
  ambiguity surfacing are exactly the highest-cost-to-reverse decisions
  this project's own Principle V exists to prevent from reaching
  implementation half-formed — a wrong call here compounds through every
  later stage.

### Task Decomposer — turns plan.md into tasks.md (specjedi-tasks)
- **Mechanism**: `Agent` tool, `subagent_type: planner`-adjacent
  decomposition role, scoped to reading one `plan.md` and writing one
  `tasks.md`.
- **Model tier**: Strongest available. **Reasoning**: `[P]` marking
  requires "reasoning explicitly" about genuine file-level independence
  (this project's own `specjedi-tasks` Always/Never rule) — a false
  parallelism marking causes real conflicts downstream; this is a
  judgment call, not mechanical transcription.

### Implementer — executes tasks.md, test-first, one feature branch + PR (specjedi-implement)
- **Mechanism**: `Agent` tool, general-purpose `builder` role per user
  story's task group; for a `tasks.md` this project's own new
  `specjedi-orchestrate` integration (feature 065) marks team-shaped
  (2+ stories with real `[P]` parallelism), the `Workflow` tool's
  `pipeline()`/`parallel()` dispatches each story's task group to its own
  `builder` agent instance concurrently, never a shared mutable branch
  state across concurrent dispatches (git worktree isolation per
  `specjedi-worktree` where genuinely needed).
- **Model tier**: Cheapest capable. **Reasoning**: once `plan.md`/`tasks.md`
  are precise (Principle V's own guarantee), implementation is mechanical
  execution against an already-decided design — high volume, low
  ambiguity, exactly the FR-004 case for the cheap tier. Never commits
  directly to `main` (constitution Principle X) — every dispatched
  instance opens its own feature branch + PR, no exception under
  team-mode dispatch (feature 065 FR-003b).

### Governance & Consistency Reviewer — pre-PR compliance + traceability (specjedi-govcheck, specjedi-analyze)
- **Mechanism**: `Agent` tool, `subagent_type: code-reviewer`-adjacent
  read-only auditor role; both skills are independently read-only and
  operate on the same branch diff, so the `Workflow` tool's `parallel()`
  runs them concurrently as a two-thunk barrier before PR-opening
  narration.
- **Model tier**: Strongest available. **Reasoning**: "any confirmed
  constitution conflict is CRITICAL, unconditionally" (this project's own
  `specjedi-govcheck` rule) — a missed CRITICAL finding here is exactly
  the class of wrong call this project's own adversarial-review posture
  (Constitution's general "push back, don't silently agree" spirit,
  Principle IV) exists to prevent; cheap-tier pattern-matching risks
  exactly the "keyword-matching instead of reasoning" failure
  `specjedi-govcheck`'s own Always/Never explicitly forbids.

### Documentarian — keeps docs current with what shipped (specjedi-docs, and Principle XXIII's freshness check)
- **Mechanism**: `Agent` tool, `subagent_type: doc-updater`-adjacent role,
  confirm-before-write per `specjedi-docs`'s own existing discipline —
  never auto-writes `CHANGELOG.md`/README rows without the drafted entry
  being presented first (unchanged by this role's dispatch).
- **Model tier**: Cheapest capable. **Reasoning**: drafting a changelog
  entry or README row from an already-shipped feature's own spec/plan is
  grounded transcription, not novel judgment — the confirm-before-write
  gate (not model strength) is what catches a bad draft here.

### Retrospective & Release Narrator — closes the loop (specjedi-retro, specjedi-release)
- **Mechanism**: `Agent` tool, general-purpose narrator role — strictly
  read-only for both skills (neither tags, publishes, nor edits code/spec/
  plan/tasks), so no `Workflow` fan-out is needed; a single delegated call
  per invocation suffices.
- **Model tier**: Cheapest capable. **Reasoning**: both skills' own
  documented behavior is "run a script/gather git history, narrate
  faithfully, log/report" — grounding-and-narration work, not open-ended
  judgment; the real judgment (whether to actually cut a release) is
  explicitly reserved for the human maintainer in both skills' own design
  (`specjedi-release`'s hard non-override boundary), so no model tier
  choice here substitutes for that.

## Pipeline shape (Workflow tool sketch, for a batch of features)

```javascript
// One feature end-to-end: sequential stages, each its own agent() call
await pipeline(
  features,
  f => agent(`Plan feature: ${f}`, {agentType: 'planner', effort: 'high'}),
  plan => agent(`Decompose into tasks: ${plan}`, {agentType: 'planner', effort: 'high'}),
  tasks => agent(`Implement: ${tasks}`, {agentType: 'builder', effort: 'low'}),
  impl => parallel([
    () => agent(`govcheck: ${impl}`, {agentType: 'code-reviewer', effort: 'high'}),
    () => agent(`analyze traceability: ${impl}`, {agentType: 'code-reviewer', effort: 'high'}),
  ]),
)
```

This sketch is illustrative of the role→mechanism mapping above, not a
committed runtime script — feature 065's own Story 2 scope (`specjedi-
implement` dispatch) is where real `Agent`/`Workflow` calls get made
per-run, grounded in each feature's own `orchestration-plan.md`, not a
static pipeline hardcoded here.

## Governance constraint check (constitution Principle X)

Only the Implementer role writes code or opens PRs. Its mechanism section
above states explicitly: every dispatched instance opens its own feature
branch + PR, never commits directly to `main` — matching this project's
own trunk-protected, PR-only discipline exactly, including under
concurrent team-mode dispatch (feature 065 FR-003b, FR-006).
