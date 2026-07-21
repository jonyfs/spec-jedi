#!/usr/bin/env bash
# Spec Jedi zero-footprint installer (Constitution Principle XVIII).
# Copies the specjedi-* product skills (never speckit-* bootstrap tooling)
# into a target project, plus the .specify/templates/*.md files those skills
# depend on at runtime. Product-only by default, harness-selected, validated
# after copy — not just asserted to work.
#
# Two install modes, chosen per --harness (Principle III's 20-harness
# compatibility matrix, specs/023-full-harness-coverage/research.md):
#   1. skills-dir: the harness natively scans a directory of SKILL.md
#      packages (claude-code, codex-cli, trae, antigravity). Full packages
#      copied as-is, exactly as before this feature.
#   2. bridge: the harness only reads a project-root rules file, a small
#      directory of rule files, or (Cody) a custom-commands JSON file --
#      never a self-describing skills directory. The full specjedi-*
#      packages are still copied to .claude/skills/ as the canonical
#      source; a generated bridge file / set of files points into it so
#      the harness's own native mechanism can find them.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_dir="."
target_dir_given=0
harness=""
auto_mode=0

usage() {
  cat <<'EOF'
Usage: install.sh [TARGET_DIR] [--harness HARNESS] [--auto]

  TARGET_DIR   Project to install Spec Jedi's specjedi-* skills into.
               Defaults to the current directory.
  --harness    Which coding agent to configure for. All 20 harnesses in
               Constitution Principle III's compatibility matrix are
               supported: claude-code, codex-cli, trae, antigravity
               (native skills-directory scanning); cursor, windsurf,
               copilot, gemini-cli, cline, continue, aider, amazon-q,
               jetbrains-ai, zed, replit, devin, tabnine, cody (bridge
               file(s) pointing at the canonical .claude/skills/ package
               -- see specs/023-full-harness-coverage/research.md for the
               per-harness mechanism and citation). If omitted, the
               installer attempts harness auto-detection among
               claude-code/codex-cli/trae (specs/021-harness-auto-detection);
               the 17 other harnesses require an explicit --harness since
               they have no reliable filesystem/PATH detection signal yet.
  --auto       When --harness is omitted and detection finds more than
               one plausible harness, automatically select the
               Recommended one instead of prompting interactively
               (Constitution Principle IV's Recommended-option standard).
               Ignored when --harness is given explicitly.

Copies only the specjedi-* product skills (never the vendored speckit-*
bootstrap tooling this repo uses to build itself) plus the four
.specify/templates/*.md files those skills read at runtime.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --harness)
      harness="${2:-}"
      shift 2
      ;;
    --auto)
      auto_mode=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      target_dir="$1"
      target_dir_given=1
      shift
      ;;
  esac
done

# specs/040-interactive-install: fully-interactive mode only triggers
# when truly NO arguments were given at all (no target dir, no
# --harness, no --auto) AND a real terminal is available to prompt
# through -- any explicit flag, or a non-interactive context (CI,
# piped input, no TTY), preserves the exact prior default/silent-auto-
# detect behavior completely untouched. Existing scripted/CI usage
# (always passes --harness explicitly) never triggers this.
interactive_mode=0
if [ "$target_dir_given" -eq 0 ] && [ -z "$harness" ] && [ "$auto_mode" -eq 0 ] && [ -t 0 ]; then
  interactive_mode=1
fi

if [ "$interactive_mode" -eq 1 ]; then
  echo "🧙 No parameters were given — let's set this up together, step by step."
  echo "   (Type 'c' at any time to cancel without installing anything.)"
  echo
  echo "[1/2] Which directory should this install into?"
  read -r -p "      Current directory [$(pwd)], another path, or 'c' to cancel: " answer
  case "$answer" in
    c|C|cancel|Cancel)
      echo "Installation cancelled — nothing was changed."
      exit 0
      ;;
    "") ;;
    *) target_dir="$answer" ;;
  esac
  echo
fi

mkdir -p "$target_dir"
target_dir="$(cd "$target_dir" && pwd)"

# specs/040-interactive-install: presents all 18 --harness values (the
# 20-harness compatibility matrix minus opencode/warp, which piggyback
# on claude-code/codex-cli with no separate flag) so a user in
# interactive_mode can pick one directly instead of being forced back
# to the command line with an explicit --harness. Sets $harness to the
# chosen value, or to "cancel" if the user backs out -- callers check
# for that sentinel themselves rather than this function exiting, so a
# caller mid-flow (e.g. the one-match confirmation declining) can
# choose how to unwind.
prompt_full_harness_list() {
  echo "Choose a harness (or 'c' to cancel):"
  echo "   1. claude-code    -- Claude Code"
  echo "   2. codex-cli      -- Codex CLI (OpenAI)"
  echo "   3. trae           -- Trae"
  echo "   4. antigravity    -- Antigravity (Google)"
  echo "   5. cursor         -- Cursor"
  echo "   6. windsurf       -- Windsurf (Codeium)"
  echo "   7. cline          -- Cline"
  echo "   8. continue       -- Continue"
  echo "   9. amazon-q       -- Amazon Q Developer"
  echo "  10. jetbrains-ai   -- JetBrains AI Assistant"
  echo "  11. tabnine        -- Tabnine"
  echo "  12. gemini-cli     -- Gemini CLI"
  echo "  13. zed            -- Zed"
  echo "  14. replit         -- Replit Agent"
  echo "  15. aider          -- Aider"
  echo "  16. copilot        -- GitHub Copilot (Chat/Workspace)"
  echo "  17. devin          -- Devin (Cognition)"
  echo "  18. cody           -- Sourcegraph Cody"
  read -r -p "> " pick
  case "$pick" in
    c|C|cancel|Cancel) harness="cancel" ;;
    1|claude-code) harness="claude-code" ;;
    2|codex-cli) harness="codex-cli" ;;
    3|trae) harness="trae" ;;
    4|antigravity) harness="antigravity" ;;
    5|cursor) harness="cursor" ;;
    6|windsurf) harness="windsurf" ;;
    7|cline) harness="cline" ;;
    8|continue) harness="continue" ;;
    9|amazon-q) harness="amazon-q" ;;
    10|jetbrains-ai) harness="jetbrains-ai" ;;
    11|tabnine) harness="tabnine" ;;
    12|gemini-cli) harness="gemini-cli" ;;
    13|zed) harness="zed" ;;
    14|replit) harness="replit" ;;
    15|aider) harness="aider" ;;
    16|copilot) harness="copilot" ;;
    17|devin) harness="devin" ;;
    18|cody) harness="cody" ;;
    *)
      echo "🔭 '$pick' is not a valid option."
      prompt_full_harness_list
      ;;
  esac
}

# Harness auto-detection (specs/021-harness-auto-detection): only runs
# when --harness was omitted. Any explicit --harness value bypasses all
# of this entirely -- zero behavior change for existing scripted/CI usage.
# Scoped to the three harnesses with a real filesystem/PATH signal; the 17
# bridge-file harnesses added in specs/023-full-harness-coverage have no
# such signal (a rules file's mere presence isn't strong evidence of which
# *harness* is in use the way a binary on PATH or a config dir is) and
# always require an explicit --harness.
if [ -z "$harness" ]; then
  signals=()

  if [ -d "$target_dir/.claude" ]; then
    signals+=("claude-code:1:target directory ($target_dir/.claude)")
  fi
  if command -v claude >/dev/null 2>&1; then
    signals+=("claude-code:2:PATH binary (claude)")
  fi
  if [ -d "${HOME:-}/.claude" ]; then
    signals+=("claude-code:3:global config (~/.claude)")
  fi

  if [ -d "$target_dir/.agents" ]; then
    signals+=("codex-cli:1:target directory ($target_dir/.agents)")
  fi
  if command -v codex >/dev/null 2>&1; then
    signals+=("codex-cli:2:PATH binary (codex)")
  fi
  if [ -d "${HOME:-}/.codex" ]; then
    signals+=("codex-cli:3:global config (~/.codex)")
  fi

  if [ -d "$target_dir/.trae" ]; then
    signals+=("trae:1:target directory ($target_dir/.trae)")
  fi
  # trae has no established cross-platform PATH binary to check
  # (it's a GUI-first IDE) -- see specs/021-harness-auto-detection/research.md
  if [ -d "${HOME:-}/.trae" ]; then
    signals+=("trae:3:global config (~/.trae)")
  fi

  claude_rank=""
  claude_evidence=""
  codex_rank=""
  codex_evidence=""
  trae_rank=""
  trae_evidence=""

  if [ "${#signals[@]}" -gt 0 ]; then
    for sig in "${signals[@]}"; do
      sig_harness="${sig%%:*}"
      sig_rest="${sig#*:}"
      sig_rank="${sig_rest%%:*}"
      sig_evidence="${sig_rest#*:}"
      case "$sig_harness" in
        claude-code)
          if [ -z "$claude_rank" ] || [ "$sig_rank" -lt "$claude_rank" ]; then
            claude_rank="$sig_rank"
            claude_evidence="$sig_evidence"
          fi
          ;;
        codex-cli)
          if [ -z "$codex_rank" ] || [ "$sig_rank" -lt "$codex_rank" ]; then
            codex_rank="$sig_rank"
            codex_evidence="$sig_evidence"
          fi
          ;;
        trae)
          if [ -z "$trae_rank" ] || [ "$sig_rank" -lt "$trae_rank" ]; then
            trae_rank="$sig_rank"
            trae_evidence="$sig_evidence"
          fi
          ;;
      esac
    done
  fi

  match_count=0
  [ -n "$claude_rank" ] && match_count=$((match_count + 1))
  [ -n "$codex_rank" ] && match_count=$((match_count + 1))
  [ -n "$trae_rank" ] && match_count=$((match_count + 1))

  if [ "$match_count" -eq 0 ]; then
    if [ "$interactive_mode" -eq 1 ]; then
      echo "[2/2] No harness was detected automatically."
      prompt_full_harness_list
      if [ "$harness" = "cancel" ]; then
        echo "Installation cancelled — nothing was changed."
        exit 0
      fi
    else
      harness="claude-code"
      echo "🔭 No harness detected on this machine/target directory — falling"
      echo "back to the default: claude-code (this is a fallback, not a"
      echo "detected match)."
    fi
  elif [ "$match_count" -eq 1 ]; then
    if [ -n "$claude_rank" ]; then
      detected_harness="claude-code"
      detected_evidence="$claude_evidence"
    elif [ -n "$codex_rank" ]; then
      detected_harness="codex-cli"
      detected_evidence="$codex_evidence"
    else
      detected_harness="trae"
      detected_evidence="$trae_evidence"
    fi
    if [ "$interactive_mode" -eq 1 ]; then
      echo "[2/2] Detected $detected_harness ($detected_evidence)."
      read -r -p "      Install for $detected_harness? [Y/n, or 'c' to cancel]: " confirm
      case "$confirm" in
        n|N|no|No)
          prompt_full_harness_list
          if [ "$harness" = "cancel" ]; then
            echo "Installation cancelled — nothing was changed."
            exit 0
          fi
          ;;
        c|C|cancel|Cancel)
          echo "Installation cancelled — nothing was changed."
          exit 0
          ;;
        *)
          harness="$detected_harness"
          ;;
      esac
    else
      harness="$detected_harness"
      echo "🔭 Detected $detected_harness (${detected_evidence}) — installing automatically."
    fi
  else
    recommended=""
    recommended_rank=999
    for cand in claude-code codex-cli trae; do
      case "$cand" in
        claude-code) cand_rank="$claude_rank" ;;
        codex-cli) cand_rank="$codex_rank" ;;
        trae) cand_rank="$trae_rank" ;;
      esac
      if [ -n "$cand_rank" ] && [ "$cand_rank" -lt "$recommended_rank" ]; then
        recommended="$cand"
        recommended_rank="$cand_rank"
      fi
    done

    if [ "$auto_mode" -eq 1 ] || [ ! -t 0 ]; then
      harness="$recommended"
      echo "🔭 Multiple harnesses detected — auto-selecting Recommended:"
      echo "$recommended (--auto passed, or no interactive terminal available)."
    else
      echo "🔭 Multiple harnesses detected on this machine/target directory:"
      letters="ABC"
      idx=0
      letter_map=()
      for cand in claude-code codex-cli trae; do
        case "$cand" in
          claude-code) cand_rank="$claude_rank"; cand_evidence="$claude_evidence" ;;
          codex-cli) cand_rank="$codex_rank"; cand_evidence="$codex_evidence" ;;
          trae) cand_rank="$trae_rank"; cand_evidence="$trae_evidence" ;;
        esac
        if [ -n "$cand_rank" ]; then
          letter="${letters:$idx:1}"
          letter_map+=("$letter:$cand")
          if [ "$cand" = "$recommended" ]; then
            echo "  $letter. $cand (Recommended — $cand_evidence)"
          else
            echo "  $letter. $cand ($cand_evidence)"
          fi
          idx=$((idx + 1))
        fi
      done
      recommended_letter=""
      for lm in "${letter_map[@]}"; do
        lm_letter="${lm%%:*}"
        lm_harness="${lm#*:}"
        if [ "$lm_harness" = "$recommended" ]; then
          recommended_letter="$lm_letter"
        fi
      done
      read -r -p "Choice [$recommended_letter] (or 'c' to cancel): " choice
      choice="${choice:-$recommended_letter}"
      case "$choice" in
        c|C|cancel|Cancel)
          echo "Installation cancelled — nothing was changed."
          exit 0
          ;;
      esac
      harness="$recommended"
      for lm in "${letter_map[@]}"; do
        lm_letter="${lm%%:*}"
        lm_harness="${lm#*:}"
        if [ "$choice" = "$lm_letter" ] || [ "$choice" = "$lm_harness" ]; then
          harness="$lm_harness"
        fi
      done
    fi
  fi
fi

# specs/041-release-hooks-settings: shareable hooks/settings (the
# generic safety hook + git-aware permissions, never the two
# repo-internal-only hooks) default on for every non-interactive
# invocation (FR-001c); an interactive session gets asked once, as part
# of the same summary/confirmation moment, not a separate later prompt.
install_shared_hooks=1
# specs/058-expand-shareable-hooks (User Story 3, FR-003): unlike the
# pure safety nets above (default-on), conventional-commits.py enforces
# a stylistic convention -- explicit opt-in only, via its own separate
# prompt, defaulting to declined ([y/N], opposite of the main prompt's
# [Y/n]). Never installed on a non-interactive run (no FR-001c-style
# default-on carve-out for this one hook).
install_conventional_commits=0

# specs/058-expand-shareable-hooks: explicit test seam, same rationale as
# has_python3()'s own SPECJEDI_TEST_FORCE_NO_PYTHON3 -- CI needs to
# exercise this specific prompt block deterministically while keeping
# $target_dir/$harness exactly as explicitly passed (unlike forcing the
# global $interactive_mode, which would also re-trigger the earlier
# directory/harness wizard prompts above and break every other
# scratch-install test's reproducibility). Never a documented public flag.
if [ "$interactive_mode" -eq 1 ] || [ -n "${SPECJEDI_TEST_FORCE_HOOKS_PROMPT:-}" ]; then
  echo
  echo "Summary:"
  echo "  Directory: $target_dir"
  echo "  Harness:   $harness"
  read -r -p "Also install shareable hooks/settings (safety hook, git-aware permissions)? [Y/n]: " hooks_answer
  case "$hooks_answer" in
    n|N|no|No) install_shared_hooks=0 ;;
  esac
  if [ "$install_shared_hooks" -eq 1 ]; then
    read -r -p "Also install conventional-commits.py (enforces 'type: description' commit messages)? [y/N]: " cc_answer
    case "$cc_answer" in
      y|Y|yes|Yes) install_conventional_commits=1 ;;
    esac
  fi
  read -r -p "Continue with installation? [Y/n]: " proceed
  case "$proceed" in
    n|N|no|No)
      echo "Installation cancelled — nothing was changed."
      exit 0
      ;;
  esac
  echo
fi

# Harness Target mapping (specs/023-full-harness-coverage/data-model.md):
# every harness shares the same source skills, the same runtime templates,
# and the same post-copy validation below. skills_dst_rel is always where
# the full specjedi-* packages land; bridge_mode/bridge_dst_rel (unset for
# skills-dir harnesses) control whether an additional adapter file gets
# generated afterward for a harness with no native skills-directory scan.
bridge_mode=""
bridge_dst_rel=""
case "$harness" in
  claude-code)
    skills_dst_rel=".claude/skills"
    ;;
  codex-cli)
    # Verified against Codex CLI's own official docs
    # (learn.chatgpt.com/docs/build-skills): repository-level skills are
    # scanned from .agents/skills, walking up to repo root; SKILL.md
    # requires the same name/description frontmatter specjedi-* skills
    # already carry -- no content rewrite needed (specs/016-codex-cli-install/research.md).
    skills_dst_rel=".agents/skills"
    ;;
  trae)
    # Verified against Trae's official Skills docs, community docs, and
    # Vercel's own `skills` CLI source (skillsDir: '.trae/skills' for the
    # trae agent target): project-local skills are scanned from
    # .trae/skills, same name/description frontmatter -- no content
    # rewrite needed (specs/019-trae-support/research.md).
    skills_dst_rel=".trae/skills"
    ;;
  antigravity)
    # Google Antigravity (the tool absorbing Gemini CLI's role) defaults
    # to the same .agents/skills convention Codex CLI already uses --
    # confirmed across Google's own Codelabs/Developer docs and community
    # verification posts (specs/023-full-harness-coverage/research.md).
    # Needs zero new code, same precedent as OpenCode/Warp piggybacking on
    # an existing target directory.
    skills_dst_rel=".agents/skills"
    ;;
  cursor)
    skills_dst_rel=".claude/skills"
    bridge_mode="dir"
    bridge_dst_rel=".cursor/rules"
    ;;
  windsurf)
    skills_dst_rel=".claude/skills"
    bridge_mode="dir"
    bridge_dst_rel=".windsurf/rules"
    ;;
  cline)
    skills_dst_rel=".claude/skills"
    bridge_mode="dir"
    bridge_dst_rel=".clinerules"
    ;;
  continue)
    skills_dst_rel=".claude/skills"
    bridge_mode="dir"
    bridge_dst_rel=".continue/rules"
    ;;
  amazon-q)
    skills_dst_rel=".claude/skills"
    bridge_mode="dir"
    bridge_dst_rel=".amazonq/rules"
    ;;
  jetbrains-ai)
    skills_dst_rel=".claude/skills"
    bridge_mode="dir"
    bridge_dst_rel=".aiassistant/rules"
    ;;
  tabnine)
    skills_dst_rel=".claude/skills"
    bridge_mode="dir"
    bridge_dst_rel=".tabnine/guidelines"
    ;;
  gemini-cli)
    skills_dst_rel=".claude/skills"
    bridge_mode="single"
    bridge_dst_rel="GEMINI.md"
    ;;
  zed)
    skills_dst_rel=".claude/skills"
    bridge_mode="single"
    bridge_dst_rel=".rules"
    ;;
  replit)
    skills_dst_rel=".claude/skills"
    bridge_mode="single"
    bridge_dst_rel="replit.md"
    ;;
  aider)
    skills_dst_rel=".claude/skills"
    bridge_mode="single"
    bridge_dst_rel="CONVENTIONS.md"
    ;;
  copilot)
    skills_dst_rel=".claude/skills"
    bridge_mode="single"
    bridge_dst_rel=".github/copilot-instructions.md"
    ;;
  devin)
    skills_dst_rel=".claude/skills"
    bridge_mode="devin"
    bridge_dst_rel=".devin.md"
    ;;
  cody)
    skills_dst_rel=".claude/skills"
    bridge_mode="cody"
    bridge_dst_rel=".vscode/cody.json"
    ;;
  opencode)
    # specs/041-release-hooks-settings: previously "piggybacked" on
    # claude-code/codex-cli's own skills output with no dedicated flag --
    # both already satisfy OpenCode's scanning convention (see
    # opencode-compatibility's own CI job, which verifies both paths). A
    # real --harness opencode value is needed now that this feature adds
    # OpenCode-native permissions translation (opencode.json), which has
    # no equivalent reachable under claude-code/codex-cli's own harness
    # value.
    skills_dst_rel=".claude/skills"
    ;;
  warp)
    # Same reasoning as opencode above -- see warp-compatibility's own CI
    # job; Warp's Skills system already scans .claude/skills/ directly.
    skills_dst_rel=".claude/skills"
    ;;
  *)
    echo "🔭 '$harness' isn't a recognized harness. See --help for the full"
    echo "list of 20 supported values (Constitution Principle III)."
    exit 1
    ;;
esac

echo "📜 Installing Spec Jedi's specjedi-* skills into: $target_dir"
echo

skills_src="$repo_root/.claude/skills"
skills_dst="$target_dir/$skills_dst_rel"
mkdir -p "$skills_dst"

# specs/055-safe-skill-update-hook: before any overwrite below replaces
# an already-installed skill/template, back up the existing copy first
# if it genuinely differs from what's about to replace it -- a locally
# hand-edited file (or one from an agent session) must never be
# silently destroyed by a routine update. Backs up nothing on a first
# install (FR-003): $dst simply doesn't exist yet, so the early return
# fires and $backup_root is never even created.
backup_root=""
backup_if_differs() {
  # $1 = source about to replace $2 = existing target path.
  local src="$1" dst="$2"
  [ -e "$dst" ] || return 0
  if ! diff -rq "$src" "$dst" >/dev/null 2>&1; then
    if [ -z "$backup_root" ]; then
      backup_root="$target_dir/.specify/backups/$(date -u +%Y%m%dT%H%M%SZ)"
      mkdir -p "$backup_root"
    fi
    cp -R "$dst" "$backup_root/$(basename "$dst")"
    echo "  🗄️  backed up locally-modified $(basename "$dst") -> ${backup_root#"$target_dir/"}"
  fi
}

installed=0
for skill_path in "$skills_src"/specjedi-*/; do
  skill_name="$(basename "$skill_path")"
  backup_if_differs "$skill_path" "$skills_dst/$skill_name"
  rm -rf "${skills_dst:?}/$skill_name"
  cp -R "$skill_path" "$skills_dst/$skill_name"
  echo "  ✅ $skill_name"
  installed=$((installed + 1))
done

if [ "$installed" -eq 0 ]; then
  echo "FAIL: no specjedi-* skills found under $skills_src — is this run from a Spec Jedi checkout?"
  exit 1
fi

# specs/067-ship-agents-in-release-package: the project-local
# .claude/agents/orchestrate-*.md definitions are Claude-Code-specific
# (Agent/Workflow tool definitions, per feature 065's own scoping) --
# only copy them for a claude-code target, and never create an empty
# .claude/agents/ directory for any other harness.
if [ "$harness" = "claude-code" ]; then
  agents_src="$repo_root/.claude/agents"
  agents_dst="$target_dir/.claude/agents"
  if [ -d "$agents_src" ]; then
    mkdir -p "$agents_dst"
    for agent_path in "$agents_src"/*.md; do
      [ -e "$agent_path" ] || continue
      agent_name="$(basename "$agent_path")"
      backup_if_differs "$agent_path" "$agents_dst/$agent_name"
      cp "$agent_path" "$agents_dst/$agent_name"
      echo "  ✅ .claude/agents/$agent_name"
    done
  fi
fi

echo
echo "📚 Installing runtime template dependencies..."
templates_dst="$target_dir/.specify/templates"
mkdir -p "$templates_dst"
for template in constitution-template.md spec-template.md plan-template.md tasks-template.md; do
  backup_if_differs "$repo_root/.specify/templates/$template" "$templates_dst/$template"
  cp "$repo_root/.specify/templates/$template" "$templates_dst/$template"
  echo "  ✅ $template"
done

# specs/042-skill-freshness-validation: records which release produced
# this install (Constitution Principle XXII) -- a prerequisite for the
# session-start freshness check to have anything to compare against.
# $repo_root here is install.sh's own source location, which is either:
#   (a) an extracted release tarball (package-release.sh staged a
#       RELEASE_VERSION stamp file at its root -- whether extracted by
#       bootstrap-install.sh or manually by a user), or
#   (b) a real git checkout (has .git), or
#   (c) neither (not a scenario either installer script currently
#       produces, but a safe fallback matters more than a fabricated
#       version).
write_release_marker() {
  local target="$1" value
  if [ -f "$repo_root/RELEASE_VERSION" ]; then
    value="$(tr -d '[:space:]' < "$repo_root/RELEASE_VERSION")"
  elif [ -d "$repo_root/.git" ]; then
    value="local-checkout"
  else
    value="local-checkout"
  fi
  mkdir -p "$target/.specify"
  printf '{"installed_release": "%s"}\n' "$value" > "$target/.specify/release-marker.json"
  echo "  ✅ .specify/release-marker.json ($value)"
}
write_release_marker "$target_dir"

# Bridge-file generation (specs/023-full-harness-coverage): only runs for
# harnesses with no native skills-directory scan. Reads name/description
# straight back out of the just-installed .claude/skills/specjedi-*/SKILL.md
# files, so the bridge always reflects what actually landed on disk.
json_escape() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

utf8_len() {
  # Counts Unicode characters, not bytes, regardless of the runtime's
  # ambient locale. ${#str} and ${str:offset:length} both count/slice by
  # BYTE under a byte-oriented locale (e.g. C/POSIX) but by CHARACTER
  # under a UTF-8 locale -- confirmed to actually differ across GitHub-
  # hosted runners (Windows Git Bash counted this repo's em-dash-heavy
  # skill descriptions by byte, Ubuntu/macOS by character), producing a
  # different 160-char truncation point on Windows and breaking
  # install.sh/.ps1 cross-script byte-parity (Constitution Principle
  # XIII). Forcing LC_ALL=C here doesn't request byte-counting -- it
  # forces a KNOWN, CONSISTENT byte-oriented view so this function can
  # reliably identify and strip UTF-8 continuation bytes (0x80-0xBF)
  # itself, which is what actually makes the result locale-independent.
  local LC_ALL=C
  local str="$1" stripped
  stripped="${str//[$'\200'-$'\277']/}"
  printf '%s' "${#stripped}"
}

utf8_truncate() {
  # Truncates $1 to at most $2 Unicode characters (never splitting a
  # multi-byte character in half, unlike a naive byte-based ${str:0:N}),
  # locale-independent for the same reason utf8_len is.
  local LC_ALL=C
  local str="$1" max="$2" char_count=0 byte_pos=0 len=${#1} byte
  while [ "$byte_pos" -lt "$len" ]; do
    byte="${str:$byte_pos:1}"
    case "$byte" in
      [$'\200'-$'\277'])
        byte_pos=$((byte_pos + 1))
        ;;
      *)
        if [ "$char_count" -ge "$max" ]; then
          break
        fi
        char_count=$((char_count + 1))
        byte_pos=$((byte_pos + 1))
        ;;
    esac
  done
  printf '%s' "${str:0:$byte_pos}"
}

first_sentence() {
  # Truncates a description to its first sentence (up to the first ". " --
  # period-then-space, not just any period, so abbreviations like
  # "spec.md"/"SKILL.md" inside a description don't cause a false cut),
  # falling back to a 160-char hard cap -- Principle XVI/XX token economy:
  # the full detail already lives in the SKILL.md this line points to.
  # ${desc%%. *} is a portable (bash 3.2+, no GNU-only regex) way to keep
  # everything before the first ". ": %% removes the *longest* matching
  # suffix, and the suffix starting at the earliest ". " is the longest
  # one that matches, so this lands on the first sentence boundary.
  local desc="$1" cut
  cut="${desc%%. *}"
  if [ "$cut" != "$desc" ]; then
    desc="$cut."
  fi
  if [ "$(utf8_len "$desc")" -gt 160 ]; then
    desc="$(utf8_truncate "$desc" 157)"
    # Trim back to the last complete word (last space) rather than
    # cutting at the exact character boundary -- a raw character cut
    # regularly landed mid-word (e.g. "...journey, k...",
    # "...directly t..."), a confusing fragment for something an agent
    # reads directly as its own session-start context (CLAUDE.md/
    # AGENTS.md/.trae/rules' generated section, specs/039). No-op if
    # there's no space in the truncated string at all.
    case "$desc" in
      *" "*) desc="${desc% *}" ;;
    esac
    desc="${desc}..."
  fi
  printf '%s' "$desc"
}

skill_meta() {
  # Prints "name<TAB>description" for one SKILL.md.
  local skill_file="$1" name desc
  name="$(grep -m1 -E '^name:[[:space:]]*' "$skill_file" | sed -E 's/^name:[[:space:]]*//')"
  desc="$(grep -m1 -E '^description:[[:space:]]*' "$skill_file" | sed -E 's/^description:[[:space:]]*//')"
  printf '%s\t%s\n' "$name" "$(first_sentence "$desc")"
}

# specs/039-memory-file-skill-mentions: for harnesses with a confirmed,
# separate project-memory-file convention distinct from their skills
# directory (CLAUDE.md, AGENTS.md, .trae/rules/project_rules.md), create
# or idempotently update a marker-delimited section naming the installed
# skills -- never for antigravity (no confirmed convention) or the 14
# bridge harnesses (their existing bridge file already serves this
# purpose).
memory_section() {
  # $1 = skills_dst_rel (e.g. ".claude/skills"), for the "installed at"
  # sentence. Reads skill metadata from $skills_dst (already populated
  # by the copy loop above skill_meta is already used in).
  local skills_dst_rel="$1"
  echo "<!-- SPEC-JEDI:SKILLS:START -->"
  echo "## Spec Jedi skills available in this project"
  echo
  echo "This project has the Spec Jedi spec-driven-development skill set"
  echo "installed at \`$skills_dst_rel/\`. When a request matches one of"
  echo "the skills below, open and follow the full instructions in its"
  echo "\`SKILL.md\` before responding. New to Spec Jedi? Start with"
  echo "\`specjedi-onboard\`."
  echo
  echo "| Skill | What it does |"
  echo "|---|---|"
  for f in "$skills_dst"/specjedi-*/SKILL.md; do
    IFS=$'\t' read -r name desc < <(skill_meta "$f")
    echo "| \`$name\` | $desc |"
  done
  echo "<!-- SPEC-JEDI:SKILLS:END -->"
}

update_memory_file() {
  # $1 = absolute path to the memory file, $2 = skills_dst_rel.
  local memory_path="$1" skills_dst_rel="$2"
  local start_marker="<!-- SPEC-JEDI:SKILLS:START -->"
  local end_marker="<!-- SPEC-JEDI:SKILLS:END -->"
  local new_section
  new_section="$(memory_section "$skills_dst_rel")"

  mkdir -p "$(dirname "$memory_path")"

  if [ ! -f "$memory_path" ]; then
    printf '%s\n' "$new_section" > "$memory_path"
    echo "  ✅ $(basename "$memory_path") created"
    return
  fi

  # Capture the file's raw bytes losslessly (a sentinel "x" appended
  # inside the same command substitution absorbs $(...)'s own trailing-
  # newline stripping, so the file's actual trailing bytes -- whatever
  # they are -- survive untouched), then strip exactly one trailing \n
  # ourselves. Plain "$(cat "$memory_path")" was tried first and found
  # to behave inconsistently across bash builds: on Windows Git Bash it
  # strips a trailing \r along with the \n (unlike macOS/Linux bash,
  # which strips only \n), silently losing a CRLF-terminated file's
  # trailing \r and producing a bare-LF ending after the later printf
  # re-append -- confirmed via CI byte diagnostics showing the suffix
  # one byte short on windows-latest only. Mirrors install.ps1's
  # `-replace '\n$', ''`, which strips the same single character.
  local content
  content="$(cat "$memory_path"; echo x)"
  content="${content%x}"
  content="${content%$'\n'}"

  local has_start=0 has_end=0
  case "$content" in *"$start_marker"*) has_start=1 ;; esac
  case "$content" in *"$end_marker"*) has_end=1 ;; esac

  if [ "$has_start" -ne "$has_end" ]; then
    echo "FAIL: $memory_path has a Spec Jedi marker without its matching pair -- refusing to guess where the managed section ends. Remove the stray marker manually and re-run."
    exit 1
  fi

  if [ "$has_start" -eq 1 ]; then
    # Whole-content substring slicing, not a line-by-line rewrite: %%
    # removes the longest suffix starting at the FIRST occurrence of
    # start_marker (everything before it, untouched); ## removes the
    # longest prefix ending at the LAST occurrence of end_marker
    # (leaving everything after it, untouched). This is CRLF-safe by
    # construction -- there's no per-line $0-style comparison to be
    # defeated by a trailing \r. Bytes outside the markers -- CRLF or
    # not -- are never touched, only sliced around.
    local before after
    before="${content%%"$start_marker"*}"
    after="${content##*"$end_marker"}"
    printf '%s%s%s\n' "$before" "$new_section" "$after" > "$memory_path"
    echo "  ✅ $(basename "$memory_path") updated (existing Spec Jedi section refreshed)"
  else
    printf '\n%s\n' "$new_section" >> "$memory_path"
    echo "  ✅ $(basename "$memory_path") updated (Spec Jedi section appended)"
  fi
}

# specs/041-release-hooks-settings: detects the TARGET repo's actual
# default/trunk branch so the shared dangerous-command-guard's
# force-push check protects the branch that's really in use there
# (develop/trunk/release/...), not a hardcoded main/master that may not
# even exist in that repo. git symbolic-ref reads local metadata (fast,
# no network); git remote show origin is the fallback when that
# metadata was never set locally (e.g. right after a shallow clone).
# Returns the literal two-word string "main master" -- never nothing --
# when neither detection path succeeds, so the installed hook always
# has at least the same protection this repo's own copy has.
detect_trunk_branch() {
  local dir="$1" branch
  branch="$(git -C "$dir" symbolic-ref refs/remotes/origin/HEAD --short 2>/dev/null | sed 's@^origin/@@')"
  if [ -z "$branch" ]; then
    branch="$(git -C "$dir" remote show origin 2>/dev/null | sed -n 's/^ *HEAD branch: //p')"
  fi
  if [ -n "$branch" ]; then
    printf '%s' "$branch"
  else
    printf '%s' "main master"
  fi
}

# specs/058-expand-shareable-hooks (FR-005): gates every Python-based
# shareable hook (secret-scanner.py, prevent-direct-push.py,
# conventional-commits.py) on python3's actual presence on the target
# machine -- near-universal on macOS/Linux, never guaranteed on a bare
# Windows environment. Never installs something silently non-functional
# (Principle XX). dangerous-command-guard.sh/secret-file-guard.sh are
# bash, zero-dependency, and never gated on this check.
has_python3() {
  # Explicit test seam, not a real installer feature: CI needs to assert
  # FR-005's skip-with-warning behavior deterministically across Linux/
  # macOS/Windows, and every attempt to simulate "python3 absent" by
  # mutating the real environment (shadow-PATH symlinks, PATH filtering,
  # renaming the real binary aside) failed for a different real,
  # platform-specific reason on this feature's own CI run: MSYS2 DLL
  # resolution breaks for symlinked binaries on Windows, filtering
  # python3's own PATH directory can remove unrelated coreutils that
  # share it, and renaming the real system python3 aside needs root on
  # a stock Ubuntu/macOS runner. A dependency-injection env var sidesteps
  # all three at once, verified only by CI, never read from a real user's
  # own environment (SPECJEDI_TEST_* is not a documented public flag).
  if [ -n "${SPECJEDI_TEST_FORCE_NO_PYTHON3:-}" ]; then
    return 1
  fi
  command -v python3 >/dev/null 2>&1
}

# specs/058-expand-shareable-hooks: builds prevent-direct-push.py's own
# Python-set-literal substitution value from a space-separated trunk
# branch list (the same $trunk_branch detect_trunk_branch() already
# returns) -- e.g. {"main"} or {"main", "master"}. Distinct from the
# bash case-pattern trunk_pattern used for dangerous-command-guard.sh,
# since Python set syntax isn't expressible in that same form.
build_python_protected_set() {
  local trunk_branch="$1" python_protected=""
  for b in $trunk_branch; do
    if [ -n "$python_protected" ]; then
      python_protected="${python_protected}, \"${b}\""
    else
      python_protected="\"${b}\""
    fi
  done
  printf '{%s}' "$python_protected"
}

# specs/041-release-hooks-settings: merges the shareable statusLine/
# permissions keys into the TARGET's own .claude/settings.json without
# touching anything else already there (FR-003/FR-004). NOTE this
# deliberately does not use the marker-delimited substring-slicing
# technique update_memory_file() uses for Markdown files -- Claude
# Code's settings.json is confirmed STRICT JSON (no // comments; see
# multiple open anthropics/claude-code feature requests asking for
# JSONC support, still unimplemented as of this research), so a
# "// SPEC-JEDI:...:START" marker would itself be invalid JSON. Instead:
# each of the two keys is added independently, only if genuinely absent
# (idempotent, and safe against a target that already customized one but
# not the other); if a key already exists, it is left completely alone
# rather than attempting a deep-merge without a real JSON parser (the
# project's established zero-jq precedent) -- non-destructive by
# refusing to touch what it can't safely parse, not by guessing.
update_shared_settings() {
  local target="$1"
  mkdir -p "$(dirname "$target")"

  local statusline_block='  "statusLine": {
    "type": "command",
    "command": "bash",
    "args": ["${CLAUDE_PROJECT_DIR}/.claude/statusline.sh"]
  }'
  local permissions_block='  "permissions": {
    "allow": [
      "Bash(git status)",
      "Bash(git diff:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)",
      "Bash(git pull:*)",
      "Bash(git log:*)"
    ],
    "deny": [
      "Read(**/.env)",
      "Read(**/.env.*)",
      "Read(**/secrets/**)",
      "Read(**/config/credentials.json)",
      "Read(**/id_rsa)",
      "Read(**/id_dsa)",
      "Read(**/id_ecdsa)",
      "Read(**/id_ed25519)",
      "Read(**/*.pem)",
      "Read(**/*.key)",
      "Read(**/*.pfx)",
      "Read(**/*.p12)",
      "Read(**/.npmrc)",
      "Read(**/.netrc)",
      "Read(**/.pgpass)",
      "Read(**/.git-credentials)",
      "Read(**/.aws/credentials)",
      "Read(**/.docker/config.json)"
    ]
  }'

  if [ ! -f "$target" ]; then
    printf '{\n%s,\n%s\n}\n' "$statusline_block" "$permissions_block" > "$target"
    echo "  ✅ $(basename "$target") created with statusLine/permissions"
    return
  fi

  local content
  content="$(cat "$target"; echo x)"
  content="${content%x}"

  local has_statusline=0 has_permissions=0
  case "$content" in *'"statusLine"'*) has_statusline=1 ;; esac
  case "$content" in *'"permissions"'*) has_permissions=1 ;; esac

  if [ "$has_statusline" -eq 1 ] && [ "$has_permissions" -eq 1 ]; then
    echo "  ℹ️  $(basename "$target") already has statusLine and permissions — leaving as-is."
    return
  fi

  content="$(printf '%s' "$content" | sed -e 's/[[:space:]]*$//')"
  # Brace-balance check, not just "ends with }": a file like
  # '{ "hooks": {} ' (missing the real outer close) still ends in '}'
  # (the inner object's), which a bare last-character check would miss
  # -- confirmed by this exact case during T014's test-first pass.
  # Counting isn't a full parser (a literal '{'/'}' inside a string
  # value would throw it off) but is a real, meaningful step up from a
  # last-character check, within the zero-dependency constraint.
  local open_count close_count
  open_count="$(grep -o '{' <<<"$content" | wc -l | tr -d ' ')"
  close_count="$(grep -o '}' <<<"$content" | wc -l | tr -d ' ')"
  if [ "$open_count" != "$close_count" ] || [[ "$content" != *"}" ]]; then
    echo "FAIL: $target has unbalanced braces ($open_count '{' vs $close_count '}') — not valid JSON, refusing to guess. Fix it manually and re-run."
    exit 1
  fi
  local body="${content%\}}"
  body="$(printf '%s' "$body" | sed -e 's/[[:space:]]*$//')"

  local new_keys=""
  if [ "$has_statusline" -eq 0 ]; then
    new_keys="$statusline_block"
  fi
  if [ "$has_permissions" -eq 0 ]; then
    if [ -n "$new_keys" ]; then
      new_keys="${new_keys},
${permissions_block}"
    else
      new_keys="$permissions_block"
    fi
  fi

  if [[ "$body" == *"{" ]]; then
    # Original file was just "{}" -- no leading comma needed.
    printf '%s\n%s\n}\n' "$body" "$new_keys" > "$target"
  else
    printf '%s,\n%s\n}\n' "$body" "$new_keys" > "$target"
  fi
  echo "  ✅ $(basename "$target") updated (statusLine/permissions added)"
}

# specs/041-release-hooks-settings (User Story 2): shared non-destructive
# single-top-level-key JSON merge -- the exact same brace-balance-check-
# and-slice algorithm update_shared_settings already uses for statusLine/
# permissions, generalized once a fourth target settings file (Gemini/
# Antigravity/OpenCode/Zed) needed the identical merge -- a real, repeated
# pattern now, not a premature abstraction (plan.md's own "third/fourth
# harness proves a pattern" reasoning for when to factor).
# specs/061-install-merge-pretooluse: merges the given missing hook
# filenames into an EXISTING target settings.json's hooks.PreToolUse
# array, under the named matcher group (creating the group if absent).
# Deliberate, scoped exception to this file's own general "never
# round-trip parse settings.json" caution (see update_shared_settings's
# neighboring comment) -- Python 3.7+ preserves dict insertion order, so
# no content is lost or reordered by this json.load/json.dump round
# trip; the only side effect is possible re-indentation to this
# project's own 2-space convention (spec.md Clarifications, FR-008).
# Requires python3 -- callers MUST gate on has_python3 first.
merge_pretooluse_hooks() {
  local target="$1" matcher="$2" hooks="$3"
  python3 - "$target" "$matcher" $hooks <<'PYEOF'
import json, sys

target, matcher, *hook_files = sys.argv[1:]

try:
    with open(target) as f:
        data = json.load(f)
except json.JSONDecodeError as e:
    print(f"FAIL: {target} is not valid JSON ({e}) -- refusing to guess, fix it manually and re-run.")
    sys.exit(1)

def entry_for(hook_file):
    if hook_file.endswith(".py"):
        return {
            "type": "command",
            "command": f'python3 "${{CLAUDE_PROJECT_DIR}}/.claude/hooks/{hook_file}"'
        }
    return {
        "type": "command",
        "command": "bash",
        "args": [f"${{CLAUDE_PROJECT_DIR}}/.claude/hooks/{hook_file}"]
    }

pretooluse = data.setdefault("hooks", {}).setdefault("PreToolUse", [])
group = next((g for g in pretooluse if g.get("matcher") == matcher), None)
if group is None:
    group = {"matcher": matcher, "hooks": []}
    pretooluse.append(group)

existing = {json.dumps(h, sort_keys=True) for h in group["hooks"]}
for hf in hook_files:
    e = entry_for(hf)
    if json.dumps(e, sort_keys=True) not in existing:
        group["hooks"].append(e)

with open(target, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PYEOF
}

merge_json_key() {
  local target="$1" key_check="$2" block="$3" ok_message="$4"
  mkdir -p "$(dirname "$target")"

  if [ ! -f "$target" ]; then
    printf '{\n%s\n}\n' "$block" > "$target"
    echo "  ✅ $(basename "$target") created ($ok_message)"
    return
  fi

  local content
  content="$(cat "$target"; echo x)"
  content="${content%x}"

  case "$content" in
    *"$key_check"*)
      # specs/063-merge-json-key-array-merge: when python3 is available
      # and the existing key's value is a JSON array, and the new
      # block's own top-level value is also an array, merge the missing
      # items in (content-deduplicated) instead of silently leaving the
      # file untouched -- reusing the same parse/dedup/write technique
      # merge_pretooluse_hooks() already proved (specs/061). Any other
      # shape (object, scalar, mismatch) falls through to the original
      # conservative message, unchanged.
      if has_python3; then
        local key_name merge_status merge_exit
        key_name="${key_check#\"}"
        key_name="${key_name%\"}"
        merge_status="$(python3 - "$target" "$key_name" "$block" <<'PYEOF'
import json, sys

target, key_name, block = sys.argv[1], sys.argv[2], sys.argv[3]

try:
    with open(target) as f:
        data = json.load(f)
except json.JSONDecodeError as e:
    print(f"FAIL: {target} is not valid JSON ({e}) -- refusing to guess, fix it manually and re-run.")
    sys.exit(1)

existing = data.get(key_name)
try:
    new_value = json.loads("{" + block + "}")[key_name]
except (json.JSONDecodeError, KeyError):
    print("SKIP")
    sys.exit(0)

def is_matcher_group(item):
    return isinstance(item, dict) and "matcher" in item and "hooks" in item

if isinstance(existing, list) and isinstance(new_value, list):
    # specs/063: an array of {"matcher": ..., "hooks": [...]} groups (the
    # same shape merge_pretooluse_hooks() already handles for
    # PreToolUse, and "Stop"'s own real shape) needs group-aware
    # merging -- a new group with the same matcher value merges into
    # that existing group's own hooks array (deduplicated), rather than
    # two same-matcher groups sitting side by side. A plain array of
    # standalone items (no matcher/hooks shape) falls back to whole-item
    # dedup-append.
    changed = False
    if all(is_matcher_group(i) for i in existing + new_value):
        for new_group in new_value:
            match = next((g for g in existing if g.get("matcher") == new_group.get("matcher")), None)
            if match is None:
                existing.append(new_group)
                changed = True
                continue
            seen = {json.dumps(h, sort_keys=True) for h in match["hooks"]}
            for h in new_group["hooks"]:
                if json.dumps(h, sort_keys=True) not in seen:
                    match["hooks"].append(h)
                    changed = True
    else:
        seen = {json.dumps(item, sort_keys=True) for item in existing}
        for item in new_value:
            if json.dumps(item, sort_keys=True) not in seen:
                existing.append(item)
                changed = True
    # Only rewrite the file when something was actually appended --
    # re-running against content that's already fully present must stay
    # a true no-op (SC-003), never a reformat-only write. A prior
    # version always wrote+dumped here regardless of `changed`, which
    # silently reformatted the *entire* settings.json (Python's own
    # indent=2 array style differs from the bash-heredoc-produced
    # compact single-line arrays elsewhere in the file) on every re-run
    # -- confirmed the hard way via a real CI idempotency-test failure.
    if changed:
        with open(target, "w") as f:
            json.dump(data, f, indent=2)
            f.write("\n")
        print("MERGED")
    else:
        print("SKIP")
else:
    print("SKIP")
PYEOF
)"
        merge_exit=$?
        if [ "$merge_exit" -ne 0 ]; then
          echo "$merge_status"
          exit 1
        fi
        if [ "$merge_status" = "MERGED" ]; then
          echo "  ✅ $(basename "$target") updated ($ok_message)"
          return
        fi
      fi
      echo "  ℹ️  $(basename "$target") already has this key — leaving as-is."
      return
      ;;
  esac

  content="$(printf '%s' "$content" | sed -e 's/[[:space:]]*$//')"
  local open_count close_count
  open_count="$(grep -o '{' <<<"$content" | wc -l | tr -d ' ')"
  close_count="$(grep -o '}' <<<"$content" | wc -l | tr -d ' ')"
  if [ "$open_count" != "$close_count" ] || [[ "$content" != *"}" ]]; then
    echo "FAIL: $target has unbalanced braces ($open_count '{' vs $close_count '}') — not valid JSON, refusing to guess. Fix it manually and re-run."
    exit 1
  fi
  local body="${content%\}}"
  body="$(printf '%s' "$body" | sed -e 's/[[:space:]]*$//')"

  if [[ "$body" == *"{" ]]; then
    printf '%s\n%s\n}\n' "$body" "$block" > "$target"
  else
    printf '%s,\n%s\n}\n' "$body" "$block" > "$target"
  fi
  echo "  ✅ $(basename "$target") updated ($ok_message)"
}

if [ -n "$bridge_mode" ]; then
  echo
  echo "🌉 Generating $harness bridge file(s)..."
  bridge_dst="$target_dir/$bridge_dst_rel"

  case "$bridge_mode" in
    dir)
      mkdir -p "$bridge_dst"
      bridge_count=0
      while IFS=$'\t' read -r name desc; do
        [ -z "$name" ] && continue
        {
          echo "<!-- Managed by Spec Jedi's installer (scripts/install.sh/.ps1)."
          echo "     Re-running the installer regenerates this file. -->"
          echo
          echo "# $name"
          echo
          echo "$desc"
          echo
          echo "Full instructions: \`.claude/skills/$name/SKILL.md\` — read and follow it in full when this applies."
        } > "$bridge_dst/$name.md"
        bridge_count=$((bridge_count + 1))
      done < <(for f in "$skills_dst"/specjedi-*/SKILL.md; do skill_meta "$f"; done)
      echo "  ✅ $bridge_count bridge file(s) under $bridge_dst_rel/"
      ;;
    single|devin)
      mkdir -p "$(dirname "$bridge_dst")"
      {
        echo "<!-- Managed by Spec Jedi's installer (scripts/install.sh/.ps1)."
        echo "     Re-running the installer regenerates this file. -->"
        echo
        if [ "$bridge_mode" = "devin" ]; then
          echo "# Spec Jedi Playbook"
          echo
          echo "## Specifications"
          echo
          echo "This project has the Spec Jedi spec-driven-development skill set"
          echo "installed at \`.claude/skills/\`. Each skill below is a self-contained"
          echo "Markdown instruction file with YAML frontmatter."
          echo
          echo "## Procedure"
          echo
          echo "1. When a request matches one of the skills in the table below, open"
          echo "   its \`SKILL.md\` in full and follow its instructions before responding."
          echo "2. New to Spec Jedi? Start with \`specjedi-onboard\`."
          echo
          echo "## Advice"
          echo
        else
          echo "# Spec Jedi skills available in this project"
          echo
          echo "This project has the Spec Jedi spec-driven-development skill set"
          echo "installed at \`.claude/skills/\`. This harness reads a single"
          echo "project-level instructions file rather than scanning a skills"
          echo "directory, so this index bridges the gap: when a request matches"
          echo "one of the skills below, open and follow the full instructions in"
          echo "its \`SKILL.md\` before responding. New to Spec Jedi? Start with"
          echo "\`specjedi-onboard\`."
          echo
        fi
        echo "| Skill | What it does |"
        echo "|---|---|"
        for f in "$skills_dst"/specjedi-*/SKILL.md; do
          IFS=$'\t' read -r name desc < <(skill_meta "$f")
          echo "| \`$name\` | $desc |"
        done
      } > "$bridge_dst"
      echo "  ✅ $bridge_dst_rel"
      ;;
    cody)
      mkdir -p "$(dirname "$bridge_dst")"
      {
        echo "{"
        first=1
        for f in "$skills_dst"/specjedi-*/SKILL.md; do
          IFS=$'\t' read -r name desc < <(skill_meta "$f")
          if [ "$first" -eq 1 ]; then first=0; else echo ","; fi
          printf '  "%s": {\n' "$(json_escape "$name")"
          printf '    "description": "%s",\n' "$(json_escape "$desc")"
          printf '    "prompt": "%s",\n' "$(json_escape "Follow the instructions in .claude/skills/$name/SKILL.md in full.")"
          printf '    "contextFiles": [".claude/skills/%s/SKILL.md"]\n' "$name"
          printf '  }'
        done
        echo
        echo "}"
      } > "$bridge_dst"
      echo "  ✅ $bridge_dst_rel (Cody custom commands — invoke with /specjedi-<name>;"
      echo "     Cody has no confirmed always-on rules file, so these load on"
      echo "     explicit invocation rather than automatically, unlike the other"
      echo "     bridge harnesses — see specs/023-full-harness-coverage/research.md)"
      ;;
  esac
fi

# specs/039-memory-file-skill-mentions: harnesses with a confirmed,
# separate project-memory-file convention distinct from their skills
# directory get that file created or updated too -- never antigravity
# (no confirmed convention) or the 14 bridge harnesses above (their
# bridge file already serves this purpose).
memory_file_rel=""
case "$harness" in
  claude-code) memory_file_rel="CLAUDE.md" ;;
  codex-cli) memory_file_rel="AGENTS.md" ;;
  trae) memory_file_rel=".trae/rules/project_rules.md" ;;
esac
if [ -n "$memory_file_rel" ]; then
  echo
  echo "🧠 Updating $memory_file_rel with the installed skill set..."
  update_memory_file "$target_dir/$memory_file_rel" "$skills_dst_rel"
fi

# specs/041-release-hooks-settings (User Story 1): shareable hooks/
# settings for claude-code -- never skill-quality-guard or
# cross-platform-parity-guard, which check spec-jedi-repo-specific
# conventions (spec.md Assumptions). Wave 1/2 per-harness adaptations
# for other harnesses are separate, later work.
if [ "$harness" = "claude-code" ] && [ "$install_shared_hooks" -eq 1 ]; then
  echo
  echo "🛡️  Installing shareable hooks/settings..."
  trunk_branch="$(detect_trunk_branch "$target_dir")"
  # Build a case-pattern list covering each detected branch plus its own
  # name:name refspec form, matching the existing main:main/
  # master:master refspec coverage in this repo's own copy of the hook
  # -- e.g. "develop|develop:develop", or for the "main master" fallback,
  # "main|main:main|master|master:master".
  trunk_pattern=""
  for b in $trunk_branch; do
    if [ -n "$trunk_pattern" ]; then
      trunk_pattern="${trunk_pattern}|${b}|${b}:${b}"
    else
      trunk_pattern="${b}|${b}:${b}"
    fi
  done
  # specs/058-expand-shareable-hooks: prevent-direct-push.py's own
  # PROTECTED set is Python-set-literal syntax (`{"main", "develop"}`),
  # not the bash case-pattern trunk_pattern above -- a distinct
  # substitution value is needed, e.g. {"main"} or {"main", "master"}.
  python_protected="$(build_python_protected_set "$trunk_branch")"

  target_hooks_dir="$target_dir/.claude/hooks"
  mkdir -p "$target_hooks_dir"
  sed "s@main|master|main:main|master:master) has_main_or_master=1 ;;@${trunk_pattern}) has_main_or_master=1 ;;@" \
    "$repo_root/.claude/hooks/dangerous-command-guard.sh" > "$target_hooks_dir/dangerous-command-guard.sh"
  chmod +x "$target_hooks_dir/dangerous-command-guard.sh"
  echo "  ✅ dangerous-command-guard.sh (protecting: $trunk_branch)"

  # specs/058-expand-shareable-hooks (User Story 5): secret-file-guard.sh,
  # bash, zero-dependency (never gated on has_python3, matching
  # dangerous-command-guard.sh's own precedent). Tracked separately from
  # bash_hook_files since it belongs in a different PreToolUse matcher
  # (Read|Grep|Glob, not Bash).
  cp "$repo_root/.claude/hooks/secret-file-guard.sh" "$target_hooks_dir/secret-file-guard.sh"
  chmod +x "$target_hooks_dir/secret-file-guard.sh"
  echo "  ✅ secret-file-guard.sh"
  read_hook_files="secret-file-guard.sh"

  # specs/058-expand-shareable-hooks (User Story 1): prevent-direct-push.py,
  # gated on python3 (FR-005) -- never installed where it would silently
  # no-op or error on every invocation. bash_hook_files/skipped_python_hooks
  # accumulate across every Python hook this block installs, so the single
  # combined warning below (FR-005's own "one named warning" requirement)
  # and the PreToolUse wiring further down both stay in sync with what
  # was actually copied.
  bash_hook_files="dangerous-command-guard.sh"
  skipped_python_hooks=""
  if has_python3; then
    sed "s/PROTECTED = {\"main\", \"develop\"}/PROTECTED = ${python_protected}/" \
      "$repo_root/.claude/hooks/prevent-direct-push.py" > "$target_hooks_dir/prevent-direct-push.py"
    chmod +x "$target_hooks_dir/prevent-direct-push.py"
    echo "  ✅ prevent-direct-push.py (protecting: $trunk_branch)"
    bash_hook_files="$bash_hook_files prevent-direct-push.py"

    # specs/058-expand-shareable-hooks (User Story 2): secret-scanner.py,
    # shipped unmodified (FR-002) -- already self-contained, no
    # repo-specific paths, already carries its own self-exclusion fix and
    # the redaction fix (FR-012) directly in the source file.
    cp "$repo_root/.claude/hooks/secret-scanner.py" "$target_hooks_dir/secret-scanner.py"
    chmod +x "$target_hooks_dir/secret-scanner.py"
    echo "  ✅ secret-scanner.py"
    bash_hook_files="$bash_hook_files secret-scanner.py"

    # specs/058-expand-shareable-hooks (User Story 3): conventional-commits.py,
    # only when explicitly opted in (FR-003) -- unlike the two safety
    # nets above, never default-on.
    if [ "$install_conventional_commits" -eq 1 ]; then
      cp "$repo_root/.claude/hooks/conventional-commits.py" "$target_hooks_dir/conventional-commits.py"
      chmod +x "$target_hooks_dir/conventional-commits.py"
      echo "  ✅ conventional-commits.py"
      bash_hook_files="$bash_hook_files conventional-commits.py"
    fi
  else
    skipped_python_hooks="prevent-direct-push.py secret-scanner.py"
    if [ "$install_conventional_commits" -eq 1 ]; then
      skipped_python_hooks="$skipped_python_hooks conventional-commits.py"
    fi
  fi
  if [ -n "$skipped_python_hooks" ]; then
    echo "  ⚠️  python3 not found — skipping:$(for h in $skipped_python_hooks; do printf ' %s' "$h"; done)"
  fi

  update_shared_settings "$target_dir/.claude/settings.json"

  # Wire every newly-copied Bash-matcher hook into the target's own
  # settings.json, the same way this repo's own settings.json wires them
  # (PreToolUse/Bash) -- update_shared_settings only adds statusLine/
  # permissions, since the hooks wiring itself needs the target's own
  # resolved hooks path, not a static block. Conservative by design
  # (matching update_shared_settings()'s own "never touch what it can't
  # safely parse" philosophy): a target that already has a PreToolUse
  # array never gets surgically edited -- it gets a manual-add message
  # naming every missing hook (FR-006) instead of a risky in-array
  # insertion attempt.
  target_settings="$target_dir/.claude/settings.json"
  settings_content="$(cat "$target_settings" 2>/dev/null; echo x)"
  settings_content="${settings_content%x}"

  missing_bash_hooks=""
  for h in $bash_hook_files; do
    case "$settings_content" in *"$h"*) : ;; *) missing_bash_hooks="$missing_bash_hooks $h" ;; esac
  done
  missing_bash_hooks="${missing_bash_hooks# }"

  missing_read_hooks=""
  for h in $read_hook_files; do
    case "$settings_content" in *"$h"*) : ;; *) missing_read_hooks="$missing_read_hooks $h" ;; esac
  done
  missing_read_hooks="${missing_read_hooks# }"

  if [ -n "$missing_bash_hooks" ] || [ -n "$missing_read_hooks" ]; then
    if printf '%s' "$settings_content" | grep -q '"PreToolUse"'; then
      # specs/061-install-merge-pretooluse: python3 available -> merge
      # directly into the existing array (FR-001/FR-002/FR-003); no
      # python3 -> preserve today's exact manual-instruction fallback
      # (FR-005), unchanged.
      if has_python3; then
        merge_ok=1
        if [ -n "$missing_bash_hooks" ]; then
          merge_pretooluse_hooks "$target_settings" "Bash" "$missing_bash_hooks" || merge_ok=0
        fi
        if [ "$merge_ok" -eq 1 ] && [ -n "$missing_read_hooks" ]; then
          merge_pretooluse_hooks "$target_settings" "Read|Grep|Glob" "$missing_read_hooks" || merge_ok=0
        fi
        if [ "$merge_ok" -eq 1 ]; then
          echo "  ✅ Merged$(for h in $missing_bash_hooks $missing_read_hooks; do printf ' %s' "$h"; done) into existing PreToolUse hooks array in $(basename "$target_settings")"
        else
          echo "FAIL: could not merge shareable hooks into $(basename "$target_settings")'s existing PreToolUse array (see error above) -- refusing to guess."
          exit 1
        fi
      else
        echo "  ℹ️  Target already has a PreToolUse hooks array — add the following manually, not overwritten automatically:$(for h in $missing_bash_hooks $missing_read_hooks; do printf ' %s/%s' "$target_hooks_dir" "$h"; done)"
      fi
    else
      settings_content="$(printf '%s' "$settings_content" | sed -e 's/[[:space:]]*$//')"
      body="${settings_content%\}}"
      body="$(printf '%s' "$body" | sed -e 's/[[:space:]]*$//')"

      bash_hook_entries=""
      for h in $bash_hook_files; do
        case "$h" in
          *.sh)
            entry='          {
            "type": "command",
            "command": "bash",
            "args": ["${CLAUDE_PROJECT_DIR}/.claude/hooks/'"$h"'"]
          }'
            ;;
          *.py)
            entry='          {
            "type": "command",
            "command": "python3 \"${CLAUDE_PROJECT_DIR}/.claude/hooks/'"$h"'\""
          }'
            ;;
        esac
        if [ -n "$bash_hook_entries" ]; then
          bash_hook_entries="${bash_hook_entries},
${entry}"
        else
          bash_hook_entries="$entry"
        fi
      done

      read_hook_entries=""
      for h in $read_hook_files; do
        entry='          {
            "type": "command",
            "command": "bash",
            "args": ["${CLAUDE_PROJECT_DIR}/.claude/hooks/'"$h"'"]
          }'
        if [ -n "$read_hook_entries" ]; then
          read_hook_entries="${read_hook_entries},
${entry}"
        else
          read_hook_entries="$entry"
        fi
      done

      hooks_block='  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
'"$bash_hook_entries"'
        ]
      },
      {
        "matcher": "Read|Grep|Glob",
        "hooks": [
'"$read_hook_entries"'
        ]
      }
    ]
  }'
      if [[ "$body" == *"{" ]]; then
        printf '%s\n%s\n}\n' "$body" "$hooks_block" > "$target_settings"
      else
        printf '%s,\n%s\n}\n' "$body" "$hooks_block" > "$target_settings"
      fi
      echo "  ✅ Wired$(for h in $bash_hook_files $read_hook_files; do printf ' %s' "$h"; done) into $(basename "$target_settings")'s PreToolUse hooks"
    fi
  fi

  # specs/058-expand-shareable-hooks (User Story 4, FR-004): a target
  # either already has a Stop array (leave alone) or doesn't (insert the
  # whole block) -- exactly merge_json_key()'s own designed case, unlike
  # the PreToolUse wiring above which needs a value-level "is this
  # specific hook already present" check. Command string copied verbatim
  # from this repo's own .claude/settings.json Stop entry (plan.md
  # Implementation notes).
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
  merge_json_key "$target_dir/.claude/settings.json" '"Stop"' "$stop_block" "Stop notification hook wired"
fi

# specs/041-release-hooks-settings (User Story 2): builds the same
# branch|branch:branch case-pattern list detect_trunk_branch's caller
# already builds inline for claude-code (User Story 1) -- factored out
# here so every Wave 1 harness needing the identical pattern doesn't
# repeat the loop.
build_trunk_pattern() {
  local trunk_branch="$1" pattern="" b
  for b in $trunk_branch; do
    if [ -n "$pattern" ]; then
      pattern="${pattern}|${b}|${b}:${b}"
    else
      pattern="${b}|${b}:${b}"
    fi
  done
  printf '%s' "$pattern"
}

# specs/041-release-hooks-settings (User Story 2, Wave 1): translated
# dangerous-command-guard.sh for a BeforeTool-shaped hook contract --
# confirmed for Gemini CLI at geminicli.com/docs/hooks/reference/: stdin
# carries tool_input.command, stdout is {"decision":"deny","reason":"..."}
# with exit code 2 to block -- NOT Claude Code's own hookSpecificOutput/
# permissionDecision shape (Acceptance Scenario 2, US2: a real
# translation, not a copy). Also used for Antigravity: its own hooks.json
# lives under the same ~/.gemini/ namespace as Gemini CLI's (community-
# confirmed path ~/.gemini/antigravity-cli/hooks.json), a real signal it
# shares the same hook engine/contract -- documented here as a reasoned
# inference, not a separately-confirmed Antigravity-native schema
# (Principle XX). Detection logic itself (rm -rf root/home, force-push to
# trunk, reading real secret files) is otherwise unchanged from the
# Claude Code original.
render_gemini_style_guard() {
  local trunk_pattern="$1"
  cat <<EOF
#!/usr/bin/env bash
# Translated from .claude/hooks/dangerous-command-guard.sh (specs/
# 041-release-hooks-settings, User Story 2) for a BeforeTool-shaped hook
# contract: stdin carries tool_input.command, stdout is
# {"decision":"deny","reason":"..."} with exit code 2 to block.
set -euo pipefail

input="\$(cat)"
command="\$(printf '%s' "\$input" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"command"[[:space:]]*:[[:space:]]*"([^"]*)".*/\\1/')"

[ -n "\$command" ] || exit 0

deny() {
  printf '{"decision":"deny","reason":"%s"}\n' "\$1"
  exit 2
}

set -f
# shellcheck disable=SC2206
words=(\$command)
set +f

has_rm=0
has_recursive_force=0
has_git=0
has_push=0
has_force_flag=0
has_main_or_master=0
read_cmd=0

for w in "\${words[@]}"; do
  case "\$w" in
    rm) has_rm=1 ;;
    git) has_git=1 ;;
    push) has_push=1 ;;
    --force|--force-with-lease|-f) has_force_flag=1 ;;
    ${trunk_pattern}) has_main_or_master=1 ;;
    cat|head|tail|less|more) read_cmd=1 ;;
    --*) : ;;
    -*)
      body="\${w#-}"
      case "\$body" in
        *[rR]*) case "\$body" in *f*) has_recursive_force=1 ;; esac ;;
      esac
      ;;
  esac
  if [ "\$has_rm" -eq 1 ] && [ "\$has_recursive_force" -eq 1 ]; then
    case "\$w" in
      /|/\*) deny "Blocked: rm -rf targeting the filesystem root." ;;
      "~"|'\$HOME'|'\${HOME}') deny "Blocked: rm -rf targeting the home directory." ;;
    esac
  fi
done

if [ "\$has_git" -eq 1 ] && [ "\$has_push" -eq 1 ] && [ "\$has_force_flag" -eq 1 ] && [ "\$has_main_or_master" -eq 1 ]; then
  deny "Blocked: force-push to the trunk branch. This project's own git-workflow discipline forbids force-pushing the trunk branch."
fi

if [ "\$read_cmd" -eq 1 ]; then
  for w in "\${words[@]}"; do
    case "\$w" in
      */.aws/credentials|.aws/credentials)
        deny "Blocked: reading what looks like a real secret/credential file (.aws/credentials)."
        ;;
      */.docker/config.json|.docker/config.json)
        deny "Blocked: reading what looks like a real secret/credential file (.docker/config.json)."
        ;;
    esac
    base="\$(basename "\$w" 2>/dev/null || printf '%s' "\$w")"
    case "\$base" in
      .env.example|.env.sample|.env.template) continue ;;
      .env|.env.*|id_rsa|id_dsa|id_ecdsa|id_ed25519)
        deny "Blocked: reading what looks like a real secret/credential file."
        ;;
      *.pem|*.key|*.pfx|*.p12)
        deny "Blocked: reading what looks like a real secret/credential file."
        ;;
      .npmrc|.netrc|.pgpass|.git-credentials)
        deny "Blocked: reading what looks like a real credential file."
        ;;
    esac
  done
fi

exit 0
EOF
}

# specs/058-expand-shareable-hooks (User Story 1, Wave 1): translates
# prevent-direct-push.py for the same BeforeTool-shaped contract
# render_gemini_style_guard() targets. Unlike that function's full
# heredoc reproduction of dangerous-command-guard.sh's bash logic, this
# does a targeted source-to-source transform of the real
# prevent-direct-push.py file via python3 (already confirmed present --
# this function is only ever called from inside a has_python3 gate):
# the stdin JSON parsing (tool_input.command) is identical between
# contracts, only the deny-output construction differs. Asserts the
# expected block is found rather than silently no-op-ing if
# prevent-direct-push.py's own shape ever changes (Principle XX).
render_gemini_style_push_guard() {
  local python_protected="$1"
  python3 - "$repo_root/.claude/hooks/prevent-direct-push.py" "$python_protected" <<'PYEOF'
import sys

src_path, protected = sys.argv[1], sys.argv[2]
src = open(src_path, encoding="utf-8").read()

old_protected = 'PROTECTED = {"main", "develop"}'
if old_protected not in src:
    sys.exit("FAIL: prevent-direct-push.py's PROTECTED line not found -- update render_gemini_style_push_guard()")
src = src.replace(old_protected, f"PROTECTED = {protected}")

old_deny = '''    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }))
    sys.exit(0)'''
if old_deny not in src:
    sys.exit("FAIL: prevent-direct-push.py's deny-output block not found -- update render_gemini_style_push_guard()")
new_deny = '''    print(json.dumps({"decision": "deny", "reason": reason}))
    sys.exit(2)'''
src = src.replace(old_deny, new_deny)

header = (
    "#!/usr/bin/env python3\n"
    "# Translated from .claude/hooks/prevent-direct-push.py (specs/\n"
    "# 058-expand-shareable-hooks, User Story 1) for a BeforeTool-shaped\n"
    "# hook contract: stdin carries tool_input.command (unchanged), stdout\n"
    "# is {\"decision\":\"deny\",\"reason\":\"...\"} with exit code 2 to block.\n"
)
# Drop the original file's own module docstring header (lines 1-19) --
# it documents the Claude-Code-target adaptation specifically, which no
# longer applies verbatim to this translated copy.
body = src.split('"""', 2)[-1].lstrip("\n")
# Explicit UTF-8 byte write, not sys.stdout.write(): on a Windows CI
# runner (default locale cp1252, not UTF-8), a plain text write to
# stdout can raise UnicodeEncodeError on this file's own non-ASCII
# characters (an em dash, a checkmark) the same way an unencoded read
# raised UnicodeDecodeError above -- caught by a real CI failure during
# this feature's own PR (specs/058), not assumed.
sys.stdout.buffer.write((header + body).encode("utf-8"))
PYEOF
}

# specs/058-expand-shareable-hooks (User Story 2, Wave 1): unlike
# prevent-direct-push.py's single deny() call, secret-scanner.py's block
# output is spread across several print() calls building human-readable
# text (severity counts, per-finding details, remediation tips) to
# stderr, with exit 2 signaling block -- a valid, simpler alternative
# Claude Code PreToolUse hook convention (exit-code + stderr) than the
# JSON-on-stdout shape dangerous-command-guard.sh/prevent-direct-push.py
# use, but Gemini CLI's own BeforeTool contract specifically expects the
# {"decision":"deny","reason":"..."} JSON shape (confirmed by
# render_gemini_style_guard's own translation choice, not an assumption).
# Rather than a fragile transform of secret-scanner.py's multi-print
# logic, this wraps the real, unmodified script as a subprocess and
# re-shapes only its exit code/stderr into the expected contract -- the
# actual detection logic never diverges from the Claude-Code-target
# original.
render_gemini_style_scanner_wrapper() {
  cat <<'EOF'
#!/usr/bin/env python3
# Wraps .claude/hooks/secret-scanner.py (specs/058-expand-shareable-hooks,
# User Story 2) unmodified for a BeforeTool-shaped hook contract: stdin
# carries tool_input.command (unchanged), stdout is
# {"decision":"deny","reason":"..."} with exit code 2 to block.
import json
import os
import subprocess
import sys

scanner_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "secret-scanner.py")
result = subprocess.run(
    [sys.executable, scanner_path],
    input=sys.stdin.read(),
    capture_output=True,
    text=True,
)
if result.returncode == 2:
    print(json.dumps({"decision": "deny", "reason": result.stderr.strip()}))
    sys.exit(2)
sys.exit(0)
EOF
}

# specs/058-expand-shareable-hooks (User Story 3, Wave 1): translates
# conventional-commits.py the same source-to-source way
# render_gemini_style_push_guard() translates prevent-direct-push.py --
# a single deny() call, no PROTECTED-style substitution needed (this
# hook has no trunk-branch dependency at all).
render_gemini_style_commit_guard() {
  python3 - "$repo_root/.claude/hooks/conventional-commits.py" <<'PYEOF'
import sys

src_path = sys.argv[1]
src = open(src_path, encoding="utf-8").read()

old_deny = '''    output = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason
        }
    }
    print(json.dumps(output))
    sys.exit(0)'''
if old_deny not in src:
    sys.exit("FAIL: conventional-commits.py's deny-output block not found -- update render_gemini_style_commit_guard()")
new_deny = '''    print(json.dumps({"decision": "deny", "reason": reason}))
    sys.exit(2)'''
src = src.replace(old_deny, new_deny)

header = (
    "#!/usr/bin/env python3\n"
    "# Translated from .claude/hooks/conventional-commits.py (specs/\n"
    "# 058-expand-shareable-hooks, User Story 3) for a BeforeTool-shaped\n"
    "# hook contract: stdin carries tool_input.command (unchanged), stdout\n"
    "# is {\"decision\":\"deny\",\"reason\":\"...\"} with exit code 2 to block.\n"
)
body = src.split('"""', 2)[-1].lstrip("\n")
sys.stdout.buffer.write((header + body).encode("utf-8"))
PYEOF
}

install_hooks_gemini_cli() {
  local trunk_branch trunk_pattern target_hooks_dir guard_script hooks_block push_script push_entry python_protected scanner_entry commit_entry
  trunk_branch="$(detect_trunk_branch "$target_dir")"
  trunk_pattern="$(build_trunk_pattern "$trunk_branch")"

  target_hooks_dir="$target_dir/.gemini/hooks"
  mkdir -p "$target_hooks_dir"
  guard_script="$target_hooks_dir/dangerous-command-guard.sh"
  render_gemini_style_guard "$trunk_pattern" > "$guard_script"
  chmod +x "$guard_script"
  echo "  ✅ dangerous-command-guard.sh (Gemini CLI translation, protecting: $trunk_branch)"

  push_entry=""
  scanner_entry=""
  commit_entry=""
  if has_python3; then
    python_protected="$(build_python_protected_set "$trunk_branch")"
    push_script="$target_hooks_dir/prevent-direct-push.py"
    render_gemini_style_push_guard "$python_protected" > "$push_script"
    chmod +x "$push_script"
    echo "  ✅ prevent-direct-push.py (Gemini CLI translation, protecting: $trunk_branch)"
    push_entry=',
          {
            "type": "command",
            "command": "python3 .gemini/hooks/prevent-direct-push.py"
          }'

    cp "$repo_root/.claude/hooks/secret-scanner.py" "$target_hooks_dir/secret-scanner.py"
    render_gemini_style_scanner_wrapper > "$target_hooks_dir/secret-scanner-wrapper.py"
    chmod +x "$target_hooks_dir/secret-scanner.py" "$target_hooks_dir/secret-scanner-wrapper.py"
    echo "  ✅ secret-scanner.py (Gemini CLI translation, wrapped for BeforeTool contract)"
    scanner_entry=',
          {
            "type": "command",
            "command": "python3 .gemini/hooks/secret-scanner-wrapper.py"
          }'

    if [ "$install_conventional_commits" -eq 1 ]; then
      render_gemini_style_commit_guard > "$target_hooks_dir/conventional-commits.py"
      chmod +x "$target_hooks_dir/conventional-commits.py"
      echo "  ✅ conventional-commits.py (Gemini CLI translation)"
      commit_entry=',
          {
            "type": "command",
            "command": "python3 .gemini/hooks/conventional-commits.py"
          }'
    fi
  else
    echo "  ⚠️  python3 not found — skipping: prevent-direct-push.py secret-scanner.py (Gemini CLI translation)"
  fi

  hooks_block='  "hooks": {
    "BeforeTool": [
      {
        "matcher": "run_shell_command",
        "hooks": [
          {
            "type": "command",
            "command": "bash .gemini/hooks/dangerous-command-guard.sh"
          }'"$push_entry""$scanner_entry""$commit_entry"'
        ]
      }
    ]
  }'
  merge_json_key "$target_dir/.gemini/settings.json" '"hooks"' "$hooks_block" "BeforeTool hook wired"
}

# specs/041-release-hooks-settings (User Story 2, Wave 1): Antigravity's
# own hooks.json schema was not independently confirmed beyond a marketing
# announcement (research.md's own citation) -- this reuses the confirmed
# Gemini CLI BeforeTool contract per render_gemini_style_guard's own
# documented reasoning (shared ~/.gemini/ config namespace), targeting
# Antigravity's confirmed project-level path <project_root>/.agents/
# hooks.json (matching this installer's own existing .agents/skills
# convention for the same harness).
install_hooks_antigravity() {
  local trunk_branch trunk_pattern target_hooks_dir guard_script hooks_block push_script push_entry python_protected scanner_entry commit_entry
  trunk_branch="$(detect_trunk_branch "$target_dir")"
  trunk_pattern="$(build_trunk_pattern "$trunk_branch")"

  target_hooks_dir="$target_dir/.agents/hooks"
  mkdir -p "$target_hooks_dir"
  guard_script="$target_hooks_dir/dangerous-command-guard.sh"
  render_gemini_style_guard "$trunk_pattern" > "$guard_script"
  chmod +x "$guard_script"
  echo "  ✅ dangerous-command-guard.sh (Antigravity translation, protecting: $trunk_branch)"

  push_entry=""
  scanner_entry=""
  commit_entry=""
  if has_python3; then
    python_protected="$(build_python_protected_set "$trunk_branch")"
    push_script="$target_hooks_dir/prevent-direct-push.py"
    render_gemini_style_push_guard "$python_protected" > "$push_script"
    chmod +x "$push_script"
    echo "  ✅ prevent-direct-push.py (Antigravity translation, protecting: $trunk_branch)"
    push_entry=',
          {
            "type": "command",
            "command": "python3 .agents/hooks/prevent-direct-push.py"
          }'

    cp "$repo_root/.claude/hooks/secret-scanner.py" "$target_hooks_dir/secret-scanner.py"
    render_gemini_style_scanner_wrapper > "$target_hooks_dir/secret-scanner-wrapper.py"
    chmod +x "$target_hooks_dir/secret-scanner.py" "$target_hooks_dir/secret-scanner-wrapper.py"
    echo "  ✅ secret-scanner.py (Antigravity translation, wrapped for BeforeTool contract)"
    scanner_entry=',
          {
            "type": "command",
            "command": "python3 .agents/hooks/secret-scanner-wrapper.py"
          }'

    if [ "$install_conventional_commits" -eq 1 ]; then
      render_gemini_style_commit_guard > "$target_hooks_dir/conventional-commits.py"
      chmod +x "$target_hooks_dir/conventional-commits.py"
      echo "  ✅ conventional-commits.py (Antigravity translation)"
      commit_entry=',
          {
            "type": "command",
            "command": "python3 .agents/hooks/conventional-commits.py"
          }'
    fi
  else
    echo "  ⚠️  python3 not found — skipping: prevent-direct-push.py secret-scanner.py (Antigravity translation)"
  fi

  hooks_block='  "hooks": {
    "BeforeTool": [
      {
        "matcher": "run_shell_command",
        "hooks": [
          {
            "type": "command",
            "command": "bash .agents/hooks/dangerous-command-guard.sh"
          }'"$push_entry""$scanner_entry""$commit_entry"'
        ]
      }
    ]
  }'
  merge_json_key "$target_dir/.agents/hooks.json" '"hooks"' "$hooks_block" "hooks wired (schema inferred shared with Gemini CLI — see research.md)"
}

# specs/041-release-hooks-settings (User Story 2, Wave 1): Codex CLI's own
# hooks.json schema is confirmed structurally identical to Claude Code's
# own (matcher: "Bash", command-type hooks array — learn.chatgpt.com/docs/
# hooks) so this reuses the exact same proven trunk-substitution technique
# as the claude-code (User Story 1) block above, just targeting .codex/
# instead of .claude/. The trust-workflow message is required (plan.md's
# Codex CLI trust-workflow note, Principle XX): the installer cannot
# pre-approve a hook inside Codex CLI's own trust store.
install_hooks_codex_cli() {
  local trunk_branch trunk_pattern target_hooks_dir hooks_json python_protected bash_hook_files entry bash_hook_entries h missing_hooks
  trunk_branch="$(detect_trunk_branch "$target_dir")"
  trunk_pattern="$(build_trunk_pattern "$trunk_branch")"

  target_hooks_dir="$target_dir/.codex/hooks"
  mkdir -p "$target_hooks_dir"
  sed "s@main|master|main:main|master:master) has_main_or_master=1 ;;@${trunk_pattern}) has_main_or_master=1 ;;@" \
    "$repo_root/.claude/hooks/dangerous-command-guard.sh" > "$target_hooks_dir/dangerous-command-guard.sh"
  chmod +x "$target_hooks_dir/dangerous-command-guard.sh"
  echo "  ✅ dangerous-command-guard.sh (Codex CLI translation, protecting: $trunk_branch)"

  # specs/058-expand-shareable-hooks (User Story 1, Wave 1): Codex CLI's
  # hooks.json schema is structurally identical to Claude Code's own, so
  # prevent-direct-push.py is reused unmodified (same trunk-substitution
  # technique as the claude-code block), unlike Gemini CLI/Antigravity
  # which need render_gemini_style_push_guard's output-shape translation.
  bash_hook_files="dangerous-command-guard.sh"
  if has_python3; then
    python_protected="$(build_python_protected_set "$trunk_branch")"
    sed "s/PROTECTED = {\"main\", \"develop\"}/PROTECTED = ${python_protected}/" \
      "$repo_root/.claude/hooks/prevent-direct-push.py" > "$target_hooks_dir/prevent-direct-push.py"
    chmod +x "$target_hooks_dir/prevent-direct-push.py"
    echo "  ✅ prevent-direct-push.py (Codex CLI translation, protecting: $trunk_branch)"
    bash_hook_files="$bash_hook_files prevent-direct-push.py"

    cp "$repo_root/.claude/hooks/secret-scanner.py" "$target_hooks_dir/secret-scanner.py"
    chmod +x "$target_hooks_dir/secret-scanner.py"
    echo "  ✅ secret-scanner.py (Codex CLI translation)"
    bash_hook_files="$bash_hook_files secret-scanner.py"

    if [ "$install_conventional_commits" -eq 1 ]; then
      cp "$repo_root/.claude/hooks/conventional-commits.py" "$target_hooks_dir/conventional-commits.py"
      chmod +x "$target_hooks_dir/conventional-commits.py"
      echo "  ✅ conventional-commits.py (Codex CLI translation)"
      bash_hook_files="$bash_hook_files conventional-commits.py"
    fi
  else
    echo "  ⚠️  python3 not found — skipping: prevent-direct-push.py secret-scanner.py (Codex CLI translation)"
  fi

  hooks_json="$target_dir/.codex/hooks.json"
  if [ ! -f "$hooks_json" ]; then
    mkdir -p "$(dirname "$hooks_json")"
    bash_hook_entries=""
    for h in $bash_hook_files; do
      case "$h" in
        *.sh) entry='          {
            "type": "command",
            "command": "bash .codex/hooks/'"$h"'"
          }' ;;
        *.py) entry='          {
            "type": "command",
            "command": "python3 .codex/hooks/'"$h"'"
          }' ;;
      esac
      if [ -n "$bash_hook_entries" ]; then
        bash_hook_entries="${bash_hook_entries},
${entry}"
      else
        bash_hook_entries="$entry"
      fi
    done
    printf '{\n  "hooks": {\n    "PreToolUse": [\n      {\n        "matcher": "Bash",\n        "hooks": [\n%s\n        ]\n      }\n    ]\n  }\n}\n' "$bash_hook_entries" > "$hooks_json"
    echo "  ✅ .codex/hooks.json created (PreToolUse ->$(for h in $bash_hook_files; do printf ' %s' "$h"; done))"
  else
    missing_hooks=""
    for h in $bash_hook_files; do
      case "$h" in
        dangerous-command-guard.sh) grep -q "dangerous-command-guard" "$hooks_json" || missing_hooks="$missing_hooks $h" ;;
        *) grep -q "$h" "$hooks_json" || missing_hooks="$missing_hooks $h" ;;
      esac
    done
    missing_hooks="${missing_hooks# }"
    if [ -n "$missing_hooks" ]; then
      echo "  ℹ️  .codex/hooks.json already exists — add the following manually to its PreToolUse array, not overwritten automatically:$(for h in $missing_hooks; do printf ' %s/%s' "$target_hooks_dir" "$h"; done)"
    else
      echo "  ℹ️  .codex/hooks.json already references every shareable hook — leaving as-is."
    fi
  fi

  echo "  ⚠️  Codex CLI requires explicit trust: run /hooks inside Codex CLI and"
  echo "     approve$(for h in $bash_hook_files; do printf ' %s' "$h"; done) before they actually run — the"
  echo "     installer cannot pre-approve a hook inside Codex CLI's own trust"
  echo "     store (developers.openai.com/codex/hooks)."
}

# specs/041-release-hooks-settings (User Story 2, Wave 2): OpenCode's own
# permission schema is confirmed at opencode.ai/docs/permissions/ —
# top-level "permission" key, per-tool allow/ask/deny rules, last-match-
# wins. No hook translation attempted (research.md classifies OpenCode's
# hooks as plugin-code-only, not a clean mapping for this feature's
# shareable content).
install_permissions_opencode() {
  local permission_block
  permission_block='  "permission": {
    "bash": {
      "git status": "allow",
      "git diff *": "allow",
      "git add *": "allow",
      "git commit *": "allow",
      "git push *": "allow",
      "git pull *": "allow",
      "git log *": "allow"
    },
    "read": {
      ".env": "deny",
      ".env.*": "deny",
      "secrets/**": "deny",
      "config/credentials.json": "deny"
    }
  }'
  merge_json_key "$target_dir/opencode.json" '"permission"' "$permission_block" "git-aware permissions added"
}

# specs/041-release-hooks-settings (User Story 2, Wave 2): Zed's own
# tool-permission mechanism (agent.tool_permissions, always_allow/
# always_deny/always_confirm rules with regex patterns) is confirmed at
# zed.dev/docs/ai/tool-permissions; project-level settings live at
# .zed/settings.json per Zed's documented settings hierarchy. The
# "terminal" tool key is a reasoned inference (Zed's own shell-execution
# tool), not independently re-confirmed against a full JSON example —
# documented here per Principle XX rather than silently asserted.
install_permissions_zed() {
  local agent_block
  agent_block='  "agent": {
    "tool_permissions": {
      "terminal": {
        "always_allow": [
          "git status",
          "git diff .*",
          "git add .*",
          "git commit .*",
          "git push .*",
          "git pull .*",
          "git log .*"
        ]
      }
    }
  }'
  merge_json_key "$target_dir/.zed/settings.json" '"agent"' "$agent_block" "tool_permissions added — zed.dev/docs/ai/tool-permissions"
}

# specs/041-release-hooks-settings (User Story 2, Wave 2): Warp
# discovery — docs.warp.dev/terminal/settings/ confirms settings.toml is
# a single GLOBAL user-level file (~/.warp/settings.toml or platform
# equivalent), never a project-scoped one. Writing shareable per-project
# permissions there from a project-scoped `install.sh TARGET_DIR` run
# would mutate state far outside TARGET_DIR — a materially different,
# more invasive action than every other harness this installer touches
# (Constitution Principle XVIII's zero-footprint discipline). This
# installer prints an honest advisory instead of writing to a file
# outside the target project, matching FR-005's "never claim installed
# where it wasn't" discipline for a mechanism that exists but isn't
# safely reachable from here.
install_permissions_warp() {
  echo "  ℹ️  Warp stores agent permissions in a single global"
  echo "     ~/.warp/settings.toml (or platform equivalent) — there is no"
  echo "     project-scoped permissions file for this installer to write"
  echo "     into (docs.warp.dev/terminal/settings/). Configure allow/ask"
  echo "     autonomy for git commands yourself under Settings > AI >"
  echo "     Agents > Permissions."
}

# specs/041-release-hooks-settings (User Story 2, Wave 2): Amazon Q
# Developer CLI's custom-agent JSON schema (name/description/prompt/
# tools/allowedTools/toolsSettings) is confirmed at aws.github.io/
# amazon-q-developer-cli/agent-format.html; .amazonq/cli-agents/ is the
# documented discovery directory. Only fs_read is pre-approved here —
# execute_bash/fs_write intentionally left out of allowedTools (still
# prompt per use) because toolsSettings' sub-schema for excluding specific
# paths/commands (an fs_read/fs_write "denied paths" equivalent to specs/
# 040's secrets deny-list) was not confirmed in the fetched documentation;
# guessing an unconfirmed sub-key would violate Principle XX.
install_permissions_amazon_q() {
  local agents_dir agent_file
  agents_dir="$target_dir/.amazonq/cli-agents"
  mkdir -p "$agents_dir"
  agent_file="$agents_dir/spec-jedi-shared.json"
  if [ -f "$agent_file" ]; then
    echo "  ℹ️  .amazonq/cli-agents/spec-jedi-shared.json already exists — leaving as-is."
    return
  fi
  cat > "$agent_file" <<'EOF'
{
  "name": "spec-jedi-shared",
  "description": "Shareable git-aware tool permissions installed by Spec Jedi (specs/041-release-hooks-settings).",
  "prompt": "You are a general-purpose coding assistant.",
  "tools": ["fs_read", "fs_write", "execute_bash"],
  "allowedTools": ["fs_read"],
  "toolsSettings": {}
}
EOF
  echo "  ✅ .amazonq/cli-agents/spec-jedi-shared.json created (fs_read pre-approved; execute_bash/fs_write still prompt per use)"
}

# specs/041-release-hooks-settings (User Story 2): Wave 1 (declarative
# JSON hooks) and Wave 2 (permissions-only) per-harness translations —
# research.md's Full/Partial classifications. Never runs for the 9
# no-mechanism harnesses (FR-005's existing clean-skip already covers
# them — no new code path needed, T052/T053) or the 3 explicitly deferred
# Full harnesses (Cursor/Windsurf/Copilot — different hook dialects,
# follow-up feature per research.md's own Decision).
if [ "$install_shared_hooks" -eq 1 ]; then
  case "$harness" in
    gemini-cli)
      echo
      echo "🛡️  Installing shareable hooks (Gemini CLI translation)..."
      install_hooks_gemini_cli
      ;;
    antigravity)
      echo
      echo "🛡️  Installing shareable hooks (Antigravity translation)..."
      install_hooks_antigravity
      ;;
    codex-cli)
      echo
      echo "🛡️  Installing shareable hooks (Codex CLI translation)..."
      install_hooks_codex_cli
      ;;
    opencode)
      echo
      echo "🔐 Installing shareable permissions (OpenCode translation)..."
      install_permissions_opencode
      ;;
    zed)
      echo
      echo "🔐 Installing shareable permissions (Zed translation)..."
      install_permissions_zed
      ;;
    warp)
      echo
      echo "🔐 Shareable permissions (Warp)..."
      install_permissions_warp
      ;;
    amazon-q)
      echo
      echo "🔐 Installing shareable permissions (Amazon Q Developer translation)..."
      install_permissions_amazon_q
      ;;
  esac
fi

echo
echo "== Validating installed skills =="
fail=0
while IFS= read -r -d '' skill_file; do
  skill_dir="$(dirname "$skill_file")"
  ok=1

  if ! head -n 1 "$skill_file" | grep -q '^---$'; then
    echo "FAIL: $skill_file does not start with YAML frontmatter (---)"
    ok=0
  fi
  if ! grep -qE '^name:\s*\S+' "$skill_file"; then
    echo "FAIL: $skill_file frontmatter missing 'name:'"
    ok=0
  fi
  if ! grep -qE '^description:\s*\S+' "$skill_file"; then
    echo "FAIL: $skill_file frontmatter missing 'description:'"
    ok=0
  fi

  if [ "$ok" -eq 1 ]; then
    echo "OK: $skill_dir"
  else
    fail=1
  fi
done < <(find "$skills_dst" -name 'SKILL.md' -print0)

echo
if [ "$fail" -ne 0 ]; then
  echo "install.sh: FAILED — installed skills did not pass validation"
  exit 1
fi

echo "🚀 install.sh: $installed specjedi-* skills installed and validated."
echo
echo "Next step:"
echo "  - No .specify/memory/constitution.md yet? Run specjedi-onboard for a"
echo "    guided first-run walkthrough, or specjedi-constitution directly."
