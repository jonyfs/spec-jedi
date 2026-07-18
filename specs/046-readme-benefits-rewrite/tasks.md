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

- [x] T001 Capture the pre-feature baseline: badge count, harness-table row count, code-block count, and the exact byte range/text of the "How Spec Jedi builds itself, in comic form" section and the opening epigraph line in the current `README.md`, saved to `specs/046-readme-benefits-rewrite/baseline-facts.md` (scratch reference for T017/T018, not a shipped doc)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Re-verify every number this feature will cite or restate against current project state before any section is rewritten — all three user stories depend on writing correct, current facts, not carried-forward stale ones (FR-007).

**⚠️ CRITICAL**: No user story task in Phase 3+ may state a count or ratio until this phase confirms it against live project state.

- [x] T002 Re-verify current facts against live project state and record them in `specs/046-readme-benefits-rewrite/baseline-facts.md` alongside T001's snapshot: total `specjedi-*` skill count (`ls .claude/skills/ | grep -c specjedi-`), total skill count including `speckit-*`, the exact parity ratio and skill-count-with-no-counterpart from `specs/044-speckit-parity-audit/PARITY-LEDGER.md`, harness count from the current harness table, and the current Constitution version from `.specify/memory/constitution.md`. **Finding**: the badge claims "25 shipped" skills (stale — verified 27) and the ledger's own "16 skills with no counterpart" prose is internally inconsistent with its own 18-item list (verified correct count: 18) — both corrected in this feature's citations, see baseline-facts.md's Discrepancy note.

**Checkpoint**: Every number the rewrite will state is confirmed current — user story work can now begin.

---

## Phase 3: User Story 1 - Understand what specjedi-* actually does (Priority: P1) 🎯 MVP

**Goal**: A new reader understands, from the opening sections alone, what SDD is and what `specjedi-*` concretely does.

**Independent Test**: Give the rewritten opening sections to a reader with no prior context; confirm they can name the four core artifacts and 3+ real skills, and correctly state `specjedi-*` is a competitor to `speckit-*`, without opening a linked doc.

### Implementation for User Story 1

- [x] T003 [US1] Rewrite `README.md`'s "What Is Spec-Driven Development?" section: tighten the existing prose so the four core artifacts (constitution, spec, plan, tasks) and their producing `specjedi-*` skills are named concretely in the text itself, not only implied by the Mermaid diagram beneath it — updated the diagram's own category counts too (4/5/9, not the stale 3/4/9) to sum to the verified 27 (depends on T001, T002)
- [x] T004 [US1] Rewrite `README.md`'s "How Spec Jedi Implements SDD" opening paragraphs: state plainly, with the current verified skill count (T002, "Twenty-seven"), that all pipeline stages are shipped and name at least three real `specjedi-*` skills inline — softened "genuine competitor... not a reskin wearing its robes" framing since the new comparison subsection (T006-T008) now backs the competitor claim with hard numbers instead of an assertion (depends on T003)
- [x] T005 [US1] Manually verify User Story 1's Acceptance Scenarios against the rewritten sections: confirms a first-time read names the four artifacts (constitution/spec/plan/tasks), 5 skills by name (constitution, specify, clarify, plan, tasks, implement, quick), and correctly distinguishes `specjedi-*` as a competitor installed alongside/instead of `speckit-*` (depends on T004)

**Checkpoint**: User Story 1 is independently testable — a new reader can pass both Acceptance Scenarios from the opening sections alone.

---

## Phase 4: User Story 2 - See evidence-based benefits over speckit-* (Priority: P2)

**Goal**: A reader deciding between `specjedi-*` and `speckit-*` sees concrete, sourced comparison facts.

**Independent Test**: Pick any benefit claim in the new comparison content and verify it against `specs/044-speckit-parity-audit/PARITY-LEDGER.md` directly.

### Implementation for User Story 2

- [x] T006 [US2] Add a new comparison subsection ("`specjedi-*` versus `speckit-*`, by the numbers") under "How Spec Jedi Implements SDD" in `README.md` stating the exact parity ratio (8/11 full parity, 1/11 favorable divergence, 2/11 no equivalent, both already resolved) with a relative link to `specs/044-speckit-parity-audit/PARITY-LEDGER.md` — per research.md Decision 1, cites the ledger rather than restating its table (depends on T004, T002)
- [x] T007 [US2] In the same subsection, states the verified count (T002) of `specjedi-*`-only skills with no `speckit-*` counterpart — **18**, not the ledger's own stale "16" prose (verified against the ledger's own 18-item enumerated list plus independent arithmetic, see baseline-facts.md) — named all 18 explicitly (depends on T006)
- [x] T008 [US2] In the same subsection, states the one favorable-divergence claim (`specjedi-implement`'s trunk-based PR discipline vs. `speckit-implement`'s silence on git workflow) using the ledger's own worded verdict — no stronger or weaker claim than the ledger states (depends on T006)
- [x] T009 [US2] Manually verified User Story 2's Acceptance Scenarios: parity ratio (8/11) and favorable-divergence claim match the ledger exactly; the 18-skill count is the corrected, re-verified figure per FR-007 rather than the ledger's own stale 16 (depends on T007, T008)

**Checkpoint**: User Stories 1 AND 2 both work independently — the comparison content is fully sourced and checkable on its own.

---

## Phase 5: User Story 3 - Trust every claim in every section (Priority: P3)

**Goal**: Every remaining section holds to the same objectivity standard, while Constitution Principle XII's required voice remains intact.

**Independent Test**: Scan every remaining section for unverifiable superlatives; confirm the Honest assessment section still states a genuine limitation; confirm at least one genuine Star Wars-flavored reference remains.

### Implementation for User Story 3

- [x] T010 [US3] Reviewed `README.md`'s "Who this is for" section: no unsupported product claims present (describes reader pain points, not the product) — no change needed (depends on T005, T009)
- [x] T011 [US3] Reviewed `README.md`'s "Prerequisites" section against current project state — every claim (cross-platform CI, script pairing) already accurate — no change needed (depends on T010)
- [x] T012 [US3] Reviewed `README.md`'s "Installation" section against current `scripts/bootstrap-install.sh`/`.ps1` behavior — install command, `--harness` optionality, and the 17-harness-without-detection figure (20 total − 3 auto-detected) all still accurate — no change needed (depends on T011)
- [x] T013 [US3] Reviewed `README.md`'s "Supported harnesses" section and table: harness count (20, T002) and the 4-native/14-bridge/2-free-riding breakdown all still accurate and already citation-backed — no change needed (depends on T012)
- [x] T014 [US3] Revised `README.md`'s "Honest assessment" section: fixed two stale claims — constitution version (v1.24.0 → verified v1.27.0) and "no release has been cut yet" (three releases have since shipped: v0.1.0, v0.1.1, v0.2.0) — replaced the now-false limitation with a genuine current one (10 localized READMEs currently flagged out of sync by `scripts/validate.sh`), keeping Acceptance Scenario 2's "at least one real limitation stated" requirement satisfied with an accurate claim instead of a stale one (depends on T013)
- [x] T015 [US3] Reviewed `README.md`'s "Contributing" section against `.github/workflows/validate.yml`'s actual current jobs — CI/PR process description still accurate — no change needed (depends on T014)
- [x] T016 [US3] Reviewed `README.md`'s "License" section against `LICENSE`'s actual terms — plain-language MIT summary still accurate — no change needed (depends on T015)
- [x] T017 [US3] Confirmed the "How Spec Jedi builds itself, in comic form" section (lines 141-248) and the opening epigraph line are byte-for-byte unchanged from T001's baseline capture (FR-006) — verified via diff against baseline-facts.md's recorded range (depends on T016)

**Checkpoint**: All user stories are independently functional — every section in the document meets the same objectivity bar.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Whole-document verification spanning all three user stories.

- [x] T018 Grepped the final `README.md` for common marketing superlatives ("the best," "revolutionary," "seamless," "effortless," "amazing," "world-class," "cutting-edge," "game-changer/ing," "best-in-class," "unparalleled") — zero matches (SC-002 satisfied) (depends on T017)
- [x] T019 Confirmed every internal `#anchor` reference (`#how-spec-jedi-implements-sdd`, `#installation`, `#supported-harnesses`) resolves against an actual heading in the restructured document (SC-006 satisfied) (depends on T017)
- [x] T020 Ran the before/after content-preservation check against T001's baseline: 10/10 badges, 20/20 harness-table rows, 8/8 code blocks — zero lost; the comic section and epigraph confirmed byte-for-byte unchanged via `git diff` (T017) (SC-005 satisfied) (depends on T001, T017)
- [x] T021 Confirmed genuine Star Wars-flavored references remain outside the untouched comic section: the opening epigraph, the closing "🌌 *This is the way.*" line, and Principle XV/XII citations throughout (SC-004, Constitution Principle XII satisfied) (depends on T017)

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
