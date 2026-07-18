# Feature Specification: `specjedi-*`/`speckit-*` Parity Audit & Internal Migration Readiness

**Feature Branch**: `044-speckit-parity-audit`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "revise o funcionamento das skills specjedi para ver se está cobrindo todos os casos de speckit e se já considera substituir o uso de speckit neste projeto para specjedi" (review how the specjedi skills work to see whether they cover every speckit case, and whether it's already time to replace speckit's use in this project with specjedi)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Functional parity ledger between `specjedi-*` and `speckit-*` (Priority: P1)

This project maintains two parallel skill families: `speckit-*` (the
original Spec Kit pipeline commands, currently used to develop this
project itself — every `spec.md`/`plan.md`/`tasks.md` this repository has
ever produced, including this very one, was created with `speckit-*`) and
`specjedi-*` (the shipped product this project builds and distributes to
other projects). A maintainer needs a concrete, evidence-based answer to
"does `specjedi-*` actually cover everything `speckit-*` does, or are
there real gaps?" — not an assumption.

**Why this priority**: Every other decision in this feature depends on
having an accurate, current parity ledger first. Recommending a migration
without first confirming true functional coverage would risk silently
losing capability this project's own development workflow depends on.

**Independent Test**: Can be fully tested by comparing the complete
command list under both `speckit-*` and `specjedi-*`, and for every
`speckit-*` command actually exercised in this project's own history,
confirming whether a `specjedi-*` command exists that performs an
equivalent function — with each match or gap named explicitly, not
inferred from naming similarity alone.

**Acceptance Scenarios**:

1. **Given** the current set of `speckit-*` and `specjedi-*` skills
   installed in this repository, **When** the audit runs, **Then** every
   `speckit-*` command is matched to either a specific `specjedi-*`
   equivalent or an explicitly named gap — no command is left
   unaccounted for.
2. **Given** a `speckit-*` command with no obvious `specjedi-*`
   counterpart by name, **When** the audit evaluates it, **Then** it
   checks the command's actual described behavior (not just its name)
   before concluding a gap exists — a differently-named equivalent must
   not be misreported as missing.
3. **Given** a confirmed gap, **When** it is reported, **Then** the report
   states specifically what capability is missing and where in this
   project's own workflow that capability is currently used.

---

### User Story 2 - Internal migration readiness recommendation (Priority: P2)

Once the parity ledger exists, a maintainer wants a clear, actionable
recommendation: is this project ready to stop using `speckit-*` for its
own development and use `specjedi-*` instead, and if not yet, exactly
what stands in the way?

**Why this priority**: P2 — this recommendation is only trustworthy once
User Story 1's ledger exists; producing it first would be a guess dressed
up as an answer.

**Independent Test**: Can be fully tested by confirming the
recommendation cites, for every point it makes, a specific finding from
the User Story 1 ledger — not a general impression.

**Acceptance Scenarios**:

1. **Given** the completed parity ledger, **When** the recommendation is
   produced, **Then** it states plainly whether a full internal migration
   is currently safe, and if not, lists every specific blocking gap that
   must close first.
2. **Given** any blocking gap identified, **When** it is listed, **Then**
   the recommendation names a concrete next step to close it (e.g.,
   "build a `specjedi-*` equivalent," or "confirm this capability isn't
   actually needed internally") — never left as an open question with no
   path forward.
3. **Given** this project's own workflow relies on mechanisms outside the
   skill commands themselves (e.g., configuration that dispatches
   commands by name), **When** the recommendation is produced, **Then**
   it explicitly calls out whether those mechanisms would also need to
   change as part of any migration.

---

### Edge Cases

- What happens when a `speckit-*` command's behavior has diverged from
  its `specjedi-*` counterpart over time (both exist, but no longer do
  exactly the same thing)? Reported as a partial-parity finding, distinct
  from both "full match" and "no equivalent at all."
- What happens when a `specjedi-*` command exists that has no `speckit-*`
  counterpart at all? Noted as a capability this project's product has
  that the original tooling doesn't — informative context for the
  recommendation, not a gap to close.
- What happens if closing a specific gap would mean building
  product-facing functionality (shipped to `specjedi-*`'s end users) that
  isn't actually justified by this project's own internal needs alone?
  The recommendation must distinguish "needed to safely migrate
  internally" from "would also become a shippable feature," since these
  may call for different next steps.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The audit MUST enumerate every currently installed
  `speckit-*` command and every currently installed `specjedi-*` command
  in this repository.
- **FR-002**: For each `speckit-*` command, the audit MUST determine
  whether a `specjedi-*` command exists that performs an equivalent
  function, evaluated by actual described behavior — never by name
  similarity alone.
- **FR-003**: Every determination MUST be reported as one of three
  states: Full Parity (equivalent exists and matches), Partial Parity
  (equivalent exists but behavior has diverged), or No Equivalent (gap).
- **FR-004**: Every Partial Parity or No Equivalent finding MUST name the
  specific behavior that differs or is missing, and where in this
  project's own development workflow that behavior is currently relied
  upon.
- **FR-005**: The audit MUST also identify `specjedi-*` commands with no
  `speckit-*` counterpart, reporting them as this project's own added
  capability rather than treating the absence as any kind of gap.
- **FR-006**: The audit MUST identify whether any non-command mechanism
  (e.g., configuration that dispatches commands by name, hooks tied to a
  specific command family) would also require changes for a full internal
  migration to be possible.
- **FR-007**: Based on the completed ledger, the audit MUST produce an
  explicit recommendation: whether a full internal migration from
  `speckit-*` to `specjedi-*` is currently safe, and if not, the complete,
  itemized list of what blocks it.
- **FR-008**: Every blocking item in the recommendation MUST include a
  concrete next step to resolve it — never left unresolved with no
  suggested path forward.

### Key Entities *(include if feature involves data)*

- **Skill Command**: an individual `speckit-*` or `specjedi-*` command
  (e.g., `speckit-plan`, `specjedi-plan`) as currently installed in this
  repository, with its own described behavior.
- **Parity Finding**: the per-command verdict this audit assigns —
  Full Parity, Partial Parity, or No Equivalent — plus supporting evidence
  of what was compared.
- **Migration Blocker**: a specific, named reason a full internal
  migration is not yet safe, paired with a concrete next step to resolve
  it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of currently installed `speckit-*` commands receive an
  explicit parity finding — none are left uncompared.
- **SC-002**: Every Partial Parity or No Equivalent finding is
  specific enough that a maintainer can act on it without further
  investigation — no finding requires the maintainer to re-derive what
  was actually checked.
- **SC-003**: The final recommendation gives the maintainer a definitive
  yes/no on migration readiness, backed entirely by the ledger's own
  findings — no unsupported general impression.
- **SC-004**: If any blocking gap is found, 100% of them come with a
  concrete, actionable next step — none are left as an open question.

## Assumptions

- "Covering all speckit cases" is interpreted as functional/behavioral
  parity for the pipeline commands this project's own development
  actively exercises (specify, clarify, plan, tasks, implement, analyze,
  checklist, constitution, converge, and any supporting mechanism such as
  agent-context refresh or issue conversion) — not a demand that
  `specjedi-*` mirror `speckit-*`'s internal implementation line-for-line.
- This audit is a one-time assessment producing a ledger and a
  recommendation; it does not itself perform the migration (building any
  missing `specjedi-*` equivalent, or switching this project's own
  workflow over) — that is deliberately separate follow-up work the
  maintainer decides on based on the recommendation.
- The audit's scope is this repository's own internal development
  tooling choice (which command family it uses to build itself) — it
  does not evaluate or change what `specjedi-*` ships to other projects'
  end users, which is unaffected either way.
- Where a genuine capability gap is found and closing it would also
  benefit `specjedi-*`'s external users (not just this project's internal
  workflow), the recommendation notes that dual value explicitly, but
  scoping that as a shippable product feature (versus internal-only
  tooling) is a separate decision left to the maintainer, not decided by
  this audit.
