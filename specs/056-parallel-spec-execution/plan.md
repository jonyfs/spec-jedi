# Implementation Plan: Safe Parallel Spec Execution Across Distinct Agents

**Branch**: `056-parallel-spec-execution` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/056-parallel-spec-execution/spec.md`

## Summary

Adds a new skill, `specjedi-parallel`, that (1) cross-references
candidate features' own already-declared `plan.md` "Source Code"
sections to determine a safe-to-parallelize set (excluding
`CLAUDE.md`/`.specify/feature.json` from the overlap check, per FR-002),
(2) dispatches one worktree per safe feature by reusing
`specjedi-worktree`'s own existing creation mechanism unchanged, and (3)
relies entirely on `specjedi-status`'s own existing multi-worktree
reporting for visibility — resolving FR-007 (new skill vs. extend
`specjedi-worktree`) as a new skill, since neither the overlap-detection
reasoning nor the "many worktrees at once" orchestration fits
`specjedi-worktree`'s own single-target creation model.

## Technical Context

**Language/Version**: N/A — markdown skill content.

**Primary Dependencies**: None new. Reuses `specjedi-worktree`'s own
creation mechanism and `specjedi-status`'s own multi-worktree reporting
directly.

**Storage**: N/A.

**Testing**: No CI job. Verified via `scripts/validate.sh` and a manual
dry-run: construct two hypothetical `plan.md`s with a genuine file
overlap and confirm it's flagged; confirm two real `plan.md`s (e.g. two
of this session's own recent features) that both touch
`CLAUDE.md`/`.specify/feature.json` are correctly reported safe.

**Constraints**: FR-005 (harness dispatch mechanism not assumed
universal, Principle III) bounds User Story 2's own scope.

**Scale/Scope**: One new skill file
(`.claude/skills/specjedi-parallel/SKILL.md`).

## Constitution Check

| Principle | Check | Status |
|---|---|---|
| II | Reuses `specjedi-worktree`/`specjedi-status` unchanged rather than duplicating either; the "new skill vs. extend worktree" decision is reasoned through directly in this plan (Summary above), matching this project's own established precedent. | ✅ Pass |
| III | Distinct-agent dispatch (User Story 2) is explicitly conditional on the current harness exposing a concurrent-agent mechanism — never assumed universal. | ✅ Pass |
| IX | No CI job; validated via `scripts/validate.sh` + manual dry-run against a constructed overlap case and a real non-overlap case. | ✅ Pass |
| XII | New skill gets its own genuine Persona, distinct from `specjedi-worktree`'s "careful workspace steward." | ✅ Pass — enforced during implementation |
| XV | Named `specjedi-parallel`, correct prefix, collision-checked. | ✅ Pass |
| XIX | Token count checked before shipping. | ✅ Pass — enforced during implementation |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/056-parallel-spec-execution/
├── plan.md
└── tasks.md
```

### Source Code (repository root)

```text
.claude/skills/specjedi-parallel/
└── SKILL.md          # NEW — safe-set determination + parallel dispatch
                        #   + status visibility (reused, not duplicated)
```

### Implementation notes

1. **Enumerate candidates**: `ls specs/ | grep -E '^[0-9]+-'`, filter to
   those with a `plan.md`.
2. **Overlap check** (User Story 1, FR-001/002/003): for each pair,
   diff their `plan.md`'s own "Source Code" file lists, excluding
   `CLAUDE.md`/`.specify/feature.json`. Report genuine overlaps by name;
   report spec-only candidates as "not yet checkable."
3. **Dispatch** (User Story 2, FR-004/005): for each feature in the safe
   set, self-invoke `specjedi-worktree`'s own creation mechanism
   unchanged; then, if the current harness exposes a mechanism for
   independent concurrent agent sessions, dispatch one per worktree —
   otherwise report the prepared worktrees and safe-set determination
   without claiming dispatch happened.
4. **Status** (User Story 3, FR-006): point directly at
   `specjedi-status`'s own existing multi-worktree report — no new
   dashboard logic.
5. **Validate**: `scripts/validate.sh` passes; construct a two-feature
   overlap test case and a real non-overlapping pair, confirm both
   report correctly.
