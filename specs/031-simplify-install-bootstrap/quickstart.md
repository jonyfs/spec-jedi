# Quickstart: Simplify README Installation to Bootstrap-Only

Validation scenarios proving the simplified Installation section works
end-to-end. All scenarios run against the actual `README.md` after
implementation — no separate test fixture.

## Prerequisites

- A checkout of this repository on the feature branch, `README.md`
  already edited per `tasks.md`.
- `bash` (Linux/macOS/WSL/Git Bash) and, if verifying the PowerShell
  path, `pwsh` 7+.
- No GitHub Release published yet is the expected, current state
  (Scenario 3 below covers this explicitly, not as an error case).

## Scenario 1 — Bash one-liner is copy-pasteable and correct

```bash
grep -A5 '^## Installation' README.md | grep 'curl -fsSL'
```

**Expected**: exactly one `curl -fsSL .../bootstrap-install.sh | bash -s
-- ...` line appears, forwarding a target directory and `--harness`,
matching `scripts/bootstrap-install.sh`'s actual documented `--help`
output (`./scripts/bootstrap-install.sh --help`).

## Scenario 2 — PowerShell one-liner forwards `-Harness`/`-TargetDir`

```bash
grep -A5 '^## Installation' README.md | grep 'scriptblock'
```

**Expected**: the `&([scriptblock]::Create((iwr ...).Content)) -TargetDir
... -Harness ...` form from `research.md` appears — not the bare `iwr
... | iex` form, which cannot forward parameters.

## Scenario 3 — No `git clone` anywhere in the section

```bash
awk '/^## Installation/,/^## [A-Z]/' README.md | grep -c 'git clone'
```

**Expected**: `0` (SC-002). Note: this intentionally scopes the check to
the `## Installation` section only — other sections (e.g., `CONTRIBUTING`
pointers elsewhere in the README) are out of this feature's scope per
`spec.md`'s Edge Cases.

## Scenario 4 — Honest failure path still works (no script changes needed)

```bash
./scripts/bootstrap-install.sh --help
```

**Expected**: usage text prints; running it for real against this
repository's actual (currently empty) release list produces the
existing "no release found" message with the `git clone` fallback
command — confirming User Story 2's acceptance scenario without any
code change, since `scripts/bootstrap-install.sh` itself is untouched
by this feature.

## Scenario 5 — No structural regressions

```bash
./scripts/validate.sh
```

**Expected**: `PASSED`, with no new WARN/FAIL lines attributable to this
change (SC-004) — confirms no dangling anchor links and no localized-
docs sync regression introduced by the edit.

## Scenario 6 — Section reads as minimal format, not diagram-plus-steps

Manual read-through: confirm `## Installation` contains no `` ```mermaid ``
code fence and no numbered list (`1.`, `2.`, ...) describing the install
flow — only prose plus the two command blocks (Scenarios 1-2), per
`/speckit-clarify`'s Session 2026-07-13 decision (SC-001, SC-003).
