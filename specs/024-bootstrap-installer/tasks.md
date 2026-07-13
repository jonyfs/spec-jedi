# Tasks: Standalone Bootstrap Installer

**Input**: Design documents from `/specs/024-bootstrap-installer/`

**Prerequisites**: plan.md, spec.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's
Constitution Check, same exemption class as feature 023 (installer-script
work, no meaningful code-level red/green cycle). Verified instead via real
execution against the live GitHub API (genuine 404 path, no release
published yet) and a locally-packaged release artifact exercising the
full extract → install.sh/.ps1 handoff.

**Organization**: Tasks grouped by the single user story (spec.md, P1).

**Note**: This `tasks.md` is retroactive. The feature was implemented,
merged (`ab1f5a8`, PR #82, bundled with feature 023 as "both are part of
the same user-requested installer-completion request" per plan.md), and
its own `spec.md` marked `Status: Complete` before this task breakdown was
written — all tasks below are recorded as `[X]` to document what shipped,
not to plan new work. Written after the fact to close the gap between
actual repo state and the formal spec→plan→tasks→implement paper trail,
at user request.

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Setup

- [X] T001 Confirm zero-extra-runtime-dependency constraint (no `jq`, no
      PowerShell module install) is achievable: bash via `curl`+`tar`+
      `grep`/`sed` JSON field extraction, PowerShell via native
      `Invoke-RestMethod` object properties + `tar` (ships natively on
      Windows 10 1803+) (depends on nothing)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Release resolution is the shared prerequisite both scripts'
download/extract/handoff logic depends on.

- [X] T002 [P] In `scripts/bootstrap-install.sh`: implement release
      resolution against the GitHub Releases API —
      `/releases/latest` by default, `/releases/tags/<version>` when
      `--version` is passed — extracting `tag_name` and the
      `spec-jedi-*.tar.gz` asset download URL via `grep`/`sed` (no `jq`)
      (depends on T001)
- [X] T003 [P] In `scripts/bootstrap-install.ps1`: implement the
      equivalent release resolution via `Invoke-RestMethod`'s native
      object properties (`-Version` parameter mirrors `--version`),
      behaviorally identical to T002 per Principle XIII (depends on T001)
- [X] T004 [US1] In both scripts: on a missing/failed API response (no
      release, or requested version doesn't exist), print a clear,
      honest, Principle-XI-aware explanation plus the git-clone fallback
      command and exit non-zero — never a raw API/curl error (AC4)
      (depends on T002, T003)

**Checkpoint**: Both scripts can resolve a release (or fail honestly) —
download/extract/handoff can now be built on top.

---

## Phase 3: User Story 1 — Install without cloning (P1)

**Goal**: `curl | bash` (or `iwr | iex`) installs Spec Jedi into the
caller's project directory without a prior `git clone`.

**Independent Test**: Run each script with `--help`; run against the
live (currently-empty) GitHub Releases API and confirm a clean, honest
exit 1 (AC4); run the full mechanics against a locally-packaged release
artifact and confirm skills + a representative bridge harness install
correctly through the simulated chain.

### Implementation for User Story 1

- [X] T005 [P] [US1] In `scripts/bootstrap-install.sh`: download the
      resolved `spec-jedi-*.tar.gz` asset into a `mktemp -d` temp
      directory, with a `trap` cleaning it up on both success and failure
      (depends on T002, T004)
- [X] T006 [P] [US1] In `scripts/bootstrap-install.ps1`: download into a
      `New-Item`-created temp directory with equivalent
      try/finally cleanup, behaviorally identical to T005 (depends on
      T003, T004)
- [X] T007 [US1] In `scripts/bootstrap-install.sh`: extract with
      `tar -xzf`, locate the `spec-jedi-*` top-level directory, and hand
      off to its bundled `install.sh`, forwarding `TARGET_DIR`/
      `--harness`/`--auto` unchanged (AC3) (depends on T005)
- [X] T008 [US1] In `scripts/bootstrap-install.ps1`: extract with `tar`,
      locate the top-level directory, and hand off to its bundled
      `install.ps1`, forwarding the equivalent parameters unchanged
      (depends on T006)
- [X] T009 [US1] Build a real release artifact locally via
      `scripts/package-release.sh v0.1.0-test /tmp/...` and manually
      exercise the extract → locate → `install.sh`/`.ps1` handoff portion
      of each bootstrap script against it (bypassing only the network
      download call itself), confirming skills and a representative
      bridge harness (`cursor`/`tabnine`) install correctly (depends on
      T007, T008)
- [X] T010 [US1] Manually verify `--help`/`-Help` output for both scripts
      (depends on nothing, can run anytime after T001)
- [X] T011 [US1] Manually verify the live no-release path against the
      real, current `jonyfs/spec-jedi` GitHub API — confirmed clean,
      informative exit 1 for both scripts (AC4, depends on T004)
- [X] T012 [P] [US1] Add `bootstrap-installer-smoke` CI job (bash matrix
      + native pwsh) in `.github/workflows/validate.yml`, asserting
      `--help` works and the real no-release path exits cleanly with the
      expected message on all three OSes (depends on T010, T011)
- [X] T013 [US1] Wire `bootstrap-installer-smoke` into `ci-gate`'s
      `needs:` list in `.github/workflows/validate.yml` (depends on T012)

**Checkpoint**: `bootstrap-install.sh`/`.ps1` resolve, download, extract,
and hand off correctly against a real artifact; the honest-failure path
is CI-proven against production.

---

## Phase 4: Polish & Cross-Cutting Concerns

- [X] T014 [P] Update `references/skill-roadmap.md` — Sub-Project B moved
      from "Proposed" to "Shipped," with the known-limitation caveat
      (no real `v0.1.0` release exists yet, so AC1-AC3's live network path
      is verified only via a locally-built artifact) stated inline, not
      hidden (Principle XX)
- [X] T015 [P] Update `README.md`'s quickstart — add the one-liner
      alongside the existing clone-first path
- [X] T016 Record the same `.specify/memory/constitution.md` PATCH
      amendment as feature 023 (bundled together, both part of the same
      user-requested installer-completion request) (depends on T009,
      T011)

---

## Dependencies & Execution Order

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Phase 1. Blocks Phase 3 — no
  download/extract/handoff logic can be built before release resolution
  and the honest-failure path exist.
- **User Story 1 (Phase 3)**: Depends on Phase 2. T005/T006 (download)
  can proceed in parallel across the two scripts; T007/T008 (extract +
  handoff) each depend on their own script's download step; T009 (full
  mechanics test) depends on both; T012/T013 (CI) depend on T010/T011
  passing manually first.
- **Polish (Phase 4)**: T014/T015 can start once Phase 3 is functionally
  complete; T016 depends on T009/T011 (verification must exist before
  the constitution amendment claims this is closed).

## Notes

- No task in this feature required a failing-test-first task per
  Principle VI — the exemption is stated in `plan.md`'s Constitution
  Check and re-stated in this file's header.
- The known limitation (no real `v0.1.0` release cut yet, so the live
  network path is verified only against a locally-built artifact, not
  a real published GitHub Release) is stated in `spec.md` and
  `references/skill-roadmap.md` rather than hidden — cutting `v0.1.0`
  itself is explicitly out of scope for this feature (Principle XI: a
  deliberate, separate maintainer action).
- All tasks are recorded `[X]` — this is a retroactive record of shipped
  work (PR #82, commit `ab1f5a8`), not a forward plan.
