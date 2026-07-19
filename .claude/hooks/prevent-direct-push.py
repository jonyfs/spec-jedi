#!/usr/bin/env python3
"""
Prevent Direct Push Hook.

Adapted from aitmpl.com (github.com/davila7/claude-code-templates,
cli-tool/components/hooks/git/prevent-direct-push.py) -- NOT installed
verbatim. The vendor version blocks any `git push` whenever the CURRENT
branch is main/develop, regardless of what the command actually targets:
`git push origin feature-x` while sitting on main (this project's own
routine post-merge state -- switch back to main, then push the next
feature branch) would be wrongly denied. This version resolves the
actual push target from the command's own refspec first, falling back to
the current branch only when the command doesn't name one (plain
`git push` / `git push origin`), matching real git push semantics. It
also drops the vendor's Git-Flow-specific remediation text (feature/
release/hotfix branch prefixes, a /finish command) in favor of this
project's own NNN-feature-name branches and `gh pr create` /
specjedi-implement.
"""
import json
import re
import shlex
import subprocess
import sys

PROTECTED = {"main", "develop"}

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

if input_data.get("tool_name") != "Bash":
    sys.exit(0)

command = input_data.get("tool_input", {}).get("command", "")
if not re.search(r'(^|[;&|]\s*)git\s+push\b', command):
    sys.exit(0)

try:
    words = shlex.split(command)
except ValueError:
    sys.exit(0)

if "push" not in words:
    sys.exit(0)
push_idx = words.index("push")
args = words[push_idx + 1:]

is_force_push = any(w in ("-f", "--force", "--force-with-lease") for w in args)

positional = [w for w in args if not w.startswith("-")]
# positional[0] is the remote (e.g. "origin") when present; positional[1]
# is the refspec (e.g. "main", "feature-x:main") when present.
target_branch = None
if len(positional) >= 2:
    refspec = positional[1]
    target_branch = refspec.split(":")[-1] or refspec.split(":")[0]

if target_branch is None:
    # No explicit refspec named -- resolves to the current branch's own
    # upstream, same as plain `git push` / `git push origin` / `git push
    # -u origin`.
    try:
        target_branch = subprocess.check_output(
            ["git", "branch", "--show-current"],
            stderr=subprocess.DEVNULL, text=True,
        ).strip()
    except Exception:
        target_branch = ""

if target_branch in PROTECTED and not is_force_push:
    reason = f"""❌ Direct push to '{target_branch}' is not allowed.

This project's own workflow (Constitution/CLAUDE.md, specjedi-implement):
commits only land on {', '.join(sorted(PROTECTED))} through a feature
branch + pull request -- never a direct push.

  1. Create/switch to a feature branch (specjedi-worktree, or
     `git checkout -b <NNN-feature-name>`)
  2. Commit your changes there
  3. `git push -u origin <branch>`
  4. `gh pr create` (or specjedi-implement's own PR step)

Target resolved: {target_branch}"""
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }))
    sys.exit(0)

sys.exit(0)
