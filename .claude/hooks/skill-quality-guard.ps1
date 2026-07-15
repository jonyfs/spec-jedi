#!/usr/bin/env pwsh
# PostToolUse hook (Write|Edit|MultiEdit): native PowerShell counterpart of
# skill-quality-guard.sh (Constitution Principle XIII -- every .sh ships
# with an equivalent .ps1). See skill-quality-guard.sh for the full
# rationale; logic mirrored exactly.

$ErrorActionPreference = 'Stop'
$input_json = [Console]::In.ReadToEnd()

if ($input_json -match '"file_path"\s*:\s*"([^"]*)"') {
    $filePath = $matches[1]
} else {
    exit 0
}

if ($filePath -notmatch '[/\\]\.claude[/\\]skills[/\\]specjedi-[^/\\]+[/\\]SKILL\.md$') {
    exit 0
}

if (-not (Test-Path $filePath)) {
    exit 0
}

$content = Get-Content -Raw $filePath
$lines = Get-Content $filePath
$issues = @()

if ($lines[0] -ne '---') {
    $issues += "Missing YAML frontmatter: file must start with `---` (Principle XIX Structure)."
}
if ($content -notmatch '(?m)^name:\s*\S+') {
    $issues += "Frontmatter missing ``name:`` (Principle XIX Structure)."
}
if ($content -notmatch '(?m)^description:\s*\S+') {
    $issues += "Frontmatter missing ``description:`` (Principle XIX Structure)."
}

# Word-count * 1.3 is a common rough token-count heuristic, not a real
# tokenizer -- good enough for a soft edit-time warning; specjedi-tokencheck
# and the actual CI battery are the authoritative checks.
$wordCount = ($content -split '\s+' | Where-Object { $_ -ne '' }).Count
$approxTokens = [math]::Floor($wordCount * 1.3)
if ($approxTokens -gt 5000) {
    $issues += "Approx. $approxTokens tokens (word-count heuristic) -- Principle XIX caps SKILL.md at roughly 5,000; move detail to references/ (progressive disclosure)."
}

if ($content -notmatch '(?i)\*\*Always\*\*|## Always' -or $content -notmatch '(?i)\*\*Never\*\*|## Never') {
    $issues += "No clear Always-Do/Never-Do guardrail section found (Principle XIX)."
}

if ($issues.Count -eq 0) {
    exit 0
}

$skillName = Split-Path (Split-Path $filePath -Parent) -Leaf
$contextText = "Skill authoring standard check on $skillName/SKILL.md found:`n" + (($issues | ForEach-Object { "- $_" }) -join "`n") + "`nFix before considering this skill done (Constitution Principle XIX)."

$output = @{
    hookSpecificOutput = @{
        hookEventName    = "PostToolUse"
        additionalContext = $contextText
    }
} | ConvertTo-Json -Depth 5 -Compress

Write-Output $output
exit 0
