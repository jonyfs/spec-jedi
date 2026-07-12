#!/usr/bin/env pwsh
# Spec Jedi release-packaging tool (specs/020-release-packaging).
# Native PowerShell counterpart of package-release.sh (Constitution
# Principle XIII). Builds the single universal downloadable artifact a
# release publishes: every specjedi-* skill, the runtime template
# dependencies, and the installer scripts themselves.

param(
    [Parameter(Position = 0)]
    [string]$Version,

    [Parameter(Position = 1)]
    [string]$OutputDir,

    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help -or -not $Version -or -not $OutputDir) {
    Write-Host "Usage: package-release.ps1 VERSION OUTPUT_DIR"
    Write-Host ""
    Write-Host "  VERSION       Version string used in the artifact filename (e.g. v0.1.0)."
    Write-Host "  OUTPUT_DIR    Directory to write spec-jedi-VERSION.tar.gz into."
    Write-Host ""
    Write-Host "Produces a tarball containing .claude/skills/specjedi-*/, the four"
    Write-Host ".specify/templates/*.md files, scripts/install.sh, scripts/install.ps1,"
    Write-Host "and LICENSE -- nothing else."
    if ($Help) { exit 0 } else { exit 1 }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$staging = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Force -Path $staging | Out-Null

try {
    $archiveName = "spec-jedi-$Version.tar.gz"
    $stageRoot = Join-Path $staging "spec-jedi-$Version"
    New-Item -ItemType Directory -Force -Path $stageRoot | Out-Null

    Write-Host "📦 Staging release artifact for $Version..."

    $skillsDst = Join-Path $stageRoot ".claude/skills"
    New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null
    Get-ChildItem -Path (Join-Path $repoRoot ".claude/skills") -Directory -Filter "specjedi-*" | ForEach-Object {
        $skillName = $_.Name
        Copy-Item -Recurse -Path $_.FullName -Destination (Join-Path $skillsDst $skillName)
        Write-Host "  ✅ .claude/skills/$skillName"
    }

    $templatesDst = Join-Path $stageRoot ".specify/templates"
    New-Item -ItemType Directory -Force -Path $templatesDst | Out-Null
    foreach ($template in @("constitution-template.md", "spec-template.md", "plan-template.md", "tasks-template.md")) {
        Copy-Item -Path (Join-Path $repoRoot ".specify/templates/$template") -Destination (Join-Path $templatesDst $template)
        Write-Host "  ✅ .specify/templates/$template"
    }

    $scriptsDst = Join-Path $stageRoot "scripts"
    New-Item -ItemType Directory -Force -Path $scriptsDst | Out-Null
    Copy-Item -Path (Join-Path $repoRoot "scripts/install.sh") -Destination (Join-Path $scriptsDst "install.sh")
    Copy-Item -Path (Join-Path $repoRoot "scripts/install.ps1") -Destination (Join-Path $scriptsDst "install.ps1")
    Write-Host "  ✅ scripts/install.sh"
    Write-Host "  ✅ scripts/install.ps1"

    Copy-Item -Path (Join-Path $repoRoot "LICENSE") -Destination (Join-Path $stageRoot "LICENSE")
    Write-Host "  ✅ LICENSE"

    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
    $OutputDir = (Resolve-Path $OutputDir).Path
    $archivePath = Join-Path $OutputDir $archiveName

    tar -czf $archivePath -C $staging "spec-jedi-$Version"

    Write-Host ""
    Write-Host "🚀 package-release.ps1: $archivePath built."
}
finally {
    Remove-Item -Recurse -Force $staging -ErrorAction SilentlyContinue
}
