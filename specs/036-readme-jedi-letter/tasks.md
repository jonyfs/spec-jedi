# Tasks: README as a Wise Jedi's Letter

**Input**: Design documents from `/specs/036-readme-jedi-letter/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's
Technical Context (documentation/content feature, not application code).
`quickstart.md`'s 6 scenarios serve as this feature's verification, run
in Polish.

**Organization**: Tasks grouped by user story (spec.md priorities
P1/P1/P2). Phase order below follows a *real* content dependency, not
strict priority order: User Story 3's discipline-passage deepening
touches the same paragraph User Story 2's `letter-path.jpg` placement
depends on, so US3's text work is sequenced before US2's image-placement
task even though US2 is P1 and US3 is P2 — stated explicitly in
Dependencies, not hidden.

## Path Conventions

`README.md` (modified in place), `docs/comic/letter-open.jpg` (new),
`docs/comic/letter-path.jpg` (new), `CHANGELOG.md` (modified).

---

## Phase 1: Setup

- [X] T001 Re-read the current `README.md` in full (post PR #100's
      informal-voice rewrite) to ground the letter rewrite in today's
      actual baseline text (depends on nothing).
- [X] T002 [P] Re-read `specs/035-comic-panel-illustrations/research.md`
      for the exact Pollinations.ai URL pattern and style descriptor to
      reuse verbatim (depends on nothing).

---

## Phase 2: User Story 1 — A newcomer reads the origin story, not a product pitch (P1) 🎯 MVP

**Goal**: The README's narrative sections read as an addressed letter
from a wise mentor, while every fact/badge/link/table/code-block stays
exactly as it is today.

**Independent Test**: Read the README start to finish; confirm the
opening and section transitions read as an intentional letter, and
confirm every badge/install command/harness-table row/link still
resolves to exactly what it did before this feature.

- [X] T003 [US1] Rewrite the opening pitch in `README.md` (the
      paragraphs between the badge row and the first Mermaid diagram) as
      an addressed letter opening — a clear voice, a sense of who's
      writing to whom — per FR-001 (depends on T001).
- [X] T004 [US1] Rewrite "Who this is for" in letter voice (depends on
      T003, same file).
- [X] T005 [US1] Rewrite "What you get today"'s intro paragraph (before
      the skill table) in letter voice — the skill table itself stays
      untouched (depends on T004).
- [X] T006 [US1] Rewrite the Quickstart section's intro paragraph and
      its closing paragraph (after step 22, before "The pipeline, end to
      end") in letter voice — the "Which path should I use?" table and
      the 23 individual numbered steps stay exactly as PR #100 left
      them, per plan.md's scope decision (avoid a third rewrite pass
      with diminishing returns) (depends on T005).

**Checkpoint**: US1's independent test passes — the letter voice reads
clearly in every narrative section, and a fact-preservation check
(Scenario 1) confirms zero content lost.

---

## Phase 3: User Story 3 — The letter frames discipline as "the right side of the Force," with real humor (P2)

**Goal**: The existing "No shortcuts to the Dark Side of vibe-coding"
passage explicitly deepens into a "right side of the Force" framing for
disciplined practice, and at least one passage in the letter reads as
genuinely funny.

**Independent Test**: A reader can point to a specific passage
connecting discipline to "the right side of the Force," and a specific
passage that's genuinely funny, not just thematically decorated.

- [X] T007 [US3] Deepen the existing discipline paragraph (the one
      currently ending "No shortcuts to the Dark Side of vibe-coding
      here") into an explicit "right side of the Force" framing,
      connecting constitution-first/test-first/no-self-approval
      practice to that framing directly, per FR-006 (depends on T003,
      same paragraph region T003 already touched).
- [X] T008 [US3] Ensure at least one genuinely funny passage exists
      somewhere in the rewritten letter sections (T003-T007) — add one
      if the current pass reads as inspirational but not actually funny
      anywhere; this is a real judgment call, reason through whether
      the existing tone already clears the bar before adding anything
      new (depends on T007).

**Checkpoint**: US3's independent test passes — a reader can point to
both the discipline/"right side of the Force" passage and a genuinely
funny one.

---

## Phase 4: User Story 2 — New illustrations complement, never replace, what already exists (P1)

**Goal**: Exactly 2 new images (`letter-open.jpg`, `letter-path.jpg`)
exist, pass the Star-Wars-signature exclusion review, and are placed at
the letter's opening and its (now-finalized, per US3) discipline
passage — with zero change to the 5 existing Mermaid diagrams or the 8
existing comic panels.

**Independent Test**: Confirm every newly generated image passes the
Star-Wars-signature exclusion review, and confirm no existing Mermaid
diagram lost technical content or accuracy.

- [X] T009 [US2] Generate `docs/comic/letter-open.jpg` via the
      Pollinations.ai mechanism (T002), using research.md's exact
      prompt; review against Principle XII's exclusion list before
      accepting (depends on T002).
- [X] T010 [US2] Generate `docs/comic/letter-path.jpg` the same way,
      using research.md's exact prompt; review against Principle XII's
      exclusion list before accepting (depends on T002).
- [X] T011 [US2] Insert `letter-open.jpg` into `README.md` at the
      letter's opening, per research.md's placement decision (depends
      on T003, T009).
- [X] T012 [US2] Insert `letter-path.jpg` into `README.md` at the
      now-finalized discipline passage, per research.md's placement
      decision (depends on T007, T010) — placed after T007 specifically
      because the image's placement point is the paragraph US3 just
      finished deepening, not the paragraph's earlier, shallower draft
      from T003.

**Checkpoint**: US2's independent test passes — 2 images exist, both
clean per Principle XII, both placed at real letter milestones; the 5
Mermaid diagrams and 8 comic panels are byte-for-byte unchanged.

---

## Phase 5: Polish & Cross-Cutting Concerns

- [X] T013 [P] Update `research.md`'s Verification note with the actual
      seeds/URLs used for both images and the outcome of the Principle
      XII exclusion review (depends on T009, T010).
- [X] T014 [P] Add the `CHANGELOG.md` entry (depends on nothing else in
      this phase).
- [X] T015 Run `quickstart.md`'s 6 scenarios in order (depends on T006,
      T008, T011, T012).
- [X] T016 Badge-row review per the Distribution & Ecosystem Standards
      section (Principle X's pre-PR requirement) — this feature doesn't
      warrant a new badge (depends on T015).
- [X] T017 Run `specjedi-govcheck` against this branch before opening
      the PR (depends on T015, T016).

---

## Dependencies & Execution Order

- **Setup (Phase 1)**: T001/T002 are independent, genuinely parallel.
- **User Story 1 (Phase 2)**: Depends on Setup. T003→T004→T005→T006 are
  sequential — all touch overlapping regions of the same file.
- **User Story 3 (Phase 3)**: Depends on Phase 2 (T007 deepens the exact
  paragraph T003 wrote first). T007→T008 sequential.
- **User Story 2 (Phase 4)**: T009/T010 (image generation) depend only
  on Setup (T002) and are genuinely parallel with each other and with
  Phases 2-3's text work. T011 depends on T003+T009. T012 depends on
  T007+T010 specifically (not just T003) — the real cross-story
  dependency this file's header calls out.
- **Polish (Phase 5)**: T013/T014 are parallel with each other. T015
  depends on all functional work (T006, T008, T011, T012). T016 depends
  on T015. T017 depends on T015/T016.

## Notes

- No task in this feature required a failing-test-first task per
  Principle VI — the exemption is stated in `plan.md`'s Constitution
  Check.
- T009/T010's real Pollinations.ai generation and Principle XII review
  is this feature's actual verification, matching the "exhaustive real
  execution before shipping" discipline feature 035 already established.
