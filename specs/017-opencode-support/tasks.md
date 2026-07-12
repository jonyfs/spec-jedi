# Tasks: OpenCode Harness Support

**Input**: Design documents from `/specs/017-opencode-support/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Not requested — Principle VI exemption. `quickstart.md`'s 5
scenarios (including a real CI job) serve as this feature's actual
verification.

**Organization**: Tasks grouped by user story (spec.md priorities P1/P1/P1).

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Setup

- [X] T001 Re-confirm the exact OpenCode discovery paths and naming rule
      from `research.md` before writing CI assertions (no new research,
      just re-reading before implementation)

---

## Phase 2: Foundational

None — this feature has no shared derivation logic; proceed to Phase 3.

---

## Phase 3: User Story 1 - An OpenCode user discovers Spec Jedi already works (Priority: P1) 🎯 MVP

**Goal**: Prove the existing install paths satisfy OpenCode's own rules.

- [X] T002 [US1] Real dry run (quickstart.md Scenario 1): fresh
      `claude-code` install, confirm every skill has `SKILL.md` at
      `.claude/skills/<name>/SKILL.md`
- [X] T003 [US1] Real dry run (quickstart.md Scenario 2): fresh
      `codex-cli` install, confirm every skill has `SKILL.md` at
      `.agents/skills/<name>/SKILL.md`
- [X] T004 [US1] Real dry run (quickstart.md Scenario 3): confirm every
      installed skill's frontmatter `name` matches its directory name and
      satisfies OpenCode's lowercase-hyphenated format rule (depends on
      T002)
- [X] T005 [US1] Real check (quickstart.md Scenario 4): confirm zero
      diff in `scripts/install.sh`/`.ps1` — this feature adds no
      installer code (FR-004)

**Checkpoint**: Claim verified locally — User Story 1's mechanism is
proven, pending CI (Phase 5).

---

## Phase 4: User Story 2 - The README accurately reflects what's true (Priority: P1)

- [X] T006 [US2] Update `README.md`'s OpenCode row from "📋 Planned" to
      "✅ Supported," explicitly naming that it's satisfied by the
      existing `claude-code`/`codex-cli` install paths (not a new flag)
      (depends on T002-T005)
- [X] T007 [US2] Confirm via `git diff` that exactly one table row
      changed

**Checkpoint**: README tells the truth — User Story 2 satisfied.

---

## Phase 5: User Story 3 - CI proves the claim (Priority: P1)

- [X] T008 [US3] Add an `opencode-compatibility` job to
      `.github/workflows/validate.yml`, matrixed across
      `ubuntu-latest`/`macos-latest`/`windows-latest`: install via
      `claude-code`, assert every skill path + frontmatter name against
      OpenCode's exact documented rule (mirrors quickstart.md Scenarios
      1+3) (depends on T002, T004)
- [X] T009 [US3] Extend the same job (or add a companion step) asserting
      the `codex-cli` install path the same way (mirrors Scenario 2)
      (depends on T003)
- [X] T010 [US3] Add the new job to `ci-gate`'s `needs:` list
- [X] T011 [US3] Validate `.github/workflows/validate.yml`'s YAML syntax
      after the edits

**Checkpoint**: CI proves the claim on every OS — User Story 3 satisfied
pending the live PR run.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T012 [P] Run `bash scripts/validate.sh` and `pwsh
      scripts/validate.ps1`, confirm `PASSED` with zero unexpected WARN
      lines
- [X] T013 Update `references/principle-traceability.md`'s Principle III
      row to reflect OpenCode as a third real, CI-proven satisfied
      harness (still 🟡 Partial overall)
- [X] T014 Add a new `## Unreleased` → `### Added` entry to
      `CHANGELOG.md`
- [X] T015 Badge review per Distribution & Ecosystem Standards —
      determine no change needed (Skills/Pipeline/Roadmap/Languages all
      unaffected) and document in the PR description

---

## Dependencies & Execution Order

- Setup → User Story 1 (verification) → User Story 2 (README) and User
  Story 3 (CI) in parallel, both depending on US1's verified claim →
  Polish

### Parallel Opportunities

- T002/T003 (claude-code vs codex-cli dry runs) in parallel
- Phase 4 (README) and Phase 5 (CI) in parallel once Phase 3 completes
- T012 (Polish verification) can run independently

---

## Notes

- This is the smallest-footprint feature this session has shipped —
  most tasks are verification, not construction, matching spec.md's own
  framing that this is a proof-and-documentation feature
- Commit after each phase
