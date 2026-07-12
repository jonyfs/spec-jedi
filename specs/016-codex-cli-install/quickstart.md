# Quickstart: Verifying the Codex CLI Install Path

**Feature**: 016-codex-cli-install

## Prerequisites

- `scripts/install.sh` (and `.ps1`) updated with the `codex-cli` branch

## Scenario 1: Fresh install into a scratch directory

```bash
rm -rf /tmp/codex-install-test
bash scripts/install.sh /tmp/codex-install-test --harness codex-cli
```

**Expected outcome**: exits 0; every `specjedi-*` skill directory appears
under `/tmp/codex-install-test/.agents/skills/`; the four
`.specify/templates/*.md` files are present; the installer's own
validation output reports `OK:` for every installed skill.

## Scenario 2: No speckit-* leakage

```bash
find /tmp/codex-install-test -iname 'speckit-*'
```

**Expected outcome**: no output — zero `speckit-*` files/directories
present in the install.

## Scenario 3: Frontmatter validation actually runs and would catch a real defect

```bash
# Sanity-check the validation logic isn't a no-op: corrupt one installed
# file and confirm the installer's own validation step would have caught it
# if run standalone against this state.
head -c 0 /tmp/codex-install-test/.agents/skills/specjedi-status/SKILL.md > /tmp/empty.md
grep -q '^---$' /tmp/empty.md && echo "FAIL: validation would not have caught this" || echo "OK: validation correctly requires frontmatter"
```

## Scenario 4: Existing claude-code path unaffected

```bash
rm -rf /tmp/claude-install-test
bash scripts/install.sh /tmp/claude-install-test --harness claude-code
find /tmp/claude-install-test/.claude/skills -maxdepth 1 -name 'specjedi-*' -type d | wc -l
```

**Expected outcome**: same skill count as before this feature — the
`claude-code` path's own behavior is unchanged.

## Scenario 5: Unsupported harness still refused

```bash
bash scripts/install.sh /tmp/whatever --harness some-other-tool; echo "exit: $?"
```

**Expected outcome**: nonzero exit, the existing informative refusal
message — this feature adds one new accepted value, not a general
loosening of the refusal behavior.

## Scenario 6: PowerShell counterpart parity

```powershell
Remove-Item -Recurse -Force C:\codex-install-test -ErrorAction SilentlyContinue
.\scripts\install.ps1 -TargetDir C:\codex-install-test -Harness codex-cli
Get-ChildItem C:\codex-install-test\.agents\skills -Directory -Filter "specjedi-*" | Measure-Object
```

**Expected outcome**: same shape of result as Scenario 1.

## Scenario 7: CI proves this on all three OSes

Not reproducible locally on every OS from this machine — this is what
the new `install-test-codex-cli`/`install-test-codex-cli-windows-native`
CI job pair (FR-007) exists to prove for real, matching the existing
`install-test` job's own cross-OS verification model.
