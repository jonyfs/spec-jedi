# Research: Whole-Project Constitution Coverage Audit

**Feature**: specs/043-constitution-coverage-audit
**Date**: 2026-07-18

## Decision 0 (Principle II, competitive research before creation): does an equivalent mechanism already exist in this project?

**Decision**: No. Confirmed by direct inspection of every candidate
skill's own `SKILL.md` frontmatter description before writing spec.md:

- `specjedi-govcheck` — scoped strictly to a single branch's diff against
  `main` or a named open PR's diff (its own frontmatter: "Strictly
  read-only per-PR/per-branch governance compliance checklist"). Never
  evaluates the whole project tree at once.
- `specjedi-skill-review` — scoped to one named `specjedi-*` skill's own
  `SKILL.md` against the authoring standard (Principle XIX), not the
  constitution's 22 Core Principles as a whole.
- `specjedi-status` — a project-wide dashboard, but of feature
  completion (spec/plan/tasks checkbox state), not constitutional
  compliance.

**Rationale**: The genuine gap is a **whole-project** verdict — spec.md's
own User Story 1 exists specifically to answer a question none of these
three can answer today. This satisfies Principle II: the research
happened before the spec was written (confirmed during `/speckit-specify`
itself), and is restated here as this plan's formal record.

**Alternatives considered**: Extending `specjedi-govcheck` with a new
whole-project mode (e.g., a flag) instead of a new skill. Rejected for
this plan — see Decision 1 below.

## Decision 1: new skill, not a mode of `specjedi-govcheck`

**Decision**: Ship this as a new, separate skill:
`specjedi-constitution-audit`.

**Rationale**: `specjedi-govcheck`'s entire mechanism is diff-shaped (Step
1: "Get the diff... `git diff main...HEAD`") — its per-principle
reasoning question is "does *this diff* touch something this principle
governs?" This feature's question is structurally different: "does
*anything currently in the project* implement this principle, and does
`references/principle-traceability.md`'s claim about it still hold?" A
flag on `specjedi-govcheck` would force one skill to reason two
incompatible ways depending on a mode switch, working against this
project's own "no premature abstraction" discipline more than serving
it. A separate skill keeps each one's reasoning model — and its own
`SKILL.md` — simple and single-purpose, matching how
`specjedi-skill-review` and `specjedi-status` already exist as siblings
rather than modes of one mega-skill.

**Alternatives considered**: A `--whole-project` flag on
`specjedi-govcheck`. Rejected: would require Step 1 ("Get the diff") to
branch into two entirely different retrieval and reasoning models,
diluting the one skill's current single-purpose clarity for no reuse
benefit — the report *format* (three-state table) is shared, but that's
already trivially reusable as a documented convention, not shared code.

## Decision 2: reuse `specjedi-govcheck`'s exact report format and taxonomy

**Decision**: Same three-state taxonomy (Not Applicable / Compliant /
Non-Compliant), same unconditional-CRITICAL rule for confirmed conflicts,
same table shape (`| # | Principle | Status | Evidence / mechanism |`),
same "Overall: CLEAN / N Non-Compliant (M CRITICAL)" summary line.

**Rationale**: Spec.md's own Assumptions section requires this
explicitly ("reuses the same three-state taxonomy... for consistency
with this project's existing compliance vocabulary"). A maintainer
reading either report's output should recognize the same vocabulary
instantly — this is the same principle Principle XII already applies to
end-user voice, generalized here to this project's own internal
compliance language.

## Decision 3: `references/principle-traceability.md` as input, cross-checked — never trusted at face value

**Decision**: The audit loads `references/principle-traceability.md` the
same way `specjedi-govcheck` already does (Step 2 of its own
`SKILL.md`), but where `specjedi-govcheck` treats it purely as a lookup
aid, this audit treats each row as a **claim to verify**: does the cited
mechanism (file, script, CI job) actually exist and do what the row
claims, checked directly against the current project tree — not assumed
correct because it's written down.

**Rationale**: Directly required by User Story 2 and FR-004/FR-005. This
project's own history already produced a real instance of this file
going stale (its own header note: "five rows in this table... went
stale... after PR #58 closed [checklist items] without this file being
updated in the same PR, caught later by a `/speckit-constitution` audit
and corrected here"). A new audit that doesn't re-verify would repeat
that exact failure mode.

## Decision 4: no CI job — validation via documented reasoning coverage, matching `specjedi-govcheck`'s own precedent

**Decision**: This skill's Principle IX validation is a documented
"Validation Coverage" section in its own `SKILL.md` (the same four
categories from `references/skill-validation-testing-framework.md`
`specjedi-govcheck` already uses), backed by a real, one-time manual
dry-run against this repository itself before shipping — not a new
`.github/workflows/validate.yml` job.

**Rationale**: This is a reasoning-driven skill (LLM inspecting a
project and reasoning about compliance), not deterministic code with a
fixed input/output contract a CI assertion could check — exactly
`specjedi-govcheck`'s own documented posture (its `SKILL.md` has no
corresponding CI job either, only a "Verifiable success criteria"
section and the same four-category Validation Coverage write-up). A CI
job here would either be vacuous (asserting the skill file's structural
shape only, already covered by `scripts/validate.sh`'s existing
frontmatter lint) or would require simulating LLM judgment in a script,
which this project does not do for any of its reasoning-driven skills.

**Alternatives considered**: A scripted CI job asserting the audit
produces 24 table rows against this repo's own current state. Rejected:
would only check row count, not correctness of any individual verdict —
false confidence dressed as a real test.

## Decision 5: not proactively self-invoked by `specjedi-implement`

**Decision**: Unlike `specjedi-govcheck` (self-invoked before every PR),
this skill runs only on explicit request.

**Rationale**: Spec.md's own Assumptions state this plainly: per-PR
gating already belongs to `specjedi-govcheck`; this feature is
deliberately a periodic/on-demand whole-project check, not a per-change
gate. Wiring it into every PR would duplicate `specjedi-govcheck`'s
existing role and add latency to every implementation cycle for a
question that doesn't change on every single commit.

## Summary of touched files

| File | Change |
|---|---|
| `.claude/skills/specjedi-constitution-audit/SKILL.md` | NEW |
| `references/principle-traceability.md` | MODIFIED — one-line pointer to the new audit skill as its verification companion, per this file's own documented maintenance convention |
