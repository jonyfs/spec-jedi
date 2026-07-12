# Tasks: Codex CLI Install Path

**Input**: Design documents from `/specs/016-codex-cli-install/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's Technical
Context. `quickstart.md`'s 7 scenarios (including a real CI-proven cross-OS
job) serve as this feature's actual verification.

**Organization**: Tasks are grouped by user story (spec.md priorities P1/P2/P1).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

## Path Conventions

`scripts/install.sh`/`.ps1`, `README.md`,
`.github/workflows/validate.yml` — all existing files, extended in place
per plan.md's Structure Decision.

---

## Phase 1: Setup

**Purpose**: No new files to scaffold — this feature extends existing
scripts directly. Setup here is confirming the exact current state of
those files before editing.

- [X] T001 Re-read `scripts/install.sh`'s current `claude-code` branch
      (harness rejection check, `skills_src`/`skills_dst` variables, copy
      loop, validation loop) end to end to confirm the exact insertion
      points for T004-T006
- [X] T002 [P] Re-read `scripts/install.ps1`'s current `claude-code`
      branch (same elements as T001) to confirm insertion points for
      T007-T009

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: None beyond Phase 1 — unlike features 014/015, this feature
has no shared derivation logic multiple stories depend on; each user
story's work is additive to the same two files but not sequentially
blocking on a separate foundation step.

**Checkpoint**: Proceed directly to Phase 3.

---

## Phase 3: User Story 1 - A Codex CLI user installs Spec Jedi in one command (Priority: P1) 🎯 MVP

**Goal**: `--harness codex-cli` produces a complete, validated install
under `.agents/skills/`.

**Independent Test**: Run `bash scripts/install.sh /tmp/codex-install-test
--harness codex-cli`; confirm all skills land under `.agents/skills/`
with valid frontmatter.

### Implementation for User Story 1

- [X] T003 [US1] In `scripts/install.sh`, change the harness-rejection
      check from `if [ "$harness" != "claude-code" ]` to accept both
      `claude-code` and `codex-cli`, rejecting anything else with the
      existing informative message (depends on T001)
- [X] T004 [US1] In `scripts/install.sh`, make `skills_dst` and
      `templates_dst` resolve to `.agents/skills`/`.specify/templates`
      when `$harness = "codex-cli"` (vs. `.claude/skills` for
      `claude-code`) — the copy loop and post-copy validation loop stay
      identical, only the destination path resolution branches (depends
      on T003)
- [X] T005 [US1] Real dry run: `rm -rf /tmp/codex-install-test && bash
      scripts/install.sh /tmp/codex-install-test --harness codex-cli`;
      confirm skills land under `.agents/skills/` with the installer's
      own validation reporting `OK:` for each (quickstart.md Scenario 1)
      (depends on T004)
- [X] T006 [US1] Real dry run: confirm zero `speckit-*` leakage in the
      codex-cli install (quickstart.md Scenario 2) (depends on T005)
- [X] T007 [P] [US1] Apply the same changes (T003-T004's logic) to
      `scripts/install.ps1`: extend the `$Harness` validation and branch
      `$skillsDst`/`$templatesDst` resolution the same way (depends on
      T002)
- [X] T008 [P] [US1] Real dry run (PowerShell): confirm Scenario 6 from
      `quickstart.md` produces the same result shape as the bash version
      (depends on T007)
- [X] T009 [US1] Real dry run: confirm the existing `claude-code` path is
      unaffected — same skill count as before this feature
      (quickstart.md Scenario 4) (depends on T005, T008)
- [X] T010 [US1] Real dry run: confirm an unsupported `--harness` value
      still produces the existing refusal (quickstart.md Scenario 5)
      (depends on T005)

**Checkpoint**: `--harness codex-cli` works correctly and standalone —
User Story 1 is independently satisfied.

---

## Phase 4: User Story 2 - The README accurately reflects what's actually supported (Priority: P2)

**Goal**: The compatibility table says "✅ Supported" for Codex CLI, and
nothing else silently changes.

**Independent Test**: Read the README's table; confirm only the Codex CLI
row's status changed.

### Implementation for User Story 2

- [X] T011 [US2] Update `README.md`'s "Supported harnesses" table: Codex
      CLI row from "📋 Planned — not yet installable" to "✅ Supported,"
      matching the Claude Code row's format and level of detail (depends
      on T009, since the row shouldn't claim support before US1's
      verification is done)
- [X] T012 [US2] Confirm no other harness row in the table was touched —
      diff `README.md` and verify exactly one row changed

**Checkpoint**: README accurately reflects the new capability — User
Story 2 is independently satisfied.

---

## Phase 5: User Story 3 - CI proves the install path, not just documents it (Priority: P1)

**Goal**: A real CI job installs with `--harness codex-cli` on all three
OSes and asserts the result.

**Independent Test**: Open the PR; confirm the new job(s) run and pass.

### Implementation for User Story 3

- [X] T013 [US3] Add `install-test-codex-cli` job to
      `.github/workflows/validate.yml`, matrixed across `ubuntu-latest`/
      `macos-latest`/`windows-latest`, mirroring the existing
      `install-test` job's structure exactly but invoking `--harness
      codex-cli` and asserting skills land under `.agents/skills` with no
      `speckit-*` leakage (depends on T005, T006)
- [X] T014 [US3] Add `install-test-codex-cli-windows-native` job,
      mirroring `install-test-windows-native`'s structure, invoking
      `install.ps1 -Harness codex-cli` (depends on T008)
- [X] T015 [US3] Add both new jobs to `ci-gate`'s `needs:` list in
      `.github/workflows/validate.yml` (depends on T013, T014)
- [X] T016 [US3] Validate `.github/workflows/validate.yml`'s YAML syntax
      (`python3 -c "import yaml; yaml.safe_load(...)"`) after the edits
      (depends on T015)

**Checkpoint**: New CI jobs are wired in and will run on this PR itself —
User Story 3 is satisfied pending the live CI run in Phase 6.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final local verification before shipping, plus bookkeeping

- [X] T017 [P] Run `bash scripts/validate.sh` and `pwsh
      scripts/validate.ps1`, confirm `PASSED` with zero unexpected WARN
      lines
- [X] T018 [P] Run quickstart.md Scenario 3 (frontmatter validation
      sanity check) — confirm the validation logic isn't a no-op
- [X] T019 Update `references/principle-traceability.md`'s Principle III
      row to reflect Codex CLI now being a real, CI-proven second
      supported harness (still 🟡 Partial overall — 18 more harnesses
      remain 📋 Planned — but no longer "only Claude Code")
- [X] T020 Add a new `## Unreleased` → `### Added` entry to
      `CHANGELOG.md` for this feature
- [X] T021 Review the README badge row per the Distribution & Ecosystem
      Standards section's "before opening any pull request" requirement —
      determine whether this feature warrants a new/updated badge and
      document that determination in the PR description
- [X] T022 Note explicitly (in the PR description and in
      `research.md`/`tasks.md` if not already clear) that CI proof is
      structural, not a real Codex CLI run — honest scope, not
      overclaimed, matching this session's established discipline

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: None — skipped, see above
- **User Story 1 (Phase 3)**: Depends on Setup
- **User Story 2 (Phase 4)**: Depends on User Story 1 completing (the
  README claim must follow real, verified capability, not precede it)
- **User Story 3 (Phase 5)**: Depends on User Story 1 completing (the CI
  job asserts behavior US1 implements)
- **Polish (Phase 6)**: Depends on Phases 3-5 all completing

### User Story Dependencies

- **User Story 1 (P1)**: Independent — the actual mechanism
- **User Story 2 (P2)**: Depends on US1 (can't truthfully claim support
  before it's real)
- **User Story 3 (P1)**: Depends on US1 (proves what US1 built); can run
  in parallel with US2 since neither depends on the other

### Parallel Opportunities

- T002 (PowerShell re-read) parallel with T001 (bash re-read)
- T007/T008 (PowerShell implementation) parallel with T003-T006 (bash
  implementation) once both Setup tasks are done
- Phase 4 (US2) and Phase 5 (US3) can run in parallel once Phase 3
  completes
- T017/T018 (Polish verification) in parallel

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 3: User Story 1 (T003-T010)
3. **STOP and VALIDATE**: real dry run confirms the install path works
   correctly on this machine
4. This alone is the core mechanism — US2/US3 make it truthful (README)
   and provable (CI), respectively

### Incremental Delivery

1. Setup → confirmed insertion points in both scripts
2. User Story 1 → the mechanism itself, dry-run verified
3. User Story 2 → README tells the truth about it
4. User Story 3 → CI proves it on every OS, not just this machine
5. Polish → traceability/changelog/badge bookkeeping, honest scope note

---

## Notes

- [P] tasks = different files or independent concerns, no dependencies
- [Story] label maps task to specific user story for traceability
- T022 exists specifically to prevent this feature's CI-job proof from
  being read as "Codex CLI itself was tested" when it wasn't — say so
  explicitly, don't let the reader infer more than what was verified
- Commit after each phase, not after every single task
