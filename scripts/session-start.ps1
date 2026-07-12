#!/usr/bin/env pwsh
# Spec Jedi session-start orientation hook (Constitution Principle XXI).
# Native PowerShell counterpart of session-start.sh (Constitution Principle
# XIII). Emits an ASCII banner + on-disk-derived project status summary +
# a rotating Master Yoda greeting line as SessionStart additionalContext.
# MUST NOT block session start on any failure -- every step degrades
# gracefully (FR-007). Deliberately does not use $ErrorActionPreference =
# 'Stop': a single missing file must produce a plainer greeting, not a
# terminating error that could interfere with session startup.

try {
    $repoRoot = Split-Path -Parent $PSScriptRoot
    Set-Location $repoRoot
} catch {
    exit 0
}

# --- Part 1: ASCII banner -------------------------------------------------
# Original Spec Jedi wordmark + lightsaber motif. Never a reproduction of
# GitHub's actual spec-kit logo or any other real trademark (Principle XXI).
$banner = @"
  ┌──────────────────────────────────────────┐
  │   ⚔══════  S P E C   J E D I  ══════⚔     │
  │        Spec-Driven Development, sharpened   │
  └──────────────────────────────────────────┘
"@

# --- Part 2: status summary (reuses specjedi-status's own derivation) ----
$specsDir = Join-Path $repoRoot "specs"
$total = 0
$nSpecified = 0
$nPlanned = 0
$nInProgress = 0
$nComplete = 0
$nNotStarted = 0

if (Test-Path $specsDir) {
    $featureDirs = Get-ChildItem -Path $specsDir -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^\d{3}-' }

    foreach ($dir in $featureDirs) {
        $total++
        $tasksFile = Join-Path $dir.FullName "tasks.md"
        $planFile = Join-Path $dir.FullName "plan.md"
        $specFile = Join-Path $dir.FullName "spec.md"

        if (Test-Path $tasksFile) {
            $content = Get-Content $tasksFile -ErrorAction SilentlyContinue
            $totalCb = ($content | Select-String -Pattern '^\s*-\s*\[[ Xx]\]').Count
            $doneCb = ($content | Select-String -Pattern '^\s*-\s*\[[Xx]\]').Count
            if ($totalCb -le 0) {
                $pct = 0
            } else {
                $pct = [math]::Floor(($doneCb * 100) / $totalCb)
            }
            if ($pct -eq 100) {
                $nComplete++
            } elseif ($pct -eq 0) {
                $nNotStarted++
            } else {
                $nInProgress++
            }
        } elseif (Test-Path $planFile) {
            $nPlanned++
        } elseif (Test-Path $specFile) {
            $nSpecified++
        }
    }
}

if ($total -eq 0) {
    $statusLine = "No features yet -- run specjedi-onboard or specjedi-specify to start."
} else {
    $statusLine = "$total feature(s): $nComplete complete, $nInProgress in progress, $nPlanned planned, $nSpecified specified, $nNotStarted not started."
}

# --- Part 3: rotating Master Yoda line -------------------------------------
# Context-aware, same as session-start.sh: a line written for the "no specs
# yet" state must never be selected when the status summary above already
# reports real features -- that would directly contradict it. Rotation-pool
# entries are word-wrapped across two physical lines in the source markdown,
# so continuation lines are joined before extracting the quoted text (same
# fix ported from session-start.sh's own real dry run).
$lexicon = Join-Path $repoRoot "references/star-wars-lexicon.md"
$yodaLine = "Welcome back. Ready to build, are you."

if (Test-Path $lexicon) {
    try {
        $lines = Get-Content $lexicon -ErrorAction Stop
        $inSection = $false
        $entries = @()
        $current = ""

        foreach ($l in $lines) {
            if ($l -match '^## Master Yoda Persona') { $inSection = $true; continue }
            if ($l -match '^## Situation') { $inSection = $false }
            if (-not $inSection) { continue }
            if ($l -match '^- "') {
                if ($current -ne "") { $entries += $current }
                $current = $l
            } elseif ($current -ne "" -and $l -match '^  ') {
                $current += " " + ($l -replace '^\s+', '')
            }
        }
        if ($current -ne "") { $entries += $current }

        $allYodaLines = $entries | ForEach-Object {
            if ($_ -match '^- "([^"]*)"') { $matches[1] }
        }

        $yodaLines = @()
        foreach ($line in $allYodaLines) {
            $isEmptyOnly = $line -like "*Empty, this project*"
            if ($total -eq 0 -and $isEmptyOnly) {
                $yodaLines += $line
            } elseif ($total -gt 0 -and -not $isEmptyOnly) {
                $yodaLines += $line
            }
        }

        if ($yodaLines.Count -gt 0) {
            $idx = [int][DateTimeOffset]::UtcNow.ToUnixTimeSeconds() % $yodaLines.Count
            $yodaLine = $yodaLines[$idx]
        }
    } catch {
        # Degrade gracefully -- keep the default $yodaLine
    }
}

# --- Assemble and emit ------------------------------------------------------
Write-Output $banner
Write-Output ""
Write-Output $statusLine
Write-Output ""
Write-Output $yodaLine

exit 0
