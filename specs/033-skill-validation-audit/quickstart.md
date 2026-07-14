# Quickstart: Skill Validation & Testing Framework Compliance Audit

Validation scenarios proving all 24 shipped `specjedi-*` skills now
explicitly address the framework's four categories, and that
`specjedi-skill-review` checks this going forward.

## Scenario 1 — Zero silent omissions (SC-001)

```bash
grep -L "Validation Coverage (Principle IX)" .claude/skills/specjedi-*/SKILL.md
```

**Expected**: empty output — every one of the 24 skills' `SKILL.md`
carries the new section. (Run against the 24 skills shipped as of this
feature's start; `specjedi-worktree`, feature 032, is out of scope per
spec.md's own Assumptions.)

## Scenario 2 — Framework citation closes the original gap

```bash
grep -rl "skill-validation-testing-framework" .claude/skills/specjedi-*/SKILL.md | wc -l
```

**Expected**: `24` — the exact original gap this feature's `spec.md`
Problem statement measured as `0`.

## Scenario 3 — No generic placeholder scenarios (SC-002, spot-check)

Manual read-through of a sample of Applicable findings (e.g.
`specjedi-implement`'s Prompt Injection Resistance line,
`specjedi-status`'s Malformed Input line): confirm each names concrete
input and concrete expected behavior, or a specific cross-reference to
an existing `Example`/`Always-Never` line — never a bare restatement of
the category's own definition ("this skill resists prompt injection").

## Scenario 4 — `specjedi-skill-review` checks the framework going forward (SC-003, US3)

```bash
grep -n "skill-validation-testing-framework" .claude/skills/specjedi-skill-review/SKILL.md
```

**Expected**: a real match inside the skill's own step-by-step, not just
a passing mention — confirms FR-006 is wired in, not just documented in
this feature's own spec.

## Scenario 5 — Structural validation

```bash
./scripts/validate.sh
```

**Expected**: `PASSED` — confirms every modified `SKILL.md` still passes
the frontmatter/layout structural lint after the new section was added.
