# Research: `specjedi-onboard`

**Feature**: 002-specjedi-onboard

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

`references/skill-roadmap.md` ranked `specjedi-onboard` #1 by expected impact:
"most abandonment in a dev tool happens in the first five minutes." The full
9-stage `specjedi-*` pipeline (feature 001) is complete and powerful, but
powerful and *approachable on first contact* are different problems — a
first-time user facing 9 skill names and a constitution template has no
obvious single next action. This skill is the answer to "I just installed
this, now what do I actually type."

## Genuine contribution beyond the researched field

None of the eleven tools below (spec-kit + the ten researched for feature
001, re-checked here specifically for onboarding UX) ship a **dedicated
first-run skill that produces the user's actual first constitution and spec
together, teaching each SDD concept at the moment it becomes relevant rather
than front-loading documentation.** The closest analog found anywhere in
this environment is `bitwize-music:tutorial` ("interactive guided album
creation") — same *shape* (walk a beginner through producing a real first
artifact, not a toy example), a completely different domain, no SDD
equivalent. Every SDD tool researched instead relies on static README
quickstarts or a `--help` command list — exactly the "help"-style gap
`specjedi-explain` (feature 001, shipped) already closed for on-demand
questions. `specjedi-onboard` closes the *unprompted first-five-minutes* gap,
which `specjedi-explain` cannot on its own since it requires the user to
already know to ask.

## Baseline: GitHub spec-kit

Already deeply known (vendored in this repo). Onboarding is a static
`README.md` quickstart plus a `speckit.constitution` slash command with no
guided sequencing — a new user reads docs, then runs `/speckit-constitution`
cold, with no adaptive walkthrough and no "here's what just happened, here's
what's next" narration. **Adopt**: none directly (no onboarding mechanism to
adopt). **Reject**: the assumption that a good README quickstart is
sufficient — feature 001's own Quickstart section is already more thorough
than spec-kit's and still assumes the user reads eleven numbered steps
before typing anything.

## Researched competitors (re-checked for onboarding UX specifically)

1. **BMAD-METHOD** — ships persona-based agent selection ("pick your agent")
   but no interactive first-artifact walkthrough; onboarding is still
   docs-first. **Reject** as a direct model; **adopt** the persona-framing
   instinct (already present in every `specjedi-*` skill via Principle
   XIX's persona requirement).
2. **OpenSpec** — lightweight-path philosophy extends to onboarding: a
   single `openspec init` scaffolds files but doesn't teach concepts inline.
   **Adopt** the instinct that onboarding shouldn't feel heavier than the
   tool itself — `specjedi-onboard` must produce a *real* first constitution
   + spec, not a toy tutorial artifact thrown away afterward.
3. **Kiro** — spec-driven with guided prompts during spec creation, closest
   of the ten to "teach at the point of use," but scoped only to spec
   authoring, not the full constitution→spec sequence. **Adopt**: teach
   inline, at the exact step the concept is needed, not before.
4. **Tessl** — no dedicated onboarding flow found; assumes prior SDD
   familiarity. **Reject** as a model.
5. **Spec Kitty** — CLI wizard for initial setup (prompts for project name,
   stack) but doesn't produce a real spec during onboarding, just config.
   **Reject** the "config wizard, not real artifact" pattern — it teaches
   nothing about the actual SDD workflow.
6. **Superpowers** (installed, inspected firsthand) — has no onboarding
   skill; relies on `using-superpowers` steering users toward skill
   discovery reactively. **Adopt**: the "announce what you're using and
   why" transparency habit, already present in every `specjedi-*` skill.
7. **GSD** (installed, inspected firsthand) — `gsd-new-project` walks a user
   through roadmap creation with research agents, genuinely interactive.
   Closest competitor mechanism to what `specjedi-onboard` needs. **Adopt**:
   the pattern of a single entry skill that orchestrates what would
   otherwise be several separate steps, without skipping any of them.
   **Adapt, don't copy**: GSD's version spawns multiple research subagents;
   `specjedi-onboard` stays lightweight (Principle VIII, token economy) —
   no subagent fan-out for a first-run walkthrough.
8. **PRP** (installed, inspected firsthand) — no onboarding-specific
   mechanism; the "golden rule" (already adopted in feature 001's
   `specjedi-plan`) is orthogonal to first-run UX.
9. **codemyspec.com** — web-based, has a guided setup wizard UI (out of
   scope for a text-based skill to imitate directly), but the underlying
   principle — don't show the user a blank template, walk them to a filled
   one — transfers. **Adopt** that principle, not the web-specific
   mechanism.
10. **Traycer** — plan-review focused, no onboarding flow researched found.
    **Reject** as a model.

## Design implications for `specjedi-onboard`

- **Must produce real artifacts**, not throwaway tutorial content — a
  completed `constitution.md` and a first `spec.md` the user actually keeps
  using, per the OpenSpec/Spec-Kitty contrast above (config wizard vs. real
  output).
- **Must teach at the point of use**, not front-load — per Kiro's inline
  guidance and GSD's orchestration pattern, but without GSD's subagent
  fan-out (token economy, Principle VIII).
- **Must hand off cleanly to `specjedi-constitution` and `specjedi-specify`**
  rather than reimplementing their logic — `specjedi-onboard` orchestrates
  the first run of the existing pipeline skills with extra narration, it
  does not duplicate their behavior (avoids the maintenance cost of two
  places defining what a valid constitution/spec looks like).
- **Must know when to get out of the way** — a returning user (constitution
  already exists) should never be shown a first-run walkthrough; this skill
  self-detects prior state exactly like every other `specjedi-*` skill's
  edge-case handling in feature 001 (spec.md's Edge Cases: "a user runs
  `specjedi-plan` before `specjedi-constitution` has ever run").
