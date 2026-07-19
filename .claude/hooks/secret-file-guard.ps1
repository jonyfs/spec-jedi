#!/usr/bin/env pwsh
# PreToolUse hook (Read|Grep|Glob): PowerShell counterpart of
# secret-file-guard.sh -- identical matching logic and rationale, see
# that file's own header comment (specs/058-expand-shareable-hooks).
$ErrorActionPreference = 'Stop'
$input_json = [Console]::In.ReadToEnd()

$toolName = $null
if ($input_json -match '"tool_name"\s*:\s*"([^"]*)"') {
    $toolName = $matches[1]
}

$target = $null
switch ($toolName) {
    'Read' {
        if ($input_json -match '"file_path"\s*:\s*"([^"]*)"') { $target = $matches[1] }
    }
    { $_ -in 'Grep', 'Glob' } {
        if ($input_json -match '"path"\s*:\s*"([^"]*)"') { $target = $matches[1] }
    }
    default { exit 0 }
}

if ([string]::IsNullOrEmpty($target)) { exit 0 }

function Deny($reason) {
    $output = @{ hookSpecificOutput = @{ hookEventName = "PreToolUse"; permissionDecision = "deny"; permissionDecisionReason = $reason } } | ConvertTo-Json -Compress
    Write-Output $output
    exit 0
}

# Compound (directory/file) patterns -- matched by path suffix, never by
# basename alone (see secret-file-guard.sh's own comment for why).
$normalized = $target -replace '\\', '/'
if ($normalized -match '(^|/)\.aws/credentials$') {
    Deny "Blocked: reading what looks like a real secret/credential file (.aws/credentials)."
}
if ($normalized -match '(^|/)\.docker/config\.json$') {
    Deny "Blocked: reading what looks like a real secret/credential file (.docker/config.json)."
}

$base = Split-Path $target -Leaf -ErrorAction SilentlyContinue
if (-not $base) { $base = $target }

if ($base -in @('.env.example', '.env.sample', '.env.template')) {
    exit 0
}
if ($base -eq '.env' -or $base -like '.env.*') {
    Deny "Blocked: reading what looks like a real secret/credential file. If this is actually a template (.env.example etc.), rename or rephrase the request."
}
if ($base -in @('id_rsa', 'id_dsa', 'id_ecdsa', 'id_ed25519')) {
    Deny "Blocked: reading what looks like a real SSH private key."
}
if ($base -like '*.pem' -or $base -like '*.key' -or $base -like '*.pfx' -or $base -like '*.p12') {
    Deny "Blocked: reading what looks like a real certificate/key file."
}
if ($base -in @('.npmrc', '.netrc', '.pgpass', '.git-credentials')) {
    Deny "Blocked: reading what looks like a real credential file."
}

exit 0
