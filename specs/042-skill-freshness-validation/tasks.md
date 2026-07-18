---

description: "Task list for specs/042-skill-freshness-validation"
---

# Tasks: Skill Freshness Validation & Update Awareness

**Input**: Design documents from `/specs/042-skill-freshness-validation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md,
quickstart.md (all present — see plan.md's Project Structure; no
`contracts/`, reasoned there)

**Tests**: Not explicitly requested as TDD in spec.md, but Principle IX
requires real CI coverage for every acceptance scenario (same posture as
specs/041) — test tasks below extend `.github/workflows/validate.yml`'s
existing job families rather than being skipped.

**Organization**: Tasks are grouped by user story (US1 = P1, US2 = P2)
per spec.md's priorities. US1 and US2 touch entirely disjoint files
(US1: `install.sh`/`.ps1`, `package-release.sh`/`.ps1`; US2:
`session-start.sh`/`.ps1` only) — the one thing genuinely shared between
them is the marker's on-disk schema (data-model.md), which Foundational
below freezes before either story starts.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, or independent
  additions within the same file)
- **[Story]**: US1 or US2 per spec.md
- File paths are exact, per plan.md's Project Structure and
  Implementation notes

---

## Phase 1: Setup

**Purpose**: Confirm the design artifacts are internally consistent
before any code changes begin.

- [X] T001 Verify `plan.md`, `research.md`, `data-model.md`, and
  `quickstart.md` are mutually consistent with `spec.md`'s three
  post-`/speckit-clarify` FRs (FR-004's exact-string comparison, FR-005's
  silent-degrade list including the `"local-checkout"` sentinel, FR-006's
  short-explicit-timeout requirement) — no drift between what was
  clarified and what was planned.

---

## Phase 2: Foundational (blocking prerequisite for both stories)

**Purpose**: Freeze the one contract both stories must not diverge on.

**⚠️ CRITICAL**: Blocks Phase 3 and Phase 4 entirely.

- [X] T002 Confirm `data-model.md`'s marker schema — single
  `.specify/release-marker.json` file, one field `installed_release`,
  whose value is either a release tag string or the literal
  `"local-checkout"` — as the frozen contract User Story 1 (writer) and
  User Story 2 (reader) both implement against verbatim. No code
  produced in this phase.

**Checkpoint**: Marker schema frozen. User Story 1 and User Story 2 can
now proceed independently (and in parallel, if staffed).

---

## Phase 3: User Story 1 - Record which release an install came from (Priority: P1) 🎯 MVP

**Goal**: `scripts/install.sh`/`.ps1` write `.specify/release-marker.json`
on every install — a real release tag when installed from a packaged
release (via `bootstrap-install.sh` or a manually extracted tarball), the
`"local-checkout"` sentinel when run directly from a git clone.

**Independent Test**: Run each installer against a clean target directory
and inspect the resulting marker file/value — no session-start hook
involvement required (spec.md's own Independent Test for this story).

### Tests for User Story 1 (write failing first, per Principle IX)

- [X] T003 [P] [US1] Confirm `scripts/install.sh`'s `target_dir`
  resolution (`target_dir="$(cd "$target_dir" && pwd)"`) and the
  `.specify/templates` staging call as the insertion point for the new
  marker-writing step (research.md Decision 1/2). No code change — a
  read-only confirmation this story's implementation tasks below rely on.
- [X] T004 [P] [US1] Write a failing assertion in the
  `package-content-completeness` job (`.github/workflows/validate.yml`)
  expecting a `RELEASE_VERSION` file at the packaged tarball's root,
  containing exactly the version argument passed to
  `package-release.sh`.
- [X] T005 [P] [US1] Write failing scratch-directory assertions for a new
  `install-test-release-marker` job (`.github/workflows/validate.yml`,
  following `install-test-shared-hooks`'s exact 3-OS-matrix pattern):
  (a) `install.sh` run against a plain git clone (no `RELEASE_VERSION`
  file present) writes `{"installed_release": "local-checkout"}`; (b)
  `install.sh` run from a tarball extracted via a real
  `package-release.sh` build writes the real version string — quickstart.md
  Scenarios 1 and 2.
- [X] T006 [US1] **Revised during implementation** (research.md
  "Implementation-time discovery"): confirmed by direct execution that
  `bootstrap-installer-smoke` cannot assert marker content today —
  `bootstrap-install.sh` downloads whatever `install.sh` is bundled in
  the *currently published* release, which predates this feature and has
  no marker logic. Adding that assertion now would fail on every CI run
  until the next release is cut, for reasons unrelated to this PR's own
  correctness. No new assertion added to `bootstrap-installer-smoke`;
  `install-test-release-marker` (T005) already proves the identical code
  path (extract tarball → run bundled `install.sh`) without waiting on a
  real release cut, since `bootstrap-install.sh` itself is unmodified
  (research.md Decision 2). quickstart.md Scenario 3 documents re-running
  this check manually after the next real release ships.

### Implementation for User Story 1

- [X] T007 [US1] Implement the `RELEASE_VERSION` staging line in
  `scripts/package-release.sh` (`printf '%s' "$version" >
  "$stage_root/RELEASE_VERSION"`, per plan.md's exact snippet), alongside
  its existing `cp` staging calls.
- [X] T008 [P] [US1] Mirror the identical staging addition in
  `scripts/package-release.ps1`.
- [X] T009 [US1] Implement `write_release_marker()` in
  `scripts/install.sh` per plan.md's exact function: read
  `$repo_root/RELEASE_VERSION` if present (real tag), else check
  `$repo_root/.git` (write `"local-checkout"`), else fall back to
  `"local-checkout"` too (never fabricate a version) — write the result
  to `.specify/release-marker.json` in the target directory. Depends on
  T003, T007.
- [X] T010 [P] [US1] Implement the identical `Write-ReleaseMarker`
  function in `scripts/install.ps1`, PowerShell idiom. Depends on T008.
- [X] T011 [US1] Run T004-T006 (bash and PowerShell) and confirm all now
  pass. **Discovered and fixed a real, pre-existing production bug**
  during this run: `install.sh`/`.ps1` run from any extracted release
  tarball exited non-zero installing shareable hooks, because
  `package-release.sh`/`.ps1` never staged
  `.claude/hooks/dangerous-command-guard.sh`/`.ps1` (specs/041 added the
  read, specs/038/020 never added the corresponding package step) —
  meaning `bootstrap-install.sh`'s entire purpose (install from a
  downloaded release, no clone) has been broken for `claude-code` since
  specs/041 shipped, silently, because `bootstrap-installer-smoke` tests
  against the currently-published pre-041 release. Fixed by staging
  those two files in `package-release.sh`/`.ps1` (see research.md);
  verified exit 0 and byte-identical `.sh`/`.ps1` package trees after the
  fix, both directly and via `package-content-completeness`'s existing
  diff check.
- [X] T012 [US1] Add `install-test-release-marker` and
  `install-test-release-marker-windows-native` jobs to
  `.github/workflows/validate.yml` (real jobs encoding T005's scenarios,
  matching `install-test-shared-hooks`/`-windows-native`'s pattern), and
  extend `package-content-completeness` in place with T004's assertion
  (`bootstrap-installer-smoke` intentionally left unchanged per T006);
  wire the new job names into `ci-gate`'s `needs:` list.

**Checkpoint**: User Story 1 is fully functional and independently
testable — every install (local checkout, manually extracted release
tarball, or real `bootstrap-install.sh` run) leaves the correct marker on
disk. This is the shippable MVP slice (SC-001).

---

## Phase 4: User Story 2 - Session-start freshness line (Priority: P2)

**Goal**: `scripts/session-start.sh`/`.ps1` gain one additive "Part 4"
that compares the on-disk marker (User Story 1) against the latest
published GitHub Release tag and surfaces an update line only when
genuinely behind — advisory-only, single bounded attempt, never a second
hook registration.

**Independent Test**: Seed a project with a known stale marker value,
start a session, and confirm the orientation output names the specific
update path — no live install required, only a marker file and a
reachable (or mocked/blocked) GitHub API (spec.md's own Independent Test
for this story).

### Tests for User Story 2 (write failing first, per Principle IX)

- [X] T013 [P] [US2] Confirm `scripts/bootstrap-install.sh`'s
  `releases/latest` URL construction, opportunistic `GITHUB_TOKEN`
  `Authorization: Bearer` header, and `tag_name` grep/sed extraction as
  the exact technique this story's freshness check reuses — explicitly
  **not** its 3-attempt retry-with-backoff loop (research.md Decision 3).
  No code change — a read-only confirmation.
- [X] T014 [P] [US2] Write a failing test: `session-start.sh`, run
  against a target with a seeded stale `.specify/release-marker.json`,
  outputs a line naming the actual latest published tag and
  `scripts/bootstrap-install.sh`/`.ps1` as the update path — quickstart.md
  Scenario 4, FR-007.
- [X] T015 [P] [US2] Write a failing test: `session-start.sh`, run
  against a target whose marker already matches the actual latest
  published tag, produces no freshness line at all — quickstart.md
  Scenario 5.
- [X] T016 [P] [US2] Write a failing test covering every silent-degrade
  state from data-model.md's Read-side handling table (no marker file,
  malformed JSON, marker holding the `"local-checkout"` sentinel): zero
  freshness line, zero error output, exit 0 in every case — quickstart.md
  Scenario 6, FR-005.
- [X] T017 [P] [US2] Write a failing test: with `GITHUB_TOKEN` unset and
  `api.github.com` unreachable/blocked while a valid marker is present,
  `session-start.sh` still exits 0, produces no error output, and
  completes within its single bounded timeout (no added latency beyond
  one short attempt) — quickstart.md Scenario 6, FR-006, SC-003.

### Implementation for User Story 2

- [X] T018 [US2] Implement the freshness-check function in
  `scripts/session-start.sh` per plan.md's exact snippet: read the
  marker, skip silently unless it holds a real tag, issue a single
  `curl -sSL --max-time 2` attempt (with `GITHUB_TOKEN` header when set)
  against `releases/latest`, extract `tag_name` via the same grep/sed
  technique as T013, compare by exact string match, and set
  `freshness_line` only when they differ. Appended as an additive "Part
  4" after the existing Yoda-line assembly — Parts 1-3's output MUST stay
  byte-identical when `freshness_line` is empty. Depends on T009, T013.
- [X] T019 [P] [US2] Implement identical logic in
  `scripts/session-start.ps1`: `Invoke-RestMethod -TimeoutSec 2` wrapped
  in `try`/`catch` that swallows any exception into silence (the
  PowerShell-idiomatic equivalent of the bash `|| true` pattern already
  used throughout this script), `ConvertFrom-Json` for marker parsing.
  Depends on T010, T018.
- [X] T020 [US2] Run T014-T017 (bash and PowerShell) and confirm all now
  pass. Verified directly: no-marker, malformed-marker, local-checkout
  sentinel, stale-marker (real update line naming the actual latest tag),
  current-marker (silent), and blocked-network (silent, exit 0, <0.5s in
  bash / <2s in PowerShell) — all six states, both platforms.
- [X] T021 [US2] Add `session-start-freshness-check` and
  `session-start-freshness-check-windows-native` jobs to
  `.github/workflows/validate.yml` (real jobs encoding T014-T017), wired
  into `ci-gate`'s `needs:` list.

**Checkpoint**: User Story 2 is fully functional — both user stories
complete the feature end-to-end (Constitution Principle XXII fully
implemented).

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final parity and end-to-end sanity pass before opening the
PR.

- [X] T022 [P] Run `scripts/cross-platform-parity-guard.sh`/`.ps1` against
  every touched pair (`install.sh`/`.ps1`, `package-release.sh`/`.ps1`,
  `session-start.sh`/`.ps1`) and confirm structural parity (Principle
  XIII). All six files confirmed present as pairs.
- [X] T023 Execute `quickstart.md`'s Scenarios 1-7 end-to-end manually
  (bash and PowerShell) as a final pre-PR verification pass. All passed:
  Scenario 1 (local-checkout sentinel), 2 (real tag from extracted
  tarball), 4 (stale marker → update line), 5 (current marker → silent),
  6 (all silent-degrade states + blocked network, <1s), 7 (byte-identical
  sh/ps1 marker output and package trees). Scenario 3
  (`bootstrap-install.sh` against the currently-published release) run
  and confirmed to behave exactly as research.md's "Implementation-time
  discovery" documents — install succeeds, no marker yet, since v0.1.1
  predates this feature; to be re-confirmed once a release containing
  this feature is actually cut.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS both
  user stories (freezes the shared marker schema).
- **User Story 1 (Phase 3)**: Depends on Foundational. No dependency on
  User Story 2.
- **User Story 2 (Phase 4)**: Depends on Foundational *and* User Story 1
  (per spec.md's own stated hard dependency — "User Story 2 is
  unbuildable without this marker existing"). Its tests (T014-T017) need
  a real marker-writing `install.sh` (T009) to seed realistic scratch
  directories against.
- **Polish (Phase 5)**: Depends on both user stories being complete.

### Parallel Opportunities

- T003, T004, T005 (US1 tests) can be written in parallel — different
  job blocks in the same CI file, or read-only confirmation.
- T007/T008 (package-release.sh/.ps1 staging) and T009/T010
  (install.sh/.ps1 marker write) can proceed in parallel pairs once T003
  is confirmed.
- T013-T017 (US2 tests) can be written in parallel once Foundational
  (T002) and User Story 1 (through T009) are done.
- T018/T019 (session-start.sh/.ps1 implementation) are a sequential pair
  (bash first, PowerShell mirrors it), same as every other `.sh`/`.ps1`
  pair in this feature.

---

## Parallel Example: User Story 1

```bash
# Launch US1's independent test-writing tasks together:
Task: "Write failing RELEASE_VERSION assertion in package-content-completeness"
Task: "Write failing install-test-release-marker scratch-dir assertions"

# Launch the two staging implementations together (different files):
Task: "Implement RELEASE_VERSION staging in scripts/package-release.sh"
Task: "Mirror staging in scripts/package-release.ps1"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (freezes the marker schema)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Run quickstart.md Scenarios 1-3 independently
5. This alone satisfies SC-001 and closes Principle XXII's stated
   hard prerequisite — a real, demonstrable increment even before User
   Story 2 lands.

### Incremental Delivery

1. Setup + Foundational → shared schema frozen
2. User Story 1 → validate independently (Scenarios 1-3) → MVP
3. User Story 2 → validate independently (Scenarios 4-7) → full feature
   complete, Constitution Principle XXII fully closed

---

## Notes

- [P] tasks = different files, or independent additions within the same
  file (this repo's own established convention — see specs/041's
  tasks.md)
- No test framework or `jq` dependency introduced anywhere in this
  feature — every check is `curl`/`grep`/`sed` (bash) or native cmdlets
  (PowerShell), matching this project's zero-`jq` precedent
- Commit after each task or logical group
- Stop at the Phase 3 checkpoint to validate User Story 1 independently
  before starting User Story 2
