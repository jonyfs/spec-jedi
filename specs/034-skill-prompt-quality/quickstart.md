# Quickstart: Close Prompt-Engineering Gaps in 5 `specjedi-*` Skills

## Scenario 1 — Audience-calibration notes present (US1, US2)

```bash
grep -l "Audience calibration" .claude/skills/specjedi-constitution/SKILL.md \
  .claude/skills/specjedi-specify/SKILL.md
```

**Expected**: both files match.

## Scenario 2 — `specjedi-find-skills`'s calibration note is scoped, not generic (US2, FR-003)

```bash
grep -A3 "Audience calibration" .claude/skills/specjedi-find-skills/SKILL.md
```

**Expected**: the matched text specifically names verification signals
(install count, source, GitHub stars) — never a bare restatement of
Principle XIX with no reference to this skill's own reasoning.

## Scenario 3 — Chain-of-thought instructions present in the step itself (US3, US4)

```bash
grep -B2 -A2 "reason through" .claude/skills/specjedi-onboard/SKILL.md \
  .claude/skills/specjedi-quick/SKILL.md
```

**Expected**: both files show the phrase inside the actual step-by-step
instruction (Step 2 for onboard, Step 1 for quick), not only inside an
Example section.

## Scenario 4 — Zero other files touched (SC-002, FR-006)

```bash
git diff main --stat -- .claude/skills/
```

**Expected**: exactly 5 `SKILL.md` files listed —
`specjedi-constitution`, `specjedi-specify`, `specjedi-find-skills`,
`specjedi-onboard`, `specjedi-quick`.

## Scenario 5 — Token ceiling respected (SC-003, FR-007)

```bash
for f in specjedi-constitution specjedi-specify specjedi-find-skills specjedi-onboard specjedi-quick; do
  wc -w ".claude/skills/$f/SKILL.md"
done
```

**Expected**: each file's word count stays comfortably under Principle
XIX's ~5,000-token ceiling (roughly ~3,750 words at a 1.33 token/word
ratio) — a spot-check against the file's pre-edit word count confirms
the addition was a small, targeted paragraph, not a rewrite.

## Scenario 6 — Structural validation

```bash
./scripts/validate.sh
```

**Expected**: `PASSED`.
