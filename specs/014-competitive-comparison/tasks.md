# Tasks: Competitive Comparison Table

**Input**: Design documents from `/specs/014-competitive-comparison/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's Technical
Context (pure documentation, no executable logic). `quickstart.md`'s scenarios
serve as the verification step instead, run in the Polish phase below.

**Organization**: Tasks are grouped by user story (spec.md priorities P1/P2/P3)
to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files/rows, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

Single new reference file (`references/competitive-comparison.md`) plus one
`README.md` edit — no `src/`/`tests/`/backend/frontend split applies, per
plan.md's Structure Decision.

---

## Phase 1: Setup

**Purpose**: Create the file this whole feature adds

- [X] T001 Create `references/competitive-comparison.md` with a title, one-line
      purpose statement, and an empty table skeleton (header row only, 11
      tool-name rows to be filled in Phase 3) — follow
      `references/genuine-contributions-log.md`'s existing header structure
      (title, short purpose paragraph citing the constitution principle it
      closes, then the table)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Extract the source-of-truth content every user story's table
cells depend on, before any row gets written

**⚠️ CRITICAL**: No table row (Phase 3) can be written accurately until this
extraction is done — writing rows from memory instead of this extraction is
exactly the kind of unverified claim Principle XX and this feature's own
FR-003 forbid

- [X] T002 Re-read `specs/001-specjedi-pipeline/research.md` end to end and
      extract, per tool, its Good/Poor summary and its explicit adopt/adapt/
      reject decision — working notes only (not committed to the repo), used
      directly by every T004-T014 task below

**Checkpoint**: Foundation ready — Phase 3 table-writing can begin

---

## Phase 3: User Story 1 - Prospective adopter compares tools at a glance (Priority: P1) 🎯 MVP

**Goal**: A reader with no prior exposure to `research.md` can identify, for
each of the 11 researched tools, at least one concrete way Spec Jedi differs
— using only `references/competitive-comparison.md`.

**Independent Test**: Open the file with no other context; confirm all 11
tool rows are present, each citing a real `research.md` finding (not an
invented one).

### Implementation for User Story 1

- [X] T003 [US1] Write the table header row in
      `references/competitive-comparison.md`: Tool | Category | What Spec
      Jedi Adopted | What Spec Jedi Rejected (and why) | Verifiable? — covers
      FR-004 (table format) and FR-005 (adopt/reject distinction)
- [X] T004 [US1] Fill the **spec-kit** (baseline) row in
      `references/competitive-comparison.md`, citing `research.md`'s
      "Baseline: GitHub spec-kit" section (depends on T002, T003)
- [X] T005 [P] [US1] Fill the **BMAD-METHOD** row in
      `references/competitive-comparison.md`, citing `research.md` §1
      (depends on T002, T003)
- [X] T006 [P] [US1] Fill the **OpenSpec** row in
      `references/competitive-comparison.md`, citing `research.md` §2
      (depends on T002, T003)
- [X] T007 [P] [US1] Fill the **Kiro** row in
      `references/competitive-comparison.md`, citing `research.md` §3
      (depends on T002, T003)
- [X] T008 [P] [US1] Fill the **Tessl** row in
      `references/competitive-comparison.md`, citing `research.md` §4
      (depends on T002, T003)
- [X] T009 [P] [US1] Fill the **Spec Kitty** row in
      `references/competitive-comparison.md`, citing `research.md` §5
      (depends on T002, T003)
- [X] T010 [P] [US1] Fill the **Superpowers** row in
      `references/competitive-comparison.md`, citing `research.md` §6
      (depends on T002, T003)
- [X] T011 [P] [US1] Fill the **GSD** row in
      `references/competitive-comparison.md`, citing `research.md` §7
      (depends on T002, T003)
- [X] T012 [P] [US1] Fill the **PRP** row in
      `references/competitive-comparison.md`, citing `research.md` §8
      (depends on T002, T003)
- [X] T013 [P] [US1] Fill the **Traycer** row in
      `references/competitive-comparison.md`, citing `research.md` §9,
      marking any non-verifiable cell (closed-source, philosophy-only
      evaluation) explicitly as "not verifiable" per spec.md's Edge Cases
      rather than guessing (depends on T002, T003)
- [X] T014 [P] [US1] Fill the **codemyspec.com** row in
      `references/competitive-comparison.md`, citing `research.md` §10 —
      note it's a cross-check/secondary signal, not a tool with its own
      adopt/reject mechanism, per `research.md`'s own framing (depends on
      T002, T003)
- [X] T015 [US1] Add a short "How to read this table" intro paragraph above
      the table in `references/competitive-comparison.md`, plus a "Genuine
      contributions" callout listing the capabilities `research.md` already
      names as unmatched by any of the 11 tools (depends on T004-T014 being
      complete so the intro accurately previews the finished table)

**Checkpoint**: `references/competitive-comparison.md` is complete and
independently readable — User Story 1 is fully satisfied on its own.

---

## Phase 4: User Story 2 - Maintainer keeps the comparison from going stale (Priority: P2)

**Goal**: A future maintainer knows exactly when and how to update this
document, rather than discovering it's stale by accident.

**Independent Test**: Read the maintenance note; confirm it names a concrete
trigger (a new `research.md` competitor entry, or a shipped feature that
closes a currently-claimed Spec-Jedi-only gap).

### Implementation for User Story 2

- [X] T016 [US2] Add a `## Maintenance` section to
      `references/competitive-comparison.md` stating the update trigger,
      mirroring `references/genuine-contributions-log.md`'s existing
      "Maintenance" section pattern exactly (depends on T001; independent of
      T004-T015's row content)

**Checkpoint**: The document states its own upkeep contract — User Story 2 is
satisfied independently of Phase 3's specific row content.

---

## Phase 5: User Story 3 - Reader discovers the comparison from the README (Priority: P3)

**Goal**: A reader starting from `README.md` alone finds the comparison
document within one click.

**Independent Test**: Starting from `README.md`, follow a link and land on
`references/competitive-comparison.md`.

### Implementation for User Story 3

- [X] T017 [US3] Add a link to `references/competitive-comparison.md` in
      `README.md`, placed near the existing "Supported harnesses" section
      (depends only on T001 — the file existing — not on Phase 3/4's
      content, so this can run in parallel with either)

**Checkpoint**: All three user stories are independently satisfied.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verify the whole feature per `quickstart.md`, and keep the
project's own bookkeeping (CHANGELOG, badge review) current

- [X] T018 [P] Run `quickstart.md` Scenario 1 (the citation-trace grep loop)
      against `references/competitive-comparison.md` and
      `specs/001-specjedi-pipeline/research.md`; fix any `FAIL` line before
      proceeding
- [X] T019 [P] Run `quickstart.md` Scenario 2 (`grep -q
      "competitive-comparison.md" README.md`); fix if it fails
- [X] T020 Run `quickstart.md` Scenario 3 (`bash scripts/validate.sh`) and
      confirm `validate.sh: PASSED`
- [X] T021 Add a new `## Unreleased` → `### Added` entry to `CHANGELOG.md`
      for `references/competitive-comparison.md`, per this project's
      existing changelog convention
- [X] T022 Review the README badge row per the Distribution & Ecosystem
      Standards section's "before opening any pull request" requirement —
      determine whether this feature warrants a new/updated badge (likely
      not, since it adds a reference doc rather than a shipped skill) and
      document that determination in the PR description. **Determination**:
      no badge change needed — Skills (23), Pipeline (9/9), Roadmap
      (12/12), and Languages (11) counts are all unaffected by adding a
      reference doc; none of them count `references/*.md` files.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup (T001) — BLOCKS all of Phase 3
- **User Story 1 (Phase 3)**: Depends on Foundational (T002) completion
- **User Story 2 (Phase 4)**: Depends only on Setup (T001) — independent of
  Phase 3's row content, can run in parallel with Phase 3
- **User Story 3 (Phase 5)**: Depends only on Setup (T001) — independent of
  Phase 3/4, can run in parallel with either
- **Polish (Phase 6)**: Depends on Phases 3, 4, and 5 all being complete
  (verification needs the finished document)

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational (Phase 2) only — no
  dependency on US2 or US3
- **User Story 2 (P2)**: Depends on Setup (Phase 1) only — genuinely
  independent of US1's row content, unlike most multi-story features where
  later stories build on earlier ones
- **User Story 3 (P3)**: Depends on Setup (Phase 1) only — genuinely
  independent of US1/US2

This feature's three user stories are unusually decoupled (all three touch
the same file, but not the same content) precisely because it's one small
document rather than a layered application — noted here rather than forcing
an artificial "US2 builds on US1" narrative that wouldn't be true.

### Parallel Opportunities

- T005-T014 (10 of the 11 tool rows) can all run in parallel once T002/T003
  are done — different table rows, no cross-dependencies
- Phase 4 (T016) and Phase 5 (T017) can both run in parallel with Phase 3
  once Setup (T001) is done
- T018/T019 (Polish verification) can run in parallel with each other

---

## Parallel Example: User Story 1

```bash
# Once T002 (research extraction) and T003 (table header) are done,
# launch all remaining tool rows together:
Task: "Fill the BMAD-METHOD row in references/competitive-comparison.md"
Task: "Fill the OpenSpec row in references/competitive-comparison.md"
Task: "Fill the Kiro row in references/competitive-comparison.md"
Task: "Fill the Tessl row in references/competitive-comparison.md"
Task: "Fill the Spec Kitty row in references/competitive-comparison.md"
Task: "Fill the Superpowers row in references/competitive-comparison.md"
Task: "Fill the GSD row in references/competitive-comparison.md"
Task: "Fill the PRP row in references/competitive-comparison.md"
Task: "Fill the Traycer row in references/competitive-comparison.md"
Task: "Fill the codemyspec.com row in references/competitive-comparison.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001)
2. Complete Phase 2: Foundational (T002) — CRITICAL, blocks Phase 3
3. Complete Phase 3: User Story 1 (T003-T015)
4. **STOP and VALIDATE**: open the file standalone, confirm all 11 rows
   read correctly with no invented claims
5. This alone is a shippable, valuable artifact — US2/US3 add polish, not
   core value

### Incremental Delivery

1. Setup + Foundational → the file exists, extraction notes ready
2. Add User Story 1 → the table itself, independently valuable (MVP)
3. Add User Story 2 → maintenance note, prevents future drift
4. Add User Story 3 → README link, makes it discoverable
5. Polish → verify via `quickstart.md`, update CHANGELOG, badge review

---

## Notes

- [P] tasks = different table rows or different files, no dependencies
- [Story] label maps task to specific user story for traceability
- No tests were requested; `quickstart.md`'s three scenarios are this
  feature's actual verification step, run in Phase 6
- Every T004-T014 task must cite a real `research.md` section — inventing a
  cell's content instead of sourcing it from T002's extraction is exactly
  the failure mode FR-003/SC-002 exist to prevent
- Commit after each phase (or after the parallel row-writing batch in Phase
  3), not after every single task — an 11-row table is one coherent unit of
  work for review purposes
