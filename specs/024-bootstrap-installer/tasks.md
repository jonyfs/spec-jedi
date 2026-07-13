# Tasks: Standalone Bootstrap Installer

**Input**: Design documents from `/specs/024-bootstrap-installer/`

**Note**: written retrospectively (2026-07-13), backfilled after a
`/speckit-analyze` markdown audit found this feature — already shipped
via PR #82 and declared complete in `references/skill-roadmap.md` and
`CHANGELOG.md` — had no `tasks.md`/`checklists/requirements.md`, unlike
every other feature in this repo. Tasks below reflect what was actually
built and verified.

**Tests**: Principle VI exemption — installer-script work (plan.md's
Constitution Check states this explicitly); verified via the live,
current GitHub API (a genuine 404, no releases published) plus a fully
simulated local end-to-end run against a real artifact built by
`scripts/package-release.sh`.

---

## Phase 1: Core script (US1)

- [X] T001 [US1] Write `scripts/bootstrap-install.sh`: GitHub Releases
      API lookup (`/releases/latest` or `/releases/tags/<version>`),
      grep/sed-only JSON field extraction (no `jq` dependency).
- [X] T002 [US1] Write `scripts/bootstrap-install.ps1`: native
      `Invoke-RestMethod` JSON parsing counterpart.
- [X] T003 [US1] Implement download → `mktemp -d`/temp-dir extraction →
      locate the `spec-jedi-*` directory → hand off to its bundled
      `install.sh`/`.ps1`, forwarding `--harness`/`--auto` unchanged.

## Phase 2: Honest failure handling (US1, Known Limitation)

- [X] T004 [US1] Implement the "no release found" path: clear,
      Principle-XI-aware message plus a git-clone fallback command —
      never a raw curl/API stack trace.
- [X] T005 Verify T004 against the real, live GitHub API for this repo
      (genuine 404 — no releases exist) for both scripts.
- [X] T006 Verify the full download→extract→install handoff against a
      locally-built release artifact (`scripts/package-release.sh`),
      since no real published release exists yet to test against —
      documented as a known limitation, not hidden.

## Phase 3: Validation

- [X] T007 Add `bootstrap-installer-smoke` CI job (`--help`/`-Help` plus
      the real no-release path) across Linux/macOS/Windows.
- [X] T008 Wire the new job into `ci-gate`'s `needs:` list.

## Phase 4: Documentation

- [X] T009 Add the bootstrap one-liner to README's Installation section,
      with the honest "no release yet" caveat inline.
- [X] T010 Update `references/skill-roadmap.md` (Sub-Project B moved to
      Shipped, limitation stated inline) and `CHANGELOG.md`.
