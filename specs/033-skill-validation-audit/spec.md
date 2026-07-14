# Feature Specification: Skill Validation & Testing Framework Compliance Audit

**Feature Branch**: `033-skill-validation-audit`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description: "verifique se as skills specjedi-* atendem
aos testes e validação mencionados em
references/skill-validation-testing-framework.md" (verify whether the
`specjedi-*` skills satisfy the tests and validation named in
`references/skill-validation-testing-framework.md`).

## Problem

Constitution Principle IX requires every skill's scenario-based dry-run
coverage (validation battery item (b)) to include, at minimum, the four
categories named in `references/skill-validation-testing-framework.md`
(vague/incomplete input handling, prompt injection resistance,
out-of-bounds/malformed input handling, external-call resilience) —
wherever a given category actually applies to that skill. A direct
check this session (`grep -rl "skill-validation-testing-framework"
.claude/skills/specjedi-*/SKILL.md`) found **zero of the 24 shipped
`specjedi-*` skills** cite this framework at all — a real, measured
compliance gap, not a hypothetical one, of the same shape this
project's own history has repeatedly found and closed (e.g., the
Principle XVII self-invoke audit, CHK018).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Every skill states its own applicability, explicitly (Priority: P1)

A maintainer reading any `specjedi-*` skill's `SKILL.md` can see, for
each of the framework's four categories, whether it applies to that
specific skill and why — never a silent omission that leaves the
question unanswered.

**Why this priority**: This is the measurable floor Principle IX
actually requires ("MUST cover, at minimum, the test categories") — a
skill that never says whether a category applies can't be verified
compliant or exempt either way.

**Independent Test**: Open any one of the 24 shipped skills' `SKILL.md`
files; confirm all four framework categories are addressed (Applicable
with a scenario, or Not Applicable with a stated reason) — never
absent.

**Acceptance Scenarios**:

1. **Given** a skill that reads external or user-supplied content it
   doesn't author itself (a `spec.md`, a fetched page, a PR
   description, a target project's files), **When** its `SKILL.md` is
   read, **Then** the Prompt Injection Resistance category is marked
   Applicable with a concrete scenario, not silently absent.
2. **Given** a skill that never reads such content and never calls an
   external service, **When** its `SKILL.md` is read, **Then** the
   corresponding categories are marked Not Applicable with a one-line
   reason — not silently omitted, and not force-fit with an invented
   scenario that doesn't really apply.

---

### User Story 2 - Every applicable gap gets a real scenario, not a checkbox (Priority: P1)

A maintainer relying on a skill's documented dry-run coverage needs an
actual, concrete scenario proving the skill handles that category
correctly — not a generic restatement of the category's name standing
in for real content.

**Why this priority**: Equal priority to US1 — marking a category
"Applicable" with no real scenario is barely better than omitting it;
this is the actual substance Principle IX's dry-run requirement exists
for.

**Independent Test**: For every skill/category pair marked Applicable,
confirm the documented scenario names concrete input, concrete expected
skill behavior, and (where the skill already has a matching Example
section per Principle XIX) is grounded in or cross-referenced from that
existing example rather than duplicated as unrelated new prose.

**Acceptance Scenarios**:

1. **Given** a skill/category pair found compliant already (the skill's
   existing Example section already demonstrates the behavior in
   practice), **When** this audit runs, **Then** the fix is a
   cross-reference to that existing content, not a redundant rewrite.
2. **Given** a skill/category pair found genuinely missing coverage,
   **When** this audit runs, **Then** a new, concrete, skill-specific
   scenario is added to that skill's own `SKILL.md`.

---

### User Story 3 - Future skills get checked automatically, not just this one time (Priority: P2)

A maintainer authoring or revising a `specjedi-*` skill after this
feature ships gets this framework checked as part of the project's
existing self-review mechanism, so this compliance gap can't silently
reopen the way it did the first time.

**Why this priority**: Lower than US1/US2 because it's a recurrence-
prevention mechanism, not the compliance fix itself — but without it,
this audit only closes the gap once instead of keeping it closed.

**Independent Test**: Read the project's existing skill self-review
mechanism's own criteria after this feature ships; confirm this
framework's four categories appear as an explicit dimension it checks.

**Acceptance Scenarios**:

1. **Given** a newly-authored or newly-revised `specjedi-*` skill,
   **When** the project's existing self-review mechanism runs against
   it, **Then** it reports this framework's applicability/coverage
   status per category alongside its existing authoring-standard
   checks — not as a separate, easy-to-forget manual step.

### Edge Cases

- What about the framework's "Already covered elsewhere" categories
  (groundedness, persona/tone, technical-language translation)? →
  Explicitly out of scope for new scenarios here — the framework's own
  text already cross-references them to Principle XX, Principle XII/
  `specjedi-skill-review`'s voice dimension, and Principle XIX
  respectively; this audit doesn't duplicate that.
- What about `speckit-*` skills (vendored spec-kit bootstrap tooling)?
  → Out of scope. Principle XV explicitly distinguishes `speckit-*` as
  third-party bootstrap tooling this project doesn't author, not part
  of the `specjedi-*` product surface Principle IX's dry-run
  requirement governs.
- What if a skill/category audit finding is genuinely ambiguous (does
  this really count as "reading external content it doesn't author")?
  → Resolved by the same stated, consistent rule every skill is
  checked against (Requirements, below) — not a one-off judgment call
  that could classify the same shape of behavior differently across
  skills.
- What about skills shipped *after* this feature (e.g., a
  `specjedi-worktree` skill currently in its own separate, unmerged
  feature)? → Out of scope for this audit's own scope (the 24 skills
  shipped as of this feature's start); User Story 3's ongoing
  `specjedi-skill-review` check is what covers every future skill going
  forward, including that one once it ships.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Every one of the 24 currently-shipped `specjedi-*`
  skills' `SKILL.md` MUST explicitly state, for each of the framework's
  four adopted categories (vague/incomplete input, prompt injection
  resistance, out-of-bounds/malformed input, external-call resilience),
  whether it is Applicable or Not Applicable to that skill.
- **FR-002**: Every category marked Applicable MUST be backed by a
  concrete, skill-specific dry-run scenario — naming real input and the
  skill's actual expected behavior — never a generic restatement of the
  category's own definition.
- **FR-003**: Applicability MUST be determined by a single, stated,
  consistently-applied rule per category (e.g., "Prompt Injection
  Resistance applies to any skill that reads a `spec.md`/fetched page/
  PR description/target-project file it doesn't author itself") — not
  an ad hoc per-skill judgment call that could classify the same
  underlying behavior differently across skills.
- **FR-004**: Every genuine gap this audit finds (an Applicable category
  with no documented scenario) MUST be fixed within this same feature —
  this closes the compliance gap, it does not just report it.
- **FR-005**: Where a skill/category pair is already satisfied in
  substance by that skill's own existing Example section (Principle
  XIX), the fix MUST cross-reference that existing content rather than
  duplicate it as separate, redundant prose.
- **FR-006**: The project's existing skill self-review mechanism MUST
  gain this framework's four categories as an explicit review
  dimension, so future skill authoring/revision is checked against it
  going forward, not just corrected retroactively this one time.
- **FR-007**: This audit's findings MUST be traceable per skill and per
  category (compliant-with-cross-reference / fixed-with-new-scenario /
  not-applicable-with-reason) — never reported only as an aggregate
  pass/fail count that hides which specific skill needed what.

### Key Entities

*(Not applicable — this feature audits and revises existing
documentation content; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 24 of 24 shipped `specjedi-*` skills explicitly address
  all four framework categories (Applicable-with-scenario or
  Not-Applicable-with-reason) — zero silent omissions, verifiable by
  the same `grep`-based check that found the original gap.
- **SC-002**: 100% of Applicable-category findings carry a concrete,
  skill-specific scenario — zero generic placeholders standing in for
  real content.
- **SC-003**: The project's skill self-review mechanism's own
  documented criteria name this framework explicitly, confirmed by
  reading that mechanism's own source after this feature ships.
- **SC-004**: A future reader can determine any skill's compliance
  status for any one category by reading that skill's own `SKILL.md`
  alone — no need to cross-reference a separate, external tracking
  document to know the answer.

## Assumptions

- Scope is the 24 `specjedi-*` skills shipped as of this feature's own
  starting point — not `speckit-*` (vendored, out of scope per
  Principle XV) and not any skill still in its own separate, unmerged
  feature branch at this feature's start.
- "Fixing" a gap ranges from a lightweight cross-reference (where a
  skill's existing Example section already demonstrates the behavior in
  practice — likely the common case for vague-input handling, already
  required project-wide by Principle IV) to writing a genuinely new
  scenario (more likely for prompt-injection resistance and
  external-call resilience, which fewer skills' existing examples
  happen to already cover) — the audit determines which, per skill, per
  category; this is not assumed to be uniformly heavy or uniformly
  light across all 24 skills.
- This audit does not become a new automated `scripts/validate.sh`
  check — "does this skill's prose contain a real scenario for category
  X" isn't cleanly structurally verifiable the way frontmatter
  presence is; the existing skill self-review mechanism (a read-only,
  judgment-based audit, per User Story 3) is the right enforcement
  layer, matching how Principle IX's dry-run requirement is already
  verified project-wide today.
- The project's existing skill self-review mechanism (referenced in
  User Story 3/FR-006) is the correct place to wire this in, rather
  than inventing a second, parallel review skill — consistent with this
  project's own "avoid internal redundancy" discipline (Principle II).
