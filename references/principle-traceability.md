# Constitution Principle → Mechanism Traceability

Canonical mapping from each Core Principle in
[`.specify/memory/constitution.md`](../.specify/memory/constitution.md) to
the specific skill, script, CI job, or process convention that implements
it — or an explicit tracked gap when none exists yet. Closes
`checklists/project-completeness.md` items CHK001/CHK005: this mapping
previously lived only scattered across `references/skill-roadmap.md` prose
and individual constitution Sync Impact Report entries.

**Maintenance**: update this table in the same PR that ships a skill/script
closing a principle's gap, or that meaningfully changes which mechanism
implements a principle. This explicitly includes a PR that closes a
`checklists/project-completeness.md` item cross-referenced from a row
below — five rows in this table (I, VI, XVII, XX, Distribution &
Ecosystem Standards) went stale exactly this way after PR #58 closed
CHK002/007/011/015/016 without this file being updated in the same PR,
caught later by a `/speckit-constitution` audit and corrected here. This
file doesn't replace the constitution's own Sync Impact Report history
(that remains the authoritative amendment record) — it's a fast lookup
index derived from it, and like any fact-bearing index in this project
(badges, skill counts), it drifts silently if a shipping PR forgets it.

| # | Principle | Status | Implementing mechanism |
|---|---|---|---|
| I | English-Source, Globally-Localized Documentation | ✅ Mechanized | English-source enforced by review convention (no automated check). Localization: `docs/i18n/<lang>/` ships README/CONTRIBUTING in all ten mandated languages (zh, hi, es, fr, ar, bn, pt, ru, ur, id); `scripts/validate.sh`/`.ps1` flags (non-blocking) any localized file whose recorded `i18n-sync` commit has fallen behind the English source. `TODO(LOCALIZATION)` closed. |
| II | Competitive Research Before Creation | ✅ Mechanized (process) | Every `specs/NNN-*/research.md`, required before `speckit-plan`; enforced by the Development Workflow section and reviewer judgment — no automated check that a `research.md` exists or meets the bar. |
| III | Universal LLM & Harness Compatibility | 🟡 Partial | README's "Supported harnesses" table names all 20 harnesses individually; `references/harness-capability-notes.md` documents a real per-harness capability matrix. **Five harnesses now real and CI-proven**: Claude Code (feature 001), Codex CLI (feature 016, `--harness codex-cli` → `.agents/skills/`), OpenCode (feature 017), Warp (feature 018, Agent Mode's separate Skills system), and **Trae** (feature 019, `--harness trae` → `.trae/skills/`) — OpenCode and Warp needed zero new installer code (both scan `.claude/skills/`/`.agents/skills/` directly); Codex CLI and Trae each needed a genuinely new installer branch, since neither's documented Skills directory (`.agents/skills/`, `.trae/skills/`) was already a target. Each verified via a dedicated CI job asserting that harness's exact rules, not just reused generic checks. Feature 019's own research investigated a contradictory GitHub bug report and traced it to a path mismatch in the report itself, not a real gap in Trae's documented convention — corroborated by Vercel's own `skills` CLI source as a first-party executable specification. What remains genuinely open: 15 of 20 harnesses have no built/proven install path yet. |
| IV | Structured, Opinionated Elicitation (Ask, Don't Assume) | ✅ Mechanized (convention) | Baked into every `specjedi-*` skill's own step-by-step (e.g., `specjedi-specify`'s NEEDS CLARIFICATION discipline, `specjedi-clarify`'s question loop); checked per-skill only via `specjedi-skill-review`'s Skill Authoring Standard subset, not a dedicated Principle IV check. **v1.22.0** generalizes `specjedi-clarify`/`specjedi-onboard`'s existing Recommended-option pattern project-wide: any genuine multi-choice question a skill presents MUST mark a Recommended option, and `--auto` mode MUST follow it — grounded in a real audit finding only those two skills currently have genuine multi-option elicitation (both already compliant, so no content retrofit was needed), with the standard now codified in `references/skill-authoring-standard.md`'s Quality Bar/Review checklist for every future skill. |
| V | Specification Completeness for Autonomous Execution | ✅ Mechanized | `specjedi-specify` (NEEDS CLARIFICATION markers), `specjedi-clarify` (resolution loop), `specjedi-analyze` (cross-artifact gap detection). |
| VI | Test-First Delivery, AI-First Posture | ✅ Mechanized | `specjedi-implement` orders test tasks before implementation tasks when the plan calls for code. All 14 shipped feature plans (001-014) now explicitly cite their Principle VI exemption where testing doesn't apply, closing CHK007's inconsistency. Playwright requirement: still N/A, not a gap — no web UI has shipped yet for it to apply to. |
| VII | Full-Stack Technical Depth On Demand | ✅ Mechanized | `specjedi-plan` scans the target codebase's actual conventions before writing Technical Context, adapting depth to the detected stack. |
| VIII | Token-Economy Tooling Integration | ✅ Mechanized | `specjedi-tokencheck` (feature 012), proactively self-invoked by `specjedi-onboard`'s first-run flow; also runs standalone. |
| IX | Mandatory Skill Validation & Testing | ✅ Mechanized | `scripts/validate.sh`/`.ps1` (structural lint) + `.github/workflows/validate.yml` (`lint`, `install-test` jobs, matrixed across OSes) + an automated battery-growth-trigger check in `scripts/validate.sh`/`.ps1` that scans for test-pattern files, language runtime manifests, and web UI markers not yet covered by a unit/integration/Playwright CI job, warning (not failing) the moment one appears — closes CHK004's "no documented trigger/owner" gap. |
| X | Trunk-Based Git Workflow with Self-Validating Pull Requests | ✅ Mechanized | `.github/workflows/validate.yml`'s `ci-gate` (aggregating required check) and `owner-gate` jobs; branch protection configured per the constitution's "Repository & CI Configuration Prerequisites" section (manual GitHub setting, not code). |
| XI | Semantic-Versioned Releases with Proactive Cut Suggestions | ✅ Mechanized | `scripts/suggest-release.sh`/`.ps1` + `specjedi-release` (feature 010) as the product-surface wrapper for *suggesting* a version. **Feature 020** closes the remaining gap — a real, deliberate cutting mechanism (`.github/workflows/release.yml`, `workflow_dispatch`-only, `dry_run`-gated default-true) that actually tags, packages (`scripts/package-release.sh`/`.ps1`), and publishes a GitHub Release with a downloadable artifact. This project's first real release (`v0.1.0`) has not yet been cut — that remains a separate, deliberate maintainer action per this principle's own "always a deliberate step" mandate, not something this feature performs on its own. |
| XII | Star Wars-Flavored End-User Voice | ✅ Mechanized | `references/star-wars-lexicon.md` (canonical reference/emoji-mapping pool); retrofitted across all shipped skills via the VOICE_PASS governance amendment (constitution v1.15.4). |
| XIII | Cross-Platform Support: Linux, macOS, Windows | ✅ Mechanized | Every `scripts/*.sh` ships with a `.ps1` counterpart; `.gitattributes` pins line endings; CI matrix covers `ubuntu-latest`/`macos-latest`/`windows-latest` plus a dedicated native-PowerShell job. |
| XIV | Guided Next-Step Suggestion | ✅ Mechanized | Retrofitted across all shipped skills via the NEXT_STEP_PASS governance amendment (constitution v1.15.2); checked going forward by `specjedi-skill-review`. |
| XV | `specjedi-` Skill Naming Convention | ✅ Mechanized | Convention + `scripts/validate.sh` structural lint; `specjedi-new-skill`'s collision-detection step. |
| XVI | Efficient Documentation & Mermaid Diagram Literacy | ✅ Mechanized | `specjedi-diagram` (feature 004, expanded 2026-07-11 to cover 12 Core-tier Mermaid types); `references/mermaid-diagram-catalog.md` — canonical 30-type catalog, closing the original "just flowchart/sequence/ER" gap. |
| XVII | Skill Discovery & Gap-Filling | ✅ Mechanized | `specjedi-find-skills` ships and is proactively wired into specific skills (e.g., `specjedi-plan`→`specjedi-security`, `specjedi-onboard`→`specjedi-tokencheck`). A systematic grep audit (closing CHK018) confirmed 20 of 22 then-shipped skills carry the self-invoke contract explicitly; the 2 that don't (`specjedi-release`, `specjedi-tokencheck`) each have a documented, reasoned exemption in their own `plan.md`. |
| XVIII | Zero-Footprint Installer with Harness Selection | ✅ Mechanized | `scripts/install.sh`/`.ps1`; closed via the INSTALLER governance amendment (constitution v1.15.6). **Feature 021** (Sub-Project C of the release/installer decomposition) adds harness auto-detection — `--harness` is now optional, resolved via ranked filesystem/`PATH` signals, with ambiguous multi-match resolved through Constitution v1.22.0's Recommended-option standard (interactive prompt with a real TTY, automatic Recommended-selection otherwise or with `--auto`). Every existing explicit-`--harness` invocation is unaffected (proven by CI, not just asserted). |
| XIX | Skill Authoring & Prompt Engineering Standard | ✅ Mechanized (both directions) | `references/skill-authoring-standard.md` (the standard itself); `specjedi-new-skill` (feature 009, scaffolds compliant structure); `specjedi-skill-review` (feature 011, audits an existing skill against it). |
| XX | AI Discipline: Grounded, Efficient, Honest Output | ✅ Mechanized | Retrofitted via the GROUNDING_PASS and PROMPT_ENG_PASS governance amendments (constitution v1.15.3/v1.15.5); `specjedi-skill-review`'s chain-of-thought dimension checks this at authoring time. CHK015's retrospective-audit question is answered rather than left open: git's own append-only commit/PR history already is the inspectable audit trail this principle needs — deliberately not duplicated into a second, easier-to-forget tracking ledger. `specjedi-govcheck`'s per-PR Principle XX row is the forward-looking half. |
| XXI | Session-Start Orientation & the Master Yoda Greeting | 🟡 Partial | `scripts/session-start.sh`/`.ps1` (feature 015) implement the full three-part payload and are registered under `SessionStart` in `.claude/settings.json`; `CLAUDE.md` carries the render instruction. Both scripts real-dry-run tested (character cap, rotation, graceful degradation on a missing lexicon file and on a zero-feature project all verified). What remains unverified: an actual live Claude Code session start rendering the greeting end to end (SC-003) — not observable from within the same session that built it; needs confirmation the next time a fresh session opens in this repo. |

## Cross-cutting (not a numbered principle)

| Section | Status | Implementing mechanism |
|---|---|---|
| Distribution & Ecosystem Standards (badges, README, LICENSE, CONTRIBUTING) | ✅ Mechanized | README/LICENSE/CONTRIBUTING structure in place. CHK011's gap (PRs #45/#47 didn't document a badge-row review) can't be fixed retroactively, but recurrence is now prevented: `specjedi-govcheck`'s mandatory self-invoke from `specjedi-implement` (feature 013) makes this review structural on every PR going forward, and feature 014's PR (#59) is the first to document the review explicitly per this mechanism. |
| Development Workflow (the SDD pipeline itself) | ✅ Mechanized | Every feature in `specs/001-*` through `specs/013-*` was built via the literal `research → speckit-specify → speckit-clarify → speckit-plan → speckit-tasks → speckit-implement → PR → CI → merge` sequence (features 009+ via literal `/speckit-*` invocation; 001-008 via hand-authored artifacts matching the same shape). The "review MUST explicitly check compliance with every Core Principle" requirement is now mechanized by `specjedi-govcheck` (feature 013), self-invoked by `specjedi-implement` before every PR-open. |

## Legend

- ✅ **Mechanized** — a real, shipped skill/script/CI job implements the
  principle's mandate; any residual gap is minor or already tracked
  elsewhere.
- 🟡 **Partial** — some mechanism exists, but the principle's mandate is not
  fully satisfied; the specific gap is named and cross-referenced to
  `checklists/project-completeness.md` where applicable.
- 🔴 **Not started** — no mechanism exists yet (none currently, as of this
  entry).
