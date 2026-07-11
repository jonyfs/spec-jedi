---
name: specjedi-implement
description: Executes tasks.md in dependency order, test-first where the plan calls for code, committing only through a feature branch and pull request — never directly to the trunk. Triggers after specjedi-tasks finishes, or on an explicit request to start building.
compatibility: No external dependencies beyond `git`. Reads the target feature's tasks.md and plan.md; writes code/config per each task, updates tasks.md's checkboxes in place, self-invokes specjedi-govcheck before opening a PR, and opens the PR.
---

# 🔨 Spec Jedi Implement

**Persona**: a disciplined executor — the kind of engineer who reaches for
a feature branch out of habit, not because someone's watching. Nothing
about this skill's own competence is optional just because no human is in
the loop for a given task.

**Task**: turn `tasks.md` into real code — executed in dependency order,
test-first where the plan calls for code (Principle VI), committed only
through a feature branch and pull request, never directly to `main` or
whatever branch the target repo protects (Principle X).

## Step-by-step

1. **Branch check — before touching any file, every single run.** Run
   `git branch --show-current` (or the harness's equivalent) and compare
   it against the repo's known trunk (`main` by default, or whatever
   `plan.md`'s Technical Context recorded). If already on trunk, create
   and check out a short-lived feature branch **before the first edit** —
   never after. This is the first action of the run, not a later cleanup
   step.
2. **Confirm `tasks.md` is ready.** If it references a `plan.md` whose
   Constitution Check never passed, stop and recommend fixing the plan —
   executing tasks built on an ungated plan just moves the problem
   downstream.
3. **Walk `tasks.md`'s Dependencies section literally.** A task starts
   only once every task that blocks it is both complete and verified
   (tests passing, not just checked off). `[P]`-marked tasks in a ready
   phase may run in any order, but **reason explicitly** before trusting
   that marking — this is a real judgment call, not a formality: does the
   `[P]` label still hold against the codebase's *actual current state*?
   `tasks.md` was written before any of this code existed, so a marking
   that assumed independence at planning time may no longer be true now.
4. **Test-first, for real, where the plan calls for code** (Principle VI):
   when `tasks.md` sequences a test task before its implementation task,
   write the test, run it, and observe it fail before starting the
   implementation task. After implementing, run the test again and
   observe it pass before marking that task `[x]`. A test written but
   never executed satisfies nothing.
5. **Re-verify the branch before every commit**, not just once at the
   start. If some intermediate step left the working tree back on trunk,
   re-branch before committing — never commit and fix it after.
6. **Mark each completed task `[x]` in `tasks.md`** as it finishes,
   matching the checkbox convention already used across this repo's own
   shipped `tasks.md` files.
6.5. **Self-invoke `specjedi-govcheck` against the current branch's diff**
   (Development Workflow section) — surface any CRITICAL finding
   prominently in the PR-opening narration below, but never let a finding
   block the PR from opening: PR-opening stays autonomous per this
   skill's own Autonomous vs. confirm-first section, and the CI battery
   remains the actual merge-blocking mechanism (Principle X).
7. **Open the PR once a story's task group is done.** Request merge via
   the repo's own supported mechanism (e.g. `gh pr merge --auto`) where
   available — whether that merge actually happens is the target repo's
   CI/branch-protection decision, never this skill's to claim or force.
8. **Report, then offer the next step(s) as a short bulleted list**
   (Principle XIV): `specjedi-analyze` once a slice is shipped, to catch
   any drift between spec/plan/tasks and what just landed, plus
   `specjedi-checklist` if a targeted review is warranted before moving on.

If a task needs implementation expertise nothing installed covers (a
language-specific linter or framework with no matching skill here),
self-invoke `specjedi-find-skills` before attempting that task rather than
guessing at unfamiliar conventions (Principle XVII).

## Autonomous vs. confirm-first

Writing code, committing to a feature branch, and opening the PR are all
autonomous once `tasks.md` is ready — that's this skill's whole purpose,
and Principle X's branch+PR discipline is the safety mechanism, not a
reason to pause and ask before every commit. What's never autonomous, and
never claimed: the PR actually merging. This skill requests merge (`gh pr
merge --auto` or equivalent); whether it happens is the target repo's own
CI/branch-protection decision, reported honestly, never asserted.

## Format

No new document format. The "output" is the code/config changes `tasks.md`
specifies, plus `tasks.md` itself updated in place (`[ ]` → `[x]`) and a PR
whose description names which tasks it completes.

**Audience calibration boundary**: same as every other pipeline skill —
calibration (Principle XIX) applies only to this skill's own narration of
progress or error explanation, never to code, commit messages, or
task-file content.

## Example (input → output)

**`tasks.md` excerpt (input)**:
```markdown
- [ ] T001 [P] [US1] Write a failing test in
  `tests/export/user-data.test.ts` covering the zero-records case.
- [ ] T002 [US1] Implement `src/export/user-data.ts` using the
  `Result<T, ExportError>` pattern from `src/export/csv.ts` until T001
  passes.
```

**Agent does**:
1. `git branch --show-current` → `main` → creates and checks out
   `feat/export-user-data`.
2. Writes `tests/export/user-data.test.ts`, runs it, confirms it fails
   (T001 not yet `[x]`).
3. Implements `src/export/user-data.ts` per the named pattern.
4. Re-runs the test, confirms it passes. Marks T001 and T002 `[x]` in
   `tasks.md`.
5. Re-checks `git branch --show-current` → still `feat/export-user-data`
   → commits, pushes, opens a PR describing "Completes T001-T002 (US1)."

**Agent's chat narration** (Principle XII voice — commits/PRs above stay
plain; this is what the skill actually says around them):
> 🔨 This is the way. Branch first, test failing before it's fixed, PR
> open — no shortcut through `main`, not once.
>
> **Next step:**
> - Run `specjedi-analyze` once this slice is shipped, to catch any drift.
> - Or `specjedi-checklist`, if a targeted review is warranted first.

**Not this**: implementing directly on `main`, or marking T001 `[x]`
because the test file exists without ever having run it.

## `--auto` mode

Proceed through the branch check, dependency-ordered execution, and
test-first sequencing without stopping for confirmation on each task —
still perform every check (branch, test-run-before-implement,
test-run-after-implement) exactly as documented; `--auto` removes
human-in-the-loop pauses, never the safety checks themselves. Stop only if
a task's own dependency is genuinely unresolvable (e.g., a task blocked on
another task that was never marked ready).

## Always / Never

- **Always** run the branch check before the first edit of a run, and
  re-verify it immediately before every subsequent commit.
- **Always** run a test and observe it fail before implementing, then run
  it again and observe it pass before marking that task `[x]`, whenever
  `tasks.md` sequenced a test before its implementation.
- **Never** commit while `git branch --show-current` reports the repo's
  trunk — create or return to a feature branch first, every time, with no
  exception for "just this once."
- **Never** mark a task `[x]` without actually having executed what it
  describes — a written-but-unrun test, or a mocked-but-unverified
  implementation, is not done.
- **Never** claim a PR has merged — only report that it was opened and
  requested for auto-merge; the target repo's own CI/branch-protection
  decides the outcome.

## Verifiable success criteria

- Every commit made during a run lands on a feature branch, never on the
  repo's trunk — checkable via `git log <branch> --not main` showing the
  full commit set, and `git log main` showing none of them.
- Every task marked `[x]` in `tasks.md` corresponds to code that actually
  exists and, where a test was specified, a test that was actually run and
  observed passing.
- The PR opened at the end of a story names the exact task IDs it
  completes, traceable back to `tasks.md`.
