# Tasks: Release Packaging & Publishing Workflow

**Input**: Design documents from `/specs/020-release-packaging/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's Technical
Context. `quickstart.md`'s 6 scenarios (a real `dry_run: true` workflow
execution among them) serve as this feature's actual verification.

**Organization**: Tasks grouped by user story (spec.md priorities P1/P1/P2).

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Setup

- [X] T001 Re-confirm `scripts/install.sh`'s existing allowlist copy
      pattern (`specjedi-*` glob, explicit template file list) as the
      exact pattern `scripts/package-release.sh` will reuse
- [X] T002 [P] Re-confirm `.github/workflows/validate.yml`'s existing job
      style (step naming, `shell: bash`/`shell: pwsh` conventions) as the
      pattern `release.yml` will follow
- [X] T003 [P] Re-confirm `CHANGELOG.md`'s exact current `## Unreleased`
      heading text and structure before writing the rewrite logic

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The packaging script is shared by every user story — none of
them are independently testable without it.

- [X] T004 Write `scripts/package-release.sh`: stage
      `.claude/skills/specjedi-*/` (unmodified), the four
      `.specify/templates/*.md` files, `scripts/install.sh`,
      `scripts/install.ps1`, and `LICENSE` into a temp staging dir, then
      `tar -czf spec-jedi-<version>.tar.gz` it. Accepts `<version>
      <output_dir>` as arguments (quickstart.md Scenario 1's exact
      invocation shape) (depends on T001)
- [X] T005 [P] Write `scripts/package-release.ps1`, same behavior as T004
      (depends on T001)
- [X] T006 Real dry run: `bash scripts/package-release.sh v0.1.0-test
      /tmp/release-package-test`; confirm the archive's contents exactly
      match data-model.md's Release Artifact spec via `tar -tzf`
      (quickstart.md Scenario 1) (depends on T004)
- [X] T007 [P] Real dry run (PowerShell): confirm `package-release.ps1`
      produces an equivalent archive (depends on T005)

**Checkpoint**: A real, inspectable artifact can be built locally by
either script.

---

## Phase 3: User Story 1 - The maintainer safely rehearses a release (Priority: P1) 🎯 MVP

**Goal**: `workflow_dispatch` with `dry_run: true` (the default) runs
every validation/packaging step and produces zero durable side effects.

**Independent Test**: Trigger the workflow with `dry_run: true`; confirm
no tag, no release, no commit resulted (quickstart.md Scenario 3).

### Implementation for User Story 1

- [X] T008 [US1] Create `.github/workflows/release.yml` with the
      `workflow_dispatch` trigger and `version`/`dry_run` inputs exactly
      as specified in research.md's input-schema decision (depends on
      T002)
- [X] T009 [US1] Add the version-validation step: `vMAJOR.MINOR.PATCH`
      format check, plus an existing-tag check (`git tag -l` or `gh api
      repos/:owner/:repo/git/refs/tags/<version>`) — fail immediately
      with a clear message on either violation (FR-003) (depends on T008)
- [X] T010 [US1] Add the `scripts/validate.sh` gate step — fail
      immediately if it doesn't pass, before any packaging (FR-004)
      (depends on T009)
- [X] T011 [US1] Add the `## Unreleased` emptiness check — fail
      immediately with a clear message if that section has no content
      (FR-006) (depends on T003, T010)
- [X] T012 [US1] Add the packaging step, invoking `scripts/package-release.sh`
      (T004) with the validated `version` input (depends on T011, T004)
- [X] T013 [US1] Add the `dry_run: true` branch: upload the built
      artifact as a workflow-run artifact
      (`actions/upload-artifact@v4`), compute and print the changelog
      diff that *would* be written, and stop — no tag/release/commit
      steps execute (depends on T012)
- [X] T014 [US1] Real run: trigger the workflow with `dry_run: true`
      against a throwaway version string; confirm the run succeeds and
      that afterward no tag, no release, and no new commit exist
      (quickstart.md Scenario 3) (depends on T013)
- [X] T015 [US1] Real run: trigger the workflow with a malformed version
      string; confirm it fails immediately at the version-validation step
      (quickstart.md Scenario 4) (depends on T009)

**Checkpoint**: The entire mechanism can be rehearsed with zero risk —
User Story 1 is independently satisfied.

---

## Phase 4: User Story 2 - The maintainer cuts a real, deliberate release (Priority: P1)

**Goal**: `dry_run: false` produces a real tag, GitHub Release, and
`CHANGELOG.md` commit.

**Independent Test**: Trigger with `dry_run: false` and a real version;
confirm the tag, release, and changelog commit all exist afterward.

### Implementation for User Story 2

- [X] T016 [US2] Add the `dry_run: false` branch: `gh release create
      <version> <artifact> --notes-file <computed-notes> --target main`
      (research.md's atomic tag+release decision) (depends on T013)
- [X] T017 [US2] Add the `CHANGELOG.md` rewrite step: replace `##
      Unreleased` with `## Unreleased\n\n## [<version>] - <date>`,
      preserving the existing section content beneath the new versioned
      heading (research.md's rewrite decision) (depends on T016)
- [X] T018 [US2] Add the commit-to-main step for the rewritten
      `CHANGELOG.md`, scoped to the `dry_run: false` branch only (depends
      on T017)
- [X] T019 [US2] Code review (not a live broken-state run — honestly
      scoped per quickstart.md Scenario 5): confirm the workflow's step
      ordering guarantees `scripts/validate.sh` (T010) always runs before
      packaging (T012) and before any `dry_run: false` step (T016-T018)
      (depends on T018)

**Checkpoint**: A real release can be cut in one deliberate action — User
Story 2 (MVP) is independently satisfied. The actual first `v0.1.0` cut
itself is explicitly out of scope (spec.md Assumptions) — a separate
maintainer action after this PR ships.

---

## Phase 5: User Story 3 - The artifact matches what the installer expects (Priority: P2)

**Goal**: The packaged artifact installs identically to a full clone.

**Independent Test**: Extract the artifact; run `scripts/install.sh`
from inside it; compare to an in-clone install.

### Implementation for User Story 3

- [X] T020 [US3] Real dry run: extract the Phase 2 artifact into a
      scratch directory, run `scripts/install.sh --harness claude-code`
      from inside it, and confirm the same skill count (23) as a normal
      in-clone install (quickstart.md Scenario 2) (depends on T006)
- [X] T021 [P] [US3] Repeat T020 for `--harness codex-cli` and `--harness
      trae`, confirming identical results for each (depends on T006)

**Checkpoint**: The artifact is proven to be a drop-in replacement for a
full clone, for every currently-supported harness — User Story 3 is
independently satisfied.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T022 [P] Validate `.github/workflows/release.yml`'s YAML syntax
      (`python3 -c "import yaml; yaml.safe_load(...)"`)
- [X] T023 [P] Run `bash scripts/validate.sh` and `pwsh
      scripts/validate.ps1`, confirm `PASSED` with zero unexpected WARN
      lines
- [X] T024 Update `references/principle-traceability.md`'s Principle XI
      row to reflect this feature closing the "suggest-only, never cuts"
      gap
- [X] T025 Add a new `## Unreleased` → `### Added` entry to
      `CHANGELOG.md` for this feature (the meta-irony of this feature's
      own changelog entry being the last one written under the old
      manual convention, before the mechanism it describes takes over)
- [X] T026 Review the README badge row per the Distribution & Ecosystem
      Standards section — determine whether this feature warrants a
      new/updated badge (e.g. a "latest release" badge, deferred until a
      real release actually exists) and document that determination in
      the PR description

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup — blocks all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational
- **User Story 2 (Phase 4)**: Depends on User Story 1 (extends the same
  workflow file's `dry_run: false` branch, built after the `dry_run:
  true` branch is proven safe)
- **User Story 3 (Phase 5)**: Depends on Foundational only — can run in
  parallel with Phases 3-4 once Phase 2 completes
- **Polish (Phase 6)**: Depends on Phases 3-5 all completing

### Parallel Opportunities

- T002/T003 parallel with T001
- T005/T007 (PowerShell) parallel with T004/T006 (bash)
- Phase 5 (US3) can run in parallel with Phases 3-4 once Phase 2 completes
- T021 parallel across harnesses
- T022/T023 (Polish verification) in parallel

---

## Implementation Strategy

### MVP First (User Stories 1+2)

1. Complete Phase 1 (Setup) and Phase 2 (Foundational — the packaging
   script)
2. Complete Phase 3 (US1 — dry-run rehearsal, proven safe)
3. Complete Phase 4 (US2 — the real-cut mechanism, MVP)
4. **STOP and VALIDATE**: a real `dry_run: true` run has been executed
   and confirmed side-effect-free before this ships
5. Phase 5 (US3 — artifact-content verification) and Phase 6 (Polish)
   round out the feature

### Incremental Delivery

1. Setup → confirmed conventions to reuse
2. Foundational → a real, inspectable artifact exists
3. US1 → the mechanism can be rehearsed with zero risk
4. US2 → the mechanism can actually cut a release (not exercised for
   real in this PR — that's a separate maintainer action)
5. US3 → the artifact is proven to be a drop-in clone replacement
6. Polish → traceability/changelog/badge bookkeeping

---

## Notes

- This feature explicitly does NOT cut the real `v0.1.0` release —
  T014/T015 exercise `dry_run: true` only; the first `dry_run: false` use
  is a separate, deliberate maintainer action after this PR merges
  (spec.md Assumptions, Constitution Principle XI).
- Commit after each phase, not after every single task
