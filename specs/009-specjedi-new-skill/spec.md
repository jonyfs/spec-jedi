# Feature Specification: `specjedi-new-skill`

**Feature Branch**: `009-specjedi-new-skill`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Build specjedi-new-skill, a meta-skill that
scaffolds a new specjedi-* skill's file structure (the
specs/NNN-feature-name/ research.md/spec.md/plan.md/tasks.md set, plus the
.claude/skills/specjedi-name/SKILL.md skeleton) following this project's own
Skill Authoring & Prompt Engineering Standard (Constitution Principle XIX)
and Principle II's competitive-research requirement. This directly
automates the exact scaffolding work that has been done by hand for every
one of the eighteen specjedi-* skills shipped so far in this project, and
is the natural next capability for anyone extending Spec Jedi itself with a
new skill."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Scaffold a new skill's file structure (Priority: P1)

A contributor with an idea for a new `specjedi-*` skill asks
`specjedi-new-skill` to scaffold it. The skill creates the next-numbered
`specs/NNN-specjedi-<name>/` directory with a `spec-template.md`-shaped
`spec.md` pre-filled with the idea's stated scope, plus placeholder
`research.md` (with the Principle II competitive-research checklist
already listed), `plan.md`, and `tasks.md` files, and a
`.claude/skills/specjedi-<name>/SKILL.md` skeleton with every section the
Skill Authoring Standard requires (frontmatter, persona, task, format,
worked example, `--auto` mode, autonomous vs. confirm-first, Always/
Never, verifiable success criteria) — each marked with a clear
placeholder, never invented content.

**Why this priority**: The entire reason this skill exists — without it,
scaffolding a new skill's file set is manual, repetitive work a
contributor has to reconstruct from reading existing examples each time.

**Independent Test**: Given a one-sentence idea for a new skill, run
`specjedi-new-skill` and verify the correct next-numbered `specs/`
directory is created with all four files, the `SKILL.md` skeleton
contains every Skill Authoring Standard section as a labeled placeholder,
and no file claims to be complete when it isn't.

**Acceptance Scenarios**:

1. **Given** a one-sentence description of a new skill idea, **When**
   `specjedi-new-skill` runs, **Then** it creates
   `specs/NNN-specjedi-<name>/` with `research.md`, `spec.md`, `plan.md`,
   and `tasks.md`, each following this project's own established shape
   (matching the structure of `specs/001-specjedi-pipeline/` through
   `specs/008-specjedi-docs/`).
2. **Given** the same scaffold request, **When** the `SKILL.md` skeleton
   is generated, **Then** it includes every section the Skill Authoring
   Standard requires, each clearly marked as a placeholder to fill in —
   not pre-written content presented as finished.

---

### User Story 2 - Never skips the competitive research requirement (Priority: P2)

A contributor scaffolds a new skill and is reminded, prominently, that
Principle II requires benchmarking against spec-kit and at least ten
other SDD tools — including checking this project's *own* already-shipped
skills for redundancy (the precedent `specjedi-security`, feature 007,
established) — before the skill can actually ship.

**Why this priority**: Prevents the failure mode of a scaffolding tool
that makes it easy to generate files but easy to forget the research
discipline that makes those files trustworthy.

**Independent Test**: Scaffold a new skill and verify the generated
`research.md` contains the actual Principle II checklist (spec-kit +
ten competitors + internal-redundancy check + genuine-contribution
requirement) as explicit, unfilled prompts — not just an empty file.

**Acceptance Scenarios**:

1. **Given** a freshly scaffolded feature, **When** the contributor opens
   `research.md`, **Then** it contains the Principle II checklist
   (competitor list to fill in, genuine-contribution question, internal-
   redundancy check against already-shipped `specjedi-*` skills)
   pre-written as prompts, not left blank with no guidance.

### Edge Cases

- A requested skill name collides with an already-shipped `specjedi-*`
  skill: the scaffold declines and says so explicitly, rather than
  silently overwriting an existing skill's files.
- The feature-numbering sequence has a gap or the highest existing number
  can't be determined cleanly: the skill reports what it found and asks
  for confirmation of the next number rather than guessing silently.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-new-skill` MUST create a next-numbered
  `specs/NNN-specjedi-<name>/` directory containing `research.md`,
  `spec.md`, `plan.md`, and `tasks.md`, each matching this project's own
  established structure (the shape already used by features 001-008).
- **FR-002**: `specjedi-new-skill` MUST create a
  `.claude/skills/specjedi-<name>/SKILL.md` skeleton containing every
  section the Skill Authoring & Prompt Engineering Standard (Principle
  XIX) requires, each clearly marked as a placeholder — never pre-written
  content presented as finished.
- **FR-003**: `specjedi-new-skill` MUST pre-populate the scaffolded
  `research.md` with Principle II's actual checklist (spec-kit + at least
  ten competitors, an internal-redundancy check against already-shipped
  `specjedi-*` skills, and the genuine-contribution requirement) as
  explicit prompts.
- **FR-004**: `specjedi-new-skill` MUST decline, with an explanation,
  when the requested skill name collides with an already-shipped
  `specjedi-*` skill.
- **FR-005**: `specjedi-new-skill` MUST NOT write any file content that
  isn't marked as a placeholder — it scaffolds structure, it does not
  invent research findings, design decisions, or skill behavior on the
  contributor's behalf.

### Key Entities

- **Skill scaffold**: one `specjedi-new-skill` invocation's output — a
  `specs/NNN-specjedi-<name>/` directory (four files) plus a
  `.claude/skills/specjedi-<name>/SKILL.md` skeleton, all placeholder
  content clearly marked as such.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A contributor can go from a one-sentence skill idea to a
  complete, correctly-structured scaffold in a single request.
- **SC-002**: Every scaffolded `SKILL.md` contains all Skill Authoring
  Standard sections, verified against
  `references/skill-authoring-standard.md`'s own checklist.
- **SC-003**: Zero scaffolded files contain invented (non-placeholder)
  research findings, design rationale, or behavioral content.

## Assumptions

- This is its own feature cycle, following the same incremental discipline
  as features 001-008 — `specjedi-new-skill` ships alone.
- The scaffold targets this repository's own conventions specifically
  (the `specs/NNN-specjedi-<name>/` + `.claude/skills/specjedi-<name>/`
  shape already established) rather than a generic, project-agnostic
  skill-scaffolding tool — out of scope for v1.
- Numbering follows `.specify/init-options.json`'s configured scheme
  (`sequential` in this repository) — the skill reads that config rather
  than assuming a fixed convention.
