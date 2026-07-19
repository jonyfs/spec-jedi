# Feature Specification: Safe Parallel Spec Execution Across Distinct Agents

**Feature Branch**: `056-parallel-spec-execution`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "crie a habilidade de rodar especificações
em pararalo, caso o usuário decida, para que agentes distintos, possa
executar as especificacoes em paralelo desde que não atrapalhe o
funcionamento das outras que estão sendo executadas" (create the ability
to run specs in parallel, if the user decides, so distinct agents can
execute specs in parallel as long as it doesn't disrupt the others being
executed).

Grounding read before drafting: `specjedi-worktree` **already**
mechanizes isolated, collision-free workspaces — one real git worktree
per feature, native-relocation-tool-first, with a path-collision guard
and worktree-aware status reporting already wired into `specjedi-status`
(`git worktree list --porcelain`, one section per worktree). What it
does **not** do: decide *which* candidate features are actually safe to
run at the same time, or dispatch more than one agent at once — it
creates exactly one worktree per invocation, on an explicit request or
accepted offer. Two more things confirmed directly: (1) every `plan.md`
already has a "Source Code (repository root)" section under "Project
Structure" declaring the exact files that feature will touch — an
existing, machine-readable scope declaration, never a new format to
invent; (2) every feature this project has ever shipped also touches two
genuinely shared files as a routine part of `specjedi-specify`'s own
workflow — `CLAUDE.md`'s "current plan" pointer and
`.specify/feature.json` — which would falsely appear as "colliding" in
any naive file-overlap check that doesn't know to exclude them, since
they're expected to differ per feature and are reconciled by git's own
normal merge process, not a real functional conflict.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Know which specs are actually safe to run at the same time before starting any of them (Priority: P1)

A user with several features in flight (a real, current state of this
project — several features are simultaneously specified/mid-clarify
right now) wants to know, before dispatching any parallel work, which
combinations would genuinely collide (declare overlapping files to
touch) versus which are safely independent — reusing each feature's own
already-declared `plan.md` scope, never inventing a second declaration
format or guessing from file names.

**Why this priority**: This is the actual safety mechanism the request's
own "desde que não atrapalhe" (as long as it doesn't disrupt) clause
depends on — dispatching parallel agents onto colliding work is the one
failure mode worth preventing before anything about *running* things in
parallel matters at all.

**Independent Test**: Given two or more features that already have a
`plan.md`, when their declared "Source Code" file lists are compared,
then any genuine overlap is named explicitly (which files, which
features) and known shared/metadata files
(`CLAUDE.md`, `.specify/feature.json`) are excluded from that
comparison — never falsely flagged as a collision.

**Acceptance Scenarios**:

1. **Given** two features whose `plan.md`s declare non-overlapping file
   sets, **When** checked, **Then** they're reported safe to run in
   parallel.
2. **Given** two features whose `plan.md`s declare at least one
   genuinely shared file (excluding `CLAUDE.md`/`.specify/feature.json`),
   **When** checked, **Then** the specific overlapping file and both
   features are named explicitly — never silently allowed.
3. **Given** a candidate feature with only a `spec.md` and no `plan.md`
   yet (no declared file scope exists), **When** checked, **Then** it's
   reported as "not yet checkable" rather than assumed safe or assumed
   colliding.

---

### User Story 2 - Actually dispatch one agent per safe feature into its own isolated worktree (Priority: P2)

Once a safe set is known (User Story 1), a user wants each of those
features actually started by a distinct agent, each working inside its
own isolated worktree — reusing `specjedi-worktree`'s own existing
creation mechanism per feature, never a second, parallel
worktree-creation implementation.

**Why this priority**: P2 — the literal "run in parallel" half of the
request, built directly on User Story 1's safety determination rather
than dispatching blind.

**Independent Test**: Given a safe set of N features (User Story 1),
when parallel execution is requested, then N worktrees are created (one
per feature, via `specjedi-worktree`'s own existing mechanism) and N
distinct agent sessions are started, each confined to its own worktree.

**Acceptance Scenarios**:

1. **Given** a safe set of features and a harness that exposes a
   mechanism for running independent concurrent agent sessions (this
   session's own current harness does), **When** parallel execution is
   requested, **Then** one worktree and one distinct agent session are
   created per feature in the safe set.
2. **Given** a harness with no such concurrent-agent-dispatch mechanism,
   **When** parallel execution is requested, **Then** the worktrees are
   still prepared and the safe-set determination is still reported, but
   this feature does not claim to have started anything a human must
   still start themselves — never a false claim of parallel execution
   that didn't actually happen.

---

### User Story 3 - See every parallel run's status in one place (Priority: P3)

A user with several agents running concurrently across several
worktrees wants one combined view of progress — reusing
`specjedi-status`'s own already-existing, already-worktree-aware
reporting, never a second, separately-maintained dashboard.

**Why this priority**: P3 — visibility on top of Users Stories 1-2's
own mechanism; genuinely useful but not what makes parallel execution
safe in the first place.

**Independent Test**: Given N features running in N worktrees, when
`specjedi-status` is run, then all N appear in its existing
per-worktree sections — confirming no new, separate tracking mechanism
was introduced.

**Acceptance Scenarios**:

1. **Given** parallel execution is in progress across multiple
   worktrees, **When** `specjedi-status` runs, **Then** every one
   appears under its own already-existing worktree heading — nothing
   new to build here beyond confirming this already works end-to-end.

### Edge Cases

- **What if a "safe" pair later turns out to touch a shared file neither
  plan.md declared** (an incomplete plan.md, or a file both plans
  legitimately need that was missed at planning time)? Out of scope to
  guarantee against — this feature's safety check is only as good as
  each feature's own declared scope; it doesn't independently re-derive
  what files a feature "really" needs.
- **What if the user asks to parallelize features from different
  priority tiers or wildly different completion states** (one barely
  specified, one already at `tasks.md`)? Not this feature's concern —
  User Story 1's overlap check applies to any pair with a `plan.md`
  regardless of how far along each one otherwise is.
- **What if only one feature in a requested set turns out to be safe,
  and the rest collide with each other**? The safe subset still runs in
  parallel (even if that subset has only one member); the colliding
  ones are named and left for the user to decide manually — never
  silently dropped without explanation.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Before any parallel execution is dispatched, every
  candidate feature pair with an existing `plan.md` MUST have its
  declared "Source Code" file list cross-checked against every other
  candidate's — any genuine overlap MUST be named explicitly (both
  features, the specific file) rather than silently allowed.
- **FR-002**: `CLAUDE.md`'s "current plan" pointer section and
  `.specify/feature.json` MUST be excluded from the overlap
  determination — both are expected, routine, per-feature-differing
  metadata reconciled by git's own normal merge process, never a real
  functional collision.
- **FR-003**: A candidate feature with no `plan.md` yet MUST be reported
  as "not yet checkable" — never silently assumed safe, and never
  silently assumed colliding.
- **FR-004**: For every feature confirmed safe (FR-001-003), this
  feature MUST create its isolated worktree by reusing
  `specjedi-worktree`'s own existing creation mechanism exactly — never
  a second, parallel implementation of worktree creation.
- **FR-005**: Dispatching a distinct agent session per safe feature MUST
  use whatever mechanism the current harness provides for running
  independent, concurrent agent sessions — this is not assumed to exist
  on every harness (Constitution Principle III); on a harness without
  one, this feature MUST still report the safe-set determination and
  prepared worktrees, and MUST NOT claim execution was dispatched when
  it wasn't.
- **FR-006**: Status visibility across all concurrently-running parallel
  work MUST be satisfied entirely by `specjedi-status`'s own existing,
  already-worktree-aware reporting — this feature MUST NOT introduce a
  second, separately-maintained tracking mechanism (Principle II,
  matching Constitution Principle XXI's own "no parallel status system"
  rule applied here).
- **FR-007**: Whether this capability ships as a new orchestrating skill
  or as a new mode/extension of `specjedi-worktree` itself (which
  already creates one worktree per invocation and is the natural home
  for "create several at once, safely") is a technical decision resolved
  during planning — matching this project's own established "new skill
  vs. extend" precedent (specs/043, specs/049, specs/050, specs/052
  similar deferrals).

### Key Entities

*(Not applicable — this feature cross-references existing `plan.md`
content and orchestrates existing worktree/status mechanisms; no data
model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Given any set of candidate features with existing
  `plan.md`s, the overlap check correctly identifies every genuine file
  collision (verifiable by constructing a known-colliding pair and
  confirming it's flagged) and produces zero false positives from
  `CLAUDE.md`/`.specify/feature.json` (verifiable by constructing a
  known-non-colliding pair that both still touch, and confirming it's
  reported safe).
- **SC-002**: On a harness with a concurrent-agent-dispatch mechanism, a
  safe set of N features results in N real worktrees (verifiable via
  `git worktree list`) and N distinct agent sessions actually running.
- **SC-003**: On a harness without such a mechanism, this feature never
  claims execution happened when it didn't — verifiable by inspecting
  its own reported output for an honest, distinguishable "prepared, not
  dispatched" state.
- **SC-004**: `specjedi-status`, run at any point during parallel
  execution, shows every in-progress worktree under its own existing
  section — verifiable by comparing its output against `git worktree
  list`'s own enumeration.

## Assumptions

- `specjedi-worktree`'s own existing creation mechanism (native-tool-
  first, collision-guarded, never-proactive-removal) is reused entirely
  unchanged — this feature only decides *which* features to create
  worktrees for and *how many at once*, never reimplementing worktree
  mechanics.
- `specjedi-status`'s own existing multi-worktree reporting is reused
  entirely unchanged for User Story 3 — no new dashboard.
- "Distinct agents" means whatever the current harness's own mechanism
  for independent, concurrent agent sessions is (e.g. this session's own
  harness has one) — this feature does not assume every harness in the
  Constitution Principle III compatibility matrix has an equivalent.
- The overlap check (User Story 1) is scoped to `plan.md`'s own already-
  declared "Source Code" section — it does not attempt to independently
  infer a feature's real file footprint by other means (e.g. static
  analysis of `spec.md`'s prose), since that would be guessing rather
  than reading a declared, authoritative source.
