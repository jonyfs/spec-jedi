# Tasks: Original Illustrations for the Internal-Bootstrap Comic

**Input**: Design documents from `/specs/035-comic-panel-illustrations/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's
Technical Context (static image assets + a `README.md` prose edit, no
application code). The mandatory two-stage FR-003 review (per image,
before and after generation) is this feature's actual validation
battery item; `quickstart.md`'s 7 scenarios verify the finished state.

**Organization**: Tasks grouped by user story (spec.md priorities
P1/P1/P2). User Story 2 (the sample-approval gate) is sequenced before
User Story 1 despite equal priority, since US1 cannot honestly
"complete" (all 8 panels in one consistent, approved style) before
US2's gate passes.

## Path Conventions

New directory: `docs/comic/`. Modified files: `README.md`,
`.specify/memory/constitution.md`. Prompt record lives in this
feature's own `research.md` (already written during planning).

---

## Phase 1: Setup

- [X] T001 [P] Create the `docs/comic/` directory (depends on nothing).
- [X] T002 [P] Re-read `README.md`'s exact 8-panel block (line range,
      current structure) to confirm the exact insertion point for each
      panel's image embed (depends on nothing).
- [X] T003 [P] Verify `https://image.pollinations.ai` is reachable from
      this implementation environment with one throwaway test request
      — confirms the network/service state research.md verified still
      holds at implementation time (depends on nothing).

---

## Phase 2: User Story 2 — Style approved once before all 8 are made (P1)

**Goal**: One sample illustration exists, passes the FR-003 review, and
receives explicit maintainer approval before any further generation.

**Independent Test**: Before any other panel is generated, confirm
exactly one sample was shown and approved (or a revised direction was
requested and re-sampled).

- [X] T004 [US2] Generate `docs/comic/panel-1.jpg` using Panel 1's
      prompt + the shared style-descriptor clause from `research.md`
      (depends on T001, T003).
- [X] T005 [US2] Review the sample against FR-003's exclusion list
      (glowing-blade weapons, X-wing/TIE-fighter/Star-Destroyer-shaped
      craft, twin-sun desert-planet framing, Jedi-robe silhouettes,
      Star Wars logo/wordmark) — regenerate with a revised prompt if it
      fails, same 2-attempt bound as FR-003 (depends on T004).
- [X] T006 [US2] Present the approved sample for explicit maintainer
      go-ahead; do not begin Phase 3 without it (FR-004) (depends on
      T005).

**Checkpoint**: One approved, FR-003-clean sample exists — the style
the remaining 7 panels will follow.

---

## Phase 3: User Story 1 — Every panel gets one consistent illustration (P1)

**Goal**: All 8 panels (or fewer, with an honest fallback per any panel
that exhausts its regeneration budget) show one image each, all sharing
the approved style, embedded immediately below their existing text.

**Independent Test**: View the rendered README; confirm each panel
shows one image (or an explicit no-image fallback marker), all sharing
one visual identity, existing text unchanged.

- [X] T007 [US1] Generate `docs/comic/panel-2.jpg` through
      `panel-8.jpg` using each panel's prompt + the same shared
      style-descriptor clause from `research.md` (depends on T006 —
      the approved style).
- [X] T008 [US1] Review each of panels 2-8 against FR-003's exclusion
      list, same as T005 (depends on T007).
- [X] T009 [US1] For any panel failing T008's review, regenerate with a
      revised prompt — up to 2 regeneration attempts per panel (3
      generations total); if still failing, that panel does NOT get a
      committed image and instead gets the explicit text-only fallback
      applied in T010 (FR-003, Clarifications Session 2026-07-13)
      (depends on T008).
- [X] T010 [US1] In `README.md`: embed each successfully-generated
      image immediately below its panel's existing text block (never
      replacing it, FR-005); for any fallback panel from T009, add an
      explicit "image not generated" marker instead of an `<img>`/
      Markdown image tag (FR-006) (depends on T009).
- [X] T011 [US1] Confirm every committed file matches research.md's
      stored-format decision (768×512 JPEG under `docs/comic/`) and
      that `README.md` references only local `docs/comic/panel-N.jpg`
      paths, never a live `image.pollinations.ai` URL (FR-006) (depends
      on T010).

**Checkpoint**: The comic section shows consistent, original,
FR-003-clean illustrations (or honest fallbacks) for all 8 panels, with
zero runtime dependency on the external generation service.

---

## Phase 4: User Story 3 — A future maintainer can regenerate any single panel (P2)

**Goal**: The prompt actually used for each committed image is
accurately recorded and durable.

**Independent Test**: For any one committed image, find its exact
prompt in `research.md` without needing this session's own history.

- [X] T012 [US3] Cross-check `research.md`'s per-panel prompt list
      against what was actually used for each committed image — update
      any entry whose prompt was revised during a T009 regeneration
      attempt, so the record reflects reality, not just the original
      draft (FR-007) (depends on T011).

**Checkpoint**: Every committed image's real, final prompt is findable
in `research.md`.

---

## Phase 5: Polish & Cross-Cutting Concerns

- [X] T013 [P] Amend `.specify/memory/constitution.md`'s Principle XII
      (FR-008): add the generated-artwork guardrail (original visual
      identity required; FR-003's exclusion list named explicitly),
      Sync Impact Report, MINOR version bump (depends on nothing — the
      constitution text itself doesn't depend on which images were
      actually generated).
- [X] T014 [P] Badge-row review per the Distribution & Ecosystem
      Standards section (Principle X's pre-PR requirement): confirm no
      badge needs updating (depends on nothing).
- [X] T015 Run `quickstart.md`'s 7 scenarios in order (depends on T011,
      T012, T013).
- [X] T016 Run `scripts/validate.sh`; confirm PASSED (depends on T015).
- [X] T017 Run `specjedi-govcheck` against this branch before opening
      the PR (depends on T016).

---

## Dependencies & Execution Order

- **Setup (Phase 1)**: No dependencies — T001/T002/T003 are mutually
  parallel (directory creation, a README read, a network check).
- **User Story 2 (Phase 2)**: Depends on Setup. T004→T005→T006 are
  sequential (generate, review, get approval) — this phase is the
  MVP-equivalent gate everything else waits on.
- **User Story 1 (Phase 3)**: Depends on Phase 2's approval (T006).
  T007→T008→T009→T010→T011 are sequential (generate the rest, review,
  regenerate-or-fallback, embed, confirm).
- **User Story 3 (Phase 4)**: Depends on Phase 3 being fully done
  (T011) — needs to know the real, final prompts, including any
  revisions from T009.
- **Polish (Phase 5)**: T013 (constitution amendment) and T014 (badge
  review) are independent of the image work and of each other — both
  mutually parallel. T015-T017 depend on everything above being
  complete.

## Notes

- No task in this feature required a failing-test-first task per
  Principle VI — the exemption is stated in `plan.md`'s Constitution
  Check and re-stated in this file's header.
- T009's 2-regeneration-attempt bound and text-only fallback is the
  one behavior in this feature with a hard-coded limit, per this
  session's own `/speckit-clarify` decision (applied as the stated
  Recommended default) — never "keep trying" without a stop condition.
