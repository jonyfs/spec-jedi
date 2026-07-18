# Research: `specjedi-*` Pipeline Hook Dispatch

**Feature**: specs/047-specjedi-hook-dispatch
**Date**: 2026-07-18

No `NEEDS CLARIFICATION` markers remain in spec.md — the mechanism to
match already exists, fully specified, in every `speckit-*` skill. This
document resolves the remaining *design* question: how to adapt that
already-proven mechanism into `specjedi-*`'s own structural convention
without copying section headings verbatim or diluting each skill's own
established voice.

## Decision 1: Adapt the hook-check logic into each skill's own Step-by-step section, not a copied "Pre-Execution Checks"/"Mandatory Post-Execution Hooks" heading pair

**Decision**: Every `specjedi-*` pipeline skill gains the hook-check
logic as two new steps inside its own existing Step-by-step section (a
new first step, and a new step immediately before the existing
next-step-offer/completion step) — not as two new top-level headings
copied verbatim from `speckit-*`'s own section names.

**Rationale**: `speckit-*` and `specjedi-*` use two different, already-
established internal conventions: `speckit-*` skills are organized as
`Pre-Execution Checks` / `Outline` / `Mandatory Post-Execution Hooks` /
`Completion Report` / `Done When`; `specjedi-*` skills are organized as
`Persona` / `Task` / `Step-by-step` / `Format` / `Autonomous vs.
confirm-first` / `--auto mode` / `Always/Never` / `Verifiable success
criteria` (confirmed directly by reading all 9 target skills before
writing this decision, plus `specjedi-skill-review`'s own Required
structure list, per Principle II). Bolting `speckit-*`'s own section
names onto a `specjedi-*` skill would produce a structurally
inconsistent file that fails `specjedi-skill-review`'s own structural-
presence check (which expects the established `specjedi-*` shape).
Folding the *same behavior* into two new Step-by-step steps preserves
both: exact behavioral parity with `speckit-*` (FR-003), and each
skill's own already-audited structural conformance.

**Alternatives considered**:
- Copying `speckit-*`'s exact section headings into each `specjedi-*`
  skill verbatim. Rejected: would pass a naive text-diff comparison
  against `speckit-*` but fail `specjedi-skill-review`'s own structural
  checks, and would read as an inconsistent, bolted-on foreign section
  in an otherwise coherent `specjedi-*` skill.
- A single shared reference file
  (`references/pipeline-hook-dispatch.md`) that all 9 skills point to
  instead of repeating the check inline. Rejected: every other
  `specjedi-*` skill's own logic is self-contained inline text, not
  delegated to a shared reference at execution time (references are
  used for *authoring standards*, like
  `references/skill-authoring-standard.md`, not *runtime* logic) —
  introducing the first exception here would be a novel pattern with no
  existing precedent, for a mechanism that's genuinely small (2 short
  steps) and doesn't warrant the indirection.

## Decision 2: Voice boundary — hook-check steps stay plain, not Star-Wars-flavored

**Decision**: The two new steps' own text stays short and procedural,
matching `speckit-*`'s own plain, mechanical hook-check tone — it does
not carry Constitution Principle XII's Star Wars-flavored voice the
rest of each skill's narration does.

**Rationale**: Principle XII governs *end-user-facing narration* (the
chat responses a skill produces, its Persona framing) — `speckit-*`'s
own hook-check sections are infrastructure/dispatch logic, not
end-user narration, and carry no such voice requirement either. This
project's own precedent (specs/041's hook hygiene, specs/045's
token-budget check in `specjedi-skill-review`) already treats
infrastructure-facing check logic as plain text distinct from a
skill's persona voice — this feature follows that same boundary rather
than inventing a new one.

**Alternatives considered**: Writing the hook-check steps in full
Spec-Jedi voice (e.g., "the Council reviews the incoming decree before
training begins"). Rejected: would be decorative for a mechanical
dispatch check with no judgment call in it, and would make the two new
steps harder to visually distinguish from each skill's own real
judgment-call steps — clarity over decoration here, consistent with
`speckit-*`'s own choice to keep this plain too.

## Summary of touched files

| File | Change |
|---|---|
| `.claude/skills/specjedi-constitution/SKILL.md` | MODIFIED — `before_constitution`/`after_constitution` hook-check steps |
| `.claude/skills/specjedi-specify/SKILL.md` | MODIFIED — `before_specify`/`after_specify` hook-check steps |
| `.claude/skills/specjedi-clarify/SKILL.md` | MODIFIED — `before_clarify`/`after_clarify` hook-check steps |
| `.claude/skills/specjedi-plan/SKILL.md` | MODIFIED — `before_plan`/`after_plan` hook-check steps |
| `.claude/skills/specjedi-tasks/SKILL.md` | MODIFIED — `before_tasks`/`after_tasks` hook-check steps |
| `.claude/skills/specjedi-implement/SKILL.md` | MODIFIED — `before_implement`/`after_implement` hook-check steps |
| `.claude/skills/specjedi-analyze/SKILL.md` | MODIFIED — `before_analyze`/`after_analyze` hook-check steps |
| `.claude/skills/specjedi-checklist/SKILL.md` | MODIFIED — `before_checklist`/`after_checklist` hook-check steps |
| `.claude/skills/specjedi-converge/SKILL.md` | MODIFIED — `before_converge`/`after_converge` hook-check steps |

No new scripts, no new reference files, no new dependencies.
