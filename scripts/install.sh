#!/usr/bin/env bash
# Spec Jedi zero-footprint installer (Constitution Principle XVIII).
# Copies the specjedi-* product skills (never speckit-* bootstrap tooling)
# into a target project, plus the .specify/templates/*.md files those skills
# depend on at runtime. Product-only by default, harness-selected, validated
# after copy — not just asserted to work.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_dir="."
harness=""
auto_mode=0

usage() {
  cat <<'EOF'
Usage: install.sh [TARGET_DIR] [--harness HARNESS] [--auto]

  TARGET_DIR   Project to install Spec Jedi's specjedi-* skills into.
               Defaults to the current directory.
  --harness    Which coding agent to configure for. "claude-code",
               "codex-cli", and "trae" are built and tested today
               (Constitution Principle III); any other value is reported
               as not-yet-supported rather than silently attempted. If
               omitted, the installer attempts harness auto-detection
               (specs/021-harness-auto-detection).
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
      shift
      ;;
  esac
done

mkdir -p "$target_dir"
target_dir="$(cd "$target_dir" && pwd)"

# Harness auto-detection (specs/021-harness-auto-detection): only runs
# when --harness was omitted. Any explicit --harness value bypasses all
# of this entirely -- zero behavior change for existing scripted/CI usage.
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
    harness="claude-code"
    echo "🔭 No harness detected on this machine/target directory — falling"
    echo "back to the default: claude-code (this is a fallback, not a"
    echo "detected match)."
  elif [ "$match_count" -eq 1 ]; then
    if [ -n "$claude_rank" ]; then
      harness="claude-code"
      echo "🔭 Detected claude-code (${claude_evidence}) — installing automatically."
    elif [ -n "$codex_rank" ]; then
      harness="codex-cli"
      echo "🔭 Detected codex-cli (${codex_evidence}) — installing automatically."
    else
      harness="trae"
      echo "🔭 Detected trae (${trae_evidence}) — installing automatically."
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
      read -r -p "Choice [$recommended_letter]: " choice
      choice="${choice:-$recommended_letter}"
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

# Harness Target mapping (data-model.md): --harness value -> skill
# install location. Both entries share the same source skills, the same
# runtime templates, and the same post-copy validation below -- only the
# destination subdirectory name differs.
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
  *)
    echo "🔭 '$harness' isn't built and tested yet — only 'claude-code',"
    echo "'codex-cli', and 'trae' are fully supported today (Constitution"
    echo "Principle III's compatibility matrix). The SKILL.md files are plain"
    echo "Markdown with YAML frontmatter, so many harnesses that read custom"
    echo "instructions can already use them directly even without a dedicated"
    echo "install path — but this installer won't claim to have set that up"
    echo "for you."
    exit 1
    ;;
esac

echo "📜 Installing Spec Jedi's specjedi-* skills into: $target_dir"
echo

skills_src="$repo_root/.claude/skills"
skills_dst="$target_dir/$skills_dst_rel"
mkdir -p "$skills_dst"

installed=0
for skill_path in "$skills_src"/specjedi-*/; do
  skill_name="$(basename "$skill_path")"
  rm -rf "${skills_dst:?}/$skill_name"
  cp -R "$skill_path" "$skills_dst/$skill_name"
  echo "  ✅ $skill_name"
  installed=$((installed + 1))
done

if [ "$installed" -eq 0 ]; then
  echo "FAIL: no specjedi-* skills found under $skills_src — is this run from a Spec Jedi checkout?"
  exit 1
fi

echo
echo "📚 Installing runtime template dependencies..."
templates_dst="$target_dir/.specify/templates"
mkdir -p "$templates_dst"
for template in constitution-template.md spec-template.md plan-template.md tasks-template.md; do
  cp "$repo_root/.specify/templates/$template" "$templates_dst/$template"
  echo "  ✅ $template"
done

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
