# Quickstart: Verifying the Trae Install Path

**Feature**: 019-trae-support

## Prerequisites

- `scripts/install.sh` (and `.ps1`) updated with the `trae` branch

## Scenario 1: Fresh install into a scratch directory

```bash
rm -rf /tmp/trae-install-test
bash scripts/install.sh /tmp/trae-install-test --harness trae
```

**Expected outcome**: exits 0; every `specjedi-*` skill directory appears
under `/tmp/trae-install-test/.trae/skills/`; the four
`.specify/templates/*.md` files are present; the installer's own
validation output reports `OK:` for every installed skill.

## Scenario 2: No speckit-* leakage

```bash
find /tmp/trae-install-test -iname 'speckit-*'
```

**Expected outcome**: no output — zero `speckit-*` files/directories
present in the install.

## Scenario 3: Frontmatter validation actually runs and would catch a real defect

```bash
head -c 0 /tmp/trae-install-test/.trae/skills/specjedi-status/SKILL.md > /tmp/empty.md
grep -q '^---$' /tmp/empty.md && echo "FAIL: validation would not have caught this" || echo "OK: validation correctly requires frontmatter"
```

## Scenario 4: Existing claude-code/codex-cli paths unaffected

```bash
rm -rf /tmp/claude-install-test-2 /tmp/codex-install-test-2
bash scripts/install.sh /tmp/claude-install-test-2 --harness claude-code
bash scripts/install.sh /tmp/codex-install-test-2 --harness codex-cli
find /tmp/claude-install-test-2/.claude/skills -maxdepth 1 -name 'specjedi-*' -type d | wc -l
find /tmp/codex-install-test-2/.agents/skills -maxdepth 1 -name 'specjedi-*' -type d | wc -l
```

**Expected outcome**: same skill counts as before this feature — neither
existing path's behavior changed.

## Scenario 5: Unsupported harness still refused

```bash
bash scripts/install.sh /tmp/whatever --harness some-other-tool; echo "exit: $?"
```

**Expected outcome**: nonzero exit, the existing informative refusal
message — this feature adds one new accepted value, not a general
loosening of the refusal behavior.

## Scenario 6: PowerShell counterpart parity

```powershell
Remove-Item -Recurse -Force C:\trae-install-test -ErrorAction SilentlyContinue
.\scripts\install.ps1 -TargetDir C:\trae-install-test -Harness trae
Get-ChildItem C:\trae-install-test\.trae\skills -Directory -Filter "specjedi-*" | Measure-Object
```

**Expected outcome**: same shape of result as Scenario 1.

## Scenario 7: CI proves this on all three OSes

Not reproducible locally on every OS from this machine — this is what
the new `install-test-trae`/`install-test-trae-windows-native` CI job
pair (FR-007) exists to prove for real, matching the existing
`install-test-codex-cli` job's own cross-OS verification model.
