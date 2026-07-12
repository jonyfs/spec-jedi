# Quickstart: Verifying OpenCode Harness Support

**Feature**: 017-opencode-support

## Scenario 1: claude-code install satisfies OpenCode's Claude-compatible path

```bash
rm -rf /tmp/opencode-check-claude
bash scripts/install.sh /tmp/opencode-check-claude --harness claude-code
find /tmp/opencode-check-claude/.claude/skills -maxdepth 1 -name 'specjedi-*' -type d -exec test -f {}/SKILL.md \; -print | wc -l
```

**Expected outcome**: matches the total installed skill count — every
skill directory has a `SKILL.md` at exactly the path OpenCode's
`.claude/skills/<name>/SKILL.md` convention expects.

## Scenario 2: codex-cli install satisfies OpenCode's agent-compatible path

```bash
rm -rf /tmp/opencode-check-codex
bash scripts/install.sh /tmp/opencode-check-codex --harness codex-cli
find /tmp/opencode-check-codex/.agents/skills -maxdepth 1 -name 'specjedi-*' -type d -exec test -f {}/SKILL.md \; -print | wc -l
```

**Expected outcome**: same count, same shape, at `.agents/skills/`.

## Scenario 3: every installed skill's name satisfies OpenCode's exact rule

```bash
fail=0
for dir in /tmp/opencode-check-claude/.claude/skills/specjedi-*/; do
  name="$(basename "$dir")"
  fm_name="$(grep -m1 '^name:' "$dir/SKILL.md" | sed -E 's/^name:[[:space:]]*//' | tr -d '[:space:]"'"'"'')"
  [ "$name" = "$fm_name" ] || { echo "FAIL: dir/frontmatter mismatch: $name"; fail=1; }
  echo "$name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || { echo "FAIL: invalid name format: $name"; fail=1; }
done
[ "$fail" -eq 0 ] && echo "OK: all skill names satisfy OpenCode's naming rule"
```

## Scenario 4: no changes to install.sh/.ps1

```bash
git diff --stat scripts/install.sh scripts/install.ps1
```

**Expected outcome**: no output — zero changes to either file (FR-004,
SC-003).

## Scenario 5: CI proves this on every OS

Not fully reproducible locally on every OS — the new CI job (FR-001,
FR-002) proves Scenarios 1-3 for real on `ubuntu-latest`, `macos-latest`,
and `windows-latest`.
