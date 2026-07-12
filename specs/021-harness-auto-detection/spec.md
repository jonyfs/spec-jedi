# Feature Specification: Harness Auto-Detection

**Feature Branch**: `021-harness-auto-detection`

**Created**: 2026-07-12

**Status**: Draft

**Input**: User description: "Sub-Project C of the release/installer decomposition identified during feature 020's brainstorming: scan the target machine/directory for signals of which coding agent(s) are already present, so a user isn't required to already know and pass an explicit --harness value to scripts/install.sh/.ps1. Independent of Sub-Project B (the standalone bootstrap installer, blocked on a real release existing) -- this extends the existing install.sh/.ps1 directly. Explicit --harness always wins outright with zero detection attempted, preserving 100% backward compatibility with every existing CI job. When --harness is omitted: a single detected candidate is used automatically; multiple candidates trigger the project-wide Recommended-option pattern (Constitution Principle IV, v1.22.0) -- prompted interactively when a TTY is available, auto-selecting the Recommended candidate otherwise (non-interactive/CI) or when --auto is passed; zero candidates falls back to today's claude-code default, stated explicitly as a fallback, not a detection."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A user who doesn't know the --harness flag exists still gets a correct install (Priority: P1) 🎯 MVP

A developer clones Spec Jedi and runs `./scripts/install.sh` with no
flags, the same way they'd run most installers. They have Codex CLI
installed and nothing else. Today this silently installs for
`claude-code` (the hardcoded default) regardless of what's actually on
their machine — a wrong-harness install that looks like it worked but
puts skills where nothing reads them.

**Why this priority**: This is the actual value delivered — without it,
omitting `--harness` is a trap that produces a plausible-looking but
useless install for anyone not already on Claude Code.

**Independent Test**: Run `install.sh` with no `--harness` flag against
a scratch directory, with only `codex`'s detection signal present
(e.g. a `codex` binary stubbed onto `PATH`); confirm skills land under
`.agents/skills/`, not `.claude/skills/`.

**Acceptance Scenarios**:

1. **Given** exactly one harness's detection signal is present and
   `--harness` is omitted, **When** the installer runs, **Then** it
   installs for that harness automatically and states which signal it
   detected and why.
2. **Given** `--harness codex-cli` is passed explicitly, **When** the
   installer runs, **Then** it installs for `codex-cli` exactly as it
   does today — zero detection logic runs, zero behavior change from
   before this feature.
3. **Given** zero detection signals are present and `--harness` is
   omitted, **When** the installer runs, **Then** it installs for
   `claude-code` (today's existing default) and explicitly states this
   is a fallback default, not a detected match.

---

### User Story 2 - A user with multiple harnesses installed gets a clear, recommended choice (Priority: P1)

A developer has both Claude Code and Codex CLI installed. Running
`install.sh` with no `--harness` flag hits a genuine ambiguity — the
installer cannot silently guess which one the user actually wants for
*this* project without risking a wrong-but-plausible install.

**Why this priority**: Silently picking one of several equally-valid
matches would be exactly the kind of unstated guess Constitution
Principle IV forbids; this is the feature's core judgment call, not an
edge case bolted on afterward.

**Independent Test**: Run `install.sh` interactively (real TTY) with no
`--harness` flag against a scratch directory where two signals are
present; confirm the installer presents both candidates with one marked
Recommended and a reason, and proceeds only after a choice.

**Acceptance Scenarios**:

1. **Given** multiple detection signals are present, `--harness` is
   omitted, and stdin is a real TTY, **When** the installer runs,
   **Then** it presents the detected candidates as a lettered list, one
   marked **Recommended** with a one-line reason (Constitution Principle
   IV, v1.22.0's project-wide Recommended-option standard), and waits
   for a choice before installing anything.
2. **Given** the same ambiguous-detection scenario, **When** `--auto` is
   passed (or stdin is not a TTY, e.g. running in CI), **Then** the
   installer automatically selects the Recommended candidate, states
   that it did so and why, and proceeds without waiting for input.
3. **Given** an ambiguous-detection scenario resolved via the
   interactive prompt, **When** the user picks a candidate other than
   the Recommended one, **Then** the installer honors that choice exactly
   — the Recommended marking is guidance, never an override.

---

### User Story 3 - Existing CI and scripted usage remain byte-for-byte unaffected (Priority: P1)

Every existing `install-test*` CI job in `.github/workflows/validate.yml`
already calls `install.sh`/`.ps1` with an explicit `--harness` value.
None of them should need to change, and none should behave differently,
after this feature ships.

**Why this priority**: A backward-compatibility regression here would
silently break every harness-support feature already shipped this
session (016, 017, 018, 019) — this is a hard constraint, not aspirational.

**Independent Test**: Re-run every existing `quickstart.md` scenario from
features 016/019 (explicit `--harness` installs) unchanged; confirm
identical output and skill counts to before this feature.

**Acceptance Scenarios**:

1. **Given** any explicit `--harness` value is passed, **When** the
   installer runs, **Then** its behavior, output, and exit code are
   identical to the pre-feature-021 installer for that same invocation.

### Edge Cases

- What happens if a detection signal check itself fails unexpectedly
  (e.g. `PATH` lookup errors on an unusual shell configuration)? The
  installer MUST treat that specific check as "not detected" and
  continue evaluating the others — a single check's failure MUST NOT
  abort the whole detection pass.
- What happens when `--auto` is passed but `--harness` is ALSO passed
  explicitly? The explicit `--harness` value wins outright — `--auto`
  only affects behavior when `--harness` is omitted and detection is
  ambiguous; it is not a general "skip confirmation" flag for anything
  else the installer does.
- What happens on Windows, where `PATH` binary lookups and home-directory
  conventions differ from POSIX? `install.ps1` implements the same
  detection signals using PowerShell-native equivalents (`Get-Command`,
  `$env:USERPROFILE`) — same signals, same priority order, same
  Recommended-selection logic, per Constitution Principle XIII.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `scripts/install.sh`/`.ps1` MUST attempt harness detection
  only when `--harness` is omitted — any explicit `--harness` value
  MUST skip detection entirely and behave exactly as it does today.
- **FR-002**: For each of the three real `--harness` values
  (`claude-code`, `codex-cli`, `trae`), the installer MUST check, in
  priority order: (1) a matching directory already present in the
  target directory (`.claude/`, `.agents/`, `.trae/` respectively); (2)
  a matching CLI binary on `PATH` where one exists (`claude` for
  claude-code, `codex` for codex-cli — `trae` has no CLI-binary check,
  per Edge Cases); (3) a matching global config directory in the user's
  home directory (`~/.claude/`, `~/.codex/`, `~/.trae/`).
- **FR-003**: If exactly one harness has any matching signal, the
  installer MUST install for that harness automatically and print which
  signal it matched.
- **FR-004**: If two or more harnesses have a matching signal, the
  installer MUST rank them by the strongest signal each matched
  (directory-in-target > PATH binary > global config directory) and mark
  the top-ranked one **Recommended** with a stated reason, per
  Constitution Principle IV's project-wide Recommended-option standard.
- **FR-005**: When multiple harnesses are detected and stdin is an
  interactive TTY (and `--auto` was not passed), the installer MUST
  present the candidates as a lettered list with the Recommended one
  marked, and MUST wait for the user's explicit choice before installing
  anything.
- **FR-006**: When multiple harnesses are detected and either `--auto`
  is passed or stdin is not a TTY, the installer MUST automatically
  select the Recommended candidate, state that it did so and why, and
  proceed without waiting for input — this MUST NOT hang indefinitely in
  a non-interactive context (e.g. CI).
- **FR-007**: If zero harnesses have any matching signal, the installer
  MUST fall back to `claude-code` (today's existing default) and
  explicitly state this is a fallback default, not a detected match.
- **FR-008**: A new `--auto` flag MUST be added to both
  `scripts/install.sh` and `.ps1`, affecting only the ambiguous-detection
  resolution described in FR-006 — it MUST NOT change any other
  installer behavior (e.g. it does not skip the existing post-copy
  frontmatter validation).
- **FR-009**: Every existing `install-test*`/`install-test-codex-cli*`/
  `install-test-trae*` CI job (all of which pass explicit `--harness`
  values) MUST continue to pass unchanged, with zero modification to
  those jobs themselves — proving FR-001's backward-compatibility claim
  in CI, not just asserting it.
- **FR-010**: A new CI job MUST prove the detection mechanism itself,
  matrixed across the three supported OSes: stub a single detection
  signal, omit `--harness`, and assert the correct harness was installed
  for; and separately, stub two signals with `--auto`, and assert the
  Recommended one was installed for.

### Key Entities

- **Detection Signal**: one (harness, evidence-type, evidence-location)
  tuple — e.g. (`codex-cli`, `path-binary`, `codex`). Ranked by
  evidence-type per FR-002's priority order.
- **Detection Result**: the outcome of a detection pass — zero signals
  (fallback to `claude-code`), exactly one harness matched across all its
  signals (auto-install), or two-or-more harnesses matched (ambiguous,
  resolved per FR-005/FR-006).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user who omits `--harness` and has exactly one harness's
  signal present gets a correctly-targeted install with zero flags typed.
- **SC-002**: A user with multiple harnesses installed is never silently
  guessed for — they either see an explicit Recommended-marked choice
  (interactive) or an explicitly-stated automatic Recommended selection
  (non-interactive/`--auto`).
- **SC-003**: Every one of the 12+ existing `install-test*` CI jobs
  passes unchanged after this feature ships, proving zero regression to
  explicit-`--harness` usage.
- **SC-004**: The new detection-proving CI job passes on all three
  supported operating systems.

## Assumptions

- Detection signals are best-effort heuristics, not guarantees — a false
  negative (a harness present but undetected) degrades gracefully to
  the existing fallback-to-`claude-code` behavior (FR-007), never to an
  error or a hang.
- `trae` has no reliable cross-platform CLI-binary signal to check
  (it is a GUI-first IDE) — its detection relies on directory signals
  only (target-local `.trae/` and global `~/.trae/`), a narrower signal
  set than `claude-code`/`codex-cli`, documented explicitly rather than
  silently omitted.
- This feature does not attempt to detect any of the 17 harnesses
  without a real `--harness` install path yet (Cursor, Copilot, etc.) —
  detection is scoped to the three harnesses this project can actually
  install for today. Detecting a harness this project can't yet install
  for would produce a result with no useful action to take.
- Verification of the interactive-TTY prompt path (FR-005) is
  necessarily manual/described rather than CI-automated — GitHub Actions
  runners have no real TTY. The non-interactive/`--auto` path (FR-006)
  is what CI actually proves (FR-010), honestly scoped the same way
  every prior CI-proof feature this session was.
