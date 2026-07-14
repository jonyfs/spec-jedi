# Implementation Plan: Mention specjedi-* Skills in Each Harness's Memory File

**Branch**: `039-memory-file-skill-mentions` | **Date**: 2026-07-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/039-memory-file-skill-mentions/spec.md`

## Summary

`install.sh`/`.ps1` already generate a skill-listing bridge file for the
14 "bridge" harnesses (`bridge_mode` in `install.sh`,
`$bridgeMode` in `install.ps1`) but never touch `claude-code`/
`codex-cli`/`trae`'s own separate project-memory-file convention
(`CLAUDE.md`, `AGENTS.md`, `.trae/rules/project_rules.md`). This feature
adds a second, independent code path — parallel to `bridge_mode`, not a
modification of it — that creates or idempotently updates a
marker-delimited section in that memory file when one of those three
harnesses is selected, reusing the existing `skill_meta`/`Get-SkillMeta`
helpers so the section always reflects what actually landed on disk.
`antigravity` and the 14 bridge harnesses are explicitly untouched by
this new path (FR-006/FR-007).

## Technical Context

**Language/Version**: Bash (`set -euo pipefail`, matching `install.sh`'s
existing style) and PowerShell Core (`$ErrorActionPreference = 'Stop'`,
matching `install.ps1`'s existing style) — no new language.

**Primary Dependencies**: `awk` for the bash marker-region replace (POSIX
standard, already implicitly available everywhere `install.sh` itself
runs); .NET regex (`[regex]::Match`/`-replace`) for the PowerShell
equivalent, matching `Get-SkillMeta`'s own existing regex-based
frontmatter parsing.

**Storage**: N/A — target-project files (`CLAUDE.md`/`AGENTS.md`/
`.trae/rules/project_rules.md`) are the only persistent state this
feature reads/writes, same class of operation as the existing bridge-file
writes.

**Testing**: `.github/workflows/validate.yml`, new
`memory-file-injection` job — matches `install-test`'s existing
`runs-on: ${{ matrix.os }}` / `os: [ubuntu-latest, macos-latest, windows-latest]`
matrix pattern, builds real scratch directories and inspects real file
contents (Principle IX), never asserted in docs alone.

**Target Platform**: Linux, macOS, Windows — `install.sh` and `.ps1` both
gain the identical new logic; FR-008/SC-004 require a CI diff proving
identical output for the same input.

**Project Type**: Existing installer CLI script, extended in place — no
new project structure.

**Constraints**: FR-002/FR-005 require the marker-based replace to never
touch a single byte outside the markers, and to fail loudly (never guess)
if the markers are malformed — this is the one place in this feature
where a bug has real, hard-to-reverse consequences (a target project's
own `CLAUDE.md`/`AGENTS.md` content, which the installer doesn't own).
Every marker-handling code path MUST be covered by the CI job before this
feature is considered done, not spot-checked manually.

**Scale/Scope**: Two files change (`scripts/install.sh`,
`scripts/install.ps1`), one new CI job added — no changes to
`package-release.sh`/`.ps1` or `bootstrap-install.sh`/`.ps1` (this
feature's output only exists in a *target* project the installer runs
against, not in the release package itself).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| VI (Test-First Where Code Exists) | New `memory-file-injection` CI job (FR-009) is planned before the marker-injection logic it validates — matches this project's own established "CI proves it, docs don't" precedent (e.g. specs/038's own test-first CI job ordering). | ✅ Pass — planned in Project Structure below |
| IX (Mandatory Skill Validation & Testing) | All four Acceptance Scenarios of User Story 1 (create, preserve, idempotent, update-on-change) get real CI coverage, not asserted in docs — same discipline `bootstrap-installer-smoke`/`package-content-completeness` already established this session. | ✅ Pass — planned in Project Structure below |
| XIII (Cross-Platform Support) | `install.sh` and `.ps1` both gain identical marker logic; CI diffs their output for the same scratch input. | ✅ Pass — planned in Project Structure below |
| XVIII (Zero-Footprint Installer with Harness Selection) | This feature extends the installer's own harness-selected behavior directly — core to this principle, not a side effect of it. New memory-file writes are scoped to the 3 harnesses with a confirmed convention (FR-004), never applied blanket. | ✅ Pass |
| XX (AI Discipline: Grounded, Honest Output) | FR-006 explicitly forbids inventing a memory-file convention for `antigravity` (none confirmed in `references/harness-capability-notes.md`) — the installer's own `echo`/`Write-Host` output for that harness makes no claim about a memory file. | ✅ Pass — confirmed via spec.md User Story 3 |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/039-memory-file-skill-mentions/
├── plan.md              # This file
├── tasks.md             # Phase 2 output (specjedi-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — the one "entity" (the
marker-delimited section) is already fully specified in spec.md's Key
Entities and this plan's Implementation notes below; a separate
`quickstart.md` would duplicate spec.md's own Acceptance Scenarios.

### Source Code (repository root)

```text
scripts/
├── install.sh          # MODIFIED: new memory_section()/update_memory_file()
│                        #   functions, new harness->memory_file_rel dispatch
├── install.ps1          # MODIFIED: identical additions, PowerShell idiom

.github/workflows/
└── validate.yml         # MODIFIED: new memory-file-injection CI job
                          #   (3-OS matrix), wired into ci-gate's needs:
```

### Implementation notes for `specjedi-tasks`/`specjedi-implement`

**Marker format** (both scripts, identical strings):
`<!-- SPEC-JEDI:SKILLS:START -->` / `<!-- SPEC-JEDI:SKILLS:END -->` —
matches the existing bridge-file convention's "Managed by Spec Jedi's
installer" HTML-comment style, adapted to a start/end pair since this
feature edits *part* of a file it doesn't fully own (spec.md's own
Assumptions section already settled this).

**`install.sh`** (insert after the existing `skill_meta()` function,
around line 420, and after the existing `bridge_mode` block around line
514):

```bash
memory_section() {
  # $1 = skills_dst_rel (e.g. ".claude/skills"), for the "installed at"
  # sentence. Reads skill metadata from $skills_dst (already populated
  # by the copy loop above skill_meta is already used in).
  local skills_dst_rel="$1"
  echo "<!-- SPEC-JEDI:SKILLS:START -->"
  echo "## Spec Jedi skills available in this project"
  echo
  echo "This project has the Spec Jedi spec-driven-development skill set"
  echo "installed at \`$skills_dst_rel/\`. When a request matches one of"
  echo "the skills below, open and follow the full instructions in its"
  echo "\`SKILL.md\` before responding. New to Spec Jedi? Start with"
  echo "\`specjedi-onboard\`."
  echo
  echo "| Skill | What it does |"
  echo "|---|---|"
  for f in "$skills_dst"/specjedi-*/SKILL.md; do
    IFS=$'\t' read -r name desc < <(skill_meta "$f")
    echo "| \`$name\` | $desc |"
  done
  echo "<!-- SPEC-JEDI:SKILLS:END -->"
}

update_memory_file() {
  # $1 = absolute path to the memory file, $2 = skills_dst_rel.
  local memory_path="$1" skills_dst_rel="$2"
  local start_marker="<!-- SPEC-JEDI:SKILLS:START -->"
  local end_marker="<!-- SPEC-JEDI:SKILLS:END -->"
  local new_section
  new_section="$(memory_section "$skills_dst_rel")"

  mkdir -p "$(dirname "$memory_path")"

  if [ ! -f "$memory_path" ]; then
    printf '%s\n' "$new_section" > "$memory_path"
    echo "  ✅ $(basename "$memory_path") created"
    return
  fi

  local content
  content="$(cat "$memory_path")"

  local has_start=0 has_end=0
  case "$content" in *"$start_marker"*) has_start=1 ;; esac
  case "$content" in *"$end_marker"*) has_end=1 ;; esac

  if [ "$has_start" -ne "$has_end" ]; then
    echo "FAIL: $memory_path has a Spec Jedi marker without its matching pair -- refusing to guess where the managed section ends. Remove the stray marker manually and re-run."
    exit 1
  fi

  if [ "$has_start" -eq 1 ]; then
    # Whole-content substring slicing, not a line-by-line rewrite: %%
    # removes the longest suffix starting at the FIRST occurrence of
    # start_marker (everything before it, untouched); ## removes the
    # longest prefix ending at the LAST occurrence of end_marker
    # (leaving everything after it, untouched). This is what makes it
    # CRLF-safe by construction -- there's no per-line $0-style
    # comparison to be defeated by a trailing \r (a line-by-line awk
    # rewrite was tried first and rejected: it silently failed to
    # recognize CRLF-terminated marker lines, no-opping the update with
    # no error -- caught by specjedi-analyze against an earlier version
    # of this plan). Bytes outside the markers -- CRLF or not -- are
    # never touched, only sliced around.
    local before after
    before="${content%%"$start_marker"*}"
    after="${content##*"$end_marker"}"
    printf '%s%s%s\n' "$before" "$new_section" "$after" > "$memory_path"
    echo "  ✅ $(basename "$memory_path") updated (existing Spec Jedi section refreshed)"
  else
    printf '\n%s\n' "$new_section" >> "$memory_path"
    echo "  ✅ $(basename "$memory_path") updated (Spec Jedi section appended)"
  fi
}

memory_file_rel=""
case "$harness" in
  claude-code) memory_file_rel="CLAUDE.md" ;;
  codex-cli) memory_file_rel="AGENTS.md" ;;
  trae) memory_file_rel=".trae/rules/project_rules.md" ;;
esac
if [ -n "$memory_file_rel" ]; then
  echo
  echo "🧠 Updating $memory_file_rel with the installed skill set..."
  update_memory_file "$target_dir/$memory_file_rel" "$skills_dst_rel"
fi
```

Place the `memory_file_rel`/`update_memory_file` call block *after* the
existing `bridge_mode` block (both are independent, sequential — a
target harness is either bridge-mode or memory-file-mode per the `case`
in the harness dispatch, never both, but keeping them as separate `if`
blocks rather than merging into the `case` avoids restructuring code
that already works).

**`install.ps1`**: identical logic via `Get-SkillMeta` (already exists),
a new `Get-MemorySection` function returning a joined multi-line string
(`[string]::Join("`n", $lines)`, matching `Get-SkillMeta`'s own
`[PSCustomObject]` return-value idiom), and `Update-MemoryFile` mirroring
`install.sh`'s whole-content substring-slice approach exactly (not a
line-array splice — `.Contains()`/`.IndexOf()`/`.Substring()` on the raw
file text, the same CRLF-safe design `install.sh` uses and for the same
reason: no per-line comparison exists to be defeated by a trailing `\r`):

```powershell
function Update-MemoryFile {
    param([string]$MemoryPath, [string]$SkillsDstRel)
    $startMarker = "<!-- SPEC-JEDI:SKILLS:START -->"
    $endMarker = "<!-- SPEC-JEDI:SKILLS:END -->"
    $newSection = Get-MemorySection -SkillsDstRel $SkillsDstRel

    $parentDir = Split-Path -Parent $MemoryPath
    if ($parentDir -and -not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }

    if (-not (Test-Path $MemoryPath)) {
        [System.IO.File]::WriteAllText($MemoryPath, "$newSection`n")
        Write-Host "  ✅ $(Split-Path -Leaf $MemoryPath) created"
        return
    }

    $rawContent = [System.IO.File]::ReadAllText($MemoryPath)
    $hasStart = $rawContent.Contains($startMarker)
    $hasEnd = $rawContent.Contains($endMarker)

    if ($hasStart -ne $hasEnd) {
        Write-Host "FAIL: $MemoryPath has a Spec Jedi marker without its matching pair -- refusing to guess where the managed section ends. Remove the stray marker manually and re-run."
        exit 1
    }

    if ($hasStart) {
        # Drop exactly one trailing newline (LF or CRLF) before slicing,
        # mirroring bash's $(cat file) command-substitution semantics --
        # both scripts always re-add exactly one trailing newline at the
        # very end, which is what keeps their output byte-identical
        # (FR-008) regardless of the target file's original line-ending
        # style.
        $content = $rawContent -replace '(\r?\n)$', ''
        $startIdx = $content.IndexOf($startMarker)
        $endIdx = $content.LastIndexOf($endMarker) + $endMarker.Length
        $before = $content.Substring(0, $startIdx)
        $after = $content.Substring($endIdx)
        [System.IO.File]::WriteAllText($MemoryPath, "$before$newSection$after`n")
        Write-Host "  ✅ $(Split-Path -Leaf $MemoryPath) updated (existing Spec Jedi section refreshed)"
    } else {
        # Raw append onto the file's existing bytes exactly as they are
        # -- no rewrite of pre-existing content -- matching install.sh's
        # own `printf '\n%s\n' "$new_section" >> file` append semantics.
        [System.IO.File]::AppendAllText($MemoryPath, "`n$newSection`n")
        Write-Host "  ✅ $(Split-Path -Leaf $MemoryPath) updated (Spec Jedi section appended)"
    }
}
```

`[System.IO.File]` methods perform no newline translation (unlike
`Set-Content`/`Out-File`, which apply the platform's default newline —
CRLF on Windows — to every line they write, which would have silently
converted an existing LF-only file's non-marker content to CRLF: a real
violation of "preserve every byte outside the section," and a fresh
FR-008 mismatch against `install.sh`'s output for the same input). Same
`switch` dispatch for `$memoryFileRel` (`claude-code`→`CLAUDE.md`,
`codex-cli`→`AGENTS.md`, `trae`→`.trae/rules/project_rules.md`), same
"not for antigravity or bridge harnesses" scoping.

**CI job** (`memory-file-injection`, 3-OS matrix, both `shell: bash` and
`shell: pwsh` steps mirroring `install-test`'s existing pattern):

1. Fresh scratch dir, `install.sh --harness claude-code`; assert
   `CLAUDE.md` exists and contains both markers and every currently
   installed skill's name (User Story 1, AS1).
2. A *second* scratch dir: write a `CLAUDE.md` with known dummy content
   first (`printf '# My Project\n\nRun tests with pytest.' > CLAUDE.md`),
   capture that exact pre-install content, then install; assert (a) the
   post-install file, with the region between the markers (inclusive)
   removed, is byte-identical to the captured pre-install content — a
   real diff of the non-marker region, not just a substring presence
   check, per SC-002's own "diff the pre-existing content" wording — and
   (b) the markers/skill table are present (User Story 1, AS2).
3. Re-run the installer against scratch dir #1 with `sha256sum`/
   `Get-FileHash` before and after; assert identical (User Story 1, AS3).
4. A *third* scratch dir: write a `CLAUDE.md` using CRLF line endings
   throughout (including around a pre-existing Spec Jedi section planted
   by the test itself, not by the installer) via `printf '...\r\n...'`;
   install; assert (a) the update actually refreshes the section (not a
   silent no-op — the specific failure mode `specjedi-analyze` found in
   this feature's first plan revision) and (b) every CRLF byte outside
   the markers is still present, verified the same real-diff way as
   step 2.
5. A *fourth* scratch dir: write a `CLAUDE.md` containing only a start
   marker with no matching end marker; run the installer; assert it
   exits non-zero, prints a message naming the file, and leaves the file
   completely unmodified (FR-005, Edge Case #1 — the plan's own
   `has_start -ne has_end` branch, otherwise unexercised by any other
   step above).
6. `--harness codex-cli` into a fresh scratch dir; assert `AGENTS.md`
   exists with the markers, mentioning `.agents/skills/` (not
   `.claude/skills/`) in its "installed at" sentence — proves
   `skills_dst_rel` is actually parameterized, not hardcoded (User
   Story 2, AS1).
7. `--harness trae` into a fresh scratch dir; assert
   `.trae/rules/project_rules.md` exists with the markers (User Story 2,
   AS3).
8. `--harness antigravity` into a fresh scratch dir; assert no file
   named `CLAUDE.md`/`AGENTS.md`/anything under `.trae/rules/` was
   created — only `.agents/skills/` (User Story 3, AS1).
9. `--harness cursor` into a fresh scratch dir; assert `.cursor/rules/`
   file count equals the installed skill count (the existing bridge-file
   behavior, unchanged — User Story 3, AS2).
10. Repeat steps 1-5 for the PowerShell leg (`install.ps1`), then diff
    `install.sh`'s and `.ps1`'s `CLAUDE.md` output for the same scratch
    input (FR-008/SC-004) — already spot-verified by hand during this
    plan's own revision (bash and PowerShell produced byte-identical
    output against both a plain and a CRLF fixture), but that manual
    check doesn't substitute for real CI coverage per this plan's own
    Constraints section.

Add `memory-file-injection` to `ci-gate`'s `needs:` list in
`.github/workflows/validate.yml`, matching how every other required job
is already listed there (same pattern as feature 038's
`package-content-completeness` addition).
