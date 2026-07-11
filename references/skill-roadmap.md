# `specjedi-*` Skill Roadmap (beyond the core P1-P9 pipeline)

Living backlog of proposed skills, evaluated against Constitution
[Principle II](../.specify/memory/constitution.md) (must exceed, not just match,
what's already out there) and the explicit requirement that Spec Jedi serve users
from complete beginners to advanced practitioners. This is a proposal list, not a
build commitment — each idea still needs its own research pass before it's built,
per Principle II, the same discipline applied to the core pipeline in
`specs/001-specjedi-pipeline/research.md`.

## Gap this round of research surfaced

Inspected the "help"-style skills already present in this environment
(`gsd-help`, `help`) firsthand: both are static command-list dumps — no adaptive
depth, no actual teaching, no "why would I use this" framing. Neither spec-kit nor
any of the ten tools researched for the core pipeline (`research.md`) ships a
skill that calibrates its explanation to how experienced the asker actually is.
That's the concrete gap `specjedi-explain` (built this cycle, see below) closes.

## Shipped

- **`specjedi-explain`** 🎓 — plain-language, depth-calibrated explanation of any
  SDD concept, `specjedi-*`/`speckit-*` command, or "why would I use this"
  question. The direct answer to "this project must work for AI beginners through
  advanced users." See the skill itself for design detail.
- **`specjedi-onboard`** 🌱 (feature 002, shipped 2026-07-11) — an interactive
  first-run walkthrough that produces a user's actual first constitution +
  spec together, teaching each concept at the moment it's needed rather than
  front-loading a wall of docs. Orchestrates the existing
  `specjedi-constitution`/`specjedi-specify` skills rather than duplicating
  their logic; steps aside instantly if a constitution already exists. See
  [specs/002-specjedi-onboard/](../specs/002-specjedi-onboard/) for the full
  research/spec/plan.
- **`specjedi-migrate`** 🔄 (feature 003, shipped 2026-07-11) — rewrites
  literal `/speckit-*` tooling references in a project's own constitution/
  spec/plan/tasks to their shipped `specjedi-*` equivalents. Scoped
  narrowly and honestly: the underlying file format was already shared
  (FR-009, feature 001), so this rewrites tooling *references* only, never
  principle or requirement content — flags any reference with no shipped
  equivalent instead of guessing. Explicit request only, never proactive.
  See [specs/003-specjedi-migrate/](../specs/003-specjedi-migrate/) for the
  full research/spec/plan.
- **`specjedi-diagram`** 📊 (feature 004, shipped 2026-07-11) — generates a
  render-verified Mermaid diagram (flowchart, sequence, or ER, inferred
  from content) from an existing spec/plan, applying Principle XVI
  automatically instead of requiring the user to draw one by hand each
  time. Genuine contribution: validates every diagram actually renders
  before presenting it — no researched competitor's diagram output goes
  through an equivalent render-check. See
  [specs/004-specjedi-diagram/](../specs/004-specjedi-diagram/) for the
  full research/spec/plan.
- **`specjedi-status`** 🧭 (feature 005, shipped 2026-07-11) — a
  project-wide dashboard: which features are specified, planned, in
  progress, or complete, derived entirely from on-disk `spec.md`/
  `plan.md`/`tasks.md` artifacts. Genuine contribution: zero
  separately-maintained tracking system — no researched competitor's
  dashboard-equivalent avoids a manually-updated status field. Explicitly
  never asserts "stalled" as a fact; reports the objective last-commit
  date and lets the reader judge. See
  [specs/005-specjedi-status/](../specs/005-specjedi-status/) for the full
  research/spec/plan.

## Proposed, not yet built (prioritized by expected impact)

1. **`specjedi-retro`** 🪞 — post-`specjedi-implement` retrospective: diffs what
   shipped against what was planned, captures what changed and why. Feeds
   genuine product signal back into future `specjedi-*` skill research the same
   way `.specify/memory/skill-gaps.md` does for missing skills (Principle
   XVII).
2. **`specjedi-security`** 🛡️ — lightweight threat-modeling pass over a spec/plan
   before implementation — not a full security audit tool, just the "did we
   think about auth/input validation/secrets" questions a spec often misses.
   Serves security-conscious teams without requiring them elsewhere.
3. **`specjedi-docs`** 📚 — generates end-user-facing documentation (README
   sections, changelog entries) from a shipped spec/plan, kept in sync instead
   of drifting from what actually got built.

## Not proposed (deliberately)

- A generic "ask me anything about coding" skill — out of scope; Spec Jedi is
  an SDD tool, not a general coding assistant, and `specjedi-find-skills`
  already routes genuinely out-of-domain requests elsewhere (Principle XVII).
- Anything requiring a paid API/service by default — conflicts with
  Principle VIII's token-economy stance and Principle III's broad-harness
  portability goal.
