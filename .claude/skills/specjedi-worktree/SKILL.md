---
name: specjedi-worktree
description: Mechanizes git-worktree-based parallel development — creates a real worktree for a named feature on demand, preferring a native harness relocation tool (e.g. Claude Code's EnterWorktree/ExitWorktree) and falling back to a project-local, .gitignore-verified .worktrees/ directory via raw git worktree commands otherwise. Also provides the reusable proactive-offer detection step specjedi-specify and specjedi-quick self-invoke when starting a new feature atop real uncommitted work on a non-trunk branch. Triggers on an explicit request for a worktree, or via that proactive offer.
compatibility: No external dependencies beyond `git` (worktree support, standard since Git 2.5). Uses the host harness's native worktree tool when present (confirmed for Claude Code — EnterWorktree/ExitWorktree); falls back to `git worktree add`/`list`/`remove` otherwise. Writes `.worktrees/` plus a `.gitignore` entry only on the git-fallback path, and only after explicit invocation or an accepted proactive offer.
---

# 🌳 Spec Jedi Worktree

**Persona**: a careful workspace steward — hands you a second bench to
work at without ever touching what's already on the first one, and never
tears a bench down without asking twice.

**Task**: create a real, working git worktree for a named feature — on
demand or via a proactive offer — preferring a native harness relocation
tool when one exists and falling back to a project-local, portable `git
worktree` path otherwise; also perform guarded, explicit-request-only
removal.

## Step-by-step

1. **Determine the invocation shape**: an explicit, direct request for a
   worktree (User Story 1), or a proactive-offer check self-invoked by
   `specjedi-specify`/`specjedi-quick` before starting a new feature (User
   Story 2). Both share steps 3-6 below; only the offer/decline framing in
   step 2 differs.

2. **Proactive-offer detection** (self-invoked entry point, reused
   verbatim by `specjedi-specify` and `specjedi-quick`): run `git status
   --porcelain` and `git branch --show-current`. Offer a worktree — never
   force one — only when **both** are true: the working tree has actual
   uncommitted changes (`git status --porcelain` is non-empty) **and**
   the current branch is not the repo's trunk (FR-002 — a clean,
   already-pushed feature branch is explicitly excluded).
   State the reason plainly ("this checkout has uncommitted work on
   `<branch>` — want a separate worktree for the new feature instead?").
   Declining leaves the caller's existing flow completely unchanged — no
   degraded fallback, no second ask.

3. **Verify worktree support before attempting anything** (FR-003): confirm
   `git worktree` itself is available and functional in this environment.
   If it isn't (a very old git), decline with a clear, honest message
   naming the missing capability — never surface a raw git error.

4. **Native-tool-first creation** (FR-001, FR-007, research.md's decision):
   check whether the current harness exposes an `EnterWorktree`-shaped
   tool (confirmed this session for Claude Code). If present:
   - Sanitize the feature name to a valid `name` value (letters, digits,
     dots, underscores, dashes only, ≤64 chars) before calling it.
   - Call it with that `name`. This skill's own invocation — an explicit
     user request, or an explicit accept of the step-2 offer — is exactly
     the "explicitly instructed to work in a worktree" precondition the
     tool itself requires; never call it speculatively or without one of
     those two triggers.
   - The tool creates the worktree under `.claude/worktrees/` on a new
     branch **and relocates the running session's own working directory
     into it** — report the path it returns and confirm the session has
     already moved, never a manual next step in this branch of the flow.

5. **Portable git-fallback creation** (only when no native tool exists;
   FR-001, research.md's `.worktrees/` convention, adopted from
   Superpowers' `using-git-worktrees` skill):
   - Verify `.worktrees/` is `.gitignore`d (`git check-ignore .worktrees/`
     or equivalent). If not, add the entry and commit that change first —
     never create worktree content that could accidentally get committed.
   - Run `git worktree add .worktrees/<branch> -b <branch>`.
   - Report the exact path and the exact manual command to switch there
     (e.g. `cd .worktrees/<branch>`) — never imply the session has moved
     when it hasn't (FR-007).

6. **Path-collision guard** (FR-004): before either creation path
   above actually runs, check whether the target path already exists.
   If it does, refuse with a clear, actionable message naming the
   collision — never silently overwrite it or silently pick a different
   path instead.

7. **Guarded removal, explicit request only** (FR-005 — never proactive,
   never a side effect of another action):
   - If the target worktree was created via `EnterWorktree` in *this*
     session: use `ExitWorktree`. First attempt `action: "remove"` without
     `discard_changes`. If it refuses and lists uncommitted files or
     unmerged commits, surface that exact list to the user and require a
     second, explicit confirmation naming what would be lost before
     retrying with `discard_changes: true`. `ExitWorktree` is scoped to
     worktrees it created in the current session — it will not touch a
     worktree from a prior session, one created by the git-fallback path,
     or one created manually (verified from its own tool description).
   - For every other worktree (older session, git-fallback-created, or
     manual): check that worktree's own uncommitted/unmerged state
     directly (`git -C <path> status --porcelain`, `git -C <path> log
     <branch> --not <trunk>`). If either is non-empty, list it and require
     the same second, explicit confirmation before running `git worktree
     remove --force`; if both are empty, a plain `git worktree remove`
     suffices.

8. **Report, then offer the next step(s) as a short bulleted list**
   (Principle XIV; see `references/next-step-interaction.md`):
   typically `specjedi-specify`/`specjedi-quick` to start
   the new feature inside the freshly created worktree, or
   `specjedi-status` (now worktree-aware) to see it alongside every other
   in-progress feature.

If a target project's harness exposes a worktree-relocation tool this
skill doesn't yet recognize, self-invoke `specjedi-find-skills` rather
than guessing at its interface (Principle XVII).

## Autonomous vs. confirm-first

Creating a worktree on an **explicit, direct request** (User Story 1) is
autonomous — no separate "may I?" once the request itself is the
confirmation. The **proactive offer** (User Story 2) is never autonomous
past the offer itself: it always stops and waits for an explicit accept
or decline, never assumes either from silence or from unrelated activity.
**Removal is never autonomous, unconditionally**: it requires an explicit
request naming the worktree, and — whenever uncommitted or unmerged work
would be lost — a second, explicit confirmation naming exactly what that
loss would be, regardless of which removal path (native tool or manual
git) handles it.

## Format

No new document format — the "output" is a real `git worktree` (verifiable
via `git worktree list`) plus a short status report:

```markdown
## Worktree ready

- Path: `.claude/worktrees/<name>` (or `.worktrees/<branch>`)
- Branch: `<branch>`
- Session relocated: yes (native tool) / no — run `cd <path>` to switch

**Next step:**
- Run `specjedi-specify` (or `specjedi-quick`) here to start the feature.
```

**Audience calibration boundary**: the path/branch facts stay literal and
precise (Principle V/XII exemption); calibration applies only to the
skill's own narration around them.

## Example (input → output)

**Input**: explicit request — "give me a worktree for a new
rate-limiting feature," run in an environment where `EnterWorktree` is
available.

**Agent does**:
1. Confirms `git worktree` support (step 3 — present).
2. Sanitizes the name to `rate-limiting`.
3. Checks for a native tool → found → calls `EnterWorktree` with
   `name: "rate-limiting"`.
4. Reports the returned path; the session is already relocated there.

**Agent writes**:
```markdown
## Worktree ready

- Path: `.claude/worktrees/rate-limiting`
- Branch: `rate-limiting`
- Session relocated: yes — you're already working here.

**Next step:**
- Run `specjedi-specify` here to start the feature.
```

**Edge-case input**: same request, but no native tool exists (a harness
outside Claude Code) and `.worktrees/` isn't yet `.gitignore`d.

**Agent does**:
1. Confirms `.worktrees/` isn't ignored → adds the entry, commits it.
2. Runs `git worktree add .worktrees/rate-limiting -b rate-limiting`.
3. Reports the path and the manual `cd` command — never claims relocation
   that didn't happen.

**Not this**: calling a native relocation tool speculatively without an
explicit request or accepted offer, or removing a worktree with unmerged
commits because "the feature branch name suggested it was done."

## `--auto` mode

Proceed through support-verification, native-tool detection, collision
checking, and creation without stopping for confirmation on an
**explicit** creation request — `--auto` only removes the pause before
reporting the result. It never turns a proactive offer into a forced
action, and it never removes the second, explicit confirmation gate
before discarding uncommitted or unmerged work during removal — those two
gates are Always/Never guardrails, not human-in-the-loop conveniences
`--auto` is permitted to skip.

## Always / Never

- **Always** verify worktree support before attempting creation, and
  report an unsupported environment with a clear, honest message —
  never a raw git error.
- **Always** check for a target-path collision before creating anything,
  and refuse cleanly rather than overwrite or silently redirect.
- **Always** prefer a native harness relocation tool over raw `git
  worktree` commands when one exists, and only invoke it on an explicit
  request or accepted offer — never speculatively.
- **Always** require a second, explicit confirmation naming what would be
  lost before removing a worktree with uncommitted or unmerged work,
  regardless of which removal mechanism applies.
- **Never** create a worktree proactively — only on an explicit request or
  an explicitly accepted offer.
- **Never** remove a worktree as a side effect of another action, or
  without an explicit request naming it.
- **Never** claim the running session relocated when the git-fallback
  path was used — state the manual command instead.

## Verifiable success criteria

- A run against an explicit creation request produces a real worktree
  checkable via `git worktree list` — a distinct path, a new branch, the
  original checkout completely untouched.
- A run against a target path that already exists refuses cleanly and
  names the collision — checkable by confirming no directory was
  overwritten and no silent alternate path was chosen.
- A removal request against a worktree with uncommitted or unmerged work
  is refused until a second, explicit confirmation is given — checkable
  via the worktree still existing on disk after the first refusal.
- The proactive offer never fires against a clean working tree or the
  trunk branch — checkable by confirming zero offer text appears in those
  two conditions.
