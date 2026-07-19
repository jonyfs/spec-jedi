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

- [x] T002 [P] Add `has_python3()` helper to `scripts/install.sh` (near
  the existing `detect_trunk_branch()`): `command -v python3 >/dev/null 2>&1`,
  returning 0/1.
- [x] T003 [P] Add `Test-Python3Available` helper to `scripts/install.ps1`,
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

- [x] T004 [P] [US1] ~~Add an install-scenario case to
  `.claude/hooks/test-hooks.sh`~~ **Corrected location during
  implementation**: real install-scenario/trunk-substitution tests for
  the claude-code shareable-hooks bundle live in
  `.github/workflows/validate.yml`'s `install-test-shared-hooks` job
  (`test-hooks.sh` is for direct hook-invocation behavioral tests only —
  confirmed by reading both files; `dangerous-command-guard.sh`'s own
  trunk-substitution assertion lives there too, not in `test-hooks.sh`).
  Added `prevent-direct-push.py` presence + `PreToolUse`/`Bash` wiring
  assertions to that job's existing steps, plus the `develop`-trunk
  scenario's own `PROTECTED = {"develop"}` assertion. Verified via a
  real scratch install (bash).
- [x] T005 [P] [US1] Identical assertions added to
  `install-test-shared-hooks-windows-native`. Verified via a real
  scratch install (native `pwsh`).
- [x] T006 [P] [US1] **Behavioral test** (closes the `specjedi-analyze`
  gap): in a new `--- prevent-direct-push.py ---` section of
  `.claude/hooks/test-hooks.sh`, invoke the hook script directly with
  mock stdin — a `git push origin <trunk>` command on the target's trunk
  branch MUST produce a deny decision (spec.md Acceptance Scenario 1); a
  `git push origin <feature-branch>` command, including while checked
  out on the trunk branch, MUST produce allow (Acceptance Scenario 2).
  Mirrors `dangerous-command-guard.sh`'s own dedicated behavioral-test
  section, not just its install-scenario coverage. 5/5 cases pass
  against the existing (unmodified) hook.
- [x] T007 [P] [US1] **`python3`-gating test**: simulate `python3`
  absence (e.g. a `PATH` override in the test harness) and assert a
  scratch-target install does NOT copy `prevent-direct-push.py` at all
  (FR-005). Added to `install-test-shared-hooks` (bash) via a
  shadow-`PATH` technique (real coreutils symlinked, `python3`
  deliberately excluded); verified real skip + named warning +
  `dangerous-command-guard.sh` unaffected.
- [x] T008 [P] [US1] **Wave 1/2 harness-translation test**: assert a
  `gemini-cli`/`antigravity`/`codex-cli` scratch install produces a
  translated `prevent-direct-push.py`-equivalent guard whose deny/allow
  behavior matches T006 (mirrors `specs/041-release-hooks-settings/tasks.md`'s
  own per-harness test precedent, e.g. its T027/T030/T033).

### Implementation for User Story 1

- [x] T009 [P] [US1] Extend `scripts/install.sh`'s
  `harness = "claude-code"` shareable-hooks block to `cp` +
  trunk-pattern-substitute `prevent-direct-push.py` (a new
  `build_python_protected_set()` helper builds the Python-set-literal
  substitution — `PROTECTED = {"main", "develop"}` isn't the same syntax
  as `dangerous-command-guard.sh`'s bash case-pattern, a real correction
  found during implementation, not assumed from `plan.md`); gated on
  `has_python3`; wired into `PreToolUse`/`Bash` alongside
  `dangerous-command-guard.sh` via a generalized multi-hook `hooks_block`
  builder (also handles the "target already has a `PreToolUse` array"
  case per-hook, FR-006). Verified: fresh install, `develop`-trunk
  install, idempotent re-run, and pre-existing-array scenarios all pass
  via real scratch installs.
- [x] T010 [P] [US1] Identical addition in `scripts/install.ps1`
  (`Test-Python3Available`, matching multi-hook `$bashHookEntries`
  builder). Verified via a real scratch install (native `pwsh`).
- [x] T011 [P] [US1] Stage `prevent-direct-push.py` in
  `scripts/package-release.sh`'s `.claude/hooks/` copy block
  (research.md Decision 4). Verified: built a real tarball, confirmed
  the file is actually present inside it.
- [x] T012 [P] [US1] Identical staging in `scripts/package-release.ps1`
  (syntax-verified via `pwsh` AST parse).
- [x] T013 [US1] Added `.claude/hooks/prevent-direct-push.py` to both
  `package-content-completeness` assertion blocks (bash and PowerShell
  variants) in `.github/workflows/validate.yml`.
- [x] T014 [US1] Extended `install_hooks_gemini_cli`/
  `install_hooks_antigravity`/`install_hooks_codex_cli`: a new
  `render_gemini_style_push_guard()` does a targeted, assertion-guarded
  source-to-source transform of the real `prevent-direct-push.py` file
  (stdin parsing unchanged, only the deny-output shape + trunk
  substitution differ) for Gemini CLI/Antigravity; Codex CLI reuses the
  file unmodified (structurally identical `hooks.json` contract, same as
  `dangerous-command-guard.sh`'s own Codex CLI treatment). Wave 2
  (OpenCode/Zed/Warp/Amazon Q) intentionally out of scope, matching
  specs/041's own established precedent (permissions-only, no hook
  translation attempted for those four). Verified via real scratch
  installs for all three Wave 1 harnesses, including a functional
  deny/allow test of the translated Gemini CLI output.

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

- [x] T015 [P] [US2] Add a regression case to
  `.claude/hooks/test-hooks.sh`/`.ps1` confirming `secret-scanner.py`'s
  denial output shows a redacted match (`sk-a****...3f2b` shape, first 4
  + last 4 characters) rather than the raw matched value (FR-012).
- [x] T016 [P] [US2] **Corrected location during implementation** (same
  finding as T004): added `secret-scanner.py` presence + `PreToolUse`/
  `Bash` wiring assertions to `install-test-shared-hooks`
  (bash + windows-native) in `validate.yml`, not `test-hooks.sh`.
- [x] T017 [P] [US2] **Behavioral test** (closes the `specjedi-analyze`
  gap): in a new `--- secret-scanner.py ---` section of
  `.claude/hooks/test-hooks.sh`, a real temp git repo stages a file with
  a Stripe-live-key-shaped secret and invokes the hook directly —
  confirmed blocked (Acceptance Scenario 1) with a redacted match, and a
  clean file confirmed allowed (Acceptance Scenario 2). Found and fixed
  a real capture bug while writing this (the hook prints to stderr and
  signals block via exit 2, not stdout — `2>&1` was required).
- [x] T018 [P] [US2] **`python3`-gating test**: extended the same
  shadow-`PATH` CI step from US1 (T007) — both `prevent-direct-push.py`
  and `secret-scanner.py` skip together with one combined named warning
  (FR-005's "one named warning" requirement, verified directly).
- [x] T019 [P] [US2] **Wave 1/2 harness-translation test**: verified via
  real scratch installs for `gemini-cli`/`antigravity`/`codex-cli`,
  including a functional test of the wrapped Gemini CLI output (real
  secret → `{"decision":"deny",...}` + exit 2; clean file → allow).

### Implementation for User Story 2

- [x] T020 [US2] Verified: T015/T017 pass against
  `.claude/hooks/secret-scanner.py` — the redaction fix (FR-012) was
  already applied during this feature's `specjedi-plan` pass
  (`specjedi-security` self-invocation, 2026-07-19); this task was
  pre-completed, confirmed by T015/T017's 5/5 passing assertions.
- [x] T021 [P] [US2] Extended `scripts/install.sh`'s claude-code block to
  `cp` `secret-scanner.py` unmodified, gated on `has_python3` (nested
  inside the same gate as prevent-direct-push.py, so both skip together
  with FR-005's single combined warning); wired into `PreToolUse`/`Bash`
  via the same multi-hook block builder.
- [x] T022 [P] [US2] Identical addition in `scripts/install.ps1`.
- [x] T023 [US2] Staged `secret-scanner.py` in `package-release.sh`/`.ps1`.
  Verified: built a real tarball, confirmed both Python hooks present.
- [x] T024 [US2] Added `.claude/hooks/secret-scanner.py` to both
  `package-content-completeness` assertion blocks.
- [x] T025 [US2] Extended Wave 1/2 harness translation: a new
  `render_gemini_style_scanner_wrapper()` wraps the real, unmodified
  `secret-scanner.py` as a subprocess (its block output is spread across
  several `print()` calls, unlike `prevent-direct-push.py`'s single
  `deny()` call, so wrapping — not transforming — its exit
  code/stderr into the `{"decision":"deny",...}` shape is the more
  robust translation) for Gemini CLI/Antigravity; Codex CLI reuses it
  unmodified. Also extended `install.ps1`'s own Wave 1 functions
  (`Get-GeminiStylePushGuardScript`, `Get-GeminiStyleScannerWrapperScript`,
  `Get-PythonProtectedSet`) — these hadn't existed at all before this
  story, a real Principle XIII parity gap found and closed during
  implementation, not assumed present from `plan.md`. Verified via real
  scratch installs (bash and native `pwsh`) for all three Wave 1
  harnesses, including a functional deny/allow test of the wrapped
  Gemini CLI output.

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

- [x] T026 [P] [US5] Write failing cases in a new
  `--- secret-file-guard.sh ---` section of `.claude/hooks/test-hooks.sh`:
  root `.env` denied; nested `packages/api/.env` denied (SC-005);
  `.env.example`/`.env.sample`/`.env.template` allowed (SC-006); an
  unrelated file allowed; a `Grep`/`Glob` call whose `path` is a
  directory (not a specific secret file) never denied (research.md
  Decision 3). Confirmed red (hook didn't exist yet) before T029.
  13/13 passed once T029 landed.
- [x] T027 [P] [US5] Identical cases in `.claude/hooks/test-hooks.ps1`.
  13/13 passed against T030.
- [x] T028 [P] [US5] **Wave 1/2 harness-translation test**: research
  confirmed none of Gemini CLI/Antigravity/Codex CLI have a hook surface
  distinct from Bash/shell-command (specs/041 `research.md`) — so all
  three are the "excluded, shell-command-surface-only" case, not the
  "translate separately" case. Verified their shared reliance is
  actually true (not just documented) by widening
  `dangerous-command-guard.sh`'s own `read_cmd` check — repo-local
  `.sh`/`.ps1` copies AND both Gemini-translation heredoc/template
  copies in `install.sh`/`.ps1` — to the full FR-009 pattern set (it
  was previously narrower: missing `id_dsa`/`id_ecdsa`, `*.key`/
  `*.pfx`/`*.p12`, `.npmrc`/`.netrc`/`.pgpass`/`.git-credentials`,
  `.aws/credentials`, `.docker/config.json`). Verified via real scratch
  installs and direct hook invocation (bash and native `pwsh`) that the
  translated guard now genuinely blocks the widened set.

### Implementation for User Story 5

- [x] T029 [P] [US5] Created `.claude/hooks/secret-file-guard.sh`
  matching FR-009 exactly, plus a compound-path check (`.aws/credentials`,
  `.docker/config.json`) matched by path suffix rather than basename
  (a bare-basename match on "credentials"/"config.json" would be
  dangerously overbroad — found while implementing, not in the original
  plan). 13/13 T026 cases passed first run.
- [x] T030 [P] [US5] Created `.claude/hooks/secret-file-guard.ps1`,
  identical logic (regex-based path normalization for the compound
  patterns). 13/13 T027 cases passed first run.
- [x] T031 [US5] Wired `secret-file-guard.sh` into this repo's own
  `.claude/settings.json` as a new, separate `PreToolUse`
  `Read|Grep|Glob` array entry (kept independent from the existing
  `Read|Glob` → `graphify hook-guard read` entry, avoiding any side
  effect on that unrelated mechanism).
- [x] T032 [US5] Broadened this repo's own `.claude/settings.json`
  `permissions.deny` from `Read(./...)` to `Read(**/...)`, expanded to
  the full FR-009/FR-010 pattern set.
- [x] T033 [P] [US5] Broadened `update_shared_settings()`'s
  `permissions_block` in `scripts/install.sh` identically.
- [x] T034 [P] [US5] Identical broadening in `scripts/install.ps1`.
- [x] T035 [P] [US5] Extended `scripts/install.sh`'s claude-code block:
  copies `secret-file-guard.sh` unconditionally (no `has_python3` gate)
  and wires it into a new `PreToolUse` `Read|Grep|Glob` matcher array,
  via the same multi-hook-list/manual-add-message machinery US1/US2
  already established (generalized to a second matcher). Verified: real
  scratch install, functional deny/allow test of the *installed* copy
  (not just the repo source), idempotent re-run, `python3`-absent
  install (confirms it's never skipped, unlike the Python hooks).
- [x] T036 [P] [US5] Identical addition in `scripts/install.ps1`.
  Verified via a real scratch install (native `pwsh`): file present,
  second `PreToolUse` matcher present, installed copy functionally
  blocks/allows correctly.
- [x] T037 [US5] Staged `secret-file-guard.sh`/`.ps1` in
  `package-release.sh`/`.ps1`. Verified: built a real tarball, all 6
  expected hook files present (`dangerous-command-guard.sh`/`.ps1`,
  `prevent-direct-push.py`, `secret-scanner.py`,
  `secret-file-guard.sh`/`.ps1`).
- [x] T038 [US5] Added both to both `package-content-completeness`
  assertion blocks.
- [x] T039 [US5] Per T028's finding, no Wave 1/2 harness gets a
  separate `secret-file-guard.sh` translation — Wave 2
  (OpenCode/Zed/Warp/Amazon Q) was already out of scope for hooks per
  specs/041 precedent, and Wave 1 (Gemini CLI/Antigravity/Codex CLI) has
  no distinct Read-tool hook surface, so the existing (now-widened)
  `dangerous-command-guard.sh` translation is the actual, verified
  equivalent-coverage mechanism — not a silent omission, a documented
  and tested one (new CI step in `install-test-shared-hooks-wave1`).

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

- [x] T040 [P] [US3] Add cases to `.claude/hooks/test-hooks.sh`/`.ps1`
  asserting: the second prompt defaults to declined (`[y/N]`, no answer
  = no install); an explicit "y" installs and wires the hook; a
  non-interactive invocation never installs it.
  Verified: `--- conventional-commits.py ---` section added to both
  `test-hooks.sh` and `test-hooks.ps1`; `bash .claude/hooks/test-hooks.sh`
  and `pwsh -File .claude/hooks/test-hooks.ps1` both report "All hook
  tests passed."
- [x] T041 [P] [US3] **Behavioral test** (closes the `specjedi-analyze`
  gap): in a new `--- conventional-commits.py ---` section, invoke the
  hook directly with a non-conventional commit message (e.g. `"fixed a
  thing"`) and assert deny naming the `type: description` format
  (Acceptance Scenario 1); with a conforming message, assert allow.
  Verified: `check_commit_msg()` helper in both test scripts covers
  non-conventional (blocked), `feat:`/`fix(scope):` (allowed), and a
  non-commit command (allowed, nothing to check) — 4/4 passing on both
  platforms.
- [x] T042 [P] [US3] **`python3`-gating test**: `python3` absent →
  `conventional-commits.py` not installed even when opted in (FR-005).
  Verified: `validate.yml`'s "python3 absence skips conventional-commits.py
  even when opted in (US3, FR-005)" step combines
  `SPECJEDI_TEST_FORCE_NO_PYTHON3=1` with `SPECJEDI_TEST_FORCE_HOOKS_PROMPT=1`
  and asserts both the combined skip-warning and the file's absence;
  confirmed locally before commit.
- [x] T043 [P] [US3] **Wave 1/2 harness-translation test**: for each
  harness with an equivalent opt-in prompt mechanism, assert a scratch
  install offers and (when accepted) wires the translated hook with
  matching deny/allow behavior; document any harness excluded and why.
  Verified: `validate.yml`'s `install-test-shared-hooks-wave1` (bash) and
  `install-test-shared-hooks-wave1-windows-native` (PowerShell) jobs both
  gained a "conventional-commits.py opt-in translates correctly for all
  three Wave 1 harnesses" step covering gemini-cli/antigravity/codex-cli
  accept + a declined case; confirmed locally on macOS for both shells
  (bash step directly, PowerShell step via a genuine
  `pwsh -File`-into-child-process pipe, matching the pipe-semantics fix
  already documented for T044/T045 below). Wave 2 harnesses
  (opencode/zed/amazon-q/warp) are excluded: they only receive a
  permissions-file translation, never a hook mechanism at all (same as
  US1/US2/US5's own prevent-direct-push.py/secret-scanner.py, which were
  never offered to Wave 2 either) — not a new gap this story introduces.

### Implementation for User Story 3

- [x] T044 [P] [US3] Add the second interactive prompt to
  `scripts/install.sh` immediately after the existing
  `install_shared_hooks` prompt (~L379): `install_conventional_commits=0`,
  `[y/N]` idiom, only asked when `interactive_mode` and
  `install_shared_hooks` are both true (plan.md Implementation notes).
  Until T040 passes.
  Note: the interactive-mode gate is untestable via simple piped input in
  CI (`[ -t 0 ]` TTY check), so a dedicated, narrowly-scoped
  `SPECJEDI_TEST_FORCE_HOOKS_PROMPT` env-var seam was added to only this
  block (not the global `interactive_mode`, which would also re-trigger
  the earlier directory/harness wizard and consume the test's piped
  answers before they reached this prompt).
- [x] T045 [P] [US3] Identical prompt in `scripts/install.ps1`.
  Note: PowerShell's `|` passes .NET objects through the pipeline, not
  raw stdin bytes, so piping answer strings into a nested
  `./scripts/install.ps1` call from *within* another PowerShell script
  does not feed `Read-Host`; only a genuine OS-level pipe into a real
  `pwsh -File scripts/install.ps1` child process works. All PowerShell
  verification (T040/T041/T043) uses that invocation shape.
- [x] T046 [P] [US3] Extend `install.sh`'s claude-code block to
  conditionally `cp` + wire `conventional-commits.py` only when
  `install_conventional_commits=1`, gated on `has_python3` (depends on
  T002). Until T041/T042 pass.
- [x] T047 [P] [US3] Identical in `install.ps1`.
- [x] T048 [US3] Stage `conventional-commits.py` in
  `package-release.sh`/`.ps1` (both files, one task).
  Verified: both scripts now `cp`/`Copy-Item` `conventional-commits.py`
  into the staged `.claude/hooks/` directory unconditionally (same
  reasoning as `prevent-direct-push.py`/`secret-scanner.py` above — the
  source file must exist in a downloaded release tarball regardless of
  the user's opt-in answer at install time).
- [x] T049 [US3] Add to `validate.yml`'s `package-content-completeness`
  list.
  Verified: `.claude/hooks/conventional-commits.py` added to both the
  bash and PowerShell "must be present" lists; `python3 -c "import
  yaml..."` confirms `validate.yml` stays valid YAML.
- [x] T050 [US3] Extend Wave 1/2 harness translation for
  `conventional-commits.py`. Until T043 passes.
  Verified: `render_gemini_style_commit_guard()` (install.sh) and
  `Get-GeminiStyleCommitGuardScript` (install.ps1) both do the same
  source-to-source transform of `conventional-commits.py`'s deny block
  used for `prevent-direct-push.py`; `install_hooks_gemini_cli`/
  `install_hooks_antigravity` (translated) and `install_hooks_codex_cli`
  (reused unmodified, identical schema) all extended, PowerShell
  counterparts mirrored. All three Wave 1 harnesses verified functionally
  end-to-end locally (file present, correct output shape, wired into
  settings, and an actual deny call returns exit 2 with the translated
  JSON shape).

**Checkpoint**: US1, US2, US5, US3 all independently functional.

---

## Phase 7: User Story 4 - Desktop notification on response completion reaches installed projects (Priority: P3)

**Goal**: A `Stop` hook (native OS notification) reaches installed
projects, wired non-destructively.

**Independent Test**: A response completes; exactly one notification
fires on macOS/Linux, nothing errors on a platform with neither
mechanism (spec.md US4 Acceptance Scenarios).

### Tests for User Story 4 ⚠️

- [x] T051 [P] [US4] Add a case to `.claude/hooks/test-hooks.sh`/`.ps1`
  asserting a scratch target's `.claude/settings.json` gains the `Stop`
  hook block (osascript/notify-send fallback) on shareable-hooks install,
  non-destructively (leaves an existing `Stop` array alone, per the same
  discipline `update_shared_settings()` already applies to
  `statusLine`/`permissions`).
  Verified: new `=== Stop-hook wiring (merge_json_key) ===` /
  `=== Stop-hook wiring (Merge-JsonKey, specs/058 US4, T051) ===` sections
  added to both test scripts, covering fresh-file add + pre-existing-key
  preservation, idempotent re-run, and non-destructive preservation of an
  existing `Stop` array — 3/3 passing on both `bash
  .claude/hooks/test-hooks.sh` and `pwsh -File .claude/hooks/test-hooks.ps1`
  ("All hook tests passed." on both).
- [x] T052 [US4] **Manual-verification note** (not automated — real OS
  notification firing isn't practically assertable in CI, matching
  specs/042's own established convention for UX-only requirements): once
  T053/T054 land, manually confirm on macOS and on Linux (or record why
  one platform was unavailable) that exactly one notification fires per
  completed response, and that a platform with neither `osascript` nor
  `notify-send` errors on nothing. Record the result inline in this file
  next to this task (date, platform, outcome) — this closes the
  `specjedi-analyze`-flagged Unverified status for FR-004's Acceptance
  Scenarios with an explicit, honest disposition rather than a silent gap.
  **Result (2026-07-19, macOS)**: ran the exact `stop_block` command
  string (`if command -v osascript ...; fi`) directly, not just inside
  `test-hooks.sh`'s extracted-function harness — `osascript -e 'display
  notification "Response complete" with title "Claude Code"'` executed
  and exited 0 with no error. Also confirmed the neither-tool-present
  branch (`env -i PATH="/nonexistent" bash -c '...'`) exits 0 with no
  output, matching FR-004's "errors on nothing" requirement. **Honest
  limitation**: this session runs in a non-interactive agent shell with
  no way to visually confirm the actual macOS notification banner
  rendered on screen (only that the command that triggers it returned
  success) — that visual half of the confirmation needs a human at the
  keyboard. Linux/`notify-send` was not available to test in this
  environment at all (macOS-only sandbox) — untested, not assumed
  working; the command is a straight, unmodified copy of this repo's own
  already-shipped `.claude/settings.json` Stop entry, which has been
  running in this project's own sessions already.
- [x] T053 [P] [US4] Add `Stop`-hook wiring to `scripts/install.sh`:
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
  **Real bug found and fixed during implementation**: `merge_json_key()`
  was defined *after* the top-level claude-code install block that now
  calls it — bash resolves function calls at execution time (no
  hoisting), so the original definition order (function textually below
  its new call site) failed with `merge_json_key: command not found`.
  Relocated the function's definition to immediately after
  `update_shared_settings()` (its first actual use point) rather than
  leaving it where it was originally written for the Wave 1/2 harness
  functions alone. Verified via a real scratch install: `"Stop"` key
  present, valid JSON, and a second run correctly says "already has this
  key — leaving as-is."
- [x] T054 [P] [US4] Identical addition in `scripts/install.ps1`, via
  `Merge-JsonKey` (confirmed present at `scripts/install.ps1:882`, same
  `-Target`/`-KeyCheck`/`-Block`/`-OkMessage` parameters every other Wave
  1/2 call site already uses).
  Same real bug as T053 above, confirmed independently: PowerShell also
  doesn't hoist top-level function definitions in a `.ps1` script (a
  minimal repro — calling a function before its textual definition —
  reproduces the identical "not recognized" error), so `Merge-JsonKey`
  was relocated immediately after `Update-SharedSettings` here too.
  Verified via a real scratch install with `pwsh -NoProfile -File
  scripts/install.ps1`: `"Stop"` key present, valid JSON, idempotent
  re-run confirmed.

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
