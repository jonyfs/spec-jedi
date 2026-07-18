# Feature Specification: `specjedi-*` Pipeline Hook Dispatch

**Feature Branch**: `047-specjedi-hook-dispatch`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "Estender as 9 skills do pipeline core
specjedi-* (specjedi-constitution, specjedi-specify, specjedi-clarify,
specjedi-plan, specjedi-tasks, specjedi-implement, specjedi-analyze,
specjedi-checklist, specjedi-converge) com um mecanismo equivalente de
dispatch de hooks do .specify/extensions.yml (chaves
hooks.before_<stage>/hooks.after_<stage>) que as skills speckit-*
correspondentes já implementam individualmente. Este é o único
bloqueio real de engenharia identificado em
specs/044-speckit-parity-audit/PARITY-LEDGER.md para permitir uma
migração interna completa de speckit-* para specjedi-*; os outros dois
itens da recomendação já foram resolvidos apenas por decisão do
mantenedor (documentado no PARITY-LEDGER, seção Resolution). Uma vez
que este mecanismo exista em todas as 9 skills, o hook atualmente
registrado em .specify/extensions.yml (after_specify/after_plan ->
speckit.agent-context.update) deve continuar disparando corretamente
mesmo se specjedi-* substituir speckit-* nesta migração." (Extend the
9 specjedi-* core pipeline skills with an equivalent extension-hook
dispatch mechanism to the one every matching speckit-* skill already
implements individually, so the project's already-registered hooks
keep firing if specjedi-* substitutes for speckit-* internally — the
one real engineering blocker specs/044's parity audit identified for a
full internal migration.)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Registered hooks keep firing regardless of which pipeline implementation runs (Priority: P1)

A maintainer has configured an extension hook in
`.specify/extensions.yml` tied to a specific pipeline stage (for
example, "after every specification is written, refresh the agent's
context file"). They want that automation to keep firing exactly as
before, whether the stage is executed by a `speckit-*` skill or its
`specjedi-*` counterpart — switching which pipeline implementation runs
must not silently disable configured automation.

**Why this priority**: This is the single concrete blocker specs/044's
own evidence-based readiness audit identified for a full internal
migration off `speckit-*`. Without it, nothing else about migration
readiness matters — the two other recommendation items were already
closed by decision alone, with no engineering required.

**Independent Test**: With a hook registered for a given pipeline
stage, run the `specjedi-*` skill for that stage and confirm the hook
fires exactly as it would have under the equivalent `speckit-*` skill —
same detection, same dispatch format, same silence when nothing
applies.

**Acceptance Scenarios**:

1. **Given** an enabled, unconditional hook registered under a stage's
   `before_<stage>` key, **When** the matching `specjedi-*` skill for
   that stage runs, **Then** the hook's command is surfaced (and
   executed, if mandatory) before that skill's main work begins.
2. **Given** an enabled, unconditional, mandatory hook registered under
   a stage's `after_<stage>` key, **When** the matching `specjedi-*`
   skill for that stage completes its work, **Then** the hook is
   executed before the skill reports completion to the user.
3. **Given** no hook is registered for a stage, or
   `.specify/extensions.yml` doesn't exist at all, **When** any
   `specjedi-*` pipeline skill for that stage runs, **Then** nothing
   about its normal behavior changes — the check produces no visible
   output when there is nothing to dispatch.

---

### User Story 2 - Confirm every pipeline stage is covered, not just some (Priority: P2)

A maintainer preparing to actually execute the internal migration wants
confidence that this mechanism was added consistently across every
core pipeline stage — not just the ones easiest to change — since a
partial rollout would reintroduce the exact same risk the migration
audit flagged, just for a smaller set of stages.

**Why this priority**: P2 — this verification only matters once User
Story 1's mechanism exists; checking coverage before the mechanism is
built would have nothing to verify.

**Independent Test**: Check all 9 core `specjedi-*` pipeline skills for
the same hook-dispatch capability; confirm none were skipped.

**Acceptance Scenarios**:

1. **Given** the 9 core `specjedi-*` pipeline skills
   (`specjedi-constitution`, `specjedi-specify`, `specjedi-clarify`,
   `specjedi-plan`, `specjedi-tasks`, `specjedi-implement`,
   `specjedi-analyze`, `specjedi-checklist`, `specjedi-converge`),
   **When** each is checked for hook-dispatch behavior, **Then** all 9
   show it — matching the 9-of-9 coverage `speckit-*`'s own skills
   already have.
2. **Given** this project's own currently-registered hooks
   (`after_specify`, `after_plan` → the `speckit.agent-context.update`
   extension), **When** `specjedi-specify`/`specjedi-plan` are used in
   place of `speckit-specify`/`speckit-plan`, **Then** both hooks
   continue to fire with no change to `.specify/extensions.yml` itself.

### Edge Cases

- **What happens when `.specify/extensions.yml` is missing or its YAML
  can't be parsed?** Skip hook checking silently and continue normally
  — this must match `speckit-*`'s own existing, already-shipped
  behavior exactly; this feature introduces no new failure mode.
- **What happens when a registered hook has a non-empty `condition`
  field?** Skip the hook and leave condition evaluation to whatever
  executes conditions today (currently nothing does, matching
  `speckit-*`'s own identical documented behavior) — not a new design
  decision, a parity requirement.
- **What happens to `speckit-taskstoissues`'s hook keys
  (`before_taskstoissues`/`after_taskstoissues`)?** Out of scope —
  specs/044's audit already confirmed no `specjedi-*` equivalent is
  needed internally, and none is created by this feature.
- **What happens for a stage where nothing is currently registered?**
  No visible change in behavior at all — the check itself stays silent
  when there's nothing to dispatch (Acceptance Scenario 3).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Each of the 9 core `specjedi-*` pipeline skills MUST
  check `.specify/extensions.yml` for hooks registered under its own
  `hooks.before_<stage>` key before beginning its main work.
- **FR-002**: Each of the 9 core `specjedi-*` pipeline skills MUST
  check `.specify/extensions.yml` for hooks registered under its own
  `hooks.after_<stage>` key before reporting completion to the user.
- **FR-003**: Hook-checking behavior — missing file, malformed YAML,
  disabled hooks, empty vs. non-empty `condition` fields, and the
  optional-vs-mandatory dispatch format — MUST match `speckit-*`'s own
  already-shipped behavior exactly; this is a parity requirement, not a
  new design.
- **FR-004**: When no hooks are registered for a given stage, or
  `.specify/extensions.yml` doesn't exist, a `specjedi-*` skill's
  behavior MUST be unchanged from today — the check MUST be silent.
- **FR-005**: This mechanism MUST NOT alter any of the 9 skills'
  existing product-specific behavior (their own reasoning, judgment
  calls, or voice) — it is purely additive.
- **FR-006**: The mechanism MUST be verifiable directly against this
  project's own currently-registered hooks (`after_specify`,
  `after_plan` → `speckit.agent-context.update`) without modifying
  `.specify/extensions.yml` itself.
- **FR-007**: No new `specjedi-*` skill is created by this feature —
  `speckit-taskstoissues`'s hook keys and any equivalent for a
  not-yet-built `specjedi-taskstoissues` remain explicitly out of
  scope, per specs/044's already-settled decision.

### Key Entities

*(Not applicable — this feature adds reasoning-driven checks to
existing skills; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 9 core `specjedi-*` pipeline skills implement
  hook-dispatch checking — verifiable by confirming hook-checking
  language appears in all 9, matching the 9-of-9 coverage `speckit-*`
  already has.
- **SC-002**: A hook registered under `hooks.after_specify` (or any of
  the 9 stages) fires identically whether `specjedi-specify` or
  `speckit-specify` is the skill invoked — verifiable by a side-by-side
  dry run against this project's own real registered hook.
- **SC-003**: Zero behavior change for any `specjedi-*` pipeline skill
  run when no hook is registered for its stage — verifiable by
  confirming no new output appears for a stage with nothing registered.
- **SC-004**: `specs/044-speckit-parity-audit/PARITY-LEDGER.md`'s third
  recommendation item (the `extensions.yml` hook-dispatch gap) can be
  marked resolved, citing this feature, once shipped.

## Assumptions

- Scope is exactly the 9 core pipeline skills already at Full or
  Partial parity per specs/044's ledger. `specjedi-taskstoissues` (no
  equivalent, confirmed not needed) and a persistent-plan-pointer
  equivalent to `speckit-agent-context-update` (no equivalent,
  architecturally superseded by `specjedi-status`) remain intentionally
  unbuilt — both already settled by the ledger's own Resolution
  section, not reopened here.
- The hook-checking logic itself (parsing rules, condition-skipping,
  optional/mandatory dispatch format) is matched from `speckit-*`'s own
  already-proven, currently-shipped implementation — not redesigned
  from scratch.
- This feature closes the one blocking technical gap the migration
  audit identified; it does not itself execute the actual internal
  migration (switching this repository's own day-to-day development
  workflow from `speckit-*` to `specjedi-*`) — that remains a separate,
  later maintainer decision, per specs/044's own scope boundary between
  "safe to migrate" and "migrated."
- No new script or CI job is needed — this is reasoning-driven prompt
  text added to 9 existing skills, the same way every other
  `specjedi-*` skill already implements its own logic (no code, no
  runtime dependency).
