#!/usr/bin/env pwsh
# Spec Jedi zero-footprint installer (Constitution Principle XVIII).
# Native PowerShell counterpart of install.sh (Constitution Principle XIII —
# every .sh ships with an equivalent .ps1). Copies the specjedi-* product
# skills (never speckit-* bootstrap tooling) into a target project, plus the
# .specify/templates/*.md files those skills depend on at runtime.
#
# Two install modes, chosen per -Harness (Principle III's 20-harness
# compatibility matrix, specs/023-full-harness-coverage/research.md):
#   1. skills-dir: the harness natively scans a directory of SKILL.md
#      packages (claude-code, codex-cli, trae, antigravity).
#   2. bridge: the harness only reads a project-root rules file, a small
#      directory of rule files, or (Cody) a custom-commands JSON file. The
#      full specjedi-* packages are still copied to .claude/skills/ as the
#      canonical source; a generated bridge file / set of files points
#      into it so the harness's own native mechanism can find them.

param(
    [string]$TargetDir = ".",
    [string]$Harness = "",
    [switch]$Auto,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help) {
    Write-Host "Usage: install.ps1 [-TargetDir DIR] [-Harness HARNESS] [-Auto]"
    Write-Host ""
    Write-Host "  -TargetDir   Project to install Spec Jedi's specjedi-* skills into."
    Write-Host "               Defaults to the current directory."
    Write-Host "  -Harness     Which coding agent to configure for. All 20 harnesses in"
    Write-Host "               Constitution Principle III's compatibility matrix are"
    Write-Host "               supported: claude-code, codex-cli, trae, antigravity"
    Write-Host "               (native skills-directory scanning); cursor, windsurf,"
    Write-Host "               copilot, gemini-cli, cline, continue, aider, amazon-q,"
    Write-Host "               jetbrains-ai, zed, replit, devin, tabnine, cody (bridge"
    Write-Host "               file(s) pointing at the canonical .claude/skills/ package)."
    Write-Host "               If omitted, the installer attempts harness auto-detection"
    Write-Host "               among claude-code/codex-cli/trae (specs/021-harness-auto-detection);"
    Write-Host "               the 17 other harnesses require an explicit -Harness."
    Write-Host "  -Auto        When -Harness is omitted and detection finds more than"
    Write-Host "               one plausible harness, automatically select the"
    Write-Host "               Recommended one instead of prompting interactively"
    Write-Host "               (Constitution Principle IV's Recommended-option standard)."
    exit 0
}

$repoRoot = Split-Path -Parent $PSScriptRoot

# specs/040-interactive-install: fully-interactive mode only triggers
# when truly NO parameters were given at all (no -TargetDir, no
# -Harness, no -Auto) AND a real terminal is available to prompt
# through -- any explicit parameter, or a non-interactive context (CI,
# redirected input), preserves the exact prior default/silent-auto-
# detect behavior completely untouched. Existing scripted/CI usage
# (always passes -Harness explicitly) never triggers this.
$interactiveMode = $false
if (-not $PSBoundParameters.ContainsKey('TargetDir') -and -not $Harness -and -not $Auto -and -not [Console]::IsInputRedirected) {
    $interactiveMode = $true
}
# specs/058-expand-shareable-hooks: explicit test seam, identical
# rationale to install.sh's own SPECJEDI_TEST_FORCE_INTERACTIVE.
if ($env:SPECJEDI_TEST_FORCE_INTERACTIVE) {
    $interactiveMode = $true
}

if ($interactiveMode) {
    Write-Host "🧙 No parameters were given — let's set this up together, step by step."
    Write-Host "   (Type 'c' at any time to cancel without installing anything.)"
    Write-Host ""
    Write-Host "[1/2] Which directory should this install into?"
    $answer = Read-Host "      Current directory [$(Get-Location)], another path, or 'c' to cancel"
    if ($answer -in @("c", "C", "cancel", "Cancel")) {
        Write-Host "Installation cancelled — nothing was changed."
        exit 0
    }
    if ($answer) {
        $TargetDir = $answer
    }
    Write-Host ""
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
$TargetDir = (Resolve-Path $TargetDir).Path

# specs/040-interactive-install: presents all 18 -Harness values (the
# 20-harness compatibility matrix minus opencode/warp, which piggyback
# on claude-code/codex-cli with no separate flag) so a user in
# $interactiveMode can pick one directly instead of being forced back
# to the command line with an explicit -Harness. Returns the chosen
# value, or "cancel" if the user backs out -- callers check for that
# sentinel themselves rather than this function exiting, so a caller
# mid-flow (e.g. the one-match confirmation declining) can choose how
# to unwind.
function Show-FullHarnessList {
    Write-Host "Choose a harness (or 'c' to cancel):"
    Write-Host "   1. claude-code    -- Claude Code"
    Write-Host "   2. codex-cli      -- Codex CLI (OpenAI)"
    Write-Host "   3. trae           -- Trae"
    Write-Host "   4. antigravity    -- Antigravity (Google)"
    Write-Host "   5. cursor         -- Cursor"
    Write-Host "   6. windsurf       -- Windsurf (Codeium)"
    Write-Host "   7. cline          -- Cline"
    Write-Host "   8. continue       -- Continue"
    Write-Host "   9. amazon-q       -- Amazon Q Developer"
    Write-Host "  10. jetbrains-ai   -- JetBrains AI Assistant"
    Write-Host "  11. tabnine        -- Tabnine"
    Write-Host "  12. gemini-cli     -- Gemini CLI"
    Write-Host "  13. zed            -- Zed"
    Write-Host "  14. replit         -- Replit Agent"
    Write-Host "  15. aider          -- Aider"
    Write-Host "  16. copilot        -- GitHub Copilot (Chat/Workspace)"
    Write-Host "  17. devin          -- Devin (Cognition)"
    Write-Host "  18. cody           -- Sourcegraph Cody"
    $map = @{
        "1" = "claude-code"; "2" = "codex-cli"; "3" = "trae"; "4" = "antigravity"
        "5" = "cursor"; "6" = "windsurf"; "7" = "cline"; "8" = "continue"
        "9" = "amazon-q"; "10" = "jetbrains-ai"; "11" = "tabnine"; "12" = "gemini-cli"
        "13" = "zed"; "14" = "replit"; "15" = "aider"; "16" = "copilot"
        "17" = "devin"; "18" = "cody"
    }
    $validNames = $map.Values
    while ($true) {
        $pick = Read-Host ">"
        if ($pick -in @("c", "C", "cancel", "Cancel")) { return "cancel" }
        if ($map.ContainsKey($pick)) { return $map[$pick] }
        if ($pick -in $validNames) { return $pick }
        Write-Host "🔭 '$pick' is not a valid option."
    }
}

# Harness auto-detection (specs/021-harness-auto-detection): only runs
# when -Harness was omitted. Scoped to the three harnesses with a real
# filesystem/PATH signal; the 17 bridge-file harnesses added in
# specs/023-full-harness-coverage always require an explicit -Harness.
# Global-config checks below use $HOME (PowerShell's cross-platform
# automatic variable, resolving on Linux/macOS too) rather than
# $env:USERPROFILE, which is Windows-only and null elsewhere.
if (-not $Harness) {
    $signals = @()

    if (Test-Path (Join-Path $TargetDir ".claude")) {
        $signals += "claude-code:1:target directory ($TargetDir\.claude)"
    }
    if (Get-Command claude -ErrorAction SilentlyContinue) {
        $signals += "claude-code:2:PATH binary (claude)"
    }
    if (Test-Path (Join-Path $HOME ".claude")) {
        $signals += "claude-code:3:global config (~\.claude)"
    }

    if (Test-Path (Join-Path $TargetDir ".agents")) {
        $signals += "codex-cli:1:target directory ($TargetDir\.agents)"
    }
    if (Get-Command codex -ErrorAction SilentlyContinue) {
        $signals += "codex-cli:2:PATH binary (codex)"
    }
    if (Test-Path (Join-Path $HOME ".codex")) {
        $signals += "codex-cli:3:global config (~\.codex)"
    }

    if (Test-Path (Join-Path $TargetDir ".trae")) {
        $signals += "trae:1:target directory ($TargetDir\.trae)"
    }
    # trae has no established cross-platform PATH binary to check
    # (it's a GUI-first IDE) -- see specs/021-harness-auto-detection/research.md
    if (Test-Path (Join-Path $HOME ".trae")) {
        $signals += "trae:3:global config (~\.trae)"
    }

    $ranks = @{ "claude-code" = $null; "codex-cli" = $null; "trae" = $null }
    $evidence = @{ "claude-code" = $null; "codex-cli" = $null; "trae" = $null }

    foreach ($sig in $signals) {
        $parts = $sig -split ":", 3
        $sigHarness = $parts[0]
        $sigRank = [int]$parts[1]
        $sigEvidence = $parts[2]
        if ($null -eq $ranks[$sigHarness] -or $sigRank -lt $ranks[$sigHarness]) {
            $ranks[$sigHarness] = $sigRank
            $evidence[$sigHarness] = $sigEvidence
        }
    }

    $matched = @($ranks.Keys | Where-Object { $null -ne $ranks[$_] })

    if ($matched.Count -eq 0) {
        if ($interactiveMode) {
            Write-Host "[2/2] No harness was detected automatically."
            $Harness = Show-FullHarnessList
            if ($Harness -eq "cancel") {
                Write-Host "Installation cancelled — nothing was changed."
                exit 0
            }
        }
        else {
            $Harness = "claude-code"
            Write-Host "🔭 No harness detected on this machine/target directory — falling"
            Write-Host "back to the default: claude-code (this is a fallback, not a"
            Write-Host "detected match)."
        }
    }
    elseif ($matched.Count -eq 1) {
        $detectedHarness = $matched[0]
        $detectedEvidence = $evidence[$detectedHarness]
        if ($interactiveMode) {
            Write-Host "[2/2] Detected $detectedHarness ($detectedEvidence)."
            $confirm = Read-Host "      Install for $detectedHarness? [Y/n, or 'c' to cancel]"
            if ($confirm -in @("n", "N", "no", "No")) {
                $Harness = Show-FullHarnessList
                if ($Harness -eq "cancel") {
                    Write-Host "Installation cancelled — nothing was changed."
                    exit 0
                }
            }
            elseif ($confirm -in @("c", "C", "cancel", "Cancel")) {
                Write-Host "Installation cancelled — nothing was changed."
                exit 0
            }
            else {
                $Harness = $detectedHarness
            }
        }
        else {
            $Harness = $detectedHarness
            Write-Host "🔭 Detected $detectedHarness ($detectedEvidence) — installing automatically."
        }
    }
    else {
        $priorityOrder = @("claude-code", "codex-cli", "trae")
        $recommended = $null
        $recommendedRank = 999
        foreach ($cand in $priorityOrder) {
            if ($null -ne $ranks[$cand] -and $ranks[$cand] -lt $recommendedRank) {
                $recommended = $cand
                $recommendedRank = $ranks[$cand]
            }
        }

        if ($Auto -or [Console]::IsInputRedirected) {
            $Harness = $recommended
            Write-Host "🔭 Multiple harnesses detected — auto-selecting Recommended:"
            Write-Host "$recommended (-Auto passed, or no interactive terminal available)."
        }
        else {
            Write-Host "🔭 Multiple harnesses detected on this machine/target directory:"
            $letters = @("A", "B", "C")
            $idx = 0
            $letterMap = @{}
            foreach ($cand in $priorityOrder) {
                if ($null -ne $ranks[$cand]) {
                    $letter = $letters[$idx]
                    $letterMap[$letter] = $cand
                    if ($cand -eq $recommended) {
                        Write-Host "  $letter. $cand (Recommended — $($evidence[$cand]))"
                    }
                    else {
                        Write-Host "  $letter. $cand ($($evidence[$cand]))"
                    }
                    $idx++
                }
            }
            $recommendedLetter = ($letterMap.Keys | Where-Object { $letterMap[$_] -eq $recommended })
            $choice = Read-Host "Choice [$recommendedLetter] (or 'c' to cancel)"
            if (-not $choice) { $choice = $recommendedLetter }
            if ($choice -in @("c", "C", "cancel", "Cancel")) {
                Write-Host "Installation cancelled — nothing was changed."
                exit 0
            }
            $Harness = $recommended
            foreach ($letter in $letterMap.Keys) {
                if ($choice -eq $letter -or $choice -eq $letterMap[$letter]) {
                    $Harness = $letterMap[$letter]
                }
            }
        }
    }
}

# specs/041-release-hooks-settings: shareable hooks/settings (the
# generic safety hook + git-aware permissions, never the two
# repo-internal-only hooks) default on for every non-interactive
# invocation (FR-001c); an interactive session gets asked once, as part
# of the same summary/confirmation moment, not a separate later prompt.
$installSharedHooks = $true
# specs/058-expand-shareable-hooks (User Story 3, FR-003): explicit
# opt-in only, via its own separate prompt, defaulting to declined
# ([y/N]). Never installed on a non-interactive run.
$installConventionalCommits = $false

# specs/058-expand-shareable-hooks: explicit test seam, identical
# rationale to install.sh's own SPECJEDI_TEST_FORCE_HOOKS_PROMPT --
# scoped to this block only, never the global $interactiveMode (which
# would also re-trigger the earlier directory/harness wizard prompts).
$forceHooksPrompt = [bool]$env:SPECJEDI_TEST_FORCE_HOOKS_PROMPT
if ($interactiveMode -or $forceHooksPrompt) {
    Write-Host ""
    Write-Host "Summary:"
    Write-Host "  Directory: $TargetDir"
    Write-Host "  Harness:   $Harness"
    $hooksAnswer = Read-Host "Also install shareable hooks/settings (safety hook, git-aware permissions)? [Y/n]"
    if ($hooksAnswer -in @("n", "N", "no", "No")) {
        $installSharedHooks = $false
    }
    if ($installSharedHooks) {
        $ccAnswer = Read-Host "Also install conventional-commits.py (enforces 'type: description' commit messages)? [y/N]"
        if ($ccAnswer -in @("y", "Y", "yes", "Yes")) {
            $installConventionalCommits = $true
        }
    }
    $proceed = Read-Host "Continue with installation? [Y/n]"
    if ($proceed -in @("n", "N", "no", "No")) {
        Write-Host "Installation cancelled — nothing was changed."
        exit 0
    }
    Write-Host ""
}

# Harness Target mapping (specs/023-full-harness-coverage/data-model.md):
# every harness shares the same source skills, runtime templates, and
# post-copy validation below. $skillsDstRel is always where the full
# specjedi-* packages land; $bridgeMode/$bridgeDstRel (empty for
# skills-dir harnesses) control whether an additional adapter file gets
# generated afterward for a harness with no native skills-directory scan.
$bridgeMode = ""
$bridgeDstRel = ""
switch ($Harness) {
    "claude-code" { $skillsDstRel = ".claude/skills" }
    "codex-cli" {
        # Verified against Codex CLI's own official docs
        # (learn.chatgpt.com/docs/build-skills): repository-level skills
        # are scanned from .agents/skills, walking up to repo root
        # (specs/016-codex-cli-install/research.md).
        $skillsDstRel = ".agents/skills"
    }
    "trae" {
        # Verified against Trae's official Skills docs and Vercel's own
        # `skills` CLI source (specs/019-trae-support/research.md).
        $skillsDstRel = ".trae/skills"
    }
    "antigravity" {
        # Google Antigravity defaults to the same .agents/skills
        # convention Codex CLI already uses -- confirmed across Google's
        # own Codelabs/Developer docs (specs/023-full-harness-coverage/research.md).
        $skillsDstRel = ".agents/skills"
    }
    "cursor" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".cursor/rules" }
    "windsurf" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".windsurf/rules" }
    "cline" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".clinerules" }
    "continue" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".continue/rules" }
    "amazon-q" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".amazonq/rules" }
    "jetbrains-ai" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".aiassistant/rules" }
    "tabnine" { $skillsDstRel = ".claude/skills"; $bridgeMode = "dir"; $bridgeDstRel = ".tabnine/guidelines" }
    "gemini-cli" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = "GEMINI.md" }
    "zed" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = ".rules" }
    "replit" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = "replit.md" }
    "aider" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = "CONVENTIONS.md" }
    "copilot" { $skillsDstRel = ".claude/skills"; $bridgeMode = "single"; $bridgeDstRel = ".github/copilot-instructions.md" }
    "devin" { $skillsDstRel = ".claude/skills"; $bridgeMode = "devin"; $bridgeDstRel = ".devin.md" }
    "cody" { $skillsDstRel = ".claude/skills"; $bridgeMode = "cody"; $bridgeDstRel = ".vscode/cody.json" }
    "opencode" {
        # specs/041-release-hooks-settings: previously "piggybacked" on
        # claude-code/codex-cli's own skills output with no dedicated
        # value -- both already satisfy OpenCode's scanning convention
        # (see opencode-compatibility's own CI job). A real -Harness
        # opencode value is needed now that this feature adds
        # OpenCode-native permissions translation (opencode.json).
        $skillsDstRel = ".claude/skills"
    }
    "warp" {
        # Same reasoning as opencode above -- Warp's Skills system
        # already scans .claude/skills/ directly (warp-compatibility).
        $skillsDstRel = ".claude/skills"
    }
    default {
        Write-Host "🔭 '$Harness' isn't a recognized harness. See -Help for the full"
        Write-Host "list of 20 supported values (Constitution Principle III)."
        exit 1
    }
}

Write-Host "📜 Installing Spec Jedi's specjedi-* skills into: $TargetDir"
Write-Host ""

$skillsSrc = Join-Path $repoRoot ".claude/skills"
$skillsDst = Join-Path $TargetDir $skillsDstRel
New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null

# specs/055-safe-skill-update-hook: before any overwrite below replaces
# an already-installed skill/template, back up the existing copy first
# if it genuinely differs from what's about to replace it -- matching
# install.sh's own identical logic. Backs up nothing on a first install
# (FR-003): $Dst simply doesn't exist yet, so the early return fires.
$script:backupRoot = $null
function Backup-IfDiffers {
    param([string]$Src, [string]$Dst)
    if (-not (Test-Path $Dst)) { return }
    $srcIsDir = (Get-Item $Src).PSIsContainer
    if ($srcIsDir) {
        $srcHashes = Get-ChildItem -Recurse $Src -File | Get-FileHash | Select-Object -ExpandProperty Hash | Sort-Object
        $dstHashes = Get-ChildItem -Recurse $Dst -File -ErrorAction SilentlyContinue | Get-FileHash | Select-Object -ExpandProperty Hash | Sort-Object
    } else {
        $srcHashes = (Get-FileHash $Src).Hash
        $dstHashes = (Get-FileHash $Dst -ErrorAction SilentlyContinue).Hash
    }
    $differs = (Compare-Object $srcHashes $dstHashes -ErrorAction SilentlyContinue) -ne $null
    if ($differs) {
        if (-not $script:backupRoot) {
            $stamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
            $script:backupRoot = Join-Path $TargetDir ".specify/backups/$stamp"
            New-Item -ItemType Directory -Force -Path $script:backupRoot | Out-Null
        }
        $name = Split-Path $Dst -Leaf
        Copy-Item -Recurse -Path $Dst -Destination (Join-Path $script:backupRoot $name)
        Write-Host "  🗄️  backed up locally-modified $name -> $($script:backupRoot.Substring($TargetDir.Length + 1))"
    }
}

$installed = 0
Get-ChildItem -Path $skillsSrc -Directory -Filter "specjedi-*" | ForEach-Object {
    $skillName = $_.Name
    $dstPath = Join-Path $skillsDst $skillName
    Backup-IfDiffers -Src $_.FullName -Dst $dstPath
    if (Test-Path $dstPath) {
        Remove-Item -Recurse -Force $dstPath
    }
    Copy-Item -Recurse -Path $_.FullName -Destination $dstPath
    Write-Host "  ✅ $skillName"
    $installed++
}

if ($installed -eq 0) {
    Write-Host "FAIL: no specjedi-* skills found under $skillsSrc — is this run from a Spec Jedi checkout?"
    exit 1
}

Write-Host ""
Write-Host "📚 Installing runtime template dependencies..."
$templatesDst = Join-Path $TargetDir ".specify/templates"
New-Item -ItemType Directory -Force -Path $templatesDst | Out-Null
foreach ($template in @("constitution-template.md", "spec-template.md", "plan-template.md", "tasks-template.md")) {
    $templateSrc = Join-Path $repoRoot ".specify/templates/$template"
    $templateDst = Join-Path $templatesDst $template
    Backup-IfDiffers -Src $templateSrc -Dst $templateDst
    Copy-Item -Path $templateSrc -Destination $templateDst
    Write-Host "  ✅ $template"
}

# specs/042-skill-freshness-validation: records which release produced
# this install (Constitution Principle XXII) -- a prerequisite for the
# session-start freshness check to have anything to compare against.
# $repoRoot here is install.ps1's own source location, which is either:
#   (a) an extracted release tarball (package-release.ps1 staged a
#       RELEASE_VERSION stamp file at its root -- whether extracted by
#       bootstrap-install.ps1 or manually by a user), or
#   (b) a real git checkout (has .git), or
#   (c) neither (not a scenario either installer script currently
#       produces, but a safe fallback matters more than a fabricated
#       version).
function Write-ReleaseMarker {
    param([string]$Target)
    $releaseVersionFile = Join-Path $repoRoot "RELEASE_VERSION"
    $gitDir = Join-Path $repoRoot ".git"
    if (Test-Path $releaseVersionFile) {
        $value = (Get-Content $releaseVersionFile -Raw).Trim()
    } elseif (Test-Path $gitDir) {
        $value = "local-checkout"
    } else {
        $value = "local-checkout"
    }
    $specifyDst = Join-Path $Target ".specify"
    New-Item -ItemType Directory -Force -Path $specifyDst | Out-Null
    $markerPath = Join-Path $specifyDst "release-marker.json"
    [System.IO.File]::WriteAllText($markerPath, "{`"installed_release`": `"$value`"}`n")
    Write-Host "  ✅ .specify/release-marker.json ($value)"
}
Write-ReleaseMarker -Target $TargetDir

# Bridge-file generation (specs/023-full-harness-coverage): only runs for
# harnesses with no native skills-directory scan. Reads name/description
# straight back out of the just-installed .claude/skills/specjedi-*/SKILL.md
# files, so the bridge always reflects what actually landed on disk.
function Get-SkillMeta {
    param([string]$SkillFile)
    $content = Get-Content -Path $SkillFile -Raw
    $name = [regex]::Match($content, '(?m)^name:\s*(\S+)').Groups[1].Value
    $descMatch = [regex]::Match($content, '(?m)^description:\s*(.+)$')
    $desc = $descMatch.Groups[1].Value.Trim()

    # First sentence only (up to the first ". " -- period-then-space, so
    # "spec.md"/"SKILL.md" abbreviations inside a description don't cause
    # a false cut), capped at 160 chars -- same rule as install.sh.
    $sentenceMatch = [regex]::Match($desc, '^(.*?\.)\s')
    if ($sentenceMatch.Success) {
        $desc = $sentenceMatch.Groups[1].Value
    }
    if ($desc.Length -gt 160) {
        $truncated = $desc.Substring(0, 157)
        # Trim back to the last complete word rather than cutting at the
        # exact character boundary -- a raw character cut regularly
        # landed mid-word (e.g. "...journey, k...", "...directly t..."),
        # a confusing fragment for something an agent reads directly as
        # its own session-start context (CLAUDE.md/AGENTS.md/.trae/rules'
        # generated section, specs/039). No-op if there's no space in
        # the truncated string at all -- mirrors install.sh's
        # ${desc% *} exactly.
        $lastSpace = $truncated.LastIndexOf(" ")
        if ($lastSpace -ge 0) {
            $truncated = $truncated.Substring(0, $lastSpace)
        }
        $desc = $truncated + "..."
    }
    [PSCustomObject]@{ Name = $name; Description = $desc }
}

# specs/039-memory-file-skill-mentions: for harnesses with a confirmed,
# separate project-memory-file convention distinct from their skills
# directory (CLAUDE.md, AGENTS.md, .trae/rules/project_rules.md), create
# or idempotently update a marker-delimited section naming the installed
# skills -- never for antigravity (no confirmed convention) or the 14
# bridge harnesses (their existing bridge file already serves this
# purpose).
function Get-MemorySection {
    param([string]$SkillsDstRel)
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("<!-- SPEC-JEDI:SKILLS:START -->")
    $lines.Add("## Spec Jedi skills available in this project")
    $lines.Add("")
    $lines.Add("This project has the Spec Jedi spec-driven-development skill set")
    $lines.Add("installed at ``$SkillsDstRel/``. When a request matches one of")
    $lines.Add("the skills below, open and follow the full instructions in its")
    $lines.Add("``SKILL.md`` before responding. New to Spec Jedi? Start with")
    $lines.Add("``specjedi-onboard``.")
    $lines.Add("")
    $lines.Add("| Skill | What it does |")
    $lines.Add("|---|---|")
    # Sort explicitly: bash's `for f in "$skills_dst"/specjedi-*/SKILL.md`
    # glob expansion is alphabetically ordered by the shell itself, but
    # Get-ChildItem's enumeration order is filesystem-dependent, not
    # alphabetical -- without this, the two scripts would produce a
    # different skill order in the table for the same skill set,
    # breaking FR-008/SC-004's byte-parity requirement (verified locally:
    # unsorted Get-ChildItem returned a different order than bash's glob
    # for the same three test directories).
    Get-ChildItem -Path $skillsDst -Recurse -Filter "SKILL.md" | Sort-Object FullName | ForEach-Object {
        $meta = Get-SkillMeta -SkillFile $_.FullName
        $lines.Add("| ``$($meta.Name)`` | $($meta.Description) |")
    }
    $lines.Add("<!-- SPEC-JEDI:SKILLS:END -->")
    [string]::Join("`n", $lines)
}

function Update-MemoryFile {
    param([string]$MemoryPath, [string]$SkillsDstRel)
    $startMarker = "<!-- SPEC-JEDI:SKILLS:START -->"
    $endMarker = "<!-- SPEC-JEDI:SKILLS:END -->"
    $newSection = Get-MemorySection -SkillsDstRel $SkillsDstRel

    $parentDir = Split-Path -Parent $MemoryPath
    if ($parentDir -and -not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }

    if (-not (Test-Path $MemoryPath)) {
        [System.IO.File]::WriteAllText($MemoryPath, "$newSection`n")
        Write-Host "  ✅ $(Split-Path -Leaf $MemoryPath) created"
        return
    }

    $rawContent = [System.IO.File]::ReadAllText($MemoryPath)
    $hasStart = $rawContent.Contains($startMarker)
    $hasEnd = $rawContent.Contains($endMarker)

    if ($hasStart -ne $hasEnd) {
        Write-Host "FAIL: $MemoryPath has a Spec Jedi marker without its matching pair -- refusing to guess where the managed section ends. Remove the stray marker manually and re-run."
        exit 1
    }

    if ($hasStart) {
        # Drop exactly one trailing LF before slicing, mirroring bash's
        # $(cat file) command-substitution semantics EXACTLY: bash's
        # command substitution strips only a trailing \n, not a
        # preceding \r -- a CRLF-terminated file keeps its trailing \r
        # after stripping, which the final "...$after`n" reconstruction
        # below then completes back into a proper CRLF. Stripping
        # `\r?\n` instead (both characters as one unit) was tried first
        # and rejected: it strips the \r too, so a CRLF-terminated file
        # loses its trailing \r and ends in a bare LF after re-append --
        # a real, verified FR-002 byte-preservation gap AND an FR-008
        # cross-script mismatch against install.sh, which doesn't have
        # this problem (confirmed by inspecting both scripts' raw output
        # bytes against the same CRLF fixture). Whole-content substring
        # slicing (.IndexOf()/.Substring()), never a line-array rebuild
        # -- CRLF-safe by construction, since there's no per-line
        # comparison to be defeated by a trailing \r.
        $content = $rawContent -replace '\n$', ''
        $startIdx = $content.IndexOf($startMarker)
        $endIdx = $content.LastIndexOf($endMarker) + $endMarker.Length
        $before = $content.Substring(0, $startIdx)
        $after = $content.Substring($endIdx)
        [System.IO.File]::WriteAllText($MemoryPath, "$before$newSection$after`n")
        Write-Host "  ✅ $(Split-Path -Leaf $MemoryPath) updated (existing Spec Jedi section refreshed)"
    } else {
        # Raw append onto the file's existing bytes exactly as they are
        # -- no rewrite of pre-existing content -- matching install.sh's
        # own `printf '\n%s\n' "$new_section" >> file` append semantics.
        [System.IO.File]::AppendAllText($MemoryPath, "`n$newSection`n")
        Write-Host "  ✅ $(Split-Path -Leaf $MemoryPath) updated (Spec Jedi section appended)"
    }
}

# specs/041-release-hooks-settings: native PowerShell counterpart of
# detect_trunk_branch() (install.sh) -- see that function for the full
# rationale. Returns the literal two-word string "main master" when
# neither detection path succeeds.
function Get-TrunkBranch {
    param([string]$Dir)
    $branch = (git -C $Dir symbolic-ref refs/remotes/origin/HEAD --short 2>$null)
    if ($branch) { $branch = $branch -replace '^origin/', '' }
    if (-not $branch) {
        $remoteInfo = (git -C $Dir remote show origin 2>$null)
        if ($remoteInfo) {
            $headLine = $remoteInfo | Where-Object { $_ -match '^\s*HEAD branch:\s*(.+)$' }
            if ($headLine -and $Matches) { $branch = $Matches[1].Trim() }
        }
    }
    # Both git calls above are expected to fail (non-zero exit) on a target
    # with no origin remote -- that's the documented fallback path, not an
    # error. $LASTEXITCODE isn't reset by any PowerShell cmdlet in between
    # (Where-Object, string ops, etc. don't touch it), so a real CI failure
    # was observed here: it stayed non-zero all the way to this function's
    # return and then to install.ps1's own natural end, where GitHub
    # Actions' own pwsh step wrapper exits the whole step with whatever
    # $LASTEXITCODE last held -- failing an otherwise fully successful run.
    # Reset explicitly since both git failures above are already handled.
    $global:LASTEXITCODE = 0
    if ($branch) { return $branch } else { return "main master" }
}

# specs/058-expand-shareable-hooks (FR-005): gates every Python-based
# shareable hook on python3's actual presence -- identical semantics to
# scripts/install.sh's has_python3(). Get-Command with
# -ErrorAction SilentlyContinue never invokes the target executable, so
# it never touches $LASTEXITCODE the way a real git call does above.
function Test-Python3Available {
    # Explicit test seam -- identical rationale to has_python3()'s own
    # comment in scripts/install.sh: every attempt to simulate "python3
    # absent" by mutating the real environment failed for a real,
    # platform-specific reason, so CI asserts FR-005 via this env var
    # instead, never by mutating the runner's actual python3 install.
    if ($env:SPECJEDI_TEST_FORCE_NO_PYTHON3) {
        return $false
    }
    return [bool](Get-Command python3 -ErrorAction SilentlyContinue)
}

# specs/041-release-hooks-settings: native PowerShell counterpart of
# update_shared_settings() (install.sh) -- see that function for the
# full rationale, including why this deliberately avoids
# ConvertFrom-Json/ConvertTo-Json: a parse-then-reserialize round-trip
# risks reformatting/reordering content the target project's own
# maintainers already wrote, the same reformatting risk
# Update-MemoryFile already avoids for CLAUDE.md/AGENTS.md via
# whole-content substring slicing rather than a structured rewrite.
function Update-SharedSettings {
    param([string]$Target)
    $parentDir = Split-Path -Parent $Target
    if ($parentDir -and -not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }

    $statusLineBlock = @'
  "statusLine": {
    "type": "command",
    "command": "bash",
    "args": ["${CLAUDE_PROJECT_DIR}/.claude/statusline.sh"]
  }
'@
    $permissionsBlock = @'
  "permissions": {
    "allow": [
      "Bash(git status)",
      "Bash(git diff:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)",
      "Bash(git pull:*)",
      "Bash(git log:*)"
    ],
    "deny": [
      "Read(**/.env)",
      "Read(**/.env.*)",
      "Read(**/secrets/**)",
      "Read(**/config/credentials.json)",
      "Read(**/id_rsa)",
      "Read(**/id_dsa)",
      "Read(**/id_ecdsa)",
      "Read(**/id_ed25519)",
      "Read(**/*.pem)",
      "Read(**/*.key)",
      "Read(**/*.pfx)",
      "Read(**/*.p12)",
      "Read(**/.npmrc)",
      "Read(**/.netrc)",
      "Read(**/.pgpass)",
      "Read(**/.git-credentials)",
      "Read(**/.aws/credentials)",
      "Read(**/.docker/config.json)"
    ]
  }
'@

    if (-not (Test-Path $Target)) {
        [System.IO.File]::WriteAllText($Target, "{`n$statusLineBlock,`n$permissionsBlock`n}`n")
        Write-Host "  ✅ $(Split-Path -Leaf $Target) created with statusLine/permissions"
        return
    }

    $content = [System.IO.File]::ReadAllText($Target)
    $hasStatusLine = $content.Contains('"statusLine"')
    $hasPermissions = $content.Contains('"permissions"')

    if ($hasStatusLine -and $hasPermissions) {
        Write-Host "  ℹ️  $(Split-Path -Leaf $Target) already has statusLine and permissions — leaving as-is."
        return
    }

    $trimmed = $content.TrimEnd()
    # Brace-balance check, not just EndsWith('}'): a file like
    # '{ "hooks": {} ' (missing the real outer close) still ends in
    # '}' (the inner object's) -- confirmed as a real bug caught by
    # install.sh's own T014 test-first pass, fixed identically here.
    $openCount = ([regex]::Matches($trimmed, '\{')).Count
    $closeCount = ([regex]::Matches($trimmed, '\}')).Count
    if ($openCount -ne $closeCount -or -not $trimmed.EndsWith('}')) {
        Write-Host "FAIL: $Target has unbalanced braces ($openCount '{' vs $closeCount '}') -- not valid JSON, refusing to guess. Fix it manually and re-run."
        exit 1
    }
    $body = $trimmed.Substring(0, $trimmed.Length - 1).TrimEnd()

    $newKeys = ""
    if (-not $hasStatusLine) {
        $newKeys = $statusLineBlock
    }
    if (-not $hasPermissions) {
        if ($newKeys) {
            $newKeys = "$newKeys,`n$permissionsBlock"
        } else {
            $newKeys = $permissionsBlock
        }
    }

    if ($body.EndsWith('{')) {
        [System.IO.File]::WriteAllText($Target, "$body`n$newKeys`n}`n")
    } else {
        [System.IO.File]::WriteAllText($Target, "$body,`n$newKeys`n}`n")
    }
    Write-Host "  ✅ $(Split-Path -Leaf $Target) updated (statusLine/permissions added)"
}

if ($bridgeMode) {
    Write-Host ""
    Write-Host "🌉 Generating $Harness bridge file(s)..."
    $bridgeDst = Join-Path $TargetDir $bridgeDstRel
    $skillMetas = Get-ChildItem -Path $skillsDst -Recurse -Filter "SKILL.md" | ForEach-Object { Get-SkillMeta -SkillFile $_.FullName }

    switch ($bridgeMode) {
        "dir" {
            New-Item -ItemType Directory -Force -Path $bridgeDst | Out-Null
            $bridgeCount = 0
            foreach ($meta in $skillMetas) {
                $lines = @(
                    "<!-- Managed by Spec Jedi's installer (scripts/install.sh/.ps1).",
                    "     Re-running the installer regenerates this file. -->",
                    "",
                    "# $($meta.Name)",
                    "",
                    $meta.Description,
                    "",
                    "Full instructions: ``.claude/skills/$($meta.Name)/SKILL.md`` — read and follow it in full when this applies."
                )
                Set-Content -Path (Join-Path $bridgeDst "$($meta.Name).md") -Value $lines
                $bridgeCount++
            }
            Write-Host "  ✅ $bridgeCount bridge file(s) under $bridgeDstRel/"
        }
        { $_ -in "single", "devin" } {
            $bridgeParent = Split-Path -Parent $bridgeDst
            if ($bridgeParent) { New-Item -ItemType Directory -Force -Path $bridgeParent | Out-Null }
            $lines = @(
                "<!-- Managed by Spec Jedi's installer (scripts/install.sh/.ps1).",
                "     Re-running the installer regenerates this file. -->",
                ""
            )
            if ($bridgeMode -eq "devin") {
                $lines += @(
                    "# Spec Jedi Playbook",
                    "",
                    "## Specifications",
                    "",
                    "This project has the Spec Jedi spec-driven-development skill set",
                    "installed at ``.claude/skills/``. Each skill below is a self-contained",
                    "Markdown instruction file with YAML frontmatter.",
                    "",
                    "## Procedure",
                    "",
                    "1. When a request matches one of the skills in the table below, open",
                    "   its ``SKILL.md`` in full and follow its instructions before responding.",
                    "2. New to Spec Jedi? Start with ``specjedi-onboard``.",
                    "",
                    "## Advice",
                    ""
                )
            }
            else {
                $lines += @(
                    "# Spec Jedi skills available in this project",
                    "",
                    "This project has the Spec Jedi spec-driven-development skill set",
                    "installed at ``.claude/skills/``. This harness reads a single",
                    "project-level instructions file rather than scanning a skills",
                    "directory, so this index bridges the gap: when a request matches",
                    "one of the skills below, open and follow the full instructions in",
                    "its ``SKILL.md`` before responding. New to Spec Jedi? Start with",
                    "``specjedi-onboard``.",
                    ""
                )
            }
            $lines += @("| Skill | What it does |", "|---|---|")
            foreach ($meta in $skillMetas) {
                $lines += "| ``$($meta.Name)`` | $($meta.Description) |"
            }
            Set-Content -Path $bridgeDst -Value $lines
            Write-Host "  ✅ $bridgeDstRel"
        }
        "cody" {
            $bridgeParent = Split-Path -Parent $bridgeDst
            if ($bridgeParent) { New-Item -ItemType Directory -Force -Path $bridgeParent | Out-Null }
            $commands = [ordered]@{}
            foreach ($meta in $skillMetas) {
                $commands[$meta.Name] = [ordered]@{
                    description  = $meta.Description
                    prompt       = "Follow the instructions in .claude/skills/$($meta.Name)/SKILL.md in full."
                    contextFiles = @(".claude/skills/$($meta.Name)/SKILL.md")
                }
            }
            ($commands | ConvertTo-Json -Depth 5) | Set-Content -Path $bridgeDst
            Write-Host "  ✅ $bridgeDstRel (Cody custom commands — invoke with /specjedi-<name>;"
            Write-Host "     Cody has no confirmed always-on rules file, so these load on"
            Write-Host "     explicit invocation rather than automatically, unlike the other"
            Write-Host "     bridge harnesses — see specs/023-full-harness-coverage/research.md)"
        }
    }
}

# specs/039-memory-file-skill-mentions: harnesses with a confirmed,
# separate project-memory-file convention distinct from their skills
# directory get that file created or updated too -- never antigravity
# (no confirmed convention) or the 14 bridge harnesses above (their
# bridge file already serves this purpose).
$memoryFileRel = ""
switch ($Harness) {
    "claude-code" { $memoryFileRel = "CLAUDE.md" }
    "codex-cli" { $memoryFileRel = "AGENTS.md" }
    "trae" { $memoryFileRel = ".trae/rules/project_rules.md" }
}
if ($memoryFileRel) {
    Write-Host ""
    Write-Host "🧠 Updating $memoryFileRel with the installed skill set..."
    Update-MemoryFile -MemoryPath (Join-Path $TargetDir $memoryFileRel) -SkillsDstRel $skillsDstRel
}

# specs/041-release-hooks-settings (User Story 1): shareable hooks/
# settings for claude-code -- never skill-quality-guard or
# cross-platform-parity-guard, which check spec-jedi-repo-specific
# conventions. Wave 1/2 per-harness adaptations are separate, later work.
if ($Harness -eq "claude-code" -and $installSharedHooks) {
    Write-Host ""
    Write-Host "🛡️  Installing shareable hooks/settings..."
    $trunkBranch = Get-TrunkBranch -Dir $TargetDir
    $trunkCases = ($trunkBranch -split ' ' | ForEach-Object {
        "        '$_' { `$hasMainOrMaster = `$true }`n        '$($_):$($_)' { `$hasMainOrMaster = `$true }"
    }) -join "`n"
    # specs/058-expand-shareable-hooks: prevent-direct-push.py's own
    # PROTECTED set is Python-set-literal syntax, a distinct substitution
    # value from $trunkCases above -- e.g. {"main"} or {"main", "master"}.
    $pythonProtected = '{' + (($trunkBranch -split ' ' | ForEach-Object { "`"$_`"" }) -join ', ') + '}'

    $targetHooksDir = Join-Path $TargetDir ".claude/hooks"
    New-Item -ItemType Directory -Force -Path $targetHooksDir | Out-Null
    $hookSource = Get-Content (Join-Path $repoRoot ".claude/hooks/dangerous-command-guard.ps1") -Raw
    $originalCases = "        'main' { `$hasMainOrMaster = `$true }`n        'master' { `$hasMainOrMaster = `$true }`n        'main:main' { `$hasMainOrMaster = `$true }`n        'master:master' { `$hasMainOrMaster = `$true }"
    $hookContent = $hookSource.Replace($originalCases, $trunkCases)
    [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "dangerous-command-guard.ps1"), $hookContent)
    Write-Host "  ✅ dangerous-command-guard.ps1 (protecting: $trunkBranch)"

    # specs/058-expand-shareable-hooks (User Story 5): secret-file-guard.ps1,
    # zero-dependency (never gated on Test-Python3Available). Tracked
    # separately from $bashHookFiles since it belongs in a different
    # PreToolUse matcher (Read|Grep|Glob, not Bash).
    Copy-Item -Path (Join-Path $repoRoot ".claude/hooks/secret-file-guard.ps1") -Destination (Join-Path $targetHooksDir "secret-file-guard.ps1")
    Write-Host "  ✅ secret-file-guard.ps1"
    $readHookFiles = @("secret-file-guard.ps1")

    # specs/058-expand-shareable-hooks (User Story 1): prevent-direct-push.py
    # (a single cross-platform Python file -- no separate .ps1 counterpart
    # needed, unlike dangerous-command-guard.ps1's own bash/PowerShell
    # twin), gated on python3 (FR-005).
    $bashHookFiles = @("dangerous-command-guard.ps1")
    $skippedPythonHooks = @()
    if (Test-Python3Available) {
        $pushSource = Get-Content (Join-Path $repoRoot ".claude/hooks/prevent-direct-push.py") -Raw
        $pushContent = $pushSource.Replace('PROTECTED = {"main", "develop"}', "PROTECTED = $pythonProtected")
        [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "prevent-direct-push.py"), $pushContent)
        Write-Host "  ✅ prevent-direct-push.py (protecting: $trunkBranch)"
        $bashHookFiles += "prevent-direct-push.py"

        # specs/058-expand-shareable-hooks (User Story 2): secret-scanner.py,
        # shipped unmodified (FR-002).
        Copy-Item -Path (Join-Path $repoRoot ".claude/hooks/secret-scanner.py") -Destination (Join-Path $targetHooksDir "secret-scanner.py")
        Write-Host "  ✅ secret-scanner.py"
        $bashHookFiles += "secret-scanner.py"

        # specs/058-expand-shareable-hooks (User Story 3): conventional-commits.py,
        # only when explicitly opted in (FR-003).
        if ($installConventionalCommits) {
            Copy-Item -Path (Join-Path $repoRoot ".claude/hooks/conventional-commits.py") -Destination (Join-Path $targetHooksDir "conventional-commits.py")
            Write-Host "  ✅ conventional-commits.py"
            $bashHookFiles += "conventional-commits.py"
        }
    } else {
        $skippedPythonHooks += "prevent-direct-push.py"
        $skippedPythonHooks += "secret-scanner.py"
        if ($installConventionalCommits) {
            $skippedPythonHooks += "conventional-commits.py"
        }
    }
    if ($skippedPythonHooks.Count -gt 0) {
        Write-Host "  ⚠️  python3 not found — skipping: $($skippedPythonHooks -join ' ')"
    }

    $targetSettings = Join-Path $TargetDir ".claude/settings.json"
    Update-SharedSettings -Target $targetSettings

    $settingsContent = [System.IO.File]::ReadAllText($targetSettings)
    $missingBashHooks = @($bashHookFiles | Where-Object { -not $settingsContent.Contains($_) })
    $missingReadHooks = @($readHookFiles | Where-Object { -not $settingsContent.Contains($_) })

    if ($missingBashHooks.Count -gt 0 -or $missingReadHooks.Count -gt 0) {
        if ($settingsContent -match '"PreToolUse"') {
            $missingPaths = (($missingBashHooks + $missingReadHooks) | ForEach-Object { Join-Path $targetHooksDir $_ }) -join ' '
            Write-Host "  ℹ️  Target already has a PreToolUse hooks array — add the following manually, not overwritten automatically: $missingPaths"
        } else {
            $trimmed = $settingsContent.TrimEnd()
            $body = $trimmed.Substring(0, $trimmed.Length - 1).TrimEnd()

            $bashHookEntries = ($bashHookFiles | ForEach-Object {
                if ($_ -like "*.ps1") {
                    @"
          {
            "type": "command",
            "command": "powershell",
            "args": ["-NoProfile", "-File", "`${CLAUDE_PROJECT_DIR}/.claude/hooks/$_"]
          }
"@
                } else {
                    @"
          {
            "type": "command",
            "command": "python3 \"`${CLAUDE_PROJECT_DIR}/.claude/hooks/$_\""
          }
"@
                }
            }) -join ",`n"

            $readHookEntries = ($readHookFiles | ForEach-Object {
                @"
          {
            "type": "command",
            "command": "powershell",
            "args": ["-NoProfile", "-File", "`${CLAUDE_PROJECT_DIR}/.claude/hooks/$_"]
          }
"@
            }) -join ",`n"

            $hooksBlock = @"
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
$bashHookEntries
        ]
      },
      {
        "matcher": "Read|Grep|Glob",
        "hooks": [
$readHookEntries
        ]
      }
    ]
  }
"@
            if ($body.EndsWith('{')) {
                [System.IO.File]::WriteAllText($targetSettings, "$body`n$hooksBlock`n}`n")
            } else {
                [System.IO.File]::WriteAllText($targetSettings, "$body,`n$hooksBlock`n}`n")
            }
            $wiredList = ($bashHookFiles + $readHookFiles) -join ' '
            Write-Host "  ✅ Wired $wiredList into $(Split-Path -Leaf $targetSettings)'s PreToolUse hooks"
        }
    }
}

# specs/041-release-hooks-settings (User Story 2): native PowerShell
# counterpart of merge_json_key() (install.sh) -- see that function for
# the full rationale.
function Merge-JsonKey {
    param([string]$Target, [string]$KeyCheck, [string]$Block, [string]$OkMessage)
    $parentDir = Split-Path -Parent $Target
    if ($parentDir -and -not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }

    if (-not (Test-Path $Target)) {
        [System.IO.File]::WriteAllText($Target, "{`n$Block`n}`n")
        Write-Host "  ✅ $(Split-Path -Leaf $Target) created ($OkMessage)"
        return
    }

    $content = [System.IO.File]::ReadAllText($Target)
    if ($content.Contains($KeyCheck)) {
        Write-Host "  ℹ️  $(Split-Path -Leaf $Target) already has this key — leaving as-is."
        return
    }

    $trimmed = $content.TrimEnd()
    $openCount = ([regex]::Matches($trimmed, '\{')).Count
    $closeCount = ([regex]::Matches($trimmed, '\}')).Count
    if ($openCount -ne $closeCount -or -not $trimmed.EndsWith('}')) {
        Write-Host "FAIL: $Target has unbalanced braces ($openCount '{' vs $closeCount '}') -- not valid JSON, refusing to guess. Fix it manually and re-run."
        exit 1
    }
    $body = $trimmed.Substring(0, $trimmed.Length - 1).TrimEnd()

    if ($body.EndsWith('{')) {
        [System.IO.File]::WriteAllText($Target, "$body`n$Block`n}`n")
    } else {
        [System.IO.File]::WriteAllText($Target, "$body,`n$Block`n}`n")
    }
    Write-Host "  ✅ $(Split-Path -Leaf $Target) updated ($OkMessage)"
}

# specs/041-release-hooks-settings (User Story 2): factors out the exact
# trunk-case-block expression the claude-code block above already builds
# inline, so every Wave 1 harness needing the identical pattern doesn't
# repeat it.
function Get-TrunkCases {
    param([string]$TrunkBranch)
    ($TrunkBranch -split ' ' | ForEach-Object {
        "        '$_' { `$hasMainOrMaster = `$true }`n        '$($_):$($_)' { `$hasMainOrMaster = `$true }"
    }) -join "`n"
}

# specs/041-release-hooks-settings (User Story 2, Wave 1): native
# PowerShell counterpart of render_gemini_style_guard() (install.sh) --
# see that function for the full rationale (BeforeTool-shaped hook
# contract, shared by Gemini CLI (confirmed) and Antigravity (reasoned
# inference, documented at the Install-HooksAntigravity call site).
# Single-quoted here-string (no interpolation) plus one placeholder
# .Replace(), matching this file's own existing statusLineBlock/
# hooksBlock technique exactly -- avoids having to backtick-escape every
# one of the ~20 `$variable` references a double-quoted here-string would
# otherwise require.
function Get-GeminiStyleGuardScript {
    param([string]$TrunkCases)
    $template = @'
#!/usr/bin/env pwsh
# Translated from .claude/hooks/dangerous-command-guard.ps1 (specs/
# 041-release-hooks-settings, User Story 2) for a BeforeTool-shaped hook
# contract: stdin carries tool_input.command, stdout is
# {"decision":"deny","reason":"..."} with exit code 2 to block.
$ErrorActionPreference = 'Stop'
$input_json = [Console]::In.ReadToEnd()

if ($input_json -match '"command"\s*:\s*"([^"]*)"') {
    $command = $matches[1]
} else {
    exit 0
}

if ([string]::IsNullOrEmpty($command)) { exit 0 }

function Deny($reason) {
    $output = @{ decision = "deny"; reason = $reason } | ConvertTo-Json -Compress
    Write-Output $output
    exit 2
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
__TRUNK_CASES__
        'cat' { $readCmd = $true }
        'head' { $readCmd = $true }
        'tail' { $readCmd = $true }
        'less' { $readCmd = $true }
        'more' { $readCmd = $true }
        default {
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
    Deny "Blocked: force-push to the trunk branch. This project's own git-workflow discipline forbids force-pushing the trunk branch."
}

if ($readCmd) {
    foreach ($w in $words) {
        $normalizedW = $w -replace '\\', '/'
        if ($normalizedW -match '(^|/)\.aws/credentials$') {
            Deny "Blocked: reading what looks like a real secret/credential file (.aws/credentials)."
        }
        if ($normalizedW -match '(^|/)\.docker/config\.json$') {
            Deny "Blocked: reading what looks like a real secret/credential file (.docker/config.json)."
        }
        $base = Split-Path $w -Leaf -ErrorAction SilentlyContinue
        if (-not $base) { $base = $w }
        if ($base -in @('.env.example', '.env.sample', '.env.template')) { continue }
        if ($base -eq '.env' -or $base -like '.env.*' -or $base -in @('id_rsa', 'id_dsa', 'id_ecdsa', 'id_ed25519') -or $base -like '*.pem' -or $base -like '*.key' -or $base -like '*.pfx' -or $base -like '*.p12') {
            Deny "Blocked: reading what looks like a real secret/credential file."
        }
        if ($base -in @('.npmrc', '.netrc', '.pgpass', '.git-credentials')) {
            Deny "Blocked: reading what looks like a real credential file."
        }
    }
}

exit 0
'@
    $template.Replace('__TRUNK_CASES__', $TrunkCases)
}

# specs/058-expand-shareable-hooks (User Story 1, Wave 1): unlike
# Get-GeminiStyleGuardScript's full PowerShell reimplementation of
# dangerous-command-guard's bash logic, prevent-direct-push.py stays
# Python -- only its stdin-parse-identical, deny-output-shape-different
# nature needs translating (same reasoning as install.sh's
# render_gemini_style_push_guard()). PowerShell here only builds the
# Python source text; it never executes it.
function Get-GeminiStylePushGuardScript {
    param([string]$PythonProtected)
    $src = Get-Content (Join-Path $repoRoot ".claude/hooks/prevent-direct-push.py") -Raw
    $oldProtected = 'PROTECTED = {"main", "develop"}'
    if (-not $src.Contains($oldProtected)) {
        throw "FAIL: prevent-direct-push.py's PROTECTED line not found -- update Get-GeminiStylePushGuardScript"
    }
    $src = $src.Replace($oldProtected, "PROTECTED = $PythonProtected")

    $oldDeny = "    print(json.dumps({`n        `"hookSpecificOutput`": {`n            `"hookEventName`": `"PreToolUse`",`n            `"permissionDecision`": `"deny`",`n            `"permissionDecisionReason`": reason,`n        }`n    }))`n    sys.exit(0)"
    if (-not $src.Contains($oldDeny)) {
        throw "FAIL: prevent-direct-push.py's deny-output block not found -- update Get-GeminiStylePushGuardScript"
    }
    $newDeny = "    print(json.dumps({`"decision`": `"deny`", `"reason`": reason}))`n    sys.exit(2)"
    $src = $src.Replace($oldDeny, $newDeny)

    $header = "#!/usr/bin/env python3`n# Translated from .claude/hooks/prevent-direct-push.py (specs/`n# 058-expand-shareable-hooks, User Story 1) for a BeforeTool-shaped`n# hook contract: stdin carries tool_input.command (unchanged), stdout`n# is {`"decision`":`"deny`",`"reason`":`"...`"} with exit code 2 to block.`n"
    $body = ($src -split '"""', 3)[2].TrimStart("`n")
    return $header + $body
}

# specs/058-expand-shareable-hooks (User Story 2, Wave 1): PowerShell
# counterpart of render_gemini_style_scanner_wrapper() -- same
# subprocess-wrapping approach (never a fragile transform of
# secret-scanner.py's own multi-print output logic).
function Get-GeminiStyleScannerWrapperScript {
    return @'
#!/usr/bin/env python3
# Wraps .claude/hooks/secret-scanner.py (specs/058-expand-shareable-hooks,
# User Story 2) unmodified for a BeforeTool-shaped hook contract: stdin
# carries tool_input.command (unchanged), stdout is
# {"decision":"deny","reason":"..."} with exit code 2 to block.
import json
import os
import subprocess
import sys

scanner_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "secret-scanner.py")
result = subprocess.run(
    [sys.executable, scanner_path],
    input=sys.stdin.read(),
    capture_output=True,
    text=True,
)
if result.returncode == 2:
    print(json.dumps({"decision": "deny", "reason": result.stderr.strip()}))
    sys.exit(2)
sys.exit(0)
'@
}

# specs/058-expand-shareable-hooks (User Story 3, Wave 1): PowerShell
# counterpart of render_gemini_style_commit_guard() -- source-to-source
# transform of the real conventional-commits.py file (same reasoning
# as Get-GeminiStylePushGuardScript above).
function Get-GeminiStyleCommitGuardScript {
    $src = Get-Content (Join-Path $repoRoot ".claude/hooks/conventional-commits.py") -Raw
    $oldDeny = "    output = {`n        `"hookSpecificOutput`": {`n            `"hookEventName`": `"PreToolUse`",`n            `"permissionDecision`": `"deny`",`n            `"permissionDecisionReason`": reason`n        }`n    }`n    print(json.dumps(output))`n    sys.exit(0)"
    if (-not $src.Contains($oldDeny)) {
        throw "FAIL: conventional-commits.py's deny-output block not found -- update Get-GeminiStyleCommitGuardScript"
    }
    $newDeny = "    print(json.dumps({`"decision`": `"deny`", `"reason`": reason}))`n    sys.exit(2)"
    $src = $src.Replace($oldDeny, $newDeny)

    $header = "#!/usr/bin/env python3`n# Translated from .claude/hooks/conventional-commits.py (specs/`n# 058-expand-shareable-hooks, User Story 3) for a BeforeTool-shaped`n# hook contract: stdin carries tool_input.command (unchanged), stdout`n# is {`"decision`":`"deny`",`"reason`":`"...`"} with exit code 2 to block.`n"
    $body = ($src -split '"""', 3)[2].TrimStart("`n")
    return $header + $body
}

# specs/058-expand-shareable-hooks: PowerShell counterpart of
# build_python_protected_set() (scripts/install.sh) -- identical
# semantics.
function Get-PythonProtectedSet {
    param([string]$TrunkBranch)
    return '{' + (($TrunkBranch -split ' ' | ForEach-Object { "`"$_`"" }) -join ', ') + '}'
}

function Install-HooksGeminiCli {
    $trunkBranch = Get-TrunkBranch -Dir $TargetDir
    $trunkCases = Get-TrunkCases -TrunkBranch $trunkBranch
    $targetHooksDir = Join-Path $TargetDir ".gemini/hooks"
    New-Item -ItemType Directory -Force -Path $targetHooksDir | Out-Null
    $guardScript = Get-GeminiStyleGuardScript -TrunkCases $trunkCases
    [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "dangerous-command-guard.ps1"), $guardScript)
    Write-Host "  ✅ dangerous-command-guard.ps1 (Gemini CLI translation, protecting: $trunkBranch)"

    $pushEntry = ""
    $scannerEntry = ""
    $commitEntry = ""
    if (Test-Python3Available) {
        $pythonProtected = Get-PythonProtectedSet -TrunkBranch $trunkBranch
        $pushScript = Get-GeminiStylePushGuardScript -PythonProtected $pythonProtected
        [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "prevent-direct-push.py"), $pushScript)
        Write-Host "  ✅ prevent-direct-push.py (Gemini CLI translation, protecting: $trunkBranch)"
        $pushEntry = @'
,
          {
            "type": "command",
            "command": "python3 .gemini/hooks/prevent-direct-push.py"
          }
'@
        Copy-Item -Path (Join-Path $repoRoot ".claude/hooks/secret-scanner.py") -Destination (Join-Path $targetHooksDir "secret-scanner.py")
        $wrapperScript = Get-GeminiStyleScannerWrapperScript
        [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "secret-scanner-wrapper.py"), $wrapperScript)
        Write-Host "  ✅ secret-scanner.py (Gemini CLI translation, wrapped for BeforeTool contract)"
        $scannerEntry = @'
,
          {
            "type": "command",
            "command": "python3 .gemini/hooks/secret-scanner-wrapper.py"
          }
'@
        if ($installConventionalCommits) {
            $commitScript = Get-GeminiStyleCommitGuardScript
            [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "conventional-commits.py"), $commitScript)
            Write-Host "  ✅ conventional-commits.py (Gemini CLI translation)"
            $commitEntry = @'
,
          {
            "type": "command",
            "command": "python3 .gemini/hooks/conventional-commits.py"
          }
'@
        }
    } else {
        Write-Host "  ⚠️  python3 not found — skipping: prevent-direct-push.py secret-scanner.py (Gemini CLI translation)"
    }

    $hooksBlock = @"
  "hooks": {
    "BeforeTool": [
      {
        "matcher": "run_shell_command",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -File .gemini/hooks/dangerous-command-guard.ps1"
          }$pushEntry$scannerEntry$commitEntry
        ]
      }
    ]
  }
"@
    Merge-JsonKey -Target (Join-Path $TargetDir ".gemini/settings.json") -KeyCheck '"hooks"' -Block $hooksBlock -OkMessage "BeforeTool hook wired"
}

# specs/041-release-hooks-settings (User Story 2, Wave 1): Antigravity's
# own hooks.json schema was not independently confirmed beyond a
# marketing announcement (research.md's own citation) -- reuses the
# confirmed Gemini CLI BeforeTool contract per Get-GeminiStyleGuardScript's
# own documented reasoning (shared ~/.gemini/ config namespace), targeting
# Antigravity's confirmed project-level path <project_root>/.agents/
# hooks.json.
function Install-HooksAntigravity {
    $trunkBranch = Get-TrunkBranch -Dir $TargetDir
    $trunkCases = Get-TrunkCases -TrunkBranch $trunkBranch
    $targetHooksDir = Join-Path $TargetDir ".agents/hooks"
    New-Item -ItemType Directory -Force -Path $targetHooksDir | Out-Null
    $guardScript = Get-GeminiStyleGuardScript -TrunkCases $trunkCases
    [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "dangerous-command-guard.ps1"), $guardScript)
    Write-Host "  ✅ dangerous-command-guard.ps1 (Antigravity translation, protecting: $trunkBranch)"

    $pushEntry = ""
    $scannerEntry = ""
    $commitEntry = ""
    if (Test-Python3Available) {
        $pythonProtected = Get-PythonProtectedSet -TrunkBranch $trunkBranch
        $pushScript = Get-GeminiStylePushGuardScript -PythonProtected $pythonProtected
        [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "prevent-direct-push.py"), $pushScript)
        Write-Host "  ✅ prevent-direct-push.py (Antigravity translation, protecting: $trunkBranch)"
        $pushEntry = @'
,
          {
            "type": "command",
            "command": "python3 .agents/hooks/prevent-direct-push.py"
          }
'@
        Copy-Item -Path (Join-Path $repoRoot ".claude/hooks/secret-scanner.py") -Destination (Join-Path $targetHooksDir "secret-scanner.py")
        $wrapperScript = Get-GeminiStyleScannerWrapperScript
        [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "secret-scanner-wrapper.py"), $wrapperScript)
        Write-Host "  ✅ secret-scanner.py (Antigravity translation, wrapped for BeforeTool contract)"
        $scannerEntry = @'
,
          {
            "type": "command",
            "command": "python3 .agents/hooks/secret-scanner-wrapper.py"
          }
'@
        if ($installConventionalCommits) {
            $commitScript = Get-GeminiStyleCommitGuardScript
            [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "conventional-commits.py"), $commitScript)
            Write-Host "  ✅ conventional-commits.py (Antigravity translation)"
            $commitEntry = @'
,
          {
            "type": "command",
            "command": "python3 .agents/hooks/conventional-commits.py"
          }
'@
        }
    } else {
        Write-Host "  ⚠️  python3 not found — skipping: prevent-direct-push.py secret-scanner.py (Antigravity translation)"
    }

    $hooksBlock = @"
  "hooks": {
    "BeforeTool": [
      {
        "matcher": "run_shell_command",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -File .agents/hooks/dangerous-command-guard.ps1"
          }$pushEntry$scannerEntry$commitEntry
        ]
      }
    ]
  }
"@
    Merge-JsonKey -Target (Join-Path $TargetDir ".agents/hooks.json") -KeyCheck '"hooks"' -Block $hooksBlock -OkMessage "hooks wired (schema inferred shared with Gemini CLI)"
}

# specs/041-release-hooks-settings (User Story 2, Wave 1): Codex CLI's own
# hooks.json schema is confirmed structurally identical to Claude Code's
# own, so this reuses the exact same proven trunk-substitution technique
# as the claude-code (User Story 1) block above, just targeting .codex/
# instead of .claude/.
function Install-HooksCodexCli {
    $trunkBranch = Get-TrunkBranch -Dir $TargetDir
    $trunkCases = Get-TrunkCases -TrunkBranch $trunkBranch
    $targetHooksDir = Join-Path $TargetDir ".codex/hooks"
    New-Item -ItemType Directory -Force -Path $targetHooksDir | Out-Null
    $hookSource = Get-Content (Join-Path $repoRoot ".claude/hooks/dangerous-command-guard.ps1") -Raw
    $originalCases = "        'main' { `$hasMainOrMaster = `$true }`n        'master' { `$hasMainOrMaster = `$true }`n        'main:main' { `$hasMainOrMaster = `$true }`n        'master:master' { `$hasMainOrMaster = `$true }"
    $hookContent = $hookSource.Replace($originalCases, $trunkCases)
    [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "dangerous-command-guard.ps1"), $hookContent)
    Write-Host "  ✅ dangerous-command-guard.ps1 (Codex CLI translation, protecting: $trunkBranch)"

    # specs/058-expand-shareable-hooks (User Story 1/2, Wave 1): Codex
    # CLI's hooks.json schema is structurally identical to Claude Code's
    # own, so prevent-direct-push.py/secret-scanner.py are reused
    # unmodified (same trunk-substitution technique as the claude-code
    # block), unlike Gemini CLI/Antigravity which need translated shapes.
    $bashHookFiles = @("dangerous-command-guard.ps1")
    if (Test-Python3Available) {
        $pythonProtected = Get-PythonProtectedSet -TrunkBranch $trunkBranch
        $pushSource = Get-Content (Join-Path $repoRoot ".claude/hooks/prevent-direct-push.py") -Raw
        $pushContent = $pushSource.Replace('PROTECTED = {"main", "develop"}', "PROTECTED = $pythonProtected")
        [System.IO.File]::WriteAllText((Join-Path $targetHooksDir "prevent-direct-push.py"), $pushContent)
        Write-Host "  ✅ prevent-direct-push.py (Codex CLI translation, protecting: $trunkBranch)"
        $bashHookFiles += "prevent-direct-push.py"

        Copy-Item -Path (Join-Path $repoRoot ".claude/hooks/secret-scanner.py") -Destination (Join-Path $targetHooksDir "secret-scanner.py")
        Write-Host "  ✅ secret-scanner.py (Codex CLI translation)"
        $bashHookFiles += "secret-scanner.py"

        if ($installConventionalCommits) {
            Copy-Item -Path (Join-Path $repoRoot ".claude/hooks/conventional-commits.py") -Destination (Join-Path $targetHooksDir "conventional-commits.py")
            Write-Host "  ✅ conventional-commits.py (Codex CLI translation)"
            $bashHookFiles += "conventional-commits.py"
        }
    } else {
        Write-Host "  ⚠️  python3 not found — skipping: prevent-direct-push.py secret-scanner.py (Codex CLI translation)"
    }

    $hooksJson = Join-Path $TargetDir ".codex/hooks.json"
    if (-not (Test-Path $hooksJson)) {
        $parentDir = Split-Path -Parent $hooksJson
        if ($parentDir -and -not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
        }
        $bashHookEntries = ($bashHookFiles | ForEach-Object {
            if ($_ -like "*.ps1") {
                @"
          {
            "type": "command",
            "command": "powershell -NoProfile -File .codex/hooks/$_"
          }
"@
            } else {
                @"
          {
            "type": "command",
            "command": "python3 .codex/hooks/$_"
          }
"@
            }
        }) -join ",`n"
        $hooksJsonContent = @"
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
$bashHookEntries
        ]
      }
    ]
  }
}
"@
        [System.IO.File]::WriteAllText($hooksJson, $hooksJsonContent)
        $wiredList = $bashHookFiles -join ' '
        Write-Host "  ✅ .codex/hooks.json created (PreToolUse -> $wiredList)"
    } else {
        $hooksJsonContent = [System.IO.File]::ReadAllText($hooksJson)
        $missingHooks = @($bashHookFiles | Where-Object {
            if ($_ -eq "dangerous-command-guard.ps1") { -not $hooksJsonContent.Contains("dangerous-command-guard") }
            else { -not $hooksJsonContent.Contains($_) }
        })
        if ($missingHooks.Count -gt 0) {
            $missingPaths = ($missingHooks | ForEach-Object { Join-Path $targetHooksDir $_ }) -join ' '
            Write-Host "  ℹ️  .codex/hooks.json already exists — add the following manually to its PreToolUse array, not overwritten automatically: $missingPaths"
        } else {
            Write-Host "  ℹ️  .codex/hooks.json already references every shareable hook — leaving as-is."
        }
    }

    $approveList = $bashHookFiles -join ' '
    Write-Host "  ⚠️  Codex CLI requires explicit trust: run /hooks inside Codex CLI and"
    Write-Host "     approve $approveList before they actually run — the"
    Write-Host "     installer cannot pre-approve a hook inside Codex CLI's own trust"
    Write-Host "     store (developers.openai.com/codex/hooks)."
}

# specs/041-release-hooks-settings (User Story 2, Wave 2): OpenCode's own
# permission schema is confirmed at opencode.ai/docs/permissions/.
function Install-PermissionsOpencode {
    $permissionBlock = @'
  "permission": {
    "bash": {
      "git status": "allow",
      "git diff *": "allow",
      "git add *": "allow",
      "git commit *": "allow",
      "git push *": "allow",
      "git pull *": "allow",
      "git log *": "allow"
    },
    "read": {
      ".env": "deny",
      ".env.*": "deny",
      "secrets/**": "deny",
      "config/credentials.json": "deny"
    }
  }
'@
    Merge-JsonKey -Target (Join-Path $TargetDir "opencode.json") -KeyCheck '"permission"' -Block $permissionBlock -OkMessage "git-aware permissions added"
}

# specs/041-release-hooks-settings (User Story 2, Wave 2): Zed's own
# tool-permission mechanism is confirmed at zed.dev/docs/ai/tool-
# permissions; the "terminal" tool key is a reasoned inference, documented
# per Principle XX rather than silently asserted (see install.sh's own
# install_permissions_zed comment for the full citation).
function Install-PermissionsZed {
    $agentBlock = @'
  "agent": {
    "tool_permissions": {
      "terminal": {
        "always_allow": [
          "git status",
          "git diff .*",
          "git add .*",
          "git commit .*",
          "git push .*",
          "git pull .*",
          "git log .*"
        ]
      }
    }
  }
'@
    Merge-JsonKey -Target (Join-Path $TargetDir ".zed/settings.json") -KeyCheck '"agent"' -Block $agentBlock -OkMessage "tool_permissions added"
}

# specs/041-release-hooks-settings (User Story 2, Wave 2): Warp discovery
# -- docs.warp.dev/terminal/settings/ confirms settings.toml is a single
# GLOBAL user-level file, never project-scoped. See install.sh's own
# install_permissions_warp comment for the full zero-footprint reasoning.
function Install-PermissionsWarp {
    Write-Host "  ℹ️  Warp stores agent permissions in a single global"
    Write-Host "     settings.toml (or platform equivalent) — there is no"
    Write-Host "     project-scoped permissions file for this installer to write"
    Write-Host "     into (docs.warp.dev/terminal/settings/). Configure allow/ask"
    Write-Host "     autonomy for git commands yourself under Settings > AI >"
    Write-Host "     Agents > Permissions."
}

# specs/041-release-hooks-settings (User Story 2, Wave 2): Amazon Q
# Developer CLI's custom-agent JSON schema is confirmed at aws.github.io/
# amazon-q-developer-cli/agent-format.html.
function Install-PermissionsAmazonQ {
    $agentsDir = Join-Path $TargetDir ".amazonq/cli-agents"
    New-Item -ItemType Directory -Force -Path $agentsDir | Out-Null
    $agentFile = Join-Path $agentsDir "spec-jedi-shared.json"
    if (Test-Path $agentFile) {
        Write-Host "  ℹ️  .amazonq/cli-agents/spec-jedi-shared.json already exists — leaving as-is."
        return
    }
    $agentContent = @'
{
  "name": "spec-jedi-shared",
  "description": "Shareable git-aware tool permissions installed by Spec Jedi (specs/041-release-hooks-settings).",
  "prompt": "You are a general-purpose coding assistant.",
  "tools": ["fs_read", "fs_write", "execute_bash"],
  "allowedTools": ["fs_read"],
  "toolsSettings": {}
}
'@
    [System.IO.File]::WriteAllText($agentFile, $agentContent)
    Write-Host "  ✅ .amazonq/cli-agents/spec-jedi-shared.json created (fs_read pre-approved; execute_bash/fs_write still prompt per use)"
}

# specs/041-release-hooks-settings (User Story 2): Wave 1 (declarative
# JSON hooks) and Wave 2 (permissions-only) per-harness translations --
# never runs for the 9 no-mechanism harnesses (FR-005's existing
# clean-skip already covers them) or the 3 explicitly deferred Full
# harnesses (Cursor/Windsurf/Copilot).
if ($installSharedHooks) {
    switch ($Harness) {
        "gemini-cli" {
            Write-Host ""
            Write-Host "🛡️  Installing shareable hooks (Gemini CLI translation)..."
            Install-HooksGeminiCli
        }
        "antigravity" {
            Write-Host ""
            Write-Host "🛡️  Installing shareable hooks (Antigravity translation)..."
            Install-HooksAntigravity
        }
        "codex-cli" {
            Write-Host ""
            Write-Host "🛡️  Installing shareable hooks (Codex CLI translation)..."
            Install-HooksCodexCli
        }
        "opencode" {
            Write-Host ""
            Write-Host "🔐 Installing shareable permissions (OpenCode translation)..."
            Install-PermissionsOpencode
        }
        "zed" {
            Write-Host ""
            Write-Host "🔐 Installing shareable permissions (Zed translation)..."
            Install-PermissionsZed
        }
        "warp" {
            Write-Host ""
            Write-Host "🔐 Shareable permissions (Warp)..."
            Install-PermissionsWarp
        }
        "amazon-q" {
            Write-Host ""
            Write-Host "🔐 Installing shareable permissions (Amazon Q Developer translation)..."
            Install-PermissionsAmazonQ
        }
    }
}

Write-Host ""
Write-Host "== Validating installed skills =="
$fail = $false
Get-ChildItem -Path $skillsDst -Recurse -Filter "SKILL.md" -Force | ForEach-Object {
    $skillFile = $_.FullName
    $skillDir = $_.DirectoryName
    $ok = $true

    $lines = Get-Content -Path $skillFile -TotalCount 1
    if ($lines -ne "---") {
        Write-Host "FAIL: $skillFile does not start with YAML frontmatter (---)"
        $ok = $false
    }

    $content = Get-Content -Path $skillFile -Raw
    if ($content -notmatch '(?m)^name:\s*\S+') {
        Write-Host "FAIL: $skillFile frontmatter missing 'name:'"
        $ok = $false
    }
    if ($content -notmatch '(?m)^description:\s*\S+') {
        Write-Host "FAIL: $skillFile frontmatter missing 'description:'"
        $ok = $false
    }

    if ($ok) {
        Write-Host "OK: $skillDir"
    } else {
        $fail = $true
    }
}

Write-Host ""
if ($fail) {
    Write-Host "install.ps1: FAILED - installed skills did not pass validation"
    exit 1
}

Write-Host "🚀 install.ps1: $installed specjedi-* skills installed and validated."
Write-Host ""
Write-Host "Next step:"
Write-Host "  - No .specify/memory/constitution.md yet? Run specjedi-onboard for a"
Write-Host "    guided first-run walkthrough, or specjedi-constitution directly."
