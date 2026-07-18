---

description: "Task list for specs/044-speckit-parity-audit"
---

# Tasks: `specjedi-*`/`speckit-*` Parity Audit & Internal Migration Readiness

**Input**: Design documents from `/specs/044-speckit-parity-audit/`

**Prerequisites**: plan.md, spec.md, research.md (all present; no
data-model.md/contracts/quickstart.md — see plan.md's Project Structure)

**Tests**: N/A — this feature produces one Markdown deliverable, not
code (plan.md Testing). Verification is structural: every `speckit-*`
command appears in the ledger (SC-001, checkable by row count), every
finding cites evidence (SC-002).

**Organization**: Tasks are grouped by user story (US1 = P1, US2 = P2)
per spec.md's priorities. research.md already contains the real,
evidence-based comparison (done during planning, since the comparison
itself is this feature's central technical work) — these tasks present
that work as the standalone `PARITY-LEDGER.md` deliverable, they do not
redo the investigation.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different sections, no shared state)
- **[Story]**: US1 or US2 per spec.md
- File paths are exact, per plan.md's Project Structure

---

## Phase 1: Setup

**Purpose**: Confirm the source data (research.md's findings) is still
current before publishing it as a standalone deliverable.

- [X] T001 Re-verify research.md's command enumeration against a fresh
  `ls .claude/skills/ | grep -E 'speckit-|specjedi-'` — confirm no
  `speckit-*` or `specjedi-*` skill was added/removed since planning that
  would change the ledger's row count.

---

## Phase 2: Foundational

**Purpose**: N/A for this feature — there is no shared code or contract
between the two user stories beyond research.md's already-completed
findings, which both stories present rather than derive independently.
Proceeding directly to User Story 1.

---

## Phase 3: User Story 1 - Functional parity ledger (Priority: P1) 🎯 MVP

**Goal**: Every one of the 11 `speckit-*` commands is matched to a
`specjedi-*` equivalent or an explicitly named gap, backed by real
evidence from each skill's own described behavior.

**Independent Test**: Confirm the ledger's 11 rows match research.md
Decision 2's findings exactly, and that every Partial Parity/No
Equivalent row cites the specific behavior checked.

### Implementation for User Story 1

- [X] T002 [US1] Create `specs/044-speckit-parity-audit/PARITY-LEDGER.md`
  with a self-contained opening paragraph (no assumed prior context)
  stating the deliverable's purpose per spec.md's User Story 1.
- [X] T003 [US1] Transcribe research.md Decision 2's 11-row parity table
  into the deliverable verbatim — Full Parity (8 rows: specify, clarify,
  plan, tasks, analyze, checklist, constitution, converge), Partial
  Parity (1 row: implement), No Equivalent (2 rows: taskstoissues,
  agent-context-update) — each with its cited evidence intact, satisfying
  FR-002/FR-003/SC-001/SC-002.
- [X] T004 [P] [US1] Transcribe research.md Decision 3's list of 16
  `specjedi-*`-only commands into the deliverable as its own subsection,
  satisfying FR-005 (reported as added capability, not a gap).

**Checkpoint**: The deliverable's parity ledger section is complete and
matches research.md's findings exactly — independently readable and
correct even before the recommendation section exists.

---

## Phase 4: User Story 2 - Internal migration readiness recommendation (Priority: P2)

**Goal**: A definitive, evidence-backed yes/no on migration readiness,
with every blocker paired with a concrete next step.

**Independent Test**: Confirm every point in the recommendation cites a
specific finding from User Story 1's ledger, and every blocker has a
named next step.

### Implementation for User Story 2

- [X] T005 [US2] Transcribe research.md Decision 4's finding (the
  `.specify/extensions.yml` hook-dispatch gap) into its own clearly
  labeled subsection, satisfying FR-006.
- [X] T006 [US2] Transcribe research.md Decision 5's recommendation table
  (three blockers, each with a "needed to migrate?" verdict and a
  concrete next step) into the deliverable, satisfying FR-007/FR-008/
  SC-003/SC-004. Depends on T003, T005 (the recommendation cites both).
- [X] T007 [US2] Write the deliverable's opening summary (per plan.md's
  Implementation notes) surfacing the three recommended action items
  prominently, ahead of the detailed tables, so a maintainer gets the
  answer before the evidence.

**Checkpoint**: The deliverable is complete end-to-end — ledger,
added-capability list, structural blocker, and recommendation with
next steps, each traceable back to research.md's original findings.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency pass before treating the deliverable as
done.

- [X] T008 Cross-check every claim in `PARITY-LEDGER.md` against
  research.md line-by-line — confirm nothing was altered, summarized
  lossily, or introduced during transcription (T003-T007) that wasn't
  already evidenced during planning.
- [X] T009 Confirm the deliverable distinguishes, for every finding,
  "blocks internal migration" from "would also be a shippable product
  feature" (spec.md's own Edge Case) — explicit for the
  `speckit-taskstoissues` finding specifically, since that's the one
  research.md flags as having potential dual value.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: N/A — skipped, no shared code/contract.
- **User Story 1 (Phase 3)**: Depends on Setup. Independently complete
  and readable on its own (MVP).
- **User Story 2 (Phase 4)**: Depends on User Story 1's ledger (T003)
  existing to cite.
- **Polish (Phase 5)**: Depends on both user stories being complete.

### Parallel Opportunities

- T004 (added-capability list) can be written in parallel with T003
  (parity table) — independent subsections of the same new file.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 3: User Story 1
3. **STOP and VALIDATE**: Confirm the 11-row ledger is complete and
   evidenced — this alone answers "does specjedi-* cover speckit-*'s
   cases?" even before the migration recommendation exists
4. This satisfies SC-001/SC-002 on its own

### Incremental Delivery

1. Setup → source data re-verified current
2. User Story 1 → ledger complete → MVP (parity question answered)
3. User Story 2 → recommendation complete → full feature (migration
   question answered)
4. Polish → consistency pass, dual-value distinction confirmed

---

## Notes

- This feature produces one document; "tasks" are its sections in
  dependency order, not independent code modules
- No CI job, no test framework — verification is a line-by-line
  cross-check against research.md's already-evidenced findings (T008)
- Commit once the deliverable is complete, not per section
