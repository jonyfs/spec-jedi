# Tasks: install.sh/.ps1 Merge Shareable Hooks Into an Existing PreToolUse Array

**Input**: Design documents from `specs/061-install-merge-pretooluse/`

**Prerequisites**: plan.md (done), spec.md (done, clarified)

**Tests**: Applicable and required in full — this feature changes real
executable logic (bash + python3 subprocess in `install.sh`, native
PowerShell in `install.ps1`), unlike this session's prior two features.
Every implementation task is preceded by a failing-test task per
Constitution Principle VI, extending the existing `install-test-shared-
hooks` CI job family (`.github/workflows/validate.yml`).

**Organization**: Two source files (`scripts/install.sh`,
`scripts/install.ps1`) are genuinely independent of each other (`[P]`
where marked) once their respective failing tests exist. Test additions
within the same CI job file are sequential (same file, growing content).

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: None required — reuses `has_python3()`/
`Test-Python3Available` (existing), the existing `missing_bash_hooks`/
`missing_read_hooks`/`$missingBashHooks`/`$missingReadHooks` computation
(existing, unchanged), and the existing `install-test-shared-hooks` job
family's own established test pattern (plan.md Technical Context).

*(No tasks.)*

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: None — the three user stories share no prerequisite beyond
the target files already existing, which they do.

*(No tasks.)*

---

## Phase 3: User Story 1 - Missing Bash-matcher hooks merge into an existing PreToolUse/Bash group (Priority: P1) 🎯 MVP

**Goal**: When python3/PowerShell JSON tooling is available, missing
Bash-matcher shareable hooks merge into an existing `PreToolUse` array's
`Bash` matcher group (or a new one is created if absent) instead of
printing a manual-instruction message.

**Independent Test**: Given a target `settings.json` with an existing
`PreToolUse` array and missing Bash-matcher hooks, running the installer
results in those hooks appearing in the correct group, with everything
pre-existing unchanged.

- [x] T001 [US1] Write failing CI scenarios in a new job
  `install-test-shared-hooks-merge` (bash matrix: ubuntu-latest/
  macos-latest/windows-latest, mirroring `install-test-shared-hooks-
  wave1`'s exact job shape) in `.github/workflows/validate.yml`: (a) a
  target `settings.json` pre-seeded with `PreToolUse` → `[{"matcher":
  "Bash", "hooks": [<one pre-existing custom hook>]}]`, missing
  `dangerous-command-guard.sh` — assert after `install.sh` runs, the
  `Bash` group contains both the pre-existing hook (byte-unchanged) and
  the new entry; (b) a target `settings.json` pre-seeded with
  `PreToolUse` → `[{"matcher": "Read|Grep|Glob", "hooks": [...]}]` (no
  `Bash` group), missing Bash hooks — assert a new `Bash` group is
  appended to the array, the `Read|Grep|Glob` group unchanged. Run
  against today's `install.sh` and confirm both FAIL (today prints the
  manual-instruction message and leaves `settings.json` untouched).
- [x] T002 [US1] Write the equivalent failing CI scenarios (a) and (b)
  in a new job `install-test-shared-hooks-merge-windows-native` (native
  PowerShell, mirroring `install-test-shared-hooks-wave1-windows-
  native`'s shape) targeting `install.ps1`. Run against today's
  `install.ps1` and confirm both FAIL.
- [x] T003 [US1] [P] Implement `merge_pretooluse_hooks()` in
  `scripts/install.sh` (plan.md's Project Structure: `json.load`, locate-
  or-create the named matcher group, append entries, `json.dump(...,
  indent=2)`) and wire the `Bash`-matcher call site (replacing the
  conservative bail-out at today's lines 1263-1265, gated on
  `has_python3`). Re-run T001's scenarios, confirm both PASS.
- [x] T004 [US1] [P] Implement `Merge-PreToolUseHooks` in
  `scripts/install.ps1` (plan.md's Project Structure:
  `ConvertFrom-Json`, locate-or-create the named matcher group, append
  entries, `ConvertTo-Json -Depth <N>`) and wire the `Bash`-matcher call
  site (replacing today's lines 989-992). Re-run T002's scenarios,
  confirm both PASS.

**Checkpoint**: Story 1 alone closes the exact real gap the user hit for
Bash-matcher hooks.

---

## Phase 4: User Story 2 - Missing Read-matcher hooks merge the same way (Priority: P1)

**Goal**: The same merge behavior applies symmetrically to
`secret-file-guard.sh`'s `Read|Grep|Glob` matcher group.

**Independent Test**: Given a target `settings.json` with an existing
`PreToolUse` array and `secret-file-guard.sh` missing, running the
installer merges it into the correct group the same non-destructive way.

- [x] T005 [US2] Add failing CI scenarios to the `install-test-shared-
  hooks-merge` job (T001's job): (a) existing `PreToolUse` → `[{"matcher":
  "Bash", ...}]` only (no `Read|Grep|Glob` group), `secret-file-guard.sh`
  missing — assert a new `Read|Grep|Glob` group is appended, `Bash` group
  unchanged; (b) existing `Read|Grep|Glob` group with unrelated
  pre-existing hooks — assert `secret-file-guard.sh` is appended into
  that group, pre-existing entries unchanged. Run against T003's
  `install.sh` (which doesn't yet wire the Read-matcher call site);
  confirm both FAIL.
- [x] T006 [US2] Add the equivalent scenarios (a)/(b) to the
  `install-test-shared-hooks-merge-windows-native` job (T002's job)
  targeting `install.ps1`. Run against T004's `install.ps1`; confirm both
  FAIL.
- [x] T007 [US2] [P] Wire the `Read|Grep|Glob`-matcher call site in
  `scripts/install.sh` to `merge_pretooluse_hooks()` (T003's function,
  reused — no new function needed). Re-run T005's scenarios, confirm both
  PASS.
- [x] T008 [US2] [P] Wire the `Read|Grep|Glob`-matcher call site in
  `scripts/install.ps1` to `Merge-PreToolUseHooks` (T004's function,
  reused). Re-run T006's scenarios, confirm both PASS.

**Checkpoint**: Stories 1+2 together mean every shareable hook the user's
real `barbearia` failure named now merges automatically.

---

## Phase 5: User Story 3 - The suggest-only boundary and safety fallbacks stay intact (Priority: P2)

**Goal**: The no-python3 manual-instruction fallback (`install.sh` only),
the malformed-JSON failure path (both), and idempotent re-runs (both) all
behave exactly as spec.md's Story 3 and Edge Cases require.

**Independent Test**: A python3-less run, a malformed-JSON target, and a
second consecutive run each produce the exact documented outcome — no
merge attempted, or no duplicate entries.

- [x] T009 [US3] Add a CI scenario to `install-test-shared-hooks-merge`:
  `SPECJEDI_TEST_FORCE_NO_PYTHON3=1` (this project's existing test seam)
  + a target with an existing `PreToolUse` array missing hooks — assert
  today's exact manual-instruction message prints and `settings.json` is
  byte-for-byte unchanged (FR-005). Run against T003/T007's `install.sh`;
  this is a regression guard, expected to already PASS (T003/T007's
  `has_python3` gating must leave this path untouched) — if it fails,
  fix the gating before proceeding.
- [x] T010 [US3] Add a CI scenario to `install-test-shared-hooks-merge`:
  a target `settings.json` with unbalanced-braces/invalid-JSON content in
  its `PreToolUse` structure — assert `install.sh` fails explicitly
  (non-zero exit, clear message naming the file) rather than attempting a
  guessed insertion (FR-006). Run against T003/T007's `install.sh`;
  confirm PASS (a `json.load()` `JSONDecodeError`, caught and reported
  clearly by the inline python3 script).
- [x] T011 [US3] [P] Add the equivalent malformed-JSON CI scenario to
  `install-test-shared-hooks-merge-windows-native` targeting
  `install.ps1` (FR-006 parity). Run against T004/T008's `install.ps1`;
  confirm PASS.
- [x] T012 [US3] Add a CI scenario to `install-test-shared-hooks-merge`:
  running `install.sh` twice in a row against the same target (after a
  successful merge) produces byte-identical `settings.json` on the
  second run (SC-003), matching the existing job family's own
  "Idempotent re-run" scenario shape (`.github/workflows/validate.yml`
  lines 1274-1282). Run against T003/T007's `install.sh`; confirm PASS
  (relies on the existing `missing_bash_hooks`/`missing_read_hooks`
  substring-presence check already preventing re-add).
- [x] T013 [US3] [P] Add the equivalent idempotent-re-run CI scenario to
  `install-test-shared-hooks-merge-windows-native` targeting
  `install.ps1`. Run against T004/T008's `install.ps1`; confirm PASS.

**Checkpoint**: All three stories complete — merging is additive and
safe; every documented fallback/failure path still behaves exactly as
specified.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Wire the new CI battery into `ci-gate` and land the change
per Trunk-Based workflow (Principle X).

- [x] T014 Add `install-test-shared-hooks-merge` and
  `install-test-shared-hooks-merge-windows-native` to `ci-gate`'s own
  `needs` list in `.github/workflows/validate.yml` (confirmed at line
  2130) — required per Constitution Principle X ("new battery jobs are
  added to that `needs` list as the project grows").
- [x] T015 Run `scripts/validate.sh` locally (the same structural +
  constitution validation the `lint` CI job runs) to confirm no
  regression in either edited script's structural validity.
- [x] T016 Confirm none of the existing `install-test-shared-hooks`/
  `-wave1`/`-wave2` job scenarios (fresh-install path, no pre-existing
  `PreToolUse`) regressed — these exercise the unchanged
  `PreToolUse`-doesn't-exist branch, which this feature's changes don't
  touch; spot-check by re-reading the diff against those call sites.
- [ ] T017 Commit the change set
  (`specs/061-install-merge-pretooluse/spec.md`, `plan.md`, `tasks.md`,
  `scripts/install.sh`, `scripts/install.ps1`,
  `.github/workflows/validate.yml`, plus `CLAUDE.md`'s already-updated
  plan pointer) on the `061-install-merge-pretooluse` branch — never
  commit directly to `main`.
- [ ] T018 Self-invoke `specjedi-govcheck` against the branch's diff
  before opening the PR.
- [ ] T019 Push and open a PR against `main`; request auto-merge.
- [ ] T020 Monitor the PR's CI status to a terminal state, diagnosing any
  real failure from actual job logs before pushing a fix.

**Checkpoint**: Feature complete, PR open, CI running or merged.

---

## Dependencies & Execution Order

- **Phase 1 (Setup)** → none, empty.
- **Phase 2 (Foundational)** → none, empty.
- **Phase 3 (US1)**: T001 → T003 (bash impl needs T001's failing test to
  exist first); T002 → T004 (same, PowerShell side). T003 and T004 are
  `[P]` relative to each other — different files (`install.sh` vs.
  `install.ps1`), no shared state. T001/T002 are sequential relative to
  each other only because both edit the same `validate.yml` file (not a
  hard dependency, just avoiding concurrent edits to one file).
- **Phase 4 (US2)** depends on **Phase 3**: T005 extends T001's job
  (needs it to exist) and runs against T003's implementation (needs the
  `Bash`-matcher call site and shared `merge_pretooluse_hooks()` function
  to exist first, even though T005/T007 target the *Read*-matcher call
  site specifically — the function itself is created in T003). Same
  logic for T006/T008 against T002/T004.
- **Phase 5 (US3)** depends on **Phase 4**: T009-T013 all run against
  the fully-wired implementations (both matchers) from Phases 3-4.
  T011/T013 are `[P]` relative to T010/T012 respectively — different CI
  job files (bash job vs. windows-native job), genuinely independent.
- **Phase 6 (Polish)** depends on **Phase 5** being complete: T014-T016
  verify/wire the finished battery; T017-T020 land it. T018 (govcheck)
  MUST run before T019 (open PR), matching `specjedi-implement`'s own
  documented Step 6.5-before-Step-7 ordering and this session's own
  established practice for the three prior features.

## Implementation Strategy

### MVP First (User Story 1 Only)

T001-T004 alone already close the Bash-matcher half of the user's real
`barbearia` failure — but Story 2's Read-matcher merge (T005-T008) closes
the other half of that exact same real failure, and Story 3's safety
fallbacks (T009-T013) are what keep the automation trustworthy rather
than a regression risk for python3-less or malformed-JSON targets. All
three stories ship together in one PR, matching this session's own
established precedent for single-surface, sequentially-dependent
features (specs/059, specs/060).

### Incremental Delivery

Not warranted here for the same reason as this session's prior two
features: the phases are sequentially dependent (each builds on the
shared `merge_pretooluse_hooks()`/`Merge-PreToolUseHooks` functions and
the same two CI jobs), so fragmenting across multiple PRs would add
process overhead without independent-deployability benefit.
