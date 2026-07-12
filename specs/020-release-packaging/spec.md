# Feature Specification: Release Packaging & Publishing Workflow

**Feature Branch**: `020-release-packaging`

**Created**: 2026-07-12

**Status**: Draft

**Input**: User description (via `/superpowers:brainstorming`, then materialized through `/speckit-specify`): "Build a real, deliberate release-cutting mechanism for Spec Jedi. Today `scripts/suggest-release.sh` only ever suggests the next semantic version — it never tags or publishes, and this repository has zero git tags and zero GitHub Releases. This is the prerequisite piece (Sub-Project A of 3) for a larger goal: a standalone bootstrap installer script (Homebrew/SDKMAN-style, no repo clone required) that lets a user pick from already-released versions — which requires actual releases to exist first. Deliberate, manual `workflow_dispatch` trigger only (never automatic on push/merge, preserving Constitution Principle XI's 'cutting is always a deliberate, maintainer-driven step'). A `dry_run` input (default `true`) validates and packages everything without any side effect, so the mechanism itself can be proven safe before the real first cut (v0.1.0, chosen over v1.0.0 specifically because the release-artifact format itself is new and unproven). A single universal downloadable artifact (not per-harness), since harness selection already happens at install time via `scripts/install.sh`'s existing `--harness` flag — duplicating that mapping into the packaging step would create two places the harness→directory mapping could drift out of sync. The release must never publish if `scripts/validate.sh` fails first."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The maintainer safely rehearses a release before cutting one for real (Priority: P1)

The maintainer wants to prove the entire release mechanism — version
validation, artifact packaging, changelog handling — works correctly
without any risk of publishing a broken or premature release, especially
since this is the very first release this project has ever cut.

**Why this priority**: Nothing else in this feature matters if the
mechanism itself can't be trusted; a `dry_run` rehearsal is the
precondition for the maintainer having enough confidence to flip to a
real cut (User Story 2).

**Independent Test**: Trigger the workflow with `dry_run: true` (the
default) for a plausible next version; confirm every step runs
(validation, packaging, changelog diff) and confirm afterward that zero
git tags, zero GitHub Releases, and zero commits to `main` resulted.

**Acceptance Scenarios**:

1. **Given** the workflow is triggered with `dry_run: true` and a valid,
   unused version string, **When** it runs, **Then** it validates the
   version format, runs `scripts/validate.sh`, builds the release
   artifact, and computes the changelog section it *would* write —
   reporting all of this in the run's summary — without creating a tag,
   a GitHub Release, or a commit.
2. **Given** the same dry run, **When** it completes, **Then** the built
   artifact is available as a workflow run artifact (for manual
   inspection) even though nothing was published.

---

### User Story 2 - The maintainer cuts a real, deliberate release (Priority: P1) 🎯 MVP

The maintainer decides the project is ready for its first real release
and wants a single, explicit, auditable action that produces a tagged
GitHub Release with a downloadable artifact — never something that
happens silently as a side effect of merging code.

**Why this priority**: This is the actual deliverable — without it,
Spec Jedi has no downloadable, versioned artifact at all, which blocks
every downstream goal (a standalone installer, version selection, "what
release am I even on" questions from users).

**Independent Test**: Trigger the workflow with `dry_run: false` and
`version: v0.1.0`; confirm a `v0.1.0` git tag, a GitHub Release with that
tag, and a downloadable `spec-jedi-v0.1.0.tar.gz` artifact attached all
exist afterward, and that `CHANGELOG.md` on `main` now has a real `##
[v0.1.0]` section instead of everything sitting under `## Unreleased`.

**Acceptance Scenarios**:

1. **Given** a valid, unused version and `dry_run: false`, **When** the
   workflow runs and `scripts/validate.sh` passes, **Then** it creates
   and pushes a `vX.Y.Z` git tag, creates a GitHub Release for that tag
   with the packaged artifact attached, and commits an updated
   `CHANGELOG.md` (the `## Unreleased` section's content moved under a
   new `## [vX.Y.Z] - YYYY-MM-DD` heading) to `main`.
2. **Given** `scripts/validate.sh` fails for any reason, **When** the
   workflow runs (dry run or real), **Then** it fails immediately before
   packaging or publishing anything — a release is never published in a
   broken state.
3. **Given** a version string that is malformed (not `vX.Y.Z`) or
   already used by an existing tag, **When** the workflow runs, **Then**
   it fails immediately with a clear message identifying the problem,
   before any other step executes.

---

### User Story 3 - The downloadable artifact contains exactly what the existing installer needs (Priority: P2)

A future consumer of this artifact (the standalone bootstrap installer
script, a separate future feature) needs the artifact's contents to be
exactly what `scripts/install.sh` already knows how to install from —
no new file layout to learn, no harness-specific pre-filtering to
reverse-engineer.

**Why this priority**: Gets this feature's actual contents right, but is
secondary to the mechanism (User Stories 1-2) actually working at all;
an artifact with the wrong contents is a smaller, easier fix than a
release mechanism that doesn't work or isn't safe to rehearse.

**Independent Test**: Extract the built artifact into a scratch
directory; confirm `scripts/install.sh --harness claude-code` (or any
other supported harness) run from inside that extracted directory
produces an identical install to running it from a full repository
clone.

**Acceptance Scenarios**:

1. **Given** the built artifact, **When** it is extracted, **Then** it
   contains every `.claude/skills/specjedi-*/` directory unmodified, all
   four `.specify/templates/*.md` files, `scripts/install.sh`,
   `scripts/install.ps1`, and `LICENSE` — and nothing else (no
   `speckit-*` bootstrap tooling, no `.git/`, no CI configuration).
2. **Given** the same artifact, **When** `scripts/install.sh` is run
   from inside it for each of the five currently-supported harnesses
   (`claude-code`, `codex-cli`, `trae`, plus `opencode`/`warp`'s
   already-satisfied paths), **Then** every install succeeds identically
   to running from a full clone.

### Edge Cases

- What happens if the workflow is triggered twice concurrently for the
  same version? The tag-push step MUST fail cleanly (git rejects a
  duplicate tag) rather than silently overwriting or producing two
  releases for the same version.
- What happens if `CHANGELOG.md`'s `## Unreleased` section is empty at
  release time (nothing shipped since the last release)? The workflow
  MUST fail with a clear message rather than publishing a release with
  an empty or fabricated changelog section — an empty release is a sign
  something is wrong (or that a release isn't actually warranted yet),
  not something to paper over.
- What happens to the workflow run's build artifact after a `dry_run`?
  It follows GitHub Actions' standard workflow-artifact retention
  (available for download/inspection, auto-expires) — it is never
  itself published as a GitHub Release.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A new `.github/workflows/release.yml` MUST exist, triggered
  only by `workflow_dispatch` — never by `push`, `pull_request`, or any
  other automatic trigger.
- **FR-002**: The workflow MUST accept two inputs: `version` (required,
  string, `vX.Y.Z` format) and `dry_run` (boolean, default `true`).
- **FR-003**: The workflow MUST validate `version` matches semantic
  versioning format (`vMAJOR.MINOR.PATCH`) and does not already exist as
  a git tag, failing immediately with a clear message if either check
  fails.
- **FR-004**: The workflow MUST run `scripts/validate.sh` and fail
  immediately (before packaging or publishing) if it does not pass.
- **FR-005**: A new `scripts/package-release.sh` MUST build a single
  universal artifact (`spec-jedi-<version>.tar.gz`) containing every
  `.claude/skills/specjedi-*/` directory, the four
  `.specify/templates/*.md` files, `scripts/install.sh`,
  `scripts/install.ps1`, and `LICENSE` — nothing else. This script MUST
  be runnable both from the workflow and locally by the maintainer for
  manual inspection.
- **FR-006**: The workflow MUST fail if `CHANGELOG.md`'s `## Unreleased`
  → `### Added` (or equivalent) section is empty at release time.
- **FR-007**: When `dry_run: true` (the default), the workflow MUST
  perform every validation and packaging step, upload the built artifact
  as a workflow run artifact for inspection, and report the changelog
  section it would have written — but MUST NOT create a git tag, MUST
  NOT create a GitHub Release, and MUST NOT commit anything to `main`.
- **FR-008**: When `dry_run: false`, after all validations pass, the
  workflow MUST: create and push a `vX.Y.Z` git tag; create a GitHub
  Release for that tag with the packaged artifact attached; rewrite
  `CHANGELOG.md` so the current `## Unreleased` content moves under a new
  `## [vX.Y.Z] - YYYY-MM-DD` heading (with a fresh empty `## Unreleased`
  left above it); and commit that `CHANGELOG.md` change to `main`.
- **FR-009**: The packaged artifact's contents MUST be installable via
  the existing `scripts/install.sh`/`.ps1` (any currently-supported
  `--harness` value) with identical results to running those scripts
  from a full repository clone.

### Key Entities

- **Release Artifact**: the versioned, downloadable `.tar.gz` package —
  one per released version, containing exactly the subset of repository
  files `scripts/install.sh` already knows how to install from.
- **Release Run**: one `workflow_dispatch` invocation, characterized by
  its `version` and `dry_run` inputs — a dry run has zero durable side
  effects; a real run produces exactly one tag, one GitHub Release, and
  one `CHANGELOG.md` commit.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A maintainer can rehearse the entire release mechanism
  (`dry_run: true`) with zero risk of an accidental publish, tag, or
  commit.
- **SC-002**: A maintainer can cut a real release in one deliberate
  action (`dry_run: false`), producing a tag, a GitHub Release, and an
  updated `CHANGELOG.md`, with no manual packaging or file-copying steps.
- **SC-003**: The very first real release cut under this mechanism
  (`v0.1.0`) succeeds on its first real (non-dry-run) attempt, having
  already been rehearsed via `dry_run: true` beforehand.
- **SC-004**: The downloadable artifact installs identically to a full
  repository clone, for every currently-supported harness.

## Assumptions

- This feature builds the release mechanism only — it does NOT itself
  cut the real `v0.1.0` release. Actually triggering `dry_run: false`
  for the first time is a deliberate, separate maintainer action, per
  Constitution Principle XI ("cutting a release is always a deliberate,
  maintainer-driven step") — this feature's own CI proof is a dry run,
  honestly scoped the same way prior harness-support features scoped
  their own structural-not-live verification.
- This feature is explicitly Sub-Project A of a 3-part decomposition
  identified during brainstorming (release packaging → standalone
  bootstrap installer script → harness auto-detection). Sub-Projects B
  and C are out of scope here and are tracked separately (see
  `references/skill-roadmap.md` or an equivalent backlog entry) rather
  than fully specified in this cycle, to keep this feature's scope
  proportionate and shippable on its own.
- `gh release create`'s own default behavior (asset upload, release
  notes body) is used directly rather than reimplemented — the workflow
  supplies the changelog section as the release body via `--notes`.
