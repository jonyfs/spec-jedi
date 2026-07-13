# Tasks: Theme-Safe, Right-Sized Mermaid Diagrams for `specjedi-diagram`

**Input**: Design documents from `/specs/025-diagram-readability/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md
(prompt-content revision, no executable logic). `quickstart.md`'s
scenarios serve as verification, run in Polish.

**Organization**: Tasks grouped by user story (spec.md P1/P1/P2).

## Path Conventions

Two existing files revised: `.claude/skills/specjedi-diagram/SKILL.md`,
`references/mermaid-diagram-catalog.md`. No new files.

---

## Phase 1: Foundational — canonical reference sections (blocks US1-US3)

- [X] T001 Add a "Theme Safety" section to
      `references/mermaid-diagram-catalog.md` (research.md Decision 1):
      never emit explicit `style`/`classDef`/`%%{init` color overrides;
      encode distinctions via shape/edge-style/label instead.
- [X] T002 Add a "Complexity Threshold" section to
      `references/mermaid-diagram-catalog.md` (research.md Decision 2):
      20-node threshold + "can't describe in one sentence" qualitative
      backstop; split along a natural seam when exceeded.

## Phase 2: Theme safety in SKILL.md (US1)

- [X] T003 [US1] Revise `specjedi-diagram/SKILL.md` Step 4: fold in the
      theme-safety self-check (scan for `style `/`classDef `/`%%{init`;
      remove and re-express via shape/label if found).
- [X] T004 [US1] Add paired Always/Never entries for theme safety.

## Phase 3: Complexity threshold in SKILL.md (US2)

- [X] T005 [US2] Revise `specjedi-diagram/SKILL.md` Step 2: add the
      complexity self-check (tally nodes / one-sentence test) run
      immediately after generation.
- [X] T006 [US2] Document the split-along-a-seam behavior, the labeling
      requirement (FR-004), and the "don't force a split" exception
      (FR-005, Edge Cases) in the Step-by-step section.
- [X] T007 [US2] Add paired Always/Never entries for the complexity
      threshold.

## Phase 4: Render-verification folding (US3)

- [X] T008 [US3] State explicitly in Step 4 that both new self-checks
      are part of that same step (not a new Step 5), so they run even
      without a live render-verification mechanism available.

## Phase 5: Worked example consistency check

- [X] T009 Re-check the existing "Example (input → output)" sample
      diagram against both new rules; add a one-line confirmation note
      (plan.md's Design section) — no content change needed since it
      already complies.

## Phase 6: Polish

- [X] T010 Run `quickstart.md`'s 4 scenarios manually (dry-run reasoning
      through each).
- [X] T011 Run `scripts/validate.sh`; confirm PASSED.
