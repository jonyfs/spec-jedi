# Feature Specification: Standalone Bootstrap Installer

**Status**: Complete (2026-07-13) — with one honestly-stated limitation
(see below).

## Problem

`scripts/install.sh`/`.ps1` require a prior `git clone` of the Spec Jedi
repository, since they read skill packages from a local checkout
(`repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"`). This is
friction for the common "just try it" case every Homebrew/rustup/SDKMAN-
style tool avoids.

## User Story (P1) — Install without cloning

As a developer who wants to try Spec Jedi, I want to run one `curl | bash`
(or `iwr | iex`) command in my project directory and have it install,
without first cloning the full repository.

**Acceptance criteria**:
- AC1: `scripts/bootstrap-install.sh`/`.ps1` fetch the latest published
  GitHub Release by default, or a specific one via `--version`/`-Version`.
- AC2: The release's `spec-jedi-<version>.tar.gz` asset is downloaded and
  extracted to a temp directory that's cleaned up afterward (success or
  failure).
- AC3: The extracted `scripts/install.sh`/`.ps1` runs against the
  caller's target directory, with `--harness`/`--auto` forwarded
  unchanged.
- AC4: If no release exists (or the requested `--version` doesn't exist),
  the script exits non-zero with a clear, honest explanation — never a
  raw API/curl error.

## Known limitation (stated explicitly, not hidden)

This project's own first release (`v0.1.0`) has not been cut as of this
feature shipping. AC1-AC3's live network path (real API call → real
download → real extraction) is therefore verified only against a
**locally-built** release artifact (via `scripts/package-release.sh`),
not a real published GitHub Release — the mechanics are proven, but true
end-to-end production verification is pending the first real release
cut. AC4 *is* verified against production: this repo's real, current
(empty) release list returns a genuine 404, and the script's handling of
that real response was tested directly.

## Out of scope

- Cutting `v0.1.0` itself (a separate, deliberate maintainer action per
  Principle XI — not something this feature performs).
- A package-manager-native install (Homebrew formula, npm package, etc.)
  — out of scope per `references/skill-roadmap.md`'s existing "Not
  proposed (deliberately)" stance against dependencies beyond what's
  strictly needed.

## Non-functional requirements

- Zero extra runtime dependency beyond `curl`/`tar` (bash) or
  `Invoke-RestMethod`/`tar` (PowerShell 5.1+, which ships `tar` natively
  on Windows 10 1803+) — no `jq`, no PowerShell module install required.
- Cross-platform (Principle XIII): `.sh` and `.ps1` counterparts, both
  tested against real interpreters (bash, `pwsh` 7.6.3) locally.
