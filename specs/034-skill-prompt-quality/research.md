# Research: Close Prompt-Engineering Gaps in 5 `specjedi-*` Skills

**Goal**: state the exact fix pattern for each of the 5 gaps spec.md's
Problem section names, each grounded in an already-shipped sibling
skill's own version of the missing dimension — not an invented phrasing.

## Principle II note

Per spec.md's Input note, the validation-testing-framework-compliance
half of the original request is feature 033's distinct scope. This
feature's own "genuine contribution" is closing a real, internally-
measured prompt-engineering gap (an audit this session read all 24
skills against Principle XIX's 5 dimensions), not a claim requiring new
external competitor research — the fix pattern for every one of the 5
gaps is "match what a sibling skill in this same project already ships,"
grounded directly in this project's own prior work.

## Fix 1 — `specjedi-constitution`: audience-calibration note (FR-001)

**Decision**: add an "Audience calibration boundary" note, immediately
after the Format section, in `specjedi-clarify`'s exact shape:

> **Audience calibration boundary**: `constitution.md`'s own content
> stays precise and testable (Principle V/XII exemption); calibration
> (Principle XIX) applies only to the skill's own narration — the
> follow-up questions Step 2 asks when a principle is vague or
> contradictory, and the explanation around a version-bump decision —
> never to the constitution's own written principle text.

**Rationale**: `specjedi-clarify`'s existing boundary note (already
shipped) draws the exact same line this skill needs — precise artifact
content stays precise, calibration applies only to the conversational
narration around it. `specjedi-constitution`'s own Step 2 already asks
clarifying questions the same shape `specjedi-clarify` does; it was
simply never given the matching boundary statement.

## Fix 2 — `specjedi-specify`: audience-calibration note (FR-002)

**Decision**: add the same shape of note, scoped to `spec.md`'s own
content vs. this skill's narration around Step 1's idea-shaping
conversation.

**Rationale**: identical reasoning to Fix 1 — `specjedi-specify`'s Step 1
already "asks what problem it solves and for whom" when given a rough
idea, the same conversational shape `specjedi-clarify` calibrates.

## Fix 3 — `specjedi-find-skills`: audience-calibration note, scoped to verification-signal reasoning (FR-003)

**Decision**: add a note specifically addressing Step 5's
verification-signal reasoning (install count, source reputation, GitHub
stars) — not a generic restatement, per FR-003's own explicit
requirement:

> **Audience calibration**: Step 5's verification signals (install
> count, source, GitHub stars) mean little to someone unfamiliar with
> package-ecosystem conventions. For a beginner-signaled request, name
> what each signal actually indicates in plain terms ("1K+ installs
> means a lot of other people already trust this one"), not just the
> bare numbers; for an experienced asker, the numbers alone are enough.

**Rationale**: this is the one gap where a generic "the skill's own
narration calibrates" note would fail FR-003's own explicit bar — the
audit's finding was specifically that verification-signal *reasoning*
needs translation for a beginner, not merely that some narration
somewhere should calibrate. `specjedi-explain`'s own beginner/advanced
worked-example pattern (plain language + concrete anchor for a beginner,
direct/technical for an expert) is the model this note's own phrasing
follows.

## Fix 4 — `specjedi-onboard`: chain-of-thought at the directional-synthesis step (FR-004)

**Decision**: add a "reason through this explicitly" instruction inside
Step 2's guided-ideation bullet on surfacing 2-3 candidate directions,
matching the exact framing `specjedi-checklist`/`specjedi-converge`/
`specjedi-migrate`/`specjedi-diagram`/`specjedi-plan` already use for
their own one-real-judgment-call step.

**Rationale**: `specjedi-onboard`'s own Example section (the "less
disorganized" walkthrough) already *demonstrates* reasoned trade-offs
between 2-3 directions in practice — the gap is that the step-by-step
instruction never told the agent to reason through the choice explicitly
before presenting it, only the worked example showed it happening. This
mirrors exactly `specjedi-skill-review`'s own documented "present but
weak" finding class (a plan.md's intention vs. the shipped SKILL.md text
never actually stating it).

## Fix 5 — `specjedi-quick`: chain-of-thought in the eligibility-checklist step (FR-005)

**Decision**: add a "reason through each criterion explicitly, don't
pattern-match on a keyword" instruction directly inside Step 1's
eligibility-checklist list, not only inside the Example section.

**Rationale**: same gap class as Fix 4 — `specjedi-quick`'s own Example
section already shows the eligibility reasoning happening correctly in
practice ("Agent reasons: one page easily, single file... no ambiguity,
not a new skill, not a constitution change → eligible"), but Step 1's
own instruction text lists the five criteria without an explicit
"reason through this" framing at the step itself.

## Verification: token-ceiling constraint (FR-007)

Each addition is a single short paragraph (60-90 words) — well within
the margin every already-shipped sibling skill's equivalent section
occupies. Verified per file via a word-count check during implementation
(Polish phase), not assumed.

## Summary of the 5 fixes

| # | Skill | Gap | Pattern matched |
|---|---|---|---|
| 1 | `specjedi-constitution` | Audience calibration missing | `specjedi-clarify`'s boundary note |
| 2 | `specjedi-specify` | Audience calibration missing | `specjedi-clarify`'s boundary note |
| 3 | `specjedi-find-skills` | Audience calibration missing (scoped) | `specjedi-explain`'s beginner/advanced translation pattern |
| 4 | `specjedi-onboard` | Chain-of-thought present but weak (example only) | `specjedi-checklist`/`specjedi-converge`/`specjedi-migrate`/`specjedi-diagram`/`specjedi-plan`'s "reason through this explicitly" framing |
| 5 | `specjedi-quick` | Chain-of-thought present but weak (example only) | Same pattern as Fix 4 |
