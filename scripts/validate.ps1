#!/usr/bin/env pwsh
# Spec Jedi self-validation entrypoint (Constitution Principle IX).
# Native PowerShell counterpart of validate.sh (Constitution Principle XIII —
# every .sh ships with an equivalent .ps1). Every PR's CI workflow runs one of
# these two; a nonzero exit blocks merge.

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$fail = $false

Write-Host "== Constitution: no leftover placeholder tokens =="
# Skip the leading Sync Impact Report HTML comment: it's a historical audit
# log and may legitimately mention a literal token like "[TEMPLATE]" when
# describing a version transition without that being an unresolved
# placeholder in the constitution body itself.
$constitutionPath = Join-Path $repoRoot '.specify/memory/constitution.md'
$lines = Get-Content -Path $constitutionPath
$commentEndIndex = ($lines | Select-String -Pattern '-->' -List | Select-Object -First 1).LineNumber
$bodyLines = if ($commentEndIndex) { $lines[$commentEndIndex..($lines.Count - 1)] } else { $lines }
$placeholders = $bodyLines | Select-String -Pattern '\[[A-Z_]+\]'
if ($placeholders) {
    $placeholders | ForEach-Object { Write-Host $_.Line }
    Write-Host "FAIL: unresolved [PLACEHOLDER] tokens found in constitution.md body"
    $fail = $true
} else {
    Write-Host "OK"
}

Write-Host ""
Write-Host "== SKILL.md structural lint =="
$skillFiles = Get-ChildItem -Path $repoRoot -Recurse -Force -Filter 'SKILL.md' -File |
    Where-Object { $_.FullName -notmatch '\.git[\\/]' }

foreach ($skillFile in $skillFiles) {
    $skillDir = $skillFile.DirectoryName
    $ok = $true
    $content = Get-Content -Path $skillFile.FullName

    if (-not $content -or $content[0] -ne '---') {
        Write-Host "FAIL: $($skillFile.FullName) does not start with YAML frontmatter (---)"
        $ok = $false
    }

    if (-not ($content -match '^name:\s*\S+')) {
        Write-Host "FAIL: $($skillFile.FullName) frontmatter missing 'name:'"
        $ok = $false
    }

    if (-not ($content -match '^description:\s*\S+')) {
        Write-Host "FAIL: $($skillFile.FullName) frontmatter missing 'description:'"
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
    Write-Host "validate.ps1: FAILED"
    exit 1
}

Write-Host "validate.ps1: PASSED"
