# Quickstart: Validating Skill Freshness Validation & Update Awareness

**Feature**: specs/042-skill-freshness-validation
**Prerequisites**: A working checkout of this repository; `bash` (or
PowerShell Core for the `.ps1` variants); no network access required
except for Scenario 3.

This guide proves the feature end-to-end without needing a real GitHub
Release cut for every check — see data-model.md for the marker's exact
shape and FR references for the requirements each scenario proves.

## Scenario 1 — `install.sh` run from a local checkout writes the sentinel

```bash
dir=$(mktemp -d)
./scripts/install.sh "$dir" --harness claude-code
cat "$dir/.specify/release-marker.json"
# Expect: {"installed_release": "local-checkout"}
```

Proves FR-002, User Story 1 Scenario 2.

## Scenario 2 — A packaged release, extracted and installed directly, writes the real tag

```bash
out_dir=$(mktemp -d)
./scripts/package-release.sh v0.0.0-quickstart-check "$out_dir"
work_dir=$(mktemp -d)
tar -xzf "$out_dir/spec-jedi-v0.0.0-quickstart-check.tar.gz" -C "$work_dir"
target=$(mktemp -d)
"$work_dir/spec-jedi-v0.0.0-quickstart-check/scripts/install.sh" "$target" --harness claude-code
cat "$target/.specify/release-marker.json"
# Expect: {"installed_release": "v0.0.0-quickstart-check"}
```

Proves FR-001/FR-002 (release path), Decision 2's staged
`RELEASE_VERSION` mechanism, and — since this never invokes
`bootstrap-install.sh` — that the marker is correct even for a manually
extracted tarball, not just the bootstrap-installer path.

## Scenario 3 — `bootstrap-install.sh` against a real published release

```bash
dir=$(mktemp -d)
./scripts/bootstrap-install.sh "$dir"
cat "$dir/.specify/release-marker.json"
# Expect: {"installed_release": "<the actual latest published tag>"}
```

Proves FR-001 end-to-end (User Story 1 Scenario 1) — **once a release
containing this feature has actually been cut and published.** Run
against whatever release is *currently* published at implementation
time, this will not show a marker yet, because that release's bundled
`install.sh` predates this feature (research.md's "Implementation-time
discovery"). Scenario 2 above already proves the identical code path
(extract tarball → run bundled `install.sh`) without waiting on a real
release cut, since `bootstrap-install.sh` itself is unmodified. Re-run
this exact scenario after the next release ships as a final confirming
check, not as a CI gate.

## Scenario 4 — Session-start freshness line when behind

```bash
target=$(mktemp -d)
./scripts/install.sh "$target" --harness claude-code >/dev/null
mkdir -p "$target/.specify"
echo '{"installed_release": "v0.0.0-definitely-stale"}' > "$target/.specify/release-marker.json"
cd "$target" && bash /path/to/repo/scripts/session-start.sh
```

Expect the orientation output to include a line naming the actual latest
release tag and pointing at `scripts/bootstrap-install.sh`/`.ps1` as the
update path. Proves FR-007, User Story 2 Scenario 1, SC-002.

## Scenario 5 — Session-start stays silent when current

Seed the marker with the actual latest published tag (from Scenario 3's
output) and re-run Scenario 4's session-start invocation. Expect no
freshness line — banner and status summary only, no "you're behind"
text and no "you're current" text either (Decision 4). Proves User Story
2 Scenario 2.

## Scenario 6 — Silent degrade: no marker, no network, malformed marker

Three independent checks, each expected to produce **zero** freshness
line and **zero** error output or nonzero exit from `session-start.sh`:

1. No `.specify/release-marker.json` present at all.
2. `.specify/release-marker.json` containing invalid JSON (e.g. `not json`).
3. Network unreachable — temporarily unset `GITHUB_TOKEN` and block
   `api.github.com` (or run in a sandboxed/offline CI runner) with a
   valid marker present.

Proves FR-005, FR-006, User Story 2 Scenario 3, SC-003, all four Edge
Cases in spec.md.

## Scenario 7 — Cross-platform parity

Repeat Scenarios 1, 2, and 4 using `install.ps1`/`package-release.ps1`/
`session-start.ps1` on a Windows (or `pwsh`-native) runner and confirm
byte-for-byte equivalent marker content and freshness-line wording to the
bash runs. Proves FR-008 (Principle XIII).
