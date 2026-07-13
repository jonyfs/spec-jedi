# Tasks: SDD Explainer + How Spec Jedi Skills Help

**Input**: Design documents from `/specs/030-sdd-documentation/`

**Tests**: Principle VI exemption (pure documentation) per plan.md.

---

## Phase 1: `what-is-sdd.md` (US1)

- [X] T001 [US1] Write `references/what-is-sdd.md`: problem statement,
      four core artifacts, phase sequence, contrast with code-first,
      why teams adopt it — zero `specjedi-*` references (FR-001/FR-002).

## Phase 2: `specjedi-and-sdd.md` (US2)

- [X] T002 [US2] Write `references/specjedi-and-sdd.md`'s activity→skill
      mapping table, each row grounded in a verified mechanism
      (FR-003).
- [X] T003 [US2] Write the "Genuine contributions" section (≥3 items,
      FR-004), reusing `honest-assessment.md`'s existing verified claims.

## Phase 3: Integration

- [X] T004 Add both documents' links to `README.md`.

## Phase 4: Polish

- [X] T005 Grep-verify `what-is-sdd.md` has zero `specjedi-` references
      (SC-001); verify every activity has a mapping row (SC-002); verify
      every citation resolves (SC-003).
- [X] T006 Run `scripts/validate.sh`; confirm PASSED.
