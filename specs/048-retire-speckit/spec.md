# Feature Specification: Retire `speckit-*` Bootstrap Tooling

**Feature Branch**: `048-retire-speckit`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "Já posso remover speckit deste projeto
sem perder features que contém em speckit que não tem em specjedi?"
(Can I already remove speckit from this project without losing any
feature speckit has that specjedi doesn't?) — followed by explicit
maintainer confirmation to retire the two `.specify/extensions.yml`
hooks that still depend on a `speckit-*` skill
(`speckit.agent-context.update`) before executing the removal, since
`specjedi-status`'s zero-parallel-tracking design and Constitution
Principle XXI's `SessionStart` re-surfacing already cover that need
(per `specs/044-speckit-parity-audit/PARITY-LEDGER.md`'s own
Resolution). This feature executes the internal migration
`specs/044`/`specs/047` assessed and prepared but deliberately did not
perform.

## Clarifications

### Session 2026-07-18

- Q: Acceptance Scenario 3 (US1) implies a documented replacement
  mechanism for keeping `CLAUDE.md`'s plan pointer current once the
  automating hook is retired, but no Functional Requirement stated this
  explicitly — should one be added? → A: Yes — add FR-011 requiring
  `specjedi-plan` (or an equivalent skill) to natively document/perform
  this update, closing the gap for real rather than leaving it
  implicit in an acceptance scenario alone.
- Q: Acceptance Scenario 1 (US3) left an "either update in place, or
  reframe as historical" choice open for the README's comic-form
  section, but research.md's Decision 3 already firmly resolved it
  (update in place) — should spec.md be tightened to match? → A: Yes —
  requiring the in-place update directly in the acceptance scenario
  removes the risk of spec.md and plan.md silently disagreeing about
  an already-made decision.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Stop relying on a `speckit-*` skill for the agent-context hook (Priority: P1)

A maintainer confirmed that the two live hooks currently registered in
`.specify/extensions.yml` (`after_specify`, `after_plan`, both
dispatching to `speckit.agent-context.update`) should be retired rather
than kept — `specjedi-status`'s own on-disk-derived status and
Constitution Principle XXI's `SessionStart` re-surfacing already cover
the underlying need (keeping the agent aware of the current plan)
without a separate, driftable pointer mechanism. This must happen
*before* any `speckit-*` skill file is deleted, since deleting
`speckit-agent-context-update` while those hooks still name it would
leave a dangling reference every `specjedi-*` pipeline skill's own new
hook-dispatch check (specs/047) would otherwise try to surface.

**Why this priority**: This is the literal precondition for User Story
2 — removing `speckit-*` files while this dependency still exists
would break something real, not hypothetical.

**Independent Test**: After retiring the hooks, run any core
`specjedi-*` pipeline skill for the `specify`/`plan` stages and confirm
no `## Extension Hooks` block appears — because nothing is registered
anymore, not because the check silently failed.

**Acceptance Scenarios**:

1. **Given** `.specify/extensions.yml` currently has `after_specify`/
   `after_plan` hooks registered to `speckit.agent-context.update`,
   **When** this story is complete, **Then** `.specify/extensions.yml`
   no longer registers either hook.
2. **Given** the hooks are retired, **When** `specjedi-specify` or
   `specjedi-plan` runs, **Then** their Pre-flight/after-hook checks
   find nothing registered and stay silent, exactly as documented for
   the "nothing registered" case.
3. **Given** the hooks are retired, **When** a maintainer asks how
   `CLAUDE.md`'s plan pointer now stays current, **Then** the answer is
   documented: manual update as part of each `speckit-plan`/
   `specjedi-plan` cycle (the existing Phase 1 convention this project
   has already followed all session), not a dangling reference to a
   removed automation.

---

### User Story 2 - Remove the vendored `speckit-*` skills (Priority: P1)

A maintainer wants the 11 vendored `speckit-*` skill directories
removed from `.claude/skills/`, now that `specjedi-*` has full or
better parity for all 9 core pipeline skills (`specs/044`'s ledger)
plus hook-dispatch parity (`specs/047`), and the two "no equivalent"
items are each confirmed non-blocking (`speckit-taskstoissues`: never
used internally; `speckit-agent-context-update`: its underlying need is
retired, not replaced, per User Story 1).

**Why this priority**: This is the actual ask — removing the vendored
tooling the maintainer no longer needs, once nothing depends on it.

**Independent Test**: After removal, `.claude/skills/` contains zero
`speckit-*` directories, and `scripts/validate.sh` still passes.

**Acceptance Scenarios**:

1. **Given** User Story 1 is complete, **When** all 11 `speckit-*`
   skill directories are deleted, **Then** no registered hook, no
   `specjedi-*` skill, and no packaging/install script references a
   `speckit-*` skill that no longer exists.
2. **Given** the removal is complete, **When** `scripts/install.sh`/
   `.ps1` and `scripts/package-release.sh`/`.ps1` are inspected,
   **Then** their behavior is unchanged — they never packaged or
   installed `speckit-*` skills for end users in the first place, so
   external users of Spec Jedi are unaffected either way.
3. **Given** the removal is complete, **When** a maintainer runs
   `scripts/validate.sh`, **Then** it passes with no new failure
   caused by the removal.

---

### User Story 3 - Documentation stops describing a workflow that no longer exists (Priority: P2)

A reader of this project's own documentation (README, CONTRIBUTING,
the constitution, the principle-traceability index) needs every
mention of `speckit-*` as this project's *current* internal-development
mechanism corrected — either removed or explicitly reframed as
historical — once `speckit-*` is actually gone, so no document teaches
a process this repository no longer follows.

**Why this priority**: P2 — depends on User Story 2 actually happening
first; documenting a removal that hasn't occurred yet would be
premature and wrong in the other direction.

**Independent Test**: Grep the whole repository for `/speckit-` command
references in prose (excluding this feature's own historical spec/plan
files and past CHANGELOG entries, which correctly describe what was
once true); confirm every remaining hit either no longer describes a
*current* practice or is explicitly labeled historical.

**Acceptance Scenarios**:

1. **Given** `speckit-*` is removed, **When** a reader reaches
   README's "How Spec Jedi builds itself, in comic form" section,
   **Then** its narrated commands are updated in place to their
   `specjedi-*` equivalents (Clarifications, Session 2026-07-18) — the
   same walkthrough, illustrations, epigraph, and internal-bootstrap
   disclaimer stay, only the tool named changes; it is never presented
   as still describing `speckit-*` commands that no longer exist.
2. **Given** `speckit-*` is removed, **When** a reader reaches
   Constitution Principle XV, **Then** its text no longer states that
   "this project currently uses spec-kit's own command skills to build
   itself" as an ongoing fact — the principle's actual rules (naming
   convention; bootstrap/product distinction in end-user docs) remain
   intact and correct regardless, since removing the tool doesn't
   change what the rule requires going forward.
3. **Given** `speckit-*` is removed, **When** a reader reaches
   `CONTRIBUTING.md`'s "Voice and naming" section, **Then** its
   description of `speckit-*` as tooling "this repo uses to build
   itself" is corrected to reflect that it no longer does.
4. **Given** `speckit-*` is removed, **When** a reader reaches
   `references/principle-traceability.md`'s Principle XV row and the
   Development Workflow cross-cutting row, **Then** both reflect the
   completed migration, citing this feature.

### Edge Cases

- **What happens to this project's own historical record of using
  `speckit-*`** (past CHANGELOG entries, past `specs/001-*` through
  `specs/047-*` spec/plan/tasks files that reference `speckit-*`
  commands as what was actually run at the time)? Left untouched —
  these are accurate historical records of what genuinely happened;
  rewriting them would falsify project history. Only *forward-looking*
  or *currently-descriptive* text (README's live sections, the
  constitution's stated current practice, CONTRIBUTING's guidance to
  future contributors) gets corrected.
- **What happens to the "How Spec Jedi builds itself, in comic form"
  section specifically**, given specs/036/037 both explicitly decided
  to keep it as-is? Both of those decisions were made while `speckit-*`
  was still this project's live internal-development mechanism —
  removing that mechanism is new information neither prior decision
  had. This feature does not silently leave it stale describing a
  process that no longer runs — its commands are updated in place
  (Acceptance Scenario 1, Clarifications Session 2026-07-18), keeping
  specs/036/037's illustrated panels and voice intact while fixing what
  would otherwise become inaccurate.
- **What if a future contributor wants `speckit-agent-context-update`'s
  underlying capability back later?** The mechanism it wrapped
  (`.specify/extensions/agent-context/`) is a spec-kit extension
  package, not something this feature deletes from
  `.specify/extensions/` — only the `speckit-*` *skill* that dispatched
  to it and this project's own *hook registration* are retired. The
  extension package itself remains available to reinstall a hook
  against, should a future maintainer decide the need has changed.
- **What if `speckit-taskstoissues` turns out to be wanted later after
  all?** Per specs/044's already-settled Dual-Value Distinction, that
  would ship as a genuine new `specjedi-taskstoissues` product feature
  through its own `/specjedi-specify` cycle, not a retroactive
  un-deletion of the vendored tool.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `after_specify` and `after_plan` hook registrations
  in `.specify/extensions.yml` (both currently dispatching to
  `speckit.agent-context.update`) MUST be removed before any
  `speckit-*` skill file is deleted.
- **FR-002**: All 11 `speckit-*` skill directories under
  `.claude/skills/` MUST be removed once FR-001 is complete.
- **FR-003**: The removal MUST NOT change `scripts/install.sh`/`.ps1`
  or `scripts/package-release.sh`/`.ps1`'s behavior for end users —
  these scripts never packaged or installed `speckit-*` skills in the
  first place, confirmed before this feature began.
- **FR-004**: `scripts/validate.sh`/`.ps1` MUST still pass after the
  removal, with no new failure introduced by missing `speckit-*` files.
- **FR-005**: Constitution Principle XV MUST be amended to no longer
  state that this project *currently* dogfoods `speckit-*` to build
  itself — the principle's actual rules (naming convention;
  bootstrap/product distinction requirement for any future vendored
  tooling) remain unchanged, since removing today's specific vendored
  tool doesn't change what the rule requires if a similar situation
  ever recurs. This is a Governance-tracked amendment with its own
  Sync Impact Report, per the constitution's own amendment procedure.
- **FR-006**: README's "How Spec Jedi builds itself, in comic form"
  section's narrated commands MUST be updated in place to their
  `specjedi-*` equivalents once `speckit-*` is removed (Clarifications,
  Session 2026-07-18) — the walkthrough, illustrations, epigraph, and
  internal-bootstrap disclaimer are otherwise unchanged. It MUST NOT be
  left describing `speckit-*` commands that no longer exist.
- **FR-007**: `CONTRIBUTING.md`'s "Voice and naming" section's
  description of `speckit-*` MUST be corrected to no longer claim this
  repository presently uses it to build itself.
- **FR-008**: `references/principle-traceability.md`'s Principle XV row
  and Development Workflow row MUST be updated to reflect the completed
  migration, citing this feature.
- **FR-009**: This feature MUST NOT alter any historical record (past
  CHANGELOG entries, past `specs/NNN-*` artifacts describing what
  actually ran at the time) — only current/forward-looking
  documentation is in scope (see Edge Cases).
- **FR-010**: `specs/044-speckit-parity-audit/PARITY-LEDGER.md` MUST be
  updated to record that the migration it assessed readiness for has
  now actually been executed, citing this feature.
- **FR-011**: `specjedi-plan` (or an equivalent skill) MUST natively
  document and perform the update to `CLAUDE.md`'s plan-reference
  pointer as part of its own normal flow, once the `after_plan` hook
  that previously automated this is retired (FR-001) — this MUST NOT
  be left as an implicit expectation with no stated owner or
  documented step (Clarifications, Session 2026-07-18).

### Key Entities

*(Not applicable — this feature removes files and corrects
documentation; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Zero `speckit-*` directories remain under
  `.claude/skills/` — verifiable via a direct directory listing.
- **SC-002**: Zero hook registrations in `.specify/extensions.yml`
  reference a `speckit-*` command — verifiable by reading the file.
- **SC-003**: `scripts/validate.sh`/`.ps1` passes with no new failure
  attributable to this removal — verifiable by running it.
- **SC-004**: Every current/forward-looking document that previously
  described `speckit-*` as this project's live internal-development
  mechanism (README, CONTRIBUTING.md, Constitution Principle XV,
  `references/principle-traceability.md`) now accurately reflects that
  it no longer is — verifiable by reading each document.
- **SC-005**: Zero historical artifact (past CHANGELOG entries, past
  `specs/NNN-*` files) is altered by this feature — verifiable via
  `git diff` showing changes scoped only to the files FR-001 through
  FR-008/FR-010 name.
- **SC-006**: A reader of the corrected README's build-process section
  sees only `specjedi-*` commands named — verifiable by confirming zero
  remaining `/speckit-*` mentions in that section.

## Assumptions

- Scope is exactly what the maintainer confirmed: retire the two
  `agent-context` hooks (User Story 1), remove the 11 vendored
  `speckit-*` skills (User Story 2), and correct documentation that
  would otherwise become inaccurate (User Story 3). It does not include
  building a `specjedi-taskstoissues` product feature (explicitly
  deferred per specs/044's own Dual-Value Distinction) or any other new
  capability — this is a removal-and-correction feature, not an
  expansion.
- `.specify/extensions/agent-context/`'s underlying extension package
  is left in place (not deleted) — only the `speckit-*` skill that
  dispatched to it and this repository's own hook registrations are
  removed, per the Edge Cases' reasoning.
- Going forward, this repository's own SDD pipeline for its own
  development uses `specjedi-*` exclusively — the same tool this
  project ships to its end users, closing the "eat your own dog food"
  loop `specs/044`/`specs/047` assessed and prepared for.
