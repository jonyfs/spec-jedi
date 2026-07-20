#!/usr/bin/env bash
# PreToolUse hook (Bash): blocks the narrow set of genuinely catastrophic
# commands before they run, adapted from the community's most widely-cited
# Claude Code safety hook pattern (disler/claude-code-hooks-mastery's
# pre_tool_use.py; morphllm.com's .env-blocking guide) to this project's own
# git-workflow discipline. Deliberately narrow -- `rm -rf "$tmpdir"` and
# ordinary `git push` are exactly what specjedi-implement's own test/PR flow
# does constantly and MUST NOT be blocked; only root/home wipes, force-push
# to this repo's trunk, and reading real secret files are stopped. Installed
# with explicit user confirmation (this hook can deny a tool call, unlike
# this project's other two advisory-only PostToolUse hooks).
#
# Tokenized rather than substring/glob-matched on purpose: an earlier draft
# used `case "$command" in *"rm -rf /"*)` and blocked `rm -rf
# /tmp/scratch-dir` as a false positive, because that pattern is also a
# literal substring of the command. Word-splitting and comparing whole
# tokens (a path argument must EQUAL "/", not merely start with it) is what
# actually distinguishes "wipe the root" from "operate on some path under
# root" -- every path on this OS starts with "/".
set -euo pipefail

input="$(cat)"
command="$(printf '%s' "$input" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"command"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')"

[ -n "$command" ] || exit 0

deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}

# noglob during word-splitting: an unquoted expansion would otherwise let
# bash pathname-expand a literal token like "/*" against the real
# filesystem root before this script ever compares it, defeating the exact
# "/" or "/*" token check below (and needlessly stat-ing the whole root).
set -f
# shellcheck disable=SC2206
words=($command)
set +f

has_rm=0
has_recursive_force=0
has_git=0
has_push=0
has_force_flag=0
has_main_or_master=0
read_cmd=0

for w in "${words[@]}"; do
  # Specific literal words are matched before the generic -*/--* fallbacks
  # below (shell `case` stops at the first match) so that e.g. `-f` sets
  # has_force_flag rather than being silently swallowed by the generic
  # short-flag-cluster branch.
  case "$w" in
    rm) has_rm=1 ;;
    git) has_git=1 ;;
    push) has_push=1 ;;
    --force|--force-with-lease|-f) has_force_flag=1 ;;
    main|master|main:main|master:master) has_main_or_master=1 ;;
    cat|head|tail|less|more) read_cmd=1 ;;
    --*) : ;; # any other long option (e.g. --recursive) never counted as an -rf cluster below
    -*)
      body="${w#-}"
      # Short-option cluster containing BOTH r/R and f (order-independent):
      # matches -rf/-fr/-Rf/-vrf and similar, but never a long --force/
      # --recursive, which would otherwise each satisfy half of "contains
      # r and f" on their own and produce a false positive.
      case "$body" in
        *[rR]*) case "$body" in *f*) has_recursive_force=1 ;; esac ;;
      esac
      ;;
  esac
  if [ "$has_rm" -eq 1 ] && [ "$has_recursive_force" -eq 1 ]; then
    case "$w" in
      /|/\*) deny "Blocked: rm -rf targeting the filesystem root." ;;
      "~"|'$HOME'|'${HOME}') deny "Blocked: rm -rf targeting the home directory." ;;
    esac
  fi
done

if [ "$has_git" -eq 1 ] && [ "$has_push" -eq 1 ] && [ "$has_force_flag" -eq 1 ] && [ "$has_main_or_master" -eq 1 ]; then
  deny "Blocked: force-push to main/master. This project's own git-workflow discipline (and specjedi-implement's Never list) forbids force-pushing the trunk branch."
fi

if [ "$read_cmd" -eq 1 ]; then
  for w in "${words[@]}"; do
    # Compound (directory/file) patterns -- matched against the whole
    # token, never the bare basename (specs/058-expand-shareable-hooks:
    # a basename match on "credentials"/"config.json" alone would be
    # dangerously overbroad for an ordinary project). Full pattern set
    # widened here to match secret-file-guard.sh's own FR-009 list, so
    # every Wave 1 harness relying on this same check for Read-equivalent
    # coverage (Gemini CLI/Antigravity/Codex CLI have no confirmed hook
    # surface distinct from Bash) gets the identical protection.
    case "$w" in
      */.aws/credentials|.aws/credentials)
        deny "Blocked: reading what looks like a real secret/credential file (.aws/credentials)."
        ;;
      */.docker/config.json|.docker/config.json)
        deny "Blocked: reading what looks like a real secret/credential file (.docker/config.json)."
        ;;
    esac
    base="$(basename "$w" 2>/dev/null || printf '%s' "$w")"
    case "$base" in
      .env.example|.env.sample|.env.template) continue ;;
      .env|.env.*|id_rsa|id_dsa|id_ecdsa|id_ed25519)
        deny "Blocked: reading what looks like a real secret/credential file. If this is actually a template (.env.example etc.), rename or rephrase the command."
        ;;
      *.pem|*.key|*.pfx|*.p12)
        deny "Blocked: reading what looks like a real secret/credential file. If this is actually a template (.env.example etc.), rename or rephrase the command."
        ;;
      .npmrc|.netrc|.pgpass|.git-credentials)
        deny "Blocked: reading what looks like a real credential file."
        ;;
    esac
  done
fi

exit 0
