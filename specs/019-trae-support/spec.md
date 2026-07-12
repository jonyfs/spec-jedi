# Feature Specification: Trae Harness Support

**Feature Branch**: `019-trae-support`

**Created**: 2026-07-12

**Status**: Draft

**Input**: User description: "Build a real, tested install path for a fifth supported harness beyond Claude Code, Codex CLI, OpenCode, and Warp, upgrading Trae's README status from 'Planned' to 'Supported' per Constitution Principle III. Target harness: Trae (the AI-native IDE from ByteDance, docs.trae.ai). Verified via Trae's official Skills documentation, community documentation, and authoritatively via Vercel's own `skills` CLI source code (vercel-labs/skills, src/agents.ts) that Trae has a genuine, separate, directory-based Skills capability distinct from its Rules system (.trae/rules/project_rules.md): skills live in .trae/skills/<name>/SKILL.md, following the same open Agent Skills standard (YAML frontmatter with name/description) as Claude Code. This is NOT one of Spec Jedi's two existing install targets, so unlike OpenCode/Warp this needs a genuinely new installer branch -- architecturally the same shape as feature 016 (Codex CLI): extend scripts/install.sh/.ps1 to support --harness trae, update the README compatibility table, and add real CI coverage proving the installed skills land correctly and pass the same frontmatter/naming validation the other paths already prove. Also document a real research correction: a GitHub issue (Trae-AI/TRAE#2253) reported a symlinked SKILL.md directory wasn't recognized by Trae, but the reporter's symlink target path did not match either agent's actual documented directory, so the negative report traces to a path mismatch in the bug report, not a real gap in Trae's project-local .trae/skills/ discovery convention."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A Trae user installs Spec Jedi in one command (Priority: P1)

A developer using Trae (ByteDance's AI-native IDE) wants to use Spec
Jedi's `specjedi-*` skills in their project. Today the installer refuses
any harness other than `claude-code` or `codex-cli`, even though nothing
about the skill content itself is specific to either. They run the
installer with `--harness trae` and get a working install, the same way
Claude Code and Codex CLI users already do.

**Why this priority**: This is the actual value delivered — without it,
Trae users can only use Spec Jedi by manually copying files into
`.trae/skills/` and guessing at the right structure, exactly the
friction Principle XVIII's zero-footprint installer exists to remove.

**Independent Test**: Run the installer with `--harness trae` against a
scratch directory; confirm all `specjedi-*` skills land under
`.trae/skills/` with valid frontmatter, verified by re-running the
installer's own post-copy validation step (already proven for the Claude
Code and Codex CLI paths) against the new target location.

**Acceptance Scenarios**:

1. **Given** a scratch project directory, **When** the installer runs
   with `--harness trae`, **Then** every `specjedi-*` skill is copied
   under `.trae/skills/<skill-name>/SKILL.md` in that directory,
   unmodified from the source.
2. **Given** the installed skills, **When** the installer's post-copy
   validation runs, **Then** every installed `SKILL.md` passes the same
   frontmatter checks (YAML delimiters, `name:`, `description:`) the
   other install paths already enforce.
3. **Given** the installer is run with an unsupported harness name,
   **When** it runs, **Then** it still reports the existing "not built
   and tested yet" message rather than silently attempting an unverified
   path.

---

### User Story 2 - The README accurately reflects what's actually supported (Priority: P2)

A prospective adopter reads the "Supported harnesses" table to decide
whether Spec Jedi will work for their setup. Today it lists Trae as
"📋 Planned." Once a real, tested install path exists, the table must
say so — the same "no capability claims for anything not actually built
and tested" discipline this table already follows for every other row.

**Why this priority**: A stale status row is exactly the kind of
fact-bearing drift this project has caught and fixed before — shipping
the mechanism without updating the table that describes it would
immediately reintroduce that same class of gap.

**Independent Test**: Read the README's compatibility table after this
feature ships; confirm the Trae row says "✅ Supported" and nothing else
silently changed status without a corresponding real capability behind
it.

**Acceptance Scenarios**:

1. **Given** this feature has shipped and its CI job passes, **When** a
   reader checks the README's "Supported harnesses" table, **Then** the
   Trae row reads "✅ Supported" with a pointer to the install
   instructions, matching the existing rows' format.

---

### User Story 3 - CI proves the install path, not just documents it (Priority: P1)

A maintainer wants confidence that the Trae install path actually works
on every OS this project claims to support (Principle XIII), the same
way the existing `install-test`/`install-test-codex-cli` CI jobs already
prove those paths rather than merely asserting them.

**Why this priority**: This project's own established discipline is
"prove it in CI, don't just claim it" — a README status change with no
CI backing it would be the exact kind of unverified claim Principle XX
forbids.

**Independent Test**: Open the PR that ships this feature; confirm a new
CI job (matrixed across the same OSes the existing `install-test` job
covers) installs into a scratch directory with `--harness trae` and
asserts the skills land correctly, and that this job is added to
`ci-gate`'s required list.

**Acceptance Scenarios**:

1. **Given** a PR shipping this feature, **When** CI runs, **Then** a
   dedicated job reinstalls fresh with `--harness trae` on
   `ubuntu-latest`, `macos-latest`, and `windows-latest`, asserting the
   expected skill count lands under `.trae/skills/` with no `speckit-*`
   bootstrap tooling leakage (mirroring the existing
   `install-test-codex-cli` job's own assertions).

### Edge Cases

- What happens if a target directory already has a `.trae/skills/`
  directory from a different tool (e.g. an existing Trae project with
  its own custom skills, or skills installed via Trae's own `npx skills`
  ecosystem)? The installer MUST only touch `specjedi-*`-named
  subdirectories within `.trae/skills/`, same as the existing paths'
  behavior toward their own target directories — never wipe the whole
  directory.
- What happens if `--harness trae` is combined with a target directory
  that has no existing `.trae/` structure at all? The installer MUST
  create the directory structure, same as the other paths already do.
- What happens to the four `.specify/templates/*.md` runtime
  dependencies the other paths also install? They MUST still be
  installed identically for the Trae path — those files aren't
  harness-specific, they're read by the skills themselves regardless of
  which harness is running them.
- What happens with Trae's *other* skill mechanism (skills installed via
  its `npx skills`-CLI-integrated ecosystem, distinct from a raw
  directory scan)? Out of scope for this feature — this targets Trae's
  own documented project-local `.trae/skills/<name>/SKILL.md` discovery
  convention only, the same class of file-placement claim already proven
  for the other four harnesses, not Trae's separate marketplace/registry
  flow.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `scripts/install.sh` and `scripts/install.ps1` MUST accept
  `--harness trae` as a valid value, in addition to the existing
  `claude-code` and `codex-cli`.
- **FR-002**: When `--harness trae` is given, the installer MUST copy
  every `specjedi-*` skill directory (unmodified — same content, no
  rewriting) to `<target>/.trae/skills/<skill-name>/` instead of
  `<target>/.claude/skills/<skill-name>/` or `<target>/.agents/skills/<skill-name>/`.
- **FR-003**: The installer MUST still install the four
  `.specify/templates/*.md` runtime-dependency files regardless of which
  harness was selected — these are not harness-specific.
- **FR-004**: The installer's post-copy validation (YAML frontmatter
  delimiters present, `name:` present, `description:` present) MUST run
  against the Trae install location exactly as it already does for the
  other locations — no separate, weaker validation path.
- **FR-005**: An unsupported `--harness` value MUST continue to produce
  the existing informative refusal — this feature adds one new supported
  value, it does not relax the refusal behavior for every other
  unsupported name.
- **FR-006**: README's "Supported harnesses" table MUST update the Trae
  row from "📋 Planned" to "✅ Supported," matching the existing rows'
  format and level of detail.
- **FR-007**: `.github/workflows/validate.yml` MUST gain a CI job
  (matrixed across `ubuntu-latest`, `macos-latest`, `windows-latest`,
  plus a native-PowerShell counterpart, mirroring the existing
  `install-test-codex-cli`/`install-test-codex-cli-windows-native` job
  pair exactly) that installs fresh into a scratch directory with
  `--harness trae` and asserts: the expected skill count landed under
  `.trae/skills/`, and no `speckit-*` bootstrap tooling leaked into the
  install. This job MUST be added to `ci-gate`'s required list.

### Key Entities

- **Harness Target**: a supported `--harness` value and its
  corresponding install-location convention (`claude-code` →
  `.claude/skills/`, `codex-cli` → `.agents/skills/`, `trae` →
  `.trae/skills/`) — this feature adds one new entry.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Running the installer with `--harness trae` against a
  scratch directory produces a complete, validated install with zero
  manual follow-up steps.
- **SC-002**: The Trae install-test CI job passes on all three operating
  systems this project claims cross-platform support for.
- **SC-003**: The README's compatibility table accurately reflects the
  new capability with no other row's status silently changing.

## Assumptions

- Trae's `.trae/skills/<name>/SKILL.md` directory convention and its
  `name`/`description` frontmatter requirement are taken as verified
  from Trae's official Skills documentation and community documentation,
  cross-checked authoritatively against Vercel's own `skills` CLI source
  (`vercel-labs/skills`, `src/agents.ts`, which hardcodes
  `skillsDir: '.trae/skills'` for the `trae` agent target) — a
  first-party, executable specification, not re-derived here;
  `research.md` records the citations.
- A GitHub issue (`Trae-AI/TRAE#2253`) reporting that a symlinked
  SKILL.md directory wasn't recognized by Trae was investigated and
  found to trace to a path mismatch in the reporter's own reproduction
  steps (a Windows global AppData path that doesn't match either agent's
  documented directory), not a real gap in the project-local
  `.trae/skills/` convention this feature targets. This correction is
  recorded in `research.md` rather than silently discarded.
- This feature does not attempt to verify behavior by actually running
  Trae itself (not available in this environment) — verification is
  structural (file placement, frontmatter validity), the same class of
  verification the existing Claude Code and Codex CLI `install-test`
  jobs already perform, honestly scoped the same way.
- No `specjedi-*` skill content requires modification for this feature —
  confirmed via the same grep audit already run for feature 016 (zero
  hardcoded harness-specific tool-name references across all 23 skills).
