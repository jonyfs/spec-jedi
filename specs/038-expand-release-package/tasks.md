# Tasks: Expand the Release Package's Contents

**Input**: Design documents from `/specs/038-expand-release-package/`

**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Tests**: This feature is testing/validation-focused by nature (FR-011) —
the "test" for User Stories 1/2/3 is a real, built package's actual
contents, not a unit test of packaging logic in isolation. Task sequencing
below writes the CI-level content-completeness check as its own task
before the packaging-script changes that make it pass, matching
Principle VI's test-first spirit at the level this feature actually
operates on.

**Organization**: Tasks are grouped by user story (spec.md priorities:
US1 = P1, US3 = P1, US2 = P2), plus a Setup phase for the one shared
prerequisite (the new reference doc both US1 and US2 depend on
structurally, though each story's *acceptance* is independently
checkable).

## Format: `[ID] [P?] [Story] Description`

## Path Conventions

Single project, repository root — `scripts/`, `references/`,
`.github/workflows/` as named in plan.md's Project Structure.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Author the one net-new content file every later phase's
completeness check needs to find. No packaging-script changes yet.

- [ ] T001 [P] Author `references/session-start-hook-guide.md`: explain
  what `scripts/session-start.sh`/`.ps1` does (per plan.md's
  Implementation notes — reads `SessionStart` hook stdin, calls
  `specjedi-status`'s on-disk logic, emits `additionalContext`, matching
  Constitution Principle XXI's documented mechanism), show the exact
  `.claude/settings.json` `SessionStart` hook registration this repo's
  own `.claude/settings.json` uses as a working Claude Code example, then
  a per-harness status table for all 20 harnesses in
  `references/harness-capability-notes.md`, each row stating "confirmed
  hook/automation mechanism" or "unconfirmed — adapt manually" — never a
  blanket claim (FR-008, Constitution Principle XX).

**Checkpoint**: The new doc exists and is internally accurate against
`references/harness-capability-notes.md` and `.claude/settings.json`'s
real content — later phases can now reference it by path.

---

## Phase 2: User Story 3 — The package never ships internal spec-authoring history (Priority: P1)

**Goal**: Establish the completeness/absence CI check *before* the
allowlist changes it will validate, so the check can first be observed
failing against today's package (missing the new content) and later
observed passing once Phases 3-4 land — this ordering exists precisely
because US3's own Acceptance Scenarios are about *absence*, which is
already true today; what's genuinely new and needs the fail-then-pass
cycle is the *presence* assertions from US1/US2, added to the same check
in this phase for both.

**Independent Test**: `tar -tzf` a freshly built package; assert zero
`specs/*` paths and zero of the 11 named excluded files (spec.md User
Story 3, Acceptance Scenario 2) — true today, stays true after this
feature, verified by the new CI job regardless of whether US1/US2's
additions have landed yet.

- [ ] T002 [US3] Add a new `package-content-completeness` job to
  `.github/workflows/validate.yml`, matching the existing
  `bootstrap-installer-smoke` job's `runs-on: ${{ matrix.os }}` /
  `strategy.matrix.os: [ubuntu-latest, macos-latest, windows-latest]`
  pattern (per plan.md's CI check notes). Bash step: run
  `./scripts/package-release.sh v0.0.0-ci-check /tmp/pkg-check`, then
  `tar -tzf /tmp/pkg-check/spec-jedi-v0.0.0-ci-check.tar.gz` and assert
  (via `grep -q`/`grep -qv` against the listing) zero lines matching
  `spec-jedi-v0.0.0-ci-check/specs/` and zero lines matching any of the
  11 excluded files named in spec.md User Story 3 Acceptance Scenario 2
  (`references/skill-authoring-standard.md`,
  `references/skill-validation-testing-framework.md`,
  `references/star-wars-lexicon.md`, `references/skill-roadmap.md`,
  `references/mermaid-diagram-catalog.md`,
  `references/principle-traceability.md`,
  `references/genuine-contributions-log.md`,
  `references/competitive-comparison.md`,
  `references/honest-assessment.md`,
  `references/security-question-bank.md`,
  `references/harness-capability-notes.md`, plus `CONTRIBUTING.md`),
  exiting non-zero with a clear `FAIL:` message naming which excluded
  path leaked if any is found.
- [ ] T003 [US3] In the same job, add the PowerShell counterpart step
  (`shell: pwsh`): run `./scripts/package-release.ps1 v0.0.0-ci-check C:\pkg-check`
  (or `$env:RUNNER_TEMP`-based path per the cross-platform-path lesson
  already applied to `bootstrap-installer-smoke` in
  `.github/workflows/validate.yml`), extract via `tar -xzf`, and assert
  the same absence set using `Test-Path`/`Get-ChildItem -Recurse` checks,
  mirroring T002's assertions exactly (Constitution Principle XIII).
- [ ] T004 [US3] Add `package-content-completeness` to `ci-gate`'s
  `needs:` list in `.github/workflows/validate.yml`, matching how every
  other required job is already listed there.

**Checkpoint**: Running the new job today (before Phase 3/4) proves the
absence guarantees already hold — a real, green signal independent of
this feature's other additions.

---

## Phase 3: User Story 1 — A user can learn how to use what they installed (Priority: P1)

**Goal**: The four usage-documentation files land in the release package,
at paths that keep their existing internal relative links resolvable.

**Independent Test**: Build a real package; extract it; open
`README.md`, then follow its trail into
`references/quickstart-guide.md`, `references/what-is-sdd.md`,
`references/specjedi-and-sdd.md` — all present, all readable, no broken
relative links, without needing anything from Phase 4.

- [ ] T005 [P] [US1] In `scripts/package-release.sh`, after the existing
  templates-copy loop, add a `references_dst="$stage_root/references"` +
  `mkdir -p "$references_dst"` block, then copy `README.md` to
  `$stage_root/README.md` and copy
  `quickstart-guide.md what-is-sdd.md specjedi-and-sdd.md` from
  `references/` into `$references_dst` via an explicit `for ref in ...; do`
  loop (matching the existing templates loop's style exactly, per
  plan.md's Implementation notes) — `session-start-hook-guide.md` is
  intentionally excluded from this task's loop list (added in Phase 4,
  T007, to keep US1 and US2 independently landable/revertable). Update
  the script's `usage()` heredoc to name the newly-added contents.
- [ ] T006 [P] [US1] In `scripts/package-release.ps1`, add the identical
  additions using this script's existing `Copy-Item`/
  `New-Item -ItemType Directory -Force` idiom and `foreach (... in @(...))`
  array style (matches the existing templates `foreach` loop), same
  three-file `references/` list, `README.md` copy, and `usage`
  Write-Host block update. T005 and T006 are `[P]` — different files, no
  shared state, each independently testable by running its own script.

**Checkpoint**: Re-run T002/T003's job — the presence half of the check
(once added in Phase 4's T008/T009) will find these four files; running
`package-release.sh`/`.ps1` manually right now already proves T005/T006
work in isolation via `tar -tzf`.

---

## Phase 4: User Story 2 — A user can adapt the session-start hook (Priority: P2)

**Goal**: `session-start.sh`/`.ps1` and the new hooks reference doc
(T001) land in the package.

**Independent Test**: Build a real package; extract it; `scripts/`
contains `session-start.sh` and `session-start.ps1` alongside
`install.sh`/`.ps1`; `references/session-start-hook-guide.md` is present
and its per-harness table is readable — checkable without US1's files
being present (though in practice they will be, since both phases modify
the same two scripts).

- [ ] T007 [US2] In `scripts/package-release.sh`, extend the
  `references_dst` loop from T005 to also include
  `session-start-hook-guide.md`, and add
  `cp "$repo_root/scripts/session-start.sh" "$stage_root/scripts/session-start.sh"`
  (with matching `echo "  ✅ ..."` output) immediately after the existing
  `install.sh`/`.ps1` copy block. Depends on T001 (the doc must exist)
  and T005 (extends the same loop T005 introduced — not `[P]` with T005).
- [ ] T008 [US2] In `scripts/package-release.ps1`, make the identical
  extension: add `session-start-hook-guide.md` to the `references/`
  `foreach` list from T006, and `Copy-Item` `session-start.ps1` alongside
  the existing `install.ps1` copy. Depends on T001 and T006 (extends the
  same loop) — not `[P]` with T006.
- [ ] T009 [US2] Add the presence assertions to T002's bash CI step:
  `grep -q` the `tar -tzf` listing for
  `spec-jedi-v0.0.0-ci-check/README.md`,
  `spec-jedi-v0.0.0-ci-check/references/quickstart-guide.md`,
  `spec-jedi-v0.0.0-ci-check/references/what-is-sdd.md`,
  `spec-jedi-v0.0.0-ci-check/references/specjedi-and-sdd.md`,
  `spec-jedi-v0.0.0-ci-check/references/session-start-hook-guide.md`,
  `spec-jedi-v0.0.0-ci-check/scripts/session-start.sh`,
  `spec-jedi-v0.0.0-ci-check/scripts/session-start.ps1` — all seven MUST
  be found, failing loudly with `FAIL:` naming whichever is missing.
  Depends on T002 (extends its step), T005, T007 (files must exist to be
  found).
- [ ] T010 [US2] Add the matching presence assertions to T003's
  PowerShell CI step (`Test-Path` for the same seven paths). Depends on
  T003, T006, T008.

**Checkpoint**: T009/T010 turn T002/T003's job from "absence-only" into
the full completeness check spec.md's SC-002/SC-003 require — this is
the point where the CI job first exercises everything this feature adds.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: The two remaining plan.md requirements that cut across all
three stories — cross-platform staged-output parity (FR-010/SC-004) and
`specjedi-govcheck`.

- [ ] T011 Add a final step to the `package-content-completeness` job (or
  a small follow-up step) that runs both `package-release.sh` and
  `.ps1` against the identical version string in the same job run and
  diffs their two staged directory trees (before compression) — asserting
  zero differences per FR-010/SC-004. This is a genuinely new assertion;
  name it as its own explicit step rather than assuming T002/T003 already
  cover it (plan.md's Implementation notes call this out specifically).
- [ ] T012 Self-invoke `specjedi-govcheck` against this branch's full
  diff before opening the PR, per `specjedi-implement`'s standard
  pre-PR step — surface any finding, never block the PR on it.

## Dependencies & Execution Order

- **Phase 1 (T001)** blocks Phase 4 (T007, T008 copy the doc T001
  authors) but nothing in Phase 2 or Phase 3 — those don't reference the
  new doc's content, only its eventual presence (checked in Phase 4's
  T009/T010, not Phase 2's T002/T003).
- **Phase 2 (T002-T004)** has no dependency on Phase 1/3/4's content —
  it asserts *absence*, which is already true. It can run and pass
  first, proving the negative guarantee, before any positive-presence
  content exists.
- **Phase 3 (T005-T006)** depends only on Phase 2's job existing if you
  want to *observe* it via CI (optional — T005/T006 are independently
  verifiable by running the scripts locally); no code dependency on
  Phase 1, 2, or 4.
- **Phase 4 (T007-T010)** depends on Phase 1 (T001, content to copy),
  Phase 3 (T005/T006, extends the same loops), and Phase 2 (T002/T003,
  extends the same CI steps).
- **Phase 5 (T011-T012)** depends on Phases 2-4 all being in place (diffs
  the real staged output; govchecks the real full diff).
- **Within Phase 3**: T005 and T006 are `[P]` (different files, no shared
  state).
- **Within Phase 4**: T007/T008 are NOT `[P]` with T005/T006 respectively
  (they extend the same loop in the same file) but T007 and T008 ARE
  `[P]` with each other (different files). T009/T010 are `[P]` with each
  other (different CI steps, though same workflow file — no functional
  overlap).

## Implementation Strategy

**MVP scope**: Phase 1 + Phase 2 alone already ship a real, verifiable
guarantee (US3, P1) — the absence check. Phase 3 (US1) is the next
priority slice (P1, usage docs) and can ship independently. Phase 4 (US2,
P2) is the lowest-priority slice and can be deferred to a follow-up PR
without blocking the other two if scope needs to shrink.

**Incremental delivery**: Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5,
each phase's Checkpoint independently demonstrable, matching spec.md's
three independently-testable user stories.
