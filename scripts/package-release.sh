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
scripts/session-start.sh, scripts/session-start.ps1,
.claude/hooks/dangerous-command-guard.sh/.ps1, a RELEASE_VERSION stamp
file, README.md, four user-facing references/*.md files
(quickstart-guide.md, what-is-sdd.md, specjedi-and-sdd.md,
session-start-hook-guide.md), and LICENSE -- never specs/,
CONTRIBUTING.md, or this project's own internal skill-authoring/
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

# specs/042-skill-freshness-validation: pre-existing bug found while
# testing this feature -- install.sh/.ps1's shareable-hooks step
# (specs/041) reads $repo_root/.claude/hooks/dangerous-command-guard.sh
# /.ps1 unconditionally for claude-code and every Wave 1/2 harness, but
# this staging script never packaged it, so install.sh run from ANY
# extracted release tarball (bootstrap-install.sh's entire purpose) has
# always exited 1 here. Fixed as part of this feature since it directly
# blocks testing the marker-writing behavior end-to-end from a real
# package.
hooks_dst="$stage_root/.claude/hooks"
mkdir -p "$hooks_dst"
cp "$repo_root/.claude/hooks/dangerous-command-guard.sh" "$hooks_dst/dangerous-command-guard.sh"
cp "$repo_root/.claude/hooks/dangerous-command-guard.ps1" "$hooks_dst/dangerous-command-guard.ps1"
echo "  ✅ .claude/hooks/dangerous-command-guard.sh"
echo "  ✅ .claude/hooks/dangerous-command-guard.ps1"

# specs/058-expand-shareable-hooks (research.md Decision 4): the same bug
# class specs/042 already found once for dangerous-command-guard.sh above
# -- install.sh/.ps1 read these hook files from $repo_root/.claude/hooks/*
# unconditionally, so a release tarball this script never staged them into
# would leave install.sh exiting non-zero for every user installing from
# an actual downloadable release, not a git checkout.
cp "$repo_root/.claude/hooks/prevent-direct-push.py" "$hooks_dst/prevent-direct-push.py"
echo "  ✅ .claude/hooks/prevent-direct-push.py"
cp "$repo_root/.claude/hooks/secret-scanner.py" "$hooks_dst/secret-scanner.py"
echo "  ✅ .claude/hooks/secret-scanner.py"
cp "$repo_root/.claude/hooks/secret-file-guard.sh" "$hooks_dst/secret-file-guard.sh"
cp "$repo_root/.claude/hooks/secret-file-guard.ps1" "$hooks_dst/secret-file-guard.ps1"
echo "  ✅ .claude/hooks/secret-file-guard.sh"
echo "  ✅ .claude/hooks/secret-file-guard.ps1"
cp "$repo_root/.claude/hooks/conventional-commits.py" "$hooks_dst/conventional-commits.py"
echo "  ✅ .claude/hooks/conventional-commits.py"

cp "$repo_root/LICENSE" "$stage_root/LICENSE"
echo "  ✅ LICENSE"

# specs/042-skill-freshness-validation: a plain-text stamp of the version
# being packaged, read by install.sh at install time to write a real
# release tag into the target's installed-release marker instead of the
# "local-checkout" sentinel -- the only way install.sh can know its own
# version when running from an extracted tarball (no .git directory).
printf '%s' "$version" > "$stage_root/RELEASE_VERSION"
echo "  ✅ RELEASE_VERSION"

mkdir -p "$output_dir"
output_dir="$(cd "$output_dir" && pwd)"
tar -czf "$output_dir/$archive_name" -C "$staging" "spec-jedi-${version}"

echo
echo "🚀 package-release.sh: $output_dir/$archive_name built."
