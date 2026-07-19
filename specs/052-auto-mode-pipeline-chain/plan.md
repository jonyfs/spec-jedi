# Implementation Plan: `--auto` Mode Verification & Chained Pipeline Execution

**Branch**: `052-auto-mode-pipeline-chain` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/052-auto-mode-pipeline-chain/spec.md`

## Summary

Two independent additions: (1) extends `specjedi-skill-review`'s own
Step 2/Format with a new dimension checking that a skill's `--auto mode`
text doesn't contradict its own Always/Never section, reused
catalog-wide by `specjedi-catalog-audit` — never a duplicate checker;
(2) a new skill, `specjedi-chain`, orchestrating `specjedi-specify` →
`specjedi-clarify` → `specjedi-plan` → `specjedi-tasks` in `--auto` mode
back-to-back, reusing each stage's own existing `--auto` behavior
unchanged, halting exactly where any stage's own documented `--auto`
already halts, and surfacing each artifact's own already-existing
quality gate (never adding new, earlier govcheck/constitution-audit
self-invocations, per the FR-005 Clarification).

## Technical Context

**Language/Version**: N/A — markdown skill content, no application code.

**Primary Dependencies**: None new. Orchestrates existing
`specjedi-specify`/`specjedi-clarify`/`specjedi-plan`/`specjedi-tasks`
skills exactly as they already work.

**Storage**: N/A.

**Testing**: No CI job. Verified via `scripts/validate.sh` and a manual
dry-run: (a) the extended `specjedi-skill-review` dimension checked
against a skill known to be consistent (e.g. `specjedi-release`); (b)
the chain run conceptually against a fully-resolvable hypothetical spec
and against one with a deliberate ambiguity, confirming it halts at the
right point.

**Constraints**: FR-002 (never auto-resolve a genuine ambiguity) is the
central, non-negotiable constraint (Principle IV/XX). FR-005 (no new
self-invocation timing) bounds User Story 3's own scope.

**Scale/Scope**: One small addition to `specjedi-skill-review`
(Step/Format), one new skill file
(`.claude/skills/specjedi-chain/SKILL.md`).

## Constitution Check

| Principle | Check | Status |
|---|---|---|
| II | US1 extends `specjedi-skill-review` rather than duplicating it; US2/3's orchestration reuses existing stages' own `--auto` behavior unchanged. **Amended 2026-07-19**: the original internal-reuse reasoning above did not satisfy Principle II's external-competitive-benchmark requirement — flagged by `specjedi-constitution-audit`; `research.md` was added retroactively, benchmarking against spec-kit and 10 other tools (closest prior art: BMAD-METHOD's orchestrated handoff, GSD's auto-mode state machine) and confirming the shipped design. | ✅ Pass (retroactively grounded) |
| IV/XX | FR-002 is the plan's central constraint — the chain never resolves a genuine ambiguity; every stage's own existing human-decision points are preserved exactly. | ✅ Pass |
| IX | No CI job; validated via `scripts/validate.sh` + manual dry-run against both a clean and an ambiguous case. | ✅ Pass |
| XII | `specjedi-chain` gets its own genuine Persona, distinct from every sibling pipeline skill. | ✅ Pass — enforced during implementation |
| XV | New skill named `specjedi-chain`, correct prefix, collision-checked before creation. | ✅ Pass |
| XIX | New skill's token count checked before shipping (target: comparable to sibling pipeline skills, well under the 5,000 hard cap). | ✅ Pass — enforced during implementation |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/052-auto-mode-pipeline-chain/
├── plan.md
└── tasks.md
```

### Source Code (repository root)

```text
.claude/skills/specjedi-skill-review/SKILL.md  # AMENDED — Step 2.6 +
                                                 #   Format row: --auto
                                                 #   vs Always/Never
                                                 #   contradiction check

.claude/skills/specjedi-chain/
└── SKILL.md          # NEW — orchestrates specify→clarify→plan→tasks
                        #   in --auto mode, halting at any stage's own
                        #   documented stopping condition
```

### Implementation notes

1. **Extend `specjedi-skill-review`** (User Story 1): add Step 2.6 —
   for each skill, compare its `--auto mode` section's own text against
   its Always/Never section; flag a contradiction if the `--auto`
   text claims to skip something Always/Never calls non-negotiable.
   Add a corresponding Format table row.
2. **Write `specjedi-chain`** (User Story 2/3): Persona/Task establishing
   it as a pipeline orchestrator, not a redefinition of any stage's own
   behavior. Step-by-step: (a) detect which artifacts already exist for
   the named feature and resume from the right stage (FR-004); (b) run
   each remaining stage's own `--auto` mode exactly as documented,
   surfacing that stage's own quality gate (e.g. `plan.md`'s Constitution
   Check) in a running summary (FR-005, US3); (c) halt immediately and
   hand control back the moment any stage hits its own documented
   `--auto` stopping condition (FR-002) — never past it.
3. **Validate**: `scripts/validate.sh` passes; manual dry-run of both the
   extended `specjedi-skill-review` dimension and the chain's own
   halt-on-ambiguity behavior.
