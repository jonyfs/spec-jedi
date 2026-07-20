# Tasks: merge_json_key() Merges Into an Existing Array-Shaped Key

**Input**: Design documents from `specs/063-merge-json-key-array-merge/`

**Prerequisites**: plan.md (done), spec.md (done)

**Tests**: Applicable and required in full — real executable logic
(bash + python3 subprocess in `install.sh`, native PowerShell in
`install.ps1`), same as specs/061. Extends the *existing*
`install-test-shared-hooks-merge`/`-windows-native` CI job pair
(specs/061) with new steps — no new job needed.

**Organization**: Two source files (`scripts/install.sh`,
`scripts/install.ps1`) are genuinely independent (`[P]` where marked)
once their respective failing tests exist.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: None required — reuses `has_python3()`/
`Test-Python3Available` and the existing `install-test-shared-hooks-
merge` job family (plan.md Technical Context).

*(No tasks.)*

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: None — both stories share no prerequisite beyond the
target files already existing.

*(No tasks.)*

---

## Phase 3: User Story 1 - Missing content merges into an existing array-shaped key (Priority: P1) 🎯 MVP

**Goal**: When the existing key's value is an array and the new block
is also an array, merge the missing items in instead of no-op'ing.

**Independent Test**: Given a target `.claude/settings.json` with an
existing `"Stop"` array missing the shareable notification hook,
running the installer merges it in, pre-existing entries unchanged.

- [x] T001 [US1] Add a failing CI scenario to the existing
  `install-test-shared-hooks-merge` job
  (`.github/workflows/validate.yml`): a target `.claude/settings.json`
  pre-seeded with `"Stop": [{"matcher": "", "hooks": [<one pre-existing
  custom hook>]}]` — assert after `install.sh` runs, that array contains
  both the pre-existing hook (unchanged) and the shareable notification
  hook entry. Run against today's `install.sh`; confirm FAIL (today
  prints "already has this key — leaving as-is" and leaves the array
  untouched).
- [x] T002 [US1] Add the equivalent failing CI scenario to
  `install-test-shared-hooks-merge-windows-native` targeting
  `install.ps1`. Run against today's `install.ps1`; confirm FAIL.
- [x] T003 [US1] [P] Extend `merge_json_key()` in `scripts/install.sh`
  (today's `case "$content" in *"$key_check"*)` branch) with the
  array-detection-and-merge logic: python3-gated (`has_python3`),
  `json.load()` both the existing value and the new block, if both are
  lists merge (content-dedup, `json.dump(..., indent=2)`), otherwise
  fall through to today's exact existing message — plan.md's Project
  Structure §1. Re-run T001's scenario, confirm PASS.
- [x] T004 [US1] [P] Extend `Merge-JsonKey` in `scripts/install.ps1`
  with the equivalent `ConvertFrom-Json`/`ConvertTo-Json`-based logic
  (no python3 gate, native cmdlets always available; `@()`-wrapping
  discipline per specs/061) — plan.md's Project Structure §2. Re-run
  T002's scenario, confirm PASS.

**Checkpoint**: Story 1 alone closes the real, directly-named gap for
the `"Stop"` key — the second instance of this class of gap specs/061
started closing.

---

## Phase 4: User Story 2 - Object-shaped existing keys keep today's behavior (Priority: P2)

**Goal**: The four object-shaped call sites (gemini-cli/antigravity
`"hooks"`, opencode `"permission"`, zed `"agent"`) see zero behavior
change — confirmed, not assumed.

**Independent Test**: Given a target with an existing `"permission"` key
(opencode), running the installer produces today's exact unchanged
message.

- [x] T005 [US2] Add a regression-guard CI scenario to
  `install-test-shared-hooks-merge`: a target `opencode.json` with an
  existing `"permission"` object — assert `install.sh` prints today's
  exact "already has this key — leaving as-is" message and the file is
  byte-for-byte unchanged. Run against T003's `install.sh`; this is a
  regression guard, expected to already PASS (the array-vs-object shape
  check must correctly fall through for this case) — if it fails, fix
  T003's shape detection before proceeding.
- [x] T006 [US2] [P] Add the equivalent regression-guard scenario to
  `install-test-shared-hooks-merge-windows-native` targeting
  `install.ps1` (e.g. zed's `"agent"` object, or opencode via
  `install.ps1` if that harness's PowerShell path is confirmed to exist
  — ground against the actual `install.ps1` harness list before writing,
  don't assume parity blindly). Run against T004's `install.ps1`;
  confirm PASS.

**Checkpoint**: Both stories complete — the array-merge capability is
additive; the four object-shaped harnesses are provably unaffected.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Verification and landing the change per Trunk-Based
workflow (Principle X).

- [x] T007 Add an idempotent-re-run CI scenario (bash): running the
  installer twice against the same `"Stop"`-array-merged target produces
  byte-identical `settings.json` on the second run (SC-003). Run against
  T003's `install.sh`; confirm PASS (relies on the same content-dedup
  logic already proven in specs/061).
- [x] T008 [P] Add the equivalent idempotent-re-run scenario
  (windows-native) targeting `install.ps1`. Confirm PASS.
- [x] T009 Run `scripts/validate.sh` locally to confirm no structural
  regression in either edited script.
- [x] T010 Confirm none of the existing `install-test-shared-hooks-
  merge` scenarios from specs/061 (the `PreToolUse`-array cases)
  regressed — `merge_json_key()`'s own new branch must not affect
  `merge_pretooluse_hooks()`'s separate, untouched code path.
- [x] T011 Commit the change set
  (`specs/063-merge-json-key-array-merge/spec.md`, `plan.md`,
  `tasks.md`, `scripts/install.sh`, `scripts/install.ps1`,
  `.github/workflows/validate.yml`, plus `CLAUDE.md`'s already-updated
  plan pointer) on the `063-merge-json-key-array-merge` branch — never
  commit directly to `main`.
- [x] T012 Self-invoke `specjedi-govcheck` against the branch's diff
  before opening the PR.
- [x] T013 Push and open a PR against `main`; request auto-merge.
- [x] T014 Monitor the PR's CI status to a terminal state, diagnosing
  any real failure from actual job logs before pushing a fix.

**Checkpoint**: Feature complete, PR open, CI running or merged.

---

## Dependencies & Execution Order

- **Phase 1 (Setup)** → none, empty.
- **Phase 2 (Foundational)** → none, empty.
- **Phase 3 (US1)**: T001 → T003 (bash impl needs T001's failing test
  first); T002 → T004 (same, PowerShell). T003/T004 are `[P]` — different
  files, no shared state. T001/T002 sequential relative to each other
  only because both edit the same `validate.yml` file.
- **Phase 4 (US2)** depends on **Phase 3**: T005/T006 run against
  T003/T004's finished implementations (need the array-vs-object
  detection to exist first to confirm it correctly falls through).
  T005/T006 are `[P]` relative to each other — different CI job files.
- **Phase 5 (Polish)** depends on **Phase 4**: T007-T010 verify the
  finished behavior; T011-T014 land it. T012 (govcheck) MUST run before
  T013 (open PR), matching this session's own established ordering.

## Implementation Strategy

### MVP First (User Story 1 Only)

T001-T004 alone already close the real, directly-named gap (`"Stop"`
key). Story 2 (T005-T006) is the regression guard confirming the other
four call sites are genuinely unaffected — both ship together in one
PR, matching this session's own established precedent for this exact
shape of change (specs/061).

### Incremental Delivery

Not warranted — same file, tightly-coupled behavior change (one new
branch inside one shared function), matching specs/061's own reasoning.
