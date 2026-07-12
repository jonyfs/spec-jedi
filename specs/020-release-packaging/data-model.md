# Phase 1 Data Model: Release Packaging & Publishing Workflow

## Entity: Release Artifact

The versioned, downloadable package a future bootstrap installer (Sub-Project B) will fetch.

| Field | Value |
|---|---|
| Filename | `spec-jedi-<version>.tar.gz` (e.g. `spec-jedi-v0.1.0.tar.gz`) |
| Contents | `.claude/skills/specjedi-*/` (all, unmodified) + `.specify/templates/{constitution,spec,plan,tasks}-template.md` + `scripts/install.sh` + `scripts/install.ps1` + `LICENSE` |
| Excludes | `.claude/skills/speckit-*/` (bootstrap-only tooling), `.git/`, CI configuration, `specs/`, every other repo-root file |
| Built by | `scripts/package-release.sh` / `.ps1` |
| Attached to | exactly one GitHub Release (real runs only) or one workflow run artifact (dry runs only) |

## Entity: Release Run

One `workflow_dispatch` invocation of `.github/workflows/release.yml`.

| Field | Type | Notes |
|---|---|---|
| `version` | string, required | Must match `vMAJOR.MINOR.PATCH`; must not already exist as a git tag (FR-003) |
| `dry_run` | boolean, default `true` | `true` → validate + package only, zero durable side effects. `false` → tag + release + `CHANGELOG.md` commit |

**State transitions**:

```text
triggered → version validated → validate.sh passed → artifact packaged →
  ├─ dry_run=true  → artifact uploaded as workflow-run artifact → done (no durable effect)
  └─ dry_run=false → tag+release created (gh release create) → CHANGELOG.md rewritten → committed to main → done
```

Any validation failure (malformed version, duplicate version, `validate.sh`
failure, empty `## Unreleased` section) short-circuits before packaging —
no partial artifact, no partial publish.

## Harness Target mapping — unchanged

This feature does not modify `scripts/install.sh`/`.ps1`'s own Harness
Target mapping (features 001/016/019) — the packaged artifact ships that
logic unchanged; harness selection still happens at install time, inside
the extracted artifact, exactly as it does today from a full clone.
