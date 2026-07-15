#!/usr/bin/env bash
# PostToolUse hook (Write|Edit|MultiEdit): flags a new or edited scripts/*.sh
# or scripts/*.ps1 with no sibling counterpart, mechanizing Constitution
# Principle XIII (every .sh ships with an equivalent .ps1) at edit-time
# instead of only at specjedi-govcheck/PR review -- this exact gap (Portuguese
# strings and missing CI coverage aside) is the kind of thing this project's
# own governance check has caught after the fact; this hook catches the
# "forgot the other platform's file entirely" case immediately.
set -euo pipefail

input="$(cat)"
file_path="$(printf '%s' "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"file_path"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')"

case "$file_path" in
  */scripts/*.sh) counterpart="${file_path%.sh}.ps1" ;;
  */scripts/*.ps1) counterpart="${file_path%.ps1}.sh" ;;
  *) exit 0 ;;
esac

[ -f "$file_path" ] || exit 0
[ -f "$counterpart" ] && exit 0

context="$(basename "$file_path") has no sibling $(basename "$counterpart") in the same directory -- Constitution Principle XIII requires both in the same change set. Add $(basename "$counterpart") with equivalent behavior before this is done."
context_escaped="$(printf '%s' "$context" | sed 's/\\/\\\\/g; s/"/\\"/g')"
printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$context_escaped"
exit 0
