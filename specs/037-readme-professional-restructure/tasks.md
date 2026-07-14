---

description: "Task list for restructuring README.md as an SDD primer with a professional-but-themed voice"
---

# Tasks: Restructure README as an SDD Primer With a Professional-But-Themed Voice

**Input**: Design documents from `/specs/037-readme-professional-restructure/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, quickstart.md

**Tests**: Not applicable — this is a documentation-only feature (no code, no automated test suite; verification is the manual fact-preservation/read-through checks in quickstart.md).

**Organization**: Tasks are grouped by user story. Because nearly every
task edits the same file (`README.md`), most tasks within a phase are
**not** parallelizable against each other — only tasks touching a
different file (the two new reference docs, `CONTRIBUTING.md`) can run
alongside a `README.md` task.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

## Path Conventions

Single repository, documentation-only. All paths are repo-root-relative.

---

## Phase 1: Setup

**Purpose**: Capture the pre-change baseline needed to prove FR-008/SC-003 (zero fact loss) once the rewrite is done.

- [x] T001 Capture the pre-feature fact-preservation baseline: badge count, skill-table row count, harness-table row count, and a list of every code block in the current `README.md`, saved to `specs/037-readme-professional-restructure/baseline-facts.md` (scratch reference for T017, not a shipped doc)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create the relocation targets FR-009 requires before any `README.md` section can safely drop the content it currently holds — every user story phase links to or removes content in favor of these files, so they must exist first.

**⚠️ CRITICAL**: No `README.md` rewrite task in Phase 3+ may delete a section until its replacement destination from this phase exists.

- [x] T002 [P] Create `references/quickstart-guide.md` with the relocated 25-row skill catalog table, the skills mindmap Mermaid diagram, the pipeline flowchart Mermaid diagram (`### The pipeline, end to end`), the "Which path should I use?" table, and all 23 numbered Quickstart steps — moved verbatim from the current `README.md` (research.md: "verbatim vs. tightened" decision), with a short new intro paragraph orienting a reader who arrived from the README's link
- [x] T003 [P] Create `references/recommended-companions.md` with the "Recommended companions" section's `rtk`/`graphify` content moved verbatim from the current `README.md`
- [x] T004 [P] Add a new `## Versioning & releases` section to `CONTRIBUTING.md` with that section's content moved verbatim from the current `README.md`, and relocate `docs/comic/letter-path.jpg` to render inside `CONTRIBUTING.md`'s existing `## How changes ship` section, with one new short caption line carrying the "right side of the Force, mechanized" thematic seasoning (research.md's `letter-path.jpg` decision) — do not restate the discipline passage itself, `## How changes ship` already states it

**Checkpoint**: All three relocation targets exist with real, complete content (not stubs) — `README.md` rewrite can now safely drop the sections that moved here.

---

## Phase 3: User Story 1 - A reader learns what SDD is before being asked to adopt a tool for it (Priority: P1) 🎯 MVP

**Goal**: A reader encounters a condensed, honest SDD explanation, then a Spec-Jedi-specific mapping, before any installation instruction.

**Independent Test**: Read `README.md` from the top; confirm "What Is Spec-Driven Development?" appears before "How Spec Jedi Implements SDD," and that section appears before "Installation."

### Implementation for User Story 1

- [x] T005 [US1] Rewrite `README.md`'s opening: keep the title/i18n banner/badges/epigraph/`letter-open.jpg` exactly as-is, keep the retained hook line "**A letter, from one Master to whoever picks up this scroll next:**" verbatim (FR-001), then replace the multi-paragraph first-person letter body with 2-3 new third-person bridge sentences leading into the SDD primer (FR-006) — depends on T001 (baseline captured first)
- [x] T006 [US1] Add a new `## What Is Spec-Driven Development?` section to `README.md` immediately after the opening bridge: a genuinely new, condensed (not copy-pasted) third-person summary of `references/what-is-sdd.md`, keep the existing small constitution flowchart (`Const --> Core/Onboard/Quality/Meta`) here as its illustration, link to the full doc (depends on T005)
- [x] T007 [US1] Add a new `## How Spec Jedi Implements SDD` section to `README.md` immediately after it: a genuinely new, condensed third-person summary of `references/specjedi-and-sdd.md`'s activity→skill mapping, replacing the old "What you get today" skill table and mindmap diagram with condensed prose, linking to `references/quickstart-guide.md` (T002) for the full catalog/diagrams/steps and to `references/specjedi-and-sdd.md` for the full mapping (depends on T002, T006)
- [x] T008 [US1] Remove the now-relocated "What you get today" skill table, skills mindmap diagram, and the entire "Quickstart" section (including the pipeline flowchart diagram and all 23 numbered steps) from `README.md` — their content already lives in `references/quickstart-guide.md` per T002 (depends on T002, T007). Also removed the now-relocated "Recommended companions" and "Versioning & releases" sections in the same pass, since they immediately followed and their content already lives in `references/recommended-companions.md` (T003) and `CONTRIBUTING.md` (T004) — folded into this task rather than tracked as a separate ID.
- [x] T009 [US1] Retarget the `Pipeline` and `Skills` badge links in `README.md`'s badge row from `#what-you-get-today` to `#how-spec-jedi-implements-sdd` (depends on T007)

**Checkpoint**: User Story 1 is independently testable — reading order is SDD-primer → specjedi-mapping → (Prerequisites/Installation still where they were), with badges pointing at a heading that now exists.

---

## Phase 4: User Story 2 - A reader gets an honest, self-aware summary without leaving the page (Priority: P1)

**Goal**: A condensed, genuinely honest summary of real advantages/limitations sits inline on the home page, without dropping the source documents' caveats.

**Independent Test**: Read the condensed honest-assessment and harness-capability-notes summaries; confirm each keeps at least one genuine limitation (not just an advantage), with a link to the full document.

### Implementation for User Story 2

- [x] T010 [US2] Add a new `## Honest assessment` section to `README.md`, positioned after "Installation" (Prerequisites/Installation/Supported harnesses stay exactly where they are per FR-003 — this section follows them): a genuinely new 2-4 sentence teaser for `references/honest-assessment.md` (one real advantage, one real limitation — e.g. no release cut yet, or heavier ceremony outside `specjedi-quick`'s fast path) and a genuinely new 2-4 sentence teaser for `references/harness-capability-notes.md` (one real advantage, one real limitation — most bridge-harness install paths are desk-research-grounded, not hands-on-verified), each linking to its full document, plus the existing `references/competitive-comparison.md` link carried over (depends on T005, since it sits after the rewritten opening)
- [x] T011 [US2] Remove the now-superseded one-line teaser paragraphs for `honest-assessment.md`/`harness-capability-notes.md`/`competitive-comparison.md`/`what-is-sdd.md`/`specjedi-and-sdd.md` from the end of the old "Supported harnesses" subsection in `README.md` — their expanded replacements now live in the new `## Honest assessment` section (T010) and the `what-is-sdd.md`/`specjedi-and-sdd.md` links already moved into US1's new sections (T006, T007) (depends on T010)

**Checkpoint**: User Stories 1 AND 2 both independently verifiable — SDD literacy first, honest self-assessment inline before the comic/Contributing/License tail.

---

## Phase 5: User Story 3 - The README reads as professional while keeping its Star Wars-themed personality (Priority: P2)

**Goal**: The document reads as organized and credible while at least one Star-Wars-themed, SDD-concept-specific reference remains as seasoning.

**Independent Test**: Skim the README's headings for organization; confirm at least one Star Wars reference tied to a specific SDD concept (drawn from `references/star-wars-lexicon.md`) is still present.

### Implementation for User Story 3

- [x] T012 [US3] Tighten `## Who this is for` in `README.md` to drop its one first-person aside ("...the feeling I'm describing") in favor of third-person phrasing, consistent with FR-006's dial-back — keep the section's content and meaning otherwise unchanged (depends on T007, runs after US1's sections exist so the surrounding voice is consistent)
- [x] T013 [US3] Read through the full rewritten `README.md` end to end and confirm: no sustained first-person "I/you" narrator remains outside the single FR-001 hook line; at least one Star Wars reference tied to a specific SDD concept (e.g. the constitution ↔ Jedi Code framing already in the new SDD-primer sections, or the light/dark path framing now paired with `letter-path.jpg` in `CONTRIBUTING.md`, T004) is present and drawn from `references/star-wars-lexicon.md`, not invented ad hoc (depends on T004, T009, T010, T011, T012)

**Checkpoint**: All three user stories independently verifiable — professional organization confirmed, thematic seasoning confirmed present, nothing invented outside the lexicon.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Prove FR-007/FR-008/SC-003/SC-005 hold across the whole restructure, not just within one story.

- [x] T014 Confirm `## How Spec Jedi builds *itself*, in comic form` (and its 8 panels) is untouched and still sits in its original relative position in `README.md`, and confirm `## Contributing` and `## License` remain the final two sections, in that order (FR-007, Amendment 2) — depends on T008, T010
- [x] T015 Run the fact-preservation diff against `specs/037-readme-professional-restructure/baseline-facts.md` (T001): badge count (expect 10, unchanged), harness-table row count (expect 20, unchanged — not relocated), and every install/release code block's content byte-identical to before, only location may differ (FR-008, SC-003) — depends on T001, T013
- [x] T016 Run all 6 scenarios in `specs/037-readme-professional-restructure/quickstart.md` against the finished `README.md`/`CONTRIBUTING.md`/`references/quickstart-guide.md`/`references/recommended-companions.md` and record the outcome of each — depends on T013, T014, T015
- [x] T017 Delete the scratch `specs/037-readme-professional-restructure/baseline-facts.md` file created in T001 once T015 confirms the diff — it was working scratch, not a shipped artifact — depends on T015
- [ ] T018 Run `specjedi-govcheck` against the feature branch's diff before opening the PR (self-invoked convention this session has followed for every prior feature) — depends on T016

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories (the relocation targets must exist before `README.md` can drop their content).
- **User Stories (Phase 3-5)**: All depend on Foundational phase completion. Because every story edits the same `README.md`, they run in priority order (US1 → US2 → US3), not in parallel, despite all being independently *testable* once their own edits land.
- **Polish (Phase 6)**: Depends on all three user story phases being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Phase 2. No dependency on US2/US3's own edits, but shares the file US2/US3 also edit, so it goes first by priority.
- **User Story 2 (P1)**: Starts after US1's sections exist (T010 is positioned relative to content US1 introduces) — same-file sequencing, not a substantive content dependency.
- **User Story 3 (P2)**: Starts after US1 and US2's sections exist, since its own read-through/tightening pass (T013) needs the full rewritten document to check.

### Parallel Opportunities

- T002, T003, T004 (Phase 2) touch three different files (`references/quickstart-guide.md`, `references/recommended-companions.md`, `CONTRIBUTING.md`) and can run in parallel.
- No task within Phase 3, 4, or 5 is parallelizable against another task in the same phase — all edit `README.md` sequentially.
- T017 (delete scratch file) and T018 (`specjedi-govcheck`) could run in parallel with each other once T016 passes, but T018 is listed last since a clean govcheck report is the natural final check before PR.

---

## Parallel Example: Phase 2 (Foundational)

```bash
# Launch all three relocation-target creations together — different files, no shared dependency:
Task: "Create references/quickstart-guide.md with relocated skill catalog/diagrams/Quickstart steps"
Task: "Create references/recommended-companions.md with relocated rtk/graphify content"
Task: "Add ## Versioning & releases to CONTRIBUTING.md and relocate letter-path.jpg into ## How changes ship"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (baseline capture).
2. Complete Phase 2: Foundational (all three relocation targets — CRITICAL, blocks everything).
3. Complete Phase 3: User Story 1.
4. **STOP and VALIDATE**: Confirm US1's Independent Test (reading order) passes before continuing.

### Incremental Delivery

1. Setup + Foundational → relocation targets ready.
2. Add User Story 1 → validate reading order → this is the structural MVP.
3. Add User Story 2 → validate honest-assessment teasers keep their caveats.
4. Add User Story 3 → validate voice/seasoning read-through.
5. Polish → fact-preservation diff, quickstart.md scenarios, `specjedi-govcheck`, then PR.

---

## Notes

- Nearly every task shares one file (`README.md`) by design — this is a single-document restructure, not a multi-service feature, so file-level parallelism is genuinely limited to the three Phase 2 relocation targets.
- FR-009's "never simply deleted" constraint is why Phase 2 (creating the destinations) is Foundational rather than Polish — nothing in `README.md` may be removed before its replacement home exists.
- Commit after each phase (or each task, if preferred) rather than one giant commit — makes the eventual PR diff easier to review against research.md's stated decisions.
- `docs/i18n/*/README.md` translations are explicitly out of scope (plan.md's Technical Context) — no task touches them.
