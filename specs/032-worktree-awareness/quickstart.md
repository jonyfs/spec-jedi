# Quickstart: Mechanize Worktree-Awareness

Validation scenarios proving `specjedi-worktree` and its wiring into
`specjedi-status`/`specjedi-specify`/`specjedi-quick` work end-to-end.
Scenarios 1-3 use *real* `git worktree` commands against this actual
checkout, not dry-run reasoning — cleaned up before this feature's PR
opens (Scenario 6).

## Prerequisites

- A checkout of this repository on the feature branch, with
  `.claude/skills/specjedi-worktree/SKILL.md` already written per
  `tasks.md`.
- `git` 2.5+ (worktree support).
- Running inside Claude Code confirms the native-tool tier; running the
  same scenarios with the `EnterWorktree`/`ExitWorktree` tools
  unavailable (e.g., reasoning through the skill's own fallback branch
  by inspection) confirms the portable git-only tier.

## Scenario 1 — On-demand worktree creation (US1)

```bash
git worktree add .worktrees/032-quickstart-test -b 032-quickstart-test
git worktree list --porcelain | grep "032-quickstart-test"
```

**Expected**: a real worktree exists at `.worktrees/032-quickstart-test`
on its own branch — confirms the underlying git mechanics `specjedi-
worktree`'s git-fallback path relies on actually work in this
repository (FR-001).

## Scenario 2 — Path collision is refused, not overwritten (FR-004)

```bash
git worktree add .worktrees/032-quickstart-test -b 032-quickstart-test-2 2>&1 | grep -i "already exists\|already registered"
```

**Expected**: git itself refuses the collision with a real error —
`specjedi-worktree` surfaces this as a clear, honest message rather
than a raw dump (confirmed by inspection of the skill's own error-
handling instructions during implementation, not just by this git
behavior existing).

## Scenario 3 — `.gitignore` verification (research.md's adopted convention)

```bash
git check-ignore -q .worktrees || echo "NOT IGNORED — skill must add + commit before creating"
```

**Expected**: after `specjedi-worktree` ships, this repository's own
`.gitignore` contains a `.worktrees/` entry (added by the skill's first
real run, or pre-added during implementation) — confirms the mandatory
ignore-verification step from `research.md` is actually wired in, not
just described.

## Scenario 4 — Guarded removal refuses to discard work (FR-005)

```bash
cd .worktrees/032-quickstart-test && touch uncommitted-test-file.txt && cd -
git worktree remove .worktrees/032-quickstart-test 2>&1 | grep -i "contains modified or untracked files"
```

**Expected**: git itself refuses to remove a dirty worktree without
`--force` — confirms `specjedi-worktree`'s own FR-005 guard (never
discard without a second, explicit confirmation) has real git behavior
to rely on, not just a documented promise.

## Scenario 5 — `specjedi-status` reports across worktrees (US3, FR-006)

Manual read-through: with the test worktree from Scenario 1 still
present (containing no `specs/` content of its own — a fresh branch),
confirm `specjedi-status`'s revised instructions correctly enumerate it
via `git worktree list --porcelain` and report "no feature artifacts"
for it rather than silently omitting it from the report (the same
"objective status, never silently invisible" discipline `specjedi-
status` already applies to the current checkout, per feature 005's
original design).

## Scenario 6 — Cleanup before this feature's own PR opens

```bash
rm -f .worktrees/032-quickstart-test/uncommitted-test-file.txt
git worktree remove .worktrees/032-quickstart-test --force
git branch -D 032-quickstart-test
git worktree prune
```

**Expected**: this repository returns to its pre-quickstart state — no
leftover test worktree or branch ships in the feature's own PR.

## Scenario 7 — Structural validation

```bash
./scripts/validate.sh
```

**Expected**: `PASSED` — confirms the new `specjedi-worktree/SKILL.md`
passes the same frontmatter/layout lint every other skill does, and no
regression was introduced in `specjedi-status`/`specjedi-specify`/
`specjedi-quick`'s own structural validity.
