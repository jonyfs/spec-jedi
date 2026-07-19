# Research: Safe Parallel Spec Execution Across Distinct Agents

**Feature**: specs/056-parallel-spec-execution
**Date**: 2026-07-19 (retroactive)

**Note on timing**: this document was written *after* `specjedi-parallel`
shipped (PR #147), not before — a `specjedi-constitution-audit` run on
2026-07-19 found the feature had no `research.md` at all, a direct
violation of Principle II (NON-NEGOTIABLE: "No new skill... may be
added... without first researching"). `plan.md`'s own Constitution
Check table self-certified Principle II "✅ Pass" on the basis that the
"new skill vs. extend `specjedi-worktree`" decision was "reasoned
through directly in this plan" — a real design decision, but not the
external competitive benchmark the principle actually requires. This
document supplies that benchmark now, closing the artifact gap; it does
not undo that the skill was built without it first.

## Why this skill, why now

The request was to run multiple specs in parallel, across distinct
agents, without one run disrupting another. `specjedi-worktree` already
mechanizes isolated, collision-free workspaces (one real git worktree
per feature) but does not decide *which* candidate features are
actually safe to run at the same time, and dispatches exactly one
worktree per invocation. The genuinely new work is the safety
determination (file-overlap analysis across candidates' own declared
`plan.md` scope) plus multi-worktree/multi-agent dispatch.

## Baseline: GitHub spec-kit

No native concurrent-execution or worktree-dispatch mechanism as of
this research — confirmed by a still-open upstream feature request
(`github/spec-kit` issue #1476, "Native `git worktree` Support for
Concurrent/Parallel Agent Execution"), meaning the maintainers
themselves treat this as an unimplemented gap, not a design they
rejected. **Adopt**: nothing (no mechanism to adopt). **Reject**: none
applicable.

## Researched competitors

1. **Spec Kitty** — the closest and most directly relevant real prior
   art found, genuinely exercising the exact capability this feature
   needs: it explicitly supports running "parallel Claude Code, Codex,
   Cursor, Copilot, Gemini, or Windsurf work with git worktree
   isolation," coordinating multi-stage work (an Analysis Agent, an
   Implementation Agent, a Review Agent, a Test Agent) across worktrees
   with a Kanban-style dashboard and an explicit
   next→review→accept→merge runtime loop ([Spec Kitty
   GitHub](https://github.com/Priivacy-ai/spec-kitty);
   [skillsllm.com](https://skillsllm.com/skill/spec-kitty)). Already
   partially credited in `references/competitive-comparison.md` for
   worktree-awareness generally (adopted into `specjedi-worktree`,
   feature 032); this research confirms Spec Kitty's own model goes
   further than that credit currently states — it's built for genuine
   multi-agent parallel dispatch, not just worktree isolation for one
   agent at a time.
2. **GSD** — "wave-based parallel execution" groups task plans by
   dependency into waves; independent plans within a wave run in
   parallel (each in a fresh subagent with its own full context
   window), while dependent plans wait for their wave
   ([open-techstack.com](https://open-techstack.com/blog/get-shit-done-ai-coding-context-engineering/)).
   This is real, working prior art for *automatic* dependency-aware
   parallel scheduling — a capability `specjedi-parallel` does not
   itself implement (it determines safety via file-overlap, not a
   dependency graph, and requires an explicit user decision to run in
   parallel rather than auto-scheduling waves).
3. **BMAD-METHOD, OpenSpec, Kiro, Tessl, Superpowers, PRP, Traycer,
   codemyspec.com** — no publicly documented multi-agent parallel
   dispatch or worktree-safety-determination mechanism found for any of
   these in this pass; each is already characterized in
   `references/competitive-comparison.md` for a different capability.

**Adopt**: git-worktree isolation as the concurrency primitive (Spec
Kitty's own approach, already the industry-emerging default per
independent research — see [Zylos Research on worktree isolation
patterns](https://zylos.ai/research/2026-02-22-git-worktree-parallel-ai-development/)),
reusing `specjedi-worktree` rather than reinventing worktree management.
**Reject**: Spec Kitty's own Kanban-dashboard/lane-assignment model
(work packages manually assigned to lanes) and GSD's automatic
wave-scheduling by dependency graph — both heavier than what this
feature needs; `specjedi-parallel` stays a narrow "is this pair of
candidates actually safe together, given their own declared file
scope?" check, on explicit request only, not a standing scheduler.

## Genuine contribution beyond the researched field

Neither Spec Kitty nor GSD is documented to determine parallel-safety
by cross-referencing each candidate's own already-declared plan-scope
file list for genuine overlap before dispatching — Spec Kitty relies on
a human assigning work to lanes/worktrees, and GSD's wave grouping is
by task *dependency*, not by declared *file-scope overlap* specifically.
`specjedi-parallel`'s own mechanism — reading each candidate's own
`plan.md` "Source Code" section, excluding known-shared metadata files
every feature routinely touches, and only then treating a pair as safe
— is a narrower, more mechanically verifiable safety check than either
researched competitor's own documented approach, and one this project
contributes back to the field.

## Design implications (confirms the shipped design, not a new one)

- Reuse `specjedi-worktree`/`specjedi-status` unchanged — worktree
  creation and cross-worktree status reporting were already solved;
  `specjedi-parallel`'s only new work is the safety determination and
  dispatch, matching Spec Kitty's own worktree-as-primitive choice
  without adopting its dashboard/lane machinery.
- Distinct-agent dispatch is explicitly conditional on the current
  harness exposing a concurrent-agent-dispatch mechanism, never assumed
  universal (Principle III) — unlike GSD and Spec Kitty, which are each
  built for one specific harness ecosystem, `specjedi-*` ships across
  20 harnesses and can't assume every one supports concurrent dispatch.
- File-overlap safety check, not dependency-graph scheduling (unlike
  GSD's wave model) — in scope for a future feature if dependency-aware
  auto-scheduling is ever genuinely requested; not retrofitted
  speculatively here.

## Summary of touched files (matches what actually shipped)

| File | Change |
|---|---|
| `.claude/skills/specjedi-parallel/SKILL.md` | NEW — safe parallel spec execution across distinct agents |

No new scripts, no new reference files, no new dependencies.
