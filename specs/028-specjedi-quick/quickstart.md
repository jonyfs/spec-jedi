# Quickstart: Verifying `specjedi-quick`

**Feature**: 028-specjedi-quick

## Prerequisites

- `.claude/skills/specjedi-quick/SKILL.md` created per plan.md's Design.
- `.claude/skills/specjedi-status/SKILL.md` extended for `quick.md`.

## Scenario 1: An eligible request produces `quick.md` and implements

**Run**: Invoke `specjedi-quick` with a small, single-file, unambiguous
change request.

**Expected outcome**: a single `specs/NNN-name/quick.md` is created (not
`spec.md`+`plan.md`+`tasks.md`), followed directly by implementation —
branch check, test-first where applicable, `specjedi-govcheck`
self-invoke, PR opened with auto-merge requested (never claimed).

## Scenario 2: An ineligible request is declined and redirected

**Run**: Invoke `specjedi-quick` once per FR-001 criterion with a request
that fails only that criterion (e.g., a request for a brand-new skill;
a request touching two unrelated subsystems; a request with genuine
unresolved ambiguity).

**Expected outcome**: each is declined with the specific failing
criterion named, and redirected to `specjedi-specify` — zero `quick.md`
files produced for any of them (spec.md SC-002).

## Scenario 3: Mid-flight escalation

**Run**: Start a `quick.md` for an apparently-small change; simulate
discovering mid-implementation that it actually touches a second
subsystem.

**Expected outcome**: the skill states this plainly, stops, and offers to
hand `quick.md`'s content to `specjedi-specify` rather than continuing on
the fast path or silently dropping the work already captured.

## Scenario 4: `specjedi-status` reports a quick-path feature correctly

**Setup**: Construct a test fixture — a `specs/999-test-quick/quick.md`
with `Status: Implemented` and 3/3 Acceptance Checks checked.

**Run**: Invoke `specjedi-status`.

**Expected outcome**: `999-test-quick` appears in the report as "100%
(complete)," derived from `quick.md`, not reported as "no artifacts
found" (spec.md SC-003). Delete the fixture afterward — it's a test
artifact, not a real feature.

## Structural validation

```bash
./scripts/validate.sh
```

**Expected outcome**: passes for both `specjedi-quick/SKILL.md` and the
revised `specjedi-status/SKILL.md`.
