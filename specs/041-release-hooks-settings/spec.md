# Feature Specification: Release-Ship Shareable Hooks & Settings, Per Harness

**Feature Branch**: `041-release-hooks-settings`

**Created**: 2026-07-15

**Status**: Draft

**Input**: User description: "todos os hooks e settings que podem ser compartilhados juntos com specjedi-* devem ser inclusos no release e adaptados para serem configurados para cada harness quando for aplicável" (all hooks and settings that can be shared alongside specjedi-* must be included in the release and adapted to be configured for each harness when applicable)

## Clarifications

### Session 2026-07-15

- Q: Should shareable hooks/settings install automatically on every run, or only when explicitly requested? → A: Interactive prompt — reuse feature 040's interactive-install pattern (specs/040-aitmpl-settings-improvements): ask once during an interactive install session, default-on (no prompt, install automatically) for scripted/CI/explicit-flag invocations where no human is present to ask.
- Q: Should this feature's v1 scope to Claude Code only, or attempt research and adaptation across all 19 non-Claude-Code harnesses? → A: All 19 — full per-harness research and adaptation is in scope for this feature, not deferred to a follow-up.
- Q: `dangerous-command-guard`'s force-push protection hardcodes `main`/`master` — should the shared copy detect the target repo's actual trunk branch, or ship with the same hardcoded check regardless of the target's naming? → A: Detect the target's actual default/trunk branch at install time (`git symbolic-ref refs/remotes/origin/HEAD` or `git remote show origin`) and bake it into the installed copy, falling back to `main`/`master` if detection fails — a one-time detection at install, not a re-check on every hook invocation.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Generically-useful hooks/settings reach installed projects (Priority: P1)

A person who runs `scripts/install.sh`/`.ps1` to install `specjedi-*`
skills into their own project also gets the subset of this repo's own
`.claude/hooks/*` and `.claude/settings.json` additions that are
genuinely useful to *any* project — not the ones that only make sense
inside spec-jedi's own repo because they check spec-jedi-specific
conventions.

**Why this priority**: This is the feature's entire point — without it,
"included in the release" doesn't happen at all. P1 by elimination.

**Independent Test**: Run the installer against a scratch directory for
`claude-code`, both interactively and via an explicit `--harness` flag;
confirm the shareable hook(s)/setting(s) land in the target's own
`.claude/` directory with content equivalent to this repo's own copy
(after an affirmative interactive answer, or automatically in the
scripted case), and confirm the repo-internal-only hooks (see
Assumptions) do NOT land there either way.

**Acceptance Scenarios**:

1. **Given** an interactive install session (per specs/040's own
   `interactive_mode` detection: no target dir/harness/`--auto` given, a
   real TTY attached), **When** the installer reaches the point of
   copying skills, **Then** it asks once whether to also install the
   shareable hooks/settings, honoring the user's Y/n answer (default:
   yes, matching this project's other interactive prompts' default-
   accept convention).
2. **Given** a scripted/CI invocation (`--harness claude-code` passed
   explicitly, or non-interactive/no-TTY context), **When** the installer
   runs, **Then** the shareable hooks/settings install automatically,
   with no prompt.
3. **Given** either path above resulted in installation, **When** the
   target's `.claude/` directory is inspected, **Then**
   `dangerous-command-guard.sh`/`.ps1` and the `statusline`/`permissions`
   additions are present, each with the target's own
   `${CLAUDE_PROJECT_DIR}`-relative paths (not this repo's own absolute
   paths).
4. **Given** a target repository whose `origin` remote's default branch
   is named `develop` (not `main`/`master`), **When**
   `dangerous-command-guard` is installed, **Then** its force-push check
   protects `develop`, not a hardcoded `main`/`master` that doesn't exist
   in that repo.
5. **Given** a target repository with no `origin` remote configured yet,
   **When** `dangerous-command-guard` is installed, **Then** its
   force-push check falls back to `main`/`master` rather than shipping
   with no protection at all.
6. **Given** the same run, **When** the target's resulting
   `.claude/hooks/` directory is inspected, **Then** `skill-quality-guard.*`
   and `cross-platform-parity-guard.*` (spec-jedi-repo-specific, see
   Assumptions) are absent.
7. **Given** a target directory that already has its own
   `.claude/settings.json` with unrelated `hooks`/`permissions`/
   `statusLine` content, **When** the installer runs, **Then** the
   shareable additions are merged in without deleting or overwriting the
   target's own pre-existing entries — same non-destructive-merge
   discipline `update_memory_file`/`Update-MemoryFile` (specs/039)
   already established for `CLAUDE.md`/`AGENTS.md`.

---

### User Story 2 - Researched, per-harness adaptation across all 20 harnesses (Priority: P2)

A person installing for *any* harness in Principle III's compatibility
matrix — not just `claude-code` — gets shareable hooks/settings adapted
to that harness's own real mechanism when one exists (researched fresh
by this feature, since `references/harness-capability-notes.md` and
`specs/023-full-harness-coverage/research.md` have only ever covered
rules/skills-file capability, never hooks/settings/statusline), and a
clean, honestly-labeled skip when it genuinely doesn't.

**Why this priority**: Directly required by the user's own "quando for
aplicável" (when applicable) qualifier, resolved via Clarifications to
mean full research across all 19 non-Claude-Code harnesses, not a
Claude-Code-only v1. Still P2, not P1: User Story 1 (the Claude Code
case, where the actual source hooks/settings already exist and are
already tested) is the independently-valuable, buildable-first slice;
this story's 19-harness research is what determines *how much* of the
"for every harness" ambition is actually achievable, and by how much.

**Independent Test**: For a sample of 3 harnesses spanning the found
range (one with a confirmed adaptable mechanism, one with a
partially-expressible mechanism, one with none), run the installer and
confirm each behaves per its own researched category — full adaptation,
partial adaptation, or clean skip.

**Acceptance Scenarios**:

1. **Given** this feature's own research phase confirms a harness has no
   hook/settings-equivalent mechanism, **When** the installer runs for
   that harness, **Then** it completes successfully (skills still
   install) and prints no hooks/settings-related success message for
   that harness.
2. **Given** the research phase confirms a harness *has* an adaptable
   mechanism, **When** the installer runs, **Then** the shareable
   hooks/settings are translated into that harness's own mechanism/
   format, not copied verbatim as Claude-Code-specific JSON.
3. **Given** the research phase finds mixed evidence for a harness
   (plausible but unconfirmed mechanism), **When** that harness is
   installed for, **Then** the installer treats it the same as "no
   mechanism" (Scenario 1) — matching this project's existing precedent
   of never claiming an unconfirmed capability (e.g., Cody's own
   "Unclear" status resolution in specs/023).

### Edge Cases

- What happens when a target's existing `.claude/settings.json` has a
  syntax error before the installer touches it? Matches
  `update_memory_file`'s existing "malformed marker pair" precedent
  (specs/039 FR): fail loudly and specifically, never guess or silently
  overwrite.
- What happens on a re-run (idempotency)? Re-running the installer
  against a target that already has the shareable hooks/settings
  installed MUST NOT duplicate entries — same idempotency bar
  `update_memory_file` already meets for memory files.
- What happens when a harness's own native hook/settings mechanism
  can express *some* but not all of the shareable set (e.g., it supports
  a deny-rule equivalent but nothing statusline-like)? Install the
  translatable subset; do not block the whole feature on the harness's
  weakest-supported piece.
- Automatic vs. opt-in installation (resolved, see Clarifications):
  interactive sessions ask once (default: yes); scripted/CI/explicit-flag
  invocations install automatically with no prompt, matching specs/040's
  own interactive-vs-scripted distinction (`interactive_mode` detection).
- Harness research scope (resolved, see Clarifications): all 19
  non-Claude-Code harnesses are researched and adapted-for in this same
  feature, not deferred — a `specs/023`-sized research effort is
  explicitly part of this feature's own Phase 0.
- Trunk branch name generalization (resolved, see Clarifications): a
  target repository with no `origin` remote configured yet (e.g., a
  brand-new local-only project) can't have its default branch detected
  via `git remote show origin` — FR-002a's fallback to `main`/`master`
  covers this exact case, not just a hypothetical detection failure.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The release/installer MUST include, for `claude-code`, the
  subset of this repo's own `.claude/hooks/*` and `.claude/settings.json`
  content classified as shareable (see Assumptions) — not the full set
  this repo uses for its own development.
- **FR-001a**: For each of the other 19 harnesses in Principle III's
  compatibility matrix, this feature MUST research (fresh — extending
  `references/harness-capability-notes.md`'s scope, which has never
  covered this) whether a hook/settings/statusline-equivalent mechanism
  exists, and classify each as: full adaptation possible, partial
  adaptation possible (per Edge Cases), or no mechanism (clean skip, User
  Story 2).
- **FR-001b**: The installer MUST, during an interactive install session
  (per specs/040's own `interactive_mode` detection), ask once whether to
  install the shareable hooks/settings, defaulting to yes on an empty
  answer — matching this project's other interactive prompts' default-
  accept convention (specs/040's own harness-confirmation prompt).
- **FR-001c**: The installer MUST install shareable hooks/settings
  automatically, with no prompt, whenever `interactive_mode` is false
  (explicit `--harness`/`-Harness`, `--auto`/`-Auto`, or non-interactive/
  no-TTY context) — matching skill-file copying's own existing
  default-on behavior for every non-interactive invocation.
- **FR-002**: Shareable hook script content (`dangerous-command-guard.sh`/
  `.ps1`) MUST be installed with paths rewritten relative to the
  *target's* own `${CLAUDE_PROJECT_DIR}`, never hard-coded to this repo's
  own absolute paths.
- **FR-002a**: At install time, the installer MUST detect the target
  repository's actual default/trunk branch (e.g. via `git symbolic-ref
  refs/remotes/origin/HEAD` or `git remote show origin`) and bake that
  branch name into the installed `dangerous-command-guard.sh`/`.ps1`
  copy's force-push check, replacing the hardcoded `main`/`master`
  check this repo's own copy uses. If detection fails (e.g. no `origin`
  remote configured yet), the installed copy MUST fall back to checking
  `main`/`master`, matching this repo's own existing behavior, rather
  than shipping with no force-push protection at all. Detection happens
  once, at install time — the installed hook itself does not re-detect
  the branch on every invocation (Clarifications).
- **FR-003**: Installing shareable hooks/settings into a target's
  existing `.claude/settings.json` MUST be a non-destructive merge —
  existing unrelated keys/entries in that file MUST survive unchanged,
  matching the merge discipline `update_memory_file`/`Update-MemoryFile`
  (specs/039) already established for a file this installer doesn't
  fully own.
- **FR-004**: Installing shareable hooks/settings a second time against
  the same target (idempotent re-run) MUST NOT duplicate entries.
- **FR-005**: For a harness confirmed to have no hook/settings-equivalent
  mechanism, the installer MUST complete the skills install successfully
  and MUST NOT print any message claiming hooks/settings were installed
  for that harness (Principle XX).
- **FR-006**: Repo-internal-only hooks (`skill-quality-guard.*`,
  `cross-platform-parity-guard.*` — see Assumptions) MUST NOT be
  installed into any target project, regardless of harness.
- **FR-007**: Both `install.sh` and `install.ps1` MUST gain equivalent
  new logic for this feature (Constitution Principle XIII).

### Key Entities

- **Shareable hook/setting**: one of this repo's own `.claude/hooks/*`
  or `.claude/settings.json` additions, classified (per Assumptions) as
  generically useful to any project rather than specific to spec-jedi's
  own repo conventions.
- **Repo-internal-only hook/setting**: the complement — useful only
  because it checks a spec-jedi-repo-specific convention (e.g., SKILL.md
  authoring standards, this repo's own `scripts/*.sh`/`.ps1` pairing
  discipline); never installed into a target project.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: For `claude-code`, a fresh install into a scratch directory
  results in the shareable hook(s)/setting(s) present and functionally
  equivalent (same block/allow behavior, verified via the same test
  matrix style as `.claude/hooks/test-hooks.sh`) to this repo's own copy.
- **SC-002**: Re-running the installer against the same target directory
  twice produces byte-identical `.claude/settings.json`/hook-file content
  after the second run compared to after the first (idempotent).
- **SC-003**: Installing against a target with a pre-existing, unrelated
  `.claude/settings.json` entry preserves that entry unchanged, verified
  by diffing the untouched keys before and after install.
- **SC-004**: Installing against a harness with no confirmed hook/
  settings mechanism produces zero hooks/settings-related output lines
  and a fully successful skills install (exit code 0).
- **SC-005**: All 19 non-Claude-Code harnesses in Principle III's
  compatibility matrix have a documented, cited classification (full
  adaptation / partial adaptation / no mechanism) before this feature is
  considered done — zero harnesses left unresearched or guessed at.
- **SC-006**: An interactive install session run twice — once answering
  yes, once answering no to the shareable-hooks prompt — produces the
  expected presence/absence of those hooks/settings each time, with no
  prompt at all appearing for a scripted/`--harness`-flagged invocation
  in between.
- **SC-007**: Installing into a scratch repository with a `develop`
  default branch results in an installed `dangerous-command-guard` that
  blocks a force-push to `develop` and allows one to an arbitrarily-named
  non-trunk branch — verified by an actual attempted force-push in the
  test matrix, not asserted.

## Assumptions

- **Shareability classification** (this repo's own judgment call,
  documented here rather than left to re-litigate at plan time): of the
  hooks/settings built this session, `dangerous-command-guard.sh`/`.ps1`
  (generic destructive-command/secret-file protection) and the
  `statusline`/`permissions` additions from specs/040 (generic git-branch
  visibility and routine-git-op/secret-file permission rules) are
  shareable — nothing about them depends on spec-jedi's own repo
  structure. `skill-quality-guard.sh`/`.ps1` (checks
  `specjedi-*/SKILL.md` authoring standards) and
  `cross-platform-parity-guard.sh`/`.ps1` (checks `scripts/*.sh`/`.ps1`
  pairing) are repo-internal-only — a `specjedi-*` end-user is not
  typically authoring new `specjedi-*`-branded skills or maintaining a
  dual-shipped `scripts/` convention of their own, so these two would
  produce false-positive noise rather than value in a target project.
- This feature builds on the hooks/settings already designed and tested
  this session (PR #119, specs/040) — it does not commission new
  research into *additional* hooks/settings beyond what already exists,
  matching the narrower reading of "hooks and settings that can be
  shared together with specjedi-*" (adapting what exists) over a broader
  reading (finding wholly new ones).
- Where a harness's own native mechanism can only partially express the
  shareable set (per Edge Cases), a partial install is acceptable and
  MUST be scoped by this feature's own research phase per-harness, not
  guessed at implementation time.
