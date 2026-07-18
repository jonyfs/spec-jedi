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
    Write-Host "scripts/session-start.sh, scripts/session-start.ps1,"
    Write-Host ".claude/hooks/dangerous-command-guard.sh/.ps1, a RELEASE_VERSION stamp"
    Write-Host "file, README.md, four user-facing references/*.md files"
    Write-Host "(quickstart-guide.md, what-is-sdd.md,"
    Write-Host "specjedi-and-sdd.md, session-start-hook-guide.md), and LICENSE -- never"
    Write-Host "specs/, CONTRIBUTING.md, or this project's own internal skill-authoring/"
    Write-Host "governance reference docs (specs/038-expand-release-package)."
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

    $referencesDst = Join-Path $stageRoot "references"
    New-Item -ItemType Directory -Force -Path $referencesDst | Out-Null
    foreach ($ref in @("quickstart-guide.md", "what-is-sdd.md", "specjedi-and-sdd.md", "session-start-hook-guide.md")) {
        Copy-Item -Path (Join-Path $repoRoot "references/$ref") -Destination (Join-Path $referencesDst $ref)
        Write-Host "  ✅ references/$ref"
    }

    Copy-Item -Path (Join-Path $repoRoot "README.md") -Destination (Join-Path $stageRoot "README.md")
    Write-Host "  ✅ README.md"

    $scriptsDst = Join-Path $stageRoot "scripts"
    New-Item -ItemType Directory -Force -Path $scriptsDst | Out-Null
    Copy-Item -Path (Join-Path $repoRoot "scripts/install.sh") -Destination (Join-Path $scriptsDst "install.sh")
    Copy-Item -Path (Join-Path $repoRoot "scripts/install.ps1") -Destination (Join-Path $scriptsDst "install.ps1")
    Copy-Item -Path (Join-Path $repoRoot "scripts/session-start.sh") -Destination (Join-Path $scriptsDst "session-start.sh")
    Copy-Item -Path (Join-Path $repoRoot "scripts/session-start.ps1") -Destination (Join-Path $scriptsDst "session-start.ps1")
    Write-Host "  ✅ scripts/install.sh"
    Write-Host "  ✅ scripts/install.ps1"
    Write-Host "  ✅ scripts/session-start.sh"
    Write-Host "  ✅ scripts/session-start.ps1"

    # specs/042-skill-freshness-validation: pre-existing bug found while
    # testing this feature -- install.sh/.ps1's shareable-hooks step
    # (specs/041) reads $repoRoot/.claude/hooks/dangerous-command-guard.sh
    # /.ps1 unconditionally for claude-code and every Wave 1/2 harness,
    # but this staging script never packaged it, so install.ps1 run from
    # ANY extracted release tarball (bootstrap-install.ps1's entire
    # purpose) has always exited non-zero here. Fixed as part of this
    # feature since it directly blocks testing the marker-writing
    # behavior end-to-end from a real package.
    $hooksDst = Join-Path $stageRoot ".claude/hooks"
    New-Item -ItemType Directory -Force -Path $hooksDst | Out-Null
    Copy-Item -Path (Join-Path $repoRoot ".claude/hooks/dangerous-command-guard.sh") -Destination (Join-Path $hooksDst "dangerous-command-guard.sh")
    Copy-Item -Path (Join-Path $repoRoot ".claude/hooks/dangerous-command-guard.ps1") -Destination (Join-Path $hooksDst "dangerous-command-guard.ps1")
    Write-Host "  ✅ .claude/hooks/dangerous-command-guard.sh"
    Write-Host "  ✅ .claude/hooks/dangerous-command-guard.ps1"

    Copy-Item -Path (Join-Path $repoRoot "LICENSE") -Destination (Join-Path $stageRoot "LICENSE")
    Write-Host "  ✅ LICENSE"

    # specs/042-skill-freshness-validation: a plain-text stamp of the
    # version being packaged, read by install.ps1 at install time to
    # write a real release tag into the target's installed-release
    # marker instead of the "local-checkout" sentinel -- the only way
    # install.ps1 can know its own version when running from an
    # extracted tarball (no .git directory).
    [System.IO.File]::WriteAllText((Join-Path $stageRoot "RELEASE_VERSION"), $Version)
    Write-Host "  ✅ RELEASE_VERSION"

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
