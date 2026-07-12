# Quickstart: Verifying Warp Harness Support

**Feature**: 018-warp-support

## Scenario 1: claude-code install satisfies Warp's Skills convention

```bash
rm -rf /tmp/warp-check-claude
bash scripts/install.sh /tmp/warp-check-claude --harness claude-code
find /tmp/warp-check-claude/.claude/skills -maxdepth 1 -name 'specjedi-*' -type d -exec test -f {}/SKILL.md \; -print | wc -l
```

**Expected outcome**: matches the total installed skill count.

## Scenario 2: codex-cli install satisfies Warp's Skills convention

```bash
rm -rf /tmp/warp-check-codex
bash scripts/install.sh /tmp/warp-check-codex --harness codex-cli
find /tmp/warp-check-codex/.agents/skills -maxdepth 1 -name 'specjedi-*' -type d -exec test -f {}/SKILL.md \; -print | wc -l
```

**Expected outcome**: same count, at `.agents/skills/`.

## Scenario 3: naming and frontmatter satisfy Warp's requirement

```bash
fail=0
for dir in /tmp/warp-check-claude/.claude/skills/specjedi-*/; do
  name="$(basename "$dir")"
  grep -qE '^name:\s*\S+' "${dir}SKILL.md" || { echo "FAIL: $name missing name:"; fail=1; }
  grep -qE '^description:\s*\S+' "${dir}SKILL.md" || { echo "FAIL: $name missing description:"; fail=1; }
  echo "$name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || { echo "FAIL: $name not kebab-case"; fail=1; }
done
[ "$fail" -eq 0 ] && echo "OK: all skills satisfy Warp's Skills naming/frontmatter rule"
```

## Scenario 4: no changes to install.sh/.ps1

```bash
git diff --stat scripts/install.sh scripts/install.ps1
```

**Expected outcome**: no output.

## Scenario 5: CI proves this on every OS

Not fully reproducible locally on every OS — the new CI job proves
Scenarios 1-3 for real on all three OSes.
