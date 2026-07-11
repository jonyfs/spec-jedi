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

## Shipping this cycle

- **`specjedi-explain`** 🎓 — plain-language, depth-calibrated explanation of any
  SDD concept, `specjedi-*`/`speckit-*` command, or "why would I use this"
  question. The direct answer to "this project must work for AI beginners through
  advanced users." See the skill itself for design detail.

## Proposed, not yet built (prioritized by expected impact)

1. **`specjedi-onboard`** 🌱 — an interactive first-run walkthrough that produces
   a user's actual first constitution + spec together, teaching each concept at
   the moment it's needed rather than front-loading a wall of docs. Closest
   comparable seen: `bitwize-music:tutorial` ("interactive guided album
   creation") — same shape, different domain, no direct SDD equivalent found.
   Highest impact for the "reach thousands of people" goal (Principle I):
   most abandonment in a dev tool happens in the first five minutes.
2. **`specjedi-migrate`** 🔄 — converts an existing spec-kit project (its
   `constitution.md`/`spec.md`/etc.) into `specjedi-*` conventions, preserving
   content while adding Spec Jedi's own guided-next-step and voice layers.
   Directly lowers switching cost for spec-kit's existing user base — a genuine
   competitive move (Principle XV), not just parity.
3. **`specjedi-diagram`** 📊 — generates a Mermaid diagram (flow, sequence, or
   ER as appropriate) from an existing spec/plan on request, applying
   Principle XVI automatically instead of requiring the user to ask for one
   by hand each time.
4. **`specjedi-status`** 🧭 — a project-wide dashboard skill: which features have
   a spec/plan/tasks, which are mid-implementation, which are stalled — useful
   once a project has more than one or two features in flight. Mainly serves
   advanced/team users managing multiple concurrent efforts.
5. **`specjedi-retro`** 🪞 — post-`specjedi-implement` retrospective: diffs what
   shipped against what was planned, captures what changed and why. Feeds
   genuine product signal back into future `specjedi-*` skill research the same
   way `.specify/memory/skill-gaps.md` does for missing skills (Principle
   XVII).
6. **`specjedi-security`** 🛡️ — lightweight threat-modeling pass over a spec/plan
   before implementation — not a full security audit tool, just the "did we
   think about auth/input validation/secrets" questions a spec often misses.
   Serves security-conscious teams without requiring them elsewhere.
7. **`specjedi-docs`** 📚 — generates end-user-facing documentation (README
   sections, changelog entries) from a shipped spec/plan, kept in sync instead
   of drifting from what actually got built.

## Not proposed (deliberately)

- A generic "ask me anything about coding" skill — out of scope; Spec Jedi is
  an SDD tool, not a general coding assistant, and `specjedi-find-skills`
  already routes genuinely out-of-domain requests elsewhere (Principle XVII).
- Anything requiring a paid API/service by default — conflicts with
  Principle VIII's token-economy stance and Principle III's broad-harness
  portability goal.
