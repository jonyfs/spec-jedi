# Research: Mechanize Worktree-Awareness

**Goal**: this is a genuinely new mechanism (Principle II applies in
full — the same 11-tool field `specs/001-specjedi-pipeline/research.md`
already benchmarked, re-checked here specifically for worktree-related
mechanisms rather than re-researched from scratch), plus resolve the
real technical unknowns Phase 0 surfaced once this session actually
inspected the two competitors that touch this domain.

## Principle II: competitive research, worktree-specific

Re-read all 11 rows of `specs/001-specjedi-pipeline/research.md` for
any worktree-related mechanism (`grep -i worktree`). Two hits, not
eleven — the rest (spec-kit, BMAD-METHOD, OpenSpec, Kiro, Tessl,
GSD, PRP, Traycer, codemyspec.com) have no worktree concept at all.

### Spec Kitty — already benchmarked, re-confirmed unchanged

`research.md`'s existing verdict stands: worktree-awareness there is
"a genuinely useful pattern," but Spec Jedi's own prior decision
(feature 001) was to adopt it only as *documented option*, not
mechanized. This feature now closes that gap — Spec Kitty's own
worktree mechanism itself was never independently inspected (smaller/
newer entrant, tracked via `cameronsjo/spec-compare` rather than a
primary source), so no further claim is made about its internals here.

### Superpowers' `using-git-worktrees` skill — inspected directly, not just cited

The original research named this skill in Superpowers' skill list but
never evaluated its actual mechanism — a real gap, closed now since
this session has direct filesystem access to the installed plugin
(`~/.claude/plugins/cache/claude-plugins-official/superpowers/6.1.1/
skills/using-git-worktrees/SKILL.md`, read in full this session). Its
design, in order:

1. **Detect existing isolation first** (`GIT_DIR != GIT_COMMON`, with an
   explicit submodule guard) — never nest a worktree inside a worktree.
2. **Prefer a native harness tool over raw git** — explicitly checks for
   "a tool with a name like `EnterWorktree`, `WorktreeCreate`, a
   `/worktree` command" before ever falling back to `git worktree add`
   directly, reasoning that a native tool "handles directory placement,
   branch creation, and cleanup automatically" while raw git commands
   create "phantom state your harness can't see or manage."
3. **Git fallback, only if no native tool exists**: creates the worktree
   under a project-local `.worktrees/` directory (checking for an
   existing `worktrees/` alternative first), with a **mandatory
   `git check-ignore` verification step** before creating anything —
   adding the directory to `.gitignore` and committing that change if
   it isn't already ignored.
4. **Project setup + baseline test run** inside the new worktree
   (`npm install`/`cargo build`/etc., then a test run) before declaring
   it ready.
5. **Consent-gated, always**: asks the user before creating a worktree
   unless a preference was already declared.
6. **No cross-worktree status aggregation** — this skill sets up one
   isolated workspace per invocation; it has no concept of reporting on
   multiple worktrees at once.

**Genuine contribution, now grounded against a real, inspected
competitor rather than just Spec Kitty's documented-option approach**:
neither Superpowers' skill nor Spec Kitty's own mechanism unifies
status reporting *across* multiple already-created worktrees — each
treats "set up one isolated workspace" as the whole job. This feature's
User Story 3 (a single status report spanning every worktree of the
repository) is the piece no researched tool in this field does.

## Decision: native-tool-first, portable-git-fallback (adopted from Superpowers, not reinvented)

**Decision**: `specjedi-worktree` checks for a native harness worktree
tool first; only falls back to raw `git worktree` commands when none
exists.

**Rationale**: This session's own environment has exactly the kind of
native tool Superpowers' skill anticipates — Claude Code ships
`EnterWorktree`/`ExitWorktree` (tool schemas fetched and inspected this
session, not assumed):

- `EnterWorktree` creates a worktree under `.claude/worktrees/` on a new
  branch (or switches into an already-existing one by `path`) **and
  relocates the running session's own working directory into it** —
  something no plain git command or Markdown-instruction skill can do
  on its own.
- `ExitWorktree` restores the original directory, and — critically for
  FR-005's revised safety requirement — **refuses to remove a worktree
  with uncommitted files or unmerged commits unless `discard_changes:
  true` is explicitly passed**, i.e. the exact "second, explicit
  confirmation naming what would be lost" FR-005 already requires,
  already built in.

This directly overturns two claims the spec made before this research
existed: that the mechanism "cannot relocate the running coding-agent
session" (false on Claude Code, where a native tool does exactly that)
and that removal must "never be automated under any circumstance"
(too absolute — the native tool's own guarded removal path already
satisfies this project's real concern, explicit-confirmation-before-
destroying-work, without needing to ban the capability outright). Both
`spec.md` FRs were revised in place during this planning session with a
note pointing back here, per this project's own established practice
for a spec correction discovered during Phase 0 research (the same
class of update feature 022's session-start research made to a prior
principle's own precedence rule).

**Alternatives considered**:
- *Always use raw `git worktree` commands, ignore any native tool* —
  rejected: throws away real capability (session relocation, guarded
  removal) that's already sitting there, and contradicts Principle
  XIII's own architecture ("harness-specific adapters layered on top,"
  not ignored in favor of the lowest tier unconditionally).
- *Require the native tool, refuse to run without one* — rejected:
  violates Principle III's lowest-common-denominator requirement
  directly; the other 19 harnesses in the compatibility matrix have no
  confirmed equivalent, and this feature must still work there via the
  portable git fallback.

## Decision: `.worktrees/` project-local directory for the git-fallback path

**Decision**: when no native tool is available, the git-fallback path
creates worktrees under `.worktrees/<branch-name>/` at the project
root, verifying (and if needed adding) a `.gitignore` entry before
creating anything — Superpowers' own convention, adopted rather than
reinvented.

**Rationale**: This is a genuinely better-tested choice than this
feature's own original assumption (a sibling directory, `../<repo>-
<slug>/`), which had no real-world precedent behind it beyond "matches
git's own suggested example command." `.worktrees/` keeps every
worktree scoped inside the project (simpler for a developer managing
several at once — `ls .worktrees/` shows all of them, a sibling-
directory layout scatters them across the parent directory next to
unrelated projects), and Superpowers' explicit ignore-verification step
closes the real risk sibling directories don't even have to think about
(accidentally committing worktree contents).

**Alternatives considered**:
- *Sibling directory (original assumption)* — superseded; no
  independent adoption signal found for it versus the project-local
  convention an inspected, real competitor already uses and tests
  (Superpowers ships `test-worktree-path-policy.sh` and
  `test-worktree-native-preference.sh` test files alongside this exact
  skill, confirming the convention is deliberately tested, not
  incidental).

## Decision: `specjedi-status` worktree enumeration via `git worktree list --porcelain`

**Decision**: the worktree-aware extension to the project's status
mechanism (FR-006) runs `git worktree list --porcelain` to enumerate
every worktree path and branch, then reads each worktree's own
`specs/*/` directory tree directly (filesystem access to a sibling
path is already how a single checkout reads its own `specs/`, just
pointed at a different root per worktree) to derive that worktree's
feature status using the exact same on-disk-artifact logic
`specjedi-status` already applies to the current checkout — no new
derivation rule, per Constitution Principle XXI's "no parallel tracking
system" precedent, applied here to "no parallel status-derivation
logic" as well.

**Rationale**: `--porcelain` is git's own stable, script-friendly output
format for exactly this enumeration (unambiguous path per worktree, one
record per line), avoiding fragile parsing of the human-readable
default format.

**Alternatives considered**: shelling out to run `specjedi-status`
itself once per worktree and concatenating output — rejected as
needlessly indirect; reading each worktree's on-disk `specs/` state
directly is the same operation `specjedi-status` already performs for
the current checkout, just repeated per enumerated path.

## Summary of spec.md corrections this research made

Both changes are documented in `spec.md` itself (FR-005, FR-007, the
two corresponding Edge Cases, and the directory-convention Assumption)
with a pointer back to this file — recorded here as well so the
Sync-Impact-style trail is visible from either document:

1. Worktree removal: from "never automated under any circumstance" to
   "only on explicit request, with a mandatory second confirmation
   before discarding uncommitted/unmerged work" — because the native
   tool's own guard already satisfies the real safety concern more
   precisely than an outright ban.
2. Session relocation: from an unconditional "the mechanism cannot do
   this" to "MUST use a native relocation tool when the harness
   provides one, falls back to a manual instruction otherwise" —
   because Claude Code, confirmed this session, actually can.
3. Directory convention: from an untested sibling-directory guess to
   the project-local, gitignore-verified `.worktrees/` convention a
   real, inspected competitor already tests.
