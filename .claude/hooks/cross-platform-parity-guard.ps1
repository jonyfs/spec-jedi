#!/usr/bin/env pwsh
# PostToolUse hook (Write|Edit|MultiEdit): native PowerShell counterpart of
# cross-platform-parity-guard.sh (Constitution Principle XIII -- every .sh
# ships with an equivalent .ps1). See cross-platform-parity-guard.sh for the
# full rationale; logic mirrored exactly.

$ErrorActionPreference = 'Stop'
$input_json = [Console]::In.ReadToEnd()

if ($input_json -match '"file_path"\s*:\s*"([^"]*)"') {
    $filePath = $matches[1]
} else {
    exit 0
}

if ($filePath -match '[/\\]scripts[/\\][^/\\]+\.sh$') {
    $counterpart = $filePath -replace '\.sh$', '.ps1'
} elseif ($filePath -match '[/\\]scripts[/\\][^/\\]+\.ps1$') {
    $counterpart = $filePath -replace '\.ps1$', '.sh'
} else {
    exit 0
}

if (-not (Test-Path $filePath)) { exit 0 }
if (Test-Path $counterpart) { exit 0 }

$contextText = "$(Split-Path $filePath -Leaf) has no sibling $(Split-Path $counterpart -Leaf) in the same directory -- Constitution Principle XIII requires both in the same change set. Add $(Split-Path $counterpart -Leaf) with equivalent behavior before this is done."

$output = @{
    hookSpecificOutput = @{
        hookEventName    = "PostToolUse"
        additionalContext = $contextText
    }
} | ConvertTo-Json -Depth 5 -Compress

Write-Output $output
exit 0
