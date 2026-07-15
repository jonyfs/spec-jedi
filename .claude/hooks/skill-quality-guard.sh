#!/usr/bin/env bash
# PostToolUse hook (Write|Edit|MultiEdit): live authoring-standard check for
# specjedi-*/SKILL.md files, mechanizing Constitution Principle XIX so a
# violation surfaces at edit-time instead of only later at
# specjedi-skill-review/specjedi-govcheck. PostToolUse can't undo the write
# (docs.claude.com/hooks), so this reports via additionalContext rather than
# blocking -- the same "auto-lint on save, surface don't silently fail"
# pattern used by community PostToolUse validators (e.g.
# disler/claude-code-hooks-mastery's ruff_validator.py/ty_validator.py),
# adapted here to this project's actual lint surface (SKILL.md structure)
# instead of a language linter, since this repo ships Markdown skill
# packages, not application source.
set -euo pipefail

input="$(cat)"
file_path="$(printf '%s' "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"file_path"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')"

case "$file_path" in
  */.claude/skills/specjedi-*/SKILL.md) ;;
  *) exit 0 ;;
esac

[ -f "$file_path" ] || exit 0

issues=""
nl="$(printf '\nx')"; nl="${nl%x}"

first_line="$(head -n 1 "$file_path")"
if [ "$first_line" != "---" ]; then
  issues="${issues}- Missing YAML frontmatter: file must start with \`---\` (Principle XIX Structure).${nl}"
fi
if ! grep -qE '^name:[[:space:]]*\S+' "$file_path"; then
  issues="${issues}- Frontmatter missing \`name:\` (Principle XIX Structure).${nl}"
fi
if ! grep -qE '^description:[[:space:]]*\S+' "$file_path"; then
  issues="${issues}- Frontmatter missing \`description:\` (Principle XIX Structure).${nl}"
fi

# Word-count * 1.3 is a common rough token-count heuristic, not a real
# tokenizer -- good enough for a soft edit-time warning; specjedi-tokencheck
# and the actual CI battery are the authoritative checks.
word_count="$(wc -w < "$file_path" | tr -d ' ')"
approx_tokens=$(( word_count * 13 / 10 ))
if [ "$approx_tokens" -gt 5000 ]; then
  issues="${issues}- Approx. ${approx_tokens} tokens (word-count heuristic) -- Principle XIX caps SKILL.md at roughly 5,000; move detail to references/ (progressive disclosure).${nl}"
fi

if ! grep -qiE '\*\*Always\*\*|## Always' "$file_path" || ! grep -qiE '\*\*Never\*\*|## Never' "$file_path"; then
  issues="${issues}- No clear Always-Do/Never-Do guardrail section found (Principle XIX).${nl}"
fi

if [ -z "$issues" ]; then
  exit 0
fi

context="Skill authoring standard check on $(basename "$(dirname "$file_path")")/SKILL.md found:${nl}${issues}Fix before considering this skill done (Constitution Principle XIX)."
# JSON-string-escape: backslash and double-quote per line, then join lines
# with the two-character \n escape (NOT a real newline byte, which isn't
# valid inside a JSON string) -- awk (not GNU sed's :a;N;$!ba loop, which
# BSD sed on macOS doesn't accept) for portability across contributor OSes.
context_escaped="$(printf '%s' "$context" | awk 'BEGIN{ORS=""} { gsub(/\\/,"\\\\"); gsub(/"/,"\\\""); if (NR>1) printf "\\n"; printf "%s", $0 }')"
printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$context_escaped"
exit 0
