# Feature Specification: Expand the Release Package's Contents

**Feature Branch**: `038-expand-release-package`

**Created**: 2026-07-14

**Status**: Draft

**Input**: User description: "o pacote de release deve conter todas as
skills specjedi-*, documentacao de uso, possíveis scripts utilitários que
serão uteis para o usuário para a criaçao de hooks conforme harness, evite
adiconar arquivos que só serviram de spec para criacao de specjedi,
imagine que este arquivo será baixado pelo script
@scripts/bootstrap-install.sh, orquestre toda a mudança necessária,
planeje, crie tasks e implemente"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A user downloads the package and can actually learn how to use it (Priority: P1)

A user runs `bootstrap-install.sh`/`.ps1` against a project with no local
clone of Spec Jedi. Today the downloaded tarball contains only the skills,
four runtime templates, the installer scripts, and `LICENSE` — no
explanation of what SDD is, what the skills do together, or how the
9-stage pipeline flows. The user is left to either guess from skill
frontmatter or go find the GitHub repo's README separately.

**Why this priority**: Without this, every other improvement in this
feature is invisible — a user who can't find out how to use what they
just installed gets no value from the other stories either. P1 by
elimination as well as by value.

**Independent Test**: Given a freshly built release tarball, when a user
extracts it without ever visiting the GitHub repo, then they can find and
read a top-level explanation of what Spec Jedi is, what SDD is, and the
full skill-by-skill walkthrough — entirely from files already on disk.

**Acceptance Scenarios**:

1. **Given** a freshly extracted release tarball, **When** the user opens
   it, **Then** a `README.md` at the tarball root explains what Spec Jedi
   is and how to get started.
2. **Given** the same tarball, **When** the user wants the full skill
   catalog and pipeline walkthrough beyond the README's condensed version,
   **Then** a `references/quickstart-guide.md` is present and its internal
   link back to the README (`../README.md#...`) resolves correctly inside
   the tarball's own directory structure.
3. **Given** the same tarball, **When** the user wants to understand SDD
   and Spec Jedi's relationship to it before committing to the workflow,
   **Then** `references/what-is-sdd.md` and `references/specjedi-and-sdd.md`
   are present.

---

### User Story 2 - A user can adapt the session-start hook to their own harness (Priority: P2)

A user installing with a harness other than Claude Code (or even Claude
Code itself) wants their target project to greet them with project status
on session start, the way this project's own `scripts/session-start.sh`/
`.ps1` does — but that pair of scripts isn't in the release package today,
and nothing explains how the hook mechanism this repo built for itself
could be adapted to a different harness's own automation/hook system
(where one exists).

**Why this priority**: Valuable and directly named in the request, but
strictly additive on top of User Story 1 — a user can already get real
value from the skills and docs alone without this. P2, not P1.

**Independent Test**: Given a freshly built release tarball, when a user
looks for a working example of a session-start hook plus guidance on
adapting it, then `scripts/session-start.sh`/`.ps1` and a reference
document explaining the mechanism and its harness-specific adaptation
points are both present — independent of whether User Story 1's docs are
read first.

**Acceptance Scenarios**:

1. **Given** a freshly extracted release tarball, **When** the user
   inspects `scripts/`, **Then** `session-start.sh` and `session-start.ps1`
   are present alongside `install.sh`/`.ps1`.
2. **Given** the same tarball, **When** the user reads the new hooks
   reference document, **Then** it names the exact Claude Code
   `.claude/settings.json` registration this repo uses as a concrete,
   working example, and states honestly — never fabricates — which of the
   other 19 supported harnesses are known to have an equivalent
   user-configurable hook/automation mechanism versus not.

---

### User Story 3 - The package never ships this project's own internal spec-authoring history (Priority: P1)

A maintainer builds a release and wants confidence that the artifact a
user downloads only contains what a *user* of Spec Jedi needs — never the
`specs/*` directory (this project's own SDD paper trail for building
itself), nor internal skill-authoring/governance references that only
matter to someone extending Spec Jedi's own skill catalog.

**Why this priority**: A regression here isn't just clutter — it ships
this project's internal working history to every user, and blurs the line
between "using Spec Jedi" and "developing Spec Jedi." Tied with User
Story 1 for P1 as a correctness guarantee, not an enhancement.

**Independent Test**: Given a freshly built release tarball, when its
full file listing is inspected, then it contains zero files from `specs/`,
and zero of the specifically-excluded internal-authoring reference docs
(see FR-006) — checkable by `tar -tzf` against an explicit denylist,
independent of what User Stories 1 and 2 add.

**Acceptance Scenarios**:

1. **Given** a freshly built release tarball, **When** its contents are
   listed, **Then** no path begins with `specs/`.
2. **Given** the same tarball, **When** its contents are listed, **Then**
   none of `references/skill-authoring-standard.md`,
   `references/skill-validation-testing-framework.md`,
   `references/star-wars-lexicon.md`, `references/skill-roadmap.md`,
   `references/mermaid-diagram-catalog.md`,
   `references/principle-traceability.md`,
   `references/genuine-contributions-log.md`,
   `references/competitive-comparison.md`,
   `references/honest-assessment.md`,
   `references/security-question-bank.md`, or
   `references/harness-capability-notes.md` are present.

### Edge Cases

- What happens if a `references/*.md` file included in the package links
  (relatively) to a file this feature deliberately excludes? The link
  would 404 inside the extracted tarball even though it resolves fine in
  the full source repo. Every included file's relative links MUST be
  checked before inclusion; a file with an unavoidable dangling link to
  excluded content is either excluded too, or the link is documented as a
  known "see the full repo on GitHub" pointer rather than silently left
  broken.
- What happens when a new `references/*.md` file is added to the repo in
  the future — should it be included by default or excluded by default?
  Resolved as an explicit allowlist (FR-005), not a denylist: a new
  reference doc is excluded from the package by default until someone
  deliberately adds it to the allowlist, so the package can't silently
  balloon with internal-authoring content again.
- What happens to `CONTRIBUTING.md`? It documents how to contribute
  *changes back to the Spec Jedi source repository itself* (branch/PR
  workflow, research requirements) — not how to *use* an installed
  Spec Jedi in a target project. Out of scope for "usage documentation";
  deliberately excluded (see Assumptions).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The release package MUST continue to contain every shipped
  `specjedi-*` skill directory under `.claude/skills/`, unchanged from
  current behavior.
- **FR-002**: The release package MUST continue to contain the four
  runtime templates under `.specify/templates/`, `scripts/install.sh`,
  `scripts/install.ps1`, and `LICENSE`, unchanged from current behavior.
- **FR-003**: The release package MUST additionally contain `README.md`
  at its root.
- **FR-004**: The release package MUST additionally contain
  `references/quickstart-guide.md`, `references/what-is-sdd.md`, and
  `references/specjedi-and-sdd.md` under a `references/` directory at its
  root, preserving the same relative path these files have in the source
  repo so their existing relative links (e.g., back to `../README.md`)
  keep resolving correctly.
- **FR-005**: The set of included `references/*.md` files MUST be an
  explicit allowlist maintained in the packaging scripts (not "every file
  in the directory"), so a future internal-authoring reference doc added
  to the repo is excluded by default rather than shipped automatically.
- **FR-006**: The release package MUST NOT contain any path under
  `specs/`, and MUST NOT contain `CONTRIBUTING.md` or any of the
  internal-authoring reference docs named in User Story 3's Acceptance
  Scenario 2.
- **FR-007**: The release package MUST additionally contain
  `scripts/session-start.sh` and `scripts/session-start.ps1`.
- **FR-008**: A new reference document MUST explain the session-start
  hook mechanism (what it does, the exact `.claude/settings.json`
  registration this repo uses as a working Claude Code example) and MUST
  honestly state, harness by harness, which of the 20 supported harnesses
  are known (from `references/harness-capability-notes.md`'s own existing
  research, already excluded from the package itself per FR-006 but
  usable as a source) to expose an equivalent user-configurable hook or
  automation mechanism versus which are unknown/unconfirmed — never a
  blanket claim that the hook works identically everywhere.
- **FR-009**: `scripts/install.sh`/`.ps1` MUST NOT be changed to
  automatically configure any hook in the target project — this feature
  ships the utility scripts and documentation for a user to adopt
  manually; automatic hook configuration for one or more harnesses is
  explicitly out of scope (see Assumptions).
- **FR-010**: `scripts/package-release.sh` and `scripts/package-release.ps1`
  MUST both implement the expanded contents identically (Constitution
  Principle XIII) — a diff of their staged output for the same version
  string MUST be empty.
- **FR-011**: `scripts/validate.sh`/`.ps1` or the CI battery MUST gain a
  check that builds a real package for a scratch version string and
  asserts: every FR-001–FR-004/FR-007 path is present in the resulting
  tarball, and every FR-006 path is absent — matching Principle XVIII's
  "validated, not just asserted" standard already applied to the
  installer itself.

### Key Entities

- **Release package allowlist**: the explicit, maintained list (skills
  directory glob, template filenames, script filenames, and the four
  named `references/*.md` files) that `package-release.sh`/`.ps1` stage
  into the tarball — the single source of truth this feature adds to,
  never an implicit "copy everything" rule.
- **Hooks reference document**: the new `references/*.md` file
  documenting the session-start hook mechanism and its per-harness
  adaptation status.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user who extracts the release tarball and never visits
  the GitHub repository can name, from files on disk alone, what SDD is,
  what Spec Jedi does, and which of the 25 skills to run first for a new
  feature.
- **SC-002**: `tar -tzf spec-jedi-<version>.tar.gz` run against a freshly
  built package contains zero paths matching `specs/*` and zero paths
  matching any of the 11 explicitly-excluded internal-authoring files
  named in User Story 3.
- **SC-003**: The same tarball listing contains all of: `README.md`,
  `references/quickstart-guide.md`, `references/what-is-sdd.md`,
  `references/specjedi-and-sdd.md`, `references/<new-hooks-doc>.md`,
  `scripts/session-start.sh`, `scripts/session-start.ps1` — 100% present,
  every build.
- **SC-004**: `scripts/package-release.sh` and `.ps1` produce byte-for-byte
  identical staged file trees (differing only in the outer
  `spec-jedi-<version>` directory name if versions differ) for the same
  version input.

## Assumptions

- "Documentação de uso" (usage documentation) is scoped to files that
  help a user understand and use an *installed* Spec Jedi — `README.md`
  plus the three named user-facing `references/*.md` files. It excludes
  `CONTRIBUTING.md` (governs contributing to the Spec Jedi source repo
  itself) and every reference doc whose actual audience is someone
  authoring or validating a new `specjedi-*` skill (the skill-authoring
  standard, the validation-testing framework, the Star Wars voice
  lexicon, the skill roadmap, the Mermaid diagram catalog, the principle
  traceability index, the genuine-contributions log, the competitive
  comparison, the honest self-assessment, the security question bank,
  and the harness capability research notes) — these are exactly the
  "files that only served as spec for creating specjedi" the request
  says to avoid, generalized from `specs/*` to this equivalent class of
  `references/*.md` files.
- "Scripts utilitários... para a criação de hooks conforme harness" is
  scoped to *shipping a working reference implementation plus
  documentation a user adapts themselves* (session-start.sh/.ps1 plus a
  new explanatory reference doc), not to *automatically wiring a hook
  into the target project* during install for any harness. Automatic
  per-harness hook installation is a materially larger feature (harness
  detection already exists for skill placement, but hook/automation
  mechanisms are unconfirmed for most of the 20 harnesses per
  `references/harness-capability-notes.md`) and is out of scope here.
- `bootstrap-install.sh`/`.ps1` themselves are not bundled inside the
  package they download — a user runs the bootstrap script to *obtain*
  the package; including a copy of it inside the package it fetches adds
  no value and isn't requested.
- `recommended-companions.md` is not added to the package: it recommends
  companion *tools* (rtk, graphify) for developing *within* the Spec Jedi
  source repo's own workflow, not for using an installed target project,
  and is therefore treated as adjacent to CONTRIBUTING.md's excluded
  category rather than as user-facing usage documentation.
