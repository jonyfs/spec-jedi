# Data Model: Skill Freshness Validation & Update Awareness

**Feature**: specs/042-skill-freshness-validation

## Entity: Installed-release marker

A small on-disk record, written at install time by `scripts/install.sh`/
`.ps1`, read (never written) at session-start time by
`scripts/session-start.sh`/`.ps1`.

**Location**: `<target-project>/.specify/release-marker.json`

**Schema**:

```json
{
  "installed_release": "v0.1.1"
}
```

**Field**: `installed_release` (string, required)

| Value shape | Meaning | Written when |
|---|---|---|
| A release tag (e.g. `v0.1.1`) | This project was installed from that published GitHub Release. | `install.sh`/`.ps1` finds a `RELEASE_VERSION` stamp file in its own source tree (see research.md Decision 2) — i.e. it's running from an extracted release tarball, whether via `bootstrap-install.sh` or a manually downloaded tarball. |
| The literal string `"local-checkout"` | Sentinel: this install came from a git clone of the repository, not a packaged release — there is nothing to compare against. | No `RELEASE_VERSION` stamp file found, but `$repo_root/.git` exists (or, as a safe fallback, neither signal is present). |

**No other states exist.** The field is always present after this feature
ships (SC-001: 100% of installs leave a marker), but pre-existing
installs (from before this feature shipped) have no `.specify/
release-marker.json` file at all — this is a valid, expected absence
(User Story 1 Scenario 3), not a third value of this field.

## Read-side handling (session-start.sh/.ps1)

The freshness check treats the following as equivalent "nothing to
report" states — all degrade silently, no freshness line, never an error
(FR-005):

1. `.specify/release-marker.json` does not exist (pre-existing install, or
   a user manually deleted it).
2. The file exists but is not valid JSON, or lacks the
   `installed_release` field (malformed / future-incompatible format).
3. `installed_release` is present and equals `"local-checkout"`.
4. The GitHub API lookup (research.md Decision 3) does not complete
   within its short timeout, returns a non-200 status, or its body
   doesn't parse to a `tag_name`.

Only when all of the above are cleared — a real tag is on disk, and a
real `tag_name` came back from the API within the timeout — does the
check proceed to the exact-string comparison (Clarification Q2) and
possibly emit a freshness line.

## Relationships

No relationships to other entities — this is a standalone, single-field
record local to each installed project. It is not committed to git by
convention (install-time local state, same category as
`.specify/feature.json`), though this feature does not require adding it
to `.gitignore` — out of scope per the spec's Assumptions (file
layout/packaging is this plan's call, but `.gitignore` policy for
target projects is outside what either installer script currently
manages).
