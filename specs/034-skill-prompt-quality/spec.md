# Feature Specification: Close Prompt-Engineering Gaps in 5 `specjedi-*` Skills

**Feature Branch**: `034-skill-prompt-quality`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description: "busque insights para deixar as skills
specjedi ainda mais eficientes em resolver os prompts que elas forem
executar" (find insights to make the specjedi-* skills more effective
at resolving the prompts they execute) — the validation-testing-
framework-compliance half of the original request is already covered
by `specs/033-skill-validation-audit`, out of scope here to avoid
duplicating that feature.

## Problem

An audit this session read all 24 shipped `specjedi-*` skills against
Constitution Principle XIX's five prompt-engineering dimensions
(persona, task framing, output format, worked few-shot example, chain-
of-thought for judgment calls, audience calibration). Persona, task,
format, and worked examples are uniformly strong across all 24 — but
two dimensions have real, narrow gaps in 5 specific skills:

- **Audience calibration missing** in `specjedi-constitution`,
  `specjedi-specify`, and `specjedi-find-skills` — every other
  conversational, ask-the-user skill in the set (`specjedi-clarify`,
  `specjedi-govcheck`, `specjedi-tasks`, `specjedi-retro`) already
  carries an explicit "Audience calibration boundary" note; these three
  don't, despite asking the same shape of clarifying questions.
- **Chain-of-thought missing or weak** in `specjedi-onboard` (its own
  directional-synthesis step — surfacing 2-3 candidate feature
  directions with trade-offs for a vague idea — is a real judgment call
  with no "reason through this explicitly" instruction, unlike its
  sibling skills `specjedi-checklist`/`specjedi-converge`/`specjedi-
  migrate`/`specjedi-diagram`/`specjedi-plan`) and `specjedi-quick`
  (the eligibility-checklist reasoning only appears inside the worked
  example, not as an instruction in the step that actually makes the
  call).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Constitutional and spec-writing conversations calibrate to the asker (Priority: P1)

A total beginner and an experienced practitioner both interact with
`specjedi-constitution` or `specjedi-specify` and each gets an
explanation depth matched to how they phrased their request — not the
same one-size-fits-all register regardless of who's asking.

**Why this priority**: These are two of the most-used, first-contact
skills in the whole pipeline (every project's first constitution, every
feature's first spec) — an uncalibrated register here has the widest
possible reach of any gap this audit found.

**Independent Test**: Read `specjedi-constitution/SKILL.md` and
`specjedi-specify/SKILL.md`; confirm each has an explicit audience-
calibration instruction, in the same shape `specjedi-clarify`'s already-
shipped one takes (a beginner gets the reasoning, an expert can reply
in one word and move on).

**Acceptance Scenarios**:

1. **Given** `specjedi-constitution`'s `SKILL.md`, **When** it is read,
   **Then** an explicit audience-calibration instruction is present,
   scoped the same way `specjedi-clarify`'s existing one is (narration
   calibrates, artifact content stays precise per Principle V).
2. **Given** `specjedi-specify`'s `SKILL.md`, **When** it is read,
   **Then** the same holds.

---

### User Story 2 - Skill recommendations explain their own evidence at the right depth (Priority: P1)

A user unfamiliar with GitHub stars/install-count conventions asks
`specjedi-find-skills` for help and gets the reasoning behind a
recommendation (or a decline) explained in terms they can actually
evaluate — not a bare "356 stars, MIT license" dropped with no context
for someone who doesn't know what those numbers mean.

**Why this priority**: Equal priority to US1 — this skill's own
verification reasoning (install count, license, source reputation) is
exactly the kind of signal a beginner cannot interpret unassisted, per
the audit's own finding; leaving it uncalibrated defeats the purpose of
recommending a skill to someone who needed help in the first place.

**Independent Test**: Read `specjedi-find-skills/SKILL.md`; confirm an
explicit audience-calibration instruction addresses how its
verification-signal reasoning (stars, license, reputation) should be
explained differently to a beginner versus a practitioner.

**Acceptance Scenarios**:

1. **Given** `specjedi-find-skills/SKILL.md`, **When** it is read,
   **Then** an audience-calibration instruction is present and
   specifically addresses its own verification-signal reasoning, not a
   generic restatement of the principle.

---

### User Story 3 - Onboarding's own judgment call reasons out loud (Priority: P1)

A brand-new user gives `specjedi-onboard` a vague idea; the skill
surfaces 2-3 candidate directions with trade-offs — and now visibly
reasons through why those particular directions, the same way every
other judgment-making skill in the pipeline already does, rather than
presenting a synthesis with no shown reasoning behind it.

**Why this priority**: Equal priority to US1/US2 — `specjedi-onboard`
is the skill most explicitly built for total beginners; an unreasoned
synthesis is the least trustworthy possible shape of output for exactly
that audience.

**Independent Test**: Read `specjedi-onboard/SKILL.md`; confirm its
directional-synthesis step now includes an explicit "reason through
this before presenting" instruction, matching the pattern already used
in `specjedi-checklist`/`specjedi-converge`/`specjedi-migrate`/
`specjedi-diagram`/`specjedi-plan`.

**Acceptance Scenarios**:

1. **Given** `specjedi-onboard/SKILL.md`'s directional-synthesis step,
   **When** it is read, **Then** an explicit chain-of-thought
   instruction is present at that step, not only implied by an example
   elsewhere in the file.

---

### User Story 4 - Quick-path eligibility reasoning is instructed, not just demonstrated (Priority: P2)

A developer invoking `specjedi-quick` gets an eligibility decision that
was actually reasoned through against all five criteria — with that
reasoning instructed as part of the step itself, not left to be
inferred only from reading the worked example.

**Why this priority**: Lower than US1-3 — the reasoning already happens
correctly in practice (the example demonstrates it), so this is a
consistency/robustness fix (making the instruction explicit rather than
implicit) rather than a closing of a behavior that's currently missing
outright.

**Independent Test**: Read `specjedi-quick/SKILL.md`'s eligibility-
checklist step; confirm an explicit "reason through each criterion"
instruction is present in the step itself, not only inside the Example
section.

**Acceptance Scenarios**:

1. **Given** `specjedi-quick/SKILL.md`'s eligibility-checklist step,
   **When** it is read, **Then** an explicit chain-of-thought
   instruction is present directly in that step.

### Edge Cases

- What about `specjedi-status`, which also has no chain-of-thought
  instruction? → Not a gap — the audit confirmed `specjedi-status`'s
  own text explicitly disclaims making any judgment call (it reports
  on-disk state, it doesn't classify or prioritize anything), so
  Not Applicable is the correct, already-satisfied state; this feature
  does not touch it.
- What if adding an audience-calibration note or a chain-of-thought
  instruction pushes a skill's `SKILL.md` over Principle XIX's
  ~5,000-token ceiling? → Each addition MUST stay small and targeted (a
  boundary note or a reasoning instruction, not a rewrite) — the exact
  shape already used successfully in the skills that already have these
  sections; token count is verified per file after the edit.
- What about the other 19 already-compliant skills? → Explicitly out of
  scope — this feature touches only the 5 skills the audit actually
  found gaps in, never a broader rewrite pass.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-constitution`'s `SKILL.md` MUST gain an explicit
  audience-calibration instruction, in the same scoped shape (narration
  calibrates, artifact content stays precise) as `specjedi-clarify`'s
  already-shipped one.
- **FR-002**: `specjedi-specify`'s `SKILL.md` MUST gain the same.
- **FR-003**: `specjedi-find-skills`'s `SKILL.md` MUST gain an audience-
  calibration instruction specifically addressing how its own
  verification-signal reasoning (install counts, license, source
  reputation) is explained at different levels of asker familiarity —
  not a generic, unspecific restatement of the principle.
- **FR-004**: `specjedi-onboard`'s `SKILL.md` MUST gain an explicit
  chain-of-thought instruction at its directional-synthesis step
  (surfacing 2-3 candidate directions with trade-offs), matching the
  "reason through this explicitly" pattern already used in
  `specjedi-checklist`/`specjedi-converge`/`specjedi-migrate`/
  `specjedi-diagram`/`specjedi-plan`.
- **FR-005**: `specjedi-quick`'s `SKILL.md` MUST gain an explicit
  chain-of-thought instruction directly in its eligibility-checklist
  step — not only demonstrated inside that skill's own worked Example
  section.
- **FR-006**: No skill other than these 5 MUST be modified by this
  feature — this is a narrow, targeted fix for the specific gaps the
  audit found, not a broader rewrite.
- **FR-007**: Every edited `SKILL.md` MUST remain within Principle
  XIX's ~5,000-token ceiling after the edit.

### Key Entities

*(Not applicable — this feature edits existing skill-instruction
content; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 5 identified skills gain their specific missing or
  weak dimension, re-verifiable by the same read-through method the
  original audit used.
- **SC-002**: Zero of the other 19 already-compliant skills are
  modified by this feature.
- **SC-003**: Every edited skill's `SKILL.md` stays under Principle
  XIX's token ceiling after the edit.
- **SC-004**: `specjedi-skill-review`, run against any of these 5
  skills after the fix, reports the audience-calibration/chain-of-
  thought dimensions clean — no longer flagged as missing or weak.

## Assumptions

- Scope is exactly the 5 skill/dimension gaps this session's audit
  found — not a general re-audit of all 24 skills against Principle
  XIX's full five-dimension bar, which the audit already confirmed is
  otherwise uniformly strong (persona, task, format, and worked
  examples had zero gaps across the entire set).
- The fix pattern for each gap is "add a small, targeted section/
  instruction matching an already-shipped sibling skill's own version
  of it" — not inventing a new phrasing or structure from scratch,
  consistent with this project's own "ground new work in what already
  exists" discipline.
- This feature is independent of, and does not depend on or block,
  `specs/033-skill-validation-audit` — the two audits check different
  Principle XIX/IX dimensions (prompt-engineering quality vs.
  validation-testing-framework category coverage) and touch an
  almost entirely non-overlapping set of skills.
