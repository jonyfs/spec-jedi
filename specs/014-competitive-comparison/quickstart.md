# Quickstart: Verifying the Competitive Comparison Table

**Feature**: 014-competitive-comparison

Validation scenarios that prove this feature's deliverable is correct —
not the table content itself (that's `references/competitive-comparison.md`,
a Phase 2/implementation output, not a planning artifact).

## Prerequisites

- `specs/001-specjedi-pipeline/research.md` (the source of truth for every
  claim)
- `references/genuine-contributions-log.md` and
  `references/harness-capability-notes.md` (the structural precedent to
  match)

## Scenario 1: Every claim traces to an existing citation

```bash
# For each of the 11 tool names in the new table, confirm it appears in
# the existing research doc — no tool should be compared that wasn't
# actually researched.
for tool in "spec-kit" "BMAD-METHOD" "OpenSpec" "Kiro" "Tessl" "Spec Kitty" \
            "Superpowers" "GSD" "PRP" "Traycer" "codemyspec"; do
  grep -qi "$tool" specs/001-specjedi-pipeline/research.md \
    && echo "OK: $tool found in research.md" \
    || echo "FAIL: $tool missing from research.md"
done
```

**Expected outcome**: all 11 lines print `OK` — zero `FAIL` lines. A
`FAIL` here means the comparison table introduced a tool this project
never actually researched under Principle II, which is not permitted by
this feature's own scope (spec.md Assumptions).

## Scenario 2: The table is reachable from README

```bash
grep -q "competitive-comparison.md" README.md \
  && echo "OK: README links to the comparison table" \
  || echo "FAIL: no link found"
```

**Expected outcome**: `OK` — confirms FR-006 / SC-003 (reachable within
one click from the project's front door).

## Scenario 3: Structural lint still passes

```bash
bash scripts/validate.sh
```

**Expected outcome**: `validate.sh: PASSED` — this feature adds no new
constitution placeholders, no new `SKILL.md`, and trips no Principle IX
battery-growth trigger, so the existing validation battery should pass
unchanged.
