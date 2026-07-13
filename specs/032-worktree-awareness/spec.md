# Feature Specification: Mechanize Worktree-Awareness

**Feature Branch**: `032-worktree-awareness`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description: "Mechanize worktree-awareness: today,
git-worktree-based parallel development of independent Spec Jedi
features is only documented advice (references/competitive-
comparison.md's Spec Kitty row, references/honest-assessment.md's
Improvement Points) -- no specjedi-* skill or installer flag actually
detects, creates, or manages a worktree for a feature branch. Close
this gap with a real, tested mechanism, closing the corresponding
Disadvantage/Improvement Point in references/honest-assessment.md once
shipped."

## Clarifications

### Session 2026-07-13

- Q: FR-002's proactive worktree offer fires for "a non-trunk branch
  with uncommitted or unmerged work" — does that mean it fires whenever
  the current branch simply hasn't merged yet (even with a clean
  working tree), or only when there are actual uncommitted changes
  present? → A: Only when the working tree has actual uncommitted
  changes on a non-trunk branch — a clean, already-pushed feature
  branch never triggers an offer.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Get a worktree for a new feature on demand (Priority: P1)

A developer wants to start a new, independent feature without
disturbing their current checkout (which already has another feature's
uncommitted work in it) and asks for a worktree directly.

**Why this priority**: The entire point named in `honest-assessment.md`
and `competitive-comparison.md` — a real, working mechanism instead of
"you could set one up yourself" prose.

**Independent Test**: Invoke the mechanism for a named new feature;
confirm a real `git worktree` exists at a distinct filesystem path,
checked out on a new branch, ready to work in — verifiable with
`git worktree list`.

**Acceptance Scenarios**:

1. **Given** a clean or dirty current checkout, **When** a developer
   asks for a worktree for a new feature, **Then** a new worktree is
   created at a distinct sibling path with its own new feature branch
   checked out, and the current checkout is left completely untouched.
2. **Given** the target worktree path already exists, **When** creation
   is attempted, **Then** it fails with a clear, actionable message
   naming the collision — never silently overwrites or picks a
   different path without saying so.
3. **Given** the running git doesn't support worktrees (unsupported/very
   old version), **When** creation is attempted, **Then** the failure is
   a clear, honest explanation — never a raw git error dumped to the
   user.

---

### User Story 2 - Get offered a worktree before a collision happens (Priority: P2)

A developer starts specifying a new feature while their current
checkout already has actual uncommitted changes on another feature's
branch, and gets offered a worktree proactively instead of finding out
the hard way that switching branches would disturb that work. A clean,
already-committed-and-pushed feature branch never triggers this offer
(Clarifications, Session 2026-07-13) — only real, undisturbed-work risk
does.

**Why this priority**: Prevention is more valuable than a tool the
developer has to remember exists — the same proactive-detection
discipline Principle XVII already establishes for other gap-filling
skills in this project.

**Independent Test**: With uncommitted changes present on a non-trunk
branch, start a new feature via the normal feature-creation flow;
confirm a worktree offer appears before any branch switch happens, and
confirm declining it falls back to today's existing behavior unchanged.

**Acceptance Scenarios**:

1. **Given** the current checkout has actual uncommitted changes on a
   non-trunk branch, **When** a developer starts a new, unrelated
   feature, **Then** a worktree is offered before any branch switch
   occurs, with the reason stated plainly.
2. **Given** the current checkout is clean and on the trunk branch,
   **When** a developer starts a new feature, **Then** no worktree offer
   appears — today's existing single-checkout flow proceeds unchanged.
3. **Given** the current checkout is on a non-trunk branch but has no
   uncommitted changes (e.g., already committed and pushed), **When** a
   developer starts a new feature, **Then** no worktree offer appears
   either — a clean branch carries no real collision risk.
4. **Given** a worktree offer, **When** the developer declines it,
   **Then** the existing, unmodified feature-creation flow proceeds
   exactly as it does today — declining never blocks or degrades the
   normal path.

---

### User Story 3 - See every parallel feature's status in one place (Priority: P2)

A developer with several features in flight across several worktrees
wants one unified status view, not one status check per worktree.

**Why this priority**: Equal priority to US2 — parallelism without
visibility just recreates the "which feature was I on again" problem
one worktree at a time; this closes the loop the same way feature 028
closed `specjedi-status`'s own compatibility gap for its lightweight
path.

**Independent Test**: With features in progress across 2+ worktrees of
the same repository, run the project status check from any one of them;
confirm every worktree's feature status appears in the single report,
not just the current one's.

**Acceptance Scenarios**:

1. **Given** 3 worktrees of the same repository, each with a different
   feature in progress, **When** the status check runs from any one of
   them, **Then** all 3 features' statuses appear in one report, each
   correctly attributed to its own worktree.
2. **Given** no other worktrees exist (the common, single-checkout
   case), **When** the status check runs, **Then** its output is
   unchanged from today — no new noise for the common case.

### Edge Cases

- What happens once a worktree's feature branch merges — does the
  mechanism delete the worktree automatically? → Never on its own. Only
  on an explicit user request, and even then it refuses to discard
  uncommitted or unmerged work without a second, explicit confirmation
  — consistent with this project's standing policy against autonomous
  destructive git operations (FR-005).
- Can the mechanism itself move the running coding-agent session into
  the new worktree's directory? → Depends on the harness. Where a
  native relocation tool exists (confirmed for Claude Code during
  planning), the mechanism MUST use it so the session lands there for
  real. On a harness with no such tool, its output MUST instead tell
  the developer the exact path and next action — never implying a
  switch happened that didn't (FR-007).
- What if the repository has no remote configured? → Not a
  precondition — `git worktree` is a local operation; a remote is only
  needed later, at the same point it's already needed for opening a PR.
- What if a target project (not this repo) doesn't want worktree
  offers at all? → Out of scope for this feature; a global opt-out
  toggle is not requested and not assumed — the offer itself is always
  declinable per-instance (User Story 2, Acceptance Scenario 3).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The mechanism MUST create a new git worktree for a named
  feature via `git worktree add`, checking out a new feature branch,
  when explicitly invoked on demand.
- **FR-002**: The mechanism MUST be proactively offered when starting a
  new feature while the current checkout has actual uncommitted changes
  on a non-trunk branch — a clean, already-committed-and-pushed feature
  branch MUST NOT trigger an offer (Clarifications, Session 2026-07-13).
  This is always an offer, never a forced action; declining MUST leave
  today's existing feature-creation flow completely unchanged.
- **FR-003**: The mechanism MUST verify git's worktree support before
  attempting creation and decline with a clear, honest message — never a
  raw git error — if unsupported.
- **FR-004**: The mechanism MUST detect and refuse a target path
  collision rather than silently overwriting an existing directory or
  silently picking a different one.
- **FR-005**: The mechanism MUST perform worktree cleanup only on
  explicit user request — never proactively, never as a side effect of
  another action — and MUST refuse to discard uncommitted or unmerged
  work without a second, explicit confirmation naming exactly what
  would be lost, consistent with this project's standing policy against
  autonomous destructive git operations (revised during planning —
  research.md — after finding the harness-native removal path already
  builds in this exact guard).
- **FR-006**: The project's existing status-reporting mechanism MUST
  become worktree-aware: it MUST enumerate all worktrees of the current
  repository and report each one's feature status in a single, unified
  view — not just the current checkout's own.
- **FR-007**: The mechanism's output MUST state the exact path and next
  action needed to start working in the new worktree. Where the current
  harness provides a native tool able to relocate the running
  coding-agent session into that directory itself (e.g., Claude Code's
  worktree tooling), the mechanism MUST use it so the session lands
  there directly; on a harness with no such tool, the mechanism MUST
  instead give the user the exact manual command to switch there
  themselves (revised during planning — research.md — after confirming
  this native capability exists on at least one supported harness).

### Key Entities

*(Not applicable — this feature manages filesystem/git state, not a
data model with persisted entities.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer goes from "I need a worktree for this
  feature" to a ready, checked-out worktree in one invocation — no
  manual multi-step `git worktree` incantation required.
- **SC-002**: The project's status report, run from any single worktree,
  shows every in-progress feature across every worktree of the same
  repository — a developer never has to check more than one place.
- **SC-003**: Zero raw git errors are ever shown to the user for a
  worktree operation — every failure path (unsupported git, path
  collision) produces a clear, actionable message instead.
- **SC-004**: The common, single-checkout case (no other worktrees)
  produces byte-for-byte unchanged status-report output — the new
  capability adds zero noise when it isn't relevant.

## Assumptions

- This ships as a new, dedicated `specjedi-*` skill (per Principle XV's
  naming convention), not a `--worktree` flag bolted onto existing
  skills — matching this project's established pattern of giving a
  mechanized capability its own product surface rather than overloading
  an already-shipped skill's scope (the same shape of decision
  `specjedi-tokencheck`/`specjedi-govcheck`/`specjedi-release` already
  represent).
- No new `scripts/*.sh`/`.ps1` wrapper script is needed — the mechanism
  issues `git worktree` commands directly, the same way `specjedi-
  implement` already handles git branch/commit/PR operations without a
  dedicated wrapper script.
- Where a native harness worktree tool is available, that tool owns its
  own directory convention entirely (the mechanism never dictates a
  path in that case). Where the mechanism falls back to raw `git
  worktree` commands, it uses a project-local, `.gitignore`-verified
  directory rather than a sibling directory outside the repository —
  revised during planning (research.md) after finding this is the
  better-tested convention among the tools inspected for this feature.
- The proactive-offer detection in FR-002 reuses git's own working-tree
  dirty-state check (`git status`) combined with the current branch not
  being trunk — no second, parallel tracking system, matching Constitution
  Principle XXI's established "reuse `specjedi-status`'s own logic"
  precedent.
- Cross-platform parity (Constitution Principle XIII) is satisfied
  because `git worktree` itself is a single cross-platform git
  subcommand — no separate bash/PowerShell code paths are needed for
  the underlying operation, only for any surrounding script logic if a
  wrapper script turns out to be needed during planning.
