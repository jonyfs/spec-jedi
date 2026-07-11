# Research: `specjedi-retro`

**Feature**: 006-specjedi-retro

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

`references/skill-roadmap.md` ranks `specjedi-retro` next after
`specjedi-status` (feature 005): "post-`specjedi-implement` retrospective:
diffs what shipped against what was planned, captures what changed and
why. Feeds genuine product signal back into future `specjedi-*` skill
research the same way `.specify/memory/skill-gaps.md` does for missing
skills." Every prior pipeline stage checks a plan/spec against itself
(`specjedi-analyze`) or catches undocumented drift going forward
(`specjedi-converge`) — none of them look *backward* at a completed
feature and ask "did what we planned match what we actually built, and if
not, why." That backward-looking signal is exactly what turns one-off
deviations into a pattern worth noticing across features.

## Relationship to `specjedi-analyze` and `specjedi-converge` (scoping question)

These three skills are easy to conflate; the distinction is real and
matters for design:

- **`specjedi-analyze`** (feature 001): checks internal consistency
  *between* `spec.md`/`plan.md`/`tasks.md` and the constitution, at any
  point — strictly read-only, no code involved.
- **`specjedi-converge`** (feature 001): compares the actual codebase
  against `tasks.md` and *appends new tasks* to close a detected gap — it
  remediates.
- **`specjedi-retro`** (this feature): compares the actual codebase/git
  history against `plan.md` *narratively* — not to append tasks (that's
  converge's job) but to capture *why* a deviation happened, in prose, and
  log it as a durable product-signal entry for future skill research.
  Strictly read-only like `specjedi-analyze`, but backward-looking and
  narrative rather than a structured findings table.

## Genuine contribution beyond the researched field

None of the eleven tools researched (spec-kit + the ten from feature 001,
re-checked here for retrospective tooling) ship a mechanism that appends
completed-feature deviations to a **durable, cross-feature signal log**
feeding the project's own future development — every retrospective
practice found in the researched field (where one exists at all) is a
human ceremony (a meeting, a doc template) with no structural link back
into the tool's own roadmap process. `specjedi-retro` closes that loop the
same way `specjedi-find-skills`'s `skill-gaps.md` already does for missing
skills (Principle XVII) — this is the second `specjedi-*` mechanism in
this project built around "a recurring signal across sessions should
survive past one conversation," extending an established pattern to a new
signal type (planned-vs-actual deviation) rather than inventing an
unrelated one.

## Baseline: GitHub spec-kit

No retrospective command in its surface (`constitution`, `specify`,
`clarify`, `plan`, `tasks`, `implement`, `analyze`, `checklist`).
**Adopt**: nothing (no mechanism to adopt). **Reject**: none applicable.

## Researched competitors (re-checked for retrospective tooling)

1. **BMAD-METHOD** — no retrospective/diff-against-plan mechanism found.
2. **OpenSpec** — no retrospective tooling found.
3. **Kiro** — no retrospective mechanism found in its public surface.
4. **Tessl** — no retrospective tooling found.
5. **Spec Kitty** — CLI wizard scope; no retrospective mechanism.
6. **Superpowers** (installed, inspected firsthand) — no retrospective
   skill in its set.
7. **GSD** (installed, inspected firsthand) — closest candidate:
   `gsd-verifier` does goal-backward verification (does the codebase
   deliver what the phase promised), which is related but forward-facing
   at completion time, not a durable cross-feature signal log. **Adopt**:
   the goal-backward verification instinct — did the deliverable match
   the intent — informs `specjedi-retro`'s own comparison step, but GSD
   has no equivalent to the durable logging mechanism this feature adds.
8. **PRP** (installed, inspected firsthand) — no retrospective mechanism.
9. **codemyspec.com** — no retrospective tooling found.
10. **Traycer** — plan-review focused (forward, pre-implementation); no
    backward-looking retrospective mechanism found.

**Adopt**: GSD's goal-backward comparison instinct (adapted, not copied —
GSD's version doesn't log a durable cross-feature signal). Everything else
confirms the gap rather than pointing to prior art to adapt further.

## Design implications for `specjedi-retro`

- **Strictly read-only, like `specjedi-analyze`** — narrates and logs, never
  edits `plan.md`, `tasks.md`, or code. Remediation (new tasks for
  undocumented work) stays `specjedi-converge`'s job.
- **"Why" must be grounded, never invented** (Principle XX) — a deviation's
  cause is stated only when traceable to something actually read (a
  commit message, a PR description, `tasks.md`'s own notes); an
  untraceable deviation is reported as "cause not determinable from
  available history," never filled in with a plausible-sounding guess.
- **The log is durable and append-only**, mirroring `skill-gaps.md`'s
  exact convention (dated, one-line-per-entry, created on first use) —
  consistency with an established pattern this project already has,
  rather than inventing a parallel logging convention.
- **Triggers only on completion or explicit request** — a feature with
  `tasks.md` still in progress has nothing meaningful to retrospect yet;
  running this mid-implementation would produce a premature, likely
  misleading comparison.
