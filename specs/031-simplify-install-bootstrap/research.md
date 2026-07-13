# Research: Simplify README Installation to Bootstrap-Only

**Goal**: resolve the one real technical unknown blocking a correct
Phase 1 design — how to show a PowerShell one-liner that both (a) needs
no prior `git clone`/download step (FR-001) and (b) actually forwards
`-TargetDir`/`-Harness`/`-Auto` the way the bash example already does
(FR-002/FR-003), since `bootstrap-install.ps1` takes real named
parameters (`param(...)`, confirmed by reading the script directly:
`scripts/bootstrap-install.ps1` lines 18-24).

## Decision: `&([scriptblock]::Create((iwr ...).Content)) -TargetDir ... -Harness ...`

**Decision**: The PowerShell command block in the simplified Installation
section uses the "download content, compile to scriptblock, invoke with
args" idiom:

```powershell
&([scriptblock]::Create((iwr -useb https://raw.githubusercontent.com/jonyfs/spec-jedi/main/scripts/bootstrap-install.ps1).Content)) -TargetDir C:\path\to\your-project -Harness cursor
```

**Rationale**: Today's README (and the comment header inside
`bootstrap-install.ps1` itself) shows the simple pipe form:

```powershell
iwr -useb <url> | iex
```

That form works for a script with no parameters, but `iex` (an alias for
`Invoke-Expression`) evaluates piped text as a script block with **no
mechanism to pass arguments into it** — there is no `iex -Args` or
equivalent. `bootstrap-install.ps1` takes real named parameters
(`-TargetDir`, `-Harness`, `-Auto`, `-Version`), and FR-002/FR-003
require the simplified section to actually demonstrate passing
`--harness`/`--auto`, matching what the bash example already does via
`bash -s -- /path/to/your-project --harness cursor`. The
`&([scriptblock]::Create(...))` form is the standard, documented
PowerShell idiom for exactly this case — download-then-invoke-with-
parameters — and is the same pattern widely used by other installers
distributing a parameterized bootstrap script over HTTP (e.g., Chocolatey's
own install docs use the equivalent `iex ((New-Object
System.Net.WebClient).DownloadString(...))` predecessor of this pattern).
No third-party tool or module is introduced — this is native PowerShell
syntax available in every version this project already targets (PowerShell
7+, per Prerequisites).

**Alternatives considered**:
- *Keep the bare `iwr -useb <url> | iex` form, omit harness/target
  arguments from the PowerShell example* — rejected: violates FR-002/
  FR-003 (parity with the bash example, which does show arguments) and
  would leave Windows readers with a working command for the default
  case only, silently worse coverage than the bash side of the same
  section.
- *Direct users to download-then-run-locally instead of a true one-liner
  (`iwr -useb <url> -OutFile bootstrap-install.ps1; .\bootstrap-install.ps1
  -TargetDir ... -Harness ...`)* — rejected: reintroduces a two-step flow
  (download, then invoke) that this feature is specifically trying to
  collapse to one command, and the `&([scriptblock]::Create(...))` form
  already achieves a genuine one-liner without that regression.

## Confirmed: no other file references the subsections being removed

Grepped `README.md` and `CONTRIBUTING.md` for anchors pointing at the
"Claude Code (fully supported today)" subsection or its clone-based
walkthrough specifically. Only two references exist to `#installation`
itself (the section heading, which is not being removed — line 17's
badge and line 458's Quickstart step 1 pointer) — both remain valid
since only subsections underneath the heading change, not the heading
anchor itself. No dangling-link risk found.

## Confirmed: no code/script changes needed

Re-read `scripts/bootstrap-install.sh` and `scripts/bootstrap-install.ps1`
in full (this session). Both already implement everything FR-001–FR-004
depend on: fetch-latest-or-tagged-release, extract, forward
`TARGET_DIR`/`--harness`/`--auto` (or `-TargetDir`/`-Harness`/`-Auto`)
to the bundled `install.sh`/`.ps1`, and print an honest, actionable
message with a `git clone` fallback when no release exists. This
feature's implementation is therefore prose-only — no task in Phase 2
touches either script.
