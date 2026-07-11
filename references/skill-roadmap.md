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
- **`specjedi-retro`** 🪞 (feature 006, shipped 2026-07-11) —
  post-`specjedi-implement` retrospective: strictly read-only, compares a
  completed feature's actual implementation against its `plan.md`,
  grounds any deviation's cause in traceable `git log` history (never
  invents one), and logs a durable, dated entry to
  `.specify/memory/retro-log.md` — the second cross-session signal log
  this project ships, alongside `skill-gaps.md`. Genuine contribution: no
  researched competitor's retrospective practice (where one exists at
  all) links back into a durable, structural signal log the way this
  does. See [specs/006-specjedi-retro/](../specs/006-specjedi-retro/) for
  the full research/spec/plan.
- **`specjedi-security`** 🛡️ (feature 007, shipped 2026-07-11) —
  lightweight, proactive threat-modeling prompt: self-invoked by
  `specjedi-plan` when spec/plan content is security-relevant, surfacing
  targeted "did we think about X" questions grounded in a maintained
  taxonomy (`references/security-question-bank.md`) — never a full
  security audit, and every response says so explicitly. Scoped
  deliberately to avoid duplicating `specjedi-checklist`'s own
  security-focus-area capability: this skill prompts proactively with
  targeted questions, `specjedi-checklist` produces a comprehensive
  on-request checklist — they compose, this skill recommends the other
  for full coverage. See
  [specs/007-specjedi-security/](../specs/007-specjedi-security/) for the
  full research/spec/plan.

- **`specjedi-docs`** 📚 (feature 008, shipped 2026-07-11) — drafts a
  README skill-table row, a Quickstart step, and a `CHANGELOG.md` entry
  from a shipped feature's spec/plan, grounded in actual content, always
  shown for confirmation before writing. Scoped deliberately to this
  project's own bounded doc surfaces rather than open-ended generation.
  The seventh and final item in this backlog's original list — its own
  worked example documents itself, and its own shipment populated this
  repo's first `CHANGELOG.md`. See
  [specs/008-specjedi-docs/](../specs/008-specjedi-docs/) for the full
  research/spec/plan.

## Shipped (second wave, beyond the original backlog)

- **`specjedi-new-skill`** 🌟 (feature 009, shipped 2026-07-11) —
  scaffolds a new `specjedi-*` skill's file structure (the
  `specs/NNN-specjedi-<name>/` research/spec/plan/tasks set plus the
  `.claude/skills/specjedi-<name>/SKILL.md` skeleton) following this
  project's own Skill Authoring Standard, placeholders only, never
  invented content. Genuine contribution: no researched competitor ships
  a self-scaffolding meta-tool for their own skill ecosystem that stops
  short of generating finished (and therefore unverified) content. The
  first feature in this repository's history built by literally invoking
  `/speckit-specify` → `/speckit-clarify` → `/speckit-plan` →
  `/speckit-tasks` → `/speckit-implement` rather than hand-authoring
  matching artifacts. See
  [specs/009-specjedi-new-skill/](../specs/009-specjedi-new-skill/) for
  the full research/spec/plan.
- **`specjedi-release`** 🚀 (feature 010, shipped 2026-07-11) — wraps the
  existing `scripts/suggest-release.sh`/`.ps1` with Spec Jedi's own
  voice, narrating the last tag, suggested next version/bump type, and
  contributing commits. Never tags or publishes — declines explicitly
  with the correct manual command if asked to actually cut a release
  (Principle XI's suggest-only boundary is absolute, not a confirm-then-
  proceed gate). Closes the same class of gap `TODO(INSTALLER)` closed
  for Principle XVIII: a principle mandated a capability, only a bare
  script implemented it, no `specjedi-*` skill gave it a product surface.
  `specjedi-docs`'s own next-step reference now points here instead of
  the bare script. See
  [specs/010-specjedi-release/](../specs/010-specjedi-release/) for the
  full research/spec/plan.

## Proposed, not yet built (prioritized by expected impact)

None currently. New proposals get added here as they're identified, each
still needing its own research pass per Principle II before it's built.

## Not proposed (deliberately)

- A generic "ask me anything about coding" skill — out of scope; Spec Jedi is
  an SDD tool, not a general coding assistant, and `specjedi-find-skills`
  already routes genuinely out-of-domain requests elsewhere (Principle XVII).
- Anything requiring a paid API/service by default — conflicts with
  Principle VIII's token-economy stance and Principle III's broad-harness
  portability goal.
