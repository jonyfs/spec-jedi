#!/usr/bin/env pwsh
# Native PowerShell counterpart of statusline.sh (Constitution Principle
# XIII -- every .sh ships with an equivalent .ps1). See statusline.sh
# for the full rationale (specs/040-aitmpl-settings-improvements);
# logic mirrored exactly, no jq/external JSON-parser dependency.
#
# Windows dispatch: Claude Code runs statusLine.command through Git Bash
# when installed, or PowerShell when Git Bash is absent
# (code.claude.com/docs/en/statusline, "Windows configuration"). This
# file is the manual-swap target for the Windows-without-Git-Bash case
# -- see references/session-start-hook-guide.md for the same pattern
# already established for the SessionStart hook.

$ErrorActionPreference = 'Stop'
$input_json = [Console]::In.ReadToEnd()

$model = ''
if ($input_json -match '"display_name"\s*:\s*"([^"]*)"') {
    $model = $matches[1]
}

$dir = ''
if ($input_json -match '"current_dir"\s*:\s*"([^"]*)"') {
    $dir = $matches[1]
}

$folder = Split-Path $dir -Leaf -ErrorAction SilentlyContinue
if (-not $folder) { $folder = $dir }

$branch = ''
if ($dir -and (git -C $dir rev-parse --git-dir 2>$null)) {
    $b = (git -C $dir branch --show-current 2>$null)
    $changesRaw = (git -C $dir status --porcelain 2>$null)
    $changes = 0
    if ($changesRaw) { $changes = ($changesRaw | Measure-Object -Line).Lines }
    $branch = " | 🌿 $b"
    if ($changes -gt 0) {
        $branch = "$branch ($changes)"
    }
}

Write-Output "[$model] 📁 $folder$branch"
