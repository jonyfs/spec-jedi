#!/usr/bin/env bash
# Git-branch-aware statusline (specs/040-aitmpl-settings-improvements),
# adapted from aitmpl.com's git-branch-statusline.json
# (davila7/claude-code-templates) to avoid a jq dependency, matching
# scripts/bootstrap-install.sh's and .claude/hooks/*.sh's existing
# zero-dependency precedent -- grep/sed field extraction instead.
#
# Reads Claude Code's own statusline stdin JSON schema
# (code.claude.com/docs/en/statusline): model.display_name and
# workspace.current_dir are each a unique key in that schema, so a
# simple grep -o extraction is unambiguous without a real JSON parser.
set -euo pipefail

input="$(cat)"
model="$(printf '%s' "$input" | grep -o '"display_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"display_name"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')"
dir="$(printf '%s' "$input" | grep -o '"current_dir"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"current_dir"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')"
folder="${dir##*/}"

branch=""
if [ -n "$dir" ] && git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
  # git -C "$dir" (not relying on this script's own cwd) since the
  # statusline command's working directory isn't guaranteed to equal
  # workspace.current_dir.
  b="$(git -C "$dir" branch --show-current 2>/dev/null)"
  changes="$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  changes="${changes:-0}"
  branch=" | 🌿 ${b}"
  if [ "$changes" -gt 0 ]; then
    branch="${branch} (${changes})"
  fi
fi

printf '[%s] 📁 %s%s\n' "$model" "$folder" "$branch"
