#!/usr/bin/env bash
# Spec Jedi release-suggestion tool (Constitution Principle XI).
# Reads Conventional-Commit-style history since the last tag and suggests
# the next semantic version. Never tags, never publishes — it only
# recommends; cutting a release always requires an explicit human step.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

last_tag="$(git describe --tags --abbrev=0 2>/dev/null || true)"

if [ -z "$last_tag" ]; then
  echo "No tags found yet — this would be the first release."
  echo "Suggested starting version: v0.1.0 (pre-1.0: API/skill surface still settling)"
  echo "or v1.0.0 if the maintainer considers the current skill set stable."
  echo
  echo "Commits considered (all history):"
  git log --pretty='format:  %h %s'
  exit 0
fi

range="${last_tag}..HEAD"
commits="$(git log "$range" --pretty='format:%s')"

if [ -z "$commits" ]; then
  echo "No commits since ${last_tag}. No release suggested."
  exit 0
fi

bump="none"
if echo "$commits" | grep -qE '^[a-zA-Z]+(\([^)]*\))?!:|BREAKING CHANGE'; then
  bump="major"
elif echo "$commits" | grep -qE '^feat(\([^)]*\))?:'; then
  bump="minor"
elif echo "$commits" | grep -qE '^(fix|docs|chore|refactor|perf|test)(\([^)]*\))?:'; then
  bump="patch"
fi

IFS='.' read -r major minor patch <<< "${last_tag#v}"
case "$bump" in
  major) next="v$((major + 1)).0.0" ;;
  minor) next="v${major}.$((minor + 1)).0" ;;
  patch) next="v${major}.${minor}.$((patch + 1))" ;;
  none)
    echo "Commits since ${last_tag} don't match a known Conventional Commits"
    echo "prefix (feat/fix/docs/chore/refactor/perf/test, or a '!'/BREAKING"
    echo "CHANGE marker). No automatic suggestion — review manually:"
    git log "$range" --pretty='format:  %h %s'
    exit 0
    ;;
esac

echo "Last release: ${last_tag}"
echo "Suggested next version: ${next} (${bump} bump)"
echo
echo "Commits since ${last_tag}:"
git log "$range" --pretty='format:  %h %s'
echo
echo "This is a suggestion only. Cutting the release (tag + publish +"
echo "changelog) requires an explicit maintainer decision (Principle XI)."
