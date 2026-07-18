# Research: `specjedi-*`/`speckit-*` Parity Ledger & Migration Readiness

**Feature**: specs/044-speckit-parity-audit
**Date**: 2026-07-18

This document performs the actual comparison spec.md's User Story 1
requires — the "technical decision" this plan resolves is *how* to
produce the ledger, and the ledger itself is that resolution's direct
output, verified against each skill's real `SKILL.md` frontmatter and
body (never inferred from name alone, per FR-002).

## Decision 1: this is a one-time analysis deliverable, not a new skill

**Decision**: Ship this feature's output as a single Markdown report —
`specs/044-speckit-parity-audit/PARITY-LEDGER.md` — not a new
`specjedi-*` or `speckit-*` skill.

**Rationale**: Unlike specs/043 (constitution compliance, a genuinely
recurring concern as new features ship), this feature's core question —
"is `specjedi-*` ready to replace `speckit-*` for this project's own
development?" — has a natural endpoint: once acted on (gaps closed or
explicitly waived), the question is answered and doesn't need re-asking
on a recurring cadence the way constitutional drift does. Building a
permanent skill for a point-in-time decision would be exactly the kind
of premature abstraction this project's own coding-style discipline
warns against ("three similar lines is better than a premature
abstraction").

**Alternatives considered**: A reusable `specjedi-parity-check` skill.
Rejected for now — nothing in spec.md's User Stories implies this needs
re-running on a schedule; if the maintainer later wants to re-verify
after closing gaps, re-running this same analysis by hand (or asking for
this spec's work again) costs less than maintaining a skill whose only
job is a question this project will only ask a handful of times total.

## Decision 2: the parity ledger (User Story 1)

Built by reading every `speckit-*` skill's actual frontmatter
`description` and body against its apparent `specjedi-*` counterpart —
not name-matching alone (FR-002).

| `speckit-*` command | `specjedi-*` counterpart | Verdict | Evidence |
|---|---|---|---|
| `speckit-specify` | `specjedi-specify` | **Full Parity** | Both turn a feature idea into a prioritized spec.md. `specjedi-specify` additionally welcomes a rougher one-sentence starting point — a superset, not a regression. |
| `speckit-clarify` | `specjedi-clarify` | **Full Parity** | Both scan for real ambiguity, ask up to 5 targeted questions, write answers back into spec.md. `specjedi-clarify` adds proactive self-invocation after `specjedi-specify` — additive. |
| `speckit-plan` | `specjedi-plan` | **Full Parity** | Both turn a clarified spec into plan.md (+ research.md/data-model.md as needed). |
| `speckit-tasks` | `specjedi-tasks` | **Full Parity** | Both break plan.md into a dependency-ordered, user-story-organized tasks.md. |
| `speckit-implement` | `specjedi-implement` | **Partial Parity** | Both execute tasks.md in order. **Divergence, confirmed by reading both `SKILL.md` bodies**: `speckit-implement`'s own instructions contain no git branch/commit discipline at all — it only processes tasks. `specjedi-implement`'s own frontmatter explicitly requires "committing only through a feature branch and pull request — never directly to the trunk" (Constitution Principle X), plus a bounded CI-monitor-and-fix mandate this project's own constitution v1.27.0 added. This project's actual practice already goes through PRs by session discipline even under `speckit-implement`, but that discipline is convention, not something the skill itself enforces. |
| `speckit-analyze` | `specjedi-analyze` | **Full Parity** | Both perform non-destructive cross-artifact consistency checks across spec/plan/tasks. `specjedi-analyze` additionally checks the constitution when present — additive. |
| `speckit-checklist` | `specjedi-checklist` | **Full Parity** | Both generate a focus-area checklist grounded in the current feature. |
| `speckit-constitution` | `specjedi-constitution` | **Full Parity** | Both create/amend a project constitution. `specjedi-constitution`'s own frontmatter explicitly notes it reads an existing `speckit-*`-produced `constitution.md` if present — deliberate interop, not an accidental gap. |
| `speckit-converge` | `specjedi-converge` | **Full Parity** | Both assess actual code against spec/plan/tasks and append unbuilt work as new tasks. |
| `speckit-taskstoissues` | *(none)* | **No Equivalent** | Confirmed: no `specjedi-taskstoissues` or equivalent GitHub-issue-conversion skill exists anywhere in `.claude/skills/specjedi-*`. This project's own workflow has never used `speckit-taskstoissues` in its real history (tasks.md checkboxes are tracked in-file, not as GitHub issues, in every shipped feature to date) — a real gap in principle, but not one this project's own actual practice has ever exercised. |
| `speckit-agent-context-update` | *(none)* | **No Equivalent — but architecturally superseded, not merely missing** | Confirmed: no `specjedi-agent-context-update` exists, and `specjedi-plan`'s own `SKILL.md` has no equivalent step for maintaining a persistent "current plan" pointer in a memory file at all (checked directly — zero matches for `CLAUDE.md`/marker-update language). This isn't an oversight: `specjedi-status`'s own frontmatter states its design principle directly — "zero separately-maintained tracking system," deriving status from on-disk artifacts fresh each time instead of maintaining a pointer that can go stale. Constitution Principle XXI's `SessionStart` hook independently re-surfaces project status every session. `specjedi-*`'s own `update_memory_file` mechanism (specs/039, a *different* marker: `<!-- SPEC-JEDI:SKILLS:START/END -->`) maintains a target project's installed-skill listing, not a "most recent plan" pointer — a related but genuinely different job, confirmed by reading `scripts/install.sh`'s actual implementation. |

**Full Parity: 8 of 11. Partial Parity: 1 of 11 (`speckit-implement`). No
Equivalent: 2 of 11** (`speckit-taskstoissues`,
`speckit-agent-context-update`).

## Decision 3: `specjedi-*`'s own added capabilities (User Story 1, FR-005)

Sixteen `specjedi-*` skills exist with no `speckit-*` counterpart at all
— confirmed by enumerating `.claude/skills/` directly: `specjedi-diagram`,
`specjedi-docs`, `specjedi-explain`, `specjedi-find-skills`,
`specjedi-govcheck`, `specjedi-master`, `specjedi-migrate`,
`specjedi-new-skill`, `specjedi-onboard`, `specjedi-quick`,
`specjedi-release`, `specjedi-retro`, `specjedi-security`,
`specjedi-skill-review`, `specjedi-status`, `specjedi-tokencheck`,
`specjedi-worktree`. Reported as this project's own added value per
FR-005 — not a gap of any kind.

## Decision 4: the non-command blocking mechanism (User Story 2 Scenario 3, FR-006)

**Finding**: `.specify/extensions.yml`'s hook-dispatch mechanism (`hooks.
before_specify`, `hooks.after_specify`, `hooks.after_plan`, etc.) is
implemented individually inside every `speckit-*` skill's own "Pre-
Execution Checks"/"Mandatory Post-Execution Hooks" sections — confirmed
present, near-identically worded, in every `speckit-*` `SKILL.md` read
during this analysis. Grepping every `specjedi-*` pipeline skill
(`specify`, `clarify`, `plan`, `tasks`, `implement`, `analyze`,
`checklist`, `constitution`, `converge`) for the same
`extensions.yml`/hook-checking language returns **zero matches** — the
only `specjedi-*` skill mentioning "hooks" at all
(`specjedi-master`) is about a structurally different concept
(Claude Code `PreToolUse`/`SessionStart` hooks it can help a user
*install*, not this project's own pipeline-stage hook-dispatch config).

**Consequence**: this repository's own currently-registered hook
(`hooks.after_specify`/`hooks.after_plan`, the optional
`speckit.agent-context.update` extension) would simply never fire if
`specjedi-*` skills were substituted directly — `specjedi-*` skills have
no code path that reads `.specify/extensions.yml` at all. This is a
second, independent blocking finding beyond the two command gaps above:
even a `specjedi-taskstoissues`-equivalent skill existing wouldn't help
if nothing in the `specjedi-*` family ever checks
`hooks.after_tasks`/etc. in the first place.

## Decision 5: migration readiness recommendation (User Story 2)

**Recommendation**: **Not yet safe for a full, immediate internal
migration.** Three concrete blockers, each with a distinct next step:

| Blocker | Needed to migrate internally? | Concrete next step |
|---|---|---|
| `speckit-taskstoissues` has no `specjedi-*` equivalent | No — this project's own workflow has never actually used GitHub-issue conversion in its real history (Decision 2) | Confirm with the maintainer this capability isn't needed internally; if ever wanted, scope as a genuine `specjedi-taskstoissues` product feature (dual value — also benefits `specjedi-*`'s external users), separate follow-up work |
| `speckit-agent-context-update` has no `specjedi-*` equivalent | No — architecturally superseded by `specjedi-status`'s zero-parallel-tracking design and Principle XXI's `SessionStart` hook (Decision 2) | No action needed; explicitly document this as an intentional design difference, not a gap to close |
| `.specify/extensions.yml`'s hook-dispatch mechanism has no `specjedi-*` implementation | **Yes** — this repo's own `extensions.yml` has live, registered hooks (`after_specify`, `after_plan`) that would silently stop firing | Either (a) extend `specjedi-*`'s pipeline skills with equivalent hook-check/dispatch logic, or (b) confirm the currently-registered hooks are non-essential and can be retired before migrating |
| `speckit-implement` vs. `specjedi-implement` behavioral divergence | **No — favorable, not blocking** | `specjedi-implement`'s stricter trunk-based-PR discipline is a strict improvement over `speckit-implement`'s silence on the matter; nothing to build, this divergence argues *for* migrating this specific command, not against it |

**Overall**: two of the three real blockers require no new engineering
work at all (they're resolved by explicit maintainer acknowledgment that
the "gap" is either unused or already superseded by a better mechanism).
Only the `extensions.yml` hook-dispatch gap is a genuine, must-close
blocker before a full migration — and even that has a narrow, well-
understood scope (one optional hook, one extension).
