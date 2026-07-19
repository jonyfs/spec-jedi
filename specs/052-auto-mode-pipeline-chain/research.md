# Research: `--auto` Mode Verification & Chained Pipeline Execution

**Feature**: specs/052-auto-mode-pipeline-chain
**Date**: 2026-07-19 (retroactive)

**Note on timing**: this document was written *after* `specjedi-chain`
shipped (PR #146), not before — a `specjedi-constitution-audit` run on
2026-07-19 found the feature had no `research.md` at all, a direct
violation of Principle II (NON-NEGOTIABLE: "No new skill... may be
added... without first researching"). `plan.md`'s own Constitution
Check table self-certified Principle II "✅ Pass" on the basis of
internal-reuse reasoning (extends `specjedi-skill-review`, reuses
existing stages' own `--auto` behavior) — a real and sound engineering
argument, but not the external competitive benchmark the principle
actually requires. This document supplies that benchmark now, closing
the artifact gap; it does not undo that the skill was built without it
first.

## Why this skill, why now

The request was to verify `--auto` mode works consistently across the
catalog *and* let it run multiple pipeline stages back-to-back without
manual re-invocation between them. The first half needed no new build
(a full sweep confirmed all 28-then-shipped skills already had a
correctly-scoped `## \`--auto\` mode` section). The second half —
chaining `specjedi-specify` → `specjedi-clarify` → `specjedi-plan` →
`specjedi-tasks` in sequence — is genuinely new build work, and is what
this research addresses.

## Baseline: GitHub spec-kit

`speckit-*`'s own commands (`specify`, `clarify`, `plan`, `tasks`) are
independently invoked, one at a time, with no native "run the next N
stages automatically" mode and no persisted state tracking where a
chained run left off. Consistent with this project's own existing
characterization (`references/competitive-comparison.md`): "rigid phase
gates with no lightweight path." **Adopt**: nothing (no mechanism to
adopt). **Reject**: none applicable.

## Researched competitors

1. **BMAD-METHOD** — the closest real prior art found. Its Orchestrator
   agent runs a YAML-defined workflow across specialized agents,
   evaluating each stage's output for completeness before handing off
   to the next, with pre-defined handoff prompts carrying context
   forward automatically ([BMAD Method Explained, Augment
   Code](https://www.augmentcode.com/guides/bmad-method-ai-development);
   [BMAD Planning & Orchestrator
   plugin](https://aj-geddes.github.io/claude-code-bmad-skills/)). This
   is a genuine automatic-chaining mechanism, not just documentation
   describing one.
2. **GSD** — Auto mode is a persistent state machine (DB-backed at the
   project root) that creates a fresh subagent session per unit of
   work, injects pre-inlined context, and can resume an interrupted run
   from durable state on the next invocation
   ([open-techstack.com](https://open-techstack.com/blog/get-shit-done-ai-coding-context-engineering/);
   [gsd-build/gsd-2 auto-mode
   docs](https://github.com/gsd-build/gsd-2/blob/main/docs/user-docs/auto-mode.md)).
   Already partially credited in `references/competitive-comparison.md`
   for the `--auto` flag concept itself; this research confirms GSD's
   own continuous-execution design is more elaborate (durable,
   crash-resumable state) than what `specjedi-chain` adopts.
3. **OpenSpec, Kiro, Tessl, Spec Kitty, Superpowers, PRP, Traycer,
   codemyspec.com** — no publicly documented multi-stage
   auto-chaining mechanism found for any of these in this pass; each is
   already characterized in `references/competitive-comparison.md` for
   a different capability (worktree isolation, plan completeness, IDE
   integration, etc.), none of which is chaining.

**Adopt**: BMAD's core insight — chain by handing off between
already-existing, independently-capable stages, evaluating completeness
between each, rather than building one monolithic multi-stage command.
**Reject**: BMAD's own persona-orchestration model (a dedicated
Orchestrator agent distinct from the stage agents) and GSD's durable,
DB-backed resumability — both heavier than this project's own scope.
`specjedi-chain` deliberately stays a thin sequencer over the *existing*
`specjedi-specify`/`clarify`/`plan`/`tasks` skills' own already-shipped
`--auto` behavior, per Principle II's "adapting, not reinventing" — this
project already had four independently-`--auto`-capable stages; BMAD and
GSD both build orchestration *and* the stages themselves as one system,
which isn't the situation `specjedi-chain` was solving for.

## Genuine contribution beyond the researched field

Neither BMAD nor GSD's chaining mechanism preserves each stage's own
*independent* human-decision-point discipline as a hard constraint —
BMAD's Orchestrator evaluates completeness and decides when to hand off,
which is itself a judgment call the orchestrator makes; GSD's state
machine resumes automatically without a documented equivalent of "halt
at *this specific* human-decision point, no others." `specjedi-chain`'s
own FR-002 (the chain never resolves a genuine ambiguity itself; every
stage's own existing halt condition — a real NEEDS CLARIFICATION, a
failed eligibility check — is preserved exactly, verified during
implementation) is not something either researched competitor's public
documentation describes doing. This is the capability this project
contributes back to the field for this specific skill, per Principle II.

## Design implications (confirms the shipped design, not a new one)

- Reuse existing stages' own `--auto` behavior unchanged — never a
  second, competing definition of what `--auto` means per stage
  (matches BMAD's handoff-between-independently-capable-stages pattern,
  not GSD's build-everything-as-one-system pattern).
- Halt exactly where any stage's own `--auto` already halts — the one
  design requirement neither researched competitor's chaining mechanism
  is documented to guarantee as explicitly.
- No durable/resumable state (unlike GSD) — in scope for a future
  feature if a real need for crash-recovery across a chained run
  surfaces; not requested here, not retrofitted speculatively.

## Summary of touched files (matches what actually shipped)

| File | Change |
|---|---|
| `.claude/skills/specjedi-chain/SKILL.md` | NEW — orchestrates specify→clarify→plan→tasks in `--auto` mode |

No new scripts, no new reference files, no new dependencies.
