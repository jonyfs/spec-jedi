# Feature Specification: Warp Harness Support

**Feature Branch**: `018-warp-support`

**Created**: 2026-07-12

**Status**: Draft

**Input**: User description: "Continue the harness-support work (feature 017 pattern) for Warp (Agent Mode). Initial research checking only Warp's Rules docs (docs.warp.dev/agent-platform/capabilities/rules/) found a flat AGENTS.md/WARP.md-only convention with no directory-based skills -- but a second check against Warp's separate Skills docs (docs.warp.dev/agent-platform/capabilities/skills/) found Warp actually has a dedicated, directory-based Skills system scanning ten directory names including .claude/skills/ and .agents/skills/ directly, with the same name/description SKILL.md frontmatter convention. This corrects the initial finding: Warp, like OpenCode, needs zero new installer code -- the existing claude-code/codex-cli install paths already satisfy it. This feature verifies that claim in CI and updates README, matching feature 017's scope exactly."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A Warp user discovers Spec Jedi already works for them (Priority: P1)

A developer using Warp's Agent Mode reads the README's compatibility
table and sees Warp listed as "📋 Planned." In reality, Warp's own Skills
system (distinct from its `AGENTS.md`/`WARP.md` rules file) already scans
`.claude/skills/` and `.agents/skills/` directly, so an existing install
via either harness value already produces a result Warp can discover.

**Why this priority**: Same as feature 017 — the entire value is a
correction from "not supported" to "already supported" at zero build
cost, since the mechanism already exists.

**Independent Test**: Run the existing installer with either harness
value against a scratch directory; confirm the result matches locations
Warp's own documented Skills discovery convention scans.

**Acceptance Scenarios**:

1. **Given** a scratch directory installed via `--harness claude-code`,
   **When** Warp's documented Skills discovery locations are checked
   against it, **Then** `.claude/skills/<name>/SKILL.md` matches one of
   Warp's own scanned directory names exactly.
2. **Given** the same scratch directory installed via `--harness
   codex-cli`, **When** checked against Warp's documented locations,
   **Then** `.agents/skills/<name>/SKILL.md` also matches.
3. **Given** each installed skill's frontmatter, **When** checked against
   Warp's naming requirement (`name` — "typically kebab-case" —
   `description`), **Then** all 23 skills already satisfy it.

---

### User Story 2 - The README accurately reflects what's actually true (Priority: P1)

Same discipline as features 016/017 — a stale "Planned" row is
fact-bearing drift this project has caught before.

**Independent Test**: Read the README's table; confirm the Warp row
changed, names both satisfying install paths, and implies no new
dedicated flag.

**Acceptance Scenarios**:

1. **Given** this feature has shipped, **When** a reader checks the
   README, **Then** the Warp row reads "✅ Supported" and explains it's
   satisfied by the existing `claude-code`/`codex-cli` install paths.

---

### User Story 3 - CI proves the claim, not just asserts it (Priority: P1)

Same discipline as features 016/017.

**Independent Test**: Open the PR; confirm a CI job installs via the
existing installer and asserts the result against Warp's specific
documented Skills rules.

**Acceptance Scenarios**:

1. **Given** a PR shipping this feature, **When** CI runs, **Then** a
   job asserts both existing install paths land at locations Warp's own
   documented Skills convention scans, with frontmatter satisfying its
   naming rule.

### Edge Cases

- What if a future Warp documentation change alters its scanned
  directory list? Same disproportionate-machinery reasoning as feature
  017 — this feature verifies the convention as documented on
  2026-07-12, not an automated docs-drift-watcher.
- What if a project already has skills under one of Warp's *other*
  scanned directory names (e.g. `.cursor/skills/`, `.gemini/skills/`)
  from a different tool? Neither existing install path writes to any of
  those — no collision possible, since this feature verifies existing
  targets, it doesn't add new ones.
- This feature is explicitly narrower than the earlier discarded
  "Warp Rules" framing (a flat `AGENTS.md`/`WARP.md` file) — Warp's
  separate Skills system, not its Rules system, is what this feature
  addresses. The two are distinct Warp mechanisms; conflating them was
  the actual mistake this feature's own research corrected before
  writing this spec.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A new CI job MUST verify, after a fresh `--harness
  claude-code` install, that every installed skill's location and
  frontmatter satisfies Warp's documented Skills discovery convention
  (path under `.claude/skills/<name>/SKILL.md`; `name` and `description`
  present).
- **FR-002**: The same CI job (or a companion one) MUST perform the
  equivalent check for the `codex-cli` install path against
  `.agents/skills/<name>/SKILL.md`.
- **FR-003**: README's "Supported harnesses" table MUST update the Warp
  row from "📋 Planned" to "✅ Supported," explicitly naming which
  existing install path(s) satisfy it — never implying a new, separate
  `--harness warp` flag exists when none was built.
- **FR-004**: This feature MUST NOT add any new code path to
  `scripts/install.sh`/`.ps1` — same internal-redundancy discipline as
  feature 017's own FR-004.

### Key Entities

- **Harness Satisfaction Claim** (extends feature 017's data model):
  Warp is the second harness whose own Skills discovery requirement is a
  strict subset of what already exists.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A real CI job confirms, on every OS this project supports,
  that the existing install output satisfies Warp's documented Skills
  convention exactly.
- **SC-002**: README accurately reflects the new status with no new
  installer flag implied that doesn't exist.
- **SC-003**: Zero new lines added to `scripts/install.sh`/`.ps1`,
  verified via `git diff`.

## Assumptions

- Warp's Skills discovery convention and `SKILL.md` format are taken as
  verified from Warp's own official documentation
  (`docs.warp.dev/agent-platform/capabilities/skills/`, fetched
  2026-07-12) — `research.md` records both this citation and the initial,
  corrected finding from Warp's separate Rules documentation, since
  getting that distinction right (and documenting the correction) is
  itself part of this feature's grounding discipline.
- This feature does not attempt to actually run Warp itself — same
  honest scoping as features 016/017.
- No `specjedi-*` skill content requires modification — format and
  naming already verified compliant before this spec was written.
