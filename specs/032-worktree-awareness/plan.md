# Implementation Plan: Mechanize Worktree-Awareness

**Branch**: `032-worktree-awareness` | **Date**: 2026-07-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/032-worktree-awareness/spec.md`

## Summary

A new skill, `specjedi-worktree`, mechanizes the worktree-based
parallel-development pattern this project previously only documented as
advice (`references/competitive-comparison.md`'s Spec Kitty row,
`references/honest-assessment.md`'s Improvement Points). It creates a
worktree for a named feature on demand (US1) or proactively offers one
when starting a new feature while the current checkout has real
uncommitted work on a non-trunk branch (US2, narrowed during
`/speckit-clarify` to avoid noise on already-pushed branches). It
prefers a native harness relocation tool when one exists (confirmed
this session: Claude Code's `EnterWorktree`/`ExitWorktree`), falling
back to a project-local, `.gitignore`-verified `.worktrees/` directory
via raw `git worktree` commands otherwise — a design adopted from
Superpowers' own `using-git-worktrees` skill (inspected directly this
session), not invented from scratch. `specjedi-status` gains a matching
extension (US3, FR-006): a single report spanning every worktree of the
repository, not just the current checkout's — the one capability
neither Spec Kitty nor Superpowers' skill provides, and this feature's
genuine Principle II contribution.

## Technical Context

**Language/Version**: N/A — `SKILL.md` prompt content (Markdown +
YAML frontmatter), plus real `git worktree`/`git status`/`git branch`
commands issued directly; no new script files.

**Primary Dependencies**: `git` (worktree support, a mainline feature
since Git 2.5); optionally the host harness's own native worktree
tooling when present (Claude Code's `EnterWorktree`/`ExitWorktree`,
confirmed this session by fetching their real tool schemas).

**Storage**: N/A (git's own `.git/worktrees/` metadata; no
project-level persisted state beyond the `.worktrees/` directory itself
for the git-fallback path).

**Testing**: Principle VI exemption — this feature's deliverable is
`SKILL.md` prompt content plus an extension to another already-shipped
skill's prompt content, not application code with a meaningful
code-level red/green cycle (same exemption class as every prior
`specjedi-*` skill-shipping feature, 001-013/025-028). Verification
takes the form of `quickstart.md`'s scenarios, which include *real*
`git worktree` command execution against this actual checkout (create,
list, and — with explicit confirmation — remove a genuine test
worktree), not just dry-run reasoning, matching the "exhaustive real
execution before shipping" discipline features 023/024 already
established for git/installer-adjacent work.

**Target Platform**: Any of the 20 harnesses in Principle III's
compatibility matrix. Behavior forks cleanly in two tiers: a native-tool
tier (currently confirmed only for Claude Code) and a portable git-only
tier that works identically everywhere `git` itself runs — no
harness-specific content beyond the native-tool detection check itself.

**Project Type**: Single project — a new skill package plus a scoped
extension to one existing skill.

**Performance Goals**: N/A.

**Constraints**: MUST NOT automate destructive operations without
explicit user request and, for anything that would discard uncommitted/
unmerged work, a second explicit confirmation (FR-005, revised from an
absolute "never automate removal" once research.md found the native
tool's own guard already satisfies this project's real concern more
precisely). MUST NOT assume a native relocation tool exists — detect,
never assume (FR-007).

**Scale/Scope**: One new skill (`specjedi-worktree`), one extension to
an existing skill (`specjedi-status`), two proactive-wiring edits
(`specjedi-specify`, `specjedi-quick` — both are "start a new feature"
entry points FR-002 applies to), plus the standard README/roadmap/
genuine-contributions-log/honest-assessment/competitive-comparison/
CHANGELOG updates every shipped feature in this project already
performs.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I**: N/A directly — skill content is English-canonical
  like every other `specjedi-*` skill; no localized-docs implication
  beyond the project's own existing whole-project cadence.
- **Principle II**: Satisfied — see `research.md`. Genuine contribution:
  cross-worktree unified status reporting (US3), which neither Spec
  Kitty's own mechanism nor Superpowers' `using-git-worktrees` skill
  (inspected directly, not just cited) provides.
- **Principle III**: Directly embodied, not just satisfied — the
  native-tool-first/portable-fallback design *is* this principle's own
  "lowest common denominator content, harness-specific adapters layered
  on top" architecture, applied to a concrete new capability rather
  than only installer paths.
- **Principle IV**: The worktree offer (FR-002) is a binary confirm/
  proceed gate, not a multi-option menu — per this principle's own
  explicit scoping clause, it does NOT require an artificial
  Recommended-option table; a clear yes/no ask is the correct, already-
  compliant shape.
- **Principle V**: Satisfied — `spec.md` carries zero open
  `[NEEDS CLARIFICATION]` markers after `/speckit-clarify`.
- **Principle VI**: Exemption stated above in Technical Context.
- **Principle IX**: Satisfied via the existing structural lint
  (`scripts/validate.sh`'s `SKILL.md` frontmatter/layout check, which
  automatically covers the new skill file) plus `quickstart.md`'s
  real-command-execution scenarios (battery item (b)/(c)) — no new CI
  job invented for this feature; the battery-growth-trigger check
  itself (`scripts/validate.sh`) will flag if that assessment turns out
  wrong once the skill is actually written.
- **Principle X**: Standard feature-branch → PR → `ci-gate` → auto-merge
  flow, as always.
- **Principle XIII**: Satisfied by construction — no new `scripts/*.sh`/
  `.ps1` files (research.md's Assumption), and `git worktree` itself is
  a single cross-platform git subcommand with no OS-specific behavior
  fork needed at the skill-content level.
- **Principle XIV**: The skill's own output MUST offer clear next steps
  per this principle — standard for every skill, enforced at authoring
  time (Principle XIX) and checked by `specjedi-skill-review`/
  `specjedi-govcheck` before merge, same as every prior skill.
- **Principle XV**: `specjedi-worktree` — compliant naming.
- **Principle XVI**: No diagram needed for this skill's own
  documentation — a short, linear create/list/cleanup flow doesn't
  clear this principle's own "diagram earns its keep" bar; consistent
  with the `/speckit-clarify`-informed minimal-format discipline this
  session already applied to feature 031's README section.
- **Principle XVII**: `specjedi-worktree` carries the standard
  standing self-invoke-`specjedi-find-skills` contract like every
  `specjedi-*` skill. Distinctly, it is itself the proactive-invocation
  *target* for `specjedi-specify` and `specjedi-quick` (FR-002) — the
  same "principle mandates a capability, a dedicated skill gives it a
  product surface, wired proactively into the entry-point skill(s)"
  precedent `specjedi-plan`→`specjedi-security` and `specjedi-onboard`→
  `specjedi-tokencheck` already established.
- **Principle XVIII**: N/A — not installer work.
- **Principle XIX**: Full Skill Authoring Standard applies to the new
  `SKILL.md` — structure, ruthless literalness, progressive disclosure,
  Always/Never guardrails, verifiable success criteria, explicit
  human-approval boundaries (the worktree-creation offer and the
  removal-confirmation gate are exactly this principle's "state which
  actions are autonomous and which require explicit confirmation"
  requirement in concrete form), persona/task/format/few-shot/
  chain-of-thought/audience-calibration prompt-engineering discipline —
  enforced during implementation (tasks.md), checked by
  `specjedi-skill-review` before merge.
- **Principle XX**: Directly modeled in this very plan — the native-tool
  claim is grounded in a real tool-schema fetch this session, not
  assumed; the competitive claim is grounded in actually reading
  Superpowers' installed skill file, not just citing its name from
  prior research.
- **Principle XXI**: N/A.
- **Distribution & Ecosystem Standards**: README's skill table/mindmap/
  badge row gain the new skill entry (skill count 24→25); badge-row
  review runs per the standing pre-PR requirement.
- **Development Workflow**: This exact pipeline (research → specify →
  clarify → plan → tasks → implement → validation → PR) is being
  followed live for this feature.

No violations requiring justification. Complexity Tracking table is
empty by design.

## Project Structure

### Documentation (this feature)

```text
specs/032-worktree-awareness/
├── plan.md              # This file
├── research.md          # Phase 0 output — competitive analysis + native-tool/directory-convention decisions
├── quickstart.md         # Phase 1 output — real-command validation scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not created by /speckit-plan)
```

`data-model.md` and `contracts/` are intentionally omitted: no data
entities (spec.md's Key Entities section is explicitly not applicable)
and no external interface beyond the skill's own Markdown instructions
and the git commands/native tool calls it issues.

### Source Code (repository root)

```text
.claude/skills/
├── specjedi-worktree/         # NEW — the mechanized worktree skill
│   └── SKILL.md
├── specjedi-status/
│   └── SKILL.md               # MODIFIED — worktree enumeration (FR-006)
├── specjedi-specify/
│   └── SKILL.md               # MODIFIED — proactive offer wiring (FR-002)
└── specjedi-quick/
    └── SKILL.md               # MODIFIED — proactive offer wiring (FR-002)

README.md                       # MODIFIED — skill table/mindmap/badge (24→25 skills)
CHANGELOG.md                    # MODIFIED — new entry
references/
├── skill-roadmap.md            # MODIFIED — Shipped section entry
├── genuine-contributions-log.md # MODIFIED — new row (Principle II claim)
├── honest-assessment.md        # MODIFIED — closes the worktree Disadvantage/Improvement Point
└── competitive-comparison.md   # MODIFIED — Spec Kitty row's "Rejected" cell updated per that doc's own Maintenance rule
```

No `.worktrees/` directory is created by this plan itself — that's a
runtime artifact the shipped skill creates in *target* projects (and,
during `quickstart.md`'s real-execution validation, transiently in this
repository itself, cleaned up before the PR opens).

**Structure Decision**: One new skill package, one extension to an
existing skill, two small proactive-wiring edits to skill-entry-point
files, and the standard set of doc/reference updates every shipped
`specjedi-*` skill in this project's history already performs. No new
top-level directories, no new scripts.

## Complexity Tracking

*No Constitution Check violations — this section is intentionally empty.*
