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

# --- Part 2.5: next-step suggestion (specs/054, extends Part 2's own -----
# derivation -- never a second, separately-maintained tracking mechanism,
# per Constitution Principle XXI's own "no parallel status system" rule).
# A hook script cannot invoke an LLM-interpreted specjedi-status skill
# directly, so this reimplements that skill's own "most relevant" priority
# order in PowerShell, matching session-start.sh's own identical logic.
# Priority: in-progress (most recent tasks.md) > planned-not-tasked (most
# recent plan.md) > specified-not-planned (most recent spec.md) > none.
$nextStepLine = ""
if ($total -gt 0) {
    function Get-MostRecentFeature($fileName) {
        $best = $null
        $bestTime = [DateTime]::MinValue
        foreach ($dir in $featureDirs) {
            $f = Join-Path $dir.FullName $fileName
            if (Test-Path $f) {
                $mtime = (Get-Item $f).LastWriteTimeUtc
                if ($mtime -gt $bestTime) {
                    $bestTime = $mtime
                    $best = $dir.Name
                }
            }
        }
        return $best
    }

    if ($nInProgress -gt 0 -or $nNotStarted -gt 0) {
        $feat = Get-MostRecentFeature "tasks.md"
        if ($feat) { $nextStepLine = "Next step: $feat has a task breakdown ready -- run specjedi-implement to continue it." }
    }
    if (-not $nextStepLine -and $nPlanned -gt 0) {
        $feat = Get-MostRecentFeature "plan.md"
        if ($feat) { $nextStepLine = "Next step: $feat is planned but not yet broken into tasks -- run specjedi-tasks." }
    }
    if (-not $nextStepLine -and $nSpecified -gt 0) {
        $feat = Get-MostRecentFeature "spec.md"
        if ($feat) { $nextStepLine = "Next step: $feat is specified -- run specjedi-clarify or specjedi-plan." }
    }
}
if (-not $nextStepLine) {
    $nextStepLine = "Next step: run specjedi-specify to start a new feature."
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

# --- Part 4: skill freshness check (Constitution Principle XXII) -----------
# Advisory-only: any incomplete state (no marker, malformed marker, the
# "local-checkout" sentinel, unreachable/rate-limited API) degrades
# silently to an empty $freshnessLine -- never an error, never a guess.
# Single attempt, short explicit timeout -- deliberately NOT
# bootstrap-install.ps1's own retry loop (specs/042 research.md Decision
# 3): that loop has no per-attempt cap and would make every session
# start's worst case unbounded.
$freshnessLine = ""
$marker = Join-Path $repoRoot ".specify/release-marker.json"
if (Test-Path $marker) {
    try {
        $markerJson = Get-Content $marker -Raw | ConvertFrom-Json
        $installed = $markerJson.installed_release
        if ($installed -and $installed -ne "local-checkout") {
            $headers = @{}
            if ($env:GITHUB_TOKEN) {
                $headers["Authorization"] = "Bearer $($env:GITHUB_TOKEN)"
            }
            $release = Invoke-RestMethod -Uri "https://api.github.com/repos/jonyfs/spec-jedi/releases/latest" -Headers $headers -TimeoutSec 2 -ErrorAction Stop
            $latest = $release.tag_name
            if ($latest -and $latest -ne $installed) {
                $freshnessLine = "Update available: $installed installed, $latest published -- ask whether to update now (specs/055); on yes, run scripts/bootstrap-install.sh/.ps1 (now backs up any locally-modified skill/template file first, specs/055 User Story 1); on no, do nothing further this session."
            }
        }
    } catch {
        # Degrade silently -- malformed marker, unreachable API, timeout,
        # rate limit: none of these should ever surface as an error here.
    }
}

# --- Assemble and emit ------------------------------------------------------
# 10,000-character additionalContext cap (Principle XXI's own documented
# fact, FR-006): if the full payload would exceed it, drop the freshness
# line first (already the lowest-priority, optional element) -- never the
# new next-step suggestion or the core banner/status/Yoda trio.
$fullPayload = @($banner, "", $statusLine, "", $yodaLine, "", $nextStepLine, "", $freshnessLine) -join "`n"
$includeFreshness = $freshnessLine -and ($fullPayload.Length -le 10000)

Write-Output $banner
Write-Output ""
Write-Output $statusLine
Write-Output ""
Write-Output $yodaLine
Write-Output ""
Write-Output $nextStepLine
if ($includeFreshness) {
    Write-Output ""
    Write-Output $freshnessLine
}

exit 0
