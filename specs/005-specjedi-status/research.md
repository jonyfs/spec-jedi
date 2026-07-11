# Research: `specjedi-status`

**Feature**: 005-specjedi-status

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

`references/skill-roadmap.md` ranks `specjedi-status` next after
`specjedi-diagram` (feature 004): "a project-wide dashboard skill: which
features have a spec/plan/tasks, which are mid-implementation, which are
stalled — useful once a project has more than one or two features in
flight." This repo's own `specs/` directory already holds five feature
directories (001-005) by the time this skill ships — the exact scale
where "which of these am I actually still working on" stops being
answerable by memory alone.

## Genuine contribution beyond the researched field

None of the eleven tools researched (spec-kit + the ten from feature 001,
re-checked here for status/dashboard tooling) ship a skill that derives
project status **entirely from artifact state on disk** — existence of
`spec.md`/`plan.md`/`tasks.md`, and the checkbox completion ratio inside
`tasks.md` — with zero separate tracking system to keep in sync. Every
dashboard-style mechanism found in the researched tools (where one exists
at all) requires a separate status field, ticket, or board entry a human
has to remember to update. `specjedi-status` never asks anyone to update
anything: the source of truth is the same `tasks.md` checkbox convention
every `specjedi-*` skill this project ships already reads and writes, so
status is a read of existing fact, never a maintained fiction.

## Baseline: GitHub spec-kit

No cross-feature dashboard in its command surface — each `speckit-*`
command operates on one feature at a time, no aggregate view. **Adopt**:
nothing (no mechanism to adopt). **Reject**: none applicable.

## Researched competitors (re-checked for status/dashboard tooling)

1. **BMAD-METHOD** — no cross-feature dashboard found in its agent set.
2. **OpenSpec** — lightweight-path philosophy; no aggregate status view.
3. **Kiro** — per-spec structured docs; no cross-project dashboard found
   in its public surface.
4. **Tessl** — no status/dashboard tooling found.
5. **Spec Kitty** — CLI wizard scope; no cross-feature status view.
6. **Superpowers** (installed, inspected firsthand) — no project-wide
   status mechanism in its skill set.
7. **GSD** (installed, inspected firsthand) — `gsd-roadmapper` produces a
   roadmap document, and phase tracking exists within a single project's
   plan, but no derived-from-artifacts dashboard comparable to what's
   proposed here — GSD's status lives in its own tracked files, not
   inferred from checkbox state.
8. **PRP** (installed, inspected firsthand) — no dashboard mechanism.
9. **codemyspec.com** — web UI likely has some project view, but no
   portable, artifact-derived status mechanism comparable to a file-based
   skill.
10. **Traycer** — plan-review focused; no cross-feature dashboard found.

Every researched tool either has no aggregate status view or requires a
separately maintained tracking artifact. **Adopt**: nothing directly
transferable — this confirms the "derive from disk, never a separate
system" design choice is the actual differentiator, not an adaptation of
existing prior art.

## Design implications for `specjedi-status`

- **Zero new tracked state** — the skill MUST NOT create or require a
  separate status file, ticket system, or manually-updated field. Status
  is always derived fresh from what's actually on disk at run time.
- **Derivation rules MUST be simple and inspectable**: a feature directory
  with only `spec.md` is "specified"; with `spec.md` + `plan.md` is
  "planned"; with `tasks.md` present, status becomes a checkbox
  completion ratio (0% = "not started," partial = "in progress," 100% =
  "complete"). "Stalled" is a judgment call (see below), not a hard
  threshold — this project's own `specs/003-specjedi-migrate/tasks.md`
  reaching 100% the same day it was created is normal here, not evidence
  a fixed time-based staleness rule would be meaningful across different
  team paces.
- **Grounding discipline**: every status line MUST trace to an actual
  file/checkbox observed this run — never inferred from a feature's name
  or assumed from convention.
