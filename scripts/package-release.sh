#!/usr/bin/env bash
# Spec Jedi release-packaging tool (specs/020-release-packaging).
# Builds the single universal downloadable artifact a release publishes:
# every specjedi-* skill, the runtime template dependencies, and the
# installer scripts themselves -- the same allowlist scripts/install.sh
# already uses, never speckit-* bootstrap tooling.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: package-release.sh VERSION OUTPUT_DIR

  VERSION       Version string used in the artifact filename (e.g. v0.1.0).
  OUTPUT_DIR    Directory to write spec-jedi-VERSION.tar.gz into.

Produces a tarball containing .claude/skills/specjedi-*/, the four
.specify/templates/*.md files, scripts/install.sh, scripts/install.ps1,
scripts/session-start.sh, scripts/session-start.ps1, README.md, four
user-facing references/*.md files (quickstart-guide.md, what-is-sdd.md,
specjedi-and-sdd.md, session-start-hook-guide.md), and LICENSE -- never
specs/, CONTRIBUTING.md, or this project's own internal skill-authoring/
governance reference docs (specs/038-expand-release-package).
EOF
}

if [ "$#" -ne 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  usage
  exit "$([ "$#" -eq 2 ] && echo 1 || echo 0)"
fi

version="$1"
output_dir="$2"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

staging="$(mktemp -d)"
trap 'rm -rf "$staging"' EXIT

archive_name="spec-jedi-${version}.tar.gz"
stage_root="$staging/spec-jedi-${version}"
mkdir -p "$stage_root"

echo "📦 Staging release artifact for ${version}..."

skills_dst="$stage_root/.claude/skills"
mkdir -p "$skills_dst"
for skill_path in "$repo_root/.claude/skills"/specjedi-*/; do
  skill_name="$(basename "$skill_path")"
  cp -R "$skill_path" "$skills_dst/$skill_name"
  echo "  ✅ .claude/skills/$skill_name"
done

templates_dst="$stage_root/.specify/templates"
mkdir -p "$templates_dst"
for template in constitution-template.md spec-template.md plan-template.md tasks-template.md; do
  cp "$repo_root/.specify/templates/$template" "$templates_dst/$template"
  echo "  ✅ .specify/templates/$template"
done

references_dst="$stage_root/references"
mkdir -p "$references_dst"
for ref in quickstart-guide.md what-is-sdd.md specjedi-and-sdd.md session-start-hook-guide.md; do
  cp "$repo_root/references/$ref" "$references_dst/$ref"
  echo "  ✅ references/$ref"
done

cp "$repo_root/README.md" "$stage_root/README.md"
echo "  ✅ README.md"

mkdir -p "$stage_root/scripts"
cp "$repo_root/scripts/install.sh" "$stage_root/scripts/install.sh"
cp "$repo_root/scripts/install.ps1" "$stage_root/scripts/install.ps1"
cp "$repo_root/scripts/session-start.sh" "$stage_root/scripts/session-start.sh"
cp "$repo_root/scripts/session-start.ps1" "$stage_root/scripts/session-start.ps1"
echo "  ✅ scripts/install.sh"
echo "  ✅ scripts/install.ps1"
echo "  ✅ scripts/session-start.sh"
echo "  ✅ scripts/session-start.ps1"

cp "$repo_root/LICENSE" "$stage_root/LICENSE"
echo "  ✅ LICENSE"

mkdir -p "$output_dir"
output_dir="$(cd "$output_dir" && pwd)"
tar -czf "$output_dir/$archive_name" -C "$staging" "spec-jedi-${version}"

echo
echo "🚀 package-release.sh: $output_dir/$archive_name built."
