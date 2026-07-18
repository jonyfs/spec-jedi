---

description: "Task list for rewriting README.md's substantive prose for objectivity and evidence-based specjedi-*/speckit-* benefits"
---

# Tasks: README Objectivity & Evidence-Based Benefits Rewrite

**Input**: Design documents from `/specs/046-readme-benefits-rewrite/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md

**Tests**: Not applicable — this is a documentation-only feature (no code, no automated test suite; verification is the manual citation-check/content-preservation/read-through checks described in plan.md's Testing section).

**Organization**: Tasks are grouped by user story. Because every task
edits the same file (`README.md`), tasks within a phase are **not**
parallelizable against each other — only the baseline-capture task
(different file) and the fact-verification task (no file write) can
run without waiting on a `README.md` edit.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

## Path Conventions

Single repository, documentation-only. All paths are repo-root-relative.

---

## Phase 1: Setup

**Purpose**: Capture the pre-change baseline needed to prove SC-005 (zero fact/content loss) once the rewrite is done.

- [ ] T001 Capture the pre-feature baseline: badge count, harness-table row count, code-block count, and the exact byte range/text of the "How Spec Jedi builds itself, in comic form" section and the opening epigraph line in the current `README.md`, saved to `specs/046-readme-benefits-rewrite/baseline-facts.md` (scratch reference for T017/T018, not a shipped doc)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Re-verify every number this feature will cite or restate against current project state before any section is rewritten — all three user stories depend on writing correct, current facts, not carried-forward stale ones (FR-007).

**⚠️ CRITICAL**: No user story task in Phase 3+ may state a count or ratio until this phase confirms it against live project state.

- [ ] T002 Re-verify current facts against live project state and record them in `specs/046-readme-benefits-rewrite/baseline-facts.md` alongside T001's snapshot: total `specjedi-*` skill count (`ls .claude/skills/ | grep -c specjedi-`), total skill count including `speckit-*`, the exact parity ratio and 16-skill count from `specs/044-speckit-parity-audit/PARITY-LEDGER.md`, harness count from the current harness table, and the current Constitution version from `.specify/memory/constitution.md`

**Checkpoint**: Every number the rewrite will state is confirmed current — user story work can now begin.

---

## Phase 3: User Story 1 - Understand what specjedi-* actually does (Priority: P1) 🎯 MVP

**Goal**: A new reader understands, from the opening sections alone, what SDD is and what `specjedi-*` concretely does.

**Independent Test**: Give the rewritten opening sections to a reader with no prior context; confirm they can name the four core artifacts and 3+ real skills, and correctly state `specjedi-*` is a competitor to `speckit-*`, without opening a linked doc.

### Implementation for User Story 1

- [ ] T003 [US1] Rewrite `README.md`'s "What Is Spec-Driven Development?" section: tighten the existing prose so the four core artifacts (constitution, spec, plan, tasks) and their producing `specjedi-*` skills are named concretely in the text itself, not only implied by the Mermaid diagram beneath it — keep the existing diagram unchanged (depends on T001, T002)
- [ ] T004 [US1] Rewrite `README.md`'s "How Spec Jedi Implements SDD" opening paragraphs: state plainly, with the current verified skill count (T002), that all pipeline stages are shipped and name at least three real `specjedi-*` skills inline — remove any adjective describing the pipeline ("genuine," "real," used as unsupported emphasis) that isn't immediately followed by the citation/evidence already present in this section (depends on T003)
- [ ] T005 [US1] Manually verify User Story 1's Acceptance Scenarios against the rewritten sections: confirm a first-time read names the four artifacts, 3+ skills, and correctly distinguishes `specjedi-*` from `speckit-*` (depends on T004)

**Checkpoint**: User Story 1 is independently testable — a new reader can pass both Acceptance Scenarios from the opening sections alone.

---

## Phase 4: User Story 2 - See evidence-based benefits over speckit-* (Priority: P2)

**Goal**: A reader deciding between `specjedi-*` and `speckit-*` sees concrete, sourced comparison facts.

**Independent Test**: Pick any benefit claim in the new comparison content and verify it against `specs/044-speckit-parity-audit/PARITY-LEDGER.md` directly.

### Implementation for User Story 2

- [ ] T006 [US2] Add a new comparison subsection under "How Spec Jedi Implements SDD" in `README.md` stating the exact parity ratio (8/11 full parity, 1/11 favorable divergence, 2/11 no equivalent, both already resolved) with a relative link to `specs/044-speckit-parity-audit/PARITY-LEDGER.md` — per research.md Decision 1, cite the ledger rather than restating its table (depends on T004, T002)
- [ ] T007 [US2] In the same subsection, state the verified count (T002) of `specjedi-*`-only skills with no `speckit-*` counterpart (16, per the ledger) as a concrete benefit sentence, citing the same ledger (depends on T006)
- [ ] T008 [US2] In the same subsection, state the one favorable-divergence claim (`specjedi-implement`'s trunk-based PR discipline vs. `speckit-implement`'s silence on git workflow) using the ledger's own worded verdict — no stronger or weaker claim than the ledger states (depends on T006)
- [ ] T009 [US2] Manually verify User Story 2's Acceptance Scenarios: confirm the parity ratio, the 16-skill count, and the favorable-divergence claim each match their cited source exactly (depends on T007, T008)

**Checkpoint**: User Stories 1 AND 2 both work independently — the comparison content is fully sourced and checkable on its own.

---

## Phase 5: User Story 3 - Trust every claim in every section (Priority: P3)

**Goal**: Every remaining section holds to the same objectivity standard, while Constitution Principle XII's required voice remains intact.

**Independent Test**: Scan every remaining section for unverifiable superlatives; confirm the Honest assessment section still states a genuine limitation; confirm at least one genuine Star Wars-flavored reference remains.

### Implementation for User Story 3

- [ ] T010 [US3] Revise `README.md`'s "Who this is for" section: keep its scope, remove or cite any unsupported claim (depends on T005, T009 — runs after US1/US2 content exists so the whole document's tone is consistent)
- [ ] T011 [US3] Revise `README.md`'s "Prerequisites" section, re-verifying any tool/version claim against current project state (depends on T010)
- [ ] T012 [US3] Revise `README.md`'s "Installation" section, re-verifying the install command and harness-detection description against current `scripts/bootstrap-install.sh`/`.ps1` behavior (depends on T011)
- [ ] T013 [US3] Revise `README.md`'s "Supported harnesses" section and table: re-verify the harness count (T002) and confirm every row's status claim still matches current install-script behavior; replace any unsupported adjective in the surrounding prose with a citation or number (depends on T012)
- [ ] T014 [US3] Revise `README.md`'s "Honest assessment" section: sharpen objectivity while explicitly confirming at least one genuine current limitation remains stated alongside the advantages (Acceptance Scenario 2) (depends on T013)
- [ ] T015 [US3] Revise `README.md`'s "Contributing" section for objectivity, re-verifying its description of the CI/PR process against `.github/workflows/validate.yml`'s actual current jobs (depends on T014)
- [ ] T016 [US3] Revise `README.md`'s "License" section for objectivity — confirm the plain-language MIT summary still matches `LICENSE`'s actual terms (depends on T015)
- [ ] T017 [US3] Confirm the "How Spec Jedi builds itself, in comic form" section and the opening epigraph line are byte-for-byte unchanged from T001's baseline capture (FR-006) (depends on T016)

**Checkpoint**: All user stories are independently functional — every section in the document meets the same objectivity bar.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Whole-document verification spanning all three user stories.

- [ ] T018 Grep the final `README.md` for common marketing superlatives ("the best," "revolutionary," "seamless," "effortless," and similar); confirm every remaining match carries a citation, a number, or an explicit qualifier (SC-002) (depends on T017)
- [ ] T019 Confirm every internal `#anchor` and relative-link target the file uses still resolves after restructuring (SC-006) (depends on T017)
- [ ] T020 Run the before/after content-preservation check against T001's baseline: confirm zero badges, harness-table rows, or code blocks were lost, and the comic section/epigraph match byte-for-byte (SC-005) (depends on T001, T017)
- [ ] T021 Confirm at least one genuine Star Wars-flavored reference tied to a specific SDD concept remains in the document outside the untouched comic section (SC-004, Constitution Principle XII) (depends on T017)

**Checkpoint**: All success criteria (SC-001 through SC-006) are verified against the shipped document.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories (no number may be cited before it's re-verified).
- **User Stories (Phase 3-5)**: All depend on Foundational phase completion. Because every task edits the same `README.md`, stories run in priority order (P1 → P2 → P3) rather than in parallel, despite being independently testable in isolation.
- **Polish (Phase 6)**: Depends on all three user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) — no dependency on US2/US3 content.
- **User Story 2 (P2)**: Builds on US1's rewritten "How Spec Jedi Implements SDD" section (adds a subsection to it) — sequenced after US1 for this reason, though independently testable once written.
- **User Story 3 (P3)**: Touches sections after US1/US2's content, sequenced last so the whole document's tone is consistent by the time of the final objectivity pass.

### Parallel Opportunities

None within a user story — every implementation task edits `README.md` (same-file conflict, per the template's own "avoid cross-task same-file conflicts" guidance). T001 (baseline capture) and T002 (fact verification) both precede any `README.md` edit and touch different files (`baseline-facts.md` only), so they are the only two tasks not blocked by a `README.md` write — but T002 still logically follows T001 in this task list for clarity.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (re-verify all numbers)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Give the rewritten opening sections to a reader with no prior context; confirm Acceptance Scenarios 1-2 pass
5. Continue to User Story 2 once validated

### Incremental Delivery

1. Complete Setup + Foundational → verified numbers ready
2. Add User Story 1 → validate independently (MVP: reader understands what specjedi-* does)
3. Add User Story 2 → validate independently (evidence-based comparison is checkable)
4. Add User Story 3 → validate independently (whole-document objectivity + voice preserved)
5. Complete Polish phase → all Success Criteria verified

## Notes

- [Story] label maps task to specific user story for traceability.
- No task in this feature is parallelizable against another `README.md` edit — this is expected and documented, not an oversight (see Parallel Opportunities above).
- Commit after each user story phase, not after every task, matching this project's own trunk-based workflow (Constitution Principle X) — the PR opens once all phases are complete, per `specjedi-implement`.
- Avoid: touching the comic-panel section or the opening epigraph line (T017 exists specifically to confirm this didn't happen).
