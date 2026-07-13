# Implementation Plan: Standalone Bootstrap Installer

## Constitution Check

- Principle II: satisfied — see `research.md`.
- Principle VI (test-first): installer-script work, same exemption class
  as feature 023 (no meaningful code-level red/green cycle); verified
  instead via real execution against the live GitHub API (genuine 404
  path) and a locally-packaged release artifact (full download-simulated
  → extract → install.sh/.ps1 path). Stated explicitly per the CHK007
  precedent.
- Principle IX (validation): CI job runs `--help` and the real (currently
  404) API path for both scripts, asserting a clean non-crashing exit
  rather than a stack trace — the one thing genuinely testable in CI
  without a real release exising yet.
- Principle XI (semantic-versioned releases): this feature does not cut
  any release itself; `--version`/`-Version` only *selects* an
  already-published one.
- Principle XIII (cross-platform): `.sh` + `.ps1`, both tested against
  real interpreters.
- Principle XX (grounded, honest output): the known-limitation section in
  `spec.md` and the corresponding note in `references/skill-roadmap.md`
  exist specifically so this feature isn't miscategorized as more
  thoroughly verified than it actually is.

## Technical approach

Two new scripts, `scripts/bootstrap-install.sh` and `.ps1`, each:

1. Resolve a release: GitHub Releases API `/releases/latest` or
   `/releases/tags/<version>`.
2. Extract `tag_name` and the `spec-jedi-*.tar.gz` asset's download URL
   from the JSON response (grep/sed in bash; native `Invoke-RestMethod`
   object properties in PowerShell — no `jq` dependency either way).
3. On a missing/failed response, print the Principle-XI-aware explanation
   and the git-clone fallback command, exit 1.
4. Download the asset into a `mktemp -d` (bash) / `New-Item` temp
   directory (PowerShell), extract with `tar -xzf`, locate the
   `spec-jedi-*` top-level directory, and hand off to its bundled
   `install.sh`/`.ps1`, forwarding `TARGET_DIR`/`--harness`/`--auto`
   unchanged.
5. Clean up the temp directory via `trap`/`finally` regardless of
   success or failure.

## Files touched

- `scripts/bootstrap-install.sh`, `scripts/bootstrap-install.ps1` — new.
- `references/skill-roadmap.md` — Sub-Project B moved from "Proposed" to
  "Shipped," with the known-limitation caveat stated inline.
- `README.md` — quickstart gains the one-liner alongside the existing
  clone-first path (see Installation section).
- `.github/workflows/validate.yml` — `bootstrap-installer-smoke` job
  (bash matrix + native pwsh) asserting `--help` works and the real
  no-release path exits cleanly with the expected message, on all three
  OSes.
- `.specify/memory/constitution.md` — same PATCH amendment as feature
  023 (bundled together; both are part of the same user-requested
  installer-completion request).

## Testing strategy

- `--help`/`-Help` output verified manually (both scripts).
- Live test against the real, current `jonyfs/spec-jedi` GitHub API (no
  releases published) — confirmed clean, informative exit 1 for both
  `bootstrap-install.sh` and `bootstrap-install.ps1`.
- Full mechanics test: built a real release artifact locally via
  `scripts/package-release.sh v0.1.0-test /tmp/...`, then manually
  exercised the extract → locate → `install.sh`/`.ps1` handoff portion of
  each bootstrap script against that artifact (bypassing only the actual
  network download call, which is standard `curl`/`Invoke-WebRequest`
  usage and the lowest-risk part of the script) — confirmed skills and a
  representative bridge harness (`cursor`/`tabnine`) both installed
  correctly through the full simulated chain.
- CI: `bootstrap-installer-smoke` exercises the real (currently-404)
  network path directly (this is the one piece safely testable against
  production as-is), plus `--help`.
