# Changelog

All notable changes to Spec Jedi are documented here, drafted by
`specjedi-docs` from each feature's own spec/plan and confirmed before
being written. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/) — version numbers come
from `scripts/suggest-release.sh` (Constitution Principle XI), not from
this file directly.

## Unreleased

### Added

- **Warp harness support** (feature 018) — the fourth real, CI-proven
  supported harness, and the second requiring zero new installer code.
  Verified via Warp's own official Skills documentation
  (docs.warp.dev/agent-platform/capabilities/skills/) that Agent Mode
  scans ten directory names including `.claude/skills/` and
  `.agents/skills/` directly — a separate capability from Warp's
  `AGENTS.md`/`WARP.md` Rules mechanism, which an initial (incomplete)
  research pass had mistakenly treated as Warp's only convention. New
  `warp-compatibility` CI job asserts both existing install paths
  against Warp's specific documented rules. `scripts/install.sh`/`.ps1`
  unchanged.
- **OpenCode harness support** (feature 017) — the third real, CI-proven
  supported harness, and the first requiring **zero new installer code**:
  verified via OpenCode's own official docs that it natively scans both
  `.claude/skills/` and `.agents/skills/`, the exact paths the existing
  `claude-code`/`codex-cli` install paths already write to, with an
  identical `SKILL.md` frontmatter format. A direct audit confirmed all
  23 `specjedi-*` skill names already satisfy OpenCode's exact naming
  rule. New `opencode-compatibility` CI job asserts both existing install
  paths against OpenCode's specific documented rules (not just reused
  generic checks). README updated; `scripts/install.sh`/`.ps1` are
  unchanged (confirmed via `git diff`).

### Fixed

- Constitution `TODO(SESSION_START_HOOK)` was still listed as open even
  though feature 015 actually shipped and merged the mechanism it
  tracked — a `/speckit-constitution` audit caught the stale bookkeeping
  and closed it (v1.20.1, PATCH). The one genuinely separate open item
  (a live session confirming the greeting renders end to end) stays
  tracked in `references/principle-traceability.md`, not as a
  constitution-level TODO.
- All 10 localized `docs/i18n/<lang>/README.md` files had drifted after
  feature 016's README edit (Codex CLI's intro paragraph + table row) —
  translated and resynced.

### Added

- **Codex CLI (OpenAI) install path** (feature 016) — `scripts/install.sh`/
  `.ps1 --harness codex-cli` now installs all 23 `specjedi-*` skills to
  `.agents/skills/`, the second real, CI-proven harness beyond Claude
  Code. Verified via Codex CLI's own official docs that its `SKILL.md`
  frontmatter requirement (`name`, `description`) already matches this
  project's own skills unmodified — a direct grep audit confirmed zero
  skills hardcode Claude-Code-specific content, so no content rewrite
  was needed, only a new install-target branch. New
  `install-test-codex-cli`/`-windows-native` CI jobs mirror the existing
  `install-test` job pattern exactly. README's compatibility table
  updated; verification is honestly scoped as structural (file
  placement, frontmatter validity), not an actual Codex CLI run.
- `scripts/session-start.sh`/`.ps1` (feature 015) — implements Principle
  XXI's `SessionStart` hook: an ASCII Spec Jedi banner, a project status
  summary derived from `specjedi-status`'s own on-disk logic, and a
  context-aware rotating Master Yoda greeting line, registered in
  `.claude/settings.json` and paired with the required `CLAUDE.md` render
  instruction. Real dry runs caught and fixed two genuine bugs before
  shipping: a `grep -c`/`|| echo 0` double-counting bug, and a Yoda-line
  selector that could pick the "empty project" line for a 15-feature
  project (now filtered by actual on-disk state) — plus a word-wrapped
  quote extraction bug in the PowerShell/bash line-parsing logic. The one
  remaining unverified item is a live, real Claude Code session actually
  rendering the greeting end to end — not observable from within the same
  session that built it.
- Constitution Principle XXI (Session-Start Orientation & the Master
  Yoda Greeting, v1.20.0, MINOR): policy for a three-part session-start
  orientation (ASCII Spec Jedi banner, `specjedi-status`-derived project
  summary, rotating Master Yoda greeting line). Precisely documents the
  real Claude Code `SessionStart` hook mechanism (stdout becomes
  `additionalContext`, not a direct terminal print — verified against
  official docs before writing) and requires both a hook and a
  `CLAUDE.md` render instruction, not a hook alone. Explicitly defers
  the actual build to a Principle II-gated feature cycle, tracked as
  `TODO(SESSION_START_HOOK)` / feature 015 — not built ad hoc under this
  amendment.
- `references/star-wars-lexicon.md` gained a dedicated Master Yoda
  Persona section: speech patterns (inverted object-subject-verb
  construction, terse aphorisms) and a starter rotation pool of lines,
  scoped narrowly to the session-start greeting rather than general
  end-user dialogue.

### Changed

- Constitution Principle XVI renamed "Mermaid-First Process Documentation"
  → "Efficient Documentation & Mermaid Diagram Literacy" (v1.19.0, MINOR):
  every `specjedi-*` skill must now actively evaluate the most efficient
  documentation format (prose/table/list/diagram) rather than defaulting
  to a diagram out of habit, and any diagram-producing skill must know
  Mermaid's full current diagram-type catalog, not just flowchart/
  sequence/ER. New canonical reference
  `references/mermaid-diagram-catalog.md` (30 diagram types, grounded in
  two independently cross-checked fetches of mermaid.js.org's syntax
  reference). `specjedi-diagram` (feature 004) updated in the same PR:
  active type-inference broadened from 3 to 12 Core-tier types, and it
  now names Specialized-tier types explicitly instead of always falling
  back to `specjedi-find-skills`.

### Fixed

- `references/principle-traceability.md` had gone stale: five rows
  (Principles I, VI, XVII, XX, and the Distribution & Ecosystem Standards
  cross-cutting row) still cited CHK002/007/011/015/018 as open gaps,
  even though PR #58 had already resolved all five — that PR never
  updated this file despite its own Maintenance instruction to do so.
  Found via a `/speckit-constitution` compliance audit; corrected all
  five rows, and strengthened the Maintenance note to name this exact
  failure mode. Only Principle III remains genuinely 🟡 Partial (19 of 20
  harnesses still lack a built, tested install path).
- Localized `docs/i18n/<lang>/README.md` files (all 10 languages) had
  fallen one commit behind English after feature 014's README edit — the
  drift-check correctly flagged it (non-blocking WARN). Translated the
  two new sentences into all 10 languages and updated each file's
  `i18n-sync` marker to the current source commit.

### Added

- `references/competitive-comparison.md` — an 11-row table comparing Spec
  Jedi to spec-kit and the ten other researched SDD/agent-skill tools,
  reusing `specs/001-specjedi-pipeline/research.md`'s existing citations
  rather than performing new competitor research; linked from `README.md`
  (feature 014, shipped via the literal `speckit-specify` →
  `speckit-plan` → `speckit-tasks` → `speckit-implement` pipeline).
- `references/harness-capability-notes.md` — desk-research capability
  matrix for all 19 non-Claude-Code harnesses in Principle III's
  compatibility table (mechanism, cited source, Yes/Unclear call per
  harness); flags that Gemini CLI is being sunset in favor of Antigravity
  CLI (2026-06-18). Closes `checklists/project-completeness.md` CHK002.
- `references/genuine-contributions-log.md` — durable index of every
  shipped feature's Principle II "genuine contribution" claim, linking
  back to each `research.md`, with a maintenance rule for future
  features. Closes `checklists/project-completeness.md` CHK013.
- `.github/workflows/validate.yml` gained `tokencheck-detection`
  (ubuntu/macos/windows matrix) and `tokencheck-detection-windows-native`
  jobs, both required by `ci-gate`, proving `specjedi-tokencheck`'s
  `which`/`where` present/absent detection logic for real on every OS
  Principle XIII requires. Closes `checklists/project-completeness.md`
  CHK016.
- Localized documentation (`docs/i18n/<lang>/README.md` and
  `CONTRIBUTING.md`) in ten languages — Mandarin Chinese, Hindi, Spanish,
  French, Arabic, Bengali, Portuguese (Brazilian), Russian, Urdu, and
  Indonesian — AI-assisted translations, English canonical.
  `scripts/validate.sh`/`.ps1` gained an automated, non-blocking
  sync-drift check flagging any localized doc whose recorded source
  commit has fallen behind the English file's actual latest commit.
  Closes `TODO(LOCALIZATION)` (open since constitution v1.15.14) and
  `checklists/project-completeness.md` CHK003/CHK006 — Principle I
  amended to name the ten languages concretely instead of a re-derivable
  "ten most-spoken" (v1.17.0 shipped the first six; v1.18.0 extended to
  the full ten on explicit maintainer direction).
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

- `checklists/project-completeness.md` — all 19 items now resolved.
  CHK011 (retroactive badge-row review gap) and CHK015 (Principle XX
  retrospective-audit gap) closed by construction/reasoning rather than
  new infrastructure: `specjedi-govcheck`'s mandatory per-PR self-invoke
  already makes the former structural going forward, and git's own
  append-only history already is the latter's audit trail.
- Constitution Principle III clarified: the compatibility-matrix
  re-verification trigger now explicitly names Principle XI's MAJOR
  product release line, not the constitution's own version number.
- Constitution Development Workflow section corrected: localization
  (Principle I) runs on its own whole-project cadence, not as a
  per-feature pipeline step — matching what actually happened.
- All 12 pre-existing feature plans (`specs/001-*` through `specs/012-*`)
  updated to explicitly cite their Principle VI test-first exemption,
  matching the precedent feature 013 already set.
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
