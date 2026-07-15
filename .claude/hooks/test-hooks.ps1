#!/usr/bin/env pwsh
# Native PowerShell counterpart of test-hooks.sh (Constitution Principle
# XIII -- every .sh in this repo ships with an equivalent .ps1, including
# this repo's own dev tooling, not just scripts/). Exercises the .ps1 hook
# files directly; see test-hooks.sh for the full rationale.

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$hooksDir = Join-Path $repoRoot ".claude/hooks"
$script:failCount = 0

function Test-Pass($msg) { Write-Host "  PASS: $msg" }
function Test-Fail($msg) { Write-Host "  FAIL: $msg"; $script:failCount++ }

function Invoke-Hook($scriptPath, $jsonInput) {
    $jsonInput | pwsh -NoProfile -File $scriptPath
}

Write-Host "=== skill-quality-guard.ps1 ==="

Get-ChildItem (Join-Path $repoRoot ".claude/skills") -Directory -Filter "specjedi-*" | ForEach-Object {
    $skillFile = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skillFile) {
        $input_json = @{ tool_name = "Write"; tool_input = @{ file_path = $skillFile } } | ConvertTo-Json -Compress
        $out = Invoke-Hook (Join-Path $hooksDir "skill-quality-guard.ps1") $input_json
        if ($out) { Test-Fail "real SKILL.md flagged (false positive): $($_.Name)" }
    }
}
Test-Pass "every real specjedi-*/SKILL.md is silent (no false positives)"

$tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Force -Path (Join-Path $tmpDir ".claude/skills/specjedi-fake") | Out-Null
$badFile = Join-Path $tmpDir ".claude/skills/specjedi-fake/SKILL.md"
"No frontmatter, no Always/Never section at all." | Set-Content $badFile
$input_json = @{ tool_name = "Write"; tool_input = @{ file_path = $badFile } } | ConvertTo-Json -Compress
$out = Invoke-Hook (Join-Path $hooksDir "skill-quality-guard.ps1") $input_json
try {
    $decoded = $out | ConvertFrom-Json
    if ($decoded.hookSpecificOutput.additionalContext -match '(?i)frontmatter') {
        Test-Pass "malformed SKILL.md correctly flagged with valid JSON"
    } else {
        Test-Fail "malformed SKILL.md flagged but context missing expected text: $out"
    }
} catch {
    Test-Fail "malformed SKILL.md should have produced valid JSON, got: $out"
}
Remove-Item -Recurse -Force $tmpDir

Write-Host "=== cross-platform-parity-guard.ps1 ==="

$input_json = @{ tool_name = "Write"; tool_input = @{ file_path = (Join-Path $repoRoot "scripts/install.sh") } } | ConvertTo-Json -Compress
$out = Invoke-Hook (Join-Path $hooksDir "cross-platform-parity-guard.ps1") $input_json
if (-not $out) { Test-Pass "install.sh (has .ps1) is silent" } else { Test-Fail "install.sh should be silent, got: $out" }

$tmpScripts = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName()) "scripts"
New-Item -ItemType Directory -Force -Path $tmpScripts | Out-Null
$lonely = Join-Path $tmpScripts "lonely.sh"
New-Item -ItemType File -Path $lonely | Out-Null
$input_json = @{ tool_name = "Write"; tool_input = @{ file_path = $lonely } } | ConvertTo-Json -Compress
$out = Invoke-Hook (Join-Path $hooksDir "cross-platform-parity-guard.ps1") $input_json
if ($out) { Test-Pass "orphan .sh with no .ps1 sibling correctly flagged" } else { Test-Fail "orphan .sh should have been flagged" }
Remove-Item -Recurse -Force (Split-Path $tmpScripts -Parent)

Write-Host "=== dangerous-command-guard.ps1 ==="

function Test-Command($desc, $cmd, $expect) {
    $input_json = @{ tool_name = "Bash"; tool_input = @{ command = $cmd } } | ConvertTo-Json -Compress
    $out = Invoke-Hook (Join-Path $hooksDir "dangerous-command-guard.ps1") $input_json
    if ($expect -eq "allow") {
        if (-not $out) { Test-Pass $desc } else { Test-Fail "$desc (should allow, got: $out)" }
    } else {
        if ($out) { Test-Pass $desc } else { Test-Fail "$desc (should block, was allowed)" }
    }
}

# False positives this matrix was written to catch during authoring:
Test-Command "temp dir cleanup allowed" 'rm -rf /tmp/scratch-dir-abc123' "allow"
Test-Command "cwd relative cleanup allowed" 'rm -rf ./build' "allow"
Test-Command "home subfolder cleanup allowed" 'rm -rf ~/Downloads/tempstuff' "allow"
Test-Command "ordinary git push allowed" 'git push origin feature-branch' "allow"
Test-Command "force push to non-trunk branch allowed" 'git push --force origin feature/rewrite-history' "allow"
Test-Command "force push to branch containing 'main' substring allowed" 'git push --force origin domain-migration' "allow"
Test-Command "cat .env.example allowed" 'cat .env.example' "allow"
Test-Command "cat unrelated *environment* file allowed" 'cat myenvironment.txt' "allow"

# True positives:
Test-Command "root wipe blocked" 'rm -rf /' "block"
Test-Command "root wipe wildcard blocked" 'rm -rf /*' "block"
Test-Command "root wipe -fr order blocked" 'rm -fr /' "block"
Test-Command "home wipe tilde blocked" 'rm -rf ~' "block"
Test-Command 'home wipe $HOME blocked' 'rm -rf $HOME' "block"
Test-Command "force push main blocked" 'git push --force origin main' "block"
Test-Command "force push -f master blocked" 'git push -f origin master' "block"
Test-Command "cat real .env blocked" 'cat .env' "block"
Test-Command "cat id_rsa blocked" 'cat ~/.ssh/id_rsa' "block"
Test-Command "cat .pem blocked" 'cat server.pem' "block"

Write-Host ""
if ($script:failCount -eq 0) {
    Write-Host "All hook tests passed."
    exit 0
} else {
    Write-Host "One or more hook tests FAILED -- see above."
    exit 1
}
