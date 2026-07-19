#!/usr/bin/env python3
"""
Conventional Commits Hook.

Adapted from aitmpl.com (github.com/davila7/claude-code-templates,
cli-tool/components/hooks/git/conventional-commits.py) -- installed via
specjedi-master to mechanize a rule this project's own git-workflow.md
rules already state as convention (type: description, same type list)
but never enforced technically until now.

One fix from the vendor original: it tried the plain `-m "message"`
regex before the heredoc-specific one, and that plain regex's
`[^"\']+` character class stops at the FIRST quote of either kind --
including the single quote inside this project's own
`-m "$(cat <<'EOF' ...` heredoc convention (used in literally every
commit this session makes). That let the plain regex "succeed" with
garbage ("$(cat <<") before the heredoc branch ever ran, denying every
real heredoc commit. Trying the heredoc pattern first fixes it.
"""
import json
import sys
import re

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
    sys.exit(1)

tool_name = input_data.get("tool_name", "")
tool_input = input_data.get("tool_input", {})
command = tool_input.get("command", "")

# Only validate git commit commands
if tool_name != "Bash" or "git commit" not in command:
    sys.exit(0)

# Extract commit message from -m flag.
# Heredoc format tried first: -m "$(cat <<'EOF' ... EOF)" -- checked
# before the plain quote regex below, whose [^"\']+ class would
# otherwise stop at the single quote inside <<'EOF' and "succeed" with
# garbage (see module docstring).
heredoc_match = re.search(r'git commit.*?-m\s+"?\$\(cat\s+<<["\']?EOF["\']?\s*\n(.+?)\nEOF', command, re.DOTALL)
if heredoc_match:
    commit_msg = heredoc_match.group(1).strip()
else:
    # Plain -m "message" or -m 'message' format
    match = re.search(r'git commit.*?-m\s+["\']([^"\']+)["\']', command)
    if not match:
        sys.exit(0)  # Can't extract message, allow it
    commit_msg = match.group(1)

# Check if message follows Conventional Commits format
# Format: type(scope)?: description
# Types: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert
conventional_pattern = r'^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?:\s.+'

if not re.match(conventional_pattern, commit_msg):
    reason = f"""❌ Invalid commit message format

Your message: {commit_msg}

Commit messages must follow Conventional Commits:
  type(scope): description

Types:
  feat:     New feature
  fix:      Bug fix
  docs:     Documentation changes
  style:    Code style changes (formatting)
  refactor: Code refactoring
  perf:     Performance improvements
  test:     Adding or updating tests
  chore:    Maintenance tasks
  ci:       CI/CD changes
  build:    Build system changes
  revert:   Revert previous commit

Examples:
  ✅ feat: add user authentication
  ✅ feat(auth): implement JWT tokens
  ✅ fix: resolve memory leak in parser
  ✅ fix(api): handle null responses
  ✅ docs: update API documentation

Invalid:
  ❌ Added new feature (no type)
  ❌ feat:add feature (missing space after colon)
  ❌ feature: add login (wrong type, use 'feat')

💡 Tip: Start your message with one of the types above followed by a colon and space."""

    output = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason
        }
    }
    print(json.dumps(output))
    sys.exit(0)

# Allow the command
sys.exit(0)
