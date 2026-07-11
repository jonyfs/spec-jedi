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
$constitutionPath = Join-Path $repoRoot '.specify/memory/constitution.md'
$placeholders = Select-String -Path $constitutionPath -Pattern '\[[A-Z_]+\]'
if ($placeholders) {
    $placeholders | ForEach-Object { Write-Host $_.Line }
    Write-Host "FAIL: unresolved [PLACEHOLDER] tokens found in constitution.md"
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
