# Tasks: Mention specjedi-* Skills in Each Harness's Memory File

**Input**: Design documents from `/specs/039-memory-file-skill-mentions/`

**Prerequisites**: plan.md (required, Constitution Check passed clean),
spec.md (required for user stories)

**Tests**: This feature is installer-behavior-focused (FR-009) — the
"test" for every user story is real CI coverage building scratch
directories and inspecting real file contents, not a unit test of
isolated logic. Task sequencing below writes each CI assertion
immediately after the dispatch/logic change it proves, per story.

**Organization**: Tasks are grouped by user story (spec.md priorities:
US1 = P1, US2 = P2, US3 = P3), plus a Foundational phase for the shared
marker-injection functions every story's dispatch code calls into.

## Format: `[ID] [P?] [Story] Description`

## Path Conventions

Single project, repository root — `scripts/install.sh`,
`scripts/install.ps1`, `.github/workflows/validate.yml`, as named in
plan.md's Project Structure.

---

## Phase 1: Setup

None required — this feature extends two existing scripts and one
existing CI workflow file in place; no new dependencies, directories, or
scaffolding.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The shared marker-injection functions every user story's
dispatch code calls into. Unreachable (no `case`/`switch` entry points
to them yet) until Phase 3 adds the first one — expected at this stage.

- [x] T001 [P] In `scripts/install.sh`, add `memory_section()` and
  `update_memory_file()` (insert after the existing `skill_meta()`
  function, before the `bridge_mode` block) exactly per plan.md's
  Implementation notes: `memory_section()` takes `skills_dst_rel`,
  reuses `skill_meta()` in the same `for f in "$skills_dst"/specjedi-*/SKILL.md`
  loop pattern the existing bridge-file `single`/`devin` generation
  already uses, wrapped in the `<!-- SPEC-JEDI:SKILLS:START -->`/
  `<!-- SPEC-JEDI:SKILLS:END -->` markers. `update_memory_file()` uses
  the whole-content substring-slice design (bash `%%`/`##` parameter
  expansion on `$(cat "$memory_path")`, never a per-line comparison) for
  create / append-if-existing-no-markers / replace-if-existing-markers,
  and the `has_start -ne has_end` check that exits 1 with a clear
  message naming the file (FR-005).
- [x] T002 [P] In `scripts/install.ps1`, add `Get-MemorySection` and
  `Update-MemoryFile` (insert after the existing `Get-SkillMeta`
  function, before the `bridgeMode` block) exactly per plan.md's
  Implementation notes: same whole-content substring-slice design using
  `.Contains()`/`.IndexOf()`/`.LastIndexOf()`/`.Substring()` on
  `[System.IO.File]::ReadAllText()`, `[System.IO.File]::WriteAllText()`/
  `AppendAllText()` for output (never `Set-Content`/`Out-File`, which
  would apply platform-default newline translation and break FR-008
  byte-parity with `install.sh`), and the trailing-newline-strip
  (`-replace '(\r?\n)$', ''`) before slicing that mirrors bash's
  `$(cat file)` semantics. T001 and T002 are `[P]` — different files, no
  shared state, both independently testable by calling the new functions
  directly.

**Checkpoint**: Both scripts have working, callable marker-injection
functions with no dispatch wiring yet — nothing observable changes for
any `--harness` value until Phase 3.

---

## Phase 3: User Story 1 — `CLAUDE.md` for `claude-code` (Priority: P1)

**Goal**: Installing with `--harness claude-code` creates or idempotently
updates `CLAUDE.md`, in both scripts, verified in CI including the CRLF
and marker-corruption edge cases.

**Independent Test**: Per spec.md's own Independent Test for this story —
fresh-file creation, pre-existing-content preservation, and idempotent
re-run, all checkable without any other harness's dispatch code existing.

- [ ] T003 [US1] In `scripts/install.sh`, add a `memory_file_rel=""` +
  `case "$harness" in claude-code) memory_file_rel="CLAUDE.md" ;; esac`
  block and the `if [ -n "$memory_file_rel" ]; then ... update_memory_file ...; fi`
  call, placed *after* the existing `bridge_mode` block (per plan.md:
  "keeping them as separate `if` blocks rather than merging into the
  `case` avoids restructuring code that already works"). Depends on
  T001.
- [ ] T004 [US1] In `scripts/install.ps1`, add the equivalent
  `$memoryFileRel = ""` + `switch ($Harness) { "claude-code" { $memoryFileRel = "CLAUDE.md" } }`
  block and the `if ($memoryFileRel) { ... Update-MemoryFile ... }` call,
  placed after the existing `bridgeMode` block. Depends on T002. Not
  `[P]` with T003 in the sense that both must exist before Phase 3's CI
  tasks can pass, but they touch different files with no shared state —
  safe to implement in either order.
- [ ] T005 [US1] Add a new `memory-file-injection` job to
  `.github/workflows/validate.yml`, 3-OS matrix
  (`runs-on: ${{ matrix.os }}` / `os: [ubuntu-latest, macos-latest, windows-latest]`,
  matching `install-test`'s existing pattern), with a `shell: bash` step
  implementing plan.md's CI step 1: fresh scratch dir,
  `./scripts/install.sh --harness claude-code <dir>`, assert `CLAUDE.md`
  exists and contains both markers plus every currently installed
  skill's name. Depends on T003.
- [ ] T006 [US1] Extend the same bash step (or add a second one in the
  same job) implementing plan.md's CI step 2: a *second* scratch dir,
  write a `CLAUDE.md` with known dummy content first, capture that exact
  pre-install content, install, then assert the post-install file with
  the marker region (inclusive) removed is byte-identical to the
  captured pre-install content (a real diff, not a substring `grep`) —
  per SC-002's own wording. Depends on T005.
- [ ] T007 [US1] Extend the job implementing plan.md's CI step 3:
  re-run the installer against T005's first scratch dir, hash the file
  before and after (`sha256sum`), assert identical. Depends on T005.
- [ ] T008 [US1] Extend the job implementing plan.md's CI step 4: a
  *third* scratch dir, write a `CLAUDE.md` using CRLF line endings
  throughout (including around a Spec-Jedi-section the test plants
  itself, not the installer), install, assert (a) the section actually
  refreshes rather than silently no-op'ing, and (b) every CRLF byte
  outside the markers is preserved (same real-diff method as T006).
  Depends on T003.
- [ ] T009 [US1] Extend the job implementing plan.md's CI step 5: a
  *fourth* scratch dir, write a `CLAUDE.md` with only a start marker and
  no matching end marker, run the installer, assert non-zero exit, an
  error message naming the file, and the file left completely
  unmodified (FR-005). Depends on T003.
- [ ] T010 [US1] Add the `shell: pwsh` counterpart step to the same job,
  repeating T005-T009's five scenarios against `install.ps1` (plan.md CI
  step 10's "repeat steps 1-5 for the PowerShell leg"), then add a final
  assertion diffing `install.sh`'s and `install.ps1`'s `CLAUDE.md` output
  for the same scratch input (FR-008/SC-004). Depends on T004, T006,
  T007, T008, T009 (needs the bash-side scenarios already implemented to
  mirror and diff against).

**Checkpoint**: `--harness claude-code` fully implements and CI-proves
User Story 1 end-to-end, both scripts, including both edge cases
`specjedi-analyze` surfaced against this feature's first plan revision.

---

## Phase 4: User Story 2 — `AGENTS.md` (Codex CLI) and `.trae/rules/project_rules.md` (Trae) (Priority: P2)

**Goal**: The same create/preserve/idempotent behavior Phase 3 proved for
`claude-code` extends to `codex-cli` and `trae`, reusing the Phase 2
functions unchanged.

**Independent Test**: Per spec.md's own Independent Test for this story —
checkable without Phase 3's `CLAUDE.md` logic ever running, since it
exercises a different harness value end-to-end.

- [ ] T011 [US2] In `scripts/install.sh`, extend the `case "$harness" in`
  block T003 introduced with `codex-cli) memory_file_rel="AGENTS.md" ;;`
  and `trae) memory_file_rel=".trae/rules/project_rules.md" ;;`. Depends
  on T003 (extends the same `case` block — not safe to run before T003
  exists, and not `[P]` with it since both edit the same block).
- [ ] T012 [US2] In `scripts/install.ps1`, extend the `switch ($Harness)`
  block T004 introduced with the equivalent `"codex-cli"` and `"trae"`
  entries. Depends on T004 (same-block reasoning as T011). T011 and T012
  ARE `[P]` with each other — different files.
- [ ] T013 [US2] Extend `memory-file-injection`'s bash step implementing
  plan.md's CI step 6: `--harness codex-cli` into a fresh scratch dir,
  assert `AGENTS.md` exists with the markers, and that its "installed
  at" sentence names `.agents/skills/` (not `.claude/skills/`) — proves
  `skills_dst_rel` is genuinely parameterized in `memory_section()`, not
  hardcoded. Depends on T011.
- [ ] T014 [US2] Extend the same step implementing plan.md's CI step 7:
  `--harness trae` into a fresh scratch dir, assert
  `.trae/rules/project_rules.md` (and its parent directory) was created
  with the markers. Depends on T011.

**Checkpoint**: `codex-cli` and `trae` both get real, CI-proven memory-
file handling, with zero new logic beyond two more `case`/`switch`
entries — confirms Phase 2's functions were genuinely harness-agnostic.

---

## Phase 5: User Story 3 — Antigravity and bridge harnesses stay untouched (Priority: P3)

**Goal**: Prove the negative — this feature adds nothing for
`antigravity` and doesn't regress the 14 bridge harnesses' existing
output.

**Independent Test**: Per spec.md's own Independent Test — checkable
without any Phase 3/4 dispatch code running for the harness under test.

- [ ] T015 [US3] Extend `memory-file-injection`'s bash step implementing
  plan.md's CI step 8: `--harness antigravity` into a fresh scratch dir,
  assert no `CLAUDE.md`/`AGENTS.md`/`.trae/rules/*` file was created —
  only `.agents/skills/`. No dependency on any dispatch task (FR-006 is
  satisfied by the *absence* of an `antigravity` entry in T003/T011's
  `case` block, not by new code).
- [ ] T016 [US3] Extend the same step implementing plan.md's CI step 9:
  `--harness cursor` into a fresh scratch dir, assert `.cursor/rules/`'s
  file count equals the installed skill count — the existing bridge-file
  behavior, unchanged by this feature (FR-007). No dependency on any
  dispatch task.

**Checkpoint**: This feature's full scope (3 memory-file harnesses
handled, 1 explicitly excluded, 14 bridge harnesses verified unaffected)
is now completely CI-proven.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [ ] T017 Add `memory-file-injection` to `ci-gate`'s `needs:` list in
  `.github/workflows/validate.yml`, matching how every other required
  job is already listed there (same pattern as feature 038's
  `package-content-completeness` addition). Depends on T005 (the job
  must exist first).
- [ ] T018 Self-invoke `specjedi-govcheck` against this branch's full
  diff before opening the PR, per `specjedi-implement`'s standard
  pre-PR step — surface any finding, never block the PR on it. Depends
  on all preceding tasks.

## Dependencies & Execution Order

- **Phase 1** is empty — no blocking effect.
- **Phase 2 (T001, T002)** blocks every dispatch task in Phases 3-4
  (T003, T004, T011, T012 all call the functions T001/T002 define) —
  nothing else in this feature can run before it.
- **Phase 3 (T003-T010)**: T003 blocks T005-T009 (bash CI assertions
  need the dispatch entry to exist) and T011 (extends the same `case`
  block). T004 blocks T010 and T012 (extends the same `switch` block).
  T010 depends on T004 and on T006-T009 already existing (it mirrors and
  diffs against them). Within this phase, T003/T004 have no shared-file
  conflict with each other; T005-T009 are sequential (same CI job/file
  region, extended one assertion at a time) rather than `[P]`.
- **Phase 4 (T011-T014)** depends on Phase 3's T003/T004 (extends the
  same `case`/`switch` blocks) and T005 (the CI job must already exist
  to extend). T011/T012 are `[P]` with each other; T013/T014 are
  sequential extensions of the same bash step, each depending on T011.
- **Phase 5 (T015-T016)** depends only on T005 (the CI job existing) —
  genuinely independent of Phases 3/4's dispatch code, since it's
  proving an absence/non-regression, not a new behavior.
- **Phase 6 (T017-T018)** depends on all preceding phases: T017 needs
  the job to exist (T005); T018 govchecks the complete, final diff.

## Implementation Strategy

**MVP scope**: Phase 2 + Phase 3 alone already ship the feature's
highest-value, P1 story (`claude-code`/`CLAUDE.md`) fully CI-proven,
including both edge cases `specjedi-analyze` found. Phase 4 (P2) and
Phase 5 (P3, a pure verification phase) can each ship independently in
follow-up PRs if scope needs to shrink.

**Incremental delivery**: Phase 2 → Phase 3 → Phase 4 → Phase 5 →
Phase 6, each phase's Checkpoint independently demonstrable, matching
spec.md's three independently-testable user stories.
