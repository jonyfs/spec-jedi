# Implementation Plan: A Distinct "Mission Complete" Closing Voice

**Branch**: `057-mission-complete-voice` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/057-mission-complete-voice/spec.md`

## Summary

Adds one new reference document, `references/mission-complete-voice.md`,
defining the concrete "genuinely exhausted scope" trigger condition and
the closing-line convention (FR-001/002), then applies it to every
`specjedi-*` skill whose own logic can genuinely reach that state —
enumerated by reading each skill's own closing-moment logic directly,
not assumed from its name. Resolves the "shared doc vs. per-skill
duplication" question as a shared doc, matching this project's own
established precedent (specs/049, 050, 051, 052, 056).

## Technical Context

**Language/Version**: N/A — markdown skill content + one new reference
doc.

**Primary Dependencies**: `references/star-wars-lexicon.md` (existing,
reused for the actual inspirational lines — never a new lexicon).

**Storage**: N/A.

**Testing**: No CI job. Verified via `scripts/validate.sh` and a manual
cross-discipline spot-check.

**Constraints**: FR-003/FR-004 (never fabricate "the end," never claim
project-wide completion) are the central, non-negotiable guardrails
(Constitution Principle XX).

**Scale/Scope**: One new reference file; a short addition to each
qualifying skill's own clean-pass/exhausted-scope closing text.

## Constitution Check

| Principle | Check | Status |
|---|---|---|
| II | No new voice mechanism — reuses `references/star-wars-lexicon.md`'s existing pool; the trigger condition itself is new but narrowly scoped and documented here, not a structural pattern needing external benchmarking. | ✅ Pass |
| IX | No CI job; validated via `scripts/validate.sh` + manual spot-check. | ✅ Pass |
| XII | Every closing line is genuine, specific Star Wars voice, reusing the existing lexicon — never generic. | ✅ Pass — enforced during implementation |
| XX | FR-003/004 make this plan's central constraint explicit: never fabricate an ending, never overstate scope. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/057-mission-complete-voice/
├── plan.md
└── tasks.md
```

### Source Code (repository root)

```text
references/
└── mission-complete-voice.md   # NEW — trigger condition + closing
                                  #   convention, cited by qualifying
                                  #   skills rather than restated

.claude/skills/specjedi-skill-review/SKILL.md         # AMENDED — clean-pass closing
.claude/skills/specjedi-catalog-audit/SKILL.md        # AMENDED — clean audit closing
.claude/skills/specjedi-constitution-audit/SKILL.md   # AMENDED — clean audit closing
.claude/skills/specjedi-quick/SKILL.md                # AMENDED — eligibility-satisfied closing (if applicable)
```

### Implementation notes

1. **Write `references/mission-complete-voice.md`**: the trigger
   condition (verifiably exhausted scope, never ambiguous completion),
   the closing-line shape (additive to plain status text, per Principle
   XII's own existing plain-language-pairing rule), and the two hard
   guardrails (never fires when a next step exists; never implies
   project-wide completion).
2. **Enumerate qualifying skills** by reading each skill's own
   closing-moment logic directly: `specjedi-skill-review` (clean pass),
   `specjedi-catalog-audit`/`specjedi-constitution-audit` (clean audit,
   zero findings), `specjedi-quick` (eligibility check with nothing
   further required) are strong candidates; skills with no genuine
   exhausted-scope case (e.g. `specjedi-explain`) are correctly excluded.
3. **Add the closing line** to each qualifying skill's own
   already-existing clean-pass/no-findings branch — additive to the
   plain status word, citing the new reference doc rather than restating
   its rule.
4. **Validate**: `scripts/validate.sh` passes; spot-check at least one
   qualifying skill's own updated closing text against the reference
   doc's own trigger condition.
