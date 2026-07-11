#!/usr/bin/env bash
# Spec Jedi self-validation entrypoint (Constitution Principle IX).
# Every PR's CI workflow runs this single command; a nonzero exit blocks merge.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

fail=0

echo "== Constitution: no leftover placeholder tokens =="
# Skip the leading Sync Impact Report HTML comment: it's a historical audit
# log and may legitimately mention a literal token like "[TEMPLATE]" when
# describing a version transition (e.g. "Version change: [TEMPLATE] -> 1.0.0"
# on a project's first-ever ratification) without that being an unresolved
# placeholder in the constitution body itself.
if awk '/-->/{f=1;next} f' .specify/memory/constitution.md | grep -nE '\[[A-Z_]+\]'; then
  echo "FAIL: unresolved [PLACEHOLDER] tokens found in constitution.md body"
  fail=1
else
  echo "OK"
fi

echo
echo "== SKILL.md structural lint =="
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
done < <(find . -path ./.git -prune -o -name 'SKILL.md' -print0)

echo
if [ "$fail" -ne 0 ]; then
  echo "validate.sh: FAILED"
  exit 1
fi

echo "validate.sh: PASSED"
