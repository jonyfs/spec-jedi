# Implementation Plan: Skill Reference Integrity & Hook Enablement

**Branch**: `050-reference-integrity-hooks` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/050-reference-integrity-hooks/spec.md`

## Summary

Creates the two currently-missing reference files
(`references/constitution-mechanics.md`, `references/aitmpl-browsing-
playbook.md`) with real, grounded content matching exactly what their
citing skills' own text promises. Ships an example
`.specify/extensions.yml` with hook proposals grounded in real,
already-existing project scripts/skills. Resolves FR-006 (durable vs.
one-time reference check): extends `specjedi-skill-review`'s own Step 2
structural-presence check with one new dimension — verifying every
`references/*.md` citation in the reviewed skill resolves to a real
file, excluding fenced-code-block occurrences (FR-008) — reused
catalog-wide by `specjedi-catalog-audit`'s own per-skill pass, never a
third, separate audit mechanism.

## Technical Context

**Language/Version**: N/A — markdown reference docs, a YAML example
file, and a small addition to an existing skill's own check dimension.

**Primary Dependencies**: None new.

**Storage**: N/A.

**Testing**: No CI job. Verified via `scripts/validate.sh` plus a manual
re-run of the original grep-based reference sweep confirming zero
missing files remain.

**Constraints**: FR-002's two new files must satisfy exactly what their
citing skill already promises — no invented capability beyond that.
FR-005 requires the example `.specify/extensions.yml` be unambiguously
inactive.

**Scale/Scope**: Two new reference files, one new example config file,
one small addition (~10 lines) to `specjedi-skill-review`'s own Step 2.

## Constitution Check

| Principle | Check | Status |
|---|---|---|
| II | No new mechanism — extends `specjedi-skill-review`'s already-shipped structural check rather than building a third audit skill. | ✅ Pass |
| IX | No CI job; validated via `scripts/validate.sh` + manual re-sweep. | ✅ Pass |
| XIX | `specjedi-skill-review`'s own token count re-checked after the small addition (target: stay well under 5,000 hard cap). | ✅ Pass — enforced during implementation |
| XX | Both new reference files are read directly from their citing skill's own promised content — never fabricated. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/050-reference-integrity-hooks/
├── plan.md
└── tasks.md
```

### Source Code (repository root)

```text
references/
├── constitution-mechanics.md        # NEW
└── aitmpl-browsing-playbook.md      # NEW

.specify/extensions.yml.example      # NEW — starter hook config, inactive

.claude/skills/specjedi-skill-review/SKILL.md  # AMENDED — Step 2 gains
                                                 #   reference-existence
                                                 #   check (FR-006/007/008)
```

### Implementation notes

1. Write `references/constitution-mechanics.md`: the exact Sync Impact
   Report format (as demonstrated repeatedly this session), the
   propagation checklist for dependent templates
   (`checklist-template.md`, `tasks-template.md`, `plan-template.md`
   when a principle they cite changes), and the validation steps
   (`[PLACEHOLDER]` check, version-line match, ISO dates).
2. Write `references/aitmpl-browsing-playbook.md`: concrete URL patterns
   for aitmpl.com's six categories and the underlying GitHub source
   tree structure (`davila7/claude-code-templates/cli-tool/
   components/<category>/<subcategory>/`), grounded in this session's
   own real browsing of that catalog.
3. Write `.specify/extensions.yml.example`: hook proposals for a handful
   of pipeline stages, each `command` naming a real project script or
   `specjedi-*` skill, headed by an explicit "copy to `.specify/
   extensions.yml` and uncomment to activate" comment (FR-005).
4. Amend `specjedi-skill-review`'s Step 2: add "confirm every
   `references/*.md` citation in the reviewed skill resolves to a real
   file, excluding any occurrence inside a fenced code block" as one
   more structural-presence check, with a corresponding Format table
   row.
5. Validate: `scripts/validate.sh` passes; re-run the original grep
   sweep from spec.md's own Input section, confirming zero missing.
