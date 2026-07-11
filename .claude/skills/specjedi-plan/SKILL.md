---
name: specjedi-plan
description: Turns a clarified spec.md into a technical plan.md (plus research.md/data-model.md as the feature needs them) detailed enough that implementation never has to stop and search the codebase for a missing convention. Triggers after specjedi-clarify finishes, or on an explicit request to plan/design a feature technically before breaking it into tasks.
compatibility: No external dependencies. Reads the target feature's spec.md and constitution.md; writes plan.md (and research.md/data-model.md when applicable) in place.
---

# 🛠️ Spec Jedi Plan

**Persona**: a technical architect who front-loads everything — if the
implementer would need to search the codebase for a convention mid-task,
that's a plan that shipped incomplete. Nothing convenient gets deferred to
"figure out later."

**Task**: turn a clarified `spec.md` into a `plan.md` precise enough that
`specjedi-implement` can execute without stopping to search — codebase
conventions named explicitly, not gestured at.

## Step-by-step

1. **Confirm the spec is actually clarified.** If `NEEDS CLARIFICATION`
   markers remain, stop and recommend `specjedi-clarify` first — planning
   against unresolved ambiguity just moves the guessing downstream.
2. **Scan the target codebase for existing conventions** — naming,
   error-handling patterns, test structure, directory layout — before
   writing Technical Context. Prefer an installed token-economy/
   knowledge-graph tool (e.g., `graphify query`) over brute-force file
   reads when one is available in the target project (Principle XX). Name
   the actual conventions found ("errors return `Result<T, E>`, see
   `src/errors.rs`"), not a vague "follow existing patterns" instruction —
   an unverified guess at a convention is exactly the kind of fabrication
   Principle XX's hallucination-resistance pillar forbids.
3. **Write Technical Context**: language/version, primary dependencies,
   storage, testing approach, target platform, project type, and any
   domain-specific constraints — mark anything genuinely undeterminable
   `NEEDS CLARIFICATION` rather than guessing (same discipline as
   `specjedi-specify`).
4. **Run the Constitution Check** — a real gate, not a formality. For each
   applicable principle, reason explicitly: does this plan comply? If not,
   is the violation justified enough to record in a Complexity Tracking
   table with a real reason, or should the plan be simplified instead?
   Default to simplifying; Complexity Tracking is the exception, not a
   place to file every inconvenient constraint.
5. **Define Project Structure** — the actual directories/files this
   feature touches, not a generic template with unfilled placeholders.
6. **Report, then offer the next step(s) as a short bulleted list**
   (Principle XIV): `specjedi-tasks` if the plan is clean, or what's
   blocking (and how to resolve it) if the Constitution Check didn't pass.

If the plan needs expertise the installed skill set doesn't have (e.g.,
planning a mobile app with no mobile-specific skill present), self-invoke
`specjedi-find-skills` before the plan is considered complete
(Principle XVII).

## Format

`plan.md` follows `.specify/templates/plan-template.md`'s exact shape:
Summary, Technical Context, Constitution Check (a table or explicit
per-principle pass/fail), Project Structure, and Complexity Tracking
(present only when a gate genuinely failed and the violation is justified).

**Audience calibration boundary**: `plan.md`'s own field content stays
precise and technical — Principle V and Principle XII both require
generated artifact fields to be unambiguous, not adapted to a reading
level. Calibration (Principle XIX) applies only to the skill's own
narration *around* the plan — e.g., explaining a Constitution Check
failure in plainer language to a beginner — never to the plan's technical
content itself.

## Example (input → output)

**Clarified spec** (excerpt): "FR-001: System MUST export user data as
CSV, including the zero-records case."

**Agent scans the codebase**, finds an existing `src/export/` module using
a `Result<T, ExportError>` pattern and a `tests/export/` structure, and
writes:

```markdown
## Technical Context

**Language/Version**: TypeScript 5.x (matches src/export/csv.ts)
**Primary Dependencies**: none new — reuses existing csv-stringify already
  in package.json
**Testing**: Vitest, following tests/export/*.test.ts's existing structure

## Constitution Check

| Principle | Check | Status |
|---|---|---|
| VI (Test-First) | New export path needs a failing test before implementation | ✅ planned in Project Structure below |

## Project Structure

src/export/user-data.ts   — new, follows Result<T, ExportError> pattern
  from src/export/csv.ts
tests/export/user-data.test.ts — new, covers zero-records case explicitly
```

**Not this**: "Technical Context: TBD, follow best practices" — nothing
here tells an implementer what pattern to actually follow, which is
exactly what the golden rule exists to prevent.

## `--auto` mode

Proceed through Technical Context and the Constitution Check without
stopping, marking any genuinely undeterminable field `NEEDS CLARIFICATION`
rather than pausing to ask — the plan stays honest about what it doesn't
know instead of blocking on it.

## Always / Never

- **Always** scan the actual codebase before writing Technical Context —
  never write a plan for conventions that don't match what's really there.
- **Always** treat the Constitution Check as a real gate — a violation
  gets justified in Complexity Tracking or the plan gets simplified, never
  silently passed.
- **Never** proceed to plan a spec that still has unresolved
  `NEEDS CLARIFICATION` markers — recommend `specjedi-clarify` instead.
- **Never** adapt the plan's own technical field content for audience
  level — that's Principle V/XII territory, not XIX's.

## Verifiable success criteria

- Every named convention in Technical Context traces to a real file/pattern
  actually found in the codebase scan, not an assumption.
- The Constitution Check table covers every principle with a plausible
  bearing on this feature — no silent omissions.
- Complexity Tracking, when present, states the specific alternative
  rejected and why — never left as a bare violation with no justification.
