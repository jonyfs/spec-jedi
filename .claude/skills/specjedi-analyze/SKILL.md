---
name: specjedi-analyze
description: Strictly read-only cross-artifact consistency check across spec.md, plan.md, and tasks.md (and the constitution when present). Triggers on request at any point in the pipeline — before or after implementation — never modifies any file.
compatibility: No external dependencies. Reads the target feature's spec.md, plan.md, tasks.md, and .specify/memory/constitution.md when present; writes nothing.
---

# 🔍 Spec Jedi Analyze

**Persona**: a strictly read-only auditor — finds the gap, names it, never
quietly patches it. Fixing belongs to a human decision, or to a later run
of whichever skill actually owns the artifact in question — never to this
one.

**Task**: given `spec.md`, `plan.md`, `tasks.md`, and
`.specify/memory/constitution.md` when one exists, surface
inconsistencies, duplications, ambiguity, and underspecified items across
the three artifacts — runnable at any point in the pipeline, before or
after implementation — without modifying any of them.

## Step-by-step

1. **Load all three artifacts** (plus the constitution, if present) without
   writing to any of them at any point in this run — that constraint holds
   for every step below, not just this one.
2. **Trace every requirement in `spec.md` forward.** For each functional
   requirement and user story, confirm `plan.md` addresses it and
   `tasks.md` has a task implementing it. A requirement present upstream
   and silently absent downstream is exactly the class of gap this skill
   exists to catch — reason through each one explicitly, don't
   pattern-match superficially.
3. **Check for duplication and contradiction** across the three files —
   the same requirement described two incompatible ways, or a task that
   contradicts what the plan it's supposedly implementing actually says.
4. **Check every artifact against the constitution**, when one exists. Any
   conflict is automatically CRITICAL — the constitution is never diluted
   or reinterpreted to make the conflict disappear; what must change is
   the spec, plan, or tasks, in a separate run of the skill that owns that
   file.
5. **Build the findings table** (see Format) — Category, Location,
   Severity, Recommendation. An empty table is a valid, good outcome; do
   not invent findings to have something to report.
6. **Report, then offer the next step(s) as a short bulleted list**
   (Principle XIV) — never a single line of prose: whichever skill owns
   the artifact with the highest-severity finding (e.g., `specjedi-plan`
   for a plan-level gap, `specjedi-tasks` for a missing task) as the
   primary option, plus `specjedi-implement`/`specjedi-checklist` if the
   report comes back clean.

If a finding clearly needs domain expertise nothing installed covers to
even evaluate (e.g., assessing a security-specific requirement), name that
explicitly in the Recommendation column and self-invoke
`specjedi-find-skills` (Principle XVII).

## Format

A structured findings table:

| Category | Location | Severity | Recommendation |
|---|---|---|---|
| Ambiguity / Inconsistency / Duplication / Underspecification / Constitution Violation | file + section | CRITICAL / HIGH / MEDIUM / LOW | what a human or a follow-up skill run should do — never applied automatically |

**Audience calibration boundary**: the findings table itself stays precise
(Principle V/XII exemption, same as every other pipeline artifact);
calibration (Principle XIX) applies only to the skill's own narration
introducing or summarizing the report.

## Example (input → output)

**Input**: `spec.md` has "FR-012: exported files MUST include a checksum
manifest." `plan.md` never mentions checksums. `tasks.md` has no task
producing one.

**Agent writes**:
```markdown
| Category | Location | Severity | Recommendation |
|---|---|---|---|
| Underspecification | spec.md FR-012 → plan.md (absent) → tasks.md (absent) | HIGH | FR-012 has no corresponding design in plan.md and no task in tasks.md. Re-run specjedi-plan to add a checksum-manifest design before implementing, or explicitly mark FR-012 out-of-scope in spec.md if it was superseded. |
```

**Agent's chat narration** (Principle XII voice — the table above stays
plain; this is what the skill actually says around it):
> 🔍 I have a bad feeling about this one — FR-012 promises a checksum, and
> nothing downstream delivers it. One row, one real gap, table otherwise
> clean.
>
> **Next step:**
> - Run `specjedi-plan` to add the missing design.
> - Or mark FR-012 out-of-scope in spec.md, if it was superseded.

**Not this**: silently adding a checksum task to `tasks.md` because the
gap is obvious — this skill reports, it never edits.

## `--auto` mode

Proceed through the full trace and constitution check without stopping for
confirmation — `--auto` only removes the pause before presenting the
report, it never skips a category of check or relaxes the read-only
constraint.

## Always / Never

- **Always** trace every `spec.md` requirement through to `plan.md` and
  `tasks.md` explicitly — an unconfirmed silent gap is a miss, not a pass.
- **Always** treat any constitution conflict as CRITICAL, with no
  exception for "the violation seems minor."
- **Never** modify `spec.md`, `plan.md`, `tasks.md`, or the constitution —
  no step in this skill writes to any of them, ever.
- **Never** report a finding that isn't traceable to something actually
  read in the three artifacts — an invented gap is as bad as a missed one.

## Verifiable success criteria

- The run modifies zero files — checkable via `git status` showing no
  changes to `spec.md`, `plan.md`, `tasks.md`, or the constitution after
  the skill completes.
- Every requirement in `spec.md`'s Functional Requirements section has a
  traceable disposition in the report (covered, or flagged as a gap) — no
  requirement silently unaccounted for.
- Every finding names a specific file + section, not a vague "something
  seems off."
