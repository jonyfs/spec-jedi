# Implementation Plan: Expand the Release Package's Contents

**Branch**: `038-expand-release-package` | **Date**: 2026-07-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/038-expand-release-package/spec.md`

## Summary

`scripts/package-release.sh`/`.ps1` currently stage only
`.claude/skills/specjedi-*/`, the four `.specify/templates/*.md` files,
`scripts/install.sh`/`.ps1`, and `LICENSE` into the downloadable tarball.
This feature adds, as an explicit allowlist (never "copy everything"):
`README.md`; three existing user-facing reference docs
(`references/quickstart-guide.md`, `references/what-is-sdd.md`,
`references/specjedi-and-sdd.md`); a new reference doc explaining the
session-start hook and its per-harness adaptation status; and the
`scripts/session-start.sh`/`.ps1` utility scripts themselves. It
explicitly does **not** change `scripts/install.sh`/`.ps1` to
auto-configure any hook — this is a packaging change, not an installer
behavior change. A new CI check builds a real scratch package and asserts
the full expected content set is present and every internal-authoring
file is absent.

## Technical Context

**Language/Version**: Bash (POSIX-ish, matches `package-release.sh`'s
existing `set -euo pipefail` style) and PowerShell Core (matches
`package-release.ps1`'s existing `$ErrorActionPreference = 'Stop'` style)
— no new language, this feature only extends two existing scripts.

**Primary Dependencies**: `tar` (already used by both scripts), no new
external dependency.

**Storage**: N/A — the "storage" here is the release tarball itself,
already the pattern both scripts produce.

**Testing**: `scripts/validate.sh`/`.ps1` plus `.github/workflows/validate.yml`
— matches the existing pattern of `bootstrap-installer-smoke` (which
already builds and exercises a real package end-to-end in CI, see
`.github/workflows/validate.yml`'s `package-release.sh` invocation
inside the release workflow, and `specs/020-release-packaging/tasks.md`'s
own precedent for testing packaging logic with a real scratch build
rather than mocking `tar`).

**Target Platform**: Linux, macOS, Windows — both script variants must
stay identical in staged output (Principle XIII), verified by a CI job
that diffs their staged trees.

**Project Type**: CLI/build-tooling scripts within an existing repo — no
new project structure.

**Performance Goals**: N/A — packaging already runs once per release, a
few new file copies add negligible time.

**Constraints**: The four newly-added `references/*.md` files must be
placed at the *same relative path* they occupy in the source repo
(`references/<name>.md`) so their existing internal relative links (e.g.
`references/quickstart-guide.md`'s `../README.md#how-spec-jedi-implements-sdd`
link) continue to resolve once extracted, per FR-004/Edge Cases.

**Scale/Scope**: Two files change (`package-release.sh`, `package-release.ps1`),
one new reference doc is authored, one new CI job is added — no changes
to `install.sh`/`.ps1` (explicitly out of scope per FR-009).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I (English-Source, Globally-Localized Docs) | New reference doc (`references/session-start-hook-guide.md`) is English-source; not one of the two files (README.md, CONTRIBUTING.md) Principle I requires translated into all 10 languages — `references/*.md` files are English-only by existing project convention. | ✅ Pass — no translation obligation triggered |
| II (Skill-First Distribution) | This feature touches packaging/docs, not skill content itself. | ✅ N/A |
| IX (Mandatory Skill Validation & Testing) | New CI job (FR-011) validates the packaging change for real (builds an actual tarball, asserts contents) rather than asserting behavior in docs only — matches this principle's non-negotiable validation standard. | ✅ Pass — planned in Project Structure below |
| XI (Semantic-Versioned Releases) | This feature doesn't change when/how releases are cut, only what a given release contains. | ✅ N/A |
| XIII (Cross-Platform Support) | Both `package-release.sh` and `.ps1` gain the identical new allowlist entries; FR-010/SC-004 require their staged output to match exactly. | ✅ Pass — planned in Project Structure below |
| XVI (Efficient Documentation & Mermaid Diagram Literacy) | The new hooks reference doc is a straightforward explanation + a per-harness status table — prose/table is the efficient format here, not a diagram (no process flow or relationship graph to visualize). | ✅ Pass — no diagram warranted |
| XVIII (Zero-Footprint Installer with Harness Selection) | FR-009 explicitly keeps `install.sh`/`.ps1` unchanged — this principle's installer behavior is not touched by this feature. | ✅ Pass — confirmed out of scope |
| XX (AI Discipline: Grounded, Honest Output) | FR-008 requires the new hooks doc to state per-harness hook-mechanism status honestly (known/unknown), grounded in `references/harness-capability-notes.md`'s existing research — never a fabricated blanket claim. | ✅ Pass — planned in Project Structure below |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/038-expand-release-package/
├── plan.md              # This file
├── tasks.md             # Phase 2 output (specjedi-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — this feature has no
data entities or external interface contracts beyond the tarball's own
file layout, already fully specified in spec.md's Key Entities and
Requirements sections; a separate `quickstart.md` would duplicate
spec.md's own Acceptance Scenarios and User Stories.

### Source Code (repository root)

```text
scripts/
├── package-release.sh        # MODIFIED: add references/ allowlist copy loop,
│                              #   session-start.sh copy
├── package-release.ps1       # MODIFIED: identical additions, PowerShell idiom
├── session-start.sh          # UNCHANGED — now also copied into the package
├── session-start.ps1         # UNCHANGED — now also copied into the package
├── validate.sh                # MODIFIED: new package-content-completeness check
└── validate.ps1                # MODIFIED: identical new check

references/
└── session-start-hook-guide.md   # NEW — hook mechanism + per-harness status

.github/workflows/
└── validate.yml               # MODIFIED: wire the new validate.sh/.ps1 check
                                #   into a CI job (or extend an existing one),
                                #   required by ci-gate
```

### Implementation notes for `specjedi-tasks`/`specjedi-implement`

- **`package-release.sh`** (bash): after the existing templates-copy loop,
  add a `references_dst="$stage_root/references"` + `mkdir -p` + a
  `for ref in quickstart-guide.md what-is-sdd.md specjedi-and-sdd.md session-start-hook-guide.md; do cp ...; done`
  loop — same style as the existing templates loop (explicit array, not a
  glob, per FR-005's allowlist requirement). Add a single
  `cp "$repo_root/scripts/session-start.sh" "$stage_root/scripts/session-start.sh"`
  (and matching for `.ps1`) alongside the existing `install.sh`/`.ps1`
  copies. Update the `usage()` heredoc to name the new contents (matches
  this script's existing convention of the usage text being a truthful
  content manifest).
- **`package-release.ps1`**: identical additions using this script's
  existing `Copy-Item`/`New-Item -ItemType Directory -Force` idiom and
  `foreach (... in @(...))` array style (matches the existing templates
  loop at the line copying `constitution-template.md` etc.).
- **`references/session-start-hook-guide.md`** (new): explains what
  `scripts/session-start.sh`/`.ps1` does (reads `SessionStart` hook
  stdin, calls `specjedi-status`'s on-disk logic, emits `additionalContext`
  — matches the mechanism `.specify/memory/constitution.md`'s Principle
  XXI already documents precisely); shows the exact
  `.claude/settings.json` registration this repo's own `.claude/settings.json`
  uses as a working example; then a per-harness status table built from
  `references/harness-capability-notes.md`'s existing research — for each
  of the 20 harnesses, state "confirmed hook/automation mechanism" /
  "unconfirmed — adapt manually" rather than guessing.
- **CI check (FR-011)**: extend `.github/workflows/validate.yml`'s
  existing `bootstrap-installer-smoke` job (or a new
  `package-content-completeness` job, matching that job's
  `runs-on: ${{ matrix.os }}` / `os: [ubuntu-latest, macos-latest, windows-latest]`
  matrix pattern) that runs `scripts/package-release.sh v0.0.0-ci-check /tmp/pkg-check`
  (bash leg) and the PowerShell equivalent, then asserts via `tar -tzf`
  (or `Expand-Archive`/`tar` on the PowerShell leg) that every FR-003/
  FR-004/FR-007 path is present and every FR-006 path is absent — mirrors
  the existing "assert real output, not mocked" discipline already used
  by `install-test`/`bootstrap-installer-smoke`.
- **Cross-platform parity check (FR-010/SC-004)**: same CI job (or a
  follow-up step) runs both scripts against the same version string and
  diffs the two staged directory trees before compression — this is a
  genuinely new assertion the existing CI battery doesn't have yet for
  `package-release.*`, so name it explicitly as a new step rather than
  assuming an existing job already covers it.
