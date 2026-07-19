#!/usr/bin/env bash
# Spec Jedi session-start orientation hook (Constitution Principle XXI).
# Emits an ASCII banner + on-disk-derived project status summary + a
# rotating Master Yoda greeting line as SessionStart additionalContext.
# MUST NOT block session start on any failure -- every step degrades
# gracefully (FR-007) rather than erroring out. Deliberately does not use
# `set -e`: a single missing file must produce a plainer greeting, not a
# nonzero exit that could interfere with session startup.
set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd 2>/dev/null)" || exit 0
cd "$repo_root" 2>/dev/null || exit 0

# --- Part 1: ASCII banner -------------------------------------------------
# Original Spec Jedi wordmark + lightsaber motif. Never a reproduction of
# GitHub's actual spec-kit logo or any other real trademark (Principle XXI).
banner='  ┌──────────────────────────────────────────┐
  │   ⚔══════  S P E C   J E D I  ══════⚔     │
  │        Spec-Driven Development, sharpened   │
  └──────────────────────────────────────────┘'

# --- Part 2: status summary (reuses specjedi-status's own derivation) ----
specs_dir="$repo_root/specs"
total=0
n_specified=0
n_planned=0
n_in_progress=0
n_complete=0
n_not_started=0

if [ -d "$specs_dir" ]; then
  for dir in "$specs_dir"/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    case "$name" in
      [0-9][0-9][0-9]-*) : ;;
      *) continue ;;
    esac
    total=$((total + 1))
    tasks_file="$dir/tasks.md"
    plan_file="$dir/plan.md"
    spec_file="$dir/spec.md"
    if [ -f "$tasks_file" ]; then
      # grep -c always prints a count (including "0" for zero matches) but
      # exits 1 when the count is zero -- do NOT pair it with `|| echo 0`,
      # that doubles the output to "0\n0" on a fresh, all-unchecked
      # tasks.md (caught by this script's own first real dry run).
      total_cb=$(grep -cE '^[[:space:]]*-[[:space:]]*\[[ Xx]\]' "$tasks_file" 2>/dev/null)
      done_cb=$(grep -cE '^[[:space:]]*-[[:space:]]*\[[Xx]\]' "$tasks_file" 2>/dev/null)
      total_cb=${total_cb:-0}
      done_cb=${done_cb:-0}
      if [ "$total_cb" -le 0 ] 2>/dev/null; then
        pct=0
      else
        pct=$(( done_cb * 100 / total_cb ))
      fi
      if [ "$pct" -eq 100 ]; then
        n_complete=$((n_complete + 1))
      elif [ "$pct" -eq 0 ]; then
        n_not_started=$((n_not_started + 1))
      else
        n_in_progress=$((n_in_progress + 1))
      fi
    elif [ -f "$plan_file" ]; then
      n_planned=$((n_planned + 1))
    elif [ -f "$spec_file" ]; then
      n_specified=$((n_specified + 1))
    fi
  done
fi

if [ "$total" -eq 0 ]; then
  status_line="No features yet -- run specjedi-onboard or specjedi-specify to start."
else
  status_line="${total} feature(s): ${n_complete} complete, ${n_in_progress} in progress, ${n_planned} planned, ${n_specified} specified, ${n_not_started} not started."
fi

# --- Part 3: rotating Master Yoda line -------------------------------------
# Context-aware: a line written for the "no specs yet" state (e.g. "Empty,
# this project's specs are") must never be selected when the status summary
# above already reports real features -- that would directly contradict it.
# Caught by this script's own first real dry run against this very repo's
# 15 shipped features, which surfaced exactly that contradiction.
lexicon="$repo_root/references/star-wars-lexicon.md"
yoda_line="Welcome back. Ready to build, are you."

if [ -f "$lexicon" ]; then
  # Rotation-pool entries are word-wrapped across two physical lines in the
  # source markdown (readable prose, not a machine format) -- a naive
  # single-line grep/sed truncates mid-quote for any entry that wraps.
  # Caught by this script's own dry run (one of five entries broke this
  # way); join continuation lines before extracting the quoted text.
  mapfile -t all_yoda_lines < <(
    awk '
      /^## Master Yoda Persona/ {f=1; next}
      /^## Situation/ {f=0}
      f && /^- "/ {
        if (entry != "") print entry
        entry = $0
        next
      }
      f && entry != "" && /^  / {
        line = $0
        sub(/^  */, " ", line)
        entry = entry line
        next
      }
      END { if (entry != "") print entry }
    ' "$lexicon" 2>/dev/null \
      | sed -E 's/^- "([^"]*)".*/\1/' 2>/dev/null
  ) || true

  yoda_lines=()
  for line in "${all_yoda_lines[@]+"${all_yoda_lines[@]}"}"; do
    is_empty_only=0
    case "$line" in
      *"Empty, this project"*) is_empty_only=1 ;;
    esac
    if [ "$total" -eq 0 ] && [ "$is_empty_only" -eq 1 ]; then
      yoda_lines+=("$line")
    elif [ "$total" -gt 0 ] && [ "$is_empty_only" -eq 0 ]; then
      yoda_lines+=("$line")
    fi
  done

  if [ "${#yoda_lines[@]}" -gt 0 ]; then
    idx=$(( $(date +%s 2>/dev/null || echo 0) % ${#yoda_lines[@]} ))
    yoda_line="${yoda_lines[$idx]}"
  fi
fi

# --- Part 4: skill freshness check (Constitution Principle XXII) -----------
# Advisory-only: any incomplete state (no marker, malformed marker, the
# "local-checkout" sentinel, unreachable/rate-limited API) degrades
# silently to an empty $freshness_line -- never an error, never a guess.
# Single attempt, short explicit timeout -- deliberately NOT
# bootstrap-install.sh's own 3-attempt retry loop (specs/042 research.md
# Decision 3): that loop has no per-attempt cap and would make every
# session start's worst case unbounded.
freshness_line=""
marker="$repo_root/.specify/release-marker.json"
if [ -f "$marker" ]; then
  # Isolated in its own subshell, ending in an explicit `true`: no matter
  # what fails inside (curl, grep, pipefail interaction from an empty
  # response, etc.), the subshell itself always exits 0, so this can
  # never propagate a nonzero status out to the rest of this script or
  # to whatever invoked it. The outer `|| true` is a second, redundant
  # layer of the same guarantee.
  freshness_line="$( (
    installed="$(grep -o '"installed_release":[[:space:]]*"[^"]*"' "$marker" 2>/dev/null \
      | sed -E 's/.*"([^"]*)"$/\1/')"
    if [ -n "$installed" ] && [ "$installed" != "local-checkout" ]; then
      auth_header=()
      if [ -n "${GITHUB_TOKEN:-}" ]; then
        auth_header=(-H "Authorization: Bearer $GITHUB_TOKEN")
      fi
      response="$(curl -sSL --max-time 2 ${auth_header[@]+"${auth_header[@]}"} \
        "https://api.github.com/repos/jonyfs/spec-jedi/releases/latest" 2>/dev/null)"
      # Here-string (<<<), not a `printf ... | grep -m1 ...` pipe: bash
      # writes the whole string to grep's stdin up front instead of
      # streaming it concurrently, so grep -m1 matching early and
      # closing its input can never SIGPIPE a still-writing upstream
      # `printf` -- a real, intermittent CI failure caught in
      # bootstrap-install.sh's identical pattern (research.md).
      latest="$(grep -m1 '"tag_name"' <<< "$response" 2>/dev/null \
        | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')"
      if [ -n "$latest" ] && [ "$latest" != "$installed" ]; then
        printf '%s' "Update available: $installed installed, $latest published -- ask whether to update now (specs/055); on yes, run scripts/bootstrap-install.sh/.ps1 (now backs up any locally-modified skill/template file first, specs/055 User Story 1); on no, do nothing further this session."
      fi
    fi
    true
  ) 2>/dev/null )" || true
fi

# --- Assemble and emit ------------------------------------------------------
if [ -n "$freshness_line" ]; then
  printf '%s\n\n%s\n\n%s\n\n%s\n' "$banner" "$status_line" "$yoda_line" "$freshness_line"
else
  printf '%s\n\n%s\n\n%s\n' "$banner" "$status_line" "$yoda_line"
fi

exit 0
