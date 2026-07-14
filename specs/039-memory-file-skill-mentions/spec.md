# Feature Specification: Mention specjedi-* Skills in Each Harness's Memory File

**Feature Branch**: `039-memory-file-skill-mentions`

**Created**: 2026-07-14

**Status**: Draft

**Input**: User description: "inclua no script de instalação das skills
saber configurar o Claude.md mencionando o uso das skills specjedi caso
não exista, ou atualize para isso. Faça a mesma analogia para os outros
harness para fazer de forma análoga para estes."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - `CLAUDE.md` mentions the installed skills, whether it existed before or not (Priority: P1)

A user installs Spec Jedi with `--harness claude-code` (or via
auto-detection) into a project that either has no `CLAUDE.md` yet, or
already has one full of the user's own project-specific instructions
(build commands, coding conventions, etc.). Today, `install.sh`/`.ps1`
copy `.claude/skills/specjedi-*/` but never touch `CLAUDE.md` at all —
unlike every "bridge" harness (Cursor, Windsurf, etc.), which already
gets a generated file explicitly listing the installed skills and how to
use them. Claude Code natively scans `.claude/skills/`, but nothing in
the project's own primary context file tells it these skills exist.

**Why this priority**: `claude-code` is the harness this project ships
with the deepest testing and the README's own default install path — the
gap is most visible here, and the fix pattern this story establishes
(idempotent, marker-delimited section injection into a file the
installer doesn't own) is exactly what Stories 2/3 reuse. P1 by
elimination and by value.

**Independent Test**: Given a target directory with no `CLAUDE.md`, when
`install.sh --harness claude-code` runs, then a new `CLAUDE.md` is
created mentioning the specjedi-* skills. Given a *second* target
directory with a pre-existing `CLAUDE.md` containing unrelated
user content, when the same install runs, then that content is fully
preserved and a clearly-delimited Spec Jedi section is appended.
Given a third run of the installer against either target (skill set
unchanged), then the file is unchanged byte-for-byte (idempotent, no
duplicate section).

**Acceptance Scenarios**:

1. **Given** a target directory with no `CLAUDE.md`, **When**
   `install.sh --harness claude-code` runs, **Then** `CLAUDE.md` is
   created containing a marker-delimited section listing the installed
   `specjedi-*` skills and pointing to `specjedi-onboard` for a first-run
   walkthrough.
2. **Given** a target directory whose `CLAUDE.md` already contains
   unrelated project instructions (e.g., "Run tests with `pytest`"),
   **When** the installer runs, **Then** that existing content is
   byte-for-byte preserved and the Spec Jedi section is appended after
   it, inside its own start/end markers.
3. **Given** a target directory already installed once (its `CLAUDE.md`
   already has the Spec Jedi section from a prior run), **When** the
   installer runs again with no skill-set changes, **Then** `CLAUDE.md`
   is byte-for-byte identical to before the re-run — the existing marked
   section is replaced with itself, never duplicated.
4. **Given** a target directory already installed once, **When** the
   installed skill set changes (e.g., a new `specjedi-*` skill ships)
   and the installer re-runs, **Then** only the content between the
   markers changes to reflect the new skill list — everything outside
   the markers (the user's own content) is untouched.

---

### User Story 2 - The same treatment for Codex CLI's `AGENTS.md` and Trae's `.trae/rules/project_rules.md` (Priority: P2)

A user installs with `--harness codex-cli` or `--harness trae` — both
"skills-dir" harnesses like `claude-code`, both with a confirmed,
separate project-memory-file convention distinct from their skills
directory (`AGENTS.md` for Codex CLI, per
`references/harness-capability-notes.md`'s citation of Codex CLI's
hierarchical `AGENTS.md` discovery; `.trae/rules/project_rules.md` for
Trae, per the same document's Trae row). Today neither is touched,
exactly the same gap as Story 1's `CLAUDE.md` case.

**Why this priority**: Same real gap, same fix pattern as Story 1, but
lower-traffic install paths than `claude-code` — P2, not tied for P1.

**Independent Test**: Given a target directory with no `AGENTS.md`, when
`install.sh --harness codex-cli` runs, then `AGENTS.md` is created
mentioning the specjedi-* skills — independently checkable without
Story 1's `CLAUDE.md` logic ever running. Same independent test shape for
`--harness trae` and `.trae/rules/project_rules.md`.

**Acceptance Scenarios**:

1. **Given** a target directory with no `AGENTS.md`, **When**
   `install.sh --harness codex-cli` runs, **Then** `AGENTS.md` is
   created with the same marker-delimited section pattern Story 1
   establishes.
2. **Given** a target directory with a pre-existing `AGENTS.md`
   containing unrelated content, **When** the installer runs, **Then**
   that content is preserved and the section is appended, exactly
   mirroring Story 1's Acceptance Scenario 2.
3. **Given** a target directory with no `.trae/rules/project_rules.md`,
   **When** `install.sh --harness trae` runs, **Then** the file (and its
   parent `.trae/rules/` directory) is created with the same pattern.

---

### User Story 3 - Antigravity and the 14 bridge harnesses are handled honestly, not silently duplicated or invented (Priority: P3)

A user installs with `--harness antigravity` or any of the 14 bridge
harnesses (Cursor, Windsurf, Copilot, Gemini CLI, etc.). Antigravity has
no confirmed separate memory-file convention beyond `.agents/skills/`
itself (`references/harness-capability-notes.md` documents only the
skills-directory mechanism for it) — inventing one would be a fabricated
capability claim (Constitution Principle XX). The 14 bridge harnesses
already get an equivalent, skill-listing file today via the existing
bridge-file generation (`install.sh`'s `bridge_mode` logic) — running
this feature's new logic on top of them would risk a redundant or
conflicting second file.

**Why this priority**: Correctness/non-regression guarantee, not new
value delivered — P3, the lowest priority, but still independently
verifiable and still required so this feature doesn't quietly break or
duplicate something that already works.

**Independent Test**: Given a target directory, when
`install.sh --harness antigravity` runs, then no new memory file is
created or claimed. Given a target directory, when
`install.sh --harness cursor` (or any other bridge harness) runs, then
its existing bridge-file output is unchanged from before this feature —
checkable via `diff` against this feature's own pre-implementation
output for the same input.

**Acceptance Scenarios**:

1. **Given** a target directory, **When**
   `install.sh --harness antigravity` runs, **Then** only
   `.agents/skills/specjedi-*/` is created — no new file, and no message
   claiming a memory file was configured.
2. **Given** a target directory, **When** `install.sh --harness cursor`
   runs (representative of all 14 bridge harnesses), **Then** the
   `.cursor/rules/*.md` bridge files it already generates are unchanged
   in content and count from this feature's baseline.

### Edge Cases

- What happens if the target `CLAUDE.md`/`AGENTS.md`/
  `.trae/rules/project_rules.md` already has a Spec Jedi section, but the
  markers were hand-edited or corrupted (e.g., only a start marker, no
  end marker present)? The installer MUST fail loudly and explain the
  problem rather than guessing where the section ends and silently
  corrupting surrounding user content — see FR-005.
- What happens on a completely fresh, empty target directory (no
  `CLAUDE.md` and no other files) for `--harness claude-code`? The file
  is created containing only the Spec Jedi section — no assumption that
  a "rest of the file" exists.
- What happens if the user manually deletes the memory file between
  installer runs? Treated identically to "file doesn't exist yet" (User
  Story 1, Acceptance Scenario 1) — the installer doesn't track prior
  runs outside the file itself.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `install.sh`/`.ps1` MUST create `CLAUDE.md` at the target
  directory root when installing with `--harness claude-code` (or
  auto-detected to `claude-code`) if it doesn't already exist, containing
  a clearly delimited section listing the installed `specjedi-*` skills
  (name + one-line description, matching the existing bridge-file
  table format) and pointing to `specjedi-onboard`.
- **FR-002**: If `CLAUDE.md` already exists, the installer MUST preserve
  every byte of existing content outside the Spec Jedi section and
  append the section (wrapped in unambiguous start/end HTML-comment
  markers, e.g. `<!-- SPEC-JEDI:SKILLS:START -->` /
  `<!-- SPEC-JEDI:SKILLS:END -->`) rather than overwriting the file.
- **FR-003**: Re-running the installer against a target that already has
  the Spec Jedi section MUST be idempotent: the region between the
  markers is replaced with freshly generated content (reflecting the
  current skill set), and content outside the markers is never touched.
  A re-run with no skill-set change MUST leave the file byte-for-byte
  unchanged.
- **FR-004**: The same create-if-missing / append-if-existing /
  idempotent-update behavior (FR-001–FR-003) MUST apply to `AGENTS.md`
  for `--harness codex-cli` and to `.trae/rules/project_rules.md` (with
  its parent directory created if needed) for `--harness trae`.
- **FR-005**: If a target file has a start marker with no matching end
  marker (or vice versa), the installer MUST exit non-zero with a clear
  error naming the file and the corruption, and MUST NOT attempt to
  guess a repair or write to the file.
- **FR-006**: The installer MUST NOT create or claim to configure any
  memory file for `--harness antigravity` — no confirmed separate
  memory-file convention exists for it per
  `references/harness-capability-notes.md`.
- **FR-007**: This feature MUST NOT modify the existing bridge-file
  generation logic (the 14 bridge harnesses' `dir`/`single`/`devin`/
  `cody` modes) — their current output already satisfies this feature's
  intent and stays exactly as it is today.
- **FR-008**: `scripts/install.sh` and `scripts/install.ps1` MUST
  implement identical marker-injection logic and produce identical
  output for the same input (Constitution Principle XIII).
- **FR-009**: `.github/workflows/validate.yml` MUST gain CI coverage
  proving all four Acceptance Scenarios of User Story 1 for real (fresh
  file creation, preservation of pre-existing content, idempotent
  re-run, skill-set-change update) — not asserted in docs alone
  (Constitution Principle IX), on all three OSes for both `install.sh`
  and `install.ps1`.

### Key Entities

- **Spec Jedi memory-file section**: the marker-delimited block injected
  into `CLAUDE.md`/`AGENTS.md`/`.trae/rules/project_rules.md` — owned
  and regenerated by the installer; everything outside its markers is
  the target project's own content and is never touched.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user with no `CLAUDE.md` who installs with
  `--harness claude-code` has a `CLAUDE.md` naming the specjedi-*
  skills, with zero manual steps.
- **SC-002**: A user with an existing, non-trivial `CLAUDE.md` who
  installs loses zero bytes of their existing content — verified by a
  CI check diffing the file's pre-existing content against what remains
  outside the markers post-install.
- **SC-003**: Running the installer twice in a row against the same
  target with no skill-set change produces a byte-identical
  `CLAUDE.md`/`AGENTS.md`/`.trae/rules/project_rules.md` both times.
- **SC-004**: `scripts/install.sh` and `scripts/install.ps1` produce
  identical marker-section content for the same skill set and target
  state, verified by a CI diff.

## Assumptions

- "Claude.md" in the request refers to Claude Code's real project-memory
  file, which this project and its own tooling consistently name
  `CLAUDE.md` (matching the casing already used throughout this
  repository's own `CLAUDE.md`, `references/*.md`, and skill content).
- "Faça a mesma analogia para os outros harness" (do the same for the
  other harnesses) is scoped to harnesses with a **confirmed** separate
  memory-file convention distinct from their skills directory —
  `codex-cli` (`AGENTS.md`) and `trae`
  (`.trae/rules/project_rules.md`), both already documented in
  `references/harness-capability-notes.md`. It excludes `antigravity`
  (no confirmed separate convention — see User Story 3) and the 14
  bridge harnesses, whose existing generated bridge file already serves
  the same purpose (explicitly listing installed skills and how to use
  them) — building a second, separate memory-file mechanism for those
  would duplicate, not extend, existing behavior.
- `opencode`/`warp` have no dedicated `--harness` value (satisfied today
  by installing with `claude-code` or `codex-cli`, per the README's
  compatibility table) — whichever memory-file handling this feature
  adds for `codex-cli` (`AGENTS.md`) transitively covers them too, since
  both harnesses are independently documented to read `AGENTS.md`
  (`references/harness-capability-notes.md`). No separate code path
  needed.
- The marker format mirrors the HTML-comment convention the existing
  bridge-file generation already uses ("Managed by Spec Jedi's
  installer... Re-running the installer regenerates this file"),
  adapted to a start/end pair since this feature edits *part* of a file
  the installer doesn't fully own, rather than owning the whole file the
  way bridge files do.
