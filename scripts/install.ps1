#!/usr/bin/env pwsh
# Spec Jedi zero-footprint installer (Constitution Principle XVIII).
# Native PowerShell counterpart of install.sh (Constitution Principle XIII —
# every .sh ships with an equivalent .ps1). Copies the specjedi-* product
# skills (never speckit-* bootstrap tooling) into a target project, plus the
# .specify/templates/*.md files those skills depend on at runtime.
# Product-only by default, harness-selected, validated after copy.

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
    Write-Host "  -Harness     Which coding agent to configure for. 'claude-code',"
    Write-Host "               'codex-cli', and 'trae' are built and tested today"
    Write-Host "               (Constitution Principle III); any other value is"
    Write-Host "               reported as not-yet-supported rather than silently"
    Write-Host "               attempted. If omitted, the installer attempts harness"
    Write-Host "               auto-detection (specs/021-harness-auto-detection)."
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
# when -Harness was omitted. Any explicit -Harness value bypasses all of
# this entirely -- zero behavior change for existing scripted/CI usage.
if (-not $Harness) {
    $signals = @()

    if (Test-Path (Join-Path $TargetDir ".claude")) {
        $signals += "claude-code:1:target directory ($TargetDir\.claude)"
    }
    if (Get-Command claude -ErrorAction SilentlyContinue) {
        $signals += "claude-code:2:PATH binary (claude)"
    }
    if (Test-Path (Join-Path $env:USERPROFILE ".claude")) {
        $signals += "claude-code:3:global config (~\.claude)"
    }

    if (Test-Path (Join-Path $TargetDir ".agents")) {
        $signals += "codex-cli:1:target directory ($TargetDir\.agents)"
    }
    if (Get-Command codex -ErrorAction SilentlyContinue) {
        $signals += "codex-cli:2:PATH binary (codex)"
    }
    if (Test-Path (Join-Path $env:USERPROFILE ".codex")) {
        $signals += "codex-cli:3:global config (~\.codex)"
    }

    if (Test-Path (Join-Path $TargetDir ".trae")) {
        $signals += "trae:1:target directory ($TargetDir\.trae)"
    }
    # trae has no established cross-platform PATH binary to check
    # (it's a GUI-first IDE) -- see specs/021-harness-auto-detection/research.md
    if (Test-Path (Join-Path $env:USERPROFILE ".trae")) {
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

# Harness Target mapping (data-model.md): both entries share the same
# source skills, runtime templates, and post-copy validation below --
# only the destination subdirectory name differs.
switch ($Harness) {
    "claude-code" { $skillsDstRel = ".claude/skills" }
    "codex-cli" {
        # Verified against Codex CLI's own official docs
        # (learn.chatgpt.com/docs/build-skills): repository-level skills
        # are scanned from .agents/skills, walking up to repo root;
        # SKILL.md requires the same name/description frontmatter
        # specjedi-* skills already carry (specs/016-codex-cli-install/research.md).
        $skillsDstRel = ".agents/skills"
    }
    "trae" {
        # Verified against Trae's official Skills docs, community docs,
        # and Vercel's own `skills` CLI source (skillsDir: '.trae/skills'
        # for the trae agent target): project-local skills are scanned
        # from .trae/skills, same name/description frontmatter
        # (specs/019-trae-support/research.md).
        $skillsDstRel = ".trae/skills"
    }
    default {
        Write-Host "🔭 '$Harness' isn't built and tested yet — only 'claude-code',"
        Write-Host "'codex-cli', and 'trae' are fully supported today (Constitution"
        Write-Host "Principle III's compatibility matrix). The SKILL.md files are plain"
        Write-Host "Markdown with YAML frontmatter, so many harnesses that read custom"
        Write-Host "instructions can already use them directly even without a dedicated"
        Write-Host "install path — but this installer won't claim to have set that up"
        Write-Host "for you."
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
