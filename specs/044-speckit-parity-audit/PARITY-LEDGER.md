# `specjedi-*` / `speckit-*` Parity Ledger & Internal Migration Readiness

**Feature**: specs/044-speckit-parity-audit
**Date**: 2026-07-18
**Purpose**: Answer, with evidence rather than assumption, whether
`specjedi-*` (this project's own shipped product) covers everything
`speckit-*` (the original Spec Kit pipeline, currently used to develop
this project itself) does — and whether this project is ready to stop
using `speckit-*` internally in favor of `specjedi-*`.

## Recommendation (read this first)

**Not yet safe for a full, immediate internal migration.** Three
concrete blockers were found; two require no engineering work at all —
only a maintainer decision — and one is a genuine, narrowly-scoped
engineering gap:

1. **Confirm `speckit-taskstoissues`'s GitHub-issue-conversion capability
   isn't actually needed internally.** This project's real history has
   never used it (every shipped feature tracks tasks as in-file
   checkboxes, never as GitHub issues). If ever wanted, it's a genuine
   `specjedi-taskstoissues` product feature — dual value, since it would
   also benefit `specjedi-*`'s external users — scoped as separate
   follow-up work, not a migration blocker.
2. **Document `speckit-agent-context-update`'s absence as an intentional
   design difference, not an open gap.** `specjedi-*` doesn't need an
   equivalent: `specjedi-status`'s own design principle is "zero
   separately-maintained tracking system" (deriving status fresh from
   on-disk artifacts every time, never a pointer that can go stale), and
   Constitution Principle XXI's `SessionStart` hook independently
   re-surfaces project status every session. No action needed beyond
   this documentation.
3. **The only real blocker**: no `specjedi-*` pipeline skill implements
   `.specify/extensions.yml`'s hook-dispatch mechanism (the
   `before_*`/`after_*` hook checks every `speckit-*` skill implements
   individually). This repository's own `extensions.yml` has live,
   registered hooks (`after_specify`, `after_plan` → the optional
   `speckit.agent-context.update` extension) that would simply stop
   firing if `specjedi-*` skills were substituted directly. **Next
   step**: either extend `specjedi-*`'s pipeline skills with equivalent
   hook-check/dispatch logic, or confirm the currently-registered hooks
   are non-essential and retire them before migrating.

## Parity Ledger (User Story 1)

Verdicts are based on each skill's actual described behavior (frontmatter
`description` and body), never on name similarity alone.

| `speckit-*` command | `specjedi-*` counterpart | Verdict | Evidence |
|---|---|---|---|
| `speckit-specify` | `specjedi-specify` | **Full Parity** | Both turn a feature idea into a prioritized spec.md. `specjedi-specify` additionally welcomes a rougher one-sentence starting point — a superset, not a regression. |
| `speckit-clarify` | `specjedi-clarify` | **Full Parity** | Both scan for real ambiguity, ask up to 5 targeted questions, write answers back into spec.md. `specjedi-clarify` adds proactive self-invocation after `specjedi-specify` — additive. |
| `speckit-plan` | `specjedi-plan` | **Full Parity** | Both turn a clarified spec into plan.md (+ research.md/data-model.md as needed). |
| `speckit-tasks` | `specjedi-tasks` | **Full Parity** | Both break plan.md into a dependency-ordered, user-story-organized tasks.md. |
| `speckit-implement` | `specjedi-implement` | **Partial Parity (favorable divergence)** | Both execute tasks.md in order. `speckit-implement`'s own instructions contain no git branch/commit discipline at all. `specjedi-implement` explicitly requires committing only through a feature branch and pull request — never directly to the trunk (Constitution Principle X) — plus a bounded CI-monitor-and-fix mandate (v1.27.0). This project's actual practice already goes through PRs by session discipline even under `speckit-implement`, but the skill itself doesn't enforce it. |
| `speckit-analyze` | `specjedi-analyze` | **Full Parity** | Both perform non-destructive cross-artifact consistency checks across spec/plan/tasks. `specjedi-analyze` additionally checks the constitution when present — additive. |
| `speckit-checklist` | `specjedi-checklist` | **Full Parity** | Both generate a focus-area checklist grounded in the current feature. |
| `speckit-constitution` | `specjedi-constitution` | **Full Parity** | Both create/amend a project constitution. `specjedi-constitution`'s own frontmatter explicitly notes it reads an existing `speckit-*`-produced `constitution.md` if present — deliberate interop. |
| `speckit-converge` | `specjedi-converge` | **Full Parity** | Both assess actual code against spec/plan/tasks and append unbuilt work as new tasks. |
| `speckit-taskstoissues` | *(none)* | **No Equivalent** | No GitHub-issue-conversion skill exists anywhere in `.claude/skills/specjedi-*`. Never exercised in this project's own real history. |
| `speckit-agent-context-update` | *(none)* | **No Equivalent — architecturally superseded** | No persistent "current plan" pointer mechanism exists in `specjedi-*` at all — deliberately, per `specjedi-status`'s own zero-parallel-tracking design principle and Constitution Principle XXI's independent `SessionStart` re-surfacing. |

**Full Parity: 8 of 11. Partial Parity: 1 of 11. No Equivalent: 2 of 11.**

## `specjedi-*`'s Own Added Capabilities (FR-005)

27 `specjedi-*` skills exist as of this writing; 16 have no `speckit-*`
counterpart at all — this project's own added value, not a gap:
`specjedi-diagram`, `specjedi-docs`, `specjedi-explain`,
`specjedi-find-skills`, `specjedi-govcheck`,
`specjedi-constitution-audit` (new, specs/043), `specjedi-master`,
`specjedi-migrate`, `specjedi-new-skill`, `specjedi-onboard`,
`specjedi-quick`, `specjedi-release`, `specjedi-retro`,
`specjedi-security`, `specjedi-skill-review`, `specjedi-status`,
`specjedi-tokencheck`, `specjedi-worktree`.

## The Structural Blocker (User Story 2, FR-006)

`.specify/extensions.yml`'s hook-dispatch mechanism (`hooks.
before_specify`, `hooks.after_specify`, `hooks.after_plan`, etc.) is
implemented individually inside every `speckit-*` skill's own
"Pre-Execution Checks"/"Mandatory Post-Execution Hooks" sections —
confirmed present, near-identically worded, in every `speckit-*`
`SKILL.md`. Grepping every `specjedi-*` pipeline skill for the same
hook-checking language returns zero matches (the one `specjedi-*` skill
mentioning "hooks" at all, `specjedi-master`, is about a structurally
different concept — Claude Code `PreToolUse`/`SessionStart` hooks a user
can *install*, not this project's own pipeline-stage hook-dispatch
config).

**Consequence**: this repository's own currently-registered hook (the
optional `speckit.agent-context.update` extension under
`hooks.after_specify`/`hooks.after_plan`) would never fire if
`specjedi-*` skills were substituted directly.

## Dual-Value Distinction

Per spec.md's own Edge Cases, closing `speckit-taskstoissues`'s gap would
also become a shippable `specjedi-*` product feature (GitHub-issue
conversion is generically useful to any project using `specjedi-*`, not
just this one) — that scoping decision is separate from, and not
required by, this project's own internal migration question. The
`extensions.yml` hook-dispatch gap, by contrast, is purely an internal
tooling concern: `specjedi-*`'s external users don't use
`.specify/extensions.yml`'s `speckit.*`-namespaced hook configuration at
all, so closing it has no dual product value — it would be internal-only
engineering work.
