#!/usr/bin/env bash
# Spec Jedi zero-footprint installer (Constitution Principle XVIII).
# Copies the specjedi-* product skills (never speckit-* bootstrap tooling)
# into a target project, plus the .specify/templates/*.md files those skills
# depend on at runtime. Product-only by default, harness-selected, validated
# after copy — not just asserted to work.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_dir="."
harness="claude-code"

usage() {
  cat <<'EOF'
Usage: install.sh [TARGET_DIR] [--harness HARNESS]

  TARGET_DIR   Project to install Spec Jedi's specjedi-* skills into.
               Defaults to the current directory.
  --harness    Which coding agent to configure for. Only "claude-code" is
               built and tested today (Constitution Principle III); any
               other value is reported as not-yet-supported rather than
               silently attempted.

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

if [ "$harness" != "claude-code" ]; then
  echo "🔭 '$harness' isn't built and tested yet — only 'claude-code' is fully"
  echo "supported today (Constitution Principle III's compatibility matrix)."
  echo "The SKILL.md files are plain Markdown with YAML frontmatter, so many"
  echo "harnesses that read custom instructions can already use them directly"
  echo "even without a dedicated install path — but this installer won't claim"
  echo "to have set that up for you."
  exit 1
fi

mkdir -p "$target_dir"
target_dir="$(cd "$target_dir" && pwd)"

echo "📜 Installing Spec Jedi's specjedi-* skills into: $target_dir"
echo

skills_src="$repo_root/.claude/skills"
skills_dst="$target_dir/.claude/skills"
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
