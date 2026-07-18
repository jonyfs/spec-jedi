---

description: "Task list for specs/041-release-hooks-settings"
---

# Tasks: Release-Ship Shareable Hooks & Settings, Per Harness

**Input**: Design documents from `/specs/041-release-hooks-settings/`

**Prerequisites**: plan.md, spec.md, research.md (all present; no
data-model.md/contracts/ — see plan.md's Project Structure)

**Tests**: Not explicitly requested as TDD in spec.md, but Principle IX
requires real CI coverage for every acceptance scenario — test tasks
below extend the existing `.claude/hooks/test-hooks.sh`/`.ps1` and
`.github/workflows/validate.yml` mechanisms rather than being skipped.

**Organization**: Tasks are grouped by user story (US1 = P1, US2 = P2)
per spec.md's priorities, after a Setup phase that resolves a real
sequencing discovery (see below) and a Foundational phase shared by
both stories.

## ⚠️ Setup-phase discovery (read before starting)

This feature's own spec/plan assumed `.claude/hooks/dangerous-command-
guard.sh`/`.ps1` (PR #119) and `.claude/statusline.sh`/`.ps1` +
`.claude/settings.json`'s `statusLine`/`permissions` keys (specs/040)
already existed as source content to copy. Checked directly against
this branch and `main`: **neither exists yet.** PR #119 is open,
unmerged (`gh pr view 119` → `state: OPEN`). specs/040 only ever
produced `spec.md`/`research.md`/`plan.md` — no `tasks.md`, no actual
`.claude/statusline.*` files, no `.claude/settings.json` changes were
ever implemented. Phase 1 below resolves both before any of this
feature's own new logic can be written against real source content.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1 or US2 per spec.md
- File paths are exact, per plan.md's Project Structure and
  Implementation notes

---

## Phase 1: Setup (resolve missing prerequisites)

**Purpose**: Get PR #119's hooks and specs/040's statusline/permissions
actually present in this repo before any new code in this feature
depends on them.

- [x] T001 Merge PR #119, or if it's still blocked when this phase
  starts, cherry-pick `.claude/hooks/dangerous-command-guard.sh`,
  `.claude/hooks/dangerous-command-guard.ps1`, `.claude/hooks/skill-
  quality-guard.sh`/`.ps1`, `.claude/hooks/cross-platform-parity-
  guard.sh`/`.ps1`, and `.claude/hooks/test-hooks.sh`/`.ps1` from branch
  `research-claude-code-hooks` onto this feature's own branch, so the
  files this feature's own FR-002/FR-006 reference actually exist
  locally.
- [x] T002 [P] Implement `.claude/statusline.sh` per
  `specs/040-aitmpl-settings-improvements/plan.md`'s FR-001a/FR-001b
  design (grep/sed field extraction, no `jq`, `git -C` branch/status
  detection, graceful degradation outside a git repo).
- [x] T003 [P] Implement `.claude/statusline.ps1`, identical behavior,
  PowerShell idiom, per the same spec-040 plan.
- [x] T004 Add `statusLine`, `permissions.allow`, and `permissions.deny`
  keys to this repo's own `.claude/settings.json`, per specs/040's
  `research.md` Decisions (the exact JSON content already fetched and
  verified there from `davila7/claude-code-templates`).
- [x] T005 [P] Add specs/040's own test cases (statusline output for
  clean/dirty tree/non-git-dir) to `.claude/hooks/test-hooks.sh`/`.ps1`
  (from T001), completing specs/040's own untested SC-001/SC-002/
  Acceptance-Scenario-3 before this feature builds on top of it.
- [x] T006 Run `.claude/hooks/test-hooks.sh` and `.ps1` (bash and
  PowerShell) end-to-end; confirm all cases pass, including the new
  T005 additions, before proceeding to Phase 2.

**Checkpoint**: `.claude/hooks/dangerous-command-guard.*` and
`.claude/statusline.*` + `.claude/settings.json`'s new keys exist,
tested, on this feature's own branch. Everything below can now
reference real files instead of planned ones.

---

## Phase 2: Foundational (blocking prerequisites for both stories)

**Purpose**: Shared installer plumbing both User Story 1 and User Story
2 build on. No per-harness or per-story work starts before this lands.

**⚠️ CRITICAL**: Blocks Phase 3 and Phase 4 entirely.

- [x] T007 Define the shareable/repo-internal classification as a
  literal list in `scripts/install.sh` (comment-documented, per spec.md
  Assumptions): shareable = `dangerous-command-guard`, `statusline`
  settings, `permissions` settings; repo-internal = `skill-quality-
  guard`, `cross-platform-parity-guard` (never touched by this
  feature's own install logic at all).
- [x] T008 [P] Implement the interactive-hooks prompt in `scripts/
  install.sh` per `plan.md`'s exact snippet (`install_shared_hooks`
  variable, `[Y/n]` prompt inside the existing `interactive_mode` block,
  default-on for every non-interactive path) — FR-001b/FR-001c.
- [x] T009 [P] Implement the identical prompt in `scripts/install.ps1`,
  PowerShell idiom, same variable/default semantics.
- [x] T010 [P] Implement `detect_trunk_branch()` in `scripts/install.sh`
  per `plan.md`'s exact snippet (`git symbolic-ref` primary, `git
  remote show origin` fallback, `main master` literal fallback string)
  — FR-002a.
- [x] T011 [P] Implement the identical `Get-TrunkBranch` function in
  `scripts/install.ps1`.
- [x] T012 Implement the non-destructive settings-merge function in
  `scripts/install.sh` (`// SPEC-JEDI:HOOKS:START`/`:END` marker
  slicing inside the target's `.claude/settings.json`, mirroring
  `update_memory_file`'s whole-content substring-slicing exactly, per
  `plan.md`) — FR-003/FR-004. Depends on T007.
- [x] T013 Implement the identical `Update-SharedSettings` function in
  `scripts/install.ps1`. Depends on T007.
- [x] T014 Write a failing test in `.claude/hooks/test-hooks.sh` for the
  merge function against a target with a pre-existing, unrelated
  `.claude/settings.json` entry (SC-003) and a malformed-marker-pair
  case (Edge Cases — fails loudly, never guesses). Depends on T012.
- [x] T015 Implement against T014 until it passes.
- [x] T016 [P] Mirror T014/T015 in `.claude/hooks/test-hooks.ps1` against
  `Update-SharedSettings`. Depends on T013.

**Checkpoint**: Prompt, trunk detection, and settings-merge primitives
exist and are tested independently of any specific harness.

---

## Phase 3: User Story 1 - Claude Code shareable install (Priority: P1) 🎯 MVP

**Goal**: Installing for `claude-code` (interactively or via explicit
`--harness`) copies `dangerous-command-guard.*` and the `statusline`/
`permissions` settings into the target, trunk-branch-aware, never
copying the two repo-internal hooks.

**Independent Test**: Run `install.sh`/`.ps1 --harness claude-code`
against a scratch directory twice (idempotency), once against a target
with a pre-existing settings.json entry, and once against a target repo
using `develop` as its default branch.

### Tests for User Story 1 (write first, confirm failing)

**Design correction made during implementation**: T017-T021 originally
targeted `.claude/hooks/test-hooks.sh`/`.ps1`, but those scenarios test
`scripts/install.sh`'s own full-installer behavior (real git scratch
repos, real installed-file assertions), not an individual hook script
in isolation the way `test-hooks.sh` is scoped. Moved to a real CI job
(`.github/workflows/validate.yml`'s `install-test-shared-hooks`,
matching `install-test`'s own established per-harness pattern) instead
— same "write it as a real, reproducible check" requirement, better-fit
location. All scenarios below were also manually verified end-to-end
(real `install.sh`/`.ps1` runs against scratch git repos) before being
written into CI.

- [x] T017 [P] [US1] Write a failing test in `.github/workflows/
  validate.yml`'s new `install-test-shared-hooks` job asserting a
  `claude-code` scratch install produces `dangerous-command-guard.sh` +
  the `statusLine`/`permissions` keys in the target, and does NOT
  produce `skill-quality-guard.sh`/`cross-platform-parity-guard.sh`
  (SC-001, Acceptance Scenarios 3/6).
- [x] T018 [P] [US1] Write a failing test for idempotent re-run
  (byte-identical output after a second install) — SC-002.
- [x] T019 [P] [US1] Write a failing test for trunk-branch detection: a
  scratch target repo with `origin`'s default branch set to `develop`
  gets an installed `dangerous-command-guard` whose force-push check
  matches `develop`, not `main`/`master` — SC-007, Acceptance Scenario 4.
- [x] T020 [P] [US1] Write a failing test for the no-`origin`-remote
  fallback case — installed hook checks `main`/`master` — Acceptance
  Scenario 5.
- [x] T021 [P] [US1] Mirror T017-T020 in `install-test-shared-hooks-
  windows-native` (native PowerShell CI job).

### Implementation for User Story 1

- [x] T022 [US1] In `scripts/install.sh`, after the existing skills-copy
  loop, call the T007 classification + T008/T010/T012 primitives to
  copy `dangerous-command-guard.sh` into the target's `.claude/hooks/`
  with `${CLAUDE_PROJECT_DIR}`-relative paths (FR-002) and the
  detected-trunk-branch substitution (FR-002a) applied to its force-push
  check. Also wires the copied hook into the target's `PreToolUse`
  hooks array (not originally broken out as its own sub-task, but
  required for the hook to actually do anything).
- [x] T023 [US1] In the same location, merge `statusLine`/`permissions`
  into the target's `.claude/settings.json` via T012.
- [x] T024 [US1] Mirror T022/T023 in `scripts/install.ps1` using T009/
  T011/T013. Caught and fixed a real bug during this task: the PowerShell
  wiring initially pointed `"command": "bash"` at the `.ps1` hook file
  (which bash cannot execute) — corrected to `"command": "powershell"`.
- [x] T025 [US1] Add an `install-test-shared-hooks` job to `.github/
  workflows/validate.yml` (3-OS matrix, matching `install-test`'s
  existing pattern) running T017-T021's scenarios for real, wired into
  `ci-gate`'s `needs:`.
- [x] T026 [US1] Run T017-T021 (bash and PowerShell) and confirm all
  pass. Verified via direct `install.sh`/`.ps1` runs against scratch git
  repositories (fresh install, idempotent re-run, `develop`-branch
  detection, no-remote fallback, interactive accept/decline via a `pty`
  harness) — all passing — before committing the equivalent CI job.

**Checkpoint**: User Story 1 is fully functional and independently
testable — `claude-code` installs get the shareable hooks/settings,
trunk-branch-aware, idempotent, non-destructive, never leaking the two
repo-internal hooks. This is the shippable MVP slice.

---

## Phase 4: User Story 2 - Per-harness adaptation, Waves 1 & 2 (Priority: P2)

**Goal**: Gemini CLI, Antigravity, Codex CLI (Wave 1) and OpenCode, Zed,
Warp, Amazon Q (Wave 2) get a real, harness-native translation of the
shareable set; the 9 no-mechanism harnesses get an honest, silent skip;
Cursor/Windsurf/Copilot stay explicitly out of scope (documented, not
silently dropped).

**Independent Test**: Per spec.md — install for one harness per
research.md category (a Wave-1 Full-hooks harness, a Wave-2
permissions-only harness, and a no-mechanism harness) and confirm each
behaves per its own classification.

### Wave 1: declarative-JSON-hook harnesses

- [ ] T027 [P] [US2] Write a failing test: `gemini-cli` install produces
  a translated hook block inside `.gemini/settings.json` (not a copy of
  Claude Code's own `.claude/hooks/*.json` shape) — Acceptance Scenario
  2 (US2).
- [ ] T028 [US2] Implement `install_hooks_gemini_cli()` in `scripts/
  install.sh`, writing the translated hook into `.gemini/settings.json`
  per `research.md`'s Gemini CLI row (event name `BeforeTool`, same
  stdin/stdout JSON shape as Claude Code's own hooks). Depends on T007,
  T012.
- [ ] T029 [P] [US2] Mirror T028 in `scripts/install.ps1`.
- [ ] T030 [P] [US2] Write a failing test: `antigravity` install
  produces a translated hook in Antigravity's own confirmed settings
  location (per `research.md`) — Acceptance Scenario 2 (US2).
- [ ] T031 [US2] Implement `install_hooks_antigravity()` in `scripts/
  install.sh`. Depends on T007, T012.
- [ ] T032 [P] [US2] Mirror T031 in `scripts/install.ps1`.
- [ ] T033 [P] [US2] Write a failing test: `codex-cli` install produces
  a `hooks.json` translation, and install output explicitly tells the
  user to run `/hooks` inside Codex CLI to trust it before it's active
  (`plan.md`'s Codex CLI trust-workflow note) — Acceptance Scenario 2
  (US2) plus Principle XX.
- [ ] T034 [US2] Implement `install_hooks_codex_cli()` in `scripts/
  install.sh`, including the trust-workflow output message. Depends on
  T007, T012.
- [ ] T035 [P] [US2] Mirror T034 in `scripts/install.ps1`.
- [ ] T036 [US2] Add `install-test-shared-hooks-wave1` job to `.github/
  workflows/validate.yml` (3-OS matrix, `gemini-cli`/`antigravity`/
  `codex-cli`), wired into `ci-gate`. Depends on T028-T035.
- [ ] T037 [US2] Run T027/T030/T033 (bash and PowerShell) and confirm
  all pass.


### Wave 2: permissions-only harnesses

- [ ] T038 [P] [US2] Write a failing test: `opencode` install produces
  translated `allow`/`ask`/`deny` rules in `opencode.json` (per
  `research.md`'s OpenCode row) — no hook translation attempted for
  this harness.
- [ ] T039 [US2] Implement `install_permissions_opencode()` in `scripts/
  install.sh`. Depends on T007, T012.
- [ ] T040 [P] [US2] Mirror T039 in `scripts/install.ps1`.
- [ ] T041 [P] [US2] Write a failing test: `zed` install produces
  translated tool-permission settings in Zed's own confirmed location.
- [ ] T042 [US2] Implement `install_permissions_zed()` in `scripts/
  install.sh`. Depends on T007, T012.
- [ ] T043 [P] [US2] Mirror T042 in `scripts/install.ps1`.
- [ ] T044 [P] [US2] Write a failing test: `warp` install produces
  translated agent-profile permissions in Warp's own confirmed location.
- [ ] T045 [US2] Implement `install_permissions_warp()` in `scripts/
  install.sh`. Depends on T007, T012.
- [ ] T046 [P] [US2] Mirror T045 in `scripts/install.ps1`.
- [ ] T047 [P] [US2] Write a failing test: `amazon-q` install produces
  translated `allowedTools`/`toolsSettings` in the target's custom-agent
  JSON config.
- [ ] T048 [US2] Implement `install_permissions_amazon_q()` in `scripts/
  install.sh`. Depends on T007, T012.
- [ ] T049 [P] [US2] Mirror T048 in `scripts/install.ps1`.
- [ ] T050 [US2] Add `install-test-shared-hooks-wave2` job to `.github/
  workflows/validate.yml` (3-OS matrix, `opencode`/`zed`/`warp`/
  `amazon-q`), wired into `ci-gate`. Depends on T039-T049.
- [ ] T051 [US2] Run T038/T041/T044/T047 (bash and PowerShell) and
  confirm all pass.

### No-mechanism harnesses (clean skip, no new code)

- [ ] T052 [P] [US2] Write a failing test: installing for `cline` (one
  representative of the 9 no-mechanism harnesses: `cline`, `continue`,
  `aider`, `jetbrains-ai`, `tabnine`, `replit`, `devin`, `cody`, `trae`)
  produces a successful skills install with zero hooks/settings-related
  output lines — SC-004, Acceptance Scenario 1 (US2). Confirm this
  already passes with NO new code (FR-005's existing behavior already
  covers it) — if it fails, that's a regression to fix, not a feature to
  build.
- [ ] T053 [US2] Confirm T052 passes as-is. No implementation task
  follows — this is the explicit "clean skip costs nothing" check,
  matching `plan.md`'s own Scale/Scope reasoning.

**Checkpoint**: All 19 non-Claude-Code harnesses now behave per their
`research.md` classification — Wave 1/2 harnesses get a real,
harness-native translation; the rest get an honest, silent skip;
Cursor/Windsurf/Copilot remain out of scope, named in `research.md`
and `plan.md`, not silently absent from this task list either.

---

## Phase 5: Polish & Cross-Cutting Concerns

- [ ] T054 [P] Add a CHANGELOG.md entry for this feature, naming the
  shareable hooks/settings shipped and the Wave 1/2 harnesses covered,
  following this project's existing Keep-a-Changelog format.
- [ ] T055 [P] Confirm `references/harness-capability-notes.md`'s scope
  note (added during the plan phase) still accurately reflects what
  shipped — update if Wave 1/2's actual scope changed during
  implementation.
- [ ] T056 Self-invoke `specjedi-govcheck` against the full branch diff
  before opening the PR, per `specjedi-implement`'s own Step 6.5.
- [ ] T057 Full end-to-end run of `.claude/hooks/test-hooks.sh`/`.ps1`
  plus the two new CI job families (T025, T036, T050) — confirm nothing
  regressed from Phase 1's baseline (T006).

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately. Resolves the
  missing-prerequisite discovery above. Blocks everything else.
- **Foundational (Phase 2)**: Depends on Phase 1 completing (needs real
  `dangerous-command-guard.*`/`statusline.*` files to build the copy/
  merge logic against). Blocks Phase 3 and Phase 4 entirely.
- **User Story 1 (Phase 3)**: Depends on Phase 2. Independently
  shippable once done — this is the MVP.
- **User Story 2 (Phase 4)**: Depends on Phase 2 (reuses T007/T012/T013
  directly) and benefits from Phase 3 landing first (same install.sh
  region, avoids merge conflicts) but is not functionally blocked by
  Phase 3 — could proceed in parallel with a second engineer once
  Phase 2 is done.
- **Polish (Phase 5)**: Depends on whichever of Phase 3/4 actually
  shipped — T056/T057 specifically require both to be complete if both
  are being merged together, or run once per PR if Phase 3 and Phase 4
  ship as separate PRs (recommended, per `plan.md`'s own two-wave PR
  sizing).

### Within Wave 1 / Wave 2 (Phase 4)

Each harness's test-then-implement-then-mirror sequence (e.g. T027→
T028→T029) is independent of every other harness's sequence — all three
Wave 1 harnesses, or all four Wave 2 harnesses, can proceed in parallel
by different engineers once Phase 2 is done.

### Parallel Opportunities

- T002/T003 (statusline.sh/.ps1) — different files, no shared state.
- T008-T011 (prompt + trunk-detection, both scripts) — four independent
  functions, though T008/T009 and T010/T011 are each bash/PowerShell
  pairs of the same logic (do the bash one first if solo, to catch
  design issues before duplicating into PowerShell).
- T017-T021 (all US1 test-writing) — different assertions, same file
  per-language, but independent content — write together, run together.
- Every `[P]`-marked harness pair in Phase 4 (e.g. T028/T029, T039/T040)
  — bash and PowerShell mirrors of the same harness, safe to parallelize
  once the bash version's design is settled.

---

## Implementation Strategy

### MVP First

1. Phase 1 (resolve missing prerequisites) — not optional, blocks
   everything.
2. Phase 2 (Foundational).
3. Phase 3 (User Story 1 — Claude Code). **STOP and VALIDATE**
   independently. This alone is a legitimate, shippable PR — matches
   `plan.md`'s own "keep each landed PR reviewable" reasoning.

### Incremental Delivery

1. Phase 1 + Phase 2 → land as part of the same PR as Phase 3 (Phase
   1/2 alone isn't independently valuable to a user).
2. Phase 3 → ship as its own PR (MVP).
3. Phase 4 Wave 1 → ship as its own PR once Phase 3 is merged.
4. Phase 4 Wave 2 → ship as its own PR once Wave 1 is merged (or in
   parallel, if staffed).
5. Phase 5 → folded into whichever PR is last to land, or its own small
   final PR.

### Notes

- Every `[P]` task touches a different file from every other `[P]` task
  in its own group — verified against `plan.md`'s Project Structure
  before marking.
- Commit after each task or logical group, matching `specjedi-implement`'s
  own branch-check-before-every-commit discipline.
- Cursor/Windsurf/Copilot (confirmed Full hooks, structurally distinct
  dialects) are deliberately absent from this task list — `research.md`
  and `plan.md` both name them as explicitly deferred, not an oversight.
