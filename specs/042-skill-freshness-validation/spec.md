# Feature Specification: Skill Freshness Validation & Update Awareness

**Feature Branch**: `042-skill-freshness-validation`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "Principle XXII skill freshness validation — codify a mechanism that validates specjedi-* skills stay fresh/aligned with the current constitution and codebase over time, as introduced by Constitution v1.27.0 Principle XXII (PR #124, merged 2026-07-18)"

## Clarifications

### Session 2026-07-18

- Q: FR-006 requires the freshness check to be a single bounded network attempt that never stalls. bootstrap-install.sh's own curl call has no explicit timeout flag (no cap), so "reuse bootstrap-install's exact timeout" would mean "no cap." Should the freshness check add its own short, explicit timeout instead of literally reusing that unbounded call? → A: Yes — add a short, explicit timeout (e.g. a curl bound of a couple seconds) scoped to session-start's tighter interactive budget, distinct from bootstrap-install.sh's own unbounded call.
- Q: Acceptance scenarios cover "marker behind latest" and "marker matches latest," but not an installed tag and latest release tag that simply differ without a clear ordering (e.g. a pre-release, or a marker that's technically newer). How should "behind" be determined? → A: Exact string mismatch — any marker tag that isn't byte-identical to the latest release tag is reported as behind; no semver/ordering-aware parsing.
- Q: FR-005's silent-degrade list doesn't explicitly mention the marker holding the "local checkout, not an installed release" sentinel from FR-002. Should that state also degrade fully silently, or show something distinct? → A: Fully silent, same as "no marker" — folded into FR-005's existing silent-degrade bucket, no new observable state.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Record which release an install came from (Priority: P1)

A user runs `scripts/install.sh`/`.ps1` (installing into an existing clone)
or `scripts/bootstrap-install.sh`/`.ps1` (downloading a packaged release).
Today, neither script leaves any trace of which release version was
installed. Without that marker, no later freshness check has anything to
compare against — per Constitution Principle XXII, this is an explicit
prerequisite the implementing feature "MUST close first... not an optional
nice-to-have alongside it."

**Why this priority**: P1 by hard dependency, not just importance — User
Story 2 (the actual freshness check) is unbuildable without this marker
existing. Nothing else in this feature can be demonstrated first.

**Independent Test**: Can be fully tested by running each installer against
a clean target directory and inspecting the resulting marker file/value —
no session-start hook involvement required.

**Acceptance Scenarios**:

1. **Given** a user runs `bootstrap-install.sh`/`.ps1` against a tagged
   GitHub Release, **When** the install completes, **Then** an
   installed-release marker is written recording that release's tag.
2. **Given** a user runs `install.sh`/`.ps1` directly from a cloned working
   copy of the repository (not a downloaded release tarball), **When** the
   install completes, **Then** the marker records an explicit "local
   checkout, not an installed release" sentinel rather than a fabricated
   version number.
3. **Given** a project installed before this feature shipped, **When** its
   files are inspected, **Then** no marker is present — this absence is the
   expected, valid state for a pre-existing install, not an error condition.

---

### User Story 2 - Session-start freshness line (Priority: P2)

A returning contributor starts a new session in a project with
`specjedi-*` skills already installed. They have no way to know, without
leaving their editor, whether a newer published release exists. The
existing `SessionStart` hook (Principle XXI, `scripts/session-start.sh`/
`.ps1`) already runs an orientation banner every session — this feature
adds one more line to that same hook: a comparison of the installed marker
(User Story 1) against the latest published GitHub Release tag, surfaced
plainly every session, not just once at install time.

**Why this priority**: P2 — delivers the actual user-facing value
("am I current?") but only once User Story 1's marker exists to compare
against. Depends on US1; still independently verifiable given a marker is
present.

**Independent Test**: Can be fully tested by seeding a project with a known
stale marker value, starting a session, and confirming the orientation
output names the specific update path — no live install required, only a
marker file and a reachable (or mocked) GitHub API.

**Acceptance Scenarios**:

1. **Given** an installed marker behind the latest published release,
   **When** a session starts, **Then** the orientation output states the
   project is behind and names `scripts/bootstrap-install.sh`/`.ps1` as the
   one way to update.
2. **Given** an installed marker matching the latest published release,
   **When** a session starts, **Then** the orientation output confirms the
   project is current (or stays silent about staleness — no false "behind"
   claim).
3. **Given** no network access, no marker present, or a rate-limited/
   unreachable GitHub API, **When** a session starts, **Then** the check
   degrades silently to "no freshness line this session" — it MUST NOT
   error, stall, retry indefinitely, or guess a staleness verdict it can't
   confirm.
4. **Given** the freshness check needs to look up the latest release,
   **When** it runs, **Then** it reuses the exact
   `api.github.com/repos/<owner>/<repo>/releases/latest` lookup and
   opportunistic `GITHUB_TOKEN` authentication already implemented in
   `scripts/bootstrap-install.sh`/`.ps1` — it does not reimplement a second,
   competing version-lookup call.

---

### Edge Cases

- What happens when the marker file exists but is malformed or from a
  format this feature doesn't recognize (e.g., hand-edited, or written by
  a future incompatible version of this mechanism)? Treated the same as
  "no marker present" — degrade silently, never error.
- How does the system handle a fork or private mirror where
  `api.github.com/repos/<owner>/<repo>/releases/latest` doesn't resolve to
  a meaningful release stream? Same silent-degrade path as unreachable API
  — no freshness line, no error.
- What happens if `GITHUB_TOKEN` is present but invalid/expired? The
  lookup MUST fall back the same way `bootstrap-install.sh`/`.ps1` already
  falls back for its own release lookup — no new failure mode introduced
  by reusing that logic.
- What happens when a user manually deletes the marker file after a valid
  install? Same as "pre-existing install" (User Story 1, Scenario 3) — no
  freshness line, not an error.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `scripts/bootstrap-install.sh`/`.ps1` MUST write an
  installed-release marker recording the release tag it just installed.
- **FR-002**: `scripts/install.sh`/`.ps1` MUST write a marker too; when run
  directly from a cloned repository rather than a downloaded release, it
  MUST write an explicit "local checkout, not an installed release"
  sentinel instead of a fabricated version.
- **FR-003**: The freshness check MUST run inside the existing
  `SessionStart` hook (`scripts/session-start.sh`/`.ps1`) established by
  Principle XXI — never a second, separate hook registration.
- **FR-004**: The freshness check MUST compare the on-disk marker against
  the latest published GitHub Release tag, using the identical
  `api.github.com/repos/<owner>/<repo>/releases/latest` call and
  `GITHUB_TOKEN` handling already implemented in
  `scripts/bootstrap-install.sh`/`.ps1` — no independent reimplementation
  of that lookup. The comparison MUST be an exact string mismatch (marker
  tag not byte-identical to the latest release tag means "behind") — no
  semver or other ordering-aware parsing.
- **FR-005**: The check MUST be advisory-only: any failure to complete
  cleanly (no network, no marker, rate-limited/unreachable API, malformed
  marker, or a marker holding the "local checkout, not an installed
  release" sentinel from FR-002) MUST degrade silently to no freshness
  line — never block session start, never error loudly, never guess an
  unconfirmed staleness verdict.
- **FR-006**: The check MUST NOT stall or retry indefinitely — a single
  attempt per session bounded by its own short, explicit network timeout
  (distinct from, and shorter than, `bootstrap-install.sh`/`.ps1`'s own
  lookup call, which has no explicit timeout of its own), consistent with
  Principle XX's grounded-output discipline (an unconfirmed claim is worse
  than none).
- **FR-007**: When the installed marker is behind the latest release, the
  orientation output MUST name `scripts/bootstrap-install.sh`/`.ps1` as the
  update path — it MUST NOT invent a second update flow and MUST NOT
  instruct the user to re-clone the whole repository.
- **FR-008**: Both `.sh` and `.ps1` variants of every touched script MUST
  stay behaviorally identical, per this project's existing cross-platform
  parity requirement (Principle XIII, enforced today by
  `cross-platform-parity-guard.sh`/`.ps1`).

### Key Entities *(include if feature involves data)*

- **Installed-release marker**: A small on-disk record (exact file
  format/location is a technical-planning decision, not specified here)
  written at install time, holding either a release tag or the "local
  checkout" sentinel. Read-only from the freshness check's perspective;
  only the two installer scripts (FR-001/FR-002) write it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of installs performed via `bootstrap-install.sh`/`.ps1`
  or `install.sh`/`.ps1` after this feature ships leave a marker on disk
  (a release tag or the explicit local-checkout sentinel) — zero installs
  leave no trace.
- **SC-002**: In a session where the marker is behind the latest published
  release and the GitHub API is reachable, the orientation output surfaces
  an update line naming the correct script in 100% of runs.
- **SC-003**: In a session where the freshness check cannot complete
  cleanly (network unavailable, no marker, API unreachable), session start
  proceeds with zero added latency beyond one bounded lookup attempt, and
  zero error output is shown to the user.
- **SC-004**: Zero new hook registrations are added to satisfy this
  feature — the check ships entirely inside the existing
  `SessionStart` hook.

## Assumptions

- The exact on-disk marker format (plain text file, JSON field, etc.) and
  its path are left to `specjedi-plan`'s technical design — this spec
  fixes the observable behavior (FR-001/002/003/004), not the file layout.
- "Latest published GitHub Release" means the `releases/latest` endpoint's
  result at session-start time, matching the semantics
  `bootstrap-install.sh`/`.ps1` already relies on — no separate
  release-channel concept (e.g., pre-releases, nightly builds) is in scope.
- A single bounded network attempt (FR-006) means one HTTP request with a
  short, explicit timeout of its own — `bootstrap-install.sh`/`.ps1`'s
  existing lookup call has no explicit timeout, so this feature introduces
  a new, independently-tuned (and shorter) timeout value scoped to
  session-start's tighter interactive latency budget, rather than
  literally reusing bootstrap-install's uncapped call.
- This feature does not cover *skill content* drift against the
  constitution (e.g., "has `specjedi-plan` been updated to reflect
  Principle XXII itself") — Principle XXII's own text scopes this strictly
  to release-version freshness, not skill-content-vs-constitution
  alignment; that broader concern is out of scope for this spec.
