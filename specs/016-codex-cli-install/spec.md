# Feature Specification: Codex CLI Install Path

**Feature Branch**: `016-codex-cli-install`

**Created**: 2026-07-12

**Status**: Draft

**Input**: User description: "Build a real, tested install path for a second harness beyond Claude Code, upgrading its README status from 'Planned' to 'Supported' per Constitution Principle III. Target harness: Codex CLI (OpenAI) -- verified via its official docs (learn.chatgpt.com/docs/build-skills) that it reads SKILL.md files with the same required frontmatter fields (name, description) as Claude Code, scanned from .agents/skills/ (repository-level, walking up to repo root) rather than .claude/skills/. Verified that zero specjedi-* skills hardcode Claude-Code-specific tool names or 'Claude Code' references in their content, so this is a same-content, different-target-directory install path, not a content rewrite. Extend scripts/install.sh/.ps1 to support --harness codex-cli, update the README compatibility table, and add real CI coverage (matching the existing install-test job pattern) proving the installed skills land correctly and pass the same frontmatter validation the Claude Code path already does."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A Codex CLI user installs Spec Jedi in one command (Priority: P1)

A developer using OpenAI's Codex CLI (not Claude Code) wants to use Spec
Jedi's `specjedi-*` skills in their project. Today the installer refuses
any harness other than `claude-code`, even though nothing about the
skill content itself is Claude-Code-specific. They run the installer
with `--harness codex-cli` and get a working install, the same way a
Claude Code user already does.

**Why this priority**: This is the actual value delivered — without it,
Codex CLI users can only use Spec Jedi by manually copying files and
guessing at the right location, exactly the friction Principle XVIII's
zero-footprint installer exists to remove.

**Independent Test**: Run the installer with `--harness codex-cli`
against a scratch directory; confirm all `specjedi-*` skills land under
`.agents/skills/` with valid frontmatter, verified by re-running the
installer's own post-copy validation step (already proven to work for
the Claude Code path) against the new target location.

**Acceptance Scenarios**:

1. **Given** a scratch project directory, **When** the installer runs
   with `--harness codex-cli`, **Then** every `specjedi-*` skill is
   copied under `.agents/skills/<skill-name>/SKILL.md` in that directory,
   unmodified from the source.
2. **Given** the installed skills, **When** the installer's post-copy
   validation runs, **Then** every installed `SKILL.md` passes the same
   frontmatter checks (YAML delimiters, `name:`, `description:`) the
   Claude Code install path already enforces.
3. **Given** the installer is run with an unsupported harness name (e.g.
   `--harness some-other-tool`), **When** it runs, **Then** it still
   reports the existing "not built and tested yet" message rather than
   silently attempting an unverified path.

---

### User Story 2 - The README accurately reflects what's actually supported (Priority: P2)

A prospective adopter reads the "Supported harnesses" table to decide
whether Spec Jedi will work for their setup. Today it lists Codex CLI as
"📋 Planned." Once a real, tested install path exists, the table must
say so — the same "no capability claims for anything not actually built
and tested" discipline this table already follows for every other row.

**Why this priority**: A stale status row is exactly the kind of
fact-bearing drift this project has caught and fixed before (badges,
skill counts) — shipping the mechanism without updating the table that
describes it would immediately reintroduce that same class of gap.

**Independent Test**: Read the README's compatibility table after this
feature ships; confirm the Codex CLI row says "✅ Supported" and nothing
else silently changed status without a corresponding real capability
behind it.

**Acceptance Scenarios**:

1. **Given** this feature has shipped and its CI job passes, **When** a
   reader checks the README's "Supported harnesses" table, **Then** the
   Codex CLI row reads "✅ Supported" with a pointer to the install
   instructions, matching the Claude Code row's own format.

---

### User Story 3 - CI proves the install path, not just documents it (Priority: P1)

A maintainer wants confidence that the Codex CLI install path actually
works on every OS this project claims to support (Principle XIII), the
same way the existing Claude Code `install-test` CI job already proves
that path rather than merely asserting it.

**Why this priority**: This project's own established discipline (and
CHK016's own resolution earlier this session) is "prove it in CI, don't
just claim it" — a README status change with no CI backing it would be
the exact kind of unverified claim Principle XX forbids.

**Independent Test**: Open the PR that ships this feature; confirm a new
CI job (matrixed across the same OSes the existing `install-test` job
covers) installs into a scratch directory with `--harness codex-cli` and
asserts the skills land correctly, and that this job is added to
`ci-gate`'s required list.

**Acceptance Scenarios**:

1. **Given** a PR shipping this feature, **When** CI runs, **Then** a
   dedicated job reinstalls fresh with `--harness codex-cli` on
   `ubuntu-latest`, `macos-latest`, and `windows-latest`, asserting the
   expected skill count lands under `.agents/skills/` with no
   `speckit-*` leakage (mirroring the existing Claude Code
   `install-test` job's own assertions).

### Edge Cases

- What happens if a target directory already has a `.agents/skills/`
  directory from a different tool (e.g. an existing Codex CLI project
  with its own custom skills)? The installer MUST only touch
  `specjedi-*`-named subdirectories within `.agents/skills/`, same as
  the existing Claude Code path's behavior toward `.claude/skills/` —
  never wipe the whole directory.
- What happens if `--harness codex-cli` is combined with a target
  directory that has no existing `.agents/` structure at all? The
  installer MUST create the directory structure, same as the Claude Code
  path already does for `.claude/skills/`.
- What happens to the four `.specify/templates/*.md` runtime
  dependencies the Claude Code path also installs? They MUST still be
  installed identically for the Codex CLI path — those files aren't
  harness-specific, they're read by the skills themselves regardless of
  which harness is running them.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `scripts/install.sh` and `scripts/install.ps1` MUST accept
  `--harness codex-cli` as a valid value, in addition to the existing
  `claude-code`.
- **FR-002**: When `--harness codex-cli` is given, the installer MUST
  copy every `specjedi-*` skill directory (unmodified — same content, no
  rewriting) to `<target>/.agents/skills/<skill-name>/` instead of
  `<target>/.claude/skills/<skill-name>/`.
- **FR-003**: The installer MUST still install the four
  `.specify/templates/*.md` runtime-dependency files regardless of which
  harness was selected — these are not harness-specific.
- **FR-004**: The installer's post-copy validation (YAML frontmatter
  delimiters present, `name:` present, `description:` present) MUST run
  against the Codex CLI install location exactly as it already does for
  the Claude Code location — no separate, weaker validation path.
- **FR-005**: An unsupported `--harness` value MUST continue to produce
  the existing informative refusal — this feature adds one new supported
  value, it does not relax the refusal behavior for every other
  unsupported name.
- **FR-006**: README's "Supported harnesses" table MUST update the Codex
  CLI row from "📋 Planned" to "✅ Supported," matching the existing
  Claude Code row's format and level of detail.
- **FR-007**: `.github/workflows/validate.yml` MUST gain a CI job
  (matrixed across `ubuntu-latest`, `macos-latest`, `windows-latest`,
  plus a native-PowerShell counterpart, mirroring the existing
  `install-test`/`install-test-windows-native` job pair exactly) that
  installs fresh into a scratch directory with `--harness codex-cli` and
  asserts: the expected skill count landed under `.agents/skills/`, and
  no `speckit-*` bootstrap tooling leaked into the install. This job
  MUST be added to `ci-gate`'s required list.

### Key Entities

- **Harness Target**: a supported `--harness` value and its
  corresponding install-location convention (`claude-code` →
  `.claude/skills/`, `codex-cli` → `.agents/skills/`) — this feature
  adds one new entry to what was previously a single hardcoded case.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Running the installer with `--harness codex-cli` against a
  scratch directory produces a complete, validated install with zero
  manual follow-up steps.
- **SC-002**: The Codex CLI install-test CI job passes on all three
  operating systems this project claims cross-platform support for.
- **SC-003**: The README's compatibility table accurately reflects the
  new capability with no other row's status silently changing.

## Assumptions

- Codex CLI's `.agents/skills/` directory convention and its `name`/
  `description`-only frontmatter requirement are taken as verified from
  Codex's own official documentation (`learn.chatgpt.com/docs/build-skills`),
  not re-derived here — `research.md` records the citation.
- This feature does not attempt to verify behavior by actually running
  Codex CLI itself (not available in this environment) — verification is
  structural (file placement, frontmatter validity), the same class of
  verification the existing Claude Code `install-test` job already
  performs, honestly scoped the same way.
- No `specjedi-*` skill content requires modification for this feature —
  confirmed via a direct grep audit (zero hardcoded "Claude Code" or
  Claude-Code-specific tool-name references across all 23 skills) before
  this spec was written.
