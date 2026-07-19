---

description: "Task list for specs/050-reference-integrity-hooks"
---

# Tasks: Skill Reference Integrity & Hook Enablement

**Input**: Design documents from `/specs/050-reference-integrity-hooks/`

**Tests**: No CI job. Verification: `scripts/validate.sh` + a manual
re-sweep confirming zero missing `references/*.md` citations.

## Phase 1: User Story 1 - No skill points to a reference file that doesn't exist (P1) 🎯 MVP

- [x] T001 [US1] Write `references/constitution-mechanics.md`: exact
  Sync Impact Report format, dependent-template propagation checklist,
  validation steps (FR-002).
- [x] T002 [US1] Write `references/aitmpl-browsing-playbook.md`:
  concrete aitmpl.com URL patterns and GitHub source-tree structure per
  category (FR-002).
- [x] T003 [US1] Re-run the original grep sweep; confirm zero missing
  `references/*.md` files remain (SC-001).

**Checkpoint**: User Story 1 independently complete and verifiable.

## Phase 2: User Story 2 - See a useful hook example (P2)

- [x] T004 [US2] Write `.specify/extensions.yml.example`: hook proposals
  for a meaningful subset of pipeline stages, each `command` naming a
  real project script/skill (FR-003/004), explicit inactive-template
  header (FR-005).

**Checkpoint**: User Story 2 independently complete.

## Phase 3: User Story 3 - Durable reference-integrity check (P3)

- [x] T005 [US3] Amend `specjedi-skill-review`'s Step 2: add the
  reference-existence check, excluding fenced-code-block occurrences
  (FR-006/007/008).
- [x] T006 [US3] Add a Format table row for the new check dimension.
- [x] T007 Confirm `specjedi-skill-review`'s own token count stays well
  under the 5,000 hard cap after the addition.

**Checkpoint**: All three user stories complete.

## Phase 4: Polish

- [x] T008 Confirm `scripts/validate.sh` passes.

## Dependencies

- Phase 1, 2, 3 are independent of each other — no shared files.
- Phase 4 depends on all three.
