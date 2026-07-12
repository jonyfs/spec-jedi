# Tasks: Warp Harness Support

**Input**: Design documents from `/specs/018-warp-support/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Not requested — Principle VI exemption. `quickstart.md`'s 5
scenarios (including a real CI job) serve as verification.

**Organization**: Tasks grouped by user story (spec.md priorities P1/P1/P1).

---

## Phase 1: Setup

- [X] T001 Re-confirm Warp's exact Skills discovery paths and naming
      rule from `research.md` before writing CI assertions

---

## Phase 2: Foundational

None — proceed to Phase 3.

---

## Phase 3: User Story 1 - A Warp user discovers Spec Jedi already works (Priority: P1) 🎯 MVP

- [X] T002 [US1] Real dry run (quickstart.md Scenario 1): fresh
      `claude-code` install, confirm every skill has `SKILL.md` at
      `.claude/skills/<name>/SKILL.md`
- [X] T003 [US1] Real dry run (quickstart.md Scenario 2): fresh
      `codex-cli` install, confirm every skill has `SKILL.md` at
      `.agents/skills/<name>/SKILL.md`
- [X] T004 [US1] Real dry run (quickstart.md Scenario 3): confirm every
      installed skill's frontmatter and naming satisfy Warp's Skills
      rule (depends on T002)
- [X] T005 [US1] Real check (quickstart.md Scenario 4): confirm zero
      diff in `scripts/install.sh`/`.ps1`

**Checkpoint**: Claim verified locally.

---

## Phase 4: User Story 2 - The README accurately reflects what's true (Priority: P1)

- [X] T006 [US2] Update `README.md`'s Warp row from "📋 Planned" to
      "✅ Supported," naming both satisfying install paths (depends on
      T002-T005)
- [X] T007 [US2] Confirm via `git diff` that exactly one table row
      changed

---

## Phase 5: User Story 3 - CI proves the claim (Priority: P1)

- [X] T008 [US3] Add a `warp-compatibility` job to
      `.github/workflows/validate.yml`, matrixed across
      `ubuntu-latest`/`macos-latest`/`windows-latest`: install via
      `claude-code`, assert path + frontmatter against Warp's documented
      Skills rule (mirrors quickstart.md Scenarios 1+3) (depends on T002,
      T004)
- [X] T009 [US3] Extend the same job asserting the `codex-cli` install
      path the same way (mirrors Scenario 2) (depends on T003)
- [X] T010 [US3] Add the new job to `ci-gate`'s `needs:` list
- [X] T011 [US3] Validate `.github/workflows/validate.yml`'s YAML syntax

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T012 [P] Run `bash scripts/validate.sh` and `pwsh
      scripts/validate.ps1`, confirm `PASSED` with zero unexpected WARN
      lines
- [X] T013 Update `references/principle-traceability.md`'s Principle III
      row to reflect Warp as a fourth real, CI-proven satisfied harness
- [X] T014 Add a new `## Unreleased` → `### Added` entry to
      `CHANGELOG.md`
- [X] T015 Badge review — determine no change needed and document in
      the PR description

---

## Dependencies & Execution Order

Setup → User Story 1 → User Story 2 and User Story 3 in parallel →
Polish. Same shape as feature 017.

---

## Notes

- Mirrors feature 017's task structure exactly, applied to a second
  zero-new-code harness
- Commit after each phase
