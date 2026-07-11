# Feature Specification: `specjedi-skill-review`

**Feature Branch**: `011-specjedi-skill-review`

**Created**: 2026-07-11

**Status**: Draft

## Clarifications

### Session 2026-07-11

Run via the actual `/speckit-clarify` skill, one targeted question,
self-resolved per the maintainer's standing instruction to proceed
automatically and document the reasoning rather than pause.

- Q: FR-006 lets a skill's own design documentation support a
  chain-of-thought exemption — should `specjedi-skill-review` actively
  locate and read the corresponding `specs/NNN-name/plan.md` for the
  skill under review when one exists, or evaluate the `SKILL.md` file
  purely standalone with no cross-reference? → A: Actively locate and
  read the corresponding `plan.md` when findable (matching the skill's
  own name against `specs/*/plan.md` design sections), citing it as
  supporting evidence for an exemption finding. A standalone-only review
  would force the same false-positive risk the manual 6-skill audit (PR
  #41) already hit and had to correct by hand for `specjedi-status` and
  `specjedi-diagram` — one grep-only pass flagged both as non-compliant
  before a human checked their `plan.md`/actual text and found they were
  either compliant or legitimately exempt. FR-006 and FR-004 (weak vs.
  missing) are both scoped to require this cross-reference, not just a
  standalone text scan.

**Input**: User description: "Build specjedi-skill-review, a skill that audits
an existing specjedi-* skill's SKILL.md against the Skill Authoring & Prompt
Engineering Standard (Constitution Principle XIX) and reports findings --
never silently fixing anything itself. This automates the exact manual
consistency-audit process already performed twice by hand in this project's
own history: the original GROUNDING_PASS/NEXT_STEP_PASS/VOICE_PASS/
PROMPT_ENG_PASS governance TODO passes, and the six-skill consistency audit
(PR #41) after the roadmap backlog shipped. Complements specjedi-new-skill
(which scaffolds a brand-new skill) with a review tool for an already-written
one."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Audit one skill and get a findings report (Priority: P1)

A maintainer names an existing `specjedi-*` skill. `specjedi-skill-review`
reads its `SKILL.md`, checks it against every requirement in the Skill
Authoring & Prompt Engineering Standard (Principle XIX) plus the three other
dimensions the manual audits already established as real signal (Principle
XIV bulleted next-step format, Principle XX explicit chain-of-thought framing
in the actual step text, Principle XII genuine voice beyond decorative
emoji), and reports each finding — file, section, what's missing or weak,
and which principle it maps to. It never edits the reviewed file itself.

**Why this priority**: The entire reason this skill exists — without it, a
maintainer must repeat the exact manual, line-by-line reading process this
project's own history shows was already done twice by hand.

**Independent Test**: Given a shipped skill with a known, previously-fixed
gap re-introduced into a scratch copy (e.g., strip the chain-of-thought
framing sentence out of a copy of `specjedi-docs/SKILL.md`), run
`specjedi-skill-review` against it and verify the report names that exact
gap, citing the correct principle, without modifying the scratch file.

**Acceptance Scenarios**:

1. **Given** a `SKILL.md` missing its Autonomous vs. confirm-first section
   entirely, **When** `specjedi-skill-review` runs against it, **Then** the
   report names the missing section and cites Principle XIX.
2. **Given** a `SKILL.md` that has every required section present but one
   section's content is substantively weak (e.g., a next-step reference
   written as inline prose instead of a bulleted list), **When**
   `specjedi-skill-review` runs, **Then** the report flags the weak content,
   not just section presence — matching the real "section present but weak"
   gap class the manual audits already found (e.g., the original
   `specjedi-docs` chain-of-thought gap, feature 011's own precedent).
3. **Given** a `SKILL.md` that fully satisfies every checked dimension,
   **When** `specjedi-skill-review` runs, **Then** the report states a clean
   pass explicitly rather than silently producing nothing.

---

### User Story 2 - Never modifies the reviewed file (Priority: P2)

A user asks `specjedi-skill-review` to fix an issue it just found. The skill
declines to edit the reviewed `SKILL.md` itself, explains that this tool is
report-only by design, and names the fix as something the user (or a future
manual edit) must apply.

**Why this priority**: Prevents the failure mode of a "helpful" review tool
that silently rewrites a skill's prompt content in ways nobody explicitly
reviewed — the same class of risk this project's own `specjedi-analyze`
(feature 001) already treats as a hard boundary for spec/plan/tasks
consistency review.

**Independent Test**: Ask the skill to fix a finding it just reported and
verify the underlying `SKILL.md` file is byte-for-byte unchanged afterward.

**Acceptance Scenarios**:

1. **Given** a completed review with at least one finding, **When** the user
   asks `specjedi-skill-review` to apply the fix, **Then** it declines,
   states the report-only boundary, and the reviewed file is unchanged.

### Edge Cases

- The named skill doesn't exist under `.claude/skills/`: the skill reports
  this plainly rather than guessing a nearby name or fabricating a review.
- The named target is a `speckit-*` bootstrap skill, not a `specjedi-*`
  product skill: the skill declines, since the Skill Authoring Standard
  (Principle XIX) governs this project's own `specjedi-*` skills, not the
  vendored upstream bootstrap tooling.
- A `SKILL.md` has no judgment calls at all (a fully mechanical skill): the
  chain-of-thought check reports this as a legitimate exemption rather than
  a gap, mirroring the documented `specjedi-status` precedent from the
  6-skill consistency audit (PR #41).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-skill-review` MUST accept the name of one
  `specjedi-*` skill and locate its `SKILL.md` under `.claude/skills/`.
- **FR-002**: `specjedi-skill-review` MUST check the reviewed file against
  every section the Skill Authoring & Prompt Engineering Standard
  (Principle XIX) requires: frontmatter (name/description/compatibility),
  Persona, Task, Step-by-step, Format, worked Example, Autonomous vs.
  confirm-first, `--auto` mode, Always/Never, verifiable success criteria.
- **FR-003**: `specjedi-skill-review` MUST additionally check: bulleted
  next-step format (Principle XIV), explicit chain-of-thought framing
  present in the actual step text for any real judgment call the skill
  makes (Principle XX), and genuine voice beyond decorative header emoji
  (Principle XII).
- **FR-004**: `specjedi-skill-review` MUST distinguish "section missing"
  from "section present but substantively weak" — a naive heading-presence
  check is insufficient, per the precedent gap class found in the manual
  audits.
- **FR-005**: `specjedi-skill-review` MUST NOT edit, fix, or otherwise
  modify the reviewed `SKILL.md` file under any circumstance, including
  when explicitly asked to apply a fix — it reports only.
- **FR-006**: `specjedi-skill-review` MUST actively locate the reviewed
  skill's corresponding `specs/NNN-name/plan.md` (matching by skill name)
  when one exists, and cite it as supporting evidence when a skill with no
  applicable judgment calls is reported as a legitimate chain-of-thought
  exemption rather than a finding — a standalone `SKILL.md`-only scan is
  insufficient (Clarifications session 2026-07-11).
- **FR-007**: `specjedi-skill-review` MUST state a clean pass explicitly
  when a reviewed skill satisfies every checked dimension, rather than
  producing an empty or ambiguous report.
- **FR-008**: `specjedi-skill-review` MUST decline to review a `speckit-*`
  bootstrap skill, stating that Principle XIX governs `specjedi-*` product
  skills, not vendored upstream tooling.

### Key Entities

- **Review finding**: one gap identified in a reviewed `SKILL.md` — the
  file, the section or dimension affected, what's missing or weak, and the
  constitution principle it maps to.
- **Review report**: one `specjedi-skill-review` invocation's complete
  output — either a list of findings or an explicit clean-pass statement,
  covering all checked dimensions, with zero side effects on the reviewed
  file.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Running `specjedi-skill-review` against a skill with a known,
  previously-real gap (e.g., a scratch copy of `specjedi-docs/SKILL.md`
  with its chain-of-thought sentence removed) reproduces that exact finding.
- **SC-002**: Zero edits occur to any reviewed `SKILL.md` file across any
  invocation, including when explicitly asked to apply a fix.
- **SC-003**: Running `specjedi-skill-review` against every currently
  shipped, fully-compliant `specjedi-*` skill produces a clean pass for
  each one (no false positives against skills already known to satisfy the
  standard).

## Assumptions

- This is its own feature cycle — `specjedi-skill-review` ships alone,
  following the same incremental discipline as every prior feature.
- The Skill Authoring & Prompt Engineering Standard
  (`references/skill-authoring-standard.md`) is assumed stable and
  unchanged by this feature — this skill checks against it, it does not
  redefine it.
- One invocation reviews one named skill; batch/all-skills review is out of
  scope for this feature (a natural follow-on, not required here).
