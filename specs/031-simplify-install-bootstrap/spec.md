# Feature Specification: Simplify README Installation to Bootstrap-Only

**Feature Branch**: `031-simplify-install-bootstrap`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description: "a seção de instalação deve ser apenas usando
scripts/bootstrap-install.sh e não mais fazendo clone do repositório,
simplifique o passo da instalação deixando apenas este caso no README pois
ele é mais fácil."

## Clarifications

### Session 2026-07-13

- Q: The current README uses a Mermaid flowchart + numbered steps for the
  install flow. FR-006 says the flowchart/steps must be updated or
  removed, but doesn't decide which. Should the simplified section keep
  a (reduced) flowchart + numbered steps, or collapse to a minimal
  command-block-plus-prose format with neither? → A: Collapse to minimal
  format — command block(s) plus 1-2 lines of prose, no Mermaid
  flowchart, no numbered step list.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Install with a single command, no clone (Priority: P1)

A newcomer reads README.md's Installation section and installs Spec Jedi
into their own project by running exactly one command (bash) or one
command (native PowerShell) — no `git clone` step, no separate "open the
folder," no distinguishing between "using it in this repo" versus "using
it in another project."

**Why this priority**: This is the entire ask — today's Installation
section presents three different paths (open a clone directly in Claude
Code; clone and run `install.sh` against another project; or run
`bootstrap-install.sh` with no clone at all). Collapsing to the single
simplest path is the feature's whole value.

**Independent Test**: Read only the Installation section from top to
bottom and confirm a working install is reachable by copy-pasting one
command block, with zero `git clone` commands appearing anywhere in that
section.

**Acceptance Scenarios**:

1. **Given** a reader on Linux or macOS, **When** they copy the single
   bash command shown in Installation, **Then** it downloads and runs
   the bundled installer against their target project without any prior
   clone step.
2. **Given** a reader on native Windows PowerShell, **When** they copy
   the single PowerShell command shown in Installation, **Then** it
   behaves identically to the bash path (Principle XIII parity).
3. **Given** a reader who wants a specific harness other than the
   default, **When** they look at the Installation section, **Then**
   `--harness`/`--auto` usage and a pointer to the full Supported
   harnesses table are still present and correct.

---

### User Story 2 - Honest behavior before the first release ships (Priority: P2)

A reader runs the one-liner today, before this project's own first
GitHub Release has been cut, and gets a clear, actionable explanation of
why nothing installed yet — not a cryptic curl/API error, and not a
README that silently promised something that can't work yet.

**Why this priority**: `scripts/bootstrap-install.sh`/`.ps1` already
implement this honest-failure path (feature 024) — printing a
"no release found" message plus a `git clone` fallback command. This
story exists to confirm the simplified README doesn't need to duplicate
that guidance in prose, and doesn't accidentally claim a stronger
guarantee than what actually happens today.

**Independent Test**: With no GitHub Release published (the current,
real state of this repository), run the one-liner exactly as shown in
the simplified README and confirm the resulting terminal output alone —
without consulting the README again — tells the reader what to do next.

**Acceptance Scenarios**:

1. **Given** no release has been published yet, **When** a reader runs
   the simplified README's one-liner, **Then** the script's own existing
   output names the problem and states the `git clone` fallback command,
   with no changes needed to that script for this feature.
2. **Given** the README no longer shows a `git clone` command anywhere,
   **When** a reader hits the "no release" case, **Then** they still have
   a working recovery path (the script's own printed fallback), so the
   simplification does not leave them with zero recourse.

---

### Edge Cases

- What happens to the "open a clone of this repo directly in Claude
  Code" flow (today's first Installation subsection), which is really
  how a *contributor developing Spec Jedi itself* works, not how an
  end-user installs Spec Jedi into their own project? → Removed from
  README's Installation section (wrong audience per "Who this is for");
  that workflow belongs in `CONTRIBUTING.md` if it needs documenting at
  all, out of scope for this feature.
- What happens to the existing "clone this repo, then run
  `scripts/install.sh` against another project" flow? → Removed; fully
  superseded by the bootstrap one-liner, which does the same thing
  without the clone step.
- What happens to the Installation-section Mermaid flowchart and the
  four-step numbered walkthrough that currently describe the clone-based
  flow? → Both are removed entirely (not reduced) — a single-command
  flow doesn't need a diagram or a step list to explain it (see
  Clarifications, Session 2026-07-13).
- What happens to harness-selection guidance (`--harness`, `--auto`),
  which is orthogonal to "clone vs. bootstrap"? → Stays, since it's still
  required and unrelated to this simplification.
- What happens for a user who already has a local checkout for some
  other reason (e.g., a contributor)? → Not this feature's concern;
  `scripts/install.sh` run directly from a checkout remains available and
  documented in `CONTRIBUTING.md`'s contributor-facing material, just not
  promoted in the end-user-facing Installation section anymore.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: README.md's Installation section MUST present
  `scripts/bootstrap-install.sh` (bash) and `scripts/bootstrap-install.ps1`
  (native PowerShell) as the only installation method shown — no
  `git clone` command MUST appear anywhere in that section.
- **FR-002**: The simplified section MUST retain OS-labeled command
  blocks for both bash (Linux/macOS/WSL/Git Bash) and native PowerShell
  (Windows), per Constitution Principle XIII's cross-platform parity
  requirement — the bootstrap one-liners already documented elsewhere in
  today's README are the source for this content.
- **FR-003**: The simplified section MUST retain `--harness`/`--auto`
  usage guidance and a working link to the Supported harnesses table —
  harness selection is unrelated to the clone-vs-bootstrap question and
  is still required.
- **FR-004**: The simplified section MUST NOT restate the "no GitHub
  Release published yet" failure path in README prose; the already-
  shipped script behavior (feature 024) — which prints its own honest
  explanation and `git clone` fallback command at run time — is the
  single source of truth for that case, avoiding two places that could
  drift out of sync.
- **FR-005**: The existing "Claude Code (fully supported today)"
  clone-and-open subsection, and the existing "clone this repo, then run
  `install.sh` against another project" subsection, MUST both be removed
  from the Installation section.
- **FR-006**: The Installation section MUST collapse to a minimal
  command-block-plus-prose format — the command block(s) plus 1-2 lines
  of prose — with no Mermaid flowchart and no numbered step list.
  Today's install-flow flowchart and numbered walkthrough steps MUST be
  removed entirely rather than reduced, and any anchor links elsewhere
  in the README pointing at removed subsections MUST be updated so
  nothing dangles or contradicts the simplified flow.
- **FR-007**: This feature's scope is README.md (English, canonical)
  only. The ten localized translations (Constitution Principle I) follow
  their own existing whole-project localization cadence (Development
  Workflow section) — re-translating them is explicitly not a task this
  feature performs.

### Key Entities

*(Not applicable — this is a documentation-only change with no data
entities.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The Installation section contains exactly two command
  blocks total (one bash, one PowerShell) as the installation method —
  down from today's three distinct paths (clone-and-open, clone-and-
  install, bootstrap) with their own command blocks each.
- **SC-002**: Zero occurrences of `git clone` appear inside the
  Installation section after the change.
- **SC-003**: A reader can go from "start of Installation section" to
  "has run the install command" without needing to read past the first
  command block shown — no branching decision ("are you already in a
  clone? are you installing into another project?") required before
  acting.
- **SC-004**: `scripts/validate.sh` continues to pass after the edit —
  no broken internal anchor links, no leftover reference to a removed
  subsection.

## Assumptions

- The Installation section's audience is end-users installing Spec Jedi
  into their own project (per README's existing "Who this is for"
  section) — not contributors developing Spec Jedi itself, who have
  their own, separately-documented workflow in `CONTRIBUTING.md`.
- Relying on `scripts/bootstrap-install.sh`/`.ps1`'s own existing,
  already-shipped honest-failure message (rather than duplicating that
  guidance in README prose) is an accepted, deliberate tradeoff for this
  feature: until this project's first GitHub Release is cut, following
  the simplified README literally will not produce a working install on
  the first try — the recovery path lives in the script's terminal
  output, not in the README text itself. This mirrors the same honesty
  discipline `specs/024-bootstrap-installer/spec.md`'s own "Known
  limitation" section already states for the bootstrap script.
- No changes to `scripts/bootstrap-install.sh`/`.ps1` themselves are
  needed — both already exist, already work, and already handle the
  no-release case honestly (feature 024). This feature only changes
  README.md prose.
- The existing `bootstrap-installer-smoke` CI job already exercises the
  scripts' `--help` output and the real (currently-404) no-release path;
  no new CI coverage is required by this feature's own scope.
