# Tasks: Harness Auto-Detection

**Input**: Design documents from `/specs/021-harness-auto-detection/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's Technical
Context. `quickstart.md`'s 8 scenarios (including a real CI job) serve as
this feature's actual verification.

**Organization**: Tasks grouped by user story (spec.md priorities P1/P1/P1).

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Setup

- [X] T001 Re-read `scripts/install.sh`'s current arg-parsing loop and
      harness `case` statement end to end to confirm exact insertion
      points for detection logic (depends on nothing)
- [X] T002 [P] Re-read `scripts/install.ps1`'s equivalent structure for
      the same purpose (depends on nothing)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The signal-gathering + ranking logic is shared by every
user story — none are independently testable without it.

- [X] T003 In `scripts/install.sh`: change `harness="claude-code"`'s
      default to `harness=""`, and add a new `--auto` flag to the arg
      parser (sets `auto_mode=1`) (depends on T001)
- [X] T004 In `scripts/install.sh`: implement the signal-gathering
      function per data-model.md's Detection Signal table — bash-3.2-safe
      indexed array of `"harness:signal-type:evidence"` strings, checking
      target-dir, `command -v` (where applicable), and global-config for
      each of the 3 harnesses, only when `harness` is empty (depends on
      T003)
- [X] T005 In `scripts/install.sh`: implement ranking logic — for each
      matched harness, its best (lowest-numbered) signal type, ties
      broken by fixed priority order `claude-code` > `codex-cli` >
      `trae` — producing the Recommended candidate when ≥2 harnesses
      matched (depends on T004)
- [X] T006 [P] Apply T003-T005's equivalent logic to
      `scripts/install.ps1` (same signal table, same ranking, PowerShell-
      native `Get-Command`/directory checks) (depends on T002)

**Checkpoint**: Detection and ranking logic exists and is unit-dry-run
inspectable, before wiring in the three resolution paths.

---

## Phase 3: User Story 1 - A user who omits --harness still gets a correct install (Priority: P1) 🎯 MVP

**Goal**: Zero-match falls back to `claude-code` (stated explicitly);
single-match auto-installs (stated explicitly which signal matched).

**Independent Test**: quickstart.md Scenarios 1 and 3.

### Implementation for User Story 1

- [X] T007 [US1] Wire the zero-match case: if signal-gathering (T004)
      finds nothing, set `harness="claude-code"` and print an explicit
      "falling back to default, not detected" message (FR-007) (depends
      on T005)
- [X] T008 [US1] Wire the single-match case: if exactly one harness
      matched, set `harness` to it and print which signal matched
      (FR-003) (depends on T005)
- [X] T009 [US1] Real dry run: Scenario 1 (single `.agents/` target-dir
      signal, no `--harness` flag) — confirm `codex-cli` auto-selected
      (depends on T007, T008)
- [X] T010 [US1] Real dry run: Scenario 3 (zero signals) — confirm
      fallback to `claude-code`, explicitly stated as a fallback (depends
      on T007)
- [X] T011 [P] [US1] Apply T007-T008's logic to `scripts/install.ps1`
      (depends on T006)
- [X] T012 [P] [US1] Real dry run (PowerShell): Scenario 6, confirm same
      result shape as Scenario 1 (depends on T011)

**Checkpoint**: Omitting `--harness` produces a correct, explained
install for the unambiguous cases — User Story 1 (MVP) is independently
satisfied.

---

## Phase 4: User Story 2 - A user with multiple harnesses gets a clear Recommended choice (Priority: P1)

**Goal**: Multi-match resolves via Constitution v1.22.0's
Recommended-option standard — interactive prompt with a real TTY, or
automatic Recommended-selection otherwise/with `--auto`.

**Independent Test**: quickstart.md Scenarios 2 and 7.

### Implementation for User Story 2

- [X] T013 [US2] Wire the multi-match, non-interactive/`--auto` case: if
      `[ -t 0 ]` is false OR `auto_mode=1`, set `harness` to the
      Recommended candidate (T005) and state that this was an automatic
      selection and why (FR-006) (depends on T005)
- [X] T014 [US2] Wire the multi-match, interactive case: if `[ -t 0 ]` is
      true and `auto_mode` is unset, print a lettered list of matched
      candidates with the Recommended one marked, `read` a choice
      (defaulting to Recommended on empty input), and set `harness`
      accordingly (FR-005) (depends on T005)
- [X] T015 [US2] Real dry run: Scenario 2 (`.claude/` + `.agents/` both
      present, `--auto` passed) — confirm `claude-code` wins the
      priority-order tiebreak and is stated as an automatic Recommended
      selection (depends on T013)
- [X] T016 [US2] Manual verification: Scenario 7 (real terminal, no
      `--auto`) — confirm the lettered prompt appears, Recommended is
      marked, and both accepting the default and typing an alternate
      letter produce the corresponding install (depends on T014)
- [X] T017 [P] [US2] Apply T013-T014's logic to `scripts/install.ps1`
      using `[Console]::IsInputRedirected` (depends on T006)

**Checkpoint**: Ambiguous detection is never silently guessed for — User
Story 2 is independently satisfied.

---

## Phase 5: User Story 3 - Existing explicit-`--harness` usage is completely unaffected (Priority: P1)

**Goal**: Every existing CI job and explicit invocation is byte-for-byte
unchanged.

**Independent Test**: quickstart.md Scenarios 4 and 5.

### Implementation for User Story 3

- [X] T018 [US3] Real dry run: Scenario 4 — explicit `--harness
      claude-code` against a target with an `.agents/` signal present;
      confirm `claude-code` installs (detection never runs) (depends on
      T007, T008, T013, T014)
- [X] T019 [US3] Add `harness-auto-detect` CI job to
      `.github/workflows/validate.yml`, matrixed across `ubuntu-latest`/
      `macos-latest`/`windows-latest`: reproduces quickstart.md Scenario
      1 (single-match) and Scenario 2 (`--auto` multi-match) (depends on
      T009, T015)
- [X] T020 [US3] Add `harness-auto-detect-windows-native` CI job,
      mirroring the native-PowerShell pattern from prior features
      (depends on T012, T017)
- [X] T021 [US3] Add both new jobs to `ci-gate`'s `needs:` list
- [X] T022 [US3] Validate `.github/workflows/validate.yml`'s YAML syntax
      (depends on T021)
- [X] T023 [US3] Confirm every pre-existing `install-test*` job definition
      in `.github/workflows/validate.yml` is byte-for-byte unmodified by
      this feature's diff — proves FR-009 by inspection before CI proves
      it by execution (depends on T018)

**Checkpoint**: Backward compatibility is proven, not just assumed — User
Story 3 is independently satisfied.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T024 [P] Run `bash scripts/validate.sh` and `pwsh
      scripts/validate.ps1`, confirm `PASSED` with zero unexpected WARN
      lines
- [X] T025 Update `scripts/install.sh --help`/`install.ps1 -Help` usage
      text to document `--harness` as now-optional and the new `--auto`
      flag
- [X] T026 Update `references/principle-traceability.md`'s Principle
      XVIII row to reflect harness auto-detection landing
- [X] T027 Add a new `## Unreleased` → `### Added` entry to
      `CHANGELOG.md`
- [X] T028 Remove the shipped Sub-Project C bullet from
      `references/skill-roadmap.md`'s "Proposed, not yet built" section
      (it moves from proposed to shipped)
- [X] T029 Review the README badge row — determine no change needed and
      document in the PR description

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup — blocks all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational
- **User Story 2 (Phase 4)**: Depends on Foundational — can proceed in
  parallel with Phase 3 once Phase 2 completes (different resolution
  branches of the same shared signal data)
- **User Story 3 (Phase 5)**: Depends on Phases 3-4 both completing (it
  verifies the combination of everything they built)
- **Polish (Phase 6)**: Depends on Phase 5

### Parallel Opportunities

- T002 parallel with T001
- T006 (PowerShell foundational) parallel with T003-T005 (bash) once
  Setup completes
- Phase 3 (US1) and Phase 4 (US2) can proceed in parallel once Phase 2
  completes
- T011/T012, T017 (PowerShell per-story work) parallel with their bash
  counterparts

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 (Setup) and Phase 2 (Foundational)
2. Complete Phase 3 (US1 — unambiguous cases)
3. **STOP and VALIDATE**: omitting `--harness` works correctly for
   zero-match and single-match cases
4. This alone delivers real value; US2 handles the harder ambiguous case,
   US3 proves nothing broke

### Incremental Delivery

1. Setup → confirmed insertion points
2. Foundational → signal gathering + ranking, shared by everything after
3. US1 → unambiguous cases work (MVP)
4. US2 → ambiguous cases resolved via the Recommended-option standard
5. US3 → proven backward-compatible, new CI job locks it in
6. Polish → docs, traceability, changelog, backlog bookkeeping

---

## Notes

- T023 exists specifically to make FR-009's backward-compatibility claim
  checkable by a reviewer (diff inspection), not just assumed from the
  CI jobs happening to still pass.
- Commit after each phase, not after every single task
