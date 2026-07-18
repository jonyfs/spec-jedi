# Implementation Plan: Retire `speckit-*` Bootstrap Tooling

**Branch**: `048-retire-speckit` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/048-retire-speckit/spec.md`

## Summary

Executes the internal migration `specs/044`/`specs/047` assessed
readiness for and deliberately did not perform: retires the two
`.specify/extensions.yml` hooks still dispatching to a `speckit-*`
skill, removes all 11 vendored `speckit-*` skill directories, and
corrects every current/forward-looking document that described
`speckit-*` as this project's live internal-development mechanism —
using `specjedi-migrate` (already shipped, built for exactly this)
for the constitution's own literal command references, and manual
edits for everything outside that skill's scope (Principle XV's
descriptive prose, README, CONTRIBUTING.md).

## Technical Context

**Language/Version**: N/A — file removal plus Markdown/YAML
documentation edits. No code.

**Primary Dependencies**: None new. Reuses `specjedi-migrate` (feature
003, already shipped) for its designed purpose — rewriting live
`/speckit-*` references to `/specjedi-*` in `constitution.md`, leaving
historical Sync Impact Report entries untouched per its own
live-vs-historical judgment call.

**Storage**: N/A.

**Testing**: No new CI job. Verified via `scripts/validate.sh`/`.ps1`
(structural lint, must still pass with `speckit-*` gone) plus a direct
`git diff` review confirming zero historical file (past CHANGELOG
entries, past `specs/NNN-*` artifacts) was touched — matching FR-009's
constraint.

**Target Platform**: N/A — no script is modified.

**Project Type**: Removal of 11 vendored skill directories plus
targeted documentation corrections across 5 files
(`.specify/extensions.yml`, `.specify/memory/constitution.md`,
`README.md`, `CONTRIBUTING.md`, `references/principle-traceability.md`)
and one ledger update (`specs/044-speckit-parity-audit/PARITY-LEDGER.md`).

**Performance Goals**: N/A.

**Constraints**: FR-001 (retire the two hooks) MUST complete before
FR-002 (delete `speckit-*` files) — deleting
`speckit-agent-context-update` while those hooks still name it would
leave every `specjedi-*` pipeline skill's own hook-dispatch check
(specs/047) trying to surface a now-missing command. FR-009 requires
zero historical artifact altered — every edit in this feature targets
only current/forward-looking text, confirmed per-file before editing
(Project Structure below names exactly which sections in each file are
historical vs. live). The constitution amendment (FR-005) MUST follow
the Governance section's own amendment procedure: a Sync Impact
Report, and a version bump matching the actual nature of the change.

**Scale/Scope**: 11 directories removed; 6 files edited; 1 constitution
amendment (Sync Impact Report + version bump).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II (Competitive Research Before Creation) | No new mechanism invented — reuses `specjedi-migrate`'s already-shipped, already-proven rewrite logic for the constitution's literal command references; every other edit is a direct, verified correction (each stale claim re-confirmed against current project state before this plan was written). | ✅ Pass |
| IX (Mandatory Skill Validation & Testing) | No CI job; `scripts/validate.sh`/`.ps1` must still pass post-removal (FR-004) — this is the actual test. | ✅ Pass |
| X (Trunk-Based Git Workflow) | This feature itself ships through branch → PR → CI → merge, same as every other feature this session — including the constitution amendment, which per the Governance section's own procedure requires a reviewed PR regardless of which skill authored it. | ✅ Pass |
| XI (Semantic-Versioned Releases) | Not directly implicated — this feature doesn't cut a release, though its changes will appear in a future `## Unreleased` → versioned CHANGELOG section same as any other feature. | N/A |
| XV (`specjedi-` Naming Convention) | This is the principle whose own descriptive text this feature amends (FR-005) — self-referential by design: the principle's actual rule (naming convention; bootstrap/product distinction requirement) is preserved unchanged, only the factual claim "this project currently dogfoods speckit-*" is corrected to reflect the completed migration. | ✅ Pass — this feature's core purpose |
| XX (AI Discipline: Grounded, Honest Output) | Every corrected document states what actually changed, not an inflated claim; historical records are explicitly left untouched (FR-009) rather than silently rewritten to look consistent. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/048-retire-speckit/
├── plan.md              # This file
├── research.md          # Phase 0 output — 3 decisions
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — same reasoning as
prior recent features: no entities, no interface contract, and
verification is `scripts/validate.sh` plus a direct `git diff` review,
not a separate runnable scenario doc.

### Source Code / Documentation (repository root)

```text
.specify/extensions.yml            # MODIFIED: after_specify/after_plan
                                    #   hook registrations removed (FR-001)
.claude/skills/speckit-*/          # DELETED: all 11 directories (FR-002)
.specify/memory/constitution.md    # MODIFIED: Principle XV's descriptive
                                    #   prose (manual edit) + Development
                                    #   Workflow/Governance sections' live
                                    #   command references (via
                                    #   specjedi-migrate) — Sync Impact
                                    #   Report + version bump (FR-005)
README.md                          # MODIFIED: "How Spec Jedi builds
                                    #   itself, in comic form" section
                                    #   reframed (FR-006)
CONTRIBUTING.md                    # MODIFIED: "Voice and naming"
                                    #   section's speckit-* description
                                    #   corrected (FR-007)
references/principle-traceability.md  # MODIFIED: Principle XV row +
                                    #   Development Workflow row updated
                                    #   (FR-008)
specs/044-speckit-parity-audit/
  PARITY-LEDGER.md                 # MODIFIED: migration marked executed,
                                    #   citing this feature (FR-010)
```

### Implementation notes for `speckit-tasks`/`speckit-implement`

**Live vs. historical, confirmed per file before editing** (FR-009 gate):

- `.specify/memory/constitution.md` has `speckit-*` mentions in two
  distinct categories, confirmed by direct line-by-line reading before
  this plan was written:
  - **Historical** (Sync Impact Report entries throughout the file,
    e.g. "resolved via a real `/speckit-clarify` question this cycle,"
    "built via the same literal `/speckit-*` pipeline invocation") —
    these describe what genuinely happened at each past amendment.
    **Left untouched.**
  - **Live** (Development Workflow section's pipeline description;
    Governance section's "Amendment procedure"/"Compliance review"
    clauses) — these are current, ongoing instructions.
    **Corrected**, via `specjedi-migrate` for the literal command
    substrings (its own designed purpose and judgment call already
    distinguishes exactly this live/historical split), plus a manual
    edit for Principle XV's own descriptive prose (not a command
    reference — outside `specjedi-migrate`'s literal-substring scope).
- `README.md`'s "How Spec Jedi builds itself, in comic form" section
  (specs/036/037's preserved section) is **entirely live/current** in
  its present form — it narrates `speckit-*` commands as this
  project's *ongoing* process. Once `speckit-*` is gone, this is no
  longer true, so per spec.md FR-006 it must be corrected: either
  updated to narrate the same walkthrough using `specjedi-*` commands
  (this project's actual current pipeline, unchanged in substance —
  same 9 stages, same PR/CI discipline), or explicitly retitled/
  reframed as a historical account with a clear "this described the
  project's bootstrap phase, which ended with feature 048" note.
  Preferred: **update in place to `specjedi-*` commands** — the
  narrative (constitution → spec → clarify → plan → tasks → implement
  → PR → CI → merge) is identically true today under `specjedi-*`, so
  rewriting the command names keeps the section accurate without
  discarding the illustrated panels feature 035 commissioned.
- `CONTRIBUTING.md`'s "Voice and naming" section: `speckit-*` is
  currently described as "vendored internal bootstrap tooling this
  repo uses to build itself" — correct this to state it no longer
  does, once removed.
- `specs/001-*` through `specs/047-*` — every one of these describes
  what actually ran at the time (all built via `speckit-*`, truthfully
  historical). **Left entirely untouched**, per FR-009/Edge Cases.
- Past `CHANGELOG.md` entries (everything under `## [v0.1.0]` through
  `## [v0.2.0]`) — historical, accurate record of what shipped when.
  **Left entirely untouched.** A new entry describing *this* feature's
  own changes goes under `## Unreleased`, same as every prior feature.

**Constitution amendment mechanics** (FR-005): Following the
Governance section's own "Amendment procedure," and fittingly for a
feature that retires `speckit-*`, this amendment is authored via
`specjedi-constitution` (not `speckit-constitution`) — proving the
successor tool already handles real governance work before the
predecessor is removed. Version bump: the principle's actual
*requirement* (naming convention; bootstrap/product distinction)
doesn't change — only a descriptive factual claim within it is
corrected to match reality post-migration. Per the Versioning
policy's own three-way test (MAJOR: a principle removed/redefined
incompatibly; MINOR: added/materially expanded; PATCH: wording/
clarification, no semantic change), this is a **PATCH** bump: the
rule Principle XV states is unchanged, only which tool is named as
today's example of it is corrected.

**Verification before shipping**: (1) `scripts/validate.sh`/`.ps1`
passes after removal (FR-004); (2) `git diff --stat` shows zero
touched files outside the 7 named above plus the constitution/
CHANGELOG (FR-009); (3) `grep -rn "speckit-" .` across the repo,
excluding `specs/001-*` through `specs/047-*` and past CHANGELOG
entries, returns zero live/current-tense hits.
