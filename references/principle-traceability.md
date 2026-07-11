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
implements a principle. This file doesn't replace the constitution's own
Sync Impact Report history (that remains the authoritative amendment
record) — it's a fast lookup index derived from it.

| # | Principle | Status | Implementing mechanism |
|---|---|---|---|
| I | English-Source, Globally-Localized Documentation | 🟡 Partial | English-source enforced by review convention (no automated check). Localization: **not yet implemented** — `TODO(LOCALIZATION)`, open since constitution v1.15.14, blocked on a maintainer decision (translation approach, target languages, drift-detection design). |
| II | Competitive Research Before Creation | ✅ Mechanized (process) | Every `specs/NNN-*/research.md`, required before `speckit-plan`; enforced by the Development Workflow section and reviewer judgment — no automated check that a `research.md` exists or meets the bar. |
| III | Universal LLM & Harness Compatibility | 🟡 Partial | README's "Supported harnesses" table (20 harnesses named individually as of this entry); only Claude Code actually built, tested, and documented end to end. A full compatibility *matrix* with per-harness capability detail (beyond name + status) is **not yet built** — see `checklists/project-completeness.md` CHK002. |
| IV | Structured, Opinionated Elicitation (Ask, Don't Assume) | ✅ Mechanized (convention) | Baked into every `specjedi-*` skill's own step-by-step (e.g., `specjedi-specify`'s NEEDS CLARIFICATION discipline, `specjedi-clarify`'s question loop); checked per-skill only via `specjedi-skill-review`'s Skill Authoring Standard subset, not a dedicated Principle IV check. |
| V | Specification Completeness for Autonomous Execution | ✅ Mechanized | `specjedi-specify` (NEEDS CLARIFICATION markers), `specjedi-clarify` (resolution loop), `specjedi-analyze` (cross-artifact gap detection). |
| VI | Test-First Delivery, AI-First Posture | 🟡 Partial | `specjedi-implement` orders test tasks before implementation tasks when the plan calls for code. Playwright requirement: not yet exercised (no web UI shipped by this project yet). Per-feature plans satisfy this implicitly via a "scenario-based dry run" Testing line, not always an explicit cited exemption — see CHK007. |
| VII | Full-Stack Technical Depth On Demand | ✅ Mechanized | `specjedi-plan` scans the target codebase's actual conventions before writing Technical Context, adapting depth to the detected stack. |
| VIII | Token-Economy Tooling Integration | ✅ Mechanized | `specjedi-tokencheck` (feature 012), proactively self-invoked by `specjedi-onboard`'s first-run flow; also runs standalone. |
| IX | Mandatory Skill Validation & Testing | ✅ Mechanized | `scripts/validate.sh`/`.ps1` (structural lint) + `.github/workflows/validate.yml` (`lint`, `install-test` jobs, matrixed across OSes) + an automated battery-growth-trigger check in `scripts/validate.sh`/`.ps1` that scans for test-pattern files, language runtime manifests, and web UI markers not yet covered by a unit/integration/Playwright CI job, warning (not failing) the moment one appears — closes CHK004's "no documented trigger/owner" gap. |
| X | Trunk-Based Git Workflow with Self-Validating Pull Requests | ✅ Mechanized | `.github/workflows/validate.yml`'s `ci-gate` (aggregating required check) and `owner-gate` jobs; branch protection configured per the constitution's "Repository & CI Configuration Prerequisites" section (manual GitHub setting, not code). |
| XI | Semantic-Versioned Releases with Proactive Cut Suggestions | ✅ Mechanized | `scripts/suggest-release.sh`/`.ps1` + `specjedi-release` (feature 010) as the product-surface wrapper. |
| XII | Star Wars-Flavored End-User Voice | ✅ Mechanized | `references/star-wars-lexicon.md` (canonical reference/emoji-mapping pool); retrofitted across all shipped skills via the VOICE_PASS governance amendment (constitution v1.15.4). |
| XIII | Cross-Platform Support: Linux, macOS, Windows | ✅ Mechanized | Every `scripts/*.sh` ships with a `.ps1` counterpart; `.gitattributes` pins line endings; CI matrix covers `ubuntu-latest`/`macos-latest`/`windows-latest` plus a dedicated native-PowerShell job. |
| XIV | Guided Next-Step Suggestion | ✅ Mechanized | Retrofitted across all shipped skills via the NEXT_STEP_PASS governance amendment (constitution v1.15.2); checked going forward by `specjedi-skill-review`. |
| XV | `specjedi-` Skill Naming Convention | ✅ Mechanized | Convention + `scripts/validate.sh` structural lint; `specjedi-new-skill`'s collision-detection step. |
| XVI | Mermaid-First Process Documentation | ✅ Mechanized | `specjedi-diagram` (feature 004) — render-verified Mermaid generation from spec/plan content. |
| XVII | Skill Discovery & Gap-Filling | 🟡 Partial | `specjedi-find-skills` ships and is proactively wired into specific skills verified individually (e.g., `specjedi-plan`→`specjedi-security`, `specjedi-onboard`→`specjedi-tokencheck`). No systematic audit yet confirms *every* shipped skill that should carry this contract actually does — see CHK018. |
| XVIII | Zero-Footprint Installer with Harness Selection | ✅ Mechanized | `scripts/install.sh`/`.ps1`; closed via the INSTALLER governance amendment (constitution v1.15.6). |
| XIX | Skill Authoring & Prompt Engineering Standard | ✅ Mechanized (both directions) | `references/skill-authoring-standard.md` (the standard itself); `specjedi-new-skill` (feature 009, scaffolds compliant structure); `specjedi-skill-review` (feature 011, audits an existing skill against it). |
| XX | AI Discipline: Grounded, Efficient, Honest Output | 🟡 Partial | Retrofitted via the GROUNDING_PASS and PROMPT_ENG_PASS governance amendments (constitution v1.15.3/v1.15.5); `specjedi-skill-review`'s chain-of-thought dimension checks this partially at authoring time. No retrospective runtime audit mechanism exists — see CHK015. |

## Cross-cutting (not a numbered principle)

| Section | Status | Implementing mechanism |
|---|---|---|
| Distribution & Ecosystem Standards (badges, README, LICENSE, CONTRIBUTING) | 🟡 Partial | README/LICENSE/CONTRIBUTING structure in place; the "review the badge row before every PR" requirement has not been consistently documented as performed in recent PR descriptions — see CHK011. |
| Development Workflow (the SDD pipeline itself) | ✅ Mechanized | Every feature in `specs/001-*` through `specs/013-*` was built via the literal `research → speckit-specify → speckit-clarify → speckit-plan → speckit-tasks → speckit-implement → PR → CI → merge` sequence (features 009+ via literal `/speckit-*` invocation; 001-008 via hand-authored artifacts matching the same shape). The "review MUST explicitly check compliance with every Core Principle" requirement is now mechanized by `specjedi-govcheck` (feature 013), self-invoked by `specjedi-implement` before every PR-open. |

## Legend

- ✅ **Mechanized** — a real, shipped skill/script/CI job implements the
  principle's mandate; any residual gap is minor or already tracked
  elsewhere.
- 🟡 **Partial** — some mechanism exists, but the principle's mandate is not
  fully satisfied; the specific gap is named and cross-referenced to
  `checklists/project-completeness.md` where applicable.
- 🔴 **Not started** — no mechanism exists yet (none currently; every
  principle has at least a partial mechanism as of this entry).
