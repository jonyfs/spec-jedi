# Implementation Plan: specjedi-govcheck Prints Only Findings, Auto-Proceeds When Clean

**Branch**: `062-govcheck-condensed-output` | **Date**: 2026-07-20 | **Spec**: `specs/062-govcheck-condensed-output/spec.md`

**Input**: Feature specification from `specs/062-govcheck-condensed-output/spec.md`

## Summary

`specjedi-govcheck` today always prints a full ~22-row per-principle
table, even when every row is N/A or Compliant — directly observed this
session across three real runs (specs/059, specs/060, specs/061), each
producing a full table before reaching a one-line "CLEAN" verdict. This
feature keeps Step 3's full internal per-principle reasoning unchanged
(Principle XX grounding is never shortened) but changes what gets
*printed*: an all-clean result collapses to one summary line followed
immediately by the next-step bullets; a non-clean result prints only the
Non-Compliant/CRITICAL rows. The full, unconditional table remains
available on request. This is Constitution Principle XX's own
token-economy pillar applied reflexively to a `specjedi-*` skill's own
output.

## Technical Context

**Language/Version**: Markdown (`SKILL.md` instruction file) — matches
this session's specs/059/060 edits; no code language applies.

**Primary Dependencies**: None new. `references/principle-traceability.md`
(existing, unchanged) still grounds the per-principle reasoning Step 3
already performs.

**Storage**: N/A — this skill has zero write surface today and this
feature adds none (spec.md FR-006).

**Testing**: No automated test framework applies — prose instruction-file
edit, no compiled/interpreted code artifact (same explicit-reason
pattern as specs/059/060's own Constitution Check rows for Principle
VI).

**Target Platform**: Cross-harness by construction — plain Markdown
instructions, no proprietary schema, no new script.

**Project Type**: Single skill-instruction-file edit
(`specjedi-govcheck/SKILL.md`).

**Performance Goals**: N/A — no runtime performance dimension; the
"performance" this feature improves is the report's own token footprint
(SC-001/SC-002 in spec.md).

**Constraints**:

- Step 3's per-principle reasoning scope MUST NOT shrink — every one of
  20 principles + 2 sections is still reasoned about internally on every
  run (spec.md FR-001); only the *printed* subset changes.
- Today's existing Verifiable Success Criteria bullet ("Every one of the
  20 principles plus the 2 cross-cutting sections appears in the report
  with an explicit status — none silently omitted") is in direct tension
  with this feature's own condensed default and MUST be reworded, not
  deleted — distinguishing "reasoned about" (still always true) from
  "printed by default" (no longer true for clean rows). Silently
  dropping this criterion instead of updating it would leave the file
  internally contradicting its own new behavior.
- The full-report escape hatch (FR-005) MUST remain identical in shape
  to today's existing Format table — this feature adds a condensed
  *default*, it does not remove or alter the full-table option.

**Scale/Scope**: One file (`.claude/skills/specjedi-govcheck/SKILL.md`),
five sections touched (Step 5, Format, Example, Always/Never, Verifiable
Success Criteria) — Step 1-4 and 6 (diff retrieval, principle loading,
per-principle reasoning, next-step offering) stay substantively
unchanged, only referencing the new condensed presentation where they
already referenced "the report."

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I. English-Source Docs | `spec.md`/`plan.md`/the `SKILL.md` edit all English | ✅ Compliant |
| II. Competitive Research Before Creation | Modifies existing `specjedi-govcheck` output presentation, not a new SDD-domain pattern | ✅ N/A (extends existing skill, no new territory) |
| III. Universal LLM & Harness Compatibility | Plain Markdown instructions | ✅ Compliant |
| IV. Structured, Opinionated Elicitation | No requirement-gathering questions involved — this feature is about output verbosity, not elicitation | ✅ N/A |
| V. Specification Completeness | `spec.md` has zero `NEEDS CLARIFICATION` markers | ✅ Compliant |
| VI. Test-First Delivery | No code artifact — prose instruction edit; explicit reason stated (no compiled/interpreted logic exists) | ✅ Compliant (explicit reason, matching specs/059/060 precedent) |
| VII. Full-Stack Technical Depth | Not stack-specific | ✅ N/A |
| VIII. Token-Economy Tooling Integration | Unrelated to rtk/graphify configuration specifically (though thematically adjacent — this feature is about the skill's own output economy, a distinct concern from suggesting external tools) | ✅ N/A |
| IX. Mandatory Skill Validation & Testing (NON-NEGOTIABLE) | Existing structural-lint CI (frontmatter/name-match) still applies to the edited `SKILL.md` unchanged | ✅ Compliant |
| X. Trunk-Based Git Workflow | Feature branch `062-govcheck-condensed-output` created off `main`; will open a PR, not commit direct | ✅ Compliant (to be executed) |
| XI. Semantic-Versioned Releases | Not evaluated at plan time | ✅ N/A at this stage |
| XII. Star Wars-Flavored Voice | The report's own printed content (condensed or full) stays plain per the existing, unchanged Audience Calibration Boundary; only the skill's narration around it carries voice | ✅ Compliant |
| XIII. Cross-Platform Support | No `.sh`/`.ps1` script involved | ✅ N/A |
| XIV. Guided Next-Step Suggestion | This feature directly reinforces XIV's own intent — reaching the next-step bullets faster, with less noise in front of them | ✅ Compliant (reinforces directly) |
| XV. `specjedi-` Naming Convention | Editing existing, already-correctly-named `specjedi-govcheck` | ✅ Compliant |
| XVI. Efficient Documentation & Mermaid Literacy | This feature is Principle XVI's own "choose the format that conveys content most directly, avoid padding past what's needed" applied reflexively to `specjedi-govcheck`'s own report format | ✅ Compliant (directly exemplifies this principle) |
| XVII. Skill Discovery & Gap-Filling | No domain gap | ✅ N/A trigger (no gap) |
| XVIII. Zero-Footprint Installer | Installer untouched | ✅ N/A |
| XIX. Skill Authoring & Prompt Engineering Standard | Edited file MUST retain all required sections post-edit (Format, Example, Verifiable success criteria, Always/Never, Validation Coverage — all updated coherently, none dropped) — enforced in Project Structure's exact edit text below | ✅ Compliant (enforced in edit) |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Directly motivated by three real, observed `specjedi-govcheck` runs this session (specs/059/060/061), not a hypothetical optimization — and this feature is itself an instance of XX's own "token economy by default" pillar applied to a skill's own output | ✅ Compliant (strongly, both as evidence source and as subject matter) |
| XXI. Session-Start Orientation | `scripts/session-start.sh` untouched | ✅ N/A |
| XXII. Skill Freshness Validation | Bootstrap/version-marker logic untouched | ✅ N/A |

No Complexity Tracking entries — no gate was violated.

## Project Structure

### Documentation (this feature)

```text
specs/062-govcheck-condensed-output/
├── plan.md              # This file
└── spec.md              # Already written (previous turn)
```

No `research.md`/`data-model.md`/`quickstart.md`/`contracts/` — no
external unknown requiring research; the one real design tension
(Verifiable Success Criteria's own wording conflict) was identified and
resolved directly in this plan's Constraints above.

### Source Code (repository root)

```text
.claude/skills/specjedi-govcheck/SKILL.md   — MODIFIED (only file touched)
```

**Exact edit sites**:

1. **Step 5** (today: "Build the report table... resist the urge to
   force every row into Compliant/Non-Compliant") — extend with the
   condensation rule: after reasoning through all 20 principles + 2
   sections (Step 3, unchanged), determine the printed form:
   - All N/A/Compliant → one summary line ("⚖️ Governance check:
     `<branch/PR>` — CLEAN (22/22 reasoned, 0 findings)."), no table.
   - Any Non-Compliant/CRITICAL → a table containing *only* those rows,
     led by the same summary-line shape naming the finding count (e.g.
     "2 Non-Compliant (1 CRITICAL)").
   - Either way, the condensed output MUST be followed immediately by
     Step 6's next-step bullets — no separate pause between the summary
     and the bullets (spec.md FR-002, FR-004).
2. **New sentence appended to Step 6** ("Report, then offer the next
   step(s)..."): note the on-request full-report mode (FR-005) — "If the
   user asks for the full report, present the complete, unconditional
   per-principle table instead (today's existing Format shape, preserved
   below) — this condensation is a default, not a removal."
3. **Format section** — replace the single table template with three
   labeled variants: (a) the condensed CLEAN one-liner, (b) the
   condensed findings-only table, (c) the existing full table
   (relabeled "on request," content unchanged from today).
4. **Example section** — replace today's single scratch-branch example
   with two short examples: a condensed-CLEAN case and a
   condensed-findings case, each grounded the same way today's example
   is (a real or realistic scratch-branch diff) — dropping today's
   single "missing .ps1" example's exact wording is fine as long as the
   replacement demonstrates the same underlying finding-reporting
   discipline (specific file/evidence named, never vague).
5. **Always/Never** — add: "Always reason through all 20 principles + 2
   sections internally on every run, even when most rows never print"
   and "Never omit a row from the *internal* reasoning pass to save
   tokens — only the *printed* output condenses" (paired, per Principle
   XIX's prohibition-with-alternative structure) and "Always offer the
   full report on request, unchanged from today's existing table shape."
6. **Verifiable success criteria** — reword the existing "Every one of
   the 20 principles plus the 2 cross-cutting sections appears in the
   report with an explicit status — none silently omitted" bullet to:
   "Every one of the 20 principles plus the 2 cross-cutting sections is
   reasoned about internally on every run, with an explicit status
   assigned — none silently skipped; the *printed* report shows only
   Non-Compliant/CRITICAL rows by default (or one summary line when
   clean), with the complete set always available via the full-report
   request." Add a new bullet: "A condensed clean report is under 10
   printed lines; a condensed findings report's table row count equals
   exactly the finding count — checkable by counting."

### Token-budget check (Principle XIX)

Current `specjedi-govcheck/SKILL.md` size to be measured post-edit
(`wc -w`); the net change is a few extended/added sentences across five
sections (comparable in scale to specs/059's ~15-net-line edit) — stays
well within the existing file's already-passing size, no `references/`
split needed.

### Spec/plan size-outlier check (specs/045, Step 5.5)

`spec.md`: 248 lines. `plan.md` (this file): under 200 lines. Both
comparable to this session's other single-skill-behavior-change specs
(specs/059: 238/222, specs/060: 274/251, specs/061: 286/232) — neither
is a size outlier warranting a flag.
