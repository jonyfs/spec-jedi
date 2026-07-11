# Research: `specjedi-tokencheck`

**Feature**: 012-specjedi-tokencheck

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

[Principle VIII](../../.specify/memory/constitution.md) ("Token-Economy
Tooling Integration") mandates that every project this toolkit scaffolds,
and every long-running skill session it drives, MUST proactively check
for and suggest installing/configuring `rtk` (github.com/rtk-ai/rtk) and
`graphify` (graphify.net) as token-saving companions — explaining what
each does and the expected savings — with actual
installation/configuration always gated behind explicit user
confirmation. A grep across every shipped `specjedi-*` skill turns up
exactly two mentions of `rtk`/`graphify` at all: `specjedi-plan` and
`specjedi-converge` each say to *prefer* `graphify query` over
brute-force file reads *when one is already installed* — a usage
instruction, not the mandated proactive suggest-and-explain-savings
check for a project that doesn't have either tool yet. No skill checks
whether `rtk`/`graphify` are present, and none ever suggests installing
them. This is the same shape of gap `TODO(INSTALLER)` closed for
Principle XVIII and `specjedi-release` closed for Principle XI: a
principle mandates a capability, and nothing in the shipped product
surface actually delivers it.

## Internal-redundancy check (established discipline since feature 007)

Checked against every shipped `specjedi-*` skill: `specjedi-onboard`
(feature 002) walks a first-run user through producing a constitution and
spec, but its own `plan.md`/`SKILL.md` make no mention of `rtk`/
`graphify` — it doesn't currently cover tooling suggestions at all.
`specjedi-plan`/`specjedi-converge` reference `graphify` only as an
already-installed optimization, never as something to check for or
suggest installing. `specjedi-status` reports feature-level pipeline
completion, an unrelated target. No shipped skill performs the check
Principle VIII actually mandates. No redundancy found.

## Genuine contribution beyond the researched field

None of the eleven tools researched across features 001-011 bundle a
self-referential "check for and suggest a token-saving companion tool,
with savings explained and installation confirmation-gated" mechanism as
part of their own onboarding or session flow. Most researched tools
either have no token-economy stance at all, or (where one exists) assume
the user already knows to configure it manually. The genuine contribution
here is the same "give the mandated capability a real product surface"
shape as the installer and `specjedi-release`: Principle VIII is already
a differentiator on paper; `specjedi-tokencheck` is what makes it a real,
consistently-triggered mechanism instead of a standing intention nothing
actually executes.

## Baseline: GitHub spec-kit

No token-economy companion-tool suggestion mechanism in its surface.
**Adopt**: nothing (no mechanism to adopt). **Reject**: none applicable.

## Researched competitors (re-checked for token-economy tooling suggestions)

1. **BMAD-METHOD** — no token-economy companion-suggestion mechanism found.
2. **OpenSpec** — no token-economy companion-suggestion mechanism found.
3. **Kiro** — no token-economy companion-suggestion mechanism found in its
   public surface.
4. **Tessl** — no token-economy companion-suggestion mechanism found.
5. **Spec Kitty** — no token-economy companion-suggestion mechanism found.
6. **Superpowers** (installed, inspected firsthand) — no equivalent
   proactive tooling-suggestion mechanism in its skill set.
7. **GSD** (installed, inspected firsthand) — no equivalent mechanism
   found in the installed command set inspected.
8. **PRP** (installed, inspected firsthand) — no equivalent mechanism
   found.
9. **codemyspec.com** — no comparable mechanism found.
10. **Traycer** — no comparable mechanism found.

**Adopt**: nothing directly transferable — this confirms the gap rather
than pointing to prior art to adapt.

## Design implications for `specjedi-tokencheck`

- **Check, don't assume** — actually detect whether `rtk`/`graphify` are
  present (e.g., `which rtk`, `which graphify` or the project's own
  established `graphify-out/` marker) before suggesting either; never
  suggest installing a tool that's already there, and never claim a tool
  is absent without checking.
- **Proactive, not reactive** — Principle VIII is explicit that the
  suggestion must be surfaced without the user asking. The natural
  trigger point is `specjedi-onboard`'s first-run flow (the project's
  existing entry point for "long-running skill session" setup), matching
  how `specjedi-security` is proactively self-invoked by `specjedi-plan`
  (Principle XVII's proactive-contract discipline: a literal, verified
  "self-invoke X" instruction written directly into the triggering
  skill's own file, not an assumed contract).
- **Explain savings, don't just name the tool** — Principle VIII requires
  explaining what each tool does and the expected savings, not a bare
  "you should install rtk." Ground the explanation in each tool's own
  stated purpose (token-optimized CLI proxy for `rtk`; knowledge-graph/
  codebase-query tool for `graphify`) rather than a vague "saves tokens"
  claim.
- **Installation is never autonomous** — matches this project's absolute
  standing rule (Principle VIII's own text, and the same boundary
  `specjedi-release`/`specjedi-docs` already draw for their own writes):
  suggesting is proactive and autonomous, installing/configuring always
  requires the user's explicit yes first.
- **Re-runnable, not one-shot only** — Principle VIII says "every
  long-running skill session," not just first run; the skill should be
  callable standalone (not only wired into `specjedi-onboard`) so a
  session that started without onboarding (an existing project adopting
  Spec Jedi mid-stream) still gets the check.
