# Tasks: Expand Shareable Hooks — Push/Commit/Read Guards for `specjedi-*` Projects

**Input**: Design documents from `/specs/058-expand-shareable-hooks/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md

**Tests**: Included — `plan.md`'s Testing section requires new cases in
`.claude/hooks/test-hooks.sh`/`.ps1` and `.github/workflows/validate.yml`'s
`install-test`/`package-content-completeness` jobs (Principle IX, real
scratch-directory assertions, never docs-only). **Revision note
(2026-07-19, post-`specjedi-analyze`)**: the prior version of this file
tested install/wiring correctness only for US1/US2/US3's hooks, never
their actual deny/allow runtime behavior — unlike `dangerous-command-guard.sh`'s
own established behavioral-test precedent, and unlike US5 (which already
had real behavioral tests). This revision adds the missing behavioral,
`python3`-gating, and per-harness test tasks for every story, plus an
explicit manual-verification task for US4 where automated cross-platform
notification-firing assertion isn't practical (specs/042's own
established convention for UX-only requirements).

**Organization**: Tasks are grouped by user story (spec.md priority order:
P1 stories first — US1, US2, US5 — then US3 (P2), then US4 (P3)), so each
story is independently completable and demonstrable.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1-US5, matching
  spec.md's own numbering)

## Phase 1: Setup

- [ ] T001 Create and check out feature branch `058-expand-shareable-hooks`
  from `main` — per `specjedi-implement`'s PR-only workflow, no direct
  commits to trunk.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared `python3`-availability gate US1/US2/US3 each need
before conditionally installing their Python-based hook (FR-005). US4
(settings-only) and US5 (bash, zero-dependency) do NOT depend on this
phase — see Dependencies section.

- [ ] T002 [P] Add `has_python3()` helper to `scripts/install.sh` (near
  the existing `detect_trunk_branch()`): `command -v python3 >/dev/null 2>&1`,
  returning 0/1.
- [ ] T003 [P] Add `Test-Python3Available` helper to `scripts/install.ps1`,
  identical semantics (`Get-Command python3 -ErrorAction SilentlyContinue`).

**Checkpoint**: US1/US2/US3 can now gate their Python-hook install step on
this check.

---

## Phase 3: User Story 1 - `prevent-direct-push` reaches every `specjedi-*`-installed project (Priority: P1)

**Goal**: `prevent-direct-push.py` ships in the shareable bundle, its
protected-branch set adapted to the target's own detected trunk branch.

**Independent Test**: Fresh install with the hook wired in; `git push
origin <trunk>` is denied, `git push origin <feature-branch>` succeeds
(spec.md US1 Acceptance Scenarios).

### Tests for User Story 1 ⚠️

> Write these FIRST, confirm they FAIL before the implementation tasks below.

- [ ] T004 [P] [US1] Add an install-scenario case to
  `.claude/hooks/test-hooks.sh` asserting `prevent-direct-push.py` is
  copied into a scratch target's `.claude/hooks/`, its protected-branch
  set reflects a non-`main`/`master` target trunk (mirroring
  `dangerous-command-guard.sh`'s existing trunk-pattern test), and it's
  wired into the target's `PreToolUse`/`Bash` hooks array.
- [ ] T005 [P] [US1] Identical case in `.claude/hooks/test-hooks.ps1`.
- [ ] T006 [P] [US1] **Behavioral test** (closes the `specjedi-analyze`
  gap): in a new `--- prevent-direct-push.py ---` section of
  `.claude/hooks/test-hooks.sh`, invoke the hook script directly with
  mock stdin — a `git push origin <trunk>` command on the target's trunk
  branch MUST produce a deny decision (spec.md Acceptance Scenario 1); a
  `git push origin <feature-branch>` command, including while checked
  out on the trunk branch, MUST produce allow (Acceptance Scenario 2).
  Mirrors `dangerous-command-guard.sh`'s own dedicated behavioral-test
  section, not just its install-scenario coverage.
- [ ] T007 [P] [US1] **`python3`-gating test**: simulate `python3`
  absence (e.g. a `PATH` override in the test harness) and assert a
  scratch-target install does NOT copy `prevent-direct-push.py` at all
  (FR-005).
- [ ] T008 [P] [US1] **Wave 1/2 harness-translation test**: assert a
  `gemini-cli`/`antigravity`/`codex-cli` scratch install produces a
  translated `prevent-direct-push.py`-equivalent guard whose deny/allow
  behavior matches T006 (mirrors `specs/041-release-hooks-settings/tasks.md`'s
  own per-harness test precedent, e.g. its T027/T030/T033).

### Implementation for User Story 1

- [ ] T009 [P] [US1] Extend `scripts/install.sh`'s
  `harness = "claude-code"` shareable-hooks block (~L1026) to `cp` +
  trunk-pattern-substitute `prevent-direct-push.py` into
  `$target_hooks_dir` (same `sed` substitution `dangerous-command-guard.sh`
  already uses), gated on `has_python3` (depends on T002); wire it into
  the target's `PreToolUse`/`Bash` hooks array alongside
  `dangerous-command-guard.sh`. Until T004/T006/T007 pass.
- [ ] T010 [P] [US1] Identical addition in `scripts/install.ps1` (depends
  on T003). Until T005 passes.
- [ ] T011 [P] [US1] Stage `prevent-direct-push.py` in
  `scripts/package-release.sh`'s `.claude/hooks/` copy block
  (research.md Decision 4).
- [ ] T012 [P] [US1] Identical staging in `scripts/package-release.ps1`.
- [ ] T013 [US1] Add `.claude/hooks/prevent-direct-push.py` to
  `.github/workflows/validate.yml`'s `package-content-completeness`
  job's "must be present" list.
- [ ] T014 [US1] Extend the Wave 1/2 per-harness translation functions
  (`install_hooks_gemini_cli`, `install_hooks_antigravity`,
  `install_hooks_codex_cli`) to also translate `prevent-direct-push.py`,
  reusing `render_gemini_style_guard()`'s existing pattern (FR-007/FR-011).
  Until T008 passes.

**Checkpoint**: US1 fully functional and independently testable — both
its installation AND its actual deny/allow behavior.

---

## Phase 4: User Story 2 - `secret-scanner` reaches every `specjedi-*`-installed project (Priority: P1)

**Goal**: `secret-scanner.py` ships in the shareable bundle, with its
denial-message redaction fix (FR-012) already carried in.

**Independent Test**: Fresh install; a commit with a real-looking secret
is blocked (redacted match shown), a clean commit proceeds (spec.md US2
Acceptance Scenarios).

### Tests for User Story 2 ⚠️

- [ ] T015 [P] [US2] Add a regression case to
  `.claude/hooks/test-hooks.sh`/`.ps1` confirming `secret-scanner.py`'s
  denial output shows a redacted match (`sk-a****...3f2b` shape, first 4
  + last 4 characters) rather than the raw matched value (FR-012).
- [ ] T016 [P] [US2] Add an install-scenario case asserting
  `secret-scanner.py` is copied+wired for a scratch target, including its
  existing self-exclusion behavior (PR #151) surviving the copy.
- [ ] T017 [P] [US2] **Behavioral test** (closes the `specjedi-analyze`
  gap): in a new `--- secret-scanner.py ---` section of
  `.claude/hooks/test-hooks.sh`, invoke the hook directly against a
  staged file containing a real-looking secret pattern (e.g. a Stripe
  live-key shape) and assert the commit is blocked (Acceptance Scenario
  1); against a clean staged file, assert it proceeds unblocked
  (Acceptance Scenario 2).
- [ ] T018 [P] [US2] **`python3`-gating test**: `python3` absent →
  `secret-scanner.py` not copied for a scratch install (FR-005).
- [ ] T019 [P] [US2] **Wave 1/2 harness-translation test**: assert
  `gemini-cli`/`antigravity`/`codex-cli` scratch installs produce a
  translated `secret-scanner.py`-equivalent with matching block/allow
  behavior (mirrors specs/041's own per-harness test precedent).

### Implementation for User Story 2

- [ ] T020 [US2] Verify T015/T017 pass against
  `.claude/hooks/secret-scanner.py` — the redaction fix (FR-012) was
  already applied during this feature's `specjedi-plan` pass
  (`specjedi-security` self-invocation, 2026-07-19); this task is
  pre-completed pending T015/T017's confirmation, not a new
  implementation.
- [ ] T021 [P] [US2] Extend `scripts/install.sh`'s claude-code block to
  `cp` `secret-scanner.py` unmodified, gated on `has_python3` (depends on
  T002); wire into `PreToolUse`/`Bash`. Until T016/T018 pass.
- [ ] T022 [P] [US2] Identical addition in `scripts/install.ps1` (depends
  on T003).
- [ ] T023 [US2] Stage `secret-scanner.py` in `package-release.sh`/`.ps1`
  (both files — small, same-shaped addition, tracked as one task).
- [ ] T024 [US2] Add to `validate.yml`'s `package-content-completeness`
  list.
- [ ] T025 [US2] Extend Wave 1/2 harness translation functions for
  `secret-scanner.py` (FR-007/FR-011). Until T019 passes.

**Checkpoint**: US1 and US2 both independently functional, including
their actual deny/allow behavior.

---

## Phase 5: User Story 5 - Secret/credential file reads are actively blocked, not just declared (Priority: P1)

**Goal**: A new `secret-file-guard.sh`/`.ps1` hook actively denies
`Read`/`Grep`/`Glob` calls targeting secret/credential file patterns at
any directory depth; `permissions.deny` is broadened as defense-in-depth.

**Independent Test**: Fresh install; `Read` on root `.env` and nested
`packages/api/.env` both denied, `.env.example` and unrelated files
proceed unblocked (spec.md US5 Acceptance Scenarios, SC-005/SC-006).

### Tests for User Story 5 ⚠️

- [ ] T026 [P] [US5] Write failing cases in a new
  `--- secret-file-guard.sh ---` section of `.claude/hooks/test-hooks.sh`:
  root `.env` denied; nested `packages/api/.env` denied (SC-005);
  `.env.example`/`.env.sample`/`.env.template` allowed (SC-006); an
  unrelated file allowed; a `Grep`/`Glob` call whose `path` is a
  directory (not a specific secret file) never denied (research.md
  Decision 3).
- [ ] T027 [P] [US5] Identical cases in `.claude/hooks/test-hooks.ps1`.
- [ ] T028 [P] [US5] **Wave 1/2 harness-translation test**: for each
  harness plan.md's Scale/Scope scopes FR-011 to (confirmed distinct
  Read/file-access hook surface, per specs/041 `research.md`), assert a
  scratch install produces the translated guard with matching deny/allow
  behavior; for a harness explicitly excluded from FR-011 (shell-command-
  surface-only), assert instead that its `dangerous-command-guard.sh`
  translation's own `read_cmd` check already denies the same pattern set
  — closing the same per-harness test gap `specjedi-analyze` found for
  US1/US2.

### Implementation for User Story 5

- [ ] T029 [P] [US5] Create `.claude/hooks/secret-file-guard.sh` (new,
  bash, zero-dependency): parse stdin JSON, extract
  `tool_input.file_path` (`Read`) or `tool_input.path` (`Grep`/`Glob`),
  deny via `hookSpecificOutput.permissionDecision` (same contract
  `dangerous-command-guard.sh` uses) only when that field names a
  specific file whose basename matches the FR-009 pattern set
  (`.env`/`.env.*` minus template variants, `id_rsa`/`id_dsa`/
  `id_ecdsa`/`id_ed25519`, `*.pem`/`*.key`/`*.pfx`/`*.p12`, `.npmrc`,
  `.netrc`, `.pgpass`, `.git-credentials`, `.aws/credentials`,
  `.docker/config.json`); never deny when the field is a directory or
  absent. Until T026 passes.
- [ ] T030 [P] [US5] Create `.claude/hooks/secret-file-guard.ps1`,
  identical logic. Until T027 passes.
- [ ] T031 [US5] Wire `secret-file-guard.sh` into this repo's own
  `.claude/settings.json` `PreToolUse` `Read|Grep|Glob` matcher
  (dogfooding, same convention every other repo-local hook already
  follows).
- [ ] T032 [US5] Broaden this repo's own `.claude/settings.json`
  `permissions.deny` patterns from `Read(./...)` to `Read(**/...)`,
  expanded to the same pattern set as T029 (FR-010, defense-in-depth).
- [ ] T033 [P] [US5] Broaden `update_shared_settings()`'s
  `permissions_block` in `scripts/install.sh` identically (depends on
  T032 for the confirmed pattern set).
- [ ] T034 [P] [US5] Identical broadening in `scripts/install.ps1`.
- [ ] T035 [P] [US5] Extend `scripts/install.sh`'s claude-code block to
  copy `secret-file-guard.sh` (no `has_python3` gate — bash,
  zero-dependency) and wire it into the target's `PreToolUse`
  `Read|Grep|Glob` matcher.
- [ ] T036 [P] [US5] Identical addition in `scripts/install.ps1`.
- [ ] T037 [US5] Stage `secret-file-guard.sh`/`.ps1` in
  `package-release.sh`/`.ps1` (both files, one task).
- [ ] T038 [US5] Add both to `validate.yml`'s `package-content-completeness`
  list.
- [ ] T039 [US5] Extend Wave 1/2 per-harness translation for
  `secret-file-guard.sh` per the scoping rule in T028/plan.md Scale/Scope
  — for each of Gemini CLI/Antigravity/Codex CLI/OpenCode/Zed/Warp/Amazon
  Q, either translate it or document inline why that harness's own
  `dangerous-command-guard.sh` translation already covers the equivalent
  ground — never a silent omission either way. Until T028 passes.

**Checkpoint**: US1, US2, and US5 (all P1) independently functional —
the MVP slice per spec.md's own priority ordering.

---

## Phase 6: User Story 3 - `conventional-commits` reaches every `specjedi-*`-installed project, opt-in (Priority: P2)

**Goal**: `conventional-commits.py` is offered via its own separate,
default-off Y/n prompt (never bundled into the main hooks/permissions
prompt).

**Independent Test**: Opting in installs and enforces the hook; declining
(or a non-interactive run) leaves the target completely unchanged with
respect to it (spec.md US3 Acceptance Scenarios).

### Tests for User Story 3 ⚠️

- [ ] T040 [P] [US3] Add cases to `.claude/hooks/test-hooks.sh`/`.ps1`
  asserting: the second prompt defaults to declined (`[y/N]`, no answer
  = no install); an explicit "y" installs and wires the hook; a
  non-interactive invocation never installs it.
- [ ] T041 [P] [US3] **Behavioral test** (closes the `specjedi-analyze`
  gap): in a new `--- conventional-commits.py ---` section, invoke the
  hook directly with a non-conventional commit message (e.g. `"fixed a
  thing"`) and assert deny naming the `type: description` format
  (Acceptance Scenario 1); with a conforming message, assert allow.
- [ ] T042 [P] [US3] **`python3`-gating test**: `python3` absent →
  `conventional-commits.py` not installed even when opted in (FR-005).
- [ ] T043 [P] [US3] **Wave 1/2 harness-translation test**: for each
  harness with an equivalent opt-in prompt mechanism, assert a scratch
  install offers and (when accepted) wires the translated hook with
  matching deny/allow behavior; document any harness excluded and why.

### Implementation for User Story 3

- [ ] T044 [P] [US3] Add the second interactive prompt to
  `scripts/install.sh` immediately after the existing
  `install_shared_hooks` prompt (~L379): `install_conventional_commits=0`,
  `[y/N]` idiom, only asked when `interactive_mode` and
  `install_shared_hooks` are both true (plan.md Implementation notes).
  Until T040 passes.
- [ ] T045 [P] [US3] Identical prompt in `scripts/install.ps1`.
- [ ] T046 [P] [US3] Extend `install.sh`'s claude-code block to
  conditionally `cp` + wire `conventional-commits.py` only when
  `install_conventional_commits=1`, gated on `has_python3` (depends on
  T002). Until T041/T042 pass.
- [ ] T047 [P] [US3] Identical in `install.ps1`.
- [ ] T048 [US3] Stage `conventional-commits.py` in
  `package-release.sh`/`.ps1` (both files, one task).
- [ ] T049 [US3] Add to `validate.yml`'s `package-content-completeness`
  list.
- [ ] T050 [US3] Extend Wave 1/2 harness translation for
  `conventional-commits.py`. Until T043 passes.

**Checkpoint**: US1, US2, US5, US3 all independently functional.

---

## Phase 7: User Story 4 - Desktop notification on response completion reaches installed projects (Priority: P3)

**Goal**: A `Stop` hook (native OS notification) reaches installed
projects, wired non-destructively.

**Independent Test**: A response completes; exactly one notification
fires on macOS/Linux, nothing errors on a platform with neither
mechanism (spec.md US4 Acceptance Scenarios).

### Tests for User Story 4 ⚠️

- [ ] T051 [P] [US4] Add a case to `.claude/hooks/test-hooks.sh`/`.ps1`
  asserting a scratch target's `.claude/settings.json` gains the `Stop`
  hook block (osascript/notify-send fallback) on shareable-hooks install,
  non-destructively (leaves an existing `Stop` array alone, per the same
  discipline `update_shared_settings()` already applies to
  `statusLine`/`permissions`).
- [ ] T052 [US4] **Manual-verification note** (not automated — real OS
  notification firing isn't practically assertable in CI, matching
  specs/042's own established convention for UX-only requirements): once
  T053/T054 land, manually confirm on macOS and on Linux (or record why
  one platform was unavailable) that exactly one notification fires per
  completed response, and that a platform with neither `osascript` nor
  `notify-send` errors on nothing. Record the result inline in this file
  next to this task (date, platform, outcome) — this closes the
  `specjedi-analyze`-flagged Unverified status for FR-004's Acceptance
  Scenarios with an explicit, honest disposition rather than a silent gap.

### Implementation for User Story 4

- [ ] T053 [P] [US4] Add `Stop`-hook wiring to `scripts/install.sh`:
  call `merge_json_key "$target_dir/.claude/settings.json" '"Stop"'
  "$stop_block" "Stop notification hook wired"` with the exact
  `stop_block` content `plan.md`'s Implementation notes now specify
  (copied verbatim from this repo's own `.claude/settings.json` Stop
  entry) — no new merge routine, this is `merge_json_key()`'s own
  designed case (simple key-presence check). Until T051 passes.
  *(Previously flagged by `specjedi-analyze` as ungrounded in `plan.md`;
  resolved via a `specjedi-plan` amendment, 2026-07-19 — `plan.md` now
  names `merge_json_key()` reuse explicitly with the exact block
  content.)*
- [ ] T054 [P] [US4] Identical addition in `scripts/install.ps1`, via
  `Merge-JsonKey` (confirmed present at `scripts/install.ps1:882`, same
  `-Target`/`-KeyCheck`/`-Block`/`-OkMessage` parameters every other Wave
  1/2 call site already uses).

**Checkpoint**: All five user stories independently functional.

---

## Phase 8: Polish & Cross-Cutting Concerns

- [ ] T055 Update the "target already has a `PreToolUse`/`Stop` hooks
  array — add manually" messages in `install.sh`/`.ps1` (FR-006) to name
  every newly-shareable hook this feature adds
  (`prevent-direct-push.py`, `secret-scanner.py`, `secret-file-guard.sh`,
  `conventional-commits.py` when opted in, the `Stop` notification hook)
  — not just `dangerous-command-guard.sh`.
- [ ] T056 [P] Add a test case confirming T055's message names every new
  hook (closes the previously-Unverified FR-006).
- [ ] T057 Extend the Codex CLI trust-workflow output message (carried
  from specs/041's plan.md) to name every new hook, not just the
  original — the end-user must still run `/hooks` inside Codex CLI to
  approve each one.
- [ ] T058 **`python3`-absent combined-warning test**: with all of
  US1/US2/US3 landed, simulate `python3` absence and assert install.sh
  prints exactly ONE named warning listing all three skipped hooks
  together (`secret-scanner.py`, `prevent-direct-push.py`,
  `conventional-commits.py`) — never three separate per-hook messages
  (FR-005's exact wording). This is the one FR-005 assertion that can
  only be meaningfully tested once every Python-hook story has landed;
  T007/T018/T042 each cover their own story's skip in isolation.
- [ ] T059 Full `install-test`/`install-test-*` CI job pass across every
  matrixed OS/harness in `.github/workflows/validate.yml`, confirming
  every new hook, prompt, and packaging path end-to-end — this run also
  serves as FR-008's regression check (`dangerous-command-guard.sh`'s own
  pre-existing, untouched test section is part of this same CI pass).
- [ ] T060 [P] Update `references/harness-capability-notes.md` if T014,
  T025, T039, or T050 surfaced any refinement to a Wave 1/2 harness's
  documented hook capability.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately.
- **Foundational (Phase 2)**: Depends on Setup. Blocks US1/US2/US3 only
  (their Python-hook install step needs `has_python3`) — does **not**
  block US4 (settings-only) or US5 (bash, zero-dependency); those two
  may start immediately after Setup.
- **User Stories (Phase 3-7)**: US1/US2/US5 (all P1) can proceed in
  parallel once their own prerequisites clear; US3 (P2) and US4 (P3) are
  independent of every other story and may also start any time after
  Setup.
- **Polish (Phase 8)**: Depends on every story whose hook it references
  being complete — T055/T057/T059 specifically need every story's final
  hook list; T058 specifically needs US1+US2+US3 all landed (the one
  genuinely cross-story test in this feature).

### User Story Dependencies

- **US1 (P1)**: Foundational (T002/T003) only. No dependency on any
  other story.
- **US2 (P1)**: Foundational (T002/T003) only. No dependency on US1.
- **US5 (P1)**: No dependency on Foundational or any other story — bash,
  zero-dependency, entirely self-contained.
- **US3 (P2)**: Foundational (T002/T003) only. No dependency on
  US1/US2/US5.
- **US4 (P3)**: No dependency on Foundational or any other story.

### Within Each User Story

- Tests written and confirmed failing before implementation (Principle
  VI) — every story's Tests subsection precedes its Implementation
  subsection above, including the behavioral, `python3`-gating, and
  per-harness tests added in this revision.
- Hook file created before it's wired into `install.sh`/`.ps1`.
- `install.sh`/`.ps1` wiring before `package-release.sh`/`.ps1` staging
  (a hook must exist at its final repo path before packaging references
  it) before `validate.yml`'s completeness-list addition.
- Wave 1/2 per-harness translation last within each story — it adapts an
  already-working Claude Code implementation, never the reverse.

### Parallel Opportunities

- T002/T003 (Foundational) in parallel.
- Within each story, the `.sh`/`.ps1` test-writing tasks run in parallel
  (different files); the `.sh`/`.ps1` implementation tasks that follow do
  not (each depends on its own story's test task, but the two language
  tracks are otherwise independent and could run in parallel across
  developers).
- US1, US2, US5 may be built in parallel by different developers once
  Setup completes (US5 has zero blocking dependency; US1/US2 each only
  need Foundational).

---

## Implementation Strategy

### MVP First (P1 stories only)

1. Complete Phase 1 (Setup) + Phase 2 (Foundational).
2. Complete Phase 3 (US1), Phase 4 (US2), Phase 5 (US5) — the three P1
   stories, independently testable and shippable as one PR or three.
3. **STOP and VALIDATE**: run every Tests-subsection task for US1/US2/US5
   (T004-T008, T015-T019, T026-T028) plus a real scratch-directory
   install for each, per spec.md's own SC-001 through SC-006.
4. Ship the MVP; US3/US4 (P2/P3) follow as incremental additions.

### Incremental Delivery

1. Setup + Foundational → foundation ready for US1/US2/US3.
2. US1 → test independently (install AND behavior) → merge.
3. US2 → test independently (install AND behavior) → merge.
4. US5 → test independently → merge (no dependency on 1-2, could equally
   land first).
5. US3 → test independently → merge.
6. US4 → test independently (settings wiring automated, notification
   firing manually verified per T052) → merge.
7. Phase 8 Polish (including T058's cross-story test) once every story
   intended for this release has landed.

---

## Notes

- [P] tasks touch different files with no shared state — verified per
  task above, not assumed.
- Every task's file path and convention traces to `plan.md`'s Project
  Structure or Implementation notes — including T053/T054's `Stop`-hook
  `merge_json_key()`/`Merge-JsonKey` reuse, resolved via a `specjedi-plan`
  amendment (2026-07-19) after `specjedi-analyze` flagged it as
  previously ungrounded.
- Commit after each task or logical group, PR-only per Phase 1's T001
  (no direct commits to `main`).
- Stop at each story's Checkpoint to validate independently before
  moving on.
