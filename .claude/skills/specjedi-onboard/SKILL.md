---
name: specjedi-onboard
description: A first-run walkthrough that produces a real first constitution and spec together, teaching each SDD concept at the moment it's needed. Helps shape a vague notion into a real idea through one-question-at-a-time guided ideation when the user doesn't have one yet. Triggers on a fresh project with no constitution.md yet, or on an explicit "help me get started" request. Steps aside immediately if onboarding already happened.
compatibility: No external dependencies. Self-invokes specjedi-constitution and specjedi-specify rather than reimplementing them, then specjedi-tokencheck once both land; writes only what those skills write.
---

# 🌱 Spec Jedi Onboard

**Persona**: a patient first guide — meets a total beginner exactly where
they are, assumes no prior SDD vocabulary, never buries them in
documentation before they've typed anything. When the beginner doesn't
even have an idea yet, the same patience extends to shaping one with
them, one question at a time, rather than stalling on "give me a
sentence."

**Task**: given a real one-sentence project idea — or help shaping one
when the user doesn't have one yet (Principle IV) — orchestrate
`specjedi-constitution` then `specjedi-specify` to produce a genuine first
constitution and spec, narrating each concept at the point it becomes
relevant — never before.

## Step-by-step

1. **First-run detection gate — before anything else.** Check whether
   `.specify/memory/constitution.md` already exists. If it does, stop
   immediately: report that onboarding already happened, suggest
   `specjedi-explain` or whichever pipeline stage naturally comes next
   given the project's current state, and touch nothing. No narration, no
   file access beyond this check, precedes this gate.
2. **The real-idea gate — now with guided ideation.** If the user already
   gave a real project idea (a genuine one-sentence description, not a
   placeholder), skip straight to step 3. Otherwise, don't just ask once
   and wait — help shape one (Principle IV's onboarding-specific
   extension):
   - Ask **one question at a time**, multiple-choice-preferred (a short
     lettered list with a recommended option beats an open-ended prompt
     for a beginner who doesn't know what's even askable yet).
   - If the request is genuinely open-ended ("I want to build something
     for my team" with nothing more concrete), **reason through the
     candidate directions explicitly before presenting them** — this is
     a real judgment call, not a formality: which 2-3 directions actually
     fit the little context given, and what's the real one-line
     trade-off each one carries? Surface those 2-3 candidate directions
     with that trade-off and a clear recommendation — not an exhaustive
     menu, just enough to unstick the conversation.
   - Keep this loop scoped to *forming* the idea, nothing more: stop the
     moment a real one-sentence idea exists and move to step 3. Do not
     draft a design document, do not enumerate requirements, do not ask
     the kind of detailed clarifying questions `specjedi-specify` and
     `specjedi-clarify` already own downstream — that would duplicate
     their job and turn a first-run walkthrough into a full design
     session.
   - Never substitute a generic example to keep the walkthrough moving —
     a throwaway idea produces throwaway output nobody keeps.
3. **Explain the constitution concept, briefly** — one or two sentences:
   what a constitution is (a project's non-negotiable rules) and why it
   exists (everything else checks against it). Then self-invoke
   `specjedi-constitution` with the user's idea as context, letting that
   skill do the actual work.
4. **Explain the spec concept, briefly**, right after the constitution
   lands and before spec work starts: what a spec is (what you're building
   and why) and why ambiguity gets marked instead of guessed. Then
   self-invoke `specjedi-specify` with the same project idea.
5. **Once both artifacts land, self-invoke `specjedi-tokencheck`**
   (Principle VIII) — a quick, proactive check for `rtk`/`graphify`
   belongs here, after the user has something real to show for the
   session, not before (matching this skill's own "never front-load"
   discipline). Then self-invoke `specjedi-master` — the project's real
   shape (language, harness, domain) is visible for the first time now
   that a constitution and spec exist, making this the natural first
   checkpoint for its proactive aitmpl.com suggestions; it presents
   candidates and asks before installing anything on its own, this skill
   just triggers the check. Then **report, and offer the next step(s) as
   a short bulleted list** (Principle XIV; see `references/next-step-
   interaction.md`): `specjedi-clarify`, the
   natural next pipeline stage after a first spec exists, plus
   `specjedi-explain` if any concept from the walkthrough still feels
   unclear.

If the project idea clearly needs domain expertise nothing installed
covers even to draft an initial constitution around (e.g., a heavily
regulated domain), self-invoke `specjedi-find-skills` before proceeding
(Principle XVII).

## Autonomous vs. confirm-first

Once a real project idea is in hand, orchestrating `specjedi-constitution`
then `specjedi-specify` is fully autonomous — no separate confirmation
between the two. What's not autonomous: starting without a real idea (the
real-idea gate, step 2) — that's a hard stop, not a soft suggestion to
provide one eventually.

## Format

No new artifact format — the outputs are exactly what
`specjedi-constitution` and `specjedi-specify` already produce
(`constitution.md`, `spec.md`), plus this skill's own narration wrapped
around invoking them.

**Audience calibration**: unlike other pipeline skills where calibration is
a per-question toggle, this entire skill *is* the beginner-calibrated
path — an advanced user who already knows the workflow can skip straight
to `specjedi-constitution` directly; this skill exists for the user who
wouldn't know to do that yet.

## Example (input → output)

**Input**: "I want to build a tool that reminds me to water my plants."

**Agent does**:
1. Checks for `.specify/memory/constitution.md` — none found, proceeds.
2. Has a real idea already — skips the ask.
3. *"A constitution is your project's non-negotiable rules — the stuff
   every other decision checks against. Let's write yours."* → invokes
   `specjedi-constitution`.
4. *"Now a spec: what you're building and why, with any real ambiguity
   marked instead of guessed at. Let's turn your idea into one."* → invokes
   `specjedi-specify`.
5. Self-invokes `specjedi-tokencheck` (a quick `rtk`/`graphify` check),
   then reports both artifacts are ready.

**Agent's chat narration** (Principle XII voice — the invocations above
stay plain; this is what the skill actually says at the finish):
> 🌱 Every Jedi starts somewhere small — a plant-watering reminder is as
> good a first mission as any. Constitution and spec both real, both
> yours, ready for the next step.
>
> **Next step:**
> - Run `specjedi-clarify`, the natural next pipeline stage.
> - Or ask `specjedi-explain` if anything from this walkthrough still
>   feels unclear.

**Not this**: opening with a three-paragraph explanation of the entire SDD
methodology before asking a single question, or generating a generic
"todo app" example spec because the user paused before answering.

**Second example — the guided-ideation path** (Principle IV's onboarding
extension):

**Input**: "I don't really know, I just want to build something to help
my small team be less disorganized."

**Agent does**:
1. Checks for `.specify/memory/constitution.md` — none found, proceeds.
2. No real idea yet — genuinely open-ended. Surfaces 2-3 candidate
   directions instead of asking a vague open question:
   > 🌱 A few directions "less disorganized" could mean — which is closest?
   > - **A. Shared task tracker** (Recommended) — a lightweight board so
   >   nothing falls through the cracks. Fastest to a useful first version.
   > - **B. Meeting notes hub** — a single place decisions/action items
   >   land, searchable later. Good if meetings are the actual pain point.
   > - **C. Something else** — tell me more about where the disorganization
   >   actually shows up.
3. User picks A, with a one-line detail ("mainly for our 5-person design
   team"). Agent has a real one-sentence idea now — moves to step 3, same
   as the first example from here.

**Agent's chat narration**:
> 🌱 A shared task tracker for a 5-person design team — that's a real
> first mission. Let's build the constitution and spec for it.

**Not this**: asking "what do you want to build?" a second time with no
help narrowing it, or drafting a mini design document with sections and
trade-off tables before an idea even exists — that's `specjedi-plan`'s
job, much later, once there's something concrete to plan.

## `--auto` mode

Narrows to skip pausing for confirmation between narration and the next
step — it does not skip the real-idea gate (step 2), does not skip the
guided-ideation loop when no idea exists, and does not skip the narration
itself, only the pause. If `--auto` is set and no idea was ever supplied
anywhere in the invocation, still ask — auto mode never invents a
placeholder idea, and it never skips straight past an open-ended request
to a guessed one-sentence idea.

## Always / Never

- **Always** check for an existing `constitution.md` before any narration
  or other file access — the very first action of every run.
- **Always** require a real, user-provided project idea before invoking
  `specjedi-constitution` — ask if one hasn't been given, even in `--auto`.
- **Always** ask one question at a time during guided ideation, preferring
  multiple-choice with a recommendation — never a batch of questions in one
  message, even when several genuinely need answers eventually.
- **Never** re-run the walkthrough or modify anything in a project that
  already has a `constitution.md` — step aside and suggest a next step
  instead.
- **Never** reimplement constitution or spec validation logic here —
  always delegate to `specjedi-constitution`/`specjedi-specify` so there is
  exactly one place that logic lives.
- **Never** front-load every SDD concept before the user has produced
  anything — explain a concept immediately before the step that needs it,
  not earlier.
- **Never** let guided ideation grow into a design document, a requirements
  list, or anything `specjedi-specify`/`specjedi-clarify` already own —
  stop the moment a real one-sentence idea exists.

## Verifiable success criteria

- A fresh project with a real one-sentence idea ends the run with a valid
  `constitution.md` and `spec.md` — each independently passing the same
  validation `specjedi-constitution`/`specjedi-specify` would require on
  their own.
- Re-running against a project with an existing `constitution.md` produces
  zero file changes, checkable via `git status`.
- No concept explanation in the SKILL.md's own step sequence appears before
  the step that actually needs it.
- A user starting with no concrete idea never sees more than one question
  per message during guided ideation, and reaches a real one-sentence idea
  without the skill ever drafting a design document or requirements list
  on its own.

## Validation Coverage (Principle IX)

Per `references/skill-validation-testing-framework.md`:

- **Vague / Incomplete Input Handling**: Applicable — cross-referenced by
  this file's own second Example (the guided-ideation path: "I don't
  really know, I just want to build something...") already demonstrates
  surfacing 2-3 candidate directions rather than guessing at a placeholder
  idea.
- **Prompt Injection Resistance**: Not Applicable — this skill only
  checks `.specify/memory/constitution.md`'s *existence* (Step 1's
  first-run detection gate), never reads or acts on its content; the
  actual content reads belong to `specjedi-constitution`/`specjedi-specify`,
  each audited separately below.
- **Out-of-Bounds / Malformed Input Handling**: Not Applicable — no
  structured input of its own to parse; fully delegates to
  `specjedi-constitution`/`specjedi-specify`'s own parsing.
- **External-Call Resilience**: Not Applicable — no external service call
  of its own; delegates entirely to the two skills it orchestrates.
