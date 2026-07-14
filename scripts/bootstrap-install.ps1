#!/usr/bin/env pwsh
# Spec Jedi standalone bootstrap installer (specs/024-bootstrap-installer,
# references/skill-roadmap.md "Sub-Project B"). Native PowerShell
# counterpart of bootstrap-install.sh (Constitution Principle XIII).
# Installs Spec Jedi into a project WITHOUT cloning the repository first:
# fetches a published GitHub Release's downloadable tarball
# (scripts/package-release.sh's spec-jedi-<version>.tar.gz), extracts it,
# and runs the bundled scripts/install.ps1.
#
#   iwr -useb https://raw.githubusercontent.com/jonyfs/spec-jedi/main/scripts/bootstrap-install.ps1 | iex
#
# Depends entirely on a real GitHub Release existing (Constitution
# Principle XI). This project's own first release has not been cut as of
# this script's authorship, so the "no release found" path below is not
# a hypothetical -- it's the actual current state, and fails with a
# clear, honest message rather than a cryptic API error.

param(
    [string]$TargetDir = ".",
    [string]$Harness = "",
    [switch]$Auto,
    [string]$Version = "",
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help) {
    Write-Host "Usage: bootstrap-install.ps1 [-TargetDir DIR] [-Harness HARNESS] [-Auto] [-Version vX.Y.Z]"
    Write-Host ""
    Write-Host "Downloads a published Spec Jedi release from GitHub (no git clone"
    Write-Host "required) and runs its bundled scripts/install.ps1 against -TargetDir"
    Write-Host "(defaults to the current directory)."
    Write-Host ""
    Write-Host "  -Version    Install a specific tagged release instead of the latest"
    Write-Host "              one (e.g. -Version v0.1.0)."
    Write-Host ""
    Write-Host "-Harness and -Auto are forwarded to install.ps1 unchanged."
    exit 0
}

$repo = "jonyfs/spec-jedi"
$apiUrl = "https://api.github.com/repos/$repo/releases/latest"
if ($Version) {
    $apiUrl = "https://api.github.com/repos/$repo/releases/tags/$Version"
}

Write-Host "📡 Looking up Spec Jedi release ($(if ($Version) { $Version } else { 'latest' }))..."

# A transient failure (rate limit, network blip, 5xx) and a genuine "no
# release" both surface as a caught exception here -- retry a few times
# before concluding it's the latter, rather than surfacing a misleading
# permanent-looking message for what might just be a passing hiccup.
$release = $null
for ($attempt = 1; $attempt -le 3; $attempt++) {
    try {
        $release = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "spec-jedi-bootstrap-installer" } -ErrorAction Stop
        break
    } catch {
        $release = $null
        if ($attempt -lt 3) { Start-Sleep -Seconds $attempt }
    }
}

if (-not $release -or -not $release.tag_name) {
    Write-Host ""
    Write-Host "🔭 No published Spec Jedi release found$(if ($Version) { " for $Version" })."
    Write-Host "This project cuts releases deliberately (Constitution Principle XI) --"
    Write-Host "none may exist yet, the requested version may not exist, or the"
    Write-Host "network request itself may have failed."
    Write-Host ""
    Write-Host "Alternatives:"
    Write-Host "  - List available releases: https://github.com/$repo/releases"
    Write-Host "  - Clone the repo directly and run scripts/install.ps1 from a checkout:"
    Write-Host "      git clone https://github.com/$repo.git; cd spec-jedi; .\scripts\install.ps1"
    exit 1
}

$tagName = $release.tag_name
$asset = $release.assets | Where-Object { $_.name -match '^spec-jedi-.*\.tar\.gz$' } | Select-Object -First 1

if (-not $asset) {
    Write-Host "FAIL: release '$tagName' has no spec-jedi-*.tar.gz asset — is this a valid Spec Jedi release?"
    exit 1
}

Write-Host "📦 Found $tagName — downloading $($asset.name)..."
$workDir = New-Item -ItemType Directory -Path (Join-Path ([System.IO.Path]::GetTempPath()) "spec-jedi-bootstrap-$([guid]::NewGuid())")
try {
    $archivePath = Join-Path $workDir.FullName "spec-jedi.tar.gz"
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archivePath -Headers @{ "User-Agent" = "spec-jedi-bootstrap-installer" }

    tar -xzf $archivePath -C $workDir.FullName

    $extractedDir = Get-ChildItem -Path $workDir.FullName -Directory -Filter "spec-jedi-*" | Select-Object -First 1
    if (-not $extractedDir -or -not (Test-Path (Join-Path $extractedDir.FullName "scripts/install.ps1"))) {
        Write-Host "FAIL: downloaded archive doesn't contain scripts/install.ps1 — unexpected release layout"
        exit 1
    }

    Write-Host "🚀 Running install.ps1 from $tagName..."
    Write-Host ""
    # Splat a hashtable, not an array -- array splatting binds positionally
    # (the literal "-TargetDir" string lands in install.ps1's first
    # parameter and the real path lands in its second), which silently
    # misroutes TargetDir's value into Harness. Hashtable splatting binds
    # by name unambiguously.
    $installArgs = @{ TargetDir = $TargetDir }
    if ($Harness) { $installArgs["Harness"] = $Harness }
    if ($Auto) { $installArgs["Auto"] = $true }
    & (Join-Path $extractedDir.FullName "scripts/install.ps1") @installArgs
}
finally {
    Remove-Item -Recurse -Force $workDir.FullName -ErrorAction SilentlyContinue
}
