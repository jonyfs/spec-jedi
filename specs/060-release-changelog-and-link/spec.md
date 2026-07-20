# Feature Specification: specjedi-release Drafts the Changelog and Shows a Manual-Trigger Link

**Feature Branch**: `060-release-changelog-and-link`

**Created**: 2026-07-20

**Status**: Draft

**Input**: User description: "quando executar /specjedi-release deve gerar o change log e mostrar link para fazer manualmente o release no github."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - specjedi-release drafts a missing CHANGELOG.md Unreleased entry (Priority: P1)

A user runs `/specjedi-release` and `CHANGELOG.md`'s `## Unreleased`
section is empty — exactly the state that just caused two consecutive
`release.yml` `workflow_dispatch` runs to fail with `FAIL: CHANGELOG.md's
## Unreleased section is empty -- nothing to release`. Today,
`specjedi-release` only runs `scripts/suggest-release.sh` and narrates a
version suggestion; it never looks at `CHANGELOG.md` at all, so this
failure mode isn't caught until the actual GitHub Actions run fails.
This story makes `specjedi-release` check `CHANGELOG.md` and, when
`## Unreleased` is empty, draft the missing entries — grounded in the
actual commits since the last tag (the same commit list
`suggest-release.sh` already prints), following this project's own
established `CHANGELOG.md` entry style (bold feature name, PR/feature
number, one-paragraph grounded description) — and present the full draft
for the user's explicit confirmation before writing anything, mirroring
`specjedi-docs`'s own already-established confirm-before-write
`CHANGELOG.md` convention.

**Why this priority**: This is the actual gap that caused today's real
failure. Without this story, the release workflow keeps failing at the
same point every time a shipped feature never went through
`specjedi-docs` (or `specjedi-docs` was skipped) before `specjedi-release`
runs.

**Independent Test**: Given `CHANGELOG.md`'s `## Unreleased` section is
empty and there are commits since the last tag, when `/specjedi-release`
runs, then it presents a drafted `CHANGELOG.md` entry (grounded in the
actual commit list) for confirmation — and `CHANGELOG.md` is not modified
on disk until the user explicitly confirms.

**Acceptance Scenarios**:

1. **Given** `## Unreleased` is empty and 2 feature commits exist since
   the last tag, **When** `/specjedi-release` runs, **Then** it drafts
   one `CHANGELOG.md` entry per feature, grounded in each commit's actual
   message/PR reference, and presents the full draft before writing
   anything.
2. **Given** the user confirms the draft, **When** confirmation is given,
   **Then** `CHANGELOG.md`'s `## Unreleased` section is written with the
   drafted content, in place, using the file's own existing heading/style
   conventions.
3. **Given** the user declines or asks for changes, **When** that
   happens, **Then** `CHANGELOG.md` is not written — the skill either
   revises the draft on request or ends without writing, matching
   `specjedi-docs`'s own existing "always confirmed before writing"
   behavior.
4. **Given** `## Unreleased` already has real content (not empty), **When**
   `/specjedi-release` runs, **Then** no draft step triggers at all — the
   existing content is used as-is, unchanged.

---

### User Story 2 - specjedi-release shows the exact manual-trigger link (Priority: P1)

Once `CHANGELOG.md`'s `## Unreleased` section is confirmed populated
(whether it already was, or was just drafted and written per Story 1),
`specjedi-release` shows the user the exact GitHub link to manually
trigger `release.yml`'s `workflow_dispatch` — removing the need to
navigate GitHub's UI to find it, or remember the exact `gh` CLI
invocation, every time a release is due.

**Why this priority**: Equal priority to Story 1 — the user's request
named both the changelog generation and the link explicitly, and the
link has no value without a populated changelog to actually release
against (Story 1 is a hard prerequisite in practice, though each has its
own independent test).

**Independent Test**: Given `CHANGELOG.md`'s `## Unreleased` section has
real content (via either path), when `/specjedi-release` reaches its
final report, then it shows both the browser URL to `release.yml`'s
Actions page and the equivalent `gh workflow run` command with the
suggested version already filled in.

**Acceptance Scenarios**:

1. **Given** a populated `## Unreleased` section, **When**
   `/specjedi-release` finishes, **Then** it prints the exact URL
   `https://github.com/<owner>/<repo>/actions/workflows/release.yml`
   (derived from the actual `git remote get-url origin`, never a
   hardcoded example) as the browser path to trigger the release
   manually.
2. **Given** the same state, **When** `/specjedi-release` finishes,
   **Then** it also prints the equivalent terminal command (`gh workflow
   run release.yml -f version=<suggested-version> -f dry_run=true`) as an
   alternative manual path — with `dry_run=true` as the printed default,
   since a `dry_run=false` run is the user's own explicit choice to
   change.
3. **Given** GitHub's `workflow_dispatch` UI has no supported mechanism
   to pre-fill input fields via URL query parameters, **When** the link
   is shown, **Then** the skill states this plainly rather than
   constructing a URL that implies the version/dry_run values will be
   pre-filled when they will not be.

---

### User Story 3 - The suggest-only boundary stays intact (Priority: P2)

Neither drafting the changelog nor showing the manual-trigger link
crosses `specjedi-release`'s existing hard boundary: it still never runs
`git tag`, never triggers `release.yml` itself, and never writes
`CHANGELOG.md` without the user's explicit confirmation. This story
exists to prevent the two new capabilities (Stories 1-2) from being
implemented in a way that quietly expands the skill's autonomy past what
Constitution Principle XI already establishes.

**Why this priority**: Lower priority because it's a boundary
confirmation, not new user-facing value — but it's what keeps Stories 1-2
trustworthy rather than a scope-creeping first step toward the skill
eventually cutting releases on its own.

**Independent Test**: Given `/specjedi-release` runs end-to-end
(including a Story 1 draft-and-confirm cycle and a Story 2 link
display), when the run finishes, then `git tag -l` and the GitHub Actions
run list both show zero new activity caused by the skill itself — only
`CHANGELOG.md` (if confirmed) was written, and only locally, not
committed or pushed by the skill.

**Acceptance Scenarios**:

1. **Given** the user confirms a Story 1 changelog draft, **When**
   `CHANGELOG.md` is written, **Then** the skill does not also commit,
   push, or open a PR for that change — matching `specjedi-docs`'s own
   existing behavior of writing the file only, leaving commit/PR to the
   user or whatever workflow already handles landing changes (Constitution
   Principle X — every change lands via a PR the user or another skill
   opens, never this skill silently committing).
2. **Given** Story 2's link/command is shown, **When** the run finishes,
   **Then** the skill has not called `gh workflow run` or any equivalent
   API itself — only printed the command/link for the user to run.

---

### Edge Cases

- What happens when there are zero commits since the last tag (nothing to
  release at all)? `scripts/suggest-release.sh`'s own existing "review
  manually" output already covers this — Story 1's draft step doesn't
  trigger when there's nothing to draft from, matching the script's
  existing behavior rather than fabricating an empty or placeholder
  entry.
- What happens when `CHANGELOG.md` doesn't exist at all yet? Same
  precedent `specjedi-docs` already establishes for this exact case
  (`.claude/skills/specjedi-docs/SKILL.md`: "creates the file if
  missing") — Story 1 creates it with the same header/structure
  `specjedi-docs` already uses, not a new, second format.
- What happens when some commits since the last tag correspond to a
  shipped feature that already has a `specs/NNN-*/spec.md`/`plan.md` (so
  `specjedi-docs` could ground a proper draft from it), while others
  don't (an ad hoc change with no formal spec/plan, e.g. this session's
  own `specjedi-caveman-mode` PR)? The draft step MUST handle both:
  self-invoking `specjedi-docs`'s own drafting logic where a spec/plan
  exists to ground it, and falling back to a direct, commit-message-
  grounded draft (never fabricating detail beyond what the commit message
  and diff actually show) when no spec/plan exists — see FR-003.
- What happens if the user asks `/specjedi-release` to actually trigger
  the workflow after seeing the link (e.g., "run it for me")? Existing
  behavior governs this unchanged — `specjedi-release`'s own "decline
  explicitly, name the exact manual command" rule already applies, and
  Story 2's printed command *is* that exact manual command, now already
  provided up front rather than only on request.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-release` MUST check `CHANGELOG.md`'s `##
  Unreleased` section (the same section `release.yml`'s "Extract
  Unreleased changelog section as release notes" step reads) for
  non-empty content, after running `scripts/suggest-release.sh` as it
  does today.
- **FR-002**: When `## Unreleased` is empty (or `CHANGELOG.md` doesn't
  exist) and `scripts/suggest-release.sh` found commits since the last
  tag, `specjedi-release` MUST draft the missing entries and present the
  full draft for explicit user confirmation before writing anything to
  `CHANGELOG.md` — matching `specjedi-docs`'s own established
  confirm-before-write behavior for this exact file.
- **FR-003**: The draft (FR-002) MUST be grounded per-commit: for a
  commit whose message references a `specs/NNN-*` feature directory with
  its own `spec.md`/`plan.md`, `specjedi-release` MUST self-invoke
  `specjedi-docs`'s own drafting step to ground that entry; for a commit
  with no such feature directory (an ad hoc change), the entry MUST be
  drafted directly from that commit's own message and diff — never
  fabricated detail beyond what either source actually contains.
- **FR-004**: When `## Unreleased` already has non-empty content,
  `specjedi-release` MUST NOT draft or prompt for a new entry — the
  existing content is used as-is (FR-001's check is a gate, not a
  forced overwrite).
- **FR-005**: Once `## Unreleased` is confirmed non-empty (whether
  pre-existing or freshly drafted-and-written per FR-002), `specjedi-
  release` MUST print the exact GitHub Actions URL to trigger
  `release.yml`'s `workflow_dispatch` manually, derived from the actual
  `git remote get-url origin` (owner/repo), never a hardcoded or example
  placeholder.
- **FR-006**: `specjedi-release` MUST also print the equivalent `gh
  workflow run release.yml -f version=<suggested-version> -f
  dry_run=true` command as an alternative manual-trigger path, using the
  actual version `scripts/suggest-release.sh` suggested.
- **FR-007**: `specjedi-release` MUST state plainly that GitHub's
  `workflow_dispatch` UI does not support pre-filling input fields via
  URL query parameters — the printed link is a path to the trigger page,
  not a pre-filled form, so the user isn't misled into expecting the
  version field to already be populated when they click through.
- **FR-008**: `specjedi-release` MUST NOT commit, push, or open a PR for
  a `CHANGELOG.md` draft it writes (FR-002) — writing the file is as far
  as this skill's autonomy for that action extends; landing the change
  is a separate, existing step (a manual commit, or another skill/
  workflow) outside this feature's scope.
- **FR-009**: `specjedi-release` MUST NOT call `gh workflow run` or any
  equivalent GitHub API to actually trigger `release.yml` itself, under
  any phrasing of the request — this feature only ever shows the command/
  link (FR-005, FR-006); Constitution Principle XI's existing
  never-cut-or-publish boundary is unchanged by this feature.

### Key Entities

- **`CHANGELOG.md` `## Unreleased` section**: the block of text
  `release.yml` extracts as release notes; this feature's central
  object — either already populated, or drafted-and-confirmed by this
  feature before the manual-trigger link is shown.
- **Manual-trigger link/command**: the GitHub Actions URL and equivalent
  `gh workflow run` invocation this feature prints; never executed by
  this skill itself, only displayed.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Running `/specjedi-release` against a repository state
  identical to today's real failure (empty `## Unreleased`, commits
  present since last tag) results in a presented draft, in 100% of such
  runs, before the skill's final report — not a silent pass-through to
  "here's the version suggestion" the way it behaves today.
- **SC-002**: `CHANGELOG.md` is written by `specjedi-release` in 0 runs
  where the user did not explicitly confirm the draft.
- **SC-003**: The printed manual-trigger URL matches the actual
  repository's `owner/repo` (derived from `git remote get-url origin`)
  in 100% of runs — 0 hardcoded/example URLs shown.
- **SC-004**: `git tag -l` and the GitHub Actions run list show 0 entries
  caused by `specjedi-release` itself across any number of runs,
  including runs where the user explicitly asks it to trigger the
  release.

## Assumptions

- `specjedi-docs`'s own existing drafting logic (README row, Quickstart
  step, `CHANGELOG.md` entry, all confirmed before writing) is reused,
  not reimplemented — FR-003's self-invocation for spec/plan-grounded
  commits calls into that skill's own existing behavior rather than a
  second, parallel implementation of the same drafting logic.
- The manual-trigger link (FR-005/FR-006) targets `release.yml`
  specifically, matching this repository's own confirmed workflow file
  at `.github/workflows/release.yml` — not a generic "your Actions tab"
  link.
- This feature does not change `release.yml` itself in any way — the
  workflow's own existing CHANGELOG-extraction and PR-based landing
  behavior (confirmed by direct read of `.github/workflows/release.yml`
  this session) is unaffected; this feature only prevents the empty-
  section failure from reaching that workflow in the first place.
- No new CLI flag or opt-out is in scope — if a future need to skip the
  draft step arises (e.g., "release without touching CHANGELOG.md"),
  that would be a separate feature.
