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
Test-Command "cat .npmrc blocked" 'cat .npmrc' "block"
Test-Command "cat .aws/credentials blocked" 'cat ~/.aws/credentials' "block"
Test-Command "cat .docker/config.json blocked" 'cat ~/.docker/config.json' "block"

Write-Host "=== conventional-commits.py (specs/058-expand-shareable-hooks, T041) ==="

function Test-CommitMsg($desc, $cmd, $expect) {
    $input_json = @{ tool_name = "Bash"; tool_input = @{ command = $cmd } } | ConvertTo-Json -Compress
    $out = $input_json | python3 (Join-Path $hooksDir "conventional-commits.py")
    if ($expect -eq "allow") {
        if (-not $out) { Test-Pass $desc } else { Test-Fail "$desc (should allow, got: $out)" }
    } else {
        if ($out) { Test-Pass $desc } else { Test-Fail "$desc (should block, was allowed)" }
    }
}

Test-CommitMsg "non-conventional message blocked" 'git commit -m "fixed a thing"' "block"
Test-CommitMsg "conventional feat: message allowed" 'git commit -m "feat: add user authentication"' "allow"
Test-CommitMsg "conventional fix(scope): message allowed" 'git commit -m "fix(api): handle null responses"' "allow"
Test-CommitMsg "non-commit command allowed (nothing to check)" 'git status' "allow"

Write-Host "=== secret-file-guard.ps1 (specs/058-expand-shareable-hooks, T027) ==="

function Test-Guard($desc, $tool, $field, $value, $expect) {
    $toolInput = @{}
    $toolInput[$field] = $value
    $input_json = @{ tool_name = $tool; tool_input = $toolInput } | ConvertTo-Json -Compress
    $out = Invoke-Hook (Join-Path $hooksDir "secret-file-guard.ps1") $input_json
    if ($expect -eq "allow") {
        if (-not $out) { Test-Pass $desc } else { Test-Fail "$desc (should allow, got: $out)" }
    } else {
        if ($out) { Test-Pass $desc } else { Test-Fail "$desc (should block, was allowed)" }
    }
}

Test-Guard "root .env denied" "Read" "file_path" "/tmp/some-project/.env" "block"
Test-Guard "nested .env denied (SC-005)" "Read" "file_path" "/tmp/some-project/packages/api/.env" "block"
Test-Guard ".env.example allowed (SC-006)" "Read" "file_path" "/tmp/some-project/.env.example" "allow"
Test-Guard ".env.sample allowed" "Read" "file_path" "/tmp/some-project/.env.sample" "allow"
Test-Guard "unrelated file allowed" "Read" "file_path" "/tmp/some-project/README.md" "allow"
Test-Guard "id_rsa denied" "Read" "file_path" "/home/user/.ssh/id_rsa" "block"
Test-Guard "id_ed25519 denied" "Read" "file_path" "/home/user/.ssh/id_ed25519" "block"
Test-Guard "*.pem denied" "Read" "file_path" "/tmp/some-project/server.pem" "block"
Test-Guard ".npmrc denied" "Read" "file_path" "/tmp/some-project/.npmrc" "block"
Test-Guard ".aws/credentials denied" "Read" "file_path" "/home/user/.aws/credentials" "block"
Test-Guard "Grep on a specific .env file denied" "Grep" "path" "/tmp/some-project/.env" "block"
Test-Guard "Grep with a directory path never denied" "Grep" "path" "/tmp/some-project" "allow"
Test-Guard "Glob with a directory path never denied" "Glob" "path" "/tmp/some-project" "allow"

Write-Host "=== statusline.ps1 ==="

function Invoke-Statusline($model, $dir) {
    $payload = @{ model = @{ display_name = $model }; workspace = @{ current_dir = $dir } } | ConvertTo-Json -Compress
    $payload | pwsh -NoProfile -File (Join-Path $repoRoot ".claude/statusline.ps1")
}

$tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
Push-Location $tmpDir
git init -q
git config user.email "test@example.com"
git config user.name "Test"
git checkout -q -b clean-branch
New-Item -ItemType File -Path "placeholder" | Out-Null
git add placeholder
git commit -q -m "init"
Pop-Location

$out = Invoke-Statusline "Sonnet" $tmpDir
if ($out -match '\[Sonnet\]' -and $out -match 'clean-branch') {
    if ($out -match '\(\d+\)') {
        Test-Fail "clean tree statusline should have no change count, got: $out"
    } else {
        Test-Pass "clean tree shows model, folder, and branch with no change count"
    }
} else {
    Test-Fail "clean tree statusline missing expected content: $out"
}

Add-Content -Path (Join-Path $tmpDir "placeholder") -Value "dirty"
$out = Invoke-Statusline "Sonnet" $tmpDir
if ($out -match 'clean-branch \(1\)') {
    Test-Pass "dirty tree shows a (1) change count"
} else {
    Test-Fail "dirty tree statusline missing change count: $out"
}
Remove-Item -Recurse -Force $tmpDir

$tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
$out = Invoke-Statusline "Sonnet" $tmpDir
if ($out -match '🌿') {
    Test-Fail "non-git dir statusline should have no branch segment, got: $out"
} elseif ($out -match '\[Sonnet\]') {
    Test-Pass "non-git dir degrades to model+folder, no error"
} else {
    Test-Fail "non-git dir statusline missing expected content: $out"
}
Remove-Item -Recurse -Force $tmpDir

Write-Host "=== Update-SharedSettings (scripts/install.ps1, specs/041) ==="

$installPs1 = Get-Content (Join-Path $repoRoot "scripts/install.ps1") -Raw
if ($installPs1 -notmatch '(?s)(function Update-SharedSettings \{.*?\n\})') {
    Test-Fail "could not extract Update-SharedSettings from install.ps1"
} else {
    $mergeFnSrc = $matches[1]

    function Invoke-MergeFn($fnSrc, $target) {
        $tmpScript = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName() + ".ps1")
        "$fnSrc`nUpdate-SharedSettings -Target '$target'" | Set-Content $tmpScript
        $out = & pwsh -NoProfile -File $tmpScript 2>&1
        $code = $LASTEXITCODE
        Remove-Item $tmpScript
        # Return a single object (not a stream) so the exit code and
        # output text never get mixed together in the caller's pipeline.
        return [PSCustomObject]@{ ExitCode = $code; Output = ($out -join "`n") }
    }

    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
    $target = Join-Path $tmpDir ".claude/settings.json"
    Invoke-MergeFn $mergeFnSrc $target | Out-Null
    try {
        $null = Get-Content $target -Raw | ConvertFrom-Json
        $content = Get-Content $target -Raw
        if ($content -match '"statusLine"' -and $content -match '"permissions"') {
            Test-Pass "fresh file: valid JSON with both keys"
        } else {
            Test-Fail "fresh file: missing expected keys"
        }
    } catch {
        Test-Fail "fresh file: invalid JSON"
    }
    Remove-Item -Recurse -Force $tmpDir

    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Force -Path (Join-Path $tmpDir ".claude") | Out-Null
    $target = Join-Path $tmpDir ".claude/settings.json"
    '{
  "hooks": {
    "SessionStart": [{"hooks": [{"type": "command", "command": "echo hi"}]}]
  }
}' | Set-Content $target
    Invoke-MergeFn $mergeFnSrc $target | Out-Null
    $content = Get-Content $target -Raw
    try {
        $null = $content | ConvertFrom-Json
        if ($content -match '"SessionStart"' -and $content -match '"statusLine"' -and $content -match '"permissions"') {
            Test-Pass "pre-existing unrelated content preserved, new keys added (SC-003)"
        } else {
            Test-Fail "existing-content-preserved check failed"
        }
    } catch {
        Test-Fail "merged file is not valid JSON"
    }

    $firstContent = Get-Content $target -Raw
    Invoke-MergeFn $mergeFnSrc $target | Out-Null
    $secondContent = Get-Content $target -Raw
    if ($firstContent -eq $secondContent) {
        Test-Pass "idempotent re-run: byte-identical (FR-004)"
    } else {
        Test-Fail "idempotent re-run: content changed on second run"
    }
    Remove-Item -Recurse -Force $tmpDir

    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Force -Path (Join-Path $tmpDir ".claude") | Out-Null
    $target = Join-Path $tmpDir ".claude/settings.json"
    '{ "hooks": {} ' | Set-Content $target -NoNewline
    $result = Invoke-MergeFn $mergeFnSrc $target
    if ($result.ExitCode -ne 0 -and $result.Output -match "FAIL:" -and $result.Output -match "unbalanced braces") {
        Test-Pass "malformed JSON fails loudly with a clear message, never guesses"
    } else {
        Test-Fail "malformed JSON should have failed loudly with a clear message, got exit=$($result.ExitCode) output=$($result.Output)"
    }
    Remove-Item -Recurse -Force $tmpDir
}

Write-Host ""
if ($script:failCount -eq 0) {
    Write-Host "All hook tests passed."
    exit 0
} else {
    Write-Host "One or more hook tests FAILED -- see above."
    exit 1
}
