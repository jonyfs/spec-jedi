# Feature Specification: Ship .claude/agents/ in the Release Package and Installer

**Feature Branch**: `067-ship-agents-in-release-package`

**Created**: 2026-07-21

**Status**: Draft

**Input**: User description: "verifique se todas as skills specjedi
estão sendo enviadas para release para serem empacotadas" (verify all
specjedi skills are being sent to release to be packaged)

## Clarifications

### Session 2026-07-21

- Q: Story 2 Scenario 2 — should install.sh copy .claude/agents/ unconditionally, or only for a claude-code-targeted install? → A: Only for `--harness claude-code` — the agent files are Claude-Code-specific content (`Agent`/`Workflow` tool definitions per feature 065's own scoping); a non-Claude-Code install gets no `.claude/agents/` directory at all rather than dead weight it can never read.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - `.claude/agents/orchestrate-*.md` ship in the release tarball (Priority: P1)

A user downloads a Spec Jedi release (via `bootstrap-install.sh`/`.ps1`)
expecting to get `specjedi-orchestrate` and the 9 project-local
`orchestrate-*` agent definitions it references. Today,
`scripts/package-release.sh` loops `.claude/skills/specjedi-*/` (line
48) — so `specjedi-orchestrate` the *skill* ships correctly — but never
touches `.claude/agents/` at all. The 9 agent definition files
(`orchestrate-planner.md`, `orchestrate-decomposer.md`,
`orchestrate-implementer.md`, `orchestrate-reviewer.md`,
`orchestrate-documentarian.md`, `orchestrate-narrator.md`,
`orchestrate-auditor.md`, `orchestrate-scout.md`, `orchestrate-operator.md`)
never make it into the release tarball at all.

**Why this priority**: Without this, every user who installs Spec Jedi
from a packaged release gets a skill that documents and orchestrates
around agents that don't exist on their machine — `specjedi-orchestrate`
would propose dispatching to `orchestrate-implementer` and there'd be
nothing to dispatch to. P1: this is a real, currently-shipping gap, not
a hypothetical.

**Independent Test**: Build a real package via `scripts/package-release.sh`
(exactly as `package-content-completeness`'s CI job already does) and
assert the tarball's listing contains all 9
`.claude/agents/orchestrate-*.md` files.

**Acceptance Scenarios**:

1. **Given** the current repository state (9 `orchestrate-*.md` files
   present under `.claude/agents/`), **When**
   `scripts/package-release.sh` builds a tarball, **Then** the tarball's
   listing contains all 9 files under `.claude/agents/`.
2. **Given** a future session adds a 10th `orchestrate-*.md` file,
   **When** the next package is built, **Then** it's included
   automatically — the packaging logic loops the directory's actual
   contents (matching `specjedi-*` skills' own existing loop pattern at
   line 48), never a hardcoded file list that goes stale.

---

### User Story 2 - `install.sh`/`.ps1` copy `.claude/agents/` into the target project (Priority: P1)

Even once User Story 1 ships the agents in the release tarball,
`scripts/install.sh`/`.ps1` — the actual installer a user runs against
their own project — has zero references to `.claude/agents/` anywhere
(confirmed: `grep -c ".claude/agents" scripts/install.sh` returns 0
today). The installer only copies `.claude/skills/specjedi-*/` and the
four shareable hooks into the target project; the agent definitions
would sit unused in the downloaded package, never reaching the project
the user actually wants to work in.

**Why this priority**: Story 1 alone (agents present in the tarball)
doesn't help without Story 2 (agents actually copied into the target
project during install) — both are required for a real user to end up
with working `orchestrate-*` agents. P1 alongside Story 1.

**Independent Test**: Run `install.sh <target_dir> --harness claude-code`
against a scratch target directory; confirm
`<target_dir>/.claude/agents/orchestrate-*.md` exist and match the
source files byte-for-byte after install.

**Acceptance Scenarios**:

1. **Given** a claude-code target install, **When** `install.sh` runs,
   **Then** all 9 `orchestrate-*.md` files are copied into
   `<target_dir>/.claude/agents/`.
2. **Given** a non-Claude-Code harness target install (e.g.
   `--harness cursor`), **When** `install.sh` runs, **Then** no
   `.claude/agents/` directory is created at all — the agent files are
   Claude-Code-specific content (`Agent`/`Workflow` tool definitions,
   per feature 065's own scoping) a non-Claude-Code harness can never
   read, so copying them would be dead weight rather than a useful
   artifact.
3. **Given** a target project already has its own hand-authored
   `.claude/agents/orchestrate-planner.md` (name collision), **When**
   `install.sh` runs, **Then** it does not silently overwrite that file —
   same loss-safety discipline `install.sh`'s existing skill-update
   backup mechanism (specs/055) already applies to `.claude/skills/` and
   `.specify/templates/`.

---

### Edge Cases

- What happens on a re-install/update where a target project already has
  the agents from a prior install, unmodified? Standard idempotent
  overwrite — no backup needed, matching the existing skill-update
  behavior for an unmodified file.
- What happens if `.claude/agents/` doesn't exist at all in a given
  repository state (e.g. a fork that deleted feature 065/066's work)?
  `package-release.sh` and `install.sh` both handle a missing/empty
  directory cleanly — zero agent files packaged/copied, no error, no
  invented placeholder file.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `scripts/package-release.sh` MUST copy every file in
  `.claude/agents/*.md` into the release tarball's own
  `.claude/agents/` directory, looping the directory's actual contents
  (never a hardcoded file list) — matching the existing
  `.claude/skills/specjedi-*/` loop's own pattern (spec.md Story 1
  Acceptance Scenario 2).
- **FR-002**: `scripts/install.sh` and `scripts/install.ps1` MUST copy
  `.claude/agents/*.md` from the source package into the target
  project's own `.claude/agents/` directory during install, only when
  `--harness claude-code` is the resolved target (explicit or via
  auto-detection) — never for any other harness, and never creating an
  empty `.claude/agents/` directory when skipped.
- **FR-003**: Copying `.claude/agents/` MUST respect the same loss-safety
  backup discipline (specs/055) already applied to `.claude/skills/` and
  `.specify/templates/*.md` — a locally-modified agent file gets backed
  up before being overwritten during an update, never silently
  destroyed.
- **FR-004**: The `package-content-completeness` CI job (`.github/workflows/validate.yml`)
  MUST be extended to assert at least one `.claude/agents/*.md` file is
  present in a built package's listing, closing the same class of gap
  its existing assertions already catch for `README.md`/hooks/etc.

### Key Entities

- **Release Package**: the tarball `package-release.sh` builds — must
  now include `.claude/agents/` alongside `.claude/skills/`.
- **Target Project Install**: what `install.sh`/`.ps1` produce in a
  user's own project directory — must now include `.claude/agents/`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A package built via `scripts/package-release.sh` after
  this feature ships contains all 9 currently-existing
  `.claude/agents/orchestrate-*.md` files, checkable via `tar -tzf`.
- **SC-002**: A fresh `install.sh <target> --harness claude-code` run
  produces a target directory whose `.claude/agents/orchestrate-*.md`
  files are byte-identical to the source; a fresh `install.sh <target>
  --harness cursor` run produces no `.claude/agents/` directory at all.
- **SC-003**: The `package-content-completeness` CI job fails loudly if
  a future change removes agent-file packaging — not silently passing.

## Assumptions

- This feature only fixes packaging/install plumbing — it does not
  change any agent's own content (features 065/066's work stands as-is).
- `.claude/agents/` is scoped project-local, same as `.claude/skills/`
  today — no user-level (`~/.claude/agents/`) install path is in scope
  here, matching this project's own Principle XVIII zero-footprint,
  project-scoped installer design.
