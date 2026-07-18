# Implementation Plan: Skill Freshness Validation & Update Awareness

**Branch**: `042-skill-freshness-validation` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/042-skill-freshness-validation/spec.md`

## Summary

Closes Constitution Principle XXII's two-part gap: (1) neither installer
records which release produced an install, and (2) nothing ever tells a
returning contributor whether their installed `specjedi-*` skills are
stale. `install.sh`/`.ps1` gain a small marker-writing step
(`.specify/release-marker.json`), sourced from a new `RELEASE_VERSION`
stamp file `package-release.sh`/`.ps1` stages into every packaged
tarball — meaning `bootstrap-install.sh`/`.ps1` need **no code changes at
all** (research.md Decision 2). `session-start.sh`/`.ps1` (Principle XXI's
existing hook) gains one more, purely additive "Part 4": a single
bounded, short-timeout reuse of `bootstrap-install.sh`'s own
`releases/latest` lookup and `GITHUB_TOKEN` handling, comparing by exact
string match and staying silent on every failure mode or when current.

## Technical Context

**Language/Version**: Bash (`set -euo pipefail`/`set -uo pipefail`
matching each touched script's own existing style) and PowerShell Core —
matching `scripts/install.sh`/`.ps1`, `scripts/bootstrap-install.sh`/
`.ps1`, `scripts/session-start.sh`/`.ps1`, and `scripts/package-release.sh`/
`.ps1`'s existing conventions exactly. No new language, no new runtime
dependency.

**Primary Dependencies**: None new. `curl` (bash) / `Invoke-RestMethod`
(PowerShell) for the freshness check's single HTTP call — both already
required by `bootstrap-install.sh`/`.ps1` today, no new dependency
introduced. `grep`/`sed` (bash) and native JSON cmdlets (PowerShell) for
marker read/write, matching this project's established zero-`jq`
precedent (specs/039, specs/041).

**Storage**: One new on-disk file per installed target project:
`.specify/release-marker.json` (data-model.md). No other persistent
state. Nothing server-side.

**Testing**: Extends `.github/workflows/validate.yml`'s existing
`bootstrap-installer-smoke` and `package-content-completeness` jobs with
marker-presence assertions, plus a new `install-test-release-marker` job
(and its `-windows-native` counterpart) following the exact pattern
`install-test-shared-hooks`/`-windows-native` already established (real
scratch-directory installs, real file-content assertions — Principle IX,
never asserted in docs alone). See quickstart.md for the seven concrete
scenarios these CI jobs encode.

**Target Platform**: Linux, macOS, Windows — every new code path in the
`.sh` variant of each touched script gains a behaviorally identical
`.ps1` counterpart (Principle XIII).

**Project Type**: Existing installer/hook CLI scripts, extended in
place — same class of change as specs/039/040/041, no new project
structure.

**Performance Goals**: The freshness check adds at most one short-timeout
HTTP round-trip (research.md Decision 3) to `session-start.sh`'s existing
sub-second execution; per SC-003, any failure path must add zero
perceptible latency beyond that single bounded attempt.

**Constraints**: `SessionStart` hook output is capped at 10,000
characters of `additionalContext` (Principle XXI) — the new freshness
line is at most one short sentence, negligible against that budget. The
check MUST run inside the existing `SessionStart` hook — zero new hook
registrations (FR-003, SC-004). The network call MUST be a single
attempt bounded by an explicit short timeout, never
`bootstrap-install.sh`'s own 3-attempt retry loop (FR-006, research.md
Decision 3).

**Scale/Scope**: Four scripts modified in pairs (`install.sh`/`.ps1`,
`package-release.sh`/`.ps1`, `session-start.sh`/`.ps1`) plus CI. Smallest
class of change this repo makes — no new abstraction, no new files
beyond the one marker format (data-model.md) and the one stamp file
(`RELEASE_VERSION`).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I (English-Source) | All new file content, script comments, and this plan's own docs are English-only. | ✅ Pass |
| II (Competitive Research Before Creation, NON-NEGOTIABLE) | No new structural pattern is being introduced — this feature explicitly reuses `bootstrap-install.sh`'s existing, already-researched (specs/024) release-lookup mechanism rather than inventing a new one; Principle XXII's own text already did this reasoning at the constitution level. | ✅ Pass — no new external pattern to research |
| VIII (Token-Economy Tooling) | Marker format (single-field JSON) and comparison (exact string match) are the cheapest correct options — no `jq`, no semver library, no new dependency (research.md Decisions 1/3). | ✅ Pass |
| IX (Mandatory Skill Validation & Testing) | New CI assertions join `validate.yml`'s existing per-scenario jobs (Testing above) — not asserted in docs alone. | ✅ Pass — planned in Project Structure below |
| X (Trunk-Based Git Workflow) | Work proceeds on feature branch `042-skill-freshness-validation`, PR into `main`. | ✅ Pass |
| XI (Semantic-Versioned Releases) | The marker records exactly the tags this project's own release process already produces (`v0.1.0`, `v0.1.1`, ...) — no new versioning scheme introduced. | ✅ Pass |
| XIII (Cross-Platform Support) | Every new `.sh` code path gains an equivalent `.ps1` path (Scale/Scope above). | ✅ Pass — planned in Project Structure below |
| XX (AI Discipline: Grounded, Honest Output) | The check never guesses: any incomplete state (no marker, malformed marker, unreachable API, rate limit) degrades to silence, never a fabricated staleness verdict (FR-005, data-model.md Read-side handling). | ✅ Pass |
| XXI (Session-Start Orientation) | Ships as one additive line inside the existing `SessionStart` hook — no second hook, no interference with Parts 1-3's existing banner/status/Yoda-line assembly. | ✅ Pass |
| XXII (Skill Freshness Validation & Update Awareness) | This plan is this principle's own implementing feature — every constraint in the principle text (one mechanism, marker-first prerequisite, advisory-only, existing update path) is traced to a specific FR and Decision above. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/042-skill-freshness-validation/
├── plan.md              # This file
├── research.md           # Phase 0 output — 4 technical decisions
├── data-model.md         # Phase 1 output — the marker entity's exact shape
├── quickstart.md         # Phase 1 output — 7 manual/CI validation scenarios
└── tasks.md              # Phase 2 output (speckit-tasks)
```

No `/contracts/` — this feature has no external API surface; the marker
file's schema (data-model.md) and the GitHub `releases/latest` endpoint
(already contracted by specs/024) are the only interfaces involved, and
both are fully specified above.

### Source Code (repository root)

```text
scripts/
├── install.sh              # MODIFIED: writes .specify/release-marker.json
│                             #   (FR-001/FR-002) — detects RELEASE_VERSION
│                             #   stamp file vs .git presence (research.md
│                             #   Decision 2)
├── install.ps1              # MODIFIED: identical logic, PowerShell idiom
├── package-release.sh        # MODIFIED: stages RELEASE_VERSION stamp file
│                             #   into the tarball root (research.md Decision 2)
├── package-release.ps1       # MODIFIED: identical addition
├── session-start.sh          # MODIFIED: new "Part 4" — freshness check
│                             #   (FR-003/004/005/006/007), additive only,
│                             #   never touches Parts 1-3's existing assembly
├── session-start.ps1         # MODIFIED: identical logic, PowerShell idiom
│                             #   (Invoke-RestMethod -TimeoutSec, not curl)
└── bootstrap-install.sh/.ps1  # NOT MODIFIED — satisfied transitively
                              #   (research.md Decision 2)

.github/workflows/
└── validate.yml             # MODIFIED: extends bootstrap-installer-smoke
                              #   and package-content-completeness with
                              #   marker assertions; new
                              #   install-test-release-marker (+
                              #   -windows-native) job pair
```

### Implementation notes for `speckit-tasks`/`speckit-implement`

**Marker write (`install.sh`, FR-001/FR-002)** — placed alongside the
script's existing `.specify/templates` staging step:

```bash
write_release_marker() {
  local target="$1" value
  if [ -f "$repo_root/RELEASE_VERSION" ]; then
    value="$(tr -d '[:space:]' < "$repo_root/RELEASE_VERSION")"
  elif [ -d "$repo_root/.git" ]; then
    value="local-checkout"
  else
    value="local-checkout"
  fi
  mkdir -p "$target/.specify"
  printf '{"installed_release": "%s"}\n' "$value" > "$target/.specify/release-marker.json"
}
```

**Package staging (`package-release.sh`, research.md Decision 2)** —
one line alongside the script's existing `cp "$repo_root/scripts/install.sh" ...`
staging calls:

```bash
printf '%s' "$version" > "$stage_root/RELEASE_VERSION"
```

**Freshness check (`session-start.sh`, FR-003 through FR-007)** — a new,
fully self-contained function appended after Part 3's Yoda-line assembly
and before the final `printf`/`exit 0`. Every step MUST fail toward
silence, never toward a nonzero exit or stderr output, consistent with
this script's own existing "no `set -e`, degrade gracefully" discipline
(top-of-file comment). Sketch:

```bash
freshness_line=""
marker="$repo_root/.specify/release-marker.json"
if [ -f "$marker" ]; then
  installed="$(grep -o '"installed_release":[[:space:]]*"[^"]*"' "$marker" 2>/dev/null \
    | sed -E 's/.*"([^"]*)"$/\1/')"
  if [ -n "$installed" ] && [ "$installed" != "local-checkout" ]; then
    auth_header=()
    [ -n "${GITHUB_TOKEN:-}" ] && auth_header=(-H "Authorization: Bearer $GITHUB_TOKEN")
    response="$(curl -sSL --max-time 2 ${auth_header[@]+"${auth_header[@]}"} \
      "https://api.github.com/repos/jonyfs/spec-jedi/releases/latest" 2>/dev/null || true)"
    latest="$(printf '%s' "$response" | grep -m1 '"tag_name"' \
      | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')"
    if [ -n "$latest" ] && [ "$latest" != "$installed" ]; then
      freshness_line="Update available: $installed installed, $latest published — run scripts/bootstrap-install.sh/.ps1 to update."
    fi
  fi
fi
```

The final `printf` assembling banner/status/Yoda-line/freshness gains a
conditional fourth segment only when `$freshness_line` is non-empty —
Parts 1-3's own output is byte-identical to today when the check yields
nothing, satisfying "purely additive."

**PowerShell counterpart**: same structure, `ConvertFrom-Json` for the
marker (native, no regex needed) and `Invoke-RestMethod -TimeoutSec 2
-ErrorAction Stop` wrapped in `try`/`catch` that swallows any exception
into silence — the PowerShell-idiomatic equivalent of the bash `|| true`
pattern already used throughout `session-start.ps1`.

**CI (`validate.yml`)**: follow `install-test-shared-hooks`'s exact shape
(quickstart.md Scenarios 1, 2, 6 as bash `run:` steps); extend
`package-content-completeness`'s existing tarball-listing assertions with
one more required path (`RELEASE_VERSION`); extend
`bootstrap-installer-smoke`'s existing post-install assertions with a
marker-content check reading the real tag it just installed.
