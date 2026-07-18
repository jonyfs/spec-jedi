# Feature Specification: Whole-Project Constitution Coverage Audit

**Feature Branch**: `043-constitution-coverage-audit`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "verificar se toda constituição está ok e coberta neste projeto" (verify that the entire constitution is OK and covered in this project)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Whole-project conformity verdict (Priority: P1)

A maintainer wants a single, trustworthy answer to "is my constitution
actually implemented, everywhere, right now?" — not just "did the last
PR follow it." They run this audit and get, for every one of the 22 Core
Principles plus the Distribution & Ecosystem Standards and Development
Workflow sections, a verdict evaluated against the **entire current
project** (every shipped feature, every script, every CI job on the
current branch's HEAD) — never scoped to a single diff or pull request.

**Why this priority**: This is the entire point of the request — without
a whole-project verdict, the maintainer has no way to distinguish "the
last PR was compliant" (already answered by `specjedi-govcheck`) from
"the constitution as a whole is actually covered." Nothing else in this
feature matters without this.

**Independent Test**: Can be fully tested by running the audit against
this repository's current `main` branch and confirming every one of the
22 principles plus the two cross-cutting sections receives an explicit
verdict, each backed by a named, checkable piece of evidence.

**Acceptance Scenarios**:

1. **Given** the current state of the whole repository, **When** the
   audit runs, **Then** every Core Principle (I-XXII) plus Distribution &
   Ecosystem Standards and Development Workflow receives exactly one of
   three verdicts: Not Applicable, Compliant, or Non-Compliant.
2. **Given** a principle marked Compliant or Non-Compliant, **When** the
   verdict is reported, **Then** it names a specific, checkable piece of
   evidence (a file path, script name, or CI job name) — never a vague
   assertion.
3. **Given** a confirmed conflict between the actual project state and
   the constitution's own text, **When** it is found, **Then** it is
   marked CRITICAL regardless of how minor the maintainer might judge it.
4. **Given** the audit has run, **When** the maintainer reviews the
   report, **Then** it is presented as one consolidated view spanning all
   principles at once, not fragmented per feature or per prior PR.

---

### User Story 2 - Traceability drift detection (Priority: P2)

A maintainer knows this project already keeps a running index
(`references/principle-traceability.md`) mapping each principle to the
mechanism that implements it — and knows from direct experience that this
index has gone stale before (a mechanism gets renamed or removed, and the
index still claims the old one exists). This story confirms every claim
in that index still holds against the real, current project, and flags
any principle with no index entry at all as an undocumented gap.

**Why this priority**: P2 — valuable and directly requested ("coberta"
implies verified, not just asserted), but User Story 1's whole-project
verdict is useful on its own even before this cross-check exists.

**Independent Test**: Can be fully tested by deliberately renaming or
deleting a file that a traceability entry cites as evidence, then
confirming the audit flags that specific entry as stale — no other setup
required.

**Acceptance Scenarios**:

1. **Given** a traceability entry citing a mechanism, **When** that
   mechanism no longer exists or no longer does what's claimed, **Then**
   the audit flags that entry as stale, naming what was checked and what
   was actually found.
2. **Given** a Core Principle with no corresponding entry in the
   traceability index at all, **When** the audit runs, **Then** that
   absence is reported explicitly as an undocumented-coverage gap, never
   silently skipped.

---

### Edge Cases

- What happens when the constitution has been amended more recently than
  the traceability index was last updated? Reported as a drift finding
  (User Story 2), not a fatal error — this has happened for real in this
  project's own history.
- What happens when two principles' own texts conflict with each other
  (e.g., a newer amendment contradicts an older one still in force)?
  Marked CRITICAL, same as any other confirmed constitution conflict.
- What happens when a cited mechanism is a process/convention rather than
  code (e.g., "enforced by reviewer judgment, no automated check")? Still
  evaluated on the same three-state scale — a documented, deliberate
  process gap is Compliant if the constitution itself accepts that
  enforcement level; it is not automatically Non-Compliant just because
  no code exists.
- What happens if the audit finds a principle the constitution itself no
  longer lists (removed by a later amendment) still referenced somewhere
  in the project? Reported as a stale reference, not evaluated as if it
  were still a live principle.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The audit MUST evaluate every Core Principle (I-XXII) plus
  the Distribution & Ecosystem Standards and Development Workflow
  sections against the complete current state of the project — never
  scoped to a single diff, branch comparison, or pull request.
- **FR-002**: Each principle MUST receive exactly one of three verdicts:
  Not Applicable, Compliant, or Non-Compliant.
- **FR-003**: Every Compliant or Non-Compliant verdict MUST cite specific,
  checkable evidence (a file path, script name, or CI job name) — never a
  vague or unverifiable assertion.
- **FR-004**: The audit MUST cross-check every evaluated principle against
  its corresponding entry (if any) in `references/principle-traceability.md`,
  flagging any discrepancy between what that index claims and what
  actually exists in the project today.
- **FR-005**: Any Core Principle with no corresponding entry in the
  traceability index MUST be flagged explicitly as an undocumented
  coverage gap — never silently omitted from the report.
- **FR-006**: Any confirmed conflict between the actual project state and
  the constitution's own text MUST be marked CRITICAL, regardless of
  perceived severity.
- **FR-007**: The audit MUST be strictly read-only — it MUST NOT
  automatically edit the constitution, the traceability index, or any
  project source file as a side effect of running.
- **FR-008**: The final report MUST present all evaluated principles in a
  single, consolidated view — never fragmented per feature, per prior PR,
  or per session.
- **FR-009**: When a principle is Non-Compliant or has an undocumented
  coverage gap, the report MUST suggest a concrete next step (e.g., which
  file to update, which follow-up work to open) — never leave the
  maintainer without direction.

### Key Entities *(include if feature involves data)*

- **Constitution Principle**: one of the 22 Core Principles or the two
  cross-cutting sections (Distribution & Ecosystem Standards, Development
  Workflow) as currently defined in `.specify/memory/constitution.md`.
- **Coverage Verdict**: the three-state outcome (Not Applicable /
  Compliant / Non-Compliant) this audit assigns to a principle, plus an
  optional CRITICAL severity flag.
- **Traceability Entry**: the existing record in
  `references/principle-traceability.md` for a principle — its claimed
  implementing mechanism and status as last documented.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A single audit run produces an explicit verdict for 100% of
  the constitution's principles — no principle is left unevaluated.
- **SC-002**: Every Compliant/Non-Compliant verdict is backed by evidence
  a maintainer can independently confirm in under one minute, without
  re-investigating from scratch.
- **SC-003**: 100% of discrepancies between the traceability index and
  the real, current project state are surfaced — no stale claim passes
  through unnoticed.
- **SC-004**: Running this audit eliminates the need for a maintainer to
  manually re-read all 22 principles one-by-one to confirm coverage — the
  audit fully substitutes for that manual review.

## Assumptions

- This audit reuses the same three-state taxonomy (Not Applicable /
  Compliant / Non-Compliant) and CRITICAL-severity convention that
  `specjedi-govcheck` already established, for consistency with this
  project's existing compliance vocabulary — no new taxonomy is
  introduced.
- The scope is the complete repository tree at the current branch's HEAD,
  never a diff against `main` or a specific pull request — this is
  exactly the distinction that makes this feature complementary to, not
  redundant with, `specjedi-govcheck`'s existing per-PR/per-branch check.
- `references/principle-traceability.md` remains the starting reference
  for "where to look" for each principle's implementation, but this audit
  verifies those claims rather than trusting them at face value.
- This audit runs on demand (a maintainer explicitly requests a coverage
  report), not as an automatic hook on every PR — that per-PR gating role
  already belongs to `specjedi-govcheck`.
- Fixing any Non-Compliant verdict or documentation gap this audit finds
  is follow-up work the maintainer decides on, not an action this audit
  performs automatically.
