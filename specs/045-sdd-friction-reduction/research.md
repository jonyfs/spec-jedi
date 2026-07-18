# Research: SDD Friction Reduction — Closing Researched Community Pain Points

**Feature**: specs/045-sdd-friction-reduction
**Date**: 2026-07-18

Community pain-point research (spec.md's own "Research Grounding" section)
already satisfies Principle II for *why* this feature exists. This
document resolves the remaining *technical* design questions: which
existing skill each User Story extends, and how each check is computed
without adding a new dependency.

## Decision 1 (US1): Extend `specjedi-analyze`, not a new skill

**Decision**: The requirement-to-verification traceability check is a
new step inside `specjedi-analyze`'s existing reasoning — not a new,
28th skill.

**Rationale**: `specjedi-analyze` already performs the closely-related
check "does FR-012 have a corresponding task in `tasks.md`?" (confirmed
by reading its current `SKILL.md` before proposing anything, per
Principle II). The new check is a natural continuation of the *exact
same* reasoning — "does this artifact set hold together?" — just
extended one step further: from "does the requirement have a task" to
"does the requirement have *verified evidence* the task's result is
correct." Both operate on the same inputs (`spec.md`, `plan.md`,
`tasks.md`) plus, newly, the actual codebase/test results. Inventing a
separate skill for this would duplicate `specjedi-analyze`'s entire
artifact-loading step for no structural reason — unlike
`specjedi-constitution-audit` (specs/043), which needed a *different*
skill specifically because its reasoning model (whole-tree, never a
diff) was structurally incompatible with `specjedi-govcheck`'s
diff-scoped model. Here, both old and new checks are diff-agnostic,
artifact-driven reasoning about the same three files.

**Self-invocation point** (per Clarification Q1): `specjedi-implement`
currently self-invokes `specjedi-govcheck` at Step 6.5, right before
opening a PR, and only *suggests* (never self-invokes) `specjedi-analyze`
as a Step 8 next-step. This feature adds a new Step 6.6: self-invoke the
now-enhanced `specjedi-analyze` at the same pre-PR checkpoint as
`specjedi-govcheck`, with the identical advisory-only posture (surfaces
findings prominently, never blocks the PR itself — the CI battery
remains the actual merge gate, per Constitution Principle X).

**Alternatives considered**:
- A new `specjedi-verify` skill. Rejected: would duplicate
  `specjedi-analyze`'s existing spec/plan/tasks-loading logic with no
  reasoning-model incompatibility to justify the duplication.
- Extending `specjedi-govcheck` instead. Rejected: `specjedi-govcheck`'s
  domain is constitutional/governance compliance (do we follow the 22
  Principles), a fundamentally different question from "is this
  requirement's behavior actually verified" — mixing the two would dilute
  `specjedi-govcheck`'s own single-purpose clarity, the same reasoning
  specs/043's Decision 1 already used to keep `specjedi-constitution-audit`
  separate from `specjedi-govcheck`.

## Decision 2 (US1): What counts as "evidence"

**Decision**: For each Functional Requirement/Acceptance Scenario,
evidence is one of: (a) a named, currently-passing automated test whose
assertions map to the requirement's own language, or (b) an explicit
manual-verification note already present in `tasks.md`/`quickstart.md`
(matching this project's own existing precedent — e.g., specs/042's
`tasks.md` T011/T019/T023 record manual dry-run results directly inline).
No automated test and no manual-verification note together = Unverified.

**Rationale**: This project already has a real, established convention
for manual verification when no automated test fits (every `specjedi-*`
skill itself is validated this way — no CI job, a documented dry-run
instead, per `specjedi-govcheck`'s and `specjedi-constitution-audit`'s
own precedent). Reusing that existing convention rather than inventing a
new evidence format keeps this check consistent with how this project
already proves reasoning-driven work, and directly resolves spec.md's
own Edge Case ("Requirements with no natural test shape are verified via
an explicit manual-verification note instead").

## Decision 3 (US1): Detecting orphaned code/tests (FR-002, the reverse direction)

**Decision**: Reuse `specjedi-analyze`'s existing terminology matching
(it already reasons about whether an FR's language is reflected in
`plan.md`/`tasks.md`) extended to also scan the actual diff/shipped files
for substantial new code or test files with no corresponding FR/Scenario
citation nearby (e.g., a new test file, or a new function with no
docstring/commit-message tie to any FR number). This is necessarily a
judgment call, not a mechanical grep — flagged only when genuinely
unexplained, matching `specjedi-analyze`'s own existing "never report a
finding that isn't traceable to something actually present" guardrail.

**Alternatives considered**: A mechanical grep for FR-NNN citations in
every new file. Rejected: too brittle — plenty of legitimate code has no
reason to cite an FR number inline (e.g. a small helper function), and a
purely mechanical check would produce constant false positives, exactly
the "illusion of work" failure mode the research documented.

## Decision 4 (US2): Extend `specjedi-skill-review` for the token-budget half

**Decision**: `specjedi-skill-review`'s existing audit (already reads
the target `SKILL.md` and checks it against
`references/skill-authoring-standard.md`) gains one new check: measure
the file's actual size and report it against Principle XIX's own stated
budget (~500 tokens target, 5,000 hard cap), flagging any skill over the
hard cap by name with both numbers stated.

**Token-count approximation**: no tokenizer library is available or
desired (this project's own zero-dependency, zero-`jq` precedent extends
naturally to "zero-tokenizer" here too). Uses the widely-cited
approximation of ~4 characters per token for English prose (character
count ÷ 4), computed via `wc -c` — the same class of approximation
`references/skill-authoring-standard.md`'s own "under 500 tokens... hard
cap around 5,000 tokens" guidance already assumes informally. Documented
explicitly as an approximation, not an exact count, in the check's own
output, so a skill just over the line isn't treated as a hard failure
without a human glancing at it (consistent with Clarification Q2's
advisory-only, never-CI-blocking decision).

**Self-invocation point**: automatic, as part of `specjedi-skill-review`'s
existing single audit pass — no new trigger condition needed, since this
skill already runs its full check whenever invoked against a target
skill.

## Decision 5 (US2): Extend `specjedi-plan` for the spec/plan-size half

**Decision**: `specjedi-plan`'s existing flow (already reads a completed,
clarified `spec.md`) gains a new final step: after writing `plan.md`,
compute both `spec.md`'s and the just-written `plan.md`'s line counts,
compare each against the median line count of all prior
`specs/*/spec.md`/`specs/*/plan.md` files (excluding the current feature
itself), and flag either as an outlier when it exceeds roughly double
that median — with a suggested next step (e.g., "consider whether User
Story 3 is really one story or two").

**Why line count, not tokens, for this check specifically**: unlike
Decision 4's *skill-file* budget (which the Constitution states in
tokens), the constitution doesn't establish a token budget for feature
artifacts specifically — the research finding here was about
*uncontrolled escalation relative to this project's own norms*, not a
fixed external limit. A simple `wc -l`-based historical comparison
answers exactly that question ("is this bigger than what's normal for
us?") without needing a token approximation at all.

**Edge case handling** (per spec.md's own Edge Cases): with fewer than
five prior features to compare against, fall back to a fixed, documented
absolute threshold of 400 lines rather than a statistically meaningless
median of one or two data points. This number is not arbitrary: this
project's own real historical median across all 44 shipped `specs/*/
spec.md` files today is 193 lines (computed directly via `wc -l` before
writing this decision) — 400 is roughly double that real median, the
same "roughly double" outlier bar the live historical-comparison check
itself uses once enough history exists. A fresh install of `specjedi-*`
into a brand-new project inherits this same evidence-grounded default
until it accumulates its own history to compare against instead.

**Alternatives considered**: A hard, fixed line-count limit for every
feature regardless of history. Rejected: spec.md's own Edge Case
explicitly calls for a comparison against *this project's own* history,
not an arbitrary universal number — some features are legitimately
larger (e.g., specs/041's multi-harness translation work) without that
being a problem.

## Decision 6 (US3): Extend `specjedi-quick`, not a new skill

**Decision**: `specjedi-quick` gains a second eligibility path and
artifact shape for genuine bug fixes — `bugfix.md` (repro / root cause /
fix / regression test) as a sibling to its existing `quick.md` (concrete
changes) — rather than a new, separate skill.

**Rationale**: A new skill would duplicate `specjedi-quick`'s already-
built shared plumbing: the worktree self-invoke, the mandatory
`specjedi-govcheck` self-invoke, the PR-only enforcement, and the
"eligibility check before writing anything" discipline. The two paths
share every quality gate identically (FR-009) and differ only in *what
they ask* during eligibility and *what shape* the resulting artifact
takes — exactly the kind of variation a single skill's own branching
logic should carry, not a reason to fork into a second skill.

**Eligibility distinction**: a request is bug-shaped when there is
existing, previously-correct behavior to regress to (something worked,
now it doesn't); it's feature-shaped when there's no such prior correct
state (something never existed). `specjedi-quick` reasons through which
shape a request actually is as part of its existing eligibility check,
rather than requiring the user to pick a mode explicitly — matching this
project's existing "reason through each criterion explicitly" discipline
already documented in its own Step 1.

## Summary of touched files

| File | Change |
|---|---|
| `.claude/skills/specjedi-analyze/SKILL.md` | MODIFIED — new evidence-based traceability step (Decisions 1-3) |
| `.claude/skills/specjedi-implement/SKILL.md` | MODIFIED — new Step 6.6 self-invoking the enhanced `specjedi-analyze` before every PR-open (Decision 1) |
| `.claude/skills/specjedi-skill-review/SKILL.md` | MODIFIED — new token-budget check (Decision 4) |
| `.claude/skills/specjedi-plan/SKILL.md` | MODIFIED — new spec/plan size-outlier check (Decision 5) |
| `.claude/skills/specjedi-quick/SKILL.md` | MODIFIED — new bug-fix eligibility path and `bugfix.md` artifact shape (Decision 6) |

No new scripts, no new reference files, no new dependencies — every
check is expressed as reasoning steps + `wc`/`grep` commands inline in
the relevant `SKILL.md`'s own prose, matching how every other Spec Jedi
skill (including `specjedi-govcheck`/`specjedi-constitution-audit`) is
already built.
