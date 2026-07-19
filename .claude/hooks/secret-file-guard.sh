#!/usr/bin/env bash
# PreToolUse hook (Read|Grep|Glob): actively denies calls that target a
# specific secret/credential file, at any directory depth -- closing a
# documented reliability gap in the declarative `permissions.deny`
# mechanism specs/041 already shipped (research.md Decision 1: a
# publicized Claude Code bug report found `Read` calls succeeding
# against files matching configured deny patterns). `permissions.deny`
# remains defense-in-depth only; this hook is the primary enforcement
# (Clarifications, specs/058-expand-shareable-hooks).
#
# Matching is basename-driven (mirroring dangerous-command-guard.sh's
# own token-exact philosophy): a `Grep`/`Glob` call whose `path` is a
# directory (its basename won't match any pattern below) is never
# denied -- broad, project-wide searches this repo's own `specjedi-*`
# skills run constantly must not break. Only a call whose target field
# names a specific secret-pattern file is denied.
set -euo pipefail

input="$(cat)"
tool_name="$(printf '%s' "$input" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"tool_name"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')"

target=""
case "$tool_name" in
  Read)
    target="$(printf '%s' "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"file_path"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')"
    ;;
  Grep|Glob)
    target="$(printf '%s' "$input" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"path"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')"
    ;;
  *)
    exit 0
    ;;
esac

[ -n "$target" ] || exit 0

deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}

# Compound (directory/file) patterns -- matched by path suffix, never by
# basename alone: a bare basename match ("credentials", "config.json")
# would be dangerously overbroad (an ordinary project could have an
# unrelated file with either name).
case "$target" in
  */.aws/credentials|.aws/credentials)
    deny "Blocked: reading what looks like a real secret/credential file (.aws/credentials)."
    ;;
  */.docker/config.json|.docker/config.json)
    deny "Blocked: reading what looks like a real secret/credential file (.docker/config.json)."
    ;;
esac

base="$(basename "$target" 2>/dev/null || printf '%s' "$target")"

case "$base" in
  .env.example|.env.sample|.env.template)
    exit 0
    ;;
  .env|.env.*)
    deny "Blocked: reading what looks like a real secret/credential file. If this is actually a template (.env.example etc.), rename or rephrase the request."
    ;;
  id_rsa|id_dsa|id_ecdsa|id_ed25519)
    deny "Blocked: reading what looks like a real SSH private key."
    ;;
  *.pem|*.key|*.pfx|*.p12)
    deny "Blocked: reading what looks like a real certificate/key file."
    ;;
  .npmrc|.netrc|.pgpass|.git-credentials)
    deny "Blocked: reading what looks like a real credential file."
    ;;
esac

exit 0
