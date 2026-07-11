# Changelog

All notable changes to Spec Jedi are documented here, drafted by
`specjedi-docs` from each feature's own spec/plan and confirmed before
being written. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/) — version numbers come
from `scripts/suggest-release.sh` (Constitution Principle XI), not from
this file directly.

## Unreleased

### Added

- `scripts/validate.sh`/`.ps1` — automated, non-blocking Principle IX
  validation-battery-growth-trigger check: warns the moment the repo
  gains a test-pattern file, a language runtime manifest, or a web UI
  marker not yet covered by a matching CI job. Closes
  `checklists/project-completeness.md` CHK004.
- `specjedi-govcheck` ⚖️ — strictly read-only per-PR/per-branch governance
  compliance checklist against all 20 constitution principles plus the
  Distribution & Ecosystem Standards and Development Workflow sections —
  three-state report (N/A / Compliant / Non-Compliant), any conflict
  CRITICAL. Self-invoked by `specjedi-implement` before opening a PR
  (never blocks it); also runs standalone (feature 013).
- `.specify/memory/skill-gaps.md` — first entries logged by
  `specjedi-find-skills`, surveying candidate domains this project's own
  skill set doesn't cover well (localization/i18n workflow, CI/CD
  authoring depth, accessibility depth, security-review depth).
- `references/principle-traceability.md` — canonical index mapping every
  constitution principle to its implementing skill/script/CI mechanism or
  explicit tracked gap; closes `checklists/project-completeness.md`
  CHK001.
- `checklists/project-completeness.md` — a project-wide requirements-
  completeness audit (19 items) run via `/speckit-checklist` against the
  constitution itself rather than a single feature.
- `specjedi-tokencheck` 🎒 — mechanizes Principle VIII: proactively checks
  whether `rtk` and `graphify` are installed, explains what's missing and
  its expected token savings, and offers an install walkthrough; never
  installs anything without explicit confirmation. Self-invoked by
  `specjedi-onboard`'s first-run flow, also runs standalone (feature 012).
- `specjedi-skill-review` 🎓 — strictly read-only audit of an existing
  `specjedi-*` skill's `SKILL.md` against the Skill Authoring & Prompt
  Engineering Standard, distinguishing missing from weak sections and
  cross-referencing the matching `plan.md` for legitimate exemptions;
  never edits the reviewed file (feature 011).
- `specjedi-release` 🚀 — wraps `scripts/suggest-release.sh`/`.ps1` with
  Spec Jedi's own voice, narrating the last tag, suggested next version,
  and contributing commits; declines and names the manual command if
  asked to actually cut a release (feature 010).
- `specjedi-new-skill` 🌟 — scaffolds a new `specjedi-*` skill's file
  structure, placeholders only, following this project's own Skill
  Authoring Standard (feature 009).
- `specjedi-docs` 📚 — drafts a README skill-table row, Quickstart step,
  and this changelog's own entries from a shipped feature's spec/plan,
  grounded in actual content, always confirmed before writing
  (feature 008).
- `specjedi-security` 🛡️ — lightweight, proactive "did we think about X"
  prompt for auth/input validation/secrets/data-privacy gaps, self-invoked
  by `specjedi-plan`; never claims to be a full security review
  (feature 007).
- `specjedi-retro` 🪞 — strictly read-only retrospective comparing a
  completed feature's actual implementation against its `plan.md`,
  grounding any deviation's cause in real git history, logging a durable
  entry to `.specify/memory/retro-log.md` (feature 006).
- `specjedi-status` 🧭 — project-wide dashboard deriving every feature's
  status entirely from on-disk `spec.md`/`plan.md`/`tasks.md` artifacts,
  zero separately-maintained tracking system (feature 005).
- `specjedi-diagram` 📊 — generates a render-verified Mermaid diagram
  (flowchart, sequence, or ER) from an existing spec/plan, always a
  supplement to the source prose (feature 004).
- `specjedi-migrate` 🔄 — rewrites literal `/speckit-*` tooling references
  to their `specjedi-*` equivalents, never touching principle or
  requirement content (feature 003).
- `specjedi-onboard` 🌱 — first-run walkthrough producing a real first
  `constitution.md` and `spec.md` together, teaching each SDD concept
  exactly when it's needed (feature 002).
- Zero-footprint installer (`scripts/install.sh`/`.ps1`) — copies only the
  `specjedi-*` product skills into a target project, with harness
  selection and post-install validation.
- `CONTRIBUTING.md` and GitHub issue/PR templates walking contributors
  through the research and validation requirements before review.
- The full 9-stage `specjedi-*` SDD pipeline (`specjedi-constitution`
  through `specjedi-converge`) — constitution, specify, clarify, plan,
  tasks, implement, analyze, checklist, converge (feature 001).

### Changed

- README badge row corrected: `Roadmap` badge updated from stale
  `7/7 shipped` to accurate `11/11 shipped`; new `Skills` badge added
  (`22 shipped`) — found by `checklists/project-completeness.md`.
- README's Installation section corrected from a stale "12 `specjedi-*`
  product skills" count to the accurate 22.
- README's "Supported harnesses" table expanded from ~8 named tools
  collapsed into one "and others" row to all 20 harnesses named
  individually, per Principle III's "at least twenty" mandate — status
  only, no fabricated capability claims.
- `specjedi-explain` and `specjedi-find-skills` brought into full
  compliance with the Skill Authoring Standard (`specjedi-explain` was
  missing its `Format` and `` `--auto` mode `` sections; `specjedi-
  find-skills` was missing its `` `--auto` mode `` section) — found by
  `specjedi-skill-review`'s own first real dry run.
- All 12 shipped pipeline/roadmap skills brought into compliance with
  Principle XIV's bulleted next-step format, Principle XX's chain-of-thought
  and token-economy requirements, and Principle XII's Star Wars voice
  (previously documented but unimplemented in skill output).
- Every shipped skill now states its `Autonomous vs. confirm-first`
  boundary explicitly, per Principle XIX.

## Extending this file

New entries land under `## Unreleased` as features ship, drafted by
`specjedi-docs` and confirmed before writing — never a version number
here directly; that's `scripts/suggest-release.sh`'s call to make.
