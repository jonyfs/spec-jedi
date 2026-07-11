# Feature Specification: `specjedi-tokencheck`

**Feature Branch**: `012-specjedi-tokencheck`

**Created**: 2026-07-11

**Status**: Draft

## Clarifications

### Session 2026-07-11

Run via the actual `/speckit-clarify` skill, one targeted question,
self-resolved per the maintainer's standing instruction to proceed
automatically and document the reasoning rather than pause.

- Q: Principle VIII names both `rtk` and `graphify`, and this project
  already depends on `graphify` for its own knowledge graph
  (`graphify-out/`). Should `specjedi-tokencheck` check for and suggest
  both tools independently, or treat `graphify` as effectively
  first-class (since this project already integrates with it via
  `specjedi-plan`/`specjedi-converge`) and only really "check" for `rtk`?
  → A: Check both independently, with equal treatment. Principle VIII's
  text draws no distinction in obligation between the two — "MUST
  proactively check for and suggest installing/configuring `rtk`... and
  `graphify`..." names both without qualification. This project's own use
  of `graphify` inside `specjedi-plan`/`specjedi-converge` is a downstream
  consumer relationship, not a statement that `graphify`'s own
  installation status is any less worth checking in a *target* project
  the user is scaffolding — those two skills already assume `graphify`
  might not be there ("when one is available"). Treating one tool as
  pre-approved and the other as the "real" check would under-deliver on
  the principle's explicit both-tools text with no textual basis for the
  asymmetry.

**Input**: User description: "Build specjedi-tokencheck, a skill that
mechanizes Constitution Principle VIII (Token-Economy Tooling
Integration): proactively check whether `rtk` and `graphify` are
installed in the current project/session, and if either is missing,
explain what it does and its expected token savings, then offer to walk
through installing it -- never installing or configuring anything without
explicit confirmation first. Currently no specjedi-* skill actually
performs this check; specjedi-plan and specjedi-converge only reference
graphify as an already-installed optimization, never as something to
detect or suggest. This is the same class of gap TODO(INSTALLER) closed
for Principle XVIII and specjedi-release closed for Principle XI."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Detect and suggest a missing companion tool (Priority: P1)

A user is early in a session — typically at first-run onboarding, but
also runnable standalone at any point. `specjedi-tokencheck` checks
whether `rtk` and `graphify` are present. For each tool that's missing,
it explains in one or two sentences what the tool does and the expected
token savings, then offers to walk through installing it — never
installing anything itself without an explicit yes.

**Why this priority**: The entire reason this skill exists — without it,
Principle VIII's mandate stays an unenforced intention no shipped skill
actually carries out.

**Independent Test**: Given a project/session where neither `rtk` nor
`graphify` is detectable on the system, run `specjedi-tokencheck` and
verify it reports both as missing, explains each one's purpose and
expected savings distinctly (not a single generic blurb for both), and
takes no installation action without confirmation.

**Acceptance Scenarios**:

1. **Given** neither `rtk` nor `graphify` is installed, **When**
   `specjedi-tokencheck` runs, **Then** it reports both as missing, each
   with its own purpose and expected-savings explanation, and offers to
   walk through installing either.
2. **Given** both `rtk` and `graphify` are already installed, **When**
   `specjedi-tokencheck` runs, **Then** it reports both as present and
   takes no further action — no redundant suggestion to install something
   that's already there.
3. **Given** only one of the two tools is installed, **When**
   `specjedi-tokencheck` runs, **Then** it reports the installed one as
   present and suggests only the missing one — never re-suggesting the
   tool that's already there.

---

### User Story 2 - Never installs without explicit confirmation (Priority: P2)

A user is offered a missing tool's installation walkthrough and either
declines, ignores the offer, or gives an ambiguous response.
`specjedi-tokencheck` never runs an install/configure command without an
unambiguous yes to that specific tool.

**Why this priority**: Prevents the failure mode of a "helpful" tooling
check that quietly crosses into a shell-level install action — this
project's own standing rule (installation/configuration is never silently
autonomous) applies here exactly as it does to `specjedi-find-skills`'
own skill-install gate.

**Independent Test**: Ask the skill to check tooling, decline the
installation offer, and verify no install command runs and no
configuration file changes.

**Acceptance Scenarios**:

1. **Given** a missing tool's installation is offered, **When** the user
   declines or gives no clear answer, **Then** the skill takes no
   installation action and states the manual install command as a
   next-step reference instead.

### Edge Cases

- Neither tool's presence can be determined (e.g., `which`/`where` isn't
  available in the current environment): the skill states this plainly
  rather than guessing either tool's status.
- The skill runs standalone, outside of `specjedi-onboard`'s first-run
  flow (an existing project adopting Spec Jedi mid-stream): the check
  still runs correctly — this skill's detection logic doesn't assume
  onboarding context.
- A tool is partially present (e.g., `graphify-out/` exists from a prior
  run but the `graphify` CLI itself isn't on `PATH`): the skill reports
  this distinctly rather than collapsing it into a simple present/absent
  binary.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-tokencheck` MUST check whether `rtk` and
  `graphify` are each independently present in the current environment,
  per the Clarifications resolution (equal treatment, no asymmetry).
- **FR-002**: For each tool found missing, `specjedi-tokencheck` MUST
  explain what it does and its expected token savings, grounded in each
  tool's own stated purpose — not a single generic claim covering both.
- **FR-003**: `specjedi-tokencheck` MUST offer to walk through installing
  a missing tool, but MUST NOT run any install or configuration command
  without the user's explicit, unambiguous confirmation for that specific
  tool.
- **FR-004**: `specjedi-tokencheck` MUST NOT suggest installing a tool
  that is already present — a clean, no-action report for tools already
  detected.
- **FR-005**: `specjedi-tokencheck` MUST be proactively self-invoked by
  `specjedi-onboard` during its first-run flow (Principle XVII's
  proactive-contract discipline: a literal, verified self-invoke
  instruction written into `specjedi-onboard`'s own file), and MUST also
  be independently runnable on its own for a session that never went
  through onboarding.
- **FR-006**: `specjedi-tokencheck` MUST report a tool whose presence
  can't be determined (detection mechanism unavailable) as indeterminate,
  never guessing present or absent.

### Key Entities

- **Tooling check result**: one `specjedi-tokencheck` invocation's
  output — each of `rtk`/`graphify`'s detected status (present/missing/
  indeterminate), and for each missing tool, its purpose/savings
  explanation and install offer, with zero installation side effects
  unless explicitly confirmed.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Running `specjedi-tokencheck` against a session with
  neither tool installed reports both as missing with distinct
  purpose/savings explanations for each.
- **SC-002**: Zero install or configuration actions occur from any
  `specjedi-tokencheck` invocation without an explicit confirming
  response naming that specific tool.
- **SC-003**: Running `specjedi-tokencheck` against a session with both
  tools already installed produces a clean report with no install
  offers.

## Assumptions

- This is its own feature cycle — `specjedi-tokencheck` ships alone,
  following the same incremental discipline as every prior feature.
- Detection relies on standard environment lookup mechanisms (e.g.,
  `which`/`where`, or the project's own established `graphify-out/`
  marker convention) — no new dependency is introduced to perform the
  check itself.
- `specjedi-onboard`'s existing first-run flow is the natural proactive
  trigger point; this feature edits `specjedi-onboard/SKILL.md` to wire
  in the self-invoke, matching the precedent already established for
  `specjedi-security`'s wiring into `specjedi-plan`.
