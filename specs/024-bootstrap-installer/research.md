# Research: Standalone Bootstrap Installer (feature 024)

**Goal**: build Sub-Project B from feature 020's 3-part decomposition — a
`curl | bash` / `iwr | iex`-style one-liner that installs Spec Jedi
without requiring a prior `git clone`.

## Principle II: competitive research before creation

This pattern (fetch-latest-release-and-run-bundled-installer) is the
same shape Homebrew, rustup, and SDKMAN already use — explicitly named as
the target UX in `references/skill-roadmap.md` since feature 020's
brainstorming session. No researched SDD competitor
(`specs/001-specjedi-pipeline/research.md`'s field) ships a bootstrap
installer at all, since none of them package a downloadable versioned
release artifact the way feature 020 does — this is Spec Jedi-specific
plumbing sitting on top of feature 020's own genuine contribution
(spec-kit and the other ten researched tools are all git-clone-first
installs), not a reskin of an existing mechanism.

## Dependency on feature 020

Feature 020 (`scripts/package-release.sh`, `.github/workflows/release.yml`)
defines the exact artifact contract this feature depends on:
- A GitHub Release tagged `vMAJOR.MINOR.PATCH`.
- One release asset: `spec-jedi-<version>.tar.gz`, containing a single
  top-level directory `spec-jedi-<version>/` with `.claude/skills/
  specjedi-*/`, `.specify/templates/*.md`, `scripts/install.sh`,
  `scripts/install.ps1`, and `LICENSE`.
- Published via `gh release create "$version" spec-jedi-$version.tar.gz
  --title ... --notes-file ... --target main` (confirmed by reading
  `.github/workflows/release.yml` directly, not assumed).

As of this feature's authorship, this project's own first release
(`v0.1.0`) has not been cut (`git tag -l` returns empty) — Principle XI
states cutting a release is always a deliberate, maintainer-driven step,
never automatic. This is a genuine, current constraint, not a
hypothetical: it means the live end-to-end download path (real GitHub
Release → real `curl`/`Invoke-WebRequest` download → real extraction) is
untested against production infrastructure as of this feature shipping,
and both `references/skill-roadmap.md` and this feature's `plan.md` say
so plainly rather than claiming full verification.

## Design decisions

- **No `jq` / no PowerShell-module dependency**: the bash script parses
  the GitHub Releases API JSON response with `grep`/`sed` only (matching
  `install.sh`'s own zero-extra-dependency posture); the PowerShell
  script uses `Invoke-RestMethod`'s built-in JSON parsing (no extra
  module needed, ships with PowerShell 5.1+/7+).
- **`--version`/`-Version` flag**: lets a user pin a specific tagged
  release instead of always fetching latest — useful once multiple
  releases exist; defaults to GitHub's `/releases/latest` endpoint.
- **Honest failure path**: when the GitHub API returns 404 (no releases,
  or a nonexistent `--version`), the script prints a clear explanation
  referencing Principle XI (deliberate releases) and offers the
  git-clone fallback — never a raw curl/API stack trace.
- **Forwarding, not reimplementing**: `--harness`/`--auto` are passed
  through to the downloaded `install.sh`/`.ps1` unchanged; this script
  owns only "get the release onto disk," not any install logic itself —
  avoids duplicating (and risking drift from) `install.sh`'s own harness
  table.
