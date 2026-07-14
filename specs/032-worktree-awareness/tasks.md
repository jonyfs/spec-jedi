# Tasks: Mechanize Worktree-Awareness

**Input**: Design documents from `/specs/032-worktree-awareness/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's
Technical Context (this feature's deliverable is `SKILL.md` prompt
content, not application code with a meaningful red/green cycle).
`quickstart.md`'s 7 scenarios — several using *real* `git worktree`
command execution against this actual checkout — serve as this
feature's verification, run in Polish.

**Organization**: Tasks grouped by user story (spec.md priorities
P1/P2/P2).

## Path Conventions

New file: `.claude/skills/specjedi-worktree/SKILL.md`. Modified files:
`.claude/skills/specjedi-status/SKILL.md`,
`.claude/skills/specjedi-specify/SKILL.md`,
`.claude/skills/specjedi-quick/SKILL.md`, `README.md`, `CHANGELOG.md`,
`references/skill-roadmap.md`, `references/genuine-contributions-log.md`,
`references/honest-assessment.md`, `references/competitive-comparison.md`.

---

## Phase 1: Setup

- [X] T001 [P] Re-read `.claude/skills/specjedi-tokencheck/SKILL.md`
      and `.claude/skills/specjedi-implement/SKILL.md` in full — both
      already establish this project's convention for confirm-gated
      actions and direct git command execution respectively; ground
      `specjedi-worktree`'s own structure in these rather than
      inventing a new shape (depends on nothing).
- [X] T002 [P] Re-read `.claude/skills/specjedi-status/SKILL.md`'s
      current on-disk-artifact derivation logic end to end to confirm
      the exact insertion point for worktree enumeration (US3 prep;
      depends on nothing).

---

## Phase 2: User Story 1 — Get a worktree for a new feature on demand (P1) 🎯 MVP

**Goal**: `specjedi-worktree` exists and creates a real, working git
worktree for a named feature on demand, preferring a native harness
tool when available and falling back to `git worktree` commands
otherwise.

**Independent Test**: Invoke the skill for a named new feature; confirm
via `git worktree list` that a real worktree exists at a distinct path,
checked out on a new branch.

- [X] T003 [US1] Write `.claude/skills/specjedi-worktree/SKILL.md`'s
      YAML frontmatter, Persona, and Task sections (depends on T001)
- [X] T004 [US1] Write the native-tool-detection step: check whether
      the current harness exposes an `EnterWorktree`-shaped tool
      (confirmed this session for Claude Code); if present, delegate to
      it and let it own directory placement + session relocation
      (FR-001, FR-007, research.md's native-tool-first decision)
      (depends on T003)
- [X] T005 [US1] Write the git-fallback path (only when no native tool
      exists): verify `.worktrees/` is `.gitignore`d — add + commit the
      entry first if not — then `git worktree add .worktrees/<branch>
      -b <branch>` (FR-001, research.md's `.worktrees/` convention,
      adopted from Superpowers' `using-git-worktrees` skill) (depends
      on T004)
- [X] T006 [US1] Write the path-collision guard: detect an existing
      target path and refuse with a clear, actionable message instead
      of overwriting or silently picking a different path (FR-004)
      (depends on T005)
- [X] T007 [US1] Write the unsupported-git-worktree-version guard: a
      clear, honest decline message instead of a raw git error (FR-003)
      (depends on T005)
- [X] T008 [US1] Add Format, Example (input → output — a full worked
      scenario showing both the native-tool path and the git-fallback
      path), `--auto` mode, Always/Never, and Verifiable success
      criteria sections per the Skill Authoring Standard (Principle XIX
      full bar) (depends on T006, T007)

**Checkpoint**: `specjedi-worktree` is a complete, standalone,
invokable skill — US1 is independently testable and shippable as an
MVP on its own.

---

## Phase 3: User Story 2 — Get offered a worktree before a collision happens (P2)

**Goal**: `specjedi-specify` and `specjedi-quick` proactively offer a
worktree — never force one — when starting a new feature while the
current checkout has actual uncommitted changes on a non-trunk branch.

**Independent Test**: With uncommitted changes present on a non-trunk
branch, start a new feature via the normal flow; confirm the offer
appears before any branch switch, and confirm declining leaves today's
existing flow completely unchanged.

- [X] T009 [US2] In `.claude/skills/specjedi-worktree/SKILL.md`: write
      the reusable proactive-offer detection step (`git status`
      dirty-check combined with current branch ≠ trunk) as a step other
      skills self-invoke, plus the FR-005 guarded-removal step (explicit
      request only; refuse to discard uncommitted/unmerged work without
      a second, explicit confirmation — leaning on the native tool's own
      built-in guard where available, per research.md) (depends on T008)
- [X] T010 [P] [US2] Wire `.claude/skills/specjedi-specify/SKILL.md` to
      self-invoke T009's detection step before creating the new feature
      directory, offering (never forcing) a worktree when it fires
      (FR-002; Principle XVII proactive-invocation precedent) (depends
      on T009)
- [X] T011 [P] [US2] Wire `.claude/skills/specjedi-quick/SKILL.md` to do
      the same (FR-002) (depends on T009)

**Checkpoint**: Starting a new feature with dirty, uncommitted work on
another branch triggers a clear, declinable offer; a clean or trunk
checkout triggers nothing new.

---

## Phase 4: User Story 3 — See every parallel feature's status in one place (P2)

**Goal**: The project's status-reporting mechanism enumerates every
worktree of the repository and reports each one's feature status in a
single, unified view.

**Independent Test**: With features in progress across 2+ worktrees,
run the status check from any one of them; confirm every worktree's
feature status appears in the single report.

- [X] T012 [US3] In `.claude/skills/specjedi-status/SKILL.md`: add the
      `git worktree list --porcelain` enumeration step (FR-006,
      research.md's decision) (depends on T002)
- [X] T013 [US3] In `.claude/skills/specjedi-status/SKILL.md`: for each
      enumerated worktree beyond the current checkout, apply the exact
      same on-disk `specs/*/` derivation logic already used for the
      current checkout, reading that worktree's own directory (FR-006)
      (depends on T012)
- [X] T014 [US3] In `.claude/skills/specjedi-status/SKILL.md`: add an
      explicit early-return/guard so the common case (no other
      worktrees) produces byte-for-byte unchanged output — zero added
      noise (SC-004) (depends on T013)

**Checkpoint**: A developer with 3 worktrees never needs to run the
status check more than once to see all 3 features.

---

## Phase 5: Polish & Cross-Cutting Concerns

- [X] T015 [P] Update `README.md`: add the `specjedi-worktree` row to
      the skill table, update the mindmap (Meta and Tooling 8→9, total
      24→25), update the `Skills` badge count.
- [X] T016 [P] Update `references/skill-roadmap.md`: add the Shipped
      section entry for `specjedi-worktree`.
- [X] T017 [P] Update `references/genuine-contributions-log.md`: add
      the row for this feature (cross-worktree unified status
      reporting — the genuine Principle II contribution per
      research.md).
- [X] T018 [P] Update `references/honest-assessment.md`: close the
      worktree-awareness Disadvantage/Improvement Point now that a real
      mechanism ships.
- [X] T019 [P] Update `references/competitive-comparison.md`: revise
      the Spec Kitty row's "Rejected" cell (worktree-awareness is no
      longer rejected-as-mandatory-machinery — it's shipped) per that
      document's own Maintenance rule; note Superpowers'
      `using-git-worktrees` skill was directly inspected this cycle.
- [X] T020 [P] Add the `CHANGELOG.md` entry.
- [X] T021 Run `quickstart.md`'s 7 scenarios in order — Scenarios 1-4
      execute real `git worktree` commands against this checkout;
      Scenario 6 cleans up the test worktree/branch before anything
      else proceeds; Scenario 7 runs `scripts/validate.sh` (depends on
      T008, T011, T014).
- [X] T022 Badge-row review per the Distribution & Ecosystem Standards
      section (Principle X's pre-PR requirement) (depends on T015).
- [ ] T023 Run `specjedi-govcheck` against this branch before opening
      the PR (depends on T021, T022).

---

## Dependencies & Execution Order

- **Setup (Phase 1)**: No dependencies — T001/T002 read different files
  and can run in parallel.
- **User Story 1 (Phase 2)**: Depends on Setup. T003→T004→T005→T006/T007
  →T008 are sequential (each builds on the same file's growing content).
  This phase is the MVP — independently shippable on its own.
- **User Story 2 (Phase 3)**: Depends on Phase 2 (T009 extends the same
  skill file US1 just finished writing). T010 and T011 touch different
  files (`specjedi-specify` vs. `specjedi-quick`) and are genuinely
  parallel once T009 lands.
- **User Story 3 (Phase 4)**: Depends only on Setup (T002), not on
  Phases 2/3 — `specjedi-status`'s own file is untouched by either.
  Could be implemented in parallel with Phases 2-3 by a different
  contributor; sequenced after here only for narrative clarity.
- **Polish (Phase 5)**: T015-T020 (doc/reference updates) depend on
  Phases 2-4 being functionally complete and are mutually parallel
  (six different files). T021 (quickstart validation) depends on all
  three user stories' code being done. T022 depends on T015 (same
  file, README). T023 depends on T021 and T022.

## Notes

- No task in this feature required a failing-test-first task per
  Principle VI — the exemption is stated in `plan.md`'s Constitution
  Check and re-stated in this file's header.
- T021's real `git worktree` command execution (Scenarios 1-4 of
  `quickstart.md`) is this feature's actual verification in place of
  code-level tests, matching the "exhaustive real execution before
  shipping" discipline features 023/024 already established.
