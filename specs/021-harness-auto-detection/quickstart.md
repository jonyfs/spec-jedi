# Quickstart: Verifying Harness Auto-Detection

**Feature**: 021-harness-auto-detection

## Prerequisites

- `scripts/install.sh`/`.ps1` updated with detection logic + `--auto` flag

## Scenario 1: Single signal, auto-installed

```bash
rm -rf /tmp/detect-test-single
mkdir -p /tmp/detect-test-single/.agents   # target-dir signal for codex-cli
bash scripts/install.sh /tmp/detect-test-single
```

**Expected outcome**: installs for `codex-cli` (the only matched
harness) into `.agents/skills/`, printing which signal it matched — no
`--harness` flag needed.

## Scenario 2: Multiple signals, `--auto` picks Recommended

```bash
rm -rf /tmp/detect-test-multi
mkdir -p /tmp/detect-test-multi/.claude /tmp/detect-test-multi/.agents
bash scripts/install.sh /tmp/detect-test-multi --auto
```

**Expected outcome**: both `claude-code` and `codex-cli` match via
target-dir signals (tied rank) — `claude-code` wins the tiebreak per its
fixed priority order; installs for `claude-code`, stating this was an
automatic Recommended selection and why.

## Scenario 3: Zero signals, fallback default

```bash
rm -rf /tmp/detect-test-zero
bash scripts/install.sh /tmp/detect-test-zero
```

**Expected outcome** (assuming no `claude`/`codex` binaries and no
`~/.claude`/`~/.codex`/`~/.trae` on the machine running this — otherwise
substitute a genuinely signal-free scratch environment): installs for
`claude-code`, explicitly stating this is the fallback default, not a
detected match.

## Scenario 4: Explicit `--harness` bypasses detection entirely

```bash
rm -rf /tmp/detect-test-explicit
mkdir -p /tmp/detect-test-explicit/.agents   # would detect codex-cli
bash scripts/install.sh /tmp/detect-test-explicit --harness claude-code
find /tmp/detect-test-explicit/.claude/skills -maxdepth 1 -name 'specjedi-*' -type d | wc -l
```

**Expected outcome**: installs for `claude-code` (the explicit value),
completely ignoring the `.agents/` target-dir signal that would have
otherwise pointed at `codex-cli` — proves FR-001.

## Scenario 5: Every existing explicit-`--harness` CI job is unaffected

Not re-derived here — this is exactly what the existing
`install-test*`/`install-test-codex-cli*`/`install-test-trae*` CI jobs
already prove on every PR, unmodified by this feature (FR-009). This
feature's own PR re-running them unchanged and green is the proof.

## Scenario 6: PowerShell counterpart parity

```powershell
Remove-Item -Recurse -Force C:\detect-test-single -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path C:\detect-test-single\.agents | Out-Null
.\scripts\install.ps1 -TargetDir C:\detect-test-single
Get-ChildItem C:\detect-test-single\.agents\skills -Directory -Filter "specjedi-*" | Measure-Object
```

**Expected outcome**: same shape of result as Scenario 1.

## Scenario 7: The interactive-TTY prompt path

Not reproducible non-interactively (spec.md Assumptions — GitHub Actions
runners have no real TTY). Manually verified by running
`bash scripts/install.sh /tmp/detect-test-multi` (no `--auto`, real
terminal) against Scenario 2's setup and confirming a lettered prompt
appears with `claude-code` marked Recommended, and that both accepting
the default and typing `B` for `codex-cli` produce the corresponding
install.

## Scenario 8: CI proves detection on all three OSes

The new `harness-auto-detect`/`harness-auto-detect-windows-native` CI
job pair (FR-010) — Scenario 1's single-match case and Scenario 2's
`--auto` multi-match case, matrixed across `ubuntu-latest`,
`macos-latest`, `windows-latest`.
