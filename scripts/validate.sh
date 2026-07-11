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
echo "== Constitution Principle IX: validation battery growth trigger =="
# Informational only (never fails the build): flags the moment this repo
# gains unit-testable logic, an integration surface, or a web UI that the
# CI battery (.github/workflows/*.yml) doesn't yet cover — the exact
# "moment any skill produces..." trigger Principle IX names but leaves
# undetected otherwise (checklists/project-completeness.md CHK004).
battery_signal=0

if find . -path ./.git -prune -o \( -iname '*.test.*' -o -iname '*.spec.*' -o -iname '*_test.py' \) -print -quit 2>/dev/null | grep -q .; then
  echo "SIGNAL: test-pattern file(s) found (*.test.*, *.spec.*, *_test.py) — unit-testable logic may exist"
  battery_signal=1
fi

if [ -f package.json ] || [ -f pyproject.toml ] || [ -f Cargo.toml ] || [ -f go.mod ]; then
  echo "SIGNAL: a language runtime manifest (package.json/pyproject.toml/Cargo.toml/go.mod) exists at repo root"
  battery_signal=1
fi

if [ -f index.html ] || grep -qE '"(react|vue|svelte|next)"' package.json 2>/dev/null; then
  echo "SIGNAL: web UI marker found (index.html, or a React/Vue/Svelte/Next dependency)"
  battery_signal=1
fi

if [ "$battery_signal" -eq 1 ]; then
  battery_jobs=$(grep -vE '^\s*#' .github/workflows/*.yml 2>/dev/null | grep -iE 'unit|integration|playwright' || true)
  if [ -z "$battery_jobs" ]; then
    echo "WARN: signal(s) found above, but no unit/integration/playwright job exists in .github/workflows/ — the validation battery should grow (Principle IX)."
  else
    echo "OK: signal(s) found above, and a corresponding CI job already exists — battery already covers this."
  fi
else
  echo "OK: no unit-testable code, integration surface, or web UI detected — battery growth not yet triggered."
fi

echo
echo "== Constitution Principle I: localized docs sync check =="
# Informational only (never fails the build): each translated file under
# docs/i18n/<lang>/ records "i18n-sync: source=<file>@<hash>" naming the
# English source commit it was translated from. Warn when the English
# source has moved since — Principle I requires drift to be flagged
# ("MUST be flagged... rather than silently served as current"), not
# silently ignored.
if [ -d docs/i18n ]; then
  while IFS= read -r -d '' translated_file; do
    marker_line=$(grep -m1 'i18n-sync: source=' "$translated_file" 2>/dev/null || true)
    if [ -z "$marker_line" ]; then
      echo "WARN: $translated_file has no i18n-sync marker — drift cannot be checked."
      continue
    fi
    source_rel=$(echo "$marker_line" | sed -E 's/.*source=([^@]+)@([0-9a-f]+).*/\1/')
    synced_hash=$(echo "$marker_line" | sed -E 's/.*source=([^@]+)@([0-9a-f]+).*/\2/')
    if [ ! -f "$source_rel" ]; then
      echo "WARN: $translated_file references missing source $source_rel"
      continue
    fi
    current_hash=$(git log -1 --format=%h -- "$source_rel" 2>/dev/null || true)
    if [ -n "$current_hash" ] && [ "$current_hash" != "$synced_hash" ]; then
      echo "WARN: $translated_file is out of sync — $source_rel changed since commit $synced_hash (now at $current_hash)."
    fi
  done < <(find docs/i18n -name '*.md' -print0)
  echo "OK: localized docs sync check complete (see WARN lines above, if any)."
else
  echo "OK: no docs/i18n/ directory yet."
fi

echo
if [ "$fail" -ne 0 ]; then
  echo "validate.sh: FAILED"
  exit 1
fi

echo "validate.sh: PASSED"
