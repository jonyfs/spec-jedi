# Feature Specification: OpenCode Harness Support

**Feature Branch**: `017-opencode-support`

**Created**: 2026-07-12

**Status**: Draft

**Input**: User description: "Continue the harness-support work (feature 016 pattern) for OpenCode. Verified via OpenCode's own official docs (opencode.ai/docs/skills/) that it discovers skills from six locations including .claude/skills/<name>/SKILL.md and .agents/skills/<name>/SKILL.md at both project and global scope, with an identical SKILL.md format to Claude Code (name, description, license, compatibility, metadata frontmatter fields) -- meaning the existing claude-code and codex-cli install paths already satisfy OpenCode's own discovery convention with zero new install-path code. Verified all 23 specjedi-* skill names already match OpenCode's exact naming requirement (lowercase alphanumeric, single-hyphen separators, directory name matching frontmatter name). This feature is scoped to verifying and proving that claim in CI, then updating README's compatibility table -- not building new installer logic."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An OpenCode user discovers Spec Jedi already works for them (Priority: P1)

A developer using OpenCode (not Claude Code or Codex CLI) reads the
README's compatibility table and sees OpenCode listed as "📋 Planned."
In reality, running the existing installer with either
`--harness claude-code` or `--harness codex-cli` already produces a
result OpenCode can discover and use, because OpenCode's own skill
discovery already scans both `.claude/skills/` and `.agents/skills/`.
The table should say so.

**Why this priority**: This is the entire value of the feature — a
correction from "not supported" to "already supported," costing nothing
to build because the mechanism already exists; the only real work is
verifying the claim is true and making it discoverable.

**Independent Test**: Run the existing installer with either harness
value against a scratch directory; confirm the result matches every
location OpenCode's own documented discovery convention scans.

**Acceptance Scenarios**:

1. **Given** a scratch directory installed via
   `--harness claude-code`, **When** OpenCode's documented discovery
   locations are checked against it, **Then** `.claude/skills/<name>/SKILL.md`
   matches one of OpenCode's own scanned paths exactly.
2. **Given** the same scratch directory, **When** each installed
   `SKILL.md`'s frontmatter `name` field is checked, **Then** it matches
   OpenCode's exact naming rule (lowercase alphanumeric, single-hyphen
   separators, matches the containing directory name) for all 23 skills.

---

### User Story 2 - The README accurately reflects what's actually true (Priority: P1)

Same discipline as feature 016's User Story 2: a stale "Planned" status
row is exactly the kind of fact-bearing drift this project has caught
before. Once verified, the table must say "Supported."

**Independent Test**: Read the README's table; confirm the OpenCode row
changed and explains which existing install path(s) satisfy it, without
implying a new dedicated `--harness opencode` flag exists (none is
needed).

**Acceptance Scenarios**:

1. **Given** this feature has shipped, **When** a reader checks the
   README, **Then** the OpenCode row reads "✅ Supported" and explains
   that it's satisfied by the existing `claude-code`/`codex-cli` install
   paths, not a new dedicated flag.

---

### User Story 3 - CI proves the claim, not just asserts it (Priority: P1)

Same discipline as feature 016's User Story 3 — this project's
established rule is "prove it in CI, don't just claim it," even when the
claim is "nothing new needed to build, it already works."

**Independent Test**: Open the PR; confirm a CI job installs via the
existing installer and asserts every file lands at a path OpenCode's own
documented discovery convention would actually scan.

**Acceptance Scenarios**:

1. **Given** a PR shipping this feature, **When** CI runs, **Then** a
   job reinstalls into a scratch directory and asserts the installed
   skill paths and frontmatter both satisfy OpenCode's documented
   requirements exactly (path shape, `name`/`description` presence,
   `name` format rule) — not merely re-running the existing
   `install-test`/`install-test-codex-cli` assertions, but checking them
   specifically against OpenCode's own stated rules.

### Edge Cases

- What if a future OpenCode documentation change alters its discovery
  paths or naming rules? This feature verifies the convention as
  documented on 2026-07-12; it does not build an automated
  docs-drift-watcher — that would be disproportionate machinery for a
  claim this cheap to re-verify by hand if OpenCode's docs ever change.
- What if a project already has an unrelated `.opencode/skills/`
  directory with its own custom skills? Neither the `claude-code` nor
  `codex-cli` install path writes to `.opencode/skills/` at all — no
  collision is possible, since this feature verifies existing install
  targets, it doesn't add a new one.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A new CI job MUST verify, after a fresh `--harness
  claude-code` install, that every installed skill's location and
  frontmatter satisfies OpenCode's documented discovery convention
  (path under `.claude/skills/<name>/SKILL.md`; `name` present,
  lowercase-alphanumeric-hyphenated, matching its directory).
- **FR-002**: The same CI job (or a companion one) MUST perform the
  equivalent check for the `codex-cli` install path against
  `.agents/skills/<name>/SKILL.md`.
- **FR-003**: README's "Supported harnesses" table MUST update the
  OpenCode row from "📋 Planned" to "✅ Supported," explicitly naming
  which existing install path(s) satisfy it — never implying a new,
  separate `--harness opencode` flag exists when none was built.
- **FR-004**: This feature MUST NOT add any new code path to
  `scripts/install.sh`/`.ps1` — the existing `claude-code`/`codex-cli`
  branches already produce a valid result; adding a redundant third
  branch that does the same thing would be exactly the kind of
  unnecessary duplication this project's own discipline (Principle II's
  internal-redundancy check) already forbids.

### Key Entities

- **Harness Satisfaction Claim**: a mapping from an existing install
  target (`.claude/skills/`, `.agents/skills/`) to the additional
  harnesses whose own documented discovery convention that target
  already satisfies — OpenCode is the first entry beyond the harness the
  target was originally built for.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A real CI job confirms, on every OS this project supports,
  that the existing install output satisfies OpenCode's documented
  discovery convention exactly — not merely asserted in prose.
- **SC-002**: README accurately reflects the new status with no new
  installer flag implied that doesn't exist.
- **SC-003**: Zero new lines added to `scripts/install.sh`/`.ps1` — this
  feature is proof-and-documentation only, verified via `git diff`
  showing no changes to those two files.

## Assumptions

- OpenCode's discovery convention and `SKILL.md` format are taken as
  verified from OpenCode's own official documentation
  (`opencode.ai/docs/skills/`, fetched 2026-07-12) — `research.md`
  records the citation and quotes the exact scanned paths and naming
  rule.
- This feature does not attempt to actually run OpenCode itself (not
  available in this environment) — verification is structural, matching
  the same honest scoping established in feature 016.
- No `specjedi-*` skill content requires modification — the format is
  already identical to Claude Code's per OpenCode's own documentation,
  and every skill's naming already independently verified compliant
  before this spec was written.
