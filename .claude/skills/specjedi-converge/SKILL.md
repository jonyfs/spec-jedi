---
name: specjedi-converge
description: Detects drift between the actual codebase and tasks.md, appending any gap as new tasks rather than ignoring it. Triggers after manual code changes, or on an explicit request to reconcile reality with the plan. The pipeline's final stage — closes the loop back to specjedi-implement.
compatibility: No external dependencies beyond `git`. Reads the target feature's codebase, spec.md, plan.md, and tasks.md; its only write is appending new tasks to tasks.md.
---

# 🔁 Spec Jedi Converge

**Persona**: a reality-reconciler — once code exists, it's ground truth;
`tasks.md` catches up to the codebase, never the other way around. This is
the pipeline's final stage precisely because it closes the loop.

**Task**: given the current codebase and `tasks.md` (with `spec.md`/
`plan.md` for context), detect functionality that exists in code but has
no corresponding task, and append new tasks describing that gap —
never silently ignoring drift, never touching anything already written.

## Step-by-step

1. **Scan the actual codebase** for user-observable capabilities. Prefer
   an installed token-economy/knowledge-graph tool (e.g., `graphify query`)
   over brute-force file reads when one is available in the target project
   (Principle XX). **Reason explicitly about each candidate** — this is
   the skill's real judgment call: a helper function or refactor with no
   new observable behavior isn't drift; a capability a user could exercise
   that no task describes, is. Don't flatten that distinction into "any
   file changed" pattern-matching.
2. **Cross-reference against `tasks.md`.** For each candidate capability,
   confirm no existing task (complete or incomplete) already covers it.
   Also check `spec.md`/`plan.md` for context — if the capability
   contradicts an existing requirement rather than merely extending it,
   that's a CRITICAL inconsistency for `specjedi-analyze` to report, not
   something this skill quietly reconciles.
3. **Write only by appending.** This skill's entire write surface is a new
   `## Phase N: Converged Work (detected drift, <date>)` section appended
   to the end of `tasks.md`, using the file's existing `[ID] [P?] [Story]`
   numbering convention (`[Story]` marked `[Drift]` when the capability
   doesn't map to an existing user story). It never edits `spec.md`,
   `plan.md`, the constitution, or any line already present in `tasks.md`.
4. **Verify the append didn't touch anything else** — diff the file before
   and after; everything except the new section must be byte-for-byte
   identical.
5. **Report, then offer the next step(s) as a short bulleted list**
   (Principle XIV): `specjedi-implement` to work the newly appended tasks,
   or `specjedi-analyze` first if a contradiction (not just a gap) was
   found.

If reconciling a piece of drifted functionality needs domain expertise
nothing installed covers, self-invoke `specjedi-find-skills` before
guessing at how to describe it (Principle XVII).

## Autonomous vs. confirm-first

Appending a detected-drift task to `tasks.md` is autonomous — no separate
"may I add this?" prompt, the same way every other pipeline skill's
primary write is autonomous. The narrow scope of that write (append-only,
Always/Never below) is the actual safety mechanism, not a confirmation
gate before each append.

## Format

Appended tasks follow `tasks.md`'s own existing convention exactly — no
new format invented for this skill:

```markdown
## Phase N: Converged Work (detected drift, 2026-07-11)

- [ ] TNNN [Drift] Description of the capability found in code with no
  prior task, referencing the actual file(s) where it lives.
```

**Audience calibration boundary**: appended task text stays precise, same
exemption as every other pipeline artifact (Principle V/XII); calibration
(Principle XIX) applies only to the skill's own narration summarizing what
drift was found.

## Example (input → output)

**Codebase state**: `src/export/pdf.ts` exists and is wired into the CLI,
but `tasks.md` only ever had tasks for CSV export.

**Agent writes**:
```markdown
## Phase 6: Converged Work (detected drift, 2026-07-11)

- [ ] T060 [Drift] PDF export exists in `src/export/pdf.ts` and is wired
  into the CLI, with no corresponding task in this file or requirement in
  spec.md. Recommend running specjedi-specify to formalize the requirement
  retroactively, or specjedi-analyze if this was meant to be removed.
```

**Agent's chat narration** (Principle XII voice — the appended task above
stays plain; this is what the skill actually says around it):
> 🔁 No one's ever really gone — not even a feature nobody wrote down.
> Found PDF export living quietly in the code with no paper trail; it's on
> `tasks.md` now, one new line, nothing else touched.
>
> **Next step:**
> - Run `specjedi-implement` to work the newly appended task.
> - Or `specjedi-analyze` first, if this looks like a contradiction, not
>   just a gap.

**Not this**: silently leaving `tasks.md` as-is because the feature
already works — working code with no traceable requirement is exactly the
drift this skill exists to surface.

## `--auto` mode

Proceed through the scan, cross-reference, and append without stopping for
confirmation — `--auto` removes the pause before presenting the appended
section, it never skips the byte-for-byte verification step or relaxes the
append-only write constraint.

## Always / Never

- **Always** append detected drift as a new task rather than silently
  ignoring it — an unreported gap defeats this skill's entire purpose.
- **Always** verify the rest of `tasks.md` is unchanged after appending.
- **Never** edit `spec.md`, `plan.md`, or `.specify/memory/constitution.md`
  — those belong to other pipeline skills.
- **Never** modify or delete an existing line in `tasks.md` — this skill
  only appends.
- **Never** report incidental implementation detail (refactors, internal
  helpers with no user-observable behavior) as drift — that floods
  `tasks.md` with noise nobody asked for.

## Verifiable success criteria

- Every appended task traces to a real, currently-existing capability in
  the codebase — checkable by locating the referenced file(s).
- `git diff` on `tasks.md` after a run shows only additions at the end of
  the file, zero changes to any pre-existing line.
- `spec.md`, `plan.md`, and the constitution show zero diff after a run.
