# Research: `specjedi-security`

**Feature**: 007-specjedi-security

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

`references/skill-roadmap.md` ranks `specjedi-security` next after
`specjedi-retro` (feature 006): "lightweight threat-modeling pass over a
spec/plan before implementation — not a full security audit tool, just
the 'did we think about auth/input validation/secrets' questions a spec
often misses."

## The redundancy question (must resolve before designing anything else)

This project already ships `specjedi-checklist` (feature 001), whose own
worked example is literally a security-focused checklist item. Before
building anything, it's necessary to establish that `specjedi-security`
isn't just "`specjedi-checklist` with the focus area pre-filled" — that
would fail Principle II's genuine-contribution bar against this project's
*own* existing capability, not just external competitors.

**Resolution**: the two skills differ in trigger model and mechanism, not
just topic:

- `specjedi-checklist` is **request-only** (a user must explicitly ask for
  a checklist on a named focus area) and produces a **comprehensive,
  persisted checklist file** covering whatever the spec/plan actually
  supports for that area.
- `specjedi-security` is designed here as **proactive** — self-invoked by
  `specjedi-plan` the moment it notices security-relevant content (auth,
  external input, secrets, data handling) the same way
  `specjedi-find-skills`'s gap-check self-invokes mid-task (Principle
  XVII's proactive pattern) — and produces a **short list of targeted
  questions**, not a persisted checklist, closer in shape to
  `specjedi-clarify`'s targeted-questioning mechanism (Principle IV) but
  scoped to a maintained security taxonomy instead of general spec
  ambiguity.
- The two compose rather than duplicate: if a user wants the full,
  comprehensive treatment, `specjedi-security` explicitly recommends
  `specjedi-checklist` with the security focus area as the next step —
  it never tries to be the comprehensive tool itself, matching the
  roadmap's own "not a full security audit tool" framing.

## Genuine contribution beyond the researched field

None of the eleven tools researched (spec-kit + the ten from feature 001,
re-checked here for proactive security prompting) ship a mechanism that
**proactively surfaces security blind spots during planning**, before a
checklist or audit is explicitly requested — every researched
competitor's closest equivalent (where one exists) is an on-request
checklist or a separate, heavier security-review product, never a
lightweight proactive nudge woven into the planning step itself. The
combination of (a) a maintained, extensible security-question taxonomy
(mirroring `references/star-wars-lexicon.md`'s own "maintained reference
pool, not invented inline" pattern) and (b) proactive self-invocation
during `specjedi-plan` (mirroring Principle XVII's gap-scout contract,
applied to a new domain) is what's actually new here.

## Baseline: GitHub spec-kit

No security-specific prompting in its command surface. **Adopt**: nothing
(no mechanism to adopt). **Reject**: none applicable.

## Researched competitors (re-checked for proactive security prompting)

1. **BMAD-METHOD** — no security-specific agent/prompting found.
2. **OpenSpec** — no security-specific mechanism found.
3. **Kiro** — no security-specific prompting found in its public surface.
4. **Tessl** — no security-specific tooling found.
5. **Spec Kitty** — CLI wizard scope; no security-specific mechanism.
6. **Superpowers** (installed, inspected firsthand) — has a general
   `security-reviewer`-style agent pattern in some configurations, but
   that's a full code-level review, not a lightweight pre-implementation
   spec/plan nudge — different scope entirely.
7. **GSD** (installed, inspected firsthand) — `gsd-security-auditor`
   verifies threat mitigations *after* a phase is planned (per its own
   description: "verifies threat mitigations from PLAN.md threat model
   exist in implemented code") — this is post-hoc verification, not
   proactive pre-implementation prompting. **Adopt**: the instinct that a
   threat model belongs in the plan itself, but GSD's mechanism verifies
   an existing threat model rather than proactively prompting for gaps
   the plan doesn't have yet — the proactive-nudge mechanism here is
   still novel relative to GSD's verify-after approach.
8. **PRP** (installed, inspected firsthand) — no security-specific
   mechanism.
9. **codemyspec.com** — no security-specific tooling found.
10. **Traycer** — plan-review focused generally, no security-specific
    proactive mechanism found.

**Adopt**: GSD's "threat model belongs in the plan" instinct, adapted to
a proactive-prompting mechanism rather than GSD's post-hoc verification
approach — a genuine adaptation, not a copy.

## Design implications for `specjedi-security`

- **Maintain a security-question taxonomy as a reference file**
  (`references/security-question-bank.md`), mirroring the lexicon
  pattern — extended over time, never invented ad hoc per invocation.
- **Proactive trigger**: `specjedi-plan` self-invokes this skill's
  gap-check when the spec/plan content it's processing mentions
  authentication, external input, secrets/credentials, or data handling
  — the same "notice mid-task, don't wait to be asked" contract Principle
  XVII already establishes for `specjedi-find-skills`.
- **Output is questions, not a checklist file** — a short, targeted list
  (same spirit as `specjedi-clarify`'s question budget discipline),
  recommending `specjedi-checklist` (security focus) as the next step for
  anyone wanting the comprehensive treatment.
- **Never claims to be a security audit** — the roadmap's own framing
  ("not a full security audit tool") must be honored explicitly in the
  skill's own persona/scope statement, so it never overclaims coverage it
  doesn't provide (Principle XX overclaiming discipline, same as
  `specjedi-migrate`'s honest scoping in feature 003).
