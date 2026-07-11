# Feature Specification: `specjedi-govcheck`

**Feature Branch**: `013-specjedi-govcheck`

**Created**: 2026-07-11

**Status**: Draft

## Clarifications

### Session 2026-07-11

Run via the actual `/speckit-clarify` skill, one targeted question,
self-resolved per the maintainer's standing instruction to proceed
automatically and document the reasoning rather than pause.

- Q: Should `specjedi-implement` proactively self-invoke
  `specjedi-govcheck` right before opening a PR (mirroring
  `specjedi-plan`→`specjedi-security`'s proactive contract), and if so,
  should a CRITICAL finding block the PR from opening? → A: Yes,
  proactively self-invoke right before step 7 (PR opening) — unlike
  `specjedi-release`'s check (which has no comparable urgency), the
  Development Workflow section makes governance-principle compliance a
  literal MUST for every review, the same class of "real cost to missing
  it" that made `specjedi-security`'s proactive trigger the right call.
  However, a CRITICAL finding MUST NOT block the PR from opening —
  `specjedi-implement`'s own existing Autonomous vs. confirm-first section
  already states PR-opening is autonomous, and Principle X's own design
  already designates the CI battery (`ci-gate`) as the actual merge-
  blocking mechanism, not any single skill's own judgment. `specjedi-
  govcheck` surfaces CRITICAL findings prominently in the PR-opening
  narration instead, giving the maintainer visibility without silently
  changing an already-established autonomy boundary.

**Input**: User description: "Build specjedi-govcheck, a skill that
produces a per-PR (or per-branch) governance compliance checklist against
all 20 Constitution Core Principles plus the Distribution & Ecosystem
Standards and Development Workflow sections -- strictly read-only,
reasoning per principle whether the current changeset is not-applicable,
compliant, or non-compliant, with any constitution conflict automatically
CRITICAL. This closes CHK005 from checklists/project-completeness.md: no
existing skill mechanizes the Development Workflow section's own
requirement that 'Code and content review MUST explicitly check
compliance with every Core Principle above before approval.'
specjedi-analyze checks one feature's spec/plan/tasks consistency;
specjedi-skill-review checks one skill's SKILL.md against Principle XIX
specifically; neither checks an actual PR/branch changeset against the
full principle set."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Get a per-principle compliance report for the current branch (Priority: P1)

A user is about to open a PR (or already has one open) and wants to know
whether their changeset complies with the constitution before review.
`specjedi-govcheck` diffs the current branch against `main` (or a named
open PR via `gh pr diff <N>`), reasons through each of the 20 Core
Principles plus the two cross-cutting sections, and reports each as
Not Applicable, Compliant, or Non-Compliant — never collapsing the three
into a single pass/fail.

**Why this priority**: The entire reason this skill exists — without it,
"review MUST explicitly check compliance with every Core Principle" stays
a standing instruction reviewers have to remember unaided, the exact gap
`checklists/project-completeness.md` CHK005 found.

**Independent Test**: Given a branch with real changes (e.g., a new `.sh`
script added without its `.ps1` counterpart), run `specjedi-govcheck` and
verify the report flags this specific Principle XIII violation by name,
while correctly marking unrelated principles (e.g., Principle XVI,
Mermaid diagrams) as Not Applicable since nothing in the diff touches
process documentation.

**Acceptance Scenarios**:

1. **Given** a branch whose diff touches only documentation with no
   script changes, **When** `specjedi-govcheck` runs, **Then** Principle
   XIII (cross-platform script pairing) is reported Not Applicable, not
   silently omitted or falsely marked compliant.
2. **Given** a branch that adds a new `.sh` script with no `.ps1`
   counterpart, **When** `specjedi-govcheck` runs, **Then** Principle
   XIII is reported Non-Compliant, naming the specific missing
   counterpart file.
3. **Given** a branch whose diff adds a new shipped capability but
   doesn't touch the README badge row, **When** `specjedi-govcheck` runs,
   **Then** the Distribution & Ecosystem Standards section is reported
   Non-Compliant if the new capability is genuinely badge-worthy, or
   Compliant if the badge row is unaffected — reasoning through which one
   applies rather than defaulting to either.

---

### User Story 2 - Any constitution conflict is automatically CRITICAL (Priority: P2)

A changeset directly contradicts a Core Principle (e.g., a commit made
directly to `main`, or a skill's write action taken without the
confirmation Principle VIII/XIX requires). `specjedi-govcheck` marks this
finding CRITICAL, with no severity downgrade regardless of how minor the
violation might seem.

**Why this priority**: Prevents the failure mode of a governance check
that exists but doesn't actually block anything — mirrors
`specjedi-analyze`'s own existing "any constitution conflict is
automatically CRITICAL" rule (Principle-conflict findings never get
diluted).

**Independent Test**: Construct a scenario with a clear constitution
conflict and verify the report marks it CRITICAL, not a lower severity.

**Acceptance Scenarios**:

1. **Given** a changeset that violates a Core Principle's MUST-level
   requirement, **When** `specjedi-govcheck` reports it, **Then** the
   finding's severity is CRITICAL unconditionally.

### Edge Cases

- The current branch has no diff against `main` (nothing to check): the
  skill reports this plainly rather than fabricating findings.
- A named PR number doesn't exist or isn't accessible via `gh pr diff`:
  the skill states this explicitly rather than silently falling back to
  the local branch diff without saying so.
- A principle's applicability itself is a judgment call (e.g., does a
  pure-prose documentation change touch Principle IX's validation
  battery?): the skill reasons through this explicitly before marking
  Not Applicable vs. Compliant, rather than defaulting to whichever is
  easier to justify.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-govcheck` MUST diff the current branch against
  `main` by default, or a named open PR's diff via `gh pr diff <N>` when
  a PR number is given.
- **FR-002**: `specjedi-govcheck` MUST assess every one of the 20 Core
  Principles plus the Distribution & Ecosystem Standards and Development
  Workflow sections, reporting each as Not Applicable, Compliant, or
  Non-Compliant — never omitting a principle from the report and never
  collapsing the three states into a binary pass/fail.
- **FR-003**: `specjedi-govcheck` MUST treat any confirmed constitution
  conflict as CRITICAL severity, with no downgrade for perceived
  minorness — mirroring `specjedi-analyze`'s existing rule.
- **FR-004**: `specjedi-govcheck` MUST NOT modify any file — strictly
  read-only, mirroring `specjedi-analyze`/`specjedi-skill-review`'s
  existing report-only boundary.
- **FR-005**: `specjedi-govcheck` MUST reference
  `references/principle-traceability.md` for each principle's known
  implementing mechanism rather than re-deriving that mapping inline.
- **FR-006**: `specjedi-govcheck` MUST name the specific evidence (file
  path, diff hunk, missing counterpart file) behind each Non-Compliant or
  CRITICAL finding — never a vague "this principle might be violated."
- **FR-007**: `specjedi-govcheck` MUST report plainly when the diff is
  empty or a named PR is inaccessible, rather than fabricating findings
  or silently falling back without saying so.
- **FR-008**: `specjedi-implement` MUST proactively self-invoke
  `specjedi-govcheck` immediately before opening a PR (resolved via
  Clarifications), surfacing any CRITICAL finding prominently in the
  PR-opening narration — but a CRITICAL finding MUST NOT block the PR
  from opening; PR-opening remains autonomous per `specjedi-implement`'s
  existing Autonomous vs. confirm-first section, and the CI battery
  remains the actual merge-blocking mechanism (Principle X).

### Key Entities

- **Governance report**: one `specjedi-govcheck` invocation's output — a
  per-principle table (all 20 principles + 2 cross-cutting sections) with
  status (N/A / Compliant / Non-Compliant), severity for any
  Non-Compliant finding, and the specific evidence behind it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Running `specjedi-govcheck` against a branch with a known,
  constructed Principle XIII violation (a `.sh` script with no `.ps1`
  counterpart) reproduces that exact finding by name.
- **SC-002**: Zero file modifications occur from any `specjedi-govcheck`
  invocation.
- **SC-003**: A report against a small, targeted diff (e.g., documentation
  only) marks the clear majority of principles Not Applicable rather than
  forcing every principle into Compliant/Non-Compliant.

## Assumptions

- This is its own feature cycle — `specjedi-govcheck` ships alone.
- `references/principle-traceability.md` (created this session) is
  assumed stable and current — this skill reads it, it doesn't maintain
  it independently.
- `gh` CLI availability is assumed for the named-PR mode (FR-001); the
  local-branch-diff mode has no such dependency.
