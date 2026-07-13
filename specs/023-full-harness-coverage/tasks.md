# Tasks: Full Harness Coverage

**Input**: Design documents from `/specs/023-full-harness-coverage/`

**Prerequisites**: plan.md, spec.md, research.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's
Constitution Check (installer-script work, no meaningful code-level
red/green cycle). Verification instead took the form of exhaustive real
execution against all 18 explicit `--harness` values via both real `bash`
and real `pwsh`, documented in plan.md's Testing strategy, plus the CI
jobs added in this feature.

**Organization**: Tasks grouped by the single user story (spec.md, P1).

**Note**: This `tasks.md` is retroactive. The feature was implemented,
merged (`ab1f5a8`, PR #82), and its own `spec.md` marked `Status: Complete`
before this task breakdown was written — all tasks below are recorded as
`[X]` to document what shipped, not to plan new work. Written after the
fact to close the gap between actual repo state and the formal
spec→plan→tasks→implement paper trail (Principle VI's own record-keeping
spirit), at user request.

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Setup

- [X] T001 Re-verify two `references/harness-capability-notes.md` findings
      that materially changed the install design (Antigravity's real
      target directory, Cody's actual customization surface) via fresh
      WebSearch/WebFetch — recorded in `research.md` (depends on nothing)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The metadata-extraction and description-truncation helpers
are shared by every bridge-mode code path below — no bridge harness can
be added until these exist.

- [X] T002 In `scripts/install.sh`: add `first_sentence()` — truncate a
      description to its first `". "` boundary (portable `${desc%%. *}`,
      not GNU-only regex), 160-char hard-cap fallback (Principle XVI/XX
      token economy) (depends on nothing)
- [X] T003 In `scripts/install.sh`: add `skill_meta()` — read `name:`/
      `description:` back out of a just-installed `SKILL.md` via
      `grep -m1 -E` + `sed -E`, using the POSIX `[[:space:]]` class (not
      GNU `\s`) after catching a BSD-`sed` portability bug during manual
      testing on macOS that silently produced a leading-space bug instead
      of erroring (depends on T002)
- [X] T004 In `scripts/install.sh`: add `json_escape()` for Cody's
      custom-commands JSON output (depends on nothing) [P]
- [X] T005 In `scripts/install.ps1`: add `Get-SkillMeta` and the
      equivalent first-sentence truncation logic, kept behaviorally
      identical to T002/T003 per Principle XIII (depends on nothing) [P]

**Checkpoint**: Metadata-extraction and truncation helpers exist in both
scripts — bridge-generation code paths can now be added.

---

## Phase 3: User Story 1 — Install into any of the 20 matrix harnesses (P1)

**Goal**: `scripts/install.sh`/`.ps1 --harness <mine>` places Spec Jedi's
skills somewhere every one of the 20 documented harnesses will find them.

**Independent Test**: Run `--harness <value>` for each of the 18 explicit
values on both `bash` and real `pwsh`; confirm the full `specjedi-*`
package set lands at the harness's documented path, and — for the 14
bridge harnesses — that a correctly-shaped bridge file/directory is also
generated referencing every installed skill.

### Implementation for User Story 1

- [X] T006 [P] [US1] In `scripts/install.sh`'s harness `case` statement:
      add the `antigravity` branch — `skills_dst_rel=".agents/skills"`,
      sharing Codex CLI's exact target directory, zero new bridge code
      (depends on T001's re-verified finding)
- [X] T007 [P] [US1] In `scripts/install.sh`: add the 7 `bridge_mode="dir"`
      branches — `cursor` (`.cursor/rules`), `windsurf`
      (`.windsurf/rules`), `cline` (`.clinerules`), `continue`
      (`.continue/rules`), `amazon-q` (`.amazonq/rules`), `jetbrains-ai`
      (`.aiassistant/rules`), `tabnine` (`.tabnine/guidelines`) (depends
      on T002-T003)
- [X] T008 [P] [US1] In `scripts/install.sh`: add the 5
      `bridge_mode="single"` branches — `gemini-cli` (`GEMINI.md`), `zed`
      (`.rules`), `replit` (`replit.md`), `aider` (`CONVENTIONS.md`),
      `copilot` (`.github/copilot-instructions.md`) (depends on
      T002-T003)
- [X] T009 [US1] In `scripts/install.sh`: add the `devin` branch
      (`bridge_mode="devin"`, `.devin.md`), wrapping the skill index in
      Devin's documented Procedure/Specifications/Advice Playbook
      sections (depends on T002-T003)
- [X] T010 [US1] In `scripts/install.sh`: add the `cody` branch
      (`bridge_mode="cody"`, `.vscode/cody.json`), emitting Cody's
      Custom Commands JSON schema (`description`/`prompt`/`contextFiles`
      per skill) via `json_escape()` (depends on T004)
- [X] T011 [US1] In `scripts/install.sh`: implement the `dir` bridge-
      generation code path — one small `<skill>.md` file per installed
      skill under `bridge_dst_rel/` (depends on T007)
- [X] T012 [US1] In `scripts/install.sh`: implement the `single`/`devin`
      bridge-generation code path — one combined index file (table of
      skill name + first-sentence description), Devin's variant wrapped
      in Playbook sections (depends on T008, T009)
- [X] T013 [US1] In `scripts/install.sh`: implement the `cody`
      bridge-generation code path — valid JSON matching Cody's Custom
      Commands schema (AC4), spot-checked with `python3 -m json.tool`
      (depends on T010)
- [X] T014 [P] [US1] Port T006-T013 to `scripts/install.ps1`
      (`switch ($Harness)` branches, `Get-SkillMeta`-driven bridge
      generation), kept behaviorally identical to the bash version per
      Principle XIII (depends on T005)
- [X] T015 [US1] Manually run all 18 explicit `--harness` values via
      real `bash` locally — 18/18 pass, correct target path confirmed
      per harness (depends on T006-T013)
- [X] T016 [US1] Manually run all 18 explicit `--harness` values via
      real `pwsh` 7.6.3 locally — 18/18 pass, byte-for-byte equivalent
      bridge content to the bash run (spot-checked: Cody JSON, Cursor
      bridge dir, Gemini index table, Devin Playbook) (depends on T014)
- [X] T017 [P] [US1] Add `install-test-antigravity` +
      `install-test-antigravity-windows-native` CI jobs in
      `.github/workflows/validate.yml`, mirroring the existing
      codex-cli/trae job pattern (depends on T006, T014)
- [X] T018 [P] [US1] Add `install-test-bridge-harnesses` +
      `install-test-bridge-harnesses-windows-native` CI jobs in
      `.github/workflows/validate.yml` — one matrix job covering all 14
      bridge harnesses, each matrix entry independently visible pass/fail
      (depends on T007-T014)
- [X] T019 [US1] Wire T017/T018's four new jobs into `ci-gate`'s `needs:`
      list in `.github/workflows/validate.yml` (depends on T017, T018)

**Checkpoint**: All 20 matrix harnesses install correctly on Linux,
macOS, and Windows (bash-on-Windows and native PowerShell), CI-proven.

---

## Phase 4: Polish & Cross-Cutting Concerns

- [X] T020 [P] Update `README.md`'s harness table (all 20 ✅), Mermaid
      diagram, and install-flow prose
- [X] T021 [P] Update `references/harness-capability-notes.md` — status
      corrections for Antigravity and Cody per T001's re-verified
      findings
- [X] T022 Update `references/principle-traceability.md` — Principle III
      row → ✅ Mechanized, citing this feature (depends on T015, T016)
- [X] T023 Record a PATCH amendment in `.specify/memory/constitution.md`
      closing this gap (documentation/traceability update only, no
      principle text changes — v1.16.3/v1.16.4/v1.18.1 precedent)
      (depends on T022)

---

## Dependencies & Execution Order

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Phase 1. Blocks all of Phase 3 —
  no bridge branch can be added before `first_sentence`/`skill_meta`/
  `json_escape`/`Get-SkillMeta` exist.
- **User Story 1 (Phase 3)**: Depends on Phase 2. T006-T010 (branch
  additions) can proceed in parallel across harnesses since each touches
  only its own `case` arm; T011-T013 (bridge-generation code paths) are
  each gated on their respective branches existing. T015/T016 (manual
  verification) depend on all branches + code paths. T017-T019 (CI) depend
  on the harnesses they assert existing and working.
- **Polish (Phase 4)**: T020/T021 can start once Phase 3 is functionally
  complete; T022/T023 depend on T015/T016 (verification must exist before
  claiming the principle is Mechanized).

## Notes

- No task in this feature required a failing-test-first task per
  Principle VI — the exemption is stated in `plan.md`'s Constitution
  Check and re-stated in this file's header.
- All tasks are recorded `[X]` — this is a retroactive record of shipped
  work (PR #82, commit `ab1f5a8`), not a forward plan.
