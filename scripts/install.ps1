#!/usr/bin/env pwsh
# Spec Jedi zero-footprint installer (Constitution Principle XVIII).
# Native PowerShell counterpart of install.sh (Constitution Principle XIII —
# every .sh ships with an equivalent .ps1). Copies the specjedi-* product
# skills (never speckit-* bootstrap tooling) into a target project, plus the
# .specify/templates/*.md files those skills depend on at runtime.
#
# Two install modes, chosen per -Harness (Principle III's 20-harness
# compatibility matrix, specs/023-full-harness-coverage/research.md):
#   1. skills-dir: the harness natively scans a directory of SKILL.md
#      packages (claude-code, codex-cli, trae, antigravity).
#   2. bridge: the harness only reads a project-root rules file, a small
#      directory of rule files, or (Cody) a custom-commands JSON file. The
#      full specjedi-* packages are still copied to .claude/skills/ as the
#      canonical source; a generated bridge file / set of files points
#      into it so the harness's own native mechanism can find them.

param(
    [string]$TargetDir = ".",
    [string]$Harness = "",
    [switch]$Auto,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help) {
    Write-Host "Usage: install.ps1 [-TargetDir DIR] [-Harness HARNESS] [-Auto]"
    Write-Host ""
    Write-Host "  -TargetDir   Project to install Spec Jedi's specjedi-* skills into."
    Write-Host "               Defaults to the current directory."
    Write-Host "  -Harness     Which coding agent to configure for. All 20 harnesses in"
    Write-Host "               Constitution Principle III's compatibility matrix are"
    Write-Host "               supported: claude-code, codex-cli, trae, antigravity"
    Write-Host "               (native skills-directory scanning); cursor, windsurf,"
    Write-Host "               copilot, gemini-cli, cline, continue, aider, amazon-q,"
    Write-Host "               jetbrains-ai, zed, replit, devin, tabnine, cody (bridge"
    Write-Host "               file(s) pointing at the canonical .claude/skills/ package)."
    Write-Host "               If omitted, the installer attempts harness auto-detection"
    Write-Host "               among claude-code/codex-cli/trae (specs/021-harness-auto-detection);"
    Write-Host "               the 17 other harnesses require an explicit -Harness."
    Write-Host "  -Auto        When -Harness is omitted and detection finds more than"
    Write-Host "               one plausible harness, automatically select the"
    Write-Host "               Recommended one instead of prompting interactively"
    Write-Host "               (Constitution Principle IV's Recommended-option standard)."
    exit 0
}

$repoRoot = Split-Path -Parent $PSScriptRoot

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
$TargetDir = (Resolve-Path $TargetDir).Path

# Harness auto-detection (specs/021-harness-auto-detection): only runs
# when -Harness was omitted. Scoped to the three harnesses with a real
# filesystem/PATH signal; the 17 bridge-file harnesses added in
# specs/023-full-harness-coverage always require an explicit -Harness.
# Global-config checks below use $HOME (PowerShell's cross-platform
# automatic variable, resolving on Linux/macOS too) rather than
# $env:USERPROFILE, which is Windows-only and null elsewhere.
if (-not $Harness) {
    $signals = @()

    if (Test-Path (Join-Path $TargetDir ".claude")) {
        $signals += "claude-code:1:target directory ($TargetDir\.claude)"
    }
    if (Get-Command claude -ErrorAction SilentlyContinue) {
        $signals += "claude-code:2:PATH binary (claude)"
    }
    if (Test-Path (Join-Path $HOME ".claude")) {
        $signals += "claude-code:3:global config (~\.claude)"
    }

    if (Test-Path (Join-Path $TargetDir ".agents")) {
        $signals += "codex-cli:1:target directory ($TargetDir\.agents)"
    }
    if (Get-Command codex -ErrorAction SilentlyContinue) {
        $signals += "codex-cli:2:PATH binary (codex)"
    }
    if (Test-Path (Join-Path $HOME ".codex")) {
        $signals += "codex-cli:3:global config (~\.codex)"
    }

    if (Test-Path (Join-Path $TargetDir ".trae")) {
        $signals += "trae:1:target directory ($TargetDir\.trae)"
    }
    # trae has no established cross-platform PATH binary to check
    # (it's a GUI-first IDE) -- see specs/021-harness-auto-detection/research.md
    if (Test-Path (Join-Path $HOME ".trae")) {
        $signals += "trae:3:global config (~\.trae)"
    }

    $ranks = @{ "claude-code" = $null; "codex-cli" = $null; "trae" = $null }
    $evidence = @{ "claude-code" = $null; "codex-cli" = $null; "trae" = $null }

    foreach ($sig in $signals) {
        $parts = $sig -split ":", 3
        $sigHarness = $parts[0]
        $sigRank = [int]$parts[1]
        $sigEvidence = $parts[2]
        if ($null -eq $ranks[$sigHarness] -or $sigRank -lt $ranks[$sigHarness]) {
            $ranks[$sigHarness] = $sigRank
            $evidence[$sigHarness] = $sigEvidence
        }
    }

    $matched = @($ranks.Keys | Where-Object { $null -ne $ranks[$_] })

    if ($matched.Count -eq 0) {
        $Harness = "claude-code"
        Write-Host "🔭 No harness detected on this machine/target directory — falling"
        Write-Host "back to the default: claude-code (this is a fallback, not a"
        Write-Host "detected match)."
    }
    elseif ($matched.Count -eq 1) {
        $Harness = $matched[0]
        Write-Host "🔭 Detected $Harness ($($evidence[$Harness])) — installing automatically."
    }
    else {
        $priorityOrder = @("claude-code", "codex-cli", "trae")
        $recommended = $null
        $recommendedRank = 999
        foreach ($cand in $priorityOrder) {
            if ($null -ne $ranks[$cand] -and $ranks[$cand] -lt $recommendedRank) {
                $recommended = $cand
                $recommendedRank = $ranks[$cand]
            }
        }

        if ($Auto -or [Console]::IsInputRedirected) {
            $Harness = $recommended
            Write-Host "🔭 Multiple harnesses detected — auto-selecting Recommended:"
            Write-Host "$recommended (-Auto passed, or no interactive terminal available)."
        }
        else {
            Write-Host "🔭 Multiple harnesses detected on this machine/target directory:"
            $letters = @("A", "B", "C")
            $idx = 0
            $letterMap = @{}
            foreach ($cand in $priorityOrder) {
                if ($null -ne $ranks[$cand]) {
                    $letter = $letters[$idx]
                    $letterMap[$letter] = $cand
                    if ($cand -eq $recommended) {
                        Write-Host "  $letter. $cand (Recommended — $($evidence[$cand]))"
                    }
                    else {
                        Write-Host "  $letter. $cand ($($evidence[$cand]))"
                    }
                    $idx++
                }
            }
            $recommendedLetter = ($letterMap.Keys | Where-Object { $letterMap[$_] -eq $recommended })
            $choice = Read-Host "Choice [$recommendedLetter]"
            if (-not $choice) { $choice = $recommendedLetter }
            $Harness = $recommended
            foreach ($letter in $letterMap.Keys) {
                if ($choice -eq $letter -or $choice -eq $letterMap[$letter]) {
                    $Harness = $letterMap[$letter]
                }
            }
        }
    }
}

# Harness Target mapping (specs/023-full-harness-coverage/data-model.md):
# every harness shares the same source skills, runtime templates, and
# post-copy validation below. $skillsDstRel is always where the full
# specjedi-* packages land; $bridgeMode/$bridgeDstRel (empty for
# skills-dir harnesses) control whether an additional adapter file gets
# generated afterward for a harness with no native skills-directory scan.
$bridgeMode = ""
$bridgeDstRel = ""
switch ($Harness) {
    "claude-code" { $skillsDstRel = ".claude/skills" }
    "codex-cli" {
        # Verified against Codex CLI's own official docs
        # (learn.chatgpt.com/docs/build-skills): repository-level skills
        # are scanned from .agents/skills, walking up to repo root
        # (specs/016-codex-cli-install/research.md).
        $skillsDstRel = ".agents/skills"
    }
    "trae" {
        # Verified against Trae's official Skills docs and Vercel's own
        # `skills` CLI source (specs/019-trae-support/research.md).
        $skillsDstRel = ".trae/skills"
    }
    "antigravity" {
        # Google Antigravity defaults to the same .agents/skills
        # convention Codex CLI already uses -- confirmed across Google's
        # own Codelabs/Developer docs (specs/023-full-harness-coverage/research.md).
        $skillsDstRel = ".agents/skills"
    }
    "cursor" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".cursor/rules" }
    "windsurf" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".windsurf/rules" }
    "cline" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".clinerules" }
    "continue" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".continue/rules" }
    "amazon-q" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".amazonq/rules" }
    "jetbrains-ai" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".aiassistant/rules" }
    "tabnine" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".tabnine/guidelines" }
    "gemini-cli" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = "GEMINI.md" }
    "zed" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = ".rules" }
    "replit" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = "replit.md" }
    "aider" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = "CONVENTIONS.md" }
    "copilot" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = ".github/copilot-instructions.md" }
    "devin" { $skillsDstRel = ".claude/skills"; $bridgeMode = "devin"; $bridgeDstRel = ".devin.md" }
    "cody" { $skillsDstRel = ".claude/skills"; $bridgeMode = "cody"; $bridgeDstRel = ".vscode/cody.json" }
    default {
        Write-Host "🔭 '$Harness' isn't a recognized harness. See -Help for the full"
        Write-Host "list of 20 supported values (Constitution Principle III)."
        exit 1
    }
}

Write-Host "📜 Installing Spec Jedi's specjedi-* skills into: $TargetDir"
Write-Host ""

$skillsSrc = Join-Path $repoRoot ".claude/skills"
$skillsDst = Join-Path $TargetDir $skillsDstRel
New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null

$installed = 0
Get-ChildItem -Path $skillsSrc -Directory -Filter "specjedi-*" | ForEach-Object {
    $skillName = $_.Name
    $dstPath = Join-Path $skillsDst $skillName
    if (Test-Path $dstPath) {
        Remove-Item -Recurse -Force $dstPath
    }
    Copy-Item -Recurse -Path $_.FullName -Destination $dstPath
    Write-Host "  ✅ $skillName"
    $installed++
}

if ($installed -eq 0) {
    Write-Host "FAIL: no specjedi-* skills found under $skillsSrc — is this run from a Spec Jedi checkout?"
    exit 1
}

Write-Host ""
Write-Host "📚 Installing runtime template dependencies..."
$templatesDst = Join-Path $TargetDir ".specify/templates"
New-Item -ItemType Directory -Force -Path $templatesDst | Out-Null
foreach ($template in @("constitution-template.md", "spec-template.md", "plan-template.md", "tasks-template.md")) {
    Copy-Item -Path (Join-Path $repoRoot ".specify/templates/$template") -Destination (Join-Path $templatesDst $template)
    Write-Host "  ✅ $template"
}

# Bridge-file generation (specs/023-full-harness-coverage): only runs for
# harnesses with no native skills-directory scan. Reads name/description
# straight back out of the just-installed .claude/skills/specjedi-*/SKILL.md
# files, so the bridge always reflects what actually landed on disk.
function Get-SkillMeta {
    param([string]$SkillFile)
    $content = Get-Content -Path $SkillFile -Raw
    $name = [regex]::Match($content, '(?m)^name:\s*(\S+)').Groups[1].Value
    $descMatch = [regex]::Match($content, '(?m)^description:\s*(.+)$')
    $desc = $descMatch.Groups[1].Value.Trim()

    # First sentence only (up to the first ". " -- period-then-space, so
    # "spec.md"/"SKILL.md" abbreviations inside a description don't cause
    # a false cut), capped at 160 chars -- same rule as install.sh.
    $sentenceMatch = [regex]::Match($desc, '^(.*?\.)\s')
    if ($sentenceMatch.Success) {
        $desc = $sentenceMatch.Groups[1].Value
    }
    if ($desc.Length -gt 160) {
        $truncated = $desc.Substring(0, 157)
        # Trim back to the last complete word rather than cutting at the
        # exact character boundary -- a raw character cut regularly
        # landed mid-word (e.g. "...journey, k...", "...directly t..."),
        # a confusing fragment for something an agent reads directly as
        # its own session-start context (CLAUDE.md/AGENTS.md/.trae/rules'
        # generated section, specs/039). No-op if there's no space in
        # the truncated string at all -- mirrors install.sh's
        # ${desc% *} exactly.
        $lastSpace = $truncated.LastIndexOf(" ")
        if ($lastSpace -ge 0) {
            $truncated = $truncated.Substring(0, $lastSpace)
        }
        $desc = $truncated + "..."
    }
    [PSCustomObject]@{ Name = $name; Description = $desc }
}

# specs/039-memory-file-skill-mentions: for harnesses with a confirmed,
# separate project-memory-file convention distinct from their skills
# directory (CLAUDE.md, AGENTS.md, .trae/rules/project_rules.md), create
# or idempotently update a marker-delimited section naming the installed
# skills -- never for antigravity (no confirmed convention) or the 14
# bridge harnesses (their existing bridge file already serves this
# purpose).
function Get-MemorySection {
    param([string]$SkillsDstRel)
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("<!-- SPEC-JEDI:SKILLS:START -->")
    $lines.Add("## Spec Jedi skills available in this project")
    $lines.Add("")
    $lines.Add("This project has the Spec Jedi spec-driven-development skill set")
    $lines.Add("installed at ``$SkillsDstRel/``. When a request matches one of")
    $lines.Add("the skills below, open and follow the full instructions in its")
    $lines.Add("``SKILL.md`` before responding. New to Spec Jedi? Start with")
    $lines.Add("``specjedi-onboard``.")
    $lines.Add("")
    $lines.Add("| Skill | What it does |")
    $lines.Add("|---|---|")
    # Sort explicitly: bash's `for f in "$skills_dst"/specjedi-*/SKILL.md`
    # glob expansion is alphabetically ordered by the shell itself, but
    # Get-ChildItem's enumeration order is filesystem-dependent, not
    # alphabetical -- without this, the two scripts would produce a
    # different skill order in the table for the same skill set,
    # breaking FR-008/SC-004's byte-parity requirement (verified locally:
    # unsorted Get-ChildItem returned a different order than bash's glob
    # for the same three test directories).
    Get-ChildItem -Path $skillsDst -Recurse -Filter "SKILL.md" | Sort-Object FullName | ForEach-Object {
        $meta = Get-SkillMeta -SkillFile $_.FullName
        $lines.Add("| ``$($meta.Name)`` | $($meta.Description) |")
    }
    $lines.Add("<!-- SPEC-JEDI:SKILLS:END -->")
    [string]::Join("`n", $lines)
}

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
        # Drop exactly one trailing LF before slicing, mirroring bash's
        # $(cat file) command-substitution semantics EXACTLY: bash's
        # command substitution strips only a trailing \n, not a
        # preceding \r -- a CRLF-terminated file keeps its trailing \r
        # after stripping, which the final "...$after`n" reconstruction
        # below then completes back into a proper CRLF. Stripping
        # `\r?\n` instead (both characters as one unit) was tried first
        # and rejected: it strips the \r too, so a CRLF-terminated file
        # loses its trailing \r and ends in a bare LF after re-append --
        # a real, verified FR-002 byte-preservation gap AND an FR-008
        # cross-script mismatch against install.sh, which doesn't have
        # this problem (confirmed by inspecting both scripts' raw output
        # bytes against the same CRLF fixture). Whole-content substring
        # slicing (.IndexOf()/.Substring()), never a line-array rebuild
        # -- CRLF-safe by construction, since there's no per-line
        # comparison to be defeated by a trailing \r.
        $content = $rawContent -replace '\n$', ''
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

if ($bridgeMode) {
    Write-Host ""
    Write-Host "🌉 Generating $Harness bridge file(s)..."
    $bridgeDst = Join-Path $TargetDir $bridgeDstRel
    $skillMetas = Get-ChildItem -Path $skillsDst -Recurse -Filter "SKILL.md" | ForEach-Object { Get-SkillMeta -SkillFile $_.FullName }

    switch ($bridgeMode) {
        "dir" {
            New-Item -ItemType Directory -Force -Path $bridgeDst | Out-Null
            $bridgeCount = 0
            foreach ($meta in $skillMetas) {
                $lines = @(
                    "<!-- Managed by Spec Jedi's installer (scripts/install.sh/.ps1).",
                    "     Re-running the installer regenerates this file. -->",
                    "",
                    "# $($meta.Name)",
                    "",
                    $meta.Description,
                    "",
                    "Full instructions: ``.claude/skills/$($meta.Name)/SKILL.md`` — read and follow it in full when this applies."
                )
                Set-Content -Path (Join-Path $bridgeDst "$($meta.Name).md") -Value $lines
                $bridgeCount++
            }
            Write-Host "  ✅ $bridgeCount bridge file(s) under $bridgeDstRel/"
        }
        { $_ -in "single", "devin" } {
            $bridgeParent = Split-Path -Parent $bridgeDst
            if ($bridgeParent) { New-Item -ItemType Directory -Force -Path $bridgeParent | Out-Null }
            $lines = @(
                "<!-- Managed by Spec Jedi's installer (scripts/install.sh/.ps1).",
                "     Re-running the installer regenerates this file. -->",
                ""
            )
            if ($bridgeMode -eq "devin") {
                $lines += @(
                    "# Spec Jedi Playbook",
                    "",
                    "## Specifications",
                    "",
                    "This project has the Spec Jedi spec-driven-development skill set",
                    "installed at ``.claude/skills/``. Each skill below is a self-contained",
                    "Markdown instruction file with YAML frontmatter.",
                    "",
                    "## Procedure",
                    "",
                    "1. When a request matches one of the skills in the table below, open",
                    "   its ``SKILL.md`` in full and follow its instructions before responding.",
                    "2. New to Spec Jedi? Start with ``specjedi-onboard``.",
                    "",
                    "## Advice",
                    ""
                )
            }
            else {
                $lines += @(
                    "# Spec Jedi skills available in this project",
                    "",
                    "This project has the Spec Jedi spec-driven-development skill set",
                    "installed at ``.claude/skills/``. This harness reads a single",
                    "project-level instructions file rather than scanning a skills",
                    "directory, so this index bridges the gap: when a request matches",
                    "one of the skills below, open and follow the full instructions in",
                    "its ``SKILL.md`` before responding. New to Spec Jedi? Start with",
                    "``specjedi-onboard``.",
                    ""
                )
            }
            $lines += @("| Skill | What it does |", "|---|---|")
            foreach ($meta in $skillMetas) {
                $lines += "| ``$($meta.Name)`` | $($meta.Description) |"
            }
            Set-Content -Path $bridgeDst -Value $lines
            Write-Host "  ✅ $bridgeDstRel"
        }
        "cody" {
            $bridgeParent = Split-Path -Parent $bridgeDst
            if ($bridgeParent) { New-Item -ItemType Directory -Force -Path $bridgeParent | Out-Null }
            $commands = [ordered]@{}
            foreach ($meta in $skillMetas) {
                $commands[$meta.Name] = [ordered]@{
                    description  = $meta.Description
                    prompt       = "Follow the instructions in .claude/skills/$($meta.Name)/SKILL.md in full."
                    contextFiles = @(".claude/skills/$($meta.Name)/SKILL.md")
                }
            }
            ($commands | ConvertTo-Json -Depth 5) | Set-Content -Path $bridgeDst
            Write-Host "  ✅ $bridgeDstRel (Cody custom commands — invoke with /specjedi-<name>;"
            Write-Host "     Cody has no confirmed always-on rules file, so these load on"
            Write-Host "     explicit invocation rather than automatically, unlike the other"
            Write-Host "     bridge harnesses — see specs/023-full-harness-coverage/research.md)"
        }
    }
}

# specs/039-memory-file-skill-mentions: harnesses with a confirmed,
# separate project-memory-file convention distinct from their skills
# directory get that file created or updated too -- never antigravity
# (no confirmed convention) or the 14 bridge harnesses above (their
# bridge file already serves this purpose).
$memoryFileRel = ""
switch ($Harness) {
    "claude-code" { $memoryFileRel = "CLAUDE.md" }
    "codex-cli" { $memoryFileRel = "AGENTS.md" }
    "trae" { $memoryFileRel = ".trae/rules/project_rules.md" }
}
if ($memoryFileRel) {
    Write-Host ""
    Write-Host "🧠 Updating $memoryFileRel with the installed skill set..."
    Update-MemoryFile -MemoryPath (Join-Path $TargetDir $memoryFileRel) -SkillsDstRel $skillsDstRel
}

Write-Host ""
Write-Host "== Validating installed skills =="
$fail = $false
Get-ChildItem -Path $skillsDst -Recurse -Filter "SKILL.md" -Force | ForEach-Object {
    $skillFile = $_.FullName
    $skillDir = $_.DirectoryName
    $ok = $true

    $lines = Get-Content -Path $skillFile -TotalCount 1
    if ($lines -ne "---") {
        Write-Host "FAIL: $skillFile does not start with YAML frontmatter (---)"
        $ok = $false
    }

    $content = Get-Content -Path $skillFile -Raw
    if ($content -notmatch '(?m)^name:\s*\S+') {
        Write-Host "FAIL: $skillFile frontmatter missing 'name:'"
        $ok = $false
    }
    if ($content -notmatch '(?m)^description:\s*\S+') {
        Write-Host "FAIL: $skillFile frontmatter missing 'description:'"
        $ok = $false
    }

    if ($ok) {
        Write-Host "OK: $skillDir"
    } else {
        $fail = $true
    }
}

Write-Host ""
if ($fail) {
    Write-Host "install.ps1: FAILED - installed skills did not pass validation"
    exit 1
}

Write-Host "🚀 install.ps1: $installed specjedi-* skills installed and validated."
Write-Host ""
Write-Host "Next step:"
Write-Host "  - No .specify/memory/constitution.md yet? Run specjedi-onboard for a"
Write-Host "    guided first-run walkthrough, or specjedi-constitution directly."
