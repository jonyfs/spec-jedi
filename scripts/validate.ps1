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
$placeholders = $bodyLines | Select-String -CaseSensitive -Pattern '\[[A-Z_]+\]'
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
Write-Host "== Constitution Principle IX: validation battery growth trigger =="
# Informational only (never fails the build): flags the moment this repo
# gains unit-testable logic, an integration surface, or a web UI that the
# CI battery (.github/workflows/*.yml) doesn't yet cover — the exact
# "moment any skill produces..." trigger Principle IX names but leaves
# undetected otherwise (checklists/project-completeness.md CHK004).
$batterySignal = $false

$testFiles = Get-ChildItem -Path $repoRoot -Recurse -Force -File -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '\.git[\\/]' -and ($_.Name -match '\.test\.' -or $_.Name -match '\.spec\.' -or $_.Name -match '_test\.py$') } |
    Select-Object -First 1
if ($testFiles) {
    Write-Host "SIGNAL: test-pattern file(s) found (*.test.*, *.spec.*, *_test.py) - unit-testable logic may exist"
    $batterySignal = $true
}

$packageJsonPath = Join-Path $repoRoot 'package.json'
if ((Test-Path (Join-Path $repoRoot 'package.json')) -or (Test-Path (Join-Path $repoRoot 'pyproject.toml')) -or (Test-Path (Join-Path $repoRoot 'Cargo.toml')) -or (Test-Path (Join-Path $repoRoot 'go.mod'))) {
    Write-Host "SIGNAL: a language runtime manifest (package.json/pyproject.toml/Cargo.toml/go.mod) exists at repo root"
    $batterySignal = $true
}

$hasWebMarker = (Test-Path (Join-Path $repoRoot 'index.html'))
if (-not $hasWebMarker -and (Test-Path $packageJsonPath)) {
    $pkgContent = Get-Content -Path $packageJsonPath -Raw
    if ($pkgContent -match '"(react|vue|svelte|next)"') {
        $hasWebMarker = $true
    }
}
if ($hasWebMarker) {
    Write-Host "SIGNAL: web UI marker found (index.html, or a React/Vue/Svelte/Next dependency)"
    $batterySignal = $true
}

if ($batterySignal) {
    $workflowFiles = Get-ChildItem -Path (Join-Path $repoRoot '.github/workflows') -Filter '*.yml' -ErrorAction SilentlyContinue
    $batteryJobs = $workflowFiles | Where-Object {
        $nonCommentLines = (Get-Content -Path $_.FullName) | Where-Object { $_ -notmatch '^\s*#' }
        ($nonCommentLines -join "`n") -match 'unit|integration|playwright'
    }
    if (-not $batteryJobs) {
        Write-Host "WARN: signal(s) found above, but no unit/integration/playwright job exists in .github/workflows/ - the validation battery should grow (Principle IX)."
    } else {
        Write-Host "OK: signal(s) found above, and a corresponding CI job already exists - battery already covers this."
    }
} else {
    Write-Host "OK: no unit-testable code, integration surface, or web UI detected - battery growth not yet triggered."
}

Write-Host ""
Write-Host "== Constitution Principle I: localized docs sync check =="
# Informational only (never fails the build): each translated file under
# docs/i18n/<lang>/ records "i18n-sync: source=<file>@<hash>" naming the
# English source commit it was translated from. Warn when the English
# source has moved since - Principle I requires drift to be flagged
# ("MUST be flagged... rather than silently served as current"), not
# silently ignored.
$i18nDir = Join-Path $repoRoot 'docs/i18n'
if (Test-Path $i18nDir) {
    $translatedFiles = Get-ChildItem -Path $i18nDir -Recurse -Filter '*.md' -File
    foreach ($translatedFile in $translatedFiles) {
        $markerLine = (Get-Content -Path $translatedFile.FullName) | Select-String -Pattern 'i18n-sync: source=' | Select-Object -First 1
        if (-not $markerLine) {
            Write-Host "WARN: $($translatedFile.FullName) has no i18n-sync marker - drift cannot be checked."
            continue
        }
        if ($markerLine.Line -match 'source=([^@]+)@([0-9a-f]+)') {
            $sourceRel = $matches[1]
            $syncedHash = $matches[2]
            $sourcePath = Join-Path $repoRoot $sourceRel
            if (-not (Test-Path $sourcePath)) {
                Write-Host "WARN: $($translatedFile.FullName) references missing source $sourceRel"
                continue
            }
            $currentHash = (git log -1 --format=%h -- $sourceRel 2>$null)
            if ($currentHash -and ($currentHash -ne $syncedHash)) {
                Write-Host "WARN: $($translatedFile.FullName) is out of sync - $sourceRel changed since commit $syncedHash (now at $currentHash)."
            }
        }
    }
    Write-Host "OK: localized docs sync check complete (see WARN lines above, if any)."
} else {
    Write-Host "OK: no docs/i18n/ directory yet."
}

Write-Host ""
if ($fail) {
    Write-Host "validate.ps1: FAILED"
    exit 1
}

Write-Host "validate.ps1: PASSED"
