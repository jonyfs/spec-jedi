#!/usr/bin/env pwsh
# PreToolUse hook (Bash): native PowerShell counterpart of
# dangerous-command-guard.sh (Constitution Principle XIII -- every .sh ships
# with an equivalent .ps1). See dangerous-command-guard.sh for the full
# rationale and for why this is tokenized rather than substring-matched:
# an earlier draft's `-match 'rm -rf /(\*|\s|$)'` looked boundary-safe but
# the home-directory pattern `'rm -rf (~|\$HOME|...)'` had no trailing
# boundary at all and would have blocked `rm -rf ~/Downloads/tempstuff`;
# tokenizing and comparing whole words is what actually gets this right,
# mirrored here exactly from the bash version's word-by-word logic.

$ErrorActionPreference = 'Stop'
$input_json = [Console]::In.ReadToEnd()

if ($input_json -match '"command"\s*:\s*"([^"]*)"') {
    $command = $matches[1]
} else {
    exit 0
}

if ([string]::IsNullOrEmpty($command)) { exit 0 }

function Deny($reason) {
    $output = @{
        hookSpecificOutput = @{
            hookEventName       = "PreToolUse"
            permissionDecision  = "deny"
            permissionDecisionReason = $reason
        }
    } | ConvertTo-Json -Depth 5 -Compress
    Write-Output $output
    exit 0
}

$words = $command -split '\s+' | Where-Object { $_ -ne '' }

$hasRm = $false
$hasRecursiveForce = $false
$hasGit = $false
$hasPush = $false
$hasForceFlag = $false
$hasMainOrMaster = $false
$readCmd = $false

foreach ($w in $words) {
    switch -Exact ($w) {
        'rm' { $hasRm = $true }
        'git' { $hasGit = $true }
        'push' { $hasPush = $true }
        '--force' { $hasForceFlag = $true }
        '--force-with-lease' { $hasForceFlag = $true }
        '-f' { $hasForceFlag = $true }
        'main' { $hasMainOrMaster = $true }
        'master' { $hasMainOrMaster = $true }
        'main:main' { $hasMainOrMaster = $true }
        'master:master' { $hasMainOrMaster = $true }
        'cat' { $readCmd = $true }
        'head' { $readCmd = $true }
        'tail' { $readCmd = $true }
        'less' { $readCmd = $true }
        'more' { $readCmd = $true }
        default {
            # Short-option cluster containing BOTH r/R and f (order-
            # independent): matches -rf/-fr/-Rf/-vrf and similar, but never
            # a long --force/--recursive, which would otherwise each
            # satisfy half of "contains r and f" on their own and produce
            # a false positive.
            if ($w -match '^-[^-]' -and $w -match '[rR]' -and $w -match 'f') {
                $hasRecursiveForce = $true
            }
        }
    }

    if ($hasRm -and $hasRecursiveForce) {
        if ($w -eq '/' -or $w -eq '/*') {
            Deny "Blocked: rm -rf targeting the filesystem root."
        }
        if ($w -eq '~' -or $w -eq '$HOME' -or $w -eq '${HOME}') {
            Deny "Blocked: rm -rf targeting the home directory."
        }
    }
}

if ($hasGit -and $hasPush -and $hasForceFlag -and $hasMainOrMaster) {
    Deny "Blocked: force-push to main/master. This project's own git-workflow discipline (and specjedi-implement's Never list) forbids force-pushing the trunk branch."
}

if ($readCmd) {
    foreach ($w in $words) {
        $base = Split-Path $w -Leaf -ErrorAction SilentlyContinue
        if (-not $base) { $base = $w }
        if ($base -in @('.env.example', '.env.sample', '.env.template')) { continue }
        if ($base -in @('.env', 'id_rsa', 'id_ed25519') -or $base -like '*.pem') {
            Deny "Blocked: reading what looks like a real secret/credential file. If this is actually a template (.env.example etc.), rename or rephrase the command."
        }
    }
}

exit 0
