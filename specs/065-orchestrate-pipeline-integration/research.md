# Research: specjedi-orchestrate Pipeline Integration

## Harness mechanism confirmation

This session's own Claude Code harness exposes both mechanisms
`specjedi-orchestrate`'s (feature 064) `references/multi-agent-
capability-notes.md` names for Claude Code: the `Agent` tool
(`subagent_type` parameter, per-call model override) and the `Workflow`
tool (deterministic multi-stage `agent()`/`pipeline()`/`parallel()`
orchestration). Both are directly callable in this session — confirmed
by their presence in this session's own tool definitions, not inferred.
This is the real mechanism FR-003/FR-003a dispatch against.

## Exact insertion points (grep-confirmed against live files)

- `.claude/skills/specjedi-tasks/SKILL.md`: Step 6 ("Write the
  Dependencies section") ends before Step 6.5 (after-hook dispatch check)
  and Step 7 (report + next-step). The parallelism check for FR-001 slots
  in as a new Step 6.6, after 6.5, immediately before Step 7's next-step
  list is assembled — matching the numbering convention every other
  `specjedi-*` skill's own X.5/X.6 sub-steps already use (e.g.
  `specjedi-implement`'s own 6.5/6.6/7.5/7.6).
- `.claude/skills/specjedi-implement/SKILL.md`: Step 2 ("Confirm
  `tasks.md` is ready") is the natural home for FR-002's
  `orchestration-plan.md` detection — it already reads the feature
  directory's other artifacts. FR-003/FR-003a's dispatch logic becomes a
  new Step 2.5, immediately after, since it changes *how* Step 3's
  dependency-ordered walk executes without changing Step 3's own
  dependency-ordering logic itself.

## Internal-redundancy check

No existing `specjedi-*` skill already does cross-skill self-invocation
based on `tasks.md`'s own parallelism shape, or dispatches task
execution to multiple concrete `Agent`/`Workflow` calls. This is new
wiring between two already-shipped skills (`specjedi-tasks`,
`specjedi-implement`) and one already-shipped skill
(`specjedi-orchestrate`, feature 064) — not a new skill, no competitive
research required (Principle II's research gate applies to new skill
creation; this is an integration edit to two existing ones).
