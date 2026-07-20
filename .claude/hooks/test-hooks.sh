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
# specs/058-expand-shareable-hooks: pattern set widened to match
# secret-file-guard.sh's own FR-009 list (Wave 1 harness parity, T039).
check_cmd "cat .npmrc blocked" 'cat .npmrc' block
check_cmd "cat .aws/credentials blocked" 'cat ~/.aws/credentials' block
check_cmd "cat .docker/config.json blocked" 'cat ~/.docker/config.json' block

# --- prevent-direct-push.py (specs/058-expand-shareable-hooks, T006) ----
echo "=== prevent-direct-push.py ==="

check_push() {
  local desc="$1" cmd="$2" expect="$3"
  local out
  out=$(python3 -c "import json,sys; print(json.dumps({'tool_name':'Bash','tool_input':{'command':sys.argv[1]}}))" "$cmd" | python3 "$hooks_dir/prevent-direct-push.py")
  if [ "$expect" = "allow" ]; then
    [ -z "$out" ] && pass "$desc" || fail "$desc (should allow, got: $out)"
  else
    [ -n "$out" ] && pass "$desc" || fail "$desc (should block, was allowed)"
  fi
}

# This repo's own copy protects main/develop directly (spec.md US1
# Acceptance Scenario 1). An explicit two-part refspec is used throughout
# so target-branch resolution never falls back to `git branch
# --show-current` -- deterministic regardless of which branch this test
# actually runs on.
check_push "push to main blocked" 'git push origin main' block
check_push "push to develop blocked" 'git push origin develop' block
check_push "push to feature branch allowed" 'git push origin feature-x' allow
check_push "push to feature branch while a refspec renames it to main is blocked" 'git push origin feature-x:main' block
# Force-push to a protected branch is deliberately NOT blocked by this
# hook -- dangerous-command-guard.sh's own has_force_flag/has_main_or_master
# check already covers that case separately (see its own test matrix
# above); this hook exists for the *non-force* accidental-direct-push
# case only (see prevent-direct-push.py's own `not is_force_push` guard).
check_push "force push to main allowed here (dangerous-command-guard.sh's own job)" 'git push --force origin main' allow

# --- secret-scanner.py (specs/058-expand-shareable-hooks, T015/T017) ----
echo "=== secret-scanner.py ==="

# A real git repo, not a mock stdin -- secret-scanner.py's own logic
# calls `git diff --cached` directly, so PreToolUse's stdin only carries
# the attempted command string; the staged content comes from the real
# working tree it's invoked in.
scan_repo="$(mktemp -d)"
(
  cd "$scan_repo"
  git init -q
  git config user.email "t@example.com"
  git config user.name "T"
)

# secret-scanner.py prints its denial report to stderr and signals block
# via exit 2 (not stdout, unlike dangerous-command-guard.sh's JSON-on-
# stdout convention) -- 2>&1 is required to actually capture it; `|| true`
# keeps set -e from aborting this script on that exit 2. Separated from
# check_scan() below (which only reports pass/fail) so the raw output can
# also be inspected separately for the redaction assertion.
scan_output() {
  local filecontent="$1"
  printf '%s' "$filecontent" > "$scan_repo/secret.txt"
  (cd "$scan_repo" && git add secret.txt)
  (cd "$scan_repo" && python3 -c "import json,sys; print(json.dumps({'tool_name':'Bash','tool_input':{'command':'git commit -m test'}}))" | python3 "$hooks_dir/secret-scanner.py") 2>&1 || true
}

check_scan() {
  local desc="$1" filecontent="$2" expect="$3" out
  out="$(scan_output "$filecontent")"
  if [ "$expect" = "allow" ]; then
    [ -z "$out" ] && pass "$desc" || fail "$desc (should allow, got: $out)"
  else
    [ -n "$out" ] && pass "$desc" || fail "$desc (should block, was allowed)"
  fi
}

# Stripe live key shape, 24+ alphanumeric after the prefix.
stripe_key="sk_live_$(printf 'a%.0s' $(seq 1 28))"
scan_out="$(scan_output "const key = \"$stripe_key\";")"
if [ -n "$scan_out" ]; then pass "real-looking Stripe key blocked"; else fail "real-looking Stripe key blocked (should block, was allowed)"; fi
case "$scan_out" in
  *"$stripe_key"*)
    fail "denial output leaked the raw matched secret value (FR-012 regression)"
    ;;
  *"Match: ${stripe_key:0:4}"*"${stripe_key: -4}"*)
    pass "denial output shows a redacted match, never the raw value (FR-012)"
    ;;
  *)
    fail "denial output missing the expected redacted-match line: $scan_out"
    ;;
esac

check_scan "clean file allowed" "const greeting = \"hello world\";" allow

rm -rf "$scan_repo"

# --- conventional-commits.py (specs/058-expand-shareable-hooks, T041) ---
echo "=== conventional-commits.py ==="

check_commit_msg() {
  local desc="$1" cmd="$2" expect="$3"
  local out
  out=$(python3 -c "import json,sys; print(json.dumps({'tool_name':'Bash','tool_input':{'command':sys.argv[1]}}))" "$cmd" | python3 "$hooks_dir/conventional-commits.py")
  if [ "$expect" = "allow" ]; then
    [ -z "$out" ] && pass "$desc" || fail "$desc (should allow, got: $out)"
  else
    [ -n "$out" ] && pass "$desc" || fail "$desc (should block, was allowed)"
  fi
}

check_commit_msg "non-conventional message blocked" 'git commit -m "fixed a thing"' block
check_commit_msg "conventional feat: message allowed" 'git commit -m "feat: add user authentication"' allow
check_commit_msg "conventional fix(scope): message allowed" 'git commit -m "fix(api): handle null responses"' allow
check_commit_msg "non-commit command allowed (nothing to check)" 'git status' allow

# --- secret-file-guard.sh (specs/058-expand-shareable-hooks, T026) ------
echo "=== secret-file-guard.sh ==="

check_guard() {
  local desc="$1" tool="$2" field="$3" value="$4" expect="$5"
  local out
  out=$(python3 -c "
import json, sys
print(json.dumps({'tool_name': sys.argv[1], 'tool_input': {sys.argv[2]: sys.argv[3]}}))
" "$tool" "$field" "$value" | "$hooks_dir/secret-file-guard.sh")
  if [ "$expect" = "allow" ]; then
    [ -z "$out" ] && pass "$desc" || fail "$desc (should allow, got: $out)"
  else
    [ -n "$out" ] && pass "$desc" || fail "$desc (should block, was allowed)"
  fi
}

check_guard "root .env denied" "Read" "file_path" "/tmp/some-project/.env" block
check_guard "nested .env denied (SC-005)" "Read" "file_path" "/tmp/some-project/packages/api/.env" block
check_guard ".env.example allowed (SC-006)" "Read" "file_path" "/tmp/some-project/.env.example" allow
check_guard ".env.sample allowed" "Read" "file_path" "/tmp/some-project/.env.sample" allow
check_guard "unrelated file allowed" "Read" "file_path" "/tmp/some-project/README.md" allow
check_guard "id_rsa denied" "Read" "file_path" "/home/user/.ssh/id_rsa" block
check_guard "id_ed25519 denied" "Read" "file_path" "/home/user/.ssh/id_ed25519" block
check_guard "*.pem denied" "Read" "file_path" "/tmp/some-project/server.pem" block
check_guard ".npmrc denied" "Read" "file_path" "/tmp/some-project/.npmrc" block
check_guard ".aws/credentials denied" "Read" "file_path" "/home/user/.aws/credentials" block
check_guard "Grep on a specific .env file denied" "Grep" "path" "/tmp/some-project/.env" block
check_guard "Grep with a directory path never denied" "Grep" "path" "/tmp/some-project" allow
check_guard "Glob with a directory path never denied" "Glob" "path" "/tmp/some-project" allow

# --- statusline.sh (specs/040-aitmpl-settings-improvements) -------------
echo "=== statusline.sh ==="

statusline_input() {
  python3 -c "import json,sys; print(json.dumps({'model':{'display_name':sys.argv[1]},'workspace':{'current_dir':sys.argv[2]}}))" "$1" "$2"
}

tmpdir="$(mktemp -d)"
(
  cd "$tmpdir"
  git init -q
  git config user.email "test@example.com"
  git config user.name "Test"
  git checkout -q -b clean-branch
  touch placeholder
  git add placeholder
  git commit -q -m "init"
)
out="$(statusline_input "Sonnet" "$tmpdir" | "$repo_root/.claude/statusline.sh")"
case "$out" in
  *"[Sonnet]"*"clean-branch"*)
    if printf '%s' "$out" | grep -qE '\([0-9]+\)'; then
      fail "clean tree statusline should have no change count, got: $out"
    else
      pass "clean tree shows model, folder, and branch with no change count"
    fi
    ;;
  *) fail "clean tree statusline missing expected content: $out" ;;
esac

echo "dirty" >> "$tmpdir/placeholder"
out="$(statusline_input "Sonnet" "$tmpdir" | "$repo_root/.claude/statusline.sh")"
case "$out" in
  *"clean-branch (1)"*) pass "dirty tree shows a (1) change count" ;;
  *) fail "dirty tree statusline missing change count: $out" ;;
esac
rm -rf "$tmpdir"

tmpdir="$(mktemp -d)"
out="$(statusline_input "Sonnet" "$tmpdir" | "$repo_root/.claude/statusline.sh")"
case "$out" in
  *"🌿"*) fail "non-git dir statusline should have no branch segment, got: $out" ;;
  *"[Sonnet]"*) pass "non-git dir degrades to model+folder, no error" ;;
  *) fail "non-git dir statusline missing expected content: $out" ;;
esac
rm -rf "$tmpdir"

# --- update_shared_settings() (scripts/install.sh, specs/041) -----------
echo "=== update_shared_settings() ==="

# Sourced into a function-only subshell scope via eval so its own
# `exit 1` (matching update_memory_file's established fail-loudly
# convention) only terminates that one check, not this whole test run.
merge_fn_src="$(sed -n '/^update_shared_settings()/,/^}/p' "$repo_root/scripts/install.sh")"

tmpdir="$(mktemp -d)"
target="$tmpdir/.claude/settings.json"
bash -c "$merge_fn_src"'; update_shared_settings "'"$target"'"' >/dev/null
if python3 -m json.tool "$target" >/dev/null 2>&1 && grep -q '"statusLine"' "$target" && grep -q '"permissions"' "$target"; then
  pass "fresh file: valid JSON with both keys"
else
  fail "fresh file: invalid JSON or missing keys"
fi
rm -rf "$tmpdir"

tmpdir="$(mktemp -d)"
mkdir -p "$tmpdir/.claude"
target="$tmpdir/.claude/settings.json"
cat > "$target" << 'SETTINGSEOF'
{
  "hooks": {
    "SessionStart": [{"hooks": [{"type": "command", "command": "echo hi"}]}]
  }
}
SETTINGSEOF
bash -c "$merge_fn_src"'; update_shared_settings "'"$target"'"' >/dev/null
if python3 -m json.tool "$target" >/dev/null 2>&1 && grep -q '"SessionStart"' "$target" && grep -q '"statusLine"' "$target" && grep -q '"permissions"' "$target"; then
  pass "pre-existing unrelated content preserved, new keys added (SC-003)"
else
  fail "existing-content-preserved check failed"
fi

first_content="$(cat "$target")"
bash -c "$merge_fn_src"'; update_shared_settings "'"$target"'"' >/dev/null
second_content="$(cat "$target")"
if [ "$first_content" = "$second_content" ]; then
  pass "idempotent re-run: byte-identical (FR-004)"
else
  fail "idempotent re-run: content changed on second run"
fi
rm -rf "$tmpdir"

tmpdir="$(mktemp -d)"
mkdir -p "$tmpdir/.claude"
target="$tmpdir/.claude/settings.json"
printf '{ "hooks": {} ' > "$target"
if bash -c "$merge_fn_src"'; update_shared_settings "'"$target"'"' >/tmp/merge-test-out.txt 2>&1; then
  fail "malformed JSON (unbalanced braces) should have failed loudly, but succeeded"
else
  if grep -q "FAIL:" /tmp/merge-test-out.txt && grep -q "unbalanced braces" /tmp/merge-test-out.txt; then
    pass "malformed JSON fails loudly with a clear message, never guesses"
  else
    fail "malformed JSON failed but without the expected clear message: $(cat /tmp/merge-test-out.txt)"
  fi
fi
rm -rf "$tmpdir" /tmp/merge-test-out.txt

# --- Stop-hook wiring (scripts/install.sh, specs/058 US4, T051) ---------
echo "=== Stop-hook wiring (merge_json_key) ==="

# A temp-script-file approach (not inline bash -c string composition)
# since the stop_block's own command string embeds single/double quotes
# that make nested bash -c quoting too fragile to get right.
merge_key_fn_src="$(sed -n '/^merge_json_key()/,/^}/p' "$repo_root/scripts/install.sh")"
run_stop_merge_script="$(mktemp)"
{
  printf '%s\n' "$merge_key_fn_src"
  cat << 'CALLEOF'
stop_block='  "Stop": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "if command -v osascript >/dev/null 2>&1; then osascript -e '"'"'display notification \"Response complete\" with title \"Claude Code\"'"'"'; elif command -v notify-send >/dev/null 2>&1; then notify-send \"Claude Code\" \"Response complete\"; fi"
        }
      ]
    }
  ]'
merge_json_key "$1" '"Stop"' "$stop_block" "Stop notification hook wired"
CALLEOF
} > "$run_stop_merge_script"

tmpdir="$(mktemp -d)"
mkdir -p "$tmpdir/.claude"
target="$tmpdir/.claude/settings.json"
printf '{\n  "statusLine": {}\n}\n' > "$target"
bash "$run_stop_merge_script" "$target" >/dev/null
if python3 -m json.tool "$target" >/dev/null 2>&1 && grep -q '"Stop"' "$target" && grep -q '"statusLine"' "$target"; then
  pass "Stop hook block added, pre-existing statusLine preserved"
else
  fail "Stop hook block not added correctly, or existing content lost"
fi

first_content="$(cat "$target")"
bash "$run_stop_merge_script" "$target" >/dev/null
second_content="$(cat "$target")"
if [ "$first_content" = "$second_content" ]; then
  pass "Stop hook re-run: byte-identical (idempotent)"
else
  fail "Stop hook re-run: content changed on second run"
fi
rm -rf "$tmpdir"

tmpdir="$(mktemp -d)"
mkdir -p "$tmpdir/.claude"
target="$tmpdir/.claude/settings.json"
cat > "$target" << 'STOPEOF'
{
  "hooks": {
    "Stop": [{"hooks": [{"type": "command", "command": "echo my-own-notifier"}]}]
  }
}
STOPEOF
bash "$run_stop_merge_script" "$target" >/dev/null
if grep -q "my-own-notifier" "$target" && ! grep -q "osascript" "$target"; then
  pass "existing Stop array left alone, never overwritten (non-destructive)"
else
  fail "an existing Stop array was overwritten -- should have been left as-is"
fi
rm -rf "$tmpdir" "$run_stop_merge_script"

echo
if [ "$fail" -eq 0 ]; then
  echo "All hook tests passed."
else
  echo "One or more hook tests FAILED -- see above."
  exit 1
fi
