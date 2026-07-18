# Research: Skill Freshness Validation & Update Awareness

**Feature**: specs/042-skill-freshness-validation
**Date**: 2026-07-18

All items below were genuine open decisions after `/speckit-clarify` (three
clarifications already resolved in `spec.md`'s `## Clarifications`
section). This document resolves the remaining *technical* design
questions the spec deliberately left to planning.

## Decision 1: Where does the marker live, and in what format?

**Decision**: `.specify/release-marker.json`, a single-field JSON file:
`{"installed_release": "v0.1.1"}` or `{"installed_release": "local-checkout"}`.

**Rationale**: `.specify/` is already this repo's convention for
project-level, harness-agnostic Spec Jedi metadata that isn't part of any
one harness's own config (`feature.json`, `init-options.json`,
`integration.json`, `extensions.yml` all live there today, and
`install.sh` already stages `.specify/templates/*` into every install
target — the directory is guaranteed to exist post-install). JSON matches
every sibling file in that directory (grep/sed field extraction, no `jq`
dependency, consistent with this project's established zero-`jq`
precedent). A single scalar field keeps read/write trivial in both bash
(`grep`/`sed`, matching `.specify/feature.json`'s own existing edit
pattern) and PowerShell (`ConvertFrom-Json`/`ConvertTo-Json`, both
built in).

**Alternatives considered**:
- Plain-text single-token file (no JSON) — marginally simpler, but
  inconsistent with every other `.specify/*` metadata file already in the
  directory; rejected for consistency, not correctness.
- Storing it in `.claude/settings.json` — rejected: that file is
  harness-specific (`claude-code` only) and this repo installs into 19+
  other harnesses; the marker must exist regardless of which harness the
  user chose, so it belongs at the harness-agnostic `.specify/` layer.

## Decision 2: How does `install.sh` know whether it's a local checkout or an installed release?

**Decision**: `package-release.sh`/`.ps1` (specs/020) is extended to stage
one new file into the tarball root: `RELEASE_VERSION` (plain text,
single line, the version string passed as `package-release.sh`'s own
first argument — e.g. `v0.1.1`). `install.sh`/`.ps1` then writes the
target's marker using this rule, checked in order:

1. If `$repo_root/RELEASE_VERSION` exists (i.e. `install.sh` is running
   from an extracted release tarball, whether launched by
   `bootstrap-install.sh` or by a user who downloaded and extracted a
   release tarball manually) → write `installed_release` = that file's
   content.
2. Else if `$repo_root/.git` exists (a real git checkout) → write
   `installed_release` = `"local-checkout"`.
3. Else (neither signal present — a hand-copied file tree with no `.git`
   and no stamp file; not a scenario either installer script can
   currently produce, but a safe fallback matters more than a fabricated
   version) → write `"local-checkout"`, per FR-002's "never fabricate a
   version" requirement.

**Rationale**: This makes `install.sh` fully self-sufficient — it
determines the correct marker value from its own source tree, with zero
new coupling to `bootstrap-install.sh`. Concretely, **`bootstrap-install.sh`/`.ps1` need NO code changes at all** to satisfy FR-001: it already
extracts a release tarball and runs `install.sh` from inside it (line 156
of the current script); once `package-release.sh` stages
`RELEASE_VERSION` into that tarball, `install.sh`'s own new detection
logic produces the correct marker automatically, for both the
bootstrap-install path AND the "user manually downloaded+extracted a
release tarball and ran `install.sh` directly" path that
FR-002/Acceptance Scenario 2 also implies must resolve to a real tag, not
a sentinel. FR-001 is satisfied by the *outcome* (a `bootstrap-install.sh`
run always leaves a correct marker) exactly as the spec's own
Independent Test criterion frames it ("running each installer... and
inspecting the resulting marker file/value") — not by requiring the
literal write statement to live inside `bootstrap-install.sh`'s own
source file.

**Alternatives considered**:
- Pass the tag from `bootstrap-install.sh` to `install.sh` via an env var
  or new flag (e.g. `SPEC_JEDI_RELEASE_TAG`) — rejected: this only covers
  the bootstrap-install invocation path. A user who downloads a release
  tarball from the GitHub Releases page directly (without going through
  `bootstrap-install.sh`) and runs `./scripts/install.sh` themselves would
  incorrectly fall back to `.git`-detection (absent, since a tarball has
  no `.git`) and, without the stamp file, have no way to recover a real
  tag at all. The staged-file approach handles both invocation paths with
  one rule.
- Detecting "release" purely from `.git`'s absence, with no stamp file —
  rejected: a shallow/partial clone or a `.git`-stripped copy would then
  be silently (and incorrectly) treated as a full release install with no
  tag to report, forcing a fabricated or empty version — exactly what
  FR-002 forbids.

## Decision 3: How does the session-start freshness check make its network call?

**Decision**: A new function in `session-start.sh`/`.ps1` reuses
`bootstrap-install.sh`'s URL construction (`api.github.com/repos/<owner>/
<repo>/releases/latest`), its opportunistic `GITHUB_TOKEN`
`Authorization: Bearer` header, and its grep/sed `tag_name` field
extraction — but as a **single attempt with an explicit short timeout**
(e.g. `curl -sSL --max-time 2 ...` / PowerShell
`Invoke-RestMethod -TimeoutSec 2`), never `bootstrap-install.sh`'s own
3-attempt retry-with-backoff loop (lines 93-104 of the current script).

**Rationale**: Directly resolves Clarification Q1 — `bootstrap-install.sh`'s
retry loop can take several seconds across three attempts and has no cap
on any single attempt's own duration, which is fine for a foreground
install a user is actively watching but is exactly what FR-006 forbids
for a hook that runs on every session start. "Reuses the identical
lookup" (FR-004) is satisfied at the level that matters — same endpoint,
same auth mechanism, same zero-`jq` parsing technique — without importing
the retry wrapper that would make the check unbounded in the worst case.

**Alternatives considered**:
- Literally shelling out to (a copy of) `bootstrap-install.sh`'s retry
  logic — rejected per Clarification Q1: no explicit timeout on any
  single attempt inside that loop, and 3 attempts × sleep(1)+sleep(2)
  could add several seconds to every single session start in a bad
  network state.

## Decision 4: What happens when the marker matches the latest release?

**Decision**: Stay silent — no freshness line at all when current.

**Rationale**: Acceptance Scenario 2 explicitly allows either "confirms
current" or silence ("no false 'behind' claim"). Silence keeps the
session-start banner uncluttered on the common case (most sessions, most
days, the project *is* current), consistent with Principle XX's
"grounded, not noisy" discipline and this hook's existing terse three-part
structure (`session-start.sh` Part 1/2/3) — a fourth line only appears
when there's something the user actually needs to act on.

**Alternatives considered**:
- Always show a line ("current" or "behind") — rejected: adds
  guaranteed-noise on 100% of sessions to inform on the minority where
  the user is actually behind; the spec's own wording treats both as
  compliant, and terser wins per this hook's established style.

## Implementation-time discovery: `bootstrap-installer-smoke` can't assert marker content yet

Confirmed by direct execution (`./scripts/bootstrap-install.sh <scratch-dir>`
against the real, already-published `v0.1.1` release): the marker file is
**not** produced, because `bootstrap-install.sh` downloads and runs
whatever `install.sh` was actually packaged into that already-published
release — code that predates this feature and has no marker-writing
logic at all. This is not a regression; it's the same "depends on a real
release existing" timing constraint `bootstrap-install.sh`'s own source
comment already documents for specs/024's original smoke test. The
marker-writing logic only ships in whatever release gets cut *after*
this PR merges.

**Consequence for the CI plan**: `bootstrap-installer-smoke` (which
downloads the real, currently-published release) MUST NOT gain a new
"marker is present" assertion — it would fail on every run until the
next release is cut, permanently red for reasons unrelated to this PR's
own correctness. The real, timing-independent proof that
`bootstrap-install.sh`'s eventual behavior will be correct is already
covered by `install-test-release-marker` (quickstart.md Scenario 2):
building a release tarball locally via `package-release.sh` and running
its bundled `install.sh` directly proves the exact same code path
`bootstrap-install.sh` triggers (extract tarball → run bundled
`install.sh`) without needing to wait for a real release cut.
`bootstrap-install.sh` itself is unmodified (Decision 2), so this
substitution loses no real coverage.

## Implementation-time discovery: `package-release.sh`/`.ps1` never staged the shareable hook, breaking `bootstrap-install.sh` for `claude-code` since specs/041

Found while testing this feature's own marker-writing logic against a
real packaged tarball (the exact same code path `bootstrap-install.sh`
exercises): `install.sh`/`.ps1`'s shareable-hooks step (specs/041) reads
`$repo_root/.claude/hooks/dangerous-command-guard.sh`/`.ps1`
unconditionally for `claude-code` (and every Wave 1/2 harness), but
`package-release.sh`/`.ps1` (specs/020/038) never staged those files
into the tarball. Running `install.sh` from any extracted release
tarball therefore exited non-zero — meaning `bootstrap-install.sh`'s
entire reason to exist (install from a downloaded release, no clone
required) has silently failed for `claude-code` since specs/041 shipped.
This escaped `bootstrap-installer-smoke` because that job downloads
whatever release is *currently published* (predates specs/041 entirely).

**Fix**: `package-release.sh`/`.ps1` now also stage
`.claude/hooks/dangerous-command-guard.sh`/`.ps1` into the tarball root,
alongside the new `RELEASE_VERSION` stamp file (Decision 2). Verified:
exit 0 from both `install.sh` and `install.ps1` run against a freshly
built package, byte-identical `.sh`/`.ps1` package trees preserved.
`package-content-completeness`'s existing "must exist" assertions
(bash and PowerShell) now also require these two paths, so this
regression class can't reoccur silently.

## Summary of touched files

| File | Change |
|---|---|
| `scripts/install.sh` / `.ps1` | New marker-writing logic (Decision 2) |
| `scripts/package-release.sh` / `.ps1` | Stage new `RELEASE_VERSION` file into tarball root (Decision 2) |
| `scripts/session-start.sh` / `.ps1` | New "Part 4": freshness check + optional line (Decisions 1, 3, 4) |
| `.github/workflows/validate.yml` | New/extended CI assertions (see quickstart.md) |
| `scripts/bootstrap-install.sh` / `.ps1` | **No changes** — satisfied transitively via Decision 2 |
