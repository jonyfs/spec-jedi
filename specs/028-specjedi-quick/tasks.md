# Tasks: `specjedi-quick`

**Input**: Design documents from `/specs/028-specjedi-quick/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md

**Tests**: Principle VI exemption for *this feature's own* deliverable
(prompt content, not application code) stated in plan.md's Technical
Context — same precedent as features 004/025/026. The fast path
`specjedi-quick` itself enables still requires test-first for real
(FR-004) once it ships; that's the skill's documented behavior, not
something this feature's own task list needs to unit test.

**Organization**: Tasks grouped by user story (spec.md P1/P1/P2).

## Path Conventions

New file: `.claude/skills/specjedi-quick/SKILL.md`. Revised file:
`.claude/skills/specjedi-status/SKILL.md`. Plus README/roadmap/
CHANGELOG updates.

---

## Phase 1: `specjedi-quick` core (US1)

- [X] T001 [US1] Create `.claude/skills/specjedi-quick/SKILL.md`:
      frontmatter (name, description, compatibility), persona, task
      statement.
- [X] T002 [US1] Write the eligibility checklist step (FR-001, five
      criteria) as the skill's first action, before any artifact is
      written.
- [X] T003 [US1] Write the `quick.md` generation step (FR-002) with the
      exact four-section template from plan.md's Design.
- [X] T004 [US1] Write the straight-to-implementation step (FR-003),
      mirroring `specjedi-implement`'s branch-check/test-first/govcheck/
      PR sequence verbatim where applicable (FR-004), including setting
      `quick.md`'s `Status:` line to `Implemented` once the PR opens
      (FR-007).
- [X] T005 [US1] Add Format, Example (input → output), `--auto` mode,
      Always/Never, and Verifiable success criteria sections per the
      Skill Authoring Standard (Principle XIX full bar).

## Phase 2: Ineligibility handling (US2)

- [X] T006 [US2] Write the decline-and-redirect behavior: name the
      specific failing criterion, redirect to `specjedi-specify`.
- [X] T007 [US2] Write the mid-flight escalation behavior (FR-005, Edge
      Cases) — state plainly, stop, hand off `quick.md` content.
- [X] T008 [US2] Add an ineligible-request example (new-skill request)
      to the Example section alongside the eligible one, per Principle
      XIX's "at least one edge case" requirement.

## Phase 3: `specjedi-status` compatibility (US3)

- [X] T009 [US3] Add the `quick.md`-recognition branch to
      `specjedi-status/SKILL.md`'s Step 3 (FR-006): `Status:` line +
      Acceptance Checks checkbox count → same 0%/1-99%/100% mapping
      `tasks.md` already uses.
- [X] T010 [US3] Update `specjedi-status/SKILL.md`'s frontmatter
      `description`/`compatibility` lines to mention `quick.md`.

## Phase 4: Integration

- [X] T011 Add `specjedi-quick` to `README.md`'s skill table and the
      "What you get today" skill-count mindmap; add a short note on when
      to use it vs. the full pipeline near the Quickstart section.
- [X] T012 Add a Shipped entry for `specjedi-quick` in
      `references/skill-roadmap.md`.
- [X] T013 Add a CHANGELOG.md entry.

## Phase 5: Polish

- [X] T014 Run `quickstart.md`'s 4 scenarios (Scenario 4 requires
      constructing and then deleting a real test fixture).
- [X] T015 Run `scripts/validate.sh`; confirm PASSED.
