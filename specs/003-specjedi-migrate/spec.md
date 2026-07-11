# Feature Specification: `specjedi-migrate`

**Feature Branch**: `003-specjedi-migrate`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Build specjedi-migrate, the next item in
references/skill-roadmap.md's proposed-but-not-yet-built backlog: converts
an existing spec-kit project's tooling references to specjedi-* equivalents,
lowering switching cost for spec-kit's existing user base."

## Clarifications

### Session 2026-07-11

Run autonomously per the maintainer's standing instruction to proceed
through roadmap work and resolve what can reasonably be judged, deferring
only genuine blockers. Each answer applies research.md's scoping analysis
rather than guessing fresh.

- Q: Does `specjedi-migrate` need to convert `constitution.md`/`spec.md`
  file *format*? → A: No — research.md establishes the underlying template
  shape is already shared between `speckit-*` and `specjedi-*` output
  (FR-009 from feature 001). The skill's actual job is narrower: rewriting
  literal `speckit-*` tooling references in prose to their `specjedi-*`
  equivalents, never touching principle/requirement content.
- Q: Should `specjedi-migrate` also install the `specjedi-*` skills into
  the target project? → A: No — that's `scripts/install.sh`/`.ps1`'s job
  (shipped, TODO(INSTALLER)). `specjedi-migrate` assumes the skills are
  already installed (or tells the user to run the installer first if a
  quick check shows they aren't) and focuses on reference migration, to
  keep each tool doing one job.
- Q: What counts as a "speckit-* tooling reference" worth rewriting? → A:
  A literal mention of a `/speckit-<name>` command in prose (e.g., a
  constitution's Development Workflow section, a spec's own notes) — not
  every occurrence of the substring "speckit" (e.g., a deliberate,
  attributed comparison like "this project used to use speckit-plan" in a
  changelog entry should not be silently rewritten into false history).
- Q: Should the skill run automatically, or only on explicit request? →
  A: Explicit request only — unlike the core pipeline skills that chain
  naturally (spec → clarify → plan...), migration is a one-time, consent-
  needed operation on a project a team already has real history in; it
  MUST NOT trigger proactively the way `specjedi-find-skills`'s gap-check
  does.
- Q: How should the skill handle a reference to a `speckit-*` command with
  no shipped `specjedi-*` equivalent yet (e.g., `/speckit-taskstoissues`,
  which has no `specjedi-*` counterpart in this project)? → A: Leave it
  unchanged and flag it explicitly in the migration report — never
  silently drop the reference or guess at an equivalent that doesn't
  exist.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Migrate a spec-kit project's tooling references (Priority: P1)

A team with an existing spec-kit project — a `constitution.md` whose
Development Workflow section names `/speckit-specify`, `/speckit-clarify`,
`/speckit-plan` as the mandated pipeline — has installed `specjedi-*`
skills (via the installer) and now wants their own constitution and specs
to reference the tool they're actually using going forward. Running
`specjedi-migrate` rewrites every literal `speckit-*` command reference it
finds to the corresponding `specjedi-*` skill name, leaves everything else
in the file completely untouched, and reports exactly what changed.

**Why this priority**: The entire reason this skill exists — without it,
"lower switching cost" is just a claim, not a working mechanism.

**Independent Test**: Given a `constitution.md` containing several literal
`/speckit-*` command mentions in prose, run `specjedi-migrate` and verify
every mention with a shipped `specjedi-*` equivalent is rewritten, no
principle or requirement text changed, and a migration report lists every
change made.

**Acceptance Scenarios**:

1. **Given** a constitution's Development Workflow section reading "New
   features follow research → `/speckit-specify` → `/speckit-clarify` →
   `/speckit-plan` → `/speckit-tasks`", **When** `specjedi-migrate` runs,
   **Then** each command name is rewritten to its `specjedi-*` equivalent
   and the surrounding sentence structure is otherwise unchanged.
2. **Given** a reference to `/speckit-taskstoissues` (no shipped
   `specjedi-*` equivalent), **When** `specjedi-migrate` runs, **Then**
   that reference is left unchanged and flagged in the migration report as
   having no equivalent yet — never silently dropped or guessed at.

---

### User Story 2 - Nothing to migrate is a clean, honest result (Priority: P2)

A user runs `specjedi-migrate` against a project that has no `speckit-*`
references at all (a fresh Spec Jedi project, or one already fully
migrated). The skill reports that plainly and changes nothing.

**Why this priority**: Prevents the failure mode of a migration tool that
always "finds" something to change to justify having run.

**Independent Test**: Given a project with zero `speckit-*` references,
run `specjedi-migrate` and verify it reports no changes needed and
modifies no file.

**Acceptance Scenarios**:

1. **Given** a `constitution.md` with no `speckit-*` mentions, **When**
   `specjedi-migrate` runs, **Then** it reports "nothing to migrate" and
   `git status` (or equivalent) shows zero file changes.

### Edge Cases

- A `speckit-*` reference appearing inside a code fence or literal example
  (e.g., documenting historical usage) rather than live prose instructing
  a workflow: the skill flags it for human judgment in the report rather
  than rewriting inside quoted/historical context (resolved, Clarifications
  Session 2026-07-11 — the "attributed comparison" case).
- `specjedi-*` skills not yet installed in the target project when
  `specjedi-migrate` is run: the skill checks first and recommends running
  the installer before proceeding, rather than rewriting references to
  skills that don't actually exist in the project yet.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-migrate` MUST rewrite only literal `/speckit-*`
  command references in prose to their shipped `specjedi-*` equivalent —
  it MUST NOT alter principle text, requirement text, or any other
  substantive content.
- **FR-002**: `specjedi-migrate` MUST leave a reference unchanged and flag
  it explicitly in a migration report when no shipped `specjedi-*`
  equivalent exists for the referenced `speckit-*` command.
- **FR-003**: `specjedi-migrate` MUST run only on explicit user request —
  never proactively or automatically triggered by another skill.
- **FR-004**: `specjedi-migrate` MUST check whether `specjedi-*` skills
  are actually installed in the target project before rewriting references
  to them, and MUST recommend running the installer first if they aren't.
- **FR-005**: `specjedi-migrate` MUST produce a migration report listing
  every change made (and every reference flagged but left unchanged) —
  silent rewrites are not acceptable even when the mapping is obvious.
- **FR-006**: A run against a project with no `speckit-*` references MUST
  report "nothing to migrate" and modify zero files.

### Key Entities

- **Migration report**: the output of one `specjedi-migrate` run — a list
  of every rewritten reference (old → new) and every flagged-but-unchanged
  reference (with the reason), never a separate persisted file unless the
  user asks to keep it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every `/speckit-*` reference with a shipped `specjedi-*`
  equivalent is rewritten correctly in a single run — verified by zero
  remaining `/speckit-*` mentions in live prose (outside code fences/
  historical context) after the run.
- **SC-002**: Zero principle or requirement text changes as a byte-diff
  side effect of a migration run — only the flagged tooling-reference
  substrings change.
- **SC-003**: A run against an already-clean project makes zero file
  changes, verified via `git status`.

## Assumptions

- This is its own feature cycle, following the same incremental discipline
  as features 001 and 002 — `specjedi-migrate` ships alone; the remaining
  roadmap items (`specjedi-diagram`, `-status`, `-retro`, `-security`,
  `-docs`) each get their own research pass per Principle II when their
  turn comes.
- `specjedi-migrate` targets `speckit-*` specifically (the tool this
  project itself vendors and is the closest, best-understood competitor
  per Principle XV) — migrating from other SDD tools' formats is out of
  scope for v1 and not researched here.
