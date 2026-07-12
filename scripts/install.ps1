#!/usr/bin/env pwsh
# Spec Jedi zero-footprint installer (Constitution Principle XVIII).
# Native PowerShell counterpart of install.sh (Constitution Principle XIII —
# every .sh ships with an equivalent .ps1). Copies the specjedi-* product
# skills (never speckit-* bootstrap tooling) into a target project, plus the
# .specify/templates/*.md files those skills depend on at runtime.
# Product-only by default, harness-selected, validated after copy.

param(
    [string]$TargetDir = ".",
    [string]$Harness = "claude-code",
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help) {
    Write-Host "Usage: install.ps1 [-TargetDir DIR] [-Harness HARNESS]"
    Write-Host ""
    Write-Host "  -TargetDir   Project to install Spec Jedi's specjedi-* skills into."
    Write-Host "               Defaults to the current directory."
    Write-Host "  -Harness     Which coding agent to configure for. 'claude-code' and"
    Write-Host "               'codex-cli' are built and tested today (Constitution"
    Write-Host "               Principle III); any other value is reported as"
    Write-Host "               not-yet-supported rather than silently attempted."
    exit 0
}

$repoRoot = Split-Path -Parent $PSScriptRoot

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
    default {
        Write-Host "🔭 '$Harness' isn't built and tested yet — only 'claude-code' and"
        Write-Host "'codex-cli' are fully supported today (Constitution Principle III's"
        Write-Host "compatibility matrix). The SKILL.md files are plain Markdown with"
        Write-Host "YAML frontmatter, so many harnesses that read custom instructions"
        Write-Host "can already use them directly even without a dedicated install"
        Write-Host "path — but this installer won't claim to have set that up for you."
        exit 1
    }
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
$TargetDir = (Resolve-Path $TargetDir).Path

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
