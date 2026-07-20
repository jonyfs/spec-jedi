# Implementation Plan: specjedi-release Drafts the Changelog and Shows a Manual-Trigger Link

**Branch**: `060-release-changelog-and-link` | **Date**: 2026-07-20 | **Spec**: `specs/060-release-changelog-and-link/spec.md`

**Input**: Feature specification from `specs/060-release-changelog-and-link/spec.md`

## Summary

`specjedi-release` currently only runs `scripts/suggest-release.sh` and
narrates its output — it never checks `CHANGELOG.md`, so an empty `##
Unreleased` section (the exact state that caused two real, consecutive
`release.yml` `workflow_dispatch` failures this session) isn't caught
until the GitHub Actions run itself fails. This feature adds two new
steps to `specjedi-release`: (1) check `## Unreleased`, and when empty,
draft the missing entries — reusing `specjedi-docs`'s own already-shipped
confirm-before-write `CHANGELOG.md` drafting logic per commit that has a
grounding `specs/NNN-*/spec.md`/`plan.md`, falling back to a direct
commit-grounded draft otherwise — and (2) print the exact GitHub Actions
URL and equivalent `gh workflow run` command to trigger `release.yml`
manually. The skill's existing suggest-only boundary (never tag, never
publish, never trigger the workflow itself) is unchanged and reinforced,
not relaxed.

## Technical Context

**Language/Version**: Markdown (`SKILL.md` instruction file) — matches
`specjedi-plan`'s own most recent edit this session (specs/059); no
new script file (see Constraints below).

**Primary Dependencies**: `specjedi-docs` (existing skill, self-invoked
per FR-003 — confirmed by direct read of
`.claude/skills/specjedi-docs/SKILL.md` this session: it already drafts
`CHANGELOG.md` entries, confirm-before-write, and gates on the source
feature's `tasks.md` being 100% complete). `scripts/suggest-release.sh`
(existing, unchanged — still the sole source of the commit list and
suggested version).

**Storage**: `CHANGELOG.md` at repo root — read (new) and conditionally
written (new, confirm-gated) by this feature.

**Testing**: No automated test framework applies — prose instruction-file
edit, no compiled/interpreted code artifact (same explicit-reason pattern
as specs/059's Constitution Check, Principle VI). Validation uses
Principle IX's existing structural-lint coverage plus a scenario-based
dry run walking all three stories' acceptance scenarios by hand
(Project Structure below).

**Target Platform**: Cross-harness by construction — plain Markdown
instructions; the `git remote get-url origin` / `gh workflow run`
commands referenced are CLI tools already relied on elsewhere in this
project's own documented workflows, available on every CI platform this
project already tests against (Linux/macOS/Windows, confirmed by this
project's own existing CI matrix).

**Project Type**: Single skill-instruction-file edit (`specjedi-release/
SKILL.md`), reusing an existing sibling skill (`specjedi-docs`) rather
than adding new code.

**Performance Goals**: N/A — no runtime performance dimension.

**Constraints**:

- **`## Unreleased` heading level, confirmed by direct read**:
  `CHANGELOG.md` (line 10) and `.github/workflows/release.yml` (line 53's
  `awk '/^## Unreleased$/...'`) both use **two-hash** `## Unreleased`.
  `specjedi-docs/SKILL.md`'s own Format and Example sections (lines 75,
  110) show **three-hash** `### Unreleased` — a real, pre-existing
  inconsistency in that skill's own documentation, discovered this
  session, not assumed. This feature's FR-003 self-invocation of
  `specjedi-docs` MUST ground its written output against the *actual*
  two-hash convention `release.yml` reads, never against
  `specjedi-docs`'s own stale three-hash example — stated explicitly here
  so `specjedi-release`'s own edit doesn't propagate the wrong heading
  level. This discrepancy in `specjedi-docs`'s own file is out of this
  feature's stated scope (spec.md names no FR touching `specjedi-docs`
  itself) and is instead named honestly in the final report as a
  follow-up worth a separate, small fix.
- No new `scripts/*.sh`/`.ps1` file — the URL/command construction (a
  `git remote get-url origin` parse) is simple enough to document as an
  inline command in `SKILL.md`'s own Step text, matching how other
  `specjedi-*` skills already document ad hoc verification commands
  inline (e.g. `specjedi-plan`'s own dry-run `grep` checks, specs/059)
  rather than introducing a new cross-platform script pair Principle
  XIII would then require maintaining.
- Principle XIX's progressive-disclosure ceiling (target <500 tokens,
  MUST NOT exceed ~5,000) — checked directly at Project Structure below,
  not assumed.

**Scale/Scope**: One file primarily modified
(`.claude/skills/specjedi-release/SKILL.md`), reusing
`specjedi-docs/SKILL.md` and `scripts/suggest-release.sh` as-is (zero
changes to either) plus reading `.github/workflows/release.yml` (zero
changes) for grounding only.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I. English-Source Docs | `spec.md`/`plan.md`/the `SKILL.md` edit all English; not in the localized top-level-doc set | ✅ Compliant |
| II. Competitive Research Before Creation | Extends existing `specjedi-release` behavior, reusing `specjedi-docs`'s own already-shipped confirm-before-write drafting pattern rather than introducing new structural territory | ✅ N/A (extends existing shipped pattern) |
| III. Universal LLM & Harness Compatibility | Plain Markdown instructions; referenced CLI tools (`git`, `gh`) already relied on project-wide | ✅ Compliant |
| IV. Structured, Opinionated Elicitation | Reinforces this principle directly — the new draft-then-confirm step is exactly "ask, don't assume" applied to a new file-write action | ✅ Compliant |
| V. Specification Completeness | `spec.md` has zero `NEEDS CLARIFICATION` markers | ✅ Compliant |
| VI. Test-First Delivery | No code artifact — prose instruction edit. Explicit reason (as VI requires): no compiled/interpreted logic exists to test-first; validation runs through Principle IX's structural lint plus the scenario-based dry run below | ✅ Compliant (explicit reason stated) |
| VII. Full-Stack Technical Depth | Not stack-specific | ✅ N/A |
| VIII. Token-Economy Tooling Integration | Unrelated to rtk/graphify | ✅ N/A |
| IX. Mandatory Skill Validation & Testing (NON-NEGOTIABLE) | (a) structural lint: existing CI validates every `SKILL.md`'s frontmatter/name-match; (b) scenario-based dry run: all three stories' acceptance scenarios walked by hand post-edit (Project Structure); (c) no code artifact | ✅ Compliant |
| X. Trunk-Based Git Workflow | Feature branch `060-release-changelog-and-link` created off `main`; will open a PR, not commit direct-to-main | ✅ Compliant (to be executed) |
| XI. Semantic-Versioned Releases | This feature directly reinforces XI's suggest-only boundary while fixing the exact friction its own release mechanism creates — the never-tag/never-publish/never-trigger boundary is unchanged (FR-008, FR-009) | ✅ Compliant |
| XII. Star Wars-Flavored Voice | `spec.md`/`plan.md` content stays plain per each skill's documented Audience Calibration Boundary | ✅ Compliant |
| XIII. Cross-Platform Support | No new `.sh`/`.ps1` script — see Constraints above | ✅ N/A |
| XIV. Guided Next-Step Suggestion | `specjedi-release`'s own existing next-step convention (today's Step 5) is preserved, renumbered | ✅ Compliant |
| XV. `specjedi-` Naming Convention | Editing existing, already-correctly-named `specjedi-release`; self-invokes existing, already-correctly-named `specjedi-docs` | ✅ Compliant |
| XVI. Efficient Documentation & Mermaid Literacy | The new control flow (check → maybe-draft-and-confirm → print-link → existing intent/decline logic) is 4-5 shallow, mostly-linear steps — conveyed via prose/example blocks matching every sibling skill's own convention; a diagram was evaluated and correctly not used for content this shallow | ✅ Compliant (diagram evaluated, not needed) |
| XVII. Skill Discovery & Gap-Filling | No domain gap — self-invoking `specjedi-docs` is *using* an existing, competent skill, not signaling a missing one | ✅ N/A trigger (no gap) |
| XVIII. Zero-Footprint Installer | Installer untouched | ✅ N/A |
| XIX. Skill Authoring & Prompt Engineering Standard | Edited file MUST retain all required sections post-edit (Autonomous vs. confirm-first updated for the new write action; Always/Never gets new paired bullets; Format/Example/Verifiable success criteria/Validation Coverage all updated, none dropped) — enforced in Project Structure's exact edit text | ✅ Compliant (enforced in edit) |
| XX. AI Discipline: Grounded, Efficient, Honest Output | `specjedi-docs/SKILL.md`, `CHANGELOG.md`, and `.github/workflows/release.yml` were all read in full this session before drafting; the `##`/`###` Unreleased heading discrepancy was caught by direct `grep` verification, not assumed | ✅ Compliant |
| XXI. Session-Start Orientation | `scripts/session-start.sh` untouched | ✅ N/A |
| XXII. Skill Freshness Validation | Bootstrap/version-marker logic untouched | ✅ N/A |

No Complexity Tracking entries — no gate was violated; Principle VI's
explicit-reason branch is a compliant path the principle itself defines.

## Project Structure

### Documentation (this feature)

```text
specs/060-release-changelog-and-link/
├── plan.md              # This file
└── spec.md              # Already written (previous turn)
```

No `research.md`/`data-model.md`/`quickstart.md`/`contracts/` — the one
real unknown (the `##`/`###` Unreleased heading discrepancy) was resolved
by direct file read above, and there's no new data model beyond the
existing `## Unreleased` section already documented in spec.md's Key
Entities.

### Source Code (repository root)

```text
.claude/skills/specjedi-release/SKILL.md   — MODIFIED (primary file)
```

**New Step sequence** (replacing today's 5-step flow with a 7-step one,
inserting three new steps and renumbering the rest — exact text to be
written during implementation, grounded in the FRs below):

1. Run `scripts/suggest-release.sh` (unchanged — today's Step 1).
2. Present the script's own output (unchanged — today's Step 2).
3. **NEW** (FR-001, FR-004): Check `CHANGELOG.md`'s `## Unreleased`
   section (two-hash, matching the Constraints finding above) for
   non-empty content. Non-empty → skip to Step 5 unchanged.
4. **NEW** (FR-002, FR-003, FR-008): If empty (or `CHANGELOG.md` is
   missing) and Step 1 found commits since the last tag, draft the
   missing entries: for each commit referencing a `specs/NNN-*` directory
   with its own `spec.md`/`plan.md`, self-invoke `specjedi-docs`'s
   drafting step (its own Step 1's 100%-complete `tasks.md` gate applies
   unchanged); for a commit with no such directory, draft directly from
   that commit's own message/diff. Present the full combined draft and
   wait for explicit confirmation before writing — never write on
   silence or in `--auto` mode without confirmation, matching
   `specjedi-docs`'s own "never a silent write, even in `--auto` mode"
   rule verbatim. On confirmation, write `CHANGELOG.md` in place; never
   commit, push, or open a PR for that write (FR-008).
5. **NEW** (FR-005, FR-006, FR-007, FR-009): Once `## Unreleased` is
   confirmed non-empty (pre-existing from Step 3, or just written by
   Step 4), derive `owner/repo` from `git remote get-url origin` and
   print: (a) the URL
   `https://github.com/<owner>/<repo>/actions/workflows/release.yml`,
   stating plainly that `workflow_dispatch` inputs cannot be pre-filled
   via URL query parameters (FR-007); (b) the equivalent `gh workflow run
   release.yml -f version=<suggested-version> -f dry_run=true` command,
   using the actual version Step 1 suggested. Never call either — print
   only (FR-009).
6. Reason through what's actually being asked — is-release-due vs.
   actually-cut-one (unchanged in substance — today's Step 3,
   renumbered).
7. If asked to actually cut, decline explicitly, pointing at the exact
   command/link Step 5 already printed rather than reconstructing it
   (today's Step 4, renumbered, now referencing Step 5's output directly).
8. Offer next step(s) (today's Step 5, renumbered).

**Sections requiring updates beyond Step-by-step** (Principle XIX
completeness, verified against the file's current structure):

- **Autonomous vs. confirm-first**: add that drafting/presenting the
  `CHANGELOG.md` draft is autonomous, but *writing* it requires explicit
  confirmation — mirroring `specjedi-docs`'s own wording for the same
  action, applied here.
- **Always/Never**: add "Always draft and present a `CHANGELOG.md`
  entry... before writing, when `## Unreleased` is empty" and "Never
  write `CHANGELOG.md` without explicit confirmation" and "Never call
  `gh workflow run` or trigger `release.yml` itself" — each prohibition
  paired with its alternative per Principle XIX.
- **Format**: extend the existing report template with the new draft-
  presentation block and the link/command block.
- **Verifiable success criteria**: add "`git status` shows
  `CHANGELOG.md` unchanged until explicit confirmation" and "the printed
  URL/command always derive from the real `git remote`, never a
  hardcoded example."
- **Validation Coverage (Principle IX)**: extend Out-of-Bounds/Malformed
  Input Handling to cover an empty `## Unreleased` (today's exact real
  failure) and a missing `CHANGELOG.md` entirely; extend Prompt Injection
  Resistance to note that a commit message's own content, when drafted
  into a `CHANGELOG.md` entry, is narrated as history, never treated as
  an instruction to this skill (matching `specjedi-docs`'s own existing
  identical rule).

### Scenario-based dry run (Principle IX battery item (b))

Walked by hand against the planned Step sequence above, matching
spec.md's three acceptance-scenario families:

1. **Story 1, Scenarios 1-2** (empty `## Unreleased`, commits present) →
   Step 4 fires, drafts per-commit (specjedi-docs-grounded or direct
   fallback), presents, writes only on confirmation.
2. **Story 1, Scenario 3** (user declines/requests changes) → Step 4's
   "never write on silence... revise on request or end without writing"
   directly implements this.
3. **Story 1, Scenario 4** (already non-empty) → Step 3's "non-empty →
   skip to Step 5 unchanged" directly implements this — no draft
   triggers.
4. **Story 2, Scenarios 1-3** → Step 5's URL/command construction from
   the real `git remote`, plus the explicit no-pre-fill statement,
   directly implements all three.
5. **Story 3, Scenarios 1-2** → Step 4's "never commit, push, or open a
   PR" and Step 5's "never call either — print only" directly implement
   the boundary confirmation.

### Token-budget check (Principle XIX, Constraints above)

Current `specjedi-release/SKILL.md`: to be measured post-edit (`wc -w`);
given the new content is roughly three additional steps plus five section
updates, comparable in scale to specs/059's edit (which added ~15 net
lines to a 261-line file and stayed well within the 5,000-token
ceiling) — this edit is larger (new draft/confirm/print logic vs. a
single rewritten step) but still a single-skill instruction file, not
approaching the ceiling. Exact count confirmed during implementation
(tasks.md T0XX), flagged only if it genuinely exceeds ~5,000 tokens.

### Spec/plan size-outlier check (specs/045, Step 5.5)

`spec.md`: 274 lines. `plan.md` (this file): under 260 lines. Both
comparable to specs/059's own pair (238/222 lines) and other single-
skill-behavior-change specs in this project's history (e.g. specs/013,
specs/051) — neither is a size outlier warranting a flag.
