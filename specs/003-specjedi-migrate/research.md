# Research: `specjedi-migrate`

**Feature**: 003-specjedi-migrate

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

`references/skill-roadmap.md` ranks `specjedi-migrate` #1 in the
proposed-but-not-yet-built backlog (behind only `specjedi-onboard`, shipped
in feature 002): "directly lowers switching cost for spec-kit's existing
user base — a genuine competitive move (Principle XV), not just parity."
spec-kit has the largest existing SDD user base of any tool in this field
(~93K GitHub stars, feature 001's research.md); every one of those users is
a project already carrying `speckit-*`-produced artifacts. Zero switching
cost is a real competitive lever spec-kit itself cannot offer against Spec
Jedi (a tool can't discount adopting itself).

## What actually needs migrating (the scoping question)

Feature 001's FR-009 already established that `specjedi-*` skills are
**read-compatible** with `speckit-*`-produced `constitution.md`/`spec.md`,
and every shipped `specjedi-*` skill (`-constitution`, `-specify`, `-plan`,
`-tasks`) writes output in the *same* underlying template shape
(`.specify/templates/*-template.md`) that spec-kit itself uses — there is
no file-format incompatibility to convert. Read compatibility alone means
a spec-kit user could, in principle, start running `specjedi-*` skills
against their existing files today with zero migration step.

What genuinely needs migrating, then, is narrower and more honest than "convert
the files": a spec-kit project's own **constitution and artifacts often
name `speckit-*` commands explicitly** — a Development Workflow section
that says "run `/speckit-plan`", a spec's own notes referencing
`/speckit-clarify` by name. Those literal tooling references go stale the
moment a team switches its actual daily workflow to `specjedi-*` skills,
and nothing else in this project's shipped skill set is scoped to catch
that class of drift (`specjedi-analyze`, the closest candidate, checks
spec/plan/tasks consistency with each other and the constitution — not
whether the constitution's own prose still points at the right tool).

## Genuine contribution beyond the researched field

None of the eleven tools researched (spec-kit + the ten from feature 001,
re-checked here for migration-tooling specifically) ship a **dedicated
skill that migrates a competitor's own artifacts in place** — every
competitor either assumes a greenfield start or, at best, documents a
manual "how to switch" guide. `specjedi-migrate` is a working migration
path, not a doc page, and it is explicitly narrow and honest about what it
changes (tooling references only, never touching a single word of an
actual principle or requirement) rather than claiming a wholesale format
conversion that isn't actually needed.

## Baseline: GitHub spec-kit

No migration-away tooling exists, unsurprisingly — spec-kit has no reason
to help users leave it. **Adopt**: nothing (no mechanism to adopt).
**Reject**: none applicable.

## Researched competitors (re-checked for migration/switching-cost tooling)

1. **BMAD-METHOD** — no migration tooling from other SDD formats found.
2. **OpenSpec** — lightweight-path philosophy extends to "just start using
   it," no conversion tooling from spec-kit or others.
3. **Kiro** — proprietary spec format, no interop tooling with spec-kit
   found.
4. **Tessl** — no migration tooling found.
5. **Spec Kitty** — CLI wizard scopes to fresh `init`, not migrating an
   existing spec-kit project.
6. **Superpowers** (installed, inspected firsthand) — skill-discovery
   focused, no artifact-migration mechanism; not a comparable domain.
7. **GSD** (installed, inspected firsthand) — has its own roadmap/spec
   format with no spec-kit interop or migration path.
8. **PRP** (installed, inspected firsthand) — no migration mechanism; the
   golden-rule pattern (already adopted, feature 001) is orthogonal.
9. **codemyspec.com** — web-based, no spec-kit CLI-artifact migration
   found.
10. **Traycer** — plan-review focused, no migration-from-competitor
    mechanism found.

Every researched tool treats "switching from another SDD tool" as the
user's own manual problem. **Adopt**: nothing directly transferable — this
confirms the gap rather than pointing to prior art to adapt.

## Design implications for `specjedi-migrate`

- **Scope narrowly and honestly**: rewrite literal `speckit-*` tooling
  references (command names mentioned in prose) to their `specjedi-*`
  equivalents. Never touch principle text, requirement text, or any
  substantive content — the same "report, don't silently patch content"
  discipline `specjedi-analyze` already established for a different
  concern.
- **Must not require the file format to change** — per the scoping
  analysis above, the underlying template shape is already shared;
  claiming to "convert" files that don't need converting would be
  dishonest output (Principle XX, hallucination resistance covers
  overclaiming just as much as fabricating).
- **Must leave an audit trail** — mirror the Sync Impact Report pattern
  `specjedi-constitution` already uses, so a team can review exactly what
  changed before trusting it.
- **Depends on the installer** (feature from TODO(INSTALLER), shipped) to
  actually bring `specjedi-*` skills into the target project — migration
  of *references* is this skill's job; installing the skills themselves is
  `scripts/install.sh`'s.
