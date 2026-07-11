#!/usr/bin/env pwsh
# Spec Jedi release-suggestion tool (Constitution Principle XI).
# Native PowerShell counterpart of suggest-release.sh (Constitution Principle
# XIII). Reads Conventional-Commit-style history since the last tag and
# suggests the next semantic version. Never tags, never publishes — it only
# recommends; cutting a release always requires an explicit human step.

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$lastTag = (git describe --tags --abbrev=0 2>$null)
if ($LASTEXITCODE -ne 0) { $lastTag = $null }

if (-not $lastTag) {
    Write-Host "No tags found yet - this would be the first release."
    Write-Host "Suggested starting version: v0.1.0 (pre-1.0: API/skill surface still settling)"
    Write-Host "or v1.0.0 if the maintainer considers the current skill set stable."
    Write-Host ""
    Write-Host "Commits considered (all history):"
    git log --pretty='format:  %h %s' | ForEach-Object { Write-Host $_ }
    exit 0
}

$range = "$lastTag..HEAD"
$commits = git log $range --pretty='format:%s'

if (-not $commits) {
    Write-Host "No commits since ${lastTag}. No release suggested."
    exit 0
}

$bump = 'none'
if ($commits -match '(?m)^[a-zA-Z]+(\([^)]*\))?!:|BREAKING CHANGE') {
    $bump = 'major'
} elseif ($commits -match '(?m)^feat(\([^)]*\))?:') {
    $bump = 'minor'
} elseif ($commits -match '(?m)^(fix|docs|chore|refactor|perf|test)(\([^)]*\))?:') {
    $bump = 'patch'
}

$versionCore = $lastTag -replace '^v', ''
$parts = $versionCore -split '\.'
[int]$major = $parts[0]
[int]$minor = $parts[1]
[int]$patch = $parts[2]

switch ($bump) {
    'major' { $next = "v$($major + 1).0.0" }
    'minor' { $next = "v$major.$($minor + 1).0" }
    'patch' { $next = "v$major.$minor.$($patch + 1)" }
    'none' {
        Write-Host "Commits since $lastTag don't match a known Conventional Commits"
        Write-Host "prefix (feat/fix/docs/chore/refactor/perf/test, or a '!'/BREAKING"
        Write-Host "CHANGE marker). No automatic suggestion - review manually:"
        git log $range --pretty='format:  %h %s' | ForEach-Object { Write-Host $_ }
        exit 0
    }
}

Write-Host "Last release: $lastTag"
Write-Host "Suggested next version: $next ($bump bump)"
Write-Host ""
Write-Host "Commits since ${lastTag}:"
git log $range --pretty='format:  %h %s' | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "This is a suggestion only. Cutting the release (tag + publish +"
Write-Host "changelog) requires an explicit maintainer decision (Principle XI)."
