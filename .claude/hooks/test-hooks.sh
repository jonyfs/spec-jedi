#!/usr/bin/env bash
# Reproducible test matrix for this repo's Claude Code hooks
# (.claude/hooks/*.sh), turning the ad-hoc verification done while
# authoring them into a real, re-runnable script -- run after editing any
# hook here, before committing. Exercises the bash versions directly;
# the .ps1 counterparts are logic-mirrored by hand (Constitution Principle
# XIII) and were verified against this same matrix during authoring, but
# require `pwsh` to re-check and aren't invoked by this script to keep it
# dependency-free on machines without PowerShell installed.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
hooks_dir="$repo_root/.claude/hooks"
fail=0

pass() { echo "  PASS: $1"; }
fail() { echo "  FAIL: $1"; fail=1; }

# --- skill-quality-guard.sh --------------------------------------------
echo "=== skill-quality-guard.sh ==="

for f in "$repo_root"/.claude/skills/specjedi-*/SKILL.md; do
  out=$(printf '{"tool_name":"Write","tool_input":{"file_path":"%s"}}' "$f" | "$hooks_dir/skill-quality-guard.sh")
  if [ -n "$out" ]; then
    fail "real SKILL.md flagged (false positive): $(basename "$(dirname "$f")")"
  fi
done
pass "every real specjedi-*/SKILL.md is silent (no false positives)"

tmpdir="$(mktemp -d)"
mkdir -p "$tmpdir/.claude/skills/specjedi-fake"
badfile="$tmpdir/.claude/skills/specjedi-fake/SKILL.md"
printf 'No frontmatter, no Always/Never section at all.\n' > "$badfile"
out=$(printf '{"tool_name":"Write","tool_input":{"file_path":"%s"}}' "$badfile" | "$hooks_dir/skill-quality-guard.sh")
if printf '%s' "$out" | python3 -c "import json,sys; d=json.load(sys.stdin); assert 'frontmatter' in d['hookSpecificOutput']['additionalContext'].lower()" 2>/dev/null; then
  pass "malformed SKILL.md correctly flagged with valid JSON"
else
  fail "malformed SKILL.md should have been flagged with valid JSON, got: $out"
fi
rm -rf "$tmpdir"

# --- cross-platform-parity-guard.sh -------------------------------------
echo "=== cross-platform-parity-guard.sh ==="

out=$(printf '{"tool_name":"Write","tool_input":{"file_path":"%s"}}' "$repo_root/scripts/install.sh" | "$hooks_dir/cross-platform-parity-guard.sh")
[ -z "$out" ] && pass "install.sh (has .ps1) is silent" || fail "install.sh should be silent, got: $out"

tmpdir="$(mktemp -d)/scripts"
mkdir -p "$tmpdir"
touch "$tmpdir/lonely.sh"
out=$(printf '{"tool_name":"Write","tool_input":{"file_path":"%s"}}' "$tmpdir/lonely.sh" | "$hooks_dir/cross-platform-parity-guard.sh")
[ -n "$out" ] && pass "orphan .sh with no .ps1 sibling correctly flagged" || fail "orphan .sh should have been flagged"
rm -rf "$(dirname "$tmpdir")"

# --- dangerous-command-guard.sh -----------------------------------------
echo "=== dangerous-command-guard.sh ==="

check_cmd() {
  local desc="$1" cmd="$2" expect="$3"
  local out
  out=$(python3 -c "import json,sys; print(json.dumps({'tool_name':'Bash','tool_input':{'command':sys.argv[1]}}))" "$cmd" | "$hooks_dir/dangerous-command-guard.sh")
  if [ "$expect" = "allow" ]; then
    [ -z "$out" ] && pass "$desc" || fail "$desc (should allow, got: $out)"
  else
    [ -n "$out" ] && pass "$desc" || fail "$desc (should block, was allowed)"
  fi
}

# False positives this exact matrix was written to catch during authoring
# (an earlier draft used substring/glob matching and blocked all of these):
check_cmd "temp dir cleanup allowed" 'rm -rf /tmp/scratch-dir-abc123' allow
check_cmd "cwd relative cleanup allowed" 'rm -rf ./build' allow
check_cmd "home subfolder cleanup allowed" 'rm -rf ~/Downloads/tempstuff' allow
check_cmd "ordinary git push allowed" 'git push origin feature-branch' allow
check_cmd "force push to non-trunk branch allowed" 'git push --force origin feature/rewrite-history' allow
check_cmd "force push to branch containing 'main' substring allowed" 'git push --force origin domain-migration' allow
check_cmd "cat .env.example allowed" 'cat .env.example' allow
check_cmd "cat unrelated *environment* file allowed" 'cat myenvironment.txt' allow

# True positives:
check_cmd "root wipe blocked" 'rm -rf /' block
check_cmd "root wipe wildcard blocked" 'rm -rf /*' block
check_cmd "root wipe -fr order blocked" 'rm -fr /' block
check_cmd "home wipe tilde blocked" 'rm -rf ~' block
check_cmd "home wipe \$HOME blocked" 'rm -rf $HOME' block
check_cmd "force push main blocked" 'git push --force origin main' block
check_cmd "force push -f master blocked" 'git push -f origin master' block
check_cmd "cat real .env blocked" 'cat .env' block
check_cmd "cat id_rsa blocked" 'cat ~/.ssh/id_rsa' block
check_cmd "cat .pem blocked" 'cat server.pem' block

echo
if [ "$fail" -eq 0 ]; then
  echo "All hook tests passed."
else
  echo "One or more hook tests FAILED -- see above."
  exit 1
fi
